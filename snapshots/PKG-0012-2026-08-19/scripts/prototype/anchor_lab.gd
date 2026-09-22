class_name AnchorLab
extends Node2D

const VIEW_SIZE := Vector2(640.0, 360.0)
const COLOR_BACKGROUND := Color("071018")
const COLOR_GRID := Color("162832")
const COLOR_PLATFORM := Color("263943")
const COLOR_PLATFORM_EDGE := Color("66747a")
const COLOR_ANCHOR := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_TEXT_MUTED := Color("788791")
const COLOR_AMBER := Color("d39a62")

@onready var player: PrototypePlayer = $Player
@onready var geometry: Node2D = $Geometry
@onready var anchorables: Node2D = $Anchorables
@onready var goal: Area2D = $Goal
@onready var kill_zone: Area2D = $KillZone

var current_reality: AnchorableObject.RealityState = AnchorableObject.RealityState.STATE_A
var active_anchor: AnchorableObject = null
var _spawn_position := Vector2(48.0, 296.0)
var _goal_reached := false
var _wave_progress := -1.0
var _wave_tween: Tween


func _ready() -> void:
	if player:
		_spawn_position = player.global_position

	# Connect anchorable signals
	for child in anchorables.get_children():
		if child is AnchorableObject:
			var obj := child as AnchorableObject
			obj.anchor_state_changed.connect(_on_object_anchor_changed.bind(obj))

	queue_redraw()


func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	# Update proximity for all anchorable objects
	for child in anchorables.get_children():
		if child is AnchorableObject:
			(child as AnchorableObject).update_player_distance(player.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"restart") and not event.is_echo():
		_respawn()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed(&"pause") and not event.is_echo():
		get_tree().quit()
	elif event.is_action_pressed(&"interact") and not event.is_echo():
		_handle_player_anchor_toggle()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed(&"trigger_correction") and not event.is_echo():
		trigger_correction_pulse()
		get_viewport().set_input_as_handled()


func _handle_player_anchor_toggle() -> void:
	if not is_instance_valid(player):
		return

	var closest_obj: AnchorableObject = null
	var closest_dist := 999999.0

	for child in anchorables.get_children():
		if child is AnchorableObject:
			var obj := child as AnchorableObject
			var dist := obj.global_position.distance_to(player.global_position)
			if dist <= obj.interaction_radius and dist < closest_dist:
				closest_dist = dist
				closest_obj = obj

	if closest_obj != null:
		if closest_obj.is_anchored:
			set_active_anchor(null)
		else:
			set_active_anchor(closest_obj)


func set_active_anchor(obj: AnchorableObject) -> void:
	if active_anchor == obj:
		return

	# Release previous anchor (enforcing single-anchor rule)
	if is_instance_valid(active_anchor) and active_anchor != obj:
		active_anchor.set_anchored(false)

	active_anchor = obj

	if is_instance_valid(active_anchor):
		active_anchor.set_anchored(true)

	queue_redraw()


func _on_object_anchor_changed(is_anchored: bool, obj: AnchorableObject) -> void:
	if is_anchored:
		if active_anchor != null and active_anchor != obj:
			active_anchor.set_anchored(false)
		active_anchor = obj
	elif active_anchor == obj:
		active_anchor = null
	queue_redraw()


func trigger_correction_pulse() -> void:
	var next_state := (
		AnchorableObject.RealityState.STATE_B
		if current_reality == AnchorableObject.RealityState.STATE_A
		else AnchorableObject.RealityState.STATE_A
	)
	current_reality = next_state

	# Animate visual correction pulse line across the screen
	if _wave_tween and _wave_tween.is_valid():
		_wave_tween.kill()

	_wave_progress = 0.0
	_wave_tween = create_tween()
	_wave_tween.tween_property(self, "_wave_progress", 1.0, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_wave_tween.tween_callback(func(): _wave_progress = -1.0; queue_redraw())

	# Apply reality shift to all anchorable objects
	for child in anchorables.get_children():
		if child is AnchorableObject:
			var obj := child as AnchorableObject
			obj.apply_reality_shift(next_state, true)

	queue_redraw()


func _respawn() -> void:
	_goal_reached = false
	current_reality = AnchorableObject.RealityState.STATE_A
	set_active_anchor(null)

	for child in anchorables.get_children():
		if child is AnchorableObject:
			var obj := child as AnchorableObject
			obj.is_anchored = false
			obj.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)

	if is_instance_valid(player):
		player.reset_to(_spawn_position)
	queue_redraw()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == player:
		_respawn()


