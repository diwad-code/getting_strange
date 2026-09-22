extends SceneTree

## PKG-0148 contract gate — P7 diagnostic waves S09–S10 (Station 26–30).
## Proves technical contracts only: authored sequence data, discriminating trials,
## explicit Anchor/Yield costs, three continuing consent paths, forecasts,
## persistence, migration, topology, guidance and clean cutover.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const S09 := &"interrupted_trial_and_small_cost"
const S10 := &"jakub_boundary_and_forecasts"
const S09_PREFIX := "p7.interrupted_trial_and_small_cost."
const S10_PREFIX := "p7.jakub_boundary_and_forecasts."

const SEQUENCES: Array[Dictionary] = [
	{
		"id": S09,
		"resource": "res://resources/gameplay/interrupted_trial_and_small_cost_sequence.tres",
		"stations": [&"station_26", &"station_27", &"station_28"],
		"entry_gate": &"p7.three_place_proofs.trace",
	},
	{
		"id": S10,
		"resource": "res://resources/gameplay/jakub_boundary_and_forecasts_sequence.tres",
		"stations": [&"station_29", &"station_30"],
		"entry_gate": &"p7.interrupted_trial_and_small_cost.trace",
	},
]

const LEGACY_TOKENS: Array[String] = [
	"_check_unlock", "set_campaign_flag", "advance_dialogue",
	"inspect_console", "inspect_designator", "inspect_speaker", "anchor_motivation",
	"inspect_badge", "interact_jakub", "inspect_monitor",
	"inspect_window", "inspect_paradox", "inspect_intercom",
	"inspect_tracks", "inspect_neon", "inspect_well", "inspect_beacon",
	"inspect_board", "inspect_transformer", "throw_breaker", "inspect_schematic",
	"s26_motivation_anchored", "s27_pulses_sent", "s28_carriage_travel_completed",
	"s29_power_balanced", "s30_three_models_resolved",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0148 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)
	_test_sequence_resources()
	if state != null:
		_test_wave_save_migration(state)
		await _test_s09_trial(state)
		await _test_s09_cost_paths(state)
		await _test_s10_consent_paths(state)
		await _test_s10_forecasts(state)
		await _test_save_reload(state)
	await _test_topology_and_guidance()
	_test_clean_cutover()
	if state != null:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	_finish()


func _test_sequence_resources() -> void:
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
		var hypotheses: Array = sequence.get("hypotheses")
		_expect(hypotheses.size() >= 3, "%s musi zawierać trzy konkurencyjne hipotezy" % sequence_id)
		for hypothesis in hypotheses:
			_expect(hypothesis is Resource, "%s hipoteza musi być Resource" % sequence_id)
			if hypothesis is Resource:
				_expect(not String(hypothesis.get("predicted_outcome")).is_empty(), "%s hipoteza musi przewidywać obserwowalny wynik" % sequence_id)
				_expect(not String(hypothesis.get("trial_result")).is_empty(), "%s hipoteza musi wskazywać wynik próby" % sequence_id)
		var commitments: Array = sequence.get("commitments")
		_expect(not commitments.is_empty(), "%s musi mieć jawne zobowiązania" % sequence_id)
		for commitment in commitments:
			_expect(commitment is Resource, "%s zobowiązanie musi być Resource" % sequence_id)
			if commitment is Resource:
				_expect(not String(commitment.get("known_cost")).is_empty(), "%s zobowiązanie musi ujawniać koszt" % sequence_id)
				_expect(not String(commitment.get("alternative_route")).is_empty(), "%s zobowiązanie musi wskazywać alternatywę" % sequence_id)
				_expect(not commitment.has_method("get_moral_score"), "%s nie może mieć moral score" % sequence_id)


