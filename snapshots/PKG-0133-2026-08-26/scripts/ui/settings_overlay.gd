class_name SettingsOverlay
extends Panel

## Shared R1 settings surface used by the title shell and the pause menu.
## The overlay owns presentation and focus; GameStateManager owns persistence
## and InputMap truth.

signal closed()

const PANEL_SIZE := Vector2(292.0, 312.0)
const REMAPPABLE_FALLBACK: Array[StringName] = [
	&"jump", &"interact", &"pause", &"restart", &"trigger_correction",
]

var _game_state: Node
var _settings_title: Label
var _master_label: Label
var _text_speed_label: Label
var _text_scale_label: Label
var _fullscreen_check: CheckButton
var _locale_label: Label
var _locale_option: OptionButton
var _master_volume_slider: HSlider
var _master_volume_value: Label
var _text_speed_slider: HSlider
var _text_speed_value: Label
var _text_scale_slider: HSlider
var _text_scale_value: Label
var _remap_button: Button
var _settings_hint: Label
var _settings_back_button: Button

var _remap_panel: Panel
var _remap_title: Label
var _remap_hint: Label
var _remap_grid: GridContainer
var _remap_back_button: Button
var _remap_defaults_button: Button
var _remap_action_labels: Dictionary = {}
var _remap_action_buttons: Dictionary = {}
var _pending_rebind_action: StringName = &""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_game_state = get_node_or_null("/root/GameStateManager")
	_build_interface()
	if _game_state:
		if _game_state.has_signal(&"accessibility_changed"):
			_game_state.accessibility_changed.connect(_on_accessibility_changed)
		if _game_state.has_signal(&"settings_changed"):
			_game_state.settings_changed.connect(_on_settings_changed)
		if _game_state.has_signal(&"input_map_changed"):
			_game_state.input_map_changed.connect(_on_input_map_changed)
	_refresh_localized_text()
	_sync_controls()
	if _game_state and _game_state.has_method("apply_text_scale_to_tree"):
		_game_state.apply_text_scale_to_tree()


func open_panel() -> void:
	_pending_rebind_action = &""
	_remap_panel.visible = false
	visible = true
	_sync_controls()
	_refresh_localized_text()
	_locale_option.grab_focus.call_deferred()


func close_panel() -> void:
	_pending_rebind_action = &""
	_remap_panel.visible = false
	visible = false
	closed.emit()


func refresh_for_test() -> void:
	_refresh_localized_text()
	_sync_controls()
	_refresh_remap_rows()


func open_remap_for_test() -> void:
	_open_remap()


func close_remap_for_test() -> void:
	_close_remap()


func begin_rebind_for_test(action: StringName) -> void:
	_begin_rebind(action)


func submit_rebind_event_for_test(event: InputEvent) -> Dictionary:
	return _submit_rebind_event(event)


