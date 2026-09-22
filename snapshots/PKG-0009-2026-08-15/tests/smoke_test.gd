extends SceneTree

const PROFILE_PATHS := {
	&"A": "res://resources/movement/profile_a.tres",
	&"B": "res://resources/movement/profile_b.tres",
	&"C": "res://resources/movement/profile_c.tres",
}
const CONTROLLED_FIELDS: Array[StringName] = [
	&"ground_acceleration",
	&"ground_deceleration",
	&"air_acceleration",
	&"air_deceleration",
]
const SHARED_FIELDS: Array[StringName] = [
	&"move_speed",
	&"jump_velocity",
	&"gravity",
	&"fall_gravity_multiplier",
	&"coyote_time",
	&"jump_buffer_time",
	&"jump_release_multiplier",
	&"max_fall_speed",
]
const BASELINE_A_VALUES := {
	&"move_speed": 96.0,
	&"ground_acceleration": 900.0,
	&"ground_deceleration": 1100.0,
	&"air_acceleration": 480.0,
	&"air_deceleration": 480.0,
	&"jump_velocity": -252.0,
	&"gravity": 720.0,
	&"fall_gravity_multiplier": 1.35,
	&"coyote_time": 0.10,
	&"jump_buffer_time": 0.15,
	&"jump_release_multiplier": 0.45,
	&"max_fall_speed": 360.0,
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("SMOKE: " + message)


func _run() -> void:
	_expect(ProjectSettings.get_setting("application/config/name") == "Getting Strange", "unexpected project name")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_width") == 640, "viewport width must be 640")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_height") == 360, "viewport height must be 360")

	for action in [&"move_left", &"move_right", &"jump", &"restart", &"pause"]:
		_expect(InputMap.has_action(action), "missing input action: %s" % action)

	var profiles := _test_movement_profiles()

	var packed_lab := load("res://scenes/prototype/movement_lab.tscn") as PackedScene
	_expect(packed_lab != null, "movement lab scene does not load")
	if packed_lab == null:
		_finish()
		return

	var lab := packed_lab.instantiate()
	root.add_child(lab)
	await physics_frame

	var player := lab.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "prototype player is missing")
	_expect(lab.get_node_or_null("Geometry") != null, "geometry root is missing")
	_expect(lab.get_node_or_null("KillZone") != null, "kill zone is missing")
	_expect(lab.get_node_or_null("Goal") != null, "goal is missing")
	if player == null:
		_finish()
		return
	_expect(
		player.movement_profile == profiles.get(&"A"),
		"default scene must use baseline profile A"
	)

	for frame in range(45):
		await physics_frame
	_expect(player.is_on_floor(), "player should settle on the starting floor")

	var start_x := player.global_position.x
	Input.action_press(&"move_right")
	for frame in range(20):
		await physics_frame
	Input.action_release(&"move_right")
	_expect(player.global_position.x > start_x + 12.0, "right input should move the player")

	Input.action_press(&"jump")
	await physics_frame
	Input.action_release(&"jump")
	await physics_frame
	_expect(player.velocity.y < 0.0, "jump should create upward velocity")

	player.reset_to(Vector2(48.0, 296.0))
	_expect(player.velocity == Vector2.ZERO, "reset should clear velocity")
	_expect(player.global_position == Vector2(48.0, 296.0), "reset should restore spawn position")
	for frame in range(30):
		await physics_frame

	# A deterministic input sequence proves the graybox is traversable with the
	# same controller code used by a player, rather than with teleports.
	var jump_marks := [190.0, 250.0, 360.0, 494.0]
	var next_jump := 0
	Input.action_press(&"move_right")
	for frame in range(600):
		if next_jump < jump_marks.size() \
				and player.global_position.x >= jump_marks[next_jump] \
				and player.is_on_floor():
			Input.action_press(&"jump")
			for hold_frame in range(20):
				await physics_frame
			Input.action_release(&"jump")
			next_jump += 1
		else:
			await physics_frame

		if player.global_position.x >= 590.0:
			break
	Input.action_release(&"move_right")
	Input.action_release(&"jump")
	_expect(
		player.global_position.x >= 590.0,
		"movement lab route should be traversable (x=%.1f, jumps=%d)" % [
			player.global_position.x,
			next_jump,
		]
	)

	lab.queue_free()
	await process_frame
	_finish()


func _test_movement_profiles() -> Dictionary:
	var profiles := {}
	for profile_id in PROFILE_PATHS:
		var profile := load(PROFILE_PATHS[profile_id]) as MovementProfile
		_expect(profile != null, "movement profile %s must load" % profile_id)
		if profile != null:
			profiles[profile_id] = profile

	if profiles.size() != PROFILE_PATHS.size():
		return profiles

	for field in BASELINE_A_VALUES:
		_expect(
			profiles[&"A"].get(field) == BASELINE_A_VALUES[field],
			"profile A must preserve baseline field %s" % field
		)

	for field in SHARED_FIELDS:
		var baseline_value: Variant = profiles[&"A"].get(field)
		for profile_id in [&"B", &"C"]:
			_expect(
				profiles[profile_id].get(field) == baseline_value,
				"shared field %s must match profile A in profile %s" % [field, profile_id]
			)

	for field in CONTROLLED_FIELDS:
		var values := {}
		for profile_id in PROFILE_PATHS:
			values[profiles[profile_id].get(field)] = true
		_expect(
			values.size() == PROFILE_PATHS.size(),
			"controlled field %s must differ across A, B and C" % field
		)

	_expect(
		MovementProfileCatalog.get_profile(&"Z") == null,
		"unknown movement profile must not resolve"
	)
	for profile_id in PROFILE_PATHS:
		_expect(
			MovementProfileCatalog.get_profile(profile_id) == profiles[profile_id],
			"catalog must resolve movement profile %s" % profile_id
		)
	return profiles


func _finish() -> void:
	if _failures.is_empty():
		print("SMOKE PASS: project, scene, input and player physics")
		quit(0)
	else:
		print("SMOKE FAIL: %d check(s) failed" % _failures.size())
		quit(1)
