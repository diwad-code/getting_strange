class_name OpeningActionPoint
extends Area2D

## Small local-scene action primitive for the rebuilt opening.
## It owns only reach, semantic InputMap input and visible action state. The
## station owns prerequisites, consequences, persistence and route changes.

signal action_requested(action_id: StringName)
signal action_state_changed(action_id: StringName, is_resolved: bool)

@export var action_id: StringName
@export_range(20.0, 72.0, 1.0) var interaction_radius := 34.0
@export var initially_available := true

var is_player_in_range := false:
	set(value):
		if is_player_in_range == value:
			return
		is_player_in_range = value
		queue_redraw()

var is_available := true:
	set(value):
		if is_available == value:
			return
		is_available = value
		queue_redraw()

var is_resolved := false:
	set(value):
		if is_resolved == value:
			return
		is_resolved = value
		action_state_changed.emit(action_id, is_resolved)
		queue_redraw()


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	is_available = initially_available
	_ensure_collision_shape()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	queue_redraw()


func _ensure_collision_shape() -> void:
	var collision_shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision_shape == null:
		collision_shape = CollisionShape2D.new()
		collision_shape.name = "CollisionShape2D"
		add_child(collision_shape)
	var shape := collision_shape.shape as CircleShape2D
	if shape == null:
		shape = CircleShape2D.new()
		collision_shape.shape = shape
	shape.radius = interaction_radius


func _on_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = false


func _unhandled_input(event: InputEvent) -> void:
	if not is_player_in_range or not event.is_action_pressed(&"interact"):
		return
	if trigger_interaction():
		get_viewport().set_input_as_handled()


func trigger_interaction() -> bool:
	if not is_available or is_resolved:
		return false
	action_requested.emit(action_id)
	return true


func set_available(value: bool) -> void:
	is_available = value


func resolve() -> void:
	is_resolved = true


func _draw() -> void:
	var color := VectorStageStyle.ANCHOR_CYAN if is_resolved else VectorStageStyle.HUMAN_AMBER
	if not is_available:
		color = VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.22)
	elif not is_player_in_range and not is_resolved:
		color = VectorStageStyle.shade(color, 0.36)
	var radius := 8.0 if is_player_in_range and not is_resolved else 6.0
	draw_circle(Vector2.ZERO, radius, Color(color, 0.10))
	draw_circle(Vector2.ZERO, radius, color, false, 1.5)
	if is_resolved:
		draw_line(Vector2(-3.0, 0.0), Vector2(-0.5, 3.0), color, 1.5)
		draw_line(Vector2(-0.5, 3.0), Vector2(4.0, -4.0), color, 1.5)
