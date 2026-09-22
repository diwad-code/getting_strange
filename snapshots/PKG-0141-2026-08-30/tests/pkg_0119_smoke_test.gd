extends SceneTree

## PKG-0119 Smoke Test — Station 08..13, Sekwencja II/III (Rysa i cudzy dom) według Kanonu 0.3
##
## Weryfikuje:
## 1. Instancjonowanie i determinizm scen Station 08..13 w pętli 60 Hz.
## 2. Brak wywołań draw_string() w Layer 0 — wszystkie napisy w CrispDiegeticText (Layer 10).
## 3. Brak zakazanych pojęć przedwczesnych w dialogu i myślach 08..13.
## 4. Pętle stacji zgodne z Kanonem 0.3:
##    - 08: dokument vs lista lokatorów vs własny kod, drzwi bloku
##    - 09: sąsiadka wita naturalnie, dwunastka piętro niżej, donica na biegu schodów
##    - 10: klucz pasuje, torba przy drzwiach, brak odruchowego wejścia
##    - 11: fotografia Leny i Marty, dowody domowe, komoda w przedpokoju
##    - 12: domknięty balkon, całe nagranie Marty, dwa zapisane pytania
##    - 13: para dokumentów, szuflada, prośba o spotkanie
## 5. Rejestracja i domykanie hipotez w NarrativeGuidanceService.
## 6. Porażka jest kosztem, nie śmiercią — każda stacja liczy stracone podejście i gra dalej.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")

const STATION_NUMBERS := [8, 9, 10, 11, 12, 13]

## Kanon 0.3 zabrania nazywania drugiego świata i procedur zanim Lena je pozna.
const FORBIDDEN_EARLY_TERMS := [
	"rówień",
	"drugi świat",
	"duplikat",
	"inna linia czasowa",
	"alternatywna lena",
	"miejscowa lena",
	"podstruktura",
]

