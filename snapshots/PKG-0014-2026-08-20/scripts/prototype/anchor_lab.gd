class_name AnchorLab
extends Node2D

const VIEW_SIZE := Vector2(640.0, 360.0)
const CHAMBER_COUNT := 3
const TOTAL_WIDTH := 1920.0

const COLOR_BACKGROUND := Color("071018")
const COLOR_GRID := Color("162832")
const COLOR_PLATFORM := Color("263943")
const COLOR_PLATFORM_EDGE := Color("66747a")
const COLOR_ANCHOR := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_TEXT_MUTED := Color("788791")
const COLOR_AMBER := Color("d39a62")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var anchorables: Node2D = $Anchorables
@onready var goal: Area2D = $Goal
@onready var kill_zone: Area2D = $KillZone

var current_reality: AnchorableObject.RealityState = AnchorableObject.RealityState.STATE_A
var active_anchor: AnchorableObject = null

var chamber_bounds: Array[Rect2] = []
var chamber_checkpoints: Array[Vector2] = [
	Vector2(60.0, 296.0),
	Vector2(680.0, 296.0),
	Vector2(1320.0, 176.0)
]

var _spawn_position := Vector2(60.0, 296.0)
var _active_chamber_index: int = 0
var _goal_reached := false
var _wave_progress := -1.0
var _wave_chamber_index := 0
var _wave_tween: Tween

var _correction_player: AudioStreamPlayer
var _goal_player: AudioStreamPlayer
var _correction_sfx: AudioStreamWAV
var _goal_sfx: AudioStreamWAV

# Pulse timer for physical apparatus indicator lamps
var _beacon_phase := 0.0


func _ready() -> void:
	_setup_chambers()
	_setup_camera()
	_setup_audio()

	if player:
		_spawn_position = player.global_position

	# Connect anchorable signals
	if anchorables:
		for child in anchorables.get_children():
			if child is AnchorableObject:
				var obj := child as AnchorableObject
				obj.anchor_state_changed.connect(_on_object_anchor_changed.bind(obj))

	queue_redraw()


func _setup_chambers() -> void:
	chamber_bounds.clear()
	for i in range(CHAMBER_COUNT):
		var x_pos := float(i) * VIEW_SIZE.x
		chamber_bounds.append(Rect2(Vector2(x_pos, 0.0), VIEW_SIZE))


func _setup_camera() -> void:
	if not is_instance_valid(camera):
		camera = CinematicCamera.new()
		camera.name = "Camera"
		add_child(camera)

	camera.target = player
	camera.setup_chambers(chamber_bounds)
	camera.chamber_changed.connect(_on_camera_chamber_changed)


func _setup_audio() -> void:
	_correction_player = AudioStreamPlayer.new()
	_correction_player.name = "CorrectionAudioPlayer"
	_correction_player.bus = &"Master"
	add_child(_correction_player)
	_correction_sfx = ProceduralAudio.create_correction_pulse_sound()

	_goal_player = AudioStreamPlayer.new()
	_goal_player.name = "GoalAudioPlayer"
	_goal_player.bus = &"Master"
	add_child(_goal_player)
	_goal_sfx = ProceduralAudio.create_goal_sound()


func _physics_process(delta: float) -> void:
	_beacon_phase += delta * 2.5
	if _beacon_phase > TAU:
		_beacon_phase -= TAU

	if not is_instance_valid(player):
		return

	# Update active chamber tracking based on player position
	var px := player.global_position.x
	var current_idx := clampi(int(px / VIEW_SIZE.x), 0, CHAMBER_COUNT - 1)
	if current_idx != _active_chamber_index:
		_active_chamber_index = current_idx

	# Update proximity for all anchorable objects
	if anchorables:
		for child in anchorables.get_children():
			if child is AnchorableObject:
				(child as AnchorableObject).update_player_distance(player.global_position)

	queue_redraw()


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
	if not is_instance_valid(player) or not anchorables:
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

	# Release previous anchor (enforcing single-anchor exclusivity rule)
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


func _on_camera_chamber_changed(from_idx: int, to_idx: int) -> void:
	_active_chamber_index = to_idx
	queue_redraw()


