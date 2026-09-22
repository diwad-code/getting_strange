class_name ColdOpen
extends Node2D

## PKG-0176 / DEF-1 — warstwa A zimnego otwarcia (`COLD_OPEN_SPEC.md` §3).
##
## Trzy ujęcia, jedno cięcie między nimi, zero tekstu ekspozycyjnego. Scena nie
## jest adresem kampanii: nie wchodzi do `CAMPAIGN_ROUTE`, nie ma `ReturnZone`,
## nie liczy się do budżetu 20 adresów ani do GATE-INT (spec §7).
##
## Sekwencja chodzi po `_physics_process`, nie po `_process`: czas ujęć jest
## wtedy funkcją kroku 60 Hz, a nie tempa renderowania, więc trwa dokładnie tyle
## samo w grze, w bramce nagłówkowej i w capture.
##
## Cały obraz ujęcia powstaje w jednym `_draw()`, żeby kolejność warstw —
## ballast, szyna, sylwetka, obejma, rękawica, ciemność nad pulą światła — była
## jawna i nie zależała od kolejności węzłów w drzewie.
##
## Warstwa A ustanawia dwa z pięciu faktów `PLAYER_CONTRACT.md` §3 (sylwetka
## przy pracy technicznej, maszyna robiąca swoje) plus rozbieżność zapisu, oraz
## pierwsze cztery kroki pojęcia „drgania”. Trzeci fakt o narzędziu i fakt o
## Marcie należą do warstwy B w `Station01`.

const ColdOpenFactsScript := preload("res://scripts/campaign/cold_open_facts.gd")
const VibrationTraceDisplayScript := preload("res://scripts/visual/vibration_trace_display.gd")

const LOGICAL_SIZE := Vector2(640.0, 360.0)
const STATION_ONE_SCENE := "res://scenes/levels/station_01.tscn"
## Ujecie 2 jest plansza wygenerowana w tym samym pipelinie co kazda klatka
## Leny: referencja -> `gen-ai character` -> `tools/process_cold_open_plate.py`
## (D-186, `CAST_AND_NPC_BIBLE.md`). Anatomii postaci nie wolno przedluzac
## prymitywami silnika, wiec dlonie, rekawice, obejma i kabel przychodza z
## jednego rysunku, nie z `draw_circle`.
const SHOT_TWO_PLATE := "res://assets/cold_open/shot2_rail_hands.png"

## Ujęcia 1–3. Suma 14,5 s mieści się w oknie 12–16 s ze spec §2.
const SHOT_SECONDS: Array[float] = [5.5, 4.5, 4.5]
## Tryb ograniczonego ruchu skraca przejazd i zdejmuje panoramę; treść ujęć
## zostaje bez zmian (D-151, spec §3 „Reguły warstwy A”). Suma 12,5 s.
const SHOT_SECONDS_REDUCED: Array[float] = [4.5, 4.0, 4.0]

const TRAM_ENTER_AT := 0.9
const TRAM_CROSS_SECONDS := 2.4
const TRAM_CROSS_SECONDS_REDUCED := 1.3
const PAN_DISTANCE := 18.0

## Ujęcie 3: kiedy przebieg na żywo startuje i kiedy przewija się do archiwum.
const LIVE_PASS_START := 0.35
const LIVE_PASS_SECONDS := 2.0
const ARCHIVE_AT := 2.9

## Szyna biegnie blizej kamery niz Lena i przecina kadr na wysokosci jej goleni,
## wiec sylwetka czyta sie za nia, a nie za barierka.
## Srodek obejmy w plaszy ujecia 2 — tam swieci lampa robocza.
const MOUNT_CENTER := Vector2(478.0, 274.0)

const SKIP_HINT_KEY := "COLD_OPEN_SKIP"

signal cold_open_finished(skipped: bool)

var _game_state: Node
var _shot := 0
var _shot_time := 0.0
var _elapsed := 0.0
var _finished := false
var _can_skip := false
var _reduced := false
var _tram_sound_played := false
var _tram_reported := false
var _identity_reported := false
var _archive_reported := false
var _shot_two_plate: Texture2D
var _trace: VibrationTraceDisplay
var _audio: AudioStreamPlayer
var _labels: Array[Node2D] = []
var _skip_label: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_game_state = get_node_or_null("/root/GameStateManager")
	_reduced = MotionAccessibility.is_reduced_motion()
	_can_skip = _game_state != null and bool(_game_state.is_cold_open_seen())
	_shot_two_plate = load(SHOT_TWO_PLATE) as Texture2D
	_build_nodes()
	_enter_shot(0)
	queue_redraw()


