class_name Station28
extends Node2D

## Station 28 (Przestrzeń 28: Tramwaj bez pasażerów / Finał Aktu II: Korekta) for Getting Strange Vertical Slice.
## Features Technical Tram Wagon transit through deep Substructure tunnel on Line 4.
## Implements Scene 28 per FULL_STORY.md and NARRATIVE_BIBLE.md:
## Lena and Jakub ride the moving technical train wagon toward Podstructure,
## observation windows reveal 3 simultaneous versions of Line 4 accident (empty, crowded, consensus glow),
## Jakub sees only 2; Lena sees all 3. Trace spells »ŚWIADEK« across passing station signs,
## Dr Helena Wierzbicka transmits over the intercom: »Nie ścigam państwa. Zamykam drogę, którą otwieracie za sobą.«
## pneumatic brakes engage at the end of track, opening entrance to Act III (Przestrzeń 29: Peron trzynasty).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 28).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0d1215")
const COLOR_TUNNEL_WALL := Color("141d22")
const COLOR_CARRIAGE_BODY := Color("1e2a31")
const COLOR_CARRIAGE_INTERIOR := Color("182228")
const COLOR_INFRASTRUCTURE := Color("4a6875")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal console_interacted()
signal window_inspected()
signal paradox_inspected()
signal intercom_inspected()
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

