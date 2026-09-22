extends SceneTree

## PKG-0135 Smoke Test: capture preview, one_way 09/11 remediation, 05->04->03 backtrack

const STATIONS: Array[StringName] = [
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
	print("--- PKG-0135 Smoke Test: capture, one_way 09/11, 05->04->03 backtrack ---")
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm:
		gsm.set("campaign_auto_transition_enabled", false)
	_test_visual_capture_reports()
	await _test_station_09_planter()
	await _test_station_11_sideboard()
	await _test_backtrack_05_04_03()
	_test_no_new_binaries()

	if _failures.is_empty():
		print("PKG-0135: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)


func _test_visual_capture_reports() -> void:
	print("1. Visual capture files exist in reports/...")
	var reports_dir := "res://reports"
	var expected_files: Array[String] = [
		"pkg_0135_station_01_lena.png",
		"pkg_0135_station_09_planter.png",
		"pkg_0135_station_11_sideboard.png",
		"pkg_0135_station_04_backtrack.png",
	]
	for fname: String in expected_files:
		var path: String = reports_dir + "/" + fname
		_expect(ResourceLoader.exists(path) or FileAccess.file_exists(ProjectSettings.globalize_path(path)), "Report %s exists" % fname)


func _test_station_09_planter() -> void:
	print("2. Station 09 StairwellPlanter is <=18px, no one_way, traversable without jumping...")
	var packed := load("res://scenes/levels/station_09.tscn") as PackedScene
	_expect(packed != null, "station_09 loads")
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame

	var planter := station.get_node_or_null("Geometry/StairwellPlanter") as MovableAnchorableProp
	_expect(planter != null, "StairwellPlanter exists")
	if planter:
		_expect(planter.crate_size.y <= 18.0, "Planter crate_size.y is <= 18px (got %.1f)" % planter.crate_size.y)
		var col_shape := planter.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_expect(col_shape != null, "Planter has CollisionShape2D")
		if col_shape:
			_expect(not col_shape.one_way_collision, "Planter must NOT have one_way_collision")

	# Walk test across station 09 past StairwellPlanter without jumping
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "station_09 has player")
	if player:
		player.set_physics_process(false)
		var target_x := 360.0
		var frames := 220
		while frames > 0:
			frames -= 1
			var dx := target_x - player.global_position.x
			if absf(dx) <= 8.0:
				break
			if not player.is_on_floor():
				player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
			else:
				player.velocity.y = 0.0
			player.velocity.x = signf(dx) * 120.0
			player.move_and_slide()
			if player.has_method("try_curb_step"):
				player.try_curb_step(dx)
			await physics_frame
		_expect(player.global_position.x >= 340.0, "Player walked past planter (x=248) to x=%.1f" % player.global_position.x)

	station.queue_free()
	await process_frame
	print("2. Station 09 PASS")


func _test_station_11_sideboard() -> void:
	print("3. Station 11 HallwaySideboard is <=18px, no one_way, traversable without jumping...")
	var packed := load("res://scenes/levels/station_11.tscn") as PackedScene
	_expect(packed != null, "station_11 loads")
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame

	var sideboard := station.get_node_or_null("Geometry/HallwaySideboard") as MovableAnchorableProp
	_expect(sideboard != null, "HallwaySideboard exists")
	if sideboard:
		_expect(sideboard.crate_size.y <= 18.0, "Sideboard crate_size.y is <= 18px (got %.1f)" % sideboard.crate_size.y)
		var col_shape := sideboard.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_expect(col_shape != null, "Sideboard has CollisionShape2D")
		if col_shape:
			_expect(not col_shape.one_way_collision, "Sideboard must NOT have one_way_collision")

	# Walk test across station 11 past HallwaySideboard without jumping
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "station_11 has player")
	if player:
		player.set_physics_process(false)
		var target_x := 500.0
		var frames := 320
		var fc := 0
		while frames > 0:
			frames -= 1
			fc += 1
			var dx := target_x - player.global_position.x
			if fc % 20 == 0 or absf(dx) <= 8.0:
				print("S11 Frame %d: pos=(%.1f, %.1f), on_floor=%s, on_wall=%s" % [fc, player.global_position.x, player.global_position.y, str(player.is_on_floor()), str(player.is_on_wall())])
			if absf(dx) <= 8.0:
				break
			if not player.is_on_floor():
				player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
			else:
				player.velocity.y = 0.0
			player.velocity.x = signf(dx) * 120.0
			player.move_and_slide()
			if player.has_method("try_curb_step"):
				player.try_curb_step(dx)
			await physics_frame
		_expect(player.global_position.x >= 480.0, "Player walked past sideboard (x=408) to x=%.1f" % player.global_position.x)

	station.queue_free()
	await process_frame
	print("3. Station 11 PASS")