func _build_interface() -> void:
	size = PANEL_SIZE
	add_theme_stylebox_override(&"panel", _make_panel_style(VectorStageStyle.DEEP_PLANE, VectorStageStyle.ANCHOR_CYAN))

	_settings_title = _add_label("SettingsTitle", "", Vector2(18.0, 10.0), Vector2(256.0, 22.0), 14, VectorStageStyle.HUMAN_AMBER)
	_locale_label = _add_label("LocaleLabel", "", Vector2(18.0, 37.0), Vector2(132.0, 18.0), 9, VectorStageStyle.LIGHT_PLANE)
	_locale_option = OptionButton.new()
	_locale_option.name = "LocaleOptionButton"
	_locale_option.position = Vector2(166.0, 34.0)
	_locale_option.size = Vector2(108.0, 24.0)
	_locale_option.focus_mode = Control.FOCUS_ALL
	_mark_scalable(_locale_option, 9)
	_locale_option.item_selected.connect(_on_locale_selected)
	_style_button(_locale_option)
	add_child(_locale_option)

	_master_label = _add_label("MasterVolumeLabel", "", Vector2(18.0, 65.0), Vector2(180.0, 16.0), 9, VectorStageStyle.LIGHT_PLANE)
	_master_volume_slider = _add_slider("MasterVolumeSlider", Vector2(18.0, 82.0), 0.0, 1.0, 0.01)
	_master_volume_value = _add_label("MasterVolumeValue", "", Vector2(204.0, 79.0), Vector2(65.0, 20.0), 9, VectorStageStyle.ANCHOR_CYAN)

	_text_speed_label = _add_label("TextSpeedLabel", "", Vector2(18.0, 108.0), Vector2(205.0, 16.0), 9, VectorStageStyle.LIGHT_PLANE)
	_text_speed_slider = _add_slider("TextSpeedSlider", Vector2(18.0, 125.0), 10.0, 90.0, 1.0)
	_text_speed_value = _add_label("TextSpeedValue", "", Vector2(204.0, 122.0), Vector2(65.0, 20.0), 9, VectorStageStyle.ANCHOR_CYAN)

	_text_scale_label = _add_label("TextScaleLabel", "", Vector2(18.0, 151.0), Vector2(205.0, 16.0), 9, VectorStageStyle.LIGHT_PLANE)
	_text_scale_slider = _add_slider("TextScaleSlider", Vector2(18.0, 168.0), 0.85, 1.15, 0.05)
	_text_scale_value = _add_label("TextScaleValue", "", Vector2(204.0, 165.0), Vector2(65.0, 20.0), 9, VectorStageStyle.ANCHOR_CYAN)

	_fullscreen_check = CheckButton.new()
	_fullscreen_check.name = "FullscreenCheckButton"
	_fullscreen_check.position = Vector2(14.0, 193.0)
	_fullscreen_check.size = Vector2(260.0, 25.0)
	_fullscreen_check.focus_mode = Control.FOCUS_ALL
	_mark_scalable(_fullscreen_check, 9)
	_fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	_style_check_button(_fullscreen_check)
	add_child(_fullscreen_check)

	_remap_button = _add_button("RemapButton", "", Vector2(18.0, 221.0), Vector2(256.0, 25.0), _open_remap)
	_settings_hint = _add_label("SettingsHint", "", Vector2(18.0, 249.0), Vector2(256.0, 26.0), 8, VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.20))
	_settings_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_settings_back_button = _add_button("SettingsBackButton", "", Vector2(18.0, 279.0), Vector2(256.0, 25.0), close_panel)

	_master_volume_slider.value_changed.connect(_on_master_volume_changed)
	_text_speed_slider.value_changed.connect(_on_text_speed_changed)
	_text_scale_slider.value_changed.connect(_on_text_scale_changed)
	_build_remap_interface()
	_update_focus_chain()


func _build_remap_interface() -> void:
	_remap_panel = Panel.new()
	_remap_panel.name = "RemapPanel"
	_remap_panel.position = Vector2.ZERO
	_remap_panel.size = PANEL_SIZE
	_remap_panel.visible = false
	_remap_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_remap_panel.add_theme_stylebox_override(&"panel", _make_panel_style(VectorStageStyle.INK, VectorStageStyle.HUMAN_AMBER))
	add_child(_remap_panel)

	_remap_title = _add_panel_label(_remap_panel, "RemapTitle", "", Vector2(14.0, 10.0), Vector2(264.0, 22.0), 13, VectorStageStyle.HUMAN_AMBER)
	_remap_hint = _add_panel_label(_remap_panel, "RemapHint", "", Vector2(14.0, 34.0), Vector2(264.0, 28.0), 8, VectorStageStyle.LIGHT_PLANE)
	_remap_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_remap_grid = GridContainer.new()
	_remap_grid.name = "RemapGrid"
	_remap_grid.position = Vector2(14.0, 66.0)
	_remap_grid.size = Vector2(264.0, 170.0)
	_remap_grid.columns = 2
	_remap_grid.add_theme_constant_override(&"h_separation", 4)
	_remap_grid.add_theme_constant_override(&"v_separation", 4)
	_remap_panel.add_child(_remap_grid)

	for action in _get_remappable_actions():
		var action_label := Label.new()
		action_label.name = "ActionLabel_" + String(action)
		action_label.custom_minimum_size = Vector2(128.0, 25.0)
		action_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		action_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_mark_scalable(action_label, 8)
		_remap_grid.add_child(action_label)
		_remap_action_labels[action] = action_label

		var action_button := _add_panel_button(_remap_grid, "ActionButton_" + String(action), "", Vector2(132.0, 25.0), _begin_rebind.bind(action))
		_remap_action_buttons[action] = action_button

	_remap_defaults_button = _add_positioned_panel_button(_remap_panel, "RestoreDefaultsButton", "", Vector2(14.0, 248.0), Vector2(128.0, 25.0), _restore_defaults)
	_remap_back_button = _add_positioned_panel_button(_remap_panel, "RemapBackButton", "", Vector2(150.0, 248.0), Vector2(128.0, 25.0), _close_remap)
	_refresh_remap_rows()
	_update_remap_focus_chain()


