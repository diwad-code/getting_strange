class_name Station25
extends Node2D

## Station 25 (Przestrzeń 25: Wejście Jakuba / Węzeł tranzytowy Linii 4, Jakub jako operator UCP, blizna pod żebrem i dialog D-09) for Getting Strange Vertical Slice.
## Features Line 4 Transit & Technical Maintenance Concourse in Compliance Point 6.
## Implements Dialogue D-09 and emotional boundary confrontation per FULL_STORY.md (Scene 25) & DIALOGUE_SCRIPT.md:
## Lena encounters her living brother Jakub Wolski working as a UCP technician/operator,
## who confronts her about her nervous hand habit (cutting finger on edge vs turning wedding ring),
## Lena reveals her memory of identifying his dead body and the glass scar under his left rib,
## Jakub sits on the floor, asserts his living independence ("Nie jestem twoim wspomnieniem"),
## and unlocks the service airlock towards Space 26 (Próba zamknięcia / strefa izolacji).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 25).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("10171a")
const COLOR_WALL_TUNNEL := Color("162227")
const COLOR_WALL_DARK := Color("0e1518")
const COLOR_INFRASTRUCTURE := Color("4a6d7c")
const COLOR_DARK_STEEL := Color("1e2a30")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")
const COLOR_RAIL_STEEL := Color("5a7684")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal cart_inspected()
signal chart_inspected()
signal sensor_inspected()
signal jakub_confronted()
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

