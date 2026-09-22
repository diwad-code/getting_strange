extends Node

## Versioned local campaign state, pause UI and station transition coordinator.
## Save data is deliberately small, JSON-only and recoverable from malformed files.

signal checkpoint_changed(station_id: StringName, spawn_position: Vector2)
signal clue_collected(clue_id: StringName)
signal decision_recorded(decision_id: StringName, value: Variant)
signal campaign_saved(save_path: String)
signal campaign_reloaded()
signal campaign_reset()
signal pause_changed(is_paused: bool)
signal transition_started(target_scene: String)
signal transition_finished(target_scene: String)
signal campaign_completed(finale_id: StringName)
signal settings_changed(master_volume: float, text_speed_cps: float, fullscreen: bool)

const SAVE_SCHEMA_VERSION := 1
const SAVE_PATH := "user://getting_strange_campaign_v1.json"
const SETTINGS_PATH := "user://getting_strange_settings_v1.json"
const STATION_SCENE_PREFIX := "res://scenes/levels/station_"
const STATION_SCENE_SUFFIX := ".tscn"
const CAMPAIGN_TRANSITION_LIMIT := 41
const CAMPAIGN_ROUTE: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41",
]
const CAMPAIGN_FINALES: Array[StringName] = [&"station_42a", &"station_42b", &"station_42c"]
const CAMPAIGN_EPILOGUE := &"station_43"
const CAMPAIGN_SELECTOR_STATIONS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41", &"station_42a", &"station_43",
]
const OPERATION_TO_FINALE := {"A": &"station_42a", "B": &"station_42b", "C": &"station_42c"}
const DEFAULT_MASTER_VOLUME := 0.85
const DEFAULT_TEXT_SPEED_CPS := 42.0

var reached_stations: Dictionary = {}
var collected_clues: Dictionary = {}
var decisions: Dictionary = {}
var last_checkpoint_station: StringName = &""
var last_checkpoint_position := Vector2.ZERO
var test_mode_enabled := false
## Test harnesses may disable scene changes while retaining the real unlock chain.
var campaign_auto_transition_enabled := true
var master_volume_linear: float = DEFAULT_MASTER_VOLUME
var text_speed_cps: float = DEFAULT_TEXT_SPEED_CPS
var fullscreen_enabled := false

var _transition_layer: CanvasLayer
var _fade_rect: ColorRect
var _pause_layer: CanvasLayer
var _station_grid: GridContainer
var _status_label: Label
var _transitioning := false
var _save_valid := false
var _handled_completions: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	reload_settings_from_disk()
	reload_campaign_from_disk()
	_ensure_transition_overlay()
	_ensure_pause_menu()
	get_tree().node_added.connect(_observe_campaign_station)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed(&"pause") or event.is_echo() or _transitioning:
		return
	set_pause_menu_visible(not get_tree().paused)
	get_viewport().set_input_as_handled()


func mark_station_reached(station_id: StringName) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if normalized_id.is_empty() or reached_stations.has(normalized_id):
		return
	reached_stations[normalized_id] = true
	save_campaign()


func set_checkpoint(station_id: StringName, spawn_position: Vector2) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if normalized_id.is_empty():
		return
	mark_station_reached(normalized_id)
	last_checkpoint_station = normalized_id
	last_checkpoint_position = spawn_position
	save_campaign()
	checkpoint_changed.emit(normalized_id, spawn_position)


func collect_clue(clue_id: StringName) -> void:
	if clue_id.is_empty() or collected_clues.has(clue_id):
		return
	collected_clues[clue_id] = true
	save_campaign()
	clue_collected.emit(clue_id)


func has_collected_clue(clue_id: StringName) -> bool:
	return collected_clues.has(clue_id)


func record_decision(decision_id: StringName, value: Variant) -> void:
	if decision_id.is_empty():
		return
	decisions[decision_id] = value
	save_campaign()
	decision_recorded.emit(decision_id, value)


func has_reached_station(station_id: StringName) -> bool:
	return reached_stations.has(station_id)


func get_reached_station_ids() -> Array[StringName]:
	var result: Array[StringName] = []
	for station_id in reached_stations:
		result.append(StringName(station_id))
	return result