func _build_nodes() -> void:
	_audio = AudioStreamPlayer.new()
	_audio.name = "ColdOpenAudio"
	add_child(_audio)

	_trace = VibrationTraceDisplayScript.new()
	_trace.name = "InstrumentTrace"
	_trace.screen_size = Vector2(432.0, 154.0)
	_trace.position = Vector2(104.0, 116.0)
	_trace.draw_bezel = false
	_trace.visible = false
	add_child(_trace)

	var skip_layer := CanvasLayer.new()
	skip_layer.name = "SkipLayer"
	skip_layer.layer = 12
	add_child(skip_layer)
	_skip_label = Label.new()
	_skip_label.name = "SkipHint"
	_skip_label.text = LocalizationManager.tr_key(SKIP_HINT_KEY)
	_skip_label.position = Vector2(548.0, 330.0)
	_skip_label.add_theme_font_size_override(&"font_size", 9)
	_skip_label.add_theme_color_override(&"font_color", VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.34))
	_skip_label.visible = _can_skip
	skip_layer.add_child(_skip_label)


# ─── Sekwencja ───────────────────────────────────────────────────────────────

func shot_seconds(index: int) -> float:
	var table := SHOT_SECONDS_REDUCED if _reduced else SHOT_SECONDS
	return table[clampi(index, 0, table.size() - 1)]


func total_seconds() -> float:
	var total := 0.0
	for index in range(SHOT_SECONDS.size()):
		total += shot_seconds(index)
	return total


func get_shot_index() -> int:
	return _shot


func get_elapsed_seconds() -> float:
	return _elapsed


func is_skippable() -> bool:
	return _can_skip


func is_finished() -> bool:
	return _finished


func get_trace_display() -> VibrationTraceDisplay:
	return _trace


func _enter_shot(index: int) -> void:
	_shot = index
	_shot_time = 0.0
	_clear_labels()
	_trace.visible = index == 2
	position = Vector2.ZERO
	match index:
		1:
			_play(&"cold_open_mount", ProceduralAudio.create_switch_toggle_sound)
		2:
			_trace.mode = VibrationTraceDisplayScript.Mode.LIVE
			_trace.pass_progress = 0.0
			_spawn_label(ColdOpenFactsScript.TEXT_TRACK_LABEL, Vector2(104.0, 90.0), VectorStageStyle.ANCHOR_CYAN, 11)
			var axis_color := VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.16)
			_spawn_label(ColdOpenFactsScript.TEXT_TIME_LEFT, Vector2(104.0, 278.0), axis_color, 9)
			_spawn_label(ColdOpenFactsScript.TEXT_TIME_MID, Vector2(306.0, 278.0), axis_color, 9)
			_spawn_label(ColdOpenFactsScript.TEXT_TIME_RIGHT, Vector2(512.0, 278.0), axis_color, 9)
	queue_redraw()


func _physics_process(delta: float) -> void:
	if _finished:
		return
	_shot_time += delta
	_elapsed += delta
	match _shot:
		0:
			_update_shot_track()
		1:
			_update_shot_work()
		2:
			_update_shot_gap()
	if _shot_time >= shot_seconds(_shot):
		if _shot >= 2:
			_finish(false)
		else:
			_enter_shot(_shot + 1)
	queue_redraw()


func _tram_cross_seconds() -> float:
	return TRAM_CROSS_SECONDS_REDUCED if _reduced else TRAM_CROSS_SECONDS


func _update_shot_track() -> void:
	var cross := _tram_cross_seconds()
	if not _reduced:
		var pan_t := clampf((_shot_time - TRAM_ENTER_AT) / maxf(cross, 0.001), 0.0, 1.0)
		position = Vector2(-PAN_DISTANCE * pan_t, 0.0)
	if not _tram_sound_played and _shot_time >= TRAM_ENTER_AT:
		_tram_sound_played = true
		_play(&"cold_open_tram", ProceduralAudio.create_tram_traction_sound)
	if not _tram_reported and _shot_time >= TRAM_ENTER_AT + cross:
		_tram_reported = true
		# Maszyna wykonała swoją pracę bez gracza — nośnik faktu „to jest
		# miejsce pracy” i zarazem przyczyna w kolejności §4.3.
		ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_WORKPLACE)
		ColdOpenFactsScript.record_step(ColdOpenFactsScript.STEP_TRAM_PASSED)


func _update_shot_work() -> void:
	if not _identity_reported and _shot_time >= 1.2:
		_identity_reported = true
		ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_IDENTITY_WORK, "gen_ai_plate_shot_2")


