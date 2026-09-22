class_name TitleScreen
extends Control

## Production shell for the Godot PC build.
## The scene owns presentation and focus; campaign truth stays in the autoload.

const LOGICAL_SIZE := Vector2(640.0, 360.0)
const PANEL_STYLE_COLOR := Color("0b1016")

var _game_state: Node
var _title_panel: Panel
var _settings_panel: Panel
var _menu_buttons: Array[Button] = []
var _new_game_button: Button
var _continue_button: Button
var _settings_button: Button
var _quit_button: Button
var _status_label: Label
var _controls_label: Label
var _settings_back_button: Button
var _master_volume_slider: HSlider
var _master_volume_value: Label
var _text_speed_slider: HSlider
var _text_speed_value: Label
var _fullscreen_check: CheckButton
var _settings_hint: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	focus_mode = Control.FOCUS_ALL
	_game_state = get_node_or_null("/root/GameStateManager")
	_build_interface()
	_refresh_state()
	_sync_settings_controls()
	queue_redraw()


func _draw() -> void:
	VectorStageStyle.draw_stage_background(self, LOGICAL_SIZE, 43, true)
	# A quiet proscenium frame makes the shell read as the same instrument as the
	# stations without introducing a new asset or a separate visual language.
	draw_line(Vector2(18.0, 18.0), Vector2(622.0, 18.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(18.0, 18.0), Vector2(18.0, 342.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(622.0, 18.0), Vector2(622.0, 342.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(18.0, 342.0), Vector2(622.0, 342.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(36.0, 94.0), Vector2(604.0, 94.0), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.28), 1.0)
	draw_line(Vector2(36.0, 304.0), Vector2(604.0, 304.0), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.24), 1.0)
	for x in [76.0, 214.0, 414.0, 552.0]:
		VectorStageStyle.draw_faceted_lamp(self, Vector2(x, 34.0), 12.0)


func _build_interface() -> void:
	_title_panel = Panel.new()
	_title_panel.name = "TitlePanel"
	_title_panel.position = Vector2(36.0, 28.0)
	_title_panel.size = Vector2(568.0, 276.0)
	_title_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_title_panel.add_theme_stylebox_override(&"panel", _make_panel_style(VectorStageStyle.INK, VectorStageStyle.LIGHT_PLANE))
	add_child(_title_panel)

	_add_label(_title_panel, "TitleLabel", "GETTING STRANGE", Vector2(24.0, 16.0), Vector2(300.0, 28.0), 23, VectorStageStyle.HUMAN_AMBER)
	_add_label(_title_panel, "SubtitleLabel", "RÓWIEŃ  //  VECTOR-STAGE  //  KANAŁ PRODUKCYJNY", Vector2(26.0, 47.0), Vector2(450.0, 18.0), 9, VectorStageStyle.ANCHOR_CYAN)

	_new_game_button = _add_menu_button(_title_panel, "NewGameButton", "NOWA GRA", Vector2(24.0, 82.0), _on_new_game_pressed)
	_continue_button = _add_menu_button(_title_panel, "ContinueButton", "KONTYNUUJ", Vector2(24.0, 118.0), _on_continue_pressed)
	_settings_button = _add_menu_button(_title_panel, "SettingsButton", "USTAWIENIA", Vector2(24.0, 154.0), _on_settings_pressed)
	_quit_button = _add_menu_button(_title_panel, "QuitButton", "ZAKOŃCZ", Vector2(24.0, 190.0), _on_quit_pressed)
	_menu_buttons = [_new_game_button, _continue_button, _settings_button, _quit_button]

	_status_label = _add_label(_title_panel, "CampaignStatus", "", Vector2(270.0, 84.0), Vector2(270.0, 42.0), 10, VectorStageStyle.LIGHT_PLANE)
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_controls_label = _add_label(_title_panel, "ControlsHint", "", Vector2(270.0, 137.0), Vector2(270.0, 82.0), 10, VectorStageStyle.LIGHT_PLANE)
	_controls_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_add_label(_title_panel, "BuildLabel", "PC  //  640x360  //  FIZYKA 60 Hz", Vector2(270.0, 231.0), Vector2(270.0, 16.0), 9, VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.18))

	_settings_panel = Panel.new()
	_settings_panel.name = "SettingsPanel"
	_settings_panel.position = Vector2(294.0, 44.0)
	_settings_panel.size = Vector2(292.0, 252.0)
	_settings_panel.add_theme_stylebox_override(&"panel", _make_panel_style(VectorStageStyle.DEEP_PLANE, VectorStageStyle.ANCHOR_CYAN))
	_settings_panel.visible = false
	add_child(_settings_panel)
	_add_label(_settings_panel, "SettingsTitle", "USTAWIENIA  //  RUNTIME", Vector2(18.0, 14.0), Vector2(250.0, 22.0), 14, VectorStageStyle.HUMAN_AMBER)
	_add_label(_settings_panel, "MasterVolumeLabel", "GŁOŚNOŚĆ MASTER", Vector2(18.0, 48.0), Vector2(180.0, 16.0), 10, VectorStageStyle.LIGHT_PLANE)
	_master_volume_slider = _add_slider(_settings_panel, "MasterVolumeSlider", Vector2(18.0, 67.0), 0.0, 1.0, 0.01)
	_master_volume_value = _add_label(_settings_panel, "MasterVolumeValue", "", Vector2(204.0, 64.0), Vector2(65.0, 20.0), 10, VectorStageStyle.ANCHOR_CYAN)
	_add_label(_settings_panel, "TextSpeedLabel", "TEMPO TEKSTU  //  ZNAKI/S", Vector2(18.0, 101.0), Vector2(200.0, 16.0), 10, VectorStageStyle.LIGHT_PLANE)
	_text_speed_slider = _add_slider(_settings_panel, "TextSpeedSlider", Vector2(18.0, 120.0), 10.0, 90.0, 1.0)
	_text_speed_value = _add_label(_settings_panel, "TextSpeedValue", "", Vector2(204.0, 117.0), Vector2(65.0, 20.0), 10, VectorStageStyle.ANCHOR_CYAN)
	_fullscreen_check = CheckButton.new()
	_fullscreen_check.name = "FullscreenCheckButton"
	_fullscreen_check.text = "TRYB PEŁNOEKRANOWY"
	_fullscreen_check.position = Vector2(14.0, 153.0)
	_fullscreen_check.size = Vector2(250.0, 26.0)
	_fullscreen_check.focus_mode = Control.FOCUS_ALL
	_fullscreen_check.add_theme_font_size_override(&"font_size", 10)
	_fullscreen_check.add_theme_color_override(&"font_color", VectorStageStyle.LIGHT_PLANE)
	_fullscreen_check.add_theme_color_override(&"font_hover_color", Color.WHITE)
	_fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	_settings_panel.add_child(_fullscreen_check)
	_settings_hint = _add_label(_settings_panel, "SettingsHint", "Zmiany są zapisywane natychmiast. PL/EN i remap należą do R1.", Vector2(18.0, 185.0), Vector2(252.0, 30.0), 9, VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.16))
	_settings_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_settings_back_button = _add_menu_button(_settings_panel, "SettingsBackButton", "POWRÓT", Vector2(18.0, 215.0), _on_settings_back_pressed, Vector2(250.0, 27.0))

	_master_volume_slider.value_changed.connect(_on_master_volume_changed)
	_text_speed_slider.value_changed.connect(_on_text_speed_changed)
	_update_focus_chain()


