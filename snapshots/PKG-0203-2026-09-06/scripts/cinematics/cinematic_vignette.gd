class_name CinematicVignette
extends CanvasLayer

## PKG-0190 — odtwarzacz jednej krótkiej sekwencji "cinematic vignette".
##
## Pokazuje 2–5 niemal statycznych, wygenerowanych plansz 640x360 (jak
## `ColdOpen._draw_shot_work()` z jedną planszą gen-ai), z krótkim podpisem
## na natywnym, ostrym panelu (wzorem `CRTDialogueBox`/`InnerThoughtSurface` —
## własny `Panel`+`RichTextLabel` w tej samej warstwie co plansza, nigdy
## `CrispDiegeticText`: ta klasa zakłada osadzenie w świecie gry i zawsze
## renderuje przez własną, globalną warstwę 10, więc pod planszą tej winiety
## byłaby niewidoczna). Tekst nigdy nie jest wypalony w obrazie gen-ai. Cięcia
## między klatkami, bez fade. Zawsze pomijalna jednym wejściem
## `interact`/`ui_accept` od pierwszego wyświetlenia (mocniejszy kontrakt niż
## `ColdOpen`, który pozwala pominąć dopiero po pierwszym pełnym obejrzeniu —
## tu każda winieta jest wzmocnieniem istniejącego faktu, nigdy jego jedynym
## nośnikiem, więc nie ma potrzeby wymuszać pierwszego pełnego obejrzenia).
##
## Warstwa 19: nad `WorldPixelCompositor` (5), `CrispDiegeticTextLayer` (10) i
## `InnerThoughtSurface` (16), pod `CRTDialogueBox` (20) — `CinematicDirector`
## nie wyzwala winiety, gdy `CRTDialogueBox.is_presenting()` jest `true`.

signal cinematic_finished(vignette_id: StringName, skipped: bool)

const LOGICAL_SIZE := Vector2(640.0, 360.0)
const DEFAULT_FRAME_SECONDS := 2.4
const DEFAULT_FRAME_SECONDS_REDUCED := 1.4

var vignette_id: StringName = &""

var _frames: Array[Texture2D] = []
var _captions: Array[String] = []
var _frame_seconds: Array[float] = []
var _frame_seconds_reduced: Array[float] = []
var _reduced := false
var _index := -1
var _elapsed := 0.0
var _finished := false
var _can_skip := true
var _game_state: Node
var _paused_player: Node

var _plate: TextureRect
var _caption_panel: Panel
var _caption_label: RichTextLabel
var _skip_label: Label


## Musi być wywołane zaraz po `CinematicVignette.new()`, przed dodaniem do
## drzewa — `_ready()` odtwarza pierwszą klatkę natychmiast.
func setup(id: StringName, catalog_entry: Dictionary, player_to_pause: Node = null) -> void:
	vignette_id = id
	_frames.clear()
	for path in catalog_entry.get("frames", []):
		var texture := load(String(path)) as Texture2D
		if texture != null:
			_frames.append(texture)
	var raw_captions: Array = catalog_entry.get("captions", [])
	_captions = []
	for line in raw_captions:
		_captions.append(String(line))
	_frame_seconds = _to_float_array(catalog_entry.get("frame_seconds", []))
	_frame_seconds_reduced = _to_float_array(catalog_entry.get("frame_seconds_reduced", _frame_seconds))
	_paused_player = player_to_pause


func _to_float_array(source: Array) -> Array[float]:
	var out: Array[float] = []
	for value in source:
		out.append(float(value))
	return out


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 19
	_game_state = get_node_or_null("/root/GameStateManager")
	_reduced = MotionAccessibility.is_reduced_motion()
	if _paused_player != null and is_instance_valid(_paused_player) and _paused_player.has_method("set_physics_process"):
		_paused_player.set_physics_process(false)
	_build_ui()
	if _frames.is_empty():
		_finish(false)
		return
	_enter_frame(0)


