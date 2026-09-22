extends SceneTree

## PKG-0151 final P7 audit gate.
## Proves technical contracts only: sequence resources, guidance ladders,
## clean scene/script cutover, save migration, current-state persistence and
## full 01->43 traversal across all three finale branches by authored player verbs.

const ReturnZone := preload("res://scripts/environment/return_zone.gd")
const CRTDialogueBox := preload("res://scripts/ui/crt_dialogue_box.gd")
const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const AnchorableObject := preload("res://scripts/interactables/anchorable_object.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")

const WALK_SPEED := 120.0
const SEQUENCE_SPECS := [
	{"id": &"sample_and_promise", "resource": "res://resources/gameplay/sample_and_promise_sequence.tres", "stations": [&"station_01", &"station_02", &"station_03"], "entry_gate": &"", "trace_key": &"p7.sample_and_promise.trace"},
	{"id": &"return_under_control", "resource": "res://resources/gameplay/return_under_control_sequence.tres", "stations": [&"station_04", &"station_05"], "entry_gate": &"p7.sample_and_promise.trace", "trace_key": &"p7.return_under_control.trace"},
	{"id": &"address_and_record", "resource": "res://resources/gameplay/address_and_record_sequence.tres", "stations": [&"station_06", &"station_07", &"station_08"], "entry_gate": &"p7.return_under_control.trace", "trace_key": &"p7.address_and_record.trace"},
	{"id": &"foreign_daily_life", "resource": "res://resources/gameplay/foreign_daily_life_sequence.tres", "stations": [&"station_09", &"station_10", &"station_11"], "entry_gate": &"p7.address_and_record.trace", "trace_key": &"p7.foreign_daily_life.trace"},
	{"id": &"marta_threshold", "resource": "res://resources/gameplay/marta_threshold_sequence.tres", "stations": [&"station_12", &"station_13", &"station_14"], "entry_gate": &"p7.foreign_daily_life.trace", "trace_key": &"p7.marta_threshold.trace"},
	{"id": &"work_history_and_record", "resource": "res://resources/gameplay/work_history_and_record_sequence.tres", "stations": [&"station_15", &"station_16", &"station_17"], "entry_gate": &"p7.marta_threshold.trace", "trace_key": &"p7.work_history_and_record.trace"},
	{"id": &"three_place_proofs", "resource": "res://resources/gameplay/three_place_proofs_sequence.tres", "stations": [&"station_18", &"station_19", &"station_20", &"station_21"], "entry_gate": &"p7.work_history_and_record.trace", "trace_key": &"p7.three_place_proofs.trace"},
	{"id": &"mutual_test", "resource": "res://resources/gameplay/mutual_test_sequence.tres", "stations": [&"station_22", &"station_23", &"station_24", &"station_25"], "entry_gate": &"world_recognized", "trace_key": &"p7.mutual_test.ucp_buffer_trace"},
	{"id": &"interrupted_trial_and_small_cost", "resource": "res://resources/gameplay/interrupted_trial_and_small_cost_sequence.tres", "stations": [&"station_26", &"station_27", &"station_28"], "entry_gate": &"p7.three_place_proofs.trace", "trace_key": &"p7.interrupted_trial_and_small_cost.trace"},
	{"id": &"jakub_boundary_and_forecasts", "resource": "res://resources/gameplay/jakub_boundary_and_forecasts_sequence.tres", "stations": [&"station_29", &"station_30"], "entry_gate": &"p7.interrupted_trial_and_small_cost.trace", "trace_key": &"p7.jakub_boundary_and_forecasts.trace"},
	{"id": &"archive_countermodel", "resource": "res://resources/gameplay/archive_countermodel_sequence.tres", "stations": [&"station_31", &"station_32", &"station_33"], "entry_gate": &"p7.jakub_boundary_and_forecasts.trace", "trace_key": &"p7.archive_countermodel.trace"},
	{"id": &"pair_cost_and_echo", "resource": "res://resources/gameplay/pair_cost_and_echo_sequence.tres", "stations": [&"station_34", &"station_35", &"station_36"], "entry_gate": &"p7.archive_countermodel.trace", "trace_key": &"p7.pair_cost_and_echo.trace"},
	{"id": &"consent_and_rescue_boundary", "resource": "res://resources/gameplay/consent_and_rescue_boundary_sequence.tres", "stations": [&"station_37", &"station_38"], "entry_gate": &"p7.pair_cost_and_echo.trace", "trace_key": &"p7.consent_and_rescue_boundary.trace"},
	{"id": &"branch_clarity_and_irreversible_choice", "resource": "res://resources/gameplay/branch_clarity_and_irreversible_choice_sequence.tres", "stations": [&"station_39", &"station_40", &"station_41"], "entry_gate": &"p7.consent_and_rescue_boundary.trace", "trace_key": &"p7.branch_clarity_and_irreversible_choice.trace"},
	{"id": &"conscious_silence_and_presence", "resource": "res://resources/gameplay/conscious_silence_and_presence_sequence.tres", "stations": [&"station_42a", &"station_42b", &"station_42c", &"station_43"], "entry_gate": &"p7.branch_clarity_and_irreversible_choice.trace", "trace_key": &"p7.conscious_silence_and_presence.trace"},
]
const TECHNICAL_SCENE_IDS := [&"station_01", &"station_02", &"station_03", &"station_04", &"station_05", &"station_06", &"station_07", &"station_08", &"station_09", &"station_10", &"station_11", &"station_12", &"station_13", &"station_14", &"station_15", &"station_16", &"station_17", &"station_18", &"station_19", &"station_20", &"station_21", &"station_22", &"station_23", &"station_24", &"station_25", &"station_26", &"station_27", &"station_28", &"station_29", &"station_30", &"station_31", &"station_32", &"station_33", &"station_34", &"station_35", &"station_36", &"station_37", &"station_38", &"station_39", &"station_40", &"station_41", &"station_42a", &"station_42b", &"station_42c", &"station_43"]
const STATION_SCRIPT_PATHS := ["res://scripts/levels/station_01.gd", "res://scripts/levels/station_02.gd", "res://scripts/levels/station_03.gd", "res://scripts/levels/station_04.gd", "res://scripts/levels/station_05.gd", "res://scripts/levels/station_06.gd", "res://scripts/levels/station_07.gd", "res://scripts/levels/station_08.gd", "res://scripts/levels/station_09.gd", "res://scripts/levels/station_10.gd", "res://scripts/levels/station_11.gd", "res://scripts/levels/station_12.gd", "res://scripts/levels/station_13.gd", "res://scripts/levels/station_14.gd", "res://scripts/levels/station_15.gd", "res://scripts/levels/station_16.gd", "res://scripts/levels/station_17.gd", "res://scripts/levels/station_18.gd", "res://scripts/levels/station_19.gd", "res://scripts/levels/station_20.gd", "res://scripts/levels/station_21.gd", "res://scripts/levels/station_22.gd", "res://scripts/levels/station_23.gd", "res://scripts/levels/station_24.gd", "res://scripts/levels/station_25.gd", "res://scripts/levels/station_26.gd", "res://scripts/levels/station_27.gd", "res://scripts/levels/station_28.gd", "res://scripts/levels/station_29.gd", "res://scripts/levels/station_30.gd", "res://scripts/levels/station_31.gd", "res://scripts/levels/station_32.gd", "res://scripts/levels/station_33.gd", "res://scripts/levels/station_34.gd", "res://scripts/levels/station_35.gd", "res://scripts/levels/station_36.gd", "res://scripts/levels/station_37.gd", "res://scripts/levels/station_38.gd", "res://scripts/levels/station_39.gd", "res://scripts/levels/station_40.gd", "res://scripts/levels/station_41.gd", "res://scripts/levels/station_42a.gd", "res://scripts/levels/station_42b.gd", "res://scripts/levels/station_42c.gd", "res://scripts/levels/station_43.gd"]
const FINALE_EXPECTATIONS := {"A": &"station_42a", "B": &"station_42b", "C": &"station_42c"}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0151 FAILURE: " + message)


