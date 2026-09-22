class_name Station26
extends Node2D

## Station 26 (Przestrzeń 26: Próba zamknięcia / Strefa łagodnej izolacji Podstruktury, zmienne funkcje pomieszczeń po komunikatach PA i test motywacji Leny Wolskiej) for Getting Strange Vertical Slice.
## Features Adaptive Gentle Isolation Concourse in Podstructure.
## Implements Scene 26 per FULL_STORY.md and NARRATIVE_BIBLE.md:
## Dr Wierzbicka initiates gentle isolation when Lena's presence threatens structural stability,
## Rooms reallocate functions dynamically following soothing PA intercom announcements,
## Lena refuses cognitive surrender, carving her core intent on the composite wall with a stylus,
## anchoring her motivation against dissolution and unlocking the service transit to Space 27.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 26).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0e1518")
const COLOR_WALL_ISOLATION := Color("182226")
const COLOR_WALL_DARK := Color("0b1013")
const COLOR_INFRASTRUCTURE := Color("3d5a65")
const COLOR_DARK_STEEL := Color("1b272e")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN_CALMING := Color("5da398")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

enum RoomState {
	RESIDENTIAL = 0,
	ARCHIVE = 1,
	SEDATION = 2,
	DECOMPOSITION = 3,
}

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal console_inspected()
signal designator_inspected()
signal speaker_inspected()
signal motivation_anchored()
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_console_inspected: bool = false
var is_designator_inspected: bool = false
var is_speaker_inspected: bool = false
var is_motivation_anchored: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var current_room_state: RoomState = RoomState.RESIDENTIAL
var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Dr Wierzbicka uruchamia strefę łagodnej izolacji adaptacyjnej. Ściany Podstruktury wyciszają się aksamitnym szumem.",
		"is_witness": true,
		"is_lena": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Uwaga. W tej części budynku obowiązuje jedna, uzgodniona kolejność pomieszczeń.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Zmieniacie układ za moimi plecami.",
		"is_witness": false,
		"is_lena": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Nie zmieniamy. Pozwalamy przestrzeni przyjąć funkcję, która wygasza napięcie.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wskaźnik funkcyjny komory płynnie przełącza się: MIESZKALNY -> ARCHIWUM -> SEDACJA.",
		"is_witness": true,
		"is_lena": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "W przypadku rozbieżności prosimy nie forsować przejścia. Prosimy wskazać osobę, która pamięta to samo.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Próbujecie odebrać mi powód, dla którego tu weszłam.",
		"is_witness": false,
		"is_lena": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Powód, który rani wszystkich wokół, nie jest ochroną, pani Leno. To tylko przedłużony wstrząs.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena wyciąga stalowy rysik i z naciskiem ryje na ścianie Podstruktury: »PAMIĘTAM DLACZEGO PRZYSZŁAM. NIE JESTEM ADAPTACJĄ.«",
		"is_witness": true,
		"is_lena": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Nie zgubię tego.",
		"is_witness": false,
		"is_lena": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Każda rysa w szwie pociąga za sobą resztę. Ale rozumiem, że musi pani spróbować.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rekonfiguracja przestrzenna zatrzymuje się na utrwalonym znaku. Śluza serwisowa ku Przestrzeni 27 otwiera się z sykiem dekompresji.",
		"is_witness": true,
		"is_lena": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
	queue_redraw()


func _setup_station() -> void:
	if camera:
		camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)])
		camera.set_chamber(0, false)
	if player:
		player.reset_to(Vector2(50.0, 240.0))


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_resonance_triggered)
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _on_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	match type_idx:
		MemoryResonancePoint.PropType.ISOLATION_ZONE_CONSOLE:
			is_console_inspected = true
			console_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.DYNAMIC_ROOM_DESIGNATOR:
			is_designator_inspected = true
			designator_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.WIERZBICKA_PA_SPEAKER:
			is_speaker_inspected = true
			speaker_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.MOTIVATION_ANCHOR_RECORD:
			is_motivation_anchored = true
			motivation_anchored.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_26_EXIT:
			if is_exit_unlocked:
				_on_airlock_entered(player)


