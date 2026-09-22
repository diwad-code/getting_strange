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
	print("TEST: movement_lab completed")

	await _test_anchor_lab()
	print("TEST: anchor_lab completed")
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


func _test_station_11() -> void:
	var packed_station := load("res://scenes/levels/station_11.tscn") as PackedScene
	_expect(packed_station != null, "station_11 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station11
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")
	var mist_particles := station.get_node_or_null("MistParticles") as CPUParticles2D

	_expect(player != null, "station_11: player missing")
	_expect(camera != null, "station_11: camera missing")
	_expect(geometry != null, "station_11: geometry missing")
	_expect(props != null, "station_11: props node missing")
	_expect(airlock_zone != null, "station_11: airlock_zone missing")
	_expect(mist_particles != null, "station_11: mist particles missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var window_prop := props.get_node_or_null("ObservationWindow") as MemoryResonancePoint
	var marta_prop := props.get_node_or_null("MartaObservationDialogue") as MemoryResonancePoint
	var ucp_prop := props.get_node_or_null("UcpInterventionTeam") as MemoryResonancePoint
	var resident_prop := props.get_node_or_null("ElderlyResidentGuide") as MemoryResonancePoint
	var doorway_prop := props.get_node_or_null("ErasedDoorwayTrace") as MemoryResonancePoint
	var airlock_prop := props.get_node_or_null("CourtyardExitAirlock") as MemoryResonancePoint

	_expect(window_prop != null, "ObservationWindow prop missing in station_11")
	_expect(marta_prop != null, "MartaObservationDialogue prop missing in station_11")
	_expect(ucp_prop != null, "UcpInterventionTeam prop missing in station_11")
	_expect(resident_prop != null, "ElderlyResidentGuide prop missing in station_11")
	_expect(doorway_prop != null, "ErasedDoorwayTrace prop missing in station_11")
	_expect(airlock_prop != null, "CourtyardExitAirlock prop missing in station_11")

	if window_prop == null or marta_prop == null or doorway_prop == null or airlock_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("AmbienceAudioPlayer") != null, "AmbienceAudioPlayer missing in station_11")
	_expect(station.get_node_or_null("StabilizerAudioPlayer") != null, "StabilizerAudioPlayer missing in station_11")
	_expect(station.get_node_or_null("MasonryAudioPlayer") != null, "MasonryAudioPlayer missing in station_11")
	_expect(station.get_node_or_null("BlipAudioPlayer") != null, "BlipAudioPlayer missing in station_11")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_11")

	# Initial state
	_expect(not station.window_inspected, "window should not be inspected initially")
	_expect(not station.is_intervention_completed, "intervention should not be completed initially")
	_expect(not station.is_masonry_smoothed, "masonry should not be smoothed initially")
	_expect(not station.is_airlock_unlocked, "courtyard airlock must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Observation Window interaction on upper gallery at x=110
	player.global_position = Vector2(110.0, 146.0)
	await physics_frame
	await physics_frame
	_expect(window_prop.is_player_in_range, "observation window must detect player in range at x=110")

	window_prop.trigger_interaction()
	_expect(window_prop.is_activated, "ObservationWindow prop must be activated")
	_expect(station.window_inspected, "station.window_inspected must be true")
	_expect(station.marta_dialogue_active, "observation dialogue must start upon looking through window")
	_expect(station.marta_dialogue_index == 0, "dialogue must start at line 0")

	# Test 2: Step through observation dialogue lines (0..4) and verify stabilizer & masonry smooth trigger
	var l1 := station.advance_marta_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (OPERATOR UCP)")

	var l2 := station.advance_marta_dialogue()
	_expect(l2 == 2, "dialogue must advance to line 2 (ŚWIADECTWO: Stabilizator polowy)")
	_expect(station.is_masonry_smoothed, "masonry smoothing must be triggered at line 2")
	_expect(station.is_intervention_completed, "intervention must be marked completed")
	_expect(doorway_prop.is_activated, "ErasedDoorwayTrace prop must be activated")

	var l3 := station.advance_marta_dialogue()
	_expect(l3 == 3, "dialogue must advance to line 3 (ŚWIADECTWO: Obrys wejścia wygładza się)")

	var l4 := station.advance_marta_dialogue()
	_expect(l4 == 4, "dialogue must advance to line 4 (KOBIETA: Rzeczywiście...)")

	# Test 3: Dialogue with Marta Kurek (lines 5..9)
	var l5 := station.advance_marta_dialogue()
	_expect(l5 == 5, "dialogue must advance to line 5 (MARTA: Zgłosiłam ją...)")

	var l6 := station.advance_marta_dialogue()
	_expect(l6 == 6, "dialogue must advance to line 6 (LENA: Jak te drzwi?)")

	var l7 := station.advance_marta_dialogue()
	_expect(l7 == 7, "dialogue must advance to line 7 (MARTA: Że jeśli nikt jej nie poszuka...)")

	var l8 := station.advance_marta_dialogue()
	_expect(l8 == 8, "dialogue must advance to line 8 (LENA: UCP jej nie skrzywdziło...)")

	var l9 := station.advance_marta_dialogue()
	_expect(l9 == 9, "dialogue must advance to line 9 (MARTA: Uratowali ją. I wymazali jej wspomnienie...)")

	var l_end := station.advance_marta_dialogue()
	_expect(l_end == -1, "advancing past line 9 must complete dialogue and return -1")
	_expect(station.is_marta_dialogue_completed, "marta dialogue must be marked completed")
	_expect(not station.marta_dialogue_active, "dialogue must no longer be active")
	_expect(station.is_airlock_unlocked, "courtyard airlock must unlock after dialogue and masonry smoothing")
	_expect(airlock_prop.is_activated, "CourtyardExitAirlock prop must be activated")

	# Test 4: Player descends stairs to Courtyard level and inspects erased doorway trace at x=515
	player.global_position = Vector2(515.0, 286.0)
	await physics_frame
	await physics_frame
	_expect(doorway_prop.is_player_in_range, "doorway trace must detect player in range at x=515")

	doorway_prop.trigger_interaction()
	_expect(station.doorway_inspected, "station.doorway_inspected must be true")

	# Test 5: Player approaches and enters Courtyard Exit Airlock at x=600 to transition to Space 12
	player.global_position = Vector2(600.0, 286.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station_11 must complete upon entering airlock zone")

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

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_12: player missing")
	_expect(camera != null, "station_12: camera missing")
	_expect(geometry != null, "station_12: geometry missing")
	_expect(props != null, "station_12: props node missing")
	_expect(airlock_zone != null, "station_12: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var terminal_prop := props.get_node_or_null("UcpInfoTerminal") as MemoryResonancePoint
	var vitrine_prop := props.get_node_or_null("ShowcaseVitrine") as MemoryResonancePoint
	var poster_prop := props.get_node_or_null("InstructionPoster") as MemoryResonancePoint
	var pillar_prop := props.get_node_or_null("SubwayTilePillar") as MemoryResonancePoint
	var gate_prop := props.get_node_or_null("UnderpassExitGate") as MemoryResonancePoint

	_expect(terminal_prop != null, "UcpInfoTerminal prop missing in station_12")
	_expect(vitrine_prop != null, "ShowcaseVitrine prop missing in station_12")
	_expect(poster_prop != null, "InstructionPoster prop missing in station_12")
	_expect(pillar_prop != null, "SubwayTilePillar prop missing in station_12")
	_expect(gate_prop != null, "UnderpassExitGate prop missing in station_12")

	if terminal_prop == null or vitrine_prop == null or poster_prop == null or pillar_prop == null or gate_prop == null:
		station.queue_free()
		await process_frame
		return

	# Audio players verification
	_expect(station.get_node_or_null("SubwayHumPlayer") != null, "SubwayHumPlayer missing in station_12")
	_expect(station.get_node_or_null("NeonFlickerPlayer") != null, "NeonFlickerPlayer missing in station_12")
	_expect(station.get_node_or_null("PaChimePlayer") != null, "PaChimePlayer missing in station_12")
	_expect(station.get_node_or_null("TerminalPlayer") != null, "TerminalPlayer missing in station_12")
	_expect(station.get_node_or_null("DoorAudioPlayer") != null, "DoorAudioPlayer missing in station_12")
	_expect(station.get_node_or_null("BlipAudioPlayer") != null, "BlipAudioPlayer missing in station_12")

	# Initial state
	_expect(not station.terminal_inspected, "terminal should not be inspected initially")
	_expect(not station.is_stabilization_active, "stabilization should not be active initially")
	_expect(not station.is_child_evacuated, "child should not be evacuated initially")
	_expect(not station.is_safety_demonstrated, "safety demonstration should not be complete initially")
	_expect(not station.is_gate_unlocked, "underpass gate must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Pillar inspection at x=320
	player.global_position = Vector2(320.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(pillar_prop.is_player_in_range, "pillar must detect player in range at x=320")
	pillar_prop.trigger_interaction()
	_expect(pillar_prop.is_activated, "pillar must be activated")
	_expect(station.pillar_inspected, "station.pillar_inspected must be true")

	# Test 2: Poster inspection at x=380
	player.global_position = Vector2(380.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(poster_prop.is_player_in_range, "poster must detect player in range at x=380")
	poster_prop.trigger_interaction()
	_expect(poster_prop.is_activated, "poster must be activated")
	_expect(station.poster_inspected, "station.poster_inspected must be true")

	# Test 3: Vitrine inspection at x=440
	player.global_position = Vector2(440.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(vitrine_prop.is_player_in_range, "vitrine must detect player in range at x=440")
	vitrine_prop.trigger_interaction()
	_expect(vitrine_prop.is_activated, "vitrine must be activated")
	_expect(station.vitrine_inspected, "station.vitrine_inspected must be true")

	# Test 4: UCP Information Terminal interaction at x=500 -> start dialogue & safety demonstration
	player.global_position = Vector2(500.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(terminal_prop.is_player_in_range, "terminal must detect player in range at x=500")

	terminal_prop.trigger_interaction()
	_expect(terminal_prop.is_activated, "terminal must be activated")
	_expect(station.terminal_inspected, "station.terminal_inspected must be true")
	_expect(station.dialogue_active, "safety dialogue must start upon logging into terminal")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0 (PA announcement)")

	# Test 5: Step through dialogue lines (0..8) and verify stabilization & Level 3 clearance readout
	var l1 := station.advance_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (STRAŻNIK EWAKUACJI UCP)")

	var l2 := station.advance_dialogue()
	_expect(l2 == 2, "dialogue must advance to line 2 (ŚWIADECTWO: Nakładające się schody)")

	var l3 := station.advance_dialogue()
	_expect(l3 == 3, "dialogue must advance to line 3 (LENA: Przełączam zasilanie)")

	var l4 := station.advance_dialogue()
	_expect(l4 == 4, "dialogue must advance to line 4 (ŚWIADECTWO: Wiązka stabilizatora)")
	_expect(station.is_stabilization_active, "stabilization must be triggered at line 4")
	_expect(station.is_child_evacuated, "child evacuation must be triggered at line 4")
	_expect(station.is_safety_demonstrated, "safety demonstration must be marked completed")

	var l5 := station.advance_dialogue()
	_expect(l5 == 5, "dialogue must advance to line 5 (STRAŻNIK: Dziękuję za asystę)")

	var l6 := station.advance_dialogue()
	_expect(l6 == 6, "dialogue must advance to line 6 (TERMINAL: Autoryzacja Poziomu 3)")

	var l7 := station.advance_dialogue()
	_expect(l7 == 7, "dialogue must advance to line 7 (LENA: Współtworzyła ten system)")

	var l8 := station.advance_dialogue()
	_expect(l8 == 8, "dialogue must advance to line 8 (TERMINAL: Pamięć to nie pomiar)")

	var l_end := station.advance_dialogue()
	_expect(l_end == -1, "advancing past line 8 must complete dialogue and return -1")
	_expect(station.is_dialogue_completed, "safety dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")
	_expect(station.is_gate_unlocked, "underpass exit gate must unlock after dialogue and clearance verification")
	_expect(gate_prop.is_activated, "UnderpassExitGate prop must be activated")

	# Wait for gate opening progress
	for f in range(20):
		await physics_frame

	_expect(station._gate_open_progress > 0.1, "gate opening progress must advance")

	# Test 6: Player enters Underpass Exit Airlock zone at x=600 to transition to Space 13
	player.global_position = Vector2(600.0, 260.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station_12 must complete upon entering airlock zone")

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

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_13: player missing")
	_expect(camera != null, "station_13: cinematic camera missing")
	_expect(geometry != null, "station_13: geometry missing")
	_expect(props != null, "station_13: props node missing")
	_expect(airlock_zone != null, "station_13: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var drafting_prop := props.get_node_or_null("DraftingTable") as MemoryResonancePoint
	var cabinet_prop := props.get_node_or_null("TopographyIndexCabinet") as MemoryResonancePoint
	var circuit_prop := props.get_node_or_null("ResonanceCircuitNode") as MemoryResonancePoint
	var photo_prop := props.get_node_or_null("JakubPhotographFrame") as MemoryResonancePoint
	var airlock_prop := props.get_node_or_null("TechPassageAirlock") as MemoryResonancePoint

	_expect(drafting_prop != null, "DraftingTable prop missing in station_13")
	_expect(cabinet_prop != null, "TopographyIndexCabinet prop missing in station_13")
	_expect(circuit_prop != null, "ResonanceCircuitNode prop missing in station_13")
	_expect(photo_prop != null, "JakubPhotographFrame prop missing in station_13")
	_expect(airlock_prop != null, "TechPassageAirlock prop missing in station_13")

	if drafting_prop == null or cabinet_prop == null or circuit_prop == null or photo_prop == null or airlock_prop == null:
		station.queue_free()
		await process_frame
		return

	# Initial state
	_expect(not station.drafting_table_inspected, "drafting table should not be inspected initially")
	_expect(not station.cabinet_inspected, "cabinet should not be inspected initially")
	_expect(not station.circuit_inspected, "circuit node should not be inspected initially")
	_expect(not station.photo_frame_inspected, "photo frame should not be inspected initially")
	_expect(not station.is_photo_inserted, "photo should not be inserted initially")
	_expect(not station.is_shadow_developed, "shadow should not be developed initially")
	_expect(not station.is_circuit_aligned, "circuit should not be aligned initially")
	_expect(not station.is_airlock_unlocked, "airlock must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Drafting table inspection at x=140
	player.global_position = Vector2(140.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(drafting_prop.is_player_in_range, "drafting table must detect player in range at x=140")
	drafting_prop.trigger_interaction()
	_expect(drafting_prop.is_activated, "drafting table must be activated")
	_expect(station.drafting_table_inspected, "station.drafting_table_inspected must be true")
	_expect(station.dialogue_active, "dialogue must start upon analyzing drafting table")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")

	# Test 2: Advance dialogue line 0 -> 1 (ŚWIADECTWO PAMIĘCI)
	var l1 := station.advance_dialogue()
	_expect(l1 == 1, "dialogue must advance to line 1 (ŚWIADECTWO PAMIĘCI)")

	# Test 3: Topography Index Cabinet inspection at x=250
	player.global_position = Vector2(250.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(cabinet_prop.is_player_in_range, "cabinet must detect player in range at x=250")
	cabinet_prop.trigger_interaction()
	_expect(cabinet_prop.is_activated, "cabinet must be activated")
	_expect(station.cabinet_inspected, "station.cabinet_inspected must be true")

	# Test 4: Resonance Circuit Node inspection at x=370
	player.global_position = Vector2(370.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(circuit_prop.is_player_in_range, "circuit node must detect player in range at x=370")
	circuit_prop.trigger_interaction()
	_expect(circuit_prop.is_activated, "circuit node must be activated")
	_expect(station.circuit_inspected, "station.circuit_inspected must be true")

	# Test 5: Jakub Photograph Frame interaction at x=470 -> Inserts photo, triggers shadow emergence & circuit alignment
	player.global_position = Vector2(470.0, 260.0)
	await physics_frame
	await physics_frame
	_expect(photo_prop.is_player_in_range, "photo frame must detect player in range at x=470")

	photo_prop.trigger_interaction()
	_expect(station.is_photo_inserted, "photograph must be inserted into frame")
	_expect(station.photo_frame_inspected, "photo frame must be inspected")
	_expect(photo_prop.is_activated, "photo frame prop must be activated")
	_expect(station.is_circuit_aligned, "circuit alignment must be triggered upon photo insertion")
	_expect(station.is_airlock_unlocked, "tech passage airlock must be unlocked")
	_expect(airlock_prop.is_activated, "TechPassageAirlock prop must be activated")

	# Test 6: Step through remaining dialogue lines (4..8) and verify shadow development
	station.start_dialogue(4)
	_expect(station.dialogue_index == 4, "dialogue must be at line 4 (LENA: Puste gniazdo w ramie)")

	var l5 := station.advance_dialogue()
	_expect(l5 == 5, "dialogue must advance to line 5 (ŚWIADECTWO: Wsuwasz fotografię)")

	var l6 := station.advance_dialogue()
	_expect(l6 == 6, "dialogue must advance to line 6 (ŚWIADECTWO: Dorosły cień narasta)")
	_expect(station._shadow_progress > 0.0, "shadow progress must advance")

	var l7 := station.advance_dialogue()
	_expect(l7 == 7, "dialogue must advance to line 7 (LENA: Pamięć jest kluczem i ceną)")

	var l8 := station.advance_dialogue()
	_expect(l8 == 8, "dialogue must advance to line 8 (ŚWIADECTWO: Śluza odryglowana)")

	var l_end := station.advance_dialogue()
	_expect(l_end == -1, "advancing past line 8 must complete dialogue and return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")

	# Process frames to advance shadow progress and airlock opening
	for f in range(25):
		await physics_frame

	_expect(station.is_airlock_unlocked, "airlock must remain unlocked")
	_expect(station._airlock_open_progress > 0.1, "airlock open progress must advance")

	# Test 7: Player enters Tech Passage Airlock zone at x=600 to transition to Space 14
	player.global_position = Vector2(600.0, 260.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station_13 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_14() -> void:
	var packed_station := load("res://scenes/levels/station_14.tscn") as PackedScene
	_expect(packed_station != null, "station 14 scene must load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station14
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 14: player missing")
	_expect(camera != null, "station 14: camera missing")
	_expect(geometry != null, "station 14: geometry root missing")
	_expect(props != null, "station 14: props root missing")
	_expect(airlock_zone != null, "station 14: airlock zone missing")

	if player == null or camera == null or props == null or airlock_zone == null:
		station.queue_free()
		await process_frame
		return

	var rack := props.get_node_or_null("MaintenanceRack") as MemoryResonancePoint
	var scratch := props.get_node_or_null("MetalScratchBeam") as MemoryResonancePoint
	var lever := props.get_node_or_null("SeamStabilizerLever") as MemoryResonancePoint
	var tape := props.get_node_or_null("TapePlaybackDeck") as MemoryResonancePoint
	var shaft := props.get_node_or_null("SubstructureConduitShaft") as MemoryResonancePoint

	_expect(rack != null, "station 14: MaintenanceRack prop missing")
	_expect(scratch != null, "station 14: MetalScratchBeam prop missing")
	_expect(lever != null, "station 14: SeamStabilizerLever prop missing")
	_expect(tape != null, "station 14: TapePlaybackDeck prop missing")
	_expect(shaft != null, "station 14: SubstructureConduitShaft prop missing")

	if rack == null or scratch == null or lever == null or tape == null or shaft == null:
		station.queue_free()
		await process_frame
		return

	_expect(rack.prop_type == MemoryResonancePoint.PropType.MAINTENANCE_RACK, "rack prop_type mismatch")
	_expect(scratch.prop_type == MemoryResonancePoint.PropType.METAL_SCRATCH_BEAM, "scratch beam prop_type mismatch")
	_expect(lever.prop_type == MemoryResonancePoint.PropType.SEAM_STABILIZER_LEVER, "seam lever prop_type mismatch")
	_expect(tape.prop_type == MemoryResonancePoint.PropType.TAPE_PLAYBACK_DECK, "tape deck prop_type mismatch")
	_expect(shaft.prop_type == MemoryResonancePoint.PropType.SUBSTRUCTURE_CONDUIT_SHAFT, "conduit shaft prop_type mismatch")

	# Test 1: Initial state verification
	_expect(not station.rack_inspected, "rack must start uninspected")
	_expect(not station.is_scratch_anchored, "scratch must start unanchored")
	_expect(not station.is_seam_clamped, "seam stabilizer must start unclamped")
	_expect(not station.is_tape_playing, "tape player must start inactive")
	_expect(not station.is_silence_discovered, "silence gap clue must start undiscovered")
	_expect(not station.is_shaft_unlocked, "conduit shaft must start locked")
	_expect(not station.is_level_completed, "station 14 must not start completed")

	# Test 2: Inspect Maintenance Rack (tools & calipers) at x=140
	player.global_position = Vector2(140.0, 260.0)
	for f in range(2):
		await physics_frame
	rack.trigger_interaction()

	_expect(station.rack_inspected, "rack must be marked inspected")
	_expect(station.dialogue_active, "inspecting rack must activate dialogue")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "LENA", "line 0 speaker must be LENA")

	# Test 3: Anchor the scratch in the metal beam at x=260 (Primary Anchor mechanic)
	player.global_position = Vector2(260.0, 230.0)
	for f in range(2):
		await physics_frame
	scratch.trigger_interaction()

	_expect(station.is_scratch_anchored, "scratch must be anchored")
	_expect(scratch.is_activated, "scratch prop must be activated")
	_expect(scratch.shadow_progress >= 0.99, "scratch shadow progress must reach 1.0")
	_expect(station.dialogue_index == 2, "anchoring scratch must advance dialogue to line 2")

	# Test 4: Engage seam stabilizer lever at x=360
	player.global_position = Vector2(360.0, 270.0)
	for f in range(2):
		await physics_frame
	lever.trigger_interaction()

	_expect(station.is_seam_clamped, "seam stabilizer must be clamped")
	_expect(lever.is_activated, "lever prop must be activated")
	_expect(station.is_shaft_unlocked, "anchored scratch + clamped seam must unlock substructure shaft")

	# Test 5: Tape playback deck at x=470 (voice degradation & clue discovery)
	player.global_position = Vector2(470.0, 265.0)
	for f in range(2):
		await physics_frame
	tape.trigger_interaction()

	_expect(station.is_tape_playing, "tape playback must be active")
	_expect(tape.is_activated, "tape deck prop must be activated")
	_expect(station.dialogue_index == 5, "tape playback must advance dialogue to line 5")

	# Test 6: Advance dialogue through all lines and verify narrative beats
	# Advance to Line 6: Jakub voice degradation noticed
	station.advance_dialogue()
	_expect(station.dialogue_index == 6, "dialogue must be at line 6")
	_expect(station.dialogue_lines[6]["is_witness"], "line 6 must be stage direction / witness")

	# Advance to Line 8: Searching for tape damage
	station.advance_dialogue() # to 7
	station.advance_dialogue() # to 8
	_expect(station.dialogue_index == 8, "dialogue must be at line 8")

	# Advance to Line 9: 3rd-second silence discovered (Clue R-04 / R-05)
	station.advance_dialogue()
	_expect(station.dialogue_index == 9, "dialogue must be at line 9")
	_expect(station.is_silence_discovered, "3rd-second silence clue must be registered")

	# Advance to Line 11: Final clearance and conduit shaft unlocked
	station.advance_dialogue() # to 10
	station.advance_dialogue() # to 11
	_expect(station.dialogue_index == 11, "dialogue must be at line 11")
	_expect(station.is_shaft_unlocked, "shaft must remain unlocked")
	_expect(shaft.is_activated, "shaft prop must be activated")

	# Advance past line 11 to complete dialogue
	var l_end := station.advance_dialogue()
	_expect(l_end == -1, "advancing past line 11 must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")

	# Process frames for shaft opening animation
	for f in range(25):
		await physics_frame

	_expect(station._shaft_open_progress > 0.1, "shaft open progress must advance")

	# Test 7: Player enters AirlockZone at x=590 to transition to Space 15
	player.global_position = Vector2(590.0, 250.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 14 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_15() -> void:
	var packed_station := load("res://scenes/levels/station_15.tscn") as PackedScene
	_expect(packed_station != null, "station 15 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station15
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 15: player missing")
	_expect(camera != null, "station 15: camera missing")
	_expect(geometry != null, "station 15: geometry root missing")
	_expect(props != null, "station 15: props root missing")
	_expect(airlock_zone != null, "station 15: airlock zone missing")

	if player == null or camera == null or props == null or airlock_zone == null:
		station.queue_free()
		await process_frame
		return

	var hygiene_board := props.get_node_or_null("HygieneInstructionBoard") as MemoryResonancePoint
	var formula := props.get_node_or_null("HandwrittenCorrelationFormula") as MemoryResonancePoint
	var puddle := props.get_node_or_null("ReflectivePuddle") as MemoryResonancePoint
	var valve := props.get_node_or_null("PressureReliefValve") as MemoryResonancePoint
	var gate := props.get_node_or_null("TransitServiceGate") as MemoryResonancePoint

	_expect(hygiene_board != null, "station 15: HygieneInstructionBoard prop missing")
	_expect(formula != null, "station 15: HandwrittenCorrelationFormula prop missing")
	_expect(puddle != null, "station 15: ReflectivePuddle prop missing")
	_expect(valve != null, "station 15: PressureReliefValve prop missing")
	_expect(gate != null, "station 15: TransitServiceGate prop missing")

	if hygiene_board == null or formula == null or puddle == null or valve == null or gate == null:
		station.queue_free()
		await process_frame
		return

	_expect(hygiene_board.prop_type == MemoryResonancePoint.PropType.HYGIENE_INSTRUCTION_BOARD, "hygiene board prop_type mismatch")
	_expect(formula.prop_type == MemoryResonancePoint.PropType.HANDWRITTEN_CORRELATION_FORMULA, "correlation formula prop_type mismatch")
	_expect(puddle.prop_type == MemoryResonancePoint.PropType.REFLECTIVE_PUDDLE, "reflective puddle prop_type mismatch")
	_expect(valve.prop_type == MemoryResonancePoint.PropType.PRESSURE_RELIEF_VALVE, "pressure valve prop_type mismatch")
	_expect(gate.prop_type == MemoryResonancePoint.PropType.TRANSIT_SERVICE_GATE, "transit gate prop_type mismatch")

	# Test 1: Initial state verification
	_expect(not station.is_hygiene_inspected, "hygiene board must start uninspected")
	_expect(not station.is_formula_discovered, "correlation formula must start undiscovered")
	_expect(not station.is_reflection_revealed, "reflection vector must start unrevealed")
	_expect(not station.is_pressure_released, "pressure valve must start unreleased")
	_expect(not station.is_gate_unlocked, "transit gate must start locked")
	_expect(not station.is_level_completed, "station 15 must not start completed")

	# Test 2: Inspect Hygiene Instruction Board at x=130
	player.global_position = Vector2(130.0, 230.0)
	for f in range(2):
		await physics_frame
	hygiene_board.trigger_interaction()

	_expect(station.is_hygiene_inspected, "hygiene board must be marked inspected")
	_expect(station.dialogue_active, "inspecting hygiene board must activate dialogue")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "LENA", "line 0 speaker must be LENA")

	# Advance dialogue to line 2 (reading guidelines)
	station.advance_dialogue() # to 1
	station.advance_dialogue() # to 2
	_expect(station.dialogue_index == 2, "dialogue must be at line 2")

	# Test 3: Discover Handwritten Correlation Formula at x=250 (Clue R-06)
	player.global_position = Vector2(250.0, 210.0)
	for f in range(2):
		await physics_frame
	formula.trigger_interaction()

	_expect(station.is_formula_discovered, "correlation formula must be discovered")
	_expect(formula.is_activated, "formula prop must be activated")
	_expect(station.dialogue_index == 3, "discovering formula must advance dialogue to line 3")

	# Advance dialogue through formula analysis (lines 3..5)
	station.advance_dialogue() # to 4
	station.advance_dialogue() # to 5
	_expect(station.dialogue_index == 5, "dialogue must be at line 5")

	# Test 4: Inspect Reflective Puddle at x=370 (Asynchronous reflection vector)
	player.global_position = Vector2(370.0, 305.0)
	for f in range(2):
		await physics_frame
	puddle.trigger_interaction()

	_expect(station.is_reflection_revealed, "reflection vector must be revealed")
	_expect(puddle.is_activated, "puddle prop must be activated")
	_expect(station.dialogue_index == 6, "inspecting puddle must advance dialogue to line 6")

	# Advance dialogue through reflection vector revelation (lines 6..8)
	station.advance_dialogue() # to 7
	station.advance_dialogue() # to 8
	_expect(station.dialogue_index == 8, "dialogue must be at line 8")

	# Test 5: Release Pressure Relief Valve at x=480
	player.global_position = Vector2(480.0, 240.0)
	for f in range(2):
		await physics_frame
	valve.trigger_interaction()

	_expect(station.is_pressure_released, "pressure valve must be released")
	_expect(valve.is_activated, "valve prop must be activated")
	_expect(station.is_gate_unlocked, "releasing pressure must unlock transit service gate")
	_expect(gate.is_activated, "transit gate prop must be activated")
	_expect(station.dialogue_index == 9, "releasing pressure must advance dialogue to line 9")

	# Test 6: Advance dialogue through completion (lines 9..11)
	station.advance_dialogue() # to 10
	station.advance_dialogue() # to 11
	_expect(station.dialogue_index == 11, "dialogue must be at line 11")

	station.advance_dialogue() # past 11
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")

	# Process frames for steam and gate animations
	for f in range(25):
		await physics_frame

	_expect(station._pressure_vent_progress > 0.1, "pressure vent animation must progress")
	_expect(station._gate_open_progress > 0.1, "gate open animation must progress")

	# Test 7: Player enters AirlockZone at x=590 to transition to Space 16
	player.global_position = Vector2(590.0, 245.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 15 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_16() -> void:
	var packed_station := load("res://scenes/levels/station_16.tscn") as PackedScene
	_expect(packed_station != null, "station 16 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station16
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 16: player missing")
	_expect(camera != null, "station 16: camera missing")
	_expect(geometry != null, "station 16: geometry root missing")
	_expect(props != null, "station 16: props root missing")
	_expect(airlock_zone != null, "station 16: airlock zone missing")

	if player == null or camera == null or props == null or airlock_zone == null:
		station.queue_free()
		await process_frame
		return

	var clock := props.get_node_or_null("KitchenClock") as MemoryResonancePoint
	var cup := props.get_node_or_null("CrackedTeaCup") as MemoryResonancePoint
	var dossier := props.get_node_or_null("CorrelationDossier") as MemoryResonancePoint
	var ring_stand := props.get_node_or_null("WeddingRingStand") as MemoryResonancePoint
	var balcony := props.get_node_or_null("BalconyExitDoor") as MemoryResonancePoint

	_expect(clock != null, "station 16: KitchenClock prop missing")
	_expect(cup != null, "station 16: CrackedTeaCup prop missing")
	_expect(dossier != null, "station 16: CorrelationDossier prop missing")
	_expect(ring_stand != null, "station 16: WeddingRingStand prop missing")
	_expect(balcony != null, "station 16: BalconyExitDoor prop missing")

	if clock == null or cup == null or dossier == null or ring_stand == null or balcony == null:
		station.queue_free()
		await process_frame
		return

	_expect(clock.prop_type == MemoryResonancePoint.PropType.KITCHEN_CLOCK, "kitchen clock prop_type mismatch")
	_expect(cup.prop_type == MemoryResonancePoint.PropType.CRACKED_TEA_CUP, "tea cup prop_type mismatch")
	_expect(dossier.prop_type == MemoryResonancePoint.PropType.CORRELATION_DOSSIER, "dossier prop_type mismatch")
	_expect(ring_stand.prop_type == MemoryResonancePoint.PropType.WEDDING_RING_STAND, "ring stand prop_type mismatch")
	_expect(balcony.prop_type == MemoryResonancePoint.PropType.BALCONY_EXIT_DOOR, "balcony door prop_type mismatch")

	# Test 1: Initial state verification
	_expect(not station.is_cup_inspected, "tea cup must start uninspected")
	_expect(not station.is_dossier_reviewed, "dossier must start unreviewed")
	_expect(not station.is_clock_inspected, "clock must start uninspected")
	_expect(not station.is_ring_chosen, "ring choice must start unchosen")
	_expect(not station.is_balcony_unlocked, "balcony door must start locked")
	_expect(not station.is_level_completed, "station 16 must not start completed")

	# Test 2: Inspect Kitchen Clock at x=140
	player.global_position = Vector2(140.0, 200.0)
	for f in range(2):
		await physics_frame
	clock.trigger_interaction()

	_expect(station.is_clock_inspected, "kitchen clock must be marked inspected")
	_expect(clock.is_activated, "clock prop must be activated")

	# Test 3: Inspect Cracked Tea Cup at x=250 (Triggers D-05 Dialogue start)
	player.global_position = Vector2(250.0, 240.0)
	for f in range(2):
		await physics_frame
	cup.trigger_interaction()

	_expect(station.is_cup_inspected, "tea cup must be marked inspected")
	_expect(station.dialogue_active, "inspecting cup must activate dialogue D-05")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "LENA", "line 0 speaker must be LENA")

	# Test 4: Review Correlation Dossier at x=310
	player.global_position = Vector2(310.0, 240.0)
	for f in range(2):
		await physics_frame
	dossier.trigger_interaction()

	_expect(station.is_dossier_reviewed, "correlation dossier must be reviewed")
	_expect(dossier.is_activated, "dossier prop must be activated")

	# Test 5: Advance through D-05 dialogue lines (lines 1..9)
	station.advance_dialogue() # to 1 (Stage direction)
	_expect(station.dialogue_index == 1, "dialogue must be at line 1")
	_expect(station.dialogue_lines[1]["is_witness"], "line 1 must be stage direction")

	station.advance_dialogue() # to 2 (Marta)
	station.advance_dialogue() # to 3 (Lena: Daty sa w zlej kolejnosci)
	station.advance_dialogue() # to 4 (Marta: Daty sa nasze)
	station.advance_dialogue() # to 5 (Lena: W moim swiecie sie nie znalysmy)
	station.advance_dialogue() # to 6 (Stage direction: Klej wyplywa na stol)
	station.advance_dialogue() # to 7 (Marta: Pytalam?)
	station.advance_dialogue() # to 8 (Lena: Chcialas)
	station.advance_dialogue() # to 9 (Marta: Chcialam, zebys nie odpowiadala tak szybko)
	_expect(station.dialogue_index == 9, "dialogue must be at line 9")

	station.advance_dialogue() # to 10 (Lena: ring choice prompt)
	_expect(station.dialogue_index == 10, "dialogue must be at line 10")

	# Test 6: Execute Interactive Ring Choice on Wedding Ring Stand at x=370
	player.global_position = Vector2(370.0, 240.0)
	for f in range(2):
		await physics_frame

	# 6a: Test 'leave' ring disposition choice per D-05 ("To jest twoje" -> "Nie. Ja swojej nie zgubiłam.")
	station.make_ring_choice("leave")
	_expect(station.is_ring_chosen, "ring choice must be registered")
	_expect(station.ring_disposition == "leave", "ring disposition must be 'leave'")
	_expect(station.is_balcony_unlocked, "making ring choice must unlock balcony exit door")
	_expect(balcony.is_activated, "balcony door prop must be activated")

	# 6b: Test alternate ring disposition choices ("wear" and "sample")
	station.make_ring_choice("wear")
	_expect(station.ring_disposition == "wear", "ring disposition updated to 'wear'")
	station.make_ring_choice("sample")
	_expect(station.ring_disposition == "sample", "ring disposition updated to 'sample'")

	# Test 7: Complete dialogue through lines 11..12
	station.advance_dialogue() # to 11
	_expect(station.dialogue_index == 11, "dialogue must be at line 11")
	station.advance_dialogue() # to 12
	_expect(station.dialogue_index == 12, "dialogue must be at line 12")

	var l_end := station.advance_dialogue() # past 12
	_expect(l_end == -1, "advancing past final line must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")

	# Process frames for balcony door glow animation
	for f in range(20):
		await physics_frame

	_expect(station._balcony_open_progress > 0.1, "balcony open progress must advance")

	# Test 8: Player enters AirlockZone at x=590 to transition to Space 17
	player.global_position = Vector2(590.0, 245.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 16 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_17() -> void:
	var packed_station := load("res://scenes/levels/station_17.tscn") as PackedScene
	_expect(packed_station != null, "station 17 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station17
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 17: player missing")
	_expect(camera != null, "station 17: camera missing")
	_expect(geometry != null, "station 17: geometry missing")
	_expect(props != null, "station 17: props container missing")
	_expect(airlock != null, "station 17: airlock zone missing")

	if props == null:
		station.queue_free()
		await process_frame
		return

	var ticket_dispenser := props.get_node_or_null("QueuingTicketDispenser") as MemoryResonancePoint
	var waiting_bench := props.get_node_or_null("ComplianceWaitingBench") as MemoryResonancePoint
	var pneumatic_station := props.get_node_or_null("PneumaticDossierStation") as MemoryResonancePoint
	var diagnostic_printer := props.get_node_or_null("DiagnosticMemoryPrinter") as MemoryResonancePoint
	var office_door := props.get_node_or_null("ConsultationOfficeDoor") as MemoryResonancePoint

	_expect(ticket_dispenser != null, "station 17: QueuingTicketDispenser prop missing")
	_expect(waiting_bench != null, "station 17: ComplianceWaitingBench prop missing")
	_expect(pneumatic_station != null, "station 17: PneumaticDossierStation prop missing")
	_expect(diagnostic_printer != null, "station 17: DiagnosticMemoryPrinter prop missing")
	_expect(office_door != null, "station 17: ConsultationOfficeDoor prop missing")

	if ticket_dispenser == null or waiting_bench == null or pneumatic_station == null or diagnostic_printer == null or office_door == null:
		station.queue_free()
		await process_frame
		return

	_expect(ticket_dispenser.prop_type == MemoryResonancePoint.PropType.QUEUING_TICKET_DISPENSER, "ticket dispenser prop_type mismatch")
	_expect(waiting_bench.prop_type == MemoryResonancePoint.PropType.COMPLIANCE_WAITING_BENCH, "waiting bench prop_type mismatch")
	_expect(pneumatic_station.prop_type == MemoryResonancePoint.PropType.PNEUMATIC_DOSSIER_STATION, "pneumatic station prop_type mismatch")
	_expect(diagnostic_printer.prop_type == MemoryResonancePoint.PropType.DIAGNOSTIC_MEMORY_PRINTER, "diagnostic printer prop_type mismatch")
	_expect(office_door.prop_type == MemoryResonancePoint.PropType.CONSULTATION_OFFICE_DOOR, "office door prop_type mismatch")

	# Test 1: Initial state verification
	_expect(not station.is_ticket_dispensed, "ticket dispenser must start uninspected")
	_expect(not station.is_bench_inspected, "waiting bench must start uninspected")
	_expect(not station.is_pneumatic_dispatched, "pneumatic station must start undispatched")
	_expect(not station.is_diagnostic_initiated, "diagnostic printer must start uninitiated")
	_expect(not station.is_office_door_unlocked, "consultation office door must start locked")
	_expect(not station.is_level_completed, "station 17 must not start completed")

	# Test 2: Inspect Queuing Ticket Dispenser at x=130 (Issues Case 084/17 - status from 17 days ago)
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	ticket_dispenser.trigger_interaction()

	_expect(station.is_ticket_dispensed, "ticket dispenser must be marked dispensed")
	_expect(ticket_dispenser.is_activated, "ticket dispenser prop must be activated")

	# Test 3: Inspect Compliance Waiting Bench at x=230
	player.global_position = Vector2(230.0, 240.0)
	for f in range(2):
		await physics_frame
	waiting_bench.trigger_interaction()

	_expect(station.is_bench_inspected, "waiting bench must be inspected")
	_expect(waiting_bench.is_activated, "waiting bench prop must be activated")

	# Test 4: Inspect Pneumatic Dossier Station at x=340 (Capsule transfer)
	player.global_position = Vector2(340.0, 240.0)
	for f in range(2):
		await physics_frame
	pneumatic_station.trigger_interaction()

	_expect(station.is_pneumatic_dispatched, "pneumatic dossier station must be dispatched")
	_expect(pneumatic_station.is_activated, "pneumatic station prop must be activated")

	# Test 5: Inspect Diagnostic Memory Printer at x=450 (Triggers D-06 Dialogue start)
	player.global_position = Vector2(450.0, 240.0)
	for f in range(2):
		await physics_frame
	diagnostic_printer.trigger_interaction()

	_expect(station.is_diagnostic_initiated, "diagnostic printer must be initiated")
	_expect(diagnostic_printer.is_activated, "diagnostic printer prop must be activated")
	_expect(station.dialogue_active, "diagnostic initiation must activate D-06 dialogue")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "WIERZBICKA", "line 0 speaker must be WIERZBICKA")

	# Test 6: Advance through D-06 dialogue lines (lines 1..11)
	station.advance_dialogue() # to 1 (Lena: Przyszlam z wlasnej woli)
	_expect(station.dialogue_index == 1, "dialogue must be at line 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")

	station.advance_dialogue() # to 2 (Wierzbicka: Zapach korytarza po identyfikacji ciala)
	station.advance_dialogue() # to 3 (Lena: To nie jest pytanie)
	station.advance_dialogue() # to 4 (Wierzbicka: Prosze powiedziec pierwszy material)
	station.advance_dialogue() # to 5 (Lena: Chlor)
	station.advance_dialogue() # to 6 (Swiadectwo Pamieci: KAWA / LINOLEUM / MOKRA WEŁNA)
	_expect(station.dialogue_index == 6, "dialogue must be at line 6")
	_expect(station.dialogue_lines[6]["is_witness"], "line 6 must be stage direction / witness")

	station.advance_dialogue() # to 7 (Wierzbicka: Chlor jest odpowiedzia uporzadkowana)
	station.advance_dialogue() # to 8 (Lena: Skad ja ma?)
	station.advance_dialogue() # to 9 (Wierzbicka: Z miejsca, ktore pamieta pania dluzej)
	station.advance_dialogue() # to 10 (Lena: Chce wrocic)
	station.advance_dialogue() # to 11 (Wierzbicka: Do wspolrzednych czy do przekonania?)
	_expect(station.dialogue_index == 11, "dialogue must be at line 11")

	var l_end := station.advance_dialogue() # past 11
	_expect(l_end == -1, "advancing past final line must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")
	_expect(station.is_office_door_unlocked, "completing D-06 must unlock consultation office door")
	_expect(office_door.is_activated, "consultation office door prop must be activated")

	# Process frames for door open glow animation
	for f in range(20):
		await physics_frame

	_expect(station._door_open_progress > 0.1, "office door open progress must advance")

	# Test 7: Player enters AirlockZone at x=590 to transition to Space 18
	player.global_position = Vector2(590.0, 245.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 17 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_18() -> void:
	var packed_station := load("res://scenes/levels/station_18.tscn") as PackedScene
	_expect(packed_station != null, "station 18 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station18
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 18: player missing")
	_expect(camera != null, "station 18: camera missing")
	_expect(geometry != null, "station 18: geometry missing")
	_expect(props != null, "station 18: props container missing")
	_expect(airlock != null, "station 18: airlock zone missing")

	if props == null:
		station.queue_free()
		await process_frame
		return

	var desk := props.get_node_or_null("WierzbickaDesk") as MemoryResonancePoint
	var memory_map := props.get_node_or_null("SensoryMemoryMap") as MemoryResonancePoint
	var galvanometer := props.get_node_or_null("CorrectionGalvanometer") as MemoryResonancePoint
	var conduit := props.get_node_or_null("AcousticWeightConduit") as MemoryResonancePoint
	var model_airlock := props.get_node_or_null("ModelRoomAirlock") as MemoryResonancePoint

	_expect(desk != null, "station 18: WierzbickaDesk prop missing")
	_expect(memory_map != null, "station 18: SensoryMemoryMap prop missing")
	_expect(galvanometer != null, "station 18: CorrectionGalvanometer prop missing")
	_expect(conduit != null, "station 18: AcousticWeightConduit prop missing")
	_expect(model_airlock != null, "station 18: ModelRoomAirlock prop missing")

	if desk == null or memory_map == null or galvanometer == null or conduit == null or model_airlock == null:
		station.queue_free()
		await process_frame
		return

	_expect(desk.prop_type == MemoryResonancePoint.PropType.WIERZBICKA_DESK, "desk prop_type mismatch")
	_expect(memory_map.prop_type == MemoryResonancePoint.PropType.SENSORY_MEMORY_MAP, "memory map prop_type mismatch")
	_expect(galvanometer.prop_type == MemoryResonancePoint.PropType.CORRECTION_GALVANOMETER, "galvanometer prop_type mismatch")
	_expect(conduit.prop_type == MemoryResonancePoint.PropType.ACOUSTIC_WEIGHT_CONDUIT, "conduit prop_type mismatch")
	_expect(model_airlock.prop_type == MemoryResonancePoint.PropType.MODEL_ROOM_AIRLOCK, "model room airlock prop_type mismatch")

	# Test 1: Initial state verification
	_expect(not station.is_desk_approached, "desk must start unapproached")
	_expect(not station.is_map_inspected, "map must start uninspected")
	_expect(not station.is_galvanometer_triggered, "galvanometer must start untriggered")
	_expect(not station.is_strain_detected, "strain must start undetected")
	_expect(not station.is_airlock_unlocked, "airlock must start locked")
	_expect(not station.is_level_completed, "station 18 must not start completed")

	# Test 2: Inspect sensory memory map (x=90)
	player.global_position = Vector2(90.0, 240.0)
	for f in range(2):
		await physics_frame
	memory_map.trigger_interaction()

	_expect(station.is_map_inspected, "memory map must be inspected")
	_expect(memory_map.is_activated, "memory map prop must be activated")

	# Test 3: Inspect acoustic weight conduit (x=180)
	player.global_position = Vector2(180.0, 240.0)
	for f in range(2):
		await physics_frame
	conduit.trigger_interaction()

	_expect(station.is_strain_detected, "acoustic weight conduit must be triggered")
	_expect(conduit.is_activated, "conduit prop must be activated")

	# Test 4: Approach Wierzbicka desk at x=300 (triggers D-07 dialogue)
	player.global_position = Vector2(300.0, 240.0)
	for f in range(2):
		await physics_frame
	desk.trigger_interaction()

	_expect(station.is_desk_approached, "desk must be marked approached")
	_expect(desk.is_activated, "desk prop must be activated")
	_expect(station.dialogue_active, "desk interaction must activate D-07 dialogue")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "WIERZBICKA", "line 0 speaker must be WIERZBICKA")

	# Test 5: Advance through D-07 dialogue lines
	station.advance_dialogue() # to 1 (Lena: Dobrze)
	_expect(station.dialogue_index == 1, "dialogue must be at line 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")

	station.advance_dialogue() # to 2 (Wierzbicka: Zapach szpitala)
	station.advance_dialogue() # to 3 (Lena: Środek dezynfekcyjny)
	station.advance_dialogue() # to 4 (ŚWIADECTWO: galwanometr przyjmuje lawendę)
	_expect(station.dialogue_index == 4, "dialogue must be at line 4")
	_expect(station.dialogue_lines[4]["is_witness"], "line 4 must be witness stage direction")
	_expect(station.is_galvanometer_triggered, "galvanometer must be triggered after first lie accepted")

	station.advance_dialogue() # to 5 (Wierzbicka: Strona peronu)
	station.advance_dialogue() # to 6 (Lena: Prawa)
	station.advance_dialogue() # to 7 (ŚWIADECTWO: zapis galwaniczny prawa)
	_expect(station.dialogue_lines[7]["is_witness"], "line 7 must be witness stage direction")

	station.advance_dialogue() # to 8 (Wierzbicka: Ciepło dłoni Jakuba)
	station.advance_dialogue() # to 9 (Lena: Nie pamiętam)
	station.advance_dialogue() # to 10 (ŚWIADECTWO: system stabilizuje narrację)
	_expect(station.dialogue_index == 10, "dialogue must be at line 10")
	_expect(station.dialogue_lines[10]["is_witness"], "line 10 must be witness stage direction")

	station.advance_dialogue() # to 11 (Wierzbicka: Procedura zakończona)
	_expect(station.dialogue_index == 11, "dialogue must be at line 11")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past final line must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")
	_expect(station.is_airlock_unlocked, "completing D-07 must unlock model room airlock")
	_expect(model_airlock.is_activated, "model room airlock prop must be activated")
	_expect(galvanometer.is_activated, "galvanometer prop must be activated at dialogue end")
	_expect(conduit.is_activated, "conduit prop must be activated at dialogue end")

	# Process frames for airlock glow animation
	for f in range(20):
		await physics_frame

	_expect(station._airlock_open_progress > 0.1, "airlock open progress must advance")

	# Test 6: Player enters AirlockZone at x=600 to transition to Space 19
	player.global_position = Vector2(600.0, 245.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 18 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_19() -> void:
	var packed_station := load("res://scenes/levels/station_19.tscn") as PackedScene
	_expect(packed_station != null, "station 19 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station19
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 19: player missing")
	_expect(camera != null, "station 19: camera missing")
	_expect(geometry != null, "station 19: geometry missing")
	_expect(props != null, "station 19: props container missing")
	_expect(airlock != null, "station 19: airlock zone missing")

	if props == null:
		station.queue_free()
		await process_frame
		return

	var table := props.get_node_or_null("ModelDisplayTable") as MemoryResonancePoint
	var map_left := props.get_node_or_null("StaircaseMapLeft") as MemoryResonancePoint
	var map_right := props.get_node_or_null("StaircaseMapRight") as MemoryResonancePoint
	var ledger := props.get_node_or_null("ElevenPersonsLedger") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("ModelRoomExit") as MemoryResonancePoint

	_expect(table != null, "station 19: ModelDisplayTable prop missing")
	_expect(map_left != null, "station 19: StaircaseMapLeft prop missing")
	_expect(map_right != null, "station 19: StaircaseMapRight prop missing")
	_expect(ledger != null, "station 19: ElevenPersonsLedger prop missing")
	_expect(exit_prop != null, "station 19: ModelRoomExit prop missing")

	if table == null or map_left == null or map_right == null or ledger == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(table.prop_type == MemoryResonancePoint.PropType.MODEL_DISPLAY_TABLE, "table prop_type mismatch")
	_expect(map_left.prop_type == MemoryResonancePoint.PropType.STAIRCASE_MAP_LEFT, "map_left prop_type mismatch")
	_expect(map_right.prop_type == MemoryResonancePoint.PropType.STAIRCASE_MAP_RIGHT, "map_right prop_type mismatch")
	_expect(ledger.prop_type == MemoryResonancePoint.PropType.ELEVEN_PERSONS_LEDGER, "ledger prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.MODEL_ROOM_EXIT, "exit prop_type mismatch")

	# Test 1: Initial state verification
	_expect(not station.is_table_approached, "table must start unapproached")
	_expect(not station.is_map_left_inspected, "map left must start uninspected")
	_expect(not station.is_map_right_inspected, "map right must start uninspected")
	_expect(not station.is_ledger_inspected, "ledger must start uninspected")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "station 19 must not start completed")

	# Test 2: Inspect left schematic map (x=130)
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	map_left.trigger_interaction()

	_expect(station.is_map_left_inspected, "left map must be marked inspected")
	_expect(map_left.is_activated, "left map prop must be activated")

	# Test 3: Inspect right schematic map (x=490)
	player.global_position = Vector2(490.0, 240.0)
	for f in range(2):
		await physics_frame
	map_right.trigger_interaction()

	_expect(station.is_map_right_inspected, "right map must be marked inspected")
	_expect(map_right.is_activated, "right map prop must be activated")

	# Test 4: Inspect eleven persons ledger (x=220)
	player.global_position = Vector2(220.0, 240.0)
	for f in range(2):
		await physics_frame
	ledger.trigger_interaction()

	_expect(station.is_ledger_inspected, "ledger must be marked inspected")
	_expect(ledger.is_activated, "ledger prop must be activated")

	# Test 5: Approach model display table at x=310 (triggers D-07 dialogue sequence)
	player.global_position = Vector2(310.0, 240.0)
	for f in range(2):
		await physics_frame
	table.trigger_interaction()

	_expect(station.is_table_approached, "table must be marked approached")
	_expect(table.is_activated, "table prop must be activated")
	_expect(station.dialogue_active, "table interaction must activate D-07 dialogue")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "WIERZBICKA", "line 0 speaker must be WIERZBICKA")

	# Test 6: Advance through D-07 dialogue lines
	station.advance_dialogue() # to 1 (Lena: Która jest prawdziwa?)
	_expect(station.dialogue_index == 1, "dialogue must be at line 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")

	station.advance_dialogue() # to 2 (Wierzbicka: Ta, po której...)
	_expect(station.dialogue_index == 2, "dialogue must be at line 2")

	station.advance_dialogue() # to 3 (Lena: To nie odpowiedź.)
	_expect(station.dialogue_index == 3, "dialogue must be at line 3")

	station.advance_dialogue() # to 4 (Wierzbicka: To odpowiedzialność z terminem.)
	_expect(station.dialogue_index == 4, "dialogue must be at line 4")

	station.advance_dialogue() # to 5 (Wierzbicka: Nikt nie zginął...)
	_expect(station.dialogue_index == 5, "dialogue must be at line 5")

	station.advance_dialogue() # to 6 (Lena: A kogo przesunęliście?)
	_expect(station.dialogue_index == 6, "dialogue must be at line 6")

	station.advance_dialogue() # to 7 (Wierzbicka: Tego właśnie jeszcze nie wiemy.)
	_expect(station.dialogue_index == 7, "dialogue must be at line 7")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past final line must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")
	_expect(station.is_exit_unlocked, "completing D-07 must unlock exit to Space 20")
	_expect(exit_prop.is_activated, "exit prop must be activated at dialogue end")
	_expect(table.is_activated, "table prop must be activated at dialogue end")

	# Process frames for exit indicator animation
	for f in range(20):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 7: Player enters AirlockZone at x=610 to transition to Space 20
	player.global_position = Vector2(610.0, 245.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 19 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_20() -> void:
	var packed_station := load("res://scenes/levels/station_20.tscn") as PackedScene
	_expect(packed_station != null, "station_20 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station20
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_20: player missing")
	_expect(camera != null, "station_20: camera missing")
	_expect(geometry != null, "station_20: geometry missing")
	_expect(props != null, "station_20: props node missing")
	_expect(airlock_zone != null, "station_20: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var szymon_prop := props.get_node_or_null("SzymonBera") as MemoryResonancePoint
	var drawing_prop := props.get_node_or_null("WellDrawing") as MemoryResonancePoint
	var report_prop := props.get_node_or_null("HydrologyReport") as MemoryResonancePoint
	var magnifier_prop := props.get_node_or_null("ErasedSignatureMagnifier") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("SzymonRoomExit") as MemoryResonancePoint

	_expect(szymon_prop != null, "SzymonBera prop missing in station_20")
	_expect(drawing_prop != null, "WellDrawing prop missing in station_20")
	_expect(report_prop != null, "HydrologyReport prop missing in station_20")
	_expect(magnifier_prop != null, "ErasedSignatureMagnifier prop missing in station_20")
	_expect(exit_prop != null, "SzymonRoomExit prop missing in station_20")

	if szymon_prop == null or drawing_prop == null or report_prop == null or magnifier_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	# Initial state
	_expect(not station.is_szymon_approached, "szymon should not be approached initially")
	_expect(not station.is_drawing_inspected, "drawing should not be inspected initially")
	_expect(not station.is_report_inspected, "hydrology report should not be inspected initially")
	_expect(not station.is_magnifier_inspected, "magnifier should not be inspected initially")
	_expect(not station.is_door_shifted, "door should not be shifted initially")
	_expect(station.drawing_choice == Station20.DrawingChoice.NONE, "drawing choice must be NONE initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect magnifier at x=140
	player.global_position = Vector2(140.0, 240.0)
	for f in range(2):
		await physics_frame
	magnifier_prop.trigger_interaction()

	_expect(station.is_magnifier_inspected, "magnifier must be marked inspected")
	_expect(magnifier_prop.is_activated, "magnifier prop must be activated")

	# Test 2: Inspect hydrology report at x=420
	player.global_position = Vector2(420.0, 240.0)
	for f in range(2):
		await physics_frame
	report_prop.trigger_interaction()

	_expect(station.is_report_inspected, "report must be marked inspected")
	_expect(report_prop.is_activated, "report prop must be activated")

	# Test 3: Inspect well drawing at x=330 (triggers D-08 dialogue)
	player.global_position = Vector2(330.0, 240.0)
	for f in range(2):
		await physics_frame
	drawing_prop.trigger_interaction()

	_expect(station.is_drawing_inspected, "drawing must be marked inspected")
	_expect(drawing_prop.is_activated, "drawing prop must be activated")
	_expect(station.dialogue_active, "drawing interaction must activate D-08 dialogue")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "SZYMON", "line 0 speaker must be SZYMON")

	# Test 4: Step through D-08 dialogue lines
	station.advance_dialogue() # to 1 (LENA: Nie widzę podpisu.)
	_expect(station.dialogue_index == 1, "dialogue must be at line 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")

	station.advance_dialogue() # to 2 (SZYMON: Wytarli. Papier jest cieńszy.)
	_expect(station.dialogue_index == 2, "dialogue must be at line 2")

	station.advance_dialogue() # to 3 (LENA: Jak miała na imię?)
	_expect(station.dialogue_index == 3, "dialogue must be at line 3")

	station.advance_dialogue() # to 4 (SZYMON: Iga. Nie zapisuj od razu...)
	_expect(station.dialogue_index == 4, "dialogue must be at line 4")

	station.advance_dialogue() # to 5 (LENA: Iga.)
	_expect(station.dialogue_index == 5, "dialogue must be at line 5")

	station.advance_dialogue() # to 6 (SZYMON: Jeszcze raz.)
	_expect(station.dialogue_index == 6, "dialogue must be at line 6")

	station.advance_dialogue() # to 7 (LENA: Iga.)
	_expect(station.dialogue_index == 7, "dialogue must be at line 7")

	station.advance_dialogue() # to 8 (ŚWIADECTWO: Drzwi sali przesuwają się o kilka centymetrów.)
	_expect(station.dialogue_index == 8, "dialogue must be at line 8")
	_expect(station.is_door_shifted, "door must be shifted at stage direction line 8")

	station.advance_dialogue() # to 9 (SZYMON: Widzisz? Nie lubią, kiedy są dwie osoby.)
	_expect(station.dialogue_index == 9, "dialogue must be at line 9")

	station.advance_dialogue() # to 10 (LENA: Mogę sprawdzić skażenie.)
	_expect(station.dialogue_index == 10, "dialogue must be at line 10")

	station.advance_dialogue() # to 11 (SZYMON: Sprawdź. Ale ona nie musi zatruć...)
	_expect(station.dialogue_index == 11, "dialogue must be at line 11")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past final line must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")
	_expect(station.is_exit_unlocked, "completing D-08 must unlock exit to Space 21")
	_expect(exit_prop.is_activated, "exit prop must be activated at dialogue end")

	# Test 5: Choose drawing disposition (Anchor Drawing)
	station.choose_drawing_disposition(Station20.DrawingChoice.ANCHOR_DRAWING)
	_expect(station.drawing_choice == Station20.DrawingChoice.ANCHOR_DRAWING, "drawing choice must be set to ANCHOR_DRAWING")

	# Process frames for door shift & exit indicator animation
	for f in range(20):
		await physics_frame

	_expect(station._door_shift_offset > 5.0, "door shift offset must advance")
	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to transition to Space 21
	player.global_position = Vector2(610.0, 245.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 20 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_21() -> void:
	var packed_station := load("res://scenes/levels/station_21.tscn") as PackedScene
	_expect(packed_station != null, "station_21 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station21
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_21: player missing")
	_expect(camera != null, "station_21: camera missing")
	_expect(geometry != null, "station_21: geometry missing")
	_expect(props != null, "station_21: props node missing")
	_expect(airlock_zone != null, "station_21: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var terminal_prop := props.get_node_or_null("AnesthesiaTerminal") as MemoryResonancePoint
	var szymon_prop := props.get_node_or_null("SzymonPostCorrection") as MemoryResonancePoint
	var pedestal_prop := props.get_node_or_null("DrawingDispositionPedestal") as MemoryResonancePoint
	var dossier_prop := props.get_node_or_null("FilteredDossierSlot") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station21Exit") as MemoryResonancePoint

	_expect(terminal_prop != null, "AnesthesiaTerminal prop missing in station_21")
	_expect(szymon_prop != null, "SzymonPostCorrection prop missing in station_21")
	_expect(pedestal_prop != null, "DrawingDispositionPedestal prop missing in station_21")
	_expect(dossier_prop != null, "FilteredDossierSlot prop missing in station_21")
	_expect(exit_prop != null, "Station21Exit prop missing in station_21")

	if terminal_prop == null or szymon_prop == null or pedestal_prop == null or dossier_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(terminal_prop.prop_type == MemoryResonancePoint.PropType.ANESTHESIA_TERMINAL, "terminal prop_type mismatch")
	_expect(szymon_prop.prop_type == MemoryResonancePoint.PropType.SZYMON_POST_CORRECTION, "szymon post prop_type mismatch")
	_expect(pedestal_prop.prop_type == MemoryResonancePoint.PropType.DRAWING_DISPOSITION_PEDESTAL, "pedestal prop_type mismatch")
	_expect(dossier_prop.prop_type == MemoryResonancePoint.PropType.FILTERED_DOSSIER_SLOT, "dossier slot prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_21_EXIT, "exit prop_type mismatch")

	# Initial state
	_expect(not station.is_szymon_approached, "szymon should not be approached initially")
	_expect(not station.is_terminal_inspected, "terminal should not be inspected initially")
	_expect(not station.is_dossier_inspected, "dossier should not be inspected initially")
	_expect(not station.is_pedestal_inspected, "pedestal should not be inspected initially")
	_expect(not station.is_erased_name_attempted, "erased name should not be attempted initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Anesthesia Terminal at x=140
	player.global_position = Vector2(140.0, 240.0)
	for f in range(2):
		await physics_frame
	terminal_prop.trigger_interaction()

	_expect(station.is_terminal_inspected, "terminal must be marked inspected")
	_expect(terminal_prop.is_activated, "terminal prop must be activated")

	# Test 2: Inspect Filtered Dossier Slot at x=480
	player.global_position = Vector2(480.0, 240.0)
	for f in range(2):
		await physics_frame
	dossier_prop.trigger_interaction()

	_expect(station.is_dossier_inspected, "dossier slot must be marked inspected")
	_expect(dossier_prop.is_activated, "dossier slot prop must be activated")

	# Test 3: Inspect Drawing Disposition Pedestal at x=380
	player.global_position = Vector2(380.0, 240.0)
	for f in range(2):
		await physics_frame
	pedestal_prop.trigger_interaction()

	_expect(station.is_pedestal_inspected, "pedestal must be marked inspected")
	_expect(pedestal_prop.is_activated, "pedestal prop must be activated")

	# Test 4: Step through Scene 21 dialogue (triggered by pedestal / approaching Szymon)
	_expect(station.dialogue_active, "dialogue must be activated")
	_expect(station.dialogue_index == 0, "dialogue must start at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "SZYMON", "line 0 speaker must be SZYMON")

	station.advance_dialogue() # to 1 (LENA: Iga.)
	_expect(station.dialogue_index == 1, "dialogue must be at line 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")

	station.advance_dialogue() # to 2 (ŚWIADECTWO: Szymon próbuje powtórzyć...)
	_expect(station.dialogue_index == 2, "dialogue must be at line 2")
	_expect(station.is_erased_name_attempted, "erased name attempted must be flagged at line 2")

	station.advance_dialogue() # to 3 (SZYMON: Nie zabieraj kartki. To miejsce po kimś.)
	_expect(station.dialogue_index == 3, "dialogue must be at line 3")

	station.advance_dialogue() # to 4 (LENA: Pamiętasz skażenie wody?)
	_expect(station.dialogue_index == 4, "dialogue must be at line 4")

	station.advance_dialogue() # to 5 (SZYMON: Woda w studni była zła...)
	_expect(station.dialogue_index == 5, "dialogue must be at line 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Fakt publiczny został nienaruszony...)
	_expect(station.dialogue_index == 6, "dialogue must be at line 6")

	station.advance_dialogue() # to 7 (LENA: Kto zgłosił studnię?)
	_expect(station.dialogue_index == 7, "dialogue must be at line 7")

	station.advance_dialogue() # to 8 (SZYMON: Nikt. Zgłoszenie było od zawsze.)
	_expect(station.dialogue_index == 8, "dialogue must be at line 8")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past final line must return -1")
	_expect(station.is_dialogue_completed, "dialogue must be marked completed")
	_expect(not station.dialogue_active, "dialogue must no longer be active")
	_expect(station.is_exit_unlocked, "completing dialogue must unlock exit to Space 22")
	_expect(exit_prop.is_activated, "exit prop must be activated at dialogue end")

	# Process frames for exit animation
	for f in range(20):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 5: Player enters AirlockZone at x=610 to transition to Space 22
	player.global_position = Vector2(610.0, 245.0)
	for frame in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 21 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_22() -> void:
	var packed_st22 := load("res://scenes/levels/station_22.tscn") as PackedScene
	_expect(packed_st22 != null, "station 22 scene does not load")
	if packed_st22 == null:
		return

	var station := packed_st22.instantiate() as Station22
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station 22: player missing")
	_expect(camera != null, "station 22: camera missing")
	_expect(geometry != null, "station 22: geometry missing")
	_expect(props != null, "station 22: props missing")
	_expect(airlock_zone != null, "station 22: airlock zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var register_prop := props.get_node_or_null("ComplianceContactRegister") as MemoryResonancePoint
	var ring_prop := props.get_node_or_null("RingFittingScanner") as MemoryResonancePoint
	var paint_prop := props.get_node_or_null("PaintResinResonanceSlab") as MemoryResonancePoint
	var gate_prop := props.get_node_or_null("BiometricIdentityGate") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station22Exit") as MemoryResonancePoint

	_expect(register_prop != null, "ComplianceContactRegister prop missing")
	_expect(ring_prop != null, "RingFittingScanner prop missing")
	_expect(paint_prop != null, "PaintResinResonanceSlab prop missing")
	_expect(gate_prop != null, "BiometricIdentityGate prop missing")
	_expect(exit_prop != null, "Station22Exit prop missing")

	if register_prop == null or ring_prop == null or paint_prop == null or gate_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(register_prop.prop_type == MemoryResonancePoint.PropType.COMPLIANCE_CONTACT_REGISTER, "register prop_type mismatch")
	_expect(ring_prop.prop_type == MemoryResonancePoint.PropType.RING_FITTING_SCANNER, "ring scanner prop_type mismatch")
	_expect(paint_prop.prop_type == MemoryResonancePoint.PropType.PAINT_RESIN_RESONANCE_SLAB, "paint slab prop_type mismatch")
	_expect(gate_prop.prop_type == MemoryResonancePoint.PropType.BIOMETRIC_IDENTITY_GATE, "biometric gate prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_22_EXIT, "exit prop_type mismatch")

	# Initial state
	_expect(not station.is_gate_scanned, "gate should not be scanned initially")
	_expect(not station.is_contact_inspected, "contact register should not be inspected initially")
	_expect(not station.is_ring_inspected, "ring scanner should not be inspected initially")
	_expect(not station.is_paint_recalled, "paint memory should not be recalled initially")
	_expect(not station.is_biographical_erasure_measured, "biographical erasure should not be measured initially")
	_expect(not station.is_yield_accepted, "yield should not be accepted initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Compliance Contact Register at x=140
	player.global_position = Vector2(140.0, 240.0)
	for f in range(2):
		await physics_frame
	register_prop.trigger_interaction()

	_expect(station.is_contact_inspected, "contact register must be marked inspected")
	_expect(register_prop.is_activated, "register prop must be activated")

	# Test 2: Inspect Ring Fitting Scanner at x=250
	player.global_position = Vector2(250.0, 245.0)
	for f in range(2):
		await physics_frame
	ring_prop.trigger_interaction()

	_expect(station.is_ring_inspected, "ring scanner must be marked inspected")
	_expect(ring_prop.is_activated, "ring prop must be activated")

	# Test 3: Inspect Paint Resin Resonance Slab at x=370
	player.global_position = Vector2(370.0, 240.0)
	for f in range(2):
		await physics_frame
	paint_prop.trigger_interaction()

	_expect(station.is_paint_recalled, "paint memory must be recalled")
	_expect(paint_prop.is_activated, "paint prop must be activated")

	# Test 4: Inspect Biometric Identity Gate at x=490
	player.global_position = Vector2(490.0, 235.0)
	for f in range(2):
		await physics_frame
	gate_prop.trigger_interaction()

	_expect(station.is_gate_scanned, "biometric gate must be marked scanned")
	_expect(gate_prop.is_activated, "gate prop must be activated")

	# Test 5: Step through Scene 22 dialogue sequence (10 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "LENA", "line 0 speaker must be LENA")

	station.advance_dialogue() # to 1 (ŚWIADECTWO)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	station.advance_dialogue() # to 2 (LENA)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	station.advance_dialogue() # to 3 (ŚWIADECTWO: Uległość / Yield)
	_expect(station.dialogue_index == 3, "dialogue at 3")
	station.advance_dialogue() # to 4 (LENA: Obrączka pasuje na palec...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_contact_inspected and station.is_ring_inspected, "ring and contact verified at line 4")

	station.advance_dialogue() # to 5 (ŚWIADECTWO: Napływa obce, ciepłe wspomnienie...)
	_expect(station.dialogue_index == 5, "dialogue at 5")
	_expect(station.is_paint_recalled, "paint memory recalled at line 5")

	station.advance_dialogue() # to 6 (LENA: Nigdy z nią nie malowałam...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (ŚWIADECTWO: Koszt korekty: szczegół z własnej gałęzi...)
	_expect(station.dialogue_index == 7, "dialogue at 7")
	_expect(station.is_biographical_erasure_measured, "biographical erasure measured at line 7")

	station.advance_dialogue() # to 8 (LENA: Próbuję przypomnieć sobie jej twarz...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (LENA: To tylko zmęczenie... Zapisuję jako błąd pomiaru i idę dalej.)
	_expect(station.dialogue_index == 9, "dialogue at 9")

	var l_end := station.advance_dialogue() # past end -> accepts Yield and unlocks exit
	_expect(l_end == -1, "advancing past line 9 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_yield_accepted, "completing dialogue must accept Yield")
	_expect(station.is_exit_unlocked, "accepting Yield must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door and warmth transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")
	_expect(station._yield_warmth_progress > 0.1, "yield warmth progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 22 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_23() -> void:
	var packed_station := load("res://scenes/levels/station_23.tscn") as PackedScene
	_expect(packed_station != null, "station_23 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station23
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_23: player missing")
	_expect(camera != null, "station_23: camera missing")
	_expect(geometry != null, "station_23: geometry missing")
	_expect(props != null, "station_23: props missing")
	_expect(airlock_zone != null, "station_23: airlock zone missing")

	if props == null or player == null or camera == null:
		station.queue_free()
		await process_frame
		return

	var terminal_prop := props.get_node_or_null("DesignerTerminal") as MemoryResonancePoint
	var model_prop := props.get_node_or_null("SubstructureModel") as MemoryResonancePoint
	var ledger_prop := props.get_node_or_null("BurdenedLedger") as MemoryResonancePoint
	var console_prop := props.get_node_or_null("ShadowInteractiveConsole") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station23Exit") as MemoryResonancePoint

	_expect(terminal_prop != null, "DesignerTerminal prop missing")
	_expect(model_prop != null, "SubstructureModel prop missing")
	_expect(ledger_prop != null, "BurdenedLedger prop missing")
	_expect(console_prop != null, "ShadowInteractiveConsole prop missing")
	_expect(exit_prop != null, "Station23Exit prop missing")

	if terminal_prop == null or model_prop == null or ledger_prop == null or console_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(terminal_prop.prop_type == MemoryResonancePoint.PropType.DESIGNER_TERMINAL, "terminal prop_type mismatch")
	_expect(model_prop.prop_type == MemoryResonancePoint.PropType.SUBSTRUCTURE_ARCHITECTURAL_MODEL, "model prop_type mismatch")
	_expect(ledger_prop.prop_type == MemoryResonancePoint.PropType.BURDENED_PERSONS_LEDGER, "ledger prop_type mismatch")
	_expect(console_prop.prop_type == MemoryResonancePoint.PropType.SHADOW_INTERACTIVE_CONSOLE, "console prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_23_EXIT, "exit prop_type mismatch")

	# Initial state
	_expect(not station.is_terminal_inspected, "terminal should not be inspected initially")
	_expect(not station.is_model_inspected, "model should not be inspected initially")
	_expect(not station.is_ledger_inspected, "ledger should not be inspected initially")
	_expect(not station.is_cursor_shifted, "cursor should not be shifted initially")
	_expect(not station.is_burden_list_scrolled, "burden list should not be scrolled initially")
	_expect(not station.is_purpose_revealed, "purpose should not be revealed initially")
	_expect(not station.is_archive_confirmed, "archive should not be confirmed initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Designer Terminal at x=140
	player.global_position = Vector2(140.0, 240.0)
	for f in range(2):
		await physics_frame
	terminal_prop.trigger_interaction()

	_expect(station.is_terminal_inspected, "terminal must be marked inspected")
	_expect(terminal_prop.is_activated, "terminal prop must be activated")

	# Test 2: Inspect Substructure Model at x=260
	player.global_position = Vector2(260.0, 245.0)
	for f in range(2):
		await physics_frame
	model_prop.trigger_interaction()

	_expect(station.is_model_inspected, "model must be marked inspected")
	_expect(model_prop.is_activated, "model prop must be activated")

	# Test 3: Inspect Burdened Persons Ledger at x=380
	player.global_position = Vector2(380.0, 240.0)
	for f in range(2):
		await physics_frame
	ledger_prop.trigger_interaction()

	_expect(station.is_ledger_inspected, "ledger must be marked inspected")
	_expect(ledger_prop.is_activated, "ledger prop must be activated")

	# Test 4: Inspect Shadow Interactive Console at x=490
	player.global_position = Vector2(490.0, 240.0)
	for f in range(2):
		await physics_frame
	console_prop.trigger_interaction()

	_expect(station.is_cursor_shifted, "cursor shift must be triggered")
	_expect(console_prop.is_activated, "console prop must be activated")

	# Test 5: Step through Scene 23 dialogue sequence D-16 (13 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (LENA: Na moje.)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")

	station.advance_dialogue() # to 2 (ŚWIADECTWO: Lena otwiera polecenie nadpisania wzorca. Kursor sam odsuwa się...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.is_cursor_shifted, "cursor must be shifted at line 2")

	station.advance_dialogue() # to 3 (LENA: Nie chcesz, żebym to zrobiła...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (ŚWIADECTWO: Na monitorze zapala się jedno pole listy: OSOBY OBCIĄŻONE...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_burden_list_scrolled, "burden list marked at line 4")

	station.advance_dialogue() # to 5 (LENA: Odpowiadasz nie na to pytanie.)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Lista przewija się sama. Zatrzymuje się na wierszu bez nazwiska.)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (LENA: Wiem, że tu jestem przez ciebie. Chcę wiedzieć po co.)
	_expect(station.dialogue_index == 7, "dialogue at 7")
	_expect(station.is_purpose_revealed, "purpose revealed at line 7")

	station.advance_dialogue() # to 8 (ŚWIADECTWO: Kursor wraca na polecenie nadpisania i zostaje. Ślad go nie zabiera.)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (LENA: Nie. Ty najpierw.)
	_expect(station.dialogue_index == 9, "dialogue at 9")

	station.advance_dialogue() # to 10 (LENA: Zatwierdzałaś pierwsze korekty. Podpis jest twój.)
	_expect(station.dialogue_index == 10, "dialogue at 10")
	_expect(station.is_archive_confirmed, "archive confirmed at line 10")

	station.advance_dialogue() # to 11 (ŚWIADECTWO: Ekran gaśnie na jedną klatkę i wraca z tym samym widokiem.)
	_expect(station.dialogue_index == 11, "dialogue at 11")

	station.advance_dialogue() # to 12 (LENA: Dobrze. To zostaw włączone.)
	_expect(station.dialogue_index == 12, "dialogue at 12")

	var l_end := station.advance_dialogue() # past end -> unlocks exit
	_expect(l_end == -1, "advancing past line 12 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 23 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_24() -> void:
	var packed_station := load("res://scenes/levels/station_24.tscn") as PackedScene
	_expect(packed_station != null, "station_24 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station24
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_24: player missing")
	_expect(camera != null, "station_24: camera missing")
	_expect(geometry != null, "station_24: geometry missing")
	_expect(props != null, "station_24: props node missing")
	_expect(airlock_zone != null, "station_24: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var cctv_prop := props.get_node_or_null("CCTVArray") as MemoryResonancePoint
	var gauge_prop := props.get_node_or_null("CorrectionGauge") as MemoryResonancePoint
	var terminal_prop := props.get_node_or_null("TransmissionTerminal") as MemoryResonancePoint
	var selector_prop := props.get_node_or_null("DispositionSelector") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station24Exit") as MemoryResonancePoint

	_expect(cctv_prop != null, "CCTVArray prop missing")
	_expect(gauge_prop != null, "CorrectionGauge prop missing")
	_expect(terminal_prop != null, "TransmissionTerminal prop missing")
	_expect(selector_prop != null, "DispositionSelector prop missing")
	_expect(exit_prop != null, "Station24Exit prop missing")

	if cctv_prop == null or gauge_prop == null or terminal_prop == null or selector_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	# Initial state assertions
	_expect(not station.is_cctv_inspected, "cctv should not be inspected initially")
	_expect(not station.is_gauge_inspected, "gauge should not be inspected initially")
	_expect(not station.is_terminal_inspected, "terminal should not be inspected initially")
	_expect(not station.is_disposition_made, "disposition should not be confirmed initially")
	_expect(not station.is_stress_escalated, "stress should not be escalated initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect CCTV Wall at x=140
	player.global_position = Vector2(140.0, 240.0)
	for f in range(2):
		await physics_frame
	cctv_prop.trigger_interaction()

	_expect(station.is_cctv_inspected, "cctv wall must be marked inspected")
	_expect(cctv_prop.is_activated, "cctv prop must be activated")

	# Test 2: Inspect Correction Stress Gauge at x=250
	player.global_position = Vector2(250.0, 240.0)
	for f in range(2):
		await physics_frame
	gauge_prop.trigger_interaction()

	_expect(station.is_gauge_inspected, "gauge must be marked inspected")
	_expect(gauge_prop.is_activated, "gauge prop must be activated")

	# Test 3: Inspect Transmission Terminal at x=370
	player.global_position = Vector2(370.0, 240.0)
	for f in range(2):
		await physics_frame
	terminal_prop.trigger_interaction()

	_expect(station.is_terminal_inspected, "terminal must be marked inspected")
	_expect(terminal_prop.is_activated, "terminal prop must be activated")

	# Test 4: Inspect Disposition Selector at x=490 & test disposition switching
	player.global_position = Vector2(490.0, 240.0)
	for f in range(2):
		await physics_frame
	
	station.set_disposition(Station24.DispositionChoice.EXPLICIT_CONSENT)
	_expect(station.selected_disposition == Station24.DispositionChoice.EXPLICIT_CONSENT, "disposition choice 0 set")
	_expect(station.dialogue_lines[6]["text"] == "Zgadzam się. Chrońcie Martę.", "line 6 updated for consent")
	
	station.set_disposition(Station24.DispositionChoice.EXPLICIT_REFUSAL)
	_expect(station.selected_disposition == Station24.DispositionChoice.EXPLICIT_REFUSAL, "disposition choice 2 set")
	_expect(station.dialogue_lines[6]["text"] == "Nie kupię jej bezpieczeństwa waszym kłamstwem.", "line 6 updated for refusal")

	station.set_disposition(Station24.DispositionChoice.APPARENT_COOPERATION)
	_expect(station.selected_disposition == Station24.DispositionChoice.APPARENT_COOPERATION, "disposition choice 1 set")
	_expect(station.dialogue_lines[6]["text"] == "Podpiszę formularz. Ale sprawdzę każdy odczyt.", "line 6 updated for apparent coop")

	selector_prop.trigger_interaction()
	_expect(selector_prop.is_activated, "selector prop must be activated")

	# Test 5: Step through Scene 24 dialogue sequence (9 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (DR WIERZBICKA: Marta Kurek nie przyjmuje wersji...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "DR WIERZBICKA", "line 1 speaker must be DR WIERZBICKA")

	station.advance_dialogue() # to 2 (LENA: Nie zrobicie jej tego.)
	_expect(station.dialogue_index == 2, "dialogue at 2")

	station.advance_dialogue() # to 3 (DR WIERZBICKA: My nie robimy niczego z zemsty...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (ŚWIADECTWO: Wskaźnik naprężeń korelacyjnych bije w czerwone pole...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_stress_escalated, "stress escalated at line 4")

	station.advance_dialogue() # to 5 (DR WIERZBICKA: Oferuję ochronę Marty...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (LENA: Podpiszę formularz...)
	_expect(station.dialogue_index == 6, "dialogue at 6")
	_expect(station.is_disposition_made, "disposition confirmed at line 6")

	station.advance_dialogue() # to 7 (DR WIERZBICKA: Wybór został odnotowany w magistrali...)
	_expect(station.dialogue_index == 7, "dialogue at 7")
	_expect(station.is_exit_unlocked, "exit unlocked at line 7")

	station.advance_dialogue() # to 8 (ŚWIADECTWO: Syrena naprężeń cichnie. Śluza ku Przestrzeni 25...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 8 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 24 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_25() -> void:
	var packed_station := load("res://scenes/levels/station_25.tscn") as PackedScene
	_expect(packed_station != null, "station_25 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station25
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_25: player missing")
	_expect(camera != null, "station_25: camera missing")
	_expect(geometry != null, "station_25: geometry missing")
	_expect(props != null, "station_25: props node missing")
	_expect(airlock_zone != null, "station_25: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var cart_prop := props.get_node_or_null("MaintenanceCart") as MemoryResonancePoint
	var chart_prop := props.get_node_or_null("ScarChart") as MemoryResonancePoint
	var jakub_prop := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
	var sensor_prop := props.get_node_or_null("GestureSensor") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station25Exit") as MemoryResonancePoint

	_expect(cart_prop != null, "MaintenanceCart prop missing")
	_expect(chart_prop != null, "ScarChart prop missing")
	_expect(jakub_prop != null, "JakubOperator prop missing")
	_expect(sensor_prop != null, "GestureSensor prop missing")
	_expect(exit_prop != null, "Station25Exit prop missing")

	if cart_prop == null or chart_prop == null or jakub_prop == null or sensor_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(cart_prop.prop_type == MemoryResonancePoint.PropType.TRANSIT_MAINTENANCE_CART, "cart prop_type mismatch")
	_expect(chart_prop.prop_type == MemoryResonancePoint.PropType.SCAR_DIAGNOSTIC_CHART, "chart prop_type mismatch")
	_expect(jakub_prop.prop_type == MemoryResonancePoint.PropType.JAKUB_OPERATOR_UCP, "jakub prop_type mismatch")
	_expect(sensor_prop.prop_type == MemoryResonancePoint.PropType.JAKUB_HAND_GESTURE_SENSOR, "sensor prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_25_EXIT, "exit prop_type mismatch")

	# Initial state assertions
	_expect(not station.is_cart_inspected, "cart should not be inspected initially")
	_expect(not station.is_chart_inspected, "chart should not be inspected initially")
	_expect(not station.is_sensor_inspected, "sensor should not be inspected initially")
	_expect(not station.is_jakub_confronted, "jakub should not be confronted initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Transit Maintenance Cart at x=130
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	cart_prop.trigger_interaction()

	_expect(station.is_cart_inspected, "cart must be marked inspected")
	_expect(cart_prop.is_activated, "cart prop must be activated")

	# Test 2: Inspect Scar Diagnostic Chart at x=230
	player.global_position = Vector2(230.0, 240.0)
	for f in range(2):
		await physics_frame
	chart_prop.trigger_interaction()

	_expect(station.is_chart_inspected, "chart must be marked inspected")
	_expect(chart_prop.is_activated, "chart prop must be activated")

	# Test 3: Inspect Gesture Sensor at x=480
	player.global_position = Vector2(480.0, 240.0)
	for f in range(2):
		await physics_frame
	sensor_prop.trigger_interaction()

	_expect(station.is_sensor_inspected, "sensor must be marked inspected")
	_expect(sensor_prop.is_activated, "sensor prop must be activated")

	# Test 4: Confront Jakub Wolski at x=380
	player.global_position = Vector2(380.0, 240.0)
	for f in range(2):
		await physics_frame
	jakub_prop.trigger_interaction()

	_expect(station.is_jakub_confronted, "jakub must be marked confronted")
	_expect(jakub_prop.is_activated, "jakub prop must be activated")

	# Test 5: Step through Scene 25 dialogue sequence D-09 (13 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "JAKUB", "line 0 speaker must be JAKUB")

	station.advance_dialogue() # to 1 (LENA: Co?)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")

	station.advance_dialogue() # to 2 (JAKUB: Moja siostra obraca obrączkę...)
	_expect(station.dialogue_index == 2, "dialogue at 2")

	station.advance_dialogue() # to 3 (LENA: W mojej wersji masz bliznę pod lewym żebrem...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (JAKUB: Mam.)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (LENA: Widziałam ją, kiedy identyfikowałam ciało.)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Jakub siada na podłodze. Nie patrzy na Lenę.)
	_expect(station.dialogue_index == 6, "dialogue at 6")
	_expect(station._jakub_sitting, "jakub sitting posture updated at line 6")

	station.advance_dialogue() # to 7 (JAKUB: I co teraz? Mam ci udowodnić, że oddycham?)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (LENA: Nie.)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (JAKUB: Właśnie to robisz. Patrzysz, czy się zgadzam.)
	_expect(station.dialogue_index == 9, "dialogue at 9")

	station.advance_dialogue() # to 10 (LENA: Jakub—)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # to 11 (JAKUB: Nie jestem twoim wspomnieniem...)
	_expect(station.dialogue_index == 11, "dialogue at 11")
	_expect(station.is_exit_unlocked, "exit unlocked at line 11")

	station.advance_dialogue() # to 12 (ŚWIADECTWO: Ślad w rejestrze personelu stabilizuje się...)
	_expect(station.dialogue_index == 12, "dialogue at 12")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 12 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 25 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_26() -> void:
	var packed_station := load("res://scenes/levels/station_26.tscn") as PackedScene
	_expect(packed_station != null, "station_26 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station26
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_26: player missing")
	_expect(camera != null, "station_26: camera missing")
	_expect(geometry != null, "station_26: geometry missing")
	_expect(props != null, "station_26: props node missing")
	_expect(airlock_zone != null, "station_26: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var console_prop := props.get_node_or_null("IsolationConsole") as MemoryResonancePoint
	var desig_prop := props.get_node_or_null("RoomDesignator") as MemoryResonancePoint
	var speaker_prop := props.get_node_or_null("PASpeaker") as MemoryResonancePoint
	var anchor_prop := props.get_node_or_null("MotivationAnchor") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station26Exit") as MemoryResonancePoint

	_expect(console_prop != null, "IsolationConsole prop missing")
	_expect(desig_prop != null, "RoomDesignator prop missing")
	_expect(speaker_prop != null, "PASpeaker prop missing")
	_expect(anchor_prop != null, "MotivationAnchor prop missing")
	_expect(exit_prop != null, "Station26Exit prop missing")

	if console_prop == null or desig_prop == null or speaker_prop == null or anchor_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(console_prop.prop_type == MemoryResonancePoint.PropType.ISOLATION_ZONE_CONSOLE, "console prop_type mismatch")
	_expect(desig_prop.prop_type == MemoryResonancePoint.PropType.DYNAMIC_ROOM_DESIGNATOR, "designator prop_type mismatch")
	_expect(speaker_prop.prop_type == MemoryResonancePoint.PropType.WIERZBICKA_PA_SPEAKER, "speaker prop_type mismatch")
	_expect(anchor_prop.prop_type == MemoryResonancePoint.PropType.MOTIVATION_ANCHOR_RECORD, "anchor prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_26_EXIT, "exit prop_type mismatch")

	# Initial state assertions
	_expect(not station.is_console_inspected, "console should not be inspected initially")
	_expect(not station.is_designator_inspected, "designator should not be inspected initially")
	_expect(not station.is_speaker_inspected, "speaker should not be inspected initially")
	_expect(not station.is_motivation_anchored, "motivation should not be anchored initially")
	_expect(station.current_room_state == Station26.RoomState.RESIDENTIAL, "initial room state must be RESIDENTIAL")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Isolation Console at x=130
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	console_prop.trigger_interaction()

	_expect(station.is_console_inspected, "console must be marked inspected")
	_expect(console_prop.is_activated, "console prop must be activated")

	# Test 2: Inspect Room Designator at x=240
	player.global_position = Vector2(240.0, 240.0)
	for f in range(2):
		await physics_frame
	desig_prop.trigger_interaction()

	_expect(station.is_designator_inspected, "designator must be marked inspected")
	_expect(desig_prop.is_activated, "designator prop must be activated")

	# Test 3: Inspect PA Speaker at x=360
	player.global_position = Vector2(360.0, 230.0)
	for f in range(2):
		await physics_frame
	speaker_prop.trigger_interaction()

	_expect(station.is_speaker_inspected, "speaker must be marked inspected")
	_expect(speaker_prop.is_activated, "speaker prop must be activated")

	# Test 4: Inspect Motivation Anchor at x=470
	player.global_position = Vector2(470.0, 240.0)
	for f in range(2):
		await physics_frame
	anchor_prop.trigger_interaction()

	_expect(station.is_motivation_anchored, "motivation anchor must be marked inspected")
	_expect(anchor_prop.is_activated, "anchor prop must be activated")

	# Test 5: Step through Scene 26 dialogue sequence (12 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (DR WIERZBICKA: Uwaga. W tej części budynku obowiązuje jedna kolejność...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "DR WIERZBICKA", "line 1 speaker must be DR WIERZBICKA")

	station.advance_dialogue() # to 2 (LENA: Zmieniacie układ za moimi plecami.)
	_expect(station.dialogue_index == 2, "dialogue at 2")

	station.advance_dialogue() # to 3 (DR WIERZBICKA: Nie zmieniamy. Pozwalamy przestrzeni przyjąć funkcję...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (ŚWIADECTWO: Wskaźnik funkcyjny komory płynnie przełącza się...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.current_room_state == Station26.RoomState.SEDATION, "room state shifted to SEDATION at line 4")

	station.advance_dialogue() # to 5 (DR WIERZBICKA: W przypadku rozbieżności prosimy nie forsować...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (LENA: Próbujecie odebrać mi powód...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (DR WIERZBICKA: Powód, który rani wszystkich wokół...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (ŚWIADECTWO: Lena wyciąga stalowy rysik i z naciskiem ryje...)
	_expect(station.dialogue_index == 8, "dialogue at 8")
	_expect(station.is_motivation_anchored, "motivation anchored at line 8")

	station.advance_dialogue() # to 9 (LENA: Nie zgubię tego.)
	_expect(station.dialogue_index == 9, "dialogue at 9")

	station.advance_dialogue() # to 10 (DR WIERZBICKA: Każda rysa w szwie pociąga za sobą resztę...)
	_expect(station.dialogue_index == 10, "dialogue at 10")
	_expect(station.is_exit_unlocked, "exit unlocked at line 10")

	station.advance_dialogue() # to 11 (ŚWIADECTWO: Rekonfiguracja przestrzenna zatrzymuje się...)
	_expect(station.dialogue_index == 11, "dialogue at 11")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 11 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 26 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_27() -> void:
	var packed_station := load("res://scenes/levels/station_27.tscn") as PackedScene
	_expect(packed_station != null, "station_27 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station27
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_27: player missing")
	_expect(camera != null, "station_27: camera missing")
	_expect(geometry != null, "station_27: geometry missing")
	_expect(props != null, "station_27: props node missing")
	_expect(airlock_zone != null, "station_27: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var badge_prop := props.get_node_or_null("WorkerBadge") as MemoryResonancePoint
	var jakub_prop := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
	var mon_prop := props.get_node_or_null("SurfaceMonitor") as MemoryResonancePoint
	var console_prop := props.get_node_or_null("JunctionConsole") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station27Exit") as MemoryResonancePoint

	_expect(badge_prop != null, "WorkerBadge prop missing")
	_expect(jakub_prop != null, "JakubOperator prop missing")
	_expect(mon_prop != null, "SurfaceMonitor prop missing")
	_expect(console_prop != null, "JunctionConsole prop missing")
	_expect(exit_prop != null, "Station27Exit prop missing")

	if badge_prop == null or jakub_prop == null or mon_prop == null or console_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(badge_prop.prop_type == MemoryResonancePoint.PropType.SAVED_WORKER_BADGE, "badge prop_type mismatch")
	_expect(jakub_prop.prop_type == MemoryResonancePoint.PropType.JAKUB_SERVICE_OPERATOR, "jakub prop_type mismatch")
	_expect(mon_prop.prop_type == MemoryResonancePoint.PropType.SURFACE_STABILITY_MONITOR, "monitor prop_type mismatch")
	_expect(console_prop.prop_type == MemoryResonancePoint.PropType.TECHNICAL_JUNCTION_CONSOLE, "console prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_27_EXIT, "exit prop_type mismatch")

	# Initial state assertions
	_expect(not station.is_badge_inspected, "badge should not be inspected initially")
	_expect(not station.is_jakub_interacted, "jakub should not be interacted initially")
	_expect(not station.is_monitor_inspected, "monitor should not be inspected initially")
	_expect(not station.is_console_inspected, "console should not be inspected initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Worker Badge at x=130
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	badge_prop.trigger_interaction()

	_expect(station.is_badge_inspected, "badge must be marked inspected")
	_expect(badge_prop.is_activated, "badge prop must be activated")

	# Test 2: Interact with Jakub at x=240
	player.global_position = Vector2(240.0, 260.0)
	for f in range(2):
		await physics_frame
	jakub_prop.trigger_interaction()

	_expect(station.is_jakub_interacted, "jakub must be marked interacted")
	_expect(jakub_prop.is_activated, "jakub prop must be activated")

	# Test 3: Inspect Surface Monitor at x=360
	player.global_position = Vector2(360.0, 240.0)
	for f in range(2):
		await physics_frame
	mon_prop.trigger_interaction()

	_expect(station.is_monitor_inspected, "monitor must be marked inspected")
	_expect(mon_prop.is_activated, "monitor prop must be activated")

	# Test 4: Inspect Junction Console at x=470
	player.global_position = Vector2(470.0, 240.0)
	for f in range(2):
		await physics_frame
	console_prop.trigger_interaction()

	_expect(station.is_console_inspected, "console must be marked inspected")
	_expect(console_prop.is_activated, "console prop must be activated")

	# Test 5: Step through Scene 27 dialogue sequence (11 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (JAKUB: Wierzbicka wyciągnęła mnie z tamtego wagonu...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "JAKUB", "line 1 speaker must be JAKUB")

	station.advance_dialogue() # to 2 (LENA: I dała ci mundur...)
	_expect(station.dialogue_index == 2, "dialogue at 2")

	station.advance_dialogue() # to 3 (JAKUB: Dała mi dwanaście lat życia...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (ŚWIADECTWO: Jakub wskazuje monitor stabilności...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_monitor_inspected, "monitor marked inspected at line 4")

	station.advance_dialogue() # to 5 (JAKUB: Nie chcę umierać znowu...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (LENA: Nie przyszłam burzyć miasta...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (JAKUB: Więc udowodnij to...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (ŚWIADECTWO: Lena dotyka dłoni brata...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (JAKUB: Skład techniczny Linii 4 stoi na peronie dwudziestym ósmym...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Brama techniczna Podstruktury unosi się...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 10 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 27 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_28() -> void:
	var packed_station := load("res://scenes/levels/station_28.tscn") as PackedScene
	_expect(packed_station != null, "station_28 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station28
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_28: player missing")
	_expect(camera != null, "station_28: camera missing")
	_expect(geometry != null, "station_28: geometry missing")
	_expect(props != null, "station_28: props node missing")
	_expect(airlock_zone != null, "station_28: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var console_prop := props.get_node_or_null("DriverConsole") as MemoryResonancePoint
	var win_prop := props.get_node_or_null("TransitWindow") as MemoryResonancePoint
	var par_prop := props.get_node_or_null("ParadoxViewport") as MemoryResonancePoint
	var ic_prop := props.get_node_or_null("ClosingIntercom") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station28Exit") as MemoryResonancePoint

	_expect(console_prop != null, "DriverConsole prop missing")
	_expect(win_prop != null, "TransitWindow prop missing")
	_expect(par_prop != null, "ParadoxViewport prop missing")
	_expect(ic_prop != null, "ClosingIntercom prop missing")
	_expect(exit_prop != null, "Station28Exit prop missing")

	if console_prop == null or win_prop == null or par_prop == null or ic_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(console_prop.prop_type == MemoryResonancePoint.PropType.TRAM_DRIVER_CONSOLE, "console prop_type mismatch")
	_expect(win_prop.prop_type == MemoryResonancePoint.PropType.PANORAMIC_TRANSIT_WINDOW, "window prop_type mismatch")
	_expect(par_prop.prop_type == MemoryResonancePoint.PropType.TRIPLE_ACCIDENT_PARADOX_VIEW, "paradox prop_type mismatch")
	_expect(ic_prop.prop_type == MemoryResonancePoint.PropType.WIERZBICKA_CLOSING_INTERCOM, "intercom prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_28_EXIT, "exit prop_type mismatch")

	# Initial state assertions
	_expect(not station.is_console_interacted, "console should not be interacted initially")
	_expect(not station.is_window_inspected, "window should not be inspected initially")
	_expect(not station.is_paradox_inspected, "paradox should not be inspected initially")
	_expect(not station.is_intercom_inspected, "intercom should not be inspected initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Driver Console at x=130
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	console_prop.trigger_interaction()

	_expect(station.is_console_interacted, "console must be marked interacted")
	_expect(console_prop.is_activated, "console prop must be activated")

	# Test 2: Inspect Panoramic Transit Window at x=240
	player.global_position = Vector2(240.0, 240.0)
	for f in range(2):
		await physics_frame
	win_prop.trigger_interaction()

	_expect(station.is_window_inspected, "window must be marked inspected")
	_expect(win_prop.is_activated, "window prop must be activated")

	# Test 3: Inspect Triple Paradox Viewport at x=360
	player.global_position = Vector2(360.0, 240.0)
	for f in range(2):
		await physics_frame
	par_prop.trigger_interaction()

	_expect(station.is_paradox_inspected, "paradox must be marked inspected")
	_expect(par_prop.is_activated, "paradox prop must be activated")

	# Test 4: Inspect Closing Intercom at x=470
	player.global_position = Vector2(470.0, 240.0)
	for f in range(2):
		await physics_frame
	ic_prop.trigger_interaction()

	_expect(station.is_intercom_inspected, "intercom must be marked inspected")
	_expect(ic_prop.is_activated, "intercom prop must be activated")

	# Test 5: Step through Scene 28 dialogue sequence (11 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (JAKUB: Patrz w okna...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "JAKUB", "line 1 speaker must be JAKUB")

	station.advance_dialogue() # to 2 (LENA: Widzę go. Pusty peron...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.is_window_inspected, "window inspected at line 2")

	station.advance_dialogue() # to 3 (JAKUB: Karetki? Ja widzę tylko...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (LENA: Są trzy wersje, Jakub...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (ŚWIADECTWO: Mijane tablice stacyjne... ŚWIADEK)
	_expect(station.dialogue_index == 5, "dialogue at 5")
	_expect(station.is_paradox_inspected, "paradox inspected at line 5")

	station.advance_dialogue() # to 6 (JAKUB: Widzę tylko dwie...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (LENA: Dlatego jedziemy razem...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (ŚWIADECTWO: Głośnik interkomu w kabinie...)
	_expect(station.dialogue_index == 8, "dialogue at 8")
	_expect(station.is_intercom_inspected, "intercom inspected at line 8")

	station.advance_dialogue() # to 9 (WIERZBICKA: Nie ścigam państwa. Zamykam drogę...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Skład uderza w hamulce pneumatyczne...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 10 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 28 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_29() -> void:
	var packed_station := load("res://scenes/levels/station_29.tscn") as PackedScene
	_expect(packed_station != null, "station_29 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station29
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_29: player missing")
	_expect(camera != null, "station_29: camera missing")
	_expect(geometry != null, "station_29: geometry missing")
	_expect(props != null, "station_29: props node missing")
	_expect(airlock_zone != null, "station_29: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var trk_prop := props.get_node_or_null("AbandonedTracks") as MemoryResonancePoint
	var neon_prop := props.get_node_or_null("FlickeringNeon") as MemoryResonancePoint
	var well_prop := props.get_node_or_null("SubstructureWell") as MemoryResonancePoint
	var bcn_prop := props.get_node_or_null("JakubBeacon") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station29Exit") as MemoryResonancePoint

	_expect(trk_prop != null, "AbandonedTracks prop missing")
	_expect(neon_prop != null, "FlickeringNeon prop missing")
	_expect(well_prop != null, "SubstructureWell prop missing")
	_expect(bcn_prop != null, "JakubBeacon prop missing")
	_expect(exit_prop != null, "Station29Exit prop missing")

	if trk_prop == null or neon_prop == null or well_prop == null or bcn_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(trk_prop.prop_type == MemoryResonancePoint.PropType.ABANDONED_PLATFORM_TRACKS, "tracks prop_type mismatch")
	_expect(neon_prop.prop_type == MemoryResonancePoint.PropType.FLICKERING_NEON_SIGN, "neon prop_type mismatch")
	_expect(well_prop.prop_type == MemoryResonancePoint.PropType.DEEP_SUBSTRUCTURE_WELL, "well prop_type mismatch")
	_expect(bcn_prop.prop_type == MemoryResonancePoint.PropType.JAKUB_TORCH_BEACON, "beacon prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_29_EXIT, "exit prop_type mismatch")

	# Initial state assertions
	_expect(not station.is_tracks_inspected, "tracks should not be inspected initially")
	_expect(not station.is_neon_inspected, "neon should not be inspected initially")
	_expect(not station.is_well_inspected, "well should not be inspected initially")
	_expect(not station.is_beacon_inspected, "beacon should not be inspected initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Abandoned Tracks at x=130
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	trk_prop.trigger_interaction()

	_expect(station.is_tracks_inspected, "tracks must be marked inspected")
	_expect(trk_prop.is_activated, "tracks prop must be activated")

	# Test 2: Inspect Flickering Neon at x=240
	player.global_position = Vector2(240.0, 240.0)
	for f in range(2):
		await physics_frame
	neon_prop.trigger_interaction()

	_expect(station.is_neon_inspected, "neon must be marked inspected")
	_expect(neon_prop.is_activated, "neon prop must be activated")

	# Test 3: Inspect Substructure Well at x=360
	player.global_position = Vector2(360.0, 240.0)
	for f in range(2):
		await physics_frame
	well_prop.trigger_interaction()

	_expect(station.is_well_inspected, "well must be marked inspected")
	_expect(well_prop.is_activated, "well prop must be activated")

	# Test 4: Inspect Jakub Beacon at x=470
	player.global_position = Vector2(470.0, 240.0)
	for f in range(2):
		await physics_frame
	bcn_prop.trigger_interaction()

	_expect(station.is_beacon_inspected, "beacon must be marked inspected")
	_expect(bcn_prop.is_activated, "beacon prop must be activated")

	# Test 5: Step through Scene 29 dialogue sequence (11 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (JAKUB: Koniec torowiska Linii 4...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "JAKUB", "line 1 speaker must be JAKUB")

	station.advance_dialogue() # to 2 (LENA: Ten peron wygląda...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.is_neon_inspected, "neon inspected at line 2")

	station.advance_dialogue() # to 3 (JAKUB: Bo tak było...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (ŚWIADECTWO: Zardzewiałe szyny kończą się...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_tracks_inspected, "tracks inspected at line 4")

	station.advance_dialogue() # to 5 (LENA: Słyszysz ten dźwięk...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (JAKUB: To nie pompy. To kompensatory...)
	_expect(station.dialogue_index == 6, "dialogue at 6")
	_expect(station.is_well_inspected, "well inspected at line 6")

	station.advance_dialogue() # to 7 (ŚWIADECTWO: Neon nad peronem migocze...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (JAKUB: Za tą kratą zaczyna się Sektor Zasilania...)
	_expect(station.dialogue_index == 8, "dialogue at 8")
	_expect(station.is_beacon_inspected, "beacon inspected at line 8")

	station.advance_dialogue() # to 9 (LENA: Nie wracamy, Jakub...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Rdzawa krata ustępuje z głuchym jękiem metalu...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 10 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 29 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_30() -> void:
	var packed_station := load("res://scenes/levels/station_30.tscn") as PackedScene
	_expect(packed_station != null, "station_30 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station30
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera") as CinematicCamera
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone")

	_expect(player != null, "station_30: player missing")
	_expect(camera != null, "station_30: camera missing")
	_expect(geometry != null, "station_30: geometry missing")
	_expect(props != null, "station_30: props node missing")
	_expect(airlock_zone != null, "station_30: airlock_zone missing")

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var board_prop := props.get_node_or_null("MainDistributionBoard") as MemoryResonancePoint
	var trans_prop := props.get_node_or_null("TransformerBank") as MemoryResonancePoint
	var breaker_prop := props.get_node_or_null("SectionBreakerLever") as MemoryResonancePoint
	var schema_prop := props.get_node_or_null("GridSchematicDisplay") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station30Exit") as MemoryResonancePoint

	_expect(board_prop != null, "MainDistributionBoard prop missing")
	_expect(trans_prop != null, "TransformerBank prop missing")
	_expect(breaker_prop != null, "SectionBreakerLever prop missing")
	_expect(schema_prop != null, "GridSchematicDisplay prop missing")
	_expect(exit_prop != null, "Station30Exit prop missing")

	if board_prop == null or trans_prop == null or breaker_prop == null or schema_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(board_prop.prop_type == MemoryResonancePoint.PropType.MAIN_POWER_DISTRIBUTION_BOARD, "board prop_type mismatch")
	_expect(trans_prop.prop_type == MemoryResonancePoint.PropType.HIGH_VOLTAGE_TRANSFORMER_BANK, "transformer prop_type mismatch")
	_expect(breaker_prop.prop_type == MemoryResonancePoint.PropType.SECTION_BREAKER_LEVER, "breaker prop_type mismatch")
	_expect(schema_prop.prop_type == MemoryResonancePoint.PropType.GRID_SCHEMATIC_DISPLAY, "schematic prop_type mismatch")
	_expect(exit_prop.prop_type == MemoryResonancePoint.PropType.STATION_30_EXIT, "exit prop_type mismatch")

	# Initial state assertions
	_expect(not station.is_board_inspected, "board should not be inspected initially")
	_expect(not station.is_transformer_inspected, "transformer should not be inspected initially")
	_expect(not station.is_breaker_thrown, "breaker should not be thrown initially")
	_expect(not station.is_schematic_inspected, "schematic should not be inspected initially")
	_expect(not station.is_exit_unlocked, "exit must be locked initially")
	_expect(not station.is_level_completed, "level must not be completed initially")

	# Test 1: Inspect Main Distribution Board at x=130
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	board_prop.trigger_interaction()

	_expect(station.is_board_inspected, "board must be marked inspected")
	_expect(board_prop.is_activated, "board prop must be activated")

	# Test 2: Inspect Transformer Bank at x=240
	player.global_position = Vector2(240.0, 240.0)
	for f in range(2):
		await physics_frame
	trans_prop.trigger_interaction()

	_expect(station.is_transformer_inspected, "transformer must be marked inspected")
	_expect(trans_prop.is_activated, "transformer prop must be activated")

	# Test 3: Inspect Section Breaker Lever at x=360
	player.global_position = Vector2(360.0, 240.0)
	for f in range(2):
		await physics_frame
	breaker_prop.trigger_interaction()

	_expect(station.is_breaker_thrown, "breaker must be marked thrown")
	_expect(breaker_prop.is_activated, "breaker prop must be activated")

	# Test 4: Inspect Grid Schematic Display at x=470
	player.global_position = Vector2(470.0, 240.0)
	for f in range(2):
		await physics_frame
	schema_prop.trigger_interaction()

	_expect(station.is_schematic_inspected, "schematic must be marked inspected")
	_expect(schema_prop.is_activated, "schematic prop must be activated")

	# Test 5: Step through Scene 30 dialogue sequence (11 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (JAKUB: To stąd UCP zasila siatkę konsensusu...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "JAKUB", "line 1 speaker must be JAKUB")

	station.advance_dialogue() # to 2 (LENA: Spójrz na wskaźniki obciążenia...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.is_board_inspected, "board inspected at line 2")

	station.advance_dialogue() # to 3 (JAKUB: Bo im więcej ludzi pamięta inaczej...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (ŚWIADECTWO: Na podświetlanym schemacie pulsują punkty...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_transformer_inspected, "transformer inspected at line 4")

	station.advance_dialogue() # to 5 (LENA: Marta nadal świeci na schemacie...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (JAKUB: Jeśli przestawimy ten trójfazowy bezpiecznik...)
	_expect(station.dialogue_index == 6, "dialogue at 6")
	_expect(station.is_schematic_inspected, "schematic inspected at line 6")

	station.advance_dialogue() # to 7 (ŚWIADECTWO: Potężna dźwignia bezpiecznika nożowego lśni...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (LENA: Przestaw go, Jakub...)
	_expect(station.dialogue_index == 8, "dialogue at 8")
	_expect(station.is_breaker_thrown, "breaker thrown at line 8")

	station.advance_dialogue() # to 9 (JAKUB: Zrobione. Obwody nadzoru zgasły...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Rygiel magnetyczny ciężkiej bramy ekranowanej...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 10 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 30 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_31() -> void:
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
	_expect(airlock_zone != null, "station_31: airlock_zone missing")

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

	# Test 1: Inspect 11 Chairs at x=130
	player.global_position = Vector2(130.0, 240.0)
	for f in range(2):
		await physics_frame
	chairs_prop.trigger_interaction()

	_expect(station.is_chairs_inspected, "eleven chairs must be marked inspected")
	_expect(chairs_prop.is_activated, "chairs prop must be activated")

	# Test 2: Inspect Wierzbicka Holoterminal at x=240
	player.global_position = Vector2(240.0, 240.0)
	for f in range(2):
		await physics_frame
	holo_prop.trigger_interaction()

	_expect(station.is_holoterminal_inspected, "holoterminal must be marked inspected")
	_expect(holo_prop.is_activated, "holoterminal prop must be activated")

	# Test 3: Inspect Jakub Twelfth Chair at x=350
	player.global_position = Vector2(350.0, 240.0)
	for f in range(2):
		await physics_frame
	twelfth_prop.trigger_interaction()

	_expect(station.is_twelfth_chair_inspected, "twelfth chair must be marked inspected")
	_expect(twelfth_prop.is_activated, "twelfth chair prop must be activated")

	# Test 4: Inspect Variant Choice Ledger at x=460
	player.global_position = Vector2(460.0, 240.0)
	for f in range(2):
		await physics_frame
	ledger_prop.trigger_interaction()

	_expect(station.is_ledger_inspected, "ledger must be marked inspected")
	_expect(ledger_prop.is_activated, "ledger prop must be activated")

	# Test 5: Step through Scene 31 dialogue sequence (11 lines)
	_expect(station.dialogue_active, "dialogue must be active")
	_expect(station.dialogue_index == 0, "dialogue must be at line 0")
	_expect(station.dialogue_lines[0]["speaker"] == "ŚWIADECTWO", "line 0 speaker must be ŚWIADECTWO")

	station.advance_dialogue() # to 1 (LENA: Płaszcz kolejowy z biletami w kieszeni...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker must be LENA")
	_expect(station.is_chairs_inspected, "chairs inspected at line 1")

	station.advance_dialogue() # to 2 (JAKUB: To pasażerowie z tamtego dnia...)
	_expect(station.dialogue_index == 2, "dialogue at 2")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Zimnoniebieski holoterminal na ścianie uaktywnia się...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (WIERZBICKA: Janina Kowalczyk. Adam Sikora...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_holoterminal_inspected, "holoterminal inspected at line 4")

	station.advance_dialogue() # to 5 (LENA: Pamięta pani ich imiona...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (WIERZBICKA: Pamięć o nich to mój osobisty ciężar...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (LENA: A dwunaste nazwisko? Dlaczego na dwunastym krześle...)
	_expect(station.dialogue_index == 7, "dialogue at 7")
	_expect(station.is_twelfth_chair_inspected, "twelfth chair inspected at line 7")

	station.advance_dialogue() # to 8 (WIERZBICKA: Wybierałam stabilny wariant historii...)
	_expect(station.dialogue_index == 8, "dialogue at 8")
	_expect(station.is_ledger_inspected, "ledger inspected at line 8")

	station.advance_dialogue() # to 9 (JAKUB: Bo nie jestem pani wyborem...)
	_expect(station.dialogue_index == 9, "dialogue at 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Przeszklona śluza ciśnieniowa rozszczelnia się...)
	_expect(station.dialogue_index == 10, "dialogue at 10")
	_expect(station.is_exit_unlocked, "exit unlocked at line 10")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 10 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 31 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_32() -> void:
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

	_expect(player != null, "station_32: player missing")
	_expect(camera != null, "station_32: camera missing")
	_expect(geometry != null, "station_32: geometry missing")
	_expect(props != null, "station_32: props node missing")
	_expect(airlock_zone != null, "station_32: airlock_zone missing")

	if props == null or player == null or airlock_zone == null:
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

	# Initial state: dialogue active at line 0, exit locked
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 0, "dialogue starts at index 0")
	_expect(not station.is_steamed_pane_inspected, "steamed pane not inspected initially")
	_expect(not station.is_cracked_pane_inspected, "cracked pane not inspected initially")
	_expect(not station.is_trace_etched, "trace not etched initially")
	_expect(not station.is_polished_pane_inspected, "polished pane not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Steamed glass pane inspection at x=125
	player.global_position = Vector2(125.0, 245.0)
	await physics_frame
	await physics_frame
	_expect(steamed_prop.is_player_in_range, "player must be in range of SteamedGlassPaneA")

	# Test 2: Cracked glass pane inspection at x=235
	player.global_position = Vector2(235.0, 245.0)
	await physics_frame
	await physics_frame
	_expect(cracked_prop.is_player_in_range, "player must be in range of CrackedGlassPaneB")

	# Test 3: Trace etcher interaction at x=345
	player.global_position = Vector2(345.0, 248.0)
	await physics_frame
	await physics_frame
	_expect(trace_prop.is_player_in_range, "player must be in range of CondensationTraceEtcher")

	# Test 4: Polished glass pane inspection at x=455
	player.global_position = Vector2(455.0, 245.0)
	await physics_frame
	await physics_frame
	_expect(polished_prop.is_player_in_range, "player must be in range of PolishedGlassPaneC")

	# Test 5: Step through full Scene 32 dialogue progression
	_expect(station.dialogue_index == 0, "dialogue at 0")

	station.advance_dialogue() # to 1 (LENA: Spójrz na tę taflę po lewej...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.is_steamed_pane_inspected, "steamed pane inspected at line 1")

	station.advance_dialogue() # to 2 (JAKUB: A ta po prawej jest gęsto popękana...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.is_cracked_pane_inspected, "cracked pane inspected at line 2")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Kondensacja pary wodnej osadza się na szkle...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (LENA: Gdy dotykam zaparowanej powierzchni i przeciągam palcem...)
	_expect(station.dialogue_index == 4, "dialogue at 4")
	_expect(station.is_trace_etched, "trace etched at line 4")

	station.advance_dialogue() # to 5 (JAKUB: Szkło pamięta kształt naprężenia, Lena...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (LENA: Nie odtwarzam zniszczenia, Jakub...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (ŚWIADECTWO: Pod wpływem Śladu zaparowane szkło rozjaśnia się chłodnym błękitem...)
	_expect(station.dialogue_index == 7, "dialogue at 7")
	_expect(station.is_polished_pane_inspected, "polished pane inspected at line 7")

	station.advance_dialogue() # to 8 (JAKUB: To wejście do pionowego szybu technicznego...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (LENA: Jesteśmy tuż pod rdzeniem...)
	_expect(station.dialogue_index == 9, "dialogue at 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Ciężki stalowy właz rewizyjny rozszczelnia się...)
	_expect(station.dialogue_index == 10, "dialogue at 10")
	_expect(station.is_exit_unlocked, "exit unlocked at line 10")

	var l_end := station.advance_dialogue() # past end
	_expect(l_end == -1, "advancing past line 10 must complete dialogue")
	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "completing scene must unlock exit")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Advance physics frames for hatch opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 32 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_33() -> void:
	var packed_station := load("res://scenes/levels/station_33.tscn") as PackedScene
	_expect(packed_station != null, "station_33 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station33
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as Camera2D
	var geometry := station.get_node_or_null("Geometry")
	var props := station.get_node_or_null("Props")
	var airlock_zone := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station_33: player missing")
	_expect(camera != null, "station_33: camera missing")
	_expect(geometry != null, "station_33: geometry missing")
	_expect(props != null, "station_33: props node missing")
	_expect(airlock_zone != null, "station_33: airlock_zone missing")

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

	# Initial state assertions
	_expect(not station.is_ladder_inspected, "ladder not inspected initially")
	_expect(not station.is_gauge_inspected, "depth gauge not inspected initially")
	_expect(not station.is_cable_trunk_inspected, "cable trunk not inspected initially")
	_expect(not station.is_work_light_inspected, "work light not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Ladder inspection at x=130
	player.global_position = Vector2(130.0, 240.0)
	await physics_frame
	await physics_frame
	ladder_prop.trigger_interaction()
	_expect(station.is_ladder_inspected, "ladder must be inspected")
	_expect(ladder_prop.is_activated, "ladder prop must be activated")
	_expect(station.dialogue_active, "dialogue must be triggered by ladder inspection")
	_expect(station.dialogue_index == 0, "dialogue must start at index 0")

	# Test 2: Gauge inspection at x=235
	player.global_position = Vector2(235.0, 245.0)
	await physics_frame
	await physics_frame
	gauge_prop.trigger_interaction()
	_expect(station.is_gauge_inspected, "gauge must be inspected")
	_expect(gauge_prop.is_activated, "gauge prop must be activated")

	# Test 3: Cable trunk inspection at x=345
	player.global_position = Vector2(345.0, 238.0)
	await physics_frame
	await physics_frame
	cable_prop.trigger_interaction()
	_expect(station.is_cable_trunk_inspected, "cable trunk must be inspected")
	_expect(cable_prop.is_activated, "cable trunk prop must be activated")

	# Test 4: Work light inspection at x=455
	player.global_position = Vector2(455.0, 242.0)
	await physics_frame
	await physics_frame
	light_prop.trigger_interaction()
	_expect(station.is_work_light_inspected, "work light must be inspected")
	_expect(light_prop.is_activated, "work light prop must be activated")

	# Test 5: Step through full Scene 33 dialogue progression (11 lines)
	station.advance_dialogue() # to 1 (LENA: Powietrze robi się gęste...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker is LENA")

	station.advance_dialogue() # to 2 (JAKUB: Manometr wskazuje minus czterdzieści metrów...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "JAKUB", "line 2 speaker is JAKUB")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Wzdłuż ścian szybu biegną grube wiązki...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (LENA: Słyszysz te rytmiczne uderzenia z dołu?...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (JAKUB: To Rdzeń Wymiany Maszynowni Głównej...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (LENA: Jeśli zejdziemy na sam dół...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (JAKUB: UCP automatycznie rygluje wyższe poziomy szybu...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (LENA: Nie przyszłam tu, żeby wracać tą samą drogą, Jakub...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (ŚWIADECTWO: Wskaźnik ciśnienia sprzeczności osiąga wartość krytyczną...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (JAKUB: Trzymaj się poręczy. Schodzimy prosto w serce...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # past end
	_expect(not station.dialogue_active, "dialogue inactive after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for hatch opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 33 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_34() -> void:
	var packed_station := load("res://scenes/levels/station_34.tscn") as PackedScene
	_expect(packed_station != null, "station 34 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station34
	root.add_child(station)
	for f in range(4):
		await physics_frame

	var player := station.get_node_or_null("Player") as Node2D
	var camera := station.get_node_or_null("Camera2D") as Camera2D
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

	# Initial state assertions
	_expect(not station.is_reactor_inspected, "reactor not inspected initially")
	_expect(not station.is_desk_inspected, "allocation desk not inspected initially")
	_expect(not station.is_thermal_inspected, "thermal gauge not inspected initially")
	_expect(not station.is_probe_inspected, "diagnostic probe not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Reactor inspection at x=140
	player.global_position = Vector2(140.0, 240.0)
	await physics_frame
	await physics_frame
	reactor_prop.trigger_interaction()
	_expect(station.is_reactor_inspected, "reactor must be inspected")
	_expect(reactor_prop.is_activated, "reactor prop must be activated")
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 0, "dialogue must start at index 0")

	# Test 2: Allocation desk inspection at x=245
	player.global_position = Vector2(245.0, 245.0)
	await physics_frame
	await physics_frame
	desk_prop.trigger_interaction()
	_expect(station.is_desk_inspected, "desk must be inspected")
	_expect(desk_prop.is_activated, "desk prop must be activated")

	# Test 3: Thermal indicator inspection at x=345
	player.global_position = Vector2(345.0, 240.0)
	await physics_frame
	await physics_frame
	thermal_prop.trigger_interaction()
	_expect(station.is_thermal_inspected, "thermal gauge must be inspected")
	_expect(thermal_prop.is_activated, "thermal gauge prop must be activated")

	# Test 4: Jakub diagnostic probe inspection at x=445
	player.global_position = Vector2(445.0, 245.0)
	await physics_frame
	await physics_frame
	probe_prop.trigger_interaction()
	_expect(station.is_probe_inspected, "probe must be inspected")
	_expect(probe_prop.is_activated, "probe prop must be activated")

	# Test 5: Step through Scene 34 dialogue progression (11 lines)
	station.advance_dialogue() # to 1 (LENA: To tutaj UCP decyduje...)
	_expect(station.dialogue_index == 1, "dialogue at 1")
	_expect(station.dialogue_lines[1]["speaker"] == "LENA", "line 1 speaker is LENA")

	station.advance_dialogue() # to 2 (JAKUB: Rdzeń nie podejmuje decyzji moralnych...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "JAKUB", "line 2 speaker is JAKUB")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Na pulpicie alokacji widoczne są nazwiska...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (LENA: Popatrz na wskaźnik termiczny...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (JAKUB: Bo prawda nie znika, Lena...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Próbnik diagnostyczny Jakuba rejestruje...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (LENA: Jeśli zablokujemy suwaki alokacji...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (JAKUB: Zablokowanie alokacji wywoła dekompensację...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (ŚWIADECTWO: Zawory dekompresyjne Rdzenia otwierają się...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (LENA: Idziemy do filtrów. Pora zobaczyć...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # past end
	_expect(not station.dialogue_active, "dialogue inactive after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for gate opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 34 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_35() -> void:
	var packed_scene := load("res://scenes/levels/station_35.tscn") as PackedScene
	_expect(packed_scene != null, "station 35 scene does not load")
	if packed_scene == null:
		return

	var station := packed_scene.instantiate() as Station35
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as Camera2D
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

	# Initial state assertions
	_expect(not station.is_pool_inspected, "basin pool not inspected initially")
	_expect(not station.is_valve_inspected, "sludge valve not inspected initially")
	_expect(not station.is_chemical_inspected, "chemical sampler not inspected initially")
	_expect(not station.is_monitor_inspected, "monitor not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Basin pool inspection at x=140
	player.global_position = Vector2(140.0, 246.0)
	await physics_frame
	await physics_frame
	basin_prop.trigger_interaction()
	_expect(station.is_pool_inspected, "basin pool must be inspected")
	_expect(basin_prop.is_activated, "basin prop must be activated")
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 1, "dialogue advanced to 1 on basin inspection")

	# Test 2: Chemical sampler inspection at x=345
	player.global_position = Vector2(345.0, 246.0)
	await physics_frame
	await physics_frame
	chemical_prop.trigger_interaction()
	_expect(station.is_chemical_inspected, "chemical sampler must be inspected")
	_expect(chemical_prop.is_activated, "chemical sampler prop must be activated")

	# Test 3: Sludge valve inspection at x=245
	player.global_position = Vector2(245.0, 246.0)
	await physics_frame
	await physics_frame
	valve_prop.trigger_interaction()
	_expect(station.is_valve_inspected, "sludge valve must be inspected")
	_expect(valve_prop.is_activated, "sludge valve prop must be activated")

	# Test 4: Jakub monitor inspection at x=445
	player.global_position = Vector2(445.0, 246.0)
	await physics_frame
	await physics_frame
	monitor_prop.trigger_interaction()
	_expect(station.is_monitor_inspected, "monitor must be inspected")
	_expect(monitor_prop.is_activated, "monitor prop must be activated")

	# Test 5: Step through Scene 35 dialogue progression (11 lines)
	station.dialogue_index = 1
	station.advance_dialogue() # to 2 (JAKUB: To nie jest zwykła woda, Lena...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "JAKUB", "line 2 speaker is JAKUB")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Na dnie basenu widoczne są kontury...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (LENA: Szymon mówił prawdę o skażeniu...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (JAKUB: Uznano, że masowy spokój jest cenniejszy...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Próbnik chemiczny Jakuba wskazuje stężenie...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (LENA: Jeśli otworzymy zawór spustowy...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (JAKUB: Odpływ prowadzi przez Zimny Ściek...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (ŚWIADECTWO: Koło zaworu spustowego obraca się...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (LENA: Nie potrzebujemy znieczulenia, Jakub...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # past end
	_expect(station.is_dialogue_completed, "dialogue completed after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for sluice gate opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 35 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_36() -> void:
	var packed_station := load("res://scenes/levels/station_36.tscn") as PackedScene
	_expect(packed_station != null, "station 36 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station36
	_expect(station != null, "station 36 instance is valid")
	if station == null:
		return

	root.add_child(station)
	await physics_frame
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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

	# Initial state assertions
	_expect(not station.is_weir_inspected, "weir not inspected initially")
	_expect(not station.is_current_inspected, "sludge current not inspected initially")
	_expect(not station.is_ladder_inspected, "ladder not inspected initially")
	_expect(not station.is_tap_inspected, "sampling tap not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Sludge current inspection at x=245
	player.global_position = Vector2(245.0, 246.0)
	await physics_frame
	await physics_frame
	current_prop.trigger_interaction()
	_expect(station.is_current_inspected, "sludge current must be inspected")
	_expect(current_prop.is_activated, "sludge current prop must be activated")
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 1, "dialogue advanced to 1 on current inspection")

	# Test 2: Weir inspection at x=140
	player.global_position = Vector2(140.0, 246.0)
	station.dialogue_index = 2
	await physics_frame
	await physics_frame
	weir_prop.trigger_interaction()
	_expect(station.is_weir_inspected, "storm drain weir must be inspected")
	_expect(weir_prop.is_activated, "weir prop must be activated")

	# Test 3: Ladder inspection at x=345
	player.global_position = Vector2(345.0, 246.0)
	station.dialogue_index = 4
	await physics_frame
	await physics_frame
	ladder_prop.trigger_interaction()
	_expect(station.is_ladder_inspected, "catwalk ladder must be inspected")
	_expect(ladder_prop.is_activated, "ladder prop must be activated")

	# Test 4: Sampling tap inspection at x=445
	player.global_position = Vector2(445.0, 246.0)
	station.dialogue_index = 6
	await physics_frame
	await physics_frame
	tap_prop.trigger_interaction()
	_expect(station.is_tap_inspected, "sampling tap must be inspected")
	_expect(tap_prop.is_activated, "sampling tap prop must be activated")

	# Test 5: Step through Scene 36 dialogue progression (11 lines)
	station.dialogue_index = 1
	station.advance_dialogue() # to 2 (JAKUB: UCP wiedziało, że zrzut sedatywów...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "JAKUB", "line 2 speaker is JAKUB")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Na kracie jazu burzowego zatrzymały się...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (LENA: To nie był margines błędu...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (JAKUB: Dr Wierzbicka uważała, że alternatywą...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Kurek probierczy wód gruntowych wskazuje...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (LENA: Marta i inni piją tę wodę każdego dnia...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (JAKUB: Jeśli przejdziemy przez bramę przeciwsztormową...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (ŚWIADECTWO: Rygle bramy przeciwsztormowej cofają się...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (LENA: Idziemy do Komory Sygnałowej...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # past end
	_expect(station.is_dialogue_completed, "dialogue completed after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for storm blast gate opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 36 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_37() -> void:
	var packed_station := load("res://scenes/levels/station_37.tscn") as PackedScene
	_expect(packed_station != null, "station 37 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station37
	_expect(station != null, "station 37 instance is valid")
	if station == null:
		return

	root.add_child(station)
	await physics_frame
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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

	# Initial state assertions
	_expect(not station.is_oscilloscope_inspected, "oscilloscope not inspected initially")
	_expect(not station.is_patchbay_inspected, "patchbay not inspected initially")
	_expect(not station.is_antenna_inspected, "antenna not inspected initially")
	_expect(not station.is_pulpit_inspected, "pulpit not inspected initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Oscilloscope inspection at x=140
	player.global_position = Vector2(140.0, 246.0)
	await physics_frame
	await physics_frame
	crt_prop.trigger_interaction()
	_expect(station.is_oscilloscope_inspected, "oscilloscope must be inspected")
	_expect(crt_prop.is_activated, "oscilloscope prop must be activated")
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 1, "dialogue advanced to 1 on oscilloscope inspection")

	# Test 2: Patchbay inspection at x=245
	player.global_position = Vector2(245.0, 246.0)
	station.dialogue_index = 2
	await physics_frame
	await physics_frame
	patchbay_prop.trigger_interaction()
	_expect(station.is_patchbay_inspected, "patchbay must be inspected")
	_expect(patchbay_prop.is_activated, "patchbay prop must be activated")

	# Test 3: Antenna inspection at x=345
	player.global_position = Vector2(345.0, 246.0)
	station.dialogue_index = 4
	await physics_frame
	await physics_frame
	antenna_prop.trigger_interaction()
	_expect(station.is_antenna_inspected, "antenna must be inspected")
	_expect(antenna_prop.is_activated, "antenna prop must be activated")

	# Test 4: Injection pulpit inspection at x=445
	player.global_position = Vector2(445.0, 246.0)
	station.dialogue_index = 6
	await physics_frame
	await physics_frame
	pulpit_prop.trigger_interaction()
	_expect(station.is_pulpit_inspected, "injection pulpit must be inspected")
	_expect(pulpit_prop.is_activated, "pulpit prop must be activated")

	# Test 5: Step through Scene 37 dialogue progression (11 lines)
	station.dialogue_index = 1
	station.advance_dialogue() # to 2 (JAKUB: Wierzbicka uważała, że dwie wersje...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "JAKUB", "line 2 speaker is JAKUB")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Na krosownicy transmisyjnej wpięte są...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (LENA: Jeśli przełączymy hebelki...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (JAKUB: To obudzi pamięć całego miasta...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Pulpit injekcyjny zostaje uzbrojony...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (LENA: Nie boję się sprzeczności...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (JAKUB: Za śluzą transmisyjną zaczyna się...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (ŚWIADECTWO: Rygiel śluzy transmisyjnej ustępuje...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (LENA: Przejdźmy przez to razem, Jakub...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # past end
	_expect(station.is_dialogue_completed, "dialogue completed after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for broadcast gate opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 37 must complete upon entering airlock zone")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_38() -> void:
	var packed_station := load("res://scenes/levels/station_38.tscn") as PackedScene
	_expect(packed_station != null, "station 38 scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station38
	_expect(station != null, "station 38 instance is valid")
	if station == null:
		return

	root.add_child(station)
	await physics_frame
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
	var props := station.get_node_or_null("Props") as Node2D
	var airlock := station.get_node_or_null("AirlockZone") as Area2D

	_expect(player != null, "station 38 player exists")
	_expect(camera != null, "station 38 camera exists")
	_expect(props != null, "station 38 props container exists")
	_expect(airlock != null, "station 38 airlock zone exists")

	if props == null or player == null:
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

	# Initial state assertions
	_expect(not station.is_calculator_inspected, "calculator not inspected initially")
	_expect(not station.is_accident_field_inspected, "accident field not inspected initially")
	_expect(not station.is_jakub_shadow_inspected, "jakub shadow not inspected initially")
	_expect(not station.is_rescue_tether_anchored, "rescue tether not anchored initially")
	_expect(not station.is_exit_unlocked, "exit must start locked")
	_expect(not station.is_level_completed, "level must not start completed")

	# Test 1: Calculator inspection at x=140
	player.global_position = Vector2(140.0, 246.0)
	await physics_frame
	await physics_frame
	calc_prop.trigger_interaction()
	_expect(station.is_calculator_inspected, "calculator must be inspected")
	_expect(calc_prop.is_activated, "calculator prop must be activated")
	_expect(station.dialogue_active, "dialogue must start active")
	_expect(station.dialogue_index == 1, "dialogue advanced to 1 on calculator inspection")

	# Test 2: Accident field inspection at x=245
	player.global_position = Vector2(245.0, 242.0)
	station.dialogue_index = 2
	await physics_frame
	await physics_frame
	field_prop.trigger_interaction()
	_expect(station.is_accident_field_inspected, "accident field must be inspected")
	_expect(field_prop.is_activated, "accident field prop must be activated")

	# Test 3: Jakub shadow inspection at x=345
	player.global_position = Vector2(345.0, 246.0)
	station.dialogue_index = 4
	await physics_frame
	await physics_frame
	jakub_prop.trigger_interaction()
	_expect(station.is_jakub_shadow_inspected, "jakub shadow must be inspected")
	_expect(jakub_prop.is_activated, "jakub shadow prop must be activated")

	# Test 4: Rescue tether anchoring at x=445
	player.global_position = Vector2(445.0, 246.0)
	station.dialogue_index = 6
	await physics_frame
	await physics_frame
	rescue_prop.trigger_interaction()
	_expect(station.is_rescue_tether_anchored, "rescue tether must be anchored")
	_expect(rescue_prop.is_activated, "rescue tether prop must be activated")

	# Test 5: Step through Scene 38 dialogue progression (11 lines)
	station.dialogue_index = 1
	station.advance_dialogue() # to 2 (LENA: Trzymaj się poręczy! Twoje ciało...)
	_expect(station.dialogue_index == 2, "dialogue at 2")
	_expect(station.dialogue_lines[2]["speaker"] == "LENA", "line 2 speaker is LENA")

	station.advance_dialogue() # to 3 (ŚWIADECTWO: Kalkulator współrzędnych UCP przelicza...)
	_expect(station.dialogue_index == 3, "dialogue at 3")

	station.advance_dialogue() # to 4 (JAKUB: Jeśli użyjesz mnie jako współrzędnej...)
	_expect(station.dialogue_index == 4, "dialogue at 4")

	station.advance_dialogue() # to 5 (LENA: Nie po to zeszłam do Podstruktury...)
	_expect(station.dialogue_index == 5, "dialogue at 5")

	station.advance_dialogue() # to 6 (ŚWIADECTWO: Lena odrzuca kalkulację instrumentalną...)
	_expect(station.dialogue_index == 6, "dialogue at 6")

	station.advance_dialogue() # to 7 (JAKUB: Jesteś pewna? Jeśli mnie wyciągniesz...)
	_expect(station.dialogue_index == 7, "dialogue at 7")

	station.advance_dialogue() # to 8 (LENA: Jesteś moim bratem, Jakub...)
	_expect(station.dialogue_index == 8, "dialogue at 8")

	station.advance_dialogue() # to 9 (JAKUB: Możemy to sprawdzić jutro...)
	_expect(station.dialogue_index == 9, "dialogue at 9")
	_expect(station.is_exit_unlocked, "exit unlocked at line 9")

	station.advance_dialogue() # to 10 (ŚWIADECTWO: Rygiel Komory Referencyjnej ustępuje...)
	_expect(station.dialogue_index == 10, "dialogue at 10")

	station.advance_dialogue() # past end
	_expect(station.is_dialogue_completed, "dialogue completed after finish")
	_expect(station.is_exit_unlocked, "exit unlocked after dialogue")
	_expect(exit_prop.is_activated, "exit prop activated")

	# Advance physics frames for reference vault door opening transition
	for f in range(25):
		await physics_frame

	_expect(station._exit_open_progress > 0.1, "exit open progress must advance")

	# Test 6: Player enters AirlockZone at x=610 to complete level
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
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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

	var station := packed_station.instantiate() as Station42A
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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

	var cups_prop := props.get_node_or_null("ReturnCups") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station42AExit") as MemoryResonancePoint

	_expect(cups_prop != null, "return cups prop exists")
	_expect(exit_prop != null, "station 42a exit prop exists")

	if cups_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(cups_prop.prop_type == 197, "return cups prop_type must be 197")
	_expect(exit_prop.prop_type == 196, "exit prop_type must be 196")

	# Initial state
	_expect(not station.is_cups_inspected, "cups not inspected initially")
	_expect(not station.is_exit_unlocked, "exit not unlocked initially")

	# Test 1: Inspect cups at x=280 and complete dialogue D-15A
	player.global_position = Vector2(280.0, 248.0)
	await physics_frame
	await physics_frame
	cups_prop.trigger_interaction()
	_expect(station.is_cups_inspected, "cups must be inspected")

	# Advance dialogue to completion
	while station.dialogue_index < station.dialogue_lines.size() - 1:
		station.advance_dialogue()
	station.advance_dialogue()

	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "exit must be unlocked")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Test 2: Enter airlock zone at x=610
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 42a completed upon entering airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_42b() -> void:
	var packed_station := load("res://scenes/levels/station_42b.tscn") as PackedScene
	_expect(packed_station != null, "station 42b scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station42B
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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

	var doorstep_prop := props.get_node_or_null("MartaDoorstep") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station42BExit") as MemoryResonancePoint

	_expect(doorstep_prop != null, "marta doorstep prop exists")
	_expect(exit_prop != null, "station 42b exit prop exists")

	if doorstep_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(doorstep_prop.prop_type == 198, "doorstep prop_type must be 198")
	_expect(exit_prop.prop_type == 196, "exit prop_type must be 196")

	# Initial state
	_expect(not station.is_doorstep_inspected, "doorstep not inspected initially")
	_expect(not station.is_exit_unlocked, "exit not unlocked initially")

	# Test 1: Inspect doorstep at x=280 and complete dialogue D-15B
	player.global_position = Vector2(280.0, 248.0)
	await physics_frame
	await physics_frame
	doorstep_prop.trigger_interaction()
	_expect(station.is_doorstep_inspected, "doorstep must be inspected")

	# Advance dialogue to completion
	while station.dialogue_index < station.dialogue_lines.size() - 1:
		station.advance_dialogue()
	station.advance_dialogue()

	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "exit must be unlocked")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Test 2: Enter airlock zone at x=610
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

	_expect(station.is_level_completed, "station 42b completed upon entering airlock")

	station.queue_free()
	for f in range(4):
		await process_frame


func _test_station_42c() -> void:
	var packed_station := load("res://scenes/levels/station_42c.tscn") as PackedScene
	_expect(packed_station != null, "station 42c scene does not load")
	if packed_station == null:
		return

	var station := packed_station.instantiate() as Station42C
	root.add_child(station)
	await physics_frame

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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

	var tram_prop := props.get_node_or_null("TramDualTracks") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station42CExit") as MemoryResonancePoint

	_expect(tram_prop != null, "tram dual tracks prop exists")
	_expect(exit_prop != null, "station 42c exit prop exists")

	if tram_prop == null or exit_prop == null:
		station.queue_free()
		await process_frame
		return

	_expect(tram_prop.prop_type == 199, "tram prop_type must be 199")
	_expect(exit_prop.prop_type == 196, "exit prop_type must be 196")

	# Initial state
	_expect(not station.is_tram_inspected, "tram not inspected initially")
	_expect(not station.is_exit_unlocked, "exit not unlocked initially")

	# Test 1: Inspect tram at x=280 and complete dialogue D-15C
	player.global_position = Vector2(280.0, 248.0)
	await physics_frame
	await physics_frame
	tram_prop.trigger_interaction()
	_expect(station.is_tram_inspected, "tram must be inspected")

	# Advance dialogue to completion
	while station.dialogue_index < station.dialogue_lines.size() - 1:
		station.advance_dialogue()
	station.advance_dialogue()

	_expect(station.is_dialogue_completed, "dialogue must be completed")
	_expect(station.is_exit_unlocked, "exit must be unlocked")
	_expect(exit_prop.is_activated, "exit prop must be activated")

	# Test 2: Enter airlock zone at x=610
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

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
	var camera := station.get_node_or_null("Camera2D") as CinematicCamera
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
	player.global_position = Vector2(610.0, 245.0)
	for f in range(5):
		await physics_frame

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
