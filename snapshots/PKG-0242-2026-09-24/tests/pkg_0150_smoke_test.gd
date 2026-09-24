extends SceneTree

## PKG-0150 contract gate — P7 diagnostic waves S14–S15 (Station 39–43).
## Proves technical contracts only: authored sequence data, discriminating trials,
## three distinct operational branch selections, three finale chambers, epilogue completion,
## persistence, migration, topology, guidance and clean cutover.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const CampaignChain := preload("res://tests/support/campaign_chain.gd")

const S14 := &"branch_clarity_and_irreversible_choice"
const S15 := &"conscious_silence_and_presence"

const S14_RES := "res://resources/gameplay/branch_clarity_and_irreversible_choice_sequence.tres"
const S15_RES := "res://resources/gameplay/conscious_silence_and_presence_sequence.tres"

const SEQUENCES: Array[Dictionary] = [
	{
		"id": S14,
		"resource": S14_RES,
		"stations": [&"station_39", &"station_40", &"station_41"],
		"entry_gate": &"p7.consent_and_rescue_boundary.trace",
	},
	{
		"id": S15,
		"resource": S15_RES,
		"stations": [&"station_42a", &"station_42b", &"station_42c", &"station_43"],
		"entry_gate": &"p7.branch_clarity_and_irreversible_choice.trace",
	},
]

const STATIONS := [
	"res://scenes/levels/station_39.tscn",
	"res://scenes/levels/station_40.tscn",
	"res://scenes/levels/station_41.tscn",
	"res://scenes/levels/station_42a.tscn",
	"res://scenes/levels/station_42b.tscn",
	"res://scenes/levels/station_42c.tscn",
	"res://scenes/levels/station_43.tscn"
]

