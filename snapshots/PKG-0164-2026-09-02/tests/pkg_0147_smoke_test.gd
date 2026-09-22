extends SceneTree

## PKG-0147 contract gate — P7 diagnostic waves S06–S07 (Station 15–21).
##
## Proves technical contracts only (D-012, ADR-003): authored sequence data,
## discriminating trials driven by player verbs, safe failed trials, the
## three-source recognition gate at Station 21, the vocabulary and method-cost
## gates before S08, ReturnZone topology, save migration and clean cutover.
## It proves nothing about fun, comprehension, emotion or human comfort.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const SEQUENCES: Array[Dictionary] = [
	{
		"id": &"work_history_and_record",
		"resource": "res://resources/gameplay/work_history_and_record_sequence.tres",
		"stations": [&"station_15", &"station_16", &"station_17"],
		"entry_gate": &"p7.marta_threshold.trace",
	},
	{
		"id": &"three_place_proofs",
		"resource": "res://resources/gameplay/three_place_proofs_sequence.tres",
		"stations": [&"station_18", &"station_19", &"station_20", &"station_21"],
		"entry_gate": &"p7.work_history_and_record.trace",
	},
]

## Every legacy checklist, auto-inspection and dialogue-completion path that the
## cutover must remove from the migrated range. No shims are allowed.
const LEGACY_TOKENS: Array[String] = [
	"_check_unlock",
	"_check_access",
	"_check_records",
	"_check_details",
	"_check_synthesis_readiness",
	"_check_completion_condition",
	"set_campaign_flag",
	"apply_table_setback",
	"apply_scanner_setback",
	"apply_intercom_setback",
	"apply_registry_setback",
	"apply_phone_setback",
	"apply_boundary_setback",
	"apply_synthesis_setback",
	"advance_expedition_dialogue",
	"advance_intercom",
	"advance_phone_dialogue",
	"advance_meeting_dialogue",
	"advance_synthesis_dialogue",
	"local_lena_search_started",
]

## Station 15–20 must not name the other world, the local Lena or a conscious
## Anchor/Yield. Station 16 may record its local method cost as part of the
## performed small-cost contract; Station 21 is still linted for the broader
## recognition method cost.
const FORBIDDEN_PRE21_TEXT: Array[String] = [
	"inny świat",
	"miejscowa lena",
	"anchor/yield",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0147 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)
		_test_sequence_resources()
		_test_p7_revision_marking(state)
		_test_wave_save_migration(state)
		await _test_s06_work_history_and_record(state)
		await _test_s07_three_place_proofs(state)
		await _test_recognition_gate(state)
		await _test_s08_entry_after_synthesis(state)
		await _test_return_topology()
		_test_pre21_vocabulary_gate()
		_test_clean_cutover()
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
		_expect(hypotheses.size() >= 2, "%s musi zawierać co najmniej dwie hipotezy" % sequence_id)
		for hypothesis in hypotheses:
			_expect(hypothesis is Resource, "%s hipoteza musi być Resource" % sequence_id)
			if hypothesis is Resource:
				_expect(not String(hypothesis.get("predicted_outcome")).is_empty(), "%s hipoteza musi przewidywać obserwowalny wynik" % sequence_id)
				_expect(not String(hypothesis.get("trial_result")).is_empty(), "%s hipoteza musi wskazywać wynik próby" % sequence_id)
				var evidence: Array = hypothesis.get("required_evidence")
				_expect(evidence.size() >= 2, "%s hipoteza musi mieć dwa niezależne konteksty" % sequence_id)
		var commitments: Array = sequence.get("commitments")
		_expect(not commitments.is_empty(), "%s musi mieć jawne zobowiązanie" % sequence_id)
		for commitment in commitments:
			_expect(commitment is Resource, "%s zobowiązanie musi być Resource" % sequence_id)
			if commitment is Resource:
				_expect(not String(commitment.get("known_cost")).is_empty(), "%s zobowiązanie musi ujawniać koszt" % sequence_id)
				_expect(not String(commitment.get("alternative_route")).is_empty(), "%s zobowiązanie musi wskazywać alternatywę" % sequence_id)
				_expect(not String(commitment.get("person_id")).is_empty(), "%s zobowiązanie musi wskazywać osobę" % sequence_id)
				_expect(not commitment.has_method("get_moral_score"), "%s nie może zawierać moral score" % sequence_id)


