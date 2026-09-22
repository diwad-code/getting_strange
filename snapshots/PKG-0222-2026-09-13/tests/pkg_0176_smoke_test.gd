extends SceneTree

## PKG-0176 gate — P9 PHASE-08 / BUNDLE-30: GATE-INTRO.
##
## Dowód techniczny zimnego otwarcia (`COLD_OPEN_SPEC.md` §8):
##   1. `Nowa gra` nie wpada w wybór Station 01 — prowadzi przez warstwę A.
##   2. Pięć faktów `PLAYER_CONTRACT.md` §3 pada przed rozwidleniem, w ≤ 90 s,
##      z nośnika innego niż menu, ekran tekstu i prompt UI.
##   3. Pojęcie „drgania” powstaje w kolejności §4.3, a słowo pada po niej.
##   4. Warstwa A jest niepomijalna za pierwszym razem i pomijalna później.
##   5. Tryb ograniczonego ruchu nie usuwa żadnego faktu.
##   6. Zero zakazanych ujawnień z §5.
##
## Przebieg M1 startuje od prawdziwego przycisku `Nowa gra` i używa wyłącznie
## semantycznych zdarzeń `InputMap` (ruch, `interact`, `ui_accept`). Bramka
## **nie** dowodzi, że nowa osoba zrozumiała, kim jest Lena — to hipoteza
## odbiorcza i pozostaje bez dowodu (D-012, ADR-003).

const _ColdOpenFacts := preload("res://scripts/campaign/cold_open_facts.gd")
const _VibrationTrace := preload("res://scripts/visual/vibration_trace_display.gd")

const REPORT_PATH := "res://reports/pkg_0176/m1_m5_trace.tsv"
const MEASUREMENT_RIG_X := 237.0
const SAMPLE_CASE_X := 375.0
const M5_BUDGET_SECONDS := 90.0

var _failures: Array[String] = []
var _trace_rows: PackedStringArray = PackedStringArray([
	"case\tsim_seconds\twall_ms\tresult\tnote",
])
var _frames := 0


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0176: " + message)


func _run() -> void:
	print("=== PKG-0176 Smoke Test: GATE-INTRO cold open ===")
	_test_catalog()
	_test_forbidden_reveals()
	_test_trace_shape()
	_test_layer_a_is_not_a_text_screen()
	await _test_first_run_from_new_game()
	await _test_skippability()
	await _test_reduced_motion_keeps_every_fact()
	_test_no_new_binaries()
	_write_trace()
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
	MotionAccessibility.reset()
	if _failures.is_empty():
		print("PKG-0176 SMOKE PASS: GATE-INTRO — five facts before the fork, concept order intact.")
		quit(0)
	else:
		printerr("PKG-0176 FAIL: %d failure(s)." % _failures.size())
		quit(1)


# ─── 1. Katalog nośników ─────────────────────────────────────────────────────

func _test_catalog() -> void:
	print("1. Every contract fact has one carrier and the carrier is not menu/text/UI...")
	var catalog: Dictionary = _ColdOpenFacts.catalog()
	_expect(catalog.size() == 5, "Cold open must carry exactly the five PLAYER_CONTRACT §3 facts (got %d)" % catalog.size())
	for fact_id in catalog.keys():
		var spec: Dictionary = catalog[fact_id]
		_expect(String(spec.get("contract_row", "")).length() > 0, "%s missing contract_row" % fact_id)
		_expect(String(spec.get("carrier", "")).length() > 0, "%s missing carrier" % fact_id)
		var kind := String(spec.get("carrier_kind", ""))
		_expect(kind in _ColdOpenFacts.ALLOWED_CARRIER_KINDS, "%s carrier_kind %s is not an allowed carrier" % [fact_id, kind])
		_expect(not (kind in _ColdOpenFacts.FORBIDDEN_CARRIER_KINDS), "%s uses a forbidden carrier kind %s" % [fact_id, kind])
	_expect(_ColdOpenFacts.VIBRATION_ORDER.size() == 5, "Vibration concept order must have five steps")


# ─── 2. Lint zakazanych ujawnień (§5) ────────────────────────────────────────