func get_selectable_stations(include_test_only: bool = false) -> Array[StringName]:
	var stations: Array[StringName] = CAMPAIGN_SELECTOR_STATIONS.duplicate()
	var selected_finale := get_selected_finale_id()
	if not selected_finale.is_empty():
		stations[41] = selected_finale
	if include_test_only or test_mode_enabled:
		return stations
	var unlocked: Array[StringName] = [&"station_01"]
	for station_id in stations:
		if has_reached_station(station_id) and not unlocked.has(station_id):
			unlocked.append(station_id)
	return unlocked


func get_all_campaign_scene_ids() -> Array[StringName]:
	var result: Array[StringName] = CAMPAIGN_ROUTE.duplicate()
	result.append_array(CAMPAIGN_FINALES)
	result.append(CAMPAIGN_EPILOGUE)
	return result


func set_test_mode(enabled: bool) -> void:
	test_mode_enabled = enabled
	_refresh_station_buttons()


func restart_from_checkpoint() -> void:
	if last_checkpoint_station.is_empty():
		return
	set_pause_menu_visible(false)
	transition_to_station(last_checkpoint_station)


func get_next_campaign_station(station_id: StringName) -> StringName:
	var normalized_id := _normalize_station_id(station_id)
	var route_index := CAMPAIGN_ROUTE.find(normalized_id)
	if route_index >= 0 and route_index < CAMPAIGN_ROUTE.size() - 1:
		return CAMPAIGN_ROUTE[route_index + 1]
	if normalized_id == &"station_41":
		return get_selected_finale_id()
	if normalized_id in CAMPAIGN_FINALES:
		return CAMPAIGN_EPILOGUE
	return &""


func complete_station(station_id: StringName, should_transition: bool = true) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if normalized_id.is_empty() or _handled_completions.has(normalized_id):
		return

	if normalized_id == &"station_41":
		var finale_id := get_selected_finale_id()
		if finale_id.is_empty():
			return
		_handled_completions[normalized_id] = true
		mark_station_reached(normalized_id)
		mark_station_reached(finale_id)
		if should_transition:
			transition_to_station(finale_id)
		return

	if normalized_id in CAMPAIGN_FINALES:
		if normalized_id != get_selected_finale_id():
			return
		_handled_completions[normalized_id] = true
		mark_station_reached(normalized_id)
		mark_station_reached(CAMPAIGN_EPILOGUE)
		if should_transition:
			transition_to_station(CAMPAIGN_EPILOGUE)
		return

	if normalized_id == CAMPAIGN_EPILOGUE:
		_handled_completions[normalized_id] = true
		mark_station_reached(normalized_id)
		decisions[&"campaign_completed"] = true
		save_campaign()
		campaign_completed.emit(get_selected_finale_id())
		if should_transition:
			return_to_title()
		return

	var route_index := CAMPAIGN_ROUTE.find(normalized_id)
	if route_index < 0:
		return
	_handled_completions[normalized_id] = true
	mark_station_reached(normalized_id)
	var next_station := get_next_campaign_station(normalized_id)
	if next_station.is_empty():
		return
	mark_station_reached(next_station)
	if should_transition:
		transition_to_station(next_station)


func start_new_game() -> void:
	reset_campaign(true)
	transition_to_station(&"station_01")


func continue_campaign() -> void:
	var target := last_checkpoint_station
	if not has_valid_campaign_save() or target.is_empty() or not _is_known_campaign_id(target):
		target = &"station_01"
	transition_to_station(target)


func return_to_title() -> void:
	get_tree().paused = false
	if is_instance_valid(_pause_layer):
		_pause_layer.visible = false
	transition_to_scene("res://scenes/shell/title_screen.tscn")


func has_valid_campaign_save() -> bool:
	return _save_valid


func is_transitioning() -> bool:
	return _transitioning


func is_campaign_completed() -> bool:
	return bool(_get_decision(&"campaign_completed", false))


func get_selected_finale_id() -> StringName:
	var saved_id := String(_get_decision(&"campaign_finale", ""))
	var finale_id := StringName(saved_id.to_lower())
	return finale_id if finale_id in CAMPAIGN_FINALES else &""