func _test_backtrack_05_04_03() -> void:
	print("4. Backtrack chain 05 -> 04 -> 03 with ReturnZone and non-wall right spawn...")
	var gsm_node := root.get_node_or_null("GameStateManager")

	# --- Step 1: Station 05 ReturnZone ---
	var packed_s05 := load("res://scenes/levels/station_05.tscn") as PackedScene
	var st05 := packed_s05.instantiate() as Node2D
	root.add_child(st05)
	await process_frame
	await physics_frame
	await physics_frame

	var rz05 := st05.get_node_or_null("ReturnZone") as ReturnZone
	var back_requested_s05 := false
	st05.connect(&"previous_level_requested", func(): back_requested_s05 = true)
	if rz05:
		rz05.connect(&"return_requested", func(): back_requested_s05 = true)

	var p05 := st05.get_node_or_null("Player") as PrototypePlayer
	_expect(p05 != null, "Station 05 player exists")
	if p05:
		p05.set_physics_process(false)
		p05.global_position = Vector2(80.0, 269.0)
		for _i in 50:
			if back_requested_s05:
				break
			p05.velocity = Vector2(-160.0, 0.0)
			p05.move_and_slide()
			await physics_frame
	_expect(back_requested_s05, "Station 05 triggers previous_level_requested at ReturnZone")
	st05.queue_free()
	await process_frame

	# --- Step 2: Station 04 backtrack from right to left ---
	if gsm_node:
		gsm_node.set("target_spawn_side", &"right")
	var packed_s04 := load("res://scenes/levels/station_04.tscn") as PackedScene
	var st04 := packed_s04.instantiate() as Node2D
	root.add_child(st04)
	await process_frame
	await physics_frame
	await physics_frame

	var rz04 := st04.get_node_or_null("ReturnZone") as ReturnZone
	var back_requested_s04 := false
	st04.connect(&"previous_level_requested", func(): back_requested_s04 = true)
	if rz04:
		rz04.connect(&"return_requested", func(): back_requested_s04 = true)

	var p04 := st04.get_node_or_null("Player") as PrototypePlayer
	_expect(p04 != null, "Station 04 player exists")
	if p04:
		# Simulate GSM right spawn at Y=269
		p04.reset_to(Vector2(560.0, 269.0))
		_expect(not p04.test_move(p04.global_transform, Vector2.ZERO), "Station 04 player spawn is NOT stuck in wall at x=560")
		p04.set_physics_process(false)

		# Walk left all the way to ReturnZone at x=18
		var target_x := 18.0
		var frames := 260
		while frames > 0:
			frames -= 1
			var dx := target_x - p04.global_position.x
			if absf(dx) <= 6.0 or back_requested_s04:
				break
			if not p04.is_on_floor():
				p04.velocity.y = minf(p04.velocity.y + 12.0, 360.0)
			else:
				p04.velocity.y = 0.0
			p04.velocity.x = signf(dx) * 200.0
			p04.move_and_slide()
			if p04.has_method("try_curb_step"):
				p04.try_curb_step(dx)
			await physics_frame
		_expect(p04.global_position.x <= 28.0, "Station 04 player walked left to ReturnZone (at x=%.1f)" % p04.global_position.x)

	for _i in 5:
		await physics_frame
	_expect(back_requested_s04, "Station 04 triggers previous_level_requested at ReturnZone")
	st04.queue_free()
	await process_frame

	# --- Step 3: Station 03 backtrack from right to left ---
	if gsm_node:
		gsm_node.set("target_spawn_side", &"right")
	var packed_s03 := load("res://scenes/levels/station_03.tscn") as PackedScene
	var st03 := packed_s03.instantiate() as Node2D
	root.add_child(st03)
	await process_frame
	await physics_frame
	await physics_frame

	var rz03 := st03.get_node_or_null("ReturnZone") as ReturnZone
	var back_requested_s03 := false
	st03.connect(&"previous_level_requested", func(): back_requested_s03 = true)
	if rz03:
		rz03.connect(&"return_requested", func(): back_requested_s03 = true)

	var p03 := st03.get_node_or_null("Player") as PrototypePlayer
	_expect(p03 != null, "Station 03 player exists")
	if p03:
		# Simulate GSM right spawn at Y=269
		p03.reset_to(Vector2(560.0, 269.0))
		_expect(not p03.test_move(p03.global_transform, Vector2.ZERO), "Station 03 player spawn is NOT stuck in wall at x=560")
		p03.set_physics_process(false)

		# Walk left all the way to ReturnZone at x=18
		var target_x := 18.0
		var frames := 260
		while frames > 0:
			frames -= 1
			var dx := target_x - p03.global_position.x
			if absf(dx) <= 6.0 or back_requested_s03:
				break
			if not p03.is_on_floor():
				p03.velocity.y = minf(p03.velocity.y + 12.0, 360.0)
			else:
				p03.velocity.y = 0.0
			p03.velocity.x = signf(dx) * 200.0
			p03.move_and_slide()
			if p03.has_method("try_curb_step"):
				p03.try_curb_step(dx)
			await physics_frame
		_expect(p03.global_position.x <= 28.0, "Station 03 player walked left to ReturnZone (at x=%.1f)" % p03.global_position.x)

	for _i in 5:
		await physics_frame
	_expect(back_requested_s03, "Station 03 triggers previous_level_requested at ReturnZone")
	st03.queue_free()
	await process_frame
	if gsm_node:
		gsm_node.set("target_spawn_side", &"left")
	print("4. Backtrack chain PASS")


func _test_no_new_binaries() -> void:
	print("5. Enforcing D-125: zero new .exe binaries in tree...")
	var exe_count := _count_tree_exe("res://")
	_expect(exe_count == 0, "zero new exe under project res://, found %d" % exe_count)


func _count_tree_exe(path: String) -> int:
	var count := 0
	var dir := DirAccess.open(path)
	if dir == null:
		return 0
	dir.list_dir_begin()
	var fname := dir.get_next()
	while fname != "":
		if fname == "." or fname == ".." or fname.begins_with("."):
			fname = dir.get_next()
			continue
		var child := path.path_join(fname)
		if dir.current_is_dir():
			if fname in ["snapshots", "dist", "archive_retired_web"]:
				fname = dir.get_next()
				continue
			count += _count_tree_exe(child)
		elif fname.to_lower().ends_with(".exe") and not fname.begins_with("Godot_v"):
			count += 1
		fname = dir.get_next()
	return count