func _run_tests() -> void:
	print("=== PKG-0151 Smoke Test: Full P7 Audit, 45 scenes, 3 finale branches ===")
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must be available")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	state.reset_campaign(true)
	_test_sequence_resources_and_graph()
	_test_scene_contracts_and_guidance()
	_test_station_scripts_lint()
	_test_selector_routes(state)
	_test_save_migrations_and_roundtrip(state)
	await _run_branch_traversal(state, "A")
	await _run_branch_traversal(state, "B")
	await _run_branch_traversal(state, "C")
	_finish()


func _test_sequence_resources_and_graph() -> void:
	var trace_keys: Dictionary = {}
	var address_seen: Dictionary = {}
	var technical_seen: Dictionary = {}
	for spec in SEQUENCE_SPECS:
		var path := String(spec["resource"])
		_expect(ResourceLoader.exists(path), "Sequence resource missing: %s" % path)
		if not ResourceLoader.exists(path):
			continue
		var sequence := load(path) as Resource
		_expect(sequence != null, "Sequence resource must load: %s" % path)
		if sequence == null:
			continue
		var sequence_id := spec["id"] as StringName
		var expected_stations: Array = spec["stations"]
		var entry_gate: StringName = spec["entry_gate"]
		var trace_key: StringName = spec["trace_key"]
		_expect(sequence.get("sequence_id") == sequence_id, "%s sequence_id mismatch" % String(sequence_id))
		_expect(sequence.get("station_ids") == expected_stations, "%s station_ids mismatch" % String(sequence_id))
		_expect(sequence.get("entry_gate") == entry_gate, "%s entry_gate mismatch" % String(sequence_id))
		_expect(sequence.get("trace_key") == trace_key, "%s trace_key mismatch" % String(sequence_id))
		var migration_revision: Variant = sequence.get("migration_revision")
		var discrepancy: Variant = sequence.get("discrepancy")
		_expect(int(migration_revision) == 1, "%s migration_revision must equal 1" % String(sequence_id))
		_expect(discrepancy is String and not String(discrepancy).is_empty(), "%s discrepancy must be non-empty" % String(sequence_id))
		_expect((sequence.get("hypotheses") as Array).size() >= 2, "%s must define at least 2 hypotheses" % String(sequence_id))
		_expect((sequence.get("commitments") as Array).size() >= 1, "%s must define at least 1 commitment" % String(sequence_id))
		_expect((sequence.get("guidance_beat_ids") as Array).size() >= 1, "%s must define guidance beats" % String(sequence_id))
		_expect((sequence.get("state_keys") as Array).size() >= 1, "%s must define state keys" % String(sequence_id))
		trace_keys[trace_key] = true
		for station_id in expected_stations:
			technical_seen[station_id] = true
			address_seen[_canonical_address(station_id)] = true
	for spec in SEQUENCE_SPECS:
		var entry_gate: StringName = spec["entry_gate"]
		if entry_gate.is_empty():
			continue
		if entry_gate == &"world_recognized":
			continue
		_expect(trace_keys.has(entry_gate), "Entry gate %s must resolve to a declared sequence trace" % String(entry_gate))
	_expect(address_seen.size() == 43, "P7 resources must cover exactly 43 narrative addresses (got %d)" % address_seen.size())
	_expect(technical_seen.size() == 45, "P7 resources must cover exactly 45 technical scenes (got %d)" % technical_seen.size())
	_expect(trace_keys.has(&"p7.mutual_test.ucp_buffer_trace"), "S08 special trace key must stay explicit")
	_expect(trace_keys.has(&"p7.three_place_proofs.trace"), "S07 trace must stay available for S09 gate")


