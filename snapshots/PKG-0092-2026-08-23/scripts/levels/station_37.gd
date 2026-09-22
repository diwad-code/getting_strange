class_name Station37
extends Node2D

## Space 37: Komora Sygnałowa / Węzeł Nadawczy (Act III: Podstruktura)
## Subterranean signal transmission node and broadcast amplifier at -40m depth
## Narrative & Mechanical Beat: Scene 37 from FULL_STORY.md & DIALOGUE_SCRIPT.md

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_oscilloscope_inspected: bool = false
var is_patchbay_inspected: bool = false
var is_antenna_inspected: bool = false
var is_pulpit_inspected: bool = false

# Internal visuals
var _bg_color: Color = Color("070c10")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Komora Sygnałowa to centralny węzeł transmisyjny Podstruktury. Zbiegają się tu wszystkie linie pamięci wymazanej z powierzchni miasta."
	},
	{
		"speaker": "LENA",
		"text": "Spójrz na oscyloskop. Fala mojego sygnału nakłada się na sygnał Śladu. Nie znoszą się — tworzą rezonans."
	},
	{
		"speaker": "JAKUB",
		"text": "Wierzbicka uważała, że dwie wersje tej samej osoby doprowadzą do implozji siatki. Ale antena utrzymuje oba sygnały jednocześnie."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na krosownicy transmisyjnej wpięte są obwody czterech sektorów. Węzły Szymona, Marty i ofiar z Linii 4 pulsują w gotowości."
	},
	{
		"speaker": "LENA",
		"text": "Jeśli przełączymy hebelki na pulpicie injekcyjnym, nadamy pełne świadectwo bezpośrednio do miejskich odbiorników."
	},
	{
		"speaker": "JAKUB",
		"text": "To obudzi pamięć całego miasta, Lena. Ludzie zobaczą sprzeczne wersje wypadku na własne oczy."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Pulpit injekcyjny zostaje uzbrojony. Wskaźniki poziomu emisji szybują w górę ku strefie krytycznej."
	},
	{
		"speaker": "LENA",
		"text": "Nie boję się sprzeczności. Boję się ciszy, którą nam narzucili."
	},
	{
		"speaker": "JAKUB",
		"text": "Za śluzą transmisyjną zaczyna się rdzeń pamięci wypadku. Musimy uważać — tam przeszłość potrafi wciągnąć człowieka."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rygiel śluzy transmisyjnej ustępuje pod naporem fali nośnej. Droga do strefy rdzeniowej stoi otworem."
	},
	{
		"speaker": "LENA",
		"text": "Przejdźmy przez to razem, Jakub. Jako żywi ludzie, nie jako widma."
	}
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES


func _ready() -> void:
	if player:
		player.position = Vector2(65.0, 248.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	
	_connect_prop_signals()


func _process(delta: float) -> void:
	_pulse_phase += delta * 2.8
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.6)
		queue_redraw()


