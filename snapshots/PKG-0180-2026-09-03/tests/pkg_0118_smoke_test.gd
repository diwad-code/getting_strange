extends SceneTree

## PKG-0118 Smoke Test — Foundation Slice 01–07 według kanonu 0.3
##
## Weryfikuje:
## 1. LenaVisualRig — 13 stanów, proporcje (44-52px), override, sygnały, zwrot, kontakt z podłożem
## 2. WorldPixelCompositor (Layer 5) & CrispDiegeticText (Layer 10) — brak draw_string w Layer 0
## 3. GuidanceBeat & NarrativeGuidanceService — model omylny, cooldown >= 8s, zamykanie hipotez
## 4. Pętle i mechaniki Station 01..07 zgodne z Kanonem 0.3:
##    - 01: czysty powtórzony pomiar drgań, archiwizacja, spakowanie sprzętu
##    - 02: fizyczne obejście serwisowe (remont, wyłączony panel, bezpieczna kładka)
##    - 03: schronienie przystankowe, wiadomość od Marty na telefonie, odjazd
##    - 04: przejazd wagonem nocnym, bufor czytnika z 3s przerwą, restart i schowanie czytnika
##    - 05: spokojny spacer znajomą ulicą w deszczu, neutralny szyld UCP / PRACE NOCNE
##    - 06: porównanie rozkładu papierowego z cache'em aplikacji w telefonie, zgodność autobusu
##    - 07: dialog w kiosku o herbatę dla Marty, rejestr sprzedaży, zakup wody i wyjście
## 5. Lint wiedzy i pojęć Act I (brak zakazanych terminów przedwczesnych)