func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.name = "Backdrop"
	backdrop.color = VectorStageStyle.INK
	backdrop.size = LOGICAL_SIZE
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)

	_plate = TextureRect.new()
	_plate.name = "Plate"
	_plate.size = LOGICAL_SIZE
	_plate.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_plate.stretch_mode = TextureRect.STRETCH_SCALE
	_plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_plate)

	_caption_panel = Panel.new()
	_caption_panel.name = "CinematicCaptionPanel"
	_caption_panel.position = Vector2(24.0, 300.0)
	_caption_panel.size = Vector2(592.0, 40.0)
	_caption_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(VectorStageStyle.INK, 0.88)
	style.border_color = VectorStageStyle.HUMAN_AMBER
	style.set_border_width_all(1)
	style.border_width_left = 3
	_caption_panel.add_theme_stylebox_override(&"panel", style)
	_caption_panel.visible = false
	add_child(_caption_panel)

	_caption_label = RichTextLabel.new()
	_caption_label.name = "CinematicCaptionText"
	_caption_label.position = Vector2(12.0, 8.0)
	_caption_label.size = Vector2(568.0, 26.0)
	_caption_label.bbcode_enabled = true
	_caption_label.fit_content = false
	_caption_label.scroll_active = false
	_caption_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_caption_label.add_theme_font_size_override(&"normal_font_size", 13)
	_caption_label.add_theme_color_override(&"default_color", Color("d7e0e3"))
	_caption_panel.add_child(_caption_label)

	var skip_layer := CanvasLayer.new()
	skip_layer.name = "SkipLayer"
	skip_layer.layer = 1
	add_child(skip_layer)
	_skip_label = Label.new()
	_skip_label.name = "SkipHint"
	_skip_label.text = LocalizationManager.tr_key("COLD_OPEN_SKIP")
	_skip_label.position = Vector2(548.0, 20.0)
	_skip_label.add_theme_font_size_override(&"font_size", 9)
	_skip_label.add_theme_color_override(&"font_color", VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.34))
	skip_layer.add_child(_skip_label)


func _enter_frame(index: int) -> void:
	if index >= _frames.size():
		_finish(false)
		return
	_index = index
	_elapsed = 0.0
	_plate.texture = _frames[index]
	var caption_text := "" if index >= _captions.size() else _captions[index]
	_caption_panel.visible = not caption_text.is_empty()
	_caption_label.text = "[color=#d7e0e3]%s[/color]" % caption_text


func _process(delta: float) -> void:
	if _finished or _index < 0:
		return
	_elapsed += delta
	if _elapsed >= _current_frame_duration():
		_enter_frame(_index + 1)


func _current_frame_duration() -> float:
	var table := _frame_seconds_reduced if _reduced else _frame_seconds
	if _index < table.size():
		return table[_index]
	return DEFAULT_FRAME_SECONDS_REDUCED if _reduced else DEFAULT_FRAME_SECONDS


func _unhandled_input(event: InputEvent) -> void:
	if _finished or not _can_skip:
		return
	if not (event.is_action_pressed(&"interact") or event.is_action_pressed(&"ui_accept")):
		return
	get_viewport().set_input_as_handled()
	_finish(true)


## Pominięcie sterowane przez bramkę (testy/capture), bez czekania na klatki.
func skip_for_test() -> bool:
	if _finished or not _can_skip:
		return false
	_finish(true)
	return true


func is_finished() -> bool:
	return _finished


func get_frame_index() -> int:
	return _index


func get_frame_count() -> int:
	return _frames.size()


func _finish(skipped: bool) -> void:
	if _finished:
		return
	_finished = true
	if _paused_player != null and is_instance_valid(_paused_player) and _paused_player.has_method("set_physics_process"):
		_paused_player.set_physics_process(true)
	if _game_state != null and not vignette_id.is_empty():
		_game_state.mark_cinematic_seen(vignette_id)
	cinematic_finished.emit(vignette_id, skipped)
	queue_free()