func _test_wave_save_migration(state: Node) -> void:
	state.reset_campaign(true)
	state.decisions[&"home_sample_preserved"] = true
	state.decisions[&"p7.three_place_proofs.trace"] = "world_recognized_and_search_committed"
	state.decisions[&"ucp_intervention_reconstructed"] = true
	state.decisions[&"local_lena_signal_confirmed"] = true
	state.decisions[&"small_cost_manifested"] = "sample_exact_second_lost"
	state.decisions[&"jakub_consent_state"] = "limited"
	state.decisions[&"route_hypotheses_mapped"] = true
	for key in [
		&"station_26_isolation_partition_corrected", &"s26_motivation_anchored",
		&"s27_pulses_sent", &"s28_carriage_travel_completed",
		&"s29_power_balanced", &"station_30_witness_relay_corrected", &"s30_three_models_resolved",
	]:
		state.decisions[key] = true
	state.decisions[&"p7.interrupted_trial_and_small_cost.trace"] = "legacy_fabricated"
	state.decisions[&"p7.jakub_boundary_and_forecasts.trace"] = "legacy_fabricated"
	state.set_checkpoint(&"station_30", Vector2(430.0, 240.0))
	state.set_reduced_motion(true, false)
	_expect(state.save_campaign(), "Legacy checkpoint S10 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Legacy checkpoint S10 musi dać się odczytać")
	_expect(state.last_checkpoint_station == &"station_29" and state.last_checkpoint_position == Vector2(70.0, 296.0), "Checkpoint S10 musi wrócić do Station 29")
	_expect(state.is_reduced_motion(), "Migracja nie może zmienić ustawień użytkownika")
	_expect(state.decisions.get(&"home_sample_preserved", false) == true, "Migracja musi zachować wcześniejsze fakty")
	_expect(state.decisions.get(&"ucp_intervention_reconstructed", false) == true, "Migracja musi zachować kanoniczny fakt S09 jako nowy fakt")
	_expect(state.decisions.get(&"local_lena_signal_confirmed", false) == true, "Migracja musi zachować kanoniczny sygnał S09")
	_expect(state.decisions.get(&"small_cost_manifested", "") == "sample_exact_second_lost", "Migracja musi zachować kanoniczny koszt S09")
	_expect(state.decisions.get(&"jakub_consent_state", "") == "limited", "Migracja musi zachować kanoniczną zgodę S10")
	_expect(state.decisions.get(&"route_hypotheses_mapped", false) == true, "Migracja musi zachować kanoniczną mapę S10")
	for key in [
		&"station_26_isolation_partition_corrected", &"s26_motivation_anchored", &"s27_pulses_sent", &"s28_carriage_travel_completed",
		&"s29_power_balanced", &"station_30_witness_relay_corrected", &"s30_three_models_resolved",
		&"p7.interrupted_trial_and_small_cost.trace", &"p7.jakub_boundary_and_forecasts.trace",
	]:
		_expect(not state.decisions.has(key), "Migracja nie może zachować ani mapować legacy klucza %s" % String(key))
	_expect(int(state.decisions.get(&"p7.interrupted_trial_and_small_cost.migration_revision", 0)) == 1, "S09 musi otrzymać rewizję migracji")
	_expect(int(state.decisions.get(&"p7.jakub_boundary_and_forecasts.migration_revision", 0)) == 1, "S10 musi otrzymać rewizję migracji")

	state.reset_campaign(true)
	state.decisions[&"s27_pulses_sent"] = true
	state.set_checkpoint(&"station_27", Vector2(300.0, 240.0))
	_expect(state.save_campaign(), "Legacy checkpoint S09 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Legacy checkpoint S09 musi dać się odczytać")
	_expect(state.last_checkpoint_station == &"station_26" and state.last_checkpoint_position == Vector2(70.0, 296.0), "Checkpoint S09 musi wrócić do Station 26")
	state.set_reduced_motion(false, false)


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