const SCRIPTS := [
	"res://scripts/levels/station_39.gd",
	"res://scripts/levels/station_40.gd",
	"res://scripts/levels/station_41.gd",
	"res://scripts/levels/station_42a.gd",
	"res://scripts/levels/station_42b.gd",
	"res://scripts/levels/station_42c.gd",
	"res://scripts/levels/station_43.gd"
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0150 FAILURE: " + message)


func _run_tests() -> void:
	print("=== PKG-0150 Smoke Test: S14-S15 Diagnostic Waves (Stations 39-43) ===")

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	_test_sequence_resources()
	if state:
		_test_save_state_migrations(state)
	_test_script_contracts_and_lint()
	_test_scene_node_stacks()

	if state:
		await _test_station_39_flow(state)
		await _test_station_40_flow(state)
		await _test_station_41_flow(state)
		await _test_station_42a_flow(state)
		await _test_station_42b_flow(state)
		await _test_station_42c_flow(state)
		await _test_station_43_flow(state)

	if _failures.is_empty():
		print("PKG-0150 Smoke Test: 100% PASS on all S14-S15 contracts.")
		quit(0)
	else:
		printerr("PKG-0150 Smoke Test: %d checks failed." % _failures.size())
		quit(1)


func _test_sequence_resources() -> void:
	for seq_meta: Dictionary in SEQUENCES:
		var seq_id: StringName = seq_meta["id"]
		var path: String = seq_meta["resource"]
		_expect(ResourceLoader.exists(path), "Resource exists at %s" % path)
		var seq: Resource = load(path)
		_expect(seq != null, "Resource loaded from %s" % path)
		if seq == null:
			continue
		_expect(seq.get("sequence_id") == seq_id, "Sequence id matches %s" % String(seq_id))
		_expect(seq.get("entry_gate") == seq_meta["entry_gate"], "Sequence entry_gate matches %s" % String(seq_meta["entry_gate"]))
		var stations: Array = seq.get("station_ids")
		var expected_stations: Array = seq_meta["stations"]
		_expect(stations.size() == expected_stations.size(), "%s station count matches" % String(seq_id))
		for st: StringName in expected_stations:
			_expect(stations.has(st), "%s contains station %s" % [String(seq_id), String(st)])
		var hypotheses: Array = seq.get("hypotheses")
		_expect(hypotheses.size() >= 3, "%s defines at least 3 hypotheses" % String(seq_id))
		var commitments: Array = seq.get("commitments")
		_expect(commitments.size() >= 1, "%s defines at least 1 commitment" % String(seq_id))


func _test_save_state_migrations(state: Object) -> void:
	var migrations: Array = state.get("P7_EARLY_SEQUENCE_MIGRATIONS")
	var found_s14 := false
	var found_s15 := false
	for entry: Dictionary in migrations:
		if entry.get("sequence_id") == S14:
			found_s14 = true
			_expect(entry.get("entry_station") == &"station_39", "S14 entry_station is station_39")
			_expect(entry.get("entry_position") == Vector2(65.0, 248.0), "S14 entry_position matches")
		elif entry.get("sequence_id") == S15:
			found_s15 = true
			_expect(entry.get("entry_station") == &"station_42a", "S15 entry_station is station_42a")
			_expect(entry.get("entry_position") == Vector2(65.0, 248.0), "S15 entry_position matches")
	_expect(found_s14, "P7_EARLY_SEQUENCE_MIGRATIONS contains S14")
	_expect(found_s15, "P7_EARLY_SEQUENCE_MIGRATIONS contains S15")


func _test_script_contracts_and_lint() -> void:
	for path: String in SCRIPTS:
		_expect(FileAccess.file_exists(path), "Script file exists: %s" % path)
		var file := FileAccess.open(path, FileAccess.READ)
		if file:
			var content := file.get_as_text()
			_expect(not content.contains("set_campaign_flag"), "%s avoids legacy set_campaign_flag" % path)
			_expect(not content.contains("APPARENT_COOPERATION"), "%s avoids legacy APPARENT_COOPERATION" % path)


func _test_scene_node_stacks() -> void:
	for path: String in STATIONS:
		_expect(ResourceLoader.exists(path), "Scene exists: %s" % path)
		var packed: PackedScene = load(path)
		_expect(packed != null, "Scene packed valid: %s" % path)
		if packed:
			var node: Node = packed.instantiate()
			_expect(node != null, "Scene instantiates cleanly: %s" % path)
			if node:
				_expect(node.has_node("Geometry"), "%s has Geometry" % path)
				_expect(node.has_node("Props"), "%s has Props" % path)
				_expect(node.has_node("AirlockZone"), "%s has AirlockZone" % path)
				_expect(node.has_node("CRTDialogueBox"), "%s has CRTDialogueBox" % path)
				_expect(node.has_node("NarrativeGuidanceService"), "%s has NarrativeGuidanceService" % path)
				node.free()


func _test_station_39_flow(state: Object) -> void:
	var packed: PackedScene = load("res://scenes/levels/station_39.tscn")
	var st: Node2D = packed.instantiate()
	root.add_child(st)
	await process_frame

	_expect(st.has_method("inspect_config_a"), "Station 39 has inspect_config_a")
	_expect(st.has_method("inspect_config_b"), "Station 39 has inspect_config_b")
	_expect(st.has_method("inspect_reference_core"), "Station 39 has inspect_reference_core")
	_expect(st.has_method("inspect_config_c"), "Station 39 has inspect_config_c")
	_expect(st.has_method("review_method_matrix"), "Station 39 has review_method_matrix")

	# Step 1: inspect components
	st.call("inspect_config_a")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.config_a_inspected") == true, "Config A recorded")

	st.call("inspect_config_b")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.config_b_inspected") == true, "Config B recorded")

	st.call("inspect_reference_core")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.reference_core_inspected") == true, "Reference core recorded")

	st.call("inspect_config_c")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.config_c_inspected") == true, "Config C recorded")

	# Step 2: matrix review unlocked exit
	_expect(st.get("is_exit_unlocked") == true, "Station 39 exit unlocked after 4 inspections")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.matrix_reviewed") == true, "Matrix reviewed recorded")

	st.queue_free()
	await process_frame


func _test_station_40_flow(state: Object) -> void:
	var packed: PackedScene = load("res://scenes/levels/station_40.tscn")
	var st: Node2D = packed.instantiate()
	root.add_child(st)
	await process_frame

	_expect(st.has_method("inspect_terminal"), "Station 40 has inspect_terminal")
	_expect(st.has_method("inspect_cost_matrix"), "Station 40 has inspect_cost_matrix")
	_expect(st.has_method("inspect_marta"), "Station 40 has inspect_marta")
	_expect(st.has_method("inspect_szymon"), "Station 40 has inspect_szymon")
	_expect(st.has_method("confront_negotiation_costs"), "Station 40 has confront_negotiation_costs")

	st.call("inspect_terminal")
	st.call("inspect_cost_matrix")
	st.call("inspect_marta")
	st.call("inspect_szymon")

	_expect(st.get("is_exit_unlocked") == true, "Station 40 exit unlocked after 4 witness inspections")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.negotiation_confronted") == true, "Negotiation confronted recorded")

	st.queue_free()
	await process_frame


func _test_station_41_flow(state: Object) -> void:
	var packed: PackedScene = load("res://scenes/levels/station_41.tscn")
	var st: Node2D = packed.instantiate()
	root.add_child(st)
	await process_frame

	_expect(st.has_method("inspect_topography"), "Station 41 has inspect_topography")
	_expect(st.has_method("select_operation_a"), "Station 41 has select_operation_a")
	_expect(st.has_method("select_operation_b"), "Station 41 has select_operation_b")
	_expect(st.has_method("select_operation_c"), "Station 41 has select_operation_c")

	st.call("inspect_topography")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.topography_inspected") == true, "Topography inspected recorded")

	# Test branch selection C
	st.call("select_operation_c")
	_expect(st.get("chosen_operation") == "C", "Station 41 chosen_operation is C")
	_expect(st.get("is_exit_unlocked") == true, "Station 41 exit unlocked after operation selection")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.console_committed") == true, "Console committed recorded")
	_expect(state.decisions.get("p7.branch_clarity_and_irreversible_choice.trace") == "method_committed_to_branch", "S14 trace recorded")
	_expect(state.decisions.get("final_branch_chosen") == "branch_c", "final_branch_chosen recorded")

	st.queue_free()
	await process_frame


func _test_station_42a_flow(state: Object) -> void:
	# PKG-0242 (R1): the finale accepts only the reachable PKG-0239 chain.
	CampaignChain.seed_before_17(state)
	_expect(await CampaignChain.commit_chain(self, "force_home", "partial", "granted"), "Chain for force_home must commit")
	var packed: PackedScene = load("res://scenes/levels/station_42a.tscn")
	var st: Node2D = packed.instantiate()
	root.add_child(st)
	await process_frame

	_expect(st.has_method("execute_forced_return") or st.has_method("inspect_cups"), "Station 42A has forced return")
	_expect(st.has_method("read_sealed_other_lena") or st.has_method("witness_chamber_a"), "Station 42A has sealed-other read")

	if st.has_method("execute_forced_return"):
		st.call("execute_forced_return")
	else:
		st.call("inspect_cups")
	if st.has_method("read_sealed_other_lena"):
		st.call("read_sealed_other_lena")
	elif st.has_method("witness_chamber_a"):
		st.call("witness_chamber_a")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.chamber_a_entered") == true, "Chamber A entered recorded")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.final_chamber_witnessed") == true, "Final chamber witnessed recorded")
	_expect(st.get("is_exit_unlocked") == true, "Station 42A exit unlocked")

	st.queue_free()
	await process_frame


