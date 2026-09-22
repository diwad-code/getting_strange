class_name Station36
extends Node2D

## Space 36: Kanał Odpływowy / Zimny Ściek (Act III: Podstruktura)
## Subterranean storm sewer drain beneath the Old Loop foundations at -40m depth
## Narrative & Mechanical Beat: Scene 36 from FULL_STORY.md & DIALOGUE_SCRIPT.md

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_weir_inspected: bool = false
var is_current_inspected: bool = false
var is_ladder_inspected: bool = false
var is_tap_inspected: bool = false

# Internal visuals
var _bg_color: Color = Color("05090c")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Kanał Odpływowy to ponura betonowa gardziel burzowa pod fundamentami Starej Pętli. Rwący nurt niesie spuszczony z basenów osad sedacyjny."
	},
	{
		"speaker": "LENA",
		"text": "Spójrz na tę smugę. Fosforyzujący osad spływa bezpośrednio do podziemnych warstw wodonośnych miasta."
	},
	{
		"speaker": "JAKUB",
		"text": "UCP wiedziało, że zrzut sedatywów przesącza się do studni głębinowych. Uznano to za »akceptowalny margines błędu ekologicznego«, dopóki ludzie nie pamiętali katastrofy."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na kracie jazu burzowego zatrzymały się kolejne odłamki wymazanej przeszłości: fragment tramwajowej poręczy, bilet z datą 3 listopada 1988 i skrawki wykresów."
	},
	{
		"speaker": "LENA",
		"text": "To nie był margines błędu. To był systemowy mechanizm pacyfikacji żałoby."
	},
	{
		"speaker": "JAKUB",
		"text": "Dr Wierzbicka uważała, że alternatywą jest masowa histeria i rozpad tkanki społecznej. Wybrała chemiczny spokój zamiast prawdy."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Kurek probierczy wód gruntowych wskazuje alarmujące skażenie. Osad przedostaje się do ujęć wody na Osiedlu Tarasowym."
	},
	{
		"speaker": "LENA",
		"text": "Marta i inni piją tę wodę każdego dnia. Dlatego nikt na osiedlu nie potrafi nazwać pustki, którą czuje."
	},
	{
		"speaker": "JAKUB",
		"text": "Jeśli przejdziemy przez bramę przeciwsztormową, dotrzemy do Komory Sygnałowej. Tam zbiegają się wszystkie linie transmisyjne Podstruktury."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Rygle bramy przeciwsztormowej cofają się z głośnym sykiem. Droga do Komory Sygnałowej stoi otworem."
	},
	{
		"speaker": "LENA",
		"text": "Idziemy do Komory Sygnałowej. Czas nadać sygnał, którego nie da się zmyć wodą."
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
	
	if id in ["storm_drain_weir", "prop_storm_weir"] or prop_type == 167:
		is_weir_inspected = true
		if dialogue_index in [2, 3, 4]:
			advance_dialogue()
	elif id in ["sedative_sludge_current", "prop_sludge_current"] or prop_type == 168:
		is_current_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["acid_resistant_catwalk_ladder", "prop_catwalk_ladder"] or prop_type == 169:
		is_ladder_inspected = true
		if dialogue_index in [4, 5]:
			advance_dialogue()
	elif id in ["contamination_sampling_tap", "prop_sampling_tap"] or prop_type == 170:
		is_tap_inspected = true
		if dialogue_index in [6, 7, 8]:
			advance_dialogue()
	elif id in ["station_36_exit", "prop_storm_exit"] or prop_type == 171:
		if is_exit_unlocked:
			_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		
		# Line 9 triggers the storm blast door retraction
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
		var exit_prop := props.get_node_or_null("Station36Exit") as MemoryResonancePoint
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
	# Deep storm sewer background
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Massive curved sewer tunnel vault ribs (concrete arches every 75px)
	for i in range(9):
		var ax: float = float(i) * 75.0 + 15.0
		# Concrete arch profile
		draw_line(Vector2(ax, 30.0), Vector2(ax, 280.0), Color("0e161c"), 4.0)
		draw_line(Vector2(ax + 1.0, 30.0), Vector2(ax + 1.0, 280.0), Color("1b2933"), 1.2)
		
		# Keystone & arch springers
		draw_rect(Rect2(ax - 5.0, 26.0, 10.0, 8.0), Color("17232b"))
		
		# Horizontal water staining / high-water marks along walls
		draw_line(Vector2(ax - 30.0, 190.0), Vector2(ax + 40.0, 190.0), Color("0d2026", 0.6), 1.0)
		draw_line(Vector2(ax - 30.0, 230.0), Vector2(ax + 40.0, 230.0), Color("0b181c", 0.8), 1.4)
	
	# Overhead sewer ventilation & drainage trunk line (y = 44..58)
	draw_line(Vector2(0.0, 48.0), Vector2(640.0, 48.0), Color("141e24"), 8.0)
	draw_line(Vector2(0.0, 48.0), Vector2(640.0, 48.0), Color("263742"), 2.0)
	for j in range(12):
		var jx: float = float(j) * 55.0 + 20.0
		draw_line(Vector2(jx, 44.0), Vector2(jx, 52.0), Color("3d5464"), 1.8)
		# Hanging conduit clamps
		draw_line(Vector2(jx, 30.0), Vector2(jx, 44.0), Color("1a242c"), 1.2)
	
	# Lower sewer wastewater trough bed (y = 280..360)
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("060d11"))
	
	# Rushing dark wastewater surface wave (y = 282..296)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 3.0)
	for w in range(32):
		var wx: float = float(w) * 20.0
		var wy: float = 286.0 + sin(_pulse_phase * 4.0 + float(w) * 0.8) * 3.0
		draw_line(Vector2(wx, wy), Vector2(wx + 18.0, wy), Color("0f2930", 0.85), 2.0)
		draw_line(Vector2(wx + 4.0, wy + 2.0), Vector2(wx + 14.0, wy + 2.0), Color("5da398", 0.4 + pulse * 0.3), 1.0)
	
	# Steel maintenance catwalk grating (elevated walkway y = 268..280)
	draw_rect(Rect2(0.0, 268.0, 640.0, 12.0), Color("121b21"))
	draw_line(Vector2(0.0, 268.0), Vector2(640.0, 268.0), Color("3b4f5e"), 1.6)
	for g in range(64):
		var gx: float = float(g) * 10.0
		draw_line(Vector2(gx, 269.0), Vector2(gx, 280.0), Color("23313a"), 1.0)
	
	# Safety handrail along catwalk (y = 244)
	draw_line(Vector2(0.0, 244.0), Vector2(640.0, 244.0), Color("d39a62", 0.75), 1.4)
	for p in range(16):
		var px: float = float(p) * 40.0 + 10.0
		draw_line(Vector2(px, 244.0), Vector2(px, 268.0), Color("d39a62", 0.65), 1.2)
	
	# Top tunnel location plaque banner
	draw_rect(Rect2(120.0, 14.0, 400.0, 20.0), Color("081014", 0.90))
	draw_rect(Rect2(120.0, 14.0, 400.0, 20.0), Color("d39a62", 0.70), false, 1.2)
	
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
	draw_rect(box_rect, Color(0.04, 0.07, 0.09, 0.94))
	
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
		draw_string(font, Vector2(130.0, 27.0), "KANAŁ ODPŁYWOWY // ZIMNY ŚCIEK // POZIOM -40 M", HORIZONTAL_ALIGNMENT_CENTER, 380.0, 9, Color("e2b060"))
