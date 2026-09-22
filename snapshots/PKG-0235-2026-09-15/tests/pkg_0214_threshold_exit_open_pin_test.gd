extends SceneTree

## PKG-0214 gate — Threshold ownership + exit-open pin (decyzja D-227).
##
## Reconciliation with PKG-0213 plan §8 (findings M1+M2): the plan prescribed
## static Threshold nodes in station_01..18.tscn plus is_exit_unlocked=true in
## _ready(). Runtime evidence shows ThresholdBinder (installed deferred by
## GameStateManager._observe_campaign_station for every route station) ALREADY
## owns runtime ThresholdZones: contract apertures (THRESHOLD §7.1), 24 px
## margin placement, AirlockZone rewire (body_entered disconnected) and
## GapLedger.ensure_exit_open (exit unlocked + zone opened, zero readings).
## Adding static nodes would create dual ownership and aperture drift, so per
## the D-216/D-218 rule (name the conflict, replace with an equivalent or
## stronger control) this gate pins Binder as the SOLE owner and pins exits
## open from scene start WITHOUT performing any readings.
## Static .tscn must therefore contain ZERO Threshold nodes on the campaign.
##
## Technical proof only: contracts, counts and wiring. No claim about fun,
## beauty, comprehension or reception (D-012, ADR-003). Not a PRODUCT GO.

const BINDER_PATH := "res://scripts/environment/threshold_binder.gd"
const ZONE_PATH := "res://scripts/environment/threshold_zone.gd"
const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")

const FAMILY_DOOR := 0
const FAMILY_VEHICLE := 1
const FAMILY_HATCH := 2

# 22 visited resources: linear 01-18 + three 42 variants + epilogue 43.
# Matches ThresholdBinder.ROUTE and GameStateManager SELECTOR coverage.
const ROUTE: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const EXPECTED_ROUTE_SIZE := 22

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0214: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _run() -> void:
	_test_binder_contract()
	_test_no_static_thresholds()
	_test_airlock_never_progresses()
	await _test_exits_open_without_readings()
	_finish()


# ─── 1. Binder owns the spec table (read-only) ──────────────────────────

func _expected_family(station_id: String) -> int:
	if station_id == "station_03" or station_id == "station_04":
		return FAMILY_VEHICLE
	if station_id == "station_14" or station_id == "station_15":
		return FAMILY_HATCH
	return FAMILY_DOOR


func _aperture_legal(family: int, size: Vector2) -> bool:
	var w: float = size.x
	var h: float = size.y
	if family == FAMILY_VEHICLE:
		return w >= 46.8 and w <= 70.4 and h >= 90.0 and h <= 121.0
	if family == FAMILY_HATCH:
		return w >= 50.4 and w <= 77.0 and h >= 50.4 and h <= 77.0
	var residential: bool = w >= 37.8 and w <= 52.8 and h >= 98.1 and h <= 119.9
	var technical: bool = w >= 43.2 and w <= 66.0 and h >= 98.1 and h <= 132.0
	return residential or technical


func _test_binder_contract() -> void:
	print("1. Binder ROUTE + spec apertures match THRESHOLD §7.1...")
	_expect(FileAccess.file_exists(BINDER_PATH), "threshold_binder.gd missing")
	_expect(FileAccess.file_exists(ZONE_PATH), "threshold_zone.gd missing")
	_expect(ThresholdBinderScript.ROUTE.size() == EXPECTED_ROUTE_SIZE,
		"Binder ROUTE must hold %d stations (got %d)" % [EXPECTED_ROUTE_SIZE, ThresholdBinderScript.ROUTE.size()])
	var seen: Dictionary = {}
	for station_id: String in ROUTE:
		_expect(ThresholdBinderScript.is_route_station(StringName(station_id)),
			"Binder must route %s" % station_id)
		seen[station_id] = true
	for routed: StringName in ThresholdBinderScript.ROUTE:
		_expect(seen.has(String(routed)), "Binder routes unknown station: %s" % String(routed))
	for station_id: String in ROUTE:
		var spec: Dictionary = ThresholdBinderScript.spec_for(station_id)
		_expect(not spec.is_empty(), "Binder spec missing for %s" % station_id)
		if spec.is_empty():
			continue
		var family: int = int(spec.get("family", -1))
		_expect(family == _expected_family(station_id),
			"%s family %d != expected %d" % [station_id, family, _expected_family(station_id)])
		var size := Vector2(float(spec.get("width", 0.0)), float(spec.get("height", 0.0)))
		_expect(_aperture_legal(family, size),
			"%s spec aperture %.0fx%.0f outside §7.1" % [station_id, size.x, size.y])


# ─── 2. No static Threshold nodes on the campaign (sole owner) ──────────

