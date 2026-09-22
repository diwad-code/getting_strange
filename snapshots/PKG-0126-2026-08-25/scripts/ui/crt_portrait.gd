class_name CRTPortrait
extends Control

## Compact, procedural Vector-Stage witness portrait for the dialogue surface.
## It uses authored facets rather than an initial glyph or external raster art.

var speaker: StringName = &"Lena"
var accent := VectorStageStyle.HUMAN_AMBER


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	queue_redraw()


func set_witness(next_speaker: StringName, next_accent: Color) -> void:
	speaker = next_speaker
	accent = next_accent
	queue_redraw()


func _draw() -> void:
	var mirrored := String(speaker).unicode_at(0) % 2 == 0 if not String(speaker).is_empty() else false
	var lean := -2.0 if mirrored else 2.0
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 4.0), Vector2(51.0, 0.0), Vector2(56.0, 58.0), Vector2(5.0, 62.0),
	]), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.12))
	draw_colored_polygon(PackedVector2Array([
		Vector2(2.0, 5.0), Vector2(48.0, 3.0), Vector2(42.0, 16.0), Vector2(5.0, 18.0),
	]), VectorStageStyle.shade(accent, 0.58))
	draw_colored_polygon(PackedVector2Array([
		Vector2(8.0, 61.0), Vector2(13.0, 45.0), Vector2(27.0 + lean, 40.0),
		Vector2(46.0, 47.0), Vector2(52.0, 61.0),
	]), VectorStageStyle.shade(accent, 0.36))
	draw_colored_polygon(PackedVector2Array([
		Vector2(20.0 + lean, 39.0), Vector2(34.0 + lean, 39.0),
		Vector2(35.0 + lean, 48.0), Vector2(19.0 + lean, 48.0),
	]), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.28))
	draw_colored_polygon(PackedVector2Array([
		Vector2(16.0 + lean, 15.0), Vector2(34.0 + lean, 12.0),
		Vector2(42.0 + lean, 24.0), Vector2(36.0 + lean, 40.0),
		Vector2(20.0 + lean, 41.0), Vector2(12.0 + lean, 28.0),
	]), VectorStageStyle.HUMAN_AMBER)
	draw_colored_polygon(PackedVector2Array([
		Vector2(14.0 + lean, 17.0), Vector2(33.0 + lean, 10.0),
		Vector2(40.0 + lean, 19.0), Vector2(22.0 + lean, 23.0),
	]), VectorStageStyle.INK)
	draw_colored_polygon(PackedVector2Array([
		Vector2(18.0 + lean, 25.0), Vector2(27.0 + lean, 22.0),
		Vector2(25.0 + lean, 35.0), Vector2(17.0 + lean, 34.0),
	]), VectorStageStyle.light(VectorStageStyle.HUMAN_AMBER, 0.12))
	draw_line(Vector2(28.0 + lean, 27.0), Vector2(35.0 + lean, 26.0), accent, 1.0)
	draw_line(Vector2(29.0 + lean, 35.0), Vector2(35.0 + lean, 34.0), VectorStageStyle.INK, 1.0)
