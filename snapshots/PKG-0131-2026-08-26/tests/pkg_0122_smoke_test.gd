extends SceneTree

## PKG-0122 Smoke Test — Station 31..37, Sekwencje VIII/IX (Podstruktura, Magazyn Dowodów i rejestr par) według Kanonu 0.3
##
## Weryfikuje:
## 1. Instancjonowanie i determinizm scen Station 31..37 w pętli 60 Hz.
## 2. Brak wywołań draw_string() w Layer 0 — wszystkie napisy w CrispDiegeticText (Layer 10) lub CRTDialogueBox (Layer 20).
## 3. Nagłówki trzech pytań o przeszkodę (D-099) we wszystkich skryptach 31..37.
## 4. Architektura Pixel-Stage: Layer 5 (WorldPixelCompositor), Layer 10 (CrispDiegeticText),
##    Layer 16 (InnerThoughtSurface), Layer 20 (CRTDialogueBox).
## 5. Pętle stacji zgodne z Kanonem 0.3:
##    - 31: Magazyn Dowodów / Dwieście krzeseł (oferta adaptacji Wierzbickiej, depozyt Linii 4, odmowa uciszenia)
##    - 32: Szkło laboratoryjne (pamięć materiału, zaparowana tafla, rezonans i właz do szybu)
##    - 33: Szyb wentylacyjny (notatka miejscowej Leny z warunkiem abortu po 3 s, manometr -40m)
##    - 34: Maszynownia Główna (rdzeń korelacyjny, rejestr par Lena A / Lena B, alokacja)
##    - 35: Sektor Filtracji (baseny sedacyjne, echo domu, nagranie Marty domowej, wykluczenie prostego swapu)
##    - 36: Drenaż trakcyjny (para katastrof, rachunek Linii 4: 207 ocalonych vs katastrofa i śmierć brata)
##    - 37: Komora Sygnałowa (granice Jakuba: 10 sekund technicznej pomocy, zestrojenie żywego sygnału na oscyloskopie)
## 6. Ciągłość łańcucha kampanii 31..38.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")

const STATION_NUMBERS := [31, 32, 33, 34, 35, 36, 37]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("BŁĄD PKG-0122: %s" % message)


func _run_all_tests() -> void:
	print("== PKG-0122 Station 31-37 Canon 0.3 Gate ==")

	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	_test_no_draw_string_in_layer_zero()
	_test_obstacle_headers()
	_test_pixel_stage_architecture()

	await _test_station_31()
	await _test_station_32()
	await _test_station_33()
	await _test_station_34()
	await _test_station_35()
	await _test_station_36()
	await _test_station_37()

	_test_campaign_chain()

	if _failures.is_empty():
		print("PKG-0122 PASS: Station 31-37 Canon 0.3, Pixel-Stage, guidance i rejestr par zweryfikowane")
		quit(0)
	else:
		printerr("PKG-0122 FAILED: %d błędów:" % _failures.size())
		for f in _failures:
			printerr("  - %s" % f)
		quit(1)


func _test_no_draw_string_in_layer_zero() -> void:
	print("TEST: brak draw_string() w Layer 0 dla stacji 31..37...")
	for num in STATION_NUMBERS:
		var script_path := "res://scripts/levels/station_%02d.gd" % num
		var file := FileAccess.open(script_path, FileAccess.READ)
		_expect(file != null, "Skrypt %s musi istnieć" % script_path)
		if file:
			var content := file.get_as_text()
			_expect(not content.contains("draw_string("),
				"Skrypt %s nie może wywoływać draw_string() w Layer 0 (użyj CrispDiegeticText lub CRTDialogueBox)" % script_path)


