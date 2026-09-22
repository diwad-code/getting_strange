class_name PrototypePlayer
extends CharacterBody2D

const LenaVisualRig := preload("res://scripts/player/lena_visual_rig.gd")
const LenaAnimationState := preload("res://scripts/player/lena_animation_state.gd")

enum SurfaceType { CONCRETE_LINOLEUM, METAL }

@export var movement_profile: MovementProfile = MovementProfileCatalog.PROFILE_A
@export var climb_speed: float = 75.0

const STEP_STRIDE: float = 24.0
const LADDER_RUNG_DISTANCE: float = 14.0

var _coyote_remaining := 0.0
var _jump_buffer_remaining := 0.0
var _facing := 1.0
var _was_on_floor := false
var _previous_vertical_velocity := 0.0
var _visual_scale := Vector2.ONE
var _visual_scale_tween: Tween

var _step_distance_accumulator := 0.0
var _step_foot_toggle := false

var is_climbing := false
var current_ladder: Area2D = null
var _last_climb_step_y := 0.0

var _footstep_linoleum_sfx: AudioStreamWAV
var _footstep_metal_sfx: AudioStreamWAV
var _land_linoleum_sfx: AudioStreamWAV
var _land_metal_sfx: AudioStreamWAV
var _ladder_rung_sfx: AudioStreamWAV

var _step_audio_player: AudioStreamPlayer2D
var _land_audio_player: AudioStreamPlayer2D
var _ladder_audio_player: AudioStreamPlayer2D

var visual_rig: LenaVisualRig
var animation_state: LenaAnimationState


func _ready() -> void:
	if movement_profile == null:
		push_error("PrototypePlayer requires a movement profile")
		set_physics_process(false)
		return
	floor_snap_length = 2.0
	floor_stop_on_slope = true

	visual_rig = get_node_or_null("LenaVisualRig") as LenaVisualRig
	if visual_rig == null:
		visual_rig = LenaVisualRig.new()
		visual_rig.name = "LenaVisualRig"
		add_child(visual_rig)
	animation_state = get_node_or_null("LenaAnimationState") as LenaAnimationState
	if animation_state == null:
		animation_state = LenaAnimationState.new()
		animation_state.name = "LenaAnimationState"
		animation_state.player = self
		animation_state.visual_rig = visual_rig
		add_child(animation_state)

	_setup_audio()
	_setup_particle_emitters()
	queue_redraw()


func _setup_audio() -> void:
	_footstep_linoleum_sfx = ProceduralAudio.get_cached_sound(&"step_linoleum", ProceduralAudio.create_footstep_linoleum_sound)
	_footstep_metal_sfx = ProceduralAudio.get_cached_sound(&"step_metal", ProceduralAudio.create_footstep_metal_sound)
	_land_linoleum_sfx = ProceduralAudio.get_cached_sound(&"land_linoleum", func() -> AudioStreamWAV: return ProceduralAudio.create_land_sound(false))
	_land_metal_sfx = ProceduralAudio.get_cached_sound(&"land_metal", func() -> AudioStreamWAV: return ProceduralAudio.create_land_sound(true))
	_ladder_rung_sfx = ProceduralAudio.get_cached_sound(&"ladder_rung", ProceduralAudio.create_ladder_rung_climb_sound)

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

	_ladder_audio_player = AudioStreamPlayer2D.new()
	_ladder_audio_player.name = "LadderAudioPlayer"
	_ladder_audio_player.max_distance = 600.0
	_ladder_audio_player.bus = &"Master"
	add_child(_ladder_audio_player)


func _setup_particle_emitters() -> void:
	_add_particle_emitter("RunDust", Color(0.68, 0.74, 0.66, 0.38), 0.7, 10, false)
	_add_particle_emitter("LandingDust", Color(0.77, 0.79, 0.69, 0.52), 0.55, 18, true)


func _add_particle_emitter(emitter_name: String, particle_color: Color, lifetime: float, amount: int, one_shot: bool) -> void:
	var particles := CPUParticles2D.new()
	particles.name = emitter_name
	particles.position = Vector2(0.0, 24.0)
	particles.amount = amount
	particles.lifetime = lifetime
	particles.one_shot = one_shot
	particles.emitting = false
	particles.direction = Vector2(0.0, -0.4)
	particles.spread = 55.0
	particles.gravity = Vector2(0.0, 54.0)
	particles.initial_velocity_min = 10.0
	particles.initial_velocity_max = 26.0
	particles.scale_amount_min = 0.55
	particles.scale_amount_max = 1.2
	particles.color = particle_color
	ParticleBudget.apply_frame_budget(particles)
	add_child(particles)