func trigger_correction_pulse() -> void:
	var next_state := (
		AnchorableObject.RealityState.STATE_B
		if current_reality == AnchorableObject.RealityState.STATE_A
		else AnchorableObject.RealityState.STATE_A
	)
	current_reality = next_state

	# Play deep institutional consensus sound
	if _correction_player and _correction_sfx:
		_correction_player.stream = _correction_sfx
		_correction_player.play()

	# Add camera shake trauma on correction wave impact
	if camera:
		camera.add_trauma(0.35)

	# Animate visual correction pulse line across the active chamber
	if _wave_tween and _wave_tween.is_valid():
		_wave_tween.kill()

	_wave_progress = 0.0
	_wave_chamber_index = _active_chamber_index
	_wave_tween = create_tween()
	_wave_tween.tween_property(self, "_wave_progress", 1.0, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_wave_tween.tween_callback(func(): _wave_progress = -1.0; queue_redraw())

	# Apply reality shift to all anchorable objects
	if anchorables:
		for child in anchorables.get_children():
			if child is AnchorableObject:
				var obj := child as AnchorableObject
				obj.apply_reality_shift(next_state, true)

	queue_redraw()


func _respawn() -> void:
	_goal_reached = false
	current_reality = AnchorableObject.RealityState.STATE_A
	set_active_anchor(null)

	if anchorables:
		for child in anchorables.get_children():
			if child is AnchorableObject:
				var obj := child as AnchorableObject
				obj.is_anchored = false
				obj.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)

	# Respawn at active chamber's entrance checkpoint
	var respawn_pos := _spawn_position
	if _active_chamber_index >= 0 and _active_chamber_index < chamber_checkpoints.size():
		respawn_pos = chamber_checkpoints[_active_chamber_index]

	if is_instance_valid(player):
		player.reset_to(respawn_pos)
	if is_instance_valid(camera):
		camera.set_chamber(_active_chamber_index, true)

	queue_redraw()


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body == player:
		_respawn()


func _on_goal_body_entered(body: Node2D) -> void:
	if body == player and not _goal_reached:
		_goal_reached = true
		if _goal_player and _goal_sfx:
			_goal_player.stream = _goal_sfx
			_goal_player.play()
		queue_redraw()


func _draw() -> void:
	# 1. Background & Clinical Grid per chamber across total width
	draw_rect(Rect2(Vector2.ZERO, Vector2(TOTAL_WIDTH, VIEW_SIZE.y)), COLOR_BACKGROUND)

	for x in range(0, int(TOTAL_WIDTH) + 1, 32):
		draw_line(Vector2(x, 0), Vector2(x, VIEW_SIZE.y), COLOR_GRID, 1.0)
	for y in range(8, int(VIEW_SIZE.y) + 1, 32):
		draw_line(Vector2(0, y), Vector2(TOTAL_WIDTH, y), COLOR_GRID, 1.0)

	# 2. Chamber Portals / Structural Dividers (x = 640 and x = 1280)
	for chamber_idx in range(1, CHAMBER_COUNT):
		var sep_x := float(chamber_idx) * VIEW_SIZE.x
		# Institutional reinforced concrete archway borders
		draw_rect(Rect2(Vector2(sep_x - 8.0, 0.0), Vector2(16.0, 40.0)), COLOR_PLATFORM)
		draw_line(Vector2(sep_x - 8.0, 40.0), Vector2(sep_x + 8.0, 40.0), COLOR_PLATFORM_EDGE, 1.5)
		draw_line(Vector2(sep_x, 0.0), Vector2(sep_x, VIEW_SIZE.y), Color(COLOR_INFRASTRUCTURE, 0.25), 1.0)
		# Optical sensor diodes on archway
		draw_circle(Vector2(sep_x, 48.0), 2.5, Color(COLOR_ANCHOR, 0.7))

	# 3. Static Platforms Geometry
	if geometry:
		for block in geometry.get_children():
			var collision := block.get_node_or_null("CollisionShape2D") as CollisionShape2D
			if collision == null or not collision.shape is RectangleShape2D:
				continue
			var rectangle := collision.shape as RectangleShape2D
			var bounds := Rect2(block.position - rectangle.size * 0.5, rectangle.size)
			draw_rect(bounds, COLOR_PLATFORM)
			draw_line(bounds.position, bounds.position + Vector2(bounds.size.x, 0.0), COLOR_PLATFORM_EDGE, 2.0)
			# Concrete hatch markings on bottom edges
			draw_line(bounds.position + Vector2(0.0, bounds.size.y), bounds.end, Color(COLOR_GRID, 0.8), 1.0)

	# 4. Physical In-World Apparatus Consoles (no screen HUD!)
	_draw_in_world_apparatus_panels()

	# 5. Goal Zone / Measurement Airlock
	if goal:
		var goal_color := COLOR_ANCHOR if not _goal_reached else Color.WHITE
		var goal_alpha := 0.18 if not _goal_reached else 0.45
		var goal_rect := Rect2(goal.position + Vector2(-16.0, -35.0), Vector2(32.0, 70.0))
		draw_rect(goal_rect, Color(goal_color, goal_alpha), true)
		draw_line(goal_rect.position, goal_rect.position + Vector2(0.0, goal_rect.size.y), goal_color, 2.0)
		draw_line(goal_rect.position + Vector2(goal_rect.size.x, 0.0), goal_rect.end, goal_color, 2.0)
		draw_line(goal_rect.position, goal_rect.position + Vector2(goal_rect.size.x, 0.0), goal_color, 2.0)
		# Station measurement reticle
		draw_circle(goal.position, 4.0, goal_color)

	# 6. Correction Pulse Sweep Wave (sweeps active chamber)
	if _wave_progress >= 0.0 and _wave_chamber_index >= 0 and _wave_chamber_index < chamber_bounds.size():
		var ch_rect := chamber_bounds[_wave_chamber_index]
		var wave_x := ch_rect.position.x + _wave_progress * ch_rect.size.x
		var wave_alpha := (1.0 - _wave_progress * 0.7)
		var wave_col := Color(COLOR_CORRECTION, wave_alpha * 0.9)
		
		# Leading wave line
		draw_line(Vector2(wave_x, ch_rect.position.y), Vector2(wave_x, ch_rect.end.y), wave_col, 2.5)
		# Trailing institutional consensus field
		draw_rect(Rect2(Vector2(wave_x - 36.0, ch_rect.position.y), Vector2(36.0, ch_rect.size.y)), Color(COLOR_CORRECTION, wave_alpha * 0.12), true)
		draw_rect(Rect2(Vector2(wave_x - 10.0, ch_rect.position.y), Vector2(10.0, ch_rect.size.y)), Color(COLOR_CORRECTION, wave_alpha * 0.22), true)
		
		# Measurement grid ticks along sweep line
		for y in range(int(ch_rect.position.y) + 20, int(ch_rect.end.y), 40):
			draw_line(Vector2(wave_x - 4.0, y), Vector2(wave_x + 4.0, y), wave_col, 1.5)


