class_name CRTDialogueBox
extends CanvasLayer

## CRT/teletype dialogue presentation. It is data-driven and can be called from
## stations without coupling them to its rendering or synthesized speech blips.

signal line_started(speaker: StringName, text: String)
signal line_finished(speaker: StringName, text: String)
signal dialogue_finished()

const SPEAKER_COLORS := {
	&"Lena": Color("d6b66d"),
	&"Marta": Color("a7d9cf"),
	&"Jakub": Color("9dc2dd"),
	&"dr Wierzbicka": Color("e0ab77"),
	&"Szymon": Color("b9c992"),
}

@export_range(10.0, 90.0, 1.0) var characters_per_second := 42.0

var _panel: Panel
var _portrait: Label
var _speaker_label: Label
var _text_label: RichTextLabel
var _continue_label: Label
var _audio: AudioStreamPlayer
var _lines: Array[Dictionary] = []
var _line_index := -1
var _visible_characters := 0
var _typing := false
var _type_accumulator := 0.0
var _current_text := ""


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_interface()
	visible = false


func present(lines: Array) -> void:
	if lines.is_empty():
		return
	_lines.clear()
	for line in lines:
		if line is Dictionary:
			_lines.append(line)
	if _lines.is_empty():
		return
	_line_index = -1
	visible = true
	_advance_line()


func is_presenting() -> bool:
	return visible and _line_index >= 0


func _unhandled_input(event: InputEvent) -> void:
	if not is_presenting() or not event.is_action_pressed(&"interact"):
		return
	get_viewport().set_input_as_handled()
	if _typing:
		_visible_characters = _current_text.length()
		_typing = false
		_render_current_text()
	else:
		_advance_line()


func _process(delta: float) -> void:
	if not _typing:
		return
	_type_accumulator += delta * characters_per_second
	var next_count := mini(_current_text.length(), int(_type_accumulator))
	if next_count > _visible_characters:
		_visible_characters = next_count
		_render_current_text()
		if _visible_characters % 2 == 0:
			_play_speech_blip()
	if _visible_characters >= _current_text.length():
		_typing = false
		_continue_label.visible = true
		line_finished.emit(StringName(_speaker_label.text), _current_text)


func _advance_line() -> void:
	_line_index += 1
	if _line_index >= _lines.size():
		visible = false
		_line_index = -1
		dialogue_finished.emit()
		return
	var line: Dictionary = _lines[_line_index]
	var speaker := StringName(line.get("speaker", "Lena"))
	_current_text = String(line.get("text", ""))
	_speaker_label.text = String(speaker).to_upper()
	_speaker_label.modulate = SPEAKER_COLORS.get(speaker, Color("d6b66d"))
	_portrait.text = String(speaker).left(1).to_upper()
	_portrait.modulate = _speaker_label.modulate
	_visible_characters = 0
	_type_accumulator = 0.0
	_typing = not _current_text.is_empty()
	_continue_label.visible = false
	_render_current_text()
	line_started.emit(speaker, _current_text)


func _render_current_text() -> void:
	var visible_text := _current_text.left(_visible_characters)
	_text_label.text = "[color=#d9e7cc]%s[/color]" % visible_text


func _play_speech_blip() -> void:
	if _audio.playing:
		return
	_audio.stream = ProceduralAudio.create_dialogue_blip_sound(_speaker_label.text == "LENA")
	_audio.pitch_scale = randf_range(0.93, 1.07)
	_audio.play()


func _build_interface() -> void:
	_panel = Panel.new()
	_panel.name = "CRTDialoguePanel"
	_panel.position = Vector2(28.0, 247.0)
	_panel.size = Vector2(584.0, 91.0)
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color("07100d")
	style.border_color = Color("97ad68")
	style.set_border_width_all(2)
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	style.shadow_color = Color(0.39, 0.73, 0.49, 0.28)
	style.shadow_size = 7
	_panel.add_theme_stylebox_override(&"panel", style)
	add_child(_panel)

	_portrait = Label.new()
	_portrait.position = Vector2(12.0, 12.0)
	_portrait.size = Vector2(50.0, 50.0)
	_portrait.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_portrait.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_portrait.add_theme_font_size_override(&"font_size", 34)
	_panel.add_child(_portrait)

	_speaker_label = Label.new()
	_speaker_label.position = Vector2(72.0, 8.0)
	_speaker_label.add_theme_font_size_override(&"font_size", 12)
	_panel.add_child(_speaker_label)

	_text_label = RichTextLabel.new()
	_text_label.position = Vector2(72.0, 26.0)
	_text_label.size = Vector2(492.0, 48.0)
	_text_label.bbcode_enabled = true
	_text_label.fit_content = false
	_text_label.scroll_active = false
	_text_label.add_theme_font_size_override(&"normal_font_size", 14)
	_text_label.add_theme_color_override(&"default_color", Color("d9e7cc"))
	_panel.add_child(_text_label)

	_continue_label = Label.new()
	_continue_label.text = "[ E ]"
	_continue_label.position = Vector2(526.0, 8.0)
	_continue_label.modulate = Color("d6b66d")
	_continue_label.add_theme_font_size_override(&"font_size", 12)
	_panel.add_child(_continue_label)

	_audio = AudioStreamPlayer.new()
	_audio.name = "DialogueBlipAudio"
	_audio.volume_db = -17.0
	_audio.bus = &"Master"
	add_child(_audio)