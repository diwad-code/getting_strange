extends SceneTree

## PKG-0120 Smoke Test — Station 14..23, Sekwencje IV/V/VI (Marta, UCP, niemożliwy brat i rozpoznanie) według Kanonu 0.3
##
## Weryfikuje:
## 1. Instancjonowanie i determinizm scen Station 14..23 w pętli 60 Hz.
## 2. Brak wywołań draw_string() w Layer 0 — wszystkie napisy w CrispDiegeticText (Layer 10).
## 3. Brak zakazanych pojęć przedwczesnych w dialogu i myślach stacji 14..20.
## 4. Pętle stacji zgodne z Kanonem 0.3:
##    - 14: odłożenie torby, przerwany gest czajnika, dialog z Martą, brak oskarżeń
##    - 15: ta sama wyprawa / dwa skutki, wybór detali, zabezpieczenie telefonu przez Martę
##    - 16: biometria zgodna, numer karty obcy, grafik UCP-4 zatwierdzony przez Wierzbicką
##    - 17: raport incydentu, interkom Wierzbickiej, skopiowany nagłówek, wyjście serwisowe
##    - 18: brak aktu zgonu Jakuba, dziewięć lat wpisów w szpitalu i miejskim rejestrze
##    - 19: telefon od Jakuba, schowek babci vs nieznany tunel, brak upiornych efektów
##    - 20: spotkanie twarzą w twarz, uszanowanie odmowy blizny, skan czytnika nieobecnego w bazie
##    - 21: synteza trzech rodzin dowodów, „To nie jest mój świat.”, flaga world_recognized, zamknięcie 4 hipotez
##    - 22: odrzucenie oferty asymilacji UCP, zapis oscyloskopu, robocze nazwy Zakotwiczenie / Uległość
##    - 23: martwy obwód, zmostkowanie bezpiecznika, fizyczny koszt mechaniki
## 5. Rejestracja i domykanie hipotez w NarrativeGuidanceService.
## 6. Porażka jest kosztem, nie śmiercią — każda stacja liczy stracone podejście i gra dalej.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")

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
	14: "memory_gap",
	15: "hyp_rehearsed_memory",
	16: "hyp_account_tampering",
	18: "hyp_ucp_forgery",
	19: "hyp_impersonation_call",
	21: "hyp_single_world_error",
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
		state.record_decision(&"p7.marta_threshold.recall_requested", true)
	var station := packed.instantiate() as Station14
	root.add_child(station)
	await process_frame
	_expect(station.place_bag_at_door(), "Torba musi zostać odłożona przy drzwiach")
	_expect(station.disclose_arrival_time(), "Godzina przybycia musi zostać podana")
	_expect(station.compare_field_equipment(), "Sprzęt terenowy musi zostać porównany")
	_expect(station.verify_key_position(), "Położenie klucza musi zostać potwierdzone")
	_expect(station.ask_independent_day_description(), "Niezależny opis dnia musi zostać uzyskany")
	_expect(station.get("is_exit_unlocked") == true, "Próg musi zostać otwarty po porównaniu")
	_expect(not station.is_level_completed, "Próg sam nie kończy sceny")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"memory_gap", false),
			"Niezależny opis dnia musi zamknąć hipotezę luki pamięci"
		)
	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 14 PASSED")


