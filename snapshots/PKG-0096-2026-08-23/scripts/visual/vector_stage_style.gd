class_name VectorStageStyle
extends RefCounted

## Shared visual grammar for Getting Strange's authored Vector-Stage look.
## It deliberately uses its own institutional palette, material language and
## narrative motifs. It does not recreate characters, scenes or iconography of
## any external work.

const BACKDROP := Color("121a24")
const DEEP_PLANE := Color("1d2b37")
const MID_PLANE := Color("344958")
const LIGHT_PLANE := Color("82949a")
const HUMAN_AMBER := Color("d29a63")
const ANCHOR_CYAN := Color("6cc4bf")
const CORRECTION_OXIDE := Color("ba625b")
const INK := Color("0b1016")

const MAX_PALETTE_COLORS := 7
const MAX_CHARACTER_POLYGONS := 9


static func shade(color: Color, amount: float) -> Color:
	return color.darkened(clampf(amount, 0.0, 0.92))


static func light(color: Color, amount: float) -> Color:
	return color.lightened(clampf(amount, 0.0, 0.92))


static func draw_facet_polygon(canvas: CanvasItem, points: PackedVector2Array, color: Color, outline_width: float = 1.0) -> void:
	canvas.draw_colored_polygon(points, color)
	if outline_width > 0.0:
		canvas.draw_polyline(points, shade(color, 0.55), outline_width, true)


static func draw_stage_background(canvas: CanvasItem, size: Vector2, stage_seed: int = 0, draw_base: bool = true) -> void:
	if draw_base:
		canvas.draw_rect(Rect2(Vector2.ZERO, size), BACKDROP)
	var horizon := 116.0 + float(stage_seed % 3) * 12.0
	var rear_plane := PackedVector2Array([
		Vector2(0.0, horizon),
		Vector2(size.x * 0.22, horizon - 54.0),
		Vector2(size.x * 0.54, horizon - 19.0),
		Vector2(size.x * 0.83, horizon - 66.0),
		Vector2(size.x, horizon - 28.0),
		Vector2(size.x, size.y),
		Vector2(0.0, size.y),
	])
	draw_facet_polygon(canvas, rear_plane, DEEP_PLANE, 0.0)
	var floor_plane := PackedVector2Array([
		Vector2(0.0, size.y * 0.82),
		Vector2(size.x, size.y * 0.82),
		Vector2(size.x, size.y),
		Vector2(0.0, size.y),
	])
	draw_facet_polygon(canvas, floor_plane, shade(MID_PLANE, 0.32), 0.0)


static func draw_faceted_lamp(canvas: CanvasItem, position: Vector2, width: float = 24.0) -> void:
	var halo := PackedVector2Array([
		position + Vector2(-width * 2.1, 5.0),
		position + Vector2(0.0, -width * 0.9),
		position + Vector2(width * 2.1, 5.0),
		position + Vector2(width * 1.25, 54.0),
		position + Vector2(-width * 1.25, 54.0),
	])
	draw_facet_polygon(canvas, halo, Color(LIGHT_PLANE, 0.11), 0.0)
	var fixture := PackedVector2Array([
		position + Vector2(-width, 0.0),
		position + Vector2(width, 0.0),
		position + Vector2(width * 0.62, 8.0),
		position + Vector2(-width * 0.62, 8.0),
	])
	draw_facet_polygon(canvas, fixture, LIGHT_PLANE, 1.0)