class_name AnchorableObject
extends AnimatableBody2D

enum RealityState {
	STATE_A = 0,
	STATE_B = 1,
}

signal anchor_state_changed(is_anchored: bool)
signal reality_shift_processed(target_state: RealityState, resisted: bool)

const COLOR_PLATFORM := Color("263943")
const COLOR_EDGE := Color("66747a")
const COLOR_ANCHOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION_CINNABAR := Color("c65d58")
const COLOR_GHOST_A := Color(0.46, 0.78, 0.76, 0.25)
const COLOR_GHOST_B := Color(0.78, 0.36, 0.35, 0.20)

@export var state_a_position: Vector2 = Vector2.ZERO
@export var state_b_position: Vector2 = Vector2.ZERO
@export var state_a_size: Vector2 = Vector2(64.0, 20.0)
@export var state_b_size: Vector2 = Vector2(64.0, 20.0)
@export var state_a_solid: bool = true
@export var state_b_solid: bool = true
@export var interaction_radius: float = 56.0
@export var object_name: String = "Anchorable Object"

var is_anchored: bool = false:
	set(value):
		if is_anchored != value:
			is_anchored = value
			anchor_state_changed.emit(is_anchored)
			queue_redraw()

var current_reality: RealityState = RealityState.STATE_A
var is_player_in_range: bool = false:
	set(value):
		if is_player_in_range != value:
			is_player_in_range = value
			queue_redraw()

var _current_size: Vector2 = Vector2(64.0, 20.0)
var _collision_shape: CollisionShape2D
var _rect_shape: RectangleShape2D
var _tween: Tween
var _pulse_phase: float = 0.0
var _flash_color: Color = Color.TRANSPARENT
var _flash_intensity: float = 0.0


func _ready() -> void:
	if state_a_position == Vector2.ZERO and state_b_position == Vector2.ZERO:
		state_a_position = position
		state_b_position = position

	_current_size = state_a_size
	_setup_collision()
	_update_to_reality(RealityState.STATE_A, false)


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

	_rect_shape.size = _current_size


func _process(delta: float) -> void:
	if is_anchored or is_player_in_range or _flash_intensity > 0.0:
		_pulse_phase += delta * 4.0
		if _flash_intensity > 0.0:
			_flash_intensity = maxf(0.0, _flash_intensity - delta * 3.0)
		queue_redraw()


func toggle_anchor() -> bool:
	set_anchored(!is_anchored)
	return is_anchored


func set_anchored(anchored: bool) -> void:
	is_anchored = anchored
	if is_anchored:
		_flash_color = COLOR_ANCHOR_CYAN
		_flash_intensity = 1.0


func apply_reality_shift(target_state: RealityState, animate: bool = true) -> void:
	if is_anchored:
		# The anchored object resists the institutional shift!
		_flash_color = COLOR_ANCHOR_CYAN
		_flash_intensity = 1.0
		reality_shift_processed.emit(target_state, true)
		queue_redraw()
		return

	# Yielding to the institutional correction
	current_reality = target_state
	_flash_color = COLOR_CORRECTION_CINNABAR
	_flash_intensity = 1.0
	reality_shift_processed.emit(target_state, false)
	_update_to_reality(target_state, animate)


