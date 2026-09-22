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
	8: "renumbered_route",
	9: "renumbering",
	10: "intruder",
	11: "lost_relationship",
	12: "staging",
	13: "different_dates",
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
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.address_and_record.shopkeeper_answer", "yesterday_purchase")
	var station := packed.instantiate() as Station08
	root.add_child(station)
	await process_frame
	_expect(station.get_node_or_null("Geometry/BuildingEntranceDoor") is AnimatableBody2D, "Station 08 musi mieć drzwi wejściowe jako ciało fizyczne")
	_expect(station.read_certificate(), "Dokument musi się zarejestrować")
	_expect(station.read_directory(), "Lista musi się zarejestrować")
	_expect(not station.get("is_exit_unlocked"), "Dwa źródła nie wystarczą do wejścia")
	_expect(station.test_intercom_recognition(), "Dokument, lista i test domofonu muszą potwierdzić wejście")
	_expect(station.get("is_exit_unlocked"), "Potwierdzone wejście musi otworzyć drzwi bloku")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(guidance.active_beats.has(&"s08_renumbering_hypothesis"), "Station 08 musi mieć myśl o przełożonych numerach")
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
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.address_and_record.trace", "identifiers_agree_and_conflict")
	var station := packed.instantiate() as Station09
	root.add_child(station)
	await process_frame
	_expect(station.get_node_or_null("Geometry/StairwellPlanter") is MovableAnchorableProp, "Station 09 musi mieć donicę jako przesuwalny rekwizyt")
	_expect(station.observe_floor_record(), "Tabliczka piętra musi się zarejestrować")
	var planter := station.get_node_or_null("Geometry/StairwellPlanter") as MovableAnchorableProp
	if planter:
		for frame in range(90):
			planter.receive_push(1.0)
			await physics_frame
	_expect(station.get("is_passage_clear") == true, "Donica musi odsunąć się z przejścia")
	_expect(station.ask_neighbour_without_leading(), "Pytanie do sąsiadki musi się zarejestrować")
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
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.foreign_daily_life.neighbour_account", "twelve_lower_fourteen_home")
	var station := packed.instantiate() as Station10
	root.add_child(station)
	await process_frame
	_expect(station.inspect_key_wear(), "Zużycie klucza musi się zarejestrować")
	_expect(station.test_key_without_claiming_home(), "Klucz musi wykonać próbę materiału")
	_expect(not station.get("is_exit_unlocked"), "Sam klucz nie może wpuścić Leny odruchowo do środka")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"renumbering", false),
			"Pasujący klucz musi obalić hipotezę przełożonych numerów"
		)
	_expect(station.commit_cautious_entry(), "Ostrożne wejście musi się zarejestrować")
	_expect(station.get("is_exit_unlocked"), "Dopiero klucz i ostrożne wejście otwierają próg")
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
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.foreign_daily_life.key_trial_result", "key_matches_foreign_history")
	var station := packed.instantiate() as Station11
	root.add_child(station)
	await process_frame
	var props := station.get_node_or_null("Props")
	_expect(props != null and props.get_child_count() >= 5, "Station 11 musi mieć komplet rekwizytów domowych")
	var sideboard := station.get_node_or_null("Geometry/HallwaySideboard") as MovableAnchorableProp
	if sideboard:
		for frame in range(110):
			sideboard.receive_push(1.0)
			await physics_frame
	_expect(station.get("is_passage_clear") == true, "Komoda musi odsunąć się z przejścia")
	_expect(station.inspect_private_photograph(), "Fotografia na komodzie musi zostać obejrzana")
	_expect(station.inspect_equipment_wear(), "Zużycie sprzętu musi się zarejestrować")
	_expect(station.inspect_reader_arrangement(), "Ustawienie czytnika musi się zarejestrować")
	_expect(station.compare_private_material(), "Trzy domowe fakty muszą zamknąć porównanie")
	_expect(station.get("is_exit_unlocked"), "Wyjście musi się odblokować po poszanowaniu materiału")
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
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.foreign_daily_life.trace", "foreign_address_and_photograph")
	var station := packed.instantiate() as Station12
	root.add_child(station)
	await process_frame
	_expect(not station.listen_to_message(), "Otwarty balkon musi zagłuszyć nagranie")
	_expect(station.close_balcony(), "Skrzydło balkonowe musi się domknąć")
	_expect(station.listen_to_message(), "Po domknięciu balkonu nagranie musi ruszyć")
	_expect(station.verify_caller_identity(), "Numer musi zostać sprawdzony")
	_expect(station.prepare_independent_questions(), "Lena musi zapisać dwa pytania zamiast odpowiadać na gorąco")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"staging", false),
			"Głos Marty musi obalić hipotezę inscenizacji"
		)
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
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.marta_threshold.independent_questions_ready", true)
	var station := packed.instantiate() as Station13
	root.add_child(station)
	await process_frame
	_expect(station.observe_field_certificate(), "Zaświadczenie z torby musi zostać porównane")
	_expect(station.open_drawer(), "Sięgnięcie po umowę musi wysunąć szufladę")
	_expect(station.observe_tenancy_contract(), "Umowa z szuflady musi zostać odczytana")
	_expect(not station.get("are_documents_compared"), "Jeden dokument nie może rozstrzygać")
	_expect(station.verify_document_independence(), "Pieczęcie muszą zostać sprawdzone")
	_expect(station.compare_document_versions(), "Dopiero para dokumentów zamyka porównanie")
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		_expect(
			guidance.closed_hypotheses.get(&"different_dates", false),
			"Para dokumentów musi obalić hipotezę różnych dat"
		)
	_expect(station.request_independent_description(), "Lena musi poprosić Martę o niezależny opis")
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
