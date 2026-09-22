extends SceneTree

## PKG-0134: every campaign station is physically traversable and interactable.

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
	print("--- PKG-0134 Smoke Test: campaign playability ---")
	_test_curb_step_api()
	await _test_door_clearance()
	_test_station_contracts()
	await _test_station_26_partition()
	if _failures.is_empty():
		print("PKG-0134: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)


func _test_curb_step_api() -> void:
	print("1. 18 px curb step exists on PrototypePlayer...")
	var packed := load("res://scenes/player/prototype_player.tscn") as PackedScene
	_expect(packed != null, "prototype_player.tscn loads")
	if packed == null:
		return
	var player := packed.instantiate() as PrototypePlayer
	root.add_child(player)
	_expect(player.has_method("try_curb_step"), "try_curb_step must exist")
	_expect(is_equal_approx(player.MAX_CURB_STEP, 18.0), "MAX_CURB_STEP is 18")
	player.queue_free()


func _test_door_clearance() -> void:
	print("2. ExitClearance disables Station 02 door...")
	var packed := load("res://scenes/levels/station_02.tscn") as PackedScene
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	if station.has_method("unlock_exit_door"):
		station.call("unlock_exit_door")
	var shape := station.get_node_or_null("ChamberDoor/CollisionShape2D") as CollisionShape2D
	_expect(shape != null, "Station 02 ChamberDoor shape exists")
	if shape:
		_expect(shape.disabled, "Station 02 open door must disable collider")
	station.queue_free()
	await process_frame


func _test_station_contracts() -> void:
	print("3. All 45 stations have Player, AirlockZone, level_completed...")
	for station_id in STATIONS:
		var path := "res://scenes/levels/%s.tscn" % String(station_id)
		var packed := load(path) as PackedScene
		_expect(packed != null, "%s loads" % station_id)
		if packed == null:
			continue
		var inst := packed.instantiate()
		_expect(inst.get_node_or_null("Player") != null, "%s has Player" % station_id)
		_expect(inst.find_child("AirlockZone", true, false) != null, "%s has AirlockZone" % station_id)
		_expect(inst.has_signal(&"level_completed"), "%s has level_completed" % station_id)
		if station_id != &"station_01":
			_expect(inst.has_signal(&"previous_level_requested"), "%s has previous_level_requested" % station_id)
		inst.queue_free()


func _test_station_26_partition() -> void:
	print("4. Station 26 isolation partition opens on unlock...")
	var packed := load("res://scenes/levels/station_26.tscn") as PackedScene
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	if station.has_method("_unlock_exit"):
		station.call("_unlock_exit")
	var shape := station.get_node_or_null("Geometry/AdaptiveIsolationPartition/CollisionShape2D") as CollisionShape2D
	_expect(shape != null, "AdaptiveIsolationPartition shape exists")
	if shape:
		_expect(shape.disabled, "Station 26 partition must disable on unlock")
	var player := station.get_node_or_null("Player") as CharacterBody2D
	_expect(player != null, "Station 26 has player")
	if player:
		player.set_physics_process(false)
		var frames := 360
		while frames > 0:
			frames -= 1
			var dx := 610.0 - player.global_position.x
			if absf(dx) <= 12.0:
				break
			if not player.is_on_floor():
				player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
			else:
				player.velocity.y = 0.0
			player.velocity.x = signf(dx) * 96.0
			player.move_and_slide()
			if player.has_method("try_curb_step"):
				player.call("try_curb_step", dx)
			await physics_frame
		_expect(player.global_position.x >= 560.0, "Station 26 walk reaches exit, x=%.1f" % player.global_position.x)
	station.queue_free()
	await process_frame
