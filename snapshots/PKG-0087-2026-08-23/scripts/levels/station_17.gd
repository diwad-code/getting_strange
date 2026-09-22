class_name Station17
extends Node2D

## Station 17 (Przestrzeń 17: Punkt Zgodności 6 / Urząd UCP, wezwanie, numer sprawy sprzed 17 dni i powitanie dr Wierzbickiej) for Getting Strange Vertical Slice.
## Represents the luminous, modernist reception and waiting room of UCP Punkt Zgodności 6.
## Features the queuing ticket dispenser issuing Lena's 17-day-old case file,
## the compliance waiting bench with procedural notices,
## the brass/glass pneumatic capsule station dispatching dossier R-01..R-06,
## the diagnostic memory recording printer,
## the frosted glass consultation door to Dr. Helena Wierzbicka's office,
## and full implementation of Scene D-06 per DIALOGUE_SCRIPT.md.
## Conforms to VISUAL_DESIGN.md (Sections 6.3, 7.1, 7.4), FULL_STORY.md (Scene 17), and CONTINUITY_TRACKER.md (Wierzbicka & R-01..R-06).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("141c22") # Deep institutional slate
const COLOR_WALL_OFFWHITE := Color("2a353c") # Clean institutional wall paneling
const COLOR_CERAMIC_TILE := Color("3b4850") # Off-white broken ceramic tile grid
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_DARK_STEEL := Color("263943")
const COLOR_AMBER := Color("d39a62") # Warm amber (Lena & administrative prompt)
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.18)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Diagnostic resonance & unlocked threshold)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Discrepancy alert)

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal ticket_dispensed()
signal bench_inspected()
signal pneumatic_dispatched()
signal diagnostic_initiated()
signal office_door_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_ticket_dispensed: bool = false
var is_bench_inspected: bool = false
var is_pneumatic_dispatched: bool = false
var is_diagnostic_initiated: bool = false
var is_office_door_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _door_open_progress: float = 0.0

# Dialogue & Narrative Readouts for Space 17 (Scene 17 per FULL_STORY.md, Scene D-06 per DIALOGUE_SCRIPT.md)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "WIERZBICKA",
		"text": "Dobrze, że przyszła pani jako osoba, nie jako zjawisko.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Przyszłam z własnej woli. Mój numer sprawy istniał w waszym systemie, zanim tu trafiłam.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Zapach korytarza po identyfikacji ciała.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "To nie jest pytanie.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Proszę powiedzieć pierwszy materiał.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Chlor.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Aparat diagnostyczny drukuje w ciszy: KAWA / LINOLEUM / MOKRA WEŁNA.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Chlor jest odpowiedzią uporządkowaną. Urządzenie pokazuje odpowiedź przeżytą.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Skąd ją ma?",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Z miejsca, które pamięta panią dłużej, niż pani pamięta to miejsce.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Chcę wrócić.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Do współrzędnych czy do przekonania? Pierwsze możemy badać. Drugiego nie będę udawała, że potrafię przywrócić.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_office_door_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 1.5)
		queue_redraw()
	
	queue_redraw()


func _setup_station() -> void:
	if camera:
		camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)])
		camera.set_chamber(0, false)
	
	if player:
		player.reset_to(Vector2(45.0, 240.0))


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
		MemoryResonancePoint.PropType.QUEUING_TICKET_DISPENSER:
			is_ticket_dispensed = true
			ticket_dispensed.emit()
		
		MemoryResonancePoint.PropType.COMPLIANCE_WAITING_BENCH:
			is_bench_inspected = true
			bench_inspected.emit()
		
		MemoryResonancePoint.PropType.PNEUMATIC_DOSSIER_STATION:
			is_pneumatic_dispatched = true
			pneumatic_dispatched.emit()
		
		MemoryResonancePoint.PropType.DIAGNOSTIC_MEMORY_PRINTER:
			is_diagnostic_initiated = true
			diagnostic_initiated.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		
		MemoryResonancePoint.PropType.CONSULTATION_OFFICE_DOOR:
			if not is_office_door_unlocked and is_dialogue_completed:
				is_office_door_unlocked = true
				office_door_unlocked.emit()


func start_dialogue() -> void:
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()


func advance_dialogue() -> int:
	if not dialogue_active:
		if not is_dialogue_completed:
			start_dialogue()
			return dialogue_index
		return -1
	
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		is_office_door_unlocked = true
		office_door_unlocked.emit()
		dialogue_completed.emit()
		
		var door_prop := props.get_node_or_null("ConsultationOfficeDoor") as MemoryResonancePoint
		if door_prop:
			door_prop.is_activated = true
		
		queue_redraw()
		return -1
	
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()
	return dialogue_index


