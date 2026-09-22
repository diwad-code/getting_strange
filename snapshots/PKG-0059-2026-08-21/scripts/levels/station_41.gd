class_name Station41
extends Node2D

## Space 41: Wybór operacyjny / Trzy warianty rozwiązania (Act IV Climax)
## UCP Operational Choice Chamber at Level 0
## Narrative & Mechanical Beat: Scene 41 from FULL_STORY.md & CONTINUITY_TRACKER.md

signal level_completed
signal interaction_triggered(id: String)
signal operation_selected(op: String)
signal dialogue_advanced(line_index: int)

@export var chosen_operation: String = ""
@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Inspection flags
var is_topography_inspected: bool = false
var is_op_a_inspected: bool = false
var is_op_b_inspected: bool = false
var is_op_c_inspected: bool = false

# Visual state
var _bg_color: Color = Color("0a1016")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Komora Wyboru Operacyjnego. Poziom 0. Trzy niezależne stanowiska egzekucyjne: Powrót (A), Uzgodnienie (B), Świadectwo (C)."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "To nie jest menu dialogowe. Decyzja nie polega na odkryciu jednej prawdy — polega na fizycznym załączeniu odpowiedzialności."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Operacja A (Powrót): Zakotwiczenie własnego gestu i sygnału pierwszej komory z 21:45. Odcięcie lokalnych świadectw. Wyjście do Przestrzeni 42A."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Operacja B (Uzgodnienie): Przyjęcie złotej obrączki, adresu mieszkania 14 i relacji z Martą Kurek. Domknięcie mostu UCP. Wyjście do Przestrzeni 42B."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Operacja C (Świadectwo): Rozproszenie punktów obserwacji na całe miasto. Obserwowalność sprzeczności bez wymazywania świadków. Wyjście do Przestrzeni 42C."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Załącz wybraną konsolę operacyjną (A, B lub C), aby odryglować wrota rozstrzygnięcia."
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
	_pulse_phase += delta * 3.0
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.8)
		queue_redraw()


func _connect_prop_signals() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	interaction_triggered.emit(id)
	
	if id in ["topography_display", "prop_topography_display"] or prop_type == 195:
		is_topography_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["console_return_a", "prop_console_return_a"] or prop_type == 192:
		is_op_a_inspected = true
		select_operation("A")
	elif id in ["console_reconciliation_b", "prop_console_reconciliation_b"] or prop_type == 193:
		is_op_b_inspected = true
		select_operation("B")
	elif id in ["console_testimony_c", "prop_console_testimony_c"] or prop_type == 194:
		is_op_c_inspected = true
		select_operation("C")
	elif id in ["station_41_exit", "prop_station_41_exit"] or prop_type == 196:
		if is_exit_unlocked:
			_complete_level()


