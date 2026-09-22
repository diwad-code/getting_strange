class_name Station38
extends Node2D

## Space 38: Sektor Pamięci Wypadku / Człowiek zamiast dowodu (Act III: Podstruktura)
## Raw uncorrected memory core of Line 4 accident at -40m depth
## Narrative & Mechanical Beat: Scene 38 from FULL_STORY.md & DIALOGUE_SCRIPT.md

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_calculator_inspected: bool = false
var is_accident_field_inspected: bool = false
var is_jakub_shadow_inspected: bool = false
var is_rescue_tether_anchored: bool = false

# Internal visuals
var _bg_color: Color = Color("080a0e")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Sektor Pamięci Wypadku. Tu przechowywany jest surowy, nieskorygowany zapis katastrofy na Linii 4 z 3 listopada 1988 roku."
	},
	{
		"speaker": "JAKUB",
		"text": "Lena... coś mnie ściąga. Pole symulacji... rozpoznaje mój wektor biograficzny."
	},
	{
		"speaker": "LENA",
		"text": "Trzymaj się poręczy! Twoje ciało zaczyna się dekompensować w falę nośną!"
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Kalkulator współrzędnych UCP przelicza profil Jakuba. Użycie go jako czystego sygnału gwarantuje bezbłędny powrót do twojego świata."
	},
	{
		"speaker": "JAKUB",
		"text": "Jeśli użyjesz mnie jako współrzędnej... wrócisz do domu, Lena. Do swojego laboratorium, gdzie nikt nie pamięta wypadku."
	},
	{
		"speaker": "LENA",
		"text": "Nie po to zeszłam do Podstruktury, żeby złożyć cię w ofierze po raz drugi."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena odrzuca kalkulację instrumentalną i wyciąga dłoń ku rozpadającemu się cieniowi brata."
	},
	{
		"speaker": "JAKUB",
		"text": "Jesteś pewna? Jeśli mnie wyciągniesz... stracisz gwarancję czystego powrotu."
	},
	{
		"speaker": "LENA",
		"text": "Jesteś moim bratem, Jakub. Żywym człowiekiem z krwi i kości."
	},
	{
		"speaker": "JAKUB",
		"text": "Możemy to sprawdzić jutro. Chodźmy do Komory Referencyjnej."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rygiel Komory Referencyjnej ustępuje. Przed wami rozpościera się serce Podstruktury."
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
	
	if id in ["coordinate_calc", "prop_coordinate_calc"] or prop_type == 180:
		is_calculator_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["accident_field", "prop_accident_field"] or prop_type == 177:
		is_accident_field_inspected = true
		if dialogue_index in [2, 3]:
			advance_dialogue()
	elif id in ["jakub_shadow", "prop_jakub_shadow"] or prop_type == 178:
		is_jakub_shadow_inspected = true
		if dialogue_index in [4, 5]:
			advance_dialogue()
	elif id in ["rescue_tether", "prop_rescue_tether"] or prop_type == 179:
		is_rescue_tether_anchored = true
		if dialogue_index in [6, 7, 8]:
			advance_dialogue()
	elif id in ["station_38_exit", "prop_reference_exit"] or prop_type == 181:
		if is_exit_unlocked:
			_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		
		# Line 9 triggers the reference chamber vault unseal
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
		var exit_prop := props.get_node_or_null("Station38Exit") as MemoryResonancePoint
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
	# Deep distorted accident core background
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Curved spacetime structural arches with stress distortion lines
	for i in range(7):
		var ax: float = float(i) * 95.0 + 35.0
		# Distorted curved arch
		draw_line(Vector2(ax - 15.0, 36.0), Vector2(ax, 160.0), Color("17222d"), 2.2)
		draw_line(Vector2(ax, 160.0), Vector2(ax - 15.0, 280.0), Color("17222d"), 2.2)
		draw_line(Vector2(ax - 15.0, 36.0), Vector2(ax + 15.0, 36.0), Color("2f4557"), 1.4)
	
	# Overhead trauma archive suspension rails (y = 36..48)
	draw_rect(Rect2(0.0, 36.0, 640.0, 12.0), Color("0f171e"))
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), Color("3d5466"), 1.6)
	draw_line(Vector2(0.0, 48.0), Vector2(640.0, 48.0), Color("3d5466"), 1.6)
	
	# Cinnabar accident trauma energy fissure lines through background
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 3.4)
	draw_line(Vector2(0.0, 42.0), Vector2(640.0, 42.0), Color(0.78, 0.36, 0.35, 0.65 + pulse * 0.3), 1.6)
	draw_line(Vector2(120.0, 42.0), Vector2(380.0, 280.0), Color(0.78, 0.36, 0.35, 0.25 + pulse * 0.2), 1.0)
	
	# Lower raised deck with vibration dampers (y = 280..360)
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("0a1015"))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("4a6272"), 1.8)
	
	# Anti-vibration deck floor ribs (y = 280..360)
	for t in range(16):
		var tx: float = float(t) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("15212b"), 1.0)
	for ty_i in range(3):
		var ty: float = 300.0 + float(ty_i) * 25.0
		draw_line(Vector2(0.0, ty), Vector2(640.0, ty), Color("15212b"), 1.0)
	
	# Top chamber header banner
	draw_rect(Rect2(100.0, 10.0, 440.0, 20.0), Color("081116", 0.90))
	draw_rect(Rect2(100.0, 10.0, 440.0, 20.0), Color("c65d58", 0.75), false, 1.2)
	
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
		accent_col = Color("c65d58")
	
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
		draw_string(font, Vector2(110.0, 23.0), "SEKTOR PAMIĘCI WYPADKU // CZŁOWIEK ZAMIAST DOWODU // POZIOM -40 M", HORIZONTAL_ALIGNMENT_CENTER, 420.0, 9, Color("c65d58"))