func _test_forbidden_reveals() -> void:
	print("2. Cold open text reveals nothing from COLD_OPEN_SPEC §5...")
	for text in _ColdOpenFacts.all_texts():
		var found: Array[String] = _ColdOpenFacts.forbidden_reveals_in(text)
		_expect(found.is_empty(), "Cold open text '%s' reveals forbidden material: %s" % [text, ", ".join(found)])
	# Warstwa A nie wolno, żeby nazwała pojęcie zanim je pokaże: w jej napisach
	# słowo „drgania” w żadnej odmianie nie występuje.
	for text in [
		_ColdOpenFacts.TEXT_TRACK_LABEL, _ColdOpenFacts.TEXT_TIME_LEFT,
		_ColdOpenFacts.TEXT_TIME_MID, _ColdOpenFacts.TEXT_TIME_RIGHT,
		_ColdOpenFacts.TEXT_GAP_MARKER, _ColdOpenFacts.TEXT_ARCHIVE_LABEL,
	]:
		_expect(not text.to_lower().contains("drga"), "Layer A label '%s' names the concept before showing it" % text)


# ─── 3. Kształt przebiegu ────────────────────────────────────────────────────

func _test_trace_shape() -> void:
	print("3. The archive record is flat for three seconds and noisy around it...")
	var display: VibrationTraceDisplay = _VibrationTrace.new()
	display.mode = _VibrationTrace.Mode.ARCHIVE
	var window: Vector2 = display.gap_window()
	var gap_fraction := window.y - window.x
	_expect(
		absf(gap_fraction - _VibrationTrace.GAP_SECONDS / _VibrationTrace.WINDOW_SECONDS) < 0.001,
		"Archive gap must span exactly %.1f s of the %.1f s window" % [_VibrationTrace.GAP_SECONDS, _VibrationTrace.WINDOW_SECONDS]
	)
	var inside_max := 0.0
	for step in range(41):
		var t: float = lerpf(window.x, window.y, float(step) / 40.0)
		inside_max = maxf(inside_max, absf(display.sample_amplitude(t)))
	_expect(inside_max == 0.0, "Archive gap must be a flat line (max amplitude %.4f)" % inside_max)
	var outside_max := 0.0
	for step in range(201):
		var t := float(step) / 200.0
		if display.is_in_gap(t):
			continue
		outside_max = maxf(outside_max, absf(display.sample_amplitude(t)))
	_expect(outside_max > 0.05, "Archive record around the gap must keep normal noise (max %.4f)" % outside_max)

	# Przebieg na żywo: szum, skok przy przejeździe, powrót do szumu.
	display.mode = _VibrationTrace.Mode.LIVE
	display.pass_progress = 1.0
	var spike := absf(display.sample_amplitude(_VibrationTrace.SPIKE_CENTER))
	var before := absf(display.sample_amplitude(_VibrationTrace.SPIKE_CENTER - 0.30))
	var after := absf(display.sample_amplitude(_VibrationTrace.SPIKE_CENTER + 0.30))
	_expect(spike > 0.6, "Live pass must spike when the tram goes by (got %.3f)" % spike)
	_expect(before < 0.25 and after < 0.25, "Live pass must sit in noise before and after the spike")
	display.free()


# ─── 4. Warstwa A nie jest ekranem tekstu ────────────────────────────────────

func _test_layer_a_is_not_a_text_screen() -> void:
	print("4. Layer A is a Godot scene, not a video and not a paragraph screen...")
	var packed := load("res://scenes/shell/cold_open.tscn") as PackedScene
	_expect(packed != null, "Cold open scene must load")
	if packed == null:
		return
	var instance := packed.instantiate()
	_expect(instance is ColdOpen, "Cold open root must be the ColdOpen scene script")
	_expect(instance is Node2D, "Layer A must be a drawn Godot scene, not a VideoStreamPlayer")
	for child in instance.get_children():
		_expect(not (child is VideoStreamPlayer), "Layer A must not use a video file")
	var total: float = (instance as ColdOpen).total_seconds()
	_expect(total >= 12.0 and total <= 16.0, "Layer A must run 12-16 s (got %.1f s)" % total)
	instance.free()


