class_name ExitClearance
extends RefCounted

## ExitClearance — open a blocking body so a 72 px capsule can pass.
## Lift alone is not enough (PKG-0133: 70 px lift left door bottom at 258,
## player top at 224). Always disable CollisionShape2D first.

const LIFT_PX := 140.0


static func open_body(body: Node2D, lift_px: float = LIFT_PX) -> void:
	if body == null or not is_instance_valid(body):
		return
	if body is CollisionObject2D:
		(body as CollisionObject2D).collision_layer = 0
		(body as CollisionObject2D).collision_mask = 0
	_disable_shapes(body)
	if body is Node2D:
		(body as Node2D).position.y -= lift_px


static func open_body_tweened(host: Node, body: Node2D, lift_px: float = LIFT_PX, duration: float = 1.0) -> void:
	if body == null or not is_instance_valid(body):
		return
	if body is CollisionObject2D:
		(body as CollisionObject2D).collision_layer = 0
		(body as CollisionObject2D).collision_mask = 0
	_disable_shapes(body)
	if host == null or not is_instance_valid(host):
		(body as Node2D).position.y -= lift_px
		return
	var tween := host.create_tween()
	tween.tween_property(body, "position:y", body.position.y - lift_px, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


static func _disable_shapes(node: Node) -> void:
	if node is CollisionShape2D:
		(node as CollisionShape2D).disabled = true
	elif node is CollisionPolygon2D:
		(node as CollisionPolygon2D).disabled = true
	for child in node.get_children():
		_disable_shapes(child)