func _test_scene_contracts_and_guidance() -> void:
	var sequence_tiers: Dictionary = {}
	var sequence_has_l2_hypothesis: Dictionary = {}
	var sequence_has_l3_check: Dictionary = {}
	for spec in SEQUENCE_SPECS:
		sequence_tiers[spec["id"]] = {}
		sequence_has_l2_hypothesis[spec["id"]] = false
		sequence_has_l3_check[spec["id"]] = false
	for station_id in TECHNICAL_SCENE_IDS:
		var path := _scene_path(station_id)
		_expect(ResourceLoader.exists(path), "Scene missing: %s" % path)
		if not ResourceLoader.exists(path):
			continue
		var packed := load(path) as PackedScene
		_expect(packed != null, "Scene must load: %s" % path)
		if packed == null:
			continue
		var node := packed.instantiate() as Node2D
		_expect(node != null, "Scene root must instantiate as Node2D: %s" % path)
		if node == null:
			continue
		_expect(node.has_node("WorldPixelCompositor"), "%s missing WorldPixelCompositor" % path)
		_expect(node.has_node("CrispDiegeticText"), "%s missing CrispDiegeticText" % path)
		_expect(node.has_node("InnerThoughtSurface"), "%s missing InnerThoughtSurface" % path)
		_expect(node.has_node("CRTDialogueBox"), "%s missing CRTDialogueBox" % path)
		_expect(node.has_node("NarrativeGuidanceService"), "%s missing NarrativeGuidanceService" % path)
		_expect(node.has_node("Geometry"), "%s missing Geometry" % path)
		_expect(node.has_node("Props"), "%s missing Props" % path)
		_expect(node.has_node("Player"), "%s missing Player" % path)
		_expect(node.has_node("AirlockZone"), "%s missing AirlockZone" % path)
		if station_id != &"station_01":
			_expect(node.has_node("ReturnZone"), "%s missing ReturnZone" % path)
		var guidance := node.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
		_expect(guidance != null, "%s guidance node must be NarrativeGuidanceService" % path)
		if guidance != null:
			_expect(guidance.active_beats.size() >= 1, "%s guidance must register beats at _ready" % path)
			var sequence_id := _sequence_for_station(station_id)
			var tiers: Dictionary = sequence_tiers.get(sequence_id, {})
			for beat_id in guidance.active_beats:
				var beat := guidance.active_beats[beat_id] as GuidanceBeat
				if beat == null:
					continue
				tiers[beat.tier] = true
				if beat.tier == GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT and not beat.hypothesis_id.is_empty() and not beat.predicted_check.is_empty():
					sequence_has_l2_hypothesis[sequence_id] = true
				if beat.tier == GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT and not beat.predicted_check.is_empty():
					sequence_has_l3_check[sequence_id] = true
			sequence_tiers[sequence_id] = tiers
		node.free()
	for spec in SEQUENCE_SPECS:
		var sequence_id := spec["id"] as StringName
		var tiers: Dictionary = sequence_tiers.get(sequence_id, {})
		for tier in [GuidanceBeat.Tier.L0_COMPOSITION, GuidanceBeat.Tier.L1_REACTION, GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, GuidanceBeat.Tier.L4_RESCUE_HINT]:
			_expect(tiers.has(tier), "%s must expose complete L0-L4 guidance ladder across its stations" % String(sequence_id))
		_expect(bool(sequence_has_l2_hypothesis.get(sequence_id, false)), "%s must expose at least one L2 hypothesis with predicted_check" % String(sequence_id))
		_expect(bool(sequence_has_l3_check.get(sequence_id, false)), "%s must expose at least one L3 predicted_check" % String(sequence_id))


func _test_station_scripts_lint() -> void:
	for path in STATION_SCRIPT_PATHS:
		_expect(FileAccess.file_exists(path), "Station script missing: %s" % path)
		if not FileAccess.file_exists(path):
			continue
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Station script must open: %s" % path)
		if file == null:
			continue
		var content := file.get_as_text()
		file.close()
		_expect(content.contains("## PRZESZKODA — dlaczego to tu jest:"), "%s missing obstacle header 1" % path)
		_expect(content.contains("## PRZESZKODA — czego wymaga od Leny:"), "%s missing obstacle header 2" % path)
		_expect(content.contains("## PRZESZKODA — koszt porażki:"), "%s missing obstacle header 3" % path)
		_expect(not content.contains("set_campaign_flag"), "%s still references set_campaign_flag" % path)
		_expect(not content.contains("_check_unlock"), "%s still references _check_unlock" % path)
		_expect(not content.contains("APPARENT_COOPERATION"), "%s still references APPARENT_COOPERATION" % path)
		_expect(not content.contains("draw_string("), "%s still draws text in Layer 0" % path)
		for line in content.split("\n"):
			if line.begins_with("## PRZESZKODA —"):
				_expect(not line.to_lower().contains("gracz"), "%s obstacle header cannot use 'gracz': %s" % [path, line])


func _test_selector_routes(state: Node) -> void:
	state.reset_campaign(true)
	for branch in ["A", "B", "C"]:
		var finale_id: StringName = FINALE_EXPECTATIONS[branch]
		state.select_finale_operation(branch)
		_expect(state.get_selected_finale_id() == finale_id, "Finale selection %s must resolve to %s" % [branch, String(finale_id)])
		var selectable: Array = state.get_selectable_stations(true)
		_expect(selectable.size() == 43, "Selectable route with branch %s must expose 43 narrative addresses" % branch)
		_expect(selectable[41] == finale_id, "Selectable route index 41 must swap in %s for branch %s" % [String(finale_id), branch])
		_expect(selectable[42] == &"station_43", "Selectable route must always end at station_43")


