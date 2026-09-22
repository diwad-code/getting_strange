class_name VectorStageEnvironment
extends Node2D

## Replaces decorative grids with stage-like planar depth for early stations.
## Runtime geometry and collision remain owned by the existing station scenes.

@export var stage_seed := 1
@export var world_size := Vector2(640.0, 360.0)


func _ready() -> void:
	z_index = -5
	queue_redraw()


func _draw() -> void:
	VectorStageStyle.draw_stage_background(self, world_size, stage_seed)
	var lamp_positions := [
		Vector2(world_size.x * 0.18, 44.0),
		Vector2(world_size.x * 0.53, 56.0),
		Vector2(world_size.x * 0.82, 40.0),
	]
	for lamp_position in lamp_positions:
		VectorStageStyle.draw_faceted_lamp(self, lamp_position)