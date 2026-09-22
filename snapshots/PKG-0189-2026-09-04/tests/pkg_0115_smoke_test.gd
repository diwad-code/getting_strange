extends SceneTree

## PKG-0115 R1 gate.
## Proves settings persistence, controlled remap, semantic UI focus, pad
## bindings and shell/pause/CRT localization. It proves technical contracts
## only; it cannot prove ergonomics, comprehension or player reception.

const MAIN_SCENE := "res://scenes/shell/title_screen.tscn"
const SETTINGS_PATH := "user://getting_strange_settings_v1.json"
const EXPECTED_SCALE := 1.15

var _failures: Array[String] = []
var _state: Node
var _title: TitleScreen


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0115: " + message)


func _run() -> void:
	_state = root.get_node_or_null("GameStateManager")
	_expect(_state != null, "GameStateManager autoload is missing")
	if _state == null:
		_finish()
		return
	_state.set_pause_menu_visible(false)
	_state.restore_default_settings(true)
	_state.restore_default_input_map(true)
	await process_frame
	_check_static_contract()
	await _check_shell_and_focus()
	await _check_settings_persistence_and_fallback()
	await _check_remap_conflict_and_restore()
	await _check_pause_and_crt_surfaces()
	_state.set_pause_menu_visible(false)
	_state.restore_default_settings(true)
	_state.reset_campaign(true)
	_finish()


func _check_static_contract() -> void:
	var constants: Dictionary = _state.get_script().get_script_constant_map()
	_expect(int(constants.get("SAVE_SCHEMA_VERSION", -1)) == 1, "R1 must preserve campaign save schema 1")
	_expect(int(constants.get("SETTINGS_SCHEMA_VERSION", -1)) == 1, "settings need their own stable schema version")
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == MAIN_SCENE, "R1 must retain the production shell entry point")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_width", -1) == 640, "R1 must retain 640 logical width")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_height", -1) == 360, "R1 must retain 360 logical height")
	for action in [&"move_left", &"move_right", &"jump", &"restart", &"pause", &"interact", &"trigger_correction"]:
		_expect(InputMap.has_action(action), "required semantic input action missing: %s" % action)
	_expect(_has_pad_button(&"pause", 7), "pause needs a semantic Start button binding")
	_expect(_has_pad_button(&"restart", 6), "restart needs a semantic Back button binding")
	_expect(_state.get_remappable_actions().size() == 5, "R1 remap surface must stay a controlled five-action set")


func _check_shell_and_focus() -> void:
	_title = current_scene as TitleScreen
	if _title == null:
		var packed := load(MAIN_SCENE) as PackedScene
		_expect(packed != null, "title scene must load for R1")
		if packed == null:
			return
		_title = packed.instantiate() as TitleScreen
		root.add_child(_title)
		await process_frame
	_expect(_title != null, "title scene root must use TitleScreen")
	if _title == null:
		return
	var new_game := _title.get_node_or_null("TitlePanel/NewGameButton") as Button
	var settings := _title.get_node_or_null("TitlePanel/SettingsButton") as Button
	var settings_panel := _title.get_node_or_null("SettingsPanel") as SettingsOverlay
	_expect(new_game != null and settings != null, "shell menu buttons must remain present")
	_expect(settings_panel != null, "shell must use the shared SettingsOverlay")
	if new_game:
		_expect(new_game.focus_mode == Control.FOCUS_ALL, "shell New Game must be keyboard/pad focusable")
	if settings:
		_expect(settings.focus_mode == Control.FOCUS_ALL, "shell Settings must be keyboard/pad focusable")
		settings.grab_focus()
		await process_frame
		_expect(settings.has_focus(), "shell focus must be observable after grab_focus")
	if settings_panel == null:
		return
	_title.open_settings_for_test()
	await process_frame
	_expect(settings_panel.visible, "settings panel must open from the shell")
	for node_name in ["LocaleOptionButton", "MasterVolumeSlider", "TextSpeedSlider", "TextScaleSlider", "FullscreenCheckButton", "RemapButton", "SettingsBackButton"]:
		var control := settings_panel.get_node_or_null(node_name) as Control
		_expect(control != null, "settings control missing: %s" % node_name)
		if control:
			_expect(control.focus_mode == Control.FOCUS_ALL, "settings control must be focusable: %s" % node_name)
	var locale_option := settings_panel.get_node_or_null("LocaleOptionButton") as OptionButton
	if locale_option:
		locale_option.grab_focus()
		await process_frame
		_expect(locale_option.has_focus(), "settings language selector must accept keyboard/pad focus")
	_title.close_settings_for_test()
	await process_frame


