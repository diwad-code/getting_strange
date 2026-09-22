extends SceneTree

## PKG-0114 R0 gate.
## This gate proves the production shell, save-driven entry points and the
## authored campaign topology through real level_completed signals. It proves
## technical contracts only; it cannot prove fun, comprehension or emotion.

const MAIN_SCENE := "res://scenes/shell/title_screen.tscn"
const SAVE_PATH := "user://getting_strange_campaign_v1.json"
const EXPECTED_ROUTE := [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18", "station_19", "station_20",
	"station_21", "station_22", "station_23", "station_24", "station_25",
	"station_26", "station_27", "station_28", "station_29", "station_30",
	"station_31", "station_32", "station_33", "station_34", "station_35",
	"station_36", "station_37", "station_38", "station_39", "station_40",
	"station_41",
]

var _failures: Array[String] = []
var _state: Node
var _transition_log: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0114: " + message)


func _run() -> void:
	_state = root.get_node_or_null("GameStateManager")
	_expect(_state != null, "GameStateManager autoload is missing")
	if _state == null:
		_finish()
		return
	# Keep the shell assertion independent from a save left by another gate or
	# by a previous local run. The production runtime still loads saves normally.
	_state.reset_campaign(true)
	_state.transition_started.connect(_on_transition_started)
	_check_route_contract()
	await _check_title_shell()
	await _check_new_game_and_continue()
	await _run_full_route_with_real_signals("A")
	await _run_branch_from_choice_chamber("B")
	await _run_branch_from_choice_chamber("C")
	await _check_continue_after_epilogue()
	_check_malformed_save_fallback()
	_state.set_pause_menu_visible(false)
	_state.campaign_auto_transition_enabled = true
	_state.restore_default_settings(true)
	_state.reset_campaign(true)
	_finish()


func _check_route_contract() -> void:
	var constants: Dictionary = _state.get_script().get_script_constant_map()
	_expect(int(constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 41, "campaign route must include Station 01..41")
	_expect(int(constants.get("SAVE_SCHEMA_VERSION", -1)) == 1, "R0 must preserve save schema 1")
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == MAIN_SCENE, "project main scene must be the production shell")
	_expect(_state.get_all_campaign_scene_ids().size() == 45, "route must map 45 scene resources to 43 spaces and three finale variants")
	_expect(_state.get_selectable_stations(true).size() == 43, "normal selector surface must retain 43 campaign entries")
	for index in range(EXPECTED_ROUTE.size() - 1):
		var current_id: StringName = StringName(EXPECTED_ROUTE[index])
		var next_id: StringName = StringName(EXPECTED_ROUTE[index + 1])
		_expect(_state.get_next_campaign_station(current_id) == next_id, "%s must lead to %s" % [current_id, next_id])
	_expect(_state.get_next_campaign_station(&"station_41").is_empty(), "Station 41 must wait for a selected operation")
	for finale_id in [&"station_42a", &"station_42b", &"station_42c"]:
		_expect(_state.get_next_campaign_station(finale_id) == &"station_43", "%s must lead only to Station 43" % finale_id)


func _check_title_shell() -> void:
	var packed := load(MAIN_SCENE) as PackedScene
	_expect(packed != null, "production title scene must load")
	if packed == null:
		return
	var title := packed.instantiate() as TitleScreen
	_expect(title != null, "production title scene root must use TitleScreen")
	if title == null:
		return
	root.add_child(title)
	await process_frame
	var title_panel := title.get_node_or_null("TitlePanel") as Panel
	_expect(title_panel != null, "title shell panel is missing")
	for button_name in ["NewGameButton", "ContinueButton", "SettingsButton", "QuitButton"]:
		var button := title.get_node_or_null("TitlePanel/" + button_name) as Button
		_expect(button != null, "title shell button is missing: " + button_name)
	var continue_button := title.get_node_or_null("TitlePanel/ContinueButton") as Button
	_expect(continue_button != null and continue_button.disabled, "Continue must be disabled without a valid save")
	_expect(title.request_quit_for_test(), "quit action must expose a safe harness equivalent")
	title.open_settings_for_test()
	await process_frame
	var settings_panel := title.get_node_or_null("SettingsPanel") as Panel
	var master_slider := title.get_node_or_null("SettingsPanel/MasterVolumeSlider") as HSlider
	var text_slider := title.get_node_or_null("SettingsPanel/TextSpeedSlider") as HSlider
	var fullscreen_check := title.get_node_or_null("SettingsPanel/FullscreenCheckButton") as CheckButton
	_expect(settings_panel != null and settings_panel.visible, "settings screen must be real and visible")
	_expect(master_slider != null and text_slider != null and fullscreen_check != null, "settings controls are incomplete")
	if master_slider and text_slider and fullscreen_check:
		master_slider.value = 0.61
	text_slider.value = 58.0
	fullscreen_check.button_pressed = true
	await process_frame
	_expect(is_equal_approx(float(_state.master_volume_linear), 0.61), "Master volume setting must update runtime state")
	_expect(is_equal_approx(float(_state.text_speed_cps), 58.0), "text tempo setting must update runtime state")
	_expect(_state.fullscreen_enabled, "fullscreen setting must update runtime state")
	_state.restore_default_settings(true)
	title.close_settings_for_test()
	title.queue_free()
	await process_frame


