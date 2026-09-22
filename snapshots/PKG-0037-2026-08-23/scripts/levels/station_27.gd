class_name Station27
extends Node2D

## Station 27 (Przestrzeń 27: Dług wdzięczności / Jakub otwiera wyjście serwisowe z Podstruktury) for Getting Strange Vertical Slice.
## Features Service Tunnel Junction & Technical Maintenance Point in Podstructure.
## Implements Scene 27 per FULL_STORY.md and NARRATIVE_BIBLE.md:
## Jakub Wolski uses his UCP service keycard to open the emergency exit,
## confesses that Dr Wierzbicka pulled him from the crushed Line 4 carriage and gave him 12 years of life,
## refuses naive rebellion, demanding Lena prove revealing the contradiction won't destroy people on the surface,
## culminating in unlatching the technical rolling shutter gate to Space 28 (Tramwaj bez pasażerów).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 27).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("111619")
const COLOR_WALL_TUNNEL := Color("1b2428")
const COLOR_WALL_DARK := Color("0b1013")
const COLOR_INFRASTRUCTURE := Color("527482")
const COLOR_DARK_STEEL := Color("1b272e")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.827, 0.604, 0.384, 0.22)
const COLOR_BEIGE_ASH := Color("c8a370")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CYAN_TECH := Color("5da398")
const COLOR_CORRECTION := Color("c65d58")

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal jakub_interacted()
signal badge_inspected()
signal monitor_inspected()
signal console_inspected()
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