func _test_station_15() -> void:
	print("TEST: Station 15 (Ta sama wyprawa, inny skutek)...")
	var packed := load("res://scenes/levels/station_15.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_15.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station15
	root.add_child(station)
	await process_frame

	station.compare_weather()
	station.compare_fence()
	_expect(station.are_details_compared, "Dwa detale wyprawy muszą zamknąć porównanie")

	station.start_expedition_dialogue()
	_expect(station.is_dialogue_active, "Rozmowa o wyprawie musi wystartować")
	for i in range(station.expedition_dialogue_lines.size()):
		station.advance_expedition_dialogue()
	_expect(station.is_dialogue_completed, "Rozmowa o wyprawie musi się zakończyć")
	_expect(station.is_phone_secured_by_marta, "Marta musi zabezpieczyć telefon")

	station.apply_table_setback()
	_expect(station.table_setback_count == 1, "Próba sięgnięcia po telefon musi zostać policzona")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 15 PASSED")


func _test_station_16() -> void:
	print("TEST: Station 16 (Zespół UCP-4)...")
	var packed := load("res://scenes/levels/station_16.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_16.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station16
	root.add_child(station)
	await process_frame

	station.scan_biometrics()
	station.scan_home_card()
	station.read_schedule()
	_expect(station.is_turnstile_unlocked, "Trzy odczyty muszą odblokować kołowrót")

	station.pass_turnstile()

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 16 PASSED")


func _test_station_17() -> void:
	print("TEST: Station 17 (Nie powtarzać próbki)...")
	var packed := load("res://scenes/levels/station_17.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_17.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station17
	root.add_child(station)
	await process_frame

	station.read_incident_report()
	_expect(station.is_report_read, "Raport incydentu musi zostać otwarty")

	for i in range(station.intercom_dialogue_lines.size()):
		station.advance_intercom()
	_expect(station.is_intercom_completed, "Interkom z Wierzbicką musi się zakończyć")

	station.copy_report_header()
	station.pull_vent_lever()
	_expect(station.is_header_copied and station.is_vent_pulled, "Nagłówek musi być skopiowany, a dźwignia wentylacji pociągnięta")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 17 PASSED")


func _test_station_18() -> void:
	print("TEST: Station 18 (Brak aktu zgonu)...")
	var packed := load("res://scenes/levels/station_18.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_18.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station18
	root.add_child(station)
	await process_frame

	station.search_municipal_records()
	station.search_hospital_records()
	station.verify_employment_card()
	station.check_disaster_file()
	_expect(station.are_public_sources_verified, "Cztery odczyty publiczne muszą potwierdzić ciągłość życia Jakuba")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 18 PASSED")


func _test_station_19() -> void:
	print("TEST: Station 19 (Głos)...")
	var packed := load("res://scenes/levels/station_19.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_19.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station19
	root.add_child(station)
	await process_frame

	station.answer_phone()
	_expect(station.is_phone_answered, "Telefon musi zostać odebrany")
	for i in range(station.phone_dialogue_lines.size()):
		station.advance_phone_dialogue()
	_expect(station.is_phone_completed, "Rozmowa telefoniczna z dwoma pytaniami kontrolnymi musi się domknąć")

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
	var station := packed.instantiate() as Station20
	root.add_child(station)
	await process_frame

	station.start_meeting_dialogue()
	_expect(station.is_dialogue_active, "Spotkanie z Jakubem musi się rozpocząć")
	for i in range(station.meeting_dialogue_lines.size()):
		station.advance_meeting_dialogue()
	_expect(station.is_dialogue_completed, "Rozmowa z Jakubem musi się domknąć")
	_expect(station.is_scar_refused, "Jakub musi odmówić pokazania blizny")
	_expect(station.is_reader_diagnosed, "Czytnik Leny musi zostać zdiagnozowany jako nieobecny w lokalnej bazie")

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
	var station := packed.instantiate() as Station21
	root.add_child(station)
	await process_frame

	station.execute_synthesis()
	_expect(not station.is_synthesis_complete, "Synteza bez trzech rodzin dowodów nie może się udać")
	_expect(station.synthesis_setback_count == 1, "Niekompletna próba syntezy musi zostać policzona")

	station.place_reader_evidence()
	station.place_public_evidence()
	_expect(not station.is_synthesis_complete, "Dwa źródła nie mogą uruchomić syntezy")

	station.place_relational_evidence()
	_expect(station.is_synthesis_complete, "Dopiero komplet trzech rodzin dowodów uruchamia syntezę")
	_expect(station.is_dialogue_active, "Dialog syntezy musi ruszyć")

	for i in range(station.synthesis_dialogue_lines.size()):
		station.advance_synthesis_dialogue()

	_expect(station.is_world_recognized, "Synteza musi potwierdzić rozpoznanie obcego świata")
	_expect(station.is_dialogue_completed, "Dialog syntezy musi się zakończyć")

	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(guidance.closed_hypotheses.get(&"hyp_conflicting_records", false), "Station 21 musi zamknąć hyp_conflicting_records")
		_expect(guidance.closed_hypotheses.get(&"hyp_memory_gap", false), "Station 21 musi zamknąć hyp_memory_gap")
		_expect(guidance.closed_hypotheses.get(&"hyp_ucp_forgery", false), "Station 21 musi zamknąć hyp_ucp_forgery")
		_expect(guidance.closed_hypotheses.get(&"hyp_single_world_error", false), "Station 21 musi zamknąć hyp_single_world_error")

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
