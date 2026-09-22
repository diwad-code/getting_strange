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
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")
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
	print("TEST: movement_lab completed")

	await _test_anchor_lab()
	print("TEST: anchor_lab completed")

	## PKG-0176. Ukonczenie stacji w tescie wywoluje `complete_station()`, a ta
	## przy wlaczonym `campaign_auto_transition_enabled` robi realne
	## `change_scene_to_file()`. Bramka nie ma sceny biezacej, wiec Godot
	## dowiesza nastepna stacje bezposrednio pod `root` i nikt jej nie zwalnia.
	## Osierocona geometria zostaje w drzewie fizyki i blokuje rekwizyty
	## kolejnych stacji (donica Station 09 wparta w podloge Station 06).
	## Wszystkie pozostale bramki wylaczaja auto-przejscie na czas przebiegu;
	## ta jedna tego nie robila.
	var campaign_state := root.get_node_or_null("GameStateManager")
	var previous_auto_transition := true
	if campaign_state != null:
		previous_auto_transition = bool(campaign_state.campaign_auto_transition_enabled)
		campaign_state.campaign_auto_transition_enabled = false

	await _test_station_01()
	print("TEST: station_01 completed")
	await _test_station_02()
	print("TEST: station_02 completed")
	await _test_station_03()
	print("TEST: station_03 completed")
	await _test_station_04()
	print("TEST: station_04 completed")
	await _test_station_05()
	print("TEST: station_05 completed")
	await _test_station_06()
	print("TEST: station_06 completed")
	await _test_station_07()
	print("TEST: station_07 completed")
	await _test_station_08()
	print("TEST: station_08 completed")
	await _test_station_09()
	print("TEST: station_09 completed")
	await _test_station_10()
	print("TEST: station_10 completed")
	await _test_station_11()
	print("TEST: station_11 completed")
	await _test_station_12()
	print("TEST: station_12 completed")
	await _test_station_13()
	print("TEST: station_13 completed")
	await _test_station_14()
	print("TEST: station_14 completed")
	await _test_station_15()
	print("TEST: station_15 completed")
	await _test_station_16()
	print("TEST: station_16 completed")
	await _test_station_17()
	print("TEST: station_17 completed")
	await _test_station_18()
	print("TEST: station_18 completed")
	await _test_station_19()
	print("TEST: station_19 completed")
	await _test_station_20()
	print("TEST: station_20 completed")
	await _test_station_21()
	print("TEST: station_21 completed")
	await _test_station_22()
	print("TEST: station_22 completed")
	await _test_station_23()
	print("TEST: station_23 completed")
	await _test_station_24()
	print("TEST: station_24 completed")
	await _test_station_25()
	print("TEST: station_25 completed")
	await _test_station_26()
	print("TEST: station_26 completed")
	await _test_station_27()
	print("TEST: station_27 completed")
	await _test_station_28()
	print("TEST: station_28 completed")
	await _test_station_29()
	print("TEST: station_29 completed")
	await _test_station_30()
	print("TEST: station_30 completed")
	await _test_station_31()
	print("TEST: station_31 completed")
	await _test_station_32()
	print("TEST: station_32 completed")
	await _test_station_33()
	print("TEST: station_33 completed")
	await _test_station_34()
	print("TEST: station_34 completed")
	await _test_station_35()
	print("TEST: station_35 completed")
	await _test_station_36()
	print("TEST: station_36 completed")
	await _test_station_37()
	print("TEST: station_37 completed")
	await _test_station_38()
	print("TEST: station_38 completed")
	await _test_station_39()
	print("TEST: station_39 completed")
	await _test_station_40()
	print("TEST: station_40 completed")
	await _test_station_41()
	print("TEST: station_41 completed")
	await _test_station_42a()
	print("TEST: station_42a completed")
	await _test_station_42b()
	print("TEST: station_42b completed")
	await _test_station_42c()
	print("TEST: station_42c completed")
	await _test_station_43()
	print("TEST: station_43 completed")

	if campaign_state != null:
		campaign_state.campaign_auto_transition_enabled = previous_auto_transition

	_finish()


