class_name Station22
extends Node2D

## Station 22 (Przestrzeń 22: Uległość / Biometryczna bramka tożsamości) for Getting Strange Vertical Slice.
## Features the identity verification and transit gate in Compliance Point 6.
## Implements the Yield mechanic (Uległość / D-019, FULL_STORY.md Scene 22):
## Player accepts local Lena's profile (wedding ring + Marta Kurek registered contact),
## receiving foreign sensory memory of painting apartment 14 with Marta (emulsion paint scent),
## with the biographical cost of losing the memory detail of the nurse's face after Jakub's death.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 22), DIALOGUE_SCRIPT.md.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("10181a")
const COLOR_WALL_PLASTER := Color("1e2a26")
const COLOR_WALL_LIGHT := Color("263630")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("1a2628")
const COLOR_AMBER := Color("d4a359")
const COLOR_AMBER_WARM := Color("e8c07a")
const COLOR_AMBER_GLOW := Color(0.831, 0.639, 0.349, 0.22)
const COLOR_CYAN := Color("6db3a8")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_ERASURE_GRAY := Color("5a6b68")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal biometric_gate_scanned()
signal contact_register_inspected()
signal ring_scanner_inspected()
signal paint_memory_recalled()
signal biographical_erasure_measured()
signal yield_accepted()
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

var is_gate_scanned: bool = false
var is_contact_inspected: bool = false
var is_ring_inspected: bool = false
var is_paint_recalled: bool = false
var is_biographical_erasure_measured: bool = false
var is_yield_accepted: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0
var _yield_warmth_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Bramka wymaga potwierdzenia tożsamości. W profilu jest tylko jedno nazwisko.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Czytnik biometryczny odczytuje kontur dłoni i obecność złotej obrączki. W rejestrze kontaktów widnieje Marta Kurek.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Jeśli przyjmę ten profil, drzwi się otworzą.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Uległość (Yield): przyjęcie reguły lokalnej Leny w zamian za przejście. Brak kary fizycznej — przesunięcie biograficzne.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Obrączka pasuje na palec. Marta jest wpisana jako kontakt.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Napływa obce, ciepłe wspomnienie: zapach świeżej farby emulsyjnej, śmiech Marty na korytarzu i wałek malarski w dłoni.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Nigdy z nią nie malowałam tego mieszkania... ale czuję zapach na dłoniach.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Koszt korekty: szczegół z własnej gałęzi traci ostrość. Twarz pielęgniarki z nocy po śmierci Jakuba znika z pamięci.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Próbuję przypomnieć sobie jej twarz. Zawsze to robiłam po powrocie ze szpitala... teraz jest tylko biała plama.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "To tylko zmęczenie i szok sensoryczny. Zapisuję jako błąd pomiaru i idę dalej.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_yield_accepted and _yield_warmth_progress < 1.0:
		_yield_warmth_progress = minf(1.0, _yield_warmth_progress + delta * 1.2)
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
		MemoryResonancePoint.PropType.COMPLIANCE_CONTACT_REGISTER:
			is_contact_inspected = true
			contact_register_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.RING_FITTING_SCANNER:
			is_ring_inspected = true
			ring_scanner_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.PAINT_RESIN_RESONANCE_SLAB:
			is_paint_recalled = true
			paint_memory_recalled.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.BIOMETRIC_IDENTITY_GATE:
			is_gate_scanned = true
			biometric_gate_scanned.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_22_EXIT:
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
		accept_yield()
		return -1
	
	if dialogue_index == 4:
		# Line 4: Ring fitted / contact confirmed
		is_contact_inspected = true
		is_ring_inspected = true
	elif dialogue_index == 5 or dialogue_index == 6:
		# Lines 5-6: Paint sensory influx
		is_paint_recalled = true
		paint_memory_recalled.emit()
	elif dialogue_index == 7 or dialogue_index == 8:
		# Lines 7-8: Biographical erasure measurement (nurse face blank)
		is_biographical_erasure_measured = true
		biographical_erasure_measured.emit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func accept_yield() -> void:
	if is_yield_accepted:
		return
	is_yield_accepted = true
	is_gate_scanned = true
	is_contact_inspected = true
	is_ring_inspected = true
	is_paint_recalled = true
	is_biographical_erasure_measured = true
	yield_accepted.emit()
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station22Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var gate_prop := props.get_node_or_null("BiometricIdentityGate") as MemoryResonancePoint
		if gate_prop:
			gate_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Base room background & wall structure (Strefa Tranzytowa 22: 640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Wall gradient / institutional clinical plaster & copper accents
	var wall_rect := Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0)
	draw_rect(wall_rect, COLOR_WALL_PLASTER)
	
	# Warm amber relational light wash if Yield is accepted
	if _yield_warmth_progress > 0.0:
		draw_rect(wall_rect, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, _yield_warmth_progress * 0.12))
	
	# Subtle ceiling light strip
	draw_line(Vector2(60.0, 42.0), Vector2(580.0, 42.0), Color("dcebe4", 0.35), 2.0)
	draw_line(Vector2(120.0, 42.0), Vector2(300.0, 42.0), Color("ffffff", 0.55), 1.0)
	draw_line(Vector2(360.0, 42.0), Vector2(520.0, 42.0), Color("ffffff", 0.55), 1.0)
	
	# Biometric identification conduit track across upper wall
	var pulse := sin(_pulse_time * 2.5) * 0.5 + 0.5
	var track_color := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.35 + pulse * 0.25)
	if is_exit_unlocked:
		track_color = Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.65 + pulse * 0.25)
	draw_line(Vector2(100.0, 58.0), Vector2(540.0, 58.0), track_color, 1.5)
	
	# Floor line & linoleum tiles
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, Color("16201e"))
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE * 0.7, 2.0)
	
	for i in range(16):
		var tx := float(i) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("121a18"), 1.0)
		draw_line(Vector2(0.0, 280.0 + float(i) * 20.0), Vector2(VIEW_SIZE.x, 280.0 + float(i) * 20.0), Color("121a18"), 1.0)
	
	# Wall panel seam lines
	for p in range(6):
		var px := 70.0 + float(p) * 100.0
		draw_line(Vector2(px, 40.0), Vector2(px, 280.0), Color("182420"), 1.0)
	
	# Institutional wall placard: "PUNKT ZGODNOŚCI 6 / TRANZYT 22 — BRAMKA TOŻSAMOŚCI I ULEGŁOŚĆ"
	draw_rect(Rect2(160.0, 75.0, 310.0, 18.0), Color("141e1c"))
	draw_rect(Rect2(160.0, 75.0, 310.0, 18.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	draw_line(Vector2(168.0, 84.0), Vector2(462.0, 84.0), Color("d4a359", 0.75), 0.8)
	
	# Light spotlight focusing on Biometric Gate (x=490) and Memory Slab (x=370)
	draw_circle(Vector2(490.0, 42.0), 4.0, Color("d4a359", 0.8))
	draw_circle(Vector2(370.0, 42.0), 4.0, Color("e8c07a", 0.8))
	
	# 2. Dialogue & subtitle display
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.06, 0.10, 0.09, 0.90))
	
	var border_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(box_rect, border_color * 0.7, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_witness else COLOR_CYAN)
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