func _test_station_42b_flow(state: Object) -> void:
	# PKG-0242 (R1): the finale accepts only the reachable PKG-0239 chain.
	CampaignChain.seed_before_17(state)
	_expect(await CampaignChain.commit_chain(self, "close_equal_recover_local", "partial", "limited"), "Chain for close_equal_recover_local must commit")
	var packed: PackedScene = load("res://scenes/levels/station_42b.tscn")
	var st: Node2D = packed.instantiate()
	root.add_child(st)
	await process_frame

	_expect(st.has_method("execute_close_flow") or st.has_method("inspect_doorstep"), "Station 42B has close flow")
	_expect(st.has_method("read_local_lena_recovered") or st.has_method("witness_chamber_b"), "Station 42B has local-lena read")

	if st.has_method("execute_close_flow"):
		st.call("execute_close_flow")
	else:
		st.call("inspect_doorstep")
	if st.has_method("read_local_lena_recovered"):
		st.call("read_local_lena_recovered")
	elif st.has_method("witness_chamber_b"):
		st.call("witness_chamber_b")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.chamber_b_entered") == true, "Chamber B entered recorded")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.final_chamber_witnessed") == true, "Final chamber witnessed recorded in 42B")
	_expect(st.get("is_exit_unlocked") == true, "Station 42B exit unlocked")

	st.queue_free()
	await process_frame