func _draw_in_world_apparatus_panels() -> void:
	# Apparatus panels placed on chamber walls according to VISUAL_DESIGN.md section 6.3 & 7.1
	var panel_positions := [
		Vector2(100.0, 80.0),   # Chamber 1 (Nauka)
		Vector2(740.0, 70.0),   # Chamber 2 (Zastosowanie)
		Vector2(1380.0, 60.0)   # Chamber 3 (Komplikacja)
	]

	var reality_lamp_color := COLOR_ANCHOR if current_reality == AnchorableObject.RealityState.STATE_A else COLOR_CORRECTION
	var anchor_lamp_color := COLOR_ANCHOR if active_anchor != null else Color(COLOR_TEXT_MUTED, 0.3)
	var amber_pulse := 0.75 + 0.25 * sin(_beacon_phase)
	var amber_color := Color(COLOR_AMBER, amber_pulse)

	for i in range(panel_positions.size()):
		var base_pos: Vector2 = panel_positions[i]
		var is_active := (i == _active_chamber_index)

		# 1. Console metal backplate
		var panel_size := Vector2(120.0, 42.0)
		draw_rect(Rect2(base_pos, panel_size), Color(COLOR_GRID, 0.9), true)
		draw_rect(Rect2(base_pos, panel_size), Color(COLOR_INFRASTRUCTURE, 0.4 if not is_active else 0.8), false, 1.0)

		# 2. Institutional label line
		draw_line(base_pos + Vector2(6.0, 10.0), base_pos + Vector2(114.0, 10.0), Color(COLOR_INFRASTRUCTURE, 0.25), 1.0)

		# 3. Three Physical Status Lamps on the Panel:
		# Lamp 1: Observer / Presence Beacon (Amber)
		var lamp1_pos := base_pos + Vector2(20.0, 24.0)
		draw_circle(lamp1_pos, 4.0, amber_color if is_active else Color(COLOR_TEXT_MUTED, 0.2))
		draw_arc(lamp1_pos, 6.0, 0, TAU, 8, Color(COLOR_INFRASTRUCTURE, 0.5), 1.0)

		# Lamp 2: Reality Consensus State (Cyan for Local State A / Oxide Vermilion for State B)
		var lamp2_pos := base_pos + Vector2(60.0, 24.0)
		draw_circle(lamp2_pos, 4.0, reality_lamp_color)
		draw_arc(lamp2_pos, 6.0, 0, TAU, 8, Color(reality_lamp_color, 0.6), 1.0)

		# Lamp 3: Active Anchor Lock (Cyan when an anchorable object is held, dim otherwise)
		var lamp3_pos := base_pos + Vector2(100.0, 24.0)
		draw_circle(lamp3_pos, 4.0, anchor_lamp_color)
		draw_arc(lamp3_pos, 6.0, 0, TAU, 8, Color(anchor_lamp_color, 0.5), 1.0)
