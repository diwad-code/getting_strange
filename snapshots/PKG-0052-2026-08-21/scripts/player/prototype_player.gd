class_name PrototypePlayer
extends CharacterBody2D

enum SurfaceType { CONCRETE_LINOLEUM, METAL }

@export var movement_profile: MovementProfile = MovementProfileCatalog.PROFILE_A

const BODY_COLOR := Color("d9d2bd")
const VISOR_COLOR := Color("63d8d2")
const SHADOW_COLOR := Color("171b24")
const STEP_STRIDE: float = 24.0

var _coyote_remaining := 0.0
var _jump_buffer_remaining := 0.0
var _facing := 1.0
var _was_on_floor := false
var _previous_vertical_velocity := 0.0

var _step_distance_accumulator := 0.0
var _step_foot_toggle := false

var _footstep_linoleum_sfx: AudioStreamWAV
var _footstep_metal_sfx: AudioStreamWAV
var _land_linoleum_sfx: AudioStreamWAV
var _land_metal_sfx: AudioStreamWAV

var _step_audio_player: AudioStreamPlayer2D
var _land_audio_player: AudioStreamPlayer2D


func _ready() -> void:
	if movement_profile == null:
		push_error("PrototypePlayer requires a movement profile")
		set_physics_process(false)
		return
	floor_snap_length = 2.0
	floor_stop_on_slope = true

	_setup_audio()
	queue_redraw()


func _setup_audio() -> void:
	_footstep_linoleum_sfx = ProceduralAudio.create_footstep_linoleum_sound()
	_footstep_metal_sfx = ProceduralAudio.create_footstep_metal_sound()
	_land_linoleum_sfx = ProceduralAudio.create_land_sound(false)
	_land_metal_sfx = ProceduralAudio.create_land_sound(true)

	_step_audio_player = AudioStreamPlayer2D.new()
	_step_audio_player.name = "StepAudioPlayer"
	_step_audio_player.max_distance = 600.0
	_step_audio_player.bus = &"Master"
	add_child(_step_audio_player)

	_land_audio_player = AudioStreamPlayer2D.new()
	_land_audio_player.name = "LandAudioPlayer"
	_land_audio_player.max_distance = 600.0
	_land_audio_player.bus = &"Master"
	add_child(_land_audio_player)


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

	var fall_speed_before_move := velocity.y
	move_and_slide()

	if is_on_ceiling() and velocity.y < 0.0:
		velocity.y = 0.0

	var now_on_floor := is_on_floor()
	if not _was_on_floor and now_on_floor:
		# Just landed
		if fall_speed_before_move > 80.0:
			play_landing(fall_speed_before_move)
		_step_distance_accumulator = 0.0

	_process_footsteps(delta, now_on_floor)
	_previous_vertical_velocity = fall_speed_before_move

	if _was_on_floor != now_on_floor:
		_was_on_floor = now_on_floor
		queue_redraw()
	elif not is_zero_approx(direction):
		queue_redraw()


func _process_footsteps(delta: float, grounded: bool) -> void:
	if grounded and absf(velocity.x) > 10.0:
		_step_distance_accumulator += absf(velocity.x) * delta
		if _step_distance_accumulator >= STEP_STRIDE:
			_step_distance_accumulator -= STEP_STRIDE
			play_footstep()
	else:
		_step_distance_accumulator = minf(_step_distance_accumulator, STEP_STRIDE * 0.5)


func get_current_surface_type() -> SurfaceType:
	for i in range(get_slide_collision_count()):
		var col := get_slide_collision(i)
		var collider := col.get_collider()
		if collider is AnchorableObject:
			return SurfaceType.METAL
		elif collider is MovableAnchorableProp:
			return SurfaceType.METAL
		elif collider != null and (collider.name.to_lower().contains("metal") or collider.name.to_lower().contains("lift") or collider.name.to_lower().contains("bridge")):
			return SurfaceType.METAL
	return SurfaceType.CONCRETE_LINOLEUM


func play_footstep() -> void:
	var surface := get_current_surface_type()
	var stream := _footstep_metal_sfx if surface == SurfaceType.METAL else _footstep_linoleum_sfx
	if _step_audio_player and stream:
		_step_audio_player.stream = stream
		_step_foot_toggle = not _step_foot_toggle
		_step_audio_player.pitch_scale = 1.03 if _step_foot_toggle else 0.97
		_step_audio_player.play()


func play_landing(fall_speed: float = 0.0) -> void:
	var surface := get_current_surface_type()
	var stream := _land_metal_sfx if surface == SurfaceType.METAL else _land_linoleum_sfx
	if _land_audio_player and stream:
		_land_audio_player.stream = stream
		var intensity := clampf(fall_speed / 300.0, 0.7, 1.3)
		_land_audio_player.pitch_scale = randf_range(0.96, 1.04)
		_land_audio_player.volume_db = linear_to_db(clampf(intensity * 0.85, 0.3, 1.0))
		_land_audio_player.play()


func reset_to(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	_coyote_remaining = 0.0
	_jump_buffer_remaining = 0.0
	_was_on_floor = false
	_previous_vertical_velocity = 0.0
	_step_distance_accumulator = 0.0
	_step_foot_toggle = false
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