func _check_settings_persistence_and_fallback() -> void:
	_expect(_title != null, "shell must remain available for settings persistence")
	_state.set_master_volume(0.61)
	_state.set_text_speed_cps(58.0)
	_state.set_text_scale(EXPECTED_SCALE)
	_state.set_fullscreen(true)
	_expect(_state.set_locale("en"), "English locale must be accepted")
	await process_frame
	_expect(String(_state.get_locale()) == "en", "English locale must update runtime")
	_expect(is_equal_approx(float(_state.text_scale), EXPECTED_SCALE), "text scale must update runtime")
	if _title:
		_expect((_title.get_node("TitlePanel/NewGameButton") as Button).text == "NEW GAME", "shell must switch to English")
		var scale_slider := _title.get_node("SettingsPanel/TextScaleSlider") as HSlider
		_expect(scale_slider != null and is_equal_approx(scale_slider.value, EXPECTED_SCALE), "settings controls must reflect text scale")
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	_expect(file != null, "settings JSON must be written")
	if file:
		var json := JSON.new()
		_expect(json.parse(file.get_as_text()) == OK and json.data is Dictionary, "settings JSON must remain parseable")
		file.close()
		if json.data is Dictionary:
			var data := json.data as Dictionary
			_expect(int(data.get("settings_version", -1)) == 1, "settings JSON must carry schema version 1")
			_expect(String(data.get("locale", "")) == "en", "settings JSON must persist locale")
			_expect(is_equal_approx(float(data.get("text_scale", 0.0)), EXPECTED_SCALE), "settings JSON must persist text scale")
	_state.reload_settings_from_disk()
	await process_frame
	_expect(is_equal_approx(float(_state.master_volume_linear), 0.61), "master volume must survive reload")
	_expect(is_equal_approx(float(_state.text_speed_cps), 58.0), "text speed must survive reload")
	_expect(is_equal_approx(float(_state.text_scale), EXPECTED_SCALE), "text scale must survive reload")
	_expect(_state.fullscreen_enabled, "fullscreen must survive reload")
	_expect(String(_state.get_locale()) == "en", "locale must survive reload")
	_expect(int(_state.get_script().get_script_constant_map().get("SAVE_SCHEMA_VERSION", -1)) == 1, "settings reload must not alter campaign save schema")

	_write_settings_text("{\"settings_version\":999,\"locale\":\"en\",\"text_scale\":9.0}")
	_expect(not _state.reload_settings_from_disk(), "unknown settings schema must use fallback defaults")
	_expect(String(_state.get_locale()) == "pl", "unknown settings schema must restore Polish default")
	_expect(is_equal_approx(float(_state.text_scale), 1.0), "unknown settings schema must restore default text scale")
	_expect(not _state.fullscreen_enabled, "unknown settings schema must restore windowed default")
	_write_settings_text("{not valid json")
	_expect(not _state.reload_settings_from_disk(), "malformed settings JSON must use fallback defaults")
	_expect(is_equal_approx(float(_state.master_volume_linear), 0.85), "malformed settings JSON must restore master default")
	_state.restore_default_settings(true)