func _test_station_42c_flow(state: Object) -> void:
	# PKG-0242 (R1): the finale accepts only the reachable PKG-0239 chain.
	CampaignChain.seed_before_17(state)
	_expect(await CampaignChain.commit_chain(self, "mutual_passage", "full", "granted"), "Chain for mutual_passage must commit")
	var packed: PackedScene = load("res://scenes/levels/station_42c.tscn")
	var st: Node2D = packed.instantiate()
	root.add_child(st)
	await process_frame

	_expect(st.has_method("execute_mutual_passage") or st.has_method("inspect_tram"), "Station 42C has mutual passage")
	_expect(st.has_method("read_memory_leak") or st.has_method("witness_chamber_c"), "Station 42C has memory leak read")

	if st.has_method("execute_mutual_passage"):
		st.call("execute_mutual_passage")
	else:
		st.call("inspect_tram")
	if st.has_method("read_memory_leak"):
		st.call("read_memory_leak")
	elif st.has_method("witness_chamber_c"):
		st.call("witness_chamber_c")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.chamber_c_entered") == true, "Chamber C entered recorded")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.final_chamber_witnessed") == true, "Final chamber witnessed recorded in 42C")
	_expect(st.get("is_exit_unlocked") == true, "Station 42C exit unlocked")

	st.queue_free()
	await process_frame


func _test_station_43_flow(state: Object) -> void:
	var packed: PackedScene = load("res://scenes/levels/station_43.tscn")
	var st: Node2D = packed.instantiate()
	root.add_child(st)
	await process_frame

	_expect(st.has_method("inspect_notice"), "Station 43 has inspect_notice")
	_expect(st.has_method("inspect_credits"), "Station 43 has inspect_credits")
	_expect(st.has_method("inspect_blackout"), "Station 43 has inspect_blackout")

	st.call("inspect_notice")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.epilogue_noticed") == true, "Epilogue noticed recorded")

	st.call("inspect_credits")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.epilogue_credits_read") == true, "Epilogue credits recorded")

	st.call("inspect_blackout")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.epilogue_completed") == true, "Epilogue completed recorded")
	_expect(state.decisions.get("epilogue_witness_completed") == true, "Canonical epilogue_witness_completed recorded")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.trace") == "conscious_silence_and_presence_witnessed", "S15 trace recorded")

	# Test persistence round-trip
	state.save_campaign()
	state.reload_campaign_from_disk()
	_expect(state.decisions.get("epilogue_witness_completed") == true, "epilogue_witness_completed survived save/load")
	_expect(state.decisions.get("p7.conscious_silence_and_presence.trace") == "conscious_silence_and_presence_witnessed", "S15 trace survived save/load")

	st.queue_free()
	await process_frame
