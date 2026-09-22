class_name Station42A
extends Node2D

## Space 42A: Powrót — Własny pokój (Scene 42A)
## Narrative & Mechanical Beat: Scene 42A from FULL_STORY.md, DIALOGUE_SCRIPT.md (D-15A)

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_cups_inspected: bool = false
var is_phone_inspected: bool = false

var _bg_color: Color = Color("091016")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Nie wiem, co stanie się z tą stroną."
	},
	{
		"speaker": "MARTA",
		"text": "Wreszcie prawidłowe zdanie."
	},
	{
		"speaker": "LENA",
		"text": "Chciałabym—"
	},
	{
		"speaker": "MARTA",
		"text": "Nie kończ za nią. Ani za mną."
	},
	{
		"speaker": "JAKUB",
		"text": "Jeśli gdzieś masz mojego brata—"
	},
	{
		"speaker": "LENA",
		"text": "Nie mam. Mam ciebie tutaj i jego tam."
	},
	{
		"speaker": "JAKUB",
		"text": "Dobrze. To pamiętaj osobno."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Uratowałam wariant, nie pana. Nie wiem, dlaczego pan się utrzymał."
	},
	{
		"speaker": "JAKUB",
		"text": "Wiem. Nie jestem pani długiem."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena budzi się w laboratorium o 21:45. Dwa kubki na stole. Na fotografii stoi dorosły Jakub. Podnosi słuchawkę telefonu."
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
	
	if id in ["return_cups", "prop_return_cups"] or prop_type == 197:
		is_cups_inspected = true
		if dialogue_index < dialogue_lines.size() - 1:
			advance_dialogue()
	elif id in ["station_42a_exit", "prop_station_42a_exit"] or prop_type == 196:
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
	# Lab 21:45 background & cold return lighting
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Modernist lab pillars
	for i in range(5):
		var px: float = 40.0 + float(i) * 135.0
		draw_line(Vector2(px, 30.0), Vector2(px, 280.0), Color("15212a"), 2.0)
	
	# Floor line
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("203340"), 2.0)
	
	# Dialogue box in-world
	if dialogue_active and dialogue_index < dialogue_lines.size():
		_draw_dialogue_overlay()


func _draw_dialogue_overlay() -> void:
	var cur: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur.get("speaker", "")
	var text: String = cur.get("text", "")
	
	var box_rect := Rect2(30.0, 292.0, 580.0, 58.0)
	draw_rect(box_rect, Color("080d12"))
	draw_rect(box_rect, Color("5da398"), false, 1.2)
	
	var speaker_color := Color("5da398")
	if speaker == "MARTA":
		speaker_color = Color("d39a62")
	elif speaker == "JAKUB":
		speaker_color = Color("75c7c3")
	elif speaker == "WIERZBICKA":
		speaker_color = Color("c65d58")
	elif speaker == "ŚWIADECTWO":
		speaker_color = Color("e2b060")
	
	draw_circle(Vector2(48.0, 306.0), 3.0, speaker_color)
	draw_rect(Rect2(42.0, 300.0, 110.0, 14.0), Color("0d1720"), false, 1.0)
