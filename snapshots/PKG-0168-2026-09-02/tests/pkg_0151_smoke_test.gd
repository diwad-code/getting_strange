extends SceneTree

## PKG-0151 final P7 audit gate.
## Technical proof only: sequence/resource graph, 45 technical scenes,
## save migration behavior, finale routing, and epilogue persistence.
## Full campaign traversal remains covered by the existing verify suite
## (`tests/smoke_test.gd`, `tests/pkg_0138_smoke_test.gd`, wave gates 0145..0150).

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")

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
	print("=== PKG-0151 Smoke Test: Full P7 audit, 45 scenes, 3 finale branches ===")
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must be available")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	state.reset_campaign(true)
	_test_sequence_resources_and_graph()
	await _test_scene_contracts_and_lint()
	_test_selector_routes(state)
	_test_save_migrations_and_roundtrip(state)
	await _test_finale_branch_flows(state)
	_finish()


func _test_sequence_resources_and_graph() -> void:
	var trace_keys: Dictionary = {}
	var narrative_addresses: Dictionary = {}
	var technical_scenes: Dictionary = {}
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
		var stations: Array = spec["stations"]
		var entry_gate := spec["entry_gate"] as StringName
		var trace_key := spec["trace_key"] as StringName
		_expect(sequence.get("sequence_id") == sequence_id, "%s sequence_id mismatch" % String(sequence_id))
		_expect(sequence.get("station_ids") == stations, "%s station_ids mismatch" % String(sequence_id))
		_expect(sequence.get("entry_gate") == entry_gate, "%s entry_gate mismatch" % String(sequence_id))
		_expect(sequence.get("trace_key") == trace_key, "%s trace_key mismatch" % String(sequence_id))
		_expect(int(sequence.get("migration_revision")) == 1, "%s migration_revision must be 1" % String(sequence_id))
		_expect((sequence.get("hypotheses") as Array).size() >= 2, "%s must define at least 2 hypotheses" % String(sequence_id))
		_expect((sequence.get("commitments") as Array).size() >= 1, "%s must define at least 1 commitment" % String(sequence_id))
		_expect((sequence.get("guidance_beat_ids") as Array).size() >= 1, "%s must define guidance beats" % String(sequence_id))
		_expect((sequence.get("state_keys") as Array).size() >= 1, "%s must define state keys" % String(sequence_id))
		trace_keys[trace_key] = true
		for station_id in stations:
			technical_scenes[station_id] = true
			narrative_addresses[_canonical_address(station_id)] = true
	for spec in SEQUENCE_SPECS:
		var entry_gate := spec["entry_gate"] as StringName
		if entry_gate.is_empty() or entry_gate == &"world_recognized":
			continue
		_expect(trace_keys.has(entry_gate), "Entry gate %s must resolve to a declared trace key" % String(entry_gate))
	_expect(narrative_addresses.size() == 43, "P7 resources must cover 43 narrative addresses (got %d)" % narrative_addresses.size())
	_expect(technical_scenes.size() == 45, "P7 resources must cover 45 technical scenes (got %d)" % technical_scenes.size())
	_expect(trace_keys.has(&"p7.mutual_test.ucp_buffer_trace"), "S08 special trace key must remain explicit")
	_expect(trace_keys.has(&"p7.three_place_proofs.trace"), "S09 gate must keep depending on S07 trace")


