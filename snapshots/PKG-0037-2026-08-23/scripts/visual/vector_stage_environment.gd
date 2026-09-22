class_name VectorStageEnvironment
extends Node2D

## Replaces decorative grids with stage-like planar depth for early stations.
## Runtime geometry and collision remain owned by the existing station scenes.

@export var stage_seed := 1
@export var world_size := Vector2(640.0, 360.0)
@export_range(1, 43) var station_number := 1


func _ready() -> void:
	z_index = -5
	queue_redraw()


func _draw() -> void:
	VectorStageStyle.draw_stage_background(self, world_size, stage_seed)
	_draw_station_composition()
	var lamp_positions := [
		Vector2(world_size.x * 0.18, 44.0),
		Vector2(world_size.x * 0.53, 56.0),
		Vector2(world_size.x * 0.82, 40.0),
	]
	for lamp_position in lamp_positions:
		VectorStageStyle.draw_faceted_lamp(self, lamp_position)


func _draw_station_composition() -> void:
	match station_number:
		6:
			# Replacement bus: long horizontal route, dark windows as negative space.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(18, 86), Vector2(622, 68), Vector2(612, 246), Vector2(24, 255)]), VectorStageStyle.MID_PLANE, 0.0)
			for x in range(44, 564, 104):
				draw_colored_polygon(PackedVector2Array([Vector2(x, 98), Vector2(x + 76, 93), Vector2(x + 65, 176), Vector2(x + 4, 182)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(418, 272), Vector2(470, 268), Vector2(484, 305), Vector2(428, 307)]), VectorStageStyle.HUMAN_AMBER)
		7:
			# Stairwell: vertical ascent cut into a mostly unoccupied cyan-grey void.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(0, 72), Vector2(272, 40), Vector2(240, 306), Vector2(0, 330)]), VectorStageStyle.DEEP_PLANE, 0.0)
			for y in range(116, 294, 30):
				draw_colored_polygon(PackedVector2Array([Vector2(356, y), Vector2(618, y - 18), Vector2(618, y + 2), Vector2(356, y + 20)]), VectorStageStyle.MID_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(458, 116), Vector2(496, 111), Vector2(504, 286), Vector2(466, 291)]), VectorStageStyle.ANCHOR_CYAN)
		8:
			# Apartment: domestic island pushed left; open window/right field supplies unease.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(26, 96), Vector2(394, 75), Vector2(416, 303), Vector2(22, 316)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(448, 58), Vector2(620, 76), Vector2(594, 255), Vector2(462, 225)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(182, 272), Vector2(332, 263), Vector2(352, 306), Vector2(168, 311)]), VectorStageStyle.HUMAN_AMBER)
		9:
			# Bathroom mirror: a hard reflective blade dominates center; floor remains quiet.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(118, 50), Vector2(362, 42), Vector2(396, 264), Vector2(96, 282)]), VectorStageStyle.LIGHT_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(151, 70), Vector2(332, 60), Vector2(360, 244), Vector2(129, 257)]), VectorStageStyle.DEEP_PLANE)
			draw_colored_polygon(PackedVector2Array([Vector2(336, 102), Vector2(464, 138), Vector2(438, 284), Vector2(349, 260)]), VectorStageStyle.CORRECTION_OXIDE)
		10:
			# Study: diagonal desk and topography board focus toward the technical airlock.
			VectorStageStyle.draw_facet_polygon(self, PackedVector2Array([Vector2(46, 82), Vector2(454, 52), Vector2(486, 286), Vector2(36, 316)]), VectorStageStyle.MID_PLANE, 0.0)
			draw_colored_polygon(PackedVector2Array([Vector2(176, 238), Vector2(454, 197), Vector2(478, 276), Vector2(204, 310)]), VectorStageStyle.HUMAN_AMBER)
			draw_colored_polygon(PackedVector2Array([Vector2(544, 78), Vector2(626, 82), Vector2(626, 304), Vector2(540, 286)]), VectorStageStyle.INK)
			draw_colored_polygon(PackedVector2Array([Vector2(555, 104), Vector2(612, 101), Vector2(607, 267), Vector2(560, 256)]), VectorStageStyle.ANCHOR_CYAN)