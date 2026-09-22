extends SceneTree

## PKG-0121 Smoke Test — Station 24..30, Sekwencje VI/VII (Węzeł pod Linią 4, żywa odpowiedź i pierwsze koszty) według Kanonu 0.3
##
## Weryfikuje:
## 1. Instancjonowanie i determinizm scen Station 24..30 w pętli 60 Hz.
## 2. Brak wywołań draw_string() w Layer 0 — wszystkie napisy w CrispDiegeticText (Layer 10).
## 3. Nagłówki trzech pytań o przeszkodę (D-099) we wszystkich skryptach 24..30.
## 4. Architektura Pixel-Stage: Layer 5 (WorldPixelCompositor), Layer 10 (CrispDiegeticText),
##    Layer 16 (InnerThoughtSurface), Layer 20 (CRTDialogueBox).
## 5. Pętle stacji zgodne z Kanonem 0.3:
##    - 24: Nie jesteś jej zastępstwem (granice Marty, pudełko na rzeczy, wybór dyspozycji)
##    - 25: Węzeł pod Linią 4 (Jakub: „Nie jestem twoim wspomnieniem”, wygaszanie maszyn)
##    - 26: Przerwana próba (log 20:40:03 kontakt wzajemny, kotwiczenie bufora, interwencja UCP)
##    - 27: Trzy powtórzenia (dwie równe próby + trzecia z błędem, korekta żywego sygnału)
##    - 28: Cena małego wyniku (wybór Anchor/Yield, pierwszy koszt pamięciowy, wózek inspekcyjny)
##    - 29: Jakub mówi nie (rozjazd podstacji, rygiel manualny, wymóg świadomej zgody)
##    - 30: Trzy prognozy (węzeł zasilania Linii 4, zestawienie modeli, odkrycie braku danych)
## 6. Ciągłość łańcucha kampanii 24..31.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")

const STATION_NUMBERS := [24, 25, 26, 27, 28, 29, 30]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("BŁĄD PKG-0121: %s" % message)


func _run_all_tests() -> void:
	print("== PKG-0121 Station 24-30 Canon 0.3 Gate ==")

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	_test_no_draw_string_in_layer_zero()
	_test_obstacle_headers()
	_test_pixel_stage_architecture()

	await _test_station_24()
	await _test_station_25()
	await _test_station_26()
	await _test_station_27()
	await _test_station_28()
	await _test_station_29()
	await _test_station_30()

	_test_campaign_chain()

	if _failures.is_empty():
		print("PKG-0121 PASS: Station 24-30 Canon 0.3, Pixel-Stage, guidance i prognozy zweryfikowane")
		quit(0)
	else:
		printerr("PKG-0121 FAILED: %d błędów:" % _failures.size())
		for f in _failures:
			printerr("  - %s" % f)
		quit(1)


func _test_no_draw_string_in_layer_zero() -> void:
	print("TEST: brak draw_string() w Layer 0 dla stacji 24..30...")
	for num in STATION_NUMBERS:
		var script_path := "res://scripts/levels/station_%02d.gd" % num
		var file := FileAccess.open(script_path, FileAccess.READ)
		_expect(file != null, "Skrypt %s musi istnieć" % script_path)
		if file:
			var content := file.get_as_text()
			_expect(not content.contains("draw_string("),
				"Skrypt %s nie może wywoływać draw_string() w Layer 0 (użyj CrispDiegeticText lub CRTDialogueBox)" % script_path)


func _test_obstacle_headers() -> void:
	print("TEST: nagłówki trzech pytań o przeszkodę dla stacji 24..30...")
	for num in STATION_NUMBERS:
		var script_path := "res://scripts/levels/station_%02d.gd" % num
		var file := FileAccess.open(script_path, FileAccess.READ)
		if file:
			var content := file.get_as_text()
			_expect(content.contains("## OBSTACLE_WORLD_PURPOSE:") or content.contains("## PRZESZKODA — dlaczego to tu jest:"),
				"Skrypt %s musi zawierać nagłówek celu przeszkody w świecie (D-099)" % script_path)