func _test_save_migrations_and_roundtrip(state: Node) -> void:
	# S08 special migration path.
	state.reset_campaign(true)
	state.record_decision(&"home_sample_preserved", true)
	state.decisions[&"s24_disposition"] = true
	state.decisions[&"p7.mutual_test.ucp_buffer_trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_24", Vector2(410.0, 240.0))
	state.set_reduced_motion(true, false)
	_expect(state.save_campaign(), "S08 legacy checkpoint must save")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "S08 legacy checkpoint must reload")
	_expect(state.last_checkpoint_station == &"station_22" and state.last_checkpoint_position == Vector2(60.0, 296.0), "S08 checkpoint must normalize to station_22")
	_expect(not state.decisions.has(&"s24_disposition"), "S08 legacy key must be removed")
	_expect(state.decisions.get(&"home_sample_preserved", false) == true, "S08 migration must preserve canonical facts")
	_expect(state.is_reduced_motion(), "S08 migration must preserve reduced-motion setting")

	# Early P7 migration.
	state.reset_campaign(true)
	state.record_decision(&"home_sample_preserved", true)
	state.decisions[&"station_14_mug_broken"] = true
	state.decisions[&"p7.marta_threshold.trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_13", Vector2(330.0, 240.0))
	_expect(state.save_campaign(), "Early P7 checkpoint must save")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Early P7 checkpoint must reload")
	_expect(state.last_checkpoint_station == &"station_12" and state.last_checkpoint_position == Vector2(70.0, 296.0), "Early P7 checkpoint must normalize to station_12")
	_expect(not state.decisions.has(&"station_14_mug_broken"), "Early P7 legacy key must be removed")
	_expect(state.decisions.get(&"home_sample_preserved", false) == true, "Early P7 migration must preserve canonical facts")

	# Mid P7 migration.
	state.reset_campaign(true)
	state.record_decision(&"local_lena_intent_found", true)
	state.decisions[&"s35_home_echo_verified"] = true
	state.decisions[&"p7.pair_cost_and_echo.trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_35", Vector2(430.0, 240.0))
	_expect(state.save_campaign(), "Mid P7 checkpoint must save")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Mid P7 checkpoint must reload")
	_expect(state.last_checkpoint_station == &"station_34" and state.last_checkpoint_position == Vector2(50.0, 240.0), "Mid P7 checkpoint must normalize to station_34")
	_expect(not state.decisions.has(&"s35_home_echo_verified"), "Mid P7 legacy key must be removed")
	_expect(state.decisions.get(&"local_lena_intent_found", false) == true, "Mid P7 migration must preserve canonical facts")

	# Late P7 migration.
	state.reset_campaign(true)
	state.record_decision(&"home_echo_verified", true)
	state.decisions[&"s41_operation_committed"] = true
	state.decisions[&"p7.branch_clarity_and_irreversible_choice.trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_40", Vector2(300.0, 240.0))
	_expect(state.save_campaign(), "Late P7 checkpoint must save")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Late P7 checkpoint must reload")
	_expect(state.last_checkpoint_station == &"station_39" and state.last_checkpoint_position == Vector2(65.0, 248.0), "Late P7 checkpoint must normalize to station_39")
	_expect(not state.decisions.has(&"s41_operation_committed"), "Late P7 legacy key must be removed")
	_expect(state.decisions.get(&"home_echo_verified", false) == true, "Late P7 migration must preserve canonical facts")

	# Current-state roundtrip must keep canonical late-game facts.
	state.reset_campaign(true)
	state.record_decision(&"p7.sample_and_promise.trace", "sample_preserved_and_time_sent")
	state.record_decision(&"home_sample_preserved", true)
	state.record_decision(&"world_recognized", true)
	state.record_decision(&"p7.archive_countermodel.trace", "local_lena_intent_found")
	state.record_decision(&"local_lena_intent_found", true)
	state.record_decision(&"p7.pair_cost_and_echo.trace", "cost_ledger_revealed")
	state.record_decision(&"home_echo_verified", true)
	state.record_decision(&"jakub_consent_state", "limited")
	state.record_decision(&"marta_truth_state", "full")
	state.record_decision(&"final_branch_chosen", "branch_b")
	state.record_decision(&"epilogue_witness_completed", true)
	state.record_decision(&"p7.conscious_silence_and_presence.trace", "conscious_silence_and_presence_witnessed")
	state.set_checkpoint(&"station_43", Vector2(320.0, 240.0))
	_expect(state.save_campaign(), "Current-state roundtrip must save")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Current-state roundtrip must reload")
	_expect(state.decisions.get(&"home_sample_preserved", false) == true, "home_sample_preserved must survive current-state reload")
	_expect(state.decisions.get(&"world_recognized", false) == true, "world_recognized must survive current-state reload")
	_expect(state.decisions.get(&"local_lena_intent_found", false) == true, "local_lena_intent_found must survive current-state reload")
	_expect(state.decisions.get(&"home_echo_verified", false) == true, "home_echo_verified must survive current-state reload")
	_expect(String(state.decisions.get(&"jakub_consent_state", "")) == "limited", "jakub_consent_state must survive current-state reload")
	_expect(String(state.decisions.get(&"marta_truth_state", "")) == "full", "marta_truth_state must survive current-state reload")
	_expect(String(state.decisions.get(&"final_branch_chosen", "")) == "branch_b", "final_branch_chosen must survive current-state reload")
	_expect(state.decisions.get(&"epilogue_witness_completed", false) == true, "epilogue_witness_completed must survive current-state reload")
	_expect(String(state.decisions.get(&"p7.conscious_silence_and_presence.trace", "")) == "conscious_silence_and_presence_witnessed", "S15 trace must survive current-state reload")


func _run_branch_traversal(state: Node, branch: String) -> void:
	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = false
	var expected_finale: StringName = FINALE_EXPECTATIONS[branch]
	for station_id in _branch_route(branch):
		var station := await _open_station(station_id)
		if station == null:
			continue
		var completed: Array = []
		if station.has_signal(&"level_completed"):
			station.connect(&"level_completed", func(): completed.append(true))
		var player := station.get_node_or_null("Player") as PrototypePlayer
		var airlock := _find(station, func(n): return String(n.name) == "AirlockZone") as Area2D
		_expect(player != null, "%s must expose Player for traversal" % String(station_id))
		_expect(airlock != null, "%s must expose AirlockZone for traversal" % String(station_id))
		if player != null:
			player.set_physics_process(false)
			await _activate_station_props(station, player)
			await _perform_station_actions(station, player, branch)
			await _advance_any_active_dialogue(station)
			if airlock != null:
				await _walk_to(player, airlock.global_position.x, 320)
				player.set_physics_process(true)
				for _i in 8:
					await physics_frame
		_expect(not completed.is_empty(), "%s must complete via authored player verbs" % String(station_id))
		if station_id == &"station_41":
			_expect(String(state.decisions.get(&"final_branch_chosen", "")) == "branch_%s" % branch.to_lower(), "station_41 must record final_branch_chosen for branch %s" % branch)
			_expect(state.get_selected_finale_id() == expected_finale, "station_41 must route GameStateManager to %s" % String(expected_finale))
		if station_id == expected_finale:
			_expect(state.get_selected_finale_id() == expected_finale, "%s traversal must preserve selected finale" % String(expected_finale))
		if station_id == &"station_43":
			_expect(state.decisions.get(&"epilogue_witness_completed", false) == true, "station_43 must record canonical epilogue completion")
		await _close_station(station)


func _open_station(station_id: StringName) -> Node2D:
	var packed := load(_scene_path(station_id)) as PackedScene
	_expect(packed != null, "%s scene must load" % String(station_id))
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	_expect(station != null, "%s scene must instantiate as Node2D" % String(station_id))
	if station == null:
		return null
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close_station(station: Node) -> void:
	if station == null:
		return
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame


func _call_bool(station: Node, method_name: StringName, message: String, args: Array = []) -> bool:
	if station == null or not station.has_method(method_name):
		_expect(false, message)
		return false
	var result: Variant = station.callv(method_name, args)
	return result is bool and result


func _call_void(station: Node, method_name: StringName, message: String, args: Array = []) -> void:
	if station == null or not station.has_method(method_name):
		_expect(false, message)
		return
	station.callv(method_name, args)


func _call_void_with_float(station: Node, method_name: StringName, value: float, message: String) -> void:
	if station == null or not station.has_method(method_name):
		_expect(false, message)
		return
	station.call(method_name, value)


func _activate_station_props(station: Node2D, player: CharacterBody2D) -> void:
	var props: Array = []
	_collect(station, func(node): return node is MemoryResonancePoint, props)
	props.sort_custom(func(a, b): return (a as Node2D).global_position.x < (b as Node2D).global_position.x)
	for p in props:
		var prop := p as MemoryResonancePoint
		if player != null:
			await _walk_to(player, prop.global_position.x, 180)
		prop.is_player_in_range = true
		prop.trigger_interaction()
		await process_frame
		await physics_frame
		await _advance_any_active_dialogue(station)
		if not prop.is_activated:
			prop.trigger_interaction()
			await process_frame
			await physics_frame
			await _advance_any_active_dialogue(station)