func select_finale_operation(operation: String) -> StringName:
	var normalized_operation := operation.to_upper()
	if not OPERATION_TO_FINALE.has(normalized_operation):
		return &""
	var finale_id: StringName = OPERATION_TO_FINALE[normalized_operation]
	decisions[&"station_41_operation"] = normalized_operation
	decisions[&"campaign_finale"] = String(finale_id)
	save_campaign()
	decision_recorded.emit(&"station_41_operation", normalized_operation)
	decision_recorded.emit(&"campaign_finale", String(finale_id))
	_refresh_station_buttons()
	return finale_id


func get_save_path() -> String:
	return SAVE_PATH


func get_settings_path() -> String:
	return SETTINGS_PATH


func set_master_volume(linear_value: float, persist: bool = true) -> void:
	master_volume_linear = clampf(linear_value, 0.0, 1.0)
	_apply_audio_setting()
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)


func set_text_speed_cps(speed: float, persist: bool = true) -> void:
	text_speed_cps = clampf(speed, 10.0, 90.0)
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)


func set_fullscreen(enabled: bool, persist: bool = true) -> void:
	fullscreen_enabled = enabled
	_apply_window_setting()
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)


func restore_default_settings(persist: bool = true) -> void:
	master_volume_linear = DEFAULT_MASTER_VOLUME
	text_speed_cps = DEFAULT_TEXT_SPEED_CPS
	fullscreen_enabled = false
	_apply_audio_setting()
	_apply_window_setting()
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)


func reload_settings_from_disk() -> bool:
	master_volume_linear = DEFAULT_MASTER_VOLUME
	text_speed_cps = DEFAULT_TEXT_SPEED_CPS
	fullscreen_enabled = false
	if not FileAccess.file_exists(SETTINGS_PATH):
		_apply_audio_setting()
		_apply_window_setting()
		return false
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file == null:
		_apply_audio_setting()
		_apply_window_setting()
		return false
	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	file.close()
	if parse_error != OK or not json.data is Dictionary:
		_apply_audio_setting()
		_apply_window_setting()
		return false
	var data := json.data as Dictionary
	master_volume_linear = clampf(float(data.get("master_volume", DEFAULT_MASTER_VOLUME)), 0.0, 1.0)
	text_speed_cps = clampf(float(data.get("text_speed_cps", DEFAULT_TEXT_SPEED_CPS)), 10.0, 90.0)
	fullscreen_enabled = bool(data.get("fullscreen", false))
	_apply_audio_setting()
	_apply_window_setting()
	return true


func save_settings_to_disk() -> bool:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_error("GameStateManager cannot write settings: %s" % SETTINGS_PATH)
		return false
	file.store_string(JSON.stringify({
		"settings_version": 1,
		"master_volume": master_volume_linear,
		"text_speed_cps": text_speed_cps,
		"fullscreen": fullscreen_enabled,
	}))
	file.close()
	return true


func _apply_audio_setting() -> void:
	var master_bus := AudioServer.get_bus_index(&"Master")
	if master_bus >= 0:
		AudioServer.set_bus_volume_linear(master_bus, maxf(master_volume_linear, 0.0001))


func _apply_window_setting() -> void:
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen_enabled else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)


func save_campaign() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("GameStateManager cannot write campaign save: %s" % SAVE_PATH)
		_save_valid = false
		return false
	file.store_string(JSON.stringify(_serialize_campaign()))
	file.close()
	_save_valid = true
	campaign_saved.emit(SAVE_PATH)
	return true


func reload_campaign_from_disk() -> bool:
	_clear_campaign_memory()
	_save_valid = false
	if not FileAccess.file_exists(SAVE_PATH):
		campaign_reloaded.emit()
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("GameStateManager could not open campaign save; using a clean campaign.")
		campaign_reloaded.emit()
		return false
	var json := JSON.new()
	var parse_error := json.parse(file.get_as_text())
	file.close()
	if parse_error != OK or not json.data is Dictionary:
		push_warning("GameStateManager ignored malformed campaign save; using a clean campaign.")
		campaign_reloaded.emit()
		return false
	var data := json.data as Dictionary
	if int(data.get("schema_version", -1)) != SAVE_SCHEMA_VERSION:
		push_warning("GameStateManager ignored unsupported campaign schema; using a clean campaign.")
		campaign_reloaded.emit()
		return false
	_restore_campaign(data)
	_save_valid = true
	campaign_reloaded.emit()
	return true


