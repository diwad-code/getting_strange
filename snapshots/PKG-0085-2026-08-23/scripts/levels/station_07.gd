class_name Station07
extends Node2D

## Station 07 (Przestrzeń 07: „Wróciłaś” / Klatka schodowa na Osiedlu Tarasowym) for Getting Strange Vertical Slice.
## Represents the modernist apartment block staircase at Osiedle Tarasowe.
## Implements the meeting with Marta Kurek in the doorway of Apt 14,
## full dialogue scene D-02 („Wróciłaś”, „Twarz się zgadza”, finger gesture test),
## interactive examination of the resident directory, mailboxes, blind truncated stairs (#geometry-restless-grid),
## and transition through the open apartment doorway to Przestrzeń 08.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 07), and DIALOGUE_SCRIPT.md (D-02).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_NIGHT_SKY := Color("0a1117")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Marta / home warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor / active signal)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Truncated floor / caution stencil)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_TERRAZZO := Color("3b4850")
const COLOR_TERRAZZO_LIGHT := Color("4e5d66")
const COLOR_WALL_PLASTER := Color("2c3840")
const COLOR_WALL_DADO := Color("1e272e") # Dark lower wall dado (lamperia)
const COLOR_DOOR_WOOD := Color("4a3928")
const COLOR_WINDOW_FRAME := Color("1e2830")

signal clue_inspected(id: String, prop_type: int)
signal marta_dialogue_started()
signal marta_dialogue_advanced(line_idx: int)
signal marta_dialogue_completed()
signal door_opened()
signal stair_timer_clicked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var tenant_directory_inspected: bool = false
var mailboxes_inspected: bool = false
var blind_stairs_inspected: bool = false
var stair_timer_inspected: bool = false

var marta_dialogue_active: bool = false
var marta_dialogue_index: int = -1
var is_marta_dialogue_completed: bool = false
var is_finger_gesture_done: bool = false

var is_door_open: bool = false
var door_open_progress: float = 0.0
var is_level_completed: bool = false

var stair_timer_active: bool = true
var stair_timer_remaining: float = 45.0
var stair_ambient_intensity: float = 1.0

var _pulse_time: float = 0.0

# Dialogue D-02 lines per FULL_STORY 07 & DIALOGUE_SCRIPT.md (D-02)
var marta_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "MARTA",
		"text": "Wróciłaś.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Pomyliła mnie pani z kimś.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Lena Wolska. Mieszkała tu. Siedemnaście dni temu wyszła. Nie wzięła butów na deszcz.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nigdy tu nie byłam.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO CIAŁA",
		"text": "Lena dociska paznokieć do szwu palca. Marta patrzy na dłoń.",
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "MARTA",
		"text": "Nie... Twarz się zgadza. Reszta dopiero weszła po schodach.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Możesz zostać na klatce. Tylko klatka dziś kończy się na trzecim piętrze, a jesteśmy na piątym. W środku przynajmniej wiem, gdzie były ściany.",
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	}
]

var _timer_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer

var _timer_sfx: AudioStreamWAV
var _door_sfx: AudioStreamWAV
var _blip_lena_sfx: AudioStreamWAV
var _blip_marta_sfx: AudioStreamWAV
var _transition_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	# Initial player spawn on staircase landing at bottom left (from bus arrival)
	if player:
		player.position = Vector2(70.0, 296.0)


func _setup_camera() -> void:
	if not is_instance_valid(camera):
		camera = CinematicCamera.new()
		camera.name = "Camera"
		add_child(camera)
	
	camera.target = player
	var bounds: Array[Rect2] = [
		Rect2(Vector2(0.0, 0.0), VIEW_SIZE),
	]
	camera.setup_chambers(bounds)
	camera.set_chamber(0, true)


