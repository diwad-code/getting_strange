class_name CRTDialogueBox
extends CanvasLayer

## CRT/teletype dialogue presentation. It is data-driven and can be called from
## stations without coupling them to its rendering or synthesized speech blips.

signal line_started(speaker: StringName, text: String)
signal line_finished(speaker: StringName, text: String)
signal dialogue_finished()

const SPEAKER_COLORS := {
	&"Lena": Color("d6b66d"),
	&"LENA": Color("d6b66d"),
	&"Marta": Color("a7d9cf"),
	&"MARTA": Color("a7d9cf"),
	&"Jakub": Color("9dc2dd"),
	&"JAKUB": Color("9dc2dd"),
	&"dr Wierzbicka": Color("e0ab77"),
	&"Wierzbicka": Color("e0ab77"),
	&"WIERZBICKA": Color("e0ab77"),
	&"Szymon": Color("b9c992"),
	&"SZYMON": Color("b9c992"),
	&"ŚWIADECTWO": Color("88cfc8"),
	&"Świadectwo": Color("88cfc8"),
	&"ŚLAD": Color("c65d58"),
	&"POWRÓT": Color("d29a63"),
	&"UZGODNIENIE": Color("75c7c3"),
	&"GETTING STRANGE": Color("88cfc8"),
}

@export_range(10.0, 90.0, 1.0) var characters_per_second := 42.0
@export var auto_advance: bool = false
@export var auto_advance_dwell_time: float = 2.5

var _panel: Panel
var _portrait: CRTPortrait
var _accent_bar: ColorRect
var _speaker_label: Label
var _text_label: RichTextLabel
var _continue_label: Label
var _channel_label: Label
var _step_status_label: Label
var _audio: AudioStreamPlayer
var _lines: Array[Dictionary] = []
var _line_index := -1
var _visible_characters := 0
var _typing := false
var _type_accumulator := 0.0
var _current_text := ""
var _dwell_accumulator := 0.0


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	var game_state := get_node_or_null("/root/GameStateManager")
	if game_state:
		characters_per_second = float(game_state.text_speed_cps)
		if game_state.has_signal(&"settings_changed"):
			game_state.settings_changed.connect(_on_settings_changed)
		if game_state.has_signal(&"accessibility_changed"):
			game_state.accessibility_changed.connect(_on_accessibility_changed)
	_build_interface()
	if game_state and game_state.has_method("apply_text_scale_to_tree"):
		game_state.apply_text_scale_to_tree()
	visible = false


func _exit_tree() -> void:
	if is_instance_valid(_audio):
		_audio.stop()
		_audio.stream = null
	var game_state := get_node_or_null("/root/GameStateManager")
	if game_state and is_instance_valid(game_state):
		if game_state.has_signal(&"settings_changed") and game_state.settings_changed.is_connected(_on_settings_changed):
			game_state.settings_changed.disconnect(_on_settings_changed)
		if game_state.has_signal(&"accessibility_changed") and game_state.accessibility_changed.is_connected(_on_accessibility_changed):
			game_state.accessibility_changed.disconnect(_on_accessibility_changed)


func _on_settings_changed(_master_volume: float, new_text_speed_cps: float, _fullscreen: bool) -> void:
	characters_per_second = clampf(new_text_speed_cps, 10.0, 90.0)


func _on_accessibility_changed(_new_text_scale: float, _locale: String) -> void:
	_continue_label.text = LocalizationManager.tr_key("CRT_CONTINUE")
	_channel_label.text = LocalizationManager.tr_key("CRT_CHANNEL")


func present(lines: Array) -> void:
	if lines.is_empty():
		return
	# PKG-0186: a fresh line sequence starts with no leftover confirmation from
	# whatever the previous `present()` call was about (playtest lead L03 —
	# the "step done" signal must never survive into an unrelated line).
	_step_status_label.text = ""
	_lines.clear()
	for line in lines:
		if line is Dictionary:
			_lines.append(line)
	if _lines.is_empty():
		return
	_line_index = -1
	visible = true
	_advance_line()