func select_operation(op: String) -> void:
	chosen_operation = op
	operation_selected.emit(chosen_operation)
	
	# Update active visuals on props
	if props:
		var prop_a := props.get_node_or_null("ConsoleReturnA") as MemoryResonancePoint
		var prop_b := props.get_node_or_null("ConsoleReconciliationB") as MemoryResonancePoint
		var prop_c := props.get_node_or_null("ConsoleTestimonyC") as MemoryResonancePoint
		
		if prop_a:
			prop_a.is_activated = (op == "A")
			prop_a.queue_redraw()
		if prop_b:
			prop_b.is_activated = (op == "B")
			prop_b.queue_redraw()
		if prop_c:
			prop_c.is_activated = (op == "C")
			prop_c.queue_redraw()
	
	unlock_exit()
	
	# Set dedicated feedback line
	var op_text := ""
	match op:
		"A":
			op_text = "Wybrano Operację A: Powrót (Własny pokój). Sygnał korelacji 21:45 zakotwiczony. Wrota do Przestrzeni 42A odryglowane."
		"B":
			op_text = "Wybrano Operację B: Uzgodnienie (Miejsce po niej). Wzorzec tożsamości z Martą Kurek przyjęty. Wrota do Przestrzeni 42B odryglowane."
		"C":
			op_text = "Wybrano Operację C: Świadectwo (Dwie prawdy). Siatka 4 świadków rozproszona na miasto. Wrota do Przestrzeni 42C odryglowane."
	
	dialogue_lines = [
		{
			"speaker": "ROZSTRZYGNIĘCIE",
			"text": op_text
		}
	]
	dialogue_index = 0
	dialogue_active = true
	queue_redraw()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
	else:
		is_dialogue_completed = true


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	
	if props:
		var exit_prop := props.get_node_or_null("Station41Exit") as MemoryResonancePoint
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
	# Base chamber background
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Panoramic surface observation strip behind architecture (y = 48..190)
	draw_rect(Rect2(30.0, 48.0, 580.0, 142.0), Color("0d1722"))
	# Dawn sky gradient bands
	for ly in range(5):
		var sky_y: float = 48.0 + float(ly) * 28.0
		var sky_alpha: float = 0.10 + float(ly) * 0.05
		draw_line(Vector2(30.0, sky_y), Vector2(610.0, sky_y), Color(0.36, 0.64, 0.60, sky_alpha), 1.0)
	
	# Skyline of Rówień in morning twilight
	draw_rect(Rect2(70.0, 120.0, 50.0, 70.0), Color("081018"))
	draw_rect(Rect2(150.0, 100.0, 70.0, 90.0), Color("060d14"))
	draw_rect(Rect2(250.0, 115.0, 90.0, 75.0), Color("081018"))
	draw_rect(Rect2(370.0, 130.0, 60.0, 60.0), Color("070e15"))
	draw_rect(Rect2(460.0, 105.0, 80.0, 85.0), Color("060d14"))
	
	# Three operational terminal alcoves (A: Cyan x=220, B: Amber x=330, C: Cinnabar x=440)
	var alcove_xs: Array[float] = [220.0, 330.0, 440.0]
	var alcove_colors: Array[Color] = [
		Color("5da398"), # A: Cyan
		Color("d39a62"), # B: Amber
		Color("c65d58")  # C: Cinnabar
	]
	var pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 2.8)
	
	for i in range(3):
		var ax: float = alcove_xs[i]
		var acol: Color = alcove_colors[i]
		var is_chosen: bool = (chosen_operation == ["A", "B", "C"][i])
		var alcove_alpha: float = 0.35 + (0.45 if is_chosen else 0.0) + (pulse * 0.15 if is_chosen else 0.0)
		
		# Vertical architectural bay column
		draw_rect(Rect2(ax - 28.0, 48.0, 56.0, 232.0), Color("0f1922"))
		draw_rect(Rect2(ax - 28.0, 48.0, 56.0, 232.0), Color(acol.r, acol.g, acol.b, alcove_alpha * 0.5), false, 1.2)
		
		# Overhead bay light conduit
		draw_line(Vector2(ax, 38.0), Vector2(ax, 280.0), Color(acol.r, acol.g, acol.b, alcove_alpha), 1.6)
		draw_circle(Vector2(ax, 42.0), 3.0, Color(acol.r, acol.g, acol.b, alcove_alpha * 1.2))
	
	# Overhead heavy structural beams & conduit tracks (y = 34..48)
	draw_rect(Rect2(0.0, 34.0, 640.0, 14.0), Color("121d26"))
	draw_line(Vector2(0.0, 34.0), Vector2(640.0, 34.0), Color("3d5464"), 1.8)
	draw_line(Vector2(0.0, 48.0), Vector2(640.0, 48.0), Color("3d5464"), 1.8)
	
	# Structural concrete columns at borders
	for cx in [20.0, 130.0, 530.0, 620.0]:
		draw_rect(Rect2(cx - 8.0, 48.0, 16.0, 232.0), Color("141e26"))
		draw_rect(Rect2(cx - 8.0, 48.0, 16.0, 232.0), Color("293c4a"), false, 1.0)
	
	# Floor platform deck (y = 280..360)
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("081117"))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("445d6e"), 2.0)
	
	# Polished floor grid lines
	for t in range(17):
		var tx: float = float(t) * 40.0
		draw_line(Vector2(tx, 280.0), Vector2(tx, 360.0), Color("132029"), 1.0)
	for ty_i in range(3):
		var ty: float = 300.0 + float(ty_i) * 25.0
		draw_line(Vector2(0.0, ty), Vector2(640.0, ty), Color("132029"), 1.0)
	
	# Top chamber designation title bar
	draw_rect(Rect2(100.0, 8.0, 440.0, 22.0), Color("09131a", 0.92))
	draw_rect(Rect2(100.0, 8.0, 440.0, 22.0), Color("5da398", 0.80), false, 1.2)
	
	# Draw active dialogue HUD if present
	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud()


func _draw_dialogue_hud() -> void:
	if dialogue_index < 0 or dialogue_index >= dialogue_lines.size():
		return
	
	var cur: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur.get("speaker", "")
	var text: String = cur.get("text", "")
	
	# Bottom HUD panel (y = 295..352)
	var box_rect := Rect2(30.0, 292.0, 580.0, 60.0)
	draw_rect(box_rect, Color("081117", 0.95))
	draw_rect(box_rect, Color("2d4657"), false, 1.2)
	
	# Speaker tag color
	var tag_col := Color("5da398")
	if speaker == "WIERZBICKA":
		tag_col = Color("75c7c3")
	elif speaker == "MARTA":
		tag_col = Color("d39a62")
	elif speaker == "JAKUB":
		tag_col = Color("75c7c3")
	elif speaker == "SZYMON":
		tag_col = Color("e2b060")
	elif speaker == "ROZSTRZYGNIĘCIE":
		tag_col = Color("e2b060")
	
	# Speaker badge
	draw_rect(Rect2(42.0, 298.0, 110.0, 16.0), Color("121f29"))
	draw_rect(Rect2(42.0, 298.0, 110.0, 16.0), tag_col * 0.75, false, 1.0)
	
	# Subtle speaker dot indicator
	draw_circle(Vector2(50.0, 306.0), 3.0, tag_col)
