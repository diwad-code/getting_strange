class_name Station40
extends Node2D

## Space 40: Ostatnia propozycja / Otwarcie Aktu IV: Sygnał powrotu (Act IV Opening)
## UCP Negotiation Chamber at Level 0 (Surface Transition)
## Narrative & Mechanical Beat: Scene 40 from FULL_STORY.md & DIALOGUE_SCRIPT.md (D-14)

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_terminal_inspected: bool = false
var is_marta_inspected: bool = false
var is_szymon_inspected: bool = false
var is_cost_matrix_inspected: bool = false

# Internal visuals
var _bg_color: Color = Color("0a1015")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Sala Negocjacyjna UCP. Poziom 0. Powrót na powierzchnię. Za pancernymi szybami majaczą zarysy porannej Równi."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Powrót ma jeden stabilny adres i nieznany skutek po tej stronie. Uzgodnienie ma znany koszt dla pani i najniższe ryzyko dla miasta."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Sieć świadków ma zbyt wiele zmiennych, by nazwać ją rozwiązaniem."
	},
	{
		"speaker": "LENA",
		"text": "Ale działała."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "W jednym pokoju przez czterdzieści trzy sekundy."
	},
	{
		"speaker": "JAKUB",
		"text": "Wystarczyło, żebyśmy wyszli."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Nie wystarczy, żeby przejechał poranny tramwaj."
	},
	{
		"speaker": "MARTA",
		"text": "Więc nauczymy motorniczą patrzeć."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "A jeśli odwróci głowę?"
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Cisza. Marta nie odsuwa wzroku. Wierzbicka zapisuje brak odpowiedzi, ale nie dopowiada go za nią."
	},
	{
		"speaker": "SZYMON",
		"text": "Była ktoś. Nie trzymam imienia, ale trzymam dowód. Jeśli miasto nie chce pamiętać, będziemy pamiętać my."
	},
	{
		"speaker": "LENA",
		"text": "Nie szukamy już oryginału, doktor Wierzbicka. Szukamy odpowiedzialności."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wrota do Komory Wyboru Operacyjnego (Przestrzeń 41) zostają odryglowane. Wszystkie trzy operacje są gotowe do egzekucji."
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
	
	if id in ["wierzbicka_terminal", "prop_wierzbicka_terminal"] or prop_type == 187:
		is_terminal_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["cost_matrix", "prop_cost_matrix"] or prop_type == 190:
		is_cost_matrix_inspected = true
		if dialogue_index in [2, 3, 4, 5]:
			advance_dialogue()
	elif id in ["marta_witness", "prop_marta_witness"] or prop_type == 188:
		is_marta_inspected = true
		if dialogue_index in [6, 7, 8]:
			advance_dialogue()
	elif id in ["szymon_monitor", "prop_szymon_monitor"] or prop_type == 189:
		is_szymon_inspected = true
		if dialogue_index in [9, 10]:
			advance_dialogue()
	elif id in ["station_40_exit", "prop_station_40_exit"] or prop_type == 191:
		if is_exit_unlocked:
			_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		
		# Line 11/12 triggers the operational choice chamber door unseal
		if dialogue_index >= 11:
			unlock_exit()
	else:
		is_dialogue_completed = true
		unlock_exit()


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	
	if props:
		var exit_prop := props.get_node_or_null("Station40Exit") as MemoryResonancePoint
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
	# Negotiation chamber base background
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Panoramic surface window behind architecture (y = 52..210)
	draw_rect(Rect2(40.0, 52.0, 560.0, 158.0), Color("0d1821"))
	# Dawn sky gradient lines
	for ly in range(6):
		var sky_y: float = 52.0 + float(ly) * 26.0
		var sky_alpha: float = 0.12 + float(ly) * 0.06
		draw_line(Vector2(40.0, sky_y), Vector2(600.0, sky_y), Color(0.36, 0.64, 0.60, sky_alpha), 1.0)
	
	# Distant skyline silhouettes of Rówień waking at dawn
	draw_rect(Rect2(90.0, 135.0, 45.0, 75.0), Color("081016"))
	draw_rect(Rect2(160.0, 110.0, 65.0, 100.0), Color("060d13"))
	draw_rect(Rect2(270.0, 125.0, 80.0, 85.0), Color("081016"))
	draw_rect(Rect2(390.0, 140.0, 55.0, 70.0), Color("070e14"))
	draw_rect(Rect2(480.0, 120.0, 70.0, 90.0), Color("060d13"))
	
	# Modernist Level 0 architectural columns (y = 48..280)
	for i in range(7):
		var cx: float = float(i) * 92.0 + 34.0
		draw_rect(Rect2(cx - 10.0, 48.0, 20.0, 232.0), Color("121b23"))
		draw_rect(Rect2(cx - 10.0, 48.0, 20.0, 232.0), Color("263845"), false, 1.2)
		draw_line(Vector2(cx, 48.0), Vector2(cx, 280.0), Color("3d5464"), 1.0)
	
	# Upper ceiling lintel & lighting track (y = 36..48)
	draw_rect(Rect2(0.0, 36.0, 640.0, 12.0), Color("111a22"))
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), Color("3a5060"), 1.6)
	draw_line(Vector2(0.0, 48.0), Vector2(640.0, 48.0), Color("3a5060"), 1.6)
	
	# Triple lighting indicator conduits overhead
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 2.8)
	draw_line(Vector2(0.0, 39.0), Vector2(640.0, 39.0), Color(0.36, 0.64, 0.60, 0.65 + pulse * 0.25), 1.2)
	draw_line(Vector2(0.0, 42.0), Vector2(640.0, 42.0), Color(0.83, 0.60, 0.38, 0.65 + pulse * 0.25), 1.2)
	draw_line(Vector2(0.0, 45.0), Vector2(640.0, 45.0), Color(0.78, 0.36, 0.35, 0.65 + pulse * 0.25), 1.2)
	
	# Raised negotiation deck floor (y = 280..360)
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("091218"))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("445d6e"), 1.8)
	
	# Polished floor grid slabs (y = 280..360)
	for t in range(16):
		var tx: float = float(t) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("15222c"), 1.0)
	for ty_i in range(3):
		var ty: float = 300.0 + float(ty_i) * 25.0
		draw_line(Vector2(0.0, ty), Vector2(640.0, ty), Color("15222c"), 1.0)
	
	# Top negotiation chamber title banner
	draw_rect(Rect2(100.0, 10.0, 440.0, 20.0), Color("09131a", 0.90))
	draw_rect(Rect2(100.0, 10.0, 440.0, 20.0), Color("5da398", 0.75), false, 1.2)
	
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
	elif speaker == "WIERZBICKA":
		accent_col = Color("5da398")
	elif speaker == "JAKUB":
		accent_col = Color("d39a62")
	elif speaker == "MARTA":
		accent_col = Color("d39a62")
	elif speaker == "SZYMON":
		accent_col = Color("c65d58")
	elif speaker == "ŚWIADECTWO":
		accent_col = Color("e5ece9")
	
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
		draw_string(font, Vector2(110.0, 23.0), "SALA NEGOCJACYJNA // POZIOM 0 // OTWARCIE AKTU IV: SYGNAŁ POWROTU", HORIZONTAL_ALIGNMENT_CENTER, 420.0, 9, Color("5da398"))
