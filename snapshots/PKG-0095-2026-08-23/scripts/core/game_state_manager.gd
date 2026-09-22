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

const SAVE_SCHEMA_VERSION := 1
const SAVE_PATH := "user://getting_strange_campaign_v1.json"
const STATION_SCENE_PREFIX := "res://scenes/levels/station_"
const STATION_SCENE_SUFFIX := ".tscn"
const CAMPAIGN_TRANSITION_LIMIT := 15

var reached_stations: Dictionary = {}
var collected_clues: Dictionary = {}
var decisions: Dictionary = {}
var last_checkpoint_station: StringName = &""
var last_checkpoint_position := Vector2.ZERO
var test_mode_enabled := false
## Test harnesses may disable scene changes while retaining the real unlock chain.
var campaign_auto_transition_enabled := true

var _transition_layer: CanvasLayer
var _fade_rect: ColorRect
var _pause_layer: CanvasLayer
var _station_grid: GridContainer
var _status_label: Label
var _transitioning := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
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
	if station_id.is_empty() or reached_stations.has(station_id):
		return
	reached_stations[station_id] = true
	save_campaign()


func set_checkpoint(station_id: StringName, spawn_position: Vector2) -> void:
	if station_id.is_empty():
		return
	mark_station_reached(station_id)
	last_checkpoint_station = station_id
	last_checkpoint_position = spawn_position
	save_campaign()
	checkpoint_changed.emit(station_id, spawn_position)


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
	var stations: Array[StringName] = []
	for station_number in range(1, 42):
		stations.append(StringName("station_%02d" % station_number))
	stations.append(&"station_42a")
	stations.append(&"station_43")
	if include_test_only or test_mode_enabled:
		return stations
	var unlocked: Array[StringName] = [&"station_01"]
	for station_id in stations:
		if has_reached_station(station_id) and not unlocked.has(station_id):
			unlocked.append(station_id)
	return unlocked


func set_test_mode(enabled: bool) -> void:
	test_mode_enabled = enabled
	_refresh_station_buttons()


func restart_from_checkpoint() -> void:
	if last_checkpoint_station.is_empty():
		return
	set_pause_menu_visible(false)
	transition_to_station(last_checkpoint_station)


func get_next_campaign_station(station_id: StringName) -> StringName:
	var station_number := _station_number_from_id(station_id)
	if station_number < 1 or station_number >= CAMPAIGN_TRANSITION_LIMIT:
		return &""
	return StringName("station_%02d" % (station_number + 1))


func complete_station(station_id: StringName, should_transition: bool = true) -> void:
	var next_station := get_next_campaign_station(station_id)
	if next_station.is_empty():
		return
	mark_station_reached(station_id)
	mark_station_reached(next_station)
	if should_transition:
		transition_to_station(next_station)


func get_save_path() -> String:
	return SAVE_PATH


func save_campaign() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("GameStateManager cannot write campaign save: %s" % SAVE_PATH)
		return false
	file.store_string(JSON.stringify(_serialize_campaign()))
	file.close()
	campaign_saved.emit(SAVE_PATH)
	return true


func reload_campaign_from_disk() -> bool:
	_clear_campaign_memory()
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
	campaign_reloaded.emit()
	return true


func reset_campaign(delete_save: bool = true) -> void:
	_clear_campaign_memory()
	if delete_save and FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	campaign_reset.emit()
	_refresh_station_buttons()


func transition_to_station(station_id: StringName) -> void:
	var normalized_id := String(station_id).to_lower()
	if normalized_id.begins_with("station_"):
		normalized_id = normalized_id.trim_prefix("station_")
	var scene_path := STATION_SCENE_PREFIX + normalized_id + STATION_SCENE_SUFFIX
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
	shade.color = Color(0.02, 0.04, 0.06, 0.92)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pause_layer.add_child(shade)
	var panel := PanelContainer.new()
	panel.position = Vector2(48.0, 26.0)
	panel.size = Vector2(544.0, 308.0)
	_pause_layer.add_child(panel)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("101d27")
	style.border_color = Color("6cc4bf")
	style.set_border_width_all(2)
	panel.add_theme_stylebox_override(&"panel", style)
	var content := VBoxContainer.new()
	content.add_theme_constant_override(&"separation", 6)
	panel.add_child(content)
	var title := Label.new()
	title.text = "KAMPANIA // PAUZA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override(&"font_size", 20)
	title.modulate = Color("d29a63")
	content.add_child(title)
	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(_status_label)
	var actions := HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_child(actions)
	_add_menu_button(actions, "WZNÓW", func() -> void: set_pause_menu_visible(false), "ResumeButton")
	_add_menu_button(actions, "CHECKPOINT", restart_from_checkpoint, "CheckpointButton")
	_add_menu_button(actions, "TRYB TESTOWY: OFF", _toggle_test_mode, "TestModeButton")
	_add_menu_button(actions, "RESET ZAPISU", func() -> void: reset_campaign(true), "ResetButton")
	content.add_child(HSeparator.new())
	_station_grid = GridContainer.new()
	_station_grid.columns = 6
	_station_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_station_grid)


func _add_menu_button(parent: Container, text: String, callback: Callable, button_name: String = "") -> void:
	var button := Button.new()
	button.name = button_name
	button.text = text
	button.custom_minimum_size = Vector2(100.0, 24.0)
	button.pressed.connect(callback)
	parent.add_child(button)


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
		button.custom_minimum_size = Vector2(76.0, 22.0)
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
	if not node is Node2D or not node.name.begins_with("Station"):
		return
	var station_number_text := String(node.name).trim_prefix("Station")
	if not station_number_text.is_valid_int():
		return
	var station_number := station_number_text.to_int()
	if station_number < 1 or station_number > CAMPAIGN_TRANSITION_LIMIT:
		return
	if node.has_signal(&"level_completed"):
		var station_id := StringName("station_%02d" % station_number)
		if not node.is_connected(&"level_completed", _on_campaign_station_completed.bind(station_id)):
			node.connect(&"level_completed", _on_campaign_station_completed.bind(station_id))


func _on_campaign_station_completed(station_id: StringName) -> void:
	complete_station(station_id, campaign_auto_transition_enabled)


func _station_number_from_id(station_id: StringName) -> int:
	var station_text := String(station_id).to_lower().trim_prefix("station_")
	return station_text.to_int() if station_text.is_valid_int() else -1