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
	await _test_station_04()
	await _test_station_05()
	await _test_station_06()
	await _test_station_07()
	await _test_station_08()
	await _test_station_09()
	await _test_station_10()
	_finish()


func _test_procedural_audio() -> void:
	var anchor_sfx := ProceduralAudio.create_anchor_sound()
	_expect(anchor_sfx != null, "anchor sound synthesis failed")
	_expect(anchor_sfx.data.size() > 0, "anchor sound buffer empty")
	_expect(anchor_sfx.format == AudioStreamWAV.FORMAT_16_BITS, "anchor sound format must be 16-bit")

	var unanchor_sfx := ProceduralAudio.create_unanchor_sound()
	_expect(unanchor_sfx != null, "unanchor sound synthesis failed")
	_expect(unanchor_sfx.data.size() > 0, "unanchor sound buffer empty")

	var wave_sfx := ProceduralAudio.create_correction_pulse_sound()
	_expect(wave_sfx != null, "correction wave sound synthesis failed")
	_expect(wave_sfx.data.size() > 0, "correction wave sound buffer empty")

	var resist_sfx := ProceduralAudio.create_resist_sound()
	_expect(resist_sfx != null, "resist sound synthesis failed")
	_expect(resist_sfx.data.size() > 0, "resist sound buffer empty")

	var goal_sfx := ProceduralAudio.create_goal_sound()
	_expect(goal_sfx != null, "goal sound synthesis failed")
	_expect(goal_sfx.data.size() > 0, "goal sound buffer empty")

	var step_floor := ProceduralAudio.create_footstep_linoleum_sound()
	_expect(step_floor != null, "step floor sound synthesis failed")
	_expect(step_floor.data.size() > 0, "step floor sound buffer empty")

	var step_metal := ProceduralAudio.create_footstep_metal_sound()
	_expect(step_metal != null, "step metal sound synthesis failed")
	_expect(step_metal.data.size() > 0, "step metal sound buffer empty")

	var land_floor := ProceduralAudio.create_land_sound(false)
	_expect(land_floor != null, "land floor sound synthesis failed")
	_expect(land_floor.data.size() > 0, "land floor sound buffer empty")

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

	var printer_strip := ProceduralAudio.create_printer_strip_sound()
	_expect(printer_strip != null, "printer strip sound synthesis failed")
	_expect(printer_strip.data.size() > 0, "printer strip sound buffer empty")

	var needle_spike := ProceduralAudio.create_needle_spike_sound()
	_expect(needle_spike != null, "needle spike sound synthesis failed")
	_expect(needle_spike.data.size() > 0, "needle spike sound buffer empty")

	var phone_pulse := ProceduralAudio.create_phone_ring_pulse_sound()
	_expect(phone_pulse != null, "phone ring pulse sound synthesis failed")
	_expect(phone_pulse.data.size() > 0, "phone ring pulse sound buffer empty")

	var card_beep := ProceduralAudio.create_card_reader_beep_sound()
	_expect(card_beep != null, "card reader beep sound synthesis failed")
	_expect(card_beep.data.size() > 0, "card reader beep sound buffer empty")

	var fluor_hum := ProceduralAudio.create_fluorescent_hum_sound()
	_expect(fluor_hum != null, "fluorescent hum sound synthesis failed")
	_expect(fluor_hum.data.size() > 0, "fluorescent hum sound buffer empty")

	var camera_click := ProceduralAudio.create_camera_click_sound()
	_expect(camera_click != null, "camera click sound synthesis failed")
	_expect(camera_click.data.size() > 0, "camera click sound buffer empty")

	var turnstile_unlatch := ProceduralAudio.create_turnstile_unlatch_sound()
	_expect(turnstile_unlatch != null, "turnstile unlatch sound synthesis failed")
	_expect(turnstile_unlatch.data.size() > 0, "turnstile unlatch sound buffer empty")

	var blip_lena := ProceduralAudio.create_dialogue_blip_sound(true)
	_expect(blip_lena != null, "dialogue blip lena synthesis failed")
	_expect(blip_lena.data.size() > 0, "dialogue blip lena buffer empty")

	var blip_guard := ProceduralAudio.create_dialogue_blip_sound(false)
	_expect(blip_guard != null, "dialogue blip guard synthesis failed")
	_expect(blip_guard.data.size() > 0, "dialogue blip guard buffer empty")

	var crosswalk_beep := ProceduralAudio.create_crosswalk_signal_sound(false)
	_expect(crosswalk_beep != null, "crosswalk signal beep synthesis failed")
	_expect(crosswalk_beep.data.size() > 0, "crosswalk signal beep buffer empty")

	var crosswalk_whisper := ProceduralAudio.create_crosswalk_signal_sound(true)
	_expect(crosswalk_whisper != null, "crosswalk signal whisper synthesis failed")
	_expect(crosswalk_whisper.data.size() > 0, "crosswalk signal whisper buffer empty")

	var rain_asphalt := ProceduralAudio.create_rain_asphalt_sound()
	_expect(rain_asphalt != null, "rain asphalt sound synthesis failed")
	_expect(rain_asphalt.data.size() > 0, "rain asphalt sound buffer empty")

	var tram_traction := ProceduralAudio.create_tram_traction_sound()
	_expect(tram_traction != null, "tram traction sound synthesis failed")
	_expect(tram_traction.data.size() > 0, "tram traction sound buffer empty")

	var bus_engine := ProceduralAudio.create_bus_engine_sound(false)
	_expect(bus_engine != null, "bus engine sound synthesis failed")
	_expect(bus_engine.data.size() > 0, "bus engine sound buffer empty")

	var bus_rain := ProceduralAudio.create_bus_rain_window_sound()
	_expect(bus_rain != null, "bus rain sound synthesis failed")
	_expect(bus_rain.data.size() > 0, "bus rain sound buffer empty")

	var bus_announcement := ProceduralAudio.create_bus_announcement_sound()
	_expect(bus_announcement != null, "bus announcement sound synthesis failed")
	_expect(bus_announcement.data.size() > 0, "bus announcement sound buffer empty")

	var bus_door := ProceduralAudio.create_bus_door_pneumatic_sound()
	_expect(bus_door != null, "bus door pneumatic sound synthesis failed")
	_expect(bus_door.data.size() > 0, "bus door pneumatic sound buffer empty")

	var ring_chime := ProceduralAudio.create_ring_chime_sound()
	_expect(ring_chime != null, "gold ring chime sound synthesis failed")
	_expect(ring_chime.data.size() > 0, "gold ring chime sound buffer empty")

	var stair_footstep := ProceduralAudio.create_stair_footstep_sound()
	_expect(stair_footstep != null, "stair footstep sound synthesis failed")
	_expect(stair_footstep.data.size() > 0, "stair footstep sound buffer empty")

	var apt_door := ProceduralAudio.create_apartment_door_sound()
	_expect(apt_door != null, "apartment door sound synthesis failed")
	_expect(apt_door.data.size() > 0, "apartment door sound buffer empty")

	var blip_marta := ProceduralAudio.create_dialogue_marta_blip_sound()
	_expect(blip_marta != null, "dialogue blip marta synthesis failed")
	_expect(blip_marta.data.size() > 0, "dialogue blip marta buffer empty")

	var stair_timer := ProceduralAudio.create_stair_timer_switch_sound()
	_expect(stair_timer != null, "stair timer switch sound synthesis failed")
	_expect(stair_timer.data.size() > 0, "stair timer switch sound buffer empty")

	var parquet_step := ProceduralAudio.create_parquet_footstep_sound()
	_expect(parquet_step != null, "parquet footstep sound synthesis failed")
	_expect(parquet_step.data.size() > 0, "parquet footstep sound buffer empty")

	var drawer_lock := ProceduralAudio.create_drawer_lock_unlatch_sound()
	_expect(drawer_lock != null, "drawer lock unlatch sound synthesis failed")
	_expect(drawer_lock.data.size() > 0, "drawer lock unlatch sound buffer empty")

	var paper_rustle := ProceduralAudio.create_paper_rustle_sound()
	_expect(paper_rustle != null, "paper rustle sound synthesis failed")
	_expect(paper_rustle.data.size() > 0, "paper rustle sound buffer empty")

	var kettle_boil := ProceduralAudio.create_kettle_boil_sound()
	_expect(kettle_boil != null, "kettle boil sound synthesis failed")
	_expect(kettle_boil.data.size() > 0, "kettle boil sound buffer empty")

	var kettle_whistle := ProceduralAudio.create_kettle_whistle_sound()
	_expect(kettle_whistle != null, "kettle whistle sound synthesis failed")
	_expect(kettle_whistle.data.size() > 0, "kettle whistle sound buffer empty")

	var tile_step := ProceduralAudio.create_tile_footstep_sound()
	_expect(tile_step != null, "tile footstep sound synthesis failed")
	_expect(tile_step.data.size() > 0, "tile footstep sound buffer empty")

	var pipe_hiss := ProceduralAudio.create_water_pipe_hiss_sound()
	_expect(pipe_hiss != null, "water pipe hiss sound synthesis failed")
	_expect(pipe_hiss.data.size() > 0, "water pipe hiss sound buffer empty")

	var glass_scratch := ProceduralAudio.create_glass_scratch_sound()
	_expect(glass_scratch != null, "glass scratch sound synthesis failed")
	_expect(glass_scratch.data.size() > 0, "glass scratch sound buffer empty")

	var mirror_shimmer := ProceduralAudio.create_mirror_shimmer_sound()
	_expect(mirror_shimmer != null, "mirror shimmer sound synthesis failed")
	_expect(mirror_shimmer.data.size() > 0, "mirror shimmer sound buffer empty")

	var bakelite_bell := ProceduralAudio.create_bakelite_bell_sound()
	_expect(bakelite_bell != null, "bakelite bell sound synthesis failed")
	_expect(bakelite_bell.data.size() > 0, "bakelite bell sound buffer empty")

	var handset_pickup := ProceduralAudio.create_handset_pickup_sound()
	_expect(handset_pickup != null, "handset pickup sound synthesis failed")
	_expect(handset_pickup.data.size() > 0, "handset pickup sound buffer empty")

	var tape_hum := ProceduralAudio.create_tape_motor_hum_sound()
	_expect(tape_hum != null, "tape motor hum sound synthesis failed")
	_expect(tape_hum.data.size() > 0, "tape motor hum sound buffer empty")

	var blip_jakub := ProceduralAudio.create_dialogue_jakub_blip_sound()
	_expect(blip_jakub != null, "dialogue blip jakub synthesis failed")
	_expect(blip_jakub.data.size() > 0, "dialogue blip jakub buffer empty")


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