## Hipotezy wymagane przez pakiet, po jednej na stację.
const REQUIRED_HYPOTHESES := {
	8: "hyp_address_shift",
	9: "hyp_neighbor_confusion",
	10: "hyp_lock_coincidence",
	11: "hyp_identity_theft",
	12: "hyp_memory_gap",
	13: "hyp_conflicting_records",
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("BŁĄD PKG-0119: %s" % message)


func _run_all_tests() -> void:
	print("== PKG-0119 Station 08-13 Canon 0.3 Gate ==")

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	_test_no_draw_string_in_layer_zero()
	_test_knowledge_lint()
	_test_obstacle_headers()
	await _test_pixel_stage_composition()
	await _test_station_08()
	await _test_station_09()
	await _test_station_10()
	await _test_station_11()
	await _test_station_12()
	await _test_station_13()
	_test_campaign_chain(state)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	_print_summary()


func _print_summary() -> void:
	if _failures.is_empty():
		print("PKG-0119 PASS: Station 08-13 Canon 0.3, Pixel-Stage, guidance i hipotezy zweryfikowane")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0119 FAILURE: " + failure)
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
	print("TEST: brak draw_string() w Layer 0 dla stacji 08..13...")
	for station_number in STATION_NUMBERS:
		var source := _read_station_source(station_number)
		_expect(
			not source.contains("draw_string("),
			"Station %02d nie może rysować tekstu przez draw_string() w Layer 0" % station_number
		)


func _test_knowledge_lint() -> void:
	print("TEST: lint wiedzy Sekwencji II/III...")
	for station_number in STATION_NUMBERS:
		var source := _read_station_source(station_number).to_lower()
		for term in FORBIDDEN_EARLY_TERMS:
			_expect(
				not source.contains(term),
				"Station %02d zawiera przedwczesny termin: '%s'" % [station_number, term]
			)


func _test_obstacle_headers() -> void:
	print("TEST: nagłówki trzech pytań o przeszkodę...")
	for station_number in STATION_NUMBERS:
		var source := _read_station_source(station_number)
		for question in ["dlaczego to tu jest", "czego wymaga od Leny", "koszt porażki"]:
			_expect(
				source.contains("## PRZESZKODA — " + question),
				"Station %02d nie ma nagłówka przeszkody '%s'" % [station_number, question]
			)


func _test_pixel_stage_composition() -> void:
	print("TEST: architektura Pixel-Stage w scenach 08..13...")
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
		if guidance:
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

		## Determinizm: stacja musi przetrwać kilka klatek fizyki bez zmiany stanu ukończenia.
		for frame in range(6):
			await physics_frame
		_expect(station.get("is_level_completed") == false, "station_%02d nie może kończyć się samoczynnie" % station_number)

		station.queue_free()
		for frame in range(2):
			await process_frame


func _test_station_08() -> void:
	print("TEST: Station 08 (Numer czternaście)...")
	var packed := load("res://scenes/levels/station_08.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_08.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station08
	root.add_child(station)
	await process_frame

	_expect(station.get_node_or_null("Geometry/BuildingEntranceDoor") is AnimatableBody2D, "Station 08 musi mieć drzwi wejściowe jako ciało fizyczne")

	station.apply_entry_setback()
	_expect(station.entry_attempt_count == 1, "Szarpnięcie klamki musi zostać policzone")
	_expect(station.directory_entry_faded, "Nieudane wejście musi zabrać szczegół listy lokatorów")
	_expect(not station.is_level_completed, "Nieudane wejście nie może kończyć sceny")

	station.read_certificate()
	station.read_directory()
	_expect(not station.is_entry_verified, "Dwa źródła nie wystarczą do wejścia")
	station.use_keypad()
	_expect(station.is_entry_verified, "Dokument, lista i kod muszą potwierdzić wejście")
	_expect(station.is_door_open, "Potwierdzone wejście musi otworzyć drzwi bloku")

	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(guidance.active_beats.has(&"s08_numbers_swapped"), "Station 08 musi mieć myśl o przełożonych numerach")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 08 PASSED")


func _test_station_09() -> void:
	print("TEST: Station 09 (Sąsiadka z trzeciego)...")
	var packed := load("res://scenes/levels/station_09.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_09.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station09
	root.add_child(station)
	await process_frame

	_expect(station.get_node_or_null("Geometry/StairwellPlanter") is MovableAnchorableProp, "Station 09 musi mieć donicę jako przesuwalny rekwizyt")

	station.start_neighbour_dialogue()
	_expect(station.neighbour_dialogue_active, "Dialog z sąsiadką musi się rozpocząć")
	_expect(String(station.neighbour_dialogue_lines[0]["text"]).contains("Dobry wieczór, Lena"), "Sąsiadka musi przywitać Lenę naturalnie")

	var has_twelve_line := false
	var has_fourteen_line := false
	for line in station.neighbour_dialogue_lines:
		var text := String(line["text"])
		if text.contains("piętro niżej"):
			has_twelve_line = true
		if text.contains("czternast"):
			has_fourteen_line = true
	_expect(has_twelve_line, "Sąsiadka musi wskazać dwunastkę piętro niżej")
	_expect(has_fourteen_line, "Sąsiadka musi przypisać Lenę do czternastki")

	for step in range(12):
		if not station.neighbour_dialogue_active:
			break
		station.advance_neighbour_dialogue()
	_expect(station.is_neighbour_dialogue_completed, "Dialog z sąsiadką musi się domknąć")

	station.apply_planter_setback()
	_expect(station.planter_setback_count == 1, "Przewrócona donica musi zostać policzona")
	_expect(not station.is_level_completed, "Przewrócona donica nie może kończyć sceny")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 09 PASSED")


func _test_station_10() -> void:
	print("TEST: Station 10 (Klucz)...")
	var packed := load("res://scenes/levels/station_10.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_10.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station10
	root.add_child(station)
	await process_frame

	station.read_number_plate()
	station.turn_key()
	_expect(station.is_key_turned, "Klucz musi pasować do zamka")
	_expect(not station.is_threshold_open, "Sam klucz nie może wpuścić Leny odruchowo do środka")

	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"hyp_address_shift", false),
			"Pasujący klucz musi obalić hipotezę przełożonych numerów"
		)

	station.set_bag_down()
	_expect(station.is_bag_set_down, "Torba musi zostać odstawiona przy drzwiach")
	_expect(station.is_threshold_open, "Dopiero klucz i odstawiona torba otwierają próg")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 10 PASSED")


func _test_station_11() -> void:
	print("TEST: Station 11 (Dwie osoby na zdjęciu)...")
	var packed := load("res://scenes/levels/station_11.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_11.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station11
	root.add_child(station)
	await process_frame

	var props := station.get_node_or_null("Props")
	_expect(props != null and props.get_child_count() >= 5, "Station 11 musi mieć komplet rekwizytów domowych")

	station.examine_photograph()
	_expect(station.photograph_inspected, "Fotografia na komodzie musi zostać obejrzana")
	station.boots_inspected = true
	station.reader_dock_inspected = true
	station._check_evidence_complete()
	_expect(station.is_evidence_complete, "Trzy domowe fakty muszą zamknąć zbiór dowodów")

	station.apply_sideboard_setback()
	_expect(station.sideboard_setback_count == 1, "Zrzucona ramka musi zostać policzona")
	_expect(station.photograph_face_blurred, "Zrzucona ramka musi zabrać ostrość jednej twarzy")
	_expect(not station.is_level_completed, "Zrzucona ramka nie może kończyć sceny")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 11 PASSED")


func _test_station_12() -> void:
	print("TEST: Station 12 (Wiadomość głosowa)...")
	var packed := load("res://scenes/levels/station_12.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_12.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station12
	root.add_child(station)
	await process_frame

	station.play_message()
	_expect(not station.message_active, "Otwarty balkon musi zagłuszyć nagranie")
	_expect(station.muffled_playback_count == 1, "Zagłuszone odsłuchanie musi zostać policzone")

	station.close_balcony()
	_expect(station.is_balcony_closed, "Skrzydło balkonowe musi się domknąć")

	station.play_message()
	_expect(station.message_active, "Po domknięciu balkonu nagranie musi ruszyć")
	station.advance_message()
	_expect(station.rewind_count == 1, "Lena musi raz cofnąć nagranie")
	for step in range(12):
		if not station.message_active:
			break
		station.advance_message()
	_expect(station.is_message_completed, "Całe nagranie musi zostać wysłuchane")

	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"hyp_identity_theft", false),
			"Głos Marty musi obalić hipotezę podszywania się"
		)

	station.check_caller_number()
	station.write_two_questions()
	_expect(station.are_questions_written, "Lena musi zapisać dwa pytania zamiast odpowiadać na gorąco")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 12 PASSED")


func _test_station_13() -> void:
	print("TEST: Station 13 (Dwie ważne wersje)...")
	var packed := load("res://scenes/levels/station_13.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_13.tscn musi istnieć")
		return
	var station := packed.instantiate() as Station13
	root.add_child(station)
	await process_frame

	station.compare_certificate()
	_expect(station.certificate_compared, "Zaświadczenie z torby musi zostać porównane")
	_expect(not station.are_documents_compared, "Jeden dokument nie może rozstrzygać")

	station.compare_contract()
	_expect(station.is_drawer_open, "Sięgnięcie po umowę musi wysunąć szufladę")
	station.compare_contract()
	_expect(station.contract_compared, "Umowa z szuflady musi zostać porównana")

	station.verify_seals()
	_expect(station.are_documents_compared, "Dopiero para dokumentów zamyka porównanie")

	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"hyp_lock_coincidence", false),
			"Para dokumentów musi obalić hipotezę pomyłki lokalu"
		)

	station.apply_squeeze_setback()
	_expect(station.squeeze_setback_count == 1, "Rozsypane papiery muszą zostać policzone")
	_expect(not station.is_level_completed, "Rozsypane papiery nie mogą kończyć sceny")

	station.request_meeting()
	_expect(station.is_meeting_requested, "Lena musi poprosić Martę o spotkanie")

	station.queue_free()
	for frame in range(3):
		await process_frame
	print("TEST: Station 13 PASSED")


func _test_campaign_chain(state: Node) -> void:
	print("TEST: łańcuch kampanii 08..14...")
	if state == null:
		return
	state.reset_campaign(true)
	for station_number in range(1, 14):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_14"), "Ukończenie stacji 13 musi odblokować stację 14")
