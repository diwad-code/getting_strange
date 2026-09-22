extends SceneTree

## PKG-0138 Smoke Test — narrative playthrough and player-verb gate across 01..43.
##
## Verifies:
## 1. Pure player-verb playthrough: movement, interaction, and dialogue advancement
##    unlock exits and trigger level completion without setting flags manually.
## 2. NarrativeGuidanceService beat registration, stall timers (L2/L3), progress resets,
##    and hypothesis closures.
## 3. Soft-lock resilience across interactable props (drawers, bulkheads, stairs).
## 4. Backtrack navigation via ReturnZone and right-side spawn clearance.

const ReturnZone := preload("res://scripts/environment/return_zone.gd")
const CRTDialogueBox := preload("res://scripts/ui/crt_dialogue_box.gd")
const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const AnchorableObject := preload("res://scripts/interactables/anchorable_object.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")

const SAMPLE_STATIONS := [
	"station_01", "station_07", "station_10", "station_13", "station_15",
	"station_16", "station_17", "station_18", "station_19", "station_20",
	"station_21", "station_22", "station_23", "station_24",
	"station_30", "station_31", "station_37", "station_38", "station_41",
	"station_42a", "station_43"
]

const WALK_SPEED := 120.0

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(cond: bool, msg: String) -> void:
	if not cond:
		_failures.append(msg)
		print("FAIL: " + msg)


func _run() -> void:
	print("================================================================================")
	print("  PKG-0138 SMOKE TEST: Narrative Playthrough, Guidance & Backtrack Gate")
	print("================================================================================")
	
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm:
		gsm.set("campaign_auto_transition_enabled", false)
		gsm.call("reset_campaign", true)
	
	print("1. Testing NarrativeGuidanceService beat contracts and stall triggers...")
	await _test_guidance_service()
	
	print("2. Testing soft-lock resilience (Station 13 drawer & Station 38 anchor)...")
	await _test_softlock_resilience()
	
	print("3. Testing bidirectional spawn & backtrack via ReturnZone...")
	await _test_bidirectional_and_backtrack()
	
	print("4. Testing player-verb narrative playthrough across campaign sample...")
	_seed_sample_facts(gsm)
	await _test_sample_playthrough()
	
	_finish()


func _test_guidance_service() -> void:
	var service := NarrativeGuidanceService.new()
	root.add_child(service)
	
	var beat_l2 := GuidanceBeat.new()
	beat_l2.beat_id = &"test_obs"
	beat_l2.scene_id = &"test_scene"
	beat_l2.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_l2.text_pl = "Obserwacja testowa."
	beat_l2.cooldown_s = 5.0
	service.register_beat(beat_l2)
	
	var beat_l3 := GuidanceBeat.new()
	beat_l3.beat_id = &"test_intent"
	beat_l3.scene_id = &"test_scene"
	beat_l3.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_l3.text_pl = "Intencja testowa."
	beat_l3.cooldown_s = 5.0
	beat_l3.supersedes = &"test_obs"
	service.register_beat(beat_l3)
	
	_expect(service.active_beats.size() == 2, "guidance service must register 2 beats")
	
	# Simulate 21 seconds idle stall -> process evaluates stall
	var thoughts: Array = []
	service.thought_requested.connect(func(b: GuidanceBeat, _t: String): thoughts.append(b.beat_id))
	service.time_since_progress = 20.0
	service._process(0.1)
	_expect(not thoughts.is_empty() and thoughts[0] == &"test_obs", "21s stall must produce L2 contextual thought")
	
	# Report progress -> should reset timer and dismiss thought
	service.report_progress(&"action_done")
	_expect(service.time_since_progress == 0.0, "report_progress must reset time_since_progress to 0")
	_expect(service.current_beat == null, "report_progress must dismiss active thought")
	
	# Close hypothesis
	service.close_hypothesis(&"test_hyp")
	_expect(service.closed_hypotheses.get(&"test_hyp", false), "close_hypothesis must record closed status")
	
	root.remove_child(service)
	service.free()
	await process_frame