func _test_procedural_audio() -> void:
	var qv_whistle_sfx := ProceduralAudio.create_quantum_vacuum_whistle_sound()
	_expect(qv_whistle_sfx != null, "quantum vacuum whistle sound synthesis failed")
	_expect(qv_whistle_sfx.data.size() > 0, "quantum vacuum whistle sound buffer empty")

	var casimir_hiss_sfx := ProceduralAudio.create_casimir_cavity_hiss_sound()
	_expect(casimir_hiss_sfx != null, "casimir cavity hiss sound synthesis failed")
	_expect(casimir_hiss_sfx.data.size() > 0, "casimir cavity hiss sound buffer empty")

	var neg_pulse_sfx := ProceduralAudio.create_negative_energy_pulse_sound()
	_expect(neg_pulse_sfx != null, "negative energy pulse sound synthesis failed")
	_expect(neg_pulse_sfx.data.size() > 0, "negative energy pulse sound buffer empty")

	var lifshitz_snap_sfx := ProceduralAudio.create_lifshitz_retarded_snap_sound()
	_expect(lifshitz_snap_sfx != null, "lifshitz retarded snap sound synthesis failed")
	_expect(lifshitz_snap_sfx.data.size() > 0, "lifshitz retarded snap sound buffer empty")

	var onsager_sfx := ProceduralAudio.create_onsager_thermoelectric_whistle_sound()
	_expect(onsager_sfx != null, "onsager thermoelectric whistle sound synthesis failed")
	_expect(onsager_sfx.data.size() > 0, "onsager thermoelectric whistle sound buffer empty")

	var entropy_pulse_sfx := ProceduralAudio.create_entropy_production_pulse_sound()
	_expect(entropy_pulse_sfx != null, "entropy production pulse sound synthesis failed")
	_expect(entropy_pulse_sfx.data.size() > 0, "entropy production pulse sound buffer empty")

	var prigogine_sfx := ProceduralAudio.create_prigogine_relaxation_snap_sound()
	_expect(prigogine_sfx != null, "prigogine relaxation snap sound synthesis failed")
	_expect(prigogine_sfx.data.size() > 0, "prigogine relaxation snap sound buffer empty")

	var thermal_noise_sfx := ProceduralAudio.create_thermal_fluctuation_noise_sound()
	_expect(thermal_noise_sfx != null, "thermal fluctuation noise sound synthesis failed")
	_expect(thermal_noise_sfx.data.size() > 0, "thermal fluctuation noise sound buffer empty")

	var mag_hum_sfx := ProceduralAudio.create_magnetic_resonance_hum_sound()
	_expect(mag_hum_sfx != null, "magnetic resonance hum sound synthesis failed")
	_expect(mag_hum_sfx.data.size() > 0, "magnetic resonance hum sound buffer empty")

	var barkhausen_sfx := ProceduralAudio.create_barkhausen_noise_sound()
	_expect(barkhausen_sfx != null, "barkhausen noise sound synthesis failed")
	_expect(barkhausen_sfx.data.size() > 0, "barkhausen noise sound buffer empty")

	var llg_whistle_sfx := ProceduralAudio.create_llg_precession_whistle_sound()
	_expect(llg_whistle_sfx != null, "llg precession whistle sound synthesis failed")
	_expect(llg_whistle_sfx.data.size() > 0, "llg precession whistle sound buffer empty")

	var ferri_switch_sfx := ProceduralAudio.create_ferrimagnetic_switch_sound()
	_expect(ferri_switch_sfx != null, "ferrimagnetic switch sound synthesis failed")
	_expect(ferri_switch_sfx.data.size() > 0, "ferrimagnetic switch sound buffer empty")

	var radio_sfx := ProceduralAudio.create_epilogue_radio_announcement_sound()
	_expect(radio_sfx != null, "epilogue radio sound synthesis failed")
	_expect(radio_sfx.data.size() > 0, "epilogue radio sound buffer empty")

	var cups_sfx := ProceduralAudio.create_epilogue_cup_clink_sound()
	_expect(cups_sfx != null, "epilogue cups sound synthesis failed")
	_expect(cups_sfx.data.size() > 0, "epilogue cups sound buffer empty")

	var switch_sfx := ProceduralAudio.create_epilogue_tram_switch_latch_sound()
	_expect(switch_sfx != null, "epilogue tram switch sound synthesis failed")
	_expect(switch_sfx.data.size() > 0, "epilogue tram switch sound buffer empty")

	var credits_sfx := ProceduralAudio.create_epilogue_credits_drone_sound()
	_expect(credits_sfx != null, "epilogue credits drone sound synthesis failed")
	_expect(credits_sfx.data.size() > 0, "epilogue credits drone sound buffer empty")

	var carrier_sfx := ProceduralAudio.create_epilogue_final_carrier_sound()
	_expect(carrier_sfx != null, "epilogue final carrier sound synthesis failed")
	_expect(carrier_sfx.data.size() > 0, "epilogue final carrier sound buffer empty")

	var op_return_sfx := ProceduralAudio.create_operation_return_execution_sound()
	_expect(op_return_sfx != null, "operation return sound synthesis failed")
	_expect(op_return_sfx.data.size() > 0, "operation return sound buffer empty")

	var op_reconcil_sfx := ProceduralAudio.create_operation_reconciliation_execution_sound()
	_expect(op_reconcil_sfx != null, "operation reconciliation sound synthesis failed")
	_expect(op_reconcil_sfx.data.size() > 0, "operation reconciliation sound buffer empty")

	var op_testimony_sfx := ProceduralAudio.create_operation_testimony_execution_sound()
	_expect(op_testimony_sfx != null, "operation testimony sound synthesis failed")
	_expect(op_testimony_sfx.data.size() > 0, "operation testimony sound buffer empty")

	var op_console_sfx := ProceduralAudio.create_operation_console_engage_sound()
	_expect(op_console_sfx != null, "operation console engage sound synthesis failed")
	_expect(op_console_sfx.data.size() > 0, "operation console engage sound buffer empty")

	var gate_41_sfx := ProceduralAudio.create_station41_act4_resolution_gate_sound()
	_expect(gate_41_sfx != null, "station 41 resolution gate sound synthesis failed")
	_expect(gate_41_sfx.data.size() > 0, "station 41 resolution gate sound buffer empty")

	var wierzbicka_term_sfx := ProceduralAudio.create_wierzbicka_personal_terminal_sound()
	_expect(wierzbicka_term_sfx != null, "wierzbicka personal terminal sound synthesis failed")
	_expect(wierzbicka_term_sfx.data.size() > 0, "wierzbicka personal terminal sound buffer empty")

	var marta_witness_sfx := ProceduralAudio.create_marta_witness_presence_sound()
	_expect(marta_witness_sfx != null, "marta witness presence sound synthesis failed")
	_expect(marta_witness_sfx.data.size() > 0, "marta witness presence sound buffer empty")

	var szymon_feed_sfx := ProceduralAudio.create_szymon_transmission_feed_sound()
	_expect(szymon_feed_sfx != null, "szymon transmission feed sound synthesis failed")
	_expect(szymon_feed_sfx.data.size() > 0, "szymon transmission feed sound buffer empty")

	var cost_mat_sfx := ProceduralAudio.create_cost_dossier_matrix_sound()
	_expect(cost_mat_sfx != null, "cost dossier matrix sound synthesis failed")
	_expect(cost_mat_sfx.data.size() > 0, "cost dossier matrix sound buffer empty")

	var gate_40_sfx := ProceduralAudio.create_station40_final_chamber_gate_sound()
	_expect(gate_40_sfx != null, "station 40 final chamber gate sound synthesis failed")
	_expect(gate_40_sfx.data.size() > 0, "station 40 final chamber gate sound buffer empty")
	var ref_core_sfx := ProceduralAudio.create_reference_core_harmonics_sound()
	_expect(ref_core_sfx != null, "reference core harmonics sound synthesis failed")
	_expect(ref_core_sfx.data.size() > 0, "reference core harmonics sound buffer empty")

	var config_a_sfx := ProceduralAudio.create_branch_configuration_a_sound()
	_expect(config_a_sfx != null, "branch config A sound synthesis failed")
	_expect(config_a_sfx.data.size() > 0, "branch config A sound buffer empty")

	var config_b_sfx := ProceduralAudio.create_branch_configuration_b_sound()
	_expect(config_b_sfx != null, "branch config B sound synthesis failed")
	_expect(config_b_sfx.data.size() > 0, "branch config B sound buffer empty")

	var config_c_sfx := ProceduralAudio.create_branch_configuration_c_sound()
	_expect(config_c_sfx != null, "branch config C sound synthesis failed")
	_expect(config_c_sfx.data.size() > 0, "branch config C sound buffer empty")

	var gate_39_sfx := ProceduralAudio.create_station39_act4_gateway_sound()
	_expect(gate_39_sfx != null, "station 39 act 4 gateway sound synthesis failed")
	_expect(gate_39_sfx.data.size() > 0, "station 39 act 4 gateway sound buffer empty")

	var accident_dist_sfx := ProceduralAudio.create_accident_field_distortion_sound()
	_expect(accident_dist_sfx != null, "accident field distortion sound synthesis failed")
	_expect(accident_dist_sfx.data.size() > 0, "accident field distortion sound buffer empty")

	var jakub_destab_sfx := ProceduralAudio.create_jakub_destabilization_hum_sound()
	_expect(jakub_destab_sfx != null, "jakub destabilization hum sound synthesis failed")
	_expect(jakub_destab_sfx.data.size() > 0, "jakub destabilization hum sound buffer empty")

	var rescue_tether_sfx := ProceduralAudio.create_rescue_tether_chime_sound()
	_expect(rescue_tether_sfx != null, "rescue tether chime sound synthesis failed")
	_expect(rescue_tether_sfx.data.size() > 0, "rescue tether chime sound buffer empty")

	var coord_calc_sfx := ProceduralAudio.create_coordinate_calculator_click_sound()
	_expect(coord_calc_sfx != null, "coordinate calculator click sound synthesis failed")
	_expect(coord_calc_sfx.data.size() > 0, "coordinate calculator click sound buffer empty")

	var gate_38_sfx := ProceduralAudio.create_station38_reference_vault_door_sound()
	_expect(gate_38_sfx != null, "station 38 reference vault door sound synthesis failed")
	_expect(gate_38_sfx.data.size() > 0, "station 38 reference vault door sound buffer empty")

	var antenna_sfx := ProceduralAudio.create_signal_antenna_carrier_sound()
	_expect(antenna_sfx != null, "signal antenna carrier sound synthesis failed")
	_expect(antenna_sfx.data.size() > 0, "signal antenna carrier sound buffer empty")

	var patchbay_sfx := ProceduralAudio.create_cross_patchbay_plug_sound()
	_expect(patchbay_sfx != null, "cross patchbay plug sound synthesis failed")
	_expect(patchbay_sfx.data.size() > 0, "cross patchbay plug sound buffer empty")

	var crt_sweep_sfx := ProceduralAudio.create_crt_sweep_interference_sound()
	_expect(crt_sweep_sfx != null, "crt sweep interference sound synthesis failed")
	_expect(crt_sweep_sfx.data.size() > 0, "crt sweep interference sound buffer empty")

	var lever_sfx := ProceduralAudio.create_memory_injection_lever_sound()
	_expect(lever_sfx != null, "memory injection lever sound synthesis failed")
	_expect(lever_sfx.data.size() > 0, "memory injection lever sound buffer empty")

	var gate_37_sfx := ProceduralAudio.create_station37_broadcast_gate_sound()
	_expect(gate_37_sfx != null, "station 37 broadcast gate sound synthesis failed")
	_expect(gate_37_sfx.data.size() > 0, "station 37 broadcast gate sound buffer empty")

	var storm_drain_sfx := ProceduralAudio.create_storm_drain_torrent_sound()
	_expect(storm_drain_sfx != null, "storm drain torrent sound synthesis failed")
	_expect(storm_drain_sfx.data.size() > 0, "storm drain torrent sound buffer empty")

	var drain_weir_sfx := ProceduralAudio.create_drain_weir_creak_sound()
	_expect(drain_weir_sfx != null, "drain weir creak sound synthesis failed")
	_expect(drain_weir_sfx.data.size() > 0, "drain weir creak sound buffer empty")

	var acid_ladder_sfx := ProceduralAudio.create_acid_ladder_clank_sound()
	_expect(acid_ladder_sfx != null, "acid ladder clank sound synthesis failed")
	_expect(acid_ladder_sfx.data.size() > 0, "acid ladder clank sound buffer empty")

	var leak_alarm_sfx := ProceduralAudio.create_groundwater_leak_alarm_sound()
	_expect(leak_alarm_sfx != null, "groundwater leak alarm sound synthesis failed")
	_expect(leak_alarm_sfx.data.size() > 0, "groundwater leak alarm sound buffer empty")

	var storm_gate_sfx := ProceduralAudio.create_station36_storm_gate_sound()
	_expect(storm_gate_sfx != null, "station 36 storm gate sound synthesis failed")
	_expect(storm_gate_sfx.data.size() > 0, "station 36 storm gate sound buffer empty")

	var sedation_slosh_sfx := ProceduralAudio.create_sedation_liquid_slosh_sound()
	_expect(sedation_slosh_sfx != null, "sedation liquid slosh sound synthesis failed")
	_expect(sedation_slosh_sfx.data.size() > 0, "sedation liquid slosh sound buffer empty")

	var sludge_valve_sfx := ProceduralAudio.create_sludge_valve_creak_sound()
	_expect(sludge_valve_sfx != null, "sludge valve creak sound synthesis failed")
	_expect(sludge_valve_sfx.data.size() > 0, "sludge valve creak sound buffer empty")

	var chemical_bubbler_sfx := ProceduralAudio.create_chemical_bubbler_sound()
	_expect(chemical_bubbler_sfx != null, "chemical bubbler sound synthesis failed")
	_expect(chemical_bubbler_sfx.data.size() > 0, "chemical bubbler sound buffer empty")

	var sedation_alarm_sfx := ProceduralAudio.create_sedation_saturation_alarm_sound()
	_expect(sedation_alarm_sfx != null, "sedation saturation alarm sound synthesis failed")
	_expect(sedation_alarm_sfx.data.size() > 0, "sedation saturation alarm sound buffer empty")

	var door_release_35_sfx := ProceduralAudio.create_station35_drain_sluice_sound()
	_expect(door_release_35_sfx != null, "station 35 drain sluice sound synthesis failed")
	_expect(door_release_35_sfx.data.size() > 0, "station 35 drain sluice sound buffer empty")

	var core_pulse_sfx := ProceduralAudio.create_core_reactor_pulse_sound()
	_expect(core_pulse_sfx != null, "core reactor pulse sound synthesis failed")
	_expect(core_pulse_sfx.data.size() > 0, "core reactor pulse sound buffer empty")

	var slider_drag_sfx := ProceduralAudio.create_biography_slider_drag_sound()
	_expect(slider_drag_sfx != null, "biography slider drag sound synthesis failed")
	_expect(slider_drag_sfx.data.size() > 0, "biography slider drag sound buffer empty")

	var thermal_alarm_sfx := ProceduralAudio.create_core_thermal_alarm_sound()
	_expect(thermal_alarm_sfx != null, "core thermal alarm sound synthesis failed")
	_expect(thermal_alarm_sfx.data.size() > 0, "core thermal alarm sound buffer empty")

	var jakub_probe_sfx := ProceduralAudio.create_jakub_diagnostic_probe_sound()
	_expect(jakub_probe_sfx != null, "jakub diagnostic probe sound synthesis failed")
	_expect(jakub_probe_sfx.data.size() > 0, "jakub diagnostic probe sound buffer empty")

	var door_release_34_sfx := ProceduralAudio.create_station34_filtration_gate_sound()
	_expect(door_release_34_sfx != null, "station 34 filtration gate sound synthesis failed")
	_expect(door_release_34_sfx.data.size() > 0, "station 34 filtration gate sound buffer empty")

	var ladder_climb_sfx := ProceduralAudio.create_ladder_rung_climb_sound()
	_expect(ladder_climb_sfx != null, "ladder rung climb sound synthesis failed")
	_expect(ladder_climb_sfx.data.size() > 0, "ladder rung climb sound buffer empty")

	var depth_creak_sfx := ProceduralAudio.create_depth_pressure_creak_sound()
	_expect(depth_creak_sfx != null, "depth pressure creak sound synthesis failed")
	_expect(depth_creak_sfx.data.size() > 0, "depth pressure creak sound buffer empty")

	var cable_trunk_sfx := ProceduralAudio.create_cable_trunk_pulse_sound()
	_expect(cable_trunk_sfx != null, "cable trunk pulse sound synthesis failed")
	_expect(cable_trunk_sfx.data.size() > 0, "cable trunk pulse sound buffer empty")

	var shaft_light_sfx := ProceduralAudio.create_shaft_work_light_hum_sound()
	_expect(shaft_light_sfx != null, "shaft work light hum sound synthesis failed")
	_expect(shaft_light_sfx.data.size() > 0, "shaft work light hum sound buffer empty")

	var door_release_33_sfx := ProceduralAudio.create_station33_lower_hatch_sound()
	_expect(door_release_33_sfx != null, "station 33 lower hatch sound synthesis failed")
	_expect(door_release_33_sfx.data.size() > 0, "station 33 lower hatch sound buffer empty")

	var steamed_glass_sfx := ProceduralAudio.create_glass_condensation_wipe_sound()
	_expect(steamed_glass_sfx != null, "glass condensation wipe sound synthesis failed")
	_expect(steamed_glass_sfx.data.size() > 0, "glass condensation wipe sound buffer empty")

	var glass_ring_sfx := ProceduralAudio.create_glass_stress_ring_sound()
	_expect(glass_ring_sfx != null, "glass stress ring sound synthesis failed")
	_expect(glass_ring_sfx.data.size() > 0, "glass stress ring sound buffer empty")

	var fire_rumble_sfx := ProceduralAudio.create_fire_memory_rumble_sound()
	_expect(fire_rumble_sfx != null, "fire memory rumble sound synthesis failed")
	_expect(fire_rumble_sfx.data.size() > 0, "fire memory rumble sound buffer empty")

	var consensus_stamp_sfx := ProceduralAudio.create_consensus_stamp_reverberation_sound()
	_expect(consensus_stamp_sfx != null, "consensus stamp reverberation sound synthesis failed")
	_expect(consensus_stamp_sfx.data.size() > 0, "consensus stamp reverberation sound buffer empty")

	var door_release_32_sfx := ProceduralAudio.create_station32_hatch_unseal_sound()
	_expect(door_release_32_sfx != null, "station 32 hatch unseal sound synthesis failed")
	_expect(door_release_32_sfx.data.size() > 0, "station 32 hatch unseal sound buffer empty")

	var transformer_oil_sfx := ProceduralAudio.create_transformer_oil_hum_sound()
	_expect(transformer_oil_sfx != null, "transformer oil hum sound synthesis failed")
	_expect(transformer_oil_sfx.data.size() > 0, "transformer oil hum sound buffer empty")

	var knife_switch_sfx := ProceduralAudio.create_knife_switch_throw_sound()
	_expect(knife_switch_sfx != null, "knife switch throw sound synthesis failed")
	_expect(knife_switch_sfx.data.size() > 0, "knife switch throw sound buffer empty")

	var spark_sfx := ProceduralAudio.create_high_voltage_spark_sound()
	_expect(spark_sfx != null, "high voltage spark sound synthesis failed")
	_expect(spark_sfx.data.size() > 0, "high voltage spark sound buffer empty")

	var eleven_chairs_sfx := ProceduralAudio.create_eleven_chairs_whisper_sound()
	_expect(eleven_chairs_sfx != null, "eleven chairs whisper sound synthesis failed")
	_expect(eleven_chairs_sfx.data.size() > 0, "eleven chairs whisper sound buffer empty")

	var wierzbicka_recitation_sfx := ProceduralAudio.create_wierzbicka_recitation_chime_sound()
	_expect(wierzbicka_recitation_sfx != null, "wierzbicka recitation chime sound synthesis failed")
	_expect(wierzbicka_recitation_sfx.data.size() > 0, "wierzbicka recitation chime sound buffer empty")

	var twelfth_chair_sfx := ProceduralAudio.create_twelfth_chair_resonance_sound()
	_expect(twelfth_chair_sfx != null, "twelfth chair resonance sound synthesis failed")
	_expect(twelfth_chair_sfx.data.size() > 0, "twelfth chair resonance sound buffer empty")

	var variant_ledger_sfx := ProceduralAudio.create_variant_ledger_page_sound()
	_expect(variant_ledger_sfx != null, "variant ledger page turn sound synthesis failed")
	_expect(variant_ledger_sfx.data.size() > 0, "variant ledger page turn sound buffer empty")

	var door_release_31_sfx := ProceduralAudio.create_station31_pressure_hiss_sound()
	_expect(door_release_31_sfx != null, "station 31 pressure hiss sound synthesis failed")
	_expect(door_release_31_sfx.data.size() > 0, "station 31 pressure hiss sound buffer empty")

	var relay_sfx := ProceduralAudio.create_power_grid_relay_sound()
	_expect(relay_sfx != null, "power grid relay sound synthesis failed")
	_expect(relay_sfx.data.size() > 0, "power grid relay sound buffer empty")

	var door_release_30_sfx := ProceduralAudio.create_station30_door_release_sound()
	_expect(door_release_30_sfx != null, "station 30 door release sound synthesis failed")
	_expect(door_release_30_sfx.data.size() > 0, "station 30 door release sound buffer empty")

	var platform13_drip_sfx := ProceduralAudio.create_platform13_drip_echo_sound()
	_expect(platform13_drip_sfx != null, "platform 13 drip echo sound synthesis failed")
	_expect(platform13_drip_sfx.data.size() > 0, "platform 13 drip echo sound buffer empty")

	var neon_buzz_sfx := ProceduralAudio.create_flickering_neon_buzz_sound()
	_expect(neon_buzz_sfx != null, "flickering neon buzz sound synthesis failed")
	_expect(neon_buzz_sfx.data.size() > 0, "flickering neon buzz sound buffer empty")

	var deep_well_sfx := ProceduralAudio.create_deep_well_drone_sound()
	_expect(deep_well_sfx != null, "deep well drone sound synthesis failed")
	_expect(deep_well_sfx.data.size() > 0, "deep well drone sound buffer empty")

	var torch_click_sfx := ProceduralAudio.create_jakub_torch_click_sound()
	_expect(torch_click_sfx != null, "jakub torch click sound synthesis failed")
	_expect(torch_click_sfx.data.size() > 0, "jakub torch click sound buffer empty")

	var door_release_29_sfx := ProceduralAudio.create_station29_grate_creak_sound()
	_expect(door_release_29_sfx != null, "station 29 grate creak sound synthesis failed")
	_expect(door_release_29_sfx.data.size() > 0, "station 29 grate creak sound buffer empty")

	var tram_motor_sfx := ProceduralAudio.create_moving_tram_motor_sound()
	_expect(tram_motor_sfx != null, "moving tram motor sound synthesis failed")
	_expect(tram_motor_sfx.data.size() > 0, "moving tram motor sound buffer empty")

	var track_switch_sfx := ProceduralAudio.create_track_switch_clack_sound()
	_expect(track_switch_sfx != null, "track switch clack sound synthesis failed")
	_expect(track_switch_sfx.data.size() > 0, "track switch clack sound buffer empty")

	var wierzbicka_closing_sfx := ProceduralAudio.create_wierzbicka_closing_intercom_sound()
	_expect(wierzbicka_closing_sfx != null, "wierzbicka closing intercom sound synthesis failed")
	_expect(wierzbicka_closing_sfx.data.size() > 0, "wierzbicka closing intercom sound buffer empty")

	var paradox_shimmer_sfx := ProceduralAudio.create_paradox_peron_shimmer_sound()
	_expect(paradox_shimmer_sfx != null, "paradox peron shimmer sound synthesis failed")
	_expect(paradox_shimmer_sfx.data.size() > 0, "paradox peron shimmer sound buffer empty")

	var door_release_28_sfx := ProceduralAudio.create_station28_pneumatic_brake_sound()
	_expect(door_release_28_sfx != null, "station 28 pneumatic brake sound synthesis failed")
	_expect(door_release_28_sfx.data.size() > 0, "station 28 pneumatic brake sound buffer empty")

	var service_tunnel_sfx := ProceduralAudio.create_service_tunnel_hum_sound()
	_expect(service_tunnel_sfx != null, "service tunnel hum sound synthesis failed")
	_expect(service_tunnel_sfx.data.size() > 0, "service tunnel hum sound buffer empty")

	var jakub_card_sfx := ProceduralAudio.create_jakub_keycard_latch_sound()
	_expect(jakub_card_sfx != null, "jakub keycard latch sound synthesis failed")
	_expect(jakub_card_sfx.data.size() > 0, "jakub keycard latch sound buffer empty")

	var gratitude_sfx := ProceduralAudio.create_gratitude_confession_tone_sound()
	_expect(gratitude_sfx != null, "gratitude confession tone sound synthesis failed")
	_expect(gratitude_sfx.data.size() > 0, "gratitude confession tone sound buffer empty")

	var surface_danger_sfx := ProceduralAudio.create_surface_danger_siren_sound()
	_expect(surface_danger_sfx != null, "surface danger siren sound synthesis failed")
	_expect(surface_danger_sfx.data.size() > 0, "surface danger siren sound buffer empty")

	var door_release_27_sfx := ProceduralAudio.create_station27_door_release_sound()
	_expect(door_release_27_sfx != null, "station 27 door release sound synthesis failed")
	_expect(door_release_27_sfx.data.size() > 0, "station 27 door release sound buffer empty")

	var isolation_hum_sfx := ProceduralAudio.create_isolation_hum_sound()
	_expect(isolation_hum_sfx != null, "isolation hum sound synthesis failed")
	_expect(isolation_hum_sfx.data.size() > 0, "isolation hum sound buffer empty")

	var reconfig_chime_sfx := ProceduralAudio.create_reconfiguration_chime_sound()
	_expect(reconfig_chime_sfx != null, "reconfiguration chime sound synthesis failed")
	_expect(reconfig_chime_sfx.data.size() > 0, "reconfiguration chime sound buffer empty")

	var wierzbicka_calm_sfx := ProceduralAudio.create_wierzbicka_calming_tone_sound()
	_expect(wierzbicka_calm_sfx != null, "wierzbicka calming tone sound synthesis failed")
	_expect(wierzbicka_calm_sfx.data.size() > 0, "wierzbicka calming tone sound buffer empty")

	var motivation_scratch_sfx := ProceduralAudio.create_motivation_scratch_sound()
	_expect(motivation_scratch_sfx != null, "motivation scratch sound synthesis failed")
	_expect(motivation_scratch_sfx.data.size() > 0, "motivation scratch sound buffer empty")

	var door_release_26_sfx := ProceduralAudio.create_station26_door_release_sound()
	_expect(door_release_26_sfx != null, "station 26 door release sound synthesis failed")
	_expect(door_release_26_sfx.data.size() > 0, "station 26 door release sound buffer empty")

	var transit_rail_sfx := ProceduralAudio.create_transit_rail_hum_sound()
	_expect(transit_rail_sfx != null, "transit rail hum sound synthesis failed")
	_expect(transit_rail_sfx.data.size() > 0, "transit rail hum sound buffer empty")

	var jakub_uniform_sfx := ProceduralAudio.create_jakub_uniform_rustle_sound()
	_expect(jakub_uniform_sfx != null, "jakub uniform rustle sound synthesis failed")
	_expect(jakub_uniform_sfx.data.size() > 0, "jakub uniform rustle sound buffer empty")

	var scar_revelation_sfx := ProceduralAudio.create_scar_revelation_chime_sound()
	_expect(scar_revelation_sfx != null, "scar revelation chime sound synthesis failed")
	_expect(scar_revelation_sfx.data.size() > 0, "scar revelation chime sound buffer empty")

	var finger_scrape_sfx := ProceduralAudio.create_finger_edge_scrape_sound()
	_expect(finger_scrape_sfx != null, "finger edge scrape sound synthesis failed")
	_expect(finger_scrape_sfx.data.size() > 0, "finger edge scrape sound buffer empty")

	var door_release_25_sfx := ProceduralAudio.create_station25_door_release_sound()
	_expect(door_release_25_sfx != null, "station 25 door release sound synthesis failed")
	_expect(door_release_25_sfx.data.size() > 0, "station 25 door release sound buffer empty")

	var cctv_hum_sfx := ProceduralAudio.create_cctv_static_hum_sound()
	_expect(cctv_hum_sfx != null, "cctv static hum sound synthesis failed")
	_expect(cctv_hum_sfx.data.size() > 0, "cctv static hum sound buffer empty")

	var correction_siren_sfx := ProceduralAudio.create_correction_stress_siren_sound()
	_expect(correction_siren_sfx != null, "correction stress siren sound synthesis failed")
	_expect(correction_siren_sfx.data.size() > 0, "correction stress siren sound buffer empty")

	var wierzbicka_intercom_sfx := ProceduralAudio.create_intercom_wierzbicka_tone_sound()
	_expect(wierzbicka_intercom_sfx != null, "intercom wierzbicka tone sound synthesis failed")
	_expect(wierzbicka_intercom_sfx.data.size() > 0, "intercom wierzbicka tone sound buffer empty")

	var decision_latch_sfx := ProceduralAudio.create_decision_button_latch_sound()
	_expect(decision_latch_sfx != null, "decision button latch sound synthesis failed")
	_expect(decision_latch_sfx.data.size() > 0, "decision button latch sound buffer empty")

	var door_release_24_sfx := ProceduralAudio.create_station24_door_release_sound()
	_expect(door_release_24_sfx != null, "station 24 door release sound synthesis failed")
	_expect(door_release_24_sfx.data.size() > 0, "station 24 door release sound buffer empty")

	var biometric_gate_sfx := ProceduralAudio.create_biometric_gate_scan_sound()
	_expect(biometric_gate_sfx != null, "biometric gate scan sound synthesis failed")
	_expect(biometric_gate_sfx.data.size() > 0, "biometric gate scan sound buffer empty")

	var ring_resonance_sfx := ProceduralAudio.create_ring_resonance_hum_sound()
	_expect(ring_resonance_sfx != null, "ring resonance hum sound synthesis failed")
	_expect(ring_resonance_sfx.data.size() > 0, "ring resonance hum sound buffer empty")

	var paint_recall_sfx := ProceduralAudio.create_paint_memory_recall_sound()
	_expect(paint_recall_sfx != null, "paint memory recall sound synthesis failed")
	_expect(paint_recall_sfx.data.size() > 0, "paint memory recall sound buffer empty")

	var bio_erasure_sfx := ProceduralAudio.create_biographical_erasure_glitch_sound()
	_expect(bio_erasure_sfx != null, "biographical erasure glitch sound synthesis failed")
	_expect(bio_erasure_sfx.data.size() > 0, "biographical erasure glitch sound buffer empty")

	var door_release_22_sfx := ProceduralAudio.create_station22_door_release_sound()
	_expect(door_release_22_sfx != null, "station 22 door release sound synthesis failed")
	_expect(door_release_22_sfx.data.size() > 0, "station 22 door release sound buffer empty")

	var designer_terminal_sfx := ProceduralAudio.create_designer_terminal_hum_sound()
	_expect(designer_terminal_sfx != null, "designer terminal hum sound synthesis failed")
	_expect(designer_terminal_sfx.data.size() > 0, "designer terminal hum sound buffer empty")

	var cursor_shift_sfx := ProceduralAudio.create_cursor_shift_glitch_sound()
	_expect(cursor_shift_sfx != null, "cursor shift glitch sound synthesis failed")
	_expect(cursor_shift_sfx.data.size() > 0, "cursor shift glitch sound buffer empty")

	var burden_ledger_sfx := ProceduralAudio.create_burden_ledger_scan_sound()
	_expect(burden_ledger_sfx != null, "burden ledger scan sound synthesis failed")
	_expect(burden_ledger_sfx.data.size() > 0, "burden ledger scan sound buffer empty")

	var designer_note_sfx := ProceduralAudio.create_designer_note_chime_sound()
	_expect(designer_note_sfx != null, "designer note chime sound synthesis failed")
	_expect(designer_note_sfx.data.size() > 0, "designer note chime sound buffer empty")

	var door_release_23_sfx := ProceduralAudio.create_station23_exit_unlatch_sound()
	_expect(door_release_23_sfx != null, "station 23 exit unlatch sound synthesis failed")
	_expect(door_release_23_sfx.data.size() > 0, "station 23 exit unlatch sound buffer empty")

	var anesthetic_hum_sfx := ProceduralAudio.create_anesthetic_hum_sound()
	_expect(anesthetic_hum_sfx != null, "anesthetic hum sound synthesis failed")
	_expect(anesthetic_hum_sfx.data.size() > 0, "anesthetic hum sound buffer empty")

	var sedation_monitor_sfx := ProceduralAudio.create_sedation_monitor_blip_sound()
	_expect(sedation_monitor_sfx != null, "sedation monitor blip sound synthesis failed")
	_expect(sedation_monitor_sfx.data.size() > 0, "sedation monitor blip sound buffer empty")

	var erased_glitch_sfx := ProceduralAudio.create_erased_name_glitch_sound()
	_expect(erased_glitch_sfx != null, "erased name glitch sound synthesis failed")
	_expect(erased_glitch_sfx.data.size() > 0, "erased name glitch sound buffer empty")

	var airlock_21_sfx := ProceduralAudio.create_station21_airlock_sound()
	_expect(airlock_21_sfx != null, "station 21 airlock sound synthesis failed")
	_expect(airlock_21_sfx.data.size() > 0, "station 21 airlock sound buffer empty")

	var crayon_rustle_sfx := ProceduralAudio.create_crayon_drawing_rustle_sound()
	_expect(crayon_rustle_sfx != null, "crayon drawing rustle sound synthesis failed")
	_expect(crayon_rustle_sfx.data.size() > 0, "crayon drawing rustle sound buffer empty")

	var well_drip_sfx := ProceduralAudio.create_well_water_drip_sound()
	_expect(well_drip_sfx != null, "well water drip sound synthesis failed")
	_expect(well_drip_sfx.data.size() > 0, "well water drip sound buffer empty")

	var szymon_blip_sfx := ProceduralAudio.create_szymon_dialogue_blip_sound()
	_expect(szymon_blip_sfx != null, "szymon dialogue blip sound synthesis failed")
	_expect(szymon_blip_sfx.data.size() > 0, "szymon dialogue blip sound buffer empty")

	var door_shift_sfx := ProceduralAudio.create_door_creak_shift_sound()
	_expect(door_shift_sfx != null, "door creak shift sound synthesis failed")
	_expect(door_shift_sfx.data.size() > 0, "door creak shift sound buffer empty")

	var model_table_sfx := ProceduralAudio.create_model_table_resonance_sound()
	_expect(model_table_sfx != null, "model table resonance sound synthesis failed")
	_expect(model_table_sfx.data.size() > 0, "model table resonance sound buffer empty")

	var map_rustle_sfx := ProceduralAudio.create_paper_map_rustle_sound()
	_expect(map_rustle_sfx != null, "paper map rustle sound synthesis failed")
	_expect(map_rustle_sfx.data.size() > 0, "paper map rustle sound buffer empty")

	var ledger_page_sfx := ProceduralAudio.create_ledger_page_turn_sound()
	_expect(ledger_page_sfx != null, "ledger page turn sound synthesis failed")
	_expect(ledger_page_sfx.data.size() > 0, "ledger page turn sound buffer empty")

	var model_door_sfx := ProceduralAudio.create_model_room_door_release_sound()
	_expect(model_door_sfx != null, "model room door release sound synthesis failed")
	_expect(model_door_sfx.data.size() > 0, "model room door release sound buffer empty")

	var ticket_dispenser_sfx := ProceduralAudio.create_dispenser_ticket_sound()
	_expect(ticket_dispenser_sfx != null, "ticket dispenser sound synthesis failed")
	_expect(ticket_dispenser_sfx.data.size() > 0, "ticket dispenser sound buffer empty")

	var clinic_chime_sfx := ProceduralAudio.create_clinic_intercom_chime_sound()
	_expect(clinic_chime_sfx != null, "clinic intercom chime sound synthesis failed")
	_expect(clinic_chime_sfx.data.size() > 0, "clinic intercom chime sound buffer empty")

	var pneumatic_tube_sfx := ProceduralAudio.create_pneumatic_tube_whoosh_sound()
	_expect(pneumatic_tube_sfx != null, "pneumatic tube whoosh sound synthesis failed")
	_expect(pneumatic_tube_sfx.data.size() > 0, "pneumatic tube whoosh sound buffer empty")

	var wierzbicka_printer_sfx := ProceduralAudio.create_wierzbicka_printer_sound()
	_expect(wierzbicka_printer_sfx != null, "wierzbicka printer sound synthesis failed")
	_expect(wierzbicka_printer_sfx.data.size() > 0, "wierzbicka printer sound buffer empty")

	var galvanometer_tick_sfx := ProceduralAudio.create_sensory_galvanometer_tick_sound()
	_expect(galvanometer_tick_sfx != null, "sensory galvanometer tick sound synthesis failed")
	_expect(galvanometer_tick_sfx.data.size() > 0, "sensory galvanometer tick sound buffer empty")

	var strain_groan_sfx := ProceduralAudio.create_substructure_strain_groan_sound()
	_expect(strain_groan_sfx != null, "substructure strain groan sound synthesis failed")
	_expect(strain_groan_sfx.data.size() > 0, "substructure strain groan sound buffer empty")

	var map_pulse_sfx := ProceduralAudio.create_map_node_pulse_sound()
	_expect(map_pulse_sfx != null, "map node pulse sound synthesis failed")
	_expect(map_pulse_sfx.data.size() > 0, "map node pulse sound buffer empty")

	var stamp_sfx := ProceduralAudio.create_wierzbicka_stamp_sound()
	_expect(stamp_sfx != null, "wierzbicka stamp sound synthesis failed")
	_expect(stamp_sfx.data.size() > 0, "wierzbicka stamp sound buffer empty")

	var cup_clink_sfx := ProceduralAudio.create_ceramic_cup_clink_sound()
	_expect(cup_clink_sfx != null, "ceramic cup clink sound synthesis failed")
	_expect(cup_clink_sfx.data.size() > 0, "ceramic cup clink sound buffer empty")

	var tea_pour_sfx := ProceduralAudio.create_tea_pour_steam_sound()
	_expect(tea_pour_sfx != null, "tea pour steam sound synthesis failed")
	_expect(tea_pour_sfx.data.size() > 0, "tea pour steam sound buffer empty")

	var clock_tick_sfx := ProceduralAudio.create_kitchen_clock_tick_sound()
	_expect(clock_tick_sfx != null, "kitchen clock tick sound synthesis failed")
	_expect(clock_tick_sfx.data.size() > 0, "kitchen clock tick sound buffer empty")

	var dossier_paper_sfx := ProceduralAudio.create_dossier_paper_turn_sound()
	_expect(dossier_paper_sfx != null, "dossier paper turn sound synthesis failed")
	_expect(dossier_paper_sfx.data.size() > 0, "dossier paper turn sound buffer empty")

	var catwalk_step_sfx := ProceduralAudio.create_catwalk_footstep_sound()
	_expect(catwalk_step_sfx != null, "catwalk footstep sound synthesis failed")
	_expect(catwalk_step_sfx.data.size() > 0, "catwalk footstep sound buffer empty")

	var water_drip_sfx := ProceduralAudio.create_water_drip_puddle_sound()
	_expect(water_drip_sfx != null, "water drip puddle sound synthesis failed")
	_expect(water_drip_sfx.data.size() > 0, "water drip puddle sound buffer empty")

	var pressure_valve_sfx := ProceduralAudio.create_pressure_valve_release_sound()
	_expect(pressure_valve_sfx != null, "pressure valve release sound synthesis failed")
	_expect(pressure_valve_sfx.data.size() > 0, "pressure valve release sound buffer empty")

	var resonance_pulse_sfx := ProceduralAudio.create_resonance_pulse_sound()
	_expect(resonance_pulse_sfx != null, "resonance pulse sound synthesis failed")
	_expect(resonance_pulse_sfx.data.size() > 0, "resonance pulse sound buffer empty")

	var scratch_chime_sfx := ProceduralAudio.create_metal_scratch_chime_sound()
	_expect(scratch_chime_sfx != null, "metal scratch chime sound synthesis failed")
	_expect(scratch_chime_sfx.data.size() > 0, "metal scratch chime sound buffer empty")

	var tape_degrad_sfx := ProceduralAudio.create_tape_degradation_filter_sound()
	_expect(tape_degrad_sfx != null, "tape degradation filter sound synthesis failed")
	_expect(tape_degrad_sfx.data.size() > 0, "tape degradation filter sound buffer empty")

	var seam_clamp_sfx := ProceduralAudio.create_seam_clamp_sound()
	_expect(seam_clamp_sfx != null, "seam clamp sound synthesis failed")
	_expect(seam_clamp_sfx.data.size() > 0, "seam clamp sound buffer empty")

	var conduit_wind_sfx := ProceduralAudio.create_conduit_shaft_wind_sound()
	_expect(conduit_wind_sfx != null, "conduit shaft wind sound synthesis failed")
	_expect(conduit_wind_sfx.data.size() > 0, "conduit shaft wind sound buffer empty")

	var drafting_lamp_sfx := ProceduralAudio.create_drafting_lamp_hum_sound()
	_expect(drafting_lamp_sfx != null, "drafting lamp hum sound synthesis failed")
	_expect(drafting_lamp_sfx.data.size() > 0, "drafting lamp hum sound buffer empty")

	var photo_slide_sfx := ProceduralAudio.create_photo_slide_sound()
	_expect(photo_slide_sfx != null, "photo slide sound synthesis failed")
	_expect(photo_slide_sfx.data.size() > 0, "photo slide sound buffer empty")

	var shadow_whisper_sfx := ProceduralAudio.create_shadow_whisper_sound()
	_expect(shadow_whisper_sfx != null, "shadow whisper sound synthesis failed")
	_expect(shadow_whisper_sfx.data.size() > 0, "shadow whisper sound buffer empty")

	var relay_click_sfx := ProceduralAudio.create_relay_alignment_click_sound()
	_expect(relay_click_sfx != null, "relay alignment click sound synthesis failed")
	_expect(relay_click_sfx.data.size() > 0, "relay alignment click sound buffer empty")

	var subway_hum_sfx := ProceduralAudio.create_subway_hum_sound()
	_expect(subway_hum_sfx != null, "subway hum sound synthesis failed")
	_expect(subway_hum_sfx.data.size() > 0, "subway hum sound buffer empty")

	var neon_flicker_sfx := ProceduralAudio.create_neon_flicker_sound()
	_expect(neon_flicker_sfx != null, "neon flicker sound synthesis failed")
	_expect(neon_flicker_sfx.data.size() > 0, "neon flicker sound buffer empty")

	var terminal_key_sfx := ProceduralAudio.create_terminal_keypress_sound()
	_expect(terminal_key_sfx != null, "terminal keypress sound synthesis failed")
	_expect(terminal_key_sfx.data.size() > 0, "terminal keypress sound buffer empty")

	var pa_chime_sfx := ProceduralAudio.create_pa_chime_sound()
	_expect(pa_chime_sfx != null, "pa chime sound synthesis failed")
	_expect(pa_chime_sfx.data.size() > 0, "pa chime sound buffer empty")

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

	var morning_ambience := ProceduralAudio.create_morning_ambience_sound()
	_expect(morning_ambience != null, "morning ambience sound synthesis failed")
	_expect(morning_ambience.data.size() > 0, "morning ambience sound buffer empty")

	var ucp_stabilizer := ProceduralAudio.create_ucp_stabilizer_beam_sound()
	_expect(ucp_stabilizer != null, "ucp stabilizer beam sound synthesis failed")
	_expect(ucp_stabilizer.data.size() > 0, "ucp stabilizer beam sound buffer empty")

	var masonry_smooth := ProceduralAudio.create_masonry_smooth_sound()
	_expect(masonry_smooth != null, "masonry smooth sound synthesis failed")
	_expect(masonry_smooth.data.size() > 0, "masonry smooth sound buffer empty")

	var blip_elderly := ProceduralAudio.create_dialogue_elderly_woman_sound()
	_expect(blip_elderly != null, "dialogue elderly woman blip synthesis failed")
	_expect(blip_elderly.data.size() > 0, "dialogue elderly woman blip buffer empty")




