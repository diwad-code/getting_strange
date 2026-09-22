class_name TitleScreen
extends Control

## Production shell for the Godot PC build.
## The scene owns presentation and focus; campaign truth stays in the autoload.

const LOGICAL_SIZE := Vector2(640.0, 360.0)
const PANEL_STYLE_COLOR := Color("0b1016")

var _game_state: Node
var _title_panel: Panel
var _settings_panel: SettingsOverlay
var _menu_buttons: Array[Button] = []
var _new_game_button: Button
var _continue_button: Button
var _settings_button: Button
var _quit_button: Button
var _status_label: Label
var _controls_label: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	focus_mode = Control.FOCUS_ALL
	_game_state = get_node_or_null("/root/GameStateManager")
	_build_interface()
	if _game_state and _game_state.has_signal(&"accessibility_changed"):
		_game_state.accessibility_changed.connect(_on_accessibility_changed)
	if _game_state and _game_state.has_signal(&"input_map_changed"):
		_game_state.input_map_changed.connect(_on_input_map_changed)
	_refresh_state()
	_refresh_localized_ui()
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
	_add_label(_title_panel, "SubtitleLabel", "", Vector2(26.0, 47.0), Vector2(450.0, 18.0), 9, VectorStageStyle.ANCHOR_CYAN)

	_new_game_button = _add_menu_button(_title_panel, "NewGameButton", "", Vector2(24.0, 82.0), _on_new_game_pressed)
	_continue_button = _add_menu_button(_title_panel, "ContinueButton", "", Vector2(24.0, 118.0), _on_continue_pressed)
	_settings_button = _add_menu_button(_title_panel, "SettingsButton", "", Vector2(24.0, 154.0), _on_settings_pressed)
	_quit_button = _add_menu_button(_title_panel, "QuitButton", "", Vector2(24.0, 190.0), _on_quit_pressed)
	_menu_buttons = [_new_game_button, _continue_button, _settings_button, _quit_button]

	_status_label = _add_label(_title_panel, "CampaignStatus", "", Vector2(270.0, 84.0), Vector2(270.0, 42.0), 10, VectorStageStyle.LIGHT_PLANE)
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_controls_label = _add_label(_title_panel, "ControlsHint", "", Vector2(270.0, 137.0), Vector2(270.0, 82.0), 10, VectorStageStyle.LIGHT_PLANE)
	_controls_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_add_label(_title_panel, "BuildLabel", "", Vector2(270.0, 231.0), Vector2(270.0, 16.0), 9, VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.18))

	_settings_panel = SettingsOverlay.new()
	_settings_panel.name = "SettingsPanel"
	_settings_panel.position = Vector2(294.0, 24.0)
	_settings_panel.visible = false
	_settings_panel.closed.connect(_on_settings_closed)
	add_child(_settings_panel)
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
	label.add_to_group("gs_scalable_text")
	label.set_meta("gs_base_font_size", font_size)
	label.set_meta("gs_font_property", "font_size")
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
	button.add_to_group("gs_scalable_text")
	button.set_meta("gs_base_font_size", 11)
	button.set_meta("gs_font_property", "font_size")
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
	_continue_button.text = _tr("MENU_REPLAY_EPILOGUE") if _game_state.is_campaign_completed() else _tr("MENU_CONTINUE")
	var checkpoint := String(_game_state.last_checkpoint_station).to_upper()
	if has_save:
		var finale_id := String(_game_state.get_selected_finale_id()).to_upper()
		var ending_text := _tr("STATUS_COMPLETED_SUFFIX") % finale_id if _game_state.is_campaign_completed() else ""
		_status_label.text = _tr("STATUS_SAVE_ACTIVE") % [checkpoint, ending_text]
	else:
		_status_label.text = _tr("STATUS_SAVE_NONE")
	_controls_label.text = "%s\n%s\n%s\n%s\n%s" % [
		_tr("CONTROLS_HEADER"),
		_action_prompt(&"move_left", _tr("INPUT_ACTION_MOVE_LEFT")) + "  /  " + _action_prompt(&"move_right", _tr("INPUT_ACTION_MOVE_RIGHT")),
		_action_prompt(&"jump", _tr("INPUT_ACTION_JUMP")),
		_action_prompt(&"interact", _tr("INPUT_ACTION_INTERACT")),
		_action_prompt(&"pause", _tr("INPUT_ACTION_PAUSE")),
	]


