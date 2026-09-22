class_name CharacterVisualRig
extends Node2D

## CharacterVisualRig — campaign NPC presentation on the Lena 4.1 canvas.
##
## Physics stays off this node. `_draw()` paints only the contact shadow.
## Every frame is authored on one uniform 64x104 canvas with a baked pivot at
## (32, 96). NPCs do not locomote: seven presentation states, idle fallback.

signal state_changed(old_state: StringName, new_state: StringName)

const CANVAS_W := 64.0
const CANVAS_H := 104.0
const PIVOT_X := 32.0
const PIVOT_Y := 96.0
const FOOT_Y := 27.0
const BREATH_PERIOD := 2.6
const ASSET_ROOT := "res://assets/characters/"

const STATE_FILES := {
	&"idle": ["idle.png"],
	&"talk": ["talk_0.png", "talk_1.png"],
	&"listen": ["listen.png"],
	&"gesture": ["gesture.png"],
	&"turn_away": ["turn_away.png"],
	&"seated": ["seated.png"],
	&"work": ["work.png"],
}

const STANDING_HEIGHTS := {
	&"marta": 86.0,
	&"jakub": 89.0,
	&"wierzbicka": 88.0,
	&"vendor": 86.0,
	&"neighbour": 86.0,
}

const SEATED_HEIGHT := 58.0
const TALK_FPS := 6.0

@export var character_id: StringName = &"marta"
@export var initial_state: StringName = &"idle"
@export var facing: float = 1.0

var _state: StringName = &"idle"
var _frames: Dictionary = {}
var _body: Sprite2D
var _state_time: float = 0.0
var _breath_cycle: float = 0.0
var _facing_visual: float = 1.0


func _ready() -> void:
	_facing_visual = 1.0 if facing >= 0.0 else -1.0
	_ensure_body_sprite()
	_load_sprite_frames()
	set_state(initial_state)
	queue_redraw()


func _ensure_body_sprite() -> void:
	_body = get_node_or_null("BodySprite") as Sprite2D
	if _body == null:
		_body = Sprite2D.new()
		_body.name = "BodySprite"
		add_child(_body)
	_body.centered = false
	_body.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_body.texture_repeat = CanvasItem.TEXTURE_REPEAT_DISABLED


func _asset_dir() -> String:
	return ASSET_ROOT + String(character_id) + "/"


func _load_sprite_frames() -> void:
	_frames.clear()
	var idle_frames: Array = _load_state_textures(&"idle")
	_frames[&"idle"] = idle_frames
	for state_name in STATE_FILES.keys():
		if state_name == &"idle":
			continue
		var loaded := _load_state_textures(state_name)
		if loaded.is_empty():
			_frames[state_name] = idle_frames
		else:
			_frames[state_name] = loaded
	if idle_frames.is_empty():
		push_warning("CharacterVisualRig: missing idle sprite under %s" % _asset_dir())


func _load_state_textures(state_name: StringName) -> Array:
	var textures: Array = []
	var names: Array = STATE_FILES.get(state_name, [])
	for file_name in names:
		var path := _asset_dir() + String(file_name)
		if not ResourceLoader.exists(path):
			continue
		var tex := load(path) as Texture2D
		if tex:
			textures.append(tex)
	return textures


func set_state(new_state_name: StringName) -> void:
	var resolved := new_state_name
	if not STATE_FILES.has(resolved):
		resolved = &"idle"
	if _frames.get(resolved, []).is_empty():
		resolved = &"idle"
	var old_name := _state
	_state = resolved
	_state_time = 0.0
	if old_name != _state:
		state_changed.emit(old_name, _state)
	_apply_current_frame()
	queue_redraw()


func get_active_state_name() -> StringName:
	return _state


func get_current_state_name() -> StringName:
	return _state


func get_visual_height() -> float:
	if _state == &"seated":
		return SEATED_HEIGHT
	return float(STANDING_HEIGHTS.get(character_id, 87.0))


func draws_polygonal_body() -> bool:
	return false


func set_facing(direction: float) -> void:
	if is_zero_approx(direction):
		return
	facing = signf(direction)
	_facing_visual = facing


func _process(delta: float) -> void:
	_state_time += delta
	_breath_cycle = fmod(_breath_cycle + delta, BREATH_PERIOD)
	_apply_current_frame()
	queue_redraw()


func _frame_index(count: int) -> int:
	if count <= 1:
		return 0
	if _state == &"talk":
		return int(_state_time * TALK_FPS) % count
	return 0


func _breath_offset() -> float:
	if _state != &"idle" and _state != &"listen":
		return 0.0
	return -1.0 if sin(_breath_cycle / BREATH_PERIOD * TAU) > 0.35 else 0.0


func _apply_current_frame() -> void:
	if _body == null:
		return
	var frames: Array = _frames.get(_state, [])
	if frames.is_empty():
		frames = _frames.get(&"idle", [])
	if frames.is_empty():
		return
	var texture := frames[_frame_index(frames.size())] as Texture2D
	_body.texture = texture
	if texture == null:
		return
	var face := 1.0 if _facing_visual >= 0.0 else -1.0
	_body.scale = Vector2(face, 1.0)
	_body.position = Vector2(
		roundf(-PIVOT_X * face),
		roundf(FOOT_Y - PIVOT_Y + _breath_offset())
	)
	_body.modulate = Color.WHITE


func _draw() -> void:
	var shadow_width := 16.0 if _state == &"seated" else 18.0
	var shadow_poly := PackedVector2Array([
		Vector2(-shadow_width * 0.6, FOOT_Y - 0.5),
		Vector2(shadow_width * 0.6, FOOT_Y - 0.5),
		Vector2(shadow_width * 0.4, FOOT_Y + 2.0),
		Vector2(-shadow_width * 0.4, FOOT_Y + 2.0)
	])
	draw_colored_polygon(shadow_poly, Color(VectorStageStyle.INK, 0.48))
