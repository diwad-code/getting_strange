extends SceneTree

## PKG-0149 contract gate — P7 diagnostic waves S11–S13 (Station 31–38).
## Proves technical contracts only: authored sequence data, discriminating trials,
## explicit Anchor/Yield costs, three continuing consent paths, forecasts,
## persistence, migration, topology, guidance and clean cutover.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const S11 := &"archive_countermodel"
const S12 := &"pair_cost_and_echo"
const S13 := &"consent_and_rescue_boundary"

const S11_RES := "res://resources/gameplay/archive_countermodel_sequence.tres"
const S12_RES := "res://resources/gameplay/pair_cost_and_echo_sequence.tres"
const S13_RES := "res://resources/gameplay/consent_and_rescue_boundary_sequence.tres"

const SEQUENCES: Array[Dictionary] = [
	{
		"id": S11,
		"resource": S11_RES,
		"stations": [&"station_31", &"station_32", &"station_33"],
		"entry_gate": &"p7.jakub_boundary_and_forecasts.trace",
	},
	{
		"id": S12,
		"resource": S12_RES,
		"stations": [&"station_34", &"station_35", &"station_36"],
		"entry_gate": &"p7.archive_countermodel.trace",
	},
	{
		"id": S13,
		"resource": S13_RES,
		"stations": [&"station_37", &"station_38"],
		"entry_gate": &"p7.pair_cost_and_echo.trace",
	},
]

const STATIONS := [
	"res://scenes/levels/station_31.tscn",
	"res://scenes/levels/station_32.tscn",
	"res://scenes/levels/station_33.tscn",
	"res://scenes/levels/station_34.tscn",
	"res://scenes/levels/station_35.tscn",
	"res://scenes/levels/station_36.tscn",
	"res://scenes/levels/station_37.tscn",
	"res://scenes/levels/station_38.tscn"
]

