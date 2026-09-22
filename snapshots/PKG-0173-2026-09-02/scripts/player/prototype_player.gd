class_name PrototypePlayer
extends CharacterBody2D

const LenaVisualRig := preload("res://scripts/player/lena_visual_rig.gd")
const LenaAnimationState := preload("res://scripts/player/lena_animation_state.gd")

enum SurfaceType {
	LINOLEUM_TILE = 0,
	TERRAZZO_STAIR = 1,
	WET_ASPHALT = 2,
	STEEL_GRATING = 3,
	HOLLOW_DECK = 4,
	CONCRETE_LINOLEUM = 0,
	METAL = 3
}

@export var movement_profile: MovementProfile = MovementProfileCatalog.PROFILE_A
@export var climb_speed: float = 75.0
const SPRINT_MULTIPLIER: float = 1.35


const STEP_STRIDE: float = 24.0
const MAX_CURB_STEP: float = 18.0

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
var is_sprinting := false

var current_ladder: Area2D = null
var _last_climb_step_y := 0.0

const STEP_DURATION_MIN := 0.18
const STEP_DURATION_MAX := 0.24
const FOOT_OFFSET_Y := 27.0

var _stepping := false
var _step_pose: StringName = &""
var _step_from := Vector2.ZERO
var _step_to := Vector2.ZERO
var _step_elapsed := 0.0
var _step_duration := STEP_DURATION_MIN
var _step_height := 0.0
var _step_land_suppress := 0.0

var _footstep_linoleum_sfx: AudioStreamWAV
var _footstep_terrazzo_sfx: AudioStreamWAV
var _footstep_asphalt_sfx: AudioStreamWAV
var _footstep_metal_sfx: AudioStreamWAV
var _footstep_deck_sfx: AudioStreamWAV