func _perform_station_actions(station: Node2D, player: CharacterBody2D, branch: String) -> void:
	var station_id := _station_id_from_node(station)
	match station_id:
		&"station_01":
			_call_bool(station, &"observe_measurement_gap", "station_01 missing observe_measurement_gap")
			_call_bool(station, &"inspect_sensor_mount", "station_01 missing inspect_sensor_mount")
			_call_bool(station, &"record_raw_measurement", "station_01 missing record_raw_measurement")
			_call_bool(station, &"repeat_measurement", "station_01 missing repeat_measurement")
			_call_bool(station, &"preserve_raw_sample", "station_01 missing preserve_raw_sample")
		&"station_02":
			_call_bool(station, &"observe_service_detour", "station_02 missing observe_service_detour")
			_call_bool(station, &"compare_route_duration", "station_02 missing compare_route_duration")
			_call_bool(station, &"take_safe_bypass", "station_02 missing take_safe_bypass")
		&"station_03":
			_call_bool(station, &"observe_departure_time", "station_03 missing observe_departure_time")
			_call_bool(station, &"send_measurement_time_notice", "station_03 missing send_measurement_time_notice")
		&"station_04":
			_call_bool(station, &"observe_reader_repeat", "station_04 missing observe_reader_repeat")
			_call_bool(station, &"observe_wagon_clock", "station_04 missing observe_wagon_clock")
			_call_bool(station, &"repeat_reader_without_route_change", "station_04 missing repeat_reader_without_route_change")
		&"station_05":
			_call_bool(station, &"observe_ordinary_street", "station_05 missing observe_ordinary_street")
			_call_bool(station, &"secure_reader_state", "station_05 missing secure_reader_state")
		&"station_06":
			_call_bool(station, &"observe_paper_timetable", "station_06 missing observe_paper_timetable")
			_call_bool(station, &"observe_offline_route", "station_06 missing observe_offline_route")
			_call_bool(station, &"compare_public_route", "station_06 missing compare_public_route")
		&"station_07":
			_call_bool(station, &"ask_shopkeeper_recent_visit", "station_07 missing ask_shopkeeper_recent_visit")
			_call_bool(station, &"inspect_sale_ledger", "station_07 missing inspect_sale_ledger")
			_call_bool(station, &"commit_ordinary_explanation", "station_07 missing commit_ordinary_explanation")
		&"station_08":
			_call_bool(station, &"read_certificate", "station_08 missing read_certificate")
			_call_bool(station, &"read_directory", "station_08 missing read_directory")
			_call_bool(station, &"test_intercom_recognition", "station_08 missing test_intercom_recognition")
		&"station_09":
			_call_bool(station, &"observe_floor_record", "station_09 missing observe_floor_record")
			for _i in 80:
				_call_void_with_float(station, &"push_planter", 1.0, "station_09 missing push_planter")
				await physics_frame
			_call_bool(station, &"ask_neighbour_without_leading", "station_09 missing ask_neighbour_without_leading")
		&"station_10":
			_call_bool(station, &"inspect_key_wear", "station_10 missing inspect_key_wear")
			_call_bool(station, &"test_key_without_claiming_home", "station_10 missing test_key_without_claiming_home")
			_call_bool(station, &"commit_cautious_entry", "station_10 missing commit_cautious_entry")
		&"station_11":
			for _i in 100:
				_call_void_with_float(station, &"push_sideboard", 1.0, "station_11 missing push_sideboard")
				await physics_frame
			_call_bool(station, &"inspect_private_photograph", "station_11 missing inspect_private_photograph")
			_call_bool(station, &"inspect_equipment_wear", "station_11 missing inspect_equipment_wear")
			_call_bool(station, &"inspect_reader_arrangement", "station_11 missing inspect_reader_arrangement")
			_call_bool(station, &"compare_private_material", "station_11 missing compare_private_material")
			_call_bool(station, &"respect_private_material", "station_11 missing respect_private_material")
		&"station_12":
			_call_bool(station, &"close_balcony", "station_12 missing close_balcony")
			_call_bool(station, &"listen_to_message", "station_12 missing listen_to_message")
			_call_bool(station, &"verify_caller_identity", "station_12 missing verify_caller_identity")
			_call_bool(station, &"prepare_independent_questions", "station_12 missing prepare_independent_questions")
		&"station_13":
			_call_bool(station, &"observe_field_certificate", "station_13 missing observe_field_certificate")
			_call_bool(station, &"open_drawer", "station_13 missing open_drawer")
			_call_bool(station, &"observe_tenancy_contract", "station_13 missing observe_tenancy_contract")
			_call_bool(station, &"verify_document_independence", "station_13 missing verify_document_independence")
			_call_bool(station, &"compare_document_versions", "station_13 missing compare_document_versions")
			_call_bool(station, &"request_independent_description", "station_13 missing request_independent_description")
		&"station_14":
			_call_bool(station, &"place_bag_at_door", "station_14 missing place_bag_at_door")
			_call_bool(station, &"disclose_arrival_time", "station_14 missing disclose_arrival_time")
			_call_bool(station, &"compare_field_equipment", "station_14 missing compare_field_equipment")
			_call_bool(station, &"verify_key_position", "station_14 missing verify_key_position")
			_call_bool(station, &"ask_independent_day_description", "station_14 missing ask_independent_day_description")
			_call_bool(station, &"respect_marta_threshold", "station_14 missing respect_marta_threshold")
		&"station_15":
			_call_bool(station, &"observe_expedition_notes", "station_15 missing observe_expedition_notes")
			_call_bool(station, &"compare_rain_detail", "station_15 missing compare_rain_detail")
			_call_bool(station, &"compare_fence_detail", "station_15 missing compare_fence_detail")
			_call_bool(station, &"observe_secured_phone", "station_15 missing observe_secured_phone")
			_call_bool(station, &"request_own_work_record", "station_15 missing request_own_work_record")
		&"station_16":
			_call_bool(station, &"scan_biometric_profile", "station_16 missing scan_biometric_profile")
			_call_bool(station, &"compare_card_number", "station_16 missing compare_card_number")
			_call_bool(station, &"read_activity_history", "station_16 missing read_activity_history")
			_call_bool(station, &"compare_field_biometrics_and_audit", "station_16 missing compare_field_biometrics_and_audit")
			_call_bool(station, &"read_roster_signature", "station_16 missing read_roster_signature")
		&"station_17":
			_call_bool(station, &"read_incident_report", "station_17 missing read_incident_report")
			_call_bool(station, &"compare_signature_with_card", "station_17 missing compare_signature_with_card")
			_call_bool(station, &"listen_intercom_warning", "station_17 missing listen_intercom_warning")
			_call_bool(station, &"release_service_route", "station_17 missing release_service_route")
			_call_bool(station, &"copy_report_header", "station_17 missing copy_report_header")
		&"station_18":
			_call_bool(station, &"search_municipal_death_registry", "station_18 missing search_municipal_death_registry")
			_call_bool(station, &"search_hospital_registry", "station_18 missing search_hospital_registry")
			_call_bool(station, &"verify_employment_card", "station_18 missing verify_employment_card")
			_call_bool(station, &"read_disaster_case_file", "station_18 missing read_disaster_case_file")
			_call_bool(station, &"compare_independent_registries", "station_18 missing compare_independent_registries")
		&"station_19":
			_call_bool(station, &"shield_microphone", "station_19 missing shield_microphone")
			_call_bool(station, &"prepare_control_questions", "station_19 missing prepare_control_questions")
			_call_bool(station, &"answer_payphone", "station_19 missing answer_payphone")
			_call_bool(station, &"ask_control_questions", "station_19 missing ask_control_questions")
			_call_bool(station, &"compare_control_answers", "station_19 missing compare_control_answers")
		&"station_20":
			_call_bool(station, &"move_parts_trolley", "station_20 missing move_parts_trolley")
			_call_bool(station, &"confirm_marta_presence", "station_20 missing confirm_marta_presence")
			_call_bool(station, &"meet_jakub_face_to_face", "station_20 missing meet_jakub_face_to_face")
			_call_bool(station, &"accept_scar_refusal", "station_20 missing accept_scar_refusal")
			_call_bool(station, &"request_voluntary_reader_scan", "station_20 missing request_voluntary_reader_scan")
			_call_bool(station, &"compare_local_service_base", "station_20 missing compare_local_service_base")
		&"station_21":
			_call_bool(station, &"place_reader_and_sample", "station_21 missing place_reader_and_sample")
			_call_bool(station, &"place_public_records", "station_21 missing place_public_records")
			_call_bool(station, &"place_relational_record", "station_21 missing place_relational_record")
			_call_bool(station, &"execute_three_family_synthesis", "station_21 missing execute_three_family_synthesis")
		&"station_22":
			_call_bool(station, &"observe_signal_echo", "station_22 missing observe_signal_echo")
			_call_bool(station, &"observe_adjacent_state", "station_22 missing observe_adjacent_state")
		&"station_23":
			_call_bool(station, &"perform_anchor_trial", "station_23 missing perform_anchor_trial")
		&"station_24":
			_call_void(station, &"disclose_marta_scope", "station_24 missing disclose_marta_scope")
			_call_void(station, &"disclose_marta_risk", "station_24 missing disclose_marta_risk")
			_call_void(station, &"disclose_marta_cost", "station_24 missing disclose_marta_cost")
			_call_bool(station, &"choose_limited_access", "station_24 missing choose_limited_access")
		&"station_25":
			_call_void(station, &"observe_ventilation_cycle", "station_25 missing observe_ventilation_cycle")
			_call_void(station, &"release_interlock", "station_25 missing release_interlock")
			_call_void(station, &"route_power", "station_25 missing route_power")
			_call_bool(station, &"retrieve_ucp_buffer", "station_25 missing retrieve_ucp_buffer")
		&"station_26":
			_call_bool(station, &"observe_interrupted_ucp_log", "station_26 missing observe_interrupted_ucp_log")
			_call_bool(station, &"synchronize_sample_clock", "station_26 missing synchronize_sample_clock")
			_call_bool(station, &"synchronize_ucp_command_clock", "station_26 missing synchronize_ucp_command_clock")
			_call_bool(station, &"synchronize_local_generator_clock", "station_26 missing synchronize_local_generator_clock")
			_call_bool(station, &"reconstruct_ucp_intervention", "station_26 missing reconstruct_ucp_intervention")
		&"station_27":
			_call_bool(station, &"calibrate_pulse_reference", "station_27 missing calibrate_pulse_reference")
			_call_bool(station, &"send_first_identical_pulse", "station_27 missing send_first_identical_pulse")
			_call_bool(station, &"send_second_identical_pulse", "station_27 missing send_second_identical_pulse")
			_call_bool(station, &"send_deliberate_error_pulse", "station_27 missing send_deliberate_error_pulse")
			_call_bool(station, &"compare_response_correction", "station_27 missing compare_response_correction")
		&"station_28":
			_call_bool(station, &"observe_transfer_constraint", "station_28 missing observe_transfer_constraint")
			_call_bool(station, &"inspect_home_sample_trace", "station_28 missing inspect_home_sample_trace")
			_call_bool(station, &"inspect_local_lena_signal_trace", "station_28 missing inspect_local_lena_signal_trace")
			_call_bool(station, &"disclose_transfer_price", "station_28 missing disclose_transfer_price")
			_call_bool(station, &"perform_shared_drift_yield", "station_28 missing perform_shared_drift_yield")
		&"station_29":
			_call_bool(station, &"inspect_ucp_jakub_contrast_proposal", "station_29 missing inspect_ucp_jakub_contrast_proposal")
			_call_bool(station, &"observe_jakub_ordinary_life_scope", "station_29 missing observe_jakub_ordinary_life_scope")
			_call_bool(station, &"disclose_jakub_signal_risk", "station_29 missing disclose_jakub_signal_risk")
			_call_bool(station, &"disable_jakub_transmitter", "station_29 missing disable_jakub_transmitter")
			_call_bool(station, &"record_jakub_consent", "station_29 missing record_jakub_consent", [&"limited"])
		&"station_30":
			_call_bool(station, &"build_force_home_forecast", "station_30 missing build_force_home_forecast")
			_call_bool(station, &"build_close_equal_recover_local_forecast", "station_30 missing build_close_equal_recover_local_forecast")
			_call_bool(station, &"build_mutual_passage_forecast", "station_30 missing build_mutual_passage_forecast")
			_call_bool(station, &"compare_forecast_consent_dependencies", "station_30 missing compare_forecast_consent_dependencies")
		&"station_31":
			_call_bool(station, &"inspect_passenger_chairs", "station_31 missing inspect_passenger_chairs")
			_call_bool(station, &"inspect_wierzbicka_proposal", "station_31 missing inspect_wierzbicka_proposal")
			_call_bool(station, &"inspect_twelfth_chair", "station_31 missing inspect_twelfth_chair")
			_call_bool(station, &"compare_passenger_ledger", "station_31 missing compare_passenger_ledger")
			_call_bool(station, &"reject_adaptation_offer", "station_31 missing reject_adaptation_offer")
		&"station_32":
			_call_bool(station, &"inspect_steamed_pane", "station_32 missing inspect_steamed_pane")
			_call_bool(station, &"inspect_cracked_pane", "station_32 missing inspect_cracked_pane")
			_call_bool(station, &"etch_condensation_trace", "station_32 missing etch_condensation_trace")
			_call_bool(station, &"inspect_polished_pane", "station_32 missing inspect_polished_pane")
			_call_bool(station, &"anchor_material_memory", "station_32 missing anchor_material_memory")
		&"station_33":
			_call_bool(station, &"inspect_ladder_infrastructure", "station_33 missing inspect_ladder_infrastructure")
			_call_bool(station, &"inspect_depth_gauge", "station_33 missing inspect_depth_gauge")
			_call_bool(station, &"inspect_cable_trunk_note", "station_33 missing inspect_cable_trunk_note")
			_call_bool(station, &"inspect_shaft_work_light", "station_33 missing inspect_shaft_work_light")
			_call_bool(station, &"reconstruct_local_lena_intent", "station_33 missing reconstruct_local_lena_intent")
		&"station_34":
			_call_bool(station, &"inspect_correlation_reactor", "station_34 missing inspect_correlation_reactor")
			_call_bool(station, &"inspect_allocation_desk", "station_34 missing inspect_allocation_desk")
			_call_bool(station, &"inspect_thermal_indicators", "station_34 missing inspect_thermal_indicators")
			_call_bool(station, &"inspect_diagnostic_probe", "station_34 missing inspect_diagnostic_probe")
			_call_bool(station, &"unlock_pair_registry", "station_34 missing unlock_pair_registry")
		&"station_35":
			_call_bool(station, &"inspect_cooling_pool", "station_35 missing inspect_cooling_pool")
			_call_bool(station, &"inspect_drain_valve", "station_35 missing inspect_drain_valve")
			_call_bool(station, &"inspect_chemical_sampler", "station_35 missing inspect_chemical_sampler")
			_call_bool(station, &"process_home_echo", "station_35 missing process_home_echo")
		&"station_36":
			_call_bool(station, &"inspect_drain_weir", "station_36 missing inspect_drain_weir")
			_call_bool(station, &"measure_drain_current", "station_36 missing measure_drain_current")
			_call_bool(station, &"inspect_service_ladder", "station_36 missing inspect_service_ladder")
			_call_bool(station, &"sample_contamination_tap", "station_36 missing sample_contamination_tap")
			_call_bool(station, &"reveal_ucp_cost_ledger", "station_36 missing reveal_ucp_cost_ledger")
		&"station_37":
			_call_bool(station, &"inspect_frequency_oscilloscope", "station_37 missing inspect_frequency_oscilloscope")
			_call_bool(station, &"inspect_transmission_patchbay", "station_37 missing inspect_transmission_patchbay")
			_call_bool(station, &"inspect_transmitting_antenna", "station_37 missing inspect_transmitting_antenna")
			_call_bool(station, &"inspect_mixing_pulpit", "station_37 missing inspect_mixing_pulpit")
			_call_bool(station, &"bridge_living_signal", "station_37 missing bridge_living_signal")
		&"station_38":
			_call_bool(station, &"inspect_radio_receiver", "station_38 missing inspect_radio_receiver")
			_call_bool(station, &"inspect_local_procedure_record", "station_38 missing inspect_local_procedure_record")
			_call_bool(station, &"inspect_jakub_switchboard", "station_38 missing inspect_jakub_switchboard")
			_call_bool(station, &"anchor_rescue_tether", "station_38 missing anchor_rescue_tether")
			_call_bool(station, &"disclose_marta_truth", "station_38 missing disclose_marta_truth", [&"full"])
		&"station_39":
			_call_bool(station, &"inspect_config_a", "station_39 missing inspect_config_a")
			_call_bool(station, &"inspect_config_b", "station_39 missing inspect_config_b")
			_call_bool(station, &"inspect_reference_core", "station_39 missing inspect_reference_core")
			_call_bool(station, &"inspect_config_c", "station_39 missing inspect_config_c")
			_call_bool(station, &"review_method_matrix", "station_39 missing review_method_matrix")
		&"station_40":
			_call_bool(station, &"inspect_terminal", "station_40 missing inspect_terminal")
			_call_bool(station, &"inspect_cost_matrix", "station_40 missing inspect_cost_matrix")
			_call_bool(station, &"inspect_marta", "station_40 missing inspect_marta")
			_call_bool(station, &"inspect_szymon", "station_40 missing inspect_szymon")
			_call_bool(station, &"confront_negotiation_costs", "station_40 missing confront_negotiation_costs")
		&"station_41":
			_call_bool(station, &"inspect_topography", "station_41 missing inspect_topography")
			match branch:
				"A":
					_call_bool(station, &"select_operation_a", "station_41 missing select_operation_a")
				"B":
					_call_bool(station, &"select_operation_b", "station_41 missing select_operation_b")
				_:
					_call_bool(station, &"select_operation_c", "station_41 missing select_operation_c")
		&"station_42a":
			_call_bool(station, &"inspect_cups", "station_42a missing inspect_cups")
			_call_bool(station, &"witness_chamber_a", "station_42a missing witness_chamber_a")
		&"station_42b":
			_call_bool(station, &"inspect_doorstep", "station_42b missing inspect_doorstep")
			_call_bool(station, &"witness_chamber_b", "station_42b missing witness_chamber_b")
		&"station_42c":
			_call_bool(station, &"inspect_tram", "station_42c missing inspect_tram")
			_call_bool(station, &"witness_chamber_c", "station_42c missing witness_chamber_c")
		&"station_43":
			_call_bool(station, &"inspect_notice", "station_43 missing inspect_notice")
			_call_bool(station, &"inspect_credits", "station_43 missing inspect_credits")
			_call_bool(station, &"inspect_blackout", "station_43 missing inspect_blackout")
	var anchors: Array = []
	_collect(station, func(node): return node is AnchorableObject, anchors)
	for anchor in anchors:
		(anchor as AnchorableObject).set_anchored(true)
	await _advance_any_active_dialogue(station)


