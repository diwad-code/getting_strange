class_name ThresholdZone
extends Area2D

## ThresholdZone — diegetic campaign entrance (D-188).
## aperture_rect is the single source of truth for drawing, collision and scale lint.
## Crossing requires the interact verb. AirlockZone is a closure zone, not a trigger.

signal crossed()
signal sequence_started()

enum Family { DOOR, VEHICLE, HATCH }

@export var entry_family: Family = Family.DOOR
@export var entry_anchor: Vector2 = Vector2(-36.0, 0.0)
@export var facing: float = 1.0
@export var aperture_rect: Rect2 = Rect2(-27.0, -57.0, 54.0, 114.0)
@export var target_station: StringName = &""
@export var is_open: bool = false:
	set(value):
		if is_open == value:
			return
		is_open = value
		queue_redraw()
@export var blocked_reason: StringName = &""
@export var blocking_body_path: NodePath = NodePath("")

const APPROACH_S := 0.32
const DOOR_S := 0.95
const VEHICLE_S := 1.40
const HATCH_S := 1.20

var is_player_in_range := false
var _busy := false
var _leaf_t := 0.0
var _sequence_player: Node2D
var _approach_from := Vector2.ZERO
var _approach_elapsed := 0.0
var _phase: StringName = &""


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	monitorable = true
	z_index = 4
	_ensure_collision_shape()
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)
	set_process(true)
	queue_redraw()


func _ensure_collision_shape() -> void:
	var shape_node := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node == null:
		shape_node = CollisionShape2D.new()
		shape_node.name = "CollisionShape2D"
		add_child(shape_node)
	var rect := RectangleShape2D.new()
	var reach := 40.0
	rect.size = Vector2(aperture_rect.size.x + reach, maxf(aperture_rect.size.y, 72.0))
	shape_node.shape = rect
	shape_node.position = Vector2(aperture_rect.position.x + aperture_rect.size.x * 0.5 - reach * 0.5, aperture_rect.position.y + aperture_rect.size.y * 0.5)


func aperture_size() -> Vector2:
	return aperture_rect.size


func _on_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = true
		queue_redraw()


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = false
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if not is_player_in_range or _busy:
		return
	if not event.is_action_pressed(&"interact"):
		return
	var player := _find_player()
	if player != null and trigger_entry(player):
		get_viewport().set_input_as_handled()


func _find_player() -> Node2D:
	var parent := get_parent()
	if parent == null:
		return null
	return parent.get_node_or_null("Player") as Node2D


func trigger_entry(player: Node2D, instant: bool = false) -> bool:
	if player == null or _busy:
		return false
	if not is_open:
		return false
	_busy = true
	_sequence_player = player
	sequence_started.emit()
	_disable_blocking_body()
	if player.has_method("lock_for_threshold"):
		player.call("lock_for_threshold")
	var rig: Node = player.get_node_or_null("LenaVisualRig")
	if rig != null and rig.has_method("set_facing"):
		rig.call("set_facing", facing)
	var pose := _pose_name()
	if rig != null and rig.has_method("play_cue"):
		rig.call("play_cue", pose, _sequence_duration())
	if instant or not player.is_physics_processing():
		_finish_entry()
		return true
	_phase = &"approach"
	_approach_from = player.global_position
	_approach_elapsed = 0.0
	_leaf_t = 0.0
	set_process(true)
	return true


func _pose_name() -> StringName:
	match entry_family:
		Family.VEHICLE:
			return &"board_vehicle"
		Family.HATCH:
			return &"ladder_dismount"
		_:
			return &"enter_door"


func _sequence_duration() -> float:
	match entry_family:
		Family.VEHICLE:
			return VEHICLE_S
		Family.HATCH:
			return HATCH_S
		_:
			return DOOR_S


func _process(delta: float) -> void:
	var host := get_parent()
	if host != null and bool(host.get("is_exit_unlocked")) and not is_open:
		is_open = true
	if not _busy:
		return
	if _phase == &"approach":
		_approach_elapsed += delta
		var t := clampf(_approach_elapsed / APPROACH_S, 0.0, 1.0)
		var target := to_global(entry_anchor)
		if _sequence_player != null and is_instance_valid(_sequence_player):
			_sequence_player.global_position = _approach_from.lerp(target, t)
		if t >= 1.0:
			_phase = &"perform"
			_leaf_t = 0.0
		queue_redraw()
		return
	if _phase == &"perform":
		_leaf_t = minf(1.0, _leaf_t + delta / _sequence_duration())
		queue_redraw()
		if _leaf_t >= 1.0:
			_finish_entry()


