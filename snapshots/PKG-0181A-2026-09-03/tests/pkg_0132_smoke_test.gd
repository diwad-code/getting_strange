extends SceneTree

## PKG-0132: Lena 4.0 sprites, WORLD_SCALE, bidirectional return, 18 px step.

const CAMPAIGN_IDS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41", &"station_42a", &"station_42b", &"station_42c", &"station_43",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(cond: bool, msg: String) -> void:
	if not cond:
		_failures.append(msg)
		printerr("FAIL: " + msg)


func _run() -> void:
	print("--- PKG-0132 Smoke Test: Lena 4.0, scale, return, 18px step ---")
	_test_lena_sprites_and_capsule()
	_test_return_signals()
	_test_geometry_threshold_and_exe()
	await _test_backtrack_spawn()
	if _failures.is_empty():
		print("PKG-0132: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)


func _test_lena_sprites_and_capsule() -> void:
	print("1. LenaVisualRig 4.0 sprite contract...")
	_expect(ResourceLoader.exists("res://assets/characters/lena/idle.png"), "idle.png must exist")
	_expect(ResourceLoader.exists("res://assets/characters/lena/walk_0.png"), "walk_0.png must exist")
	_expect(ResourceLoader.exists("res://assets/characters/lena/run_0.png"), "run_0.png must exist")
	_expect(ResourceLoader.exists("res://assets/characters/lena/climb_0.png"), "climb_0.png must exist")

	var rig := LenaVisualRig.new()
	root.add_child(rig)
	_expect(not rig.draws_polygonal_body(), "LenaVisualRig must not draw polygonal body")
	var visual_h := rig.get_visual_height()
	_expect(visual_h >= 84.0 and visual_h <= 90.0, "visual height %.1f must be 84-90" % visual_h)
	var required := [
		&"idle", &"start", &"walk", &"run", &"stop", &"turn",
		&"jump_rise", &"jump_fall", &"land", &"interact", &"examine",
		&"unease_reaction", &"seam_gesture", &"climb",
	]
	for st in required:
		rig.set_state(st)
		_expect(rig.get_active_state_name() == st, "missing state %s" % st)
	rig.queue_free()

	var packed := load("res://scenes/player/prototype_player.tscn") as PackedScene
	_expect(packed != null, "prototype_player.tscn must load")
	if packed:
		var player := packed.instantiate() as PrototypePlayer
		root.add_child(player)
		var col := player.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_expect(col != null and col.shape is CapsuleShape2D, "player capsule missing")
		if col and col.shape is CapsuleShape2D:
			var capsule := col.shape as CapsuleShape2D
			_expect(is_equal_approx(capsule.height, 72.0), "capsule height must be 72, got %.1f" % capsule.height)
			_expect(is_equal_approx(capsule.radius, 8.0), "capsule radius must be 8, got %.1f" % capsule.radius)
		player.queue_free()


func _test_return_signals() -> void:
	print("2. previous_level_requested on stations 02-43...")
	var station_01 := load("res://scripts/levels/station_01.gd")
	_expect(station_01 != null, "station_01 script loads")
	for station_id in CAMPAIGN_IDS:
		if station_id == &"station_01":
			continue
		var scene_path := "res://scenes/levels/%s.tscn" % String(station_id)
		var packed := load(scene_path) as PackedScene
		_expect(packed != null, "%s must load" % scene_path)
		if packed == null:
			continue
		var inst := packed.instantiate()
		_expect(inst.has_signal(&"previous_level_requested"), "%s missing previous_level_requested" % station_id)
		inst.queue_free()


func _test_geometry_threshold_and_exe() -> void:
	print("3. geometry_audit 18 px threshold and no new exe...")
	var audit := FileAccess.get_file_as_string("res://tools/geometry_audit.gd")
	_expect(audit.contains("step_up > 18.0"), "geometry_audit must use 18 px threshold")
	_expect(not audit.contains("step_up > 35.0"), "geometry_audit must not keep 35 px threshold")
	var exe_count := _count_tree_exe("res://")
	_expect(exe_count == 0, "zero new exe under project res://, found %d" % exe_count)


func _count_tree_exe(path: String) -> int:
	var count := 0
	var dir := DirAccess.open(path)
	if dir == null:
		return 0
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if name == "." or name == ".." or name.begins_with("."):
			name = dir.get_next()
			continue
		var child := path.path_join(name)
		if dir.current_is_dir():
			if name in ["snapshots", "dist", "archive_retired_web"]:
				name = dir.get_next()
				continue
			count += _count_tree_exe(child)
		elif name.to_lower().ends_with(".exe") and not name.begins_with("Godot_v"):
			count += 1
		name = dir.get_next()
	return count


func _test_backtrack_spawn() -> void:
	print("4. GSM previous station and ReturnZone...")
	var gsm_script := load("res://scripts/core/game_state_manager.gd") as GDScript
	var gsm: Node = gsm_script.new()
	root.add_child(gsm)
	gsm.set("campaign_auto_transition_enabled", false)
	_expect(gsm.call("get_previous_campaign_station", &"station_05") == &"station_04", "05 previous is 04")
	_expect(gsm.call("get_previous_campaign_station", &"station_04") == &"station_03", "04 previous is 03")
	_expect(gsm.call("get_previous_campaign_station", &"station_01") == &"", "01 has no previous")

	var packed := load("res://scenes/levels/station_05.tscn") as PackedScene
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await process_frame
	_expect(station.has_signal(&"previous_level_requested"), "station_05 signal")
	var zone := station.get_node_or_null("ReturnZone")
	_expect(zone != null, "GSM must attach ReturnZone to station_05")
	station.queue_free()
	gsm.queue_free()
	for _i in 3:
		await process_frame
