class_name CRTPortrait
extends Control

## CRT witness bust. Raster portraits in the same Pixel-Stage language as Lena 4.0.
## No procedural geometric face.

const PORTRAIT_DIR := "res://assets/characters/portraits/"

var speaker: StringName = &"Lena"
var accent := VectorStageStyle.HUMAN_AMBER
var _texture: Texture2D


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_texture = _load_for(speaker)
	queue_redraw()


func set_witness(next_speaker: StringName, next_accent: Color) -> void:
	speaker = next_speaker
	accent = next_accent
	_texture = _load_for(speaker)
	queue_redraw()


func _normalize_speaker(raw: StringName) -> String:
	var key := String(raw).strip_edges().to_lower()
	key = key.replace("dr ", "").replace("dr.", "")
	if key.begins_with("lena"):
		return "lena"
	if key.begins_with("marta"):
		return "marta"
	if key.begins_with("jakub"):
		return "jakub"
	if key.begins_with("wierzb"):
		return "wierzbicka"
	if key.begins_with("szymon"):
		return "szymon"
	return ""


func _load_for(who: StringName) -> Texture2D:
	var file := _normalize_speaker(who)
	if file.is_empty():
		return null
	var path := PORTRAIT_DIR + file + ".png"
	if not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D


func _draw() -> void:
	var box := Rect2(Vector2.ZERO, size)
	draw_rect(box, VectorStageStyle.DEEP_PLANE)
	if _texture:
		draw_texture_rect(_texture, box.grow(-1.0), false)
	else:
		draw_rect(box.grow(-3.0), VectorStageStyle.shade(accent, 0.22))
	draw_rect(box, accent, false, 1.0)
