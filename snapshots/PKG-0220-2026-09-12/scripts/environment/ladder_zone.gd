class_name LadderZone
extends Area2D

## LadderZone — diegetyczna drabina techniczna IKP dla Getting Strange (3.0)
## Eliminuje platforming i parkour na rzecz realistycznej wspinaczki pionowej.
## Zgodna z kanonem VISUAL_DESIGN.md i TRAVERSAL_AND_OBSTACLE_DESIGN.md.

@export var ladder_height: float = 120.0
@export var ladder_width: float = 22.0
@export var ladder_title: String = "Drabina techniczna IKP"
@export var has_safety_cage: bool = false

const RUNG_SPACING: float = 14.0

var _collision_shape: CollisionShape2D


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	_ensure_collision_shape()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	queue_redraw()


func _ensure_collision_shape() -> void:
	_collision_shape = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if _collision_shape == null:
		_collision_shape = CollisionShape2D.new()
		_collision_shape.name = "CollisionShape2D"
		var rect := RectangleShape2D.new()
		rect.size = Vector2(ladder_width + 12.0, ladder_height)
		_collision_shape.shape = rect
		_collision_shape.position = Vector2(0.0, -ladder_height * 0.5)
		add_child(_collision_shape)
	elif _collision_shape.shape is RectangleShape2D:
		var rect := _collision_shape.shape as RectangleShape2D
		ladder_height = rect.size.y
		ladder_width = maxf(16.0, rect.size.x - 12.0)


func _on_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		if body.has_method("attach_to_ladder"):
			body.attach_to_ladder(self)


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		if body.has_method("detach_from_ladder"):
			body.detach_from_ladder(self)


func _draw() -> void:
	var half_w := ladder_width * 0.5
	var top_y := -ladder_height
	var bot_y := 0.0
	
	# Shadow behind ladder
	draw_rect(Rect2(-half_w - 2.0, top_y, ladder_width + 4.0, ladder_height), Color(VectorStageStyle.INK, 0.35))
	
	# Left vertical rail
	draw_line(Vector2(-half_w, top_y), Vector2(-half_w, bot_y), VectorStageStyle.DEEP_PLANE, 3.0)
	draw_line(Vector2(-half_w, top_y), Vector2(-half_w, bot_y), VectorStageStyle.LIGHT_PLANE, 1.0)
	
	# Right vertical rail
	draw_line(Vector2(half_w, top_y), Vector2(half_w, bot_y), VectorStageStyle.DEEP_PLANE, 3.0)
	draw_line(Vector2(half_w, top_y), Vector2(half_w, bot_y), VectorStageStyle.LIGHT_PLANE, 1.0)
	
	# Wall anchors every 42 px
	var anchor_y := bot_y - 8.0
	while anchor_y >= top_y + 8.0:
		draw_line(Vector2(-half_w - 4.0, anchor_y), Vector2(-half_w, anchor_y), VectorStageStyle.INK, 3.0)
		draw_line(Vector2(half_w, anchor_y), Vector2(half_w + 4.0, anchor_y), VectorStageStyle.INK, 3.0)
		anchor_y -= 42.0
	
	# Rungs
	var rung_y := bot_y - 6.0
	var rung_idx := 0
	while rung_y >= top_y + 4.0:
		var rung_col: Color = VectorStageStyle.LIGHT_PLANE
		if rung_idx % 4 == 0:
			rung_col = VectorStageStyle.HUMAN_AMBER # Inspection markers
		draw_line(Vector2(-half_w + 1.0, rung_y), Vector2(half_w - 1.0, rung_y), VectorStageStyle.shade(rung_col, 0.25), 2.5)
		draw_line(Vector2(-half_w + 1.0, rung_y - 0.5), Vector2(half_w - 1.0, rung_y - 0.5), rung_col, 1.0)
		rung_y -= RUNG_SPACING
		rung_idx += 1
	
	# Safety Cage hoops if enabled
	if has_safety_cage:
		var hoop_y := bot_y - 36.0
		while hoop_y >= top_y + 10.0:
			var hoop_poly := PackedVector2Array([
				Vector2(-half_w, hoop_y),
				Vector2(-half_w - 8.0, hoop_y + 4.0),
				Vector2(0.0, hoop_y + 10.0),
				Vector2(half_w + 8.0, hoop_y + 4.0),
				Vector2(half_w, hoop_y)
			])
			draw_polyline(hoop_poly, VectorStageStyle.DEEP_PLANE, 2.0)
			hoop_y -= 28.0
