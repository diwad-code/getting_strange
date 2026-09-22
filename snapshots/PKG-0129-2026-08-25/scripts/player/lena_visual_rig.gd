class_name LenaVisualRig
extends Node2D

## LenaVisualRig — produkcyjny rig postaci inż. Leny Wolskiej (3.0 Feminine Silhouette)
## Zgodny ze specyfikacją docs/LENA_CHARACTER_AND_ANIMATION.md, VISUAL_DESIGN.md oraz PKG-0125.
## Oddziela prezentację od fizyki (PrototypePlayer).
## Renderuje autorską anatomię dorosłej 36-letniej inżynierki o kobiecej sylwetce i wzroście ~66 px.

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

@export var current_state: State = State.IDLE
@export var facing: float = 1.0 # 1.0 = right, -1.0 = left
@export var is_grounded: bool = true
@export var velocity: Vector2 = Vector2.ZERO
@export var scanner_active: bool = false
@export var is_climbing: bool = false

var _state_time: float = 0.0
var _facing_visual: float = 1.0
var _debug_override: StringName = &""
var _cue_time_remaining: float = 0.0
var _active_cue: StringName = &""

# Breathing, cycle and deformation phase
var _breath_cycle: float = 0.0
var _walk_cycle: float = 0.0
var _climb_cycle: float = 0.0
var _land_compression: float = 0.0


func _ready() -> void:
	_facing_visual = facing
	queue_redraw()


func _process(delta: float) -> void:
	_state_time += delta
	_breath_cycle = fmod(_breath_cycle + delta * 2.2, TAU)
	
	# Smooth facing transition
	if not is_equal_approx(_facing_visual, facing):
		_facing_visual = move_toward(_facing_visual, facing, delta * 9.0)
	
	# Handle transient cues
	if _cue_time_remaining > 0.0:
		_cue_time_remaining -= delta
		if _cue_time_remaining <= 0.0:
			var finished_cue := _active_cue
			_active_cue = &""
			animation_cue_completed.emit(finished_cue)
	
	# Handle land compression decay
	if _land_compression > 0.0:
		_land_compression = move_toward(_land_compression, 0.0, delta * 6.0)
	
	# Handle walk/run cycle accumulation
	if current_state == State.WALK or current_state == State.RUN:
		var speed_mult := 8.5 if current_state == State.WALK else 13.0
		_walk_cycle = fmod(_walk_cycle + delta * speed_mult, TAU)
	elif current_state == State.CLIMB:
		if absf(velocity.y) > 5.0:
			_climb_cycle = fmod(_climb_cycle + delta * 7.5, TAU)
	
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
	queue_redraw()


func debug_override_state(state_name: StringName) -> void:
	_debug_override = state_name
	if state_name.is_empty():
		return
	for s in STATE_NAMES:
		if STATE_NAMES[s] == state_name:
			current_state = s
			_state_time = 0.0
			queue_redraw()
			break


func get_active_state_name() -> StringName:
	return STATE_NAMES.get(current_state, &"idle")


func get_current_state_name() -> StringName:
	return STATE_NAMES.get(current_state, &"idle")


func get_state_name() -> StringName:
	return STATE_NAMES.get(current_state, &"idle")