func attach_to_ladder(ladder: Area2D) -> void:
	current_ladder = ladder


func detach_from_ladder(ladder: Area2D) -> void:
	if current_ladder == ladder:
		current_ladder = null
		if is_climbing:
			is_climbing = false


func play_ladder_rung_sound() -> void:
	if _ladder_audio_player and _ladder_rung_sfx:
		_ladder_audio_player.stream = _ladder_rung_sfx
		_ladder_audio_player.pitch_scale = randf_range(0.95, 1.05)
		_ladder_audio_player.play()


func _physics_process(delta: float) -> void:
	if movement_profile == null:
		return

	var vertical_input := 0.0
	if InputMap.has_action(&"move_up") and InputMap.has_action(&"move_down"):
		vertical_input = Input.get_axis(&"move_up", &"move_down")
	elif Input.is_action_pressed(&"ui_up"):
		vertical_input = -1.0
	elif Input.is_action_pressed(&"ui_down"):
		vertical_input = 1.0

	var horizontal_input := Input.get_axis(&"move_left", &"move_right")

	# Ladder climbing logic
	if current_ladder != null and is_instance_valid(current_ladder):
		if not is_climbing and not is_zero_approx(vertical_input):
			is_climbing = true
			_last_climb_step_y = global_position.y
			velocity = Vector2.ZERO
		
		if is_climbing:
			_coyote_remaining = 0.0
			_jump_buffer_remaining = 0.0
			
			if Input.is_action_just_pressed(&"jump"):
				# Jump off ladder
				is_climbing = false
				velocity.y = movement_profile.jump_velocity * 0.85
				velocity.x = (horizontal_input if not is_zero_approx(horizontal_input) else _facing) * movement_profile.move_speed * 0.75
			else:
				velocity.y = vertical_input * climb_speed
				var target_x: float = current_ladder.global_position.x
				velocity.x = move_toward(velocity.x, (target_x - global_position.x) * 6.0, 300.0 * delta)
				
				# Play climbing sounds per rung
				if absf(global_position.y - _last_climb_step_y) >= LADDER_RUNG_DISTANCE:
					_last_climb_step_y = global_position.y
					play_ladder_rung_sound()
				
				# Exit climbing if touching floor and moving down
				if is_on_floor() and vertical_input > 0.0:
					is_climbing = false
			
			move_and_slide()
			
			if visual_rig:
				visual_rig.set_mechanical_state(velocity, is_on_floor(), is_climbing)
			return
	else:
		if is_climbing:
			is_climbing = false

	# Standard ground / airborne movement logic
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
		_play_squash_stretch(Vector2(0.85, 1.15), 0.07, Vector2(1.05, 0.95), 0.11)
		if animation_state:
			animation_state.notify_jump()

	if Input.is_action_just_released(&"jump") and velocity.y < 0.0:
		velocity.y *= movement_profile.jump_release_multiplier

	if not grounded:
		var gravity_scale := movement_profile.fall_gravity_multiplier if velocity.y > 0.0 else 1.0
		velocity.y = minf(
			velocity.y + movement_profile.gravity * gravity_scale * delta,
			movement_profile.max_fall_speed
		)

	if not is_zero_approx(horizontal_input):
		_facing = signf(horizontal_input)
		var acceleration := (
			movement_profile.ground_acceleration if grounded else movement_profile.air_acceleration
		)
		velocity.x = move_toward(
			velocity.x,
			horizontal_input * movement_profile.move_speed,
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
			_emit_landing_dust()
			_play_squash_stretch(Vector2(1.20, 0.80), 0.07, Vector2(0.96, 1.04), 0.13)
			if animation_state:
				animation_state.notify_land(fall_speed_before_move)
		_step_distance_accumulator = 0.0

	_process_footsteps(delta, now_on_floor)
	_previous_vertical_velocity = fall_speed_before_move

	if visual_rig:
		visual_rig.set_mechanical_state(velocity, now_on_floor, false)
		visual_rig.set_facing(_facing)

	if _was_on_floor != now_on_floor:
		_was_on_floor = now_on_floor
		queue_redraw()
	elif not is_zero_approx(horizontal_input):
		queue_redraw()


func _process(_delta: float) -> void:
	if not _visual_scale.is_equal_approx(Vector2.ONE):
		queue_redraw()


func _play_squash_stretch(impact_scale: Vector2, impact_duration: float, settle_scale: Vector2, settle_duration: float) -> void:
	if is_instance_valid(_visual_scale_tween):
		_visual_scale_tween.kill()
	_visual_scale_tween = create_tween()
	_visual_scale_tween.tween_property(self, "_visual_scale", impact_scale, impact_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_visual_scale_tween.tween_property(self, "_visual_scale", settle_scale, settle_duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_visual_scale_tween.tween_property(self, "_visual_scale", Vector2.ONE, 0.08).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_visual_scale_tween.parallel().tween_callback(queue_redraw)


func _emit_landing_dust() -> void:
	var particles := get_node_or_null("LandingDust") as CPUParticles2D
	if particles:
		particles.restart()
		particles.emitting = true


func _process_footsteps(delta: float, grounded: bool) -> void:
	if grounded and absf(velocity.x) > 10.0:
		_step_distance_accumulator += absf(velocity.x) * delta
		if _step_distance_accumulator >= STEP_STRIDE:
			_step_distance_accumulator -= STEP_STRIDE
			play_footstep()
			_emit_run_dust()
	else:
		_step_distance_accumulator = minf(_step_distance_accumulator, STEP_STRIDE * 0.5)
		var particles := get_node_or_null("RunDust") as CPUParticles2D
		if particles:
			particles.emitting = false


func _emit_run_dust() -> void:
	var particles := get_node_or_null("RunDust") as CPUParticles2D
	if particles:
		particles.emitting = absf(velocity.x) > movement_profile.move_speed * 0.45


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
	is_climbing = false
	current_ladder = null
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
		"climbing": is_climbing,
		"coyote_remaining": _coyote_remaining,
		"jump_buffer_remaining": _jump_buffer_remaining,
	}


func play_visual_cue(cue_name: StringName, duration: float = 0.6) -> void:
	if visual_rig:
		visual_rig.play_cue(cue_name, duration)


func trigger_unease(duration: float = 1.5) -> void:
	if visual_rig:
		visual_rig.set_state(&"unease_reaction")
	if is_inside_tree() and get_tree().current_scene:
		var atmo := get_tree().current_scene.get_node_or_null("AtmosphereRig") as AtmosphereRig
		if atmo:
			atmo.trigger_unease_atmosphere(duration)


func get_visual_rig() -> LenaVisualRig:
	return visual_rig


func _draw() -> void:
	if visual_rig != null:
		return
	if movement_profile == null:
		return
	# Fallback Vector-Stage silhouette when visual_rig is detached
	draw_set_transform(Vector2(0.0, 0.0), 0.0, _visual_scale)
	var target_facing := signf(velocity.x) if absf(velocity.x) > 8.0 else _facing
	_facing = move_toward(_facing, target_facing, 0.18)
	var turn_lean := clampf(velocity.x / movement_profile.move_speed, -1.0, 1.0)
	var lean := turn_lean * 3.0
	var shadow := PackedVector2Array([Vector2(-9.0, 27.0), Vector2(9.0, 27.0), Vector2(6.0, 29.0), Vector2(-11.0, 29.0)])
	VectorStageStyle.draw_facet_polygon(self, shadow, Color(VectorStageStyle.INK, 0.48), 0.0)
	var coat := PackedVector2Array([
		Vector2(-5.5 + lean, -20.0), Vector2(4.5 + lean, -20.0), Vector2(6.5, 12.0),
		Vector2(-7.0, 12.0),
	])
	VectorStageStyle.draw_facet_polygon(self, coat, VectorStageStyle.MID_PLANE)
	var head := PackedVector2Array([
		Vector2(-4.0 + lean, -36.0), Vector2(4.0 + lean, -35.0), Vector2(4.5 + lean, -24.0),
		Vector2(-4.5 + lean, -24.0),
	])
	VectorStageStyle.draw_facet_polygon(self, head, VectorStageStyle.HUMAN_AMBER)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