func _connect_prop_signals() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	interaction_triggered.emit(id)
	
	if id in ["crt_oscilloscope", "prop_crt_oscilloscope"] or prop_type == 174:
		is_oscilloscope_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["cross_patchbay", "prop_cross_patchbay"] or prop_type == 173:
		is_patchbay_inspected = true
		if dialogue_index in [2, 3]:
			advance_dialogue()
	elif id in ["signal_antenna", "prop_signal_antenna"] or prop_type == 172:
		is_antenna_inspected = true
		if dialogue_index in [4, 5]:
			advance_dialogue()
	elif id in ["injection_pulpit", "prop_injection_pulpit"] or prop_type == 175:
		is_pulpit_inspected = true
		if dialogue_index in [6, 7, 8]:
			advance_dialogue()
	elif id in ["station_37_exit", "prop_broadcast_exit"] or prop_type == 176:
		if is_exit_unlocked:
			_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		
		# Line 9 triggers the broadcast gate unseal
		if dialogue_index >= 9:
			unlock_exit()
	else:
		is_dialogue_completed = true
		unlock_exit()


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	
	if props:
		var exit_prop := props.get_node_or_null("Station37Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
			exit_prop.queue_redraw()
	
	queue_redraw()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		if is_exit_unlocked:
			_complete_level()


func _complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _draw() -> void:
	# Deep broadcast chamber background
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Geometric server rack pillars and cable conduits (every 80px)
	for i in range(8):
		var rx: float = float(i) * 80.0 + 30.0
		# Vertical server rack chassis
		draw_rect(Rect2(rx - 12.0, 36.0, 24.0, 244.0), Color("0d151c"))
		draw_rect(Rect2(rx - 12.0, 36.0, 24.0, 244.0), Color("233745"), false, 1.4)
		
		# Rack blade unit divisions
		for b in range(10):
			var by: float = 44.0 + float(b) * 23.0
			draw_line(Vector2(rx - 10.0, by), Vector2(rx + 10.0, by), Color("172733"), 1.0)
			# Small indicator LED on each unit
			var led_c := Color("5da398", 0.7) if (i + b) % 3 == 0 else Color("d39a62", 0.6)
			draw_circle(Vector2(rx + 6.0, by - 4.0), 1.0, led_c)
	
	# Overhead heavy overhead cable trunk tray (y = 36..46)
	draw_rect(Rect2(0.0, 36.0, 640.0, 10.0), Color("121b22"))
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), Color("3d5566"), 1.6)
	draw_line(Vector2(0.0, 46.0), Vector2(640.0, 46.0), Color("3d5566"), 1.6)
	
	# Cyan & Amber memory transmission fiber-optic lines running overhead
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 3.2)
	draw_line(Vector2(0.0, 39.0), Vector2(640.0, 39.0), Color(0.36, 0.64, 0.60, 0.7 + pulse * 0.25), 1.6)
	draw_line(Vector2(0.0, 43.0), Vector2(640.0, 43.0), Color(0.83, 0.60, 0.38, 0.6 + pulse * 0.25), 1.4)
	
	# Lower raised floor with cable ducts (y = 280..360)
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("091016"))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("4a6678"), 1.8)
	
	# Anti-static floor tile grid (y = 280..360)
	for t in range(16):
		var tx: float = float(t) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("182630"), 1.0)
	for ty_i in range(3):
		var ty: float = 300.0 + float(ty_i) * 25.0
		draw_line(Vector2(0.0, ty), Vector2(640.0, ty), Color("182630"), 1.0)
	
	# Top chamber header banner
	draw_rect(Rect2(120.0, 10.0, 400.0, 20.0), Color("071117", 0.90))
	draw_rect(Rect2(120.0, 10.0, 400.0, 20.0), Color("d39a62", 0.75), false, 1.2)
	
	# Draw active dialogue HUD if present
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud()


func _draw_dialogue_hud() -> void:
	if dialogue_index < 0 or dialogue_index >= dialogue_lines.size():
		return
	
	var cur: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur.get("speaker", "")
	var text: String = cur.get("text", "")
	
	var box_rect := Rect2(60.0, 284.0, 520.0, 66.0)
	draw_rect(box_rect, Color(0.04, 0.07, 0.10, 0.94))
	
	var accent_col := Color("5da398")
	if speaker == "LENA":
		accent_col = Color("5da398")
	elif speaker == "JAKUB":
		accent_col = Color("d39a62")
	elif speaker == "ŚWIADECTWO":
		accent_col = Color("e2b060")
	
	draw_rect(box_rect, accent_col * 0.8, false, 1.5)
	draw_line(Vector2(70.0, 290.0), Vector2(170.0, 290.0), accent_col, 2.0)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, accent_col)
		
		# Word wrap to 2 lines max
		var words := text.split(" ")
		var line1 := ""
		var line2 := ""
		var cur_l := ""
		var max_width := 490.0
		
		for w in words:
			var test_l := cur_l + (" " if cur_l != "" else "") + w
			if font.get_string_size(test_l, HORIZONTAL_ALIGNMENT_LEFT, -1, 10).x > max_width:
				if line1 == "":
					line1 = cur_l
					cur_l = w
				else:
					line2 = cur_l
					cur_l = w
			else:
				cur_l = test_l
		
		if line1 == "":
			line1 = cur_l
		else:
			line2 = cur_l
		
		draw_string(font, Vector2(70.0, 322.0), line1, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("e5ece9"))
		if line2 != "":
			draw_string(font, Vector2(70.0, 338.0), line2, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("e5ece9"))
		
		# Draw Level title on top banner
		draw_string(font, Vector2(130.0, 23.0), "KOMORA SYGNAŁOWA // WĘZEŁ NADAWCZY // POZIOM -40 M", HORIZONTAL_ALIGNMENT_CENTER, 380.0, 9, Color("e2b060"))
