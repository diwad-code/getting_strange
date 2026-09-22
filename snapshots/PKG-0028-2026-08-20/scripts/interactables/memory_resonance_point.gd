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
	DOOR_CARD_READER = 5,
	TWIN_CUPS = 6,
	DESK_TELEPHONE = 7,
	DUTY_ROSTER = 8,
	SECURITY_MONITOR = 9,
	UCP_NOTICE = 10,
	GUARD_INTERACTION = 11,
	ANACHRONISTIC_BILLBOARD = 12,
	MISSING_FLOOR_FACADE = 13,
	CROSSWALK_SIGNAL = 14,
	TRANSIT_SHELTER = 15,
	BUS_SPEAKER = 16,
	ELDERLY_PASSENGER = 17,
	GOLD_RING = 18,
	BUS_ROUTE_MAP = 19,
	TENANT_DIRECTORY = 20,
	MAILBOXES = 21,
	BLIND_STAIRS = 22,
	MARTA_INTERACTION = 23,
	STAIR_TIMER_SWITCH = 24,
	HALLWAY_COAT_RACK = 25,
	REFLECTED_PHOTOGRAPH = 26,
	BEAKER_PLANTER = 27,
	JAKUB_MEMENTO_TOOL = 28,
	CIPHER_DESK = 29,
	TEA_KETTLE = 30,
	BATHROOM_SINK = 31,
	BATHROOM_MIRROR = 32,
	SCRATCHED_INSCRIPTION = 33,
	APOTHECARY_CABINET = 34,
	MARTA_BATHROOM_GUIDE = 35,
	BAKELITE_PHONE = 36,
	REEL_TAPE_RECORDER = 37,
	TOPOGRAPHY_BOARD = 38,
	JAKUB_DESK_LAMP = 39,
	TECH_STORAGE_AIRLOCK = 40,
}

signal resonance_triggered(id: String, prop_type: int)
signal state_changed(is_active: bool)

const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("263943")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
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
var _phone_sound: AudioStreamWAV
var _card_reader_sound: AudioStreamWAV
var _crosswalk_sound: AudioStreamWAV
var _bus_announcement_sound: AudioStreamWAV
var _ring_sound: AudioStreamWAV
var _timer_switch_sound: AudioStreamWAV
var _marta_blip_sound: AudioStreamWAV
var _door_sound: AudioStreamWAV
var _drawer_unlatch_sound: AudioStreamWAV
var _paper_rustle_sound: AudioStreamWAV
var _kettle_whistle_sound: AudioStreamWAV
var _tile_sound: AudioStreamWAV
var _pipe_sound: AudioStreamWAV
var _glass_scratch_sound: AudioStreamWAV
var _mirror_shimmer_sound: AudioStreamWAV
var _bakelite_bell_sound: AudioStreamWAV
var _handset_pickup_sound: AudioStreamWAV
var _tape_hum_sound: AudioStreamWAV
var _jakub_blip_sound: AudioStreamWAV
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
	_phone_sound = ProceduralAudio.create_phone_ring_pulse_sound()
	_card_reader_sound = ProceduralAudio.create_card_reader_beep_sound()
	_crosswalk_sound = ProceduralAudio.create_crosswalk_signal_sound(true)
	_bus_announcement_sound = ProceduralAudio.create_bus_announcement_sound()
	_ring_sound = ProceduralAudio.create_ring_chime_sound()
	_timer_switch_sound = ProceduralAudio.create_stair_timer_switch_sound()
	_marta_blip_sound = ProceduralAudio.create_dialogue_marta_blip_sound()
	_door_sound = ProceduralAudio.create_apartment_door_sound()
	_drawer_unlatch_sound = ProceduralAudio.create_drawer_lock_unlatch_sound()
	_paper_rustle_sound = ProceduralAudio.create_paper_rustle_sound()
	_kettle_whistle_sound = ProceduralAudio.create_kettle_whistle_sound()
	_tile_sound = ProceduralAudio.create_tile_footstep_sound()
	_pipe_sound = ProceduralAudio.create_water_pipe_hiss_sound()
	_glass_scratch_sound = ProceduralAudio.create_glass_scratch_sound()
	_mirror_shimmer_sound = ProceduralAudio.create_mirror_shimmer_sound()
	_bakelite_bell_sound = ProceduralAudio.create_bakelite_bell_sound()
	_handset_pickup_sound = ProceduralAudio.create_handset_pickup_sound()
	_tape_hum_sound = ProceduralAudio.create_tape_motor_hum_sound()
	_jakub_blip_sound = ProceduralAudio.create_dialogue_jakub_blip_sound()
	
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
	elif is_player_in_range or prop_type == PropType.DESK_TELEPHONE or prop_type == PropType.DOOR_CARD_READER or prop_type == PropType.GOLD_RING or prop_type == PropType.BUS_SPEAKER or prop_type == PropType.STAIR_TIMER_SWITCH or prop_type == PropType.MARTA_INTERACTION or prop_type == PropType.CIPHER_DESK or prop_type == PropType.TEA_KETTLE or prop_type == PropType.BATHROOM_MIRROR or prop_type == PropType.SCRATCHED_INSCRIPTION or prop_type == PropType.BATHROOM_SINK or prop_type == PropType.BAKELITE_PHONE or prop_type == PropType.REEL_TAPE_RECORDER or prop_type == PropType.TOPOGRAPHY_BOARD or prop_type == PropType.JAKUB_DESK_LAMP or prop_type == PropType.TECH_STORAGE_AIRLOCK:
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
	elif prop_type == PropType.DESK_TELEPHONE:
		is_activated = true
		if _audio_player and _phone_sound:
			_audio_player.stream = _phone_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.DOOR_CARD_READER:
		is_activated = true
		if _audio_player and _card_reader_sound:
			_audio_player.stream = _card_reader_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CROSSWALK_SIGNAL:
		is_activated = true
		if _audio_player and _crosswalk_sound:
			_audio_player.stream = _crosswalk_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BUS_SPEAKER:
		is_activated = true
		if _audio_player and _bus_announcement_sound:
			_audio_player.stream = _bus_announcement_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.GOLD_RING:
		is_activated = true
		if _audio_player and _ring_sound:
			_audio_player.stream = _ring_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.STAIR_TIMER_SWITCH:
		is_activated = true
		if _audio_player and _timer_switch_sound:
			_audio_player.stream = _timer_switch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MARTA_INTERACTION:
		is_activated = true
		if _audio_player and _marta_blip_sound:
			_audio_player.stream = _marta_blip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.CIPHER_DESK:
		is_activated = true
		if _audio_player and _drawer_unlatch_sound:
			_audio_player.stream = _drawer_unlatch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TEA_KETTLE:
		is_activated = true
		if _audio_player and _kettle_whistle_sound:
			_audio_player.stream = _kettle_whistle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_MEMENTO_TOOL:
		is_activated = true
		if _audio_player and _paper_rustle_sound:
			_audio_player.stream = _paper_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BATHROOM_SINK:
		is_activated = true
		if _audio_player and _pipe_sound:
			_audio_player.stream = _pipe_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BATHROOM_MIRROR:
		is_activated = true
		if _audio_player and _mirror_shimmer_sound:
			_audio_player.stream = _mirror_shimmer_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.SCRATCHED_INSCRIPTION:
		is_activated = true
		if _audio_player and _glass_scratch_sound:
			_audio_player.stream = _glass_scratch_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.APOTHECARY_CABINET:
		is_activated = true
		if _audio_player and _memory_sound:
			_audio_player.stream = _memory_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.MARTA_BATHROOM_GUIDE:
		is_activated = true
		if _audio_player and _marta_blip_sound:
			_audio_player.stream = _marta_blip_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.BAKELITE_PHONE:
		is_activated = true
		if _audio_player and _handset_pickup_sound:
			_audio_player.stream = _handset_pickup_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.REEL_TAPE_RECORDER:
		is_activated = not is_activated
		if _audio_player and _tape_hum_sound:
			_audio_player.stream = _tape_hum_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.TOPOGRAPHY_BOARD:
		is_activated = true
		if _audio_player and _paper_rustle_sound:
			_audio_player.stream = _paper_rustle_sound
			_audio_player.pitch_scale = 1.0
			_audio_player.play()
	elif prop_type == PropType.JAKUB_DESK_LAMP:
		is_activated = not is_activated
		if _audio_player and _switch_sound:
			_audio_player.stream = _switch_sound
			_audio_player.pitch_scale = 1.1 if is_activated else 0.9
			_audio_player.play()
	elif prop_type == PropType.TECH_STORAGE_AIRLOCK:
		is_activated = true
		if _audio_player and _door_sound:
			_audio_player.stream = _door_sound
			_audio_player.pitch_scale = 1.0
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
		PropType.DOOR_CARD_READER:
			_draw_door_card_reader()
		PropType.TWIN_CUPS:
			_draw_twin_cups()
		PropType.DESK_TELEPHONE:
			_draw_desk_telephone()
		PropType.DUTY_ROSTER:
			_draw_duty_roster()
		PropType.SECURITY_MONITOR:
			_draw_security_monitor()
		PropType.UCP_NOTICE:
			_draw_ucp_notice()
		PropType.GUARD_INTERACTION:
			_draw_guard_interaction()
		PropType.ANACHRONISTIC_BILLBOARD:
			_draw_anachronistic_billboard()
		PropType.MISSING_FLOOR_FACADE:
			_draw_missing_floor_facade()
		PropType.CROSSWALK_SIGNAL:
			_draw_crosswalk_signal()
		PropType.TRANSIT_SHELTER:
			_draw_transit_shelter()
		PropType.BUS_SPEAKER:
			_draw_bus_speaker()
		PropType.ELDERLY_PASSENGER:
			_draw_elderly_passenger()
		PropType.GOLD_RING:
			_draw_gold_ring()
		PropType.BUS_ROUTE_MAP:
			_draw_bus_route_map()
		PropType.TENANT_DIRECTORY:
			_draw_tenant_directory()
		PropType.MAILBOXES:
			_draw_mailboxes()
		PropType.BLIND_STAIRS:
			_draw_blind_stairs()
		PropType.MARTA_INTERACTION:
			_draw_marta_interaction()
		PropType.STAIR_TIMER_SWITCH:
			_draw_stair_timer_switch()
		PropType.HALLWAY_COAT_RACK:
			_draw_hallway_coat_rack()
		PropType.REFLECTED_PHOTOGRAPH:
			_draw_reflected_photograph()
		PropType.BEAKER_PLANTER:
			_draw_beaker_planter()
		PropType.JAKUB_MEMENTO_TOOL:
			_draw_jakub_memento_tool()
		PropType.CIPHER_DESK:
			_draw_cipher_desk()
		PropType.TEA_KETTLE:
			_draw_tea_kettle()
		PropType.BATHROOM_SINK:
			_draw_bathroom_sink()
		PropType.BATHROOM_MIRROR:
			_draw_bathroom_mirror()
		PropType.SCRATCHED_INSCRIPTION:
			_draw_scratched_inscription()
		PropType.APOTHECARY_CABINET:
			_draw_apothecary_cabinet()
		PropType.MARTA_BATHROOM_GUIDE:
			_draw_marta_bathroom_guide()
		PropType.BAKELITE_PHONE:
			_draw_bakelite_phone()
		PropType.REEL_TAPE_RECORDER:
			_draw_reel_tape_recorder()
		PropType.TOPOGRAPHY_BOARD:
			_draw_topography_board()
		PropType.JAKUB_DESK_LAMP:
			_draw_jakub_desk_lamp()
		PropType.TECH_STORAGE_AIRLOCK:
			_draw_tech_storage_airlock()
	
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