var _land_linoleum_sfx: AudioStreamWAV
var _land_terrazzo_sfx: AudioStreamWAV
var _land_asphalt_sfx: AudioStreamWAV
var _land_metal_sfx: AudioStreamWAV
var _land_deck_sfx: AudioStreamWAV
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
	_footstep_terrazzo_sfx = ProceduralAudio.get_cached_sound(&"step_terrazzo", ProceduralAudio.create_footstep_terrazzo_sound)
	_footstep_asphalt_sfx = ProceduralAudio.get_cached_sound(&"step_asphalt", ProceduralAudio.create_footstep_wet_asphalt_sound)
	_footstep_metal_sfx = ProceduralAudio.get_cached_sound(&"step_metal", ProceduralAudio.create_footstep_steel_grating_sound)
	_footstep_deck_sfx = ProceduralAudio.get_cached_sound(&"step_deck", ProceduralAudio.create_footstep_hollow_deck_sound)

	_land_linoleum_sfx = ProceduralAudio.get_cached_sound(&"land_linoleum", func() -> AudioStreamWAV: return ProceduralAudio.create_surface_land_sound(SurfaceType.LINOLEUM_TILE))
	_land_terrazzo_sfx = ProceduralAudio.get_cached_sound(&"land_terrazzo", func() -> AudioStreamWAV: return ProceduralAudio.create_surface_land_sound(SurfaceType.TERRAZZO_STAIR))
	_land_asphalt_sfx = ProceduralAudio.get_cached_sound(&"land_asphalt", func() -> AudioStreamWAV: return ProceduralAudio.create_surface_land_sound(SurfaceType.WET_ASPHALT))
	_land_metal_sfx = ProceduralAudio.get_cached_sound(&"land_metal", func() -> AudioStreamWAV: return ProceduralAudio.create_surface_land_sound(SurfaceType.STEEL_GRATING))
	_land_deck_sfx = ProceduralAudio.get_cached_sound(&"land_deck", func() -> AudioStreamWAV: return ProceduralAudio.create_surface_land_sound(SurfaceType.HOLLOW_DECK))
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
	particles.position = Vector2(0.0, 27.0)
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
	is_sprinting = InputMap.has_action(&"sprint") and Input.is_action_pressed(&"sprint")
	var target_speed: float = movement_profile.move_speed
	if is_sprinting:
		target_speed *= SPRINT_MULTIPLIER


	_step_land_suppress = maxf(0.0, _step_land_suppress - delta)
	if _stepping:
		_advance_curb_step(delta)
		return

	# Ladder climbing logic. Attach is proximity; climb requires intent (D-190).
	if current_ladder != null and is_instance_valid(current_ladder):
		if not is_climbing:
			var nearly_stopped := absf(horizontal_input) < 0.2 and absf(velocity.x) < 28.0
			var interact_intent := InputMap.has_action(&"interact") and Input.is_action_just_pressed(&"interact")
			var vertical_intent := not is_zero_approx(vertical_input) and nearly_stopped
			if interact_intent or vertical_intent:
				is_climbing = true
				_last_climb_step_y = global_position.y
				velocity = Vector2.ZERO
				if visual_rig:
					visual_rig.notify_ladder_mount()
		
		if is_climbing:
			_coyote_remaining = 0.0
			_jump_buffer_remaining = 0.0
			
			if Input.is_action_just_pressed(&"jump"):
				# Jump off ladder
				is_climbing = false
				velocity.y = movement_profile.jump_velocity * 0.85
				velocity.x = (horizontal_input if not is_zero_approx(horizontal_input) else _facing) * target_speed * 0.75
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
					if visual_rig:
						visual_rig.notify_ladder_dismount()
			
			move_and_slide()
			
			if visual_rig:
				visual_rig.set_mechanical_state(velocity, is_on_floor(), is_climbing, is_sprinting)
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
			horizontal_input * target_speed,
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
	if not _was_on_floor and now_on_floor and not _stepping and _step_land_suppress <= 0.0:
		# Just landed
		if fall_speed_before_move > 80.0:
			play_landing(fall_speed_before_move)
			_emit_landing_dust()
			_play_squash_stretch(Vector2(1.20, 0.80), 0.07, Vector2(0.96, 1.04), 0.13)
			if animation_state:
				animation_state.notify_land(fall_speed_before_move)
		_step_distance_accumulator = 0.0

	if _was_on_floor and not now_on_floor and not _stepping and not is_climbing:
		var drop := measure_drop_height()
		if drop > 1.5 and drop <= MAX_CURB_STEP:
			_begin_step(&"step_down", Vector2(signf(_facing) * 4.0, drop))
			_advance_curb_step(delta)
			return

	_process_footsteps(delta, now_on_floor)
	if now_on_floor and is_on_wall() and not is_zero_approx(horizontal_input) and not _stepping:
		try_curb_step(horizontal_input)


	_previous_vertical_velocity = fall_speed_before_move

	if visual_rig:
		var pose := _step_pose
		if pose.is_empty() and _step_land_suppress > 0.0:
			pose = &"step_up"
		visual_rig.set_mechanical_state(velocity, now_on_floor or _step_land_suppress > 0.0, false, is_sprinting, pose)
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
	if _stepping or _step_land_suppress > 0.0:
		return
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
		# PKG-0141 (D-151): kurz lądowania to dekoracja, nie informacja — tryb
		# ograniczonego ruchu ją gasi, a dźwięk lądowania zostaje.
		ParticleBudget.set_micro_emission(particles, true)


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
		ParticleBudget.set_micro_emission(
			particles,
			is_sprinting and absf(velocity.x) > movement_profile.move_speed * 0.85
		)


