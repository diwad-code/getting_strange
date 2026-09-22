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
	await _test_station_01()
	await _test_station_02()
	await _test_station_03()
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

	var footstep_linoleum := ProceduralAudio.create_footstep_linoleum_sound()
	_expect(footstep_linoleum != null, "footstep linoleum sound synthesis failed")
	_expect(footstep_linoleum.data.size() > 0, "footstep linoleum sound buffer empty")

	var footstep_metal := ProceduralAudio.create_footstep_metal_sound()
	_expect(footstep_metal != null, "footstep metal sound synthesis failed")
	_expect(footstep_metal.data.size() > 0, "footstep metal sound buffer empty")

	var land_linoleum := ProceduralAudio.create_land_sound(false)
	_expect(land_linoleum != null, "land linoleum sound synthesis failed")
	_expect(land_linoleum.data.size() > 0, "land linoleum sound buffer empty")

	var land_metal := ProceduralAudio.create_land_sound(true)
	_expect(land_metal != null, "land metal sound synthesis failed")
	_expect(land_metal.data.size() > 0, "land metal sound buffer empty")

	var airlock_seal := ProceduralAudio.create_airlock_seal_sound()
	_expect(airlock_seal != null, "airlock seal sound synthesis failed")
	_expect(airlock_seal.data.size() > 0, "airlock seal sound buffer empty")

	var memory_res := ProceduralAudio.create_memory_resonance_sound()
	_expect(memory_res != null, "memory resonance sound synthesis failed")
	_expect(memory_res.data.size() > 0, "memory resonance sound buffer empty")

	var switch_toggle := ProceduralAudio.create_switch_toggle_sound()
	_expect(switch_toggle != null, "switch toggle sound synthesis failed")
	_expect(switch_toggle.data.size() > 0, "switch toggle sound buffer empty")

	var vacuum_hum := ProceduralAudio.create_vacuum_hum_sound()
	_expect(vacuum_hum != null, "vacuum hum sound synthesis failed")
	_expect(vacuum_hum.data.size() > 0, "vacuum hum sound buffer empty")

	var corr_hum := ProceduralAudio.create_correlation_hum_sound()
	_expect(corr_hum != null, "correlation hum sound synthesis failed")
	_expect(corr_hum.data.size() > 0, "correlation hum sound buffer empty")

	var print_sfx := ProceduralAudio.create_printer_strip_sound()
	_expect(print_sfx != null, "printer strip sound synthesis failed")
	_expect(print_sfx.data.size() > 0, "printer strip sound buffer empty")

	var needle_sfx := ProceduralAudio.create_needle_spike_sound()
	_expect(needle_sfx != null, "needle spike sound synthesis failed")
	_expect(needle_sfx.data.size() > 0, "needle spike sound buffer empty")

	var phone_sfx := ProceduralAudio.create_phone_ring_pulse_sound()
	_expect(phone_sfx != null, "phone ring sound synthesis failed")
	_expect(phone_sfx.data.size() > 0, "phone ring sound buffer empty")

	var card_reader_sfx := ProceduralAudio.create_card_reader_beep_sound()
	_expect(card_reader_sfx != null, "card reader sound synthesis failed")
	_expect(card_reader_sfx.data.size() > 0, "card reader sound buffer empty")

	var fluor_sfx := ProceduralAudio.create_fluorescent_hum_sound()
	_expect(fluor_sfx != null, "fluorescent hum sound synthesis failed")
	_expect(fluor_sfx.data.size() > 0, "fluorescent hum sound buffer empty")


