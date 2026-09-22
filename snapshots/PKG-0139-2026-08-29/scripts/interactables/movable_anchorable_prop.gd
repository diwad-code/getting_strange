class_name MovableAnchorableProp
extends CharacterBody2D

## Lab cargo crate that can be pushed by the player and selectively anchored
## in space (frozen in place, resisting correction-wave consensus shifts).
##
## Push model: player presses against the crate with horizontal input.
##   The crate gets a horizontal impulse proportional to player speed.
##   Gravity applies normally when the crate is not anchored.
##   Anchored crates freeze all velocity and resist reality shifts.
##
## Uses AnchorableObject.RealityState to share the project-wide type.

signal anchor_state_changed(is_anchored: bool)
signal reality_shift_processed(target_state: AnchorableObject.RealityState, resisted: bool)

const COLOR_CRATE_BODY       := Color("2e3f48")
const COLOR_CRATE_EDGE       := Color("4a6872")
const COLOR_CRATE_STRIPE     := Color("3a5560")
const COLOR_INFRASTRUCTURE   := Color("a8b2ac")
const COLOR_ANCHOR_CYAN      := Color("75c7c3")
const COLOR_CORRECTION       := Color("c65d58")
const COLOR_AMBER            := Color("d39a62")
const COLOR_GHOST            := Color(0.46, 0.78, 0.76, 0.22)

## Physical footprint of the crate (width x height in pixels).
@export var crate_size: Vector2 = Vector2(28.0, 28.0)
## Maximum speed the crate can be pushed horizontally (px/s).
@export var push_speed_max: float = 64.0
## Horizontal acceleration when player pushes the crate (px/s²).
@export var push_acceleration: float = 420.0
## Gravity applied to the crate when airborne (px/s²).
@export var crate_gravity: float = 640.0
## Maximum downward fall speed (px/s).
@export var max_fall_speed: float = 280.0
## Interaction radius for the anchor action (px).
@export var interaction_radius: float = 48.0
## Name shown in console/debug overlays.
@export var object_name: String = "Lab Crate"

## When true the crate is frozen in 3-space and resists consensus correction.
var is_anchored: bool = false:
	set(value):
		if is_anchored != value:
			is_anchored = value
			if is_node_ready():
				if is_anchored:
					velocity = Vector2.ZERO
					_play_sfx(_anchor_sound)
					if _anchor_particles:
						_anchor_particles.emitting = true
				else:
					_play_sfx(_unanchor_sound)
					if _anchor_particles:
						_anchor_particles.emitting = false
			anchor_state_changed.emit(is_anchored)
			queue_redraw()

var current_reality: AnchorableObject.RealityState = AnchorableObject.RealityState.STATE_A
var is_player_in_range: bool = false:
	set(value):
		if is_player_in_range != value:
			is_player_in_range = value
			queue_redraw()

## Direction the player is pushing this frame (-1, 0, +1).
var _push_input: float = 0.0
var _pulse_phase: float = 0.0
var _flash_color: Color = Color.TRANSPARENT
var _flash_intensity: float = 0.0

var _collision_shape: CollisionShape2D
var _rect_shape: RectangleShape2D

var _audio_player: AudioStreamPlayer2D
var _anchor_sound: AudioStreamWAV
var _unanchor_sound: AudioStreamWAV
var _resist_sound: AudioStreamWAV

var _anchor_particles: CPUParticles2D
var _resist_particles: CPUParticles2D


var spawn_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	if spawn_position == Vector2.ZERO:
		spawn_position = position
	_setup_collision()
	_setup_audio()
	_setup_particles()
	queue_redraw()


func reset_to_spawn() -> void:
	is_anchored = false
	velocity = Vector2.ZERO
	position = spawn_position
	current_reality = AnchorableObject.RealityState.STATE_A
	queue_redraw()


func _setup_collision() -> void:
	_collision_shape = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if _collision_shape == null:
		_collision_shape = CollisionShape2D.new()
		_collision_shape.name = "CollisionShape2D"
		add_child(_collision_shape)

	if _collision_shape.shape is RectangleShape2D:
		_rect_shape = _collision_shape.shape as RectangleShape2D
	else:
		_rect_shape = RectangleShape2D.new()
		_collision_shape.shape = _rect_shape

	_rect_shape.size = crate_size