var is_jakub_interacted: bool = false
var is_badge_inspected: bool = false
var is_monitor_inspected: bool = false
var is_console_inspected: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Jakub Wolski przykłada kartę magnetyczną UCP do czytnika wyjścia awaryjnego. Ciężki rygiel opada z metalicznym szczękiem.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Wierzbicka wyciągnęła mnie z tamtego wagonu. Miałem połamane żebra i krew w płucach.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "I dała ci mundur, żebyś pilnował jej porządku.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Dała mi dwanaście lat życia, Lena. Gdyby nie jej wariant, leżałbym w ziemi pod numerem 09.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Jakub wskazuje monitor stabilności powierzchni. Słupki naprężeń drżą pod wpływem obecności dwóch sprzecznych historii.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Nie chcę umierać znowu. Ale nie chcę też, żeby ludzie na górze płacili za moje ocalenie.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie przyszłam burzyć miasta. Przyszłam po to, żeby nikt nie decydował za nas, co wolno nam pamiętać.",
		"is_witness": false,
		"is_lena": true,
		"is_jakub": false,
		"is_stage_direction": false
	},
	{
		"speaker": "JAKUB",
		"text": "Więc udowodnij to. Zanim otworzę drogę do składu technicznego, obiecaj, że nie zrobisz z nich długu.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena dotyka dłoni brata. Rysa na opuszkach palców łączy ich gest w jednym punkcie oporu.",
		"is_witness": true,
		"is_lena": false,
		"is_jakub": false,
		"is_stage_direction": true
	},
	{
		"speaker": "JAKUB",
		"text": "Skład techniczny Linii 4 stoi na peronie dwudziestym ósmym. Jedźmy.",
		"is_witness": false,
		"is_lena": false,
		"is_jakub": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Brama techniczna Podstruktury unosi się w górę, odsłaniając pusty tor tramwaju bez pasażerów.",
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
		MemoryResonancePoint.PropType.JAKUB_SERVICE_OPERATOR:
			is_jakub_interacted = true
			jakub_interacted.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.SAVED_WORKER_BADGE:
			is_badge_inspected = true
			badge_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.SURFACE_STABILITY_MONITOR:
			is_monitor_inspected = true
			monitor_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.TECHNICAL_JUNCTION_CONSOLE:
			is_console_inspected = true
			console_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_27_EXIT:
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
		# Line 4: Jakub points to surface stability monitor
		is_monitor_inspected = true
		monitor_inspected.emit()
		if props:
			var mon_prop := props.get_node_or_null("SurfaceMonitor") as MemoryResonancePoint
			if mon_prop:
				mon_prop.is_activated = true
	elif dialogue_index == 8:
		# Line 8: Lena touches Jakub's hand / gesture point of resistance
		is_badge_inspected = true
		badge_inspected.emit()
		if props:
			var badge_prop := props.get_node_or_null("WorkerBadge") as MemoryResonancePoint
			if badge_prop:
				badge_prop.is_activated = true
	elif dialogue_index == 9:
		# Line 9: Exit unlocks
		_unlock_exit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_jakub_interacted = true
	is_badge_inspected = true
	is_monitor_inspected = true
	is_console_inspected = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station27Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var jakub_prop := props.get_node_or_null("JakubOperator") as MemoryResonancePoint
		if jakub_prop:
			jakub_prop.is_activated = true
		var badge_prop := props.get_node_or_null("WorkerBadge") as MemoryResonancePoint
		if badge_prop:
			badge_prop.is_activated = true
		var mon_prop := props.get_node_or_null("SurfaceMonitor") as MemoryResonancePoint
		if mon_prop:
			mon_prop.is_activated = true
		var console_prop := props.get_node_or_null("JunctionConsole") as MemoryResonancePoint
		if console_prop:
			console_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# 1. Base Service Tunnel Architecture (Sektor Serwisowy / Rozrząd Linii 4: 640x360)
	var bg_rect := Rect2(0.0, 0.0, VIEW_SIZE.x, VIEW_SIZE.y)
	draw_rect(bg_rect, COLOR_BACKGROUND)
	
	# Vaulted rough concrete and industrial steel ribs (y=40..280)
	var wall_rect := Rect2(0.0, 40.0, VIEW_SIZE.x, 240.0)
	draw_rect(wall_rect, COLOR_WALL_TUNNEL)
	
	# Heavy reinforced steel structural ribs every 80 px
	for r in range(9):
		var rx := float(r) * 80.0
		var rib_rect := Rect2(rx, 40.0, 14.0, 240.0)
		draw_rect(rib_rect, Color("141e24"))
		draw_rect(rib_rect, COLOR_INFRASTRUCTURE * 0.45, false, 1.0)
		
		# Steel rivets along rib
		for v in range(5):
			var vy := 60.0 + float(v) * 45.0
			draw_circle(Vector2(rx + 7.0, vy), 1.5, Color("2d404b"))
	
	# Overhead heavy industrial ventilation duct and high-voltage cable tray (y=42..62)
	var pulse := sin(_pulse_time * 2.2) * 0.5 + 0.5
	draw_rect(Rect2(10.0, 44.0, 620.0, 18.0), Color("0d1317"))
	draw_rect(Rect2(10.0, 44.0, 620.0, 18.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	draw_line(Vector2(15.0, 53.0), Vector2(625.0, 53.0), Color("d39a62", 0.75), 1.5)
	
	# Amber technical caution lamps
	for lam in range(7):
		var lx := 45.0 + float(lam) * 90.0
		draw_rect(Rect2(lx, 66.0, 18.0, 6.0), Color("1b272e"))
		draw_circle(Vector2(lx + 9.0, 69.0), 2.2, Color("e2b060", 0.75 + pulse * 0.25))
	
	# Stencil wall markings: "SEKTOR SERWISOWY 27 — WĘZEŁ ROZRZĄDU LINII 4"
	draw_rect(Rect2(80.0, 80.0, 480.0, 15.0), Color("091014"))
	draw_rect(Rect2(80.0, 80.0, 480.0, 15.0), COLOR_INFRASTRUCTURE * 0.35, false, 0.8)
	draw_line(Vector2(88.0, 87.5), Vector2(552.0, 87.5), Color("5da398", 0.7), 0.8)
	
	# Dense steel grated floor foundation (y=280..360)
	var floor_rect := Rect2(0.0, 280.0, VIEW_SIZE.x, 80.0)
	draw_rect(floor_rect, COLOR_WALL_DARK)
	draw_line(Vector2(0.0, 280.0), Vector2(VIEW_SIZE.x, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(0.0, 282.0), Vector2(VIEW_SIZE.x, 282.0), Color("d39a62", 0.5), 1.0)
	
	# Service grating segments and technical pit hatches
	for g in range(16):
		var gx := float(g) * 40.0
		draw_line(Vector2(gx, 284.0), Vector2(gx, 360.0), Color("162227"), 1.2)
		draw_rect(Rect2(gx + 4.0, 288.0, 32.0, 16.0), Color("121a1f"))
		draw_rect(Rect2(gx + 4.0, 288.0, 32.0, 16.0), Color("283b45", 0.4), false, 0.8)
	
	# Spotlights on Badge (x=130), Jakub (x=240), Surface Monitor (x=360), Junction Console (x=470), Exit (x=590)
	draw_circle(Vector2(130.0, 48.0), 4.0, Color("e2b060", 0.8))
	draw_circle(Vector2(240.0, 48.0), 4.5, Color("5da398", 0.85))
	draw_circle(Vector2(360.0, 48.0), 4.0, Color("c65d58", 0.85))
	draw_circle(Vector2(470.0, 48.0), 4.0, Color("5da398", 0.8))
	draw_circle(Vector2(590.0, 48.0), 4.5, Color("d39a62", 0.85))
	
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
	draw_rect(box_rect, Color(0.05, 0.08, 0.10, 0.94))
	
	var border_color := COLOR_CYAN_TECH if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_CYAN_TECH if is_jakub else (COLOR_AMBER_WARM if is_lena else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