func start_dialogue() -> void:
	if dialogue_active:
		return
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	dialogue_advanced.emit(0)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		_finish_scene()
		return -1
	
	if dialogue_index == 4:
		# Line 4: Room function reallocates to SEDATION
		current_room_state = RoomState.SEDATION
		if props:
			var desig_prop := props.get_node_or_null("RoomDesignator") as MemoryResonancePoint
			if desig_prop:
				desig_prop.is_activated = true
	elif dialogue_index == 8:
		# Line 8: Lena carves motivation anchor record
		is_motivation_anchored = true
		motivation_anchored.emit()
		if props:
			var anchor_prop := props.get_node_or_null("MotivationAnchor") as MemoryResonancePoint
			if anchor_prop:
				anchor_prop.is_activated = true
	elif dialogue_index == 10:
		# Line 10: Exit unlocks
		_unlock_exit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_console_inspected = true
	is_designator_inspected = true
	is_speaker_inspected = true
	is_motivation_anchored = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station26Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var console_prop := props.get_node_or_null("IsolationConsole") as MemoryResonancePoint
		if console_prop:
			console_prop.is_activated = true
		var desig_prop := props.get_node_or_null("RoomDesignator") as MemoryResonancePoint
		if desig_prop:
			desig_prop.is_activated = true
		var anchor_prop := props.get_node_or_null("MotivationAnchor") as MemoryResonancePoint
		if anchor_prop:
			anchor_prop.is_activated = true
		var speaker_prop := props.get_node_or_null("PASpeaker") as MemoryResonancePoint
		if speaker_prop:
			speaker_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Base Podstructure isolation chamber architecture (Strefa łagodnej izolacji: 640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Vaulted isolation acoustic wall baffles (y=40..280)
	var wall_rect := Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0)
	draw_rect(wall_rect, COLOR_WALL_ISOLATION)
	
	# Soft acoustic dampening panels & padded structural divisions (grey sage / graphite)
	for b in range(9):
		var bx := 15.0 + float(b) * 75.0
		var panel_rect := Rect2(bx, 50.0, 60.0, 220.0)
		draw_rect(panel_rect, Color("141e22"))
		draw_rect(panel_rect, Color("263a43", 0.6), false, 1.0)
		
		# Quilted acoustic baffle texture
		for q in range(4):
			var qy := 70.0 + float(q) * 45.0
			draw_line(Vector2(bx + 10.0, qy), Vector2(bx + 50.0, qy), Color("1f2f37", 0.7), 1.0)
	
	# Overhead adaptive ventilation & atmospheric damping duct (y=48..60)
	var pulse := sin(_pulse_time * 2.0) * 0.5 + 0.5
	var air_alpha := 0.70 + pulse * 0.20
	draw_rect(Rect2(20.0, 44.0, 600.0, 16.0), Color("0b1215"))
	draw_rect(Rect2(20.0, 44.0, 600.0, 16.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	draw_line(Vector2(25.0, 52.0), Vector2(615.0, 52.0), Color(COLOR_CYAN_CALMING.r, COLOR_CYAN_CALMING.g, COLOR_CYAN_CALMING.b, air_alpha * 0.8), 1.5)
	
	# Soft ambient lumination bars (soothing cyan & muted ash)
	for lum in range(6):
		var lx := 50.0 + float(lum) * 105.0
		draw_rect(Rect2(lx, 66.0, 40.0, 4.0), Color(COLOR_CYAN_CALMING.r, COLOR_CYAN_CALMING.g, COLOR_CYAN_CALMING.b, 0.45 + pulse * 0.25))
	
	# Wall stencil banner: "STREFA ŁAGODNEJ IZOLACJI ADAPTACYJNEJ / PODSTRUKTURA — SEKTOR 26"
	draw_rect(Rect2(90.0, 78.0, 460.0, 16.0), Color("091013"))
	draw_rect(Rect2(90.0, 78.0, 460.0, 16.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	draw_line(Vector2(98.0, 86.0), Vector2(542.0, 86.0), Color(COLOR_BEIGE_ASH.r, COLOR_BEIGE_ASH.g, COLOR_BEIGE_ASH.b, 0.75), 0.8)
	
	# Dense mineral isolation floor foundation (y=280..360)
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, COLOR_WALL_DARK)
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, 282.0), Vector2(VIEW_SIZE.x, 282.0), Color("5da398", 0.4), 1.0)
	
	# Floor acoustic absorption tiles (every 32 px)
	for t in range(20):
		var tx := float(t) * 32.0
		draw_line(Vector2(tx, 284.0), Vector2(tx, 360.0), Color("121a1e"), 1.2)
		draw_rect(Rect2(tx + 4.0, 288.0, 24.0, 14.0), Color("162025"))
		draw_rect(Rect2(tx + 4.0, 288.0, 24.0, 14.0), Color("24333a", 0.4), false, 0.8)
	
	# Dynamic Room State Overlay Projection (Residential / Archive / Sedation / Decomposition)
	if current_room_state == RoomState.SEDATION:
		# Soft cyan calming mist / atmospheric sedative field
		var mist_alpha := 0.08 + sin(_pulse_time * 1.5) * 0.04
		draw_rect(Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0), Color(COLOR_CYAN_CALMING.r, COLOR_CYAN_CALMING.g, COLOR_CYAN_CALMING.b, mist_alpha))
	
	# Spotlights on Console (x=130), Designator (x=240), PA Speaker (x=360), Motivation Anchor (x=470), Exit (x=590)
	draw_circle(Vector2(130.0, 48.0), 4.0, Color("5da398", 0.7))
	draw_circle(Vector2(240.0, 48.0), 4.0, Color("c8a370", 0.7))
	draw_circle(Vector2(360.0, 48.0), 4.0, Color("e2b060", 0.8))
	draw_circle(Vector2(470.0, 48.0), 4.5, Color("c65d58", 0.85))
	draw_circle(Vector2(590.0, 48.0), 4.5, Color("5da398", 0.75))
	
	# 2. Dialogue & subtitle display
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_wierzbicka: bool = line.get("is_wierzbicka", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.05, 0.08, 0.10, 0.94))
	
	var border_color := COLOR_CYAN_CALMING if is_wierzbicka else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_CYAN_CALMING if is_wierzbicka else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