func _on_airlock_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Institutional off-white / sage modernist waiting hall background
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)
	
	# Wall paneling (clean administrative ceramic tiling / painted concrete)
	draw_rect(Rect2(0.0, 40.0, LEVEL_WIDTH, 240.0), COLOR_WALL_OFFWHITE)
	
	# Ceramic tile joint grid pattern (60x30 px modernist hospital / institutional grid)
	for gx in range(0, int(LEVEL_WIDTH) + 1, 60):
		draw_line(Vector2(float(gx), 40.0), Vector2(float(gx), 280.0), Color("202a30", 0.35), 0.8)
	for gy in range(40, 281, 30):
		draw_line(Vector2(0.0, float(gy)), Vector2(LEVEL_WIDTH, float(gy)), Color("202a30", 0.35), 0.8)
	
	# Ceiling light cove (Linear recessed flourescent troffer lighting)
	draw_rect(Rect2(40.0, 36.0, LEVEL_WIDTH - 80.0, 6.0), Color("e0ece8"))
	draw_rect(Rect2(40.0, 36.0, LEVEL_WIDTH - 80.0, 6.0), COLOR_CYAN * 0.4, false, 1.0)
	
	# Floor line (Polished light terrazzo / linoleum floor with dark border skirt)
	draw_rect(Rect2(0.0, 280.0, LEVEL_WIDTH, 80.0), Color("1e262c"))
	draw_rect(Rect2(0.0, 276.0, LEVEL_WIDTH, 4.0), Color("12171a")) # Baseboard skirting
	
	# Terrazzo subtle floor speckling
	for fx in range(20, int(LEVEL_WIDTH), 40):
		draw_circle(Vector2(float(fx), 295.0), 1.0, Color("35434d", 0.4))
		draw_circle(Vector2(float(fx + 20), 315.0), 0.8, Color("4a5c68", 0.3))
	
	# Overhead institutional directional signage strip: "PUNKT ZGODNOŚCI 06 / KONSULTACJE INDYWIDUALNE"
	var sign_rect := Rect2(180.0, 52.0, 280.0, 18.0)
	draw_rect(sign_rect, Color("1a2228"))
	draw_rect(sign_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	draw_line(Vector2(190.0, 61.0), Vector2(450.0, 61.0), Color("dce5e0"), 1.2)
	draw_line(Vector2(190.0, 64.5), Vector2(330.0, 64.5), COLOR_AMBER * 0.85, 0.8)
	
	# Modernist reception counter desk on left (x = 70..170)
	var desk_rect := Rect2(70.0, 220.0, 100.0, 60.0)
	draw_rect(desk_rect, Color("222d34"))
	draw_rect(desk_rect, COLOR_DARK_STEEL, false, 1.2)
	# Oak wood countertop ledge
	var ledge_rect := Rect2(66.0, 216.0, 108.0, 5.0)
	draw_rect(ledge_rect, Color("7a5638"))
	draw_rect(ledge_rect, Color("966c48"), false, 0.8)
	
	# Architectural column dividers between zones
	draw_rect(Rect2(295.0, 40.0, 10.0, 240.0), Color("202a30"))
	draw_rect(Rect2(295.0, 40.0, 10.0, 240.0), COLOR_INFRASTRUCTURE * 0.5, false, 0.8)
	draw_rect(Rect2(510.0, 40.0, 10.0, 240.0), Color("202a30"))
	draw_rect(Rect2(510.0, 40.0, 10.0, 240.0), COLOR_INFRASTRUCTURE * 0.5, false, 0.8)
	
	# Consultation office frosted wall glass ribbon (x = 520..640)
	var glass_wall := Rect2(520.0, 70.0, 120.0, 210.0)
	draw_rect(glass_wall, Color("1a252c", 0.65))
	draw_rect(glass_wall, COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	# Warm amber interior office lamp glow leaking through glass
	draw_circle(Vector2(585.0, 180.0), 38.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.12))
	
	# Active dialogue in-world caption panel (when speaking with Dr. Wierzbicka)
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		var line_data: Dictionary = dialogue_lines[dialogue_index]
		var speaker: String = line_data.get("speaker", "")
		var text: String = line_data.get("text", "")
		var is_witness: bool = line_data.get("is_witness", false)
		var is_lena: bool = line_data.get("is_lena", false)
		
		# Institutional dialogue lower banner
		var banner_rect := Rect2(60.0, 286.0, LEVEL_WIDTH - 120.0, 48.0)
		draw_rect(banner_rect, Color(0.08, 0.12, 0.15, 0.94))
		
		var border_color := COLOR_AMBER if is_lena else (COLOR_CYAN if not is_witness else COLOR_CORRECTION)
		draw_rect(banner_rect, border_color * 0.85, false, 1.2)
		
		# Speaker label accent bar
		draw_rect(Rect2(72.0, 292.0, 140.0, 12.0), Color("162026"))
		draw_rect(Rect2(72.0, 292.0, 140.0, 12.0), border_color * 0.5, false, 0.8)
		draw_line(Vector2(76.0, 298.0), Vector2(206.0, 298.0), border_color, 1.0)
		
		# Text abstract readouts
		draw_line(Vector2(76.0, 312.0), Vector2(550.0, 312.0), Color("d8deda"), 1.2)
		draw_line(Vector2(76.0, 322.0), Vector2(460.0, 322.0), Color("a0aca4"), 1.0)
	
	# Consultation office exit corridor indicator
	if is_office_door_unlocked:
		var exit_indicator := Rect2(560.0, 274.0, 50.0, 4.0)
		var pulse := sin(_pulse_time * 3.5) * 0.5 + 0.5
		draw_rect(exit_indicator, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + pulse * 0.5))