func _update_to_reality(state: RealityState, animate: bool) -> void:
	var target_pos := state_a_position if state == RealityState.STATE_A else state_b_position
	var target_size := state_a_size if state == RealityState.STATE_A else state_b_size
	var target_solid := state_a_solid if state == RealityState.STATE_A else state_b_solid

	if _tween and _tween.is_valid():
		_tween.kill()

	if animate:
		_tween = create_tween().set_parallel(true)
		_tween.tween_property(self, "position", target_pos, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_tween.tween_method(_set_size, _current_size, target_size, 0.25)
	else:
		position = target_pos
		_set_size(target_size)

	if _collision_shape:
		_collision_shape.set_deferred("disabled", not target_solid)
	queue_redraw()


func _set_size(new_size: Vector2) -> void:
	_current_size = new_size
	if _rect_shape:
		_rect_shape.size = _current_size
	queue_redraw()


func update_player_distance(player_global_position: Vector2) -> void:
	var dist := global_position.distance_to(player_global_position)
	is_player_in_range = (dist <= interaction_radius)


func get_ghost_rect() -> Rect2:
	var other_pos := state_b_position if current_reality == RealityState.STATE_A else state_a_position
	var other_size := state_b_size if current_reality == RealityState.STATE_A else state_a_size
	var relative_offset := other_pos - position
	return Rect2(relative_offset - other_size * 0.5, other_size)


func _draw() -> void:
	var half := _current_size * 0.5
	var body_rect := Rect2(-half, _current_size)

	# 1. Alternate reality ghost silhouette (subtle trace of the other version of reality)
	if not is_anchored:
		var ghost_rect := get_ghost_rect()
		var ghost_color := COLOR_GHOST_B if current_reality == RealityState.STATE_A else COLOR_GHOST_A
		draw_rect(ghost_rect, Color(ghost_color, 0.08), true)
		draw_rect(ghost_rect, ghost_color, false, 1.0)

	# 2. Main Platform Body
	var is_solid := state_a_solid if current_reality == RealityState.STATE_A else state_b_solid
	var fill_color := COLOR_PLATFORM if is_solid else Color(COLOR_PLATFORM.r, COLOR_PLATFORM.g, COLOR_PLATFORM.b, 0.3)
	draw_rect(body_rect, fill_color, true)

	# 3. Edge / Top Walkable Surface
	var top_edge_color := COLOR_EDGE if not is_anchored else COLOR_ANCHOR_CYAN
	draw_line(Vector2(-half.x, -half.y), Vector2(half.x, -half.y), top_edge_color, 2.0)
	draw_rect(body_rect, Color(top_edge_color, 0.5), false, 1.0)

	# 4. Anchored Visual Indicator (Cool Cyan holding border + corner pins)
	if is_anchored:
		var pulse := 0.7 + 0.3 * sin(_pulse_phase)
		var cyan_glow := Color(COLOR_ANCHOR_CYAN.r, COLOR_ANCHOR_CYAN.g, COLOR_ANCHOR_CYAN.b, pulse)
		draw_rect(body_rect.grow(2.0), cyan_glow, false, 1.5)

		# Anchor corner pins
		var pin_len := 4.0
		draw_line(Vector2(-half.x - 2, -half.y - 2), Vector2(-half.x - 2 + pin_len, -half.y - 2), cyan_glow, 2.0)
		draw_line(Vector2(-half.x - 2, -half.y - 2), Vector2(-half.x - 2, -half.y - 2 + pin_len), cyan_glow, 2.0)
		draw_line(Vector2(half.x + 2, -half.y - 2), Vector2(half.x + 2 - pin_len, -half.y - 2), cyan_glow, 2.0)
		draw_line(Vector2(half.x + 2, -half.y - 2), Vector2(half.x + 2, -half.y - 2 + pin_len), cyan_glow, 2.0)
		draw_line(Vector2(-half.x - 2, half.y + 2), Vector2(-half.x - 2 + pin_len, half.y + 2), cyan_glow, 2.0)
		draw_line(Vector2(-half.x - 2, half.y + 2), Vector2(-half.x - 2, half.y + 2 - pin_len), cyan_glow, 2.0)
		draw_line(Vector2(half.x + 2, half.y + 2), Vector2(half.x + 2 - pin_len, half.y + 2), cyan_glow, 2.0)
		draw_line(Vector2(half.x + 2, half.y + 2), Vector2(half.x + 2, half.y + 2 - pin_len), cyan_glow, 2.0)

	# 5. In-Range Interaction Bracket
	if is_player_in_range and not is_anchored:
		var bracket_color := Color(COLOR_ANCHOR_CYAN, 0.6 + 0.4 * sin(_pulse_phase))
		var bracket_rect := body_rect.grow(4.0)
		draw_rect(bracket_rect, bracket_color, false, 1.0)
		# Small center prompt pip
		draw_circle(Vector2(0, -half.y - 8.0), 2.0, bracket_color)

	# 6. Flash effect on shift / anchor change
	if _flash_intensity > 0.0:
		var flash := Color(_flash_color, _flash_intensity * 0.4)
		draw_rect(body_rect.grow(3.0), flash, true)
