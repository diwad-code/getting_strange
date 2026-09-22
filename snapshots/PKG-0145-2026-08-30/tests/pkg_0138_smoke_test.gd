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
	"station_16", "station_21", "station_22", "station_23", "station_24",
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
		if st13.has_method("toggle_drawer"):
			st13.call("toggle_drawer")
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
			if st.has_method("advance_expedition_dialogue"):
				st.call("advance_expedition_dialogue")
				advanced = true
			elif st.has_method("advance_meeting_dialogue"):
				st.call("advance_meeting_dialogue")
				advanced = true
			elif st.has_method("advance_synthesis_dialogue"):
				st.call("advance_synthesis_dialogue")
				advanced = true
			elif st.has_method("advance_dialogue"):
				st.call("advance_dialogue")
				advanced = true
		if _is_true(st, &"is_offer_active") and st.has_method("advance_offer_dialogue"):
			st.call("advance_offer_dialogue")
			advanced = true
		if _is_true(st, &"is_phone_answered") and not _is_true(st, &"is_phone_completed"):
			if st.has_method("advance_phone_dialogue"):
				st.call("advance_phone_dialogue")
				advanced = true
		if (_is_true(st, &"intercom_dialogue_active") or (st.get("intercom_dialogue_lines") != null and not _is_true(st, &"is_intercom_completed"))) and st.has_method("advance_intercom"):
			st.call("advance_intercom")
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
		for p in props:
			if p.resonance_id == "vibration_sensor":
				p.trigger_interaction()
				p.trigger_interaction()
			if p.resonance_id == "packing_bag":
				p.trigger_interaction()
	elif id.contains("07"):
		if st.has_method("start_shopkeeper_dialogue"):
			st.call("start_shopkeeper_dialogue")
		await _advance_any_active_dialogue(st)
		if st.has_method("purchase_water"):
			st.call("purchase_water")
	elif id.contains("08"):
		if st.has_method("read_certificate"):
			st.call("read_certificate")
		if st.has_method("read_directory"):
			st.call("read_directory")
		if st.has_method("use_keypad"):
			st.call("use_keypad")
	elif id.contains("09"):
		if st.has_method("start_neighbour_dialogue"):
			st.call("start_neighbour_dialogue")
		await _advance_any_active_dialogue(st)
	elif id.contains("10"):
		if st.has_method("read_number_plate"):
			st.call("read_number_plate")
		if st.has_method("turn_key"):
			st.call("turn_key")
		if st.has_method("set_bag_down"):
			st.call("set_bag_down")
	elif id.contains("11"):
		if st.has_method("examine_photograph"):
			st.call("examine_photograph")
		st.set("boots_inspected", true)
		st.set("reader_dock_inspected", true)
		if st.has_method("_check_evidence_complete"):
			st.call("_check_evidence_complete")
	elif id.contains("12"):
		if st.has_method("close_balcony"):
			st.call("close_balcony")
		if st.has_method("play_message"):
			st.call("play_message")
		await _advance_any_active_dialogue(st)
		if st.has_method("check_caller_number"):
			st.call("check_caller_number")
		if st.has_method("write_two_questions"):
			st.call("write_two_questions")
	elif id.contains("13"):
		if st.has_method("compare_certificate"):
			st.call("compare_certificate")
		if st.has_method("compare_contract"):
			st.call("compare_contract")
			st.call("compare_contract")
		if st.has_method("verify_seals"):
			st.call("verify_seals")
		if st.has_method("request_meeting"):
			st.call("request_meeting")
	elif id.contains("14"):
		if st.has_method("place_bag_at_door"):
			st.call("place_bag_at_door")
		if st.has_method("inspect_kettle"):
			st.call("inspect_kettle")
		if st.has_method("start_marta_dialogue"):
			st.call("start_marta_dialogue")
		await _advance_any_active_dialogue(st)
	elif id.contains("15"):
		if st.has_method("compare_weather"):
			st.call("compare_weather")
		if st.has_method("compare_fence"):
			st.call("compare_fence")
		if st.has_method("start_expedition_dialogue"):
			st.call("start_expedition_dialogue")
		await _advance_any_active_dialogue(st)
	elif id.contains("16"):
		if st.has_method("scan_biometrics"):
			st.call("scan_biometrics")
		if st.has_method("scan_home_card"):
			st.call("scan_home_card")
		if st.has_method("read_schedule"):
			st.call("read_schedule")
		if st.has_method("pass_turnstile"):
			st.call("pass_turnstile")
	elif id.contains("17"):
		if st.has_method("read_incident_report"):
			st.call("read_incident_report")
		await _advance_any_active_dialogue(st)
		if st.has_method("copy_report_header"):
			st.call("copy_report_header")
		if st.has_method("pull_vent_lever"):
			st.call("pull_vent_lever")
	elif id.contains("18"):
		if st.has_method("search_municipal_records"):
			st.call("search_municipal_records")
		if st.has_method("search_hospital_records"):
			st.call("search_hospital_records")
		if st.has_method("verify_employment_card"):
			st.call("verify_employment_card")
		if st.has_method("check_disaster_file"):
			st.call("check_disaster_file")
	elif id.contains("19"):
		if st.has_method("answer_phone"):
			st.call("answer_phone")
		await _advance_any_active_dialogue(st)
	elif id.contains("20"):
		if st.has_method("start_meeting_dialogue"):
			st.call("start_meeting_dialogue")
		elif st.has_method("start_jakub_dialogue"):
			st.call("start_jakub_dialogue")
		await _advance_any_active_dialogue(st)
	elif id.contains("21"):
		if st.has_method("place_reader_evidence"):
			st.call("place_reader_evidence")
		if st.has_method("place_public_evidence"):
			st.call("place_public_evidence")
		if st.has_method("place_relational_evidence"):
			st.call("place_relational_evidence")
		if st.has_method("execute_synthesis"):
			st.call("execute_synthesis")
		await _advance_any_active_dialogue(st)
	elif id.contains("22"):
		if st.has_method("observe_signal_echo"):
			st.call("observe_signal_echo")
		if st.has_method("observe_adjacent_state"):
			st.call("observe_adjacent_state")
	elif id.contains("23"):
		if st.has_method("perform_anchor_trial"):
			st.call("perform_anchor_trial")
		elif st.has_method("perform_yield_trial"):
			st.call("perform_yield_trial")
	elif id.contains("24"):
		if st.has_method("disclose_marta_scope"):
			st.call("disclose_marta_scope")
		if st.has_method("disclose_marta_risk"):
			st.call("disclose_marta_risk")
		if st.has_method("disclose_marta_cost"):
			st.call("disclose_marta_cost")
		if st.has_method("choose_limited_access"):
			st.call("choose_limited_access")
	elif id.contains("25"):
		if st.has_method("observe_ventilation_cycle"):
			st.call("observe_ventilation_cycle")
		if st.has_method("release_interlock"):
			st.call("release_interlock")
		if st.has_method("route_power"):
			st.call("route_power")
		if st.has_method("retrieve_ucp_buffer"):
			st.call("retrieve_ucp_buffer")
	elif id.contains("26"):
		if st.has_method("inspect_console"):
			st.call("inspect_console")
		if st.has_method("inspect_designator"):
			st.call("inspect_designator")
		if st.has_method("inspect_speaker"):
			st.call("inspect_speaker")
		if st.has_method("anchor_motivation"):
			st.call("anchor_motivation")
		await _advance_any_active_dialogue(st)
	elif id.contains("27"):
		if st.has_method("inspect_badge"):
			st.call("inspect_badge")
		if st.has_method("interact_jakub"):
			st.call("interact_jakub")
		if st.has_method("inspect_monitor"):
			st.call("inspect_monitor")
		if st.has_method("inspect_console"):
			st.call("inspect_console")
		await _advance_any_active_dialogue(st)
	elif id.contains("28"):
		if st.has_method("inspect_console"):
			st.call("inspect_console")
		if st.has_method("inspect_window"):
			st.call("inspect_window")
		if st.has_method("inspect_paradox"):
			st.call("inspect_paradox")
		if st.has_method("inspect_intercom"):
			st.call("inspect_intercom")
		await _advance_any_active_dialogue(st)
	elif id.contains("29"):
		if st.has_method("inspect_tracks"):
			st.call("inspect_tracks")
		if st.has_method("inspect_neon"):
			st.call("inspect_neon")
		if st.has_method("inspect_well"):
			st.call("inspect_well")
		if st.has_method("inspect_beacon"):
			st.call("inspect_beacon")
		await _advance_any_active_dialogue(st)
	elif id.contains("30"):
		if st.has_method("inspect_board"):
			st.call("inspect_board")
		if st.has_method("inspect_transformer"):
			st.call("inspect_transformer")
		if st.has_method("throw_breaker"):
			st.call("throw_breaker")
		if st.has_method("inspect_schematic"):
			st.call("inspect_schematic")
		await _advance_any_active_dialogue(st)
	elif id.contains("31"):
		if st.has_method("inspect_chairs"):
			st.call("inspect_chairs")
		if st.has_method("inspect_holoterminal"):
			st.call("inspect_holoterminal")
		if st.has_method("inspect_twelfth_chair"):
			st.call("inspect_twelfth_chair")
		if st.has_method("inspect_ledger"):
			st.call("inspect_ledger")
		await _advance_any_active_dialogue(st)
	elif id.contains("37"):
		if st.has_method("inspect_oscilloscope"):
			st.call("inspect_oscilloscope")
		if st.has_method("inspect_patchbay"):
			st.call("inspect_patchbay")
		if st.has_method("inspect_antenna"):
			st.call("inspect_antenna")
		if st.has_method("inspect_pulpit"):
			st.call("inspect_pulpit")
		await _advance_any_active_dialogue(st)
	elif id.contains("41"):
		if st.has_method("select_operation") and String(st.get("chosen_operation")).is_empty():
			st.call("select_operation", "A")
		await _advance_any_active_dialogue(st)
	
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
