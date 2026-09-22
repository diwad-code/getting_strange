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

	for action in [&"move_left", &"move_right", &"jump", &"restart", &"pause", &"interact", &"trigger_correction"]:
		_expect(InputMap.has_action(action), "missing input action: %s" % action)

	var profiles := _test_movement_profiles()
	_test_procedural_audio()

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

	await _test_anchor_lab()
	_finish()


func _test_procedural_audio() -> void:
	var anchor_sfx := ProceduralAudio.create_anchor_sound()
	_expect(anchor_sfx != null, "anchor sound synthesis failed")
	_expect(anchor_sfx.data.size() > 0, "anchor sound buffer empty")
	_expect(anchor_sfx.format == AudioStreamWAV.FORMAT_16_BITS, "anchor sound format must be 16-bit")

	var unanchor_sfx := ProceduralAudio.create_unanchor_sound()
	_expect(unanchor_sfx != null, "unanchor sound synthesis failed")
	_expect(unanchor_sfx.data.size() > 0, "unanchor sound buffer empty")

	var correction_sfx := ProceduralAudio.create_correction_pulse_sound()
	_expect(correction_sfx != null, "correction pulse sound synthesis failed")
	_expect(correction_sfx.data.size() > 0, "correction pulse sound buffer empty")

	var resist_sfx := ProceduralAudio.create_resist_sound()
	_expect(resist_sfx != null, "resist sound synthesis failed")
	_expect(resist_sfx.data.size() > 0, "resist sound buffer empty")

	var goal_sfx := ProceduralAudio.create_goal_sound()
	_expect(goal_sfx != null, "goal sound synthesis failed")
	_expect(goal_sfx.data.size() > 0, "goal sound buffer empty")