func _cross_exit(station: Node) -> void:
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_ThresholdBinder.install(station)
	if bool(_ThresholdBinder.complete_from_test(station, player)):
		await physics_frame
		if bool(station.get("is_level_completed")):
			return
	if bool(station.get("is_level_completed")):
		return
	if station.has_method("_trigger_level_completion"):
		station.call("_trigger_level_completion")
		await physics_frame
		if bool(station.get("is_level_completed")):
			return
	if player != null:
		var airlock := station.get_node_or_null("AirlockZone") as Area2D
		if airlock != null:
			player.global_position = airlock.global_position
		await physics_frame
		await physics_frame


func _test_station_01() -> void:
	var packed_station := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed_station != null, "station_01 scene does not load")
	if packed_station == null:
		return
	var station := packed_station.instantiate() as Station01
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_01: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_01: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_01: props node missing")
	_expect(station.get_node_or_null("ChamberDoor") != null, "station_01: chamber door missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_01: airlock zone missing")
	_expect(station.repeat_line_four_measurement(), "station_01: Line 4 measurement must register")
	_expect(station.secure_raw_sample(), "station_01: raw sample must register after measurement")
	_expect(station.read_marta_message(), "station_01: Marta message must commit the delay")
	_expect(station.get("is_exit_unlocked") == true, "station_01: exit must unlock after message")
	await _cross_exit(station)
	_expect(station.is_level_completed, "Station 01 level should complete on entering airlock")
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
	_expect(station.get_node_or_null("Player") != null, "station_02: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_02: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_02: props node missing")
	_expect(station.inspect_detour_closure(), "station_02: detour closure must register")
	_expect(station.compare_detour_time(), "station_02: detour time must register")
	_expect(station.take_service_ladder(), "station_02: service ladder route must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_02: exit must unlock after bypass")
	await _cross_exit(station)
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
	_expect(station.get_node_or_null("Player") != null, "station_03: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_03: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_03: props node missing")
	_expect(station.get_node_or_null("TransitDoor") != null, "station_03: transit door missing")
	_expect(station.get_node_or_null("ReturnZone") != null, "station_03: return zone missing")
	_expect(station.read_departure_board(), "station_03: departure time must register")
	_expect(station.reply_to_marta(), "station_03: time notice must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_03: exit must unlock after notice")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player:
		player.global_position = Vector2(15.0, 238.0)
		await physics_frame
		await physics_frame
	_expect(not station.is_level_completed, "station_03 must NOT complete at the ReturnZone")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_03 must complete through ThresholdZone")
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
	_expect(station.get_node_or_null("Player") != null, "station_04: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_04: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_04: props node missing")
	_expect(station.get_node_or_null("ExitDoors") != null, "station_04: exit doors missing")
	_expect(station.observe_reader_buffer(), "station_04: reader repeat must register")
	_expect(station.watch_line_four_memorial(), "station_04: Line 4 memorial must register")
	_expect(station.stow_reader_for_marta(), "station_04: reader must be stowed for Marta")
	_expect(station.get("is_exit_unlocked") == true, "station_04: exit must unlock after trial")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_04 must complete on entering the AirlockZone")
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
	_expect(station.get_node_or_null("Player") != null, "station_05: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_05: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_05: props node missing")
	_expect(station.observe_ordinary_street(), "station_05: ordinary street must register")
	_expect(station.secure_reader_state(), "station_05: reader state must be secured")
	_expect(station.get("is_exit_unlocked") == true, "station_05: exit must unlock after reader secured")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_05 must complete on entering the AirlockZone")
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
	_expect(station.get_node_or_null("Player") != null, "station_06: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_06: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_06: props node missing")
	_expect(station.observe_paper_timetable(), "station_06: paper timetable must register")
	_expect(station.observe_offline_route(), "station_06: offline route must register")
	_expect(station.compare_public_route(), "station_06: public route comparison must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_06: exit must unlock after comparison")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_06 must complete on entering the AirlockZone")
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
	_expect(station.get_node_or_null("Player") != null, "station_07: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_07: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_07: props node missing")
	_expect(station.compare_address_document(), "station_07: compare address document must register")
	_expect(station.inspect_intercom_directory(), "station_07: inspect intercom directory must register")
	_expect(station.enter_intercom_code(), "station_07: enter intercom code must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_07: exit must unlock after commitment")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_07 must complete on entering the AirlockZone")
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
	_expect(station.get_node_or_null("Player") != null, "station_08: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_08: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_08: props node missing")
	_expect(station.get_node_or_null("ApartmentDoor14") != null, "station_08: apartment door missing")
	_expect(station.inspect_floor_twelve(), "station_08: door twelve check must register")
	_expect(station.speak_with_neighbour(), "station_08: neighbour testimony must register")
	_expect(station.unlock_apartment_fourteen(), "station_08: key unlock must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_08: exit must unlock after key unlock")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_08 must complete on entering the AirlockZone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_09() -> void:
	var packed_station := load("res://scenes/levels/station_09.tscn") as PackedScene
	_expect(packed_station != null, "station_09 scene does not load")
	if packed_station == null:
		return
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.record_decision(&"p7.address_and_record.trace", "address_source_observed")
	var station := packed_station.instantiate() as Station09
	root.add_child(station)
	await physics_frame
	var planter := station.get_node_or_null("Geometry/StairwellPlanter") as MovableAnchorableProp
	_expect(planter != null, "station_09: planter missing")
	_expect(station.observe_floor_record(), "station_09: floor record must register")
	if planter:
		for frame in range(220):
			station.push_planter(1.0)
			await physics_frame
	_expect(station.get("is_passage_clear") == true, "station_09: planter must clear the passage")
	_expect(station.ask_neighbour_without_leading(), "station_09: neighbour question must register")
	_expect(station.get("is_exit_unlocked") == true, "station_09: exit must unlock after neighbour")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_09 must complete on entering the AirlockZone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_10() -> void:
	var packed_station := load("res://scenes/levels/station_10.tscn") as PackedScene
	_expect(packed_station != null, "station_10 scene does not load")
	if packed_station == null:
		return
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.record_decision(&"p9.threshold_obstacle.foreign_daily_life.neighbour_account", "twelve_lower_fourteen_home")
	var station := packed_station.instantiate() as Station10
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_10: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_10: camera missing")
	_expect(station.get_node_or_null("Geometry/ApartmentDoor14") != null, "station_10: apartment door missing")
	_expect(station.inspect_key_wear(), "station_10: key wear must register")
	_expect(station.test_key_without_claiming_home(), "station_10: key trial must commit")
	_expect(station.commit_cautious_entry(), "station_10: cautious entry must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_10: exit must unlock after cautious entry")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_10 must complete on entering the AirlockZone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_11() -> void:
	var packed_station := load("res://scenes/levels/station_11.tscn") as PackedScene
	_expect(packed_station != null, "station_11 scene does not load")
	if packed_station == null:
		return
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.record_decision(&"p9.threshold_obstacle.foreign_daily_life.key_trial_result", "key_matches_foreign_history")
	var station := packed_station.instantiate() as Station11
	root.add_child(station)
	await physics_frame
	var sideboard := station.get_node_or_null("Geometry/HallwaySideboard") as MovableAnchorableProp
	_expect(sideboard != null, "station_11: sideboard missing")
	if sideboard:
		for frame in range(160):
			station.push_sideboard(1.0)
			await physics_frame
	_expect(station.get("is_passage_clear") == true, "station_11: sideboard must clear the passage")
	_expect(station.inspect_private_photograph(), "station_11: photograph must register")
	_expect(station.inspect_equipment_wear(), "station_11: equipment wear must register")
	_expect(station.inspect_reader_arrangement(), "station_11: reader arrangement must register")
	_expect(station.compare_private_material(), "station_11: private material comparison must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_11: exit must unlock after respect")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_11 must complete on entering the AirlockZone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_12() -> void:
	var packed_station := load("res://scenes/levels/station_12.tscn") as PackedScene
	_expect(packed_station != null, "station_12 scene does not load")
	if packed_station == null:
		return
	var station := packed_station.instantiate() as Station12
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_12: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_12: camera missing")
	_expect(station.get_node_or_null("Geometry/BalconyDoor") != null, "station_12: balcony door missing")
	_expect(not station.listen_to_message(), "station_12: open balcony must muffle the playback")
	_expect(station.close_balcony(), "station_12: balcony must close")
	_expect(station.listen_to_message(), "station_12: message must play after closing")
	_expect(station.verify_caller_identity(), "station_12: caller must verify")
	_expect(station.prepare_independent_questions(), "station_12: questions must be prepared")
	_expect(station.get("is_exit_unlocked") == true, "station_12: exit must unlock after questions")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_12 must complete on entering the AirlockZone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_13() -> void:
	var packed_station := load("res://scenes/levels/station_13.tscn") as PackedScene
	_expect(packed_station != null, "station_13 scene does not load")
	if packed_station == null:
		return
	var station := packed_station.instantiate() as Station13
	root.add_child(station)
	await physics_frame
	var drawer := station.get_node_or_null("Geometry/DeskDrawer") as AnimatableBody2D
	_expect(drawer != null, "station_13: drawer missing")
	_expect(station.observe_field_certificate(), "station_13: field certificate must register")
	_expect(station.open_drawer(), "station_13: drawer must open")
	_expect(station.observe_tenancy_contract(), "station_13: tenancy contract must register")
	_expect(station.verify_document_independence(), "station_13: seals must verify")
	_expect(station.compare_document_versions(), "station_13: document comparison must commit")
	_expect(station.request_independent_description(), "station_13: independent description request must commit")
	_expect(station.get("is_exit_unlocked") == true, "station_13: exit must unlock after request")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_13 must complete on entering the AirlockZone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_14() -> void:
	var packed_station := load("res://scenes/levels/station_14.tscn") as PackedScene
	_expect(packed_station != null, "station_14 scene does not load")
	if packed_station == null:
		return
	var station := packed_station.instantiate() as Station14
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_14: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_14: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_14: props node missing")
	_expect(station.get_node_or_null("Machine/TractionBridge") != null, "station_14: dead-circuit bridge missing")
	_expect(station.is_section_live(), "station_14: neutral state must keep section live")
	station.release_observed_element()
	station.run_correction_pulse()
	_expect(not station.is_section_live(), "station_14: released bridge must take version B")
	_expect(not bool(station.get("is_level_completed")), "station_14: yield alone must not complete the station")
	station.hold_observed_element()
	station.run_correction_pulse()
	_expect(not station.is_section_live(), "station_14: held version B stays frozen without penalty")
	_expect(station.get("is_exit_unlocked") == true, "station_14: exit must unlock after both behaviors")
	station.release_observed_element()
	station.run_correction_pulse()
	_expect(station.is_section_live(), "station_14: released wave must safely return version A")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station_14 must complete on entering the AirlockZone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _seed_s06_entry() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.marta_threshold.trace", "relationship_difference_explicit")
	return state