func _check_new_game_and_continue() -> void:
	_state.reset_campaign(true)
	var title := await _mount_title()
	var new_game_button := title.get_node_or_null("TitlePanel/NewGameButton") as Button
	_expect(new_game_button != null, "New Game button must be callable")
	if new_game_button:
		new_game_button.pressed.emit()
	var station := await _wait_for_station(&"station_01")
	_expect(station != null, "New Game must enter Station 01")
	_expect(_state.has_valid_campaign_save(), "New Game must produce a valid checkpoint save")
	await _return_to_title()
	var continue_title := current_scene as TitleScreen
	_expect(continue_title != null, "ephemeral return must restore the production shell")
	if continue_title:
		var continue_button := continue_title.get_node_or_null("TitlePanel/ContinueButton") as Button
		_expect(continue_button != null and not continue_button.disabled, "Continue must activate from a valid save")
		if continue_button:
			continue_button.pressed.emit()
		var resumed := await _wait_for_station(&"station_01")
		_expect(resumed != null, "Continue must use the saved Station 01 checkpoint")
	await _return_to_title()


func _run_full_route_with_real_signals(operation: String) -> void:
	_state.reset_campaign(true)
	_state.campaign_auto_transition_enabled = true
	var title := await _mount_title()
	var new_game_button := title.get_node_or_null("TitlePanel/NewGameButton") as Button
	_expect(new_game_button != null, "full route needs the production New Game button")
	if new_game_button:
		new_game_button.pressed.emit()
	var first_station := await _wait_for_station(&"station_01")
	_expect(first_station != null, "full route must start at Station 01")
	var route_transitions_before := _transition_log.size()
	for index in range(EXPECTED_ROUTE.size() - 1):
		var expected_id := StringName(EXPECTED_ROUTE[index])
		var next_id := StringName(EXPECTED_ROUTE[index + 1])
		var current: Node = current_scene
		_expect(_station_id_from_node(current) == expected_id, "route reached %s without skipping" % expected_id)
		var transitions_before := _transition_log.size()
		if current:
			if expected_id == &"station_01":
				current.emit_signal(&"level_completed")
				current.emit_signal(&"level_completed")
			else:
				current.emit_signal(&"level_completed")
		var next_scene := await _wait_for_station(next_id)
		_expect(next_scene != null, "real completion signal must transition %s -> %s" % [expected_id, next_id])
		_expect(_transition_log.size() == transitions_before + 1, "%s must cause exactly one scene transition" % expected_id)
		_expect(_state.has_reached_station(next_id), "%s must unlock its immediate successor" % expected_id)

	var chamber := current_scene as Node
	_expect(chamber != null and _station_id_from_node(chamber) == &"station_41", "full route must arrive at Station 41")
	if chamber:
		chamber.call("select_operation", operation)
		_expect(_state.get_selected_finale_id() == &"station_42a", "Operation A must select only Station 42A")
		var branch_transitions_before := _transition_log.size()
		chamber.emit_signal(&"level_completed")
		var finale := await _wait_for_station(&"station_42a")
		_expect(finale != null, "Station 41 must enter the selected 42A variant")
		_expect(_transition_log.size() == branch_transitions_before + 1, "Station 41 must transition once")
		_expect(not _state.has_reached_station(&"station_42b"), "Operation A must not unlock Station 42B")
		_expect(not _state.has_reached_station(&"station_42c"), "Operation A must not unlock Station 42C")
		finale.emit_signal(&"level_completed")
		var epilogue := await _wait_for_station(&"station_43")
		_expect(epilogue != null, "selected 42A must lead to Station 43")
		if epilogue:
			epilogue.emit_signal(&"level_completed")
		var shell := await _wait_for_title()
		_expect(shell != null, "Station 43 completion must return to the title shell")
		_expect(_state.is_campaign_completed(), "Station 43 must save campaign completion")
	_expect(_transition_log.size() > route_transitions_before, "full route must emit production transitions")


