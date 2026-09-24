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
const SEAM_RED := Color("ba625b")
const INK := Color("0b1016")

# PKG-0218 (D-231): canon VISUAL_DESIGN §4 demands 8-16 functional world
# colours (max two accents); 7 contradicted the lower bound, so the pin moves
# to the tightest canon-compliant value. Lint: authored station _draw() must
# stay within this budget (bases, not shade()/light() derivations).
const MAX_PALETTE_COLORS := 8
const MAX_CHARACTER_POLYGONS := 9

## PKG-0137 stage apron (D-136).
## The dialogue framing offset (D-133) eases the camera below the play plane so
## the bottom-anchored panel stops covering Lena. The authored stage stops at
## world_size.y, so without an apron the lowered frame showed the engine clear
## colour under the floor. The apron is the painted budget the camera is allowed
## to spend: it is scenery only, never traversable, and no collider lives in it.
const STAGE_APRON := 40.0


static func shade(color: Color, amount: float) -> Color:
	return color.darkened(clampf(amount, 0.0, 0.92))


static func light(color: Color, amount: float) -> Color:
	return color.lightened(clampf(amount, 0.0, 0.92))


static func draw_facet_polygon(canvas: CanvasItem, points: PackedVector2Array, color: Color, outline_width: float = 1.0) -> void:
	canvas.draw_colored_polygon(points, color)
	if outline_width > 0.0:
		canvas.draw_polyline(points, shade(color, 0.55), outline_width, true)


## Paints the band between the play plane and the bottom of the framing budget.
## Drawn as a continuation of the floor plane so the lowered dialogue frame reads
## as more floor, never as a hole. Called before the background so later planes
## keep painting over it exactly as they did before.
static func draw_stage_apron(canvas: CanvasItem, size: Vector2, apron: float = STAGE_APRON) -> void:
	if apron <= 0.0:
		return
	canvas.draw_rect(Rect2(Vector2(0.0, size.y), Vector2(size.x, apron)), BACKDROP)
	draw_facet_polygon(canvas, PackedVector2Array([
		Vector2(0.0, size.y),
		Vector2(size.x, size.y),
		Vector2(size.x, size.y + apron),
		Vector2(0.0, size.y + apron),
	]), shade(MID_PLANE, 0.32), 0.0)
	# A single contact line keeps the apron reading as floor receding into the
	# proscenium rather than as a flat colour band.
	canvas.draw_line(
		Vector2(0.0, size.y + apron * 0.55),
		Vector2(size.x, size.y + apron * 0.55),
		shade(MID_PLANE, 0.52),
		1.0
	)


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

## Draws the traversable route from the colliders that actually carry it.
## VISUAL_DESIGN.md §7.4 and the obstacle canon both require the walkable way to
## hold the highest contrast in the frame, so the play plane is derived from the
## real geometry instead of being painted separately and drifting out of sync.
## Room shell bodies (ceiling, side walls) and self-drawing anchorables are
## skipped: this pass is about the route, not the box around it.
static func draw_play_plane(canvas: CanvasItem, geometry_root: Node) -> void:
	if geometry_root == null:
		return
	var bounds_list: Array[Rect2] = []
	var ground_y := 0.0
	for body in geometry_root.get_children():
		if not (body is StaticBody2D):
			continue
		var body_name := String(body.name)
		if body_name.begins_with("Wall") or body_name == "Ceiling":
			continue
		var collision := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if collision == null or not (collision.shape is RectangleShape2D):
			continue
		var rectangle := collision.shape as RectangleShape2D
		var origin: Vector2 = body.position + collision.position - rectangle.size * 0.5
		var bounds := Rect2(origin, rectangle.size)
		bounds_list.append(bounds)
		ground_y = maxf(ground_y, bounds.end.y)

	# Nothing hangs in the air (obstacle canon R7): every raised tread is carried
	# down to the ground by the mass it is actually built into.
	for bounds in bounds_list:
		if bounds.end.y >= ground_y - 1.0:
			continue
		canvas.draw_rect(
			Rect2(
				Vector2(bounds.position.x + 3.0, bounds.end.y),
				Vector2(maxf(1.0, bounds.size.x - 6.0), ground_y - bounds.end.y)
			),
			shade(DEEP_PLANE, 0.34)
		)

	for bounds in bounds_list:
		canvas.draw_rect(bounds, light(MID_PLANE, 0.06))
		# The tread edge is the single brightest line Lena can read at a glance.
		canvas.draw_line(bounds.position, bounds.position + Vector2(bounds.size.x, 0.0), LIGHT_PLANE, 1.5)
		canvas.draw_line(
			bounds.position + Vector2(0.0, bounds.size.y),
			bounds.end,
			shade(MID_PLANE, 0.50),
			1.0
		)
