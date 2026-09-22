class_name MemoryResonancePoint
extends Area2D

## Memory Resonance Point for Getting Strange.
## Represents narrative and procedural props in the game world that respond
## to Lena's presence and action without intrusive floating HUD text.
## Conforms to VISUAL_DESIGN.md (muted amber #D39A62, grey sage #A8B2AC, cyan #75C7C3).

enum PropType {
	PHOTOGRAPH = 0,
	CIRCUIT_BREAKER = 1,
	VACUUM_GAUGE = 2,
	CHAMBER_CONSOLE = 3,
	DOCUMENT_CLIPBOARD = 4,
}

signal resonance_triggered(id: String, prop_type: int)
signal state_changed(is_active: bool)

const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("263943")
const COLOR_CYAN := Color("75c7c3")
const COLOR_BACKGROUND := Color("182126")

@export var resonance_id: String = "prop_01"
@export var prop_type: PropType = PropType.PHOTOGRAPH
@export var prop_title: String = "Fotografia"
@export var prop_subtitle: String = "Sterownia IKP"
@export var interaction_radius: float = 38.0
@export var is_activated: bool = false:
	set(value):
		if is_activated != value:
			is_activated = value
			state_changed.emit(is_activated)
			queue_redraw()

@export var is_one_shot: bool = false

var is_player_in_range: bool = false:
	set(value):
		if is_player_in_range != value:
			is_player_in_range = value
			queue_redraw()

var _pulse_phase: float = 0.0
var _resonance_flash: float = 0.0
var _audio_player: AudioStreamPlayer2D
var _memory_sound: AudioStreamWAV
var _switch_sound: AudioStreamWAV
var _particles: CPUParticles2D
var _collision_shape: CollisionShape2D
var _circle_shape: CircleShape2D


func _ready() -> void:
	_setup_collision()
	_setup_audio()
	_setup_particles()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	queue_redraw()


func _setup_collision() -> void:
	_collision_shape = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if _collision_shape == null:
		_collision_shape = CollisionShape2D.new()
		_collision_shape.name = "CollisionShape2D"
		add_child(_collision_shape)
	
	if _collision_shape.shape is CircleShape2D:
		_circle_shape = _collision_shape.shape as CircleShape2D
	else:
		_circle_shape = CircleShape2D.new()
		_collision_shape.shape = _circle_shape
	
	_circle_shape.radius = interaction_radius


func _setup_audio() -> void:
	_memory_sound = ProceduralAudio.create_memory_resonance_sound()
	_switch_sound = ProceduralAudio.create_switch_toggle_sound()
	
	_audio_player = get_node_or_null("AudioPlayer2D") as AudioStreamPlayer2D
	if _audio_player == null:
		_audio_player = AudioStreamPlayer2D.new()
		_audio_player.name = "AudioPlayer2D"
		_audio_player.max_distance = 500.0
		_audio_player.bus = &"Master"
		add_child(_audio_player)


func _setup_particles() -> void:
	_particles = get_node_or_null("ResonanceParticles") as CPUParticles2D
	if _particles == null:
		_particles = CPUParticles2D.new()
		_particles.name = "ResonanceParticles"
		_particles.emitting = false
		_particles.one_shot = true
		_particles.amount = 14
		_particles.lifetime = 0.65
		_particles.explosiveness = 0.7
		_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		_particles.emission_rect_extents = Vector2(16.0, 16.0)
		_particles.direction = Vector2(0.0, -1.0)
		_particles.spread = 45.0
		_particles.gravity = Vector2(0.0, -25.0)
		_particles.initial_velocity_min = 20.0
		_particles.initial_velocity_max = 45.0
		_particles.scale_amount_min = 1.5
		_particles.scale_amount_max = 3.0
		_particles.color = COLOR_AMBER
		add_child(_particles)


func _process(delta: float) -> void:
	_pulse_phase += delta * 2.8
	if _resonance_flash > 0.0:
		_resonance_flash = maxf(0.0, _resonance_flash - delta * 2.2)
		queue_redraw()
	elif is_player_in_range:
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if not is_player_in_range:
		return
	if event.is_action_pressed(&"interact"):
		trigger_interaction()
		get_viewport().set_input_as_handled()


func trigger_interaction() -> void:
	if is_one_shot and is_activated:
		return
	
	if prop_type == PropType.CIRCUIT_BREAKER:
		is_activated = not is_activated
		if _audio_player and _switch_sound:
			_audio_player.stream = _switch_sound
			_audio_player.pitch_scale = 1.1 if is_activated else 0.9
			_audio_player.play()
	else:
		is_activated = true
		if _audio_player and _memory_sound:
			_audio_player.stream = _memory_sound
			_audio_player.pitch_scale = 1.0 + randf_range(-0.02, 0.02)
			_audio_player.play()
	
	_resonance_flash = 1.0
	if _particles:
		_particles.restart()
		_particles.emitting = true
	
	resonance_triggered.emit(resonance_id, int(prop_type))
	queue_redraw()