# ─── 5. Przebieg M1 od `Nowa gra` ────────────────────────────────────────────

func _test_first_run_from_new_game() -> void:
	print("5. M1: Nowa gra -> layer A -> layer B; five facts before the fork...")
	var state := _fresh_profile()
	if state == null:
		return
	# Ten jeden przypadek jest pelnym przebiegiem M1, wiec zmiany scen musza
	# byc prawdziwe: tytul -> warstwa A -> Station 01.
	state.campaign_auto_transition_enabled = true
	var started := Time.get_ticks_msec()
	_frames = 0

	var cold_open := await _press_new_game()
	if cold_open == null:
		return
	# Kryterium 1: `Nowa gra` nie wpada prosto w wybór Station 01.
	_expect(not (cold_open is Station01), "Nowa gra must not drop straight into the Station 01 fork")
	_expect(cold_open is ColdOpen, "Nowa gra must route through the cold open layer A")
	# Kryterium 4a: za pierwszym razem warstwa A nie jest pomijalna.
	_expect(not (cold_open as ColdOpen).is_skippable(), "Layer A must not be skippable on the first run")
	_expect(not (cold_open as ColdOpen).skip_for_test(), "skip_for_test must refuse before the first completion")

	var station := await _await_station_01(2400)
	if station == null:
		return
	_expect(_ColdOpenFacts.is_layer_a_done(state), "Layer A must record its own completion")

	# Warstwa B: nic poza pomiarem nie działa, dopóki rozwidlenie jest zamknięte.
	var player := station.get_node("Player") as PrototypePlayer
	await _advance_all_dialogue(station)
	_expect(station.is_cold_open_active(), "Station 01 must open in the cold open stage")
	await _walk_right_to(player, SAMPLE_CASE_X, 300)
	await _press_semantic_action(&"interact")
	_expect(station.opening_choice.is_empty(), "The Station 01 fork must stay shut during the cold open")
	_expect(not station.is_sample_secured, "The sample case must not commit during the cold open")

	await _walk_left_to(player, MEASUREMENT_RIG_X, 300)
	await _press_semantic_action(&"interact")
	_expect(not station.is_cold_open_active() or station.cold_open_stage != 0, "interact at the rig must start the forced measurement")

	var guard := 0
	while station.is_cold_open_active() and guard < 900:
		await physics_frame
		_frames += 1
		guard += 1
	_expect(not station.is_cold_open_active(), "The cold open must resolve into the Station 01 fork")

	var sim_seconds := float(_frames) / 60.0
	var wall_ms := Time.get_ticks_msec() - started

	# Kryterium 3: pięć faktów istnieje przed pierwszym wyborem otwarcia.
	var missing: Array[StringName] = _ColdOpenFacts.missing_facts(state)
	_expect(missing.is_empty(), "Facts missing before the fork: %s" % ", ".join(_as_strings(missing)))
	_expect(station.opening_choice.is_empty(), "No opening choice may be committed before the facts land")
	for fact_id in _ColdOpenFacts.fact_ids():
		var note := _ColdOpenFacts.fact_note(state, fact_id)
		var carrier := String((_ColdOpenFacts.CATALOG[String(fact_id)] as Dictionary).get("carrier", ""))
		_expect(note.begins_with(carrier), "%s must be carried by %s (got %s)" % [fact_id, carrier, note])

	# Kolejność pojęcia „drgania” i M5.
	_expect(_ColdOpenFacts.vibration_order_intact(state), "The vibration concept order from §4.3 must hold")
	_expect(sim_seconds <= M5_BUDGET_SECONDS, "M5: five facts must land within %.0f s (got %.1f s)" % [M5_BUDGET_SECONDS, sim_seconds])
	_trace_rows.append("gate_intro_first_run\t%.2f\t%d\t%s\tNowa gra -> layer A -> forced measurement; 5/5 carriers, concept order intact" % [
		sim_seconds, wall_ms, "PASS" if missing.is_empty() else "FAIL",
	])

	# Rozwidlenie działa dopiero teraz i nie zmieniło swojego kontraktu.
	_expect(station.repeat_line_four_measurement(), "The repeat must be available once the cold open resolves")
	_expect(station.secure_raw_sample(), "The sample branch must still commit after the cold open")
	_expect(station.read_marta_message(), "Marta's reply must still be readable after the choice")
	_expect(station.is_exit_unlocked, "PKG-0175: the Station 01 exit stays open")
	station.queue_free()
	await process_frame