func _test_scene_contracts_and_lint() -> void:
	for station_id in TECHNICAL_SCENE_IDS:
		var scene_path := _scene_path(station_id)
		var script_path := _script_path(station_id)
		_expect(FileAccess.file_exists(script_path), "Station script missing: %s" % script_path)
		if FileAccess.file_exists(script_path):
			var file := FileAccess.open(script_path, FileAccess.READ)
			_expect(file != null, "Station script must open: %s" % script_path)
			if file != null:
				var content := file.get_as_text()
				file.close()
				_expect(content.contains("## PRZESZKODA — dlaczego to tu jest:"), "%s missing obstacle header 1" % script_path)
				_expect(content.contains("## PRZESZKODA — czego wymaga od Leny:"), "%s missing obstacle header 2" % script_path)
				_expect(content.contains("## PRZESZKODA — koszt porażki:"), "%s missing obstacle header 3" % script_path)
				_expect(not content.contains("set_campaign_flag"), "%s still references set_campaign_flag" % script_path)
				_expect(not content.contains("_check_unlock"), "%s still references _check_unlock" % script_path)
				_expect(not content.contains("APPARENT_COOPERATION"), "%s still references APPARENT_COOPERATION" % script_path)
				_expect(not content.contains("draw_string("), "%s still draws text in Layer 0" % script_path)
				for line in content.split("\n"):
					if line.begins_with("## PRZESZKODA —"):
						_expect(not line.to_lower().contains("gracz"), "%s obstacle header cannot use 'gracz': %s" % [script_path, line])
		_expect(ResourceLoader.exists(scene_path), "Scene missing: %s" % scene_path)
		if not ResourceLoader.exists(scene_path):
			continue
		var packed := load(scene_path) as PackedScene
		_expect(packed != null, "Scene must load: %s" % scene_path)
		if packed == null:
			continue
		var scene := packed.instantiate() as Node2D
		_expect(scene != null, "Scene must instantiate as Node2D: %s" % scene_path)
		if scene == null:
			continue
		root.add_child(scene)
		await process_frame
		await physics_frame
		_expect(scene.has_node("WorldPixelCompositor"), "%s missing WorldPixelCompositor" % scene_path)
		_expect(_has_named_descendant(scene, "CrispDiegeticText"), "%s missing CrispDiegeticText node family" % scene_path)
		_expect(scene.has_node("InnerThoughtSurface"), "%s missing InnerThoughtSurface" % scene_path)
		_expect(scene.has_node("CRTDialogueBox"), "%s missing CRTDialogueBox" % scene_path)
		_expect(scene.has_node("NarrativeGuidanceService"), "%s missing NarrativeGuidanceService" % scene_path)
		_expect(scene.has_node("Geometry"), "%s missing Geometry" % scene_path)
		_expect(scene.has_node("Props"), "%s missing Props" % scene_path)
		_expect(scene.has_node("Player"), "%s missing Player" % scene_path)
		_expect(scene.has_node("AirlockZone"), "%s missing AirlockZone" % scene_path)
		if station_id != &"station_01":
			_expect(scene.has_node("ReturnZone"), "%s missing ReturnZone" % scene_path)
		var guidance := scene.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
		_expect(guidance != null, "%s guidance node must exist" % scene_path)
		if guidance != null:
			_expect(guidance.active_beats.size() >= 1, "%s guidance must register beats on _ready" % scene_path)
		if scene.get_parent() == root:
			root.remove_child(scene)
		scene.free()
		await process_frame


func _test_selector_routes(state: Node) -> void:
	state.reset_campaign(true)
	for branch in ["A", "B", "C"]:
		var finale_id: StringName = FINALE_EXPECTATIONS[branch]
		state.select_finale_operation(branch)
		_expect(state.get_selected_finale_id() == finale_id, "Branch %s must resolve to %s" % [branch, String(finale_id)])
		_expect(state.get_next_campaign_station(&"station_41") == finale_id, "station_41 must route to %s for branch %s" % [String(finale_id), branch])
		_expect(state.get_next_campaign_station(finale_id) == &"station_43", "%s must route to station_43" % String(finale_id))
		_expect(state.get_previous_campaign_station(finale_id) == &"station_41", "%s previous must be station_41" % String(finale_id))
		_expect(state.get_previous_campaign_station(&"station_43") == finale_id, "station_43 previous must follow branch %s" % branch)
		var selectable: Array = state.get_selectable_stations(true)
		_expect(selectable.size() == 43, "Selectable route must expose 43 narrative addresses for branch %s" % branch)
		_expect(selectable[41] == finale_id, "Selectable route index 41 must swap in %s for branch %s" % [String(finale_id), branch])
		_expect(selectable[42] == &"station_43", "Selectable route must always end at station_43")