func _draw_door_card_reader() -> void:
	# Institutional wall-mounted card terminal: 22x32 px
	var base_rect := Rect2(-11.0, -16.0, 22.0, 32.0)
	draw_rect(base_rect, COLOR_DARK_STEEL)
	draw_rect(base_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Card swipe slot on right
	draw_rect(Rect2(7.0, -14.0, 2.0, 28.0), Color("0d1317"))
	
	# Backlit LCD screen (16x14 px)
	var screen_rect := Rect2(-9.0, -14.0, 15.0, 16.0)
	var screen_bg := Color("12221b") if is_activated else Color("0e161a")
	draw_rect(screen_rect, screen_bg)
	draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Mini badge photo (Left side of LCD): Different photo/silhouette of Lena
	# Head and torso with altered neckline / haircut reflecting alternate timeline
	var photo_rect := Rect2(-8.0, -13.0, 6.0, 7.0)
	draw_rect(photo_rect, Color("2d3b3f"))
	# Alternate Lena portrait silhouette: facing slightly forward, tied hair
	draw_circle(Vector2(-5.0, -10.5), 1.6, Color("141c22"))
	draw_rect(Rect2(-7.0, -8.5, 4.0, 2.5), Color("141c22"))
	
	# Data readout lines on LCD: "WOLSKA, L." and "URLOP PRZERWANY"
	if is_activated or is_player_in_range:
		var p := sin(_pulse_phase * 3.0) * 0.3 + 0.7
		# WOLSKA, L. // ID: 884-A
		draw_line(Vector2(-1.0, -12.0), Vector2(4.0, -12.0), COLOR_INFRASTRUCTURE * 0.9, 1.0)
		draw_line(Vector2(-1.0, -9.0), Vector2(3.0, -9.0), COLOR_CYAN * 0.8, 1.0)
		
		# "URLOP PRZERWANY" (Pulsing cinnabar / amber alert banner)
		var alert_col := Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, p)
		draw_rect(Rect2(-8.0, -4.0, 13.0, 5.0), Color(0.2, 0.08, 0.08, 0.8))
		draw_line(Vector2(-7.0, -2.0), Vector2(4.0, -2.0), alert_col, 1.2)
	else:
		# Standby cursor
		draw_line(Vector2(-8.0, -2.0), Vector2(-4.0, -2.0), COLOR_INFRASTRUCTURE * 0.4, 1.0)
	
	# Status Indicator Diode (Green/Cyan authorized, Amber/Cinnabar alert)
	var led_col := COLOR_CYAN if is_activated else (COLOR_AMBER if is_player_in_range else Color("4d3826"))
	draw_circle(Vector2(-4.0, 8.0), 1.8, led_col)
	draw_circle(Vector2(4.0, 8.0), 1.5, COLOR_INFRASTRUCTURE * 0.6)


func _draw_twin_cups() -> void:
	# Operator desk surface coaster: 30x6 px
	draw_rect(Rect2(-15.0, 4.0, 30.0, 3.0), Color("1e2930"))
	draw_rect(Rect2(-15.0, 4.0, 30.0, 3.0), COLOR_INFRASTRUCTURE * 0.4, false, 1.0)
	
	# ── Cup 1 (Left): Lena's original grey ceramic mug from Scene 01 ──
	# Body: 7x9 px at x = -8
	var cup1_rect := Rect2(-11.0, -4.0, 7.0, 8.0)
	draw_rect(cup1_rect, Color("c4c0b4")) # Standard beige/grey ceramic
	draw_rect(cup1_rect, Color("8a877d"), false, 1.0)
	# Handle
	draw_rect(Rect2(-13.0, -2.0, 2.0, 5.0), Color("8a877d"))
	# Empty interior lip
	draw_line(Vector2(-11.0, -4.0), Vector2(-4.0, -4.0), Color("626058"), 1.0)
	
	# ── Cup 2 (Right): Second mug (The material anomaly - proof of an unrecorded colleague) ──
	# Body: 8x10 px at x = 5 (slightly taller, enamel dark sage with coffee residue)
	var cup2_rect := Rect2(3.0, -5.0, 8.0, 9.0)
	draw_rect(cup2_rect, Color("3d554a")) # Institutional dark sage enamel
	draw_rect(cup2_rect, Color("202c26"), false, 1.0)
	# Handle on right
	draw_rect(Rect2(11.0, -3.0, 2.0, 5.0), Color("202c26"))
	# Rim with dark coffee ring / residue
	draw_line(Vector2(3.0, -5.0), Vector2(11.0, -5.0), Color("1e140d"), 1.2)
	# Dark coffee stain running down side
	draw_line(Vector2(8.0, -4.0), Vector2(8.0, 0.0), Color("1e140d", 0.7), 1.0)
	
	# Faint steam trace above cup 2 when inspected or active (fresh coffee)
	if is_activated or is_player_in_range:
		var p := sin(_pulse_phase * 2.0) * 0.5 + 0.5
		var steam_alpha := 0.25 + p * 0.25
		draw_line(Vector2(7.0, -7.0), Vector2(8.0, -11.0), Color(1.0, 1.0, 1.0, steam_alpha), 1.0)
		draw_line(Vector2(9.0, -6.0), Vector2(10.0, -10.0), Color(1.0, 1.0, 1.0, steam_alpha * 0.7), 1.0)