func _test_no_static_thresholds() -> void:
	print("2. Campaign scenes must not carry static Threshold nodes...")
	var station_ids: Array[String] = []
	var dir: DirAccess = DirAccess.open("res://scenes/levels")
	_expect(dir != null, "scenes/levels must be listable")
	if dir == null:
		return
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if fname.begins_with("station_") and fname.ends_with(".tscn") and not dir.current_is_dir():
			station_ids.append(fname.get_basename())
		fname = dir.get_next()
	dir.list_dir_end()
	_expect(station_ids.size() == 45, "campaign must keep 45 station scenes (got %d)" % station_ids.size())
	for station_id: String in station_ids:
		var text: String = _read("res://scenes/levels/%s.tscn" % station_id)
		if text.is_empty():
			continue
		_expect(not text.contains('name="Threshold"'),
			"%s.tscn must not carry a static Threshold node (Binder is the sole owner)" % station_id)


# ─── 3. Airlock overlap never starts progress (all 22) ──────────────────

func _extract_airlock_handler(text: String) -> String:
	var marker: String = "func _on_airlock"
	var start: int = text.find(marker)
	if start < 0:
		return ""
	var next_func: int = text.find("\nfunc ", start + marker.length())
	if next_func < 0:
		return text.substr(start)
	return text.substr(start, next_func - start)


func _test_airlock_never_progresses() -> void:
	print("3. Airlock handlers must not start progress on any of the 22...")
	for station_id: String in ROUTE:
		var path: String = "res://scripts/levels/%s.gd" % station_id
		if not FileAccess.file_exists(path):
			_expect(false, "missing %s" % path)
			continue
		var text: String = _read(path)
		if text.is_empty():
			continue
		_expect(not text.contains("call_deferred(\"_complete_if_player_already_in_airlock\")"),
			"%s still auto-completes from airlock overlap" % station_id)
		var handler: String = _extract_airlock_handler(text)
		if handler.is_empty():
			continue
		_expect(not handler.contains("_trigger_level_completion")
			and not handler.contains("board_line_four")
			and not handler.contains("level_completed.emit")
			and not handler.contains("_complete_campaign"),
			"%s _on_airlock still starts progress" % station_id)


# ─── 4. Exits open from scene start, zero readings ──────────────────────

func _test_exits_open_without_readings() -> void:
	print("4. Every route station opens its exit with zero readings...")
	var families_seen: Dictionary = {}
	for station_id: String in ROUTE:
		var packed: PackedScene = load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s.tscn must load" % station_id)
		if packed == null:
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		# GameStateManager deferred pair runs here: ThresholdBinder.install
		# + GapLedger.ensure_exit_open (node_added observer).
		await process_frame
		await process_frame
		await process_frame
		_expect(not bool(station.get("is_level_completed")),
			"%s must not complete on load" % station_id)
		_expect(bool(station.get("is_exit_unlocked")),
			"%s exit must be unlocked with zero readings" % station_id)
		var zone: Node = station.get_node_or_null("Threshold")
		_expect(zone != null, "%s missing Binder ThresholdZone" % station_id)
		if zone != null:
			_expect(bool(zone.get("is_open")),
				"%s Threshold must be open with zero readings" % station_id)
			var family: int = int(zone.get("entry_family"))
			families_seen[family] = true
			_expect(family == _expected_family(station_id),
				"%s live family %d != expected %d" % [station_id, family, _expected_family(station_id)])
			var size: Vector2 = zone.call("aperture_size") as Vector2
			_expect(_aperture_legal(family, size),
				"%s live aperture %.0fx%.0f outside §7.1" % [station_id, size.x, size.y])
			var zone2d := zone as Node2D
			if zone2d != null:
				_expect(zone2d.position.x + size.x * 0.5 <= 617.0,
					"%s aperture closer than 24 px to the right edge" % station_id)
			var crossed_conns: Array = (zone as Area2D).crossed.get_connections()
			_expect(not crossed_conns.is_empty(),
				"%s Threshold.crossed must be wired" % station_id)
			var airlock := station.get_node_or_null("AirlockZone") as Area2D
			_expect(airlock != null, "%s must keep AirlockZone as closure" % station_id)
			if airlock != null:
				_expect(airlock.body_entered.get_connections().is_empty(),
					"%s AirlockZone still has body_entered connections" % station_id)
		station.queue_free()
		await process_frame
	_expect(families_seen.has(FAMILY_DOOR), "DOOR family unused on the route")
	_expect(families_seen.has(FAMILY_VEHICLE), "VEHICLE family unused on the route")
	_expect(families_seen.has(FAMILY_HATCH), "HATCH family unused on the route")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0214 THRESHOLD OWNERSHIP PASS: Binder sole owner, 22/22 exits open with zero readings, airlock never progresses.")
		quit(0)
	else:
		print("PKG-0214 THRESHOLD OWNERSHIP FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - %s" % failure)
		quit(1)