func _test_p7_revision_marking(state: Node) -> void:
	for spec in SEQUENCES:
		var sequence_id := spec["id"] as StringName
		state.reset_campaign(true)
		var fact_key := StringName("p7.%s.probe_fact" % sequence_id)
		var revision_key := StringName("p7.%s.migration_revision" % sequence_id)
		_expect(state.record_decision(fact_key, true), "Nowy fakt %s musi być JSON-safe" % sequence_id)
		_expect(int(state.decisions.get(revision_key, 0)) == 1, "Zapis %s musi od razu oznaczyć rewizję migracji" % sequence_id)
		_expect(state.save_campaign(), "Stan %s musi dać się zapisać" % sequence_id)
		state.reset_campaign(false)
		_expect(state.reload_campaign_from_disk(), "Stan %s musi dać się odczytać" % sequence_id)
		_expect(state.decisions.get(fact_key, false) == true, "Nowy fakt %s nie może zostać skasowany jako legacy" % sequence_id)


func _test_wave_save_migration(state: Node) -> void:
	## Legacy zapis z checklistowego świata: rozpoznanie, dowody i zgody
	## powstały bez wykonanej próby. Migracja musi je wymazać, a nie zmapować.
	state.reset_campaign(true)
	state.set_reduced_motion(true, false)
	state.decisions[&"ucp_intervention_reconstructed"] = true
	state.decisions[&"home_sample_preserved"] = true
	state.decisions[&"world_recognized"] = true
	state.decisions[&"local_lena_search_committed"] = true
	state.decisions[&"local_lena_search_started"] = true
	state.decisions[&"recognition_evidence_public"] = true
	state.decisions[&"recognition_evidence_relational"] = true
	state.decisions[&"recognition_evidence_carried"] = true
	state.decisions[&"jakub_public_history_verified"] = true
	state.decisions[&"jakub_voice_heard"] = true
	state.decisions[&"jakub_met_as_person"] = true
	state.decisions[&"marta_memories_conflict"] = true
	state.decisions[&"local_lena_ucp_profile_found"] = true
	state.decisions[&"parallel_test_trace_found"] = true
	state.decisions[&"station_16_scanner_blocked"] = 2
	state.decisions[&"station_20_boundary_violated"] = 1
	state.set_checkpoint(&"station_19", Vector2(430.0, 240.0))
	_expect(state.save_campaign(), "Legacy checkpoint 15–21 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Legacy checkpoint 15–21 musi dać się odczytać")
	_expect(
		state.last_checkpoint_station == &"station_18" and state.last_checkpoint_position == Vector2(70.0, 296.0),
		"Checkpoint S07 musi wrócić do bezpiecznego wejścia Station 18"
	)
	_expect(state.is_reduced_motion(), "Migracja S06–S07 nie może zmienić ustawień użytkownika")
	_expect(state.decisions.get(&"ucp_intervention_reconstructed", false) == true, "Migracja musi zachować fakty spoza migrowanych sekwencji")
	_expect(state.decisions.get(&"home_sample_preserved", false) == true, "Migracja S06–S07 musi zachować fakty S01–S05")
	for erased in [
		&"world_recognized", &"local_lena_search_committed", &"local_lena_search_started",
		&"recognition_evidence_public", &"recognition_evidence_relational", &"recognition_evidence_carried",
		&"jakub_public_history_verified", &"jakub_voice_heard", &"jakub_met_as_person",
		&"marta_memories_conflict", &"local_lena_ucp_profile_found", &"parallel_test_trace_found",
		&"station_16_scanner_blocked", &"station_20_boundary_violated",
	]:
		_expect(not state.decisions.has(erased), "Legacy klucz %s nie może przetrwać migracji S06–S07" % String(erased))
	for spec in SEQUENCES:
		var sequence_id := spec["id"] as StringName
		var revision_key := StringName("p7.%s.migration_revision" % sequence_id)
		_expect(int(state.decisions.get(revision_key, 0)) == 1, "%s musi otrzymać rewizję migracji" % sequence_id)
		var trace_key := StringName("p7.%s.trace" % sequence_id)
		_expect(not state.decisions.has(trace_key), "%s migracja nie może sfabrykować śladu" % sequence_id)
	## Checkpoint wewnątrz S06 wraca na własne wejście, nie na wejście S07.
	state.reset_campaign(true)
	state.decisions[&"local_lena_ucp_profile_found"] = true
	state.set_checkpoint(&"station_16", Vector2(300.0, 240.0))
	_expect(state.save_campaign(), "Legacy checkpoint wewnątrz S06 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Legacy checkpoint wewnątrz S06 musi dać się odczytać")
	_expect(
		state.last_checkpoint_station == &"station_15" and state.last_checkpoint_position == Vector2(70.0, 296.0),
		"Checkpoint S06 musi wrócić do bezpiecznego wejścia Station 15"
	)
	state.set_reduced_motion(false, false)