func _draw_desk_telephone() -> void:
	# Heavy 90s institutional office desk phone console: 24x18 px
	var phone_rect := Rect2(-12.0, -8.0, 24.0, 16.0)
	draw_rect(phone_rect, Color("222d35")) # Dark industrial plastic
	draw_rect(phone_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Cradle and handset on top/left
	var handset_rect := Rect2(-14.0, -10.0, 10.0, 20.0)
	draw_rect(handset_rect, Color("172026"))
	draw_rect(handset_rect, COLOR_DARK_STEEL, false, 1.0)
	# Handset grip taper
	draw_rect(Rect2(-12.0, -5.0, 6.0, 10.0), Color("10161a"))
	
	# Keypad button matrix on right: 3x3 buttons
	for row in range(3):
		for col in range(3):
			var bx := -1.0 + float(col) * 3.5
			var by := -2.0 + float(row) * 3.5
			draw_rect(Rect2(bx, by, 2.5, 2.5), Color("3d4e58"))
	
	# LCD status screen on top right
	var screen_rect := Rect2(-2.0, -7.0, 12.0, 4.0)
	draw_rect(screen_rect, Color("0e161a"))
	draw_rect(screen_rect, COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	
	# Text readout on LCD: "14" unread messages
	draw_line(Vector2(-1.0, -5.0), Vector2(8.0, -5.0), COLOR_AMBER * 0.85, 1.0)
	
	# ── Message Waiting Light (Blinking Amber LED) ──
	var blink := sin(_pulse_phase * 4.0) * 0.5 + 0.5
	var led_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.3 + blink * 0.7)
	draw_circle(Vector2(9.0, -1.0), 1.8, led_col)
	draw_circle(Vector2(9.0, -1.0), 3.5, Color(led_col.r, led_col.g, led_col.b, blink * 0.3))
	
	# Coiled telephone cable at bottom
	for c in range(4):
		var cx := -11.0 + float(c) * 2.5
		var cy := 8.0 + (1.0 if c % 2 == 0 else -1.0) * 1.5
		draw_circle(Vector2(cx, cy), 1.0, Color("141c22"))


func _draw_duty_roster() -> void:
	# Wall acrylic duty notice board: 22x28 px
	var board_rect := Rect2(-11.0, -14.0, 22.0, 28.0)
	draw_rect(board_rect, Color("1e2a32"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Corner mounting standoffs
	draw_circle(Vector2(-9.0, -12.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(9.0, -12.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(-9.0, 12.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(9.0, 12.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Header banner: IKP DYŻURY NOCNE
	draw_rect(Rect2(-9.0, -11.0, 18.0, 4.0), Color("293a44"))
	draw_line(Vector2(-7.0, -9.0), Vector2(7.0, -9.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Roster schedule entries (grid lines with strikethroughs / missing staff)
	for i in range(4):
		var y := -4.0 + float(i) * 4.5
		var line_c := COLOR_AMBER if i == 0 else COLOR_INFRASTRUCTURE * 0.7
		draw_line(Vector2(-8.0, y), Vector2(3.0, y), line_c, 1.0)
		# Red/cinnabar strikethrough or absence mark for missing night staff
		if i > 0:
			draw_line(Vector2(4.0, y - 1.0), Vector2(8.0, y + 1.0), COLOR_CORRECTION * 0.8, 1.0)
			draw_line(Vector2(4.0, y + 1.0), Vector2(8.0, y - 1.0), COLOR_CORRECTION * 0.8, 1.0)


func _draw_security_monitor() -> void:
	# CRT CCTV monitor on guard desk: 26x20 px
	var mon_rect := Rect2(-13.0, -10.0, 26.0, 20.0)
	draw_rect(mon_rect, Color("1a242b"))
	draw_rect(mon_rect, COLOR_DARK_STEEL, false, 1.0)
	
	# Bezel & screen inset
	var scr_rect := Rect2(-11.0, -8.0, 22.0, 14.0)
	draw_rect(scr_rect, Color("0b1318"))
	
	# Green/graphite CCTV raster lines
	var p := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	for row in range(3):
		var y := -6.0 + float(row) * 4.0
		draw_line(Vector2(-9.0, y), Vector2(9.0, y), Color(0.20, 0.45, 0.35, 0.4 + p * 0.2), 1.0)
	
	# Silhouette of gate on CCTV screen
	draw_line(Vector2(2.0, -5.0), Vector2(2.0, 4.0), Color(0.25, 0.55, 0.42, 0.7), 1.5)
	draw_line(Vector2(-3.0, 1.0), Vector2(2.0, -1.0), Color(0.25, 0.55, 0.42, 0.7), 1.0)
	
	# Camera status overlay text: "CAM 04 [REC]"
	draw_line(Vector2(-9.0, -7.0), Vector2(-4.0, -7.0), COLOR_CORRECTION * 0.8, 1.0)
	
	# Green power LED
	draw_circle(Vector2(8.0, 8.0), 1.0, Color("45c68a"))


func _draw_ucp_notice() -> void:
	# Official UCP institutional advisory bulletin on wall: 24x30 px
	var board_rect := Rect2(-12.0, -15.0, 24.0, 30.0)
	draw_rect(board_rect, Color("202d36"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Blue/grey header: "UCP // PROTOKÓŁ ZGŁASZANIA"
	draw_rect(Rect2(-10.0, -13.0, 20.0, 5.0), Color("2f4552"))
	draw_line(Vector2(-8.0, -10.5), Vector2(8.0, -10.5), COLOR_INFRASTRUCTURE, 1.0)
	
	# Institutional bulletin text lines
	for i in range(5):
		var y := -5.0 + float(i) * 3.8
		var col := COLOR_INFRASTRUCTURE * 0.65
		if i == 0:
			col = COLOR_AMBER * 0.8
		elif i == 4:
			col = COLOR_CORRECTION * 0.7
		draw_line(Vector2(-9.0, y), Vector2(9.0, y), col, 1.0)
	
	# Official seal / stamp mark on bottom right
	draw_rect(Rect2(3.0, 6.0, 6.0, 6.0), Color("8f3833", 0.5))


func _draw_guard_interaction() -> void:
	# Desk counter intercom / call button
	var box_rect := Rect2(-8.0, -6.0, 16.0, 12.0)
	draw_rect(box_rect, COLOR_DARK_STEEL)
	draw_rect(box_rect, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Intercom speaker grill perforations
	for i in range(3):
		var y := -3.0 + float(i) * 3.0
		draw_line(Vector2(-5.0, y), Vector2(1.0, y), Color("121a20"), 1.0)
	
	# Call / alert indicator button
	var btn_col := COLOR_CYAN if is_activated else COLOR_AMBER
	draw_circle(Vector2(4.0, 0.0), 2.2, btn_col)


func _draw_anachronistic_billboard() -> void:
	# Anachronistic advertising / institutional billboard (38x26 px)
	var board_rect := Rect2(-19.0, -18.0, 38.0, 26.0)
	
	# Steel support pillars extending into pavement
	draw_line(Vector2(-14.0, 8.0), Vector2(-14.0, 24.0), COLOR_DARK_STEEL, 2.0)
	draw_line(Vector2(14.0, 8.0), Vector2(14.0, 24.0), COLOR_DARK_STEEL, 2.0)
	
	# Billboard panel & enamel frame
	draw_rect(board_rect, Color("1a262e"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.5)
	
	# Header banner (UCP / Era-shifted enterprise)
	draw_rect(Rect2(-17.0, -16.0, 34.0, 6.0), Color("283d4a"))
	draw_line(Vector2(-15.0, -13.0), Vector2(15.0, -13.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Slogan typography lines ("PAMIĘĆ WSPÓLNA TO SPOKÓJ")
	var line_col := COLOR_AMBER if is_activated else Color("c0ccc6")
	draw_line(Vector2(-15.0, -6.0), Vector2(12.0, -6.0), line_col, 1.2)
	draw_line(Vector2(-15.0, -2.0), Vector2(8.0, -2.0), line_col * 0.85, 1.0)
	draw_line(Vector2(-15.0, 2.0), Vector2(14.0, 2.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
	
	# Era timestamp emblem in corner ("1978")
	draw_rect(Rect2(7.0, 1.0, 9.0, 4.0), Color("344b59"))
	draw_line(Vector2(8.0, 3.0), Vector2(15.0, 3.0), COLOR_CYAN * 0.8, 1.0)
	
	# Overhead floodlight bracket
	draw_line(Vector2(0.0, -18.0), Vector2(0.0, -23.0), COLOR_DARK_STEEL, 1.5)
	var lamp_col := Color("f4eed6") if is_activated else Color("3d4b52")
	draw_circle(Vector2(0.0, -23.0), 2.0, lamp_col)


func _draw_missing_floor_facade() -> void:
	# Architectural elevation inspection marker (24x30 px)
	var plaque_rect := Rect2(-12.0, -15.0, 24.0, 30.0)
	draw_rect(plaque_rect, Color("18232a"))
	draw_rect(plaque_rect, COLOR_DARK_STEEL, false, 1.2)
	
	# Building elevation outline showing missing 3rd floor
	# 5 Floors diagram: Floor 1 (y=9..5), Floor 2 (y=4..0), Floor 3 VOID (-1..-5), Floor 4 (-6..-10), Floor 5 (-11..-15)
	# Floor 1 & 2 (Lower mass)
	draw_rect(Rect2(-8.0, 0.0, 16.0, 10.0), Color("243540"))
	draw_rect(Rect2(-8.0, 0.0, 16.0, 10.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	# Floor 4 & 5 (Upper mass)
	draw_rect(Rect2(-8.0, -14.0, 16.0, 9.0), Color("243540"))
	draw_rect(Rect2(-8.0, -14.0, 16.0, 9.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Floor 3 Void gap: Only 2 slender structural columns spanning the gap
	draw_line(Vector2(-6.0, -5.0), Vector2(-6.0, 0.0), COLOR_INFRASTRUCTURE * 0.9, 1.2)
	draw_line(Vector2(6.0, -5.0), Vector2(6.0, 0.0), COLOR_INFRASTRUCTURE * 0.9, 1.2)
	
	# Oxide cinnabar annotation indicator pointing to the void
	var void_col := COLOR_CORRECTION if is_activated else Color("7a3e3b")
	draw_line(Vector2(-3.0, -2.5), Vector2(3.0, -2.5), void_col, 1.2)
	draw_circle(Vector2(0.0, -2.5), 1.2, void_col)


func _draw_crosswalk_signal() -> void:
	# Pedestrian traffic beacon & acoustic signal pole (x=0, y=-30..20)
	# Steel pole
	draw_line(Vector2(0.0, -32.0), Vector2(0.0, 24.0), COLOR_DARK_STEEL, 3.0)
	draw_line(Vector2(0.0, -32.0), Vector2(0.0, 24.0), COLOR_INFRASTRUCTURE * 0.6, 1.0)
	
	# Top signal housing (14x24 px, y=-32..-8)
	var signal_box := Rect2(-7.0, -32.0, 14.0, 24.0)
	draw_rect(signal_box, Color("141d24"))
	draw_rect(signal_box, COLOR_DARK_STEEL, false, 1.2)
	
	# Sun visors over lamps
	draw_line(Vector2(-6.0, -32.0), Vector2(6.0, -32.0), Color("0d1419"), 1.8)
	draw_line(Vector2(-6.0, -20.0), Vector2(6.0, -20.0), Color("0d1419"), 1.8)
	
	# Upper Signal: Red pedestrian stop silhouette (lit when not active)
	var red_col := COLOR_CORRECTION if not is_activated else Color("331515")
	draw_circle(Vector2(0.0, -26.0), 3.5, red_col)
	if not is_activated:
		draw_circle(Vector2(0.0, -26.0), 6.0, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.25))
	
	# Lower Signal: Green / Cyan walking figure (lit when activated)
	var green_col := COLOR_CYAN if is_activated else Color("142b29")
	draw_circle(Vector2(0.0, -14.0), 3.5, green_col)
	if is_activated:
		draw_circle(Vector2(0.0, -14.0), 7.0, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	
	# Lower Pedestrian Push-Button Box (y=0..16)
	var btn_box := Rect2(-6.0, 0.0, 12.0, 16.0)
	draw_rect(btn_box, Color("2c3b44"))
	draw_rect(btn_box, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Tactile call button
	var btn_col := COLOR_CYAN if is_activated else COLOR_AMBER
	draw_circle(Vector2(0.0, 6.0), 2.8, btn_col)
	if is_activated:
		draw_circle(Vector2(0.0, 6.0), 5.5, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.4))
	
	# Acoustic speaker perforations
	for i in range(2):
		var sy := 11.0 + float(i) * 2.5
		draw_circle(Vector2(-2.0, sy), 0.8, Color("12191f"))
		draw_circle(Vector2(2.0, sy), 0.8, Color("12191f"))


func _draw_transit_shelter() -> void:
	# Timetable board & route schematic on shelter wall (28x36 px)
	var board_rect := Rect2(-14.0, -18.0, 28.0, 36.0)
	draw_rect(board_rect, Color("1a2730"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.2)
	
	# Header strip: "LINIA 4 // ROZKŁAD"
	draw_rect(Rect2(-12.0, -16.0, 24.0, 6.0), Color("283f4f"))
	draw_line(Vector2(-10.0, -13.0), Vector2(10.0, -13.0), COLOR_INFRASTRUCTURE, 1.0)
	
	# Timetable rows
	for i in range(4):
		var y := -7.0 + float(i) * 4.0
		draw_line(Vector2(-10.0, y), Vector2(6.0, y), COLOR_INFRASTRUCTURE * 0.5, 1.0)
	
	# Red strike-through warning tape: "TRASA ZAWIESZONA / AUTOBUS ZASTĘPCZY"
	var tape_pts := PackedVector2Array([
		Vector2(-13.0, 3.0),
		Vector2(13.0, 1.0),
		Vector2(13.0, 7.0),
		Vector2(-13.0, 9.0),
	])
	draw_polygon(tape_pts, [Color("8f3833", 0.85)])
	draw_line(Vector2(-11.0, 6.0), Vector2(11.0, 4.0), Color("f0e6e6"), 1.0)
	
	# Route terminus marker dot
	draw_circle(Vector2(9.0, 13.0), 1.8, COLOR_CYAN if is_activated else COLOR_AMBER)


func _draw_bus_speaker() -> void:
	# Ceiling institutional intercom / speaker housing (24x12 px)
	var housing_rect := Rect2(-12.0, -6.0, 24.0, 12.0)
	draw_rect(housing_rect, COLOR_DARK_STEEL)
	draw_rect(housing_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	# Perforated circular grille
	draw_circle(Vector2.ZERO, 4.2, COLOR_BACKGROUND)
	draw_circle(Vector2.ZERO, 4.2, COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	
	# Acoustic aperture matrix (3x3 micro holes)
	for dx in [-2.0, 0.0, 2.0]:
		for dy in [-2.0, 0.0, 2.0]:
			draw_circle(Vector2(dx, dy), 0.6, Color("0a0f14"))
	
	# Institutional telemetry diode (Amber pulse on announcement)
	var diode_col := COLOR_AMBER if is_activated else COLOR_CYAN * 0.7
	draw_circle(Vector2(8.5, 0.0), 1.4, diode_col)
	
	# Sound emission arcs when active
	if is_activated or is_player_in_range:
		var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
		var arc_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35 + pulse * 0.45)
		draw_arc(Vector2(0.0, 6.0), 6.0 + pulse * 3.0, 0.2 * PI, 0.8 * PI, 8, arc_col, 1.2)
		draw_arc(Vector2(0.0, 6.0), 10.0 + pulse * 4.0, 0.25 * PI, 0.75 * PI, 8, arc_col * 0.6, 1.0)


func _draw_elderly_passenger() -> void:
	# Elderly passenger seated in municipal bus (profile facing left towards aisle)
	# Body / Heavy coat
	var coat_col := Color("1e2c34")
	var coat_pts := PackedVector2Array([
		Vector2(12.0, 14.0),
		Vector2(-6.0, 14.0),
		Vector2(-10.0, 0.0),
		Vector2(-8.0, -10.0),
		Vector2(6.0, -12.0),
		Vector2(12.0, 0.0),
	])
	draw_polygon(coat_pts, [coat_col])
	draw_polyline(coat_pts, COLOR_INFRASTRUCTURE * 0.4, 1.0)
	
	# Lapel / Scarf
	draw_line(Vector2(-3.0, -10.0), Vector2(1.0, 2.0), COLOR_INFRASTRUCTURE * 0.7, 1.5)
	
	# Head / Wool beanie
	draw_circle(Vector2(-1.0, -17.0), 5.5, Color("141c22"))
	draw_circle(Vector2(-1.0, -17.0), 5.0, COLOR_INFRASTRUCTURE * 0.6) # Beanie cap
	draw_circle(Vector2(-3.0, -15.0), 3.5, Color("cf9b72")) # Face profile
	
	# Hands on knees holding the gold ring / gesture
	draw_circle(Vector2(-7.0, 6.0), 2.2, Color("cf9b72"))
	
	# Subtle eye / calm observant gaze
	draw_circle(Vector2(-4.5, -15.5), 0.7, Color("141c22"))


func _draw_gold_ring() -> void:
	# Gold wedding ring on bus seat fabric (warm amber/gold #E6B450)
	var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
	var gold_col := Color("e6b450")
	var gold_shadow := Color("7a5618")
	var gold_highlight := Color("fff2b2")
	
	# Filament warmth disc beneath ring
	var glow_rad := 7.0 + pulse * 2.5
	draw_circle(Vector2.ZERO, glow_rad, Color(gold_col.r, gold_col.g, gold_col.b, 0.22 + pulse * 0.20))
	
	# Ring geometry: outer circle & inner hollow
	draw_circle(Vector2.ZERO, 3.8, gold_col)
	draw_circle(Vector2.ZERO, 2.2, Color("1a2630")) # Seat fabric background
	draw_circle(Vector2.ZERO, 3.8, gold_shadow, false, 0.8)
	
	# Specular reflection gleam
	draw_circle(Vector2(-1.4, -1.4), 0.9, gold_highlight)
	
	# Radial micro-light beams when inspected/activated
	if is_activated or is_player_in_range:
		var beam_len := 6.0 + pulse * 2.0
		var beam_col := Color(gold_col.r, gold_col.g, gold_col.b, 0.5 + pulse * 0.3)
		for angle_deg in [0.0, 72.0, 144.0, 216.0, 288.0]:
			var rad: float = deg_to_rad(angle_deg + _pulse_phase * 20.0)
			var p1 := Vector2(cos(rad), sin(rad)) * 4.2
			var p2 := Vector2(cos(rad), sin(rad)) * (4.2 + beam_len)
			draw_line(p1, p2, beam_col, 1.0)


func _draw_bus_route_map() -> void:
	# Institutional overhead route board: "LINIA ZASTĘPCZA 4" (44x16 px)
	var board_rect := Rect2(-22.0, -8.0, 44.0, 16.0)
	draw_rect(board_rect, Color("141e26"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.75, false, 1.0)
	
	# Route strip track line
	draw_line(Vector2(-18.0, 0.0), Vector2(18.0, 0.0), COLOR_CYAN * 0.8, 1.5)
	
	# Station dots:
	# 1. IKP (origin - checked)
	draw_circle(Vector2(-16.0, 0.0), 2.2, COLOR_CYAN)
	# 2. Closed stations on Line 4 (crossed out with red cinnabar)
	draw_circle(Vector2(-6.0, 0.0), 1.8, COLOR_CORRECTION)
	draw_line(Vector2(-8.0, -2.5), Vector2(-4.0, 2.5), COLOR_CORRECTION, 1.2)
	draw_line(Vector2(-8.0, 2.5), Vector2(-4.0, -2.5), COLOR_CORRECTION, 1.2)
	
	draw_circle(Vector2(4.0, 0.0), 1.8, COLOR_CORRECTION)
	draw_line(Vector2(2.0, -2.5), Vector2(6.0, 2.5), COLOR_CORRECTION, 1.2)
	draw_line(Vector2(2.0, 2.5), Vector2(6.0, -2.5), COLOR_CORRECTION, 1.2)
	
	# 3. Osiedle Tarasowe (destination - pulsing amber)
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	draw_circle(Vector2(14.0, 0.0), 2.4, COLOR_AMBER)
	draw_circle(Vector2(14.0, 0.0), 3.6 + pulse * 1.5, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35), false, 0.8)


func _draw_tenant_directory() -> void:
	# Modernist resident directory board on staircase landing (44x32 px)
	var board_rect := Rect2(-22.0, -16.0, 44.0, 32.0)
	draw_rect(board_rect, Color("121a20"))
	draw_rect(board_rect, COLOR_INFRASTRUCTURE * 0.8, false, 1.2)
	
	# Header strip: "BLOK 7 / OS. TARASOWE"
	draw_rect(Rect2(-20.0, -14.0, 40.0, 5.0), Color("1e2a32"))
	draw_line(Vector2(-18.0, -11.5), Vector2(-4.0, -11.5), COLOR_INFRASTRUCTURE * 0.9, 1.0)
	
	# Resident list entries (stairwell floor 4 & 5)
	# M. 11 & 12
	draw_line(Vector2(-18.0, -5.0), Vector2(6.0, -5.0), COLOR_INFRASTRUCTURE * 0.45, 1.0)
	draw_line(Vector2(-18.0, -1.0), Vector2(10.0, -1.0), COLOR_INFRASTRUCTURE * 0.45, 1.0)
	
	# M. 13 — Bera S. [V p.]
	draw_line(Vector2(-18.0, 3.0), Vector2(8.0, 3.0), COLOR_INFRASTRUCTURE * 0.55, 1.0)
	
	# M. 14 — Wolska L. / Kurek M. [V p.] (Highlighted with warm amber tag)
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var highlight_col := COLOR_AMBER if (is_activated or is_player_in_range) else COLOR_AMBER * 0.75
	draw_rect(Rect2(-19.0, 6.0, 38.0, 6.0), Color(highlight_col.r, highlight_col.g, highlight_col.b, 0.18 + pulse * 0.15))
	draw_line(Vector2(-17.0, 9.0), Vector2(14.0, 9.0), highlight_col, 1.2)
	draw_circle(Vector2(-17.0, 9.0), 1.5, highlight_col)


func _draw_mailboxes() -> void:
	# Steel multi-compartment mailboxes module (48x28 px)
	var box_rect := Rect2(-24.0, -14.0, 48.0, 28.0)
	draw_rect(box_rect, Color("1e2b34"))
	draw_rect(box_rect, COLOR_INFRASTRUCTURE * 0.85, false, 1.2)
	
	# 4 Individual mailbox doors (2x2 grid)
	var cells := [
		Rect2(-22.0, -12.0, 20.0, 10.0), # M. 11
		Rect2(2.0, -12.0, 20.0, 10.0),   # M. 12
		Rect2(-22.0, 2.0, 20.0, 10.0),   # M. 13
		Rect2(2.0, 2.0, 20.0, 10.0),     # M. 14 (Wolska / Kurek)
	]
	
	for i in range(cells.size()):
		var cell: Rect2 = cells[i]
		draw_rect(cell, Color("17232b"))
		draw_rect(cell, COLOR_DARK_STEEL, false, 1.0)
		# Horizontal mail drop slot
		draw_line(Vector2(cell.position.x + 3.0, cell.position.y + 3.0), Vector2(cell.position.x + cell.size.x - 3.0, cell.position.y + 3.0), Color("0a1014"), 1.2)
		# Keyhole
		draw_circle(Vector2(cell.position.x + cell.size.x - 4.0, cell.position.y + 7.0), 0.8, COLOR_INFRASTRUCTURE * 0.7)
	
	# Mailbox 14 (index 3): Protruding UCP notices / uncollected official mail
	var pulse := sin(_pulse_phase * 2.2) * 0.5 + 0.5
	var paper_col := Color("e8e2d2")
	# Envelope corner sticking out of slot
	var p_pts := PackedVector2Array([
		Vector2(6.0, 4.0),
		Vector2(18.0, 1.0 - pulse * 0.8),
		Vector2(19.0, 5.0),
		Vector2(8.0, 7.0)
	])
	draw_colored_polygon(p_pts, paper_col)
	# Official red/oxide stamp mark on envelope
	draw_rect(Rect2(12.0, 2.5, 4.0, 2.5), COLOR_CORRECTION)
	draw_line(Vector2(7.0, 5.5), Vector2(17.0, 3.5), Color("20262c"), 0.8)


func _draw_blind_stairs() -> void:
	# Concrete stairs ending abruptly into a solid monolithic wall / truncated ceiling (#geometry-restless-grid)
	# Step profiles (ascending right towards solid barrier)
	var step1 := Rect2(-24.0, 8.0, 14.0, 8.0)
	var step2 := Rect2(-10.0, 0.0, 14.0, 8.0)
	var step3 := Rect2(4.0, -8.0, 14.0, 8.0)
	
	# Terrazzo treads
	draw_rect(step1, Color("4a5860"))
	draw_rect(step2, Color("53646d"))
	draw_rect(step3, Color("5c6f7a"))
	
	# Solid concrete slab / sheer wall blocking the ascending flight at x=18
	var wall_rect := Rect2(16.0, -22.0, 16.0, 38.0)
	draw_rect(wall_rect, Color("222f37"))
	draw_rect(wall_rect, COLOR_DARK_STEEL, false, 1.2)
	# Rough unplastered concrete joints
	draw_line(Vector2(16.0, -10.0), Vector2(32.0, -10.0), Color("151e24"), 1.0)
	draw_line(Vector2(16.0, 4.0), Vector2(32.0, 4.0), Color("151e24"), 1.0)
	
	# Oxide cinnabar hazard warning tape / barrier across the dead-end flight
	var pulse := sin(_pulse_phase * 1.8) * 0.5 + 0.5
	var warn_col := COLOR_CORRECTION if not is_activated else Color("d4726d")
	draw_line(Vector2(-12.0, -2.0), Vector2(16.0, -12.0), warn_col, 2.0)
	# Diagonal hazard slashes
	for d in range(5):
		var px: float = -8.0 + d * 5.0
		var py: float = -3.5 - d * 1.8
		draw_line(Vector2(px - 1.5, py + 2.0), Vector2(px + 1.5, py - 2.0), Color("12181c"), 1.0)
	
	# Stencil symbol on concrete shear wall
	draw_circle(Vector2(24.0, -4.0), 3.2, warn_col, false, 1.0)
	draw_line(Vector2(21.5, -4.0), Vector2(26.5, -4.0), warn_col, 1.2)


func _draw_marta_interaction() -> void:
	# Marta Kurek standing in the doorway of Apt 14 (18x36 px)
	# Silhouette and attire conforming to VISUAL_DESIGN.md:
	# Wider center of gravity, dark layered work jacket with chalk/plaster marks,
	# tool bag slung across chest, folding ruler in leg pocket, observant calm gaze.
	
	# Warm amber domestic hallway glow behind Marta
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var glow_alpha := 0.25 + pulse * 0.15
	draw_circle(Vector2(4.0, -4.0), 22.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, glow_alpha))
	
	# 1. Legs & Heavy boots
	draw_rect(Rect2(-7.0, 8.0, 5.0, 10.0), Color("182329"))
	draw_rect(Rect2(1.0, 8.0, 5.0, 10.0), Color("182329"))
	draw_rect(Rect2(-8.0, 16.0, 6.5, 3.5), Color("10161a")) # Boot left
	draw_rect(Rect2(0.5, 16.0, 6.5, 3.5), Color("10161a"))  # Boot right
	
	# 2. Torso & Layered work jacket (sage green / muted dark canvas #2B3D36)
	var torso_rect := Rect2(-8.0, -8.0, 15.0, 17.0)
	draw_rect(torso_rect, Color("2b3d36"))
	draw_rect(torso_rect, Color("3a5148"), false, 1.0)
	
	# Chalk / plaster marks on sleeve & pocket (authentic artisan texture)
	draw_line(Vector2(-6.0, 0.0), Vector2(-3.0, 3.0), Color("8a9e96"), 0.8)
	draw_line(Vector2(-5.0, 4.0), Vector2(-2.0, 4.0), Color("8a9e96"), 0.8)
	
	# 3. Canvas tool bag strap across chest (diagonal from right shoulder to left hip)
	draw_line(Vector2(4.0, -8.0), Vector2(-7.0, 6.0), Color("6e5944"), 2.2)
	# Heavy rectangular canvas tool bag on left hip
	draw_rect(Rect2(-12.0, 0.0, 6.0, 9.0), Color("4a3c2e"))
	draw_rect(Rect2(-12.0, 0.0, 6.0, 9.0), Color("6e5944"), false, 0.8)
	
	# 4. Folded wooden folding ruler (calówka) peeking from right thigh pocket
	draw_rect(Rect2(4.0, 4.0, 2.5, 6.0), COLOR_AMBER)
	draw_line(Vector2(4.0, 6.0), Vector2(6.5, 6.0), Color("1c242a"), 0.6)
	draw_line(Vector2(4.0, 8.0), Vector2(6.5, 8.0), Color("1c242a"), 0.6)
	
	# 5. Head, hair & facial profile
	draw_circle(Vector2(-0.5, -13.0), 5.2, Color("1a2228")) # Dark hair tied back
	draw_circle(Vector2(-1.5, -12.5), 3.8, Color("d39a62")) # Warm skin
	draw_circle(Vector2(-3.5, -13.0), 0.8, Color("141c22")) # Observant eye
	
	# 6. Hand posture: one hand resting on door frame, one holding tool bag strap
	draw_circle(Vector2(-6.0, 4.0), 1.8, Color("d39a62")) # Hand on bag strap
	draw_circle(Vector2(7.0, -2.0), 1.6, Color("d39a62")) # Hand near door edge


func _draw_stair_timer_switch() -> void:
	# Classic modernist staircase timer push-button with amber neon pilot glow (16x16 px)
	var plate_rect := Rect2(-7.0, -7.0, 14.0, 14.0)
	draw_rect(plate_rect, Color("222e36"))
	draw_rect(plate_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Mounting screws
	draw_circle(Vector2(0.0, -5.0), 0.7, COLOR_INFRASTRUCTURE * 0.9)
	draw_circle(Vector2(0.0, 5.0), 0.7, COLOR_INFRASTRUCTURE * 0.9)
	
	# Center push button (circular)
	draw_circle(Vector2.ZERO, 3.6, Color("141c22"))
	draw_circle(Vector2.ZERO, 2.4, Color("354652"))
	
	# Glowing orange/amber neon pilot lamp in center
	var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	var neon_alpha := 0.6 + pulse * 0.4
	var neon_col := Color("ff9e3b")
	draw_circle(Vector2.ZERO, 1.4, Color(neon_col.r, neon_col.g, neon_col.b, neon_alpha))
	draw_circle(Vector2.ZERO, 3.2 + pulse * 1.2, Color(neon_col.r, neon_col.g, neon_col.b, 0.25 * neon_alpha))


func _draw_hallway_coat_rack() -> void:
	# Modernist wooden coat rack strip with brass pegs, hanging coats and rain boots (28x36 px)
	# Wall rack strip
	var rack_bar := Rect2(-14.0, -18.0, 28.0, 4.0)
	draw_rect(rack_bar, Color("4a3525")) # Teak wood
	draw_rect(rack_bar, Color("6e4e35"), false, 0.8)
	
	# Brass hooks (left, center, right)
	draw_circle(Vector2(-8.0, -16.0), 1.5, Color("cda35d"))
	draw_circle(Vector2(0.0, -16.0), 1.5, Color("cda35d"))
	draw_circle(Vector2(8.0, -16.0), 1.5, Color("cda35d"))
	
	# Coat 1 (Left hook - Lena's long dark graphite coat)
	var coat1_rect := Rect2(-12.0, -15.0, 8.0, 22.0)
	draw_rect(coat1_rect, Color("1a242a"))
	draw_rect(coat1_rect, Color("2a3740"), false, 0.8)
	draw_line(Vector2(-8.0, -15.0), Vector2(-8.0, 5.0), Color("141c22"), 1.0) # Fold/seam
	
	# Coat 2 (Center/Right hook - Marta's work jacket with chalk/paint traces)
	var coat2_rect := Rect2(-2.0, -15.0, 9.0, 16.0)
	draw_rect(coat2_rect, Color("2b3d36"))
	draw_rect(coat2_rect, Color("3a5148"), false, 0.8)
	# Chalk marks on canvas jacket
	draw_line(Vector2(0.0, -8.0), Vector2(3.0, -5.0), Color("8a9e96"), 0.8)
	draw_line(Vector2(1.0, -3.0), Vector2(4.0, -3.0), Color("8a9e96"), 0.8)
	
	# Rain boots left on rubber mat beneath (at y=10..18)
	var mat_rect := Rect2(-13.0, 14.0, 26.0, 4.0)
	draw_rect(mat_rect, Color("141a1f"))
	draw_rect(mat_rect, Color("242d35"), false, 0.8)
	# Pair of dark rain boots left behind 17 days ago
	draw_rect(Rect2(-8.0, 6.0, 6.0, 10.0), Color("10161a"))
	draw_rect(Rect2(2.0, 6.0, 6.0, 10.0), Color("10161a"))
	draw_rect(Rect2(-9.0, 13.0, 7.0, 3.5), Color("0b0f12"))
	draw_rect(Rect2(1.0, 13.0, 7.0, 3.5), Color("0b0f12"))


func _draw_reflected_photograph() -> void:
	# Framed photograph of Marta and local Lena (24x20 px)
	# Framing per VISUAL_DESIGN.md & FULL_STORY 08: Lena is framed strictly from behind or in reflection, never direct face
	var frame_rect := Rect2(-12.0, -10.0, 24.0, 20.0)
	var photo_rect := Rect2(-10.0, -8.0, 20.0, 16.0)
	
	# Modernist wooden frame with brass corners
	draw_rect(frame_rect, Color("3d2c1e"))
	draw_rect(frame_rect, Color("cda35d"), false, 0.8)
	
	# Photo paper (monochrome warm tint)
	draw_rect(photo_rect, Color("263238"))
	
	# Rainy window reflection background
	draw_line(Vector2(-8.0, -6.0), Vector2(6.0, 6.0), Color(0.46, 0.78, 0.76, 0.15), 1.0)
	draw_line(Vector2(-4.0, -6.0), Vector2(8.0, 4.0), Color(0.46, 0.78, 0.76, 0.15), 1.0)
	
	# Silhouette 1: Marta on left, profile facing towards Lena
	draw_circle(Vector2(-5.0, -3.0), 3.0, Color("182329")) # Marta's head
	draw_rect(Rect2(-7.0, 0.0, 5.0, 8.0), Color("2b3d36")) # Marta's torso
	
	# Silhouette 2: Local Lena on right, framed strictly FROM BEHIND (looking toward rainy window)
	draw_circle(Vector2(4.0, -3.5), 3.2, Color("141c22")) # Lena's hair from behind
	draw_rect(Rect2(1.5, -0.5, 6.0, 8.5), Color("1e2a32")) # Coat back
	draw_line(Vector2(4.0, 0.0), Vector2(4.0, 7.0), Color("12181d"), 0.8) # Back center seam
	
	# Subtle glass reflection glaze
	draw_line(Vector2(-10.0, 2.0), Vector2(0.0, -8.0), Color(1.0, 1.0, 1.0, 0.12), 1.0)


func _draw_beaker_planter() -> void:
	# 200ml Laboratory beaker repurposed as a domestic succulent planter (16x20 px)
	# Dual-purpose object (#composition-negative-space): institutional equipment becomes domestic shelter
	var beaker_rect := Rect2(-6.0, -6.0, 12.0, 16.0)
	
	# Potting soil inside
	draw_rect(Rect2(-5.0, -1.0, 10.0, 10.0), Color("2b1d15"))
	
	# Translucent cyan-tinted glass beaker walls
	draw_rect(beaker_rect, Color(0.46, 0.78, 0.76, 0.18))
	draw_rect(beaker_rect, Color(0.46, 0.78, 0.76, 0.8), false, 1.0)
	
	# Spout at top left
	draw_line(Vector2(-6.0, -6.0), Vector2(-8.0, -8.0), Color(0.46, 0.78, 0.76, 0.9), 1.0)
	draw_line(Vector2(-8.0, -8.0), Vector2(-5.0, -6.0), Color(0.46, 0.78, 0.76, 0.9), 1.0)
	
	# Etched graduation lines (50, 100, 150, 200 ml)
	draw_line(Vector2(2.0, 6.0), Vector2(5.0, 6.0), Color("e0e6e4"), 0.8)
	draw_line(Vector2(2.0, 2.0), Vector2(5.0, 2.0), Color("e0e6e4"), 0.8)
	draw_line(Vector2(2.0, -2.0), Vector2(5.0, -2.0), Color("e0e6e4"), 0.8)
	
	# Succulent plant sprouting upwards (jade green leaves)
	draw_circle(Vector2(0.0, -3.0), 3.2, Color("3e6350"))
	draw_circle(Vector2(-3.0, -6.0), 2.5, Color("4f7d66"))
	draw_circle(Vector2(3.0, -6.0), 2.5, Color("4f7d66"))
	draw_circle(Vector2(0.0, -9.0), 2.2, Color("5c9176"))
	# Small amber budding flower in center
	draw_circle(Vector2(0.0, -11.0), 1.4, COLOR_AMBER)


func _draw_jakub_memento_tool() -> void:
	# Jakub's technical memento used as a drafting paperweight / spirit level (26x16 px)
	# Sheet of cyan technical blueprint on desk
	var sheet_rect := Rect2(-12.0, -4.0, 24.0, 14.0)
	draw_rect(sheet_rect, Color("203340"))
	draw_rect(sheet_rect, Color("385b73"), false, 0.8)
	# Fine orthogonal grid lines on draft paper
	draw_line(Vector2(-8.0, -4.0), Vector2(-8.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	draw_line(Vector2(0.0, -4.0), Vector2(0.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	draw_line(Vector2(8.0, -4.0), Vector2(8.0, 10.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	draw_line(Vector2(-12.0, 2.0), Vector2(12.0, 2.0), Color(0.46, 0.78, 0.76, 0.25), 0.6)
	
	# Solid milled brass spirit level / memento resting on top
	var level_rect := Rect2(-9.0, -6.0, 18.0, 7.0)
	draw_rect(level_rect, Color("8f6f32"))
	draw_rect(level_rect, Color("cda35d"), false, 1.0)
	
	# Center glass vial with glowing cyan air bubble
	var vial_rect := Rect2(-4.0, -4.5, 8.0, 4.0)
	draw_rect(vial_rect, Color("142229"))
	draw_rect(vial_rect, Color(0.46, 0.78, 0.76, 0.5), false, 0.8)
	draw_circle(Vector2(0.5, -2.5), 1.2, Color("75c7c3")) # Center balanced bubble
	
	# Engraved initials "J.W." stencil
	draw_circle(Vector2(-6.5, -2.5), 0.7, Color("4a391a"))
	draw_circle(Vector2(6.5, -2.5), 0.7, Color("4a391a"))


func _draw_cipher_desk() -> void:
	# Heavy modernist study desk with combination lock drawer & gooseneck lamp (42x32 px)
	var desk_rect := Rect2(-20.0, -10.0, 40.0, 24.0)
	
	# Desktop surface (dark stained oak / teak)
	draw_rect(desk_rect, Color("38271a"))
	draw_rect(desk_rect, Color("543b27"), false, 1.0)
	
	# Desk legs / pedestal
	draw_rect(Rect2(-18.0, 14.0, 4.0, 12.0), Color("241910"))
	draw_rect(Rect2(14.0, 14.0, 4.0, 12.0), Color("241910"))
	
	# Gooseneck desk lamp on left
	draw_line(Vector2(-14.0, -10.0), Vector2(-14.0, -18.0), Color("cda35d"), 1.2)
	draw_line(Vector2(-14.0, -18.0), Vector2(-8.0, -16.0), Color("cda35d"), 1.2)
	draw_circle(Vector2(-7.0, -15.0), 3.0, Color("423223")) # Shade
	# Warm filament light cone onto desk
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var lamp_alpha := 0.22 + pulse * 0.08
	var cone_points := PackedVector2Array([
		Vector2(-7.0, -15.0),
		Vector2(-18.0, -2.0),
		Vector2(4.0, -2.0)
	])
	draw_colored_polygon(cone_points, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, lamp_alpha))
	
	# Top-right drawer with mechanical combination dial
	var drawer_rect := Rect2(2.0, -6.0, 16.0, 10.0)
	if is_activated:
		# Drawer pulled out slightly, revealing foreign handwritten sheets & Substructure sketches
		drawer_rect = Rect2(2.0, -2.0, 16.0, 12.0)
		draw_rect(drawer_rect, Color("2e1f14"))
		draw_rect(drawer_rect, COLOR_CYAN * 0.8, false, 1.0)
		
		# White/yellowed technical draft sheets peeking out
		draw_rect(Rect2(4.0, -4.0, 12.0, 6.0), Color("dcd8cd"))
		draw_line(Vector2(5.0, -2.0), Vector2(14.0, -2.0), Color("2b3d36"), 0.8) # Formula lines
		draw_line(Vector2(5.0, 0.0), Vector2(12.0, 0.0), Color("2b3d36"), 0.8)
		# Cyan unlocked bolt indicator
		draw_circle(Vector2(10.0, 4.0), 1.5, COLOR_CYAN)
	else:
		# Locked drawer flush with desk
		draw_rect(drawer_rect, Color("2b1d13"))
		draw_rect(drawer_rect, Color("4a3321"), false, 0.8)
		# Brass 4-dial combination lock faceplate
		draw_rect(Rect2(7.0, -3.0, 6.0, 4.0), Color("8f6f32"))
		draw_circle(Vector2(10.0, -1.0), 1.2, Color("cda35d"))


func _draw_tea_kettle() -> void:
	# Enameled tea kettle on stovetop with steam whistle and ceramic mugs (24x22 px)
	# Stovetop burner base
	var stove_rect := Rect2(-10.0, 4.0, 20.0, 4.0)
	draw_rect(stove_rect, Color("202a30"))
	draw_rect(stove_rect, COLOR_INFRASTRUCTURE * 0.7, false, 0.8)
	
	# Gas flamelets beneath kettle (blue/cyan)
	var pulse := sin(_pulse_phase * 4.0) * 0.5 + 0.5
	var flame_alpha := 0.6 + pulse * 0.3
	draw_circle(Vector2(-5.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	draw_circle(Vector2(0.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	draw_circle(Vector2(5.0, 4.0), 1.5, Color(0.46, 0.78, 0.76, flame_alpha))
	
	# Kettle body (dark charcoal enamel #26333c with stainless lid)
	draw_circle(Vector2(0.0, -2.0), 6.5, Color("26333c"))
	draw_rect(Rect2(-4.0, -8.0, 8.0, 3.0), Color("a8b2ac")) # Polished lid
	draw_circle(Vector2(0.0, -8.5), 1.2, Color("141a1f")) # Lid knob
	
	# Arching black handle over top
	draw_arc(Vector2(0.0, -6.0), 7.0, -PI * 0.85, -PI * 0.15, 8, Color("141a1f"), 1.4)
	
	# Spout on left emitting steam plumes
	draw_line(Vector2(-5.0, -2.0), Vector2(-10.0, -6.0), Color("26333c"), 2.0)
	var steam_pulse := sin(_pulse_phase * 3.5) * 0.5 + 0.5
	draw_circle(Vector2(-12.0 - steam_pulse * 2.0, -8.0 - steam_pulse * 4.0), 2.0 + steam_pulse * 1.5, Color(1.0, 1.0, 1.0, 0.25 * (1.0 - steam_pulse * 0.5)))
	
	# Two ceramic mugs on cork coaster next to stove (x=7..13)
	draw_rect(Rect2(7.0, 2.0, 5.0, 6.0), Color("dcd8cd")) # White ceramic mug
	draw_rect(Rect2(7.0, 2.0, 5.0, 6.0), Color("8a9e96"), false, 0.8)


func _draw_bathroom_sink() -> void:
	# Modernist ceramic washbasin with chrome fixtures (28x22 px)
	# Ceramic basin body (white ceramic #dcd8cd with subtle sage rim)
	var basin_rect := Rect2(-14.0, -4.0, 28.0, 14.0)
	draw_rect(basin_rect, Color("dcd8cd"))
	draw_rect(basin_rect, Color("8a9e96"), false, 1.0)
	
	# Inner basin bowl depth contour
	draw_rect(Rect2(-10.0, -1.0, 20.0, 9.0), Color("c5c2b6"))
	# Chrome drain ring & plug hole
	draw_circle(Vector2(0.0, 3.5), 2.2, COLOR_DARK_STEEL)
	draw_circle(Vector2(0.0, 3.5), 1.2, COLOR_INFRASTRUCTURE)
	
	# Chrome gooseneck faucet above basin
	draw_line(Vector2(0.0, -4.0), Vector2(0.0, -14.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, -14.0), Vector2(-4.0, -12.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, -14.0), Vector2(-4.0, -12.0), Color("e0e8e4"), 1.0) # Chrome glint
	
	# Hot & Cold rotary valve knobs
	draw_rect(Rect2(-7.0, -7.0, 3.0, 3.0), COLOR_CORRECTION * 0.8) # Hot (cinnabar)
	draw_rect(Rect2(4.0, -7.0, 3.0, 3.0), COLOR_CYAN * 0.8) # Cold (cyan)
	
	# S-trap exposed drain pipe down into wall
	draw_line(Vector2(0.0, 10.0), Vector2(0.0, 16.0), Color("263943"), 2.0)
	draw_line(Vector2(0.0, 16.0), Vector2(6.0, 20.0), Color("263943"), 2.0)
	draw_line(Vector2(6.0, 20.0), Vector2(10.0, 16.0), Color("263943"), 2.0)
	
	# Water droplet forming / dripping from spout
	var drop_phase := fmod(_pulse_phase * 1.8, 1.0)
	var drop_y := -11.0 + drop_phase * 14.0
	var drop_alpha := clampf(1.0 - drop_phase * 0.4, 0.2, 0.9)
	draw_circle(Vector2(-4.0, drop_y), 1.2, Color(0.46, 0.78, 0.76, drop_alpha))
	
	# Ceramic soap dish with bar of soap on left rim
	draw_rect(Rect2(-12.0, -6.0, 5.0, 2.0), Color("e8e6df"))
	draw_rect(Rect2(-11.0, -8.0, 3.5, 2.0), Color("d39a62") * 0.9)


func _draw_bathroom_mirror() -> void:
	# Framed bathroom mirror with delayed / asynchronous reflection (32x44 px)
	var frame_rect := Rect2(-16.0, -22.0, 32.0, 44.0)
	var mirror_rect := Rect2(-14.0, -20.0, 28.0, 40.0)
	
	# Dark zinc / lead frame with wall brackets
	draw_rect(frame_rect, Color("1a242a"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 1.2)
	# Wall mounting screw studs at corners
	draw_circle(Vector2(-14.0, -20.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(14.0, -20.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(-14.0, 20.0), 1.0, COLOR_INFRASTRUCTURE)
	draw_circle(Vector2(14.0, 20.0), 1.0, COLOR_INFRASTRUCTURE)
	
	# Silvered mirror surface with subtle reflection gradient
	draw_rect(mirror_rect, Color("283b47"))
	draw_rect(Rect2(-14.0, -20.0, 28.0, 20.0), Color("2f4553"))
	
	# Diagonal reflection glint lines
	draw_line(Vector2(-10.0, -18.0), Vector2(10.0, 18.0), Color(0.6, 0.75, 0.8, 0.18), 1.0)
	draw_line(Vector2(-6.0, -18.0), Vector2(14.0, 14.0), Color(0.6, 0.75, 0.8, 0.12), 1.0)
	
	# Ghostly delayed reflection silhouette of Lena & distant doorway in mirror
	var ghost_pulse := sin(_pulse_phase * 1.5) * 0.5 + 0.5
	var ghost_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.28 + ghost_pulse * 0.14)
	# Reflected doorway frame in background
	draw_rect(Rect2(2.0, -14.0, 8.0, 26.0), Color(0.12, 0.18, 0.22, 0.75))
	draw_rect(Rect2(2.0, -14.0, 8.0, 26.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.3), false, 0.8)
	# Reflected silhouette of Lena
	draw_circle(Vector2(-2.0, -4.0), 4.5, ghost_col) # Head
	draw_rect(Rect2(-5.0, 0.0, 6.0, 12.0), ghost_col) # Body & coat
	# Subtle asymmetry: coat flap in reflection
	draw_line(Vector2(-5.0, 4.0), Vector2(-8.0, 10.0), ghost_col, 1.2)


func _draw_scratched_inscription() -> void:
	# Scratched inscription on mirror glass: "NIE SZUKAJ ORYGINAŁU" (Clue R-02)
	# When viewed from front or unactivated: faint subtle scratches
	# When illuminated under oblique angle / activated: crisp glowing cyan & amber lines
	var pulse := sin(_pulse_phase * 2.5) * 0.5 + 0.5
	var is_lit := is_activated or is_player_in_range
	var alpha := 0.95 if is_lit else 0.25
	var col_scratch := COLOR_CYAN if is_lit else Color("405560")
	var col_amber := COLOR_AMBER if is_lit else Color("453a2f")
	
	# Etched razor score lines across the glass pane
	# Line 1: "NIE SZUKAJ" (symbolic geometric line groups)
	# N
	draw_line(Vector2(-16.0, -6.0), Vector2(-16.0, -1.0), col_scratch, 1.0)
	draw_line(Vector2(-16.0, -6.0), Vector2(-13.0, -1.0), col_scratch, 1.0)
	draw_line(Vector2(-13.0, -6.0), Vector2(-13.0, -1.0), col_scratch, 1.0)
	# I
	draw_line(Vector2(-11.0, -6.0), Vector2(-11.0, -1.0), col_scratch, 1.0)
	# E
	draw_line(Vector2(-9.0, -6.0), Vector2(-9.0, -1.0), col_scratch, 1.0)
	draw_line(Vector2(-9.0, -6.0), Vector2(-6.0, -6.0), col_scratch, 0.8)
	draw_line(Vector2(-9.0, -3.5), Vector2(-7.0, -3.5), col_scratch, 0.8)
	draw_line(Vector2(-9.0, -1.0), Vector2(-6.0, -1.0), col_scratch, 0.8)
	
	# Space & SZUKAJ
	# S
	draw_line(Vector2(-3.0, -6.0), Vector2(-1.0, -6.0), col_scratch, 0.8)
	draw_line(Vector2(-3.0, -6.0), Vector2(-3.0, -3.5), col_scratch, 0.8)
	draw_line(Vector2(-3.0, -3.5), Vector2(-1.0, -3.5), col_scratch, 0.8)
	draw_line(Vector2(-1.0, -3.5), Vector2(-1.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(-3.0, -1.0), Vector2(-1.0, -1.0), col_scratch, 0.8)
	# Z
	draw_line(Vector2(1.0, -6.0), Vector2(3.0, -6.0), col_scratch, 0.8)
	draw_line(Vector2(3.0, -6.0), Vector2(1.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(1.0, -1.0), Vector2(3.0, -1.0), col_scratch, 0.8)
	# U
	draw_line(Vector2(5.0, -6.0), Vector2(5.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(5.0, -1.0), Vector2(7.5, -1.0), col_scratch, 0.8)
	draw_line(Vector2(7.5, -6.0), Vector2(7.5, -1.0), col_scratch, 0.8)
	# K
	draw_line(Vector2(9.5, -6.0), Vector2(9.5, -1.0), col_scratch, 0.8)
	draw_line(Vector2(12.0, -6.0), Vector2(9.5, -3.5), col_scratch, 0.8)
	draw_line(Vector2(9.5, -3.5), Vector2(12.0, -1.0), col_scratch, 0.8)
	# A
	draw_line(Vector2(14.0, -1.0), Vector2(15.5, -6.0), col_scratch, 0.8)
	draw_line(Vector2(15.5, -6.0), Vector2(17.0, -1.0), col_scratch, 0.8)
	draw_line(Vector2(14.5, -3.5), Vector2(16.5, -3.5), col_scratch, 0.8)
	
	# Line 2: "ORYGINAŁU" (with amber & cyan highlights)
	draw_line(Vector2(-18.0, 2.0), Vector2(18.0, 2.0), Color(col_amber.r, col_amber.g, col_amber.b, alpha * 0.4), 0.6)
	# O
	draw_rect(Rect2(-16.0, 3.0, 3.5, 5.0), col_amber, false, 0.8)
	# R
	draw_line(Vector2(-11.0, 3.0), Vector2(-11.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(-11.0, 3.0), Vector2(-8.5, 3.0), col_amber, 0.8)
	draw_line(Vector2(-8.5, 3.0), Vector2(-8.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-8.5, 5.5), Vector2(-11.0, 5.5), col_amber, 0.8)
	draw_line(Vector2(-10.0, 5.5), Vector2(-8.5, 8.0), col_amber, 0.8)
	# Y
	draw_line(Vector2(-7.0, 3.0), Vector2(-5.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-4.0, 3.0), Vector2(-5.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-5.5, 5.5), Vector2(-5.5, 8.0), col_amber, 0.8)
	# G
	draw_line(Vector2(-0.5, 3.0), Vector2(-2.5, 3.0), col_amber, 0.8)
	draw_line(Vector2(-2.5, 3.0), Vector2(-2.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(-2.5, 8.0), Vector2(-0.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(-0.5, 8.0), Vector2(-0.5, 5.5), col_amber, 0.8)
	draw_line(Vector2(-0.5, 5.5), Vector2(-1.5, 5.5), col_amber, 0.8)
	# I
	draw_line(Vector2(1.5, 3.0), Vector2(1.5, 8.0), col_amber, 0.8)
	# N
	draw_line(Vector2(3.5, 3.0), Vector2(3.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(3.5, 3.0), Vector2(6.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(6.0, 3.0), Vector2(6.0, 8.0), col_amber, 0.8)
	# A
	draw_line(Vector2(8.0, 8.0), Vector2(9.5, 3.0), col_amber, 0.8)
	draw_line(Vector2(9.5, 3.0), Vector2(11.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(8.5, 5.5), Vector2(10.5, 5.5), col_amber, 0.8)
	# Ł
	draw_line(Vector2(13.0, 3.0), Vector2(13.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(13.0, 8.0), Vector2(15.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(11.8, 5.0), Vector2(14.2, 4.0), col_amber, 0.8)
	# U
	draw_line(Vector2(17.0, 3.0), Vector2(17.0, 8.0), col_amber, 0.8)
	draw_line(Vector2(17.0, 8.0), Vector2(19.5, 8.0), col_amber, 0.8)
	draw_line(Vector2(19.5, 3.0), Vector2(19.5, 8.0), col_amber, 0.8)
	
	# Micro fracture glints
	if is_lit:
		draw_circle(Vector2(-14.0 + pulse * 2.0, -3.0), 1.0, COLOR_CYAN)
		draw_circle(Vector2(10.0 - pulse * 2.0, 5.0), 1.0, COLOR_AMBER)


func _draw_apothecary_cabinet() -> void:
	# Wall-mounted medical cabinet with frosted ribbed glass door (22x30 px)
	var cab_rect := Rect2(-11.0, -15.0, 22.0, 30.0)
	draw_rect(cab_rect, Color("d0d7d4"))
	draw_rect(cab_rect, Color("24333c"), false, 1.2)
	
	# Interior shelf dividing lines
	draw_line(Vector2(-10.0, -5.0), Vector2(10.0, -5.0), Color("24333c"), 1.0)
	draw_line(Vector2(-10.0, 5.0), Vector2(10.0, 5.0), Color("24333c"), 1.0)
	
	# Top shelf: 2 amber correlation stabilizer bottles
	draw_rect(Rect2(-8.0, -13.0, 4.5, 7.0), COLOR_AMBER * 0.9)
	draw_rect(Rect2(-7.0, -14.5, 2.5, 2.0), Color("141a1f")) # Cap
	draw_rect(Rect2(-2.0, -12.0, 4.0, 6.0), Color("8f5b2b"))
	draw_rect(Rect2(-1.0, -13.5, 2.0, 2.0), Color("141a1f"))
	
	# Middle shelf: White medicine box with UCP indicator & pill blister strip
	draw_rect(Rect2(-8.0, -3.0, 8.0, 6.0), Color("f0f4f2"))
	draw_line(Vector2(-5.0, -2.0), Vector2(-5.0, 1.0), COLOR_CORRECTION, 1.0) # Cinnabar cross/bar
	draw_line(Vector2(-6.5, -0.5), Vector2(-3.5, -0.5), COLOR_CORRECTION, 1.0)
	# Silver foil blister pack on right
	draw_rect(Rect2(2.0, -2.0, 7.0, 5.0), Color("a8b2ac"))
	draw_circle(Vector2(4.0, 0.0), 1.0, COLOR_CYAN)
	draw_circle(Vector2(7.0, 0.0), 1.0, COLOR_CYAN)
	
	# Bottom shelf: Sterile gauze roll & tweezers
	draw_circle(Vector2(-5.0, 10.0), 3.5, Color("e8eee8"))
	draw_line(Vector2(2.0, 12.0), Vector2(8.0, 8.0), Color("e0e8e4"), 1.0) # Tweezers
	
	# Frosted ribbed glass door overlay with vertical fluting
	for fx in range(-9, 10, 3):
		draw_line(Vector2(float(fx), -14.0), Vector2(float(fx), 14.0), Color(0.22, 0.31, 0.36, 0.25), 0.8)
	
	# Chrome latch handle on right side
	draw_rect(Rect2(8.0, -2.0, 2.5, 4.0), Color("e0e8e4"))


func _draw_marta_bathroom_guide() -> void:
	# Architectural sightline guide marker (Marta's instruction D-03: "Zostaw drzwi w odbiciu")
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var ray_alpha := 0.35 + pulse * 0.25
	var col_amber := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ray_alpha)
	
	# Floor threshold notch
	draw_rect(Rect2(-12.0, 4.0, 24.0, 3.0), Color("1a242c"))
	draw_rect(Rect2(-12.0, 4.0, 24.0, 3.0), COLOR_INFRASTRUCTURE * 0.6, false, 0.8)
	
	# Observation line indicator pointing toward mirror on left
	draw_line(Vector2(8.0, 0.0), Vector2(-12.0, 0.0), col_amber, 1.2)
	draw_line(Vector2(-12.0, 0.0), Vector2(-8.0, -3.0), col_amber, 1.0)
	draw_line(Vector2(-12.0, 0.0), Vector2(-8.0, 3.0), col_amber, 1.0)
	
	# Amber observation tick marker
	draw_circle(Vector2(0.0, -8.0), 2.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ray_alpha * 0.8))


func _draw_bakelite_phone() -> void:
	# Heavy 1960s/70s Polish/European black bakelite desk telephone with rotary dial
	var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
	var is_ringing := not is_activated
	var shake_x: float = (sin(_pulse_phase * 24.0) * 0.8) if is_ringing else 0.0
	
	# 1. Base Housing (Heavy curved trapezoid / rounded rectangle: 24x13 px)
	var base_rect := Rect2(-12.0 + shake_x, 0.0, 24.0, 13.0)
	draw_rect(base_rect, Color("10161a")) # Deep obsidian bakelite
	draw_rect(base_rect, Color("202e38"), false, 1.0)
	# Bottom rubber foot pads
	draw_rect(Rect2(-11.0 + shake_x, 12.0, 3.0, 2.0), Color("080c0e"))
	draw_rect(Rect2(8.0 + shake_x, 12.0, 3.0, 2.0), Color("080c0e"))
	
	# 2. Chrome Cradle Forks on top
	draw_line(Vector2(-7.0 + shake_x, 0.0), Vector2(-7.0 + shake_x, -4.0), Color("c8d4ce"), 1.4)
	draw_line(Vector2(7.0 + shake_x, 0.0), Vector2(7.0 + shake_x, -4.0), Color("c8d4ce"), 1.4)
	draw_circle(Vector2(-7.0 + shake_x, -4.0), 1.2, Color("e0ece8"))
	draw_circle(Vector2(7.0 + shake_x, -4.0), 1.2, Color("e0ece8"))
	
	# 3. Rotary Dial
	var dial_center := Vector2(0.0 + shake_x, 6.5)
	draw_circle(dial_center, 5.2, Color("18232a"))
	draw_circle(dial_center, 4.2, Color("dce4e0")) # White number plate
	draw_circle(dial_center, 1.8, Color("10161a")) # Central hub
	draw_circle(dial_center, 0.9, COLOR_AMBER) # Brass center logo pin
	# Chrome finger stop bracket at bottom right (4 o'clock)
	draw_line(dial_center + Vector2(2.5, 2.5), dial_center + Vector2(4.5, 4.5), Color("b0bcba"), 1.0)
	# 10 finger holes
	for i in range(10):
		var angle := -PI * 0.75 + float(i) * (PI * 1.5 / 9.0)
		var hole_pos := dial_center + Vector2(cos(angle), sin(angle)) * 3.0
		draw_circle(hole_pos, 0.6, Color("202c34"))
	
	# 4. Handset & Cord
	if not is_activated:
		# Handset resting across cradle (with subtle vibration arcs if ringing)
		var earpiece_pos := Vector2(-9.0 + shake_x, -5.5)
		var mouthpiece_pos := Vector2(9.0 + shake_x, -5.5)
		# Earpiece cup & Mouthpiece cup
		draw_circle(earpiece_pos, 3.5, Color("10161a"))
		draw_circle(earpiece_pos, 3.5, Color("283844"), false, 0.8)
		draw_circle(mouthpiece_pos, 3.5, Color("10161a"))
		draw_circle(mouthpiece_pos, 3.5, Color("283844"), false, 0.8)
		# Connecting handle bar
		draw_line(earpiece_pos, mouthpiece_pos, Color("10161a"), 3.2)
		draw_line(earpiece_pos, mouthpiece_pos, Color("22303a"), 1.0)
		
		# Ringing acoustic vibration waves
		if is_ringing:
			var ring_alpha := 0.4 + pulse * 0.45
			draw_arc(Vector2(0.0, -9.0), 7.0, -PI * 0.8, -PI * 0.2, 8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ring_alpha), 1.0)
			draw_arc(Vector2(0.0, -12.0), 11.0, -PI * 0.75, -PI * 0.25, 8, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, ring_alpha * 0.6), 0.8)
	else:
		# Handset lifted and angled (conversation in progress D-04)
		var lift_offset := Vector2(2.0, -16.0)
		var ear_p := lift_offset + Vector2(-8.0, 3.0)
		var mouth_p := lift_offset + Vector2(8.0, -3.0)
		draw_circle(ear_p, 3.5, Color("10161a"))
		draw_circle(ear_p, 3.5, COLOR_AMBER * 0.8, false, 0.8)
		draw_circle(mouth_p, 3.5, Color("10161a"))
		draw_circle(mouth_p, 3.5, COLOR_AMBER * 0.8, false, 0.8)
		draw_line(ear_p, mouth_p, Color("10161a"), 3.2)
		draw_line(ear_p, mouth_p, COLOR_AMBER, 1.0)
		
		# Coiled cord stretching down to left side of base
		var cord_start := Vector2(-11.0, 9.0)
		var cord_end := ear_p
		for c in range(5):
			var t0 := float(c) / 5.0
			var t1 := float(c + 1) / 5.0
			var p0 := cord_start.lerp(cord_end, t0) + Vector2(sin(float(c) * 1.8) * 3.0, cos(float(c) * 1.5) * 2.0)
			var p1 := cord_start.lerp(cord_end, t1)
			draw_line(p0, p1, Color("182228"), 1.2)


func _draw_reel_tape_recorder() -> void:
	# Vintage reel-to-reel tape deck (32x22 px) with two spools and VU meter
	var deck_rect := Rect2(-16.0, -11.0, 32.0, 22.0)
	
	# Teak/walnut outer wooden chassis
	draw_rect(deck_rect, Color("342217"))
	draw_rect(deck_rect, Color("1e130c"), false, 1.2)
	
	# Brushed aluminum faceplate
	var face_rect := Rect2(-14.0, -9.0, 28.0, 18.0)
	draw_rect(face_rect, Color("94a29d"))
	draw_rect(face_rect, Color("5b6964"), false, 0.8)
	
	var is_playing := is_activated
	var rot_speed := _pulse_phase * 4.0 if is_playing else 0.0
	
	# Left Spool (Supply Reel) at (-7.0, -2.5)
	var left_hub := Vector2(-7.0, -2.5)
	var reel_r: float = 5.2
	draw_circle(left_hub, reel_r, Color("202a30")) # Dark tape layer
	draw_circle(left_hub, reel_r, Color("cbd8d3"), false, 1.0) # Reel outer flange
	draw_circle(left_hub, 1.8, Color("6b7975")) # Center hub
	for s in range(3):
		var ang := rot_speed + float(s) * (TAU / 3.0)
		draw_line(left_hub, left_hub + Vector2(cos(ang), sin(ang)) * reel_r, Color("dce7e3"), 0.8)
	
	# Right Spool (Takeup Reel) at (7.0, -2.5)
	var right_hub := Vector2(7.0, -2.5)
	draw_circle(right_hub, reel_r, Color("202a30"))
	draw_circle(right_hub, reel_r, Color("cbd8d3"), false, 1.0)
	draw_circle(right_hub, 1.8, Color("6b7975"))
	for s in range(3):
		var ang := rot_speed * 1.1 + float(s) * (TAU / 3.0)
		draw_line(right_hub, right_hub + Vector2(cos(ang), sin(ang)) * reel_r, Color("dce7e3"), 0.8)
	
	# Magnetic Tape Path between reels & Head Assembly
	var tape_col := Color("4e311f") # Ferric oxide brown
	draw_line(left_hub + Vector2(0.0, reel_r), Vector2(-2.5, 4.0), tape_col, 1.0)
	draw_line(Vector2(-2.5, 4.0), Vector2(2.5, 4.0), tape_col, 1.0)
	draw_line(Vector2(2.5, 4.0), right_hub + Vector2(0.0, reel_r), tape_col, 1.0)
	
	# Central Magnetic Head Block
	draw_rect(Rect2(-3.0, 2.0, 6.0, 3.5), Color("222e36"))
	draw_circle(Vector2(3.5, 3.5), 1.0, Color("c2cec9")) # Capstan pinch roller
	
	# VU Meter on bottom-left
	var vu_rect := Rect2(-13.0, 4.0, 6.5, 4.0)
	draw_rect(vu_rect, Color("28382d"))
	draw_rect(vu_rect, COLOR_AMBER * 0.4) # Warm backlit dial
	var needle_val := (sin(_pulse_phase * 6.0) * 0.5 + 0.5) if is_playing else 0.1
	var needle_tip := Vector2(-9.75, 4.5) + Vector2(lerpf(-2.0, 2.0, needle_val), 0.0)
	draw_line(Vector2(-9.75, 7.5), needle_tip, COLOR_CORRECTION if needle_val > 0.8 else COLOR_AMBER, 0.8)
	
	# Piano key controls on bottom-right (Rew, Play, Stop, Fwd, Rec)
	for k in range(4):
		var kx := 1.0 + float(k) * 2.8
		var k_col := COLOR_CYAN if (k == 1 and is_playing) else Color("36444c")
		draw_rect(Rect2(kx, 5.0, 2.2, 3.0), k_col)


func _draw_topography_board() -> void:
	# Wall-mounted corkboard (44x30 px) with pinned blueprints, clippings & connection strings
	var board_rect := Rect2(-22.0, -15.0, 44.0, 30.0)
	
	# Solid pine wood frame
	draw_rect(board_rect, Color("3c2819"))
	draw_rect(board_rect, Color("22160d"), false, 1.2)
	
	# Cork surface
	var cork_rect := Rect2(-20.0, -13.0, 40.0, 26.0)
	draw_rect(cork_rect, Color("5e442c"))
	
	# 1. Pinned Apartment 14 Blueprint on left (18x16 px)
	var bp_rect := Rect2(-18.0, -11.0, 18.0, 16.0)
	draw_rect(bp_rect, Color("1b3340")) # Blueprint cyan background
	draw_rect(bp_rect, Color("75c7c3"), false, 0.6)
	# Floorplan room partition lines
	draw_line(Vector2(-18.0, -3.0), Vector2(-4.0, -3.0), Color("75c7c3", 0.6), 0.7)
	draw_line(Vector2(-10.0, -11.0), Vector2(-10.0, 5.0), Color("75c7c3", 0.6), 0.7)
	# Room control node marker
	draw_circle(Vector2(-14.0, -7.0), 1.2, COLOR_AMBER) # Study
	draw_circle(Vector2(-6.0, 1.0), 1.2, COLOR_CYAN) # Bathroom
	
	# 2. Newspaper clipping on right (16x13 px) - Line 4 Tram Disaster
	var news_rect := Rect2(2.0, -11.0, 16.0, 13.0)
	draw_rect(news_rect, Color("d4dbd6"))
	draw_rect(Rect2(3.0, -10.0, 14.0, 2.0), Color("202a30")) # Headline bar
	# Text columns
	draw_line(Vector2(4.0, -6.5), Vector2(16.0, -6.5), Color("6b7a82"), 0.6)
	draw_line(Vector2(4.0, -4.5), Vector2(16.0, -4.5), Color("6b7a82"), 0.6)
	draw_line(Vector2(4.0, -2.5), Vector2(14.0, -2.5), Color("6b7a82"), 0.6)
	draw_line(Vector2(4.0, -0.5), Vector2(12.0, -0.5), Color("6b7a82"), 0.6)
	
	# 3. Graph Nodes & Connection Strings (Amber & Cyan yarn lines linking nodes)
	var node_study := Vector2(-14.0, -7.0)
	var node_bath := Vector2(-6.0, 1.0)
	var node_tram := Vector2(10.0, -5.0)
	var node_ikp := Vector2(8.0, 8.0)
	var node_substruct := Vector2(-8.0, 9.0)
	
	# Colored yarn connection strings
	draw_line(node_study, node_tram, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.8), 0.9)
	draw_line(node_tram, node_ikp, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.8), 0.9)
	draw_line(node_ikp, node_substruct, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85), 0.9)
	draw_line(node_substruct, node_bath, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.85), 0.9)
	
	# Pushpins on graph nodes
	draw_circle(node_study, 1.4, COLOR_AMBER)
	draw_circle(node_tram, 1.4, COLOR_CORRECTION)
	draw_circle(node_ikp, 1.4, COLOR_INFRASTRUCTURE)
	draw_circle(node_substruct, 1.4, COLOR_CYAN)
	draw_circle(node_bath, 1.4, COLOR_CYAN)
	
	# 4. Sticky note on bottom right: "WĘZEŁ 14 - KONTROLA CIĄGŁOŚCI"
	var note_rect := Rect2(-1.0, 4.0, 18.0, 7.0)
	draw_rect(note_rect, Color("e5c678"))
	draw_line(Vector2(1.0, 6.0), Vector2(15.0, 6.0), Color("5a441e"), 0.6)
	draw_line(Vector2(1.0, 8.0), Vector2(12.0, 8.0), Color("5a441e"), 0.6)


func _draw_jakub_desk_lamp() -> void:
	# Classic Banker's desk lamp with emerald green glass shade and brass body
	var pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	var is_lit := not is_activated # Lit by default unless toggled
	
	# Heavy circular brass base at bottom
	draw_rect(Rect2(-7.0, 5.0, 14.0, 3.0), Color("9e7e3e"))
	draw_rect(Rect2(-7.0, 5.0, 14.0, 3.0), Color("5c4820"), false, 0.8)
	
	# Curved brass gooseneck arm
	draw_line(Vector2(0.0, 5.0), Vector2(0.0, -2.0), Color("bfa058"), 1.8)
	draw_line(Vector2(0.0, -2.0), Vector2(-3.0, -7.0), Color("bfa058"), 1.8)
	
	# Banker's Emerald Green Glass Shade (18x7 px)
	var shade_rect := Rect2(-11.0, -11.0, 18.0, 7.0)
	draw_rect(shade_rect, Color("1b452e")) # Deep emerald green glass
	draw_rect(shade_rect, Color("0d2619"), false, 1.0)
	# Brass shade top bracket
	draw_rect(Rect2(-4.0, -12.5, 6.0, 2.0), Color("bfa058"))
	# White inner milk-glass lip
	draw_line(Vector2(-11.0, -4.0), Vector2(7.0, -4.0), Color("d8ece0") if is_lit else Color("7a9486"), 1.2)
	
	# Brass pull-chain switch dangling on right
	draw_line(Vector2(4.0, -4.0), Vector2(4.0, 2.0), Color("bfa058"), 0.8)
	draw_circle(Vector2(4.0, 2.5), 0.8, Color("dfc278"))
	
	# Downward illuminated light cone onto the desk surface
	if is_lit:
		var cone_alpha := 0.20 + pulse * 0.04
		var cone_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, cone_alpha)
		var cone_points: PackedVector2Array = [
			Vector2(-11.0, -4.0),
			Vector2(7.0, -4.0),
			Vector2(28.0, 18.0),
			Vector2(-32.0, 18.0)
		]
		draw_colored_polygon(cone_points, cone_col)
		# Central bright filament hot spot on desk
		draw_circle(Vector2(-2.0, 6.0), 8.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, cone_alpha * 0.6))


func _draw_tech_storage_airlock() -> void:
	# Heavy technical corridor portal / utility passage leading to Space 11
	var portal_rect := Rect2(-16.0, -28.0, 32.0, 56.0)
	
	# Reinforced structural steel frame
	draw_rect(portal_rect, COLOR_DARK_STEEL)
	draw_rect(portal_rect, COLOR_INFRASTRUCTURE, false, 1.2)
	
	# Rivet fasteners along frame perimeter
	for ry in range(-24, 25, 12):
		draw_circle(Vector2(-13.5, float(ry)), 0.8, COLOR_INFRASTRUCTURE)
		draw_circle(Vector2(13.5, float(ry)), 0.8, COLOR_INFRASTRUCTURE)
	
	# Door panel in graphite slate
	var door_rect := Rect2(-12.0, -24.0, 24.0, 50.0)
	draw_rect(door_rect, Color("1a242c"))
	
	# Vertical structural channel beams
	draw_line(Vector2(-6.0, -24.0), Vector2(-6.0, 26.0), Color("2b3c48"), 1.2)
	draw_line(Vector2(6.0, -24.0), Vector2(6.0, 26.0), Color("2b3c48"), 1.2)
	
	# Industrial ventilation louvers in upper section
	for ly in range(-20, -10, 3):
		draw_line(Vector2(-9.0, float(ly)), Vector2(9.0, float(ly)), Color("11181d"), 1.0)
		draw_line(Vector2(-9.0, float(ly) + 0.8), Vector2(9.0, float(ly) + 0.8), Color("324754"), 0.6)
	
	# Top Hazard Warning Strip (Yellow-Amber & Black diagonal stripes)
	var hazard_rect := Rect2(-15.0, -27.0, 30.0, 3.0)
	draw_rect(hazard_rect, Color("14181a"))
	for hx in range(-14, 14, 4):
		draw_line(Vector2(float(hx), -27.0), Vector2(float(hx) + 2.5, -24.0), COLOR_AMBER * 0.9, 1.0)
	
	# Consensus Lock Status Panel on right jamb at (10.0, -2.0)
	var panel_rect := Rect2(6.0, -4.0, 5.5, 10.0)
	draw_rect(panel_rect, Color("11181e"))
	draw_rect(panel_rect, COLOR_INFRASTRUCTURE, false, 0.8)
	
	var is_unlocked := is_activated
	if is_unlocked:
		# Glowing cyan consensus lock indicator (Passage open / stabilized)
		draw_circle(Vector2(8.75, 1.0), 1.6, COLOR_CYAN)
		draw_circle(Vector2(8.75, 1.0), 3.2, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.35))
	else:
		# Pulsing cinnabar security lock indicator (Secured)
		var pulse := sin(_pulse_phase * 3.0) * 0.5 + 0.5
		draw_circle(Vector2(8.75, 1.0), 1.6, Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, 0.5 + pulse * 0.5))


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

