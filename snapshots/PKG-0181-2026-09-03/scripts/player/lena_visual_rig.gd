class_name LenaVisualRig
extends Node2D

## LenaVisualRig 4.1 — sprite presentation of inż. Lena Wolska.
##
## Physics stays on PrototypePlayer. `_draw()` paints only the contact shadow.
## All frames are authored on one uniform 64x104 canvas with a baked pivot at
## (32, 96): hip column x = 32, ground line y = 96. Nothing is rescaled per
## frame any more, so the silhouette no longer slides sideways or sinks into
## the floor between frames (the 4.0 defect).
##
## Locomotion cycles are advanced by travelled distance, not by wall clock, so
## the feet cannot slide regardless of walk / sprint speed.
##
## The 14 canonical state names are unchanged. `start`, `stop` and `turn` are
## presentation-only overlays: they change the visible frame without changing
## the logical state reported by `get_active_state_name()`.

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
	CLIMB,
	STEP_UP,
	STEP_DOWN,
	CLIMB_BACK,
	LADDER_MOUNT,
	LADDER_DISMOUNT,
	ENTER_DOOR,
	BOARD_VEHICLE
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
	State.STEP_UP: &"step_up",
	State.STEP_DOWN: &"step_down",
	State.CLIMB_BACK: &"climb_back",
	State.LADDER_MOUNT: &"ladder_mount",
	State.LADDER_DISMOUNT: &"ladder_dismount",
	State.ENTER_DOOR: &"enter_door",
	State.BOARD_VEHICLE: &"board_vehicle",
}

const ASSET_DIR := "res://assets/characters/lena/"

## Baked sprite contract — every PNG in ASSET_DIR uses this canvas.
const CANVAS_W := 64.0
const CANVAS_H := 104.0
const PIVOT_X := 32.0
const PIVOT_Y := 96.0

const TARGET_VISUAL_HEIGHT := 87.0
const FOOT_Y := 27.0

## Distance travelled per full 4-frame locomotion loop (one step), in px.
## 87 px ≈ 1.75 m, so 42 px ≈ 0.85 m — a brisk adult stride at 96 px/s.
const WALK_STRIDE_PX := 42.0
const RUN_STRIDE_PX := 48.0
const CLIMB_RUNG_PX := 26.0

const MOVE_EPSILON := 8.0
const START_DURATION := 0.14
const STOP_DURATION := 0.20
const TURN_DURATION := 0.12
const LAND_DURATION := 0.24
const MOUNT_DURATION := 0.18
const DISMOUNT_DURATION := 0.18

const BREATH_PERIOD := 2.6

## States whose frames are held rather than looped.
const ONESHOT_STATES := {
	&"land": true,
	&"start": true,
	&"stop": true,
	&"turn": true,
	&"jump_rise": true,
	&"jump_fall": true,
	&"interact": true,
	&"examine": true,
	&"unease_reaction": true,
	&"seam_gesture": true,
	&"ladder_mount": true,
	&"ladder_dismount": true,
	&"enter_door": true,
	&"board_vehicle": true,
}

