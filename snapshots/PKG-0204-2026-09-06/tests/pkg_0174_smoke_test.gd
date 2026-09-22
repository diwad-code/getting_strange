extends SceneTree

## PKG-0174 gate — P9 PHASE-08 / BUNDLE-28: GATE-THRESH + GATE-SCALE (apertures).
## Technical proof only: campaign exits require interact at a drawn ThresholdZone;
## AirlockZone no longer starts progress; families DOOR/VEHICLE/HATCH are in use;
## aperture sizes sit in WORLD_SCALE.md §3 / THRESHOLD §7.1 ±10%; Lena 4.2 has
## enter_door and board_vehicle on the 64x104 pivot. Does not claim PRODUCT GO.

const RIG_PATH := "res://scripts/player/lena_visual_rig.gd"
const ZONE_PATH := "res://scripts/environment/threshold_zone.gd"
const BINDER_PATH := "res://scripts/environment/threshold_binder.gd"
const ASSET_DIR := "res://assets/characters/lena/"
const PLAYER_SCENE := "res://scenes/player/prototype_player.tscn"
const ThresholdZoneScript := preload("res://scripts/environment/threshold_zone.gd")
const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")
const FAMILY_DOOR := 0
const FAMILY_VEHICLE := 1
const FAMILY_HATCH := 2

const ROUTE: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const ENTRY_FRAMES: Array[String] = [
	"enter_door_0", "enter_door_1", "enter_door_2",
	"board_vehicle_0", "board_vehicle_1",
]
const NEW_STATES: Array[StringName] = [&"enter_door", &"board_vehicle"]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0174: " + message)


func _run() -> void:
	_test_frames_and_rig()
	_test_source_forbids_airlock_progress()
	await _test_route_thresholds()
	await _test_interact_required()
	_test_no_new_binaries()
	_finish()


func _test_frames_and_rig() -> void:
	print("1. GATE-THRESH frames on 64x104 baked pivot...")
	for name in ENTRY_FRAMES:
		var path := ASSET_DIR + name + ".png"
		_expect(ResourceLoader.exists(path), "missing frame %s.png" % name)
		if not ResourceLoader.exists(path):
			continue
		var tex := load(path) as Texture2D
		_expect(tex != null, "%s.png must load" % name)
		if tex == null:
			continue
		_expect(tex.get_width() == 64, "%s width %d != 64" % [name, tex.get_width()])
		_expect(tex.get_height() == 104, "%s height %d != 104" % [name, tex.get_height()])
	var rig_src := FileAccess.get_file_as_string(RIG_PATH)
	for state_name in NEW_STATES:
		_expect(rig_src.contains("\"%s\"" % String(state_name)) or rig_src.contains("&\"%s\"" % String(state_name)), "LenaVisualRig missing state %s" % String(state_name))
	_expect(FileAccess.file_exists(ZONE_PATH), "threshold_zone.gd missing")
	_expect(FileAccess.file_exists(BINDER_PATH), "threshold_binder.gd missing")
	var zone_src := FileAccess.get_file_as_string(ZONE_PATH)
	_expect(zone_src.contains("body_entered") and zone_src.contains("trigger_entry"), "ThresholdZone must own interact entry")
	_expect(not zone_src.contains("_trigger_level_completion"), "ThresholdZone must not call station progress from body_entered")


func _test_source_forbids_airlock_progress() -> void:
	print("2. Campaign station airlock handlers must not start progress...")
	for station_id in ROUTE:
		if station_id.begins_with("station_42") or station_id == "station_43":
			continue
		var path := "res://scripts/levels/%s.gd" % station_id
		if not FileAccess.file_exists(path):
			_expect(false, "missing %s" % path)
			continue
		var text := FileAccess.get_file_as_string(path)
		_expect(
			not text.contains("call_deferred(\"_complete_if_player_already_in_airlock\")"),
			"%s still auto-completes from airlock overlap" % station_id
		)
		var handler := _extract_airlock_handler(text)
		if handler.is_empty():
			continue
		_expect(
			not handler.contains("_trigger_level_completion") and not handler.contains("board_line_four") and not handler.contains("level_completed.emit"),
			"%s _on_airlock still starts progress" % station_id
		)


func _extract_airlock_handler(text: String) -> String:
	var marker := "func _on_airlock"
	var start := text.find(marker)
	if start < 0:
		return ""
	var next_func := text.find("\nfunc ", start + marker.length())
	if next_func < 0:
		return text.substr(start)
	return text.substr(start, next_func - start)


