class_name CinematicCamera
extends Camera2D

signal chamber_changed(from_index: int, to_index: int)

@export var target: Node2D
@export var view_size := Vector2(640.0, 360.0)
@export var smooth_speed := 6.0
@export var lead_distance := 20.0
@export var lead_speed := 4.0

var chamber_bounds: Array[Rect2] = []
var active_chamber_index: int = 0
var _target_center := Vector2(320.0, 180.0)
var _current_lead := Vector2.ZERO
var _shake_intensity := 0.0
var _shake_decay := 4.0
var _shake_offset := Vector2.ZERO


func _ready() -> void:
	# Ensure camera settings align with the 640x360 pixel-perfect specification
	anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	enabled = true
	position_smoothing_enabled = false # We handle custom cinematic smoothing


func setup_chambers(bounds: Array[Rect2]) -> void:
	chamber_bounds = bounds
	if not chamber_bounds.is_empty():
		set_chamber(0, true)


func set_chamber(index: int, immediate: bool = false) -> void:
	if index < 0 or index >= chamber_bounds.size():
		return

	var prev_index := active_chamber_index
	active_chamber_index = index
	var rect := chamber_bounds[index]
	_target_center = rect.position + rect.size * 0.5

	if immediate:
		global_position = _target_center
		_current_lead = Vector2.ZERO
	
	if prev_index != active_chamber_index:
		chamber_changed.emit(prev_index, active_chamber_index)


func get_active_chamber_rect() -> Rect2:
	if active_chamber_index >= 0 and active_chamber_index < chamber_bounds.size():
		return chamber_bounds[active_chamber_index]
	return Rect2(Vector2.ZERO, view_size)


func add_trauma(amount: float) -> void:
	_shake_intensity = clampf(_shake_intensity + amount, 0.0, 1.0)


func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		_update_chamber_from_target()
		_update_lead(delta)

	_update_shake(delta)

	# Smooth camera position toward target chamber center with lead and shake
	var desired_pos := _target_center + _current_lead
	global_position = global_position.lerp(desired_pos, 1.0 - exp(-smooth_speed * delta))
	offset = _shake_offset


func _update_chamber_from_target() -> void:
	var target_pos := target.global_position
	for i in range(chamber_bounds.size()):
		var rect := chamber_bounds[i]
		# Check if target is inside this chamber horizontally
		if target_pos.x >= rect.position.x and target_pos.x < rect.end.x:
			if i != active_chamber_index:
				set_chamber(i, false)
			break


func _update_lead(delta: float) -> void:
	var target_vel := Vector2.ZERO
	if target is CharacterBody2D:
		target_vel = (target as CharacterBody2D).velocity

	var desired_lead := Vector2.ZERO
	if absf(target_vel.x) > 10.0:
		desired_lead.x = signf(target_vel.x) * lead_distance

	_current_lead = _current_lead.lerp(desired_lead, 1.0 - exp(-lead_speed * delta))

	# Clamp so camera frame never extends outside the current chamber boundary
	if active_chamber_index >= 0 and active_chamber_index < chamber_bounds.size():
		var rect := chamber_bounds[active_chamber_index]
		var half_view := view_size * 0.5
		var min_x := rect.position.x + half_view.x
		var max_x := rect.end.x - half_view.x
		var clamped_target_x := clampf(_target_center.x + _current_lead.x, min_x, max_x)
		_current_lead.x = clamped_target_x - _target_center.x


func _update_shake(delta: float) -> void:
	if _shake_intensity > 0.001:
		_shake_intensity = maxf(0.0, _shake_intensity - _shake_decay * delta)
		var shake_power := _shake_intensity * _shake_intensity
		var max_offset := 4.0 * shake_power
		_shake_offset = Vector2(
			randf_range(-max_offset, max_offset),
			randf_range(-max_offset, max_offset)
		)
	else:
		_shake_intensity = 0.0
		_shake_offset = Vector2.ZERO