func _action_prompt(action: StringName, label: String) -> String:
	var events := InputMap.action_get_events(action)
	var prompts: Array[String] = []
	for event in events:
		var prompt := _event_prompt(event)
		if not prompt.is_empty() and not prompts.has(prompt):
			prompts.append(prompt)
	return "%s: %s" % [label, " / ".join(prompts)] if not prompts.is_empty() else "%s: —" % label


func _event_prompt(event: InputEvent) -> String:
	if _game_state and _game_state.has_method("get_input_event_prompt"):
		return String(_game_state.get_input_event_prompt(event))
	return event.as_text()


func _update_focus_chain() -> void:
	for index in range(_menu_buttons.size()):
		var current := _menu_buttons[index]
		var previous := _menu_buttons[(index - 1 + _menu_buttons.size()) % _menu_buttons.size()]
		var next := _menu_buttons[(index + 1) % _menu_buttons.size()]
		current.focus_neighbor_top = previous.get_path()
		current.focus_neighbor_bottom = next.get_path()
	if not _menu_buttons.is_empty():
		_menu_buttons[0].grab_focus.call_deferred()


func _refresh_localized_ui() -> void:
	if _title_panel == null:
		return
	(_title_panel.get_node("TitleLabel") as Label).text = "GETTING STRANGE"
	(_title_panel.get_node("SubtitleLabel") as Label).text = _tr("TITLE_SUBTITLE")
	_new_game_button.text = _tr("MENU_NEW_GAME")
	_settings_button.text = _tr("MENU_SETTINGS")
	_quit_button.text = _tr("MENU_QUIT")
	(_title_panel.get_node("BuildLabel") as Label).text = _build_runtime_label()
	_refresh_state()
	if is_instance_valid(_settings_panel):
		_settings_panel.refresh_for_test()
	
	
func _build_runtime_label() -> String:
	var version := String(ProjectSettings.get_setting("application/config/version", "DEV"))
	var viewport_width := int(ProjectSettings.get_setting("display/window/size/viewport_width", int(LOGICAL_SIZE.x)))
	var viewport_height := int(ProjectSettings.get_setting("display/window/size/viewport_height", int(LOGICAL_SIZE.y)))
	var physics_hz := int(Engine.physics_ticks_per_second)
	return _tr("BUILD_LABEL") % [version, viewport_width, viewport_height, physics_hz]


func _on_new_game_pressed() -> void:
	if _game_state:
		_game_state.start_new_game()


func _on_continue_pressed() -> void:
	if _game_state and not _continue_button.disabled:
		_game_state.continue_campaign()


func _on_settings_pressed() -> void:
	_settings_panel.open_panel()
	for button in _menu_buttons:
		button.visible = false


func _on_settings_back_pressed() -> void:
	_settings_panel.close_panel()


func _on_settings_closed() -> void:
	for button in _menu_buttons:
		button.visible = true
	_settings_button.grab_focus.call_deferred()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _sync_settings_controls() -> void:
	if is_instance_valid(_settings_panel):
		_settings_panel.refresh_for_test()


func _on_accessibility_changed(_scale: float, _locale: String) -> void:
	_refresh_localized_ui()


func _on_input_map_changed() -> void:
	_refresh_state()


func refresh_for_test() -> void:
	_refresh_localized_ui()
	_sync_settings_controls()


func open_settings_for_test() -> void:
	_on_settings_pressed()
	_sync_settings_controls()


func close_settings_for_test() -> void:
	_on_settings_back_pressed()


func request_quit_for_test() -> bool:
	_status_label.text = _tr("MENU_QUIT") + ": " + (_tr("SAVE_ACTIVE"))
	return true


func _tr(key: StringName) -> String:
	return LocalizationManager.tr_key(String(key))