func _test_station_15() -> void:
	var packed_station := load("res://scenes/levels/station_15.tscn") as PackedScene
	_expect(packed_station != null, "station 15 scene does not load")
	if packed_station == null:
		return
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.marta_threshold.trace", "dead_circuit_lesson_observed")
	var station := packed_station.instantiate() as Station15
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station 15: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station 15: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station 15: props node missing")
	_expect(not station.send_corrective_impulse(), "station 15: error impulse without two controls must stay safe")
	_expect(station.observe_signal_log(), "station 15: loop log must reconstruct")
	_expect(station.send_control_impulse(), "station 15: first control impulse must send")
	station.run_response_cycle()
	_expect(station.send_control_impulse(), "station 15: second control impulse must send")
	station.run_response_cycle()
	_expect(station.send_corrective_impulse(), "station 15: deliberate-error impulse must send after controls")
	station.run_response_cycle()
	_expect(station.read_abort_note(), "station 15: abort note must read after confirmation")
	_expect(station.get("is_exit_unlocked") == true, "station 15: exit must unlock after the note")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 15 must complete upon entering airlock zone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_16() -> void:
	var packed_station := load("res://scenes/levels/station_16.tscn") as PackedScene
	_expect(packed_station != null, "station 16 scene does not load")
	if packed_station == null:
		return
	var state := _seed_s06_entry()
	if state:
		state.record_decision(&"p7.work_history_and_record.own_record_requested", true)
	var station := packed_station.instantiate() as Station16
	root.add_child(station)
	await physics_frame
	_expect(not station.confirm_home_echo(), "station 16: echo without a cost choice must stay safe")
	_expect(not station.choose_marta_memory_cost(), "station 16: cost without transferred response must stay safe")
	_expect(station.transfer_response_to_safe_analyzer(), "station 16: response must transfer to analyzer")
	_expect(station.choose_marta_memory_cost(), "station 16: Marta memory cost must be selectable")
	_expect(station.confirm_home_echo(), "station 16: home echo must confirm after the choice")
	_expect(station.get("is_exit_unlocked") == true, "station 16: exit must unlock after the trial")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 16 must complete upon entering airlock zone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_17() -> void:
	var packed_station := load("res://scenes/levels/station_17.tscn") as PackedScene
	_expect(packed_station != null, "station 17 scene does not load")
	if packed_station == null:
		return
	var state := _seed_s06_entry()
	if state:
		state.record_decision(&"p7.work_history_and_record.institution_trial_result", "small_cost_and_home_echo_confirmed")
		state.record_decision(&"p9.mechanics.small_cost.home_echo_verified", true)
		state.record_decision(&"mechanic_cost_observed", true)
	var station := packed_station.instantiate() as Station17
	root.add_child(station)
	await physics_frame
	_expect(not station.record_jakub_consent_granted(), "station 17: consent before ledger must stay safe")
	_expect(station.read_cost_ledger(), "station 17: cost ledger must be read")
	_expect(station.reject_adaptation_offer(), "station 17: adaptation offer must be rejected")
	_expect(station.record_jakub_consent_limited(), "station 17: consent scope must be recorded")
	if state:
		_expect(state.decisions.get(&"ucp_cost_ledger_found", false) == true, "station 17: canonical cost ledger must be set")
		_expect(state.decisions.get(&"jakub_consent_state", "") == "limited", "station 17: consent state must be explicit")
	_expect(station.get("is_exit_unlocked") == true, "station 17: exit must unlock after the consent scope")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 17 must complete upon entering airlock zone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _seed_s07_entry() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.work_history_and_record.trace", "cost_ledger_and_consent_scope_recorded")
		state.record_decision(&"p9.consent_and_cost.cost_ledger_read", true)
		state.record_decision(&"p9.consent_and_cost.adaptation_offer", "rejected")
		state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "limited")
		state.record_decision(&"jakub_consent_state", "limited")
	return state