func reset_campaign(delete_save: bool = true) -> void:
	_clear_campaign_memory()
	_save_valid = false
	_handled_completions.clear()
	if delete_save and FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	campaign_reset.emit()
	_refresh_station_buttons()


func transition_to_station(station_id: StringName) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if not _is_known_campaign_id(normalized_id):
		push_error("GameStateManager cannot load unknown station: %s" % station_id)
		return
	if not test_mode_enabled and not _can_enter_station(normalized_id):
		push_warning("GameStateManager blocked locked station: %s" % normalized_id)
		return
	var scene_path := STATION_SCENE_PREFIX + String(normalized_id).trim_prefix("station_") + STATION_SCENE_SUFFIX
	if not ResourceLoader.exists(scene_path):
		push_error("GameStateManager cannot load station: %s" % station_id)
		return
	transition_to_scene(scene_path)


func transition_to_scene(scene_path: String) -> void:
	if _transitioning or scene_path.is_empty():
		return
	_transitioning = true
	_ensure_transition_overlay()
	transition_started.emit(scene_path)
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_fade_rect, "color:a", 1.0, 0.22)
	await tween.finished
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	var fade_in := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_in.tween_property(_fade_rect, "color:a", 0.0, 0.28)
	await fade_in.finished
	_transitioning = false
	transition_finished.emit(scene_path)


func set_pause_menu_visible(is_visible: bool) -> void:
	_ensure_pause_menu()
	get_tree().paused = is_visible
	_pause_layer.visible = is_visible
	if is_visible:
		_refresh_station_buttons()
	pause_changed.emit(is_visible)


func _serialize_campaign() -> Dictionary:
	return {
		"schema_version": SAVE_SCHEMA_VERSION,
		"reached_stations": reached_stations.keys(),
		"collected_clues": collected_clues.keys(),
		"decisions": decisions,
		"last_checkpoint_station": String(last_checkpoint_station),
		"last_checkpoint_position": {"x": last_checkpoint_position.x, "y": last_checkpoint_position.y},
	}


func _restore_campaign(data: Dictionary) -> void:
	for station_id in data.get("reached_stations", []):
		if station_id is String and not String(station_id).is_empty():
			reached_stations[StringName(station_id)] = true
	for clue_id in data.get("collected_clues", []):
		if clue_id is String and not String(clue_id).is_empty():
			collected_clues[StringName(clue_id)] = true
	var saved_decisions: Variant = data.get("decisions", {})
	if saved_decisions is Dictionary:
		decisions = (saved_decisions as Dictionary).duplicate(true)
	var checkpoint_station: Variant = data.get("last_checkpoint_station", "")
	if checkpoint_station is String and not String(checkpoint_station).is_empty():
		last_checkpoint_station = StringName(checkpoint_station as String)
		reached_stations[last_checkpoint_station] = true
	var saved_position: Variant = data.get("last_checkpoint_position", {})
	if saved_position is Dictionary:
		var pos_dict: Dictionary = saved_position as Dictionary
		last_checkpoint_position = Vector2(float(pos_dict.get("x", 0.0)), float(pos_dict.get("y", 0.0)))


func _clear_campaign_memory() -> void:
	reached_stations.clear()
	collected_clues.clear()
	decisions.clear()
	last_checkpoint_station = &""
	last_checkpoint_position = Vector2.ZERO


func _ensure_transition_overlay() -> void:
	if is_instance_valid(_transition_layer):
		return
	_transition_layer = CanvasLayer.new()
	_transition_layer.name = "SceneTransitionLayer"
	_transition_layer.layer = 100
	add_child(_transition_layer)
	_fade_rect = ColorRect.new()
	_fade_rect.name = "FadeToBlack"
	_fade_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_transition_layer.add_child(_fade_rect)


