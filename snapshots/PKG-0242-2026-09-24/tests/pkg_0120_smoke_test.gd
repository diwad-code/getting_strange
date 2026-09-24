extends SceneTree

## PKG-0120 Smoke Test — Station 14..23, Sekwencje IV/V/VI (Marta, UCP, niemożliwy brat i rozpoznanie) według Kanonu 0.3
##
## Weryfikuje:
## 1. Instancjonowanie i determinizm scen Station 14..23 w pętli 60 Hz.
## 2. Brak wywołań draw_string() w Layer 0 — wszystkie napisy w CrispDiegeticText (Layer 10).
## 3. Brak zakazanych pojęć przedwczesnych w dialogu i myślach stacji 14..20.
## 4. Pętle stacji zgodne z Kanonem 0.3:
##    - 14: odłożenie torby, przerwany gest czajnika, dialog z Martą, brak oskarżeń
##    - 15: odtworzenie logu 20:40, dwa kontrolne impulsy, trzeci z celowym błędem, notatka z warunkiem przerwania (P9 mutual signal test)
##    - 16: bezpieczny analizator, jawny mały koszt i echo domu (P9 BUNDLE-23)
##    - 17: raport incydentu, sygnatura vs karta, interkom jako obserwacja, rygiel wentylacji, minimalny zakres kopiowania (S06)
##    - 18: trzy prognozy, zestawienie zgód i braków, fizyczne method_committed (P9 BUNDLE-25)
##    - 19: osłona mikrofonu, przygotowane pytania, dwa pytania kontrolne, zestawienie odpowiedzi w notesie (S07)
##    - 20: wózek, Marta jako świadek, spotkanie, przyjęta odmowa blizny, dobrowolny skan, próba relacyjna (S07)
##    - 21: trzy ułożone rodziny dowodów i JAWNA synteza; dopiero ona nadaje world_recognized i drugi cel (S07)
##    - 22: odrzucenie oferty asymilacji UCP, zapis oscyloskopu, robocze nazwy Zakotwiczenie / Uległość
##    - 23: martwy obwód, zmostkowanie bezpiecznika, fizyczny koszt mechaniki
## 5. Rejestracja i domykanie hipotez w NarrativeGuidanceService.
## 6. Błędna bezpieczna próba jest informacją, nie śmiercią — zostawia fakt i nie usuwa poszlak.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
## PKG-0242 (R1): reachable post-16 state and the real 17/18 conversations.
const CampaignChain := preload("res://tests/support/campaign_chain.gd")