func _seed_s09(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.three_place_proofs.trace", "world_recognized_and_search_committed")


func _perform_s09_through_signal(state: Node) -> void:
	_seed_s09(state)
	var station := await _open_station(&"station_26")
	_call_bool(station, &"observe_interrupted_ucp_log", "Station 26 musi obserwować log")
	_call_bool(station, &"synchronize_sample_clock", "Station 26 musi synchronizować próbkę")
	_call_bool(station, &"synchronize_ucp_command_clock", "Station 26 musi synchronizować UCP")
	_call_bool(station, &"synchronize_local_generator_clock", "Station 26 musi synchronizować generator")
	_call_bool(station, &"reconstruct_ucp_intervention", "Station 26 musi rekonstruować interwencję")
	await _close_station(station)
	station = await _open_station(&"station_27")
	_call_bool(station, &"calibrate_pulse_reference", "Station 27 musi kalibrować odniesienie")
	_call_bool(station, &"send_first_identical_pulse", "Station 27 musi wysyłać pierwszy impuls")
	_call_bool(station, &"send_second_identical_pulse", "Station 27 musi wysyłać drugi impuls")
	_call_bool(station, &"send_deliberate_error_pulse", "Station 27 musi wysyłać celowy błąd")
	_call_bool(station, &"compare_response_correction", "Station 27 musi porównać korektę")
	await _close_station(station)


func _test_s09_trial(state: Node) -> void:
	_seed_s09(state)
	var station := await _open_station(&"station_26")
	_expect(not _call_bool(station, &"reconstruct_ucp_intervention", "Station 26 musi wystawiać rekonstrukcję"), "Rekonstrukcja bez trzech zegarów musi być bezpiecznie odrzucona")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.safe_trial_feedback", "") == "interrupted_log_required", "Błędna próba Station 26 musi nazwać brak logu")
	_expect(not state.decisions.has(&"ucp_intervention_reconstructed"), "Błędna próba nie może nadać kanonicznego faktu")
	_expect(_call_bool(station, &"observe_interrupted_ucp_log", "Station 26 musi obserwować log"), "Log musi być czytelny")
	_expect(_call_bool(station, &"synchronize_sample_clock", "Station 26 musi synchronizować próbkę"), "Zegar próbki musi być jawny")
	_expect(_call_bool(station, &"synchronize_ucp_command_clock", "Station 26 musi synchronizować UCP"), "Zegar UCP musi być jawny")
	_expect(_call_bool(station, &"synchronize_local_generator_clock", "Station 26 musi synchronizować generator"), "Lokalny zegar musi być jawny")
	_expect(_call_bool(station, &"reconstruct_ucp_intervention", "Station 26 musi rekonstruować interwencję"), "Trzy zegary muszą rozstrzygnąć późniejszą interwencję")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed", false) == true, "S09 musi zapisać rekonstrukcję UCP")
	await _close_station(station)

	station = await _open_station(&"station_27")
	_expect(not _call_bool(station, &"compare_response_correction", "Station 27 musi wystawiać porównanie"), "Porównanie bez impulsów musi być bezpiecznie odrzucone")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.safe_trial_feedback", "") == "pulse_reference_required", "Błędna próba Station 27 musi nazwać brak kalibracji")
	_expect(_call_bool(station, &"calibrate_pulse_reference", "Station 27 musi kalibrować odniesienie"), "Kalibracja musi być wykonana")
	_expect(_call_bool(station, &"send_first_identical_pulse", "Station 27 musi wysyłać pierwszy impuls"), "Pierwszy impuls musi być wykonany")
	_expect(_call_bool(station, &"send_second_identical_pulse", "Station 27 musi wysyłać drugi impuls"), "Drugi impuls musi być wykonany")
	_expect(_call_bool(station, &"send_deliberate_error_pulse", "Station 27 musi wysyłać błąd"), "Celowy błąd musi być wykonany")
	_expect(not state.decisions.has(&"local_lena_signal_confirmed"), "Samo wysłanie impulsów nie może automatycznie potwierdzić sygnału")
	_expect(_call_bool(station, &"compare_response_correction", "Station 27 musi porównywać korektę"), "Jawne porównanie musi rozstrzygnąć próbę")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.local_lena_signal_confirmed", false) == true, "S09 musi potwierdzić sygnał dopiero po porównaniu")
	await _close_station(station)


func _prepare_station_28(state: Node) -> Node2D:
	await _perform_s09_through_signal(state)
	var station := await _open_station(&"station_28")
	_call_bool(station, &"observe_transfer_constraint", "Station 28 musi obserwować ograniczenie")
	_call_bool(station, &"inspect_home_sample_trace", "Station 28 musi czytać ślad próbki")
	_call_bool(station, &"inspect_local_lena_signal_trace", "Station 28 musi czytać sygnał miejscowej Leny")
	return station


func _test_s09_cost_paths(state: Node) -> void:
	var station := await _prepare_station_28(state)
	_expect(not _call_bool(station, &"perform_home_trace_anchor", "Station 28 musi wystawiać Anchor"), "Anchor przed ceną musi być odrzucony")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.safe_trial_feedback", "") == "transfer_price_required", "Błędny Anchor musi nazwać brak ceny")
	_expect(not state.decisions.has(&"small_cost_manifested"), "Koszt nie może powstać przed ujawnieniem i wykonaniem")
	_expect(_call_bool(station, &"disclose_transfer_price", "Station 28 musi ujawnić cenę"), "Cena musi być jawna")
	_expect(not state.decisions.has(&"small_cost_manifested"), "Samo ujawnienie ceny nie może jej naliczyć")
	_expect(_call_bool(station, &"perform_home_trace_anchor", "Station 28 musi wykonać Anchor"), "Anchor musi być wykonany przez reality shift")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.small_cost_manifested", "") == "marta_first_meeting_detail_blurred", "Anchor musi rozmyć detal pierwszego spotkania Marty")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.trace", "") == "home_trace_anchor", "Anchor musi zostawić własny ślad")
	await _close_station(station)

	station = await _prepare_station_28(state)
	_call_bool(station, &"disclose_transfer_price", "Station 28 musi ujawnić cenę Yield")
	_expect(_call_bool(station, &"perform_shared_drift_yield", "Station 28 musi wykonać Yield"), "Yield musi być wykonany przez reality shift")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.small_cost_manifested", "") == "sample_exact_second_lost", "Yield musi utracić dokładną sekundę próbki")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.trace", "") == "shared_drift_yield", "Yield musi zostawić własny ślad")
	_expect(not _call_bool(station, &"perform_home_trace_anchor", "Station 28 musi odrzucać drugi reality shift"), "Anchor i Yield muszą być wzajemnie wyłączne")
	await _close_station(station)