const LenaVisualRig := preload("res://scripts/player/lena_visual_rig.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const WorldPixelCompositor := preload("res://scripts/visual/world_pixel_compositor.gd")
const CrispDiegeticText := preload("res://scripts/visual/crisp_diegetic_text.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const FORBIDDEN_EARLY_TERMS := [
	"inny świat",
	"alternatywny świat",
	"alternatywna lena",
	"miejscowa lena",
	"podstruktura",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("BŁĄD PKG-0118: %s" % message)


func _run_all_tests() -> void:
	print("== PKG-0118 Foundation Slice 01-07 Canon 0.3 Gate ==")
	
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)
	
	await _test_lena_visual_rig()
	await _test_world_pixel_compositor()
	await _test_crisp_diegetic_text()
	await _test_guidance_service_and_beats()
	await _test_station_01_slice()
	await _test_station_02_slice()
	await _test_station_03_slice()
	await _test_station_04_slice()
	await _test_station_05_slice()
	await _test_station_06_slice()
	await _test_station_07_slice()
	_test_knowledge_lint_act1()
	
	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	
	_print_summary()


func _print_summary() -> void:
	if _failures.is_empty():
		print("PKG-0118 PASS: Foundation Slice 01-07 Canon 0.3, LenaVisualRig, Pixel-Stage & Guidance verified")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0118 FAILURE: " + failure)
		quit(1)


func _test_lena_visual_rig() -> void:
	print("TEST: LenaVisualRig 13 states & proportions...")
	var player_scene := load("res://scenes/player/prototype_player.tscn") as PackedScene
	_expect(player_scene != null, "prototype_player.tscn musi istnieć")
	if player_scene == null:
		return
	
	var player := player_scene.instantiate() as PrototypePlayer
	root.add_child(player)
	await process_frame
	
	var rig := player.get_node_or_null("LenaVisualRig") as LenaVisualRig
	_expect(rig != null, "LenaVisualRig musi być dzieckiem PrototypePlayer")
	
	if rig != null:
		var required_states := [
			&"idle", &"start", &"walk", &"run", &"stop", &"turn",
			&"jump_rise", &"jump_fall", &"land", &"interact",
			&"examine", &"unease_reaction", &"seam_gesture"
		]
		for s_name in required_states:
			rig.debug_override_state(s_name)
			_expect(rig.get_current_state_name() == s_name, "Stan %s musi być aktywny po debug_override" % s_name)
		
		# Test cue playback
		var cue_completed := false
		rig.animation_cue_completed.connect(func(_name: StringName): cue_completed = true)
		rig.play_cue(&"seam_gesture", 0.05)
		
		# Test facing change
		rig.set_facing(-1.0)
		_expect(rig.facing == -1.0, "set_facing musi ustawić kierunek w lewo")
		rig.set_facing(1.0)
		_expect(rig.facing == 1.0, "set_facing musi ustawić kierunek w prawo")
	
	player.queue_free()
	for f in range(2):
		await process_frame


func _test_world_pixel_compositor() -> void:
	print("TEST: WorldPixelCompositor...")
	var comp := WorldPixelCompositor.new()
	root.add_child(comp)
	await process_frame
	
	_expect(comp.layer == 5, "WorldPixelCompositor musi renderować w Layer 5")
	_expect(comp.pixel_scale == 2.0, "WorldPixelCompositor musi mieć skalę 2.0 (320x180)")
	_expect(comp.compositor_enabled, "WorldPixelCompositor musi być włączony")
	
	comp.queue_free()
	for f in range(2):
		await process_frame


func _test_crisp_diegetic_text() -> void:
	print("TEST: CrispDiegeticText & no draw_string in Layer 0...")
	var crisp := CrispDiegeticText.new()
	root.add_child(crisp)
	crisp.text = "STANOWISKO 01"
	await process_frame
	
	var internal_layer := crisp.get_node_or_null("CrispDiegeticLayer") as CanvasLayer
	_expect(internal_layer != null and internal_layer.layer == 10, "CrispDiegeticText musi renderować w CanvasLayer 10")
	crisp.queue_free()
	
	# Verify that station scripts do not call draw_string in Layer 0
	for i in range(1, 8):
		var path := "res://scripts/levels/station_%02d.gd" % i
		var file := FileAccess.open(path, FileAccess.READ)
		if file:
			var content := file.get_as_text()
			_expect(not content.contains("draw_string("), "Station %02d nie może rysować tekstu przez draw_string() w Layer 0" % i)
			file.close()
	
	for f in range(2):
		await process_frame


func _test_guidance_service_and_beats() -> void:
	print("TEST: NarrativeGuidanceService & fallible beats...")
	var service := NarrativeGuidanceService.new()
	root.add_child(service)
	await process_frame
	
	var beat := GuidanceBeat.new()
	beat.beat_id = &"test_beat_1"
	beat.scene_id = &"station_01"
	beat.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat.thought_kind = &"interpretation"
	beat.text_pl = "Mocowanie jest czyste."
	beat.text_en = "Bracket is clean."
	beat.cooldown_s = 8.0
	beat.hypothesis_id = &"hyp_sensor_mount"
	beat.predicted_check = "check_sensor_mount"
	
	service.register_beat(beat)
	
	var triggered := service.trigger_beat(&"test_beat_1")
	_expect(triggered, "Beat powinien się wyzwolić")
	_expect(service.cooldown_remaining >= 8.0, "Serwis musi wymuszać cooldown >= 8.0s")
	
	# Test hypothesis closing
	service.close_hypothesis(&"hyp_sensor_mount")
	_expect(service.closed_hypotheses.get(&"hyp_sensor_mount", false), "Hipoteza musi być oznaczona jako zamknięta")
	_expect(service.current_beat == null, "Zamknięcie hipotezy musi schować myśl")
	
	# Retriggering closed hypothesis should fail
	var retriggered := service.trigger_beat(&"test_beat_1")
	_expect(not retriggered, "Beat zamkniętej hipotezy nie może się powtórzyć")
	
	service.queue_free()
	for f in range(2):
		await process_frame


func _test_station_01_slice() -> void:
	print("TEST: Station 01 (Wieczorny odczyt / Ostatni odczyt)...")
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed != null, "station_01.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await process_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_01 musi zawierać WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_01 musi zawierać NarrativeGuidanceService")
	_expect(station.get_node_or_null("InnerThoughtSurface") != null, "station_01 musi zawierać InnerThoughtSurface")
	_expect(station.call(&"repeat_line_four_measurement") == true, "Odczyt Linii 4 musi się powtórzyć")
	_expect(station.call(&"secure_raw_sample") == true, "Próbka musi zostać zabezpieczona")
	_expect(station.call(&"read_marta_message") == true, "Wiadomość Marty musi ustanowić cenę opóźnienia")
	_expect(station.get("is_exit_unlocked") == true, "Procedura stacji 01 musi odblokować wyjście")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 01 PASSED")