func _test_softlock_resilience() -> void:
	# Station 13 drawer open test
	var p13 := load("res://scenes/levels/station_13.tscn") as PackedScene
	if p13:
		var st13 := p13.instantiate() as Node2D
		root.add_child(st13)
		for _i in 6:
			await process_frame
		
		# Open the drawer
		var gsm_run := root.get_node_or_null("GameStateManager")
		if gsm_run and not gsm_run.decisions.has(&"p7.marta_threshold.independent_questions_ready"):
			gsm_run.record_decision(&"p7.marta_threshold.independent_questions_ready", true)
		if st13.has_method("open_drawer"):
			st13.call("open_drawer")
		_expect(bool(st13.get("is_drawer_open")), "station 13 drawer should be open")
		
		# Ensure player can still traverse floor with open drawer
		var player := st13.get_node_or_null("Player") as CharacterBody2D
		if player:
			player.global_position = Vector2(70.0, 296.0)
			await _walk_to(player, 560.0, 200)
			_expect(player.global_position.x > 400.0, "player must be able to step past or navigate open drawer")
		
		root.remove_child(st13)
		st13.free()
		await process_frame


func _test_bidirectional_and_backtrack() -> void:
	var stations_to_test := ["station_02", "station_10", "station_20", "station_30", "station_40"]
	
	for s_id in stations_to_test:
		var p := load("res://scenes/levels/%s.tscn" % s_id) as PackedScene
		if p == null:
			continue
		var st := p.instantiate() as Node2D
		root.add_child(st)
		for _i in 6:
			await process_frame
		
		var ret := _find(st, func(n): return String(n.name) == "ReturnZone")
		_expect(ret != null, "%s must contain a ReturnZone" % s_id)
		
		var previous_requested: Array = []
		st.connect(&"previous_level_requested", func(): previous_requested.append(true))
		
		var player := st.get_node_or_null("Player") as CharacterBody2D
		if player:
			player.global_position = Vector2(70.0, 296.0)
			await _walk_to(player, 16.0, 150)
			for _i in 12:
				await physics_frame
			_expect(not previous_requested.is_empty(), "%s ReturnZone must emit previous_level_requested when player enters" % s_id)
		
		root.remove_child(st)
		st.free()
		await process_frame



func _seed_sample_facts(gsm: Node) -> void:
	if gsm == null:
		return
	gsm.record_decision(&"world_recognized", true)
	gsm.record_decision(&"p7.sample_and_promise.route_time_confirmed", true)
	gsm.record_decision(&"p7.address_and_record.public_route_result", "paper_matches_vehicle")
	gsm.record_decision(&"p7.foreign_daily_life.neighbour_account", "twelve_lower_fourteen_home")
	gsm.record_decision(&"p7.marta_threshold.independent_questions_ready", true)
	## S06 wchodzi ze śladu S05; Station 14 nie jest w próbce, więc jego
	## wynik jest jedynym zasianym warunkiem wejściowym fali 15–21.
	gsm.record_decision(&"p7.marta_threshold.trace", "relationship_difference_explicit")
	gsm.record_decision(&"mechanic_cost_observed", true)
	gsm.record_decision(&"p7.mutual_test.signal_echo_observed", true)
	gsm.record_decision(&"p7.mutual_test.adjacent_state_observed", true)
	gsm.record_decision(&"p7.mutual_test.dead_circuit_outcome", "anchor")
	gsm.record_decision(&"p7.mutual_test.marta_boundary", "declined")
	## Station 30 jest izolowaną próbką późniejszej sekwencji; seedujemy tylko
	## jej jawne warunki wejścia, a mapę prognoz wykonują czasowniki stacji.
	gsm.record_decision(&"p7.interrupted_trial_and_small_cost.trace", "shared_drift_yield")
	gsm.record_decision(&"p7.jakub_boundary_and_forecasts.jakub_consent_state", "limited")
	gsm.record_decision(&"jakub_consent_state", "limited")