const STATION_NUMBERS := [14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
const EARLY_STATION_NUMBERS := [14, 15, 16, 17, 18, 19, 20]

## Kanon 0.3 zabrania nazywania drugiego świata i procedur zanim Lena dokona syntezy w Station 21.
const FORBIDDEN_EARLY_TERMS := [
	"rówień",
	"drugi świat",
	"duplikat",
	"inna linia czasowa",
	"alternatywna lena",
	"miejscowa lena",
	"podstruktura",
]

## Hipotezy wymagane przez pakiet dla poszczególnych stacji.
const REQUIRED_HYPOTHESES := {
	14: "dead_circuit",
	15: "living_response",
	16: "small_cost",
	17: "cheap_adaptation",
	18: "single_route_sufficient",
	19: "impostor",
	20: "impostor",
	21: "consistent_foreign_continuity",
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("BŁĄD PKG-0120: %s" % message)


func _run_all_tests() -> void:
	print("== PKG-0120 Station 14-23 Canon 0.3 Gate ==")

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	_test_no_draw_string_in_layer_zero()
	_test_knowledge_lint()
	_test_obstacle_headers()
	await _test_pixel_stage_composition()
	await _test_station_14()
	await _test_station_15()
	await _test_station_16()
	await _test_station_17()
	await _test_station_18()
	await _test_station_19()
	await _test_station_20()
	await _test_station_21()
	await _test_station_22()
	await _test_station_23()
	_test_campaign_chain(state)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	_print_summary()


func _print_summary() -> void:
	if _failures.is_empty():
		print("PKG-0120 PASS: Station 14-23 Canon 0.3, Pixel-Stage, guidance i rozpoznanie zweryfikowane")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0120 FAILURE: " + failure)
		quit(1)


func _read_station_source(station_number: int) -> String:
	var path := "res://scripts/levels/station_%02d.gd" % station_number
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_expect(false, "Skrypt stacji musi być czytelny: %s" % path)
		return ""
	var content := file.get_as_text()
	file.close()
	return content


func _test_no_draw_string_in_layer_zero() -> void:
	print("TEST: brak draw_string() w Layer 0 dla stacji 14..23...")
	for station_number in STATION_NUMBERS:
		var source := _read_station_source(station_number)
		_expect(
			not source.contains("draw_string("),
			"Station %02d nie może rysować tekstu przez draw_string() w Layer 0" % station_number
		)


func _test_knowledge_lint() -> void:
	print("TEST: lint wiedzy w stacjach 14..20 (zakaz przedwczesnych pojęć)...")
	for station_number in EARLY_STATION_NUMBERS:
		var source := _read_station_source(station_number).to_lower()
		for term in FORBIDDEN_EARLY_TERMS:
			_expect(
				not source.contains(term),
				"Station %02d zawiera przedwczesny termin: '%s'" % [station_number, term]
			)


func _test_obstacle_headers() -> void:
	print("TEST: nagłówki trzech pytań o przeszkodę dla stacji 14..23...")
	for station_number in STATION_NUMBERS:
		var source := _read_station_source(station_number)
		for question in ["dlaczego to tu jest", "czego wymaga od Leny", "koszt porażki"]:
			_expect(
				source.contains("## PRZESZKODA — " + question),
				"Station %02d nie ma nagłówka przeszkody '%s'" % [station_number, question]
			)


func _test_pixel_stage_composition() -> void:
	print("TEST: architektura Pixel-Stage w scenach 14..23...")
	for station_number in STATION_NUMBERS:
		var path := "res://scenes/levels/station_%02d.tscn" % station_number
		var packed := load(path) as PackedScene
		_expect(packed != null, "Scena %s musi się wczytać" % path)
		if packed == null:
			continue

		var station: Node2D = packed.instantiate()
		root.add_child(station)
		await process_frame

		_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_%02d musi mieć WorldPixelCompositor" % station_number)
		_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_%02d musi mieć NarrativeGuidanceService" % station_number)
		_expect(station.get_node_or_null("InnerThoughtSurface") != null, "station_%02d musi mieć InnerThoughtSurface" % station_number)
		_expect(station.get_node_or_null("CRTDialogueBox") != null, "station_%02d musi mieć CRTDialogueBox" % station_number)
		_expect(station.get_node_or_null("Player") is PrototypePlayer, "station_%02d musi mieć instancję Leny" % station_number)
		_expect(station.has_signal(&"level_completed"), "station_%02d musi zgłaszać level_completed" % station_number)

		var compositor := station.get_node_or_null("WorldPixelCompositor") as CanvasLayer
		if compositor:
			_expect(compositor.layer == 5, "WorldPixelCompositor stacji %02d musi renderować w Layer 5" % station_number)

		var crisp_found := false
		for child in station.get_children():
			if child is CrispDiegeticText:
				crisp_found = true
				var layer := child.get_node_or_null("CrispDiegeticLayer") as CanvasLayer
				_expect(layer != null and layer.layer == 10, "Napis diegetyczny stacji %02d musi być w Layer 10" % station_number)
		_expect(crisp_found, "station_%02d musi mieć co najmniej jeden napis CrispDiegeticText" % station_number)

		var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
		if guidance and REQUIRED_HYPOTHESES.has(station_number):
			var hypothesis := StringName(REQUIRED_HYPOTHESES[station_number])
			var found := false
			for beat_id in guidance.active_beats:
				var beat = guidance.active_beats[beat_id]
				if beat.hypothesis_id == hypothesis:
					found = true
					_expect(not beat.predicted_check.is_empty(), "Omylna myśl %s musi przewidywać sprawdzalny test" % String(beat_id))
					_expect(beat.thought_kind == &"interpretation", "Hipoteza %s musi być interpretacją, nie faktem" % String(hypothesis))
					_expect(beat.cooldown_s >= 8.0, "Cooldown myśli %s musi wynosić >= 8s" % String(beat_id))
			_expect(found, "station_%02d musi rejestrować hipotezę %s" % [station_number, String(hypothesis)])

		for frame in range(6):
			await physics_frame
		_expect(station.get("is_level_completed") == false, "station_%02d nie może kończyć się samoczynnie" % station_number)

		station.queue_free()
		for frame in range(2):
			await process_frame


func _test_station_14() -> void:
	print("TEST: Station 14 (Próg Marty)...")
	var packed := load("res://scenes/levels/station_14.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_14.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
	var station := packed.instantiate() as Station14
	root.add_child(station)
	await process_frame
	_expect(station.is_section_live(), "Stan neutralny musi utrzymać żywą sekcję")
	station.hold_observed_element()
	station.run_correction_pulse()
	_expect(station.is_section_live(), "Utrzymany most musi zachować wersję A")
	_expect(not station.is_level_completed, "Lekcja sama nie kończy sceny")
	station.release_observed_element()
	station.run_correction_pulse()
	_expect(not station.is_section_live(), "Puszczony most musi przejść w wersję B z kosztem sekcji")
	station.release_observed_element()
	station.run_correction_pulse()
	_expect(station.is_section_live(), "Fala bez utrzymania musi bezpiecznie przywrócić wersję A")
	_expect(station.get("is_exit_unlocked") == true, "Wyjście otwiera się po wykonaniu obu zachowań")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"dead_circuit", false),
			"Wykonanie obu zachowań musi zamknąć hipotezę martwego obwodu"
		)
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 14 PASSED")


func _reset_with(state: Node, facts: Dictionary) -> void:
	if state == null:
		return
	state.reset_campaign(true)
	for key in facts:
		state.record_decision(StringName(key), facts[key])


func _test_station_15() -> void:
	print("TEST: Station 15 (Próba wzajemnego sygnału, P9 BUNDLE-22)...")
	var packed := load("res://scenes/levels/station_15.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_15.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	_reset_with(state, {"p7.marta_threshold.trace": "dead_circuit_lesson_observed"})
	var station := packed.instantiate() as Station15
	root.add_child(station)
	await process_frame
	_expect(not station.send_corrective_impulse(), "Impuls z celowym błędem bez dwóch kontroli musi pozostać bezpieczny")
	if state:
		_expect(
			state.decisions.get(&"p9.mechanics.mutual_signal.safe_trial_feedback", "") == "controls_incomplete",
			"Błędna bezpieczna próba musi zostawić fakt"
		)
	_expect(not state.decisions.has(&"local_lena_signal_confirmed"), "Odrzucona próba nie może nadać sygnału")
	_expect(station.observe_signal_log(), "Log 20:40 musi zostać odtworzony")
	if state:
		_expect(state.decisions.get(&"ucp_intervention_reconstructed", false) == true, "Motyw UCP musi powstać z logu")
	_expect(station.send_control_impulse(), "Pierwszy impuls kontrolny musi wyjść")
	station.run_response_cycle()
	_expect(station.send_control_impulse(), "Drugi impuls kontrolny musi wyjść")
	station.run_response_cycle()
	if state:
		_expect(state.decisions.get(&"p9.mechanics.mutual_signal.control_echo_observed", "") == "echo_repeats_identically", "Kontrolne echo musi wrócić identyczne")
	_expect(station.send_corrective_impulse(), "Trzeci impuls z celowym błędem musi wyjść")
	station.run_response_cycle()
	if state:
		_expect(state.decisions.get(&"p9.mechanics.mutual_signal.corrective_response_observed", "") == "deliberate_error_corrected_selectively", "Selektywna korekta musi być jawnym wynikiem")
		_expect(state.decisions.get(&"local_lena_signal_confirmed", false) == true, "Potwierdzenie sygnału musi być kanoniczne")
	_expect(not station.get("is_level_completed"), "Potwierdzenie sygnału samo nie kończy sceny")
	_expect(station.read_abort_note(), "Notatka z warunkiem przerwania musi być odczytana")
	if state:
		_expect(state.decisions.get(&"local_lena_intent_found", false) == true, "Zamiar musi być kanoniczny po notatce")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"living_response", false),
			"Wykonany protokół musi zamknąć hipotezę żywej odpowiedzi"
		)
	_expect(station.get("is_exit_unlocked") == true, "Wyjście musi się otworzyć po odczycie notatki")
	_expect(not station.is_level_completed, "Odczyt notatki sam nie kończy sceny")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 15 PASSED")