func _on_body_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = true


func _on_body_exited(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_player_in_range = false


func _draw() -> void:
	match prop_type:
		PropType.PHOTOGRAPH:
			_draw_photograph()
		PropType.CIRCUIT_BREAKER:
			_draw_circuit_breaker()
		PropType.VACUUM_GAUGE:
			_draw_vacuum_gauge()
		PropType.CHAMBER_CONSOLE:
			_draw_chamber_console()
		PropType.DOCUMENT_CLIPBOARD:
			_draw_document_clipboard()
	
	# Proximity & Interaction reticule (Subtle in-world indicator)
	if is_player_in_range or _resonance_flash > 0.0:
		_draw_in_world_reticule()


func _draw_photograph() -> void:
	# Framed photograph on desk: 24x18 px
	# Asymmetrical composition per FULL_STORY 01: Lena & Jakub on left, right third empty
	var frame_rect := Rect2(-12.0, -10.0, 24.0, 20.0)
	var photo_rect := Rect2(-10.0, -8.0, 20.0, 16.0)
	
	# Wood/dark steel frame
	draw_rect(frame_rect, Color("20262b"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Photographic paper background (aged monochrome silver gelatin)
	var photo_bg := Color("4b585e") if not is_activated else Color("5a6970")
	draw_rect(photo_rect, photo_bg)
	
	# Silhouettes of teenage Lena & Jakub on left 2/3
	# Jakub (slightly taller, 13 years earlier / age 20)
	draw_rect(Rect2(-8.0, -3.0, 5.0, 9.0), Color("182126"))
	draw_circle(Vector2(-5.5, -5.0), 2.2, Color("182126"))
	
	# Lena (left side)
	draw_rect(Rect2(-3.0, -1.0, 4.0, 7.0), Color("243038"))
	draw_circle(Vector2(-1.0, -3.5), 1.8, Color("243038"))
	
	# Empty right third (negative space #composition-negative-space per canon)
	draw_line(Vector2(2.0, -8.0), Vector2(2.0, 8.0), Color(0.1, 0.15, 0.18, 0.25), 1.0)
	
	# Subtle glass reflection
	draw_line(Vector2(-9.0, -7.0), Vector2(3.0, 6.0), Color(1.0, 1.0, 1.0, 0.18), 1.0)
	
	# Support stand behind frame
	draw_line(Vector2(0.0, 10.0), Vector2(4.0, 13.0), Color("182126"), 2.0)


func _draw_circuit_breaker() -> void:
	# Industrial DIN rail mounted toggle switch: 18x26 px
	var base_rect := Rect2(-9.0, -13.0, 18.0, 26.0)
	
	# Backplate
	draw_rect(base_rect, COLOR_DARK_STEEL)
	draw_rect(base_rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Screw fixings
	draw_circle(Vector2(0.0, -10.0), 1.2, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(0.0, 10.0), 1.2, COLOR_INFRASTRUCTURE)
	
	# Switch slot
	draw_rect(Rect2(-4.0, -6.0, 8.0, 12.0), Color("12191e"))
	
	# Toggle lever
	var lever_y := -4.0 if is_activated else 4.0
	var lever_col := COLOR_CYAN if is_activated else Color("788791")
	draw_rect(Rect2(-3.0, lever_y - 2.0, 6.0, 4.0), lever_col)
	draw_line(Vector2(0.0, lever_y), Vector2(0.0, 0.0), COLOR_INFRASTRUCTURE, 1.5)
	
	# Status Indicator Diode
	var diode_col := COLOR_CYAN if is_activated else Color(0.4, 0.15, 0.15, 0.7)
	draw_circle(Vector2(0.0, -2.0), 2.0, diode_col)


func _draw_vacuum_gauge() -> void:
	# Circular vacuum manometer: radius 12 px
	var center := Vector2.ZERO
	var radius := 11.0
	
	# Housing
	draw_circle(center, radius + 2.0, COLOR_DARK_STEEL)
	draw_circle(center, radius + 2.0, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Gauge face
	draw_circle(center, radius, Color("141b20"))
	
	# Calibration tick marks
	for i in range(7):
		var angle := -PI * 0.75 + float(i) * (PI * 1.5 / 6.0)
		var p1 := center + Vector2(cos(angle), sin(angle)) * (radius - 3.0)
		var p2 := center + Vector2(cos(angle), sin(angle)) * (radius - 1.0)
		var tick_col := COLOR_CYAN if i >= 4 else COLOR_INFRASTRUCTURE
		draw_line(p1, p2, tick_col, 1.0)
	
	# Needle
	var needle_angle := PI * 0.45 if is_activated else -PI * 0.65
	var needle_end := center + Vector2(cos(needle_angle), sin(needle_angle)) * (radius - 2.5)
	var needle_col := COLOR_AMBER if is_activated else COLOR_INFRASTRUCTURE
	draw_line(center, needle_end, needle_col, 1.5)
	draw_circle(center, 2.0, COLOR_DARK_STEEL)


func _draw_chamber_console() -> void:
	# Terminal console with cathode readout & keylock: 26x32 px
	var rect := Rect2(-13.0, -16.0, 26.0, 32.0)
	draw_rect(rect, COLOR_DARK_STEEL)
	draw_rect(rect, COLOR_INFRASTRUCTURE, false, 1.0)
	
	# Screen bezel & CRT phosphor display
	var screen_rect := Rect2(-10.0, -13.0, 20.0, 14.0)
	draw_rect(screen_rect, Color("0e161a"))
	draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Phosphor text lines on screen
	var scr_col := COLOR_CYAN if is_activated else COLOR_AMBER
	draw_line(Vector2(-8.0, -10.0), Vector2(4.0, -10.0), scr_col * 0.9, 1.0)
	draw_line(Vector2(-8.0, -7.0), Vector2(7.0, -7.0), scr_col * 0.7, 1.0)
	draw_line(Vector2(-8.0, -4.0), Vector2(-1.0, -4.0), scr_col * 0.8, 1.0)
	
	# Keyway & Status Lamps
	draw_rect(Rect2(-8.0, 5.0, 16.0, 6.0), Color("12191e"))
	var led1 := COLOR_CYAN if is_activated else Color(0.2, 0.4, 0.4)
	var led2 := COLOR_AMBER if is_activated else Color(0.4, 0.3, 0.1)
	draw_circle(Vector2(-4.0, 8.0), 1.5, led1)
	draw_circle(Vector2(4.0, 8.0), 1.5, led2)


func _draw_document_clipboard() -> void:
	# Checklist clipboard: 16x22 px
	var rect := Rect2(-8.0, -11.0, 16.0, 22.0)
	draw_rect(rect, Color("423223"))
	
	# Paper sheets
	var paper_rect := Rect2(-7.0, -9.0, 14.0, 19.0)
	draw_rect(paper_rect, Color("c2ba9b"))
	
	# Metal spring clamp at top
	draw_rect(Rect2(-4.0, -12.0, 8.0, 3.0), COLOR_INFRASTRUCTURE)
	
	# Checklist lines
	var line_col := Color("4b4637")
	for i in range(4):
		var y := -6.0 + float(i) * 4.0
		draw_rect(Rect2(-5.0, y - 1.0, 2.0, 2.0), COLOR_CYAN if (is_activated or i < 2) else line_col)
		draw_line(Vector2(-1.0, y), Vector2(5.0, y), line_col, 1.0)


func _draw_in_world_reticule() -> void:
	var pulse := sin(_pulse_phase) * 0.5 + 0.5
	var alpha := clampf((0.35 + pulse * 0.4) if is_player_in_range else 0.0 + _resonance_flash * 0.6, 0.0, 1.0)
	var glow_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, alpha * 0.35)
	var ring_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, alpha * 0.85)
	
	# Soft warm filament glow disc
	draw_circle(Vector2.ZERO, 16.0 + pulse * 3.0, glow_col)
	
	# Corner reticule brackets indicating focus / measurement point
	var s: float = 14.0 + pulse * 1.5
	var l: float = 3.5
	# Top-Left
	draw_line(Vector2(-s, -s), Vector2(-s + l, -s), ring_col, 1.0)
	draw_line(Vector2(-s, -s), Vector2(-s, -s + l), ring_col, 1.0)
	# Top-Right
	draw_line(Vector2(s, -s), Vector2(s - l, -s), ring_col, 1.0)
	draw_line(Vector2(s, -s), Vector2(s, -s + l), ring_col, 1.0)
	# Bottom-Left
	draw_line(Vector2(-s, s), Vector2(-s + l, s), ring_col, 1.0)
	draw_line(Vector2(-s, s), Vector2(-s, s - l), ring_col, 1.0)
	# Bottom-Right
	draw_line(Vector2(s, s), Vector2(s - l, s), ring_col, 1.0)
	draw_line(Vector2(s, s), Vector2(s, s - l), ring_col, 1.0)
	
	# Minimal filament indicator dot above prop when in range
	if is_player_in_range:
		var dot_y := -s - 5.0 - pulse * 1.5
		draw_circle(Vector2(0.0, dot_y), 1.6, COLOR_AMBER)
