class_name PrototypePlayer
extends CharacterBody2D

@export var movement_profile: MovementProfile = MovementProfileCatalog.PROFILE_A

const BODY_COLOR := Color("d9d2bd")
const VISOR_COLOR := Color("63d8d2")
const SHADOW_COLOR := Color("171b24")

var _coyote_remaining := 0.0
var _jump_buffer_remaining := 0.0
var _facing := 1.0
var _was_on_floor := false


func _ready() -> void:
	if movement_profile == null:
		push_error("PrototypePlayer requires a movement profile")
		set_physics_process(false)
		return
	floor_snap_length = 2.0
	floor_stop_on_slope = true
	queue_redraw()


func _physics_process(delta: float) -> void:
	if movement_profile == null:
		return

	var grounded := is_on_floor()
	if grounded:
		_coyote_remaining = movement_profile.coyote_time
		if velocity.y > 0.0:
			velocity.y = 0.0
	else:
		_coyote_remaining = maxf(0.0, _coyote_remaining - delta)

	if Input.is_action_just_pressed(&"jump"):
		_jump_buffer_remaining = movement_profile.jump_buffer_time
	else:
		_jump_buffer_remaining = maxf(0.0, _jump_buffer_remaining - delta)

	if _jump_buffer_remaining > 0.0 and _coyote_remaining > 0.0:
		velocity.y = movement_profile.jump_velocity
		_jump_buffer_remaining = 0.0
		_coyote_remaining = 0.0
		grounded = false

	if Input.is_action_just_released(&"jump") and velocity.y < 0.0:
		velocity.y *= movement_profile.jump_release_multiplier

	if not grounded:
		var gravity_scale := movement_profile.fall_gravity_multiplier if velocity.y > 0.0 else 1.0
		velocity.y = minf(
			velocity.y + movement_profile.gravity * gravity_scale * delta,
			movement_profile.max_fall_speed
		)

	var direction := Input.get_axis(&"move_left", &"move_right")
	if not is_zero_approx(direction):
		_facing = signf(direction)
		var acceleration := (
			movement_profile.ground_acceleration if grounded else movement_profile.air_acceleration
		)
		velocity.x = move_toward(
			velocity.x,
			direction * movement_profile.move_speed,
			acceleration * delta
		)
	else:
		var deceleration := (
			movement_profile.ground_deceleration if grounded else movement_profile.air_deceleration
		)
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

	move_and_slide()

	if is_on_ceiling() and velocity.y < 0.0:
		velocity.y = 0.0

	if _was_on_floor != is_on_floor():
		_was_on_floor = is_on_floor()
		queue_redraw()
	elif not is_zero_approx(direction):
		queue_redraw()


func reset_to(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	_coyote_remaining = 0.0
	_jump_buffer_remaining = 0.0
	_was_on_floor = false
	queue_redraw()


func apply_movement_profile(profile: MovementProfile) -> void:
	if profile == null:
		push_error("PrototypePlayer cannot apply an empty movement profile")
		return
	movement_profile = profile
	set_physics_process(true)
	queue_redraw()


func debug_state() -> Dictionary:
	return {
		"position": global_position,
		"velocity": velocity,
		"grounded": is_on_floor(),
		"coyote_remaining": _coyote_remaining,
		"jump_buffer_remaining": _jump_buffer_remaining,
	}


func _draw() -> void:
	if movement_profile == null:
		return
	# The graybox silhouette already tests readable posture at the target resolution.
	var lean := clampf(velocity.x / movement_profile.move_speed, -1.0, 1.0) * 1.5
	var body := PackedVector2Array([
		Vector2(-4.0 + lean, -8.0),
		Vector2(4.0 + lean, -8.0),
		Vector2(5.0, 6.0),
		Vector2(2.0, 11.0),
		Vector2(-4.0, 11.0),
	])
	draw_polygon(body, PackedColorArray([BODY_COLOR]))
	draw_circle(Vector2(lean, -12.0), 4.5, BODY_COLOR)
	draw_rect(Rect2(Vector2(lean + _facing * 1.0 - 1.5, -13.5), Vector2(3.0, 1.5)), VISOR_COLOR)
	draw_line(Vector2(-2.0, 10.0), Vector2(-3.0 - _facing, 14.0), SHADOW_COLOR, 2.0)
	draw_line(Vector2(2.0, 10.0), Vector2(4.0 + _facing, 14.0), SHADOW_COLOR, 2.0)