func show_line(speaker: String, text: String) -> void:
	present([{"speaker": speaker, "text": text}])


func hide_box() -> void:
	visible = false
	_line_index = -1
	_typing = false
	dialogue_finished.emit()


func is_presenting() -> bool:
	return visible and _line_index >= 0


## PKG-0186 (playtest lead L03). Callers present a confirming line and then
## call this with a short, diegetic "what just resolved" tag. It lives on the
## dialogue panel itself, not on the world beneath it, so it stays visible for
## exactly the window a checkmark drawn in the world would be covered by this
## same panel (`reports/pkg_playtest_fixes/verification_matrix.md`, L03).
func set_step_status(text: String) -> void:
	_step_status_label.text = text


func get_step_status_text() -> String:
	return _step_status_label.text


func advance_dialogue() -> void:
	if not is_presenting():
		return
	if _typing:
		_visible_characters = _current_text.length()
		_typing = false
		_render_current_text()
	else:
		_advance_line()


func _unhandled_input(event: InputEvent) -> void:
	if not is_presenting() or (not event.is_action_pressed(&"interact") and not event.is_action_pressed(&"ui_accept")):
		return
	get_viewport().set_input_as_handled()
	advance_dialogue()


func _process(delta: float) -> void:
	if not visible or _line_index < 0:
		return
	if _typing:
		_type_accumulator += delta * characters_per_second
		var next_count := mini(_current_text.length(), int(_type_accumulator))
		if next_count > _visible_characters:
			_visible_characters = next_count
			_render_current_text()
			if _visible_characters % 2 == 0:
				_play_speech_blip()
		if _visible_characters >= _current_text.length():
			_typing = false
			_dwell_accumulator = 0.0
			_continue_label.visible = true
			line_finished.emit(StringName(_speaker_label.text), _current_text)
	elif auto_advance:
		_dwell_accumulator += delta
		if _dwell_accumulator >= auto_advance_dwell_time:
			_dwell_accumulator = 0.0
			_advance_line()


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
	_portrait.set_witness(speaker, _speaker_label.modulate)
	_accent_bar.color = _speaker_label.modulate
	_visible_characters = 0
	_type_accumulator = 0.0
	_dwell_accumulator = 0.0
	_typing = not _current_text.is_empty()
	_continue_label.visible = false
	_render_current_text()
	line_started.emit(speaker, _current_text)


func _render_current_text() -> void:
	var visible_text := _current_text.left(_visible_characters)
	_text_label.text = "[color=#d7e0e3]%s[/color]" % visible_text


func _play_speech_blip() -> void:
	if _audio.playing:
		return
	var raw_speaker := _speaker_label.text.to_upper()
	var cache_key: StringName = StringName("blip_" + raw_speaker.to_lower())
	_audio.stream = ProceduralAudio.get_cached_sound(cache_key, func() -> AudioStreamWAV:
		return ProceduralAudio.create_dialogue_blip_for_speaker(raw_speaker)
	)
	_audio.pitch_scale = randf_range(0.94, 1.06)
	_audio.play()


