extends SceneTree

## PKG-0176 normal-driver capture: GATE-INTRO cold open.
##
## Kadry „po” dla DEF-1. Uruchamiane normalnym sterownikiem Windows, nie
## headless — `PRESENTATION_REPAIR_PLAN.md` §0 reguła 3.
##
## Kadr dowodzi, że obraz istnieje i co jest w kadrze. Nie dowodzi, że nowa
## osoba zrozumiała, kim jest Lena (D-012, ADR-003).

const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0176"
const REPORT_PATH := "res://reports/pkg_0176/visual_evidence_report.txt"
const _ColdOpenFacts := preload("res://scripts/campaign/cold_open_facts.gd")
const _VibrationTrace := preload("res://scripts/visual/vibration_trace_display.gd")

var _failures: Array[String] = []
var _records: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred(&"_capture_all")


func _capture_all() -> void:
	root.size = LOGICAL_SIZE
	var out_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	if DirAccess.make_dir_recursive_absolute(out_dir) != OK:
		_failures.append("Cannot create output dir %s" % out_dir)
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.reset_campaign(true)
		state.cold_open_seen = false
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)

	await _capture_layer_a()
	await _capture_layer_b()

	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
	_write_report()
	if _failures.is_empty():
		print("PKG-0176 CAPTURE PASS")
		quit(0)
		return
	print("PKG-0176 CAPTURE FAIL")
	quit(1)


func _capture_layer_a() -> void:
	var packed := load("res://scenes/shell/cold_open.tscn") as PackedScene
	if packed == null:
		_failures.append("Failed to load cold_open.tscn")
		return
	var cold_open := packed.instantiate() as ColdOpen
	root.add_child(cold_open)
	await physics_frame
	# Ujęcie 1: tramwaj w połowie przejazdu — maszyna pracuje bez gracza.
	await _run_physics(int((ColdOpen.TRAM_ENTER_AT + ColdOpen.TRAM_CROSS_SECONDS * 0.45) * 60.0))
	await _shoot("cold_open_shot1_tram.png", "DEF-1 ujecie 1: nocne torowisko Linii 4, tramwaj przejezdza bez udzialu gracza")
	# Ujęcie 2: zbliżenie na szynę, czujnik, kabel, dłoń w rękawicy.
	await _run_physics(int((cold_open.shot_seconds(0) - (ColdOpen.TRAM_ENTER_AT + ColdOpen.TRAM_CROSS_SECONDS * 0.45) + 2.0) * 60.0))
	await _shoot("cold_open_shot2_hands.png", "DEF-1 ujecie 2: sylwetka Leny od barkow w dol, dlon na obejmie czujnika, twarz poza pula swiatla")
	# Ujęcie 3a: przebieg na żywo tuż po skoku przejazdu.
	await _run_physics(int((cold_open.shot_seconds(1) - 2.0 + ColdOpen.LIVE_PASS_START + ColdOpen.LIVE_PASS_SECONDS * 0.75) * 60.0))
	await _shoot("cold_open_shot3_live.png", "DEF-1 ujecie 3a: przebieg na zywo, skok przy przejezdzie i powrot do szumu")
	# Ujęcie 3b: zapis archiwalny z płaską trzysekundową luką.
	await _run_physics(int((ColdOpen.ARCHIVE_AT - ColdOpen.LIVE_PASS_START - ColdOpen.LIVE_PASS_SECONDS * 0.75 + 0.9) * 60.0))
	await _shoot("cold_open_shot3_archive.png", "DEF-1 ujecie 3b: archiwum z plaska linia 3 s w otoczeniu normalnego szumu")
	cold_open.queue_free()
	await process_frame


func _capture_layer_b() -> void:
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	if packed == null:
		_failures.append("Failed to load station_01.tscn")
		return
	var station := packed.instantiate() as Station01
	root.add_child(station)
	await _run_physics(8)
	var player := station.get_node_or_null("Player") as CharacterBody2D
	if player != null:
		player.global_position = Vector2(206.0, 296.0)
	await _run_physics(10)
	await _shoot("layer_b_before_measurement.png", "DEF-1 warstwa B: stanowisko przed pomiarem, jedyna dostepna czynnosc to rejestrator")
	if not station.run_opening_measurement():
		_failures.append("Station 01 refused the forced opening measurement")
	await _run_physics(int(Station01.MEASUREMENT_PASS_SECONDS * 0.75 * 60.0))
	await _shoot("layer_b_live_pass.png", "DEF-1 warstwa B: przyrzad robi jeden przebieg pomiaru w czasie rzeczywistym")
	var guard := 0
	while station.is_cold_open_active() and guard < 900:
		await physics_frame
		guard += 1
	await _run_physics(6)
	await _shoot("layer_b_gap_and_marta.png", "DEF-1 warstwa B: luka 3 s i wiadomosc Marty z imieniem i godzina na tym samym ekranie")
	var trace := station.get_node_or_null("InstrumentTrace") as VibrationTraceDisplay
	if trace == null or trace.mode != _VibrationTrace.Mode.ARCHIVE:
		_failures.append("Instrument display must end on the archive record")
	var message := station.get_node_or_null("CrispDiegeticText_MartaMessage") as CrispDiegeticText
	if message == null or message.text != _ColdOpenFacts.TEXT_MARTA_MESSAGE:
		_failures.append("Marta's message must be on the instrument screen")
	station.queue_free()
	await process_frame


func _run_physics(frames: int) -> void:
	for _frame in range(maxi(frames, 1)):
		await physics_frame


func _shoot(file_name: String, desc: String) -> void:
	await RenderingServer.frame_post_draw
	var image := root.get_viewport().get_texture().get_image()
	if image == null:
		_failures.append("Viewport image is null for %s" % file_name)
		return
	var err := image.save_png(OUTPUT_ROOT + "/" + file_name)
	if err != OK:
		_failures.append("save_png failed for %s" % file_name)
		return
	_records.append({"file": file_name, "desc": desc})


func _write_report() -> void:
	var f := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_line("PKG-0176 visual evidence — GATE-INTRO cold open (DEF-1)")
	f.store_line("Normal Windows display driver, not headless. 640x360 logical frame.")
	for rec in _records:
		f.store_line("- %s :: %s" % [rec["file"], rec["desc"]])
	for failure in _failures:
		f.store_line("FAIL: " + failure)
	f.close()
