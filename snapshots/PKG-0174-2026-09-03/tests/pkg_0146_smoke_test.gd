extends SceneTree

## PKG-0146 contract gate — P7 early diagnostic waves S01–S05 (Station 01–14).
## Tests authored sequence data, safe failed tests, player verbs, vocabulary gates,
## JSON persistence, migration, backtracking topology and clean removal of legacy
## checklist/auto-dialogue completion paths. It proves technical contracts only.

const SEQUENCES: Array[Dictionary] = [
	{
		"id": &"sample_and_promise",
		"resource": "res://resources/gameplay/sample_and_promise_sequence.tres",
		"stations": [&"station_01", &"station_02", &"station_03"],
	},
	{
		"id": &"return_under_control",
		"resource": "res://resources/gameplay/return_under_control_sequence.tres",
		"stations": [&"station_04", &"station_05"],
	},
	{
		"id": &"address_and_record",
		"resource": "res://resources/gameplay/address_and_record_sequence.tres",
		"stations": [&"station_06", &"station_07", &"station_08"],
	},
	{
		"id": &"foreign_daily_life",
		"resource": "res://resources/gameplay/foreign_daily_life_sequence.tres",
		"stations": [&"station_09", &"station_10", &"station_11"],
	},
	{
		"id": &"marta_threshold",
		"resource": "res://resources/gameplay/marta_threshold_sequence.tres",
		"stations": [&"station_12", &"station_13", &"station_14"],
	},
]

const LEGACY_TOKENS: Array[String] = [
	"_check_unlock",
	"_check_completion_condition",
	"_check_threshold_conditions",
	"_complete_procedure",
	"set_campaign_flag",
	"advance_shopkeeper_dialogue",
	"advance_neighbour_dialogue",
	"advance_message",
	"advance_marta_dialogue",
]

const FORBIDDEN_PRE21_TEXT: Array[String] = [
	"inny świat",
	"miejscowa lena",
	"anchor/yield",
	"wierzbicka",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0146 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)
		_test_sequence_resources()
		_test_p7_revision_marking(state)
		_test_early_save_migration(state)
		await _test_s01_sample_and_promise(state)
		await _test_s02_return_under_control(state)
		await _test_s03_address_and_record(state)
		await _test_s04_foreign_daily_life(state)
		await _test_s05_marta_threshold(state)
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
		_expect(int(sequence.get("migration_revision")) == 1, "%s musi deklarować rewizję migracji 1" % sequence_id)
		_expect(String(sequence.get("trace_key")).begins_with("p7.%s." % sequence_id), "%s musi deklarować namespaced ślad" % sequence_id)
		var hypotheses: Array = sequence.get("hypotheses")
		_expect(hypotheses.size() >= 2, "%s musi zawierać co najmniej dwie hipotezy" % sequence_id)
		for hypothesis in hypotheses:
			_expect(hypothesis is Resource, "%s hipoteza musi być Resource" % sequence_id)
			if hypothesis is Resource:
				_expect(not String(hypothesis.get("predicted_outcome")).is_empty(), "%s hipoteza musi przewidywać obserwowalny wynik" % sequence_id)
				_expect(not String(hypothesis.get("trial_result")).is_empty(), "%s hipoteza musi wskazywać wynik próby" % sequence_id)
		var commitments: Array = sequence.get("commitments")
		_expect(not commitments.is_empty(), "%s musi mieć jawne zobowiązanie" % sequence_id)
		for commitment in commitments:
			_expect(commitment is Resource, "%s zobowiązanie musi być Resource" % sequence_id)
			if commitment is Resource:
				_expect(not String(commitment.get("known_cost")).is_empty(), "%s zobowiązanie musi ujawniać koszt" % sequence_id)
				_expect(not String(commitment.get("alternative_route")).is_empty(), "%s zobowiązanie musi wskazywać alternatywę" % sequence_id)
				_expect(not commitment.has_method("get_moral_score"), "%s nie może zawierać moral score" % sequence_id)


