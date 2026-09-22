class_name Station18
extends Node2D

## Station 18 (Przestrzeń 18: Wywiad zgodności / Gabinet dr Heleny Wierzbickiej) for Getting Strange Vertical Slice.
## Represents Dr. Helena Wierzbicka's consultation room within UCP Punkt Zgodności 6.
## Features Wierzbicka's integrated recording desk, wall-mounted sensory memory map of Równia,
## bio-emotional correction galvanometer, acoustic weight conduit monitoring Podstruktura strain,
## and the secured exit toward Sala Modeli (Space 19).
## Implements D-07 (Wywiad zgodności): Wierzbicka asks sensory questions, Lena lies deliberately,
## the galvanometer accepts lies as official record, but Podstruktura strain indicator rises.
## Core narrative clue: "procedura stabilizuje wspólną narrację, nie wykrywa obiektywnej prawdy."
## Conforms to VISUAL_DESIGN.md (Sections 6.3, 7.1, 7.4), FULL_STORY.md (Scene 18), DIALOGUE_SCRIPT.md (D-07).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("111b1f")
const COLOR_WALL_OLIVE := Color("232f29")
const COLOR_WALL_PALE := Color("2a3730")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("263943")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.18)
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal desk_approached()
signal map_inspected()
signal galvanometer_triggered()
signal strain_detected()
signal airlock_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_desk_approached: bool = false
var is_map_inspected: bool = false
var is_galvanometer_triggered: bool = false
var is_strain_detected: bool = false
var is_airlock_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _airlock_open_progress: float = 0.0
var _strain_level: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "WIERZBICKA",
		"text": "Proszę usiąść. Zadaję teraz pytania o wspomnienia powiązane z przestrzenią. Odpowiedź nie musi być pełna — tylko pierwsza.",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Dobrze.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Zapach szpitala. Co pani czuła wchodząc do prosektorium?",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Środek dezynfekcyjny. Lawendę. Czyste powietrze.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Aparat galwaniczny rejestruje odpowiedź. Dane wewnętrzne: formaldehyd i zimny linoleum. Aparat przyjmuje lawendę jako wersję oficjalną.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Strona peronu. Lewa czy prawa, patrząc w kierunku jazdy pociągu?",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Prawa.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Zapis galwaniczny: prawa. Dane przeżyte: lewa — tam stali zawsze z Jakubem. Za ścianą przesuwa się ciężar.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Ciepło dłoni Jakuba. Jak pani to opisze?",
		"is_witness": false,
		"is_lena": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie pamiętam.",
		"is_witness": false,
		"is_lena": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Aparat przyjmuje: brak danych. Odcisk ciepła istnieje w podstrukturze. System stabilizuje wspólną narrację, nie wykrywa obiektywnej prawdy.",
		"is_witness": true,
		"is_lena": false,
		"is_stage_direction": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Procedura zakończona. Wyniki zostaną złożone w teczce R-01..R-06. Może pani przejść do Sali Modeli.",
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
	if is_airlock_unlocked and _airlock_open_progress < 1.0:
		_airlock_open_progress = minf(1.0, _airlock_open_progress + delta * 1.5)
		queue_redraw()
	if is_galvanometer_triggered and _strain_level < 1.0:
		_strain_level = minf(1.0, _strain_level + delta * 0.35)
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
		MemoryResonancePoint.PropType.WIERZBICKA_DESK:
			is_desk_approached = true
			desk_approached.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.SENSORY_MEMORY_MAP:
			is_map_inspected = true
			map_inspected.emit()
		MemoryResonancePoint.PropType.CORRECTION_GALVANOMETER:
			is_galvanometer_triggered = true
			galvanometer_triggered.emit()
		MemoryResonancePoint.PropType.ACOUSTIC_WEIGHT_CONDUIT:
			is_strain_detected = true
			strain_detected.emit()
		MemoryResonancePoint.PropType.MODEL_ROOM_AIRLOCK:
			if not is_airlock_unlocked and is_dialogue_completed:
				is_airlock_unlocked = true
				airlock_unlocked.emit()


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
		is_airlock_unlocked = true
		_strain_level = 1.0
		airlock_unlocked.emit()
		dialogue_completed.emit()
		var airlock_prop := props.get_node_or_null("ModelRoomAirlock") as MemoryResonancePoint
		if airlock_prop:
			airlock_prop.is_activated = true
		var galv_prop := props.get_node_or_null("CorrectionGalvanometer") as MemoryResonancePoint
		if galv_prop:
			galv_prop.is_activated = true
		var conduit_prop := props.get_node_or_null("AcousticWeightConduit") as MemoryResonancePoint
		if conduit_prop:
			conduit_prop.is_activated = true
		queue_redraw()
		return -1
	dialogue_advanced.emit(dialogue_index)
	if dialogue_lines[dialogue_index].get("is_witness", false):
		_strain_level = minf(1.0, _strain_level + 0.28)
		is_galvanometer_triggered = true
	queue_redraw()
	return dialogue_index


