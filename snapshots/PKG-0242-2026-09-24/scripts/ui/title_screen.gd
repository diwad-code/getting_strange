class_name TitleScreen
extends Control

## Production shell for the Godot PC build.
## The scene owns presentation and focus; campaign truth stays in the autoload.

const LOGICAL_SIZE := Vector2(640.0, 360.0)
const PANEL_STYLE_COLOR := Color("0b1016")
const BOOT_CAPTURE_PATH_ENV := "GS_BOOT_CAPTURE_PATH"
const BOOT_AUTOMATION_ACTION_ENV := "GS_AUTOMATION_ACTION"

var _game_state: Node
var _title_panel: Panel
var _settings_panel: SettingsOverlay
var _menu_buttons: Array[Button] = []
var _new_game_button: Button
var _continue_button: Button
var _settings_button: Button
var _quit_button: Button
var _credits_button: Button
var _credits_panel: CreditsPanel
var _status_label: Label
var _boot_capture_path := ""
var _boot_automation_action := ""

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
	_boot_capture_path = OS.get_environment(BOOT_CAPTURE_PATH_ENV).strip_edges()
	_boot_automation_action = OS.get_environment(BOOT_AUTOMATION_ACTION_ENV).strip_edges().to_lower()
	if not _boot_capture_path.is_empty():
		call_deferred("_capture_boot_frame")
	if not _boot_automation_action.is_empty():
		call_deferred("_run_boot_automation")
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, LOGICAL_SIZE), VectorStageStyle.INK)
	draw_rect(Rect2(18.0, 18.0, 604.0, 324.0), VectorStageStyle.DEEP_PLANE)
	draw_colored_polygon(PackedVector2Array([Vector2(0.0, 342.0), Vector2(214.0, 342.0), Vector2(470.0, 106.0), Vector2(380.0, 106.0)]), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.22))
	draw_line(Vector2(54.0, 338.0), Vector2(418.0, 108.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(142.0, 338.0), Vector2(494.0, 108.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(98.0, 338.0), Vector2(456.0, 108.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.36), 1.0)
	draw_circle(Vector2(506.0, 106.0), 10.0, Color(VectorStageStyle.HUMAN_AMBER, 0.18))
	draw_circle(Vector2(506.0, 106.0), 4.0, VectorStageStyle.HUMAN_AMBER)
	draw_line(Vector2(18.0, 18.0), Vector2(622.0, 18.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.28), 1.0)
	draw_line(Vector2(18.0, 342.0), Vector2(622.0, 342.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.28), 1.0)

func _build_interface() -> void:
	_title_panel = Panel.new()
	_title_panel.name = "TitlePanel"
	_title_panel.position = Vector2(36.0, 28.0)
	_title_panel.size = Vector2(568.0, 276.0)
	_title_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_title_panel.add_theme_stylebox_override(&"panel", _make_panel_style(VectorStageStyle.INK, VectorStageStyle.LIGHT_PLANE))
	add_child(_title_panel)

	_add_label(_title_panel, "TitleLabel", "GETTING STRANGE", Vector2(24.0, 16.0), Vector2(320.0, 28.0), 23, VectorStageStyle.HUMAN_AMBER)
	_add_label(_title_panel, "SubtitleLabel", "", Vector2(26.0, 47.0), Vector2(500.0, 18.0), 9, VectorStageStyle.ANCHOR_CYAN)
	var promise := _add_label(_title_panel, "PersonalPromise", "", Vector2(24.0, 68.0), Vector2(500.0, 46.0), 12, VectorStageStyle.LIGHT_PLANE)
	promise.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_new_game_button = _add_menu_button(_title_panel, "NewGameButton", "", Vector2(24.0, 118.0), _on_new_game_pressed, Vector2(248.0, 30.0))
	_continue_button = _add_menu_button(_title_panel, "ContinueButton", "", Vector2(24.0, 150.0), _on_continue_pressed, Vector2(248.0, 28.0))
	_settings_button = _add_menu_button(_title_panel, "SettingsButton", "", Vector2(24.0, 180.0), _on_settings_pressed, Vector2(248.0, 28.0))
	# PKG-0242 (release): credits and the licence notices a public build carries.
	_credits_button = _add_menu_button(_title_panel, "CreditsButton", "", Vector2(24.0, 210.0), _on_credits_pressed, Vector2(248.0, 28.0))
	_quit_button = _add_menu_button(_title_panel, "QuitButton", "", Vector2(24.0, 240.0), _on_quit_pressed, Vector2(248.0, 28.0))
	_menu_buttons = [_new_game_button, _continue_button, _settings_button, _credits_button, _quit_button]

	_status_label = _add_label(_title_panel, "CampaignStatus", "", Vector2(306.0, 130.0), Vector2(230.0, 36.0), 10, VectorStageStyle.LIGHT_PLANE)
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var return_line := _add_label(_title_panel, "ReturnPromise", "", Vector2(306.0, 181.0), Vector2(230.0, 32.0), 9, VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.12))
	return_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_add_label(_title_panel, "BuildLabel", "", Vector2(306.0, 236.0), Vector2(230.0, 16.0), 9, VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.18))

	_settings_panel = SettingsOverlay.new()
	_settings_panel.name = "SettingsPanel"
	_settings_panel.position = Vector2(174.0, 24.0)
	_settings_panel.visible = false
	_settings_panel.closed.connect(_on_settings_closed)
	add_child(_settings_panel)
	_credits_panel = CreditsPanel.new()
	_credits_panel.name = "CreditsPanel"
	_credits_panel.position = Vector2(36.0, 30.0)
	_credits_panel.visible = false
	_credits_panel.closed.connect(_on_credits_closed)
	add_child(_credits_panel)
	_update_focus_chain()