func _add_label(node_name: String, text_value: String, position_value: Vector2, size_value: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = text_value
	label.position = position_value
	label.size = size_value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override(&"font_color", color)
	_mark_scalable(label, font_size)
	add_child(label)
	return label


func _add_panel_label(parent: Control, node_name: String, text_value: String, position_value: Vector2, size_value: Vector2, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = text_value
	label.position = position_value
	label.size = size_value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override(&"font_color", color)
	_mark_scalable(label, font_size)
	parent.add_child(label)
	return label


func _add_slider(node_name: String, position_value: Vector2, min_value: float, max_value: float, step_value: float) -> HSlider:
	var slider := HSlider.new()
	slider.name = node_name
	slider.position = position_value
	slider.size = Vector2(176.0, 22.0)
	slider.min_value = min_value
	slider.max_value = max_value
	slider.step = step_value
	slider.focus_mode = Control.FOCUS_ALL
	add_child(slider)
	return slider


func _add_button(node_name: String, text_value: String, position_value: Vector2, button_size: Vector2, callback: Callable) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text_value
	button.position = position_value
	button.size = button_size
	button.focus_mode = Control.FOCUS_ALL
	_mark_scalable(button, 9)
	_style_button(button)
	button.pressed.connect(callback)
	add_child(button)
	return button


func _add_panel_button(parent: Control, node_name: String, text_value: String, button_size: Vector2, callback: Callable) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text_value
	button.custom_minimum_size = button_size
	button.focus_mode = Control.FOCUS_ALL
	_mark_scalable(button, 8)
	_style_button(button)
	button.pressed.connect(callback)
	parent.add_child(button)
	return button


func _add_positioned_panel_button(parent: Control, node_name: String, text_value: String, position_value: Vector2, button_size: Vector2, callback: Callable) -> Button:
	var button := _add_panel_button(parent, node_name, text_value, button_size, callback)
	button.position = position_value
	return button


func _mark_scalable(control: Control, base_font_size: int) -> void:
	control.add_to_group("gs_scalable_text")
	control.set_meta("gs_base_font_size", base_font_size)
	control.set_meta("gs_font_property", "font_size")


func _make_panel_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.border_width_left = 4
	style.content_margin_left = 8.0
	style.content_margin_right = 8.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	return style


func _style_button(button: BaseButton) -> void:
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
	button.add_theme_stylebox_override(&"normal", normal)
	button.add_theme_stylebox_override(&"hover", hover)
	button.add_theme_stylebox_override(&"pressed", pressed)
	button.add_theme_stylebox_override(&"focus", focus)
	button.add_theme_color_override(&"font_color", VectorStageStyle.light(VectorStageStyle.LIGHT_PLANE, 0.44))
	button.add_theme_color_override(&"font_hover_color", Color.WHITE)
	button.add_theme_color_override(&"font_pressed_color", Color.WHITE)
	button.add_theme_color_override(&"font_focus_color", Color.WHITE)
	button.add_theme_font_size_override(&"font_size", 9)


func _style_check_button(button: CheckButton) -> void:
	button.add_theme_color_override(&"font_color", VectorStageStyle.LIGHT_PLANE)
	button.add_theme_color_override(&"font_hover_color", Color.WHITE)
	button.add_theme_color_override(&"font_pressed_color", Color.WHITE)
	button.add_theme_font_size_override(&"font_size", 9)


func _get_remappable_actions() -> Array[StringName]:
	if _game_state and _game_state.has_method("get_remappable_actions"):
		return _game_state.get_remappable_actions()
	return REMAPPABLE_FALLBACK.duplicate()


func _refresh_localized_text() -> void:
	if not is_instance_valid(_settings_title):
		return
	_settings_title.text = _tr("SETTINGS_TITLE")
	_locale_label.text = _tr("SETTINGS_LANGUAGE")
	_master_label.text = _tr("SETTINGS_MASTER_VOLUME")
	_text_speed_label.text = _tr("SETTINGS_TEXT_SPEED")
	_text_scale_label.text = _tr("SETTINGS_TEXT_SCALE")
	_fullscreen_check.text = _tr("SETTINGS_FULLSCREEN")
	_remap_button.text = _tr("SETTINGS_REMAP")
	_settings_hint.text = _tr("SETTINGS_HINT")
	_settings_back_button.text = _tr("UI_BACK")
	_locale_option.tooltip_text = _tr("SETTINGS_LANGUAGE_HINT")
	_locale_option.clear()
	_locale_option.add_item("PL")
	_locale_option.set_item_metadata(0, "pl")
	_locale_option.add_item("EN")
	_locale_option.set_item_metadata(1, "en")
	if _game_state:
		_locale_option.select(0 if String(_game_state.get_locale()) == "pl" else 1)
	_remap_title.text = _tr("SETTINGS_REMAP_TITLE")
	_remap_defaults_button.text = _tr("SETTINGS_RESTORE_DEFAULTS")
	_remap_back_button.text = _tr("UI_BACK")
	_refresh_remap_rows()


func _refresh_remap_rows() -> void:
	if not is_instance_valid(_remap_grid):
		return
	for action in _get_remappable_actions():
		var label := _remap_action_labels.get(action) as Label
		var button := _remap_action_buttons.get(action) as Button
		if label:
			label.text = _tr_action(action)
		if button:
			button.text = _get_action_binding_text(action)
	if is_instance_valid(_remap_hint) and _pending_rebind_action.is_empty():
		_remap_hint.text = _tr("SETTINGS_REMAP_HINT")


func _sync_controls() -> void:
	if not _game_state:
		return
	_master_volume_slider.set_value_no_signal(float(_game_state.master_volume_linear))
	_master_volume_value.text = "%d%%" % roundi(float(_game_state.master_volume_linear) * 100.0)
	_text_speed_slider.set_value_no_signal(float(_game_state.text_speed_cps))
	_text_speed_value.text = "%d" % roundi(float(_game_state.text_speed_cps))
	_text_scale_slider.set_value_no_signal(float(_game_state.text_scale))
	_text_scale_value.text = "%d%%" % roundi(float(_game_state.text_scale) * 100.0)
	_fullscreen_check.set_pressed_no_signal(bool(_game_state.fullscreen_enabled))
	_refresh_remap_rows()


func _update_focus_chain() -> void:
	var controls: Array[Control] = [_locale_option, _master_volume_slider, _text_speed_slider, _text_scale_slider, _fullscreen_check, _remap_button, _settings_back_button]
	for index in range(controls.size()):
		var current := controls[index]
		var previous := controls[(index - 1 + controls.size()) % controls.size()]
		var next := controls[(index + 1) % controls.size()]
		current.focus_neighbor_top = previous.get_path()
		current.focus_neighbor_bottom = next.get_path()


func _update_remap_focus_chain() -> void:
	var buttons: Array[Button] = []
	for action in _get_remappable_actions():
		var button := _remap_action_buttons.get(action) as Button
		if button:
			buttons.append(button)
	if _remap_defaults_button:
		buttons.append(_remap_defaults_button)
	if _remap_back_button:
		buttons.append(_remap_back_button)
	for index in range(buttons.size()):
		var current := buttons[index]
		var previous := buttons[(index - 1 + buttons.size()) % buttons.size()]
		var next := buttons[(index + 1) % buttons.size()]
		current.focus_neighbor_top = previous.get_path()
		current.focus_neighbor_bottom = next.get_path()


func _open_remap() -> void:
	_remap_panel.visible = true
	_pending_rebind_action = &""
	_refresh_localized_text()
	_update_remap_focus_chain()
	if _remap_action_buttons.size() > 0:
		var first_action: StringName = _get_remappable_actions()[0]
		(_remap_action_buttons[first_action] as Button).grab_focus.call_deferred()


func _close_remap() -> void:
	_pending_rebind_action = &""
	_remap_panel.visible = false
	_refresh_localized_text()
	_remap_button.grab_focus.call_deferred()


func _begin_rebind(action: StringName) -> void:
	if action not in _get_remappable_actions():
		return
	_pending_rebind_action = action
	_remap_hint.text = _tr("SETTINGS_REMAP_PENDING") % _tr_action(action)
	var button := _remap_action_buttons.get(action) as Button
	if button:
		button.text = _tr("SETTINGS_REMAP_WAITING")
		button.grab_focus()


func _submit_rebind_event(event: InputEvent) -> Dictionary:
	if _pending_rebind_action.is_empty() or not _game_state:
		return {"ok": false, "reason": "idle"}
	var action := _pending_rebind_action
	var result: Dictionary = _game_state.remap_action(action, event)
	_pending_rebind_action = &""
	_refresh_remap_rows()
	var button := _remap_action_buttons.get(action) as Button
	if bool(result.get("ok", false)):
		_remap_hint.text = _tr("SETTINGS_REMAP_SAVED") % _tr_action(action)
	else:
		var conflict_action := StringName(String(result.get("conflict_action", "")))
		if String(result.get("reason", "")) == "conflict":
			_remap_hint.text = _tr("SETTINGS_REMAP_CONFLICT") % _tr_action(conflict_action)
		else:
			_remap_hint.text = _tr("SETTINGS_REMAP_UNSUPPORTED")
	if button:
		button.grab_focus.call_deferred()
	return result


func _restore_defaults() -> void:
	if _game_state and _game_state.has_method("restore_default_input_map"):
		_game_state.restore_default_input_map(true)
	_remap_hint.text = _tr("SETTINGS_REMAP_DEFAULTS_RESTORED")
	_refresh_remap_rows()


func _on_locale_selected(index: int) -> void:
	if _game_state == null or index < 0 or index >= _locale_option.item_count:
		return
	_game_state.set_locale(String(_locale_option.get_item_metadata(index)))


func _on_master_volume_changed(value: float) -> void:
	if _game_state:
		_game_state.set_master_volume(value)
	_master_volume_value.text = "%d%%" % roundi(value * 100.0)


func _on_text_speed_changed(value: float) -> void:
	if _game_state:
		_game_state.set_text_speed_cps(value)
	_text_speed_value.text = "%d" % roundi(value)


func _on_text_scale_changed(value: float) -> void:
	if _game_state:
		_game_state.set_text_scale(value)
	_text_scale_value.text = "%d%%" % roundi(value * 100.0)


func _on_fullscreen_toggled(enabled: bool) -> void:
	if _game_state:
		_game_state.set_fullscreen(enabled)


func _on_settings_changed(_master_volume: float, _text_speed: float, _fullscreen: bool) -> void:
	_sync_controls()


func _on_accessibility_changed(_scale: float, _locale: String) -> void:
	_refresh_localized_text()
	_sync_controls()


func _on_input_map_changed() -> void:
	_refresh_remap_rows()


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if _remap_panel.visible:
		if _pending_rebind_action.is_empty():
			if event.is_action_pressed(&"ui_cancel") and not event.is_echo():
				_close_remap()
				get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed(&"ui_cancel") and not event.is_echo():
			_pending_rebind_action = &""
			_refresh_remap_rows()
			get_viewport().set_input_as_handled()
			return
		var is_keyboard: bool = event is InputEventKey and event.pressed and not event.echo
		var is_button: bool = event is InputEventJoypadButton and event.pressed
		if is_keyboard or is_button:
			_submit_rebind_event(event)
			get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"ui_cancel") and not event.is_echo():
		close_panel()
		get_viewport().set_input_as_handled()


func _get_action_binding_text(action: StringName) -> String:
	if _game_state and _game_state.has_method("get_action_binding_text"):
		return String(_game_state.get_action_binding_text(action))
	return "—"


func _tr(key: StringName) -> String:
	return LocalizationManager.tr_key(String(key))


func _tr_action(action: StringName) -> String:
	return LocalizationManager.tr_key("INPUT_ACTION_" + String(action).to_upper())