func _test_p7_revision_marking(state: Node) -> void:
	state.reset_campaign(true)
	_expect(state.record_decision(&"p7.sample_and_promise.gap_observed", true), "Nowy fakt S01 musi być JSON-safe")
	_expect(int(state.decisions.get(&"p7.sample_and_promise.migration_revision", 0)) == 1, "Zapis S01 musi od razu oznaczyć rewizję migracji")
	_expect(state.save_campaign(), "Stan S01 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Stan S01 musi dać się odczytać")
	_expect(state.decisions.get(&"p7.sample_and_promise.gap_observed", false) == true, "Nowy fakt S01 nie może zostać skasowany jako legacy")


func _test_early_save_migration(state: Node) -> void:
	state.reset_campaign(true)
	state.set_reduced_motion(true, false)
	state.decisions[&"ucp_intervention_reconstructed"] = true
	state.decisions[&"station_06_bus_exit_corrected"] = 2
	state.decisions[&"station_14_mug_broken"] = 1
	state.decisions[&"marta_relationship_disclosed"] = true
	state.set_checkpoint(&"station_13", Vector2(430.0, 240.0))
	_expect(state.save_campaign(), "Legacy checkpoint 01–14 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Legacy checkpoint 01–14 musi dać się odczytać")
	_expect(state.last_checkpoint_station == &"station_12" and state.last_checkpoint_position == Vector2(70.0, 296.0), "Checkpoint S05 musi wrócić do bezpiecznego wejścia Station 12")
	_expect(state.decisions.get(&"ucp_intervention_reconstructed", false) == true, "Migracja S01–S05 musi zachować fakty spoza zakresu")
	_expect(state.is_reduced_motion(), "Migracja S01–S05 nie może zmienić ustawień użytkownika")
	_expect(not state.decisions.has(&"station_06_bus_exit_corrected") and not state.decisions.has(&"station_14_mug_broken"), "Migracja musi usuwać legacy stan stacji")
	_expect(not state.decisions.has(&"marta_relationship_disclosed"), "Legacy dialog nie może nadać nowego stanu relacji P7")
	for spec in SEQUENCES:
		var sequence_id := spec["id"] as StringName
		var revision_key := StringName("p7.%s.migration_revision" % sequence_id)
		_expect(int(state.decisions.get(revision_key, 0)) == 1, "%s musi otrzymać rewizję migracji" % sequence_id)
		var trace_key := StringName("p7.%s.trace" % sequence_id)
		_expect(not state.decisions.has(trace_key), "%s migracja nie może sfabrykować śladu" % sequence_id)
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


func _call_void(station: Node, method_name: StringName, message: String) -> void:
	if station == null or not station.has_method(method_name):
		_expect(false, message)
		return
	station.call(method_name)

func _call_void_with_float(station: Node, method_name: StringName, value: float, message: String) -> void:
	if station == null or not station.has_method(method_name):
		_expect(false, message)
		return
	station.call(method_name, value)


func _test_guidance(station: Node2D, station_id: StringName) -> void:
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	_expect(guidance != null, "%s musi mieć NarrativeGuidanceService" % station_id)
	if guidance == null:
		return
	var tiers: Dictionary = {}
	for beat_id in guidance.active_beats:
		var beat := guidance.active_beats[beat_id] as GuidanceBeat
		if beat != null:
			tiers[beat.tier] = true
	_expect(
		tiers.has(GuidanceBeat.Tier.L0_COMPOSITION)
		and tiers.has(GuidanceBeat.Tier.L1_REACTION)
		and tiers.has(GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT)
		and tiers.has(GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT)
		and tiers.has(GuidanceBeat.Tier.L4_RESCUE_HINT),
		"%s musi rejestrować pełną drabinę L0–L4" % station_id
	)
	var before: Dictionary = (root.get_node("GameStateManager").decisions as Dictionary).duplicate(true)
	for beat_id in guidance.active_beats:
		var beat := guidance.active_beats[beat_id] as GuidanceBeat
		if beat != null and beat.tier == GuidanceBeat.Tier.L4_RESCUE_HINT:
			guidance.trigger_beat(beat_id, true)
			break
	_expect(root.get_node("GameStateManager").decisions == before, "%s L4 nie może wykonać próby ani zobowiązania" % station_id)


