class_name Station39
extends Node2D

## Space 39: Komora Referencyjna / Finał Aktu III: Podstruktura (Act III Finale)
## Central Reference Core of the Substructure at -40m depth
## Narrative & Mechanical Beat: Scene 39 from FULL_STORY.md & DIALOGUE_SCRIPT.md

## PRZESZKODA — dlaczego to tu jest: Rdzeń Referencyjny pokazuje trzy
## równoprawne konfiguracje, ponieważ Podstruktura nie ustanawia jednego
## oryginału.
## PRZESZKODA — czego wymaga od Leny: Obejrzenia trzech konfiguracji i przyjęcia
## kontroli po decyzji Śladu, bez wybierania przez wskaźnik punktów lub próg ruchu.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; koszt wyboru należy do
## finałów i nie może zostać zastąpiony przez przegraną wykonawczą.

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_config_a_inspected: bool = false
var is_config_b_inspected: bool = false
var is_reference_core_inspected: bool = false
var is_config_c_inspected: bool = false

# Internal visuals
var _bg_color: Color = Color("070a0e")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Komora Referencyjna. Serce Podstruktury. Tutaj zbiegają się wszystkie wektory stabilizacyjne miasta."
	},
	{
		"speaker": "JAKUB",
		"text": "Patrzcie na rdzeń... Trzy stabilne konfiguracje. Trzy różne sposoby zamknięcia tego, co pękło."
	},
	{
		"speaker": "LENA",
		"text": "Konfiguracja A: Własny pokój. Powrót do mojego laboratorium. 21:45. Jeden ocalony świat."
	},
	{
		"speaker": "ŚLAD",
		"text": "KONFIGURACJA B: MIEJSCE PO MNIE. UZGODNIENIE. PRZYJĘCIE MIESZKANIA, MARTY I PRACY. MOST ZAMKNIĘTY BEZ ROZPADU."
	},
	{
		"speaker": "JAKUB",
		"text": "A Konfiguracja C... Świadectwo. Publiczna sieć sprzecznych świadków. Dwie prawdy istniejące obok siebie."
	},
	{
		"speaker": "LENA",
		"text": "Która opcja jest twoja, Śladzie? Którą chciałaś wybrać?"
	},
	{
		"speaker": "ŚLAD",
		"text": "JEŚLI WYBIERZĘ JA... ZNOWU ZROBIĘ Z CIEBIE KOSZT."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ślad cofa dłoń z konsoli i przekazuje panel operacyjny Lenie. Jej zarys zaczyna drżeć w świetle rdzenia."
	},
	{
		"speaker": "LENA",
		"text": "Zostajesz ze mną do końca?"
	},
	{
		"speaker": "ŚLAD",
		"text": "ODDAJĘ KONTROLĘ. WYBÓR NALEŻY DO CIEBIE."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Stabilizator pamięci osiąga stan krytyczny. Przejście do Aktu IV stoi otworem."
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
	
	if id in ["config_a", "prop_config_a"] or prop_type == 183:
		is_config_a_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["config_b", "prop_config_b"] or prop_type == 184:
		is_config_b_inspected = true
		if dialogue_index in [2, 3]:
			advance_dialogue()
	elif id in ["reference_core", "prop_reference_core"] or prop_type == 182:
		is_reference_core_inspected = true
		if dialogue_index in [4, 5, 6]:
			advance_dialogue()
	elif id in ["config_c", "prop_config_c"] or prop_type == 185:
		is_config_c_inspected = true
		if dialogue_index in [7, 8]:
			advance_dialogue()
	elif id in ["station_39_exit", "prop_act4_gateway"] or prop_type == 186:
		if is_exit_unlocked:
			_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		
		# Line 9 triggers the Act IV ascent gateway unseal
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
		var exit_prop := props.get_node_or_null("Station39Exit") as MemoryResonancePoint
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
	_draw_state_layer()
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var core_color := VectorStageStyle.LIGHT_PLANE if is_reference_core_inspected else VectorStageStyle.MID_PLANE
	draw_colored_polygon(PackedVector2Array([Vector2(304.0, 72.0), Vector2(360.0, 64.0), Vector2(378.0, 218.0), Vector2(286.0, 226.0)]), core_color)
	var a_color := VectorStageStyle.ANCHOR_CYAN if is_config_a_inspected else VectorStageStyle.MID_PLANE
	var b_color := VectorStageStyle.HUMAN_AMBER if is_config_b_inspected else VectorStageStyle.MID_PLANE
	var c_color := VectorStageStyle.CORRECTION_OXIDE if is_config_c_inspected else VectorStageStyle.MID_PLANE
	draw_line(Vector2(126.0, 206.0), Vector2(174.0, 206.0), a_color, 2.0)
	draw_line(Vector2(226.0, 196.0), Vector2(274.0, 196.0), b_color, 2.0)
	draw_line(Vector2(416.0, 206.0), Vector2(464.0, 206.0), c_color, 2.0)
	if is_exit_unlocked:
		draw_line(Vector2(522.0, 222.0), Vector2(606.0, 222.0), VectorStageStyle.ANCHOR_CYAN, 2.0)


func _draw_legacy() -> void:
	# Deep monumental reference core background
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Colossal vaulted architectural pillars of the Core
	for i in range(8):
		var px: float = float(i) * 85.0 + 22.0
		# Massive vaulted pillar
		draw_rect(Rect2(px - 14.0, 36.0, 28.0, 244.0), Color("0d151c"))
		draw_rect(Rect2(px - 14.0, 36.0, 28.0, 244.0), Color("1e2f3d"), false, 1.2)
		draw_line(Vector2(px, 36.0), Vector2(px, 280.0), Color("2f4557"), 1.0)
	
	# Overhead quantum harmonic energy conduits (y = 36..48)
	draw_rect(Rect2(0.0, 36.0, 640.0, 12.0), Color("0a1218"))
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), Color("3d5466"), 1.6)
	draw_line(Vector2(0.0, 48.0), Vector2(640.0, 48.0), Color("3d5466"), 1.6)
	
	# Tri-color harmonic energy beams running overhead (Cyan, Amber, Cinnabar)
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 3.0)
	draw_line(Vector2(0.0, 39.0), Vector2(640.0, 39.0), Color(0.36, 0.64, 0.60, 0.70 + pulse * 0.25), 1.4)
	draw_line(Vector2(0.0, 42.0), Vector2(640.0, 42.0), Color(0.83, 0.60, 0.38, 0.70 + pulse * 0.25), 1.4)
	draw_line(Vector2(0.0, 45.0), Vector2(640.0, 45.0), Color(0.78, 0.36, 0.35, 0.70 + pulse * 0.25), 1.4)
	
	# Lower raised ceremonial deck (y = 280..360)
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("091016"))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("4a6272"), 1.8)
	
	# Polished floor grid slabs (y = 280..360)
	for t in range(16):
		var tx: float = float(t) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("13202a"), 1.0)
	for ty_i in range(3):
		var ty: float = 300.0 + float(ty_i) * 25.0
		draw_line(Vector2(0.0, ty), Vector2(640.0, ty), Color("13202a"), 1.0)
	
	# Top chamber header banner
	draw_rect(Rect2(100.0, 10.0, 440.0, 20.0), Color("081116", 0.90))
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
	elif speaker == "ŚLAD":
		accent_col = Color("75c7c3")
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
		draw_string(font, Vector2(110.0, 23.0), "KOMORA REFERENCYJNA // SERCE PODSTRUKTURY // FINAŁ AKTU III", HORIZONTAL_ALIGNMENT_CENTER, 420.0, 9, Color("5da398"))