func _test_save_migrations_and_roundtrip(state: Node) -> void:
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
	_expect(state.is_reduced_motion(), "S08 migration must preserve reduced-motion state")

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
	_expect(state.decisions.get(&"home_sample_preserved", false) == true, "Early P7 migration must preserve external canonical facts")

	state.reset_campaign(true)
	state.decisions[&"s35_home_echo_verified"] = true
	state.decisions[&"p7.pair_cost_and_echo.trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_35", Vector2(430.0, 240.0))
	_expect(state.save_campaign(), "Mid P7 checkpoint must save")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Mid P7 checkpoint must reload")
	_expect(state.last_checkpoint_station == &"station_34" and state.last_checkpoint_position == Vector2(50.0, 240.0), "Mid P7 checkpoint must normalize to station_34")
	_expect(not state.decisions.has(&"s35_home_echo_verified"), "Mid P7 legacy key must be removed")

	state.reset_campaign(true)
	state.decisions[&"s41_operation_committed"] = true
	state.decisions[&"p7.branch_clarity_and_irreversible_choice.trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_40", Vector2(300.0, 240.0))
	_expect(state.save_campaign(), "Late P7 checkpoint must save")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Late P7 checkpoint must reload")
	_expect(state.last_checkpoint_station == &"station_39" and state.last_checkpoint_position == Vector2(65.0, 248.0), "Late P7 checkpoint must normalize to station_39")
	_expect(not state.decisions.has(&"s41_operation_committed"), "Late P7 legacy key must be removed")

	state.reset_campaign(true)
	state.record_decision(&"p7.sample_and_promise.trace", "sample_preserved_and_time_sent")
	state.record_decision(&"home_sample_preserved", true)
	state.record_decision(&"p7.three_place_proofs.trace", "world_recognized_and_search_committed")
	state.record_decision(&"world_recognized", true)
	state.record_decision(&"p7.archive_countermodel.trace", "local_lena_intent_found")
	state.record_decision(&"local_lena_intent_found", true)
	state.record_decision(&"p7.pair_cost_and_echo.trace", "cost_ledger_revealed")
	state.record_decision(&"home_echo_verified", true)
	state.record_decision(&"p7.jakub_boundary_and_forecasts.trace", "three_routes_mapped_against_jakub_consent")
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