func get_current_surface_type() -> SurfaceType:
	for i in range(get_slide_collision_count()):
		var col := get_slide_collision(i)
		var collider := col.get_collider()
		if collider != null:
			if collider.has_meta("surface_type"):
				var st: Variant = collider.get_meta("surface_type")
				if st is int:
					return st as SurfaceType
			var cname: String = String(collider.name).to_lower()
			if cname.contains("stair") or cname.contains("terrazzo") or cname.contains("step"):
				return SurfaceType.TERRAZZO_STAIR
			elif cname.contains("asphalt") or cname.contains("street") or cname.contains("road") or cname.contains("curb"):
				return SurfaceType.WET_ASPHALT
			elif cname.contains("metal") or cname.contains("grate") or cname.contains("grating") or cname.contains("lift") or cname.contains("bridge") or cname.contains("catwalk") or collider is AnchorableObject or collider is MovableAnchorableProp:
				return SurfaceType.STEEL_GRATING
			elif cname.contains("tram") or cname.contains("deck") or cname.contains("plank") or cname.contains("wagon"):
				return SurfaceType.HOLLOW_DECK

	# Scene/station fallback based on current station context
	if is_inside_tree() and get_tree().current_scene:
		var scene_name := get_tree().current_scene.name.to_lower()
		var scene_path := get_tree().current_scene.scene_file_path.to_lower()
		if "05" in scene_name or "05" in scene_path:
			return SurfaceType.WET_ASPHALT
		elif "07" in scene_name or "07" in scene_path or "09" in scene_name or "09" in scene_path:
			if global_position.y < 280.0:
				return SurfaceType.TERRAZZO_STAIR
		elif "28" in scene_name or "28" in scene_path:
			return SurfaceType.HOLLOW_DECK
		elif "15" in scene_name or "27" in scene_name or "30" in scene_name or "33" in scene_name or "36" in scene_name:
			return SurfaceType.STEEL_GRATING

	return SurfaceType.LINOLEUM_TILE


func play_footstep() -> void:
	var surface := get_current_surface_type()
	var stream: AudioStreamWAV = _footstep_linoleum_sfx
	match surface:
		SurfaceType.TERRAZZO_STAIR:
			stream = _footstep_terrazzo_sfx
		SurfaceType.WET_ASPHALT:
			stream = _footstep_asphalt_sfx
		SurfaceType.STEEL_GRATING:
			stream = _footstep_metal_sfx
		SurfaceType.HOLLOW_DECK:
			stream = _footstep_deck_sfx
		_:
			stream = _footstep_linoleum_sfx

	if _step_audio_player and stream:
		_step_audio_player.stream = stream
		_step_foot_toggle = not _step_foot_toggle
		_step_audio_player.pitch_scale = 1.03 if _step_foot_toggle else 0.97
		_step_audio_player.play()


func play_landing(fall_speed: float = 0.0) -> void:
	if _stepping or _step_land_suppress > 0.0:
		return
	var surface := get_current_surface_type()
	var stream: AudioStreamWAV = _land_linoleum_sfx
	match surface:
		SurfaceType.TERRAZZO_STAIR:
			stream = _land_terrazzo_sfx
		SurfaceType.WET_ASPHALT:
			stream = _land_asphalt_sfx
		SurfaceType.STEEL_GRATING:
			stream = _land_metal_sfx
		SurfaceType.HOLLOW_DECK:
			stream = _land_deck_sfx
		_:
			stream = _land_linoleum_sfx

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
	_stepping = false
	_step_pose = &""
	_step_elapsed = 0.0
	_step_height = 0.0
	_step_land_suppress = 0.0
	queue_redraw()


func apply_movement_profile(profile: MovementProfile) -> void:
	if profile == null:
		push_error("PrototypePlayer cannot apply an empty movement profile")
		return
	movement_profile = profile
	set_physics_process(true)
	queue_redraw()


func is_stepping() -> bool:
	return _stepping or _step_land_suppress > 0.0


func get_stepping_pose() -> StringName:
	return _step_pose


func measure_curb_height(direction: float) -> float:
	if is_zero_approx(direction) or get_world_2d() == null:
		return 0.0
	var space := get_world_2d().direct_space_state
	if space == null:
		return 0.0
	var facing := signf(direction)
	var ahead := Vector2(facing * 6.0, 0.0)
	var cleared_h := 0.0
	var probe_h := MAX_CURB_STEP
	while probe_h >= 4.0:
		var raised := global_transform
		raised.origin.y -= probe_h
		if not test_move(raised, ahead):
			cleared_h = probe_h
			break
		probe_h -= 2.0
	if cleared_h < 1.5:
		return 0.0
	var probe_from := global_position + ahead + Vector2(0.0, -cleared_h + 1.0)
	var probe_to := probe_from + Vector2(0.0, cleared_h + FOOT_OFFSET_Y + 8.0)
	var query := PhysicsRayQueryParameters2D.create(probe_from, probe_to)
	query.exclude = [get_rid()]
	query.collision_mask = collision_mask
	query.hit_from_inside = true
	var hit := space.intersect_ray(query)
	if not hit.is_empty():
		var hit_normal: Vector2 = hit.get("normal", Vector2.ZERO)
		if hit_normal.y <= -0.35:
			var measured := (global_position.y + FOOT_OFFSET_Y) - float(hit.position.y)
			if measured >= 1.5 and measured <= MAX_CURB_STEP + 0.51:
				return measured
	return cleared_h