# ─── 6. Pomijalność ──────────────────────────────────────────────────────────

func _test_skippability() -> void:
	print("6. Layer A is skippable only after the first completion...")
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		return
	state.campaign_auto_transition_enabled = false
	state.cold_open_seen = false
	var first := _spawn_cold_open()
	if first == null:
		return
	_expect(not first.is_skippable(), "A never-seen cold open must not be skippable")
	_expect(not first.skip_for_test(), "A never-seen cold open must refuse to skip")
	first.free()

	state.cold_open_seen = true
	var second := _spawn_cold_open()
	if second == null:
		return
	_expect(second.is_skippable(), "A seen cold open must be skippable")
	_expect(second.skip_for_test(), "A seen cold open must skip on request")
	_expect(second.is_finished(), "Skipping must finish layer A")
	second.free()
	state.campaign_auto_transition_enabled = false


# ─── 7. Tryb ograniczonego ruchu ─────────────────────────────────────────────

func _test_reduced_motion_keeps_every_fact() -> void:
	print("7. Reduced motion shortens movement and removes no fact...")
	var state := _fresh_profile()
	if state == null:
		return
	MotionAccessibility.set_reduced_motion(true)
	var cold_open := _spawn_cold_open()
	if cold_open == null:
		MotionAccessibility.reset()
		return
	var total: float = cold_open.total_seconds()
	_expect(total >= 12.0 and total <= 16.0, "Reduced motion layer A must stay inside 12-16 s (got %.1f s)" % total)
	var frames := 0
	while not cold_open.is_finished() and frames < 1400:
		await physics_frame
		frames += 1
	_expect(cold_open.is_finished(), "Reduced motion layer A must still reach its end")
	cold_open.queue_free()
	await process_frame

	var station := await _spawn_station_01()
	if station == null:
		MotionAccessibility.reset()
		return
	_expect(station.run_opening_measurement(), "Reduced motion must keep the forced measurement playable")
	var guard := 0
	while station.is_cold_open_active() and guard < 900:
		await physics_frame
		guard += 1
	var missing: Array[StringName] = _ColdOpenFacts.missing_facts(state)
	_expect(missing.is_empty(), "Reduced motion dropped facts: %s" % ", ".join(_as_strings(missing)))
	if not _ColdOpenFacts.vibration_order_intact(state):
		var ordinals: Array[String] = []
		for step_id in _ColdOpenFacts.VIBRATION_ORDER:
			ordinals.append("%s=%d" % [String(step_id), _ColdOpenFacts.step_ordinal(state, step_id)])
		_expect(false, "Reduced motion must keep the §4.3 concept order (%s)" % ", ".join(ordinals))
	_trace_rows.append("gate_intro_reduced_motion\t%.2f\t0\t%s\treduced motion keeps 5/5 carriers" % [
		float(frames + guard) / 60.0, "PASS" if missing.is_empty() else "FAIL",
	])
	station.queue_free()
	await process_frame
	MotionAccessibility.reset()


# ─── 8. D-168 ────────────────────────────────────────────────────────────────

## Stan zastany na wejsciu PKG-0176: jeden dawny build z PKG-0154 i dwa
## pliki silnika. D-168 blokuje NOWE binaria, nie kasuje starych, wiec bramka
## porownuje zbior sciezek, a nie zeruje licznik.
const KNOWN_EXE_PATHS: Array[String] = [
	"res://dist/windows/GettingStrange.exe",
	"res://Godot_v4.6.3-stable_win64.exe",
	"res://Godot_v4.6.3-stable_win64_console.exe",
]


func _test_no_new_binaries() -> void:
	print("8. D-168: no new packaged .exe...")
	var found: Array[String] = []
	_collect_exe("res://", found)
	found.sort()
	for path in found:
		_expect(path in KNOWN_EXE_PATHS, "PKG-0176 must not add a packaged .exe: %s" % path)