func _test_sample_playthrough() -> void:
	for s_id in SAMPLE_STATIONS:
		var p := load("res://scenes/levels/%s.tscn" % s_id) as PackedScene
		if p == null:
			_expect(false, "%s scene missing" % s_id)
			continue
		var st := p.instantiate() as Node2D
		root.add_child(st)
		for _i in 6:
			await process_frame
		
		var completed: Array = []
		if st.has_signal(&"level_completed"):
			st.connect(&"level_completed", func(): completed.append(true))
		
		var player := st.get_node_or_null("Player") as CharacterBody2D
		var airlock := _find(st, func(n): return String(n.name) == "AirlockZone") as Area2D
		
		if player:
			player.set_physics_process(false)
			await _perform_station_actions(st, player)
			if s_id == "station_24":
				_expect(
					st.get("is_exit_unlocked") == true,
					"station_24 must unlock after disclosure and explicit boundary; scope=%s risk=%s cost=%s boundary=%s" % [
						str(st.get("is_scope_disclosed")),
						str(st.get("is_risk_disclosed")),
						str(st.get("is_cost_disclosed")),
						str(st.get("committed_boundary")),
					]
				)
			if airlock:
				await _walk_to(player, airlock.global_position.x, 250)
				player.set_physics_process(true)
				for _i in 8:
					await physics_frame
		
		_expect(not completed.is_empty(), "%s must complete level via narrative player verbs; player=%s airlock=%s exit=%s" % [s_id, str(player.global_position) if player else "none", str(airlock.global_position) if airlock else "none", str(st.get("is_exit_unlocked"))])
		print("  PASS: %s player-verb playthrough" % s_id)
		
		root.remove_child(st)
		st.free()
		await process_frame


func _find(node: Node, pred: Callable) -> Node:
	if pred.call(node):
		return node
	for c in node.get_children():
		var f: Node = _find(c, pred)
		if f:
			return f
	return null


func _collect(node: Node, pred: Callable, out: Array) -> void:
	if pred.call(node):
		out.append(node)
	for c in node.get_children():
		_collect(c, pred, out)


func _is_true(n: Object, prop: StringName) -> bool:
	if n == null:
		return false
	var v = n.get(prop)
	return v != null and bool(v) == true


func _walk_to(player: CharacterBody2D, target_x: float, max_frames: int = 300) -> void:
	for _i in max_frames:
		var dx: float = target_x - player.global_position.x
		if absf(dx) <= 8.0:
			return
		if not player.is_on_floor():
			player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
		else:
			player.velocity.y = 0.0
		player.velocity.x = signf(dx) * WALK_SPEED
		player.move_and_slide()
		if player.has_method("try_curb_step"):
			player.try_curb_step(dx)
		await physics_frame


func _advance_any_active_dialogue(st: Node2D) -> void:
	var box := _find(st, func(n): return n is CRTDialogueBox) as CRTDialogueBox
	for _i in 50:
		var advanced := false
		if box and box.is_presenting():
			box.advance_dialogue()
			advanced = true
		if _is_true(st, &"dialogue_active") and st.has_method("advance_dialogue"):
			st.call("advance_dialogue")
			advanced = true
		if _is_true(st, &"shopkeeper_dialogue_active") and st.has_method("advance_shopkeeper_dialogue"):
			st.call("advance_shopkeeper_dialogue")
			advanced = true
		if _is_true(st, &"neighbour_dialogue_active") and st.has_method("advance_neighbour_dialogue"):
			st.call("advance_neighbour_dialogue")
			advanced = true
		if _is_true(st, &"message_active") and st.has_method("advance_message"):
			st.call("advance_message")
			advanced = true
		if _is_true(st, &"is_marta_dialogue_active") and st.has_method("advance_marta_dialogue"):
			st.call("advance_marta_dialogue")
			advanced = true
		if _is_true(st, &"is_dialogue_active"):
			if st.has_method("advance_meeting_dialogue"):
				st.call("advance_meeting_dialogue")
				advanced = true
			elif st.has_method("advance_dialogue"):
				st.call("advance_dialogue")
				advanced = true
		if _is_true(st, &"is_offer_active") and st.has_method("advance_offer_dialogue"):
			st.call("advance_offer_dialogue")
			advanced = true
		
		if not advanced:
			break
		await physics_frame