func _add_label(parent: Control, node_name: String, text_value: String, position_value: Vector2, size_value: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = text_value
	label.position = position_value
	label.size = size_value
	label.add_theme_font_size_override(&"font_size", font_size)
	label.add_theme_color_override(&"font_color", color)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(label)
	return label


func _add_menu_button(parent: Control, node_name: String, text_value: String, position_value: Vector2, callback: Callable, button_size: Vector2 = Vector2(220.0, 30.0)) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text_value
	button.position = position_value
	button.size = button_size
	button.focus_mode = Control.FOCUS_ALL
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_style_button(button)
	button.pressed.connect(callback)
	parent.add_child(button)
	return button


func _add_slider(parent: Control, node_name: String, position_value: Vector2, min_value: float, max_value: float, step_value: float) -> HSlider:
	var slider := HSlider.new()
	slider.name = node_name
	slider.position = position_value
	slider.size = Vector2(176.0, 24.0)
	slider.min_value = min_value
	slider.max_value = max_value
	slider.step = step_value
	slider.focus_mode = Control.FOCUS_ALL
	parent.add_child(slider)
	return slider


func _make_panel_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(background, 0.97)
	style.border_color = border
	style.set_border_width_all(1)
	style.border_width_left = 4
	style.content_margin_left = 8.0
	style.content_margin_right = 8.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	return style


func _style_button(button: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = VectorStageStyle.DEEP_PLANE
	normal.border_color = VectorStageStyle.MID_PLANE
	normal.set_border_width_all(1)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = VectorStageStyle.MID_PLANE
	hover.border_color = VectorStageStyle.ANCHOR_CYAN
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.50)
	pressed.border_color = VectorStageStyle.ANCHOR_CYAN
	var focus := hover.duplicate() as StyleBoxFlat
	focus.border_width_left = 4
	var disabled := normal.duplicate() as StyleBoxFlat
	disabled.bg_color = VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.24)
	disabled.border_color = VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.32)
	button.add_theme_stylebox_override(&"normal", normal)
	button.add_theme_stylebox_override(&"hover", hover)
	button.add_theme_stylebox_override(&"pressed", pressed)
	button.add_theme_stylebox_override(&"focus", focus)
	button.add_theme_stylebox_override(&"disabled", disabled)
	button.add_theme_color_override(&"font_color", VectorStageStyle.light(VectorStageStyle.LIGHT_PLANE, 0.44))
	button.add_theme_color_override(&"font_hover_color", Color.WHITE)
	button.add_theme_color_override(&"font_pressed_color", Color.WHITE)
	button.add_theme_color_override(&"font_focus_color", Color.WHITE)
	button.add_theme_color_override(&"font_disabled_color", VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.36))
	button.add_theme_font_size_override(&"font_size", 11)