var is_console_interacted: bool = false
var is_window_inspected: bool = false
var is_paradox_inspected: bool = false
var is_intercom_inspected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _tunnel_scroll: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Techniczny skład Linii 4 rusza z szarpnięciem. Stalowe koła dudnią na rozjazdach serwisowych, wjeżdżając w głęboki tunel Podstruktury.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Patrz w okna. Za chwilę miniemy stary peron Linii 4.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Widzę go. Pusty peron... ale obok niego stoją ludzie i karetki pogotowia.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Karetki? Ja widzę tylko puste ławki i żółte taśmy zabezpieczające. I jeszcze jeden peron, z boku, całkowicie zalany błękitnym światłem.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Są trzy wersje, Jakub. Trzy różne obrazy tej samej sekundy.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Mijane tablice stacyjne rozbłyskują podwójnym widmem. Ślad przestawia litery w jedno słowo: »ŚWIADEK«.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Widzę tylko dwie. Nie byłem tam, gdzie ty. Moje oczy nie potrafią złożyć trzeciej.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Dlatego jedziemy razem. Nikt sam nie utrzyma całego obrazu.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Głośnik interkomu w kabinie trzeszczy wysokim tonem wywołania. W wagonie rozbrzmiewa chłodny głos dr Heleny Wierzbickiej.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Nie ścigam państwa. Zamykam drogę, którą otwieracie za sobą.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Skład uderza w hamulce pneumatyczne. Przed wagonem wyłania się Peron Trzynasty — wejście do właściwej Podstruktury.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
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
	_tunnel_scroll += delta * 180.0
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
		MemoryResonancePoint.PropType.TRAM_DRIVER_CONSOLE:
			is_console_interacted = true
			console_interacted.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.PANORAMIC_TRANSIT_WINDOW:
			is_window_inspected = true
			window_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.TRIPLE_ACCIDENT_PARADOX_VIEW:
			is_paradox_inspected = true
			paradox_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.WIERZBICKA_CLOSING_INTERCOM:
			is_intercom_inspected = true
			intercom_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_28_EXIT:
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
	
	if dialogue_index == 2:
		# Line 2: Lena inspects transit window
		is_window_inspected = true
		window_inspected.emit()
		if props:
			var win_prop := props.get_node_or_null("TransitWindow") as MemoryResonancePoint
			if win_prop:
				win_prop.is_activated = true
	elif dialogue_index == 5:
		# Line 5: The Trace spells ŚWIADEK / triple paradox revealed
		is_paradox_inspected = true
		paradox_inspected.emit()
		if props:
			var par_prop := props.get_node_or_null("ParadoxViewport") as MemoryResonancePoint
			if par_prop:
				par_prop.is_activated = true
	elif dialogue_index == 8:
		# Line 8: Wierzbicka intercom begins
		is_intercom_inspected = true
		intercom_inspected.emit()
		if props:
			var ic_prop := props.get_node_or_null("ClosingIntercom") as MemoryResonancePoint
			if ic_prop:
				ic_prop.is_activated = true
	elif dialogue_index == 9:
		# Line 9: Wierzbicka closes the path / brakes engage & exit unlocks
		_unlock_exit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_console_interacted = true
	is_window_inspected = true
	is_paradox_inspected = true
	is_intercom_inspected = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station28Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var con_prop := props.get_node_or_null("DriverConsole") as MemoryResonancePoint
		if con_prop:
			con_prop.is_activated = true
		var win_prop := props.get_node_or_null("TransitWindow") as MemoryResonancePoint
		if win_prop:
			win_prop.is_activated = true
		var par_prop := props.get_node_or_null("ParadoxViewport") as MemoryResonancePoint
		if par_prop:
			par_prop.is_activated = true
		var ic_prop := props.get_node_or_null("ClosingIntercom") as MemoryResonancePoint
		if ic_prop:
			ic_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Background Tunnel with parallax velocity blur (640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Moving tunnel structural ribs (dark silhouette scrolling past y=20..300)
	for r in range(12):
		var rx := fmod(float(r) * 70.0 - _tunnel_scroll, 700.0) - 60.0
		draw_rect(Rect2(rx, 20.0, 16.0, 260.0), COLOR_TUNNEL_WALL)
		draw_line(Vector2(rx + 8.0, 20.0), Vector2(rx + 8.0, 280.0), Color("091014"), 1.2)
	
	# High voltage cable streaks across tunnel ceiling
	draw_line(Vector2(0.0, 48.0), Vector2(VIEW_SIZE.x, 48.0), Color("263742"), 2.0)
	draw_line(Vector2(0.0, 52.0), Vector2(VIEW_SIZE.x, 52.0), Color("d39a62", 0.6), 1.0)
	
	# 2. Tram Carriage Interior Architecture (x=20..620, y=55..280)
	var carriage_rect := Rect2(20.0, 55.0, 600.0, 225.0)
	draw_rect(carriage_rect, COLOR_CARRIAGE_INTERIOR)
	draw_rect(carriage_rect, COLOR_INFRASTRUCTURE * 0.7, false, 2.0)
	
	# Ceiling light bar & handrails
	var pulse := sin(_pulse_time * 2.5) * 0.5 + 0.5
	draw_rect(Rect2(30.0, 60.0, 580.0, 8.0), Color("10161a"))
	draw_line(Vector2(40.0, 64.0), Vector2(600.0, 64.0), Color("5da398", 0.75 + pulse * 0.25), 2.0)
	
	# Horizontal stainless handrail tube
	draw_line(Vector2(35.0, 100.0), Vector2(605.0, 100.0), Color("4a6270"), 1.5)
	for h in range(7):
		var hx := 70.0 + float(h) * 75.0
		draw_line(Vector2(hx, 68.0), Vector2(hx, 100.0), Color("4a6270"), 1.2)
		draw_circle(Vector2(hx, 106.0), 3.0, Color("354e5b"))
		draw_circle(Vector2(hx, 106.0), 2.0, Color("182228"))
	
	# Carriage Stencil Label: "SKŁAD TECHNICZNY UCP — WAGON 04 / TRANZYT LINII 4"
	draw_rect(Rect2(90.0, 75.0, 460.0, 14.0), Color("0d1418"))
	draw_rect(Rect2(90.0, 75.0, 460.0, 14.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	draw_line(Vector2(96.0, 82.0), Vector2(544.0, 82.0), Color("c8a370", 0.7), 0.8)
	
	# Carriage Floor (y=280..360)
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, Color("080d10"))
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, 282.0), Vector2(VIEW_SIZE.x, 282.0), Color("e2b060", 0.6), 1.0)
	
	# Ribbed rubber non-slip flooring
	for f in range(20):
		var fx := float(f) * 32.0
		draw_line(Vector2(fx, 284.0), Vector2(fx, 360.0), Color("121a1f"), 1.0)
	
	# Spotlights on Driver Console (x=130), Transit Window (x=240), Paradox View (x=360), Intercom (x=470), Exit (x=590)
	draw_circle(Vector2(130.0, 64.0), 4.0, Color("5da398", 0.85))
	draw_circle(Vector2(240.0, 64.0), 4.0, Color("5da398", 0.8))
	draw_circle(Vector2(360.0, 64.0), 4.5, Color("75c7c3", 0.9))
	draw_circle(Vector2(470.0, 64.0), 4.0, Color("c65d58", 0.85))
	draw_circle(Vector2(590.0, 64.0), 4.5, Color("d39a62", 0.85))
	
	# 3. Dialogue & Subtitle HUD
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_jakub: bool = line.get("is_jakub", false)
	var is_wierzbicka: bool = line.get("is_wierzbicka", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.05, 0.08, 0.10, 0.94))
	
	var border_color := COLOR_CORRECTION if is_wierzbicka else (COLOR_CYAN_TECH if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CYAN if is_witness else COLOR_INFRASTRUCTURE)))
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := border_color
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