var is_cart_inspected: bool = false
var is_chart_inspected: bool = false
var is_sensor_inspected: bool = false
var is_jakub_confronted: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0
var _jakub_sitting: bool = false

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "JAKUB",
		"text": "Pokaż dłoń.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Co?",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Moja siostra obraca obrączkę, kiedy kłamie. Ty rozcinasz sobie palec. Od drzwi wiedziałem, że coś jest nie tak.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "W mojej wersji masz bliznę pod lewym żebrem. Od szkła w wagonie.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Mam.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Widziałam ją, kiedy identyfikowałam ciało.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Jakub siada na podłodze. Nie patrzy na Lenę.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "I co teraz? Mam ci udowodnić, że oddycham?",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Właśnie to robisz. Patrzysz, czy się zgadzam.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Jakub—",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Nie jestem twoim wspomnieniem. Jeśli chcesz wyjść, pomogę osobie. Nie żałobie.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ślad w rejestrze personelu stabilizuje się. Śluza ku Przestrzeni 26 otwiera się z sykiem dekompresji.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
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
		MemoryResonancePoint.PropType.TRANSIT_MAINTENANCE_CART:
			is_cart_inspected = true
			cart_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.SCAR_DIAGNOSTIC_CHART:
			is_chart_inspected = true
			chart_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.JAKUB_HAND_GESTURE_SENSOR:
			is_sensor_inspected = true
			sensor_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.JAKUB_OPERATOR_UCP:
			is_jakub_confronted = true
			jakub_confronted.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_25_EXIT:
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
	
	if dialogue_index == 6:
		# Line 6: Jakub sits on floor
		_jakub_sitting = true
		if props:
			var jakub_prop := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
			if jakub_prop:
				jakub_prop.is_activated = true
	elif dialogue_index == 11:
		# Line 11: Exit unlocks
		_unlock_exit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_cart_inspected = true
	is_chart_inspected = true
	is_sensor_inspected = true
	is_jakub_confronted = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station25Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var cart_prop := props.get_node_or_null("MaintenanceCart") as MemoryResonancePoint
		if cart_prop:
			cart_prop.is_activated = true
		var chart_prop := props.get_node_or_null("ScarChart") as MemoryResonancePoint
		if chart_prop:
			chart_prop.is_activated = true
		var sensor_prop := props.get_node_or_null("GestureSensor") as MemoryResonancePoint
		if sensor_prop:
			sensor_prop.is_activated = true
		var jakub_prop := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
		if jakub_prop:
			jakub_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Base tunnel background & transit concourse structure (Węzeł tranzytowy Linii 4: 640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Vaulted transit tunnel wall (y=40..280)
	var wall_rect := Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0)
	draw_rect(wall_rect, COLOR_WALL_TUNNEL)
	
	# Concrete tunnel arch ribs
	for a in range(8):
		var ax := 20.0 + float(a) * 85.0
		draw_line(Vector2(ax, 40.0), Vector2(ax, 280.0), Color("111a1f"), 2.5)
		draw_line(Vector2(ax + 2.0, 40.0), Vector2(ax + 2.0, 280.0), Color("263943", 0.6), 1.0)
	
	# Overhead traction power catenary & suspension cables (Line 4 power feed)
	var pulse := sin(_pulse_time * 2.2) * 0.5 + 0.5
	var catenary_alpha := 0.70 + pulse * 0.20
	draw_line(Vector2(20.0, 48.0), Vector2(620.0, 48.0), Color("263943"), 3.0)
	draw_line(Vector2(20.0, 48.0), Vector2(620.0, 48.0), Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, catenary_alpha * 0.8), 1.2)
	draw_line(Vector2(20.0, 56.0), Vector2(620.0, 56.0), Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, catenary_alpha * 0.6), 1.0)
	
	# Catenary vertical droppers
	for d in range(12):
		var dx := 40.0 + float(d) * 48.0
		draw_line(Vector2(dx, 40.0), Vector2(dx, 56.0), Color("3d5864", 0.7), 1.0)
		draw_circle(Vector2(dx, 48.0), 2.0, Color("141f24"))
	
	# High-voltage insulator bushings and orange warning beacons
	draw_circle(Vector2(130.0, 48.0), 3.5, Color("d39a62", 0.85))
	draw_circle(Vector2(380.0, 48.0), 3.5, Color("e2b060", 0.85))
	draw_circle(Vector2(590.0, 48.0), 3.5, Color("75c7c3", 0.85))
	
	# Wall conduit raceway & vacuum cable pipe (y=72)
	draw_line(Vector2(10.0, 72.0), Vector2(630.0, 72.0), Color("0d1518"), 4.0)
	draw_line(Vector2(10.0, 72.0), Vector2(630.0, 72.0), COLOR_INFRASTRUCTURE * 0.5, 1.5)
	
	# Institutional wall stencil: "PUNKT ZGODNOŚCI 6 / TRANZYT TECHNICZNY LINII 4 — WĘZEŁ SERWISOWY"
	draw_rect(Rect2(90.0, 84.0, 460.0, 16.0), Color("0b1215"))
	draw_rect(Rect2(90.0, 84.0, 460.0, 16.0), COLOR_INFRASTRUCTURE * 0.4, false, 0.8)
	draw_line(Vector2(98.0, 92.0), Vector2(542.0, 92.0), Color("e2b060", 0.75), 0.8)
	
	# Ballast bed & track foundation (y=280..360)
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, COLOR_WALL_DARK)
	
	# Wooden sleepers / cross-ties every 24 px
	for s in range(27):
		var sx := float(s) * 24.0
		draw_rect(Rect2(sx, 282.0, 16.0, 78.0), Color("141c20"))
		draw_rect(Rect2(sx, 282.0, 16.0, 78.0), Color("24333b", 0.5), false, 0.8)
		# Rail spikes / baseplates
		draw_circle(Vector2(sx + 8.0, 290.0), 1.2, Color("3e5663"))
		draw_circle(Vector2(sx + 8.0, 310.0), 1.2, Color("3e5663"))
	
	# Dual steel running rails of Line 4
	draw_line(Vector2(0.0, 288.0), Vector2(VIEW_SIZE.x, 288.0), COLOR_RAIL_STEEL, 2.5)
	draw_line(Vector2(0.0, 287.0), Vector2(VIEW_SIZE.x, 287.0), Color("9db3be", 0.7), 1.0) # Polished rail head
	
	draw_line(Vector2(0.0, 312.0), Vector2(VIEW_SIZE.x, 312.0), COLOR_RAIL_STEEL, 2.5)
	draw_line(Vector2(0.0, 311.0), Vector2(VIEW_SIZE.x, 311.0), Color("9db3be", 0.7), 1.0) # Polished rail head
	
	# Spotlights on Maintenance Cart (x=130), Scar Chart (x=230), Jakub (x=380), Sensor (x=480), Exit (x=590)
	draw_circle(Vector2(130.0, 48.0), 4.0, Color("4a6d7c", 0.6))
	draw_circle(Vector2(230.0, 48.0), 4.0, Color("c65d58", 0.6))
	draw_circle(Vector2(380.0, 48.0), 4.5, Color("d39a62", 0.75))
	draw_circle(Vector2(480.0, 48.0), 4.0, Color("e2b060", 0.6))
	draw_circle(Vector2(590.0, 48.0), 4.5, Color("75c7c3", 0.75))
	
	# 2. Dialogue & subtitle display
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_jakub: bool = line.get("is_jakub", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.06, 0.09, 0.11, 0.94))
	
	var border_color := COLOR_AMBER if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_AMBER if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
