extends SceneTree

## PKG-0133: walk-by-default, Shift sprint, Station 01 exit, resolved interact.

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(cond: bool, msg: String) -> void:
	if not cond:
		_failures.append(msg)
		printerr("FAIL: " + msg)


func _run() -> void:
	print("--- PKG-0133 Smoke Test: walk gait, Station 01 exit, resolved interact ---")
	_test_sprint_binding()
	_test_walk_default_run_only_when_sprinting()
	await _test_station_01_door_and_one_shot()
	if _failures.is_empty():
		print("PKG-0133: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)


func _test_sprint_binding() -> void:
	print("1. sprint InputMap (Shift + LB)...")
	_expect(InputMap.has_action(&"sprint"), "sprint action must exist")
	if not InputMap.has_action(&"sprint"):
		return
	var events := InputMap.action_get_events(&"sprint")
	var has_key := false
	var has_joy := false
	for ev in events:
		if ev is InputEventKey:
			has_key = true
			_expect(
				(ev as InputEventKey).physical_keycode == KEY_SHIFT,
				"sprint keyboard binding must be Shift"
			)
		elif ev is InputEventJoypadButton or ev is InputEventJoypadMotion:
			has_joy = true
	_expect(has_key, "sprint must have a keyboard binding")
	_expect(has_joy, "sprint must have a gamepad binding")


func _test_walk_default_run_only_when_sprinting() -> void:
	print("2. visual walk at profile speed; run only with sprint flag...")
	var rig := LenaVisualRig.new()
	root.add_child(rig)
	rig.set_mechanical_state(Vector2(96.0, 0.0), true, false, false)
	_expect(rig.get_active_state_name() == &"walk", "96 px/s without sprint must be walk, got %s" % rig.get_active_state_name())
	rig.set_mechanical_state(Vector2(130.0, 0.0), true, false, true)
	_expect(rig.get_active_state_name() == &"run", "sprint flag must select run, got %s" % rig.get_active_state_name())
	rig.set_mechanical_state(Vector2.ZERO, true, false, false)
	_expect(rig.get_active_state_name() == &"idle", "zero velocity must be idle")
	rig.queue_free()


func _test_station_01_door_and_one_shot() -> void:
	print("3. Station 01 open door disables collider; one-shot props stay resolved...")
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed != null, "station_01.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station01
	_expect(station != null, "station_01 must instantiate as Station01")
	if station == null:
		return
	root.add_child(station)
	await process_frame
	await process_frame

	var bag := station.get_node_or_null("Props/PackingBag") as MemoryResonancePoint
	var sensor := station.get_node_or_null("Props/VibrationSensor") as MemoryResonancePoint
	var photo := station.get_node_or_null("Props/PhotoDesk") as MemoryResonancePoint
	_expect(photo != null and photo.is_one_shot, "PhotoDesk must be one-shot")
	_expect(sensor != null and not sensor.is_one_shot, "VibrationSensor stays reusable until second reading")
	_expect(bag != null and not bag.is_one_shot, "PackingBag stays reusable until packed")

	if photo:
		photo.is_player_in_range = true
		photo.trigger_interaction()
		_expect(photo.is_activated, "first PhotoDesk interact must resolve")
		photo.trigger_interaction()
		_expect(photo.is_activated, "second PhotoDesk interact must remain resolved")

	_expect(station.observe_measurement_gap(), "gap observation must register")
	_expect(station.inspect_sensor_mount(), "mount check must register")
	_expect(station.record_raw_measurement(), "raw record must register")
	_expect(station.repeat_measurement(), "repeat trial must commit")
	_expect(station.preserve_raw_sample(), "sample preservation must commit")
	if sensor:
		_expect(not sensor.is_activated, "VibrationSensor stays resolved only after the trial sequence")
	var door_shape := station.get_node_or_null("ChamberDoor/CollisionShape2D") as CollisionShape2D
	_expect(door_shape != null, "ChamberDoor collider exists")
	if door_shape:
		for _i in 4:
			await process_frame
		_expect(door_shape.disabled, "open ChamberDoor must disable collision so 72 px capsule can pass")

	station.queue_free()
	for _i in 3:
		await process_frame