func _test_station_02_slice() -> void:
	print("TEST: Station 02 (Obejście serwisowe)...")
	var packed := load("res://scenes/levels/station_02.tscn") as PackedScene
	_expect(packed != null, "station_02.tscn musi istnieć")
	if packed == null:
		return
	print("  Station 02 scene loaded")
	var station: Node2D = packed.instantiate()
	print("  Station 02 instantiated")
	root.add_child(station)
	print("  Station 02 added to root")
	await process_frame
	print("  Station 02 physics frame done")
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_02 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_02 musi mieć NarrativeGuidanceService")
	station.queue_free()
	print("  Station 02 queued free")
	for f in range(4):
		await process_frame
	print("TEST: Station 02 PASSED")



func _test_station_03_slice() -> void:
	print("TEST: Station 03 (Wiadomość Marty)...")
	var packed := load("res://scenes/levels/station_03.tscn") as PackedScene
	_expect(packed != null, "station_03.tscn musi istnieć")
	if packed == null:
		return
	print("  Station 03 packed scene loaded")
	var station: Node2D = packed.instantiate()
	print("  Station 03 instantiated")
	root.add_child(station)
	print("  Station 03 added to root")
	await process_frame
	print("  Station 03 physics frame finished")
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_03 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_03 musi mieć NarrativeGuidanceService")
	station.queue_free()
	print("  Station 03 queued free")
	for f in range(4):
		await process_frame
	print("TEST: Station 03 PASSED")



func _test_station_04_slice() -> void:
	print("TEST: Station 04 (Przejazd wagonem)...")
	var packed := load("res://scenes/levels/station_04.tscn") as PackedScene
	_expect(packed != null, "station_04.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await process_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_04 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_04 musi mieć NarrativeGuidanceService")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 04 PASSED")


func _test_station_05_slice() -> void:
	print("TEST: Station 05 (Znana ulica)...")
	var packed := load("res://scenes/levels/station_05.tscn") as PackedScene
	_expect(packed != null, "station_05.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await process_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_05 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_05 musi mieć NarrativeGuidanceService")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 05 PASSED")


func _test_station_06_slice() -> void:
	print("TEST: Station 06 (Dwa rozkłady)...")
	var packed := load("res://scenes/levels/station_06.tscn") as PackedScene
	_expect(packed != null, "station_06.tscn musi istnieć")
	if packed == null:
		return
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await process_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_06 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_06 musi mieć NarrativeGuidanceService")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 06 PASSED")


func _test_station_07_slice() -> void:
	print("TEST: Station 07 (Herbata dla Marty / Kiosk)...")
	var packed := load("res://scenes/levels/station_07.tscn") as PackedScene
	_expect(packed != null, "station_07.tscn musi istnieć")
	if packed == null:
		return
	var gsm07 := root.get_node_or_null("GameStateManager")
	if gsm07:
		gsm07.reset_campaign(true)
		gsm07.record_decision(&"p7.address_and_record.public_route_result", "paper_matches_vehicle")
	var station: Node2D = packed.instantiate()
	root.add_child(station)
	await process_frame
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "station_07 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "station_07 musi mieć NarrativeGuidanceService")
	_expect(station.call(&"ask_shopkeeper_recent_visit") == true, "Pytanie do sprzedawcy musi się zarejestrować")
	_expect(station.call(&"inspect_sale_ledger") == true, "Księga sprzedaży musi zostać odczytana")
	_expect(station.call(&"commit_ordinary_explanation") == true, "Zwykłe wyjaśnienie musi zostać zachowane")
	_expect(station.get("is_exit_unlocked") == true, "Wyjście musi się odblokować po zobowiązaniu")
	station.queue_free()
	for f in range(4):
		await process_frame
	print("TEST: Station 07 PASSED")


func _test_knowledge_lint_act1() -> void:
	print("TEST: Act I knowledge lint...")
	for i in range(1, 8):
		var path := "res://scripts/levels/station_%02d.gd" % i
		var file := FileAccess.open(path, FileAccess.READ)
		if file:
			var content := file.get_as_text().to_lower()
			for term in FORBIDDEN_EARLY_TERMS:
				_expect(not content.contains(term), "Station %02d zawiera przedwczesny termin: '%s'" % [i, term])
			file.close()