func _test_station_04() -> void:
	var packed_station := load("res://scenes/levels/station_04.tscn") as PackedScene
	_expect(packed_station != null, "station_04 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station04
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var turnstile := station.get_node_or_null("TurnstileBarrier")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_04: player missing")
	_expect(camera != null, "station_04: camera missing")
	_expect(geometry != null, "station_04: geometry missing")
	_expect(props != null, "station_04: props node missing")
	_expect(turnstile != null, "station_04: turnstile barrier missing")
	_expect(airlock_zone != null, "station_04: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var notice_prop := props.get_node_or_null("UCPNotice") as MemoryResonancePoint
	var monitor_prop := props.get_node_or_null("SecurityMonitor") as MemoryResonancePoint
	var guard_prop := props.get_node_or_null("GuardStation") as MemoryResonancePoint

	_expect(notice_prop != null, "UCPNotice prop missing in station_04")
	_expect(monitor_prop != null, "SecurityMonitor prop missing in station_04")
	_expect(guard_prop != null, "GuardStation prop missing in station_04")

	if notice_prop == null or monitor_prop == null or guard_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("AmbientHumPlayer") != null, "AmbientHumPlayer missing in station_04")
	_expect(station.get_node_or_null("RelayClickPlayer") != null, "RelayClickPlayer missing in station_04")
	_expect(station.get_node_or_null("TurnstileAudioPlayer") != null, "TurnstileAudioPlayer missing in station_04")
	_expect(station.get_node_or_null("DialogueBlipPlayer") != null, "DialogueBlipPlayer missing in station_04")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_04")

	# Initial state: no dialogue started, lamp lit, turnstile locked, level not complete
	_expect(not station.is_dialogue_active, "dialogue should not be active initially")
	_expect(not station.is_dialogue_completed, "dialogue should not be completed initially")
	_expect(station.dialogue_index == -1, "dialogue index should be -1 initially")
	_expect(station.camera_lamp_lit, "overhead camera lamp must be lit initially")
	_expect(not station.guard_blocks_camera, "guard should not block camera initially")
	_expect(not station.is_turnstile_unlocked, "turnstile must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect UCP Institutional Notice at x=140
	player.global_position = Vector2(140.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(notice_prop.is_player_in_range, "UCPNotice must detect player in range at x=140")

	notice_prop.trigger_interaction()
	_expect(notice_prop.is_activated, "UCPNotice prop must be activated")
	_expect(station.ucp_notice_inspected, "station.ucp_notice_inspected must be true")

	# Test 2: Inspect Security CRT Monitor at x=205 (in front of counter)
	player.global_position = Vector2(205.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(monitor_prop.is_player_in_range, "SecurityMonitor must detect player in range at x=205")

	monitor_prop.trigger_interaction()
	_expect(monitor_prop.is_activated, "SecurityMonitor prop must be activated")
	_expect(station.monitor_inspected, "station.monitor_inspected must be true")

	# Test 3: Guard Interaction & Dialogue D-01 Flow (Bramka IKP — "którego tunelu?")
	# Reaching the counter (x=205) activates dialogue
	_expect(station.is_dialogue_active, "dialogue must be triggered by approaching guard counter")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.camera_lamp_lit, "camera lamp remains lit at line 0")
	_expect(not station.guard_blocks_camera, "guard is in calm posture at line 0")

	# Advance lines 1 through 4
	for expected_idx in range(1, 5):
		var cur := station.advance_dialogue()
		_expect(cur == expected_idx, "dialogue index must advance to %d" % expected_idx)
		_expect(station.camera_lamp_lit, "camera lamp must stay lit during lines 0..4")
		_expect(not station.guard_blocks_camera, "guard must not block camera during lines 0..4")

	# Line 5: LENA: "Jakub nie żyje." -> Camera lamp dies abruptly, guard shields lens!
	var line5_idx := station.advance_dialogue()
	_expect(line5_idx == 5, "dialogue index must reach line 5 (Lena: 'Jakub nie żyje')")
	_expect(not station.camera_lamp_lit, "camera lamp must cut off when Lena states Jakub is dead")
	_expect(station.camera_lamp_alpha == 0.0, "camera lamp alpha must snap to 0.0")
	_expect(station.guard_blocks_camera, "guard must lean forward and shield the camera lens")

	# Advance lines 6, 7, 8
	for expected_idx in range(6, 9):
		var cur := station.advance_dialogue()
		_expect(cur == expected_idx, "dialogue index must advance to %d" % expected_idx)
		_expect(not station.camera_lamp_lit, "camera lamp must remain dark")
		_expect(station.guard_blocks_camera, "guard must remain shielding camera lens")

	# Advance past line 8 -> dialogue completes and unlocks turnstile
	var final_idx := station.advance_dialogue()
	_expect(final_idx == -1, "advancing past end must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(not station.is_dialogue_active, "dialogue must no longer be active")
	_expect(station.is_turnstile_unlocked, "turnstile must unlock upon dialogue completion")

	# Wait for turnstile unlatch rotation tween (0.8s at 60fps = 48 frames)
	for f in range(60):
		await physics_frame

	_expect(station.turnstile_rotation_progress >= 0.99, "turnstile rotation must reach 1.0")

	# Test 4: Player traverses turnstile into airlock zone towards Space 05 (Rówień nocą)
	player.global_position = Vector2(615.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "station_04 must complete on entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_05() -> void:
	var packed_station := load("res://scenes/levels/station_05.tscn") as PackedScene
	_expect(packed_station != null, "station_05 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station05
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")
	var rain_particles := station.get_node_or_null("RainParticles")

	_expect(player != null, "station_05: player missing")
	_expect(camera != null, "station_05: camera missing")
	_expect(geometry != null, "station_05: geometry missing")
	_expect(props != null, "station_05: props node missing")
	_expect(airlock_zone != null, "station_05: airlock_zone missing")
	_expect(rain_particles != null, "station_05: rain particles missing")

	if props == null or player == null or camera == null:
		station.queue_free()
		await process_frame
		return

	var billboard_prop := props.get_node_or_null("Billboard") as MemoryResonancePoint
	var missing_floor_prop := props.get_node_or_null("MissingFloorMarker") as MemoryResonancePoint
	var crosswalk_prop := props.get_node_or_null("CrosswalkBeacon") as MemoryResonancePoint
	var timetable_prop := props.get_node_or_null("TransitTimetable") as MemoryResonancePoint

	_expect(billboard_prop != null, "Billboard prop missing in station_05")
	_expect(missing_floor_prop != null, "MissingFloorMarker prop missing in station_05")
	_expect(crosswalk_prop != null, "CrosswalkBeacon prop missing in station_05")
	_expect(timetable_prop != null, "TransitTimetable prop missing in station_05")

	if billboard_prop == null or missing_floor_prop == null or crosswalk_prop == null or timetable_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("RainAudioPlayer") != null, "RainAudioPlayer missing in station_05")
	_expect(station.get_node_or_null("TractionAudioPlayer") != null, "TractionAudioPlayer missing in station_05")
	_expect(station.get_node_or_null("CrosswalkAudioPlayer") != null, "CrosswalkAudioPlayer missing in station_05")
	_expect(station.get_node_or_null("TransitionAudioPlayer") != null, "TransitionAudioPlayer missing in station_05")

	# Camera multi-chamber verification (2 chambers across 1280px street)
	_expect(camera.chamber_bounds.size() == 2, "station_05 camera must configure 2 chambers")
	_expect(camera.active_chamber_index == 0, "initial active chamber must be Chamber 0 (Institute & Street)")

	# Initial state: no clues inspected, restless grid unshifted, crosswalk lamp red, level not complete
	_expect(not station.billboard_inspected, "billboard should not be inspected initially")
	_expect(not station.missing_floor_inspected, "missing floor should not be inspected initially")
	_expect(not station.crosswalk_signal_triggered, "crosswalk signal should not be triggered initially")
	_expect(not station.schedule_inspected, "schedule should not be inspected initially")
	_expect(not station.restless_grid_shifted, "restless grid should be in initial state (open arch)")
	_expect(not station.crosswalk_lamp_green, "crosswalk signal lamp must be red initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Anachronistic Billboard at x=180
	player.global_position = Vector2(180.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(billboard_prop.is_player_in_range, "billboard must detect player in range at x=180")

	billboard_prop.trigger_interaction()
	_expect(billboard_prop.is_activated, "billboard prop must be activated")
	_expect(station.billboard_inspected, "station.billboard_inspected must be true")

	# Test 2: Inspect Missing Floor Building Plaque at x=340
	player.global_position = Vector2(340.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(missing_floor_prop.is_player_in_range, "missing floor marker must detect player in range at x=340")

	missing_floor_prop.trigger_interaction()
	_expect(missing_floor_prop.is_activated, "missing floor prop must be activated")
	_expect(station.missing_floor_inspected, "station.missing_floor_inspected must be true")

	# Test 3: Player moves across street threshold into Chamber 1 (x=700)
	# Triggers camera chamber switch and restless grid restructuring (#geometry-restless-grid)
	player.global_position = Vector2(700.0, 296.0)
	for frame in range(10):
		await physics_frame

	_expect(camera.active_chamber_index == 1, "camera must switch to Chamber 1 (Crosswalk & Transit)")
	_expect(station.restless_grid_shifted, "restless grid must transform into solid alternative configuration")

	# Test 4: Activate Crosswalk Beacon at x=730 (Emits acoustic signal + whispers Lena's name once)
	player.global_position = Vector2(730.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(crosswalk_prop.is_player_in_range, "crosswalk beacon must detect player in range at x=730")

	crosswalk_prop.trigger_interaction()
	_expect(crosswalk_prop.is_activated, "crosswalk beacon prop must be activated")
	_expect(station.crosswalk_signal_triggered, "station.crosswalk_signal_triggered must be true")
	_expect(station.crosswalk_lamp_green, "crosswalk signal lamp must turn green/cyan upon activation")

	# Test 5: Inspect Transit Timetable at Shelter at x=1050 (Linia Zastępcza 4)
	player.global_position = Vector2(1050.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(timetable_prop.is_player_in_range, "timetable must detect player in range at x=1050")

	timetable_prop.trigger_interaction()
	_expect(timetable_prop.is_activated, "transit timetable prop must be activated")
	_expect(station.schedule_inspected, "station.schedule_inspected must be true")

	# Test 6: Player walks into airlock transition zone at x=1240 towards Space 06 (Linia zastępcza)
	player.global_position = Vector2(1240.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "station_05 must complete on entering transit airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_06() -> void:
	var packed_station := load("res://scenes/levels/station_06.tscn") as PackedScene
	_expect(packed_station != null, "station_06 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station06
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_06: player missing")
	_expect(camera != null, "station_06: camera missing")
	_expect(geometry != null, "station_06: geometry missing")
	_expect(props != null, "station_06: props node missing")
	_expect(airlock_zone != null, "station_06: airlock_zone missing")

	if props == null or player == null or camera == null:
		station.queue_free()
		await process_frame
		return

	var route_map_prop := props.get_node_or_null("BusRouteMap") as MemoryResonancePoint
	var speaker_prop := props.get_node_or_null("BusSpeaker") as MemoryResonancePoint
	var passenger_prop := props.get_node_or_null("ElderlyPassenger") as MemoryResonancePoint
	var ring_prop := props.get_node_or_null("GoldRing") as MemoryResonancePoint

	_expect(route_map_prop != null, "BusRouteMap prop missing in station_06")
	_expect(speaker_prop != null, "BusSpeaker prop missing in station_06")
	_expect(passenger_prop != null, "ElderlyPassenger prop missing in station_06")
	_expect(ring_prop != null, "GoldRing prop missing in station_06")

	if route_map_prop == null or speaker_prop == null or passenger_prop == null or ring_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("EngineAudioPlayer") != null, "EngineAudioPlayer missing in station_06")
	_expect(station.get_node_or_null("RainAudioPlayer") != null, "RainAudioPlayer missing in station_06")
	_expect(station.get_node_or_null("AnnouncementAudioPlayer") != null, "AnnouncementAudioPlayer missing in station_06")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_06")
	_expect(station.get_node_or_null("RingAudioPlayer") != null, "RingAudioPlayer missing in station_06")
	_expect(station.get_node_or_null("BlipAudioPlayer") != null, "BlipAudioPlayer missing in station_06")
	_expect(station.get_node_or_null("TransitionAudioPlayer") != null, "TransitionAudioPlayer missing in station_06")

	# Initial state: bus moving, dialogue inactive, ring not inspected, doors closed
	_expect(station.is_bus_moving, "bus must be in motion initially")
	_expect(not station.is_bus_stopped, "bus must not be stopped initially")
	_expect(not station.route_map_inspected, "route map should not be inspected initially")
	_expect(not station.passenger_dialogue_active, "passenger dialogue should not be active initially")
	_expect(not station.is_passenger_dialogue_completed, "passenger dialogue should not be completed initially")
	_expect(not station.is_ring_inspected, "gold ring should not be inspected initially")
	_expect(not station.is_finger_checked, "finger absence check should not be done initially")
	_expect(not station.are_doors_open, "doors should be closed initially")
	_expect(not station.is_level_completed, "level should not be completed initially")

	# Test 1: Inspect Bus Route Map at x=180
	player.global_position = Vector2(180.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(route_map_prop.is_player_in_range, "route map must detect player in range at x=180")

	route_map_prop.trigger_interaction()
	_expect(route_map_prop.is_activated, "route map prop must be activated")
	_expect(station.route_map_inspected, "station.route_map_inspected must be true")

	# Test 2: Trigger Bus Speaker UCP announcement at x=290
	player.global_position = Vector2(290.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(speaker_prop.is_player_in_range, "bus speaker must detect player in range at x=290")

	speaker_prop.trigger_interaction()
	_expect(speaker_prop.is_activated, "bus speaker prop must be activated")
	_expect(station.speaker_announcement_triggered, "station.speaker_announcement_triggered must be true")

	# Test 3: Dialogue with Elderly Passenger at x=390
	player.global_position = Vector2(390.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(passenger_prop.is_player_in_range, "elderly passenger must detect player in range at x=390")

	passenger_prop.trigger_interaction()
	_expect(station.passenger_dialogue_active, "passenger dialogue must be active after interaction")
	_expect(station.passenger_dialogue_index == 0, "dialogue must be at line 0 (Pasażer: Pani Wolska?...)")

	# Step through dialogue lines
	var l1 := station.advance_passenger_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (Lena: Nigdy jej nie nosiłam...)")
	_expect(station.passenger_dialogue_lines[l1]["is_lena"] == true, "line 1 is Lena")

	var l2 := station.advance_passenger_dialogue()
	_expect(l2 == 2, "dialogue must advance to line 2 (Pasażer: Nosiła pani...)")
	_expect(station.passenger_dialogue_lines[l2]["is_lena"] == false, "line 2 is Passenger")

	var l3 := station.advance_passenger_dialogue()
	_expect(l3 == 3, "dialogue must advance to line 3 (Świadectwo ciała: Lena dociska paznokieć do szwu palca...)")
	_expect(station.is_finger_checked, "finger absence check must be confirmed on line 3")

	var l4 := station.advance_passenger_dialogue()
	_expect(l4 == -1, "advancing past end must return -1")
	_expect(station.is_passenger_dialogue_completed, "passenger dialogue must be completed")
	_expect(not station.passenger_dialogue_active, "passenger dialogue must no longer be active")

	# Test 4: Inspect Gold Ring on seat at x=450
	player.global_position = Vector2(450.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(ring_prop.is_player_in_range, "gold ring must detect player in range at x=450")

	ring_prop.trigger_interaction()
	_expect(ring_prop.is_activated, "gold ring prop must be activated")
	_expect(station.is_ring_inspected, "station.is_ring_inspected must be true")

	# Test 5: Bus arrival sequence at Osiedle Tarasowe
	# Advance frames to allow arrival deceleration and pneumatic door opening (2.2s at 60fps ~ 130 frames)
	for frame in range(150):
		await physics_frame
		if station.are_doors_open and station.door_open_progress >= 0.99:
			break

	_expect(station.is_bus_stopped, "bus must come to a complete stop at Osiedle Tarasowe")
	_expect(station.are_doors_open, "bus pneumatic doors must open upon arrival")
	_expect(station.door_open_progress >= 0.99, "door opening animation progress must reach 1.0")

	# Test 6: Player steps through open doors into airlock zone at x=585 towards Space 07 (Wróciłaś / Marta Kurek)
	player.global_position = Vector2(585.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "station_06 must complete on stepping through exit doors")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_07() -> void:
	var packed_station := load("res://scenes/levels/station_07.tscn") as PackedScene
	_expect(packed_station != null, "station_07 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station07
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_07: player missing")
	_expect(camera != null, "station_07: camera missing")
	_expect(geometry != null, "station_07: geometry missing")
	_expect(props != null, "station_07: props node missing")
	_expect(airlock_zone != null, "station_07: airlock_zone missing")

	if props == null or player == null or camera == null:
		station.queue_free()
		await process_frame
		return

	var directory_prop := props.get_node_or_null("TenantDirectory") as MemoryResonancePoint
	var mailboxes_prop := props.get_node_or_null("Mailboxes") as MemoryResonancePoint
	var timer_prop := props.get_node_or_null("StairTimerSwitch") as MemoryResonancePoint
	var marta_prop := props.get_node_or_null("MartaInteraction") as MemoryResonancePoint
	var blind_stairs_prop := props.get_node_or_null("BlindStairs") as MemoryResonancePoint

	_expect(directory_prop != null, "TenantDirectory prop missing in station_07")
	_expect(mailboxes_prop != null, "Mailboxes prop missing in station_07")
	_expect(timer_prop != null, "StairTimerSwitch prop missing in station_07")
	_expect(marta_prop != null, "MartaInteraction prop missing in station_07")
	_expect(blind_stairs_prop != null, "BlindStairs prop missing in station_07")

	if directory_prop == null or mailboxes_prop == null or timer_prop == null or marta_prop == null or blind_stairs_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("TimerAudioPlayer") != null, "TimerAudioPlayer missing in station_07")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_07")
	_expect(station.get_node_or_null("BlipAudioPlayer") != null, "BlipAudioPlayer missing in station_07")
	_expect(station.get_node_or_null("TransitionAudioPlayer") != null, "TransitionAudioPlayer missing in station_07")

	# Initial state verification
	_expect(not station.tenant_directory_inspected, "tenant directory should not be inspected initially")
	_expect(not station.mailboxes_inspected, "mailboxes should not be inspected initially")
	_expect(not station.blind_stairs_inspected, "blind stairs should not be inspected initially")
	_expect(not station.marta_dialogue_active, "marta dialogue should not be active initially")
	_expect(not station.is_marta_dialogue_completed, "marta dialogue should not be completed initially")
	_expect(not station.is_finger_gesture_done, "finger gesture should not be done initially")
	_expect(not station.is_door_open, "apartment door should be closed initially")
	_expect(not station.is_level_completed, "level should not be completed initially")

	# Test 1: Inspect Tenant Directory at x=90
	player.global_position = Vector2(90.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(directory_prop.is_player_in_range, "tenant directory must detect player in range at x=90")

	directory_prop.trigger_interaction()
	_expect(directory_prop.is_activated, "tenant directory prop must be activated")
	_expect(station.tenant_directory_inspected, "station.tenant_directory_inspected must be true")

	# Test 2: Inspect Mailboxes at x=170
	player.global_position = Vector2(170.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(mailboxes_prop.is_player_in_range, "mailboxes must detect player in range at x=170")

	mailboxes_prop.trigger_interaction()
	_expect(mailboxes_prop.is_activated, "mailboxes prop must be activated")
	_expect(station.mailboxes_inspected, "station.mailboxes_inspected must be true")

	# Test 3: Stair Timer Switch click at x=250
	player.global_position = Vector2(250.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(timer_prop.is_player_in_range, "stair timer must detect player in range at x=250")

	timer_prop.trigger_interaction()
	_expect(timer_prop.is_activated, "stair timer switch prop must be activated")
	_expect(station.stair_timer_inspected, "station.stair_timer_inspected must be true")
	_expect(station.stair_timer_remaining >= 59.0, "stair timer remaining should be reset to 60s")

	# Test 4: Inspect Blind Stairs at x=580
	player.global_position = Vector2(580.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(blind_stairs_prop.is_player_in_range, "blind stairs must detect player in range at x=580")

	blind_stairs_prop.trigger_interaction()
	_expect(blind_stairs_prop.is_activated, "blind stairs prop must be activated")
	_expect(station.blind_stairs_inspected, "station.blind_stairs_inspected must be true")

	# Test 5: Dialogue D-02 with Marta Kurek in doorway at x=460
	player.global_position = Vector2(460.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(marta_prop.is_player_in_range, "marta prop must detect player in range at x=460")

	marta_prop.trigger_interaction()
	_expect(station.marta_dialogue_active, "marta dialogue must be active after interaction")
	_expect(station.marta_dialogue_index == 0, "dialogue must start at line 0 (MARTA: Wróciłaś.)")

	# Step through dialogue D-02 lines
	var l1 := station.advance_marta_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (LENA: Pomyliła mnie pani z kimś.)")
	_expect(station.marta_dialogue_lines[l1]["is_lena"] == true, "line 1 is Lena")

	var l2 := station.advance_marta_dialogue()
	_expect(l2 == 2, "dialogue must advance to line 2 (MARTA: Lena Wolska. Mieszkała tu...)")
	_expect(station.marta_dialogue_lines[l2]["is_marta"] == true, "line 2 is Marta")

	var l3 := station.advance_marta_dialogue()
	_expect(l3 == 3, "dialogue must advance to line 3 (LENA: Nigdy tu nie byłam.)")
	_expect(station.marta_dialogue_lines[l3]["is_lena"] == true, "line 3 is Lena")

	var l4 := station.advance_marta_dialogue()
	_expect(l4 == 4, "dialogue must advance to line 4 (ŚWIADECTWO CIAŁA: Lena dociska paznokieć do szwu palca...)")
	_expect(station.is_finger_gesture_done, "finger gesture check must be confirmed on line 4")

	var l5 := station.advance_marta_dialogue()
	_expect(l5 == 5, "dialogue must advance to line 5 (MARTA: Nie... Twarz się zgadza. Reszta dopiero weszła po schodach.)")

	var l6 := station.advance_marta_dialogue()
	_expect(l6 == 6, "dialogue must advance to line 6 (MARTA: Możesz zostać na klatce. Tylko klatka dziś kończy się na trzecim piętrze...)")

	var l7 := station.advance_marta_dialogue()
	_expect(l7 == -1, "advancing past end must return -1")
	_expect(station.is_marta_dialogue_completed, "marta dialogue must be completed")
	_expect(not station.marta_dialogue_active, "marta dialogue must no longer be active")
	_expect(station.is_door_open, "apartment door must open after dialogue completes")

	# Wait for door opening animation to complete
	for frame in range(40):
		await physics_frame
		if station.door_open_progress >= 0.99:
			break

	_expect(station.door_open_progress >= 0.99, "door opening progress must reach 1.0")

	# Test 6: Player steps into the open doorway / airlock zone at x=530 towards Space 08 (Mieszkanie po kimś)
	player.global_position = Vector2(530.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "station_07 must complete upon entering apartment doorway airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_08() -> void:
	var packed_station := load("res://scenes/levels/station_08.tscn") as PackedScene
	_expect(packed_station != null, "station_08 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station08
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_08: player missing")
	_expect(camera != null, "station_08: camera missing")
	_expect(geometry != null, "station_08: geometry missing")
	_expect(props != null, "station_08: props node missing")
	_expect(airlock_zone != null, "station_08: airlock_zone missing")

	if props == null or player == null or camera == null:
		station.queue_free()
		await process_frame
		return

	var coat_rack := props.get_node_or_null("CoatRack") as MemoryResonancePoint
	var photo_prop := props.get_node_or_null("ReflectedPhoto") as MemoryResonancePoint
	var kettle_prop := props.get_node_or_null("TeaKettle") as MemoryResonancePoint
	var beaker_prop := props.get_node_or_null("BeakerPlanter") as MemoryResonancePoint
	var memento_prop := props.get_node_or_null("JakubMemento") as MemoryResonancePoint
	var marta_prop := props.get_node_or_null("MartaInteraction") as MemoryResonancePoint
	var desk_prop := props.get_node_or_null("CipherDesk") as MemoryResonancePoint

	_expect(coat_rack != null, "CoatRack prop missing in station_08")
	_expect(photo_prop != null, "ReflectedPhoto prop missing in station_08")
	_expect(kettle_prop != null, "TeaKettle prop missing in station_08")
	_expect(beaker_prop != null, "BeakerPlanter prop missing in station_08")
	_expect(memento_prop != null, "JakubMemento prop missing in station_08")
	_expect(marta_prop != null, "MartaInteraction prop missing in station_08")
	_expect(desk_prop != null, "CipherDesk prop missing in station_08")

	if coat_rack == null or photo_prop == null or kettle_prop == null or beaker_prop == null or memento_prop == null or marta_prop == null or desk_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("KettleAudioPlayer") != null, "KettleAudioPlayer missing in station_08")
	_expect(station.get_node_or_null("DrawerAudioPlayer") != null, "DrawerAudioPlayer missing in station_08")
	_expect(station.get_node_or_null("BlipAudioPlayer") != null, "BlipAudioPlayer missing in station_08")
	_expect(station.get_node_or_null("TransitionAudioPlayer") != null, "TransitionAudioPlayer missing in station_08")

	# Initial state verification
	_expect(not station.coat_rack_inspected, "coat rack should not be inspected initially")
	_expect(not station.reflected_photo_inspected, "reflected photo should not be inspected initially")
	_expect(not station.tea_kettle_inspected, "tea kettle should not be inspected initially")
	_expect(not station.beaker_planter_inspected, "beaker planter should not be inspected initially")
	_expect(not station.jakub_memento_inspected, "jakub memento should not be inspected initially")
	_expect(not station.cipher_drawer_unlocked_state, "cipher drawer must be locked initially")
	_expect(not station.marta_dialogue_active, "marta dialogue should not be active initially")
	_expect(not station.is_marta_dialogue_completed, "marta dialogue should not be completed initially")
	_expect(not station.is_level_completed, "level should not be completed initially")

	# Test 1: Inspect Hallway Coat Rack at x=105
	player.global_position = Vector2(105.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(coat_rack.is_player_in_range, "coat rack must detect player in range at x=105")

	coat_rack.trigger_interaction()
	_expect(coat_rack.is_activated, "coat rack prop must be activated")
	_expect(station.coat_rack_inspected, "station.coat_rack_inspected must be true")

	# Test 2: Inspect Reflected Photograph at x=150
	player.global_position = Vector2(150.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(photo_prop.is_player_in_range, "reflected photo must detect player in range at x=150")

	photo_prop.trigger_interaction()
	_expect(photo_prop.is_activated, "reflected photo prop must be activated")
	_expect(station.reflected_photo_inspected, "station.reflected_photo_inspected must be true")

	# Test 3: Inspect Tea Kettle on kitchen counter at x=215
	player.global_position = Vector2(215.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(kettle_prop.is_player_in_range, "tea kettle must detect player in range at x=215")

	kettle_prop.trigger_interaction()
	_expect(kettle_prop.is_activated, "tea kettle prop must be activated")
	_expect(station.tea_kettle_inspected, "station.tea_kettle_inspected must be true")

	# Test 4: Inspect Beaker Succulent Planter at x=295
	player.global_position = Vector2(295.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(beaker_prop.is_player_in_range, "beaker planter must detect player in range at x=295")

	beaker_prop.trigger_interaction()
	_expect(beaker_prop.is_activated, "beaker planter prop must be activated")
	_expect(station.beaker_planter_inspected, "station.beaker_planter_inspected must be true")

	# Test 5: Inspect Jakub's Memento Tool at x=335
	player.global_position = Vector2(335.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(memento_prop.is_player_in_range, "jakub memento must detect player in range at x=335")

	memento_prop.trigger_interaction()
	_expect(memento_prop.is_activated, "jakub memento prop must be activated")
	_expect(station.jakub_memento_inspected, "station.jakub_memento_inspected must be true")

	# Test 6: Dialogue sequence with Marta Kurek at x=375
	player.global_position = Vector2(375.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(marta_prop.is_player_in_range, "marta prop must detect player in range at x=375")

	marta_prop.trigger_interaction()
	_expect(station.marta_dialogue_active, "marta dialogue must be active after interaction")
	_expect(station.marta_dialogue_index == 0, "dialogue must start at line 0 (LENA: To nie moje rzeczy...)")

	# Step through dialogue lines (0..7)
	var l1 := station.advance_marta_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (MARTA: Wiem. Twoja Lena nie stawiała pytań...)")

	var l2 := station.advance_marta_dialogue()
	_expect(l2 == 2, "dialogue must advance to line 2 (LENA: Szuflada biurka ma zamek szyfrowy...)")

	var l3 := station.advance_marta_dialogue()
	_expect(l3 == 3, "dialogue must advance to line 3 (MARTA: Znasz. Każda wersja ciebie go zna...)")

	var l4 := station.advance_marta_dialogue()
	_expect(l4 == 4, "dialogue must advance to line 4 (ŚWIADECTWO CIAŁA: Lena odruchowo obraca bębenki...)")
	_expect(station.cipher_drawer_unlocked_state, "cipher drawer must unlock automatically on line 4")
	_expect(desk_prop.is_activated, "CipherDesk prop must be marked activated")

	var l5 := station.advance_marta_dialogue()
	_expect(l5 == 5, "dialogue must advance to line 5 (LENA: Obce pismo... ale wzory są moje...)")

	var l6 := station.advance_marta_dialogue()
	_expect(l6 == 6, "dialogue must advance to line 6 (MARTA: Ona nie uciekała przed systemem...)")

	var l7 := station.advance_marta_dialogue()
	_expect(l7 == 7, "dialogue must advance to line 7 (MARTA: Herbata paruje na stole...)")

	var l8 := station.advance_marta_dialogue()
	_expect(l8 == -1, "advancing past end must return -1")
	_expect(station.is_marta_dialogue_completed, "marta dialogue must be completed")
	_expect(not station.marta_dialogue_active, "marta dialogue must no longer be active")

	# Test 7: Direct inspection of CipherDesk at x=465
	player.global_position = Vector2(465.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(desk_prop.is_player_in_range, "desk prop must detect player in range at x=465")
	_expect(desk_prop.is_activated, "desk prop must be in unlocked/activated state")

	# Test 8: Player steps into the bathroom corridor / airlock zone at x=610 towards Space 09 (Pokój, który nie czeka)
	player.global_position = Vector2(610.0, 296.0)
	await physics_frame
	await physics_frame

	_expect(station.is_level_completed, "station_08 must complete upon entering bathroom doorway airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_09() -> void:
	var packed_station := load("res://scenes/levels/station_09.tscn") as PackedScene
	_expect(packed_station != null, "station_09 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station09
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_09: player missing")
	_expect(camera != null, "station_09: camera missing")
	_expect(geometry != null, "station_09: geometry missing")
	_expect(props != null, "station_09: props node missing")
	_expect(airlock_zone != null, "station_09: airlock_zone missing")

	if props == null or player == null or camera == null:
		station.queue_free()
		await process_frame
		return

	var sink_prop := props.get_node_or_null("BathroomSink") as MemoryResonancePoint
	var mirror_prop := props.get_node_or_null("BathroomMirror") as MemoryResonancePoint
	var inscr_prop := props.get_node_or_null("ScratchedInscription") as MemoryResonancePoint
	var apoth_prop := props.get_node_or_null("ApothecaryCabinet") as MemoryResonancePoint
	var guide_prop := props.get_node_or_null("MartaBathroomGuide") as MemoryResonancePoint

	_expect(sink_prop != null, "BathroomSink prop missing in station_09")
	_expect(mirror_prop != null, "BathroomMirror prop missing in station_09")
	_expect(inscr_prop != null, "ScratchedInscription prop missing in station_09")
	_expect(apoth_prop != null, "ApothecaryCabinet prop missing in station_09")
	_expect(guide_prop != null, "MartaBathroomGuide prop missing in station_09")

	if sink_prop == null or mirror_prop == null or inscr_prop == null or apoth_prop == null or guide_prop == null:
		station.queue_free()
		await process_frame
		return

	# Initial state verification
	_expect(not station.sink_inspected, "sink should not be inspected initially")
	_expect(not station.mirror_inspected, "mirror should not be inspected initially")
	_expect(not station.inscription_revealed, "inscription should not be revealed initially")
	_expect(not station.apothecary_inspected, "apothecary cabinet should not be inspected initially")
	_expect(not station.marta_guide_inspected, "marta guide should not be inspected initially")
	_expect(not station.is_corridor_stabilized, "corridor should not be stabilized initially")
	_expect(not station.is_door_unlocked, "exit door must be locked initially")
	_expect(not station.is_level_completed, "level should not be completed initially")

	# Test 1: Inspect Bathroom Sink at x=170
	player.global_position = Vector2(170.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(sink_prop.is_player_in_range, "sink must detect player in range at x=170")

	sink_prop.trigger_interaction()
	_expect(sink_prop.is_activated, "sink prop must be activated")
	_expect(station.sink_inspected, "station.sink_inspected must be true")

	# Test 2: Inspect Apothecary Cabinet at x=235
	player.global_position = Vector2(235.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(apoth_prop.is_player_in_range, "apothecary cabinet must detect player in range at x=235")

	apoth_prop.trigger_interaction()
	_expect(apoth_prop.is_activated, "apothecary cabinet prop must be activated")
	_expect(station.apothecary_inspected, "station.apothecary_inspected must be true")

	# Test 3: Inspect Bathroom Mirror at x=170
	player.global_position = Vector2(170.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(mirror_prop.is_player_in_range, "mirror must detect player in range at x=170")

	mirror_prop.trigger_interaction()
	_expect(mirror_prop.is_activated, "mirror prop must be activated")
	_expect(station.mirror_inspected, "station.mirror_inspected must be true")
	_expect(station.marta_dialogue_active, "dialogue D-03 must be active after mirror interaction")
	_expect(station.marta_dialogue_index == 0, "dialogue D-03 must start at line 0 (MARTA: Nie patrz na drzwi...)")

	# Test 4: Oblique Angle Discovery of Clue R-02 ("NIE SZUKAJ ORYGINAŁU")
	# Step back to x=240 looking left towards mirror
	player.global_position = Vector2(240.0, 296.0)
	player.velocity = Vector2(-20.0, 0.0) # Facing left / looking towards mirror
	await physics_frame
	await physics_frame
	_expect(station.is_oblique_angle, "station must detect oblique angle at x=240 looking left")
	_expect(station.inscription_revealed, "inscription 'NIE SZUKAJ ORYGINAŁU' must be revealed at oblique angle")
	_expect(inscr_prop.is_activated, "ScratchedInscription prop must be activated")

	# Test 5: Step through dialogue D-03 lines (0..6)
	var l1 := station.advance_marta_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (LENA: Odbicie jest opóźnione.)")

	var l2 := station.advance_marta_dialogue()
	_expect(l2 == 2, "dialogue must advance to line 2 (MARTA: Wiem.)")

	var l3 := station.advance_marta_dialogue()
	_expect(l3 == 3, "dialogue must advance to line 3 (LENA: Ile?)")

	var l4 := station.advance_marta_dialogue()
	_expect(l4 == 4, "dialogue must advance to line 4 (MARTA: Tyle, żebyś zdążyła się przestraszyć...)")

	var l5 := station.advance_marta_dialogue()
	_expect(l5 == 5, "dialogue must advance to line 5 (LENA: Zmierzę po przejściu.)")

	var l6 := station.advance_marta_dialogue()
	_expect(l6 == 6, "dialogue must advance to line 6 (MARTA: Ona też tak powiedziała.)")

	var l7 := station.advance_marta_dialogue()
	_expect(l7 == -1, "advancing past line 6 must complete dialogue and return -1")
	_expect(station.is_marta_dialogue_completed, "marta dialogue must be marked completed")
	_expect(not station.marta_dialogue_active, "marta dialogue must be inactive")

	# Test 6: Inspect Marta's Bathroom Guide marker at x=340
	player.global_position = Vector2(340.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(guide_prop.is_player_in_range, "guide marker must detect player in range at x=340")

	guide_prop.trigger_interaction()
	_expect(guide_prop.is_activated, "guide marker prop must be activated")
	_expect(station.marta_guide_inspected, "station.marta_guide_inspected must be true")

	# Test 7: Traverse the corridor towards exit door (x=560) following Marta's rule
	_expect(not station.is_corridor_stabilized, "corridor should not be stabilized before crossing")
	_expect(not station.is_door_unlocked, "door should not be unlocked before reaching doorway")

	player.global_position = Vector2(560.0, 296.0)
	player.velocity = Vector2(40.0, 0.0) # Moving rightward
	for frame in range(10):
		await physics_frame

	_expect(station.is_corridor_stabilized, "corridor must stabilize upon steady traversal to x=560")
	_expect(station.is_door_unlocked, "exit door must unlock upon corridor stabilization")

	# Test 8: Player enters the doorway / airlock zone at x=610 towards Space 10 (Telefon Jakuba)
	player.global_position = Vector2(610.0, 296.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station_09 must complete upon entering doorway airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_10() -> void:
	var packed_station := load("res://scenes/levels/station_10.tscn") as PackedScene
	_expect(packed_station != null, "station_10 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station10
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_10: player missing")
	_expect(camera != null, "station_10: camera missing")
	_expect(geometry != null, "station_10: geometry missing")
	_expect(props != null, "station_10: props node missing")
	_expect(airlock_zone != null, "station_10: airlock_zone missing")

	if props == null or player == null or camera == null:
		station.queue_free()
		await process_frame
		return

	var board_prop := props.get_node_or_null("TopographyBoard") as MemoryResonancePoint
	var phone_prop := props.get_node_or_null("BakelitePhone") as MemoryResonancePoint
	var lamp_prop := props.get_node_or_null("JakubDeskLamp") as MemoryResonancePoint
	var tape_prop := props.get_node_or_null("ReelTapeRecorder") as MemoryResonancePoint
	var airlock_prop := props.get_node_or_null("TechStorageAirlock") as MemoryResonancePoint

	_expect(board_prop != null, "TopographyBoard prop missing in station_10")
	_expect(phone_prop != null, "BakelitePhone prop missing in station_10")
	_expect(lamp_prop != null, "JakubDeskLamp prop missing in station_10")
	_expect(tape_prop != null, "ReelTapeRecorder prop missing in station_10")
	_expect(airlock_prop != null, "TechStorageAirlock prop missing in station_10")

	if board_prop == null or phone_prop == null or lamp_prop == null or tape_prop == null or airlock_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("BellAudioPlayer") != null, "BellAudioPlayer missing in station_10")
	_expect(station.get_node_or_null("PickupAudioPlayer") != null, "PickupAudioPlayer missing in station_10")
	_expect(station.get_node_or_null("TapeAudioPlayer") != null, "TapeAudioPlayer missing in station_10")
	_expect(station.get_node_or_null("BlipAudioPlayer") != null, "BlipAudioPlayer missing in station_10")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_10")

	# Initial state verification
	_expect(not station.phone_inspected, "phone should not be inspected initially")
	_expect(not station.tape_inspected, "tape should not be inspected initially")
	_expect(not station.board_inspected, "board should not be inspected initially")
	_expect(not station.lamp_inspected, "lamp should not be inspected initially")
	_expect(station.is_phone_ringing, "phone must be ringing initially")
	_expect(not station.is_phone_answered, "phone must not be answered initially")
	_expect(not station.is_tape_playing, "tape must not be playing initially")
	_expect(not station.is_airlock_unlocked, "technical airlock must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Topography Board at x=280
	player.global_position = Vector2(280.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(board_prop.is_player_in_range, "board must detect player in range at x=280")

	board_prop.trigger_interaction()
	_expect(board_prop.is_activated, "TopographyBoard prop must be activated")
	_expect(station.board_inspected, "station.board_inspected must be true")

	# Test 2: Inspect Jakub Desk Lamp at x=310
	player.global_position = Vector2(310.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(lamp_prop.is_player_in_range, "desk lamp must detect player in range at x=310")

	lamp_prop.trigger_interaction()
	_expect(lamp_prop.is_activated, "JakubDeskLamp prop must toggle activated state")
	_expect(station.lamp_inspected, "station.lamp_inspected must be true")

	# Test 3: Inspect & Toggle Reel-to-Reel Tape Recorder at x=405
	player.global_position = Vector2(405.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(tape_prop.is_player_in_range, "tape recorder must detect player in range at x=405")

	tape_prop.trigger_interaction()
	_expect(tape_prop.is_activated, "ReelTapeRecorder prop must be active (playing)")
	_expect(station.tape_inspected, "station.tape_inspected must be true")
	_expect(station.is_tape_playing, "station.is_tape_playing must be true")

	# Test 4: Move to Bakelite Phone at x=255 and Answer the Ringing Call
	player.global_position = Vector2(255.0, 296.0)
	await physics_frame
	await physics_frame
	_expect(phone_prop.is_player_in_range, "phone must detect player in range at x=255")

	phone_prop.trigger_interaction()
	_expect(phone_prop.is_activated, "BakelitePhone prop must be activated")
	_expect(station.phone_inspected, "station.phone_inspected must be true")
	_expect(station.is_phone_answered, "phone must now be answered")
	_expect(not station.is_phone_ringing, "phone must stop ringing once answered")
	_expect(station.jakub_dialogue_active, "jakub dialogue D-04 must be active after answering phone")
	_expect(station.jakub_dialogue_index == 0, "dialogue D-04 must start at line 0 (JAKUB: Odbierz jeszcze raz...)")

	# Test 5: Step through full dialogue D-04 lines (0..12)
	var l1 := station.advance_jakub_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (LENA: Kto mówi?)")

	var l2 := station.advance_jakub_dialogue()
	_expect(l2 == 2, "dialogue must advance to line 2 (JAKUB: Dobrze. Zaczynamy od kary...)")

	var l3 := station.advance_jakub_dialogue()
	_expect(l3 == 3, "dialogue must advance to line 3 (ŚWIADECTWO: Lena zastyga przy biurku...)")

	var l4 := station.advance_jakub_dialogue()
	_expect(l4 == 4, "dialogue must advance to line 4 (LENA: Podaj datę wypadku.)")

	var l5 := station.advance_jakub_dialogue()
	_expect(l5 == 5, "dialogue must advance to line 5 (JAKUB: Którego?)")

	var l6 := station.advance_jakub_dialogue()
	_expect(l6 == 6, "dialogue must advance to line 6 (LENA: Na Linii 4.)")

	var l7 := station.advance_jakub_dialogue()
	_expect(l7 == 7, "dialogue must advance to line 7 (JAKUB: Lena, ja tam pracuję...)")

	var l8 := station.advance_jakub_dialogue()
	_expect(l8 == 8, "dialogue must advance to line 8 (LENA: Trzeci listopada...)")

	var l9 := station.advance_jakub_dialogue()
	_expect(l9 == 9, "dialogue must advance to line 9 (ŚWIADECTWO: W słuchawce zapada głęboka cisza...)")

	var l10 := station.advance_jakub_dialogue()
	_expect(l10 == 10, "dialogue must advance to line 10 (JAKUB: Gdzie jesteś?)")

	var l11 := station.advance_jakub_dialogue()
	_expect(l11 == 11, "dialogue must advance to line 11 (LENA: U kobiety...)")

	var l12 := station.advance_jakub_dialogue()
	_expect(l12 == 12, "dialogue must advance to line 12 (JAKUB: To nie zawęża.)")

	var l_end := station.advance_jakub_dialogue()
	_expect(l_end == -1, "advancing past line 12 must complete dialogue and return -1")
	_expect(station.is_jakub_dialogue_completed, "jakub dialogue D-04 must be marked completed")
	_expect(not station.jakub_dialogue_active, "jakub dialogue must be inactive")
	_expect(station.is_airlock_unlocked, "technical airlock must unlock after D-04 dialogue completion")
	_expect(airlock_prop.is_activated, "TechStorageAirlock prop must be activated")

	# Wait for airlock door opening transition
	for f in range(20):
		await physics_frame

	_expect(station._door_open_progress > 0.1, "airlock door opening progress must advance")

	# Test 6: Player enters the doorway / airlock zone at x=610 to conclude Act I and transition to Space 11
	player.global_position = Vector2(610.0, 296.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station_10 must complete upon entering airlock zone")

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