func _open_station(station_id: StringName) -> Node2D:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	_expect(packed != null, "%s musi się ładować" % station_id)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	_expect(station != null, "%s musi mieć korzeń Node2D" % station_id)
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


func _call_bool(station: Node, method_name: StringName, message: String) -> bool:
	if station == null or not station.has_method(method_name):
		_expect(false, message)
		return false
	var result: Variant = station.call(method_name)
	return result is bool and result


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
		if beat.tier == GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT:
			if not beat.hypothesis_id.is_empty() and not beat.predicted_check.is_empty():
				_expect(beat.truth_scope == &"fallible", "%s omylna myśl musi być omylna" % station_id)
				has_fallible_hypothesis = true
		if beat.tier == GuidanceBeat.Tier.L4_RESCUE_HINT:
			_expect(beat.text_pl.contains("WSKAZÓWKA"), "%s L4 musi być jawną wskazówką systemu" % station_id)
	_expect(
		tiers.has(GuidanceBeat.Tier.L0_COMPOSITION)
		and tiers.has(GuidanceBeat.Tier.L1_REACTION)
		and tiers.has(GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT)
		and tiers.has(GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT)
		and tiers.has(GuidanceBeat.Tier.L4_RESCUE_HINT),
		"%s musi rejestrować pełną drabinę L0–L4" % station_id
	)
	_expect(has_l3_check, "%s L3 musi wskazywać test rozróżniający" % station_id)
	_expect(has_fallible_hypothesis, "%s musi mieć omylną myśl z hypothesis_id i predicted_check" % station_id)
	var before: Dictionary = (root.get_node("GameStateManager").decisions as Dictionary).duplicate(true)
	for beat_id in guidance.active_beats:
		var beat := guidance.active_beats[beat_id] as GuidanceBeat
		if beat != null and beat.tier == GuidanceBeat.Tier.L4_RESCUE_HINT:
			guidance.trigger_beat(beat_id, true)
			break
	_expect(root.get_node("GameStateManager").decisions == before, "%s L4 nie może wykonać próby ani zobowiązania" % station_id)


