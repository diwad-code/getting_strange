class_name LenaVisualRig
extends Node2D

## LenaVisualRig 4.0 — sprite presentation of inż. Lena Wolska.
## Physics stays on PrototypePlayer. _draw() paints only the contact shadow.
## Visual standing height: 87 ± 3 px (D-126). 14 state names unchanged.

signal state_changed(old_state: StringName, new_state: StringName)
signal animation_cue_completed(cue_name: StringName)

enum State {
	IDLE,
	START,
	WALK,
	RUN,
	STOP,
	TURN,
	JUMP_RISE,
	JUMP_FALL,
	LAND,
	INTERACT,
	EXAMINE,
	UNEASE_REACTION,
	SEAM_GESTURE,
	CLIMB
}

const STATE_NAMES := {
	State.IDLE: &"idle",
	State.START: &"start",
	State.WALK: &"walk",
	State.RUN: &"run",
	State.STOP: &"stop",
	State.TURN: &"turn",
	State.JUMP_RISE: &"jump_rise",
	State.JUMP_FALL: &"jump_fall",
	State.LAND: &"land",
	State.INTERACT: &"interact",
	State.EXAMINE: &"examine",
	State.UNEASE_REACTION: &"unease_reaction",
	State.SEAM_GESTURE: &"seam_gesture",
	State.CLIMB: &"climb",
}

const ASSET_DIR := "res://assets/characters/lena/"
const TARGET_VISUAL_HEIGHT := 87.0
const FOOT_Y := 27.0
const FRAME_FPS := {
	&"idle": 5.0,
	&"walk": 9.0,
	&"run": 11.0,
	&"climb": 7.5,
	&"start": 8.0,
	&"stop": 8.0,
	&"turn": 8.0,
	&"jump_rise": 8.0,
	&"jump_fall": 8.0,
	&"land": 8.0,
	&"interact": 8.0,
	&"examine": 7.0,
	&"unease_reaction": 6.0,
	&"seam_gesture": 7.0,
}

@export var current_state: State = State.IDLE
@export var facing: float = 1.0
@export var is_grounded: bool = true
@export var velocity: Vector2 = Vector2.ZERO
@export var scanner_active: bool = false
@export var is_climbing: bool = false

var _state_time: float = 0.0
var _facing_visual: float = 1.0
var _debug_override: StringName = &""
var _cue_time_remaining: float = 0.0
var _active_cue: StringName = &""
var _breath_cycle: float = 0.0
var _walk_cycle: float = 0.0
var _climb_cycle: float = 0.0
var _land_compression: float = 0.0
var _frames: Dictionary = {}
var _body: Sprite2D
var _visual_height: float = TARGET_VISUAL_HEIGHT


func _ready() -> void:
	_facing_visual = facing
	_ensure_body_sprite()
	_load_sprite_frames()
	_apply_current_frame()
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


func _load_sprite_frames() -> void:
	_frames.clear()
	for state_name in STATE_NAMES.values():
		_frames[state_name] = _load_state_textures(String(state_name))
	if (_frames[&"idle"] as Array).is_empty():
		push_warning("LenaVisualRig 4.0: missing idle sprite under %s" % ASSET_DIR)
	# Fallbacks keep 14 named states displayable even if a pose file is absent.
	var idle_frames: Array = _frames[&"idle"]
	for state_name in STATE_NAMES.values():
		if (_frames[state_name] as Array).is_empty() and not idle_frames.is_empty():
			_frames[state_name] = idle_frames


func _load_state_textures(state_name: String) -> Array:
	var textures: Array = []
	var single_path := ASSET_DIR + state_name + ".png"
	if ResourceLoader.exists(single_path):
		var tex := load(single_path) as Texture2D
		if tex:
			textures.append(tex)
	var index := 0
	while index < 12:
		var numbered := ASSET_DIR + state_name + "_%d.png" % index
		if not ResourceLoader.exists(numbered):
			break
		var numbered_tex := load(numbered) as Texture2D
		if numbered_tex:
			textures.append(numbered_tex)
		index += 1
	return textures


func get_visual_height() -> float:
	if _body and _body.texture:
		return _body.texture.get_height() * absf(_body.scale.y)
	return _visual_height


func _process(delta: float) -> void:
	_state_time += delta
	_breath_cycle = fmod(_breath_cycle + delta * 2.2, TAU)

	if not is_equal_approx(_facing_visual, facing):
		_facing_visual = move_toward(_facing_visual, facing, delta * 9.0)

	if _cue_time_remaining > 0.0:
		_cue_time_remaining -= delta
		if _cue_time_remaining <= 0.0:
			var finished_cue := _active_cue
			_active_cue = &""
			animation_cue_completed.emit(finished_cue)

	if _land_compression > 0.0:
		_land_compression = move_toward(_land_compression, 0.0, delta * 6.0)

	if current_state == State.WALK or current_state == State.RUN:
		var speed_mult := 8.5 if current_state == State.WALK else 13.0
		_walk_cycle = fmod(_walk_cycle + delta * speed_mult, TAU)
	elif current_state == State.CLIMB:
		if absf(velocity.y) > 5.0:
			_climb_cycle = fmod(_climb_cycle + delta * 7.5, TAU)

	_apply_current_frame()
	queue_redraw()