func _branch_route(branch: String) -> Array:
	var route: Array = []
	for index in range(1, 42):
		route.append(StringName("station_%02d" % index))
	route.append(FINALE_EXPECTATIONS[branch])
	route.append(&"station_43")
	return route


func _station_id_from_node(node: Node) -> StringName:
	var script_path := String(node.get_script().resource_path).get_file().get_basename()
	return StringName(script_path)


func _sequence_for_station(station_id: StringName) -> StringName:
	for spec in SEQUENCE_SPECS:
		var stations: Array = spec["stations"]
		if stations.has(station_id):
			return spec["id"]
	return &""


func _canonical_address(station_id: StringName) -> StringName:
	var text := String(station_id)
	if text.begins_with("station_42"):
		return &"station_42"
	return station_id


func _scene_path(station_id: StringName) -> String:
	return "res://scenes/levels/%s.tscn" % String(station_id)


func _find(node: Node, predicate: Callable) -> Node:
	if predicate.call(node):
		return node
	for child in node.get_children():
		var found := _find(child, predicate)
		if found != null:
			return found
	return null


func _collect(node: Node, predicate: Callable, out: Array) -> void:
	if predicate.call(node):
		out.append(node)
	for child in node.get_children():
		_collect(child, predicate, out)


func _is_true(node: Object, property_name: StringName) -> bool:
	if node == null:
		return false
	var value: Variant = node.get(property_name)
	return value != null and bool(value)