func _capture_boot_frame() -> void:
	await RenderingServer.frame_post_draw
	var texture := get_viewport().get_texture()
	if texture == null:
		print("TITLE_SCREEN_CAPTURE path=%s err=texture_null" % _boot_capture_path)
		return
	var image := texture.get_image()
	if image == null:
		print("TITLE_SCREEN_CAPTURE path=%s err=image_null" % _boot_capture_path)
		return
	var capture_path := _boot_capture_path
	if capture_path.begins_with("user://") or capture_path.begins_with("res://"):
		capture_path = ProjectSettings.globalize_path(capture_path)
	DirAccess.make_dir_recursive_absolute(capture_path.get_base_dir())
	var err := image.save_png(capture_path)
	var build_label := _title_panel.get_node_or_null("BuildLabel") as Label
	print(
		"TITLE_SCREEN_CAPTURE path=%s err=%s size=%s build_label=%s status=%s"
		% [
			capture_path,
			str(err),
			str(image.get_size()),
			"" if build_label == null else build_label.text,
			"" if _status_label == null else _status_label.text
		]
	)


func _run_boot_automation() -> void:
	match _boot_automation_action:
		"new_game":
			_on_new_game_pressed()
			print("TITLE_SCREEN_AUTOMATION action=new_game")
		"continue":
			if _continue_button != null and not _continue_button.disabled:
				_on_continue_pressed()
				print("TITLE_SCREEN_AUTOMATION action=continue")
			else:
				print("TITLE_SCREEN_AUTOMATION action=continue skipped=disabled")
		_:
			print("TITLE_SCREEN_AUTOMATION action=%s skipped=unknown" % _boot_automation_action)


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
	style_menu_button(button)


## Shared with CreditsPanel so every shell button reads the same.
static func style_menu_button(button: Button) -> void:
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
	if has_save:
		# PKG-0242 (UX): the save names a place, not a scene identifier.
		var checkpoint := LocalizationManager.station_display_name(String(_game_state.last_checkpoint_station)).to_upper()
		if _game_state.is_campaign_completed():
			_status_label.text = _tr("STATUS_COMPLETED") % checkpoint
		else:
			_status_label.text = _tr("STATUS_SAVE_ACTIVE") % [checkpoint, ""]
	else:
		_status_label.text = _tr("STATUS_SAVE_NONE")


func _update_focus_chain() -> void:
	for index in range(_menu_buttons.size()):
		var current := _menu_buttons[index]
		var previous := _menu_buttons[(index - 1 + _menu_buttons.size()) % _menu_buttons.size()]
		var next := _menu_buttons[(index + 1) % _menu_buttons.size()]
		current.focus_neighbor_top = previous.get_path()
		current.focus_neighbor_bottom = next.get_path()
		current.focus_next = next.get_path()
		current.focus_previous = previous.get_path()
	if not _menu_buttons.is_empty():
		_menu_buttons[0].grab_focus.call_deferred()


func _refresh_localized_ui() -> void:
	if _title_panel == null:
		return
	(_title_panel.get_node("TitleLabel") as Label).text = "GETTING STRANGE"
	(_title_panel.get_node("SubtitleLabel") as Label).text = _tr("TITLE_SUBTITLE")
	(_title_panel.get_node("PersonalPromise") as Label).text = _tr("TITLE_PERSONAL_PROMISE")
	(_title_panel.get_node("ReturnPromise") as Label).text = _tr("TITLE_RETURN_PROMISE")
	_new_game_button.text = _tr("MENU_NEW_GAME")
	_settings_button.text = _tr("MENU_SETTINGS")
	_credits_button.text = _tr("MENU_CREDITS")
	_quit_button.text = _tr("MENU_QUIT")
	(_title_panel.get_node("BuildLabel") as Label).text = _build_runtime_label()
	_refresh_state()
	if is_instance_valid(_settings_panel):
		_settings_panel.refresh_for_test()
	if is_instance_valid(_credits_panel):
		_credits_panel.refresh()
	
func _build_runtime_label() -> String:
	# PKG-0242 (UX): players see the version only; resolution and physics rate
	# were developer telemetry on a public title screen.
	var version := String(ProjectSettings.get_setting("application/config/version", "DEV"))
	return _tr("BUILD_LABEL") % version


func _on_new_game_pressed() -> void:
	if not _game_state or get_node_or_null("SafeActionDialog") != null:
		return
	if not _game_state.has_valid_campaign_save():
		_game_state.start_new_game()
		return
	var dialog := SafeActionDialog.new()
	add_child(dialog)
	dialog.confirmed.connect(_game_state.start_new_game, CONNECT_ONE_SHOT)
	dialog.present(_tr("CONFIRM_NEW_TITLE"), _tr("CONFIRM_NEW_BODY"), _tr("MENU_NEW_GAME"), _new_game_button)


func _on_continue_pressed() -> void:
	if _game_state and not _continue_button.disabled:
		_game_state.continue_campaign()


func _on_settings_pressed() -> void:
	_settings_panel.open_panel()
	_title_panel.visible = false


func _on_settings_back_pressed() -> void:
	_settings_panel.close_panel()


func _on_settings_closed() -> void:
	_title_panel.visible = true
	_settings_button.grab_focus.call_deferred()


func _on_credits_pressed() -> void:
	if get_node_or_null("SafeActionDialog") != null:
		return
	_title_panel.visible = false
	_credits_panel.open_panel(_credits_button)


func _on_credits_closed() -> void:
	_title_panel.visible = true
	_credits_button.grab_focus.call_deferred()


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