func _setup_audio() -> void:
	_audio_player = get_node_or_null("AudioPlayer2D") as AudioStreamPlayer2D
	if _audio_player == null:
		_audio_player = AudioStreamPlayer2D.new()
		_audio_player.name = "AudioPlayer2D"
		_audio_player.max_distance = 600.0
		_audio_player.bus = &"Master"
		add_child(_audio_player)

	_anchor_sound   = ProceduralAudio.create_anchor_sound()
	_unanchor_sound = ProceduralAudio.create_unanchor_sound()
	_resist_sound   = ProceduralAudio.create_resist_sound()


func _setup_particles() -> void:
	# Ambient containment aura (cyan) while anchored
	_anchor_particles = get_node_or_null("AnchorParticles") as CPUParticles2D
	if _anchor_particles == null:
		_anchor_particles = CPUParticles2D.new()
		_anchor_particles.name = "AnchorParticles"
		_anchor_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		_anchor_particles.emission_rect_extents = crate_size * 0.5
		_anchor_particles.amount = 6
		_anchor_particles.lifetime = 0.9
		_anchor_particles.direction = Vector2(0.0, -1.0)
		_anchor_particles.spread = 20.0
		_anchor_particles.gravity = Vector2(0.0, -6.0)
		_anchor_particles.initial_velocity_min = 2.0
		_anchor_particles.initial_velocity_max = 5.0
		_anchor_particles.color = Color(COLOR_ANCHOR_CYAN, 0.55)
		_anchor_particles.emitting = false
		ParticleBudget.apply_frame_budget(_anchor_particles)
		add_child(_anchor_particles)

	# Burst resistance sparks when correction wave strikes anchored crate
	_resist_particles = get_node_or_null("ResistParticles") as CPUParticles2D
	if _resist_particles == null:
		_resist_particles = CPUParticles2D.new()
		_resist_particles.name = "ResistParticles"
		_resist_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		_resist_particles.emission_rect_extents = crate_size * 0.5
		_resist_particles.amount = 12
		_resist_particles.lifetime = 0.3
		_resist_particles.one_shot = true
		_resist_particles.explosiveness = 0.9
		_resist_particles.direction = Vector2(-1.0, -0.5)
		_resist_particles.spread = 50.0
		_resist_particles.gravity = Vector2(0.0, 24.0)
		_resist_particles.initial_velocity_min = 22.0
		_resist_particles.initial_velocity_max = 50.0
		_resist_particles.color = Color(COLOR_ANCHOR_CYAN, 0.9)
		_resist_particles.emitting = false
		ParticleBudget.apply_frame_budget(_resist_particles)
		add_child(_resist_particles)


func _play_sfx(stream: AudioStreamWAV) -> void:
	if _audio_player and stream:
		_audio_player.stream = stream
		_audio_player.play()


# ─── Physics ──────────────────────────────────────────────────────────────────

func _physics_process(delta: float) -> void:
	if is_anchored:
		# Anchored crate: hard freeze, zero velocity, no movement
		velocity = Vector2.ZERO
		_push_input = 0.0
		move_and_slide()
		_pulse_phase += delta * 4.0
		queue_redraw()
		return

	# Gravity
	if not is_on_floor():
		velocity.y = minf(velocity.y + crate_gravity * delta, max_fall_speed)
	else:
		if velocity.y > 0.0:
			velocity.y = 0.0

	# Horizontal push from player contact
	if not is_zero_approx(_push_input):
		velocity.x = move_toward(
			velocity.x,
			_push_input * push_speed_max,
			push_acceleration * delta
		)
	else:
		# Friction / decelerate
		velocity.x = move_toward(velocity.x, 0.0, push_acceleration * 1.5 * delta)

	_push_input = 0.0  # consumed each frame, replenished by player contact
	move_and_slide()

	if _flash_intensity > 0.0 or is_player_in_range:
		_pulse_phase += delta * 4.0
		if _flash_intensity > 0.0:
			_flash_intensity = maxf(0.0, _flash_intensity - delta * 3.0)
		queue_redraw()


## Called by AnchorLab when the player body is pressing into the crate.
## direction: -1.0 (left) or +1.0 (right).
func receive_push(direction: float) -> void:
	if not is_anchored:
		_push_input = direction


# ─── Anchor control ───────────────────────────────────────────────────────────

func toggle_anchor() -> bool:
	set_anchored(not is_anchored)
	return is_anchored


func set_anchored(anchored: bool) -> void:
	is_anchored = anchored
	if is_anchored:
		_flash_color = COLOR_ANCHOR_CYAN
		_flash_intensity = 1.0