func _collect_exe(path: String, into: Array[String]) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if entry.begins_with("."):
			entry = dir.get_next()
			continue
		var child := path.path_join(entry)
		if dir.current_is_dir():
			if not (entry in ["snapshots", "archive_retired_web", ".godot", "reports"]):
				_collect_exe(child, into)
		elif entry.to_lower().ends_with(".exe"):
			into.append(child)
		entry = dir.get_next()
	dir.list_dir_end()


# ─── Pomocnicze ──────────────────────────────────────────────────────────────

func _fresh_profile() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	if state == null:
		return null
	state.reset_campaign(true)
	state.cold_open_seen = false
	state.campaign_auto_transition_enabled = false
	return state


func _spawn_cold_open() -> ColdOpen:
	var packed := load("res://scenes/shell/cold_open.tscn") as PackedScene
	if packed == null:
		_expect(false, "Cold open scene must load")
		return null
	var instance := packed.instantiate() as ColdOpen
	root.add_child(instance)
	return instance


func _spawn_station_01() -> Station01:
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	if packed == null:
		_expect(false, "Station 01 scene must load")
		return null
	var station := packed.instantiate() as Station01
	root.add_child(station)
	for _frame in range(6):
		await physics_frame
	return station


func _press_new_game() -> Node:
	var err := change_scene_to_file("res://scenes/shell/title_screen.tscn")
	_expect(err == OK, "M1 must start from the actual title scene")
	for _frame in range(6):
		await process_frame
	var title := current_scene as TitleScreen
	_expect(title != null, "M1 title scene must become current")
	if title == null:
		return null
	var new_game := title.get_node_or_null("TitlePanel/NewGameButton") as Button
	_expect(new_game != null, "M1 must find the real Nowa gra button")
	if new_game == null:
		return null
	new_game.grab_focus()
	await _press_semantic_action(&"ui_accept")
	for _frame in range(360):
		await process_frame
		if current_scene != null and current_scene != title:
			break
	return current_scene


func _await_station_01(frame_limit: int) -> Station01:
	for _frame in range(frame_limit):
		await physics_frame
		_frames += 1
		if current_scene is Station01:
			break
	_expect(current_scene is Station01, "Layer A must cut to Station 01")
	return current_scene as Station01


func _walk_right_to(player: PrototypePlayer, target_x: float, frame_limit: int) -> void:
	Input.action_press(&"move_right")
	for _frame in range(frame_limit):
		await physics_frame
		_frames += 1
		if player.global_position.x >= target_x - 3.0:
			break
	Input.action_release(&"move_right")
	_expect(player.global_position.x >= target_x - 10.0, "Semantic move_right must reach x=%.0f (got %.1f)" % [target_x, player.global_position.x])


func _walk_left_to(player: PrototypePlayer, target_x: float, frame_limit: int) -> void:
	Input.action_press(&"move_left")
	for _frame in range(frame_limit):
		await physics_frame
		_frames += 1
		if player.global_position.x <= target_x + 3.0:
			break
	Input.action_release(&"move_left")
	_expect(player.global_position.x <= target_x + 10.0, "Semantic move_left must reach x=%.0f (got %.1f)" % [target_x, player.global_position.x])


func _press_semantic_action(action: StringName) -> void:
	var pressed := InputEventAction.new()
	pressed.action = action
	pressed.pressed = true
	Input.parse_input_event(pressed)
	await process_frame
	var released := InputEventAction.new()
	released.action = action
	released.pressed = false
	Input.parse_input_event(released)
	await process_frame


func _advance_all_dialogue(station: Node) -> void:
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue == null:
		return
	for _step in range(16):
		if not dialogue.is_presenting():
			break
		await _press_semantic_action(&"interact")


func _as_strings(values: Array[StringName]) -> Array[String]:
	var out: Array[String] = []
	for value in values:
		out.append(String(value))
	return out


func _write_trace() -> void:
	var absolute_dir := ProjectSettings.globalize_path(REPORT_PATH.get_base_dir())
	DirAccess.make_dir_recursive_absolute(absolute_dir)
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string("\n".join(_trace_rows) + "\n")
	file.close()
