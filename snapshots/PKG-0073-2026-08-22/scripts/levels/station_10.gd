class_name Station10
extends Node2D

## Station 10 (Przestrzeń 10: Telefon Jakuba / Gabinet domowy i korytarz techniczny) for Getting Strange Vertical Slice.
## Represents the home study in apartment 14 at Osiedle Tarasowe and the technical passage behind the wall.
## Implements the confrontation between Lena's grief and the living Jakub who remembers different accidents,
## full dialogue D-04 with Jakub via the Bakelite desk telephone, inspection of the reel-to-reel tape recorder,
## the topography corkboard with control circuit schematics, desk lamp lighting,
## and unlatching of the technical corridor airlock leading to Act II (Przestrzeń 11).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 10), CONTINUITY_TRACKER.md (Clue R-02, Jakub, Telefon), and DIALOGUE_SCRIPT.md (D-04).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_NIGHT_SKY := Color("0b1218")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Domestic warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor / Substructure nodes)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Correction / Line 4 disaster)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_PARQUET := Color("3d2b1f")
const COLOR_PARQUET_LIGHT := Color("543b2c")
const COLOR_WALL_PANEL := Color("233038")
const COLOR_WALL_STRIPE := Color("1c272e")
const COLOR_BOOKSHELF := Color("2c1e15")
const COLOR_DESK_OAK := Color("453224")

signal clue_inspected(id: String, prop_type: int)
signal phone_ringing_started()
signal phone_answered()
signal jakub_dialogue_started()
signal jakub_dialogue_advanced(line_idx: int)
signal jakub_dialogue_completed()
signal tape_playback_toggled(is_playing: bool)
signal technical_airlock_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var phone_inspected: bool = false
var tape_inspected: bool = false
var board_inspected: bool = false
var lamp_inspected: bool = false
var airlock_inspected: bool = false

var is_phone_ringing: bool = true
var is_phone_answered: bool = false
var is_tape_playing: bool = false
var is_airlock_unlocked: bool = false
var is_level_completed: bool = false

var jakub_dialogue_active: bool = false
var jakub_dialogue_index: int = -1
var is_jakub_dialogue_completed: bool = false

var _door_open_progress: float = 0.0
var _pulse_time: float = 0.0
var _ring_timer: float = 0.0
var _step_timer: float = 0.0

# Dialogue lines for Space 10 (D-04 per FULL_STORY 10 & DIALOGUE_SCRIPT.md)
var jakub_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "JAKUB",
		"text": "Odbierz jeszcze raz, a spróbuję uwierzyć, że żyjesz.",
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Kto mówi?",
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Dobrze. Zaczynamy od kary. Jakub. Twój brat, karta techniczna, ostatni idiota, który ci ufał.",
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Lena zastyga przy biurku. Dłoń zaciska się na ebonitowej słuchawce.",
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Podaj datę wypadku.",
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Którego?",
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Na Linii 4.",
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Lena, ja tam pracuję. Mamy więcej niż jeden.",
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Trzeci listopada. Miałeś dwadzieścia lat.",
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "W słuchawce zapada głęboka, ciężka cisza.",
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Gdzie jesteś?",
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "U kobiety, która twierdzi, że mnie zna.",
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "To nie zawęża.",
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	}
]

var _bell_player: AudioStreamPlayer
var _pickup_player: AudioStreamPlayer
var _tape_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer


func _ready() -> void:
	_setup_audio_players()
	_connect_signals()
	_configure_camera()
	phone_ringing_started.emit()


func _setup_audio_players() -> void:
	_bell_player = AudioStreamPlayer.new()
	_bell_player.name = "BellAudioPlayer"
	_bell_player.stream = ProceduralAudio.create_bakelite_bell_sound()
	_bell_player.bus = &"Master"
	add_child(_bell_player)

	_pickup_player = AudioStreamPlayer.new()
	_pickup_player.name = "PickupAudioPlayer"
	_pickup_player.stream = ProceduralAudio.create_handset_pickup_sound()
	_pickup_player.bus = &"Master"
	add_child(_pickup_player)

	_tape_player = AudioStreamPlayer.new()
	_tape_player.name = "TapeAudioPlayer"
	_tape_player.stream = ProceduralAudio.create_tape_motor_hum_sound()
	_tape_player.bus = &"Master"
	add_child(_tape_player)

	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.bus = &"Master"
	add_child(_blip_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.bus = &"Master"
	add_child(_door_player)


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_prop_resonance)

	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _configure_camera() -> void:
	if camera:
		var bounds: Array[Rect2] = [
			Rect2(Vector2.ZERO, VIEW_SIZE)
		]
		camera.setup_chambers(bounds)
		camera.set_chamber(0, true)