func _build_interface() -> void:
	_panel = Panel.new()
	_panel.name = "CRTDialoguePanel"
	_panel.position = Vector2(24.0, 238.0)
	_panel.size = Vector2(592.0, 102.0)
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(VectorStageStyle.INK, 0.97)
	style.border_color = VectorStageStyle.LIGHT_PLANE
	style.set_border_width_all(1)
	style.border_width_left = 4
	_panel.add_theme_stylebox_override(&"panel", style)
	add_child(_panel)

	_accent_bar = ColorRect.new()
	_accent_bar.name = "SpeakerAccent"
	_accent_bar.position = Vector2(4.0, 1.0)
	_accent_bar.size = Vector2(178.0, 3.0)
	_accent_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_panel.add_child(_accent_bar)

	var witness_plane := Polygon2D.new()
	witness_plane.name = "WitnessPlane"
	witness_plane.polygon = PackedVector2Array([
		Vector2(4.0, 5.0), Vector2(72.0, 5.0), Vector2(66.0, 95.0), Vector2(4.0, 100.0),
	])
	witness_plane.color = VectorStageStyle.DEEP_PLANE
	_panel.add_child(witness_plane)

	_portrait = CRTPortrait.new()
	_portrait.name = "WitnessPortrait"
	_portrait.position = Vector2(9.0, 18.0)
	_portrait.size = Vector2(56.0, 62.0)
	_panel.add_child(_portrait)

	_speaker_label = Label.new()
	_speaker_label.name = "SpeakerLabel"
	_speaker_label.position = Vector2(82.0, 8.0)
	_speaker_label.add_theme_font_size_override(&"font_size", 13)
	_mark_scalable(_speaker_label, 13, "font_size")
	_panel.add_child(_speaker_label)

	_text_label = RichTextLabel.new()
	_text_label.name = "DialogueText"
	_text_label.position = Vector2(82.0, 30.0)
	_text_label.size = Vector2(488.0, 52.0)
	_text_label.bbcode_enabled = true
	_text_label.fit_content = false
	_text_label.scroll_active = false
	_text_label.add_theme_font_size_override(&"normal_font_size", 15)
	_mark_scalable(_text_label, 15, "normal_font_size")
	_text_label.add_theme_color_override(&"default_color", Color("d7e0e3"))
	_panel.add_child(_text_label)

	_continue_label = Label.new()
	_continue_label.name = "ContinueAction"
	_continue_label.text = LocalizationManager.tr_key("CRT_CONTINUE")
	_continue_label.position = Vector2(478.0, 8.0)
	_continue_label.modulate = VectorStageStyle.ANCHOR_CYAN
	_continue_label.add_theme_font_size_override(&"font_size", 11)
	_mark_scalable(_continue_label, 11, "font_size")
	_panel.add_child(_continue_label)

	_channel_label = Label.new()
	_channel_label.name = "ChannelLabel"
	_channel_label.text = LocalizationManager.tr_key("CRT_CHANNEL")
	_channel_label.position = Vector2(82.0, 82.0)
	_channel_label.modulate = VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.18)
	_channel_label.add_theme_font_size_override(&"font_size", 9)
	_mark_scalable(_channel_label, 9, "font_size")
	_panel.add_child(_channel_label)

	# PKG-0186 (playtest lead L03): step-resolved confirmation. Shares the
	# channel label's row so it needs no new vertical budget, but sits on the
	# panel's own right side so long channel text never overlaps it. Empty by
	# default — invisible text costs nothing, so every other station that
	# never calls `set_step_status()` sees no change at all.
	_step_status_label = Label.new()
	_step_status_label.name = "StepStatusLabel"
	_step_status_label.text = ""
	_step_status_label.position = Vector2(300.0, 82.0)
	_step_status_label.size = Vector2(286.0, 12.0)
	_step_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_step_status_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_step_status_label.modulate = VectorStageStyle.ANCHOR_CYAN
	_step_status_label.add_theme_font_size_override(&"font_size", 9)
	_mark_scalable(_step_status_label, 9, "font_size")
	_panel.add_child(_step_status_label)

	_audio = AudioStreamPlayer.new()
	_audio.name = "DialogueBlipAudio"
	_audio.volume_db = -17.0
	_audio.bus = &"Master"
	add_child(_audio)


func _mark_scalable(control: Control, base_font_size: int, property_name: String) -> void:
	control.add_to_group("gs_scalable_text")
	control.set_meta("gs_base_font_size", base_font_size)
	control.set_meta("gs_font_property", property_name)
