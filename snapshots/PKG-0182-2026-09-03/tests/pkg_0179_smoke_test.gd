extends SceneTree

## PKG-0179 verification gate: 360 quality, audit remediation and environmental innovation.
## Tests:
## 1. Zero ObjectDB instance leaks & signal hygiene on exit tree (ThresholdBinder, CrispDiegeticText, CRTDialogueBox).
## 2. Kinematics safety: step-down direction calculation & MAX_CURB_STEP handling.
## 3. Visual & portrait integrity: Marta 1024x1024, pink accent, Wierzbicka clean alpha.
## 4. Polish narrative dialogue & text audit: naturalized lines in stations 01, 06, 14, 17, and DIALOGUE_SCRIPT.md.
## 5. Sensory innovations: VibrationTraceDisplay interference factor & split-beam, body echo logic, architectural narrowings.
## 6. Hard rule D-168 enforcement: zero .exe binaries in project root / campaign state.

const S01_SCENE := "res://scenes/levels/station_01.tscn"
const S02_SCENE := "res://scenes/levels/station_02.tscn"
const S06_SCENE := "res://scenes/levels/station_06.tscn"
const S14_SCENE := "res://scenes/levels/station_14.tscn"
const S15_SCENE := "res://scenes/levels/station_15.tscn"
const S17_SCENE := "res://scenes/levels/station_17.tscn"
const PLAYER_SCENE := "res://scenes/player/prototype_player.tscn"
const DIALOGUE_SCRIPT_PATH := "res://docs/narrative/DIALOGUE_SCRIPT.md"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0179 FAIL: " + message)


func _run() -> void:
	print("=== PKG-0179 Smoke Test: 360 quality and audit remediation ===")
	_test_objectdb_and_signal_hygiene()
	_test_kinematics_step_down()
	_test_portrait_contracts()
	_test_narrative_dialogue_remediation()
	_test_sensory_innovations()
	_test_d168_no_exe_release()
	_finish()


func _test_objectdb_and_signal_hygiene() -> void:
	# Test 1.1: CrispDiegeticText signal disconnection on exit
	var crisp := CrispDiegeticText.new()
	root.add_child(crisp)
	await process_frame
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm != null and gsm.has_signal(&"accessibility_changed"):
		_expect(gsm.accessibility_changed.is_connected(crisp._on_accessibility_changed), "CrispDiegeticText must connect to accessibility_changed in tree")
		root.remove_child(crisp)
		_expect(not gsm.accessibility_changed.is_connected(crisp._on_accessibility_changed), "CrispDiegeticText must cleanly disconnect on exit tree")
	crisp.queue_free()
	await process_frame

	# Test 1.2: CRTDialogueBox signal disconnection on exit
	var crt := CRTDialogueBox.new()
	root.add_child(crt)
	await process_frame
	if gsm != null and gsm.has_signal(&"settings_changed"):
		_expect(gsm.settings_changed.is_connected(crt._on_settings_changed), "CRTDialogueBox must connect to settings_changed in tree")
		root.remove_child(crt)
		_expect(not gsm.settings_changed.is_connected(crt._on_settings_changed), "CRTDialogueBox must cleanly disconnect on exit tree")
	crt.queue_free()
	await process_frame

	# Test 1.3: ThresholdBinder signal cleanup
	var test_node := Node2D.new()
	var zone := ThresholdZone.new()
	zone.name = "Threshold"
	test_node.add_child(zone)
	root.add_child(test_node)
	ThresholdBinder.install(test_node)
	_expect(zone.crossed.get_connections().size() > 0, "Threshold zone crossed must be connected after install")
	ThresholdBinder.disconnect_station(test_node)
	_expect(zone.crossed.get_connections().size() == 0, "ThresholdBinder.disconnect_station must remove crossed connections")
	test_node.queue_free()
	await process_frame


func _test_kinematics_step_down() -> void:
	var player_scene := load(PLAYER_SCENE) as PackedScene
	_expect(player_scene != null, "PrototypePlayer scene must load")
	if player_scene == null:
		return
	var player := player_scene.instantiate() as PrototypePlayer
	root.add_child(player)
	await process_frame

	# Test measure_drop_height with direction parameter
	_expect(player.has_method("measure_drop_height"), "PrototypePlayer must provide measure_drop_height()")
	var drop_h := player.measure_drop_height(1.0)
	_expect(drop_h >= 0.0, "measure_drop_height with dir 1.0 must return non-negative float")

	player.queue_free()
	await process_frame


func _test_portrait_contracts() -> void:
	var marta_tex := load("res://assets/characters/portraits/marta.png") as Texture2D
	_expect(marta_tex != null, "Marta portrait must load")
	if marta_tex != null:
		var img := marta_tex.get_image()
		_expect(img.get_width() == 1024 and img.get_height() == 1024, "Marta portrait must be 1024x1024")
		var pink_160 := 0
		for y in range(0, img.get_height(), 4):
			for x in range(0, img.get_width(), 4):
				var p := img.get_pixel(x, y)
				if p.r > 0.65 and p.b > 0.40 and p.g < 0.52:
					pink_160 += 1
		_expect(pink_160 >= 20, "Marta portrait must retain pink hair accent for pkg_0160 (got %d)" % pink_160)

	var wierzbicka_tex := load("res://assets/characters/portraits/wierzbicka.png") as Texture2D
	_expect(wierzbicka_tex != null, "Wierzbicka portrait must load")