const SCRIPTS := [
	"res://scripts/levels/station_31.gd",
	"res://scripts/levels/station_32.gd",
	"res://scripts/levels/station_33.gd",
	"res://scripts/levels/station_34.gd",
	"res://scripts/levels/station_35.gd",
	"res://scripts/levels/station_36.gd",
	"res://scripts/levels/station_37.gd",
	"res://scripts/levels/station_38.gd"
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0149 FAILURE: " + message)


func _run_tests() -> void:
	print("=== PKG-0149 Smoke Test: S11-S13 Diagnostic Waves (Stations 31-38) ===")

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
		await _test_station_31_flow(state)
		await _test_station_32_flow(state)
		await _test_station_33_flow(state)
		await _test_station_34_flow(state)
		await _test_station_35_flow(state)
		await _test_station_36_flow(state)
		await _test_station_37_flow(state)
		await _test_station_38_flow(state)

	if _failures.is_empty():
		print("PKG-0149: ALL TESTS PASSED.")
		quit(0)
	else:
		printerr("PKG-0149: %d FAILURES ENCOUNTERED:" % _failures.size())
		for f in _failures:
			printerr("  - ", f)
		quit(1)


func _open_station(station_id: StringName) -> Node2D:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	_expect(packed != null, "%s musi się ładować" % station_id)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
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


func _test_sequence_resources() -> void:
	print("Testing Sequence resources (S11, S12, S13)...")
	for spec in SEQUENCES:
		var path := String(spec["resource"])
		_expect(ResourceLoader.exists(path), "Musi istnieć Resource sekwencji: %s" % path)
		if not ResourceLoader.exists(path):
			continue
		var sequence := load(path) as Resource
		_expect(sequence != null, "Resource sekwencji musi się ładować: %s" % path)
		if sequence == null:
			continue
		var sequence_id := spec["id"] as StringName
		_expect(sequence.get("sequence_id") == sequence_id, "%s musi mieć stabilne sequence_id" % sequence_id)
		_expect(sequence.get("station_ids") == spec["stations"], "%s musi obejmować właściwe stacje" % sequence_id)
		_expect(sequence.get("entry_gate") == spec["entry_gate"], "%s musi wymagać śladu poprzedniej sekwencji" % sequence_id)
		_expect(int(sequence.get("migration_revision")) == 1, "%s musi deklarować rewizję migracji 1" % sequence_id)
		_expect(String(sequence.get("trace_key")).begins_with("p7.%s." % sequence_id), "%s musi deklarować namespaced ślad" % sequence_id)
		_expect(not String(sequence.get("discrepancy")).is_empty(), "%s musi nazwać rozbieżność" % sequence_id)


func _test_save_state_migrations(state: Node) -> void:
	print("Testing GameStateManager S11-S13 migrations...")
	state.reset_campaign(true)
	state.decisions[&"s31_wierzbicka_adaptation_rejected"] = true
	state.decisions[&"s32_memory_trace_anchored"] = true
	state.decisions[&"s33_local_lena_intent_found"] = true
	state.decisions[&"s34_pair_registry_unlocked"] = true
	state.decisions[&"s35_home_echo_verified"] = true
	state.decisions[&"s36_line4_ledger_revealed"] = true
	state.decisions[&"s37_living_signal_bridged"] = true
	state.decisions[&"s38_marta_truth_state"] = "full"
	state.decisions[&"p7.archive_countermodel.trace"] = "legacy_fabricated"
	state.decisions[&"p7.pair_cost_and_echo.trace"] = "legacy_fabricated"
	state.decisions[&"p7.consent_and_rescue_boundary.trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_35", Vector2(430.0, 240.0))
	_expect(state.save_campaign(), "Legacy checkpoint S12 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Legacy checkpoint S12 musi dać się odczytać")
	_expect(state.last_checkpoint_station == &"station_34" and state.last_checkpoint_position == Vector2(50.0, 240.0), "Checkpoint S12 musi wrócić do Station 34")
	for key in [
		&"s31_wierzbicka_adaptation_rejected", &"s32_memory_trace_anchored", &"s33_local_lena_intent_found",
		&"s34_pair_registry_unlocked", &"s35_home_echo_verified", &"s36_line4_ledger_revealed",
		&"s37_living_signal_bridged", &"s38_marta_truth_state",
		&"p7.archive_countermodel.trace", &"p7.pair_cost_and_echo.trace", &"p7.consent_and_rescue_boundary.trace"
	]:
		_expect(not state.decisions.has(key), "Migracja nie może zachować legacy klucza %s" % String(key))
	_expect(int(state.decisions.get(&"p7.archive_countermodel.migration_revision", 0)) == 1, "S11 musi otrzymać rewizję migracji")
	_expect(int(state.decisions.get(&"p7.pair_cost_and_echo.migration_revision", 0)) == 1, "S12 musi otrzymać rewizję migracji")
	_expect(int(state.decisions.get(&"p7.consent_and_rescue_boundary.migration_revision", 0)) == 1, "S13 musi otrzymać rewizję migracji")


func _test_script_contracts_and_lint() -> void:
	print("Testing script obstacle comments and zero draw_string in Layer 0...")
	for path in SCRIPTS:
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Script must open: %s" % path)
		if file == null:
			continue
		var content := file.get_as_text()
		_expect(not content.contains("draw_string("), "%s contains prohibited draw_string in Layer 0" % path)
		_expect(content.contains("## PRZESZKODA — dlaczego to tu jest:"), "%s missing question 1" % path)
		_expect(content.contains("## PRZESZKODA — czego wymaga od Leny:"), "%s missing question 2" % path)
		_expect(content.contains("## PRZESZKODA — koszt porażki:"), "%s missing question 3" % path)

		var lines := content.split("\n")
		for line in lines:
			if line.begins_with("## PRZESZKODA —"):
				_expect(not line.to_lower().contains("gracz"), "%s obstacle header contains 'gracz': %s" % [path, line])


func _test_scene_node_stacks() -> void:
	print("Testing scene node stacks for Pixel-Stage...")
	for path in STATIONS:
		var scene := load(path) as PackedScene
		_expect(scene != null, "Scena %s musi się ładować" % path)
		if scene:
			var inst := scene.instantiate()
			_expect(inst.has_node("WorldPixelCompositor"), "Scena %s musi mieć WorldPixelCompositor (Layer 5)" % path)
			_expect(inst.has_node("CrispDiegeticText"), "Scena %s musi mieć CrispDiegeticText (Layer 10)" % path)
			_expect(inst.has_node("InnerThoughtSurface"), "Scena %s musi mieć InnerThoughtSurface (Layer 16)" % path)
			_expect(inst.has_node("CRTDialogueBox"), "Scena %s musi mieć CRTDialogueBox (Layer 20)" % path)
			_expect(inst.has_node("NarrativeGuidanceService"), "Scena %s musi mieć NarrativeGuidanceService" % path)
			_expect(inst.has_node("Geometry"), "Scena %s musi mieć Geometry" % path)
			_expect(inst.has_node("Props"), "Scena %s musi mieć Props" % path)
			_expect(inst.has_node("Player"), "Scena %s musi mieć Player" % path)
			_expect(inst.has_node("AirlockZone"), "Scena %s musi mieć AirlockZone" % path)
			inst.free()


func _test_station_31_flow(state: Node) -> void:
	print("Testing Station 31 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_31")

	# Negative control: missing entry fact
	_expect(not _call_bool(st, &"inspect_passenger_chairs", "Station 31 missing passenger chairs verb"), "Should fail inspection without entry fact")

	state.record_decision(&"p7.jakub_boundary_and_forecasts.trace", "consent_and_forecasts_resolved")
	_expect(_call_bool(st, &"inspect_passenger_chairs", "Passenger chairs inspection must succeed"), "Chairs inspection failed")
	_expect(not _call_bool(st, &"reject_adaptation_offer", "Station 31 reject verb missing"), "Premature rejection must fail")

	_expect(_call_bool(st, &"inspect_wierzbicka_proposal", "Wierzbicka proposal inspection must succeed"), "Proposal inspection failed")
	_expect(_call_bool(st, &"inspect_twelfth_chair", "Twelfth chair inspection must succeed"), "Twelfth chair failed")
	_expect(_call_bool(st, &"compare_passenger_ledger", "Passenger ledger comparison must succeed"), "Ledger comparison failed")
	_expect(_call_bool(st, &"reject_adaptation_offer", "Reject adaptation offer must succeed"), "Rejection failed")
	_expect(bool(st.get("is_adaptation_rejected")) and bool(st.get("is_exit_unlocked")), "Rejection must unlock exit")

	await _close_station(st)


func _test_station_32_flow(state: Node) -> void:
	print("Testing Station 32 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_32")

	_expect(not _call_bool(st, &"inspect_steamed_pane", "Station 32 steamed pane verb missing"), "Should fail without entry fact")
	state.record_decision(&"p7.archive_countermodel.adaptation_offer_rejected", true)

	_expect(_call_bool(st, &"inspect_steamed_pane", "Steamed pane inspection must succeed"), "Steamed pane failed")
	_expect(not _call_bool(st, &"anchor_material_memory", "Station 32 anchor verb missing"), "Premature anchor must fail")

	_expect(_call_bool(st, &"inspect_cracked_pane", "Cracked pane inspection must succeed"), "Cracked pane failed")
	_expect(_call_bool(st, &"etch_condensation_trace", "Condensation trace etch must succeed"), "Trace etch failed")
	_expect(_call_bool(st, &"inspect_polished_pane", "Polished pane inspection must succeed"), "Polished pane failed")
	_expect(_call_bool(st, &"anchor_material_memory", "Anchor material memory must succeed"), "Anchor failed")
	_expect(bool(st.get("is_material_memory_anchored")) and bool(st.get("is_exit_unlocked")), "Anchor must unlock exit")

	await _close_station(st)


func _test_station_33_flow(state: Node) -> void:
	print("Testing Station 33 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_33")

	_expect(not _call_bool(st, &"inspect_ladder_infrastructure", "Station 33 ladder verb missing"), "Should fail without entry fact")
	state.record_decision(&"p7.archive_countermodel.material_memory_anchored", true)

	_expect(_call_bool(st, &"inspect_ladder_infrastructure", "Ladder inspection must succeed"), "Ladder failed")
	_expect(not _call_bool(st, &"reconstruct_local_lena_intent", "Station 33 reconstruct verb missing"), "Premature reconstruction must fail")

	_expect(_call_bool(st, &"inspect_depth_gauge", "Depth gauge inspection must succeed"), "Gauge failed")
	_expect(_call_bool(st, &"inspect_cable_trunk_note", "Cable trunk note inspection must succeed"), "Note failed")
	_expect(_call_bool(st, &"inspect_shaft_work_light", "Shaft work light inspection must succeed"), "Light failed")
	_expect(_call_bool(st, &"reconstruct_local_lena_intent", "Reconstructing local Lena intent must succeed"), "Reconstruction failed")
	_expect(bool(st.get("is_local_lena_intent_found")) and bool(st.get("is_exit_unlocked")), "Intent reconstruction must unlock exit")

	await _close_station(st)


func _test_station_34_flow(state: Node) -> void:
	print("Testing Station 34 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_34")

	_expect(not _call_bool(st, &"inspect_correlation_reactor", "Station 34 reactor verb missing"), "Should fail without entry fact")
	state.record_decision(&"p7.archive_countermodel.trace", "local_lena_intent_found")

	_expect(_call_bool(st, &"inspect_correlation_reactor", "Reactor inspection must succeed"), "Reactor failed")
	_expect(not _call_bool(st, &"unlock_pair_registry", "Station 34 unlock verb missing"), "Premature pair registry unlock must fail")

	_expect(_call_bool(st, &"inspect_allocation_desk", "Allocation desk inspection must succeed"), "Desk failed")
	_expect(_call_bool(st, &"inspect_thermal_indicators", "Thermal indicators inspection must succeed"), "Thermal failed")
	_expect(_call_bool(st, &"inspect_diagnostic_probe", "Diagnostic probe inspection must succeed"), "Probe failed")
	_expect(_call_bool(st, &"unlock_pair_registry", "Pair registry unlock must succeed"), "Unlock failed")
	_expect(bool(st.get("is_pair_registry_unlocked")) and bool(st.get("is_exit_unlocked")), "Pair registry unlock must unlock exit")

	await _close_station(st)


func _test_station_35_flow(state: Node) -> void:
	print("Testing Station 35 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_35")

	_expect(not _call_bool(st, &"inspect_cooling_pool", "Station 35 pool verb missing"), "Should fail without entry fact")
	state.record_decision(&"p7.pair_cost_and_echo.pair_registry_inspected", true)

	_expect(_call_bool(st, &"inspect_cooling_pool", "Cooling pool inspection must succeed"), "Pool failed")
	_expect(not _call_bool(st, &"process_home_echo", "Station 35 process verb missing"), "Premature home echo process must fail")

	_expect(_call_bool(st, &"inspect_drain_valve", "Drain valve inspection must succeed"), "Valve failed")
	_expect(_call_bool(st, &"inspect_chemical_sampler", "Chemical sampler inspection must succeed"), "Sampler failed")
	_expect(_call_bool(st, &"process_home_echo", "Home echo process must succeed"), "Process echo failed")
	_expect(bool(st.get("is_home_echo_verified")) and bool(st.get("is_exit_unlocked")), "Home echo verification must unlock exit")

	await _close_station(st)


func _test_station_36_flow(state: Node) -> void:
	print("Testing Station 36 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_36")

	_expect(not _call_bool(st, &"inspect_drain_weir", "Station 36 weir verb missing"), "Should fail without entry fact")
	state.record_decision(&"p7.pair_cost_and_echo.home_echo_verified", true)

	_expect(_call_bool(st, &"inspect_drain_weir", "Drain weir inspection must succeed"), "Weir failed")
	_expect(not _call_bool(st, &"reveal_ucp_cost_ledger", "Station 36 reveal ledger verb missing"), "Premature cost ledger reveal must fail")

	_expect(_call_bool(st, &"measure_drain_current", "Drain current measurement must succeed"), "Current failed")
	_expect(_call_bool(st, &"inspect_service_ladder", "Service ladder inspection must succeed"), "Ladder failed")
	_expect(_call_bool(st, &"sample_contamination_tap", "Contamination tap sampling must succeed"), "Tap failed")
	_expect(_call_bool(st, &"reveal_ucp_cost_ledger", "Reveal UCP cost ledger must succeed"), "Reveal failed")
	_expect(bool(st.get("is_ucp_cost_ledger_found")) and bool(st.get("is_exit_unlocked")), "Cost ledger reveal must unlock exit")

	await _close_station(st)


func _test_station_37_flow(state: Node) -> void:
	print("Testing Station 37 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_37")

	_expect(not _call_bool(st, &"inspect_frequency_oscilloscope", "Station 37 oscilloscope verb missing"), "Should fail without entry fact")
	state.record_decision(&"p7.pair_cost_and_echo.trace", "ucp_cost_ledger_found")

	_expect(_call_bool(st, &"inspect_frequency_oscilloscope", "Oscilloscope inspection must succeed"), "Oscilloscope failed")
	_expect(not _call_bool(st, &"bridge_living_signal", "Station 37 bridge verb missing"), "Premature bridge must fail")

	_expect(_call_bool(st, &"inspect_transmission_patchbay", "Patchbay inspection must succeed"), "Patchbay failed")
	_expect(_call_bool(st, &"inspect_transmitting_antenna", "Antenna inspection must succeed"), "Antenna failed")
	_expect(_call_bool(st, &"inspect_mixing_pulpit", "Mixing pulpit inspection must succeed"), "Pulpit failed")
	_expect(_call_bool(st, &"bridge_living_signal", "Bridge living signal must succeed"), "Bridge signal failed")
	_expect(bool(st.get("is_living_signal_bridged")) and bool(st.get("is_exit_unlocked")), "Living signal bridge must unlock exit")

	await _close_station(st)


func _test_station_38_flow(state: Node) -> void:
	print("Testing Station 38 diagnostic flow & negative controls...")
	state.reset_campaign(true)
	var st := await _open_station(&"station_38")

	_expect(not _call_bool(st, &"inspect_radio_receiver", "Station 38 receiver verb missing"), "Should fail without entry fact")
	state.record_decision(&"p7.consent_and_rescue_boundary.living_signal_bridged", true)

	_expect(_call_bool(st, &"inspect_radio_receiver", "Radio receiver inspection must succeed"), "Receiver failed")
	_expect(not _call_bool(st, &"disclose_marta_truth", "Station 38 disclose truth verb missing", [&"full"]), "Premature truth disclosure must fail")

	_expect(_call_bool(st, &"inspect_local_procedure_record", "Local procedure record inspection must succeed"), "Record failed")
	_expect(_call_bool(st, &"inspect_jakub_switchboard", "Jakub switchboard inspection must succeed"), "Switchboard failed")
	_expect(_call_bool(st, &"anchor_rescue_tether", "Anchor rescue tether must succeed"), "Tether failed")
	_expect(_call_bool(st, &"disclose_marta_truth", "Disclose truth to Marta must succeed", [&"full"]), "Truth disclosure failed")
	_expect(bool(st.get("is_marta_truth_disclosed")) and bool(st.get("is_exit_unlocked")), "Disclosing truth must unlock exit")

	await _close_station(st)
