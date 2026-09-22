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

## PRZESZKODA — dlaczego to tu jest: kapsuła pneumatyczna wykonuje własny cykl
## dostarczania teczki między stacją odbiorczą a gabinetem UCP.
## PRZESZKODA — czego wymaga od Leny: odczytania syku i przejścia przez próg,
## gdy kapsuła odsuwa się na swoje stanowisko robocze.
## PRZESZKODA — koszt porażki: korekta odsyła Lenę do automatu, a numer sprawy
## na bilecie traci jedną cyfrę, bo urząd uzgadnia zapis pod jej nieobecność.

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
const PNEUMATIC_CYCLE_DURATION := 4.0
const PNEUMATIC_CLOSED_POSITION := Vector2(490.0, 240.0)
const PNEUMATIC_OPEN_POSITION := Vector2(560.0, 240.0)

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
@onready var pneumatic_capsule: AnimatableBody2D = $Geometry/PneumaticDossierCapsule

var is_ticket_dispensed: bool = false
var is_bench_inspected: bool = false
var is_pneumatic_dispatched: bool = false
var is_diagnostic_initiated: bool = false
var is_office_door_unlocked: bool = false
var is_level_completed: bool = false
var pneumatic_cycle_time: float = 0.0
var is_pneumatic_capsule_open: bool = false
var pneumatic_correction_count: int = 0
var pneumatic_detail_faded: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _door_open_progress: float = 0.0
var _pneumatic_open_progress: float = 0.0
var _pneumatic_correction_lock: float = 0.0
var _pneumatic_audio: AudioStreamPlayer2D
var _pneumatic_whoosh: AudioStreamWAV

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
	_setup_pneumatic_cycle()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	pneumatic_cycle_time = fposmod(pneumatic_cycle_time + delta, PNEUMATIC_CYCLE_DURATION)
	_update_pneumatic_cycle()
	_pneumatic_correction_lock = maxf(0.0, _pneumatic_correction_lock - delta)
	if player and not is_pneumatic_capsule_open and _pneumatic_correction_lock <= 0.0:
		if player.global_position.x > 446.0 and player.velocity.x > 20.0:
			_apply_pneumatic_correction()
	if is_office_door_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 1.5)
		queue_redraw()
	
	queue_redraw()


func _setup_pneumatic_cycle() -> void:
	if pneumatic_capsule:
		pneumatic_capsule.sync_to_physics = true
		pneumatic_capsule.position = PNEUMATIC_CLOSED_POSITION
	_pneumatic_audio = AudioStreamPlayer2D.new()
	_pneumatic_audio.name = "PneumaticCycleAudio"
	_pneumatic_audio.bus = &"Master"
	_pneumatic_audio.max_distance = 600.0
	_pneumatic_whoosh = ProceduralAudio.create_pneumatic_tube_whoosh_sound()
	add_child(_pneumatic_audio)
	_update_pneumatic_cycle()


func _update_pneumatic_cycle() -> void:
	var previous_open := is_pneumatic_capsule_open
	var phase := fposmod(pneumatic_cycle_time, PNEUMATIC_CYCLE_DURATION)
	if phase < 1.0:
		_pneumatic_open_progress = phase
	elif phase < 2.5:
		_pneumatic_open_progress = 1.0
	elif phase < 3.5:
		_pneumatic_open_progress = 1.0 - (phase - 2.5)
	else:
		_pneumatic_open_progress = 0.0
	is_pneumatic_capsule_open = _pneumatic_open_progress >= 0.92
	if pneumatic_capsule:
		pneumatic_capsule.position = PNEUMATIC_CLOSED_POSITION.lerp(PNEUMATIC_OPEN_POSITION, _pneumatic_open_progress)
	if previous_open != is_pneumatic_capsule_open and _pneumatic_audio and _pneumatic_whoosh:
		_pneumatic_audio.stream = _pneumatic_whoosh
		_pneumatic_audio.play()
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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"trigger_correction") and not event.is_echo():
		_apply_pneumatic_correction()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed(&"interact") and not event.is_echo() and dialogue_active:
		advance_dialogue()
		get_viewport().set_input_as_handled()


func _apply_pneumatic_correction() -> void:
	if _pneumatic_correction_lock > 0.0:
		return
	pneumatic_correction_count += 1
	pneumatic_detail_faded = true
	_pneumatic_correction_lock = 0.8
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("record_decision"):
		state.record_decision(&"station_17_pneumatic_capsule_corrected", pneumatic_correction_count)
	var ticket := props.get_node_or_null("QueuingTicketDispenser") as MemoryResonancePoint
	if ticket:
		ticket.prop_subtitle = "Sprawa 084/17 — numer częściowo wyblakły"
	if player:
		player.reset_to(Vector2(45.0, 240.0))
	queue_redraw()


func _on_airlock_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_state_layer()

	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var capsule_center := PNEUMATIC_CLOSED_POSITION
	if pneumatic_capsule:
		capsule_center = pneumatic_capsule.position
	var capsule_size := Vector2(46.0, 82.0)
	var capsule_rect := Rect2(capsule_center - capsule_size * 0.5, capsule_size)
	if _pneumatic_open_progress < 0.92:
		VectorStageStyle.draw_facet_polygon(self, _rect_points(capsule_rect), VectorStageStyle.MID_PLANE, 1.0)
		draw_line(capsule_rect.position, capsule_rect.position + Vector2(capsule_rect.size.x, 0.0), VectorStageStyle.CORRECTION_OXIDE, 2.0)
	else:
		draw_line(capsule_rect.position, capsule_rect.position + Vector2(0.0, capsule_rect.size.y), VectorStageStyle.ANCHOR_CYAN, 2.0)
		draw_line(capsule_rect.end - Vector2(0.0, capsule_rect.size.y), capsule_rect.end, VectorStageStyle.ANCHOR_CYAN, 2.0)
	draw_line(Vector2(340.0, 198.0), Vector2(capsule_center.x - 24.0, capsule_center.y - 34.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_circle(Vector2(340.0, 198.0), 3.0, VectorStageStyle.ANCHOR_CYAN if is_pneumatic_capsule_open else VectorStageStyle.CORRECTION_OXIDE)
	if pneumatic_detail_faded:
		draw_line(Vector2(112.0, 112.0), Vector2(150.0, 112.0), VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.45), 2.0)
	if is_office_door_unlocked:
		draw_line(Vector2(550.0, 270.0), Vector2(610.0, 270.0), VectorStageStyle.ANCHOR_CYAN, 2.0)


func _rect_points(rect: Rect2) -> PackedVector2Array:
	return PackedVector2Array([
		rect.position,
		Vector2(rect.end.x, rect.position.y),
		rect.end,
		Vector2(rect.position.x, rect.end.y),
	])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var box_rect := Rect2(60.0, 286.0, LEVEL_WIDTH - 120.0, 48.0)
	draw_rect(box_rect, Color(0.06, 0.10, 0.13, 0.94))
	var border_color := VectorStageStyle.HUMAN_AMBER if is_lena else (VectorStageStyle.CORRECTION_OXIDE if is_witness else VectorStageStyle.ANCHOR_CYAN)
	draw_rect(box_rect, border_color, false, 1.2)
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(72.0, 300.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, border_color)
		draw_string(font, Vector2(72.0, 321.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))


func _draw_legacy_environment() -> void:
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