func _update_shot_gap() -> void:
	if _shot_time < ARCHIVE_AT:
		_trace.mode = VibrationTraceDisplayScript.Mode.LIVE
		_trace.pass_progress = clampf((_shot_time - LIVE_PASS_START) / LIVE_PASS_SECONDS, 0.0, 1.0)
		if _trace.has_reached_spike():
			if ColdOpenFactsScript.record_step(ColdOpenFactsScript.STEP_TRACE_SPIKED):
				_play(&"cold_open_spike", ProceduralAudio.create_needle_spike_sound)
		if _trace.has_returned_to_noise():
			ColdOpenFactsScript.record_step(ColdOpenFactsScript.STEP_TRACE_REST)
		return
	if _trace.mode != VibrationTraceDisplayScript.Mode.ARCHIVE:
		_trace.mode = VibrationTraceDisplayScript.Mode.ARCHIVE
		_play(&"cold_open_archive", ProceduralAudio.create_printer_strip_sound)
		_spawn_label(ColdOpenFactsScript.TEXT_ARCHIVE_LABEL, Vector2(342.0, 90.0), VectorStageStyle.CORRECTION_OXIDE, 10)
		_spawn_label(ColdOpenFactsScript.TEXT_GAP_MARKER, Vector2(292.0, 232.0), VectorStageStyle.CORRECTION_OXIDE, 11)
	if not _archive_reported and _shot_time >= ARCHIVE_AT + 0.5:
		_archive_reported = true
		ColdOpenFactsScript.record_step(ColdOpenFactsScript.STEP_ARCHIVE_GAP)
		ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_MEASUREMENT_OFF, "layer_a_shot_3")


func _unhandled_input(event: InputEvent) -> void:
	if _finished or not _can_skip:
		return
	var pressed := (
		(event is InputEventKey and (event as InputEventKey).pressed and not (event as InputEventKey).echo)
		or (event is InputEventJoypadButton and (event as InputEventJoypadButton).pressed)
		or (event is InputEventMouseButton and (event as InputEventMouseButton).pressed)
		or (event is InputEventAction and (event as InputEventAction).pressed)
	)
	if not pressed:
		return
	get_viewport().set_input_as_handled()
	_finish(true)


## Pominięcie wywołane przez bramkę. Zwraca `false`, kiedy sekwencja nie jest
## jeszcze pomijalna — to jest dokładnie kontrakt „za pierwszym razem nie”.
func skip_for_test() -> bool:
	if _finished or not _can_skip:
		return false
	_finish(true)
	return true


func _finish(skipped: bool) -> void:
	if _finished:
		return
	_finished = true
	if skipped:
		# Pominięcie jest dozwolone dopiero po pierwszym ukończeniu, więc kroki
		# pojęcia zostały już raz pokazane. Zapisujemy je z własną adnotacją,
		# żeby rejestr nie udawał, że gracz obejrzał je w tym przebiegu.
		for step_id in ColdOpenFactsScript.VIBRATION_ORDER:
			if step_id == ColdOpenFactsScript.STEP_WORD_SPOKEN:
				continue
			ColdOpenFactsScript.record_step(step_id, "skipped_seen_before")
		ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_WORKPLACE, "skipped_seen_before")
		ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_IDENTITY_WORK, "skipped_seen_before")
		ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_MEASUREMENT_OFF, "skipped_seen_before")
	if _game_state != null:
		_game_state.record_decision(ColdOpenFactsScript.LAYER_A_DONE, true)
		_game_state.record_decision(ColdOpenFactsScript.SEEN, true)
		_game_state.mark_cold_open_seen()
	cold_open_finished.emit(skipped)
	_go_to_station_one()


func _go_to_station_one() -> void:
	if _game_state != null:
		# Ten sam przelacznik, ktorego uzywaja bramki kampanii: pozwala sprawdzic
		# sama sekwencje bez realnej zmiany sceny (`campaign_auto_transition_enabled`).
		if not bool(_game_state.campaign_auto_transition_enabled):
			return
		_game_state.transition_to_station(&"station_01")
		return
	get_tree().change_scene_to_file(STATION_ONE_SCENE)


# ─── Napisy diegetyczne ──────────────────────────────────────────────────────

func _spawn_label(text_value: String, at: Vector2, color: Color, size: int) -> void:
	var label := CrispDiegeticText.new()
	label.name = "ColdOpenLabel%d" % _labels.size()
	label.position = at
	label.font_size = size
	label.text_color = color
	label.show_border = false
	label.backdrop_color = Color(0.04, 0.05, 0.07, 0.0)
	label.text = text_value
	add_child(label)
	_labels.append(label)


func _clear_labels() -> void:
	for label in _labels:
		if is_instance_valid(label):
			label.queue_free()
	_labels.clear()


func _play(cache_key: StringName, generator: Callable) -> void:
	if _audio == null:
		return
	_audio.stream = ProceduralAudio.get_cached_sound(cache_key, generator)
	_audio.play()


# ─── Rysunek ─────────────────────────────────────────────────────────────────