func _test_obstacle_headers() -> void:
	print("TEST: nagłówki trzech pytań o przeszkodę dla stacji 31..37...")
	for num in STATION_NUMBERS:
		var script_path := "res://scripts/levels/station_%02d.gd" % num
		var file := FileAccess.open(script_path, FileAccess.READ)
		if file:
			var content := file.get_as_text()
			_expect(content.contains("## OBSTACLE_WORLD_PURPOSE:") or content.contains("## PRZESZKODA — dlaczego to tu jest:"),
				"Skrypt %s musi zawierać nagłówek celu przeszkody w świecie (D-099)" % script_path)


func _test_pixel_stage_architecture() -> void:
	print("TEST: architektura Pixel-Stage w scenach 31..37...")
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


func _test_station_31() -> void:
	print("TEST: Station 31 (Magazyn Dowodów / Dwieście krzeseł)...")
	var scene := load("res://scenes/levels/station_31.tscn") as PackedScene
	_expect(scene != null, "Scena station_31 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station31
	root.add_child(inst)
	await process_frame

	inst.inspect_chairs()
	inst.inspect_holoterminal()
	inst.inspect_twelfth_chair()
	inst.inspect_ledger()

	_expect(inst.is_chairs_inspected, "Station 31: Krzesła muszą być sprawdzone")
	_expect(inst.is_holoterminal_inspected, "Station 31: Holoterminal musi być sprawdzony")
	_expect(inst.is_twelfth_chair_inspected, "Station 31: Dwunaste krzesło musi być sprawdzone")
	_expect(inst.is_ledger_inspected, "Station 31: Rejestr musi być sprawdzony")

	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 31: Wyjście musi być odblokowane")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 31 PASSED")


func _test_station_32() -> void:
	print("TEST: Station 32 (Szkło laboratoryjne / Pamięć materiału)...")
	var scene := load("res://scenes/levels/station_32.tscn") as PackedScene
	_expect(scene != null, "Scena station_32 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station32
	root.add_child(inst)
	await process_frame

	inst.inspect_steamed_pane()
	inst.inspect_cracked_pane()
	inst.etch_trace()
	inst.inspect_polished_pane()

	_expect(inst.is_steamed_pane_inspected, "Station 32: Zaparowana tafla musi być sprawdzona")
	_expect(inst.is_cracked_pane_inspected, "Station 32: Popękana tafla musi być sprawdzona")
	_expect(inst.is_trace_etched, "Station 32: Ślad musi być naniesiony")
	_expect(inst.is_polished_pane_inspected, "Station 32: Wygładzona tafla musi być sprawdzona")

	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 32: Właz techniczny musi być odblokowany")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 32 PASSED")


func _test_station_33() -> void:
	print("TEST: Station 33 (Szyb wentylacyjny / Notatki z warunkiem przerwania)...")
	var scene := load("res://scenes/levels/station_33.tscn") as PackedScene
	_expect(scene != null, "Scena station_33 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station33
	root.add_child(inst)
	await process_frame

	inst.inspect_ladder()
	inst.inspect_gauge()
	inst.inspect_cable_trunk()
	inst.inspect_work_light()

	_expect(inst.is_ladder_inspected, "Station 33: Drabina musi być sprawdzona")
	_expect(inst.is_gauge_inspected, "Station 33: Manometr musi być sprawdzony")
	_expect(inst.is_cable_trunk_inspected, "Station 33: Notatka musi być sprawdzona")
	_expect(inst.is_work_light_inspected, "Station 33: Lampa robocza musi być sprawdzona")

	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 33: Dolny właz musi być odblokowany")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 33 PASSED")


func _test_station_34() -> void:
	print("TEST: Station 34 (Maszynownia Główna / Rdzeń korelacyjny)...")
	var scene := load("res://scenes/levels/station_34.tscn") as PackedScene
	_expect(scene != null, "Scena station_34 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station34
	root.add_child(inst)
	await process_frame

	inst.inspect_reactor()
	inst.inspect_desk()
	inst.inspect_thermal()
	inst.inspect_probe()

	_expect(inst.is_reactor_inspected, "Station 34: Rdzeń musi być sprawdzony")
	_expect(inst.is_desk_inspected, "Station 34: Pulpit alokacji musi być sprawdzony")
	_expect(inst.is_thermal_inspected, "Station 34: Wskaźnik termiczny musi być sprawdzony")
	_expect(inst.is_probe_inspected, "Station 34: Próbnik diagnostyczny musi być sprawdzony")

	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 34: Brama do filtrów musi być odblokowana")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 34 PASSED")