## States that get the slow idle breathing offset.
const BREATHING_STATES := {
	&"idle": true,
	&"examine": true,
	&"seam_gesture": true,
	&"unease_reaction": true,
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
var _cycle_phase: float = 0.0
var _climb_phase: float = 0.0
var _land_compression: float = 0.0
var _land_time: float = 0.0
var _start_time: float = 0.0
var _stop_time: float = 0.0
var _turn_time: float = 0.0
var _was_moving: bool = false
var _mount_time: float = 0.0
var _dismount_time: float = 0.0
var _frames: Dictionary = {}
var _body: Sprite2D
var _display_state: StringName = &"idle"
## PKG-0137: ground actually covered, sampled from the rig's own world position.
var _travel_anchor := Vector2.ZERO
var _has_travel_anchor: bool = false


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
		push_warning("LenaVisualRig 4.1: missing idle sprite under %s" % ASSET_DIR)
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
	return TARGET_VISUAL_HEIGHT


func _process(delta: float) -> void:
	_state_time += delta
	_breath_cycle = fmod(_breath_cycle + delta, BREATH_PERIOD)

	_start_time = maxf(_start_time - delta, 0.0)
	_stop_time = maxf(_stop_time - delta, 0.0)
	_turn_time = maxf(_turn_time - delta, 0.0)
	_mount_time = maxf(_mount_time - delta, 0.0)
	_dismount_time = maxf(_dismount_time - delta, 0.0)
	if _land_time > 0.0:
		_land_time = maxf(_land_time - delta, 0.0)

	if not is_equal_approx(_facing_visual, facing) and _turn_time <= 0.0:
		_facing_visual = facing

	if _cue_time_remaining > 0.0:
		_cue_time_remaining -= delta
		if _cue_time_remaining <= 0.0:
			var finished_cue := _active_cue
			_active_cue = &""
			animation_cue_completed.emit(finished_cue)

	if _land_compression > 0.0:
		_land_compression = move_toward(_land_compression, 0.0, delta * 5.0)

	_advance_cycles(delta)
	_apply_current_frame()
	queue_redraw()


## Locomotion phase is driven by travelled distance, so the contact foot stays
## planted at any speed. One loop == one step == STRIDE px of ground covered.
##
## PKG-0137: "travelled" is the ground the body actually covered, not the ground
## `velocity` asked for. On a slope or a curb step `move_and_slide` deflects the
## motion, so `velocity.x * delta` overstates the horizontal distance and the
## contact foot skates forward. Sampling the rig's own world position removes
## that error at its source, on every surface, at every speed.
func _advance_cycles(delta: float) -> void:
	var travelled := _sample_travel(delta)
	match current_state:
		State.WALK:
			_cycle_phase = fmod(_cycle_phase + travelled.x / WALK_STRIDE_PX, 1.0)
		State.RUN:
			_cycle_phase = fmod(_cycle_phase + travelled.x / RUN_STRIDE_PX, 1.0)
		State.CLIMB, State.CLIMB_BACK:
			_climb_phase = fmod(_climb_phase + travelled.y / CLIMB_RUNG_PX, 1.0)
		_:
			pass


## Absolute ground covered on each axis since the previous visual frame.
## A jump larger than one full stride is a teleport (spawn, scene load, ladder
## snap, a capture harness repositioning the actor) rather than locomotion, so
## it falls back to the intended velocity instead of spinning the cycle.
func _sample_travel(delta: float) -> Vector2:
	var intended := Vector2(absf(velocity.x) * delta, absf(velocity.y) * delta)
	if not is_inside_tree():
		return intended
	var here := global_position
	if not _has_travel_anchor:
		_has_travel_anchor = true
		_travel_anchor = here
		return Vector2.ZERO
	var moved := (here - _travel_anchor).abs()
	_travel_anchor = here
	var teleport_limit := maxf(RUN_STRIDE_PX, intended.length() * 4.0)
	if moved.length() > teleport_limit:
		return intended
	return moved


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
			_land_time = LAND_DURATION
		elif target_state == State.WALK or target_state == State.RUN:
			pass  # keep the locomotion phase continuous across walk/run swaps
		else:
			_land_compression = 0.0
		state_changed.emit(old_name, new_state_name)
		_apply_current_frame()
		queue_redraw()


func set_facing(direction: float) -> void:
	if is_zero_approx(direction):
		return
	var new_facing := signf(direction)
	if not is_equal_approx(new_facing, facing):
		facing = new_facing
		# A pivot reads as a turn, not as an instant mirror. Only while actually
		# moving — external orientation calls (spawn, capture) must stay instant.
		if is_grounded and not is_climbing and absf(velocity.x) > MOVE_EPSILON:
			_turn_time = TURN_DURATION
		else:
			_facing_visual = facing
	else:
		facing = new_facing


func set_mechanical_state(vel: Vector2, grounded: bool, climbing: bool = false, sprinting: bool = false, stepping: StringName = &"") -> void:
	velocity = vel
	is_grounded = grounded
	is_climbing = climbing

	var moving_now := absf(vel.x) > MOVE_EPSILON and grounded and not climbing and stepping.is_empty()
	if moving_now and not _was_moving:
		_start_time = START_DURATION
	elif _was_moving and not moving_now and grounded and not climbing:
		_stop_time = STOP_DURATION
	_was_moving = moving_now

	if not _debug_override.is_empty() or _cue_time_remaining > 0.0:
		return

	if stepping == &"step_up" or stepping == &"step_down":
		set_state(stepping)
	elif is_climbing:
		set_state(&"climb")
	elif not grounded:
		if vel.y < -15.0:
			set_state(&"jump_rise")
		else:
			set_state(&"jump_fall")
	elif absf(vel.x) > MOVE_EPSILON:
		if sprinting:
			set_state(&"run")
		else:
			set_state(&"walk")
	elif _land_compression > 0.05:
		set_state(&"land")
	else:
		set_state(&"idle")

	if not is_climbing and stepping.is_empty() and absf(vel.x) > MOVE_EPSILON:
		set_facing(vel.x)


func notify_ladder_mount() -> void:
	_mount_time = MOUNT_DURATION
	_dismount_time = 0.0
	set_state(&"climb")


func notify_ladder_dismount() -> void:
	_dismount_time = DISMOUNT_DURATION
	_mount_time = 0.0


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
		&"enter_door":
			current_state = State.ENTER_DOOR
		&"board_vehicle":
			current_state = State.BOARD_VEHICLE
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


## The frame actually on screen. Differs from the logical state during the
## start / stop / turn presentation overlays.
func get_display_state_name() -> StringName:
	return _display_state


func draws_polygonal_body() -> bool:
	return false


## Presentation state = logical state, plus the short overlays that give the
## walk an anticipation, a brake and a pivot.
func _resolve_display_state() -> StringName:
	var logical: StringName = get_active_state_name()
	if not _debug_override.is_empty() or _cue_time_remaining > 0.0:
		return logical
	if _dismount_time > 0.0:
		return &"ladder_dismount"
	if _mount_time > 0.0 and (is_climbing or logical == &"climb"):
		return &"ladder_mount"
	if logical == &"climb" or is_climbing:
		var back_frames: Array = _frames.get(&"climb_back", [])
		if not back_frames.is_empty():
			return &"climb_back"
		return &"climb"
	if _land_time > 0.0:
		return &"land"
	if _turn_time > 0.0:
		return &"turn"
	if logical == &"idle" and _stop_time > 0.0:
		return &"stop"
	if (logical == &"walk" or logical == &"run") and _start_time > 0.0:
		return &"start"
	return logical


func _frame_index(state_name: StringName, count: int) -> int:
	if count <= 1:
		return 0
	match state_name:
		&"walk", &"run":
			return int(_cycle_phase * count) % count
		&"climb", &"climb_back":
			return int(_climb_phase * count) % count
		&"step_up", &"step_down":
			return clampi(int((_state_time / 0.12) * count), 0, count - 1)
		&"enter_door":
			return clampi(int(_state_time / 0.30), 0, count - 1)
		&"board_vehicle":
			return clampi(int(_state_time / 0.70), 0, count - 1)
		&"land":
			var t: float = 1.0 - (_land_time / LAND_DURATION)
			return clampi(int(t * count), 0, count - 1)
		_:
			if ONESHOT_STATES.has(state_name):
				return count - 1
			return int(_state_time * 8.0) % count


func _breath_offset(state_name: StringName) -> float:
	if not BREATHING_STATES.has(state_name):
		return 0.0
	return -1.0 if sin(_breath_cycle / BREATH_PERIOD * TAU) > 0.35 else 0.0


func _apply_current_frame() -> void:
	if _body == null:
		return
	_display_state = _resolve_display_state()
	var frames: Array = _frames.get(_display_state, [])
	if frames.is_empty():
		frames = _frames.get(&"idle", [])
	if frames.is_empty():
		return

	var texture := frames[_frame_index(_display_state, frames.size())] as Texture2D
	_body.texture = texture
	if texture == null:
		return

	# Horizontal squash through the pivot sells the turn; landing adds a short
	# vertical compression. Neither ever moves the collider.
	var face := 1.0 if _facing_visual >= 0.0 else -1.0
	var turn_squash := 1.0
	if _turn_time > 0.0:
		var t: float = 1.0 - (_turn_time / TURN_DURATION)
		turn_squash = absf(cos(t * PI))
		turn_squash = maxf(turn_squash, 0.18)
		face = 1.0 if cos(t * PI) >= 0.0 else -1.0
		if _facing_visual < 0.0:
			face = -face

	var scale_x := face * turn_squash
	var scale_y := 1.0 - _land_compression * 0.06
	_body.scale = Vector2(scale_x, scale_y)
	_body.position = Vector2(
		roundf(-PIVOT_X * scale_x),
		roundf(FOOT_Y - PIVOT_Y * scale_y + _breath_offset(_display_state))
	)

	if scanner_active:
		_body.modulate = Color(0.82, 1.0, 1.0, 1.0)
	else:
		_body.modulate = Color.WHITE


func _draw() -> void:
	var state := _display_state
	var shadow_width := 18.0
	if state == &"jump_rise" or state == &"jump_fall":
		shadow_width = 10.0
	elif state == &"climb" or state == &"climb_back" or state == &"ladder_mount":
		shadow_width = 12.0
	elif state == &"run":
		shadow_width = 15.0
	elif state == &"land":
		shadow_width = 22.0
	var shadow_poly := PackedVector2Array([
		Vector2(-shadow_width * 0.6, FOOT_Y - 0.5),
		Vector2(shadow_width * 0.6, FOOT_Y - 0.5),
		Vector2(shadow_width * 0.4, FOOT_Y + 2.0),
		Vector2(-shadow_width * 0.4, FOOT_Y + 2.0)
	])
	draw_colored_polygon(shadow_poly, Color(VectorStageStyle.INK, 0.48))