func _test_finale_branch_flows(state: Node) -> void:
	for branch in ["A", "B", "C"]:
		var finale_id: StringName = FINALE_EXPECTATIONS[branch]
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = false
		state.record_decision(&"p7.consent_and_rescue_boundary.trace", "truth_disclosed_with_scope")
		var station39 := await _open_station(&"station_39")
		_expect(station39 != null, "station_39 must open for branch %s" % branch)
		if station39 != null:
			_expect(_call_bool(station39, &"inspect_config_a", "station_39 missing inspect_config_a"), "station_39 config A must succeed")
			_expect(_call_bool(station39, &"inspect_config_b", "station_39 missing inspect_config_b"), "station_39 config B must succeed")
			_expect(_call_bool(station39, &"inspect_reference_core", "station_39 missing inspect_reference_core"), "station_39 reference core must succeed")
			_expect(_call_bool(station39, &"inspect_config_c", "station_39 missing inspect_config_c"), "station_39 config C must succeed")
			_expect(bool(station39.get("is_exit_unlocked")), "station_39 must unlock exit after four inspections")
			_expect(state.decisions.get(&"p7.branch_clarity_and_irreversible_choice.matrix_reviewed", false) == true, "station_39 must record matrix_reviewed")
			await _close_station(station39)
		var station40 := await _open_station(&"station_40")
		_expect(station40 != null, "station_40 must open for branch %s" % branch)
		if station40 != null:
			_expect(_call_bool(station40, &"inspect_terminal", "station_40 missing inspect_terminal"), "station_40 terminal must succeed")
			_expect(_call_bool(station40, &"inspect_cost_matrix", "station_40 missing inspect_cost_matrix"), "station_40 cost matrix must succeed")
			_expect(_call_bool(station40, &"inspect_marta", "station_40 missing inspect_marta"), "station_40 Marta witness must succeed")
			_expect(_call_bool(station40, &"inspect_szymon", "station_40 missing inspect_szymon"), "station_40 Szymon witness must succeed")
			_expect(bool(station40.get("is_exit_unlocked")), "station_40 must unlock exit after witness review")
			_expect(state.decisions.get(&"p7.branch_clarity_and_irreversible_choice.negotiation_confronted", false) == true, "station_40 must record negotiation_confronted")
			await _close_station(station40)
		var station41 := await _open_station(&"station_41")
		_expect(station41 != null, "station_41 must open for branch %s" % branch)
		if station41 != null:
			_expect(_call_bool(station41, &"inspect_topography", "station_41 missing inspect_topography"), "station_41 topography must succeed")
			match branch:
				"A":
					_expect(_call_bool(station41, &"select_operation_a", "station_41 missing select_operation_a"), "station_41 branch A selection must succeed")
				"B":
					_expect(_call_bool(station41, &"select_operation_b", "station_41 missing select_operation_b"), "station_41 branch B selection must succeed")
				_:
					_expect(_call_bool(station41, &"select_operation_c", "station_41 missing select_operation_c"), "station_41 branch C selection must succeed")
			_expect(String(state.decisions.get(&"final_branch_chosen", "")) == "branch_%s" % branch.to_lower(), "station_41 must record final_branch_chosen for branch %s" % branch)
			state.select_finale_operation(branch)
			_expect(state.get_selected_finale_id() == finale_id, "GameStateManager must route branch %s to %s" % [branch, String(finale_id)])
			await _close_station(station41)
		var finale_station := await _open_station(finale_id)
		_expect(finale_station != null, "%s must open for branch %s" % [String(finale_id), branch])
		if finale_station != null:
			match finale_id:
				&"station_42a":
					state.record_decision(&"p9.method_commitment.method_committed", "force_home")
					state.record_decision(&"method_committed", "force_home")
					_expect(_call_bool(finale_station, &"execute_forced_return", "station_42a missing execute_forced_return") or _call_bool(finale_station, &"inspect_cups", "station_42a missing inspect_cups"), "station_42a forced return must succeed")
					_expect(_call_bool(finale_station, &"read_sealed_other_lena", "station_42a missing read_sealed_other_lena") or _call_bool(finale_station, &"witness_chamber_a", "station_42a missing witness_chamber_a"), "station_42a sealed other Lena must be readable")
					_expect(state.decisions.get(&"p7.conscious_silence_and_presence.chamber_a_entered", false) == true, "station_42a must record chamber_a_entered")
				&"station_42b":
					state.record_decision(&"p9.method_commitment.method_committed", "close_equal_recover_local")
					state.record_decision(&"method_committed", "close_equal_recover_local")
					_expect(_call_bool(finale_station, &"execute_close_flow", "station_42b missing execute_close_flow") or _call_bool(finale_station, &"inspect_doorstep", "station_42b missing inspect_doorstep"), "station_42b flow closure must succeed")
					_expect(_call_bool(finale_station, &"read_local_lena_recovered", "station_42b missing read_local_lena_recovered") or _call_bool(finale_station, &"witness_chamber_b", "station_42b missing witness_chamber_b"), "station_42b local Lena read must succeed")
					_expect(state.decisions.get(&"p7.conscious_silence_and_presence.chamber_b_entered", false) == true, "station_42b must record chamber_b_entered")
				_:
					_expect(_call_bool(finale_station, &"inspect_tram", "station_42c missing inspect_tram"), "station_42c tram inspection must succeed")
					_expect(state.decisions.get(&"p7.conscious_silence_and_presence.chamber_c_entered", false) == true, "station_42c must record chamber_c_entered")
			_expect(state.decisions.get(&"p7.conscious_silence_and_presence.final_chamber_witnessed", false) == true, "%s must record final chamber witness" % String(finale_id))
			_expect(bool(finale_station.get("is_exit_unlocked")), "%s must unlock exit after chamber witness" % String(finale_id))
			await _close_station(finale_station)
		var station43 := await _open_station(&"station_43")
		_expect(station43 != null, "station_43 must open for branch %s" % branch)
		if station43 != null:
			_expect(_call_bool(station43, &"inspect_notice", "station_43 missing inspect_notice"), "station_43 notice must succeed")
			_expect(_call_bool(station43, &"inspect_credits", "station_43 missing inspect_credits"), "station_43 credits must succeed")
			_expect(_call_bool(station43, &"inspect_blackout", "station_43 missing inspect_blackout"), "station_43 blackout must succeed")
			_expect(state.decisions.get(&"epilogue_witness_completed", false) == true, "station_43 must record canonical epilogue completion")
			_expect(String(state.decisions.get(&"p7.conscious_silence_and_presence.trace", "")) == "conscious_silence_and_presence_witnessed", "station_43 must leave S15 trace")
			await _close_station(station43)


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


func _canonical_address(station_id: StringName) -> StringName:
	var text := String(station_id)
	if text.begins_with("station_42"):
		return &"station_42"
	return station_id


func _scene_path(station_id: StringName) -> String:
	return "res://scenes/levels/%s.tscn" % String(station_id)




func _has_named_descendant(node: Node, prefix: String) -> bool:
	if String(node.name).begins_with(prefix):
		return true
	for child in node.get_children():
		if _has_named_descendant(child, prefix):
			return true
	return false
func _script_path(station_id: StringName) -> String:
	return "res://scripts/levels/%s.gd" % String(station_id)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0151 Smoke Test: 100% PASS on final P7 audit gate.")
		quit(0)
	else:
		printerr("PKG-0151 Smoke Test: %d failures." % _failures.size())
		quit(1)