# ─── Reality shift ────────────────────────────────────────────────────────────

func apply_reality_shift(_target_state: AnchorableObject.RealityState, _animate: bool = true) -> void:
	## MovableAnchorableProp does not change position on reality shifts.
	## When anchored it resists; when free it yields but stays in place
	## (crate position is determined by physics, not preset state positions).
	if is_anchored:
		_flash_color = COLOR_ANCHOR_CYAN
		_flash_intensity = 1.0
		_play_sfx(_resist_sound)
		if _resist_particles:
			_resist_particles.restart()
			_resist_particles.emitting = true
		reality_shift_processed.emit(_target_state, true)
		queue_redraw()
		return

	current_reality = _target_state
	_flash_color = COLOR_CORRECTION
	_flash_intensity = 1.0
	reality_shift_processed.emit(_target_state, false)
	queue_redraw()


func get_distance_to_point(point: Vector2) -> float:
	var half := crate_size * 0.5
	var dx := maxf(0.0, absf(point.x - global_position.x) - half.x)
	var dy := maxf(0.0, absf(point.y - global_position.y) - half.y)
	return sqrt(dx * dx + dy * dy)


func update_player_distance(player_global_position: Vector2) -> void:
	var dist := get_distance_to_point(player_global_position)
	is_player_in_range = (dist <= interaction_radius)


# ─── Draw ─────────────────────────────────────────────────────────────────────