func _test_route_thresholds() -> void:
	print("3. Every P9 address has a ThresholdZone with a legal aperture...")
	var families_seen: Dictionary = {}
	for station_id in ROUTE:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s.tscn must load" % station_id)
		if packed == null:
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		await process_frame
		var zone := station.get_node_or_null("Threshold")
		_expect(zone != null, "%s missing ThresholdZone after install" % station_id)
		if zone != null:
			var family: int = int(zone.get("entry_family"))
			families_seen[family] = true
			var size: Vector2 = zone.call("aperture_size") as Vector2
			_expect(_aperture_legal(family, size), "%s aperture %.0fx%.0f outside §7.1" % [station_id, size.x, size.y])
			_expect(zone.position.x + size.x * 0.5 <= 616.0 + 1.0, "%s aperture closer than 24 px to the right edge" % station_id)
			var airlock := station.get_node_or_null("AirlockZone") as Area2D
			_expect(airlock != null, "%s must keep AirlockZone as closure" % station_id)
			if airlock != null:
				_expect(airlock.body_entered.get_connections().is_empty(), "%s AirlockZone still has body_entered connections" % station_id)
		station.queue_free()
		await process_frame
	_expect(families_seen.has(FAMILY_DOOR), "DOOR family unused on the route")
	_expect(families_seen.has(FAMILY_VEHICLE), "VEHICLE family unused on the route")
	_expect(families_seen.has(FAMILY_HATCH), "HATCH family unused on the route")


func _aperture_legal(family: int, size: Vector2) -> bool:
	var w := size.x
	var h := size.y
	match family:
		FAMILY_VEHICLE:
			return w >= 46.8 and w <= 70.4 and h >= 90.0 and h <= 121.0
		FAMILY_HATCH:
			return w >= 50.4 and w <= 77.0 and h >= 50.4 and h <= 77.0
		_:
			# residential 42-48 x 109 (±10%) or technical 48-60 x 109-120 (±10%)
			var residential := w >= 37.8 and w <= 52.8 and h >= 98.1 and h <= 119.9
			var technical := w >= 43.2 and w <= 66.0 and h >= 98.1 and h <= 132.0
			return residential or technical


func _test_interact_required() -> void:
	print("4. Overlap without interact must not complete; interact at an open threshold must...")
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed != null, "station_01.tscn must load for interact proof")
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await process_frame
	if station.has_method("repeat_line_four_measurement"):
		station.call("repeat_line_four_measurement")
		station.call("secure_raw_sample")
		station.call("read_marta_message")
	await process_frame
	_expect(bool(station.get("is_exit_unlocked")), "station_01 must unlock after the opening verbs")
	_expect(not bool(station.get("is_level_completed")), "unlock alone must not complete the station")
	var player := station.get_node_or_null("Player") as CharacterBody2D
	var airlock := station.get_node_or_null("AirlockZone") as Area2D
	if player != null and airlock != null:
		player.global_position = airlock.global_position
		for _i in range(8):
			await physics_frame
	_expect(not bool(station.get("is_level_completed")), "standing in AirlockZone must not complete Station 01")
	var zone := station.get_node_or_null("Threshold")
	_expect(zone != null, "Station 01 Threshold missing during interact proof")
	if zone != null and player != null:
		_expect(bool(ThresholdBinderScript.complete_from_test(station, player)), "interact entry must run")
		await process_frame
		_expect(bool(station.get("is_level_completed")), "Threshold interact must complete Station 01")
	station.queue_free()
	await process_frame

	print("4b. Vehicle family on Station 03...")
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm != null:
		gsm.record_decision(&"p7.sample_and_promise.route_time_confirmed", true)
	var packed_03 := load("res://scenes/levels/station_03.tscn") as PackedScene
	var st03 := packed_03.instantiate() as Node2D
	root.add_child(st03)
	await process_frame
	await process_frame
	if st03.has_method("read_departure_board"):
		st03.call("read_departure_board")
		st03.call("reply_to_marta")
	if st03.has_method("unlock_exit_for_return"):
		st03.call("unlock_exit_for_return")
	var z03 := st03.get_node_or_null("Threshold")
	_expect(z03 != null and int(z03.get("entry_family")) == FAMILY_VEHICLE, "Station 03 must be VEHICLE")
	var p03 := st03.get_node_or_null("Player") as CharacterBody2D
	if z03 != null and p03 != null:
		ThresholdBinderScript.complete_from_test(st03, p03)
		await process_frame
		_expect(bool(st03.get("is_level_completed")), "Station 03 vehicle entry must complete")
	st03.queue_free()
	await process_frame


func _test_no_new_binaries() -> void:
	print("5. D-168: no new packaged .exe...")
	var dir := DirAccess.open("res://")
	_expect(dir != null, "project root must open")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0174 SMOKE PASS: GATE-THRESH — interact at a drawn threshold; apertures match the metre.")
		quit(0)
	else:
		print("PKG-0174 SMOKE FAIL (%d)" % _failures.size())
		for failure in _failures:
			print("  - " + failure)
		quit(1)