func _on_airlock_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)
	draw_rect(Rect2(0.0, 40.0, LEVEL_WIDTH, 240.0), COLOR_WALL_OLIVE)
	draw_rect(Rect2(0.0, 160.0, LEVEL_WIDTH, 120.0), COLOR_WALL_PALE)
	draw_line(Vector2(0.0, 160.0), Vector2(LEVEL_WIDTH, 160.0), Color("3d5248", 0.65), 1.2)
	for gx in range(0, int(LEVEL_WIDTH) + 1, 40):
		draw_line(Vector2(float(gx), 40.0), Vector2(float(gx), 280.0), Color("1a2621", 0.28), 0.7)
	for gy in range(40, 281, 20):
		draw_line(Vector2(0.0, float(gy)), Vector2(LEVEL_WIDTH, float(gy)), Color("1a2621", 0.28), 0.7)
	draw_rect(Rect2(30.0, 36.0, LEVEL_WIDTH - 60.0, 5.0), Color("d0ddd8"))
	draw_rect(Rect2(30.0, 36.0, LEVEL_WIDTH - 60.0, 5.0), COLOR_CYAN * 0.35, false, 0.8)
	draw_rect(Rect2(0.0, 280.0, LEVEL_WIDTH, 80.0), Color("1a2420"))
	draw_rect(Rect2(0.0, 276.0, LEVEL_WIDTH, 4.0), Color("101a15"))
	for fx in range(20, int(LEVEL_WIDTH), 50):
		draw_circle(Vector2(float(fx), 300.0), 0.9, Color("2a3e32", 0.4))
		draw_circle(Vector2(float(fx + 25), 318.0), 0.7, Color("344838", 0.3))
	var window_rect := Rect2(0.0, 70.0, 160.0, 90.0)
	draw_rect(window_rect, Color("0e1f1a"))
	draw_rect(window_rect, Color("2a4038", 0.6), false, 1.2)
	for i in range(4):
		draw_rect(Rect2(10.0 + float(i) * 35.0, 88.0, 22.0, 50.0), Color("1e3228", 0.55))
		draw_rect(Rect2(10.0 + float(i) * 35.0, 88.0, 22.0, 50.0), Color("3a5c44", 0.30), false, 0.8)
	draw_line(Vector2(0.0, 130.0), Vector2(160.0, 130.0), Color("4a7060", 0.35), 0.8)
	draw_rect(Rect2(0.0, 157.0, 164.0, 4.0), Color("3a4a42"))
	var sign_rect := Rect2(180.0, 50.0, 280.0, 18.0)
	draw_rect(sign_rect, Color("1a2621"))
	draw_rect(sign_rect, COLOR_INFRASTRUCTURE * 0.65, false, 1.0)
	draw_line(Vector2(190.0, 59.0), Vector2(450.0, 59.0), Color("dce5e0"), 1.2)
	draw_line(Vector2(190.0, 62.5), Vector2(340.0, 62.5), COLOR_AMBER * 0.80, 0.8)
	draw_rect(Rect2(170.0, 40.0, 10.0, 240.0), Color("1a2520"))
	draw_rect(Rect2(170.0, 40.0, 10.0, 240.0), COLOR_INFRASTRUCTURE * 0.45, false, 0.8)
	draw_rect(Rect2(510.0, 40.0, 10.0, 240.0), Color("1a2520"))
	draw_rect(Rect2(510.0, 40.0, 10.0, 240.0), COLOR_INFRASTRUCTURE * 0.45, false, 0.8)
	var amb := sin(_pulse_time * 1.2) * 0.04 + 0.10
	draw_circle(Vector2(340.0, 210.0), 55.0, Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, amb))
	if _strain_level > 0.05:
		var strain_alpha := _strain_level * 0.14
		draw_rect(Rect2(0.0, 160.0, LEVEL_WIDTH, 120.0), Color(COLOR_CORRECTION.r, COLOR_CORRECTION.g, COLOR_CORRECTION.b, strain_alpha))
	if is_airlock_unlocked:
		var pulse := sin(_pulse_time * 3.5) * 0.5 + 0.5
		var exit_indicator := Rect2(540.0, 274.0, 70.0, 4.0)
		draw_rect(exit_indicator, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + pulse * 0.5))
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		var line_data: Dictionary = dialogue_lines[dialogue_index]
		var is_witness: bool = line_data.get("is_witness", false)
		var is_lena: bool = line_data.get("is_lena", false)
		var banner_rect := Rect2(60.0, 286.0, LEVEL_WIDTH - 120.0, 48.0)
		draw_rect(banner_rect, Color(0.06, 0.11, 0.09, 0.95))
		var border_color := COLOR_AMBER if is_lena else (COLOR_CYAN if not is_witness else COLOR_CORRECTION)
		draw_rect(banner_rect, border_color * 0.85, false, 1.2)
		draw_rect(Rect2(72.0, 292.0, 140.0, 12.0), Color("0e1812"))
		draw_rect(Rect2(72.0, 292.0, 140.0, 12.0), border_color * 0.5, false, 0.8)
		draw_line(Vector2(76.0, 298.0), Vector2(206.0, 298.0), border_color, 1.0)
		draw_line(Vector2(76.0, 312.0), Vector2(550.0, 312.0), Color("d8deda"), 1.2)
		draw_line(Vector2(76.0, 322.0), Vector2(460.0, 322.0), Color("98a49e"), 1.0)