func _draw() -> void:
	var half := crate_size * 0.5
	var body_rect := Rect2(-half, crate_size)

	# 1. Crate body fill (dark container slate)
	draw_rect(body_rect, COLOR_CRATE_BODY, true)

	# 2. Structural cross bracing (diagonal stripes, lab equipment reinforcement)
	var stripe_color := Color(COLOR_CRATE_STRIPE, 0.7)
	draw_line(Vector2(-half.x, -half.y), Vector2(half.x, half.y), stripe_color, 1.0)
	draw_line(Vector2(half.x, -half.y), Vector2(-half.x, half.y), stripe_color, 1.0)

	# 3. Corner steel reinforcement brackets (4 corners with rivets, szara szałwia)
	var bracket_arm := 5.0
	var bracket_col := Color(COLOR_INFRASTRUCTURE, 0.75 if not is_anchored else 0.9)
	# Top-Left
	draw_line(Vector2(-half.x, -half.y), Vector2(-half.x + bracket_arm, -half.y), bracket_col, 1.5)
	draw_line(Vector2(-half.x, -half.y), Vector2(-half.x, -half.y + bracket_arm), bracket_col, 1.5)
	draw_circle(Vector2(-half.x + 2.0, -half.y + 2.0), 0.75, bracket_col)
	# Top-Right
	draw_line(Vector2(half.x, -half.y), Vector2(half.x - bracket_arm, -half.y), bracket_col, 1.5)
	draw_line(Vector2(half.x, -half.y), Vector2(half.x, -half.y + bracket_arm), bracket_col, 1.5)
	draw_circle(Vector2(half.x - 2.0, -half.y + 2.0), 0.75, bracket_col)
	# Bottom-Left
	draw_line(Vector2(-half.x, half.y), Vector2(-half.x + bracket_arm, half.y), bracket_col, 1.5)
	draw_line(Vector2(-half.x, half.y), Vector2(-half.x, half.y - bracket_arm), bracket_col, 1.5)
	draw_circle(Vector2(-half.x + 2.0, half.y - 2.0), 0.75, bracket_col)
	# Bottom-Right
	draw_line(Vector2(half.x, half.y), Vector2(half.x - bracket_arm, half.y), bracket_col, 1.5)
	draw_line(Vector2(half.x, half.y), Vector2(half.x, half.y - bracket_arm), bracket_col, 1.5)
	draw_circle(Vector2(half.x - 2.0, half.y - 2.0), 0.75, bracket_col)

	# 4. Institutional Laboratory Stencil Label & Correlation Marks (drawn with code)
	var label_col := Color(COLOR_INFRASTRUCTURE, 0.45)
	# Central correlation reticle (+)
	draw_line(Vector2(-3.0, 0.0), Vector2(3.0, 0.0), label_col, 1.0)
	draw_line(Vector2(0.0, -3.0), Vector2(0.0, 3.0), label_col, 1.0)
	# Stenciled data barcode bands on bottom half
	draw_line(Vector2(-6.0, 5.0), Vector2(6.0, 5.0), label_col, 1.0)
	draw_line(Vector2(-6.0, 8.0), Vector2(1.0, 8.0), label_col, 1.0)
	# Reality state inspection diode
	var diode_col := COLOR_AMBER if current_reality == AnchorableObject.RealityState.STATE_A else COLOR_CORRECTION
	draw_circle(Vector2(4.5, 8.0), 1.0, diode_col)

	# 5. Side Recessed Handling Grips
	var grip_col := Color(COLOR_CRATE_STRIPE, 0.8)
	draw_line(Vector2(-half.x + 2.0, -2.0), Vector2(-half.x + 2.0, 2.0), grip_col, 1.5)
	draw_line(Vector2(half.x - 2.0, -2.0), Vector2(half.x - 2.0, 2.0), grip_col, 1.5)

	# 6. Edge outline & Walkable Surface Traction Grooves
	var edge_color := COLOR_ANCHOR_CYAN if is_anchored else COLOR_CRATE_EDGE
	draw_rect(body_rect, edge_color, false, 1.0)
	draw_line(Vector2(-half.x, -half.y), Vector2(half.x, -half.y), edge_color, 1.5)
	# Top traction grooves
	draw_line(Vector2(-5.0, -half.y), Vector2(-5.0, -half.y + 2.0), edge_color, 1.0)
	draw_line(Vector2(0.0, -half.y), Vector2(0.0, -half.y + 2.0), edge_color, 1.0)
	draw_line(Vector2(5.0, -half.y), Vector2(5.0, -half.y + 2.0), edge_color, 1.0)

	# 7. Anchor Hold Spatial Lock (pulsing cyan frame, corner pins, quantum reticle)
	if is_anchored:
		var pulse := 0.7 + 0.3 * sin(_pulse_phase)
		var cyan_glow := Color(COLOR_ANCHOR_CYAN, pulse)
		draw_rect(body_rect.grow(2.0), cyan_glow, false, 1.5)

		var pin_len := 4.0
		draw_line(Vector2(-half.x - 2, -half.y - 2), Vector2(-half.x - 2 + pin_len, -half.y - 2), cyan_glow, 1.5)
		draw_line(Vector2(-half.x - 2, -half.y - 2), Vector2(-half.x - 2, -half.y - 2 + pin_len), cyan_glow, 1.5)
		draw_line(Vector2(half.x + 2, -half.y - 2), Vector2(half.x + 2 - pin_len, -half.y - 2), cyan_glow, 1.5)
		draw_line(Vector2(half.x + 2, -half.y - 2), Vector2(half.x + 2, -half.y - 2 + pin_len), cyan_glow, 1.5)
		draw_line(Vector2(-half.x - 2, half.y + 2), Vector2(-half.x - 2 + pin_len, half.y + 2), cyan_glow, 1.5)
		draw_line(Vector2(-half.x - 2, half.y + 2), Vector2(-half.x - 2, half.y + 2 - pin_len), cyan_glow, 1.5)
		draw_line(Vector2(half.x + 2, half.y + 2), Vector2(half.x + 2 - pin_len, half.y + 2), cyan_glow, 1.5)
		draw_line(Vector2(half.x + 2, half.y + 2), Vector2(half.x + 2, half.y + 2 - pin_len), cyan_glow, 1.5)

		# Central quantum anchor diamond
		var diamond_size := 3.0
		draw_line(Vector2(0, -diamond_size), Vector2(diamond_size, 0), cyan_glow, 1.0)
		draw_line(Vector2(diamond_size, 0), Vector2(0, diamond_size), cyan_glow, 1.0)
		draw_line(Vector2(0, diamond_size), Vector2(-diamond_size, 0), cyan_glow, 1.0)
		draw_line(Vector2(-diamond_size, 0), Vector2(0, -diamond_size), cyan_glow, 1.0)

	# 8. In-Range Interaction Bracket (when unanchored and player close)
	if is_player_in_range and not is_anchored:
		var bracket_alpha := 0.55 + 0.35 * sin(_pulse_phase)
		var bracket_color := Color(COLOR_ANCHOR_CYAN, bracket_alpha)
		draw_rect(body_rect.grow(4.0), bracket_color, false, 1.0)
		draw_circle(Vector2(0.0, -half.y - 7.0), 2.0, bracket_color)

	# 9. Flash on Anchor Toggle / Wave Shift
	if _flash_intensity > 0.0:
		var flash := Color(_flash_color, _flash_intensity * 0.4)
		draw_rect(body_rect.grow(3.0), flash, true)