func _test_s01_sample_and_promise(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open_station(&"station_01")
	if station == null:
		return
	_expect(not _call_bool(station, &"secure_raw_sample", "Station 01 musi odrzucać próbę zabezpieczenia bez pomiaru"), "Próbka bez pomiaru musi być bezpiecznie odrzucona")
	_expect(state.decisions.get(&"p7.sample_and_promise.safe_trial_feedback", "") == "measurement_required", "Błędna próba S01 musi dać informację")
	_expect(_call_bool(station, &"repeat_line_four_measurement", "Station 01 musi powtórzyć odczyt Linii 4"), "S01 musi wykonać jeden czytelny pomiar")
	_expect(_call_bool(station, &"secure_raw_sample", "Station 01 musi zabezpieczyć próbkę"), "S01 musi wystawiać zobowiązanie ochrony próbki")
	_expect(_call_bool(station, &"read_marta_message", "Station 01 musi odczytać wiadomość Marty"), "S01 musi ustanowić osobisty koszt po pracy")
	await _close_station(station)
	station = await _open_station(&"station_02")
	if station == null:
		return
	_expect(_call_bool(station, &"inspect_detour_closure", "Station 02 musi obserwować realne prace"), "S01 musi dawać czytelny powód obejścia")
	_expect(_call_bool(station, &"compare_detour_time", "Station 02 musi porównywać czas obejścia"), "S01 musi nazwać koszt czasu działaniem")
	_expect(_call_bool(station, &"take_service_ladder", "Station 02 musi użyć drabiny serwisowej"), "S01 musi zakończyć obejście realną architekturą pionową")
	await _close_station(station)
	station = await _open_station(&"station_03")
	if station == null:
		return
	_expect(_call_bool(station, &"read_departure_board", "Station 03 musi obserwować czas odjazdu"), "S01 musi ustanowić niezależny czas dojazdu")
	_expect(_call_bool(station, &"reply_to_marta", "Station 03 musi wystawiać jawną wiadomość do Marty"), "S01 musi odrzucić ukrywanie opóźnienia przez działanie")
	_expect(state.decisions.get(&"p7.sample_and_promise.trace", "") == "sample_preserved_and_time_sent", "S01 musi zostawić próbkę i wiadomość z czasem")
	_expect(state.decisions.get(&"home_sample_preserved", false) == true and state.decisions.get(&"marta_promise_broken", false) == true, "S01 musi utrwalić kanoniczne fakty po wykonanej próbie")
	await _close_station(station)


func _test_s02_return_under_control(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.sample_and_promise.trace", "sample_preserved_and_time_sent")
	var station := await _open_station(&"station_04")
	if station == null:
		return
	_expect(not _call_bool(station, &"stow_reader_for_marta", "Station 04 musi odrzucić schowanie czytnika bez obserwacji"), "S02 bez obserwacji musi dać bezpieczny fakt")
	_expect(state.decisions.get(&"p7.return_under_control.safe_trial_feedback", "") == "memorial_required", "Błędna próba S02 musi dać informację")
	_expect(_call_bool(station, &"observe_reader_buffer", "Station 04 musi obserwować powtórkę czytnika"), "S02 musi obserwować powtórkę")
	_expect(_call_bool(station, &"watch_line_four_memorial", "Station 04 musi obserwować ślad Linii 4"), "S02 musi obserwować niezależny świat za oknem")
	_expect(_call_bool(station, &"stow_reader_for_marta", "Station 04 musi odłożyć czytnik"), "S02 musi zakończyć próbę osobistym zobowiązaniem")
	await _close_station(station)
	station = await _open_station(&"station_05")
	if station == null:
		return
	_expect(_call_bool(station, &"observe_ordinary_street", "Station 05 musi obserwować zwykłą ulicę"), "S02 musi wykonać aktywny oddech Station 05")
	_expect(_call_bool(station, &"secure_reader_state", "Station 05 musi zabezpieczać stan czytnika"), "S02 musi zostawić czytnik do późniejszego porównania")
	_expect(state.decisions.get(&"p7.return_under_control.trace", "") == "reader_secured_without_paranormal_claim", "S02 musi utrwalić powtórkę bez paranormalnej interpretacji")
	_expect(state.decisions.get(&"ordinary_return_complete", false) == true, "S02 musi utrwalić czynny oddech Station 05")
	await _close_station(station)


func _test_s03_address_and_record(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.return_under_control.trace", "reader_secured_without_paranormal_claim")
	var station := await _open_station(&"station_06")
	if station == null:
		return
	_expect(_call_bool(station, &"observe_paper_timetable", "Station 06 musi obserwować rozkład papierowy"), "S03 musi ustanowić źródło papierowe")
	_expect(_call_bool(station, &"observe_offline_route", "Station 06 musi obserwować trasę offline"), "S03 musi ustanowić źródło offline")
	_expect(_call_bool(station, &"compare_public_route", "Station 06 musi porównywać trasę z pojazdem"), "S03 musi wykonać rozstrzygający test publiczny")
	await _close_station(station)
	station = await _open_station(&"station_07")
	if station == null:
		return
	_expect(_call_bool(station, &"ask_shopkeeper_recent_visit", "Station 07 musi wystawiać nieprowadzące pytanie"), "S03 musi uzyskać niezależny kontekst osoby")
	_expect(_call_bool(station, &"inspect_sale_ledger", "Station 07 musi czytać wpis sprzedaży"), "S03 musi sprawdzać odpowiedź sprzedawcy")
	_expect(_call_bool(station, &"commit_ordinary_explanation", "Station 07 musi wystawiać zobowiązanie bez paranormalnej interpretacji"), "S03 musi zachować racjonalną interpretację")
	await _close_station(station)
	station = await _open_station(&"station_08")
	if station == null:
		return
	_expect(_call_bool(station, &"read_certificate", "Station 08 musi czytać dokument"), "S03 musi obserwować dokument")
	_expect(_call_bool(station, &"read_directory", "Station 08 musi czytać listę"), "S03 musi obserwować listę")
	_expect(_call_bool(station, &"test_intercom_recognition", "Station 08 musi testować rozpoznanie domofonu"), "S03 musi odróżnić dokument, ciało i adres działaniem")
	_expect(state.decisions.get(&"p7.address_and_record.trace", "") == "identifiers_agree_and_conflict", "S03 musi zostawić zestaw identyfikatorów")
	_expect(state.decisions.get(&"unease_pattern_started", false) == true, "S03 musi utrwalić pierwszą racjonalizowalną rozbieżność")
	await _close_station(station)


func _test_s04_foreign_daily_life(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.address_and_record.trace", "identifiers_agree_and_conflict")
	var station := await _open_station(&"station_09")
	if station == null:
		return
	_expect(_call_bool(station, &"observe_floor_record", "Station 09 musi obserwować źródło numeracji"), "S04 musi ustanowić źródło administracyjne")
	for _i in 80:
		_call_void_with_float(station, &"push_planter", 1.0, "Station 09 musi zachować R4 ciężar")
		await physics_frame
	_expect(_call_bool(station, &"ask_neighbour_without_leading", "Station 09 musi pytać sąsiadkę nieprowadząco"), "S04 musi mieć drugi kontekst relacyjny")
	await _close_station(station)
	station = await _open_station(&"station_10")
	if station == null:
		return
	_expect(_call_bool(station, &"inspect_key_wear", "Station 10 musi sprawdzać zużycie klucza"), "S04 musi obserwować materiał klucza")
	_expect(_call_bool(station, &"test_key_without_claiming_home", "Station 10 musi testować klucz bez przywłaszczenia biografii"), "S04 musi rozstrzygać hipotezę kluczem")
	_expect(_call_bool(station, &"commit_cautious_entry", "Station 10 musi wystawiać ostrożne wejście"), "S04 musi zobowiązać się do nieprzywłaszczania mieszkania")
	await _close_station(station)
	station = await _open_station(&"station_11")
	if station == null:
		return
	for _i in 100:
		_call_void_with_float(station, &"push_sideboard", 1.0, "Station 11 musi zachować R4 ciężar")
		await physics_frame
	_expect(_call_bool(station, &"inspect_private_photograph", "Station 11 musi obserwować fotografię"), "S04 musi obserwować prywatny materiał")
	_expect(_call_bool(station, &"inspect_equipment_wear", "Station 11 musi obserwować zużycie sprzętu"), "S04 musi sprawdzać ślad ciała")
	_expect(_call_bool(station, &"inspect_reader_arrangement", "Station 11 musi obserwować ustawienie czytnika"), "S04 musi mieć drugi materiałowy kontekst")
	_expect(_call_bool(station, &"compare_private_material", "Station 11 musi porównywać materiał prywatny"), "S04 musi wykonać rozstrzygający test")
	_expect(_call_bool(station, &"respect_private_material", "Station 11 musi wystawiać zobowiązanie prywatności"), "S04 musi zostawić ślad bez przywłaszczenia rzeczy")
	_expect(state.decisions.get(&"p7.foreign_daily_life.trace", "") == "foreign_address_and_photograph", "S04 musi utrwalić obcy adres i fotografię")
	_expect(state.decisions.get(&"local_address_confirmed", false) == true, "S04 musi utrwalić działający adres po teście klucza")
	await _close_station(station)


func _test_s05_marta_threshold(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.foreign_daily_life.trace", "foreign_address_and_photograph")
	var station := await _open_station(&"station_12")
	if station == null:
		return
	_expect(not _call_bool(station, &"listen_to_message", "Station 12 musi wystawiać odsłuch wiadomości"), "S05 bez przygotowania odsłuchu musi dać bezpieczny fakt")
	_expect(state.decisions.get(&"p7.marta_threshold.safe_trial_feedback", "") == "balcony_open", "Błędna próba S05 musi dać fakt bez usuwania wiadomości")
	_expect(_call_bool(station, &"close_balcony", "Station 12 musi domykać balkon"), "S05 musi przygotować uczciwy odsłuch")
	_expect(_call_bool(station, &"listen_to_message", "Station 12 musi odsłuchać Martę"), "S05 musi poznać źródło głosu")
	_expect(_call_bool(station, &"verify_caller_identity", "Station 12 musi sprawdzić numer"), "S05 musi mieć niezależny kontekst głosu")
	_expect(_call_bool(station, &"prepare_independent_questions", "Station 12 musi przygotować pytania"), "S05 musi nie odpowiadać na gorąco")
	await _close_station(station)
	station = await _open_station(&"station_13")
	if station == null:
		return
	_expect(_call_bool(station, &"observe_field_certificate", "Station 13 musi obserwować dokument terenowy"), "S05 musi ustanowić pierwszy dokument")
	_expect(_call_bool(station, &"open_drawer", "Station 13 musi otworzyć szufladę"), "S05 musi udostępnić drugi dokument")
	_expect(_call_bool(station, &"observe_tenancy_contract", "Station 13 musi obserwować umowę"), "S05 musi ustanowić drugi dokument")
	_expect(_call_bool(station, &"verify_document_independence", "Station 13 musi sprawdzić pieczęcie"), "S05 musi weryfikować niezależne wystawienie")
	_expect(_call_bool(station, &"compare_document_versions", "Station 13 musi wykonać próbę dokumentów"), "S05 musi rozstrzygnąć konkurencyjne hipotezy")
	_expect(_call_bool(station, &"request_independent_description", "Station 13 musi prosić Martę o niezależny opis"), "S05 musi przygotować próbę relacyjną")
	await _close_station(station)
	# PKG-0162 P9 migration: Station 14 is the dead-circuit mechanic lesson,
	# not the P7 Marta threshold; the S05 contract follows the new address.
	station = await _open_station(&"station_14")
	if station == null:
		return
	_expect(_call_bool(station, &"observe_machine_cycle", "Station 14 musi utrwalić obserwację cyklu maszyny"), "S05 musi pokazać maszynę pracującą własnym cyklem")
	station.call(&"hold_observed_element")
	station.call(&"run_correction_pulse")
	_expect(bool(station.call(&"is_section_live")), "S05: utrzymany most musi zachować obserwowaną wersję")
	station.call(&"release_observed_element")
	station.call(&"run_correction_pulse")
	_expect(not bool(station.call(&"is_section_live")), "S05: puszczony most musi przejść w wersję B")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.yield_cost_observed", "")) == "dead_section_downstream", "S05 musi zostawić jawny mały koszt w stanie sekcji")
	station.call(&"run_correction_pulse")
	_expect(bool(station.call(&"is_section_live")), "S05: fala bez utrzymania musi bezpiecznie przywrócić wersję A")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.trace", "")) == "two_behaviors_before_named", "S05 musi nazwać metodę dopiero po wykonaniu obu zachowań")
	_expect(String(state.decisions.get(&"p7.marta_threshold.trace", "")) == "dead_circuit_lesson_observed", "S05 musi zostawić dziedziczony ślad wejścia do Station 15")
	_expect(bool(station.get("is_exit_unlocked")), "S05: wyjście otwiera się po obu zachowaniach bez softlocka")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.anchor_held_through_pulse", "")) == "version_maintained_under_wave" and String(state.decisions.get(&"p9.mechanics.dead_circuit.yield_cost_observed", "")) == "dead_section_downstream", "S05 musi utrwalić oba zachowania martwego obwodu po wykonanych testach")
	await _close_station(station)


func _test_pre21_vocabulary_gate() -> void:
	for station_number in range(1, 15):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Skrypt migrowanej stacji musi być czytelny: %s" % path)
		if file == null:
			continue
		var source := file.get_as_text().to_lower()
		file.close()
		for term in FORBIDDEN_PRE21_TEXT:
			_expect(not source.contains(term), "%s nie może zawierać przedwczesnego terminu: %s" % [path, term])
		_expect(not source.contains("mechanic_cost_observed"), "%s nie może uruchamiać kosztu Anchor/Yield przed Station 21" % path)


func _test_clean_cutover() -> void:
	for station_number in range(1, 15):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			_expect(false, "Skrypt migrowanej stacji musi być czytelny: %s" % path)
			continue
		var source := file.get_as_text()
		file.close()
		for token in LEGACY_TOKENS:
			_expect(not source.contains(token), "%s nie może zachować legacy path: %s" % [path, token])
		if station_number >= 2:
			var scene_path := "res://scenes/levels/station_%02d.tscn" % station_number
			var scene := load(scene_path) as PackedScene
			_expect(scene != null, "Scena migrowanej stacji musi istnieć: %s" % scene_path)
			if scene != null:
				var station := scene.instantiate() as Node2D
				root.add_child(station)
				await process_frame
				_expect(station.get_node_or_null("ReturnZone") != null and station.has_signal(&"previous_level_requested"), "%s musi zachować ReturnZone i sygnał powrotu" % scene_path)
				root.remove_child(station)
				station.free()
				await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0146 PASS: P7 S01–S05 diagnostic contracts")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0146 FAILURE: " + failure)
	quit(1)