func _test_s06_work_history_and_record(state: Node) -> void:
	## Station 15 została przebudowana w P9 (BUNDLE-22, PKG-0163) na próbę
	## wzajemnego sygnału; sekcja pilnuje jej P9 kontraktu. Station 16–17
	## pozostają w kontrakcie S06 do własnych bundle'ów P9.
	state.reset_campaign(true)
	state.record_decision(&"p7.marta_threshold.trace", "dead_circuit_lesson_observed")
	var station := await _open_station(&"station_15")
	if station == null:
		return
	_test_guidance(station, &"station_15")
	_expect(not _call_bool(station, &"send_corrective_impulse", "Station 15 musi wystawiać impuls z celowym błędem"), "Próba S06/P9 bez dwóch kontroli musi być bezpiecznie odrzucona")
	_expect(state.decisions.get(&"p9.mechanics.mutual_signal.safe_trial_feedback", "") == "controls_incomplete", "Błędna próba na 15 musi dać informację")
	_expect(not state.decisions.has(&"local_lena_signal_confirmed"), "Błędna próba nie może nadać sygnału")
	_expect(_call_bool(station, &"observe_signal_log", "Station 15 musi odtwarzać log 20:40"), "S06/P9 musi odtworzyć próbę z 20:40")
	_expect(state.decisions.get(&"ucp_intervention_reconstructed", false) == true, "Rekonstrukcja musi nadać motyw działania UCP")
	_expect(_call_bool(station, &"send_control_impulse", "Station 15 musi wysyłać impulsy kontrolne"), "S06/P9 musi mieć pierwszą kontrolę")
	station.call(&"run_response_cycle")
	_expect(_call_bool(station, &"send_control_impulse", "Station 15 musi wysyłać drugą kontrolę"), "S06/P9 musi mieć drugą kontrolę")
	station.call(&"run_response_cycle")
	_expect(state.decisions.get(&"p9.mechanics.mutual_signal.control_echo_observed", "") == "echo_repeats_identically", "Kontrolne echo musi wrócić identyczne")
	_expect(_call_bool(station, &"send_corrective_impulse", "Station 15 musi wysłać impuls z celowym błędem"), "S06/P9 musi wykonać trzeci impuls po kontrolach")
	station.call(&"run_response_cycle")
	_expect(state.decisions.get(&"p9.mechanics.mutual_signal.corrective_response_observed", "") == "deliberate_error_corrected_selectively", "Selektywna korekta musi być jawnym wynikiem")
	_expect(state.decisions.get(&"local_lena_signal_confirmed", false) == true, "S06/P9 musi utrwalić potwierdzenie żywego sygnału")
	_expect(_call_bool(station, &"read_abort_note", "Station 15 musi udostępnić notatkę po potwierdzeniu"), "S06/P9 musi mieć odczyt warunku przerwania")
	_expect(state.decisions.get(&"local_lena_intent_found", false) == true, "S06/P9 musi utrwalić zamiar bez winnego")
	_expect(bool(station.get("is_exit_unlocked")), "Odczyt notatki musi otworzyć wyjście")
	await _close_station(station)

	station = await _open_station(&"station_16")
	if station == null:
		return
	_test_guidance(station, &"station_16")
	_expect(not _call_bool(station, &"confirm_home_echo", "Station 16 musi wystawiać potwierdzenie echa domu"), "Echo domu przed kosztem musi być bezpiecznie odrzucone")
	_expect(state.decisions.get(&"p9.mechanics.small_cost.safe_trial_feedback", "") == "cost_choice_required", "Wczesne echo musi dać informację o wyborze kosztu")
	_expect(not state.decisions.has(&"p9.mechanics.small_cost.manifested"), "Wczesne echo nie może ujawnić kosztu")
	_expect(_call_bool(station, &"transfer_response_to_safe_analyzer", "Station 16 musi przekazać odpowiedź do bezpiecznego analizatora"), "S06 musi ustanowić bezpieczny odczyt")
	_expect(_call_bool(station, &"choose_sample_second_cost", "Station 16 musi pozwalać wybrać koszt drugiej próbki"), "S06 musi ustanowić wybór kosztu")
	_expect(state.decisions.get(&"p9.mechanics.small_cost.manifested", "") == "sample_exact_second_lost", "Station 16 musi zapisać wybrany koszt drugiej próbki")
	_expect(state.decisions.get(&"mechanic_cost_observed", false) == true, "Lokalny koszt metody musi powstać dopiero po wykonanym wyborze")
	_expect(_call_bool(station, &"confirm_home_echo", "Station 16 musi potwierdzać echo domu"), "S06 musi domknąć echo po koszcie")
	_expect(state.decisions.get(&"home_echo_verified", false) == true, "Echo domu musi być jawne")
	_expect(state.decisions.get(&"p7.work_history_and_record.institution_trial_result", "") == "small_cost_and_home_echo_confirmed", "S06 musi przekazać most do następnej stacji")
	_expect(bool(station.get("is_exit_unlocked")), "Station 16 musi otworzyć wyjście po echem domu")
	await _close_station(station)

	station = await _open_station(&"station_17")
	if station == null:
		return
	_test_guidance(station, &"station_17")
	_expect(not _call_bool(station, &"copy_report_header", "Station 17 musi wystawiać zobowiązanie zakresu"), "Zobowiązanie S06 bez zakresu musi być odrzucone bezpiecznie")
	_expect(state.decisions.get(&"p7.work_history_and_record.safe_trial_feedback", "") == "report_scope_incomplete", "Błędne zobowiązanie S06 musi dać informację")
	_expect(not state.decisions.has(&"parallel_test_trace_found"), "Błędne zobowiązanie nie może nadać śladu równoległej próby")
	_expect(_call_bool(station, &"read_incident_report", "Station 17 musi czytać raport"), "S06 musi obserwować raport")
	_expect(_call_bool(station, &"compare_signature_with_card", "Station 17 musi porównywać sygnaturę"), "S06 musi mieć drugi kontekst sygnatury")
	_expect(_call_bool(station, &"listen_intercom_warning", "Station 17 musi wystawiać interkom jako obserwację"), "S06 musi traktować kontakt UCP jako obserwację")
	_expect(_call_bool(station, &"release_service_route", "Station 17 musi zwalniać drogę serwisową"), "S06 musi wymagać fizycznego kroku")
	_expect(_call_bool(station, &"copy_report_header", "Station 17 musi wykonać zobowiązanie"), "S06 musi domknąć jawny zakres kopiowania")
	_expect(state.decisions.get(&"p7.work_history_and_record.report_scope", "") == "minimum_for_test", "Zakres kopiowania musi być jawny i minimalny")
	_expect(state.decisions.get(&"parallel_test_trace_found", false) == true, "S06 musi utrwalić ślad równoległej próby")
	_expect(state.decisions.get(&"p7.work_history_and_record.trace", "") == "institutional_source_and_document_conflict", "S06 musi zostawić źródło instytucjonalne i sprzeczność dokumentów")
	await _close_station(station)


