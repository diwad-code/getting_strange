extends Node

## Persistent in-memory campaign state and scene transition coordinator.
## The current package intentionally keeps saves deterministic and local: a session
## can always restart the latest checkpoint or open any implemented station.

signal checkpoint_changed(station_id: StringName, spawn_position: Vector2)
signal clue_collected(clue_id: StringName)
signal decision_recorded(decision_id: StringName, value: Variant)
signal transition_started(target_scene: String)
signal transition_finished(target_scene: String)

const STATION_SCENE_PREFIX := "res://scenes/levels/station_"
const STATION_SCENE_SUFFIX := ".tscn"

var reached_stations: Dictionary = {}
var collected_clues: Dictionary = {}
var decisions: Dictionary = {}
var last_checkpoint_station: StringName = &""
var last_checkpoint_position := Vector2.ZERO

var _transition_layer: CanvasLayer
var _fade_rect: ColorRect
var _transitioning := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_ensure_transition_overlay()


func mark_station_reached(station_id: StringName) -> void:
	if station_id.is_empty():
		return
	reached_stations[station_id] = true


func set_checkpoint(station_id: StringName, spawn_position: Vector2) -> void:
	mark_station_reached(station_id)
	last_checkpoint_station = station_id
	last_checkpoint_position = spawn_position
	checkpoint_changed.emit(station_id, spawn_position)


func collect_clue(clue_id: StringName) -> void:
	if clue_id.is_empty() or collected_clues.has(clue_id):
		return
	collected_clues[clue_id] = true
	clue_collected.emit(clue_id)


func record_decision(decision_id: StringName, value: Variant) -> void:
	if decision_id.is_empty():
		return
	decisions[decision_id] = value
	decision_recorded.emit(decision_id, value)


func has_reached_station(station_id: StringName) -> bool:
	return reached_stations.has(station_id)


func get_reached_station_ids() -> Array[StringName]:
	var result: Array[StringName] = []
	for station_id in reached_stations:
		result.append(StringName(station_id))
	return result


func get_selectable_stations() -> Array[StringName]:
	var stations: Array[StringName] = []
	for station_number in range(1, 42):
		stations.append(StringName("station_%02d" % station_number))
	# 42A/B/C are mutually exclusive story variants of a single narrative space.
	stations.append(&"station_42a")
	stations.append(&"station_43")
	return stations


func restart_from_checkpoint() -> void:
	if last_checkpoint_station.is_empty():
		return
	transition_to_station(last_checkpoint_station)


func transition_to_station(station_id: StringName) -> void:
	var scene_path := STATION_SCENE_PREFIX + String(station_id).to_lower() + STATION_SCENE_SUFFIX
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