func _process(delta: float) -> void:
	_pulse_time += delta
	
	# Periodic phone ringing until answered
	if is_phone_ringing and not is_phone_answered:
		_ring_timer += delta
		if _ring_timer >= 2.4:
			_ring_timer = 0.0
			if _bell_player:
				_bell_player.play()

	# Footstep sound effects on parquet
	if player and player.is_on_floor() and absf(player.velocity.x) > 10.0:
		_step_timer += delta
		if _step_timer >= 0.32:
			_step_timer = 0.0
			if player.has_node("StepAudioPlayer"):
				var sp := player.get_node("StepAudioPlayer") as AudioStreamPlayer2D
				if sp:
					sp.stream = ProceduralAudio.create_parquet_footstep_sound()
					sp.pitch_scale = randf_range(0.95, 1.05)
					sp.play()

	# Airlock door opening transition
	if is_airlock_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 0.9)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if jakub_dialogue_active:
		if event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump"):
			advance_jakub_dialogue()
			get_viewport().set_input_as_handled()


func _on_prop_resonance(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	
	match prop_type:
		MemoryResonancePoint.PropType.BAKELITE_PHONE:
			phone_inspected = true
			if not is_phone_answered:
				is_phone_answered = true
				is_phone_ringing = false
				phone_answered.emit()
				if _pickup_player:
					_pickup_player.play()
				start_jakub_dialogue()
		MemoryResonancePoint.PropType.REEL_TAPE_RECORDER:
			tape_inspected = true
			is_tape_playing = not is_tape_playing
			tape_playback_toggled.emit(is_tape_playing)
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.TOPOGRAPHY_BOARD:
			board_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.JAKUB_DESK_LAMP:
			lamp_inspected = true
		MemoryResonancePoint.PropType.TECH_STORAGE_AIRLOCK:
			airlock_inspected = true
	
	queue_redraw()


func start_jakub_dialogue() -> void:
	jakub_dialogue_active = true
	jakub_dialogue_index = 0
	jakub_dialogue_started.emit()
	_play_line_audio(0)
	queue_redraw()


func advance_jakub_dialogue() -> int:
	if not jakub_dialogue_active:
		return -1

	jakub_dialogue_index += 1
	if jakub_dialogue_index >= jakub_dialogue_lines.size():
		jakub_dialogue_active = false
		is_jakub_dialogue_completed = true
		jakub_dialogue_completed.emit()
		_check_unlock_conditions()
		queue_redraw()
		return -1

	jakub_dialogue_advanced.emit(jakub_dialogue_index)
	_play_line_audio(jakub_dialogue_index)
	queue_redraw()
	return jakub_dialogue_index


func _play_line_audio(idx: int) -> void:
	if idx < 0 or idx >= jakub_dialogue_lines.size():
		return

	var line := jakub_dialogue_lines[idx]
	if _blip_player:
		if line.get("is_jakub", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_jakub_blip_sound()
			_blip_player.pitch_scale = randf_range(0.97, 1.03)
			_blip_player.play()
		elif line.get("is_lena", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
			_blip_player.pitch_scale = randf_range(0.98, 1.02)
			_blip_player.play()
		elif line.get("is_stage_direction", false):
			_blip_player.stream = ProceduralAudio.create_paper_rustle_sound()
			_blip_player.pitch_scale = 1.0
			_blip_player.play()


func _check_unlock_conditions() -> void:
	# Unlock technical airlock once phone dialogue D-04 is completed
	if is_jakub_dialogue_completed and not is_airlock_unlocked:
		is_airlock_unlocked = true
		technical_airlock_unlocked.emit()
		if _door_player:
			_door_player.play()
		
		# Update TechStorageAirlock prop state
		if props:
			var airlock_prop := props.get_node_or_null("TechStorageAirlock") as MemoryResonancePoint
			if airlock_prop:
				airlock_prop.is_activated = true
		
		queue_redraw()


func _on_airlock_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_study_room()
	_draw_furniture_and_bookshelves()
	_draw_technical_corridor_zone()
	if jakub_dialogue_active:
		_draw_dialogue_overlay()


func _draw_study_room() -> void:
	# 1. Background wall paneling in dark modernist graphite teal with vertical pinstripes
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 360.0), COLOR_BACKGROUND)
	
	# Study room wall zone (x = 0..480 px)
	var study_wall := Rect2(0.0, 30.0, 480.0, 280.0)
	draw_rect(study_wall, COLOR_WALL_PANEL)
	
	# Vertical architectural rhythm pinstripes (spacing 32 px)
	for x in range(16, 480, 32):
		draw_line(Vector2(float(x), 30.0), Vector2(float(x), 310.0), COLOR_WALL_STRIPE, 1.2)
	
	# Dado rail / wooden picture rail at y=110
	draw_line(Vector2(0.0, 110.0), Vector2(480.0, 110.0), Color("36271c"), 2.0)
	draw_line(Vector2(0.0, 112.0), Vector2(480.0, 112.0), Color("1e140d"), 1.0)
	
	# 2. Window to rainy dawn on left wall (x=24..110, y=55..190)
	var win_rect := Rect2(24.0, 55.0, 86.0, 135.0)
	draw_rect(win_rect, COLOR_NIGHT_SKY)
	# Distant skyline silhouette of Rówień with pre-dawn pale amber glow
	draw_rect(Rect2(24.0, 150.0, 86.0, 40.0), Color("151f26"))
	draw_line(Vector2(24.0, 145.0), Vector2(110.0, 145.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.15), 1.0)
	# Window frame & glazing bars
	draw_rect(win_rect, Color("202a32"), false, 2.0)
	draw_line(Vector2(67.0, 55.0), Vector2(67.0, 190.0), Color("202a32"), 1.6)
	draw_line(Vector2(24.0, 120.0), Vector2(110.0, 120.0), Color("202a32"), 1.6)
	# Rain streaks on glass
	for r in range(6):
		var rx := 32.0 + float(r) * 12.0 + sin(_pulse_time + float(r)) * 3.0
		var ry := 65.0 + float(r * 18 % 100)
		draw_line(Vector2(rx, ry), Vector2(rx - 2.0, ry + 14.0), Color(0.45, 0.60, 0.65, 0.25), 0.8)
	
	# Cast-iron radiator under window (x=26..108, y=250..310)
	draw_rect(Rect2(26.0, 250.0, 82.0, 60.0), Color("1a242c"))
	for rad_x in range(30, 106, 6):
		draw_rect(Rect2(float(rad_x), 252.0, 4.0, 56.0), Color("283844"))
	draw_line(Vector2(26.0, 250.0), Vector2(108.0, 250.0), Color("3d5464"), 1.5)
	
	# 3. Herringbone Oak Parquet Floor (y=310..360)
	var floor_rect := Rect2(0.0, 310.0, LEVEL_WIDTH, 50.0)
	draw_rect(floor_rect, COLOR_PARQUET)
	for px in range(0, 480, 24):
		var p_col := COLOR_PARQUET_LIGHT if (px / 24) % 2 == 0 else COLOR_PARQUET
		draw_line(Vector2(float(px), 310.0), Vector2(float(px + 24), 360.0), p_col, 1.2)
		draw_line(Vector2(float(px + 24), 310.0), Vector2(float(px), 360.0), Color("261a12"), 0.8)
	
	# Baseboard moulding at y=306..310
	draw_rect(Rect2(0.0, 306.0, 480.0, 4.0), Color("322116"))


func _draw_furniture_and_bookshelves() -> void:
	# 1. Tall Technical Bookshelves on left (x=120..190, y=60..310)
	var shelf_rect := Rect2(120.0, 60.0, 70.0, 250.0)
	draw_rect(shelf_rect, COLOR_BOOKSHELF)
	draw_rect(shelf_rect, Color("1a120b"), false, 1.5)
	# Shelf shelves at y=110, 160, 210, 260
	for sy in [110.0, 160.0, 210.0, 260.0]:
		draw_line(Vector2(120.0, sy), Vector2(190.0, sy), Color("453123"), 2.0)
	# Technical binders & archival folders
	for bx in range(124, 186, 7):
		var b_col := Color("2a3b45") if (bx % 3 == 0) else (Color("5a4432") if (bx % 3 == 1) else Color("3c4d44"))
		draw_rect(Rect2(float(bx), 75.0, 5.5, 34.0), b_col)
		draw_rect(Rect2(float(bx), 125.0, 5.5, 34.0), b_col)
		draw_rect(Rect2(float(bx), 175.0, 5.5, 34.0), b_col)
		draw_rect(Rect2(float(bx), 225.0, 5.5, 34.0), b_col)

	# 2. Heavy Oak Desk in center (x=210..350, y=260..310)
	var desk_top := Rect2(210.0, 260.0, 140.0, 8.0)
	draw_rect(desk_top, COLOR_DESK_OAK)
	draw_rect(desk_top, Color("5c4432"), false, 1.0)
	# Left drawer pedestal (x=215..250, y=268..310)
	draw_rect(Rect2(215.0, 268.0, 35.0, 42.0), Color("38261a"))
	draw_rect(Rect2(218.0, 272.0, 29.0, 10.0), Color("2b1c13"))
	draw_rect(Rect2(218.0, 285.0, 29.0, 10.0), Color("2b1c13"))
	draw_rect(Rect2(218.0, 298.0, 29.0, 10.0), Color("2b1c13"))
	# Brass drawer handles
	draw_circle(Vector2(232.5, 277.0), 1.2, COLOR_AMBER)
	draw_circle(Vector2(232.5, 290.0), 1.2, COLOR_AMBER)
	draw_circle(Vector2(232.5, 303.0), 1.2, COLOR_AMBER)
	# Right desk leg
	draw_rect(Rect2(340.0, 268.0, 8.0, 42.0), Color("38261a"))
	
	# 3. Wooden Credenza for Tape Recorder on right (x=370..440, y=268..310)
	var cred_rect := Rect2(370.0, 268.0, 70.0, 42.0)
	draw_rect(cred_rect, Color("342217"))
	draw_rect(cred_rect, Color("1e130c"), false, 1.2)
	draw_line(Vector2(405.0, 268.0), Vector2(405.0, 310.0), Color("1e130c"), 1.0) # Double doors
	draw_circle(Vector2(402.0, 288.0), 1.2, COLOR_AMBER)
	draw_circle(Vector2(408.0, 288.0), 1.2, COLOR_AMBER)


func _draw_technical_corridor_zone() -> void:
	# Technical corridor portal & maintenance wall on right (x=480..640)
	var tech_wall := Rect2(480.0, 30.0, 160.0, 280.0)
	draw_rect(tech_wall, Color("162026"))
	
	# Industrial cable trays and conduit conduits running horizontally along top (y=45..65)
	draw_rect(Rect2(480.0, 45.0, 160.0, 14.0), Color("24333c"))
	draw_line(Vector2(480.0, 48.0), Vector2(640.0, 48.0), COLOR_INFRASTRUCTURE, 1.0)
	draw_line(Vector2(480.0, 54.0), Vector2(640.0, 54.0), COLOR_CYAN * 0.7, 1.0)
	
	# Technical corridor floor (Concrete / Steel treadplate)
	var tech_floor := Rect2(480.0, 310.0, 160.0, 50.0)
	draw_rect(tech_floor, Color("1b262e"))
	for tx in range(480, 640, 16):
		draw_line(Vector2(float(tx), 310.0), Vector2(float(tx), 360.0), Color("263642"), 1.0)

	# Transition divider / doorway opening at x=480
	draw_line(Vector2(480.0, 30.0), Vector2(480.0, 310.0), Color("0c1216"), 3.0)
	
	# Warm amber light spilling from study into the doorway when airlock opens
	if is_airlock_unlocked:
		var light_alpha := _door_open_progress * 0.35
		var light_poly: PackedVector2Array = [
			Vector2(480.0, 250.0),
			Vector2(480.0, 310.0),
			Vector2(610.0, 310.0),
			Vector2(580.0, 230.0)
		]
		draw_colored_polygon(light_poly, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, light_alpha))


func _draw_dialogue_overlay() -> void:
	if jakub_dialogue_index < 0 or jakub_dialogue_index >= jakub_dialogue_lines.size():
		return

	var line := jakub_dialogue_lines[jakub_dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_lena: bool = line.get("is_lena", false)
	var is_jakub: bool = line.get("is_jakub", false)
	var is_stage: bool = line.get("is_stage_direction", false)

	# Dialogue box in top center (x=110..530, y=28..78)
	var box_rect := Rect2(110.0, 24.0, 420.0, 52.0)
	draw_rect(box_rect, Color(0.08, 0.12, 0.15, 0.92))
	
	# Frame border color
	var frame_col := COLOR_AMBER if is_lena else (COLOR_CYAN if is_jakub else COLOR_INFRASTRUCTURE)
	draw_rect(box_rect, frame_col, false, 1.2)

	# Speaker accent bar on left
	draw_rect(Rect2(110.0, 24.0, 4.0, 52.0), frame_col)

	var font := ThemeDB.fallback_font
	if font:
		var speaker_col := COLOR_AMBER if is_lena else (COLOR_CYAN if is_jakub else COLOR_INFRASTRUCTURE)
		draw_string(font, Vector2(122.0, 40.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, speaker_col)
		
		var col_text := Color("ffffff") if not is_stage else COLOR_CYAN * 0.95
		draw_string(font, Vector2(122.0, 58.0), text, HORIZONTAL_ALIGNMENT_LEFT, 390, 11, col_text)
		
		# Advance hint [E] on bottom right
		var hint_pulse := sin(_pulse_time * 3.5) * 0.5 + 0.5
		var hint_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4 + hint_pulse * 0.5)
		draw_string(font, Vector2(495.0, 68.0), "[E]", HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, hint_col)

	# Dialogue pulse line indicator at bottom of box
	draw_line(Vector2(120.0, 74.0), Vector2(120.0 + 380.0 * (float(jakub_dialogue_index + 1) / float(jakub_dialogue_lines.size())), 74.0), frame_col, 1.5)
