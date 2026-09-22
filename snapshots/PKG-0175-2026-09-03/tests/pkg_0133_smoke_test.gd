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
	await _test_station_01_door_and_opening_actions()
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


func _test_station_01_door_and_opening_actions() -> void:
	print("3. Station 01 opens after three bounded opening actions...")
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

	var measurement := station.get_node_or_null("Props/MeasurementRig") as OpeningActionPoint
	var sample := station.get_node_or_null("Props/SampleCase") as OpeningActionPoint
	var phone := station.get_node_or_null("Props/MartaPhone") as OpeningActionPoint
	_expect(measurement != null and measurement.action_id == &"repeat_line_four_measurement", "MeasurementRig must be the first bounded opening action")
	_expect(sample != null and sample.action_id == &"secure_raw_sample", "SampleCase must be the second bounded opening action")
	_expect(phone != null and phone.action_id == &"read_marta_message", "MartaPhone must be the third bounded opening action")
	_expect(station.get_node_or_null("Props/VibrationSensor") == null, "Station 01 must remove legacy resonance gallery")

	if measurement:
		_expect(measurement.trigger_interaction(), "MeasurementRig must trigger once")
		_expect(measurement.is_resolved, "MeasurementRig must resolve after the reading")
	if sample:
		_expect(sample.trigger_interaction(), "SampleCase must trigger after the reading")
		_expect(sample.is_resolved, "SampleCase must resolve after the sample is secured")
	if phone:
		_expect(phone.trigger_interaction(), "MartaPhone must trigger after the sample is secured")
		_expect(phone.is_resolved, "MartaPhone must resolve after the message")
		_expect(not phone.trigger_interaction(), "MartaPhone must remain one-shot after the message")
	var door_shape := station.get_node_or_null("ChamberDoor/CollisionShape2D") as CollisionShape2D
	_expect(door_shape != null, "ChamberDoor collider exists")
	if door_shape:
		for _i in 4:
			await process_frame
		_expect(door_shape.disabled, "open ChamberDoor must disable collision so 72 px capsule can pass")

	station.queue_free()
	for _i in 3:
		await process_frame