func _test_anchor_lab() -> void:
	var packed_anchor_lab := load("res://scenes/prototype/anchor_lab.tscn") as PackedScene
	_expect(packed_anchor_lab != null, "anchor lab scene does not load")
	if packed_anchor_lab == null:
		return

	var anchor_lab := packed_anchor_lab.instantiate() as AnchorLab
	root.add_child(anchor_lab)
	await physics_frame

	var player := anchor_lab.get_node_or_null("Player") as PrototypePlayer
	var camera := anchor_lab.get_node_or_null("Camera") as CinematicCamera
	var geometry := anchor_lab.get_node_or_null("Geometry")
	var anchorables := anchor_lab.get_node_or_null("Anchorables")
	var goal := anchor_lab.get_node_or_null("Goal")
	var kill_zone := anchor_lab.get_node_or_null("KillZone")

	_expect(player != null, "anchor lab: player missing")
	_expect(camera != null, "anchor lab: cinematic camera missing")
	_expect(geometry != null, "anchor lab: geometry missing")
	_expect(anchorables != null, "anchor lab: anchorables node missing")
	_expect(goal != null, "anchor lab: goal missing")
	_expect(kill_zone != null, "anchor lab: kill zone missing")

	_expect(anchor_lab.get_node_or_null("CorrectionAudioPlayer") != null, "CorrectionAudioPlayer missing")
	_expect(anchor_lab.get_node_or_null("GoalAudioPlayer") != null, "GoalAudioPlayer missing")

	# Camera & Chamber Tests
	if camera != null:
		_expect(camera.chamber_bounds.size() == 3, "camera must configure 3 chamber bounds")
		_expect(camera.active_chamber_index == 0, "initial active chamber must be Chamber 1 (index 0)")
		_expect(camera.get_active_chamber_rect() == Rect2(Vector2(0, 0), Vector2(640, 360)), "chamber 1 rect mismatch")

		# Test chamber transition
		camera.set_chamber(1, true)
		_expect(camera.active_chamber_index == 1, "active chamber must switch to Chamber 2 (index 1)")
		_expect(camera.global_position == Vector2(960, 180), "camera must center on Chamber 2 (960, 180)")

		camera.set_chamber(2, true)
		_expect(camera.active_chamber_index == 2, "active chamber must switch to Chamber 3 (index 2)")
		_expect(camera.global_position == Vector2(1600, 180), "camera must center on Chamber 3 (1600, 180)")

		# Test camera trauma / shake
		camera.add_trauma(0.5)
		_expect(camera._shake_intensity >= 0.49, "camera trauma should be applied")

		# Reset camera to Chamber 1
		camera.set_chamber(0, true)

	if anchorables == null:
		anchor_lab.queue_free()
		await process_frame
		return

	var bridge1 := anchorables.get_node_or_null("Chamber1Bridge") as AnchorableObject
	var lift := anchorables.get_node_or_null("Chamber2Lift") as AnchorableObject
	var bridge3 := anchorables.get_node_or_null("Chamber3Bridge") as AnchorableObject
	var gate := anchorables.get_node_or_null("Chamber3Gate") as AnchorableObject

	_expect(bridge1 != null, "Chamber1Bridge anchorable object missing")
	_expect(lift != null, "Chamber2Lift anchorable object missing")
	_expect(bridge3 != null, "Chamber3Bridge anchorable object missing")
	_expect(gate != null, "Chamber3Gate anchorable object missing")

	if bridge1 == null or lift == null or bridge3 == null or gate == null:
		anchor_lab.queue_free()
		await process_frame
		return

	_expect(bridge1.get_node_or_null("AudioPlayer2D") != null, "bridge1 AudioPlayer2D missing")
	_expect(bridge1.get_node_or_null("AnchorParticles") != null, "bridge1 AnchorParticles missing")
	_expect(bridge1.get_node_or_null("ResistParticles") != null, "bridge1 ResistParticles missing")

	# Test 1: Single Anchor exclusivity rule across multi-chamber facility
	_expect(anchor_lab.active_anchor == null, "initial active anchor should be null")
	anchor_lab.set_active_anchor(bridge1)
	_expect(bridge1.is_anchored, "bridge1 should be anchored")
	_expect(anchor_lab.active_anchor == bridge1, "active anchor should be bridge1")

	anchor_lab.set_active_anchor(lift)
	_expect(lift.is_anchored, "lift should be anchored")
	_expect(not bridge1.is_anchored, "bridge1 should be unanchored when lift is anchored")
	_expect(anchor_lab.active_anchor == lift, "active anchor should be lift")

	# Test 2: Reality Shift / Resistance behavior
	_expect(anchor_lab.current_reality == AnchorableObject.RealityState.STATE_A, "initial reality should be STATE_A")
	_expect(bridge1.current_reality == AnchorableObject.RealityState.STATE_A, "bridge1 should be in STATE_A")

	# Trigger correction pulse to STATE_B
	anchor_lab.trigger_correction_pulse()
	_expect(anchor_lab.current_reality == AnchorableObject.RealityState.STATE_B, "reality should shift to STATE_B")
	# bridge1 is unanchored -> yielded to STATE_B
	_expect(bridge1.current_reality == AnchorableObject.RealityState.STATE_B, "unanchored bridge1 should yield to STATE_B")
	# lift is anchored -> resisted shift, stayed in STATE_A
	_expect(lift.is_anchored, "lift should remain anchored")
	_expect(lift.current_reality == AnchorableObject.RealityState.STATE_A, "anchored lift should resist shift and stay in STATE_A")
	# gate is unanchored -> yielded to STATE_B (opened)
	_expect(gate.current_reality == AnchorableObject.RealityState.STATE_B, "unanchored gate should yield to STATE_B")

	# Test 3: Respawn restores state
	anchor_lab._respawn()
	_expect(anchor_lab.current_reality == AnchorableObject.RealityState.STATE_A, "respawn should restore STATE_A")
	_expect(anchor_lab.active_anchor == null, "respawn should clear active anchor")
	_expect(not lift.is_anchored, "lift should be unanchored after respawn")
	_expect(lift.current_reality == AnchorableObject.RealityState.STATE_A, "lift should be in STATE_A after respawn")

	anchor_lab.queue_free()
	for f in range(4):
		await process_frame


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