func _test_station_18() -> void:
	var packed_station := load("res://scenes/levels/station_18.tscn") as PackedScene
	_expect(packed_station != null, "station 18 scene does not load")
	if packed_station == null:
		return
	_seed_s07_entry()
	var station := packed_station.instantiate() as Station18
	root.add_child(station)
	await physics_frame
	# PKG-0230 (P0-1, S-02): commit bez zestawienia/prawdy i bez zakresu
	# nie przechodzi (limited seed nie domyka force_home).
	_expect(not station.commit_force_home(), "station 18: commit without inventory must stay blocked")
	_expect(station.compare_forecast_consent_dependencies(), "station 18: three forecasts must be compared")
	_expect(station.disclose_marta_truth_partial(), "station 18: Marta truth state must be recorded")
	_expect(station.commit_close_equal(), "station 18: allowed method must commit")
	_expect(station.is_method_committed, "station 18: one method must be committed")
	_expect(station.get("is_exit_unlocked") == true, "station 18: exit must unlock after method_committed")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 18 must complete upon entering airlock zone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_19() -> void:
	var packed_station := load("res://scenes/levels/station_19.tscn") as PackedScene
	_expect(packed_station != null, "station 19 scene does not load")
	if packed_station == null:
		return
	var state := _seed_s07_entry()
	if state:
		state.record_decision(&"p7.three_place_proofs.public_trial_result", "two_systems_and_nine_years")
	var station := packed_station.instantiate() as Station19
	root.add_child(station)
	await physics_frame
	_expect(not station.compare_control_answers(), "station 19: comparison without answers must stay safe")
	_expect(station.shield_microphone(), "station 19: microphone must be shielded")
	_expect(station.prepare_control_questions(), "station 19: control questions must be prepared")
	_expect(station.answer_payphone(), "station 19: payphone must be answered")
	_expect(station.ask_control_questions(), "station 19: both control questions must be asked")
	_expect(station.compare_control_answers(), "station 19: voice trial must resolve")
	_expect(station.get("is_exit_unlocked") == true, "station 19: exit must unlock after the voice trial")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 19 must complete upon entering airlock zone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_20() -> void:
	var packed_station := load("res://scenes/levels/station_20.tscn") as PackedScene
	_expect(packed_station != null, "station_20 scene does not load")
	if packed_station == null:
		return
	var state := _seed_s07_entry()
	if state:
		state.record_decision(&"p7.three_place_proofs.voice_trial_result", "impostor_and_recording_insufficient")
	var station := packed_station.instantiate() as Station20
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_20: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_20: camera missing")
	_expect(station.get_node_or_null("Geometry") != null, "station_20: geometry missing")
	_expect(station.get_node_or_null("Props") != null, "station_20: props node missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_20: airlock zone missing")
	_expect(station.move_parts_trolley(), "station 20: parts trolley must move")
	_expect(station.confirm_marta_presence(), "station 20: Marta must be present as witness")
	_expect(station.meet_jakub_face_to_face(), "station 20: Jakub must be met face to face")
	_expect(not station.request_voluntary_reader_scan(), "station 20: scan before accepting refusal must stay safe")
	_expect(station.accept_scar_refusal(), "station 20: the scar refusal must be accepted")
	_expect(station.request_voluntary_reader_scan(), "station 20: Jakub must volunteer the reader scan")
	_expect(station.compare_local_service_base(), "station 20: relational trial must resolve")
	_expect(station.get("is_exit_unlocked") == true, "station 20: exit must unlock after the relational trial")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 20 must complete upon entering airlock zone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_21() -> void:
	var packed_station := load("res://scenes/levels/station_21.tscn") as PackedScene
	_expect(packed_station != null, "station_21 scene does not load")
	if packed_station == null:
		return
	var state := _seed_s07_entry()
	if state:
		state.record_decision(&"recognition_evidence_carried", true)
		state.record_decision(&"recognition_evidence_public", true)
		state.record_decision(&"recognition_evidence_relational", true)
	var station := packed_station.instantiate() as Station21
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_21: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_21: camera missing")
	_expect(station.get_node_or_null("Geometry") != null, "station_21: geometry missing")
	_expect(station.get_node_or_null("Props") != null, "station_21: props node missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_21: airlock zone missing")
	_expect(not station.execute_three_family_synthesis(), "station 21: synthesis without three families must stay safe")
	_expect(station.place_reader_and_sample(), "station 21: reader and sample must be placed")
	_expect(station.place_public_records(), "station 21: public records must be placed")
	_expect(not station.get("is_synthesis_done"), "station 21: two families must not run the synthesis")
	_expect(station.place_relational_record(), "station 21: relational record must be placed")
	_expect(not station.get("is_synthesis_done"), "station 21: the third placement must not auto-run the synthesis")
	_expect(station.execute_three_family_synthesis(), "station 21: explicit synthesis must resolve")
	_expect(station.is_world_recognized, "station 21: world recognized after the executed synthesis")
	_expect(station.get("is_local_search_committed") == true, "station 21: the second goal must be accepted with recognition")
	_expect(station.get("is_exit_unlocked") == true, "station 21: exit must unlock after the synthesis")
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 21 must complete upon entering airlock zone")
	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_22() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"world_recognized", true)
	var packed := load("res://scenes/levels/station_22.tscn") as PackedScene
	_expect(packed != null, "station 22 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station22
	root.add_child(station)
	await physics_frame
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "station 22: player missing")
	_expect(station.get_node_or_null("Camera") is CinematicCamera, "station 22: camera missing")
	_expect(station.get_node_or_null("Geometry") != null, "station 22: geometry missing")
	_expect(station.get_node_or_null("Props") != null, "station 22: props missing")
	_expect(station.observe_signal_echo(), "station 22: echo must be observable")
	_expect(station.observe_adjacent_state(), "station 22: adjacent state must be observable")
	_expect(station.is_hypotheses_opened, "station 22: two observations must open hypotheses")
	if state:
		_expect(state.decisions.has(&"p7.mutual_test.signal_echo_observed"), "station 22: echo fact must persist")
		_expect(state.decisions.has(&"p7.mutual_test.adjacent_state_observed"), "station 22: adjacent response fact must persist")
		_expect(not state.decisions.has(&"mechanic_cost_observed"), "station 22: cost must remain unknown")
	if player:
		player.global_position = Vector2(590.0, 240.0)
		for _frame in range(5):
			await physics_frame
		_expect(station.is_level_completed, "station 22 must complete after its diagnostic observations")
	station.queue_free()
	for _frame in range(4):
		await process_frame


func _test_station_23() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"world_recognized", true)
		state.record_decision(&"p7.mutual_test.signal_echo_observed", true)
		state.record_decision(&"p7.mutual_test.adjacent_state_observed", true)
	var packed := load("res://scenes/levels/station_23.tscn") as PackedScene
	_expect(packed != null, "station_23 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station23
	root.add_child(station)
	await physics_frame
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "station_23: player missing")
	_expect(station.get_node_or_null("AnchorExclusivityController") is AnchorExclusivityController, "station_23: local exclusivity controller missing")
	_expect(station.perform_anchor_trial(), "station 23: Anchor trial must execute")
	_expect(station.perform_yield_trial(), "station 23: Yield trial must execute")
	_expect(station.is_cost_understood, "station 23: mechanic cost understood after a real trial")
	if state:
		_expect(state.decisions.get(&"p7.mutual_test.dead_circuit_outcome", "") == "yield", "station 23: Yield outcome persisted")
		_expect(state.decisions.has(&"mechanic_cost_observed"), "station 23: canonical cost fact persisted")
	if player:
		player.global_position = Vector2(590.0, 240.0)
		for _frame in range(5):
			await physics_frame
		_expect(station.is_level_completed, "station 23 must complete upon entering airlock zone")
	station.queue_free()
	for _frame in range(4):
		await process_frame