func measure_drop_height() -> float:
	if get_world_2d() == null:
		return 0.0
	var space := get_world_2d().direct_space_state
	if space == null:
		return 0.0
	var from := global_position + Vector2(signf(_facing) * 6.0, 2.0)
	var to := from + Vector2(0.0, MAX_CURB_STEP + 6.0)
	var query := PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [get_rid()]
	query.collision_mask = collision_mask
	var hit := space.intersect_ray(query)
	if hit.is_empty():
		return 0.0
	return float(hit.position.y) - (global_position.y + FOOT_OFFSET_Y)


func _begin_step(pose: StringName, delta_pos: Vector2) -> void:
	_stepping = true
	_step_pose = pose
	_step_from = global_position
	_step_to = global_position + delta_pos
	_step_elapsed = 0.0
	_step_height = absf(delta_pos.y)
	_step_duration = lerpf(STEP_DURATION_MIN, STEP_DURATION_MAX, clampf(_step_height / MAX_CURB_STEP, 0.0, 1.0))
	velocity = Vector2.ZERO


func _advance_curb_step(delta: float) -> void:
	_step_elapsed += delta
	var t := clampf(_step_elapsed / maxf(_step_duration, 0.001), 0.0, 1.0)
	var s := t * t * (3.0 - 2.0 * t)
	var apex := -3.0 if _step_pose == &"step_up" else 0.0
	var mid := (_step_from + _step_to) * 0.5 + Vector2(0.0, apex)
	var one := 1.0 - s
	global_position = one * one * _step_from + 2.0 * one * s * mid + s * s * _step_to
	velocity = Vector2.ZERO
	move_and_slide()
	if visual_rig:
		visual_rig.set_mechanical_state(Vector2(_facing * 24.0, 0.0), true, false, false, _step_pose)
		visual_rig.set_facing(_facing)
	if t >= 1.0:
		global_position = _step_to
		velocity = Vector2.ZERO
		move_and_slide()
		_stepping = false
		_step_pose = &""
		_step_land_suppress = 0.16
		_was_on_floor = true
		play_footstep()


func try_curb_step(direction: float) -> bool:
	if is_zero_approx(direction) or is_climbing or _stepping:
		return false
	if not is_on_floor() or not is_on_wall():
		return false
	var blocked := false
	for i in get_slide_collision_count():
		var normal := get_slide_collision(i).get_normal()
		if absf(normal.x) > 0.7:
			blocked = true
			break
	if not blocked:
		return false
	var height := measure_curb_height(direction)
	if height < 1.5 or height > MAX_CURB_STEP + 0.51:
		return false
	var raised := global_transform
	raised.origin.y -= height
	var ahead := Vector2(signf(direction) * 6.0, 0.0)
	if test_move(raised, ahead):
		return false
	_begin_step(&"step_up", Vector2(signf(direction) * 6.0, -height))
	# Harnesses that drive move_and_slide themselves (physics_process off)
	# still need the lift in this call; live play interpolates in _physics_process.
	if not is_physics_processing():
		global_position = _step_to
		velocity.y = 0.0
		_stepping = false
		_step_pose = &""
		move_and_slide()
	return true


func debug_state() -> Dictionary:
	return {
		"position": global_position,
		"velocity": velocity,
		"grounded": is_on_floor(),
		"climbing": is_climbing,
		"stepping": _stepping,
		"step_height": _step_height,
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