func _ensure_pause_menu() -> void:
	if is_instance_valid(_pause_layer):
		return
	_pause_layer = CanvasLayer.new()
	_pause_layer.name = "CampaignPauseMenu"
	_pause_layer.layer = 110
	_pause_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	_pause_layer.visible = false
	add_child(_pause_layer)
	var shade := ColorRect.new()
	shade.color = Color(VectorStageStyle.BACKDROP, 0.96)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pause_layer.add_child(shade)
	var panel := PanelContainer.new()
	panel.name = "PanelContainer"
	panel.position = Vector2(36.0, 18.0)
	panel.size = Vector2(568.0, 324.0)
	_pause_layer.add_child(panel)
	var style := StyleBoxFlat.new()
	style.bg_color = VectorStageStyle.INK
	style.border_color = VectorStageStyle.LIGHT_PLANE
	style.set_border_width_all(1)
	style.border_width_left = 5
	style.content_margin_left = 12.0
	style.content_margin_right = 12.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	panel.add_theme_stylebox_override(&"panel", style)
	var content := VBoxContainer.new()
	content.name = "VBoxContainer"
	content.add_theme_constant_override(&"separation", 5)
	panel.add_child(content)
	var title := Label.new()
	title.text = "KAMPANIA  //  PAUZA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.add_theme_font_size_override(&"font_size", 19)
	title.modulate = VectorStageStyle.HUMAN_AMBER
	content.add_child(title)
	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_status_label.modulate = VectorStageStyle.light(VectorStageStyle.LIGHT_PLANE, 0.40)
	_status_label.add_theme_font_size_override(&"font_size", 11)
	content.add_child(_status_label)
	var actions := HBoxContainer.new()
	actions.name = "HBoxContainer"
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override(&"separation", 5)
	content.add_child(actions)
	_add_menu_button(actions, "WZNÓW", func() -> void: set_pause_menu_visible(false), "ResumeButton")
	_add_menu_button(actions, "CHECKPOINT", restart_from_checkpoint, "CheckpointButton")
	_add_menu_button(actions, "TRYB TESTOWY: OFF", _toggle_test_mode, "TestModeButton")
	_add_menu_button(actions, "RESET ZAPISU", func() -> void: reset_campaign(true), "ResetButton")
	content.add_child(HSeparator.new())
	_station_grid = GridContainer.new()
	_station_grid.name = "StationGrid"
	_station_grid.columns = 9
	_station_grid.add_theme_constant_override(&"h_separation", 4)
	_station_grid.add_theme_constant_override(&"v_separation", 4)
	_station_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_station_grid)
	var footer := Label.new()
	footer.text = "PAUZA: POWRÓT  //  INTERAKCJA: WYBÓR"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	footer.modulate = VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.12)
	footer.add_theme_font_size_override(&"font_size", 9)
	content.add_child(footer)


func _add_menu_button(parent: Container, text: String, callback: Callable, button_name: String = "") -> void:
	var button := Button.new()
	button.name = button_name
	button.text = text
	button.custom_minimum_size = Vector2(100.0, 24.0)
	_style_pause_button(button, false)
	button.pressed.connect(callback)
	parent.add_child(button)


func _style_pause_button(button: Button, compact: bool) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = VectorStageStyle.DEEP_PLANE
	normal.border_color = VectorStageStyle.MID_PLANE
	normal.set_border_width_all(1)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = VectorStageStyle.MID_PLANE
	hover.border_color = VectorStageStyle.ANCHOR_CYAN
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.52)
	pressed.border_color = VectorStageStyle.ANCHOR_CYAN
	var disabled := normal.duplicate() as StyleBoxFlat
	disabled.bg_color = VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.28)
	disabled.border_color = VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30)
	button.add_theme_stylebox_override(&"normal", normal)
	button.add_theme_stylebox_override(&"hover", hover)
	button.add_theme_stylebox_override(&"pressed", pressed)
	button.add_theme_stylebox_override(&"focus", hover)
	button.add_theme_stylebox_override(&"disabled", disabled)
	button.add_theme_color_override(&"font_color", VectorStageStyle.light(VectorStageStyle.LIGHT_PLANE, 0.46))
	button.add_theme_color_override(&"font_hover_color", Color.WHITE)
	button.add_theme_color_override(&"font_pressed_color", Color.WHITE)
	button.add_theme_color_override(&"font_disabled_color", VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.36))
	button.add_theme_font_size_override(&"font_size", 10 if compact else 11)