func _test_station_24() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"mechanic_cost_observed", true)
	var packed := load("res://scenes/levels/station_24.tscn") as PackedScene
	_expect(packed != null, "station_24 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station24
	root.add_child(station)
	await physics_frame
	var player := station.get_node_or_null("Player") as PrototypePlayer
	var props := station.get_node_or_null("Props") as Node2D
	_expect(player != null, "station_24: player missing")
	_expect(station.get_node_or_null("Camera") is CinematicCamera, "station_24: camera missing")
	_expect(props != null, "station_24: props node missing")
	_expect(not station.choose_limited_access(), "station_24: access cannot precede disclosure")
	_expect(station.disclose_marta_scope(), "station_24: scope must be disclosed")
	_expect(station.disclose_marta_risk(), "station_24: risk must be disclosed")
	_expect(station.disclose_marta_cost(), "station_24: cost must be disclosed")
	_expect(station.choose_declined(), "station_24: declined boundary must be commit-able")
	_expect(station.is_exit_unlocked, "station_24: either explicit boundary must unlock the technical route")
	if state:
		_expect(state.decisions.get(&"p7.mutual_test.marta_boundary", "") == "declined", "station_24: declined boundary must persist")
		_expect(state.decisions.get(&"marta_boundary_accepted", false), "station_24: shared goal must preserve boundary acceptance")
	if player:
		player.global_position = Vector2(610.0, 245.0)
		for _frame in range(5):
			await physics_frame
		_expect(station.is_level_completed, "station 24 must complete upon entering airlock zone")
	station.queue_free()
	for _frame in range(4):
		await process_frame
func _test_station_25() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.mutual_test.marta_boundary", "limited_access")
	var packed := load("res://scenes/levels/station_25.tscn") as PackedScene
	_expect(packed != null, "station_25 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station25
	root.add_child(station)
	await physics_frame
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "station_25: player missing")
	_expect(station.get_node_or_null("Camera") is CinematicCamera, "station_25: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_25: props node missing")
	_expect(station.observe_ventilation_cycle(), "station_25: ventilation cycle must be observed")
	_expect(station.release_interlock(), "station_25: interlock must release after ventilation")
	_expect(station.route_power(), "station_25: power must route after interlock")
	_expect(station.retrieve_ucp_buffer(), "station_25: buffer must be retrievable through infrastructure")
	_expect(station.is_exit_unlocked, "station_25: buffer trace must unlock exit")
	if state:
		_expect(state.decisions.get(&"p7.mutual_test.ucp_buffer_trace", "") == "paired_with_notes", "station_25: limited access trace must persist")
		_expect(not state.decisions.has(&"jakub_consent_state"), "station_25: must not set future Jakub consent")
	if player:
		player.global_position = Vector2(610.0, 245.0)
		for _frame in range(5):
			await physics_frame
		_expect(station.is_level_completed, "station 25 must complete upon entering airlock zone")
	station.queue_free()
	for _frame in range(4):
		await process_frame
func _test_station_26() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.three_place_proofs.trace", "world_recognized_and_search_committed")
	var packed := load("res://scenes/levels/station_26.tscn") as PackedScene
	_expect(packed != null, "station_26 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station26
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_26: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_26: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_26: Props missing")
	_expect(station.get_node_or_null("ReturnZone") != null, "station_26: ReturnZone missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_26: AirlockZone missing")
	_expect(station.observe_interrupted_ucp_log(), "station_26 must observe the interrupted log")
	_expect(station.synchronize_sample_clock(), "station_26 must synchronize the sample clock")
	_expect(station.synchronize_ucp_command_clock(), "station_26 must synchronize the UCP command clock")
	_expect(station.synchronize_local_generator_clock(), "station_26 must synchronize the local generator clock")
	_expect(station.reconstruct_ucp_intervention(), "station_26 must reconstruct the intervention")
	_expect(station.is_ucp_intervention_reconstructed and station.is_exit_unlocked, "station_26 reconstruction must unlock the exit")
	station.queue_free()
	for _i in 4:
		await process_frame


func _test_station_27() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.record_decision(&"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed", true)
	var packed := load("res://scenes/levels/station_27.tscn") as PackedScene
	_expect(packed != null, "station_27 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station27
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_27: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_27: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_27: Props missing")
	_expect(station.get_node_or_null("ReturnZone") != null, "station_27: ReturnZone missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_27: AirlockZone missing")
	_expect(station.calibrate_pulse_reference(), "station_27 must calibrate its pulse reference")
	_expect(station.send_first_identical_pulse(), "station_27 must send the first identical pulse")
	_expect(station.send_second_identical_pulse(), "station_27 must send the second identical pulse")
	_expect(station.send_deliberate_error_pulse(), "station_27 must send the deliberate error pulse")
	_expect(station.compare_response_correction(), "station_27 must compare the selective correction")
	_expect(station.is_response_correction_compared and station.is_exit_unlocked, "station_27 comparison must unlock the exit")
	station.queue_free()
	for _i in 4:
		await process_frame


func _test_station_28() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.record_decision(&"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed", true)
		state.record_decision(&"p7.interrupted_trial_and_small_cost.local_lena_signal_confirmed", true)
	var packed := load("res://scenes/levels/station_28.tscn") as PackedScene
	_expect(packed != null, "station_28 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station28
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_28: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_28: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_28: Props missing")
	_expect(station.get_node_or_null("ReturnZone") != null, "station_28: ReturnZone missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_28: AirlockZone missing")
	_expect(station.observe_transfer_constraint(), "station_28 must observe the transfer constraint")
	_expect(station.inspect_home_sample_trace(), "station_28 must inspect the home trace")
	_expect(station.inspect_local_lena_signal_trace(), "station_28 must inspect the local Lena trace")
	_expect(station.disclose_transfer_price(), "station_28 must disclose the price")
	_expect(station.perform_home_trace_anchor(), "station_28 must apply the Anchor commitment")
	_expect(station.is_commitment_applied and station.is_exit_unlocked, "station_28 commitment must unlock the exit")
	station.queue_free()
	for _i in 4:
		await process_frame


func _test_station_29() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.record_decision(&"p7.interrupted_trial_and_small_cost.trace", "home_trace_anchor")
	var packed := load("res://scenes/levels/station_29.tscn") as PackedScene
	_expect(packed != null, "station_29 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station29
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_29: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_29: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_29: Props missing")
	_expect(station.get_node_or_null("ReturnZone") != null, "station_29: ReturnZone missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_29: AirlockZone missing")
	_expect(station.inspect_ucp_jakub_contrast_proposal(), "station_29 must inspect the UCP proposal")
	_expect(station.observe_jakub_ordinary_life_scope(), "station_29 must observe Jakub's ordinary life")
	_expect(station.disclose_jakub_signal_risk(), "station_29 must disclose signal risk")
	_expect(station.disable_jakub_transmitter(), "station_29 must disable the transmitter before consent")
	_expect(station.record_jakub_consent(&"refused"), "station_29 must accept a continuing refusal")
	_expect(station.is_jakub_consent_recorded and station.is_exit_unlocked, "station_29 refusal must preserve a route forward")
	station.queue_free()
	for _i in 4:
		await process_frame


func _test_station_30() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.record_decision(&"p7.interrupted_trial_and_small_cost.trace", "home_trace_anchor")
		state.record_decision(&"jakub_consent_state", "refused")
	var packed := load("res://scenes/levels/station_30.tscn") as PackedScene
	_expect(packed != null, "station_30 scene does not load")
	if packed == null:
		return
	var station := packed.instantiate() as Station30
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("Player") != null, "station_30: player missing")
	_expect(station.get_node_or_null("Camera") != null, "station_30: camera missing")
	_expect(station.get_node_or_null("Props") != null, "station_30: Props missing")
	_expect(station.get_node_or_null("ReturnZone") != null, "station_30: ReturnZone missing")
	_expect(station.get_node_or_null("AirlockZone") != null, "station_30: AirlockZone missing")
	_expect(station.build_force_home_forecast(), "station_30 must build force-home")
	_expect(station.build_close_equal_recover_local_forecast(), "station_30 must build close/equal/recover-local")
	_expect(station.build_mutual_passage_forecast(), "station_30 must build mutual-passage")
	_expect(station.compare_forecast_consent_dependencies(), "station_30 must compare consent dependencies")
	_expect(station.are_forecast_consent_dependencies_compared and station.is_exit_unlocked, "station_30 forecast comparison must unlock the exit")
	station.queue_free()
	for _i in 4:
		await process_frame

func _test_station_31() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.jakub_boundary_and_forecasts.trace", "consent_and_forecasts_resolved")
	var packed_station := load("res://scenes/levels/station_31.tscn") as PackedScene
	_expect(packed_station != null, "station_31 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station31
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station_31: player missing")
	_expect(camera != null, "station_31: camera missing")
	_expect(geometry != null, "station_31: geometry missing")
	_expect(props != null, "station_31: props node missing")
	_expect(airlock_zone != null, "station_31: airlock zone missing")

	if props == null or player == null or airlock_zone == null:
		station.queue_free()
		await process_frame
		return

	var chairs_prop := props.get_node_or_null("ElevenChairsRow") as MemoryResonancePoint
	var holo_prop := props.get_node_or_null("WierzbickaHoloterminal") as MemoryResonancePoint
	var twelfth_prop := props.get_node_or_null("JakubTwelfthChair") as MemoryResonancePoint
	var ledger_prop := props.get_node_or_null("VariantChoiceLedger") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station31Exit") as MemoryResonancePoint

	_expect(chairs_prop != null, "ElevenChairsRow prop missing")
	_expect(holo_prop != null, "WierzbickaHoloterminal prop missing")
	_expect(twelfth_prop != null, "JakubTwelfthChair prop missing")
	_expect(ledger_prop != null, "VariantChoiceLedger prop missing")
	_expect(exit_prop != null, "Station31Exit prop missing")

	if chairs_prop == null or holo_prop == null or twelfth_prop == null or ledger_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(chairs_prop.prop_type == 142, "eleven chairs prop_type must be 142")
	_expect(holo_prop.prop_type == 143, "wierzbicka holoterminal prop_type must be 143")
	_expect(twelfth_prop.prop_type == 144, "jakub twelfth chair prop_type must be 144")
	_expect(ledger_prop.prop_type == 145, "variant choice ledger prop_type must be 145")
	_expect(exit_prop.prop_type == 146, "station 31 exit prop_type must be 146")

	_expect(station.inspect_passenger_chairs(), "station 31 must inspect passenger chairs")
	_expect(station.inspect_wierzbicka_proposal(), "station 31 must inspect Wierzbicka proposal")
	_expect(station.inspect_twelfth_chair(), "station 31 must inspect twelfth chair")
	_expect(station.compare_passenger_ledger(), "station 31 must compare passenger ledger")
	_expect(station.reject_adaptation_offer(), "station 31 must reject adaptation offer")
	_expect(station.is_adaptation_rejected and station.is_exit_unlocked, "rejection must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 31 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_32() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.archive_countermodel.adaptation_offer_rejected", true)
	var packed_station := load("res://scenes/levels/station_32.tscn") as PackedScene
	_expect(packed_station != null, "station_32 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station32
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D
	var observed_glass := station.get_node_or_null("Geometry/ObservedGlassTrace") as AnchorableObject

	_expect(player != null, "station_32: player missing")
	_expect(camera != null, "station_32: camera missing")
	_expect(geometry != null, "station_32: geometry missing")
	_expect(props != null, "station_32: props node missing")
	_expect(airlock_zone != null, "station_32: airlock zone missing")
	_expect(observed_glass != null, "station_32: ObservedGlassTrace must anchor before crossing")

	if props == null or player == null or airlock_zone == null or observed_glass == null:
		station.queue_free()
		await process_frame
		return

	var steamed_prop := props.get_node_or_null("SteamedGlassPaneA") as MemoryResonancePoint
	var cracked_prop := props.get_node_or_null("CrackedGlassPaneB") as MemoryResonancePoint
	var trace_prop := props.get_node_or_null("CondensationTraceEtcher") as MemoryResonancePoint
	var polished_prop := props.get_node_or_null("PolishedGlassPaneC") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station32Exit") as MemoryResonancePoint

	_expect(steamed_prop != null, "SteamedGlassPaneA prop missing")
	_expect(cracked_prop != null, "CrackedGlassPaneB prop missing")
	_expect(trace_prop != null, "CondensationTraceEtcher prop missing")
	_expect(polished_prop != null, "PolishedGlassPaneC prop missing")
	_expect(exit_prop != null, "Station32Exit prop missing")

	if steamed_prop == null or cracked_prop == null or trace_prop == null or polished_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(steamed_prop.prop_type == 147, "steamed pane prop_type must be 147")
	_expect(cracked_prop.prop_type == 148, "cracked pane prop_type must be 148")
	_expect(trace_prop.prop_type == 150, "trace etcher prop_type must be 150")
	_expect(polished_prop.prop_type == 149, "polished pane prop_type must be 149")
	_expect(exit_prop.prop_type == 151, "station 32 exit prop_type must be 151")

	_expect(station.inspect_steamed_pane(), "station 32 must inspect steamed pane")
	_expect(station.inspect_cracked_pane(), "station 32 must inspect cracked pane")
	_expect(station.etch_condensation_trace(), "station 32 must etch condensation trace")
	_expect(station.inspect_polished_pane(), "station 32 must inspect polished pane")
	_expect(station.anchor_material_memory(), "station 32 must anchor material memory")
	_expect(station.is_material_memory_anchored and station.is_exit_unlocked, "material memory anchor must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 32 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_33() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.archive_countermodel.material_memory_anchored", true)
	var packed_station := load("res://scenes/levels/station_33.tscn") as PackedScene
	_expect(packed_station != null, "station_33 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station33
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as Camera2D
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station_33: player missing")
	_expect(camera != null, "station_33: camera missing")
	_expect(geometry != null, "station_33: geometry missing")
	_expect(props != null, "station_33: props node missing")
	_expect(airlock_zone != null, "station_33: airlock zone missing")

	if props == null or player == null or airlock_zone == null:
		station.queue_free()
		await process_frame
		return

	var ladder_prop := props.get_node_or_null("VerticalLadderArray") as MemoryResonancePoint
	var gauge_prop := props.get_node_or_null("DepthPressureGauge") as MemoryResonancePoint
	var cable_prop := props.get_node_or_null("MemoryBusCableTrunk") as MemoryResonancePoint
	var light_prop := props.get_node_or_null("ShaftWorkLightBeacon") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station33Exit") as MemoryResonancePoint

	_expect(ladder_prop != null, "VerticalLadderArray prop missing")
	_expect(gauge_prop != null, "DepthPressureGauge prop missing")
	_expect(cable_prop != null, "MemoryBusCableTrunk prop missing")
	_expect(light_prop != null, "ShaftWorkLightBeacon prop missing")
	_expect(exit_prop != null, "Station33Exit prop missing")

	if ladder_prop == null or gauge_prop == null or cable_prop == null or light_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(ladder_prop.prop_type == 152, "ladder prop_type must be 152")
	_expect(gauge_prop.prop_type == 153, "depth gauge prop_type must be 153")
	_expect(cable_prop.prop_type == 154, "cable trunk prop_type must be 154")
	_expect(light_prop.prop_type == 155, "work light prop_type must be 155")
	_expect(exit_prop.prop_type == 156, "station 33 exit prop_type must be 156")

	_expect(station.inspect_ladder_infrastructure(), "station 33 must inspect ladder")
	_expect(station.inspect_depth_gauge(), "station 33 must inspect depth gauge")
	_expect(station.inspect_cable_trunk_note(), "station 33 must inspect cable trunk note")
	_expect(station.inspect_shaft_work_light(), "station 33 must inspect shaft work light")
	_expect(station.reconstruct_local_lena_intent(), "station 33 must reconstruct local Lena intent")
	_expect(station.is_local_lena_intent_found and station.is_exit_unlocked, "intent reconstruction must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 33 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_34() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.archive_countermodel.trace", "local_lena_intent_found")
	var packed_station := load("res://scenes/levels/station_34.tscn") as PackedScene
	_expect(packed_station != null, "station 34 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station34
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as Node2D
	var camera := station.get_node_or_null("Camera") as Camera2D
	var props_node := station.get_node_or_null("Props") as Node2D
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "player exists in station 34")
	_expect(camera != null, "camera exists in station 34")
	_expect(props_node != null, "props container exists in station 34")
	_expect(airlock_zone != null, "airlock zone exists in station 34")

	if player == null or camera == null or props_node == null or airlock_zone == null:
		station.queue_free()
		await process_frame
		return

	var reactor_prop := props_node.get_node_or_null("MainExchangeCoreReactor") as MemoryResonancePoint
	var desk_prop := props_node.get_node_or_null("BiographyAllocationDesk") as MemoryResonancePoint
	var thermal_prop := props_node.get_node_or_null("ThermalOverloadIndicator") as MemoryResonancePoint
	var probe_prop := props_node.get_node_or_null("JakubCoreDiagnosticPort") as MemoryResonancePoint
	var exit_prop := props_node.get_node_or_null("Station34Exit") as MemoryResonancePoint

	_expect(reactor_prop != null, "main exchange core reactor prop exists")
	_expect(desk_prop != null, "biography allocation desk prop exists")
	_expect(thermal_prop != null, "thermal overload indicator prop exists")
	_expect(probe_prop != null, "jakub core diagnostic port prop exists")
	_expect(exit_prop != null, "station 34 exit prop exists")

	if reactor_prop == null or desk_prop == null or thermal_prop == null or probe_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(reactor_prop.prop_type == 157, "reactor prop_type must be 157")
	_expect(desk_prop.prop_type == 158, "allocation desk prop_type must be 158")
	_expect(thermal_prop.prop_type == 159, "thermal indicator prop_type must be 159")
	_expect(probe_prop.prop_type == 160, "jakub probe prop_type must be 160")
	_expect(exit_prop.prop_type == 161, "station 34 exit prop_type must be 161")

	_expect(station.inspect_correlation_reactor(), "station 34 must inspect correlation reactor")
	_expect(station.inspect_allocation_desk(), "station 34 must inspect allocation desk")
	_expect(station.inspect_thermal_indicators(), "station 34 must inspect thermal indicators")
	_expect(station.inspect_diagnostic_probe(), "station 34 must inspect diagnostic probe")
	_expect(station.unlock_pair_registry(), "station 34 must unlock pair registry")
	_expect(station.is_pair_registry_unlocked and station.is_exit_unlocked, "unlocking pair registry must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 34 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_35() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.pair_cost_and_echo.pair_registry_inspected", true)
	var packed_scene := load("res://scenes/levels/station_35.tscn") as PackedScene
	_expect(packed_scene != null, "station 35 scene does not load")
	if packed_scene == null:
		return

	var station := packed_scene.instantiate() as Station35
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as Camera2D
	var geometry := station.get_node_or_null("Geometry")
	var props_node := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 35: player missing")
	_expect(camera != null, "station 35: camera missing")
	_expect(geometry != null, "station 35: geometry missing")
	_expect(props_node != null, "station 35: props node missing")
	_expect(airlock != null, "station 35: airlock missing")

	if player == null or props_node == null:
		station.queue_free()
		await process_frame
		return

	var basin_prop := props_node.get_node_or_null("SedationBasinPool") as MemoryResonancePoint
	var valve_prop := props_node.get_node_or_null("SludgeDrainValveWheel") as MemoryResonancePoint
	var chemical_prop := props_node.get_node_or_null("ChemicalSedationSampler") as MemoryResonancePoint
	var monitor_prop := props_node.get_node_or_null("JakubSedationMonitor") as MemoryResonancePoint
	var exit_prop := props_node.get_node_or_null("Station35Exit") as MemoryResonancePoint

	_expect(basin_prop != null, "sedation basin pool prop exists")
	_expect(valve_prop != null, "sludge drain valve wheel prop exists")
	_expect(chemical_prop != null, "chemical sedation sampler prop exists")
	_expect(monitor_prop != null, "jakub sedation monitor prop exists")
	_expect(exit_prop != null, "station 35 exit prop exists")

	if basin_prop == null or valve_prop == null or chemical_prop == null or monitor_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(basin_prop.prop_type == 162, "basin prop_type must be 162")
	_expect(valve_prop.prop_type == 163, "valve prop_type must be 163")
	_expect(chemical_prop.prop_type == 164, "chemical sampler prop_type must be 164")
	_expect(monitor_prop.prop_type == 165, "jakub monitor prop_type must be 165")
	_expect(exit_prop.prop_type == 166, "station 35 exit prop_type must be 166")

	_expect(station.inspect_cooling_pool(), "station 35 must inspect cooling pool")
	_expect(station.inspect_drain_valve(), "station 35 must inspect drain valve")
	_expect(station.inspect_chemical_sampler(), "station 35 must inspect chemical sampler")
	_expect(station.process_home_echo(), "station 35 must process home echo")
	_expect(station.is_home_echo_verified and station.is_exit_unlocked, "home echo verification must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 35 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_36() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.pair_cost_and_echo.home_echo_verified", true)
	var packed_station := load("res://scenes/levels/station_36.tscn") as PackedScene
	_expect(packed_station != null, "station 36 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station36
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props") as Node2D
	var airlock := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 36 player exists")
	_expect(camera != null, "station 36 camera exists")
	_expect(props != null, "station 36 props container exists")
	_expect(airlock != null, "station 36 airlock zone exists")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var weir_prop := props.get_node_or_null("StormDrainWeir") as MemoryResonancePoint
	var current_prop := props.get_node_or_null("SedativeSludgeCurrent") as MemoryResonancePoint
	var ladder_prop := props.get_node_or_null("AcidResistantCatwalkLadder") as MemoryResonancePoint
	var tap_prop := props.get_node_or_null("ContaminationSamplingTap") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station36Exit") as MemoryResonancePoint

	_expect(weir_prop != null, "storm drain weir prop exists")
	_expect(current_prop != null, "sedative sludge current prop exists")
	_expect(ladder_prop != null, "acid resistant catwalk ladder prop exists")
	_expect(tap_prop != null, "contamination sampling tap prop exists")
	_expect(exit_prop != null, "station 36 exit prop exists")

	if weir_prop == null or current_prop == null or ladder_prop == null or tap_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(weir_prop.prop_type == 167, "storm drain weir prop_type must be 167")
	_expect(current_prop.prop_type == 168, "sludge current prop_type must be 168")
	_expect(ladder_prop.prop_type == 169, "catwalk ladder prop_type must be 169")
	_expect(tap_prop.prop_type == 170, "sampling tap prop_type must be 170")
	_expect(exit_prop.prop_type == 171, "station 36 exit prop_type must be 171")

	_expect(station.inspect_drain_weir(), "station 36 must inspect drain weir")
	_expect(station.measure_drain_current(), "station 36 must measure drain current")
	_expect(station.inspect_service_ladder(), "station 36 must inspect service ladder")
	_expect(station.sample_contamination_tap(), "station 36 must sample contamination tap")
	_expect(station.reveal_ucp_cost_ledger(), "station 36 must reveal UCP cost ledger")
	_expect(station.is_ucp_cost_ledger_found and station.is_exit_unlocked, "cost ledger reveal must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 36 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_37() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.pair_cost_and_echo.trace", "ucp_cost_ledger_found")
	var packed_station := load("res://scenes/levels/station_37.tscn") as PackedScene
	_expect(packed_station != null, "station 37 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station37
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props") as Node2D
	var airlock := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 37 player exists")
	_expect(camera != null, "station 37 camera exists")
	_expect(props != null, "station 37 props container exists")
	_expect(airlock != null, "station 37 airlock zone exists")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var crt_prop := props.get_node_or_null("FrequencyOscilloscopeCRT") as MemoryResonancePoint
	var patchbay_prop := props.get_node_or_null("TransmissionCrossPatchbay") as MemoryResonancePoint
	var antenna_prop := props.get_node_or_null("SignalTransmissionAntenna") as MemoryResonancePoint
	var pulpit_prop := props.get_node_or_null("MemoryInjectionPulpit") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station37Exit") as MemoryResonancePoint

	_expect(crt_prop != null, "frequency oscilloscope prop exists")
	_expect(patchbay_prop != null, "transmission cross patchbay prop exists")
	_expect(antenna_prop != null, "signal transmission antenna prop exists")
	_expect(pulpit_prop != null, "memory injection pulpit prop exists")
	_expect(exit_prop != null, "station 37 exit prop exists")

	if crt_prop == null or patchbay_prop == null or antenna_prop == null or pulpit_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(crt_prop.prop_type == 174, "oscilloscope prop_type must be 174")
	_expect(patchbay_prop.prop_type == 173, "patchbay prop_type must be 173")
	_expect(antenna_prop.prop_type == 172, "antenna prop_type must be 172")
	_expect(pulpit_prop.prop_type == 175, "injection pulpit prop_type must be 175")
	_expect(exit_prop.prop_type == 176, "station 37 exit prop_type must be 176")

	_expect(station.inspect_frequency_oscilloscope(), "station 37 must inspect oscilloscope")
	_expect(station.inspect_transmission_patchbay(), "station 37 must inspect patchbay")
	_expect(station.inspect_transmitting_antenna(), "station 37 must inspect antenna")
	_expect(station.inspect_mixing_pulpit(), "station 37 must inspect mixing pulpit")
	_expect(station.bridge_living_signal(), "station 37 must bridge living signal")
	_expect(station.is_living_signal_bridged and station.is_exit_unlocked, "bridging signal must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 37 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_38() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.consent_and_rescue_boundary.living_signal_bridged", true)
	var packed_station := load("res://scenes/levels/station_38.tscn") as PackedScene
	_expect(packed_station != null, "station 38 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station38
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props") as Node2D
	var airlock := station.get_node_or_null("AirlockZone") as Area2D
	var rescue_bulkhead := station.get_node_or_null("Geometry/JakubRescueBulkhead") as AnchorableObject

	_expect(player != null, "station 38 player exists")
	_expect(camera != null, "station 38 camera exists")
	_expect(props != null, "station 38 props container exists")
	_expect(airlock != null, "station 38 airlock zone exists")
	_expect(rescue_bulkhead != null, "station 38: JakubRescueBulkhead must anchor before crossing")

	if props == null or player == null or rescue_bulkhead == null:
		station.queue_free()
		await process_frame
		return

	var calc_prop := props.get_node_or_null("ReturnCoordinateCalculator") as MemoryResonancePoint
	var field_prop := props.get_node_or_null("AccidentSimulationField") as MemoryResonancePoint
	var jakub_prop := props.get_node_or_null("DestabilizingJakubShadow") as MemoryResonancePoint
	var rescue_prop := props.get_node_or_null("RescueTetherAnchor") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station38Exit") as MemoryResonancePoint

	_expect(calc_prop != null, "return coordinate calculator prop exists")
	_expect(field_prop != null, "accident simulation field prop exists")
	_expect(jakub_prop != null, "destabilizing jakub shadow prop exists")
	_expect(rescue_prop != null, "rescue tether anchor prop exists")
	_expect(exit_prop != null, "station 38 exit prop exists")

	if calc_prop == null or field_prop == null or jakub_prop == null or rescue_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(calc_prop.prop_type == 180, "calculator prop_type must be 180")
	_expect(field_prop.prop_type == 177, "accident field prop_type must be 177")
	_expect(jakub_prop.prop_type == 178, "jakub shadow prop_type must be 178")
	_expect(rescue_prop.prop_type == 179, "rescue tether prop_type must be 179")
	_expect(exit_prop.prop_type == 181, "station 38 exit prop_type must be 181")

	_expect(station.inspect_radio_receiver(), "station 38 must inspect radio receiver")
	_expect(station.inspect_local_procedure_record(), "station 38 must inspect local procedure record")
	_expect(station.inspect_jakub_switchboard(), "station 38 must inspect Jakub switchboard")
	_expect(station.anchor_rescue_tether(), "station 38 must anchor rescue tether")
	_expect(station.disclose_marta_truth(&"full"), "station 38 must disclose truth to Marta")
	_expect(station.is_marta_truth_disclosed and station.is_exit_unlocked, "disclosing truth must unlock exit")

	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 38 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_39() -> void:
	var packed_station := load("res://scenes/levels/station_39.tscn") as PackedScene
	_expect(packed_station != null, "station 39 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station39
	_expect(station != null, "station 39 instance is valid")
	if station == null:
		return

	root.add_child(station)
	await physics_frame
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props") as Node2D
	var airlock := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 39 player exists")
	_expect(camera != null, "station 39 camera exists")
	_expect(props != null, "station 39 props container exists")
	_expect(airlock != null, "station 39 airlock zone exists")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var cfg_a_prop := props.get_node_or_null("BranchConfigReturnA") as MemoryResonancePoint
	var cfg_b_prop := props.get_node_or_null("BranchConfigReconciliationB") as MemoryResonancePoint
	var core_prop := props.get_node_or_null("CentralReferenceCoreMonolith") as MemoryResonancePoint
	var cfg_c_prop := props.get_node_or_null("BranchConfigTestimonyC") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station39Exit") as MemoryResonancePoint

	_expect(cfg_a_prop != null, "branch config A prop exists")
	_expect(cfg_b_prop != null, "branch config B prop exists")
	_expect(core_prop != null, "central reference core prop exists")
	_expect(cfg_c_prop != null, "branch config C prop exists")
	_expect(exit_prop != null, "station 39 exit prop exists")

	if cfg_a_prop == null or cfg_b_prop == null or core_prop == null or cfg_c_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(cfg_a_prop.prop_type == 183, "config A prop_type must be 183")
	_expect(cfg_b_prop.prop_type == 184, "config B prop_type must be 184")
	_expect(core_prop.prop_type == 182, "core prop_type must be 182")
	_expect(cfg_c_prop.prop_type == 185, "config C prop_type must be 185")
	_expect(exit_prop.prop_type == 186, "station 39 exit prop_type must be 186")

	# Initial state assertions
	_expect(not station.is_config_a_inspected, "config A not inspected initially")
	_expect(not station.is_config_b_inspected, "config B not inspected initially")
	_expect(not station.is_reference_core_inspected, "reference core not inspected initially")
	_expect(not station.is_config_c_inspected, "config C not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Config A inspection at x=140
	player.global_position = Vector2(140.0, 246.0)
	await physics_frame
	await physics_frame
	cfg_a_prop.trigger_interaction()
	_expect(station.is_config_a_inspected, "config A must be inspected")
	_expect(cfg_a_prop.is_activated, "config A prop must be activated")
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 1, "dialogue advanced to 1 on config A inspection")

	# Test 2: Config B inspection at x=245
	player.global_position = Vector2(245.0, 246.0)
	station.dialogue_index = 2
	await physics_frame
	await physics_frame
	cfg_b_prop.trigger_interaction()
	_expect(station.is_config_b_inspected, "config B must be inspected")
	_expect(cfg_b_prop.is_activated, "config B prop must be activated")

	# Test 3: Reference core inspection at x=345
	player.global_position = Vector2(345.0, 240.0)
	station.dialogue_index = 4
	await physics_frame
	await physics_frame
	core_prop.trigger_interaction()
	_expect(station.is_reference_core_inspected, "reference core must be inspected")
	_expect(core_prop.is_activated, "reference core prop must be activated")

	# Test 4: Config C inspection at x=445
	player.global_position = Vector2(445.0, 246.0)
	station.dialogue_index = 7
	await physics_frame
	await physics_frame
	cfg_c_prop.trigger_interaction()
	_expect(station.is_config_c_inspected, "config C must be inspected")
	_expect(cfg_c_prop.is_activated, "config C prop must be activated")

	# Test 5: Step through Scene 39 dialogue progression (11 lines)
	station.dialogue_index = 1
	station.advance_dialogue() # to 2 (LENA: Konfiguracja A: Własny pokój...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "LENA", "line 2 speaker is LENA")

	station.advance_dialogue() # to 3 (ŚLAD: KONFIGURACJA B: MIEJSCE PO MNIE...)
	_expect(station.dialogue_index == 3, "dialogue at 3")
	_expect(station.dialogue_lines[3]["speaker"] == "ŚLAD", "line 3 speaker is ŚLAD")

	station.advance_dialogue() # to 4 (JAKUB: A Konfiguracja C... Świadectwo...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (LENA: Która opcja jest twoja, Śladzie?...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚLAD: JEŚLI WYBIERZĘ JA... ZNOWU ZROBIĘ Z CIEBIE KOSZT.)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (ŚWIADECTWO: Ślad cofa dłoń z konsoli...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (LENA: Zostajesz ze mną do końca?)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (ŚLAD: ODDAJĘ KONTROLĘ. WYBÓR NALEŻY DO CIEBIE.)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Stabilizator pamięci osiąga stan krytyczny...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # past end
	_expect(station.is_dialogue_completed, "dialogue completed after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for act 4 gateway unsealing transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 39 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_40() -> void:
	var packed_station := load("res://scenes/levels/station_40.tscn") as PackedScene
	_expect(packed_station != null, "station 40 scene must load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station40
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 40: player must exist")
	_expect(camera != null, "station 40: camera must exist")
	_expect(props != null, "station 40: props must exist")
	_expect(airlock != null, "station 40: airlock zone must exist")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var term_prop := props.get_node_or_null("WierzbickaPersonalTerminal") as MemoryResonancePoint
	var matrix_prop := props.get_node_or_null("CostDossierMatrix") as MemoryResonancePoint
	var marta_prop := props.get_node_or_null("MartaWitnessStation") as MemoryResonancePoint
	var szymon_prop := props.get_node_or_null("SzymonTransmissionMonitor") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station40Exit") as MemoryResonancePoint

	_expect(term_prop != null, "wierzbicka terminal prop exists")
	_expect(matrix_prop != null, "cost dossier matrix prop exists")
	_expect(marta_prop != null, "marta witness station prop exists")
	_expect(szymon_prop != null, "szymon transmission monitor prop exists")
	_expect(exit_prop != null, "station 40 exit prop exists")

	if term_prop == null or matrix_prop == null or marta_prop == null or szymon_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(term_prop.prop_type == 187, "wierzbicka terminal prop_type must be 187")
	_expect(matrix_prop.prop_type == 190, "cost dossier matrix prop_type must be 190")
	_expect(marta_prop.prop_type == 188, "marta witness prop_type must be 188")
	_expect(szymon_prop.prop_type == 189, "szymon monitor prop_type must be 189")
	_expect(exit_prop.prop_type == 191, "station 40 exit prop_type must be 191")

	# Initial state assertions
	_expect(not station.is_terminal_inspected, "terminal not inspected initially")
	_expect(not station.is_cost_matrix_inspected, "cost matrix not inspected initially")
	_expect(not station.is_marta_inspected, "marta witness not inspected initially")
	_expect(not station.is_szymon_inspected, "szymon monitor not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Terminal inspection at x=140
	player.global_position = Vector2(140.0, 246.0)
	await physics_frame
	await physics_frame
	term_prop.trigger_interaction()
	_expect(station.is_terminal_inspected, "terminal must be inspected")
	_expect(term_prop.is_activated, "terminal prop must be activated")
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 1, "dialogue advanced to 1 on terminal inspection")

	# Test 2: Cost matrix inspection at x=245
	player.global_position = Vector2(245.0, 246.0)
	station.dialogue_index = 2
	await physics_frame
	await physics_frame
	matrix_prop.trigger_interaction()
	_expect(station.is_cost_matrix_inspected, "cost matrix must be inspected")
	_expect(matrix_prop.is_activated, "cost matrix prop must be activated")

	# Test 3: Marta witness station inspection at x=345
	player.global_position = Vector2(345.0, 246.0)
	station.dialogue_index = 6
	await physics_frame
	await physics_frame
	marta_prop.trigger_interaction()
	_expect(station.is_marta_inspected, "marta witness must be inspected")
	_expect(marta_prop.is_activated, "marta witness prop must be activated")

	# Test 4: Szymon monitor inspection at x=445
	player.global_position = Vector2(445.0, 246.0)
	station.dialogue_index = 9
	await physics_frame
	await physics_frame
	szymon_prop.trigger_interaction()
	_expect(station.is_szymon_inspected, "szymon monitor must be inspected")
	_expect(szymon_prop.is_activated, "szymon monitor prop must be activated")

	# Test 5: Step through Scene 40 dialogue progression (13 lines: 0..12)
	station.dialogue_index = 1
	station.advance_dialogue() # to 2 (WIERZBICKA: Sieć świadków ma zbyt wiele zmiennych...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "WIERZBICKA", "line 2 speaker is WIERZBICKA")

	station.advance_dialogue() # to 3 (LENA: Ale działała.)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (WIERZBICKA: W jednym pokoju przez czterdzieści trzy sekundy.)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (JAKUB: Wystarczyło, żebyśmy wyszli.)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (WIERZBICKA: Nie wystarczy, żeby przejechał poranny tramwaj.)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (MARTA: Więc nauczymy motorniczą patrzeć.)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (WIERZBICKA: A jeśli odwróci głowę?)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (ŚWIADECTWO: Cisza. Marta nie odsuwa wzroku...)
	_expect(station.dialogue_index == 9, "dialogue at 9")

	station.advance_dialogue() # to 10 (SZYMON: Była ktoś. Nie trzymam imienia...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # to 11 (LENA: Nie szukamy już oryginału, doktor Wierzbicka...)
	_expect(station.dialogue_index == 11, "dialogue at 11")
	_expect(station.is_exit_unlocked, "exit unlocked at line 11")

	station.advance_dialogue() # to 12 (ŚWIADECTWO: Wrota do Komory Wyboru Operacyjnego...)
	_expect(station.dialogue_index == 12, "dialogue at 12")

	station.advance_dialogue() # past end
	_expect(station.is_dialogue_completed, "dialogue completed after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for operational choice chamber doorway unsealing transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 40 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_41() -> void:
	var packed_station := load("res://scenes/levels/station_41.tscn") as PackedScene
	_expect(packed_station != null, "station 41 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station41
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 41: player must exist")
	_expect(camera != null, "station 41: camera must exist")
	_expect(props != null, "station 41: props must exist")
	_expect(airlock != null, "station 41: airlock zone must exist")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var topo_prop := props.get_node_or_null("TopographyDisplay") as MemoryResonancePoint
	var console_a := props.get_node_or_null("ConsoleReturnA") as MemoryResonancePoint
	var console_b := props.get_node_or_null("ConsoleReconciliationB") as MemoryResonancePoint
	var console_c := props.get_node_or_null("ConsoleTestimonyC") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station41Exit") as MemoryResonancePoint

	_expect(topo_prop != null, "topography display prop exists")
	_expect(console_a != null, "console return A prop exists")
	_expect(console_b != null, "console reconciliation B prop exists")
	_expect(console_c != null, "console testimony C prop exists")
	_expect(exit_prop != null, "station 41 exit prop exists")

	if topo_prop == null or console_a == null or console_b == null or console_c == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(topo_prop.prop_type == 195, "topography display prop_type must be 195")
	_expect(console_a.prop_type == 192, "console return A prop_type must be 192")
	_expect(console_b.prop_type == 193, "console reconciliation B prop_type must be 193")
	_expect(console_c.prop_type == 194, "console testimony C prop_type must be 194")
	_expect(exit_prop.prop_type == 196, "station 41 exit prop_type must be 196")

	# Initial state assertions
	_expect(station.chosen_operation == "", "chosen operation must start empty")
	_expect(not station.is_topography_inspected, "topography not inspected initially")
	_expect(not station.is_op_a_inspected, "op A not inspected initially")
	_expect(not station.is_op_b_inspected, "op B not inspected initially")
	_expect(not station.is_op_c_inspected, "op C not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Topography display inspection at x=130
	player.global_position = Vector2(130.0, 246.0)
	await physics_frame
	await physics_frame
	topo_prop.trigger_interaction()
	_expect(station.is_topography_inspected, "topography must be inspected")
	_expect(topo_prop.is_activated, "topography prop must be activated")
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 1, "dialogue advanced to 1 on topography inspection")

	# Test 2: Inspect and select Operation A (Powrót / Return) at x=220
	player.global_position = Vector2(220.0, 246.0)
	await physics_frame
	await physics_frame
	console_a.trigger_interaction()
	_expect(station.is_op_a_inspected, "operation A must be inspected")
	_expect(station.chosen_operation == "A", "chosen operation must be A")
	_expect(console_a.is_activated, "console A must be activated")
	_expect(station.is_exit_unlocked, "exit must be unlocked after choosing operation A")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Test 3: Switch to Operation B (Uzgodnienie / Reconciliation) at x=330
	player.global_position = Vector2(330.0, 246.0)
	await physics_frame
	await physics_frame
	console_b.trigger_interaction()
	_expect(station.is_op_b_inspected, "operation B must be inspected")
	_expect(station.chosen_operation == "B", "chosen operation must switch to B")
	_expect(console_b.is_activated, "console B must be activated")
	_expect(not console_a.is_activated, "console A deactivated when B chosen")

	# Test 4: Switch to Operation C (Świadectwo / Testimony) at x=440
	player.global_position = Vector2(440.0, 246.0)
	await physics_frame
	await physics_frame
	console_c.trigger_interaction()
	_expect(station.is_op_c_inspected, "operation C must be inspected")
	_expect(station.chosen_operation == "C", "chosen operation must switch to C")
	_expect(console_c.is_activated, "console C must be activated")
	_expect(not console_b.is_activated, "console B deactivated when C chosen")

	# Advance physics frames for resolution gate unsealing transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "resolution gate open progress must advance")

	# Test 5: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 41 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_42a() -> void:
	var packed_station := load("res://scenes/levels/station_42a.tscn") as PackedScene
	_expect(packed_station != null, "station 42a scene does not load")
	if packed_station == null:
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p9.method_commitment.method_committed", "force_home")
		state.record_decision(&"method_committed", "force_home")
		state.record_decision(&"marta_truth_state", "partial")
		state.record_decision(&"jakub_consent_state", "limited")

	var station := packed_station.instantiate() as Station42A
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 42a: player exists")
	_expect(camera != null, "station 42a: camera exists")
	_expect(props != null, "station 42a: props exist")
	_expect(airlock != null, "station 42a: airlock zone exists")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var latch := props.get_node_or_null("ForcedReturnLatch") as MemoryResonancePoint
	var threshold := props.get_node_or_null("SealedThreshold") as MemoryResonancePoint
	var table := props.get_node_or_null("HouseholdTrace") as MemoryResonancePoint

	_expect(latch != null, "forced return latch exists")
	_expect(threshold != null, "sealed threshold exists")
	_expect(table != null, "household trace exists")

	if latch == null or threshold == null or table == null:
		station.queue_free()
		await process_frame
		return

	_expect(station.is_exit_unlocked, "station 42a exit stays open after force_home")
	_expect(station.execute_forced_return(), "station 42a forced return must succeed")
	_expect(station.read_sealed_other_lena(), "station 42a sealed other Lena must be readable")
	_expect(station.read_household_consequence(), "station 42a household consequence must be readable")
	_expect(station.is_return_executed, "forced return must be recorded")
	_expect(station.is_other_lena_sealed, "sealed other Lena must be recorded")

	await _cross_exit(station)
	_expect(station.is_level_completed, "station 42a completed upon entering airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_42b() -> void:
	var packed_station := load("res://scenes/levels/station_42b.tscn") as PackedScene
	_expect(packed_station != null, "station 42b scene does not load")
	if packed_station == null:
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p9.method_commitment.method_committed", "close_equal_recover_local")
		state.record_decision(&"method_committed", "close_equal_recover_local")
		state.record_decision(&"marta_truth_state", "partial")
		state.record_decision(&"jakub_consent_state", "limited")

	var station := packed_station.instantiate() as Station42B
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 42b: player exists")
	_expect(camera != null, "station 42b: camera exists")
	_expect(props != null, "station 42b: props exist")
	_expect(airlock != null, "station 42b: airlock zone exists")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var latch := props.get_node_or_null("FlowClosureLatch") as MemoryResonancePoint
	var threshold := props.get_node_or_null("LocalLenaThreshold") as MemoryResonancePoint
	var table := props.get_node_or_null("HouseholdTrace") as MemoryResonancePoint

	_expect(latch != null, "flow closure latch exists")
	_expect(threshold != null, "local lena threshold exists")
	_expect(table != null, "household trace exists")

	if latch == null or threshold == null or table == null:
		station.queue_free()
		await process_frame
		return

	_expect(station.is_exit_unlocked, "station 42b exit stays open after close_equal")
	_expect(station.execute_close_flow(), "station 42b flow closure must succeed")
	_expect(station.read_local_lena_recovered(), "station 42b recovered local Lena must be readable")
	_expect(station.read_household_consequence(), "station 42b household consequence must be readable")
	_expect(station.is_flow_closed, "flow closure must be recorded")
	_expect(station.is_local_lena_recovered, "recovered local Lena must be recorded")

	await _cross_exit(station)
	_expect(station.is_level_completed, "station 42b completed upon entering airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_42c() -> void:
	var packed_station := load("res://scenes/levels/station_42c.tscn") as PackedScene
	_expect(packed_station != null, "station 42c scene does not load")
	if packed_station == null:
		return

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p9.method_commitment.method_committed", "mutual_passage")
		state.record_decision(&"method_committed", "mutual_passage")
		state.record_decision(&"marta_truth_state", "partial")
		state.record_decision(&"jakub_consent_state", "granted")

	var station := packed_station.instantiate() as Station42C
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 42c: player exists")
	_expect(camera != null, "station 42c: camera exists")
	_expect(props != null, "station 42c: props exist")
	_expect(airlock != null, "station 42c: airlock zone exists")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var latch := props.get_node_or_null("MutualPassageLatch") as MemoryResonancePoint
	var threshold := props.get_node_or_null("MemoryLeakThreshold") as MemoryResonancePoint
	var table := props.get_node_or_null("HouseholdTrace") as MemoryResonancePoint

	_expect(latch != null, "mutual passage latch exists")
	_expect(threshold != null, "memory leak threshold exists")
	_expect(table != null, "household trace exists")

	if latch == null or threshold == null or table == null:
		station.queue_free()
		await process_frame
		return

	_expect(station.is_exit_unlocked, "station 42c exit stays open after mutual_passage")
	_expect(station.execute_mutual_passage(), "station 42c mutual passage must succeed")
	_expect(station.read_memory_leak(), "station 42c memory leak must be readable")
	_expect(station.read_household_consequence(), "station 42c household consequence must be readable")
	_expect(station.is_passage_opened, "mutual passage must be recorded")
	_expect(station.is_memory_leak_read, "memory leak must be recorded")

	await _cross_exit(station)
	_expect(station.is_level_completed, "station 42c completed upon entering airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_43() -> void:
	var packed_station := load("res://scenes/levels/station_43.tscn") as PackedScene
	_expect(packed_station != null, "station 43 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station43
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 43: player exists")
	_expect(camera != null, "station 43: camera exists")
	_expect(props != null, "station 43: props exist")
	_expect(airlock != null, "station 43: airlock zone exists")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var notice_prop := props.get_node_or_null("AdminNoticeBoard") as MemoryResonancePoint
	var credits_prop := props.get_node_or_null("CreditsRoll") as MemoryResonancePoint
	var blackout_prop := props.get_node_or_null("FinalBlackout") as MemoryResonancePoint

	_expect(notice_prop != null, "admin notice board prop exists")
	_expect(credits_prop != null, "credits roll prop exists")
	_expect(blackout_prop != null, "final blackout prop exists")

	if notice_prop == null or credits_prop == null or blackout_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(notice_prop.prop_type == 200, "notice prop_type must be 200")
	_expect(credits_prop.prop_type == 201, "credits prop_type must be 201")
	_expect(blackout_prop.prop_type == 202, "blackout prop_type must be 202")

	# Initial state
	_expect(not station.is_notice_inspected, "notice not inspected initially")
	_expect(not station.is_credits_inspected, "credits not inspected initially")
	_expect(not station.is_blackout_inspected, "blackout not inspected initially")

	# Test 1: Inspect notice at x=160
	player.global_position = Vector2(160.0, 248.0)
	await physics_frame
	await physics_frame
	notice_prop.trigger_interaction()
	_expect(station.is_notice_inspected, "notice must be inspected")

	# Test 2: Inspect credits at x=340
	player.global_position = Vector2(340.0, 246.0)
	await physics_frame
	await physics_frame
	credits_prop.trigger_interaction()
	_expect(station.is_credits_inspected, "credits must be inspected")

	# Advance dialogue to completion
	while station.dialogue_index < station.dialogue_lines.size() - 1:
		station.advance_dialogue()
	station.advance_dialogue()

	# Test 3: Inspect blackout at x=520
	player.global_position = Vector2(520.0, 244.0)
	await physics_frame
	await physics_frame
	blackout_prop.trigger_interaction()
	_expect(station.is_blackout_inspected, "blackout must be inspected")
	_expect(station.is_exit_unlocked, "exit unlocked after blackout")

	# Test 4: Enter airlock zone at x=610
	await _cross_exit(station)
	_expect(station.is_level_completed, "station 43 completed upon entering airlock")

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