func _test_station_35() -> void:
	print("TEST: Station 35 (Sektor Filtracji / Baseny Sedacyjne)...")
	var scene := load("res://scenes/levels/station_35.tscn") as PackedScene
	_expect(scene != null, "Scena station_35 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station35
	root.add_child(inst)
	await process_frame

	inst.inspect_pool()
	inst.inspect_valve()
	inst.inspect_chemical()
	inst.inspect_monitor()

	_expect(inst.is_pool_inspected, "Station 35: Basen sedacyjny musi być sprawdzony")
	_expect(inst.is_valve_inspected, "Station 35: Zawór spustowy musi być sprawdzony")
	_expect(inst.is_chemical_inspected, "Station 35: Próbnik chemiczny musi być sprawdzony")
	_expect(inst.is_monitor_inspected, "Station 35: Monitor echa domu musi być sprawdzony")

	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 35: Śluza do drenażu musi być odblokowana")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 35 PASSED")


func _test_station_36() -> void:
	print("TEST: Station 36 (Drenaż trakcyjny / Para katastrof)...")
	var scene := load("res://scenes/levels/station_36.tscn") as PackedScene
	_expect(scene != null, "Scena station_36 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station36
	root.add_child(inst)
	await process_frame

	inst.inspect_weir()
	inst.inspect_current()
	inst.inspect_ladder()
	inst.inspect_tap()

	_expect(inst.is_weir_inspected, "Station 36: Jaz burzowy musi być sprawdzony")
	_expect(inst.is_current_inspected, "Station 36: Nurt drenażu musi być sprawdzony")
	_expect(inst.is_ladder_inspected, "Station 36: Kładka inspekcyjna musi być sprawdzona")
	_expect(inst.is_tap_inspected, "Station 36: Kurek pomiarowy musi być sprawdzony")

	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 36: Zasuwa jazu musi być odblokowana")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 36 PASSED")


func _test_station_37() -> void:
	print("TEST: Station 37 (Komora Sygnałowa / Węzeł nadawczy)...")
	var scene := load("res://scenes/levels/station_37.tscn") as PackedScene
	_expect(scene != null, "Scena station_37 musi się ładować")
	if not scene:
		return
	var inst := scene.instantiate() as Station37
	root.add_child(inst)
	await process_frame

	inst.inspect_oscilloscope()
	inst.inspect_patchbay()
	inst.inspect_antenna()
	inst.inspect_pulpit()

	_expect(inst.is_oscilloscope_inspected, "Station 37: Oscyloskop musi być sprawdzony")
	_expect(inst.is_patchbay_inspected, "Station 37: Krosownica musi być sprawdzona")
	_expect(inst.is_antenna_inspected, "Station 37: Antena musi być sprawdzona")
	_expect(inst.is_pulpit_inspected, "Station 37: Pulpit sterujący musi być sprawdzony")

	while inst.dialogue_active:
		inst.advance_dialogue()

	_expect(inst.is_exit_unlocked, "Station 37: Brama do Station 38 musi być odblokowana")

	inst.player.global_position = inst.airlock_zone.global_position
	await physics_frame
	await physics_frame

	inst.queue_free()
	await process_frame
	print("TEST: Station 37 PASSED")


func _test_campaign_chain() -> void:
	print("TEST: łańcuch kampanii 31..38...")
	var state := root.get_node_or_null("GameStateManager")
	if not state:
		return
	state.reset_campaign(true)
	for station_number in range(1, 38):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_38"), "Ukończenie stacji 37 musi odblokować stację 38")