func _test_s07_three_place_proofs(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.work_history_and_record.trace", "institutional_source_and_document_conflict")
	var station := await _open_station(&"station_18")
	if station == null:
		return
	_test_guidance(station, &"station_18")
	_expect(not _call_bool(station, &"compare_independent_registries", "Station 18 musi wystawiać próbę publiczną"), "Próba S07 bez rejestrów musi być odrzucona bezpiecznie")
	_expect(state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "registry_sources_incomplete", "Błędna próba S07 musi dać informację")
	_expect(not state.decisions.has(&"jakub_public_history_verified"), "Błędna próba nie może nadać publicznej historii")
	_expect(_call_bool(station, &"search_municipal_death_registry", "Station 18 musi sprawdzać rejestr miejski"), "S07 musi ustanowić pierwsze źródło publiczne")
	_expect(_call_bool(station, &"search_hospital_registry", "Station 18 musi sprawdzać rejestr szpitalny"), "S07 musi ustanowić drugie źródło publiczne")
	_expect(_call_bool(station, &"verify_employment_card", "Station 18 musi potwierdzać kartę pracowniczą"), "S07 musi mieć materialny identyfikator")
	_expect(_call_bool(station, &"read_disaster_case_file", "Station 18 musi czytać numer sprawy"), "S07 musi mieć numer sprawy katastrofy")
	_expect(_call_bool(station, &"compare_independent_registries", "Station 18 musi wykonać próbę"), "S07 musi rozstrzygnąć hipotezę kopii błędu")
	_expect(state.decisions.get(&"p7.three_place_proofs.public_trial_result", "") == "two_systems_and_nine_years", "Wynik próby publicznej musi być jawny")
	_expect(state.decisions.get(&"jakub_public_history_verified", false) == true, "S07 musi utrwalić publiczną historię po próbie")
	_expect(state.decisions.get(&"recognition_evidence_public", false) == true, "S07 musi utrwalić rodzinę dowodu publicznego")
	await _close_station(station)

	station = await _open_station(&"station_19")
	if station == null:
		return
	_test_guidance(station, &"station_19")
	_expect(not _call_bool(station, &"compare_control_answers", "Station 19 musi wystawiać zestawienie odpowiedzi"), "Próba S07 bez odpowiedzi musi być odrzucona bezpiecznie")
	_expect(state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "control_answers_incomplete", "Błędna próba S07 na 19 musi dać informację")
	_expect(not state.decisions.has(&"jakub_voice_heard"), "Błędna próba nie może nadać kontaktu głosowego")
	_expect(_call_bool(station, &"shield_microphone", "Station 19 musi osłaniać mikrofon"), "S07 musi wymagać fizycznego przygotowania")
	_expect(_call_bool(station, &"prepare_control_questions", "Station 19 musi przygotować pytania"), "S07 musi przygotować pytania przed rozmową")
	_expect(_call_bool(station, &"answer_payphone", "Station 19 musi odebrać połączenie"), "S07 musi otworzyć kontakt")
	_expect(_call_bool(station, &"ask_control_questions", "Station 19 musi zadać oba pytania"), "S07 musi uzyskać dwie odpowiedzi")
	_expect(_call_bool(station, &"disclose_own_theory", "Station 19 musi dopuszczać ujawnienie własnej teorii"), "S07 musi mieć bezpieczną błędną drogę")
	_expect(state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "own_theory_disclosed", "Ujawnienie teorii musi zostawić fakt")
	_expect(_call_bool(station, &"compare_control_answers", "Station 19 musi wykonać zestawienie"), "Bezpieczna błędna droga nie może zablokować poprawnej próby")
	_expect(state.decisions.get(&"p7.three_place_proofs.voice_trial_result", "") == "impostor_and_recording_insufficient", "Wynik próby głosowej musi być jawny")
	_expect(state.decisions.get(&"jakub_voice_heard", false) == true, "S07 musi utrwalić kontakt głosowy po zestawieniu")
	await _close_station(station)

	station = await _open_station(&"station_20")
	if station == null:
		return
	_test_guidance(station, &"station_20")
	_expect(_call_bool(station, &"move_parts_trolley", "Station 20 musi odsuwać wózek"), "S07 musi otworzyć przestrzeń rozmowy")
	_expect(_call_bool(station, &"confirm_marta_presence", "Station 20 musi potwierdzać obecność Marty"), "S07 musi utrzymać świadka")
	_expect(_call_bool(station, &"meet_jakub_face_to_face", "Station 20 musi prowadzić spotkanie"), "S07 musi spotkać Jakuba jako osobę")
	## Jakub jest osobą z rolą dowodu, nie nagrodą: bez przyjętej odmowy nie ma
	## dostępu do jego bazy, a naruszenie granicy jest faktem, nie karą.
	_expect(not _call_bool(station, &"request_voluntary_reader_scan", "Station 20 musi wystawiać prośbę o skan"), "Skan przed przyjęciem odmowy musi być odrzucony bezpiecznie")
	_expect(state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "boundary_not_respected", "Naruszenie granicy musi zostawić fakt")
	_expect(not state.decisions.has(&"jakub_met_as_person"), "Naruszenie granicy nie może nadać dowodu relacyjnego")
	_expect(_call_bool(station, &"accept_scar_refusal", "Station 20 musi przyjmować odmowę"), "S07 musi uszanować granicę Jakuba")
	_expect(state.decisions.get(&"p7.three_place_proofs.scar_refusal_respected", "") == "asked_and_declined", "Odmowa Jakuba musi być jawna w zapisie")
	_expect(_call_bool(station, &"request_voluntary_reader_scan", "Station 20 musi uzyskać dobrowolny skan"), "S07 musi otworzyć bazę po przyjęciu odmowy")
	_expect(_call_bool(station, &"compare_local_service_base", "Station 20 musi wykonać próbę relacyjną"), "S07 musi rozstrzygnąć hipotezę oszusta")
	_expect(state.decisions.get(&"p7.three_place_proofs.relational_trial_result", "") == "reader_absent_local_base", "Wynik próby relacyjnej musi być jawny")
	_expect(state.decisions.get(&"jakub_met_as_person", false) == true, "S07 musi utrwalić Jakuba jako osobę")
	_expect(state.decisions.get(&"recognition_evidence_relational", false) == true, "S07 musi utrwalić rodzinę dowodu relacyjnego")
	_expect(state.decisions.get(&"recognition_evidence_carried", false) == true, "S07 musi utrwalić rodzinę dowodu przywiezionego")
	await _close_station(station)


func _test_recognition_gate(state: Node) -> void:
	## Brama 21: bez trzech rodzin dowodów rozpoznanie nie może powstać, a
	## trzecie ułożenie nie uruchamia syntezy samo z siebie.
	state.reset_campaign(true)
	state.record_decision(&"recognition_evidence_carried", true)
	state.record_decision(&"recognition_evidence_public", true)
	var station := await _open_station(&"station_21")
	if station == null:
		return
	_test_guidance(station, &"station_21")
	_expect(_call_bool(station, &"place_reader_and_sample", "Station 21 musi przyjmować czytnik z próbką"), "Brama 21 musi przyjąć pierwszą rodzinę")
	_expect(_call_bool(station, &"place_public_records", "Station 21 musi przyjmować rejestry publiczne"), "Brama 21 musi przyjąć drugą rodzinę")
	_expect(not _call_bool(station, &"place_relational_record", "Station 21 musi wystawiać pole relacyjne"), "Brak dowodu relacyjnego musi zablokować trzecie pole")
	_expect(state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "relational_evidence_missing", "Brak rodziny dowodu musi dać informację")
	_expect(not _call_bool(station, &"execute_three_family_synthesis", "Station 21 musi wystawiać syntezę"), "Synteza bez trzech rodzin musi być odrzucona bezpiecznie")
	_expect(state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "relational_family_not_placed", "Niekompletna synteza musi nazwać brakujące pole")
	_expect(station.get("is_reader_family_placed") == true and station.get("is_public_family_placed") == true, "Niekompletna synteza nie może usuwać ułożonych źródeł")
	_expect(not state.decisions.has(&"world_recognized"), "world_recognized nie może powstać przed wykonaną syntezą")
	_expect(not state.decisions.has(&"local_lena_search_committed"), "Drugi cel nie może powstać przed wykonaną syntezą")
	_expect(not state.decisions.has(&"mechanic_cost_observed"), "Koszt metody nie może istnieć przed S08")
	_expect(station.get("is_exit_unlocked") == false, "Wyjście 21 nie może otworzyć się bez syntezy")

	## Dowód relacyjny domyka bramę; dopiero jawna synteza nadaje rozpoznanie.
	state.record_decision(&"recognition_evidence_relational", true)
	_expect(_call_bool(station, &"place_relational_record", "Station 21 musi przyjmować zapis serwisowy"), "Brama 21 musi przyjąć trzecią rodzinę")
	_expect(station.get("is_synthesis_done") == false, "Trzecie ułożenie nie może uruchomić syntezy automatycznie")
	_expect(not state.decisions.has(&"world_recognized"), "Samo ułożenie trzech źródeł nie może nadać rozpoznania")
	_expect(_call_bool(station, &"execute_three_family_synthesis", "Station 21 musi wykonać syntezę"), "Jawna synteza musi rozstrzygnąć")
	_expect(state.decisions.get(&"p7.three_place_proofs.synthesis_result", "") == "single_world_explanation_fails", "Wynik syntezy musi być jawny")
	_expect(state.decisions.get(&"world_recognized", false) == true, "Rozpoznanie musi powstać po wykonanej syntezie")
	_expect(state.decisions.get(&"local_lena_search_committed", false) == true, "Drugi cel musi powstać razem z rozpoznaniem")
	_expect(state.decisions.get(&"p7.three_place_proofs.trace", "") == "world_recognized_and_search_committed", "S07 musi zostawić trwały ślad")
	_expect(not state.decisions.has(&"mechanic_cost_observed"), "Station 21 nie może udostępnić kosztu metody")
	_expect(station.get("is_exit_unlocked") == true, "Wyjście 21 musi otworzyć się po syntezie")

	## Kadr: rozpoznanie i drugi cel pojawiają się w warstwie tekstu dopiero po
	## wykonanej próbie, nie przy wejściu do sceny.
	var label := station.get_node_or_null("CrispDiegeticText_Synthesis")
	_expect(label != null, "Station 21 musi mieć napis stołu syntezy")
	if label != null:
		_expect(String(label.get("text")).to_lower().contains("to nie jest mój świat"), "Po syntezie kadr musi pokazać rozpoznanie")
	var corridor := station.get_node_or_null("Props/Station21Exit")
	_expect(corridor != null, "Station 21 musi zachować węzeł Station21Exit")
	if corridor != null:
		_expect(String(corridor.get("prop_subtitle")).to_lower().contains("miejscowej leny"), "Po syntezie korytarz musi nazwać drugi cel")
	await _close_station(station)

	## Ten sam kontrakt przed syntezą: świeża scena nie ujawnia rozpoznania.
	state.reset_campaign(true)
	var fresh := await _open_station(&"station_21")
	if fresh == null:
		return
	var fresh_label := fresh.get_node_or_null("CrispDiegeticText_Synthesis")
	if fresh_label != null:
		_expect(not String(fresh_label.get("text")).to_lower().contains("to nie jest mój świat"), "Przed syntezą kadr nie może ujawniać rozpoznania")
	var fresh_corridor := fresh.get_node_or_null("Props/Station21Exit")
	if fresh_corridor != null:
		_expect(not String(fresh_corridor.get("prop_subtitle")).to_lower().contains("miejscowej leny"), "Przed syntezą korytarz nie może ujawniać drugiego celu")
	_expect(not state.decisions.has(&"world_recognized"), "Wejście do Station 21 nie może nadać rozpoznania")
	await _close_station(fresh)


func _test_s08_entry_after_synthesis(state: Node) -> void:
	## Kanoniczne `world_recognized` bez namespace jest bramą wejściową S08;
	## po syntezie Station 22 musi dać się otworzyć w tym samym przebiegu.
	state.reset_campaign(true)
	state.record_decision(&"recognition_evidence_carried", true)
	state.record_decision(&"recognition_evidence_public", true)
	state.record_decision(&"recognition_evidence_relational", true)
	var station21 := await _open_station(&"station_21")
	if station21 == null:
		return
	_expect(_call_bool(station21, &"place_reader_and_sample", "Station 21 musi przyjmować czytnik z próbką"), "Brama 21 musi przyjąć pierwszą rodzinę")
	_expect(_call_bool(station21, &"place_public_records", "Station 21 musi przyjmować rejestry publiczne"), "Brama 21 musi przyjąć drugą rodzinę")
	_expect(_call_bool(station21, &"place_relational_record", "Station 21 musi przyjmować zapis serwisowy"), "Brama 21 musi przyjąć trzecią rodzinę")
	_expect(_call_bool(station21, &"execute_three_family_synthesis", "Station 21 musi wykonać syntezę"), "Jawna synteza musi rozstrzygnąć")
	await _close_station(station21)
	var station22 := await _open_station(&"station_22")
	if station22 == null:
		return
	_expect(_call_bool(station22, &"observe_signal_echo", "Station 22 musi wystawiać obserwację echa"), "Synteza S07 musi otworzyć wejście S08 bez ręcznej flagi")
	_expect(not state.decisions.has(&"mechanic_cost_observed"), "Wejście do S08 nie może samo nadać kosztu metody")
	await _close_station(station22)


func _test_return_topology() -> void:
	for station_number in range(15, 22):
		var scene_path := "res://scenes/levels/station_%02d.tscn" % station_number
		var scene := load(scene_path) as PackedScene
		_expect(scene != null, "Scena migrowanej stacji musi istnieć: %s" % scene_path)
		if scene == null:
			continue
		var station := scene.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		_expect(station.get_node_or_null("ReturnZone") != null, "%s musi zachować ReturnZone" % scene_path)
		_expect(station.has_signal(&"previous_level_requested"), "%s musi zachować sygnał powrotu" % scene_path)
		_expect(station.get_node_or_null("AirlockZone") != null, "%s musi zachować AirlockZone" % scene_path)
		_expect(station.has_signal(&"level_completed"), "%s musi zachować sygnał ukończenia" % scene_path)
		root.remove_child(station)
		station.free()
		await process_frame


func _test_pre21_vocabulary_gate() -> void:
	for station_number in range(15, 21):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Skrypt migrowanej stacji musi być czytelny: %s" % path)
		if file == null:
			continue
		var source := file.get_as_text().to_lower()
		file.close()
		for term in FORBIDDEN_PRE21_TEXT:
			_expect(not source.contains(term), "%s nie może zawierać przedwczesnego terminu: %s" % [path, term])
		if station_number != 16:
			_expect(not source.contains("mechanic_cost_observed"), "%s nie może uruchamiać kosztu metody przed S08" % path)
	## Station 21 wypowiada rozpoznanie, ale nadal nie zna metody ani jej kosztu.
	var file_21 := FileAccess.open("res://scripts/levels/station_21.gd", FileAccess.READ)
	_expect(file_21 != null, "Skrypt Station 21 musi być czytelny")
	if file_21 != null:
		var source_21 := file_21.get_as_text().to_lower()
		file_21.close()
		_expect(not source_21.contains("mechanic_cost_observed"), "Station 21 nie może uruchamiać kosztu metody")
		_expect(not source_21.contains("anchor/yield"), "Station 21 nie może nazywać świadomego Anchor/Yield")


func _test_clean_cutover() -> void:
	for station_number in range(15, 22):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			_expect(false, "Skrypt migrowanej stacji musi być czytelny: %s" % path)
			continue
		var source := file.get_as_text()
		file.close()
		for token in LEGACY_TOKENS:
			_expect(not source.contains(token), "%s nie może zachować legacy path: %s" % [path, token])
		_expect(source.contains("_complete_if_player_already_in_airlock"), "%s musi domykać scenę przy graczu już w śluzie" % path)
		_expect(source.contains("func _draw_state_layer() -> void:"), "%s musi zachować osobny przebieg stanu" % path)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0147 PASS: P7 S06–S07 diagnostic contracts")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0147 FAILURE: " + failure)
	quit(1)