func _check_remap_conflict_and_restore() -> void:
	_state.restore_default_input_map(false)
	var default_jump: String = _state.get_action_binding_text(&"jump")
	var conflict_event: InputEvent = _copy_first_key_event(&"jump")
	var conflict_result: Dictionary = _state.remap_action(&"interact", conflict_event)
	_expect(not bool(conflict_result.get("ok", true)), "remap must reject an input already used by another action")
	_expect(String(conflict_result.get("reason", "")) == "conflict", "remap conflict must be explicit")
	var success_result: Dictionary = _state.remap_action(&"jump", _make_key(81))
	_expect(bool(success_result.get("ok", false)), "remap must accept an unused keyboard input")
	_expect(_state.get_action_binding_text(&"jump") != default_jump, "successful remap must update the active InputMap")
	_expect(_state.save_settings_to_disk(), "successful remap must persist settings")
	_expect(_state.reload_settings_from_disk(), "saved remap must reload from settings JSON")
	_expect(_state.get_action_binding_text(&"jump") != default_jump, "reloaded remap must remain active")
	_state.restore_default_input_map(true)
	_expect(_state.get_action_binding_text(&"jump") == default_jump, "restore defaults must recover the authored jump binding")


func _check_pause_and_crt_surfaces() -> void:
	_state.set_locale("en")
	_state.set_pause_menu_visible(true)
	await process_frame
	var pause_layer := _state.get_node_or_null("CampaignPauseMenu") as CanvasLayer
	_expect(pause_layer != null and pause_layer.visible, "pause surface must be visible")
	if pause_layer:
		var resume := pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/ResumeButton") as Button
		var pause_settings := pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/SettingsButton") as Button
		_expect(resume != null and pause_settings != null, "pause must expose resume and settings actions")
		if resume:
			_expect(resume.focus_mode == Control.FOCUS_ALL, "pause Resume must be focusable")
			_expect(resume.has_focus(), "pause must focus Resume on open")
		if pause_settings:
			_expect(pause_settings.text == "SETTINGS", "pause must localize settings action")
			pause_settings.pressed.emit()
			await process_frame
		var pause_overlay := pause_layer.get_node_or_null("PauseSettingsPanel") as SettingsOverlay
		_expect(pause_overlay != null and pause_overlay.visible, "pause must open the shared settings overlay")
		if pause_overlay:
			var pause_scale := pause_overlay.get_node_or_null("TextScaleSlider") as HSlider
			_expect(pause_scale != null and pause_scale.focus_mode == Control.FOCUS_ALL, "pause settings must retain focusable accessibility controls")
			pause_overlay.close_panel()
			await process_frame
	var crt := CRTDialogueBox.new()
	root.add_child(crt)
	await process_frame
	var continue_label := crt.get_node_or_null("CRTDialoguePanel/ContinueAction") as Label
	var channel_label := crt.get_node_or_null("CRTDialoguePanel/ChannelLabel") as Label
	_expect(continue_label != null and channel_label != null, "CRT must expose localized UI labels")
	if continue_label and channel_label:
		_expect(continue_label.text == "INTERACT  >", "CRT continue prompt must switch to English")
		_expect(channel_label.text == "WITNESS CHANNEL  //  SAVE ACTIVE", "CRT channel label must switch to English")
	_state.set_locale("pl")
	await process_frame
	if continue_label and channel_label:
		_expect(continue_label.text == "INTERAKCJA  >", "CRT continue prompt must switch back to Polish")
		_expect(channel_label.text == "KANAŁ ŚWIADKA  //  ZAPIS AKTYWNY", "CRT channel label must switch back to Polish")
	crt.queue_free()
	_state.set_pause_menu_visible(false)


func _has_pad_button(action: StringName, button_index: int) -> bool:
	for event in InputMap.action_get_events(action):
		if event is InputEventJoypadButton and (event as InputEventJoypadButton).button_index == button_index:
			return true
	return false


func _make_key(physical_keycode: int) -> InputEventKey:
	var event := InputEventKey.new()
	event.physical_keycode = physical_keycode
	event.pressed = true
	return event


func _copy_first_key_event(action: StringName) -> InputEvent:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			var copy := event.duplicate() as InputEventKey
			copy.pressed = true
			copy.echo = false
			return copy
	return _make_key(32)


func _write_settings_text(contents: String) -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to write controlled settings JSON")
	if file:
		file.store_string(contents)
		file.close()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0115 SMOKE PASS: settings, remap, focus, pad bindings and PL/EN UI")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0115 FAILURE: " + failure)
		quit(1)
