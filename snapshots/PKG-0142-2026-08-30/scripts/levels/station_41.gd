class_name Station41
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Komora UCP rozdziela trzy operacje, ponieważ odpowiedzialność za sprzeczną historię musi zostać załączona w jednym, jawnie obserwowalnym miejscu.
## PRZESZKODA — czego wymaga od Leny: Odczytania topografii świadków, porównania nazwanych kosztów i fizycznego załączenia jednej z konsol A/B/C, a następnie przejścia przez wrota wybranej operacji.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; dopóki żadna konsola nie zostanie załączona, wrota pozostają zamknięte, lecz wszystkie trzy operacje nadal są dostępne i nie powstaje test zręcznościowej poprawności.

signal level_completed
signal previous_level_requested
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
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Komora Wyboru Operacyjnego. Poziom 0. Trzy niezależne stanowiska egzekucyjne: Powrót (A), Zamknięcie Równi (B), Przejście Wzajemne (C)."
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
		"text": "Operacja B (Zamknięcie Równi): Przyjęcie adresu mieszkania 14 i powrót miejscowej Leny. Most zostaje zamknięty. Wyjście do Przestrzeni 42B."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Operacja C (Przejście Wzajemne): Zsynchronizowany powrót obu Len. Most częściowo otwarty, przeciek pamięci. Wyjście do Przestrzeni 42C."
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
	_setup_camera()
	
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	
	_connect_prop_signals()
	_setup_guidance()
	if dialogue_active:
		_show_dialogue_line(dialogue_index)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	var beat_start := GuidanceBeat.new()
	beat_start.beat_id = &"s41_operational_choice"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Komora wyboru. Trzy konsole i fizyczne załączenie odpowiedzialności."
	beat_start.text_en = "Choice chamber. Three consoles and physical commitment of responsibility."
	guidance_service.register_beat(beat_start)


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
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_resonance_triggered):
				pt.resonance_triggered.connect(_on_prop_resonance_triggered)


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
	
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("select_finale_operation"):
		state.select_finale_operation(op)
	
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
	
	# Set dedicated feedback line in CRTDialogueBox
	var op_text := ""
	match op:
		"A":
			op_text = "Wybrano Operację A: Powrót (Własny pokój). Sygnał korelacji 21:45 zakotwiczony. Wrota do Przestrzeni 42A odryglowane."
		"B":
			op_text = "Wybrano Operację B: Zamknięcie Równi (Miejsce po niej). Wzorzec tożsamości z Martą przyjęty. Wrota do Przestrzeni 42B odryglowane."
		"C":
			op_text = "Wybrano Operację C: Przejście Wzajemne (Świadectwo). Synchronizacja obu Len. Wrota do Przestrzeni 42C odryglowane."
	
	dialogue_lines = [
		{
			"speaker": "ROZSTRZYGNIĘCIE",
			"text": op_text
		}
	]
	dialogue_index = 0
	dialogue_active = true
	_show_dialogue_line(0)
	queue_redraw()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "ŚWIADECTWO"), line.get("text", ""))


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
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var map_color: Color = VectorStageStyle.LIGHT_PLANE if is_topography_inspected else VectorStageStyle.MID_PLANE
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(82.0, 92.0),
			Vector2(170.0, 86.0),
			Vector2(176.0, 154.0),
			Vector2(78.0, 160.0),
		]),
		map_color,
		1.0
	)
	var map_accent: Color = VectorStageStyle.ANCHOR_CYAN if is_topography_inspected else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.48)
	for index in range(4):
		var node_position := Vector2(94.0 + float(index) * 22.0, 124.0 - float(index % 2) * 8.0)
		draw_circle(node_position, 3.0, map_accent)
		if index > 0:
			draw_line(node_position - Vector2(22.0, -8.0 if index % 2 == 0 else 8.0), node_position, map_accent, 1.0)

	var console_xs: Array[float] = [220.0, 330.0, 440.0]
	var operation_names: Array[String] = ["A", "B", "C"]
	var console_colors: Array[Color] = [
		VectorStageStyle.ANCHOR_CYAN,
		VectorStageStyle.HUMAN_AMBER,
		VectorStageStyle.CORRECTION_OXIDE,
	]
	for index in range(console_xs.size()):
		var console_x: float = console_xs[index]
		var operation: String = operation_names[index]
		var console_color: Color = console_colors[index]
		var selected := chosen_operation == operation
		if not selected:
			console_color = VectorStageStyle.shade(console_color, 0.46)
		var console_rect := Rect2(console_x - 24.0, 214.0, 48.0, 38.0)
		draw_rect(console_rect, VectorStageStyle.MID_PLANE)
		draw_rect(console_rect, console_color, false, 1.5 if selected else 0.8)
		draw_line(Vector2(console_x - 16.0, 224.0), Vector2(console_x + 16.0, 224.0), console_color, 1.5)
		draw_line(Vector2(console_x - 12.0, 234.0), Vector2(console_x + 12.0, 234.0), console_color, 1.0)
		if selected:
			draw_circle(Vector2(console_x, 246.0), 3.0 + sin(_pulse_phase * 2.8) * 0.8, console_color)

	if is_exit_unlocked:
		draw_line(Vector2(492.0, 224.0), Vector2(604.0, 224.0), VectorStageStyle.HUMAN_AMBER, 2.0)
		draw_line(Vector2(520.0, 232.0), Vector2(604.0, 232.0), VectorStageStyle.ANCHOR_CYAN, 1.0)


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