func _finish_entry() -> void:
	_phase = &""
	_leaf_t = 1.0
	set_process(false)
	if _sequence_player != null and is_instance_valid(_sequence_player) and _sequence_player.has_method("unlock_from_threshold"):
		_sequence_player.call("unlock_from_threshold")
	_busy = false
	crossed.emit()
	queue_redraw()


func _disable_blocking_body() -> void:
	if blocking_body_path.is_empty():
		return
	var body := get_node_or_null(blocking_body_path) as Node2D
	if body == null and get_parent() != null:
		body = get_parent().get_node_or_null(blocking_body_path) as Node2D
	if body == null:
		return
	ExitClearance.disable_collision(body)


func _draw() -> void:
	var rect := aperture_rect
	var fill := VectorStageStyle.DEEP_PLANE
	var edge := VectorStageStyle.HUMAN_AMBER if is_open else VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.10)
	if is_player_in_range and is_open and not _busy:
		edge = VectorStageStyle.ANCHOR_CYAN
	match entry_family:
		Family.VEHICLE:
			_draw_vehicle_aperture(rect, fill, edge)
		Family.HATCH:
			_draw_hatch_aperture(rect, fill, edge)
		_:
			_draw_door_aperture(rect, fill, edge)


func _draw_door_aperture(rect: Rect2, fill: Color, edge: Color) -> void:
	var open_k := _leaf_t if _busy or _leaf_t > 0.0 else 0.0
	var leaf_w := rect.size.x * (1.0 - 0.82 * open_k)
	draw_rect(Rect2(rect.position, Vector2(leaf_w, rect.size.y)), VectorStageStyle.INK)
	draw_rect(Rect2(rect.position, Vector2(leaf_w, rect.size.y)), fill)
	draw_rect(Rect2(rect.position, Vector2(maxf(leaf_w, 2.0), rect.size.y)), edge, false, 2.0)
	if leaf_w > 8.0:
		var handle := Vector2(rect.position.x + leaf_w - 6.0, rect.position.y + rect.size.y * 0.52)
		draw_circle(handle, 2.5, VectorStageStyle.LIGHT_PLANE)
	if is_open and not _busy:
		draw_line(rect.position, rect.position + Vector2(0.0, 8.0), VectorStageStyle.ANCHOR_CYAN, 2.0)


func _draw_vehicle_aperture(rect: Rect2, fill: Color, edge: Color) -> void:
	var open_k := _leaf_t if _busy or _leaf_t > 0.0 else 0.0
	var slide := rect.size.x * 0.48 * open_k
	var half := rect.size.x * 0.5
	var left := Rect2(rect.position.x - slide, rect.position.y, half, rect.size.y)
	var right := Rect2(rect.position.x + half + slide, rect.position.y, half, rect.size.y)
	draw_rect(left, fill)
	draw_rect(right, fill)
	draw_rect(left, edge, false, 2.0)
	draw_rect(right, edge, false, 2.0)
	draw_line(Vector2(rect.position.x + half, rect.position.y + 6.0), Vector2(rect.position.x + half, rect.position.y + rect.size.y - 6.0), VectorStageStyle.LIGHT_PLANE, 1.5)


func _draw_hatch_aperture(rect: Rect2, fill: Color, edge: Color) -> void:
	draw_rect(rect, VectorStageStyle.INK)
	draw_rect(rect.grow(-3.0), fill)
	draw_rect(rect, edge, false, 2.0)
	var lid_h := rect.size.y * (1.0 - 0.7 * _leaf_t)
	draw_rect(Rect2(rect.position, Vector2(rect.size.x, lid_h)), VectorStageStyle.MID_PLANE)
	draw_line(rect.position + Vector2(4.0, 4.0), rect.position + Vector2(rect.size.x - 4.0, 4.0), VectorStageStyle.LIGHT_PLANE, 2.0)