func _on_goal_body_entered(body: Node2D) -> void:
	if body == player and not _goal_reached:
		_goal_reached = true
		queue_redraw()


func _draw() -> void:
	# 1. Background & Clinical Grid
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)

	for x in range(0, 641, 32):
		draw_line(Vector2(x, 0), Vector2(x, 360), COLOR_GRID, 1.0)
	for y in range(8, 361, 32):
		draw_line(Vector2(0, y), Vector2(640, y), COLOR_GRID, 1.0)

	# 2. Chamber Separators (subtle institutional markers)
	draw_line(Vector2(260, 20), Vector2(260, 340), Color(COLOR_GRID, 0.6), 1.0)
	draw_line(Vector2(430, 20), Vector2(430, 340), Color(COLOR_GRID, 0.6), 1.0)

	# 3. Static Platforms
	if geometry:
		for block in geometry.get_children():
			var collision := block.get_node_or_null("CollisionShape2D") as CollisionShape2D
			if collision == null or not collision.shape is RectangleShape2D:
				continue
			var rectangle := collision.shape as RectangleShape2D
			var bounds := Rect2(block.position - rectangle.size * 0.5, rectangle.size)
			draw_rect(bounds, COLOR_PLATFORM)
			draw_line(bounds.position, bounds.position + Vector2(bounds.size.x, 0.0), COLOR_PLATFORM_EDGE, 2.0)

	# 4. Status Bar & Laboratory Identifiers
	var reality_color := COLOR_ANCHOR if current_reality == AnchorableObject.RealityState.STATE_A else COLOR_CORRECTION
	var reality_name := "STATE A [LOCAL PROTOTYPE]" if current_reality == AnchorableObject.RealityState.STATE_A else "STATE B [UCP CONSENSUS]"
	draw_circle(Vector2(24, 24), 4.0, reality_color)
	draw_line(Vector2(16, 36), Vector2(240, 36), Color(reality_color, 0.4), 1.0)

	# Anchor status indicator (top right)
	var anchor_color := COLOR_ANCHOR if active_anchor != null else COLOR_TEXT_MUTED
	var anchor_text := "ACTIVE ANCHOR: 1/1" if active_anchor != null else "ACTIVE ANCHOR: 0/1"
	draw_rect(Rect2(Vector2(500, 16), Vector2(120, 18)), Color(COLOR_GRID, 0.8), true)
	draw_rect(Rect2(Vector2(500, 16), Vector2(120, 18)), Color(anchor_color, 0.6), false, 1.0)
	draw_circle(Vector2(512, 25), 3.0, anchor_color)

	# 5. Goal Zone
	if goal:
		var goal_color := COLOR_ANCHOR if not _goal_reached else Color.WHITE
		draw_rect(Rect2(goal.position + Vector2(-12.0, -32.0), Vector2(24.0, 44.0)), Color(goal_color, 0.18), true)
		draw_line(goal.position + Vector2(-12.0, 12.0), goal.position + Vector2(-12.0, -32.0), goal_color, 2.0)
		draw_line(goal.position + Vector2(12.0, 12.0), goal.position + Vector2(12.0, -32.0), goal_color, 2.0)
		draw_line(goal.position + Vector2(-12.0, -32.0), goal.position + Vector2(12.0, -32.0), goal_color, 2.0)

	# 6. Correction Pulse Sweep Wave
	if _wave_progress >= 0.0:
		var wave_x := _wave_progress * 640.0
		var wave_col := Color(COLOR_CORRECTION, (1.0 - _wave_progress) * 0.8)
		draw_line(Vector2(wave_x, 0), Vector2(wave_x, 360), wave_col, 3.0)
		draw_rect(Rect2(Vector2(wave_x - 16, 0), Vector2(32, 360)), Color(wave_col, 0.15), true)
