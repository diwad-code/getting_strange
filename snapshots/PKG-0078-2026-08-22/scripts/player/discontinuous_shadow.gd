class_name DiscontinuousShadow
extends Node2D

## DiscontinuousShadow for Getting Strange Vertical Slice.
## Implements the observed discontinuity motion principle (#motionviz-observed-discontinuity)
## specified in VISUAL_DESIGN.md and FULL_STORY.md (Scene 02: Korelacja).
## In the correlation chamber, Lena's shadow finishes its movement a single frame before her body.

const SHADOW_COLOR_PRIMARY := Color(0.06, 0.09, 0.12, 0.50)
const SHADOW_COLOR_SECONDARY := Color(0.06, 0.09, 0.12, 0.38)
const FLOOR_REFLECTION_CYAN := Color(0.46, 0.78, 0.76, 0.08)

@export var target_player: PrototypePlayer
@export var floor_y: float = 296.0
@export var light_source_a: Vector2 = Vector2(320.0, 140.0)
@export var light_source_b: Vector2 = Vector2(440.0, 140.0)

@export var is_secondary_light_active: bool = false:
	set(value):
		is_secondary_light_active = value
		queue_redraw()

@export var is_anomaly_active: bool = false:
	set(value):
		is_anomaly_active = value
		queue_redraw()

var shadow_a_pos: Vector2 = Vector2.ZERO
var shadow_b_pos: Vector2 = Vector2.ZERO

var is_frame_desynced: bool = false
var desync_frame_count: int = 0

var _prev_target_vel_x: float = 0.0
var _prev_target_pos_x: float = 0.0
var _was_moving: bool = false


func _ready() -> void:
	if target_player:
		_prev_target_pos_x = target_player.global_position.x
		_update_shadow_positions(0.016)
	queue_redraw()


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target_player):
		return
	
	_update_shadow_positions(delta)
	queue_redraw()


func _update_shadow_positions(delta: float) -> void:
	var player_pos := target_player.global_position
	var player_vel := target_player.velocity
	var is_moving := absf(player_vel.x) > 4.0
	
	# 1. Primary Shadow (Light A) - Always physically continuous and true
	var dx_a := (player_pos.x - light_source_a.x)
	var angle_factor_a := clampf(dx_a / 180.0, -1.2, 1.2)
	var target_shadow_a_x := player_pos.x + angle_factor_a * 8.0
	shadow_a_pos = Vector2(target_shadow_a_x, floor_y)
	
	# 2. Secondary Shadow (Light B) - Correlation point
	var dx_b := (player_pos.x - light_source_b.x)
	var angle_factor_b := clampf(dx_b / 180.0, -1.2, 1.2)
	var ideal_shadow_b_x := player_pos.x + angle_factor_b * 8.0
	
	if not is_anomaly_active:
		# Physically continuous tracking
		shadow_b_pos = Vector2(ideal_shadow_b_x, floor_y)
		is_frame_desynced = false
	else:
		# Discontinuous Anomaly:
		# When Lena is stopping/decelerating, the shadow finishes movement 1 frame earlier!
		# When moving steadily, the shadow runs 1 frame ahead of physical geometry.
		if is_moving:
			# Advance shadow by 1 physics frame (delta = 1/60s = ~0.0166s)
			var lead_offset := player_vel.x * delta
			shadow_b_pos = Vector2(ideal_shadow_b_x + lead_offset, floor_y)
			is_frame_desynced = true
			desync_frame_count += 1
		elif _was_moving and not is_moving:
			# Immediate snap to resting coordinate 1 frame before Lena's lingering step
			shadow_b_pos = Vector2(ideal_shadow_b_x, floor_y)
			is_frame_desynced = true
			desync_frame_count += 1
		else:
			shadow_b_pos = Vector2(ideal_shadow_b_x, floor_y)
			is_frame_desynced = false
	
	_was_moving = is_moving
	_prev_target_vel_x = player_vel.x
	_prev_target_pos_x = player_pos.x


func _draw() -> void:
	if not is_instance_valid(target_player):
		return
	
	# Transform world shadow positions to local canvas space
	var local_a := to_local(shadow_a_pos)
	var local_b := to_local(shadow_b_pos)
	
	# 1. Primary Floor Shadow (Light A)
	_draw_shadow_ellipse(local_a, SHADOW_COLOR_PRIMARY, 11.0, 3.5)
	
	# 2. Secondary Floor Shadow (Light B - Correlated)
	if is_secondary_light_active:
		_draw_shadow_ellipse(local_b, SHADOW_COLOR_SECONDARY, 10.0, 3.2)
		
		# Floor optical interference / subtle reflection between the two shadows
		if is_anomaly_active:
			var mid_point := (local_a + local_b) * 0.5
			draw_circle(mid_point, 5.0, FLOOR_REFLECTION_CYAN)


func _draw_shadow_ellipse(pos: Vector2, color: Color, radius_x: float, radius_y: float) -> void:
	var pts := PackedVector2Array()
	var segments := 16
	for i in range(segments):
		var angle := float(i) * (TAU / float(segments))
		var pt := pos + Vector2(cos(angle) * radius_x, sin(angle) * radius_y)
		pts.append(pt)
	
	# Soft outer rim + core fill
	draw_colored_polygon(pts, color)
	var inner_pts := PackedVector2Array()
	for i in range(segments):
		var angle := float(i) * (TAU / float(segments))
		var pt := pos + Vector2(cos(angle) * (radius_x * 0.6), sin(angle) * (radius_y * 0.6))
		inner_pts.append(pt)
	draw_colored_polygon(inner_pts, Color(color.r, color.g, color.b, color.a * 0.6))