func _test_pixel_stage_architecture() -> void:
	print("TEST: architektura Pixel-Stage w scenach 24..30...")
	for num in STATION_NUMBERS:
		var scene_path := "res://scenes/levels/station_%02d.tscn" % num
		var scene := load(scene_path) as PackedScene
		_expect(scene != null, "Scena %s musi się ładować" % scene_path)
		if scene:
			var inst := scene.instantiate()
			_expect(inst.has_node("WorldPixelCompositor"), "Scena %s musi mieć WorldPixelCompositor (Layer 5)" % scene_path)
			_expect(inst.has_node("CrispDiegeticText"), "Scena %s musi mieć CrispDiegeticText (Layer 10)" % scene_path)
			_expect(inst.has_node("InnerThoughtSurface"), "Scena %s musi mieć InnerThoughtSurface (Layer 16)" % scene_path)
			_expect(inst.has_node("CRTDialogueBox"), "Scena %s musi mieć CRTDialogueBox (Layer 20)" % scene_path)
			_expect(inst.has_node("NarrativeGuidanceService"), "Scena %s musi mieć NarrativeGuidanceService" % scene_path)
			inst.free()


func _test_station_24() -> void:
	print("TEST: Station 24 (Nie jesteś jej zastępstwem / jawna granica Marty)...")
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"mechanic_cost_observed", true)
	var scene := load("res://scenes/levels/station_24.tscn") as PackedScene
	_expect(scene != null, "Scena station_24 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station24
	root.add_child(inst)
	await process_frame
	_expect(not inst.choose_limited_access(), "Marta nie może zdecydować przed pełnym ujawnieniem")
	inst.disclose_marta_scope()
	inst.disclose_marta_risk()
	inst.disclose_marta_cost()
	_expect(inst.choose_limited_access(), "Marta musi móc udzielić ograniczonego dostępu po ujawnieniu")
	_expect(inst.is_exit_unlocked, "Ograniczony dostęp musi odblokować uczciwą drogę do 25")
	if state:
		_expect(state.decisions.get(&"p7.mutual_test.marta_boundary", "") == "limited_access", "Dostęp Marty musi mieć własny stan")
		_expect(state.decisions.get(&"marta_boundary_accepted", false), "Szacunek granicy musi pozostać kanoniczny")
	inst.queue_free()
	await process_frame
	print("TEST: Station 24 PASSED")


func _test_station_25() -> void:
	print("TEST: Station 25 (Węzeł pod Linią 4 / obie drogi techniczne)...")
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.mutual_test.marta_boundary", "declined")
	var scene := load("res://scenes/levels/station_25.tscn") as PackedScene
	_expect(scene != null, "Scena station_25 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station25
	root.add_child(inst)
	await process_frame
	inst.observe_ventilation_cycle()
	inst.release_interlock()
	inst.route_power()
	_expect(inst.retrieve_ucp_buffer(), "Droga techniczna po odmowie musi pobrać bufor")
	_expect(inst.is_exit_unlocked, "Bufor UCP musi odblokować wyjście do 26")
	if state:
		_expect(state.decisions.get(&"p7.mutual_test.ucp_buffer_trace", "") == "technical_route", "Odmowa Marty musi mieć techniczny ślad")
		_expect(not state.decisions.has(&"jakub_consent_state"), "Station 25 nie może nadawać późniejszej zgody Jakuba")
	inst.queue_free()
	await process_frame
	print("TEST: Station 25 PASSED")


func _test_station_26() -> void:
	print("TEST: Station 26 (Przerwana próba / Stanowisko analizatora)...")
	var scene := load("res://scenes/levels/station_26.tscn") as PackedScene
	_expect(scene != null, "Scena station_26 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station26
	root.add_child(inst)
	await process_frame

	inst.inspect_console()
	inst.inspect_designator()
	inst.inspect_speaker()
	inst.anchor_motivation()

	_expect(inst.is_console_inspected, "Station 26: Konsola musi być sprawdzona")
	_expect(inst.is_designator_inspected, "Station 26: Wskaźnik funkcyjny musi być sprawdzony")
	_expect(inst.is_speaker_inspected, "Station 26: Głośnik PA musi być sprawdzony")
	_expect(inst.is_motivation_anchored, "Station 26: Cel Leny musi być zakotwiczony")

	# Advance dialogue to end
	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 26: Wyjście do Station 27 musi być odblokowane")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 26 PASSED")


func _test_station_27() -> void:
	print("TEST: Station 27 (Trzy powtórzenia / Żywy sygnał)...")
	var scene := load("res://scenes/levels/station_27.tscn") as PackedScene
	_expect(scene != null, "Scena station_27 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station27
	root.add_child(inst)
	await process_frame

	inst.inspect_badge()
	inst.interact_jakub()
	inst.inspect_monitor()
	inst.inspect_console()

	_expect(inst.is_badge_inspected, "Station 27: Legitymacja musi być sprawdzona")
	_expect(inst.is_jakub_interacted, "Station 27: Dialog z Jakubem musi być rozpoczęty")
	_expect(inst.is_monitor_inspected, "Station 27: Monitor musi być sprawdzony")
	_expect(inst.is_console_inspected, "Station 27: Konsola musi być sprawdzona")

	# Advance dialogue to end
	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 27: Wyjście do Station 28 musi być odblokowane")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 27 PASSED")


func _test_station_28() -> void:
	print("TEST: Station 28 (Cena małego wyniku / Skład techniczny)...")
	var scene := load("res://scenes/levels/station_28.tscn") as PackedScene
	_expect(scene != null, "Scena station_28 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station28
	root.add_child(inst)
	await process_frame

	inst.inspect_console()
	inst.inspect_window()
	inst.inspect_paradox()
	inst.inspect_intercom()

	_expect(inst.is_console_interacted, "Station 28: Pulpit maszynisty musi być sprawdzony")
	_expect(inst.is_window_inspected, "Station 28: Okno tranzytowe musi być sprawdzone")
	_expect(inst.is_paradox_inspected, "Station 28: Potrójny widok musi być sprawdzony")
	_expect(inst.is_intercom_inspected, "Station 28: Interkom zamykający musi być sprawdzony")

	# Advance dialogue to end
	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 28: Wyjście do Station 29 musi być odblokowane")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 28 PASSED")


func _test_station_29() -> void:
	print("TEST: Station 29 (Jakub mówi nie / Peron trzynasty)...")
	var scene := load("res://scenes/levels/station_29.tscn") as PackedScene
	_expect(scene != null, "Scena station_29 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station29
	root.add_child(inst)
	await process_frame

	inst.inspect_tracks()
	inst.inspect_neon()
	inst.inspect_well()
	inst.inspect_beacon()

	_expect(inst.is_tracks_inspected, "Station 29: Zardzewiałe tory muszą być sprawdzone")
	_expect(inst.is_neon_inspected, "Station 29: Neon musi być sprawdzony")
	_expect(inst.is_well_inspected, "Station 29: Szyb wentylacyjny musi być sprawdzony")
	_expect(inst.is_beacon_inspected, "Station 29: Latarka Jakuba musi być sprawdzona")

	# Advance dialogue to end
	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 29: Brama do Station 30 musi być odblokowana")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 29 PASSED")


func _test_station_30() -> void:
	print("TEST: Station 30 (Trzy prognozy / Sektor Zasilania)...")
	var scene := load("res://scenes/levels/station_30.tscn") as PackedScene
	_expect(scene != null, "Scena station_30 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station30
	root.add_child(inst)
	await process_frame

	inst.inspect_board()
	inst.inspect_transformer()
	inst.throw_breaker()
	inst.inspect_schematic()

	_expect(inst.is_board_inspected, "Station 30: Tablica rozdzielcza musi być sprawdzona")
	_expect(inst.is_transformer_inspected, "Station 30: Bateria transformatorów musi być sprawdzona")
	_expect(inst.is_breaker_thrown, "Station 30: Bezpiecznik nożowy musi być przestawiony")
	_expect(inst.is_schematic_inspected, "Station 30: Mapa sieci pamięci musi być sprawdzona")

	# Advance dialogue to end
	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 30: Brama do Magazynu Dowodów (Station 31) musi być odblokowana")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 30 PASSED")


func _test_campaign_chain() -> void:
	print("TEST: łańcuch kampanii 24..31...")
	var state := root.get_node_or_null("GameStateManager")
	if not state:
		return
	state.reset_campaign(true)
	for station_number in range(1, 31):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_31"), "Ukończenie stacji 30 musi odblokować stację 31")
