class_name MovementProfile
extends Resource

@export_category("Horizontal movement")
@export var move_speed: float = 96.0
@export var ground_acceleration: float = 900.0
@export var ground_deceleration: float = 1100.0
@export var air_acceleration: float = 480.0
@export var air_deceleration: float = 480.0

@export_category("Jump")
@export var jump_velocity: float = -252.0
@export var gravity: float = 720.0
@export var coyote_time: float = 0.10
@export var jump_buffer_time: float = 0.15
@export_range(0.1, 0.9) var jump_release_multiplier: float = 0.45
@export var fall_gravity_multiplier: float = 1.35
@export var max_fall_speed: float = 360.0