func _draw() -> void:
	var f := _facing_visual
	var state := current_state
	
	# --- 1. Contact shadow on ground (y = +26..+29) ---
	var shadow_width := 18.0
	if state == State.JUMP_RISE or state == State.JUMP_FALL:
		shadow_width = 10.0
	elif state == State.CLIMB:
		shadow_width = 12.0
	var shadow_poly := PackedVector2Array([
		Vector2(-shadow_width * 0.6, 26.5),
		Vector2(shadow_width * 0.6, 26.5),
		Vector2(shadow_width * 0.4, 29.0),
		Vector2(-shadow_width * 0.4, 29.0)
	])
	draw_colored_polygon(shadow_poly, Color(VectorStageStyle.INK, 0.48))
	
	# Kinetic and deformation variables
	var hip_offset := Vector2.ZERO
	var head_offset := Vector2.ZERO
	var leg_left_angle := 0.0
	var leg_right_angle := 0.0
	var arm_reach := 0.0
	var lean := 0.0
	var coat_flutter := 0.0
	var look_back := false
	
	match state:
		State.IDLE:
			var breath := sin(_breath_cycle) * 0.9
			head_offset.y = -breath * 0.7
			hip_offset.y = -breath * 0.3
			# Subtle feminine contrapposto weight shift
			leg_left_angle = -0.8 * f
			leg_right_angle = 1.4 * f
			lean = f * 0.4
		State.START:
			lean = f * 4.5
			hip_offset.y = 1.2
			leg_left_angle = -2.0 * f
			leg_right_angle = 4.0 * f
			coat_flutter = -f * 2.0
		State.WALK:
			var cycle := _walk_cycle
			var stride := sin(cycle)
			leg_left_angle = stride * 7.5
			leg_right_angle = -stride * 7.5
			hip_offset.y = absf(sin(cycle * 2.0)) * -1.8
			lean = f * 2.5
			coat_flutter = -stride * f * 2.8
		State.RUN:
			var cycle := _walk_cycle
			var stride := sin(cycle)
			leg_left_angle = stride * 12.0
			leg_right_angle = -stride * 12.0
			hip_offset.y = absf(sin(cycle * 2.0)) * -3.2
			lean = f * 6.0
			coat_flutter = -f * 6.5 - stride * f * 2.0
		State.STOP:
			lean = -f * 3.8
			hip_offset.y = 1.5
			leg_left_angle = 4.8 * f
			leg_right_angle = -2.5 * f
			coat_flutter = f * 3.2
		State.TURN:
			f = _facing_visual * 0.35
			lean = 0.0
			leg_left_angle = -0.6
			leg_right_angle = 0.6
		State.JUMP_RISE:
			hip_offset.y = -3.5
			head_offset.y = -1.5
			leg_left_angle = 3.5 * f
			leg_right_angle = 4.5 * f
			lean = f * 1.8
			coat_flutter = f * 1.5
		State.JUMP_FALL:
			hip_offset.y = -1.0
			leg_left_angle = -3.5 * f
			leg_right_angle = -3.0 * f
			lean = f * 0.8
			coat_flutter = -f * 3.0
		State.LAND:
			hip_offset.y = _land_compression * 4.8
			head_offset.y = _land_compression * 2.2
			lean = f * 1.2
			leg_left_angle = -2.8 * f
			leg_right_angle = 2.8 * f
			coat_flutter = f * 1.0
		State.INTERACT:
			arm_reach = 1.0
			lean = f * 3.0
			head_offset.y = 0.8
		State.EXAMINE:
			lean = f * 4.2
			head_offset.y = 3.2
			hip_offset.y = 2.0
			arm_reach = 0.85
		State.UNEASE_REACTION:
			look_back = true
			lean = -f * 2.5
			head_offset.y = -0.8
			arm_reach = 0.3
			leg_left_angle = 2.0 * f
			leg_right_angle = -2.0 * f
		State.SEAM_GESTURE:
			arm_reach = 0.45
			lean = f * 0.8
			head_offset.y = 1.2
		State.CLIMB:
			var cycle := _climb_cycle
			var stride := sin(cycle)
			leg_left_angle = stride * 6.0
			leg_right_angle = -stride * 6.0
			hip_offset.y = absf(sin(cycle * 2.0)) * -1.2
			lean = 0.0
			f = 0.4
			arm_reach = 0.5 + stride * 0.5
	
	# --- 2. Legs & Boots (Pelvis y = +4, Knees y = +15, Boots y = +26) ---
	var boot_left := Vector2(-3.8 * f + leg_left_angle, 26.0 + hip_offset.y)
	var boot_right := Vector2(4.2 * f + leg_right_angle, 26.0 + hip_offset.y)
	
	# Left Leg (deep plane)
	var leg_l := PackedVector2Array([
		Vector2(-4.2 * f + lean * 0.3, 4.0 + hip_offset.y),
		Vector2(-1.2 * f + lean * 0.3, 4.0 + hip_offset.y),
		Vector2(boot_left.x - 1.2 * f, boot_left.y - 3.0),
		Vector2(boot_left.x - 3.8 * f, boot_left.y - 3.0),
	])
	VectorStageStyle.draw_facet_polygon(self, leg_l, VectorStageStyle.DEEP_PLANE, 0.0)
	
	# Right Leg (front plane)
	var leg_r := PackedVector2Array([
		Vector2(-0.5 * f + lean * 0.3, 4.0 + hip_offset.y),
		Vector2(4.5 * f + lean * 0.3, 4.0 + hip_offset.y),
		Vector2(boot_right.x + 3.8 * f, boot_right.y - 3.0),
		Vector2(boot_right.x + 0.8 * f, boot_right.y - 3.0),
	])
	VectorStageStyle.draw_facet_polygon(self, leg_r, VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.2), 0.0)
	
	# Fitted Urban Boots (defined heel, ankle & sole)
	var boot_l_poly := PackedVector2Array([
		Vector2(boot_left.x - 3.2 * f, boot_left.y - 3.5),
		Vector2(boot_left.x + 2.8 * f, boot_left.y - 3.5),
		Vector2(boot_left.x + 4.8 * f, boot_left.y + 0.8),
		Vector2(boot_left.x - 3.8 * f, boot_left.y + 0.8),
	])
	VectorStageStyle.draw_facet_polygon(self, boot_l_poly, VectorStageStyle.INK, 0.0)
	
	var boot_r_poly := PackedVector2Array([
		Vector2(boot_right.x - 3.2 * f, boot_right.y - 3.5),
		Vector2(boot_right.x + 2.8 * f, boot_right.y - 3.5),
		Vector2(boot_right.x + 4.8 * f, boot_right.y + 0.8),
		Vector2(boot_right.x - 3.8 * f, boot_right.y + 0.8),
	])
	VectorStageStyle.draw_facet_polygon(self, boot_r_poly, VectorStageStyle.INK, 0.0)
	
	# --- 3. Long Technical Trench Coat / Laboratory Prochowiec (y = -22..+12) ---
	var torso_y_top := -22.0 + hip_offset.y
	var waist_y := -8.0 + hip_offset.y
	var coat_hem_y := 12.0 + hip_offset.y
	
	# Coat Main Silhouette (tapered waist, flared hem)
	var coat_back := PackedVector2Array([
		Vector2(-5.8 * f + lean, torso_y_top),
		Vector2(4.8 * f + lean, torso_y_top),
		Vector2(3.6 * f + lean * 0.7, waist_y),
		Vector2(6.5 * f + lean * 0.4 + coat_flutter, coat_hem_y),
		Vector2(-7.2 * f + lean * 0.4 + coat_flutter * 0.8, coat_hem_y),
		Vector2(-4.2 * f + lean * 0.7, waist_y),
	])
	VectorStageStyle.draw_facet_polygon(self, coat_back, VectorStageStyle.MID_PLANE, 0.0)
	
	# Coat Top Light / Lapel Facet (illuminated side)
	var coat_lapel := PackedVector2Array([
		Vector2(-5.8 * f + lean, torso_y_top),
		Vector2(0.5 * f + lean, torso_y_top),
		Vector2(1.2 * f + lean * 0.7, waist_y),
		Vector2(1.5 * f + lean * 0.4 + coat_flutter * 0.4, coat_hem_y),
		Vector2(-7.2 * f + lean * 0.4 + coat_flutter * 0.8, coat_hem_y),
		Vector2(-4.2 * f + lean * 0.7, waist_y),
	])
	VectorStageStyle.draw_facet_polygon(self, coat_lapel, VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, -0.12), 0.0)
	
	# Left Sleeve Seam (Identity marker of Lena)
	var seam_top_x := -4.6 * f + lean
	var seam_bot_x := -3.2 * f + lean * 0.7
	draw_line(
		Vector2(seam_top_x, torso_y_top + 3.0),
		Vector2(seam_bot_x, waist_y + 2.0),
		VectorStageStyle.LIGHT_PLANE,
		1.6
	)
	
	# Asymmetrical Research Tool Bag & Cross-Strap
	var bag_poly := PackedVector2Array([
		Vector2(-6.8 * f + lean * 0.6, waist_y - 3.0),
		Vector2(-2.8 * f + lean * 0.6, waist_y - 5.0),
		Vector2(-2.2 * f + lean * 0.6, waist_y + 8.0),
		Vector2(-7.5 * f + lean * 0.6, waist_y + 9.5),
	])
	VectorStageStyle.draw_facet_polygon(self, bag_poly, VectorStageStyle.HUMAN_AMBER, 0.0)
	# Leather cross-strap across chest
	draw_line(
		Vector2(3.8 * f + lean, torso_y_top + 2.0),
		Vector2(-5.0 * f + lean * 0.6, waist_y + 1.0),
		VectorStageStyle.INK,
		1.8
	)
	
	# --- 4. Slender Neck & Head with Asymmetrical Hair (y = -36..-22) ---
	var head_center_y := -29.5 + hip_offset.y + head_offset.y
	var head_lean := lean * 1.2
	var head_facing := -f if look_back else f
	
	# Slender Neck
	var neck_top_x := head_lean
	var neck_bot_x := lean
	var neck_poly := PackedVector2Array([
		Vector2(neck_top_x - 1.8, head_center_y + 4.5),
		Vector2(neck_top_x + 1.8, head_center_y + 4.5),
		Vector2(neck_bot_x + 2.2, torso_y_top + 1.0),
		Vector2(neck_bot_x - 2.2, torso_y_top + 1.0),
	])
	VectorStageStyle.draw_facet_polygon(self, neck_poly, VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.1), 0.0)
	
	# Warm Amber Feminine Face Base (chin, jawline & brow)
	var face_poly := PackedVector2Array([
		Vector2(-4.2 * head_facing + head_lean, head_center_y - 7.0),
		Vector2(3.8 * head_facing + head_lean, head_center_y - 6.0),
		Vector2(4.5 * head_facing + head_lean, head_center_y + 0.5),
		Vector2(0.8 * head_facing + head_lean, head_center_y + 5.2),
		Vector2(-3.8 * head_facing + head_lean, head_center_y + 2.0),
	])
	VectorStageStyle.draw_facet_polygon(self, face_poly, VectorStageStyle.HUMAN_AMBER, 0.0)
	
	# Chic Asymmetrical Dark Wedge Hair (Ink)
	var hair_poly := PackedVector2Array([
		Vector2(-5.2 * head_facing + head_lean, head_center_y - 8.5),
		Vector2(4.5 * head_facing + head_lean, head_center_y - 7.0),
		Vector2(2.0 * head_facing + head_lean, head_center_y - 1.5),
		Vector2(-4.8 * head_facing + head_lean, head_center_y + 1.8),
	])
	VectorStageStyle.draw_facet_polygon(self, hair_poly, VectorStageStyle.INK, 0.0)
	
	# Gaze / Visor / Eye Accent (cyan reading line or dark gaze)
	var eye_col := VectorStageStyle.ANCHOR_CYAN if scanner_active else VectorStageStyle.INK
	var eye_x := head_facing * 2.6 + head_lean
	draw_line(
		Vector2(eye_x, head_center_y - 1.8),
		Vector2(eye_x + head_facing * 2.2, head_center_y - 1.2),
		eye_col,
		1.6
	)
	
	# --- 5. Arms, Delicate Hands & Precision Sensor Device ---
	var hand_reach_x := (7.0 + arm_reach * 7.5) * f + lean
	var hand_y := (waist_y - 2.0) - arm_reach * 6.0
	
	if state == State.SEAM_GESTURE:
		hand_reach_x = seam_top_x + 1.2 * f
		hand_y = torso_y_top + 7.0
	elif state == State.CLIMB:
		hand_reach_x = 3.0 * f
		hand_y = torso_y_top - 6.0 + arm_reach * 10.0
	
	# Right Arm (Sleeve + Forearm)
	draw_line(
		Vector2(2.8 * f + lean, torso_y_top + 3.0),
		Vector2(hand_reach_x, hand_y),
		VectorStageStyle.MID_PLANE,
		2.8
	)
	
	# Slender Hand (Warm Amber)
	draw_circle(Vector2(hand_reach_x, hand_y), 2.2, VectorStageStyle.HUMAN_AMBER)
	
	# Active measurement probe / sensor beam
	if scanner_active or state == State.EXAMINE or state == State.INTERACT:
		draw_rect(Rect2(hand_reach_x + f * 1.0, hand_y - 2.5, 3.5 * f, 5.0), VectorStageStyle.ANCHOR_CYAN)
		draw_line(
			Vector2(hand_reach_x + f * 4.5, hand_y),
			Vector2(hand_reach_x + f * 16.0, hand_y),
			Color(VectorStageStyle.ANCHOR_CYAN, 0.65),
			1.2
		)
