class_name ReturnZone
extends Area2D

## ReturnZone — lewa krawędź stacji 02–43 emituje previous_level_requested.
## Diegetycznie: próg / śluza powrotu, nie teleport. D-124.

signal return_requested()

@export var zone_width: float = 28.0
@export var zone_height: float = 220.0
@export var zone_x: float = 18.0
@export var zone_y: float = 186.0

var _armed: bool = true


func _ready() -> void:
	name = "ReturnZone"
	collision_layer = 1
	collision_mask = 1
	position = Vector2(zone_x, zone_y)
	_ensure_shape()
	monitoring = true
	monitorable = true
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)


func _ensure_shape() -> void:
	var shape_node := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node == null:
		shape_node = CollisionShape2D.new()
		shape_node.name = "CollisionShape2D"
		var rect := RectangleShape2D.new()
		rect.size = Vector2(zone_width, zone_height)
		shape_node.shape = rect
		shape_node.position = Vector2.ZERO
		add_child(shape_node)
	else:
		var rect := RectangleShape2D.new()
		rect.size = Vector2(zone_width, zone_height)
		shape_node.shape = rect
		shape_node.position = Vector2.ZERO


func _on_body_entered(body: Node2D) -> void:
	if not _armed:
		return
	if not (body is PrototypePlayer or body.name == "Player"):
		return
	_armed = false
	return_requested.emit()
	var station := _find_station_root()
	if station != null and station.has_signal(&"previous_level_requested"):
		station.emit_signal(&"previous_level_requested")


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		_armed = true


func _find_station_root() -> Node:
	var node: Node = self
	while node != null:
		if node.has_signal(&"previous_level_requested"):
			return node
		node = node.get_parent()
	return null