func _refresh_state() -> void:
	if _game_state == null:
		return
	var has_save: bool = bool(_game_state.has_valid_campaign_save())
	_continue_button.disabled = not has_save
	_continue_button.text = "POWTÓRZ EPILOG" if _game_state.is_campaign_completed() else "KONTYNUUJ"
	var checkpoint := String(_game_state.last_checkpoint_station).to_upper()
	if has_save:
		var finale_id := String(_game_state.get_selected_finale_id()).to_upper()
		var ending_text := "  //  UKOŃCZONA  //  %s" % finale_id if _game_state.is_campaign_completed() else ""
		_status_label.text = "ZAPIS: AKTYWNY\nPUNKT: %s%s" % [checkpoint, ending_text]
	else:
		_status_label.text = "ZAPIS: BRAK PRAWIDŁOWEGO STANU\nNOWA GRA OTWIERA STATION 01"
	_controls_label.text = "STEROWANIE  //  AKCJE\n%s\n%s\n%s\n%s" % [
		_action_prompt(&"move_left", "RUCH LEWO") + "  /  " + _action_prompt(&"move_right", "RUCH PRAWO"),
		_action_prompt(&"jump", "SKOK"),
		_action_prompt(&"interact", "INTERAKCJA"),
		_action_prompt(&"pause", "PAUZA"),
	]


func _action_prompt(action: StringName, label: String) -> String:
	var events := InputMap.action_get_events(action)
	var prompts: Array[String] = []
	for event in events:
		var prompt := event.as_text()
		if not prompt.is_empty() and not prompts.has(prompt):
			prompts.append(prompt)
	return "%s: %s" % [label, " / ".join(prompts)] if not prompts.is_empty() else "%s: —" % label


func _update_focus_chain() -> void:
	for index in range(_menu_buttons.size() - 1):
		_menu_buttons[index].focus_neighbor_bottom = _menu_buttons[index + 1].get_path()
		_menu_buttons[index + 1].focus_neighbor_top = _menu_buttons[index].get_path()
	if not _menu_buttons.is_empty():
		_menu_buttons[0].grab_focus.call_deferred()


func _on_new_game_pressed() -> void:
	if _game_state:
		_game_state.start_new_game()


func _on_continue_pressed() -> void:
	if _game_state and not _continue_button.disabled:
		_game_state.continue_campaign()


func _on_settings_pressed() -> void:
	_sync_settings_controls()
	_settings_panel.visible = true
	for button in _menu_buttons:
		button.visible = false
	_master_volume_slider.grab_focus.call_deferred()


func _on_settings_back_pressed() -> void:
	_settings_panel.visible = false
	for button in _menu_buttons:
		button.visible = true
	_settings_button.grab_focus.call_deferred()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_master_volume_changed(value: float) -> void:
	if _game_state:
		_game_state.set_master_volume(value)
	_master_volume_value.text = "%d%%" % roundi(value * 100.0)


func _on_text_speed_changed(value: float) -> void:
	if _game_state:
		_game_state.set_text_speed_cps(value)
	_text_speed_value.text = "%d" % roundi(value)


func _on_fullscreen_toggled(enabled: bool) -> void:
	if _game_state:
		_game_state.set_fullscreen(enabled)


func _sync_settings_controls() -> void:
	if _game_state == null:
		return
	_master_volume_slider.set_value_no_signal(_game_state.master_volume_linear)
	_master_volume_value.text = "%d%%" % roundi(_game_state.master_volume_linear * 100.0)
	_text_speed_slider.set_value_no_signal(_game_state.text_speed_cps)
	_text_speed_value.text = "%d" % roundi(_game_state.text_speed_cps)
	_fullscreen_check.set_pressed_no_signal(_game_state.fullscreen_enabled)


func refresh_for_test() -> void:
	_refresh_state()
	_sync_settings_controls()


func open_settings_for_test() -> void:
	_on_settings_pressed()
	_sync_settings_controls()


func close_settings_for_test() -> void:
	_on_settings_back_pressed()


func request_quit_for_test() -> bool:
	_status_label.text = "ZAKOŃCZ: ŻĄDANIE ZAMKNIĘCIA ODEBRANE"
	return true