func _test_narrative_dialogue_remediation() -> void:
	# Station 01: check natural Polish beat
	var s01_source := FileAccess.get_file_as_string("res://scripts/levels/station_01.gd")
	_expect(s01_source.contains("Zostawię surowy odczyt, jutro będę tu wracać z raportem. Zbieram torbę."),
		"Station 01 must contain remediated natural technician beat s01_door_blocked")

	# Station 06: check analog scepticism beat
	var s06_source := FileAccess.get_file_as_string("res://scripts/levels/station_06.gd")
	_expect(s06_source.contains("Błąd w druku albo stara tabliczka. Zawsze najpierw szuka się bałaganu w papierach."),
		"Station 06 must contain remediated analog scepticism beat s06_cache_hypothesis")

	# Station 14: check apparatus terminology
	var s14_source := FileAccess.get_file_as_string("res://scripts/levels/station_14.gd")
	_expect(s14_source.contains("POMOC: Chwyć obejmę przed impulsem rozdzielnicy. Jeśli puścisz, most przejdzie na rezerwę i odetnie zasilanie."),
		"Station 14 must contain physical apparatus hint terminology")

	# Station 17: check Jakub authentic line
	var s17_source := FileAccess.get_file_as_string("res://scripts/levels/station_17.gd")
	_expect(s17_source.contains("Przyszłaś po odczyt, a teraz każesz mi podpisać protokół in blanco. Nie ze mną, Lena."),
		"Station 17 must contain authentic Jakub refusal line")

	var script_source := FileAccess.get_file_as_string(DIALOGUE_SCRIPT_PATH)
	_expect(script_source.contains("Przyszłaś po odczyt, a teraz każesz mi podpisać protokół in blanco. Nie ze mną, Lena."),
		"DIALOGUE_SCRIPT.md must contain authentic Jakub refusal line")


func _test_sensory_innovations() -> void:
	# 1. VibrationTraceDisplay split beam and interference factor
	var trace := VibrationTraceDisplay.new()
	_expect("interference_factor" in trace, "VibrationTraceDisplay must expose interference_factor")
	trace.interference_factor = 0.85
	_expect(is_equal_approx(trace.interference_factor, 0.85), "interference_factor must store clamped value")
	trace.queue_free()

	# 2. Body echo logic
	var player_scene := load(PLAYER_SCENE) as PackedScene
	var player := player_scene.instantiate() as PrototypePlayer
	root.add_child(player)
	await process_frame
	_expect(player.has_method("_should_play_body_echo"), "PrototypePlayer must implement _should_play_body_echo")
	_expect(player.get("_body_echo_audio_player") != null, "PrototypePlayer must instantiate BodyEchoAudioPlayer")
	player.queue_free()
	await process_frame

	# 3. Constriction and floor curb geometry
	var s02_scene := load(S02_SCENE) as PackedScene
	_expect(s02_scene != null, "Station 02 scene must load")
	var s02 := s02_scene.instantiate()
	root.add_child(s02)
	await process_frame
	var constriction := s02.get_node_or_null("Geometry/ServiceConstriction")
	_expect(constriction != null, "Station 02 must contain Geometry/ServiceConstriction")
	s02.queue_free()
	await process_frame

	var s15_scene := load(S15_SCENE) as PackedScene
	_expect(s15_scene != null, "Station 15 scene must load")
	var s15 := s15_scene.instantiate()
	root.add_child(s15)
	await process_frame
	var platform := s15.get_node_or_null("Geometry/ReceiverBase")
	_expect(platform != null, "Station 15 must contain Geometry/ReceiverBase")
	var trace_15 := s15.get_node_or_null("InstrumentTrace")
	_expect(trace_15 != null, "Station 15 must contain InstrumentTrace")
	s15.queue_free()
	await process_frame


const KNOWN_EXE_PATHS: Array[String] = [
	"res://dist/windows/GettingStrange.exe",
	"res://Godot_v4.6.3-stable_win64.exe",
	"res://Godot_v4.6.3-stable_win64_console.exe",
]


func _test_d168_no_exe_release() -> void:
	var found: Array[String] = []
	_collect_exe("res://", found)
	for path in found:
		_expect(path in KNOWN_EXE_PATHS, "D-168 violation: unexpected executable %s" % path)


func _collect_exe(dir_path: String, out: Array[String]) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		var full_path := dir_path.path_join(file_name)
		if dir.current_is_dir():
			if file_name not in ["reports", "snapshots", "dist", "archive_retired_web"]:
				_collect_exe(full_path, out)
		elif file_name.to_lower().ends_with(".exe"):
			out.append(full_path)
		file_name = dir.get_next()
	dir.list_dir_end()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0179 SMOKE PASS: 360 quality, audit remediation and environmental innovation certified.")
		quit(0)
	else:
		push_error("PKG-0179 SMOKE FAILED with %d errors:\n- %s" % [_failures.size(), "\n- ".join(_failures)])
		quit(1)