func _run_branch_from_choice_chamber(operation: String) -> void:
	_state.reset_campaign(true)
	_state.campaign_auto_transition_enabled = true
	for index in range(40):
		_state.complete_station(StringName("station_%02d" % (index + 1)), false)
	_expect(_state.has_reached_station(&"station_41"), "branch setup must unlock Station 41 through the campaign API")
	_state.transition_to_station(&"station_41")
	var chamber := await _wait_for_station(&"station_41")
	_expect(chamber != null, "branch test must enter the real choice chamber scene")
	if chamber == null:
		return
	chamber.call("select_operation", operation)
	var expected_finale := StringName("station_42" + operation.to_lower())
	_expect(_state.get_selected_finale_id() == expected_finale, "operation %s must select its matching finale" % operation)
	chamber.emit_signal(&"level_completed")
	var finale := await _wait_for_station(expected_finale)
	_expect(finale != null, "operation %s must enter its matching finale" % operation)
	for other_operation in ["A", "B", "C"]:
		var other_id := StringName("station_42" + other_operation.to_lower())
		if other_id != expected_finale:
			_expect(not _state.has_reached_station(other_id), "operation %s must not unlock %s" % [operation, other_id])
	if finale:
		finale.emit_signal(&"level_completed")
		var epilogue := await _wait_for_station(&"station_43")
		_expect(epilogue != null, "operation %s finale must lead to Station 43" % operation)
		if epilogue:
			epilogue.emit_signal(&"level_completed")
			await _wait_for_title()


func _check_continue_after_epilogue() -> void:
	var title := current_scene as TitleScreen
	_expect(title != null, "title shell must remain available after branch tests")
	if title == null:
		return
	var continue_button := title.get_node_or_null("TitlePanel/ContinueButton") as Button
	_expect(continue_button != null and not continue_button.disabled, "completed campaign save must keep Continue active")
	_expect(continue_button != null and continue_button.text == "POWTÓRZ EPILOG", "completed save must identify its safe continuation")
	if continue_button:
		continue_button.pressed.emit()
		var epilogue := await _wait_for_station(&"station_43")
		_expect(epilogue != null, "Continue after epilogue must safely resume at Station 43")
	await _return_to_title()


func _check_malformed_save_fallback() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to create a controlled save file")
	if file:
		file.store_string("{not valid json")
		file.close()
	_expect(not _state.reload_campaign_from_disk(), "malformed JSON must be rejected cleanly")
	_expect(not _state.has_valid_campaign_save(), "malformed JSON must leave a clean campaign")


func _mount_title() -> TitleScreen:
	var packed := load(MAIN_SCENE) as PackedScene
	if packed == null:
		return null
	var title := packed.instantiate() as TitleScreen
	if title == null:
		return null
	root.add_child(title)
	await process_frame
	return title


func _return_to_title() -> void:
	_state.return_to_title()
	await _wait_for_title()


func _wait_for_station(station_id: StringName, max_frames: int = 240) -> Node:
	for _frame in range(max_frames):
		await process_frame
		var current: Node = current_scene
		if current != null and _station_id_from_node(current) == station_id:
			while _state.is_transitioning():
				await process_frame
			return current
	return null


func _wait_for_title(max_frames: int = 240) -> TitleScreen:
	for _frame in range(max_frames):
		await process_frame
		var current := current_scene as TitleScreen
		if current != null:
			while _state.is_transitioning():
				await process_frame
			return current
	return null


func _station_id_from_node(node: Node) -> StringName:
	if node == null:
		return &""
	var suffix := String(node.name).trim_prefix("Station").to_lower()
	if suffix.is_valid_int():
		return StringName("station_%02d" % suffix.to_int())
	if suffix in ["42a", "42b", "42c"]:
		return StringName("station_" + suffix)
	return &""


func _on_transition_started(target_scene: String) -> void:
	_transition_log.append(target_scene)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0114 SMOKE PASS: production shell, save entry points and full 01..43 topology")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0114 FAILURE: " + failure)
		quit(1)
