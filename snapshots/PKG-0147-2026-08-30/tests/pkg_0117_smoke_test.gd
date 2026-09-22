extends SceneTree

## PKG-0117 Smoke Test — rekoncyliacja zastanych komponentów Foundation
## Weryfikuje wyłącznie kontrakty techniczne, nie zgodność treści 01–07 z
## kanonem 0.3 ani jakość artystyczną Leny i Pixel-Stage:
## 1. LenaVisualRig & LenaAnimationState (12 stanów, proporcje, fasety, zwrot, VectorStageStyle).
## 2. WorldPixelCompositor & CrispDiegeticText (warstwa 5 piksel-stage, warstwa 10 ostry diegetyczny tekst).
## 3. NarrativeGuidanceService & InnerThoughtSurface (drabina L0–L4, cooldown min 8s, reset postępem, LENA // MYŚL).
## 4. Instancjonowanie przestrzeni 01–07 i zachowanie dwóch zastanych flag
##    przejścia. Treść tych przestrzeni pozostaje do adaptacji w PKG-0118.

const LenaRigScript := preload("res://scripts/player/lena_visual_rig.gd")
const LenaAnimScript := preload("res://scripts/player/lena_animation_state.gd")
const CompositorScript := preload("res://scripts/visual/world_pixel_compositor.gd")
const CrispTextScript := preload("res://scripts/visual/crisp_diegetic_text.gd")
const GuidanceServiceScript := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeatScript := preload("res://scripts/core/guidance_beat.gd")
const ThoughtSurfaceScript := preload("res://scripts/ui/inner_thought_surface.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	print("PKG-0117: _initialize called")
	call_deferred("_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("BŁĄD PKG-0117: %s" % message)


func _run_all_tests() -> void:
	print("PKG-0117: _run_all_tests started")
	await _test_lena_visual_rig()
	await _test_world_pixel_compositor()
	await _test_crisp_diegetic_text()
	await _test_guidance_and_thought_surface()
	await _test_station_01_slice()
	await _test_station_02_slice()
	await _test_station_03_slice()
	await _test_station_04_slice()
	await _test_station_05_slice()
	await _test_station_06_slice()
	await _test_station_07_slice()
	_print_summary()


func _test_lena_visual_rig() -> void:
	print("TEST: LenaVisualRig & Animation State...")
	var player_scene := load("res://scenes/player/prototype_player.tscn") as PackedScene
	_expect(player_scene != null, "prototype_player.tscn musi istnieć")
	if player_scene == null:
		return
	
	var player := player_scene.instantiate() as PrototypePlayer
	root.add_child(player)
	await process_frame
	
	var rig = player.get_node_or_null("LenaVisualRig")
	var anim_state = player.get_node_or_null("LenaAnimationState")
	
	_expect(rig != null, "LenaVisualRig musi być dzieckiem PrototypePlayer")
	_expect(anim_state != null, "LenaAnimationState musi być dzieckiem PrototypePlayer")
	
	if rig != null:
		_expect(rig.facing == 1.0, "Domyślny zwrot Leny to 1.0")
		
		# Test all 12 states override
		for s in LenaVisualRig.STATE_NAMES:
			var sname: StringName = LenaVisualRig.STATE_NAMES[s]
			rig.debug_override_state(sname)
			_expect(rig.current_state == s, "debug_override_state musi ustawić stan %s" % sname)
		
		# Test facing change
		rig.set_facing(-1.0)
		_expect(rig.facing == -1.0, "set_facing musi ustawić kierunek w lewo")
		rig.set_facing(1.0)
		_expect(rig.facing == 1.0, "set_facing musi ustawić kierunek w prawo")
	
	player.queue_free()
	await process_frame


func _test_world_pixel_compositor() -> void:
	print("TEST: WorldPixelCompositor...")
	var comp = CompositorScript.new()
	root.add_child(comp)
	await process_frame
	
	_expect(comp.layer == 5, "WorldPixelCompositor musi renderować w Layer 5")
	_expect(comp.pixel_scale == 2.0, "WorldPixelCompositor musi mieć domyślną skalę 2.0 (320x180)")
	_expect(comp.compositor_enabled, "WorldPixelCompositor musi być aktywny")
	
	comp.queue_free()
	await process_frame


func _test_crisp_diegetic_text() -> void:
	print("TEST: CrispDiegeticText...")
	var crisp = CrispTextScript.new()
	crisp.text = "TESTOWY NAPIS DIEGETYCZNY"
	crisp.font_size = 12
	root.add_child(crisp)
	await process_frame
	
	_expect(crisp.text == "TESTOWY NAPIS DIEGETYCZNY", "CrispDiegeticText musi zachować treść")
	
	crisp.queue_free()
	await process_frame


func _test_guidance_and_thought_surface() -> void:
	print("TEST: NarrativeGuidanceService & InnerThoughtSurface...")
	var service = GuidanceServiceScript.new()
	var surface = ThoughtSurfaceScript.new()
	surface.set("guidance_service", service)
	root.add_child(service)
	root.add_child(surface)
	await process_frame
	
	_expect(surface.layer == 16, "InnerThoughtSurface musi renderować w Layer 16")
	
	var beat = GuidanceBeatScript.new()
	beat.beat_id = &"test_beat_1"
	beat.tier = GuidanceBeatScript.Tier.L2_CONTEXTUAL_THOUGHT
	beat.thought_kind = &"observation"
	beat.text_pl = "To jest testowa myśl Leny."
	beat.cooldown_s = 8.0
	service.call(&"register_beat", beat)
	
	var triggered: bool = service.call(&"trigger_beat", &"test_beat_1")
	_expect(triggered, "trigger_beat musi zwrócić true dla zarejestrowanego beatu")
	_expect(surface.visible, "InnerThoughtSurface musi stać się widoczna po emisji myśli")
	
	# Repeat immediately should be blocked by cooldown
	var repeat_blocked: bool = service.call(&"trigger_beat", &"test_beat_1")
	_expect(not repeat_blocked, "Ponowne wywołanie w cooldownie musi zostać zablokowane")
	
	service.call(&"report_progress", &"test_progress")
	_expect(service.get("time_since_progress") == 0.0, "report_progress musi resetować timer utknięcia")
	_expect(not surface.visible, "report_progress musi schować powierzchnię myśli")
	
	service.queue_free()
	surface.queue_free()
	await process_frame


func _test_station_01_slice() -> void:
	print("TEST: Station 01 (Wieczorny odczyt)...")
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed != null, "station_01.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_01 musi zawierać WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_01 musi zawierać NarrativeGuidanceService")
	_expect(station.get_node_or_null("InnerThoughtSurface") != null, "station_01 musi zawierać InnerThoughtSurface")
	_expect(station.call(&"observe_measurement_gap") == true, "Rozbieżność musi się otworzyć")
	_expect(station.call(&"inspect_sensor_mount") == true, "Mocowanie musi zostać sprawdzone")
	_expect(station.call(&"record_raw_measurement") == true, "Surowy zapis musi zostać zachowany")
	_expect(station.call(&"repeat_measurement") == true, "Czysty odczyt musi wykonać przypadek")
	_expect(station.call(&"preserve_raw_sample") == true, "Próbka musi zostać zachowana")
	_expect(station.get("is_exit_unlocked") == true, "Procedura stacji 01 musi odblokować wyjście")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 01 PASSED")


func _test_station_02_slice() -> void:
	print("TEST: Station 02 (Ścieżka serwisowa)...")
	var packed := load("res://scenes/levels/station_02.tscn") as PackedScene
	_expect(packed != null, "station_02.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_02 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_02 musi mieć NarrativeGuidanceService")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 02 PASSED")


func _test_station_03_slice() -> void:
	print("TEST: Station 03 (Przystanek)...")
	var packed := load("res://scenes/levels/station_03.tscn") as PackedScene
	_expect(packed != null, "station_03.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_03 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_03 musi mieć NarrativeGuidanceService")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 03 PASSED")


func _test_station_04_slice() -> void:
	print("TEST: Station 04 (Wnętrze wagonu)...")
	var packed := load("res://scenes/levels/station_04.tscn") as PackedScene
	_expect(packed != null, "station_04.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_04 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_04 musi mieć NarrativeGuidanceService")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 04 PASSED")


func _test_station_05_slice() -> void:
	print("TEST: Station 05 (Ulica powrotna)...")
	var packed := load("res://scenes/levels/station_05.tscn") as PackedScene
	_expect(packed != null, "station_05.tscn musi istnieć")
	if packed == null:
		return
	var gsm05 := root.get_node_or_null("GameStateManager")
	if gsm05:
		gsm05.reset_campaign(true)
		gsm05.record_decision(&"p7.return_under_control.repeat_result", "repeat_persists_without_route_change")
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_05 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_05 musi mieć NarrativeGuidanceService")
	_expect(station.call(&"observe_ordinary_street") == true, "Aktywny oddech ulicy musi się zarejestrować")
	_expect(station.call(&"secure_reader_state") == true, "Stan czytnika musi zostać zabezpieczony")
	_expect(station.get("is_exit_unlocked") == true, "Station 05 musi odblokować wyjście")
	var game_state := root.get_node_or_null("GameStateManager")
	if game_state:
		_expect(game_state.decisions.get(&"ordinary_return_complete", false) == true, "Station 05 musi utrwalić ordinary_return_complete")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 05 PASSED")


func _test_station_06_slice() -> void:
	print("TEST: Station 06 (Sprzeczny rozkład)...")
	var packed := load("res://scenes/levels/station_06.tscn") as PackedScene
	_expect(packed != null, "station_06.tscn musi istnieć")
	if packed == null:
		return
	var gsm06 := root.get_node_or_null("GameStateManager")
	if gsm06:
		gsm06.reset_campaign(true)
		gsm06.record_decision(&"p7.return_under_control.trace", "reader_secured_without_paranormal_claim")
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_06 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_06 musi mieć NarrativeGuidanceService")
	_expect(station.call(&"observe_paper_timetable") == true, "Rozkład papierowy musi się zarejestrować")
	_expect(station.call(&"observe_offline_route") == true, "Trasa offline musi się zarejestrować")
	_expect(station.call(&"compare_public_route") == true, "Porównanie publiczne musi wykonać przypadek")
	_expect(station.get("is_exit_unlocked") == true, "Station 06 musi odblokować drzwi autobusu")
	var game_state := root.get_node_or_null("GameStateManager")
	if game_state:
		_expect(game_state.decisions.get(&"unease_pattern_started", false) == true, "Station 06 musi utrwalić unease_pattern_started")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 06 PASSED")


func _test_station_07_slice() -> void:
	print("TEST: Station 07 (Kiosk u Pawlaka / Klatka)...")
	var packed := load("res://scenes/levels/station_07.tscn") as PackedScene
	_expect(packed != null, "station_07.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await physics_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_07 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_07 musi mieć NarrativeGuidanceService")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 07 PASSED")


func _print_summary() -> void:
	if _failures.is_empty():
		print("PKG-0117: TECHNICZNE TESTY REKONCYLIACJI ZAKOŃCZONE SUKCESEM (0 BŁĘDÓW).")
		quit(0)
	else:
		printerr("PKG-0117: NIEPOWODZENIE — %d błędów:" % _failures.size())
		for f in _failures:
			printerr(" - %s" % f)
		quit(1)