func set_state(new_state_name: StringName) -> void:
	if not _debug_override.is_empty():
		return

	var target_state: State = State.IDLE
	for s in STATE_NAMES:
		if STATE_NAMES[s] == new_state_name:
			target_state = s
			break

	if current_state != target_state:
		var old_name: StringName = STATE_NAMES[current_state]
		current_state = target_state
		_state_time = 0.0
		if target_state == State.LAND:
			_land_compression = 1.0
		else:
			_land_compression = 0.0
		state_changed.emit(old_name, new_state_name)
		_apply_current_frame()
		queue_redraw()


func set_facing(direction: float) -> void:
	if not is_zero_approx(direction):
		facing = signf(direction)


func set_mechanical_state(vel: Vector2, grounded: bool, climbing: bool = false) -> void:
	velocity = vel
	is_grounded = grounded
	is_climbing = climbing

	if not _debug_override.is_empty() or _cue_time_remaining > 0.0:
		return

	if is_climbing:
		set_state(&"climb")
	elif not grounded:
		if vel.y < -15.0:
			set_state(&"jump_rise")
		else:
			set_state(&"jump_fall")
	elif absf(vel.x) > 60.0:
		set_state(&"run")
	elif absf(vel.x) > 8.0:
		set_state(&"walk")
	elif _land_compression > 0.05:
		set_state(&"land")
	else:
		set_state(&"idle")

	if not is_climbing and absf(vel.x) > 8.0:
		set_facing(vel.x)


func play_cue(cue_name: StringName, duration: float = 0.6) -> void:
	_active_cue = cue_name
	_cue_time_remaining = duration
	match cue_name:
		&"interact":
			current_state = State.INTERACT
		&"examine":
			current_state = State.EXAMINE
		&"unease_reaction":
			current_state = State.UNEASE_REACTION
		&"seam_gesture":
			current_state = State.SEAM_GESTURE
		&"turn":
			current_state = State.TURN
		&"stop":
			current_state = State.STOP
		&"start":
			current_state = State.START
		&"climb":
			current_state = State.CLIMB
	_state_time = 0.0
	_apply_current_frame()
	queue_redraw()


func debug_override_state(state_name: StringName) -> void:
	_debug_override = state_name
	if state_name.is_empty():
		return
	for s in STATE_NAMES:
		if STATE_NAMES[s] == state_name:
			current_state = s
			_state_time = 0.0
			_apply_current_frame()
			queue_redraw()
			break


func get_active_state_name() -> StringName:
	return STATE_NAMES.get(current_state, &"idle")


func get_current_state_name() -> StringName:
	return STATE_NAMES.get(current_state, &"idle")


func get_state_name() -> StringName:
	return STATE_NAMES.get(current_state, &"idle")


func draws_polygonal_body() -> bool:
	return false


func _apply_current_frame() -> void:
	if _body == null:
		return
	var state_name: StringName = get_active_state_name()
	var frames: Array = _frames.get(state_name, [])
	if frames.is_empty():
		return
	var fps: float = float(FRAME_FPS.get(state_name, 8.0))
	var index := 0
	if frames.size() > 1:
		index = int(floor(_state_time * fps)) % frames.size()
	var texture := frames[index] as Texture2D
	_body.texture = texture
	if texture == null:
		return
	var tex_h := float(texture.get_height())
	var tex_w := float(texture.get_width())
	if tex_h <= 0.0:
		return
	var scale_abs := TARGET_VISUAL_HEIGHT / tex_h
	_visual_height = tex_h * scale_abs
	var face := 1.0 if _facing_visual >= 0.0 else -1.0
	_body.scale = Vector2(scale_abs * face, scale_abs)
	var drawn_w := tex_w * scale_abs
	var squash := _land_compression * 3.0
	_body.position = Vector2(-drawn_w * 0.5, FOOT_Y - TARGET_VISUAL_HEIGHT + squash)
	if scanner_active:
		_body.modulate = Color(0.82, 1.0, 1.0, 1.0)
	else:
		_body.modulate = Color.WHITE


func _draw() -> void:
	var state := current_state
	var shadow_width := 18.0
	if state == State.JUMP_RISE or state == State.JUMP_FALL:
		shadow_width = 10.0
	elif state == State.CLIMB:
		shadow_width = 12.0
	var shadow_poly := PackedVector2Array([
		Vector2(-shadow_width * 0.6, FOOT_Y - 0.5),
		Vector2(shadow_width * 0.6, FOOT_Y - 0.5),
		Vector2(shadow_width * 0.4, FOOT_Y + 2.0),
		Vector2(-shadow_width * 0.4, FOOT_Y + 2.0)
	])
	draw_colored_polygon(shadow_poly, Color(VectorStageStyle.INK, 0.48))