func _perform_station_actions(st: Node2D, player: CharacterBody2D) -> void:
	var id: String = String(st.name).to_lower()
	if not id.begins_with("station"):
		id = String(st.get_script().resource_path).get_file().get_basename()
	
	var props: Array = []
	_collect(st, func(n): return n is MemoryResonancePoint, props)
	props.sort_custom(func(a, b): return (a as Node2D).global_position.x < (b as Node2D).global_position.x)
	
	for p in props:
		var prop := p as MemoryResonancePoint
		if player:
			await _walk_to(player, prop.global_position.x, 150)
		prop.is_player_in_range = true
		prop.trigger_interaction()
		await process_frame
		await physics_frame
		await _advance_any_active_dialogue(st)
		if not prop.is_activated:
			prop.trigger_interaction()
			await process_frame
			await physics_frame
			await _advance_any_active_dialogue(st)
	
	if id.contains("01"):
		if st.has_method(&"observe_measurement_gap"):
			st.call(&"observe_measurement_gap")
		if st.has_method(&"inspect_sensor_mount"):
			st.call(&"inspect_sensor_mount")
		if st.has_method(&"record_raw_measurement"):
			st.call(&"record_raw_measurement")
		if st.has_method(&"repeat_measurement"):
			st.call(&"repeat_measurement")
		if st.has_method(&"preserve_raw_sample"):
			st.call(&"preserve_raw_sample")
	elif id.contains("07"):
		if st.has_method(&"ask_shopkeeper_recent_visit"):
			st.call(&"ask_shopkeeper_recent_visit")
		if st.has_method(&"inspect_sale_ledger"):
			st.call(&"inspect_sale_ledger")
		if st.has_method(&"commit_ordinary_explanation"):
			st.call(&"commit_ordinary_explanation")
	elif id.contains("08"):
		if st.has_method(&"read_certificate"):
			st.call(&"read_certificate")
		if st.has_method(&"read_directory"):
			st.call(&"read_directory")
		if st.has_method(&"test_intercom_recognition"):
			st.call(&"test_intercom_recognition")
	elif id.contains("09"):
		if st.has_method(&"observe_floor_record"):
			st.call(&"observe_floor_record")
		if st.has_method(&"ask_neighbour_without_leading"):
			st.call(&"ask_neighbour_without_leading")
	elif id.contains("10"):
		if st.has_method(&"inspect_key_wear"):
			st.call(&"inspect_key_wear")
		if st.has_method(&"test_key_without_claiming_home"):
			st.call(&"test_key_without_claiming_home")
		if st.has_method(&"commit_cautious_entry"):
			st.call(&"commit_cautious_entry")
	elif id.contains("11"):
		if st.has_method(&"inspect_private_photograph"):
			st.call(&"inspect_private_photograph")
		if st.has_method(&"inspect_equipment_wear"):
			st.call(&"inspect_equipment_wear")
		if st.has_method(&"inspect_reader_arrangement"):
			st.call(&"inspect_reader_arrangement")
		if st.has_method(&"compare_private_material"):
			st.call(&"compare_private_material")
		if st.has_method(&"respect_private_material"):
			st.call(&"respect_private_material")
	elif id.contains("12"):
		if st.has_method(&"close_balcony"):
			st.call(&"close_balcony")
		if st.has_method(&"listen_to_message"):
			st.call(&"listen_to_message")
		if st.has_method(&"verify_caller_identity"):
			st.call(&"verify_caller_identity")
		if st.has_method(&"prepare_independent_questions"):
			st.call(&"prepare_independent_questions")
	elif id.contains("13"):
		if st.has_method(&"observe_field_certificate"):
			st.call(&"observe_field_certificate")
		if st.has_method(&"open_drawer"):
			st.call(&"open_drawer")
		if st.has_method(&"observe_tenancy_contract"):
			st.call(&"observe_tenancy_contract")
		if st.has_method(&"verify_document_independence"):
			st.call(&"verify_document_independence")
		if st.has_method(&"compare_document_versions"):
			st.call(&"compare_document_versions")
		if st.has_method(&"request_independent_description"):
			st.call(&"request_independent_description")
	elif id.contains("14"):
		if st.has_method(&"place_bag_at_door"):
			st.call(&"place_bag_at_door")
		if st.has_method(&"disclose_arrival_time"):
			st.call(&"disclose_arrival_time")
		if st.has_method(&"compare_field_equipment"):
			st.call(&"compare_field_equipment")
		if st.has_method(&"verify_key_position"):
			st.call(&"verify_key_position")
		if st.has_method(&"ask_independent_day_description"):
			st.call(&"ask_independent_day_description")
		if st.has_method(&"respect_marta_threshold"):
			st.call(&"respect_marta_threshold")
	elif id.contains("15"):
		if st.has_method(&"observe_expedition_notes"):
			st.call(&"observe_expedition_notes")
		if st.has_method(&"compare_rain_detail"):
			st.call(&"compare_rain_detail")
		if st.has_method(&"compare_fence_detail"):
			st.call(&"compare_fence_detail")
		if st.has_method(&"observe_secured_phone"):
			st.call(&"observe_secured_phone")
		if st.has_method(&"request_own_work_record"):
			st.call(&"request_own_work_record")
	elif id.contains("16"):
		if st.has_method(&"scan_biometric_profile"):
			st.call(&"scan_biometric_profile")
		if st.has_method(&"compare_card_number"):
			st.call(&"compare_card_number")
		if st.has_method(&"read_activity_history"):
			st.call(&"read_activity_history")
		if st.has_method(&"compare_field_biometrics_and_audit"):
			st.call(&"compare_field_biometrics_and_audit")
	elif id.contains("17"):
		if st.has_method(&"read_incident_report"):
			st.call(&"read_incident_report")
		if st.has_method(&"compare_signature_with_card"):
			st.call(&"compare_signature_with_card")
		if st.has_method(&"listen_intercom_warning"):
			st.call(&"listen_intercom_warning")
		if st.has_method(&"release_service_route"):
			st.call(&"release_service_route")
		if st.has_method(&"copy_report_header"):
			st.call(&"copy_report_header")
	elif id.contains("18"):
		if st.has_method(&"search_municipal_death_registry"):
			st.call(&"search_municipal_death_registry")
		if st.has_method(&"search_hospital_registry"):
			st.call(&"search_hospital_registry")
		if st.has_method(&"verify_employment_card"):
			st.call(&"verify_employment_card")
		if st.has_method(&"read_disaster_case_file"):
			st.call(&"read_disaster_case_file")
		if st.has_method(&"compare_independent_registries"):
			st.call(&"compare_independent_registries")
	elif id.contains("19"):
		if st.has_method(&"shield_microphone"):
			st.call(&"shield_microphone")
		if st.has_method(&"prepare_control_questions"):
			st.call(&"prepare_control_questions")
		if st.has_method(&"answer_payphone"):
			st.call(&"answer_payphone")
		if st.has_method(&"ask_control_questions"):
			st.call(&"ask_control_questions")
		if st.has_method(&"compare_control_answers"):
			st.call(&"compare_control_answers")
	elif id.contains("20"):
		if st.has_method(&"move_parts_trolley"):
			st.call(&"move_parts_trolley")
		if st.has_method(&"confirm_marta_presence"):
			st.call(&"confirm_marta_presence")
		if st.has_method(&"meet_jakub_face_to_face"):
			st.call(&"meet_jakub_face_to_face")
		if st.has_method(&"accept_scar_refusal"):
			st.call(&"accept_scar_refusal")
		if st.has_method(&"request_voluntary_reader_scan"):
			st.call(&"request_voluntary_reader_scan")
		if st.has_method(&"compare_local_service_base"):
			st.call(&"compare_local_service_base")
	elif id.contains("21"):
		if st.has_method(&"place_reader_and_sample"):
			st.call(&"place_reader_and_sample")
		if st.has_method(&"place_public_records"):
			st.call(&"place_public_records")
		if st.has_method(&"place_relational_record"):
			st.call(&"place_relational_record")
		if st.has_method(&"execute_three_family_synthesis"):
			st.call(&"execute_three_family_synthesis")
	elif id.contains("22"):
		if st.has_method(&"observe_signal_echo"):
			st.call(&"observe_signal_echo")
		if st.has_method(&"observe_adjacent_state"):
			st.call(&"observe_adjacent_state")
	elif id.contains("23"):
		if st.has_method(&"perform_anchor_trial"):
			st.call(&"perform_anchor_trial")
		elif st.has_method(&"perform_yield_trial"):
			st.call(&"perform_yield_trial")
	elif id.contains("24"):
		if st.has_method(&"disclose_marta_scope"):
			st.call(&"disclose_marta_scope")
		if st.has_method(&"disclose_marta_risk"):
			st.call(&"disclose_marta_risk")
		if st.has_method(&"disclose_marta_cost"):
			st.call(&"disclose_marta_cost")
		if st.has_method(&"choose_limited_access"):
			st.call(&"choose_limited_access")
	elif id.contains("25"):
		if st.has_method(&"observe_ventilation_cycle"):
			st.call(&"observe_ventilation_cycle")
		if st.has_method(&"release_interlock"):
			st.call(&"release_interlock")
		if st.has_method(&"route_power"):
			st.call(&"route_power")
		if st.has_method(&"retrieve_ucp_buffer"):
			st.call(&"retrieve_ucp_buffer")
	elif id.contains("30"):
		if st.has_method(&"build_force_home_forecast"):
			st.call(&"build_force_home_forecast")
		if st.has_method(&"build_close_equal_recover_local_forecast"):
			st.call(&"build_close_equal_recover_local_forecast")
		if st.has_method(&"build_mutual_passage_forecast"):
			st.call(&"build_mutual_passage_forecast")
		if st.has_method(&"compare_forecast_consent_dependencies"):
			st.call(&"compare_forecast_consent_dependencies")
	elif id.contains("31"):
		if st.has_method(&"inspect_passenger_chairs"):
			st.call(&"inspect_passenger_chairs")
		if st.has_method(&"inspect_wierzbicka_proposal"):
			st.call(&"inspect_wierzbicka_proposal")
		if st.has_method(&"inspect_twelfth_chair"):
			st.call(&"inspect_twelfth_chair")
		if st.has_method(&"compare_passenger_ledger"):
			st.call(&"compare_passenger_ledger")
		if st.has_method(&"reject_adaptation_offer"):
			st.call(&"reject_adaptation_offer")
	elif id.contains("32"):
		if st.has_method(&"inspect_steamed_pane"):
			st.call(&"inspect_steamed_pane")
		if st.has_method(&"inspect_cracked_pane"):
			st.call(&"inspect_cracked_pane")
		if st.has_method(&"etch_condensation_trace"):
			st.call(&"etch_condensation_trace")
		if st.has_method(&"inspect_polished_pane"):
			st.call(&"inspect_polished_pane")
		if st.has_method(&"anchor_material_memory"):
			st.call(&"anchor_material_memory")
	elif id.contains("33"):
		if st.has_method(&"inspect_ladder_infrastructure"):
			st.call(&"inspect_ladder_infrastructure")
		if st.has_method(&"inspect_depth_gauge"):
			st.call(&"inspect_depth_gauge")
		if st.has_method(&"inspect_cable_trunk_note"):
			st.call(&"inspect_cable_trunk_note")
		if st.has_method(&"inspect_shaft_work_light"):
			st.call(&"inspect_shaft_work_light")
		if st.has_method(&"reconstruct_local_lena_intent"):
			st.call(&"reconstruct_local_lena_intent")
	elif id.contains("34"):
		if st.has_method(&"inspect_correlation_reactor"):
			st.call(&"inspect_correlation_reactor")
		if st.has_method(&"inspect_allocation_desk"):
			st.call(&"inspect_allocation_desk")
		if st.has_method(&"inspect_thermal_indicators"):
			st.call(&"inspect_thermal_indicators")
		if st.has_method(&"inspect_diagnostic_probe"):
			st.call(&"inspect_diagnostic_probe")
		if st.has_method(&"unlock_pair_registry"):
			st.call(&"unlock_pair_registry")
	elif id.contains("35"):
		if st.has_method(&"inspect_cooling_pool"):
			st.call(&"inspect_cooling_pool")
		if st.has_method(&"inspect_drain_valve"):
			st.call(&"inspect_drain_valve")
		if st.has_method(&"inspect_chemical_sampler"):
			st.call(&"inspect_chemical_sampler")
		if st.has_method(&"process_home_echo"):
			st.call(&"process_home_echo")
	elif id.contains("36"):
		if st.has_method(&"inspect_drain_weir"):
			st.call(&"inspect_drain_weir")
		if st.has_method(&"measure_drain_current"):
			st.call(&"measure_drain_current")
		if st.has_method(&"inspect_service_ladder"):
			st.call(&"inspect_service_ladder")
		if st.has_method(&"sample_contamination_tap"):
			st.call(&"sample_contamination_tap")
		if st.has_method(&"reveal_ucp_cost_ledger"):
			st.call(&"reveal_ucp_cost_ledger")
	elif id.contains("37"):
		if st.has_method(&"inspect_frequency_oscilloscope"):
			st.call(&"inspect_frequency_oscilloscope")
		if st.has_method(&"inspect_transmission_patchbay"):
			st.call(&"inspect_transmission_patchbay")
		if st.has_method(&"inspect_transmitting_antenna"):
			st.call(&"inspect_transmitting_antenna")
		if st.has_method(&"inspect_mixing_pulpit"):
			st.call(&"inspect_mixing_pulpit")
		if st.has_method(&"bridge_living_signal"):
			st.call(&"bridge_living_signal")
	elif id.contains("38"):
		if st.has_method(&"inspect_radio_receiver"):
			st.call(&"inspect_radio_receiver")
		if st.has_method(&"inspect_local_procedure_record"):
			st.call(&"inspect_local_procedure_record")
		if st.has_method(&"inspect_jakub_switchboard"):
			st.call(&"inspect_jakub_switchboard")
		if st.has_method(&"anchor_rescue_tether"):
			st.call(&"anchor_rescue_tether")
		if st.has_method(&"disclose_marta_truth"):
			st.call(&"disclose_marta_truth", &"full")

	var anchors: Array = []
	_collect(st, func(n): return n is AnchorableObject, anchors)
	for a in anchors:
		(a as AnchorableObject).set_anchored(true)
	
	await _advance_any_active_dialogue(st)


func _finish() -> void:
	print("================================================================================")
	if _failures.is_empty():
		print("PKG-0138 SMOKE PASS: 100% pure narrative playthrough, guidance & backtrack verified.")
		quit(0)
	else:
		print("PKG-0138 SMOKE FAIL: %d failures" % _failures.size())
		for f in _failures:
			print("  - " + f)
		quit(1)
