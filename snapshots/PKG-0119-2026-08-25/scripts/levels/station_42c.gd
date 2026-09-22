class_name Station42C
extends Node2D

## Space 42C: Świadectwo — Dwie prawdy (Scene 42C)
## Narrative & Mechanical Beat: Scene 42C from FULL_STORY.md, DIALOGUE_SCRIPT.md (D-15C)

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_tram_inspected: bool = false

var _bg_color: Color = Color("081014")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "SZYMON",
		"text": "Była ktoś. Nie trzymam imienia."
	},
	{
		"speaker": "LENA",
		"text": "My trzymamy miejsce."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Miejsce nie zatrzyma schodów."
	},
	{
		"speaker": "JAKUB",
		"text": "Ja zatrzymam te po lewej. Pani bierze prawe."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Nie wydaje mi pan poleceń."
	},
	{
		"speaker": "JAKUB",
		"text": "Pierwsza wspólna wersja. Proszę jej nie zmarnować."
	},
	{
		"speaker": "ŚLAD",
		"text": "WIDZĘ."
	},
	{
		"speaker": "MARTA",
		"text": "My też."
	},
	{
		"speaker": "LENA",
		"text": "Nie wybierajcie mnie. Patrzcie, czy obie zostajemy."
	},
	{
		"speaker": "JAKUB",
		"text": "Lena."
	},
	{
		"speaker": "LENA",
		"text": "Która?"
	},
	{
		"speaker": "JAKUB",
		"text": "Ta, która spytała."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Poranny tramwaj staje przed dwoma torami. Motornicza wybiera jeden na ten przejazd, zapisuje wybór i rusza."
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
	
	if id in ["tram_dual_tracks", "prop_tram_dual_tracks"] or prop_type == 199:
		is_tram_inspected = true
		if dialogue_index < dialogue_lines.size() - 1:
			advance_dialogue()
	elif id in ["station_42c_exit", "prop_station_42c_exit"] or prop_type == 196:
		if not is_exit_unlocked:
			unlock_exit()


func advance_dialogue() -> void:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		unlock_exit()
	queue_redraw()


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	var exit_prop := _get_prop_by_type(196)
	if exit_prop:
		exit_prop.is_activated = true
	queue_redraw()


func _get_prop_by_type(type_val: int) -> MemoryResonancePoint:
	if props == null:
		return null
	for child in props.get_children():
		if child is MemoryResonancePoint and int(child.prop_type) == type_val:
			return child
	return null


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_state_layer()
	if dialogue_active and dialogue_index < dialogue_lines.size():
		_draw_dialogue_overlay()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var track_color := VectorStageStyle.HUMAN_AMBER if is_tram_inspected else VectorStageStyle.LIGHT_PLANE
	for track_index in range(2):
		var track_y := 206.0 + float(track_index) * 28.0
		draw_line(Vector2(64.0, track_y), Vector2(570.0, track_y + 18.0), track_color, 1.6)
		draw_line(Vector2(64.0, track_y + 7.0), Vector2(570.0, track_y + 25.0), VectorStageStyle.shade(track_color, 0.46), 1.0)
	var witness_color := VectorStageStyle.ANCHOR_CYAN if is_tram_inspected else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.42)
	for witness_index in range(3):
		var witness_position := Vector2(166.0 + float(witness_index) * 128.0, 116.0 + float(witness_index % 2) * 10.0)
		draw_circle(witness_position, 3.0, witness_color)
		if witness_index > 0:
			draw_line(witness_position - Vector2(128.0, 10.0 if witness_index % 2 == 1 else -10.0), witness_position, witness_color, 1.0)
	draw_colored_polygon(
		PackedVector2Array([Vector2(520.0, 88.0), Vector2(604.0, 92.0), Vector2(604.0, 174.0), Vector2(520.0, 170.0)]),
		VectorStageStyle.INK,
	)
	draw_line(Vector2(520.0, 224.0), Vector2(604.0, 228.0), VectorStageStyle.CORRECTION_OXIDE if is_exit_unlocked else VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.50), 1.5)


func _draw_dialogue_overlay() -> void:
	var cur: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur.get("speaker", "")
	
	var box_rect := Rect2(30.0, 292.0, 580.0, 58.0)
	draw_rect(box_rect, Color("070d12"))
	draw_rect(box_rect, Color("c65d58"), false, 1.2)
	
	var speaker_color := Color("c65d58")
	if speaker == "LENA":
		speaker_color = Color("5da398")
	elif speaker == "MARTA":
		speaker_color = Color("d39a62")
	elif speaker == "JAKUB":
		speaker_color = Color("75c7c3")
	elif speaker == "SZYMON":
		speaker_color = Color("e2b060")
	elif speaker == "ŚLAD":
		speaker_color = Color("5da398")
	elif speaker == "WIERZBICKA":
		speaker_color = Color("c65d58")
	elif speaker == "ŚWIADECTWO":
		speaker_color = Color("e2b060")
	
	draw_circle(Vector2(48.0, 306.0), 3.0, speaker_color)
	draw_rect(Rect2(42.0, 300.0, 110.0, 14.0), Color("16242e"), false, 1.0)