func _test_station_16() -> void:
	print("TEST: Station 16 (bezpieczny analizator i mały koszt)...")
	var packed := load("res://scenes/levels/station_16.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_16.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	_reset_with(state, {"p7.work_history_and_record.own_record_requested": true})
	var station := packed.instantiate() as Station16
	root.add_child(station)
	await process_frame
	_expect(not station.confirm_home_echo(), "Echo bez wyboru kosztu musi pozostać bezpieczne")
	_expect(not station.choose_marta_memory_cost(), "Koszt bez odpowiedzi musi pozostać bezpieczny")
	_expect(station.transfer_response_to_safe_analyzer(), "Odpowiedź musi zostać przekazana do analizatora")
	_expect(station.choose_marta_memory_cost(), "Wybór kosztu pamięci Marty musi zostać wykonany")
	_expect(station.confirm_home_echo(), "Echo domu musi zostać potwierdzone po koszcie")
	if state:
		_expect(state.decisions.get(&"small_cost_manifested", "") == "marta_first_meeting_detail_blurred", "Koszt pamięci Marty musi być kanoniczny")
		_expect(state.decisions.get(&"home_echo_verified", false) == true, "Echo domu musi być kanoniczne")
		_expect(state.decisions.get(&"mechanic_cost_observed", false) == true, "Koszt metody musi powstać po wykonanej próbie")
		_expect(state.decisions.get(&"p7.work_history_and_record.institution_trial_result", "") == "small_cost_and_home_echo_confirmed", "Station 16 musi przekazać ślad do Station 17")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(guidance.closed_hypotheses.get(&"small_cost", false), "Wykonana próba musi zamknąć hipotezę małego kosztu")
	_expect(station.get("is_exit_unlocked") == true, "Odbiornik musi zwolnić wyjście po próbie")
	_expect(not station.is_level_completed, "Próba sama nie kończy sceny")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 16 PASSED")


func _test_station_17() -> void:
	print("TEST: Station 17 (Rejestr par kosztów i jawny zakres zgody)...")
	var packed := load("res://scenes/levels/station_17.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_17.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	if state:
		CampaignChain.seed_before_17(state)
	var station := packed.instantiate() as Station17
	root.add_child(station)
	await process_frame
	_expect(not station.reject_adaptation_offer(), "Oferta przed odczytem rejestru musi pozostać bezpieczna")
	_expect(station.read_cost_ledger(), "Rejestr par Linii 4 musi zostać odczytany")
	_expect(station.reject_adaptation_offer(), "Oferta adaptacji musi zostać odrzucona")
	# PKG-0239: prośba otwiera rozmowę; zakres zapisuje jej zakończenie.
	_expect(station.record_jakub_consent_refused(), "Prośba o podłączenie musi otworzyć rozmowę")
	station._on_narrative_dialogue_finished("consent_scope_desk")
	_expect(station.is_consent_scope_recorded, "Odmowa zakresu musi być zapisem jak każda wartość")
	if state:
		_expect(state.decisions.get(&"ucp_cost_ledger_found", false) == true, "Rejestr par Linii 4 musi być kanoniczny")
		_expect(state.decisions.get(&"jakub_consent_state", "") == "refused", "Stan zgody Jakuba musi być jawny")
		_expect(state.decisions.get(&"p9.consent_and_cost.jakub_consent_scope", "") == "refused", "Namespaced zakres zgody musi być zapisany")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(guidance.closed_hypotheses.get(&"cheap_adaptation", false), "Wykonane odrzucenie musi zamknąć hipotezę taniej adaptacji")
	_expect(station.get("is_exit_unlocked") == true, "Jawny zakres zgody musi otworzyć wyjście")
	_expect(not station.is_level_completed, "Zapis zakresu sam nie kończy sceny")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 17 PASSED")


func _test_station_18() -> void:
	print("TEST: Station 18 (Trzy prognozy i method_committed)...")
	var packed := load("res://scenes/levels/station_18.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_18.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	if state:
		CampaignChain.seed_before_17(state)
	_expect(await CampaignChain.record_scope(self, "limited"), "Zakres ograniczony musi zostać zapisany w 17")
	var station := packed.instantiate() as Station18
	root.add_child(station)
	await process_frame
	_expect(station.compare_forecast_consent_dependencies(), "Trzy prognozy muszą zostać zestawione")
	_expect(station.disclose_marta_truth_partial(), "Rozmowa o części prawdy musi się otworzyć")
	station._on_narrative_dialogue_finished("marta_truth_table")
	_expect(station.is_marta_truth_disclosed, "Częściowa prawda Marty musi zostać zapisana")
	# PKG-0239: wskazanie → odpowiedź Jakuba w 17 → zatwierdzenie.
	var player := station.get_node("Player") as Node2D
	player.global_position.x = (station.get_node("Props/MethodCommitPost") as Node2D).global_position.x
	await physics_frame
	_expect(station.choose_method_from_player_side(), "Słupek musi wskazać odzyskanie")
	station.queue_free()
	for frame in range(3):
		await process_frame
	_expect(await CampaignChain.answer_method(self, "accepted"), "Jakub musi odpowiedzieć na wskazaną metodę")
	station = packed.instantiate() as Station18
	root.add_child(station)
	await process_frame
	_expect(station.commit_close_equal(), "Metoda musi zostać zatwierdzona po zestawieniu")
	if state:
		_expect(state.decisions.get(&"route_hypotheses_mapped", false) == true, "Zestawienie prognoz musi być kanoniczne")
		_expect(state.decisions.get(&"marta_truth_state", "") == "partial", "Stan prawdy Marty musi być jawny")
		_expect(state.decisions.get(&"method_committed", "") == "close_equal_recover_local", "Zatwierdzona metoda musi być kanoniczna")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(guidance.closed_hypotheses.get(&"single_route_sufficient", false), "Zestawienie musi zamknąć hipotezę jednej drogi")
	_expect(station.get("is_exit_unlocked") == true, "Wyjście musi się otworzyć po zatwierdzeniu metody")
	_expect(not station.is_level_completed, "Zatwierdzenie samo nie kończy sceny")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 18 PASSED")


func _test_station_19() -> void:
	print("TEST: Station 19 (Dwa pytania kontrolne)...")
	var packed := load("res://scenes/levels/station_19.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_19.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	_reset_with(state, {"p7.three_place_proofs.public_trial_result": "two_systems_and_nine_years"})
	var station := packed.instantiate() as Station19
	root.add_child(station)
	await process_frame
	_expect(station.shield_microphone(), "Panel osłonowy musi wytłumić magistralę")
	_expect(station.prepare_control_questions(), "Pytania kontrolne muszą zostać przygotowane")
	_expect(station.answer_payphone(), "Połączenie musi zostać odebrane")
	_expect(station.ask_control_questions(), "Oba pytania kontrolne muszą zostać zadane")
	_expect(station.compare_control_answers(), "Zestawienie odpowiedzi musi rozstrzygnąć")
	if state:
		_expect(state.decisions.get(&"jakub_voice_heard", false) == true, "Kontakt głosowy musi powstać po zestawieniu")
		_expect(
			state.decisions.get(&"p7.three_place_proofs.voice_trial_result", "") == "impostor_and_recording_insufficient",
			"Wynik próby głosowej musi być jawny"
		)
	_expect(station.get("is_exit_unlocked") == true, "Wyjście musi się otworzyć po próbie głosowej")
	_expect(not station.is_level_completed, "Rozmowa sama nie kończy sceny")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 19 PASSED")


func _test_station_20() -> void:
	print("TEST: Station 20 (Człowiek po tej dacie)...")
	var packed := load("res://scenes/levels/station_20.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_20.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	_reset_with(state, {"p7.three_place_proofs.voice_trial_result": "impostor_and_recording_insufficient"})
	var station := packed.instantiate() as Station20
	root.add_child(station)
	await process_frame
	_expect(station.move_parts_trolley(), "Wózek musi otworzyć przestrzeń rozmowy")
	_expect(station.confirm_marta_presence(), "Marta musi być obecna jako świadek")
	_expect(station.meet_jakub_face_to_face(), "Spotkanie twarzą w twarz musi się odbyć")
	_expect(not station.request_voluntary_reader_scan(), "Skan przed przyjęciem odmowy musi pozostać bezpieczny")
	_expect(station.accept_scar_refusal(), "Odmowa pokazania blizny musi zostać przyjęta")
	_expect(station.request_voluntary_reader_scan(), "Jakub musi sam udostępnić bazę serwisową")
	_expect(station.compare_local_service_base(), "Próba relacyjna musi rozstrzygnąć")
	if state:
		_expect(state.decisions.get(&"jakub_met_as_person", false) == true, "Jakub musi zostać utrwalony jako osoba")
		_expect(state.decisions.get(&"recognition_evidence_relational", false) == true, "Dowód relacyjny musi zostać utrwalony")
		_expect(state.decisions.get(&"recognition_evidence_carried", false) == true, "Dowód przywieziony musi zostać utrwalony")
		_expect(state.decisions.get(&"p7.three_place_proofs.scar_refusal_respected", "") == "asked_and_declined", "Granica Jakuba musi być jawna w zapisie")
	_expect(station.get("is_exit_unlocked") == true, "Wyjście musi się otworzyć po próbie relacyjnej")
	_expect(not station.is_level_completed, "Rozmowa sama nie kończy sceny")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 20 PASSED")


func _test_station_21() -> void:
	print("TEST: Station 21 (Trzy źródła / Rozpoznanie)...")
	var packed := load("res://scenes/levels/station_21.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_21.tscn musi istnieć")
		return
	var state := root.get_node_or_null("GameStateManager")
	_reset_with(state, {
		"recognition_evidence_carried": true,
		"recognition_evidence_public": true,
		"recognition_evidence_relational": true,
	})
	var station := packed.instantiate() as Station21
	root.add_child(station)
	await process_frame
	_expect(not station.execute_three_family_synthesis(), "Synteza bez trzech rodzin dowodów nie może się udać")
	if state:
		_expect(not state.decisions.has(&"world_recognized"), "Rozpoznanie nie może powstać przed wykonaną syntezą")
	_expect(station.place_reader_and_sample(), "Czytnik z próbką musi zostać ułożony")
	_expect(station.place_public_records(), "Rejestry publiczne muszą zostać ułożone")
	_expect(not station.get("is_synthesis_done"), "Dwa źródła nie mogą uruchomić syntezy")
	_expect(station.place_relational_record(), "Zapis serwisowy musi zostać ułożony")
	_expect(not station.get("is_synthesis_done"), "Trzecie ułożenie nie może uruchomić syntezy automatycznie")
	_expect(station.execute_three_family_synthesis(), "Jawna synteza musi rozstrzygnąć")
	_expect(station.is_world_recognized, "Synteza musi potwierdzić rozpoznanie")
	_expect(station.get("is_local_search_committed") == true, "Drugi cel musi zostać przyjęty razem z rozpoznaniem")
	if state:
		_expect(state.decisions.get(&"world_recognized", false) == true, "world_recognized musi powstać po syntezie")
		_expect(state.decisions.get(&"local_lena_search_committed", false) == true, "Drugi cel musi być trwały")
		_expect(not state.decisions.has(&"mechanic_cost_observed"), "Station 21 nie może udostępnić kosztu metody")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(guidance.closed_hypotheses.get(&"consistent_foreign_continuity", false), "Station 21 musi zamknąć hipotezę obcej ciągłości")
	_expect(station.get("is_exit_unlocked") == true, "Wyjście musi się otworzyć po syntezie")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 21 PASSED")


func _test_station_22() -> void:
	print("TEST: Station 22 (Odchylenie w rejestrze / dwie hipotezy)...")
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_22.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_22.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station22
	root.add_child(station)
	await process_frame
	_expect(not station.observe_signal_echo(), "Station 22 nie może interpretować sygnału przed world_recognized")
	if state:
		state.record_decision(&"world_recognized", true)
	station.observe_signal_echo()
	station.observe_adjacent_state()
	_expect(station.is_hypotheses_opened, "Dwa zachowania sygnału muszą otworzyć hipotezy")
	if state:
		_expect(state.decisions.has(&"p7.mutual_test.signal_echo_observed"), "Echo sygnału musi zostać zapisane namespaced")
		_expect(state.decisions.has(&"p7.mutual_test.adjacent_state_observed"), "Odpowiedź sąsiednia musi zostać zapisana namespaced")
		_expect(not state.decisions.has(&"mechanic_cost_observed"), "Station 22 nie może ustawić kosztu metody")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 22 PASSED")


func _test_station_23() -> void:
	print("TEST: Station 23 (Martwy obwód / próba A-B)...")
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_23.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_23.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station23
	root.add_child(station)
	await process_frame
	_expect(not station.perform_anchor_trial(), "Niekompletna próba musi pozostać bezpieczna")
	if state:
		_expect(state.decisions.get(&"p7.mutual_test.safe_trial_feedback", "") == "comparison_incomplete", "Błędna próba musi zostawić fakt")
		state.record_decision(&"world_recognized", true)
		state.record_decision(&"p7.mutual_test.signal_echo_observed", true)
		state.record_decision(&"p7.mutual_test.adjacent_state_observed", true)
	_expect(station.perform_anchor_trial(), "Anchor musi przejść przez rzeczywistą próbę")
	_expect(station.perform_yield_trial(), "Yield musi przejść przez rzeczywistą próbę")
	if state:
		_expect(state.decisions.has(&"mechanic_cost_observed"), "Koszt mechaniki musi powstać po próbie")
		_expect(state.decisions.get(&"p7.mutual_test.dead_circuit_outcome", "") == "yield", "Ostatnia próba Yield musi mieć własny wynik")
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 23 PASSED")




func _test_campaign_chain(state: Node) -> void:
	print("TEST: łańcuch kampanii 14..24...")
	if state == null:
		return
	state.reset_campaign(true)
	for station_number in range(1, 24):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_24"), "Ukończenie stacji 23 musi odblokować stację 24")