func _setup_audio() -> void:
	_timer_sfx = ProceduralAudio.create_stair_timer_switch_sound()
	_door_sfx = ProceduralAudio.create_apartment_door_sound()
	_blip_lena_sfx = ProceduralAudio.create_dialogue_blip_sound(true)
	_blip_marta_sfx = ProceduralAudio.create_dialogue_marta_blip_sound()
	_transition_sfx = ProceduralAudio.create_airlock_seal_sound()
	
	_timer_player = _get_or_create_audio_player("TimerAudioPlayer", _timer_sfx)
	_door_player = _get_or_create_audio_player("DoorAudioPlayer", _door_sfx)
	_blip_player = _get_or_create_audio_player("BlipAudioPlayer", _blip_marta_sfx)
	_transition_player = _get_or_create_audio_player("TransitionAudioPlayer", _transition_sfx)


func _get_or_create_audio_player(node_name: String, default_stream: AudioStreamWAV) -> AudioStreamPlayer:
	var p := get_node_or_null(node_name) as AudioStreamPlayer
	if p == null:
		p = AudioStreamPlayer.new()
		p.name = node_name
		p.bus = &"Master"
		p.stream = default_stream
		add_child(p)
	return p


func _connect_props() -> void:
	if not props:
		return
	
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _process(delta: float) -> void:
	_pulse_time += delta
	
	# Stair timer countdown
	if stair_timer_active:
		stair_timer_remaining = maxf(0.0, stair_timer_remaining - delta)
		if stair_timer_remaining < 5.0:
			stair_ambient_intensity = maxf(0.35, stair_timer_remaining / 5.0)
		else:
			stair_ambient_intensity = 1.0
	
	# Door opening animation tweening
	if is_door_open and door_open_progress < 1.0:
		door_open_progress = minf(1.0, door_open_progress + delta * 2.0)
	
	queue_redraw()


func start_marta_dialogue() -> void:
	marta_dialogue_active = true
	marta_dialogue_index = 0
	_play_dialogue_blip(false)
	marta_dialogue_started.emit()
	queue_redraw()


func advance_marta_dialogue() -> int:
	if not marta_dialogue_active:
		return -1
	
	marta_dialogue_index += 1
	if marta_dialogue_index >= marta_dialogue_lines.size():
		marta_dialogue_active = false
		is_marta_dialogue_completed = true
		marta_dialogue_completed.emit()
		
		# Open apartment door upon dialogue completion
		open_apartment_door()
		
		queue_redraw()
		return -1
	
	var current_line: Dictionary = marta_dialogue_lines[marta_dialogue_index]
	var is_lena: bool = current_line.get("is_lena", false)
	_play_dialogue_blip(is_lena)
	
	if marta_dialogue_index == 4:
		is_finger_gesture_done = true
	
	marta_dialogue_advanced.emit(marta_dialogue_index)
	queue_redraw()
	return marta_dialogue_index


func open_apartment_door() -> void:
	is_door_open = true
	door_open_progress = 0.0
	if _door_player:
		_door_player.play()
	door_opened.emit()
	queue_redraw()


func trigger_stair_timer() -> void:
	stair_timer_active = true
	stair_timer_remaining = 60.0
	stair_ambient_intensity = 1.0
	stair_timer_inspected = true
	if _timer_player:
		_timer_player.play()
	stair_timer_clicked.emit()
	queue_redraw()


func _play_dialogue_blip(is_lena: bool) -> void:
	if _blip_player:
		_blip_player.stream = _blip_lena_sfx if is_lena else _blip_marta_sfx
		_blip_player.pitch_scale = 1.0 + randf_range(-0.03, 0.03)
		_blip_player.play()


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	
	match prop_type:
		MemoryResonancePoint.PropType.TENANT_DIRECTORY:
			tenant_directory_inspected = true
		MemoryResonancePoint.PropType.MAILBOXES:
			mailboxes_inspected = true
		MemoryResonancePoint.PropType.BLIND_STAIRS:
			blind_stairs_inspected = true
		MemoryResonancePoint.PropType.STAIR_TIMER_SWITCH:
			trigger_stair_timer()
		MemoryResonancePoint.PropType.MARTA_INTERACTION:
			if not is_marta_dialogue_completed:
				if not marta_dialogue_active:
					start_marta_dialogue()
				else:
					advance_marta_dialogue()


func _on_airlock_body_entered(body: Node2D) -> void:
	if not is_door_open or is_level_completed:
		return
	
	if body is PrototypePlayer or body.name == "Player":
		is_level_completed = true
		if _transition_player:
			_transition_player.play()
		level_completed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		if marta_dialogue_active:
			advance_marta_dialogue()
			get_viewport().set_input_as_handled()


func _draw() -> void:
	# 1. Stairwell window and outer rain panorama
	_draw_rain_window()
	
	# 2. Modernist concrete staircase architecture & walls
	_draw_staircase_architecture()
	
	# 3. Terrazzo floor structure & stairs landings
	_draw_terrazzo_floor()
	
	# 4. Apartment 14 doorway, door opening & warm domestic interior
	_draw_apartment_doorway()
	
	# 5. Blind stairs anomaly geometry
	_draw_blind_stairs_geometry()
	
	# 6. Overhead lighting and fluorescent light fixtures
	_draw_overhead_lighting()
	
	# 7. In-world dialogue subtitle banner & HUD overlays
	_draw_in_world_dialogue_overlay()


func _draw_rain_window() -> void:
	# Panoramic staircase window (x=270..390, y=40..210)
	var win_rect := Rect2(270.0, 40.0, 120.0, 170.0)
	draw_rect(win_rect, COLOR_NIGHT_SKY)
	
	# Distant rainy city silhouettes & antenna masts
	draw_rect(Rect2(275.0, 140.0, 35.0, 70.0), Color("0d151c"))
	draw_rect(Rect2(315.0, 120.0, 45.0, 90.0), Color("101922"))
	draw_rect(Rect2(365.0, 150.0, 20.0, 60.0), Color("0d151c"))
	
	# Dim amber window dots in distant housing blocks
	draw_rect(Rect2(325.0, 135.0, 3.0, 4.0), Color("d39a62", 0.35))
	draw_rect(Rect2(340.0, 155.0, 3.0, 4.0), Color("d39a62", 0.25))
	
	# Rain streaks sliding down glass pane
	for i in range(12):
		var rx: float = fposmod(float(i * 31) + 270.0, 116.0) + 272.0
		var ry: float = fposmod(float(i * 23) + _pulse_time * 65.0, 160.0) + 44.0
		var r_len: float = 6.0 + float((i * 5) % 8)
		draw_line(Vector2(rx, ry), Vector2(rx - 2.0, ry + r_len), Color(0.65, 0.75, 0.85, 0.25), 1.0)
	
	# Window steel mullions / frames
	draw_rect(win_rect, COLOR_WINDOW_FRAME, false, 2.0)
	draw_line(Vector2(330.0, 40.0), Vector2(330.0, 210.0), COLOR_WINDOW_FRAME, 1.5)
	draw_line(Vector2(270.0, 125.0), Vector2(390.0, 125.0), COLOR_WINDOW_FRAME, 1.5)


func _draw_staircase_architecture() -> void:
	# Stairwell upper wall plaster (y=0..210)
	draw_rect(Rect2(0.0, 0.0, 270.0, 210.0), COLOR_WALL_PLASTER)
	draw_rect(Rect2(390.0, 0.0, LEVEL_WIDTH - 390.0, 210.0), COLOR_WALL_PLASTER)
	
	# Lower wall dark dado / lamperia (y=210..310)
	draw_rect(Rect2(0.0, 210.0, LEVEL_WIDTH, 100.0), COLOR_WALL_DADO)
	draw_line(Vector2(0.0, 210.0), Vector2(LEVEL_WIDTH, 210.0), Color("3d4e59"), 2.0)
	
	# Electrical conduits and junction boxes along wall
	draw_line(Vector2(40.0, 50.0), Vector2(250.0, 50.0), COLOR_INFRASTRUCTURE * 0.5, 1.5)
	draw_line(Vector2(250.0, 50.0), Vector2(250.0, 275.0), COLOR_INFRASTRUCTURE * 0.5, 1.5)
	draw_rect(Rect2(246.0, 46.0, 8.0, 8.0), COLOR_DARK_STEEL)


func _draw_terrazzo_floor() -> void:
	# Main landing floor slab (y=310..360)
	draw_rect(Rect2(0.0, 310.0, LEVEL_WIDTH, 50.0), COLOR_TERRAZZO)
	draw_line(Vector2(0.0, 310.0), Vector2(LEVEL_WIDTH, 310.0), COLOR_TERRAZZO_LIGHT, 2.0)
	
	# Brass expansion joints and mineral specks in terrazzo (lastryko)
	for joint_x in [120.0, 240.0, 360.0, 480.0]:
		draw_line(Vector2(joint_x, 310.0), Vector2(joint_x, 360.0), Color("8a7b52"), 1.2)
	
	# Terrazzo mineral speckles
	for i in range(28):
		var sp_x: float = float((i * 47) % int(LEVEL_WIDTH))
		var sp_y: float = 314.0 + float((i * 13) % 40)
		var sp_col := COLOR_TERRAZZO_LIGHT if i % 2 == 0 else Color("222b30")
		draw_circle(Vector2(sp_x, sp_y), 1.0, sp_col)
	
	# Descending stair opening on left (x=0..60)
	draw_line(Vector2(0.0, 310.0), Vector2(60.0, 310.0), COLOR_AMBER * 0.8, 1.5)
	# Tubular steel safety railings on left stair landing
	draw_line(Vector2(10.0, 250.0), Vector2(60.0, 250.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(10.0, 250.0), Vector2(10.0, 310.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(60.0, 250.0), Vector2(60.0, 310.0), COLOR_INFRASTRUCTURE, 2.0)


func _draw_apartment_doorway() -> void:
	# Apartment 14 doorway at x=470..550, y=180..310
	var frame_rect := Rect2(470.0, 180.0, 80.0, 130.0)
	draw_rect(frame_rect, Color("141c22"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 2.0)
	
	# Apartment number 14 brass plaque above door
	draw_rect(Rect2(502.0, 186.0, 16.0, 8.0), Color("8a7b52"))
	draw_rect(Rect2(502.0, 186.0, 16.0, 8.0), Color("ffe8a3"), false, 0.8)
	
	# Door panel behavior:
	# When door_open_progress > 0, door swings open revealing warm apartment interior
	var open_w: float = 12.0 + door_open_progress * 56.0
	
	# Warm interior light radiating through doorway
	var light_alpha := (0.35 + sin(_pulse_time * 2.0) * 0.08) if not is_door_open else (0.65 + door_open_progress * 0.25)
	var glow_pts := PackedVector2Array([
		Vector2(474.0, 184.0),
		Vector2(474.0 + open_w, 184.0),
		Vector2(474.0 + open_w + 35.0, 310.0),
		Vector2(440.0, 310.0)
	])
	draw_colored_polygon(glow_pts, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, light_alpha * 0.45))
	
	# Interior apartment elements visible through open doorway
	if is_door_open or door_open_progress > 0.0:
		# Interior warm floor & parquet strip
		draw_rect(Rect2(474.0, 280.0, open_w, 30.0), Color("4a3420"))
		# Wooden coat rack silhouette in interior
		draw_line(Vector2(510.0, 210.0), Vector2(510.0, 280.0), Color("2e1f14"), 2.0)
		draw_line(Vector2(504.0, 218.0), Vector2(516.0, 218.0), Color("2e1f14"), 1.5)
	
	# Door leaf panel (swivels or slides)
	var door_leaf_rect := Rect2(474.0 + open_w, 184.0, maxf(2.0, 72.0 - open_w), 126.0)
	draw_rect(door_leaf_rect, COLOR_DOOR_WOOD)
	draw_rect(door_leaf_rect, Color("2d2116"), false, 1.2)
	# Brass door handle
	if door_leaf_rect.size.x > 8.0:
		draw_circle(Vector2(door_leaf_rect.position.x + 6.0, 250.0), 1.8, Color("ffe8a3"))


func _draw_blind_stairs_geometry() -> void:
	# Ascending stairs on right (x=550..640) ending solidly into raw concrete wall at x=610
	var step_y: float = 310.0
	for i in range(4):
		var sx: float = 550.0 + float(i) * 18.0
		var sy: float = step_y - float(i + 1) * 12.0
		draw_rect(Rect2(sx, sy, 22.0, 12.0), COLOR_TERRAZZO)
		draw_line(Vector2(sx, sy), Vector2(sx + 22.0, sy), COLOR_TERRAZZO_LIGHT, 1.5)
	
	# Solid unplastered concrete shear wall blocking the 6th floor flight at x=610..640
	var slab_rect := Rect2(610.0, 140.0, 30.0, 170.0)
	draw_rect(slab_rect, Color("202a30"))
	draw_rect(slab_rect, COLOR_DARK_STEEL, false, 1.5)
	
	# Stencil warning markings (#C65D58 oxide cinnabar)
	var warn_col := COLOR_CORRECTION
	for w in range(4):
		var wy: float = 180.0 + float(w) * 14.0
		draw_line(Vector2(614.0, wy), Vector2(634.0, wy + 6.0), warn_col, 1.5)


func _draw_overhead_lighting() -> void:
	# Ceiling structural beam (y=0..30)
	draw_rect(Rect2(0.0, 0.0, LEVEL_WIDTH, 30.0), Color("151e24"))
	draw_line(Vector2(0.0, 30.0), Vector2(LEVEL_WIDTH, 30.0), COLOR_INFRASTRUCTURE * 0.6, 1.5)
	
	# Overhead fluorescent diffuser lamp (x=300..340, y=26..32)
	var lamp_rect := Rect2(300.0, 26.0, 40.0, 6.0)
	var lamp_col := Color("eef6f6") if stair_ambient_intensity > 0.5 else Color("7a8585")
	draw_rect(lamp_rect, lamp_col)
	
	# Downward light cone from stairwell light fixture
	var cone_alpha := 0.05 * stair_ambient_intensity
	var light_cone_pts := PackedVector2Array([
		Vector2(295.0, 32.0),
		Vector2(345.0, 32.0),
		Vector2(450.0, 310.0),
		Vector2(190.0, 310.0)
	])
	draw_colored_polygon(light_cone_pts, Color(0.85, 0.95, 0.95, cone_alpha))


func _draw_in_world_dialogue_overlay() -> void:
	# Active dialogue subtitle bubble in the upper screen area
	if marta_dialogue_active and marta_dialogue_index >= 0 and marta_dialogue_index < marta_dialogue_lines.size():
		var line_data: Dictionary = marta_dialogue_lines[marta_dialogue_index]
		var is_lena: bool = line_data.get("is_lena", false)
		var is_stage_direction: bool = line_data.get("is_stage_direction", false)
		
		# Dialogue container box (Centered at x=320, y=32)
		var box_w: float = 540.0
		var box_h: float = 38.0
		var box_rect := Rect2(320.0 - box_w * 0.5, 14.0, box_w, box_h)
		
		draw_rect(box_rect, Color(0.08, 0.12, 0.16, 0.92))
		var border_col := COLOR_AMBER if is_lena else (COLOR_CYAN if not is_stage_direction else COLOR_CORRECTION)
		draw_rect(box_rect, border_col, false, 1.2)
		
		# Header & speaker indicator
		draw_circle(Vector2(box_rect.position.x + 12.0, box_rect.position.y + 12.0), 2.5, border_col)
		
		# Minimalistic graphic line representation of text for crisp pixel UI
		draw_line(Vector2(box_rect.position.x + 22.0, box_rect.position.y + 12.0), Vector2(box_rect.position.x + 160.0, box_rect.position.y + 12.0), border_col, 1.2)
		draw_line(Vector2(box_rect.position.x + 12.0, box_rect.position.y + 24.0), Vector2(box_rect.position.x + box_w - 20.0, box_rect.position.y + 24.0), COLOR_INFRASTRUCTURE * 0.85, 1.5)