func _prepare_s10_state(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.interrupted_trial_and_small_cost.trace", "shared_drift_yield")


func _test_s10_consent_paths(state: Node) -> void:
	for consent in [&"granted", &"limited", &"refused"]:
		_prepare_s10_state(state)
		var station := await _open_station(&"station_29")
		_expect(not _call_bool(station, &"record_jakub_consent", "Station 29 musi wystawiać zgodę", [consent]), "Zgoda bez jawnego zakresu i ryzyka musi być odrzucona")
		_expect(state.decisions.get(&"p7.jakub_boundary_and_forecasts.safe_trial_feedback", "") == "contrast_proposal_required", "Błędna zgoda musi nazwać brak propozycji")
		_expect(not state.decisions.has(&"jakub_consent_state"), "Błędna ścieżka nie może nadać zgody")
		_expect(_call_bool(station, &"inspect_ucp_jakub_contrast_proposal", "Station 29 musi czytać propozycję"), "Propozycja musi być jawna")
		_expect(_call_bool(station, &"observe_jakub_ordinary_life_scope", "Station 29 musi obserwować zwykłe życie"), "Zakres osoby musi być jawny")
		_expect(_call_bool(station, &"disclose_jakub_signal_risk", "Station 29 musi ujawniać ryzyko"), "Ryzyko musi być jawne")
		_expect(_call_bool(station, &"disable_jakub_transmitter", "Station 29 musi wyłączać nadajnik"), "Nadajnik musi być fizycznie wyłączony")
		_expect(_call_bool(station, &"record_jakub_consent", "Station 29 musi zapisywać zgodę", [consent]), "Każdy kanoniczny stan zgody musi być poprawny")
		_expect(String(state.decisions.get(&"jakub_consent_state", "")) == String(consent), "Zgoda %s musi być zapisana bez moralnego rankingu" % consent)
		_expect(station.get("is_exit_unlocked") == true, "Zgoda %s musi zachować drogę dalej" % consent)
		await _close_station(station)


func _test_s10_forecasts(state: Node) -> void:
	_prepare_s10_state(state)
	state.record_decision(&"jakub_consent_state", "refused")
	var station := await _open_station(&"station_30")
	_expect(not _call_bool(station, &"compare_forecast_consent_dependencies", "Station 30 musi wystawiać porównanie"), "Porównanie bez prognoz musi być odrzucone")
	_expect(state.decisions.get(&"p7.jakub_boundary_and_forecasts.safe_trial_feedback", "") == "force_home_forecast_required", "Błędne porównanie musi nazwać pierwszą brakującą prognozę")
	_expect(_call_bool(station, &"build_force_home_forecast", "Station 30 musi budować force-home"), "Force-home musi być policzone")
	_expect(_call_bool(station, &"build_close_equal_recover_local_forecast", "Station 30 musi budować close/equal/recover-local"), "Close/equal/recover-local musi być policzone")
	_expect(_call_bool(station, &"build_mutual_passage_forecast", "Station 30 musi budować mutual-passage"), "Mutual-passage musi być policzone")
	_expect(not state.decisions.has(&"route_hypotheses_mapped"), "Trzecia prognoza nie może automatycznie wykonać porównania")
	_expect(_call_bool(station, &"compare_forecast_consent_dependencies", "Station 30 musi porównywać zależności"), "Jawne porównanie musi mapować trasy")
	_expect(state.decisions.get(&"route_hypotheses_mapped", false) == true, "S10 musi utrwalić mapę hipotez tras")
	_expect(state.decisions.get(&"p7.jakub_boundary_and_forecasts.trace", "") == "three_routes_mapped_against_jakub_consent", "S10 musi zostawić trwały ślad")
	_expect(station.get("is_exit_unlocked") == true, "Odmowa Jakuba musi pozostać kontynuowalna po prognozach")
	await _close_station(station)


func _test_save_reload(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.three_place_proofs.trace", "world_recognized_and_search_committed")
	state.record_decision(&"p7.interrupted_trial_and_small_cost.ucp_intervention_reconstructed", true)
	state.record_decision(&"p7.interrupted_trial_and_small_cost.local_lena_signal_confirmed", true)
	state.record_decision(&"p7.interrupted_trial_and_small_cost.small_cost_manifested", "sample_exact_second_lost")
	state.record_decision(&"p7.interrupted_trial_and_small_cost.trace", "shared_drift_yield")
	state.record_decision(&"jakub_consent_state", "refused")
	state.record_decision(&"route_hypotheses_mapped", true)
	state.record_decision(&"p7.jakub_boundary_and_forecasts.trace", "three_routes_mapped_against_jakub_consent")
	_expect(state.save_campaign(), "Stan S09–S10 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Stan S09–S10 musi dać się odczytać")
	_expect(state.decisions.get(&"p7.interrupted_trial_and_small_cost.small_cost_manifested", "") == "sample_exact_second_lost", "Koszt S09 musi przetrwać reload")
	_expect(state.decisions.get(&"jakub_consent_state", "") == "refused", "Odmowa Jakuba musi przetrwać reload")
	_expect(state.decisions.get(&"route_hypotheses_mapped", false) == true, "Mapa prognoz musi przetrwać reload")
	_expect(state.decisions.get(&"p7.jakub_boundary_and_forecasts.trace", "") == "three_routes_mapped_against_jakub_consent", "Ślad S10 musi przetrwać reload")


func _test_guidance(station: Node2D, station_id: StringName) -> void:
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	_expect(guidance != null, "%s musi mieć NarrativeGuidanceService" % station_id)
	if guidance == null:
		return
	var tiers: Dictionary = {}
	var has_l3_check := false
	var has_fallible_hypothesis := false
	for beat_id in guidance.active_beats:
		var beat := guidance.active_beats[beat_id] as GuidanceBeat
		if beat == null:
			continue
		tiers[beat.tier] = true
		if beat.tier == GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT and not beat.predicted_check.is_empty():
			has_l3_check = true
		if beat.tier == GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT and not beat.hypothesis_id.is_empty() and not beat.predicted_check.is_empty():
			_expect(beat.truth_scope == &"fallible", "%s omylna myśl musi być oznaczona fallible" % station_id)
			has_fallible_hypothesis = true
		if beat.tier == GuidanceBeat.Tier.L4_RESCUE_HINT:
			_expect(beat.text_pl.contains("WSKAZÓWKA"), "%s L4 musi być jawną wskazówką systemu" % station_id)
	_expect(tiers.has(0) and tiers.has(1) and tiers.has(2) and tiers.has(3) and tiers.has(4), "%s musi rejestrować pełną drabinę L0–L4" % station_id)
	_expect(has_l3_check, "%s L3 musi wskazywać test rozróżniający" % station_id)
	_expect(has_fallible_hypothesis, "%s musi mieć omylną myśl z hypothesis_id i predicted_check" % station_id)


func _test_topology_and_guidance() -> void:
	for number in range(26, 31):
		var id := StringName("station_%02d" % number)
		var station := await _open_station(id)
		if station == null:
			continue
		_expect(station.get_node_or_null("Props") != null, "%s musi zachować Props" % id)
		_expect(station.get_node_or_null("Camera") != null, "%s musi zachować Camera" % id)
		_expect(station.get_node_or_null("ReturnZone") != null, "%s musi zachować ReturnZone" % id)
		_expect(station.get_node_or_null("AirlockZone") != null, "%s musi zachować AirlockZone" % id)
		_expect(station.has_signal(&"previous_level_requested"), "%s musi zachować powrót" % id)
		_expect(station.has_signal(&"level_completed"), "%s musi zachować ukończenie" % id)
		_test_guidance(station, id)
		await _close_station(station)


func _test_clean_cutover() -> void:
	for number in range(26, 31):
		var path := "res://scripts/levels/station_%02d.gd" % number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Skrypt migrowanej stacji musi być czytelny: %s" % path)
		if file == null:
			continue
		var source := file.get_as_text()
		file.close()
		for token in LEGACY_TOKENS:
			_expect(not source.contains(token), "%s nie może zachować legacy path: %s" % [path, token])
		_expect(source.contains("_complete_if_player_already_in_airlock"), "%s musi domykać overlap po unlock" % path)
		_expect(source.contains("func _draw_state_layer() -> void:"), "%s musi zachować osobną warstwę stanu" % path)
	_expect(_count_token_in_station_sources("apply_reality_shift") == 2, "Obie ścieżki S09 muszą używać lokalnego reality shift wyłącznie w Station 28")


func _count_token_in_station_sources(token: String) -> int:
	var count := 0
	for number in range(26, 31):
		var file := FileAccess.open("res://scripts/levels/station_%02d.gd" % number, FileAccess.READ)
		if file == null:
			continue
		var source := file.get_as_text()
		file.close()
		count += source.count(token)
	return count


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0148 PASS: P7 S09–S10 diagnostic contracts")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0148 FAILURE: " + failure)
	quit(1)
