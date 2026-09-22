class_name Station43
extends Node2D

## Space 43: Napisy i epilog systemowy (Scene 43)
## Narrative & Mechanical Beat: Scene 43 from FULL_STORY.md & Epilogue Canon

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_notice_inspected: bool = false
var is_credits_inspected: bool = false
var is_blackout_inspected: bool = false

var _bg_color: Color = Color("05090c")
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
		"text": "Napisy pojawiają się na zwyczajnych elementach miasta: rozkładach jazdy, kartach spraw, tablicach pracowni."
	},
	{
		"speaker": "POWRÓT",
		"text": "Radio podaje: »Linia 4 zamknięta do odwołania. Prosimy korzystać z wyznaczonego obejścia.« W mieście Leny ta linia według niej nigdy nie istniała."
	},
	{
		"speaker": "UZGODNIENIE",
		"text": "Karta zgłoszenia podaje: »Pęknięcie oznaczone. Data kontroli: po przybyciu osoby zgłaszającej.« Marta dopisuje datę ręcznie, bez komentarza."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Tablica UCP podaje: »W tej części budynku utrzymują się dwie kolejności. Przed przejściem ustal kierunek z drugą osobą.« Nikt nie usuwa żadnej z nich."
	},
	{
		"speaker": "GETTING STRANGE",
		"text": "Prawda nie wybiera za człowieka. Wybór należy do odpowiedzialności. Koniec wycinka fabularnego."
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
	_pulse_phase += delta * 2.5
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
	
	if id in ["admin_notice_board", "prop_admin_notice_board"] or prop_type == 200:
		is_notice_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["credits_roll", "prop_credits_roll"] or prop_type == 201:
		is_credits_inspected = true
		if dialogue_index < dialogue_lines.size() - 1:
			advance_dialogue()
	elif id in ["final_blackout", "prop_final_blackout"] or prop_type == 202:
		is_blackout_inspected = true
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
	var exit_prop := _get_prop_by_type(202)
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
	var notice_color := VectorStageStyle.LIGHT_PLANE if is_notice_inspected else VectorStageStyle.MID_PLANE
	var credits_color := VectorStageStyle.HUMAN_AMBER if is_credits_inspected else VectorStageStyle.MID_PLANE
	var blackout_color := VectorStageStyle.ANCHOR_CYAN if is_blackout_inspected else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.48)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(92.0, 92.0),
			Vector2(222.0, 86.0),
			Vector2(224.0, 190.0),
			Vector2(90.0, 196.0),
		]),
		notice_color,
		1.0,
	)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(274.0, 78.0),
			Vector2(404.0, 80.0),
			Vector2(406.0, 188.0),
			Vector2(272.0, 186.0),
		]),
		credits_color,
		1.0,
	)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(466.0, 92.0),
			Vector2(586.0, 96.0),
			Vector2(588.0, 184.0),
			Vector2(468.0, 180.0),
		]),
		blackout_color,
		1.0,
	)
	draw_line(Vector2(112.0, 120.0), Vector2(204.0, 116.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(294.0, 112.0), Vector2(382.0, 114.0), VectorStageStyle.HUMAN_AMBER, 1.0)
	draw_line(Vector2(486.0, 126.0), Vector2(570.0, 130.0), blackout_color, 1.0)
	draw_line(Vector2(220.0, 218.0), Vector2(420.0, 214.0), VectorStageStyle.CORRECTION_OXIDE, 1.0)
	if is_exit_unlocked:
		draw_line(Vector2(510.0, 226.0), Vector2(604.0, 222.0), VectorStageStyle.HUMAN_AMBER, 1.5)


func _draw_dialogue_overlay() -> void:
	var cur: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur.get("speaker", "")
	
	var box_rect := Rect2(30.0, 292.0, 580.0, 58.0)
	draw_rect(box_rect, Color("04070a"))
	draw_rect(box_rect, Color("5da398"), false, 1.2)
	
	var speaker_color := Color("5da398")
	if speaker == "POWRÓT":
		speaker_color = Color("75c7c3")
	elif speaker == "UZGODNIENIE":
		speaker_color = Color("d39a62")
	elif speaker == "ŚWIADECTWO":
		speaker_color = Color("c65d58")
	elif speaker == "GETTING STRANGE":
		speaker_color = Color("e2b060")
	
	draw_circle(Vector2(48.0, 306.0), 3.0, speaker_color)
	draw_rect(Rect2(42.0, 300.0, 110.0, 14.0), Color("0f1820"), false, 1.0)