func _draw() -> void:
	# Tło jest większe od kadru, więc panorama nigdy nie odsłania pustki.
	draw_rect(Rect2(-96.0, -48.0, LOGICAL_SIZE.x + 192.0, LOGICAL_SIZE.y + 96.0), VectorStageStyle.INK)
	match _shot:
		0:
			_draw_shot_track()
		1:
			_draw_shot_work()
		2:
			_draw_shot_gap()


func _draw_shot_track() -> void:
	# Nocne torowisko Linii 4: niebo, sylwety zabudowy w głębi, sieć trakcyjna.
	draw_rect(Rect2(-96.0, -48.0, LOGICAL_SIZE.x + 192.0, 240.0), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.56))
	for block in [Vector2(-52.0, 104.0), Vector2(104.0, 78.0), Vector2(262.0, 116.0), Vector2(424.0, 88.0), Vector2(560.0, 122.0)]:
		draw_rect(Rect2(block.x, block.y, 98.0, 286.0 - block.y), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.32))
	draw_line(Vector2(-96.0, 68.0), Vector2(736.0, 74.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.52), 1.0)
	draw_rect(Rect2(78.0, 68.0, 5.0, 218.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.18))
	VectorStageStyle.draw_faceted_lamp(self, Vector2(508.0, 84.0), 26.0)

	# Torowisko: podkłady i dwie szyny.
	draw_rect(Rect2(-96.0, 286.0, LOGICAL_SIZE.x + 192.0, 122.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.46))
	for sleeper in range(0, 19):
		draw_rect(Rect2(-96.0 + float(sleeper) * 46.0, 302.0, 30.0, 8.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.24))
	draw_line(Vector2(-96.0, 292.0), Vector2(736.0, 292.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(-96.0, 318.0), Vector2(736.0, 318.0), VectorStageStyle.LIGHT_PLANE, 2.0)

	var t := (_shot_time - TRAM_ENTER_AT) / maxf(_tram_cross_seconds(), 0.001)
	if t < 0.0 or t > 1.16:
		return
	_draw_tram(lerpf(-272.0, 716.0, clampf(t, 0.0, 1.16)))


func _draw_tram(x: float) -> void:
	var top := 194.0
	draw_rect(Rect2(x, top, 244.0, 94.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.04))
	draw_rect(Rect2(x, top, 244.0, 94.0), VectorStageStyle.LIGHT_PLANE, false, 1.0)
	draw_rect(Rect2(x + 6.0, top - 10.0, 232.0, 10.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	for window in range(6):
		draw_rect(Rect2(x + 14.0 + float(window) * 38.0, top + 16.0, 28.0, 30.0), Color(VectorStageStyle.HUMAN_AMBER, 0.46))
	draw_rect(Rect2(x + 212.0, top + 56.0, 26.0, 12.0), Color(VectorStageStyle.HUMAN_AMBER, 0.74))
	draw_circle(Vector2(x + 44.0, top + 94.0), 8.0, VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.10))
	draw_circle(Vector2(x + 198.0, top + 94.0), 8.0, VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.10))


func _draw_shot_work() -> void:
	# Cale ujecie jest jedna plansza: szyna, przymocowany czujnik, kabel i dlonie
	# Leny w rekawicach. Kadr zaczyna sie ponizej brody, wiec twarz zostaje poza
	# ujeciem — `COLD_OPEN_SPEC.md` §3: „twarz jeszcze nie”.
	if _shot_two_plate != null:
		draw_texture_rect(_shot_two_plate, Rect2(Vector2.ZERO, LOGICAL_SIZE), false)

	# Lampa robocza swieci na obejme. To jedyna warstwa, ktora silnik dokłada do
	# planszy — swiatlo, nie anatomia.
	for ring in range(6):
		draw_circle(MOUNT_CENTER, 40.0 + float(ring) * 24.0, Color(VectorStageStyle.HUMAN_AMBER, 0.022))

	# Winieta domyka noc na krawedziach kadru.
	for band in range(14):
		var alpha := 0.055 * (1.0 - float(band) / 14.0)
		var inset := float(band) * 2.0
		draw_rect(Rect2(inset, inset, LOGICAL_SIZE.x - inset * 2.0, LOGICAL_SIZE.y - inset * 2.0), Color(VectorStageStyle.INK, alpha), false, 2.0)


func _draw_shot_gap() -> void:
	# Ekran przyrządu wypełnia kadr.
	draw_rect(Rect2(64.0, 76.0, 512.0, 234.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(64.0, 76.0, 512.0, 234.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.44), false, 2.0)
	draw_rect(Rect2(96.0, 108.0, 448.0, 170.0), VectorStageStyle.INK)
	draw_rect(Rect2(96.0, 108.0, 448.0, 170.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.24), false, 1.0)
	draw_rect(Rect2(64.0, 292.0, 512.0, 18.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.28))
	draw_circle(Vector2(556.0, 301.0), 4.0, VectorStageStyle.HUMAN_AMBER)