func _test_station_01() -> void:
	var packed_station := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed_station != null, "station_01 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station01
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var chamber_door := station.get_node_or_null("ChamberDoor")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_01: player missing")
	_expect(camera != null, "station_01: camera missing")
	_expect(geometry != null, "station_01: geometry missing")
	_expect(props != null, "station_01: props node missing")
	_expect(chamber_door != null, "station_01: chamber_door missing")
	_expect(airlock_zone != null, "station_01: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var photo := props.get_node_or_null("PhotoDesk") as MemoryResonancePoint
	var clipboard := props.get_node_or_null("Clipboard") as MemoryResonancePoint
	var c_alpha := props.get_node_or_null("CircuitAlpha") as MemoryResonancePoint
	var c_beta := props.get_node_or_null("CircuitBeta") as MemoryResonancePoint
	var c_gamma := props.get_node_or_null("CircuitGamma") as MemoryResonancePoint
	var vac_gauge := props.get_node_or_null("VacuumManometer") as MemoryResonancePoint
	var terminal := props.get_node_or_null("ChamberTerminal") as MemoryResonancePoint

	_expect(photo != null, "PhotoDesk prop missing")
	_expect(clipboard != null, "Clipboard prop missing")
	_expect(c_alpha != null, "CircuitAlpha prop missing")
	_expect(c_beta != null, "CircuitBeta prop missing")
	_expect(c_gamma != null, "CircuitGamma prop missing")
	_expect(vac_gauge != null, "VacuumManometer prop missing")
	_expect(terminal != null, "ChamberTerminal prop missing")

	if photo == null or c_alpha == null or c_beta == null or c_gamma == null or vac_gauge == null:
		station.queue_free()
		await process_frame
		return

	# Test 1: Proximity detection & memory resonance trigger
	_expect(not photo.is_player_in_range, "photo should not be in range initially (player at x=70, photo at x=140)")
	player.global_position = Vector2(140.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(photo.is_player_in_range, "photo should detect player in range at x=140")

	photo.trigger_interaction()
	_expect(photo.is_activated, "photo should be activated/inspected")
	_expect(station.photo_inspected, "station should register photo inspected")

	# Test 2: Circuit Switches & Procedure Execution
	_expect(not station.circuit_alpha_on, "Circuit Alpha should be off initially")
	_expect(not station.is_procedure_completed, "Procedure should not be complete initially")

	c_alpha.trigger_interaction()
	_expect(c_alpha.is_activated, "Circuit Alpha should be activated")
	_expect(station.circuit_alpha_on, "station.circuit_alpha_on should be true")

	c_beta.trigger_interaction()
	_expect(c_beta.is_activated, "Circuit Beta should be activated")
	_expect(station.circuit_beta_on, "station.circuit_beta_on should be true")

	c_gamma.trigger_interaction()
	_expect(c_gamma.is_activated, "Circuit Gamma should be activated")
	_expect(station.circuit_gamma_on, "station.circuit_gamma_on should be true")

	# Vacuum gauge check
	vac_gauge.trigger_interaction()
	_expect(vac_gauge.is_activated, "Vacuum gauge should be active")
	_expect(station.vacuum_checked, "station.vacuum_checked should be true")
	_expect(station.is_procedure_completed, "station procedure should be complete")

	# Advance frames to allow door opening tween to complete (1.2s at 60fps = 72 frames)
	for frame in range(80):
		await physics_frame

	_expect(station._door_open_progress >= 0.99, "chamber door should be fully opened")

	# Test 3: Player steps into Chamber Airlock
	player.global_position = Vector2(615.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "Station 01 level should be completed on entering airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_02() -> void:
	var packed_station := load("res://scenes/levels/station_02.tscn") as PackedScene
	_expect(packed_station != null, "station_02 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station02
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var chamber_door := station.get_node_or_null("ChamberDoor")
	var airlock_zone := station.get_node_or_null("AirlockZone")
	var shadow_renderer := station.get_node_or_null("DiscontinuousShadow") as DiscontinuousShadow

	_expect(player != null, "station_02: player missing")
	_expect(camera != null, "station_02: camera missing")
	_expect(geometry != null, "station_02: geometry missing")
	_expect(props != null, "station_02: props node missing")
	_expect(chamber_door != null, "station_02: chamber_door missing")
	_expect(airlock_zone != null, "station_02: airlock_zone missing")
	_expect(shadow_renderer != null, "station_02: shadow_renderer missing")

	if props == null or player == null or shadow_renderer == null:
		station.queue_free()
		await process_frame
		return

	var printer_prop := props.get_node_or_null("StripPrinter") as MemoryResonancePoint
	var console_prop := props.get_node_or_null("CorrelationConsole") as MemoryResonancePoint
	var calib_prop := props.get_node_or_null("OpticalCalibration") as MemoryResonancePoint

	_expect(printer_prop != null, "StripPrinter prop missing")
	_expect(console_prop != null, "CorrelationConsole prop missing")
	_expect(calib_prop != null, "OpticalCalibration prop missing")

	if printer_prop == null or console_prop == null or calib_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio player verifications
	_expect(station.get_node_or_null("VacuumHumPlayer") != null, "VacuumHumPlayer missing in station_02")
	_expect(station.get_node_or_null("CorrelationHumPlayer") != null, "CorrelationHumPlayer missing in station_02")
	_expect(station.get_node_or_null("PrinterAudioPlayer") != null, "PrinterAudioPlayer missing in station_02")
	_expect(station.get_node_or_null("NeedleAudioPlayer") != null, "NeedleAudioPlayer missing in station_02")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_02")

	# Initial state: Idle, single primary light, no anomaly
	_expect(station.procedure_state == Station02.ProcedureState.IDLE, "initial procedure state must be IDLE")
	_expect(not shadow_renderer.is_secondary_light_active, "secondary shadow must be inactive initially")
	_expect(not shadow_renderer.is_anomaly_active, "shadow anomaly must be inactive initially")

	# Test 1: Start procedure via OpticalCalibration trigger
	calib_prop.trigger_interaction()
	_expect(calib_prop.is_activated, "OpticalCalibration should be active")
	_expect(station.is_optical_calibrated, "station.is_optical_calibrated should be true")
	_expect(station.procedure_state == Station02.ProcedureState.EXCITATION, "procedure should transition to EXCITATION")

	# Advance frames to trigger threshold exceeded (threshold > 1.0, reaches 1.42)
	for f in range(90):
		await physics_frame

	_expect(station.is_threshold_exceeded, "station threshold must be exceeded")
	_expect(station.correlation_ratio >= 1.0, "correlation ratio must exceed 1.0")

	# Advance frames to reach anomaly active state
	for f in range(60):
		await physics_frame

	_expect(station.is_anomaly_active, "station anomaly must be active")
	_expect(shadow_renderer.is_secondary_light_active, "secondary light shadow must now be active")
	_expect(shadow_renderer.is_anomaly_active, "shadow anomaly renderer must be active")

	# Test 2: Verify Discontinuous Shadow behavior during movement under anomaly
	# Move player right: shadow leads by 1 frame
	Input.action_press(&"move_right")
	for f in range(25):
		await physics_frame
	Input.action_release(&"move_right")
	for f in range(5):
		await physics_frame

	_expect(shadow_renderer.desync_frame_count > 0, "discontinuous shadow must have recorded frame desync events")

	# Advance frames to reach verdict print state
	for f in range(90):
		await physics_frame

	_expect(station.is_verdict_printed, "verdict must be printed on strip chart")
	_expect(station.paper_feed_progress >= 0.5, "paper feed progress must be advancing")

	# Test 3: Abort procedure per Lena's safety protocol
	station.abort_procedure()
	_expect(station.is_aborted_by_lena, "procedure must be aborted by Lena")
	_expect(station.is_door_unlocked, "exit door must unlock on safety abort")

	# Allow door opening tween to complete (1.2s at 60fps = 72 frames)
	for f in range(80):
		await physics_frame

	_expect(station._door_open_progress >= 0.99, "exit chamber door must be fully open")

	# Test 4: Player enters airlock zone
	player.global_position = Vector2(615.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "station_02 must complete on entering airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_03() -> void:
	var packed_station := load("res://scenes/levels/station_03.tscn") as PackedScene
	_expect(packed_station != null, "station_03 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station03
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var security_door := station.get_node_or_null("SecurityDoor")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_03: player missing")
	_expect(camera != null, "station_03: camera missing")
	_expect(geometry != null, "station_03: geometry missing")
	_expect(props != null, "station_03: props node missing")
	_expect(security_door != null, "station_03: security_door missing")
	_expect(airlock_zone != null, "station_03: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var cups_prop := props.get_node_or_null("TwinCups") as MemoryResonancePoint
	var phone_prop := props.get_node_or_null("DeskPhone") as MemoryResonancePoint
	var roster_prop := props.get_node_or_null("DutyRoster") as MemoryResonancePoint
	var reader_prop := props.get_node_or_null("DoorCardReader") as MemoryResonancePoint

	_expect(cups_prop != null, "TwinCups prop missing in station_03")
	_expect(phone_prop != null, "DeskPhone prop missing in station_03")
	_expect(roster_prop != null, "DutyRoster prop missing in station_03")
	_expect(reader_prop != null, "DoorCardReader prop missing in station_03")

	if cups_prop == null or phone_prop == null or roster_prop == null or reader_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("AmbientHumPlayer") != null, "AmbientHumPlayer missing in station_03")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_03")

	# Initial state: no clues inspected, door sealed, level not complete
	_expect(not station.cups_inspected, "cups should not be inspected initially")
	_expect(not station.phone_inspected, "phone should not be inspected initially")
	_expect(not station.roster_inspected, "roster should not be inspected initially")
	_expect(not station.card_reader_inspected, "card reader should not be inspected initially")
	_expect(not station.is_door_unlocked, "security door must be sealed initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Twin Cups (Material Discontinuity: 2 cups instead of 1 from Scene 01)
	player.global_position = Vector2(165.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(cups_prop.is_player_in_range, "cups must detect player in range at x=165")

	cups_prop.trigger_interaction()
	_expect(cups_prop.is_activated, "TwinCups prop must be activated")
	_expect(station.cups_inspected, "station.cups_inspected must be true")

	# Test 2: Inspect Desk Telephone (14 missed calls from Marta Kurek)
	player.global_position = Vector2(230.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(phone_prop.is_player_in_range, "phone must detect player in range at x=230")

	phone_prop.trigger_interaction()
	_expect(phone_prop.is_activated, "DeskPhone prop must be activated")
	_expect(station.phone_inspected, "station.phone_inspected must be true")

	# Test 3: Inspect Duty Roster (Missing night staff)
	player.global_position = Vector2(340.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(roster_prop.is_player_in_range, "roster must detect player in range at x=340")

	roster_prop.trigger_interaction()
	_expect(roster_prop.is_activated, "DutyRoster prop must be activated")
	_expect(station.roster_inspected, "station.roster_inspected must be true")

	# Test 4: Inspect Door Card Reader ("urlop przerwany" + alternate photo -> unseals security door)
	player.global_position = Vector2(530.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(reader_prop.is_player_in_range, "card reader must detect player in range at x=530")

	reader_prop.trigger_interaction()
	_expect(reader_prop.is_activated, "DoorCardReader prop must be activated")
	_expect(station.card_reader_inspected, "station.card_reader_inspected must be true")
	_expect(station.is_door_unlocked, "security door must be unlocked after badge authorization")

	# Wait for door opening tween to complete (1.2s at 60fps = 72 frames)
	for f in range(80):
		await physics_frame

	_expect(station._door_open_progress >= 0.99, "security door must be fully open")

	# Test 5: Player enters airlock zone to progress to Space 04 (Bramka)
	player.global_position = Vector2(615.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "station_03 must complete on entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame



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
	_expect(anchor_lab.get_node_or_null("AirlockSealAudioPlayer") != null, "AirlockSealAudioPlayer missing")
	if player != null:
		_expect(player.get_node_or_null("StepAudioPlayer") != null, "StepAudioPlayer missing on player")
		_expect(player.get_node_or_null("LandAudioPlayer") != null, "LandAudioPlayer missing on player")

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

	# ── Test 4: MovableAnchorableProp (crate puzzle integration) ──────────
	var crate := anchorables.get_node_or_null("Chamber2Crate") as MovableAnchorableProp
	var crate_b := anchorables.get_node_or_null("Chamber2CrateB") as MovableAnchorableProp
	_expect(crate != null, "Chamber2Crate movable prop missing")
	_expect(crate_b != null, "Chamber2CrateB movable prop missing")

	if crate != null and crate_b != null:
		# 4a: Crate starts unanchored with no velocity at spawn position (780, 306)
		_expect(not crate.is_anchored, "crate must start unanchored")
		_expect(crate.velocity == Vector2.ZERO, "crate must start at rest")
		_expect(crate.global_position == Vector2(780.0, 306.0), "crate must spawn at (780, 306)")
		_expect(crate_b.global_position == Vector2(1080.0, 186.0), "crate B must spawn on mezzanine at (1080, 186)")

		# 4b: Push signal accepted when not anchored
		crate.receive_push(1.0)
		_expect(crate._push_input == 1.0, "crate should accept push input when unanchored")
		crate._push_input = 0.0  # reset manually

		# 4c: Anchor the crate — velocity freezes
		anchor_lab.set_active_prop_anchor(crate)
		_expect(crate.is_anchored, "crate should be anchored via set_active_prop_anchor")
		_expect(anchor_lab.active_prop_anchor == crate, "active_prop_anchor must reference the crate")
		# Simulate physics frame: velocity must stay zero when anchored
		crate.velocity = Vector2(50.0, 80.0)
		crate._physics_process(0.016)
		_expect(crate.velocity == Vector2.ZERO, "anchored crate velocity must be frozen to zero each frame")

		# 4d: Push is ignored while anchored
		crate.receive_push(1.0)
		_expect(crate._push_input == 0.0, "anchored crate must not accept push input")

		# 4e: Correction wave resists on anchored crate (reality shift rejected)
		var reality_before := crate.current_reality
		crate.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
		_expect(crate.is_anchored, "crate should remain anchored after wave hits")
		_expect(crate.current_reality == reality_before, "anchored crate must not change reality on wave")

		# 4f: Unanchored crate yields to correction wave (no positional change, state accepted)
		anchor_lab.set_active_prop_anchor(null)
		_expect(not crate.is_anchored, "crate should be unanchored after release")
		crate.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
		_expect(crate.current_reality == AnchorableObject.RealityState.STATE_B, "unanchored crate must yield to reality wave")

		# 4g: Single-anchor exclusivity across static and multiple movable props
		anchor_lab.set_active_anchor(bridge1)
		_expect(bridge1.is_anchored, "bridge1 should be anchored")
		anchor_lab.set_active_prop_anchor(crate)
		_expect(not bridge1.is_anchored, "bridge1 must be released when crate is anchored")
		_expect(crate.is_anchored, "crate should now be anchored")
		# Switching to crate B releases crate A
		anchor_lab.set_active_prop_anchor(crate_b)
		_expect(not crate.is_anchored, "crate A must be released when crate B is anchored")
		_expect(crate_b.is_anchored, "crate B should now be anchored")
		# Switching back to static anchor releases crate B
		anchor_lab.set_active_anchor(bridge1)
		_expect(bridge1.is_anchored, "bridge1 should re-anchor")
		_expect(not crate_b.is_anchored, "crate B must be released when bridge1 is anchored")

		# 4h: Player contact push simulation in Chamber 2
		player.reset_to(Vector2(745.0, 296.0))
		crate.global_position = Vector2(780.0, 306.0)
		crate.velocity = Vector2.ZERO
		crate.is_anchored = false
		for frame in range(10):
			await physics_frame
		# Move player into crate
		Input.action_press(&"move_right")
		var initial_crate_x := crate.global_position.x
		for frame in range(30):
			await physics_frame
		Input.action_release(&"move_right")
		_expect(crate.global_position.x > initial_crate_x + 5.0, "player push contact should advance crate horizontally")

		# 4i: Respawn resets all crates to their initial positions
		anchor_lab._respawn()
		_expect(not crate.is_anchored, "crate must be unanchored after respawn")
		_expect(crate.velocity == Vector2.ZERO, "crate velocity must be zero after respawn")
		_expect(crate.global_position == Vector2(780.0, 306.0), "crate A position must reset to (780, 306)")
		_expect(not crate_b.is_anchored, "crate B must be unanchored after respawn")
		_expect(crate_b.velocity == Vector2.ZERO, "crate B velocity must be zero after respawn")
		_expect(crate_b.global_position == Vector2(1080.0, 186.0), "crate B position must reset to (1080, 186)")
		_expect(anchor_lab.active_prop_anchor == null, "active_prop_anchor must be null after respawn")

	# ── Test 5: Full Deterministic 3-Chamber Traversal & Causal Chain Resolution ──
	# 5a: Chamber 1 Traversal (Nauka)
	# Start at spawn (60, 296), in State A. Bridge 1 is at (240, 328).
	player.reset_to(Vector2(60.0, 296.0))
	anchor_lab.current_reality = AnchorableObject.RealityState.STATE_A
	bridge1.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	lift.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	bridge3.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	gate.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	for frame in range(10):
		await physics_frame

	_expect(camera.active_chamber_index == 0, "must start in Chamber 1")

	# Walk right from Chamber 1 into Chamber 2
	Input.action_press(&"move_right")
	for frame in range(450):
		await physics_frame
		if player.global_position.x >= 680.0:
			break
	Input.action_release(&"move_right")

	_expect(player.global_position.x >= 680.0, "player must successfully cross Chamber 1 bridge into Chamber 2")
	_expect(camera.active_chamber_index == 1, "camera must switch to Chamber 2")

	# 5b: Chamber 2 Lift Ascent (Zastosowanie)
	# Player is at (680, 296). Walk toward lift, jumping over Chamber2Crate at (780, 306).
	Input.action_press(&"move_right")
	for frame in range(120):
		if player.global_position.x >= 730.0 and player.is_on_floor():
			Input.action_press(&"jump")
		elif player.global_position.x >= 820.0:
			Input.action_release(&"jump")
		await physics_frame
		if player.global_position.x >= 890.0:
			break
	Input.action_release(&"jump")
	Input.action_release(&"move_right")

	for frame in range(15):
		await physics_frame

	_expect(player.global_position.x >= 850.0 and player.global_position.x <= 950.0, "player must reach lift in Chamber 2")

	# Trigger consensus correction pulse to shift reality to State B
	# Unanchored lift yields and rises from (900, 328) to (900, 208)
	anchor_lab.trigger_correction_pulse()
	_expect(anchor_lab.current_reality == AnchorableObject.RealityState.STATE_B, "reality must be STATE_B after pulse")
	_expect(lift.current_reality == AnchorableObject.RealityState.STATE_B, "lift must yield to STATE_B")

	# Wait for lift movement to complete and settle
	for frame in range(30):
		await physics_frame

	_expect(lift.position == Vector2(900.0, 208.0), "lift must ascend to mezzanine height (900, 208)")
	_expect(player.global_position.y <= 210.0, "player on lift must be carried up to mezzanine level")

	# Walk right from lift onto mezzanine, jumping across lift gap and over Chamber2CrateB at (1080, 186) into Chamber 3
	Input.action_press(&"move_right")
	for frame in range(450):
		# Hop off lift edge (x=930..950) onto mezzanine
		if player.global_position.x >= 930.0 and player.global_position.x < 960.0 and player.is_on_floor():
			Input.action_press(&"jump")
		elif player.global_position.x >= 980.0 and player.global_position.x < 1030.0:
			Input.action_release(&"jump")
		# Hop over crate B on mezzanine (x=1040..1060)
		elif player.global_position.x >= 1040.0 and player.global_position.x < 1070.0 and player.is_on_floor():
			Input.action_press(&"jump")
		elif player.global_position.x >= 1120.0:
			Input.action_release(&"jump")
		await physics_frame
		if player.global_position.x >= 1320.0:
			break
	Input.action_release(&"jump")
	Input.action_release(&"move_right")

	_expect(player.global_position.x >= 1320.0, "player must reach Chamber 3 mezzanine")
	_expect(camera.active_chamber_index == 2, "camera must switch to Chamber 3")

	# 5c: Chamber 3 Causal Dilemma Resolution (Komplikacja)
	# In State B: Chamber3Bridge is dropped (y=330), Chamber3Gate is open (y=70).
	_expect(bridge3.current_reality == AnchorableObject.RealityState.STATE_B, "bridge3 is dropped in STATE_B")
	_expect(gate.current_reality == AnchorableObject.RealityState.STATE_B, "gate is open in STATE_B")

	# Step 1: Switch reality to State A to bring the bridge up
	anchor_lab.trigger_correction_pulse()
	_expect(anchor_lab.current_reality == AnchorableObject.RealityState.STATE_A, "reality switched to STATE_A")
	_expect(bridge3.current_reality == AnchorableObject.RealityState.STATE_A, "bridge3 returned to STATE_A (up)")
	_expect(gate.current_reality == AnchorableObject.RealityState.STATE_A, "gate returned to STATE_A (closed)")

	for frame in range(25):
		await physics_frame

	_expect(bridge3.position == Vector2(1500.0, 208.0), "bridge3 must be at upper level (1500, 208)")

	# Step 2: Player approaches the edge of the chasm (x=1405) and anchors Chamber3Bridge
	Input.action_press(&"move_right")
	for frame in range(120):
		await physics_frame
		if player.global_position.x >= 1405.0:
			break
	Input.action_release(&"move_right")

	for frame in range(5):
		await physics_frame

	_expect(bridge3.is_player_in_range, "player at chasm edge must be in interaction range of bridge3")
	anchor_lab.set_active_anchor(bridge3)
	_expect(bridge3.is_anchored, "bridge3 must be locked with anchor")
	_expect(anchor_lab.active_anchor == bridge3, "active_anchor must be bridge3")

	# Step 3: Trigger correction pulse to State B
	# Gate yields (opens to y=70, solid=false), but Anchored Bridge resists (stays at y=208)!
	anchor_lab.trigger_correction_pulse()
	_expect(anchor_lab.current_reality == AnchorableObject.RealityState.STATE_B, "reality shifted to STATE_B")
	_expect(bridge3.is_anchored, "bridge3 remains anchored")
	_expect(bridge3.current_reality == AnchorableObject.RealityState.STATE_A, "anchored bridge3 resisted and stayed in STATE_A")
	_expect(gate.current_reality == AnchorableObject.RealityState.STATE_B, "gate yielded to STATE_B and opened")

	for frame in range(25):
		await physics_frame

	_expect(bridge3.position == Vector2(1500.0, 208.0), "anchored bridge3 position preserved at y=208")
	_expect(gate.position == Vector2(1730.0, 70.0), "gate moved to open position y=70")

	# Step 4: Player traverses the anchored bridge, passes open gate, and reaches Goal!
	Input.action_press(&"move_right")
	for frame in range(450):
		await physics_frame
		if anchor_lab._goal_reached:
			break
	Input.action_release(&"move_right")

	_expect(anchor_lab._goal_reached, "player must reach Goal in Chamber 3")
	_expect(player.global_position.x >= 1820.0, "player final position must be inside Goal airlock (x >= 1820)")

	# Advance frames to allow airlock lockdown transition tween to complete (1.4s at 60fps = 84 frames)
	for frame in range(95):
		await physics_frame

	_expect(anchor_lab.is_sector_completed, "sector_completed must be true after airlock lockdown sequence")
	_expect(anchor_lab._airlock_lockdown_progress >= 0.99, "airlock lockdown progress must reach 1.0")

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