func _toggle_test_mode() -> void:
	set_test_mode(not test_mode_enabled)


func _refresh_station_buttons() -> void:
	if not is_instance_valid(_station_grid):
		return
	for child in _station_grid.get_children():
		child.queue_free()
	for station_id in get_selectable_stations(true):
		var button := Button.new()
		var unlocked := test_mode_enabled or station_id == &"station_01" or has_reached_station(station_id)
		button.text = String(station_id).trim_prefix("station_").to_upper()
		button.tooltip_text = "Przestrzeń " + button.text
		button.disabled = not unlocked
		button.custom_minimum_size = Vector2(52.0, 24.0)
		_style_pause_button(button, true)
		button.pressed.connect(_on_station_requested.bind(station_id))
		_station_grid.add_child(button)
	if is_instance_valid(_status_label):
		_status_label.text = "ODKRYTE: %d/43   |   TRYB TESTOWY: %s" % [get_selectable_stations().size(), "ON" if test_mode_enabled else "OFF"]
	var test_button := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/TestModeButton") as Button
	if test_button:
		test_button.text = "TRYB TESTOWY: " + ("ON" if test_mode_enabled else "OFF")


func _on_station_requested(station_id: StringName) -> void:
	set_pause_menu_visible(false)
	transition_to_station(station_id)


func _observe_campaign_station(node: Node) -> void:
	if not node is Node2D:
		return
	var station_id := _station_id_from_node(node)
	if station_id.is_empty():
		return
	if not _is_known_campaign_id(station_id):
		return
	if node.has_signal(&"level_completed"):
		var completion_callback := _on_campaign_station_completed.bind(station_id, node)
		if not node.is_connected(&"level_completed", completion_callback):
			node.connect(&"level_completed", completion_callback)
	if station_id == &"station_41" and node.has_signal(&"operation_selected"):
		var operation_callback := _on_campaign_operation_selected.bind(station_id)
		if not node.is_connected(&"operation_selected", operation_callback):
			node.connect(&"operation_selected", operation_callback)


func _on_campaign_station_completed(station_id: StringName, source_node: Node) -> void:
	if station_id == &"station_41" and source_node != null:
		var chosen_operation := String(source_node.get("chosen_operation"))
		if get_selected_finale_id().is_empty() and not chosen_operation.is_empty():
			select_finale_operation(chosen_operation)
	complete_station(station_id, campaign_auto_transition_enabled)


func _on_campaign_operation_selected(operation: String, _station_id: StringName) -> void:
	select_finale_operation(operation)


func _station_id_from_node(node: Node) -> StringName:
	var suffix := String(node.name).trim_prefix("Station").to_lower()
	if suffix.is_valid_int():
		return StringName("station_%02d" % suffix.to_int())
	if suffix in ["42a", "42b", "42c"]:
		return StringName("station_" + suffix)
	return &""


func _normalize_station_id(station_id: StringName) -> StringName:
	var normalized := String(station_id).to_lower()
	if normalized.begins_with("station") and not normalized.begins_with("station_"):
		normalized = "station_" + normalized.trim_prefix("station")
	if normalized.begins_with("station_"):
		var suffix := normalized.trim_prefix("station_")
		if suffix.is_valid_int():
			return StringName("station_%02d" % suffix.to_int())
		if suffix in ["42a", "42b", "42c", "43"]:
			return StringName(normalized)
	return &""


func _is_known_campaign_id(station_id: StringName) -> bool:
	return station_id in CAMPAIGN_ROUTE or station_id in CAMPAIGN_FINALES or station_id == CAMPAIGN_EPILOGUE


func _can_enter_station(station_id: StringName) -> bool:
	if station_id == &"station_01":
		return true
	return has_reached_station(station_id)


func _get_decision(decision_id: StringName, fallback: Variant) -> Variant:
	if decisions.has(decision_id):
		return decisions[decision_id]
	var string_id := String(decision_id)
	if decisions.has(string_id):
		return decisions[string_id]
	return fallback