func _walk_to(player: CharacterBody2D, target_x: float, max_frames: int = 400) -> void:
	for _i in max_frames:
		var dx := target_x - player.global_position.x
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


func _advance_any_active_dialogue(station: Node2D) -> void:
	var dialogue := _find(station, func(node): return node is CRTDialogueBox) as CRTDialogueBox
	for _i in 80:
		var advanced := false
		if dialogue != null and dialogue.is_presenting():
			dialogue.advance_dialogue()
			advanced = true
		if _is_true(station, &"dialogue_active") and station.has_method("advance_dialogue"):
			station.call("advance_dialogue")
			advanced = true
		if _is_true(station, &"shopkeeper_dialogue_active") and station.has_method("advance_shopkeeper_dialogue"):
			station.call("advance_shopkeeper_dialogue")
			advanced = true
		if _is_true(station, &"neighbour_dialogue_active") and station.has_method("advance_neighbour_dialogue"):
			station.call("advance_neighbour_dialogue")
			advanced = true
		if _is_true(station, &"message_active") and station.has_method("advance_message"):
			station.call("advance_message")
			advanced = true
		if _is_true(station, &"is_marta_dialogue_active") and station.has_method("advance_marta_dialogue"):
			station.call("advance_marta_dialogue")
			advanced = true
		if _is_true(station, &"is_dialogue_active"):
			if station.has_method("advance_expedition_dialogue"):
				station.call("advance_expedition_dialogue")
				advanced = true
			elif station.has_method("advance_meeting_dialogue"):
				station.call("advance_meeting_dialogue")
				advanced = true
			elif station.has_method("advance_synthesis_dialogue"):
				station.call("advance_synthesis_dialogue")
				advanced = true
			elif station.has_method("advance_dialogue"):
				station.call("advance_dialogue")
				advanced = true
		if _is_true(station, &"is_offer_active") and station.has_method("advance_offer_dialogue"):
			station.call("advance_offer_dialogue")
			advanced = true
		if _is_true(station, &"is_phone_answered") and not _is_true(station, &"is_phone_completed") and station.has_method("advance_phone_dialogue"):
			station.call("advance_phone_dialogue")
			advanced = true
		if (_is_true(station, &"intercom_dialogue_active") or (station.get("intercom_dialogue_lines") != null and not _is_true(station, &"is_intercom_completed"))) and station.has_method("advance_intercom"):
			station.call("advance_intercom")
			advanced = true
		if not advanced:
			break
		await physics_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0151 Smoke Test: 100% PASS on full P7 audit.")
		quit(0)
	else:
		printerr("PKG-0151 Smoke Test: %d failures." % _failures.size())
		quit(1)
