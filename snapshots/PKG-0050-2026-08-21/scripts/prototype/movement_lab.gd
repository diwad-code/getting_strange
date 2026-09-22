extends Node2D

const VIEW_SIZE := Vector2(640.0, 360.0)
const BACKGROUND := Color("071018")
const GRID := Color("162832")
const PLATFORM := Color("263943")
const PLATFORM_EDGE := Color("66747a")
const ANCHOR := Color("63d8d2")
const THREAT := Color("d45252")
const PROFILE_ARGUMENT := "--movement-profile="
const PROFILE_CHECK_ARGUMENT := "--profile-check"

@onready var player: PrototypePlayer = $Player
@onready var geometry: Node2D = $Geometry
@onready var goal: Area2D = $Goal

var _spawn_position := Vector2.ZERO
var _goal_reached := false


func _ready() -> void:
	if not _configure_movement_profile():
		return
	_spawn_position = player.global_position
	queue_redraw()

	if OS.get_cmdline_user_args().has(PROFILE_CHECK_ARGUMENT):
		call_deferred("_finish_profile_check")


func _configure_movement_profile() -> bool:
	var selected_id := MovementProfileCatalog.DEFAULT_PROFILE_ID
	var profile_argument_seen := false

	for argument in OS.get_cmdline_user_args():
		if argument == "--movement-profile":
			return _reject_profile("missing value; use --movement-profile=A, B or C")
		if not argument.begins_with(PROFILE_ARGUMENT):
			continue
		if profile_argument_seen:
			return _reject_profile("profile was provided more than once")

		profile_argument_seen = true
		selected_id = MovementProfileCatalog.normalize_profile_id(
			argument.trim_prefix(PROFILE_ARGUMENT)
		)

	var selected_profile := MovementProfileCatalog.get_profile(selected_id)
	if selected_profile == null:
		return _reject_profile(
			"unknown profile '%s'; valid profiles are A, B and C" % selected_id
		)

	player.apply_movement_profile(selected_profile)
	print("MOVEMENT PROFILE: %s" % selected_id)
	return true


func _reject_profile(reason: String) -> bool:
	push_error("MOVEMENT PROFILE ERROR: " + reason)
	get_tree().quit(2)
	return false


func _finish_profile_check() -> void:
	print("MOVEMENT PROFILE CHECK PASS")
	get_tree().quit(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart") and not event.is_echo():
		_respawn()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed(&"pause") and not event.is_echo():
		get_tree().quit()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), BACKGROUND)

	for x in range(0, 641, 32):
		draw_line(Vector2(x, 0), Vector2(x, 360), GRID, 1.0)
	for y in range(8, 361, 32):
		draw_line(Vector2(0, y), Vector2(640, y), GRID, 1.0)

	# Misregistered lines at the exit hint at the future reality mechanic.
	draw_line(Vector2(552, 40), Vector2(552, 320), Color(0.25, 0.9, 0.84, 0.22), 2.0)
	draw_line(Vector2(556, 40), Vector2(556, 320), Color(0.85, 0.25, 0.32, 0.18), 1.0)

	for block in geometry.get_children():
		var collision := block.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if collision == null or not collision.shape is RectangleShape2D:
			continue
		var rectangle := collision.shape as RectangleShape2D
		var bounds := Rect2(block.position - rectangle.size * 0.5, rectangle.size)
		draw_rect(bounds, PLATFORM)
		draw_line(bounds.position, bounds.position + Vector2(bounds.size.x, 0.0), PLATFORM_EDGE, 2.0)

	var goal_color := ANCHOR if not _goal_reached else Color.WHITE
	draw_rect(Rect2(goal.position + Vector2(-10.0, -34.0), Vector2(20.0, 42.0)), Color(goal_color, 0.16), true)
	draw_line(goal.position + Vector2(-10.0, 8.0), goal.position + Vector2(-10.0, -34.0), goal_color, 2.0)
	draw_line(goal.position + Vector2(10.0, 8.0), goal.position + Vector2(10.0, -34.0), goal_color, 2.0)
	draw_line(goal.position + Vector2(-10.0, -34.0), goal.position + Vector2(10.0, -34.0), goal_color, 2.0)

	# The gap is readable as danger without a HUD or tutorial label.
	draw_line(Vector2(376, 350), Vector2(420, 350), THREAT, 1.0)
	draw_line(Vector2(504, 350), Vector2(556, 350), THREAT, 1.0)


func _respawn() -> void:
	_goal_reached = false
	player.reset_to(_spawn_position)
	queue_redraw()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == player:
		_respawn()


func _on_goal_body_entered(body: Node2D) -> void:
	if body == player and not _goal_reached:
		_goal_reached = true
		queue_redraw()
