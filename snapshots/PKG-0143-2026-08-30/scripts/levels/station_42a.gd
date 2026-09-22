class_name Station42A
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Domowy stół z dwoma kubkami i czytnikiem stanowi punkt powrotu po wykonaniu operacji wymuszenia.
## PRZESZKODA — czego wymaga od Leny: Sprawdzenia kubków, konfrontacji z domową Martą i przyjęcia nieodwracalnej ceny zerwanego kontaktu.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; powrót jest trwały, a domowa relacja wymaga bezpośredniej rozmowy.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_cups_inspected: bool = false
var is_phone_inspected: bool = false

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
	beat_start.beat_id = &"s42a_return_echo"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Własny pokój. Powrót nastąpił, ale obietnice mają realną cenę."
	beat_start.text_en = "Own room. Return happened, but promises carry a real cost."
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
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
	queue_redraw()


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
	var exit_prop := _get_prop_by_type(196)
	if exit_prop:
		exit_prop.is_activated = true
		exit_prop.queue_redraw()
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


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var cups_color := VectorStageStyle.HUMAN_AMBER if is_cups_inspected else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.46)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(198.0, 214.0),
			Vector2(336.0, 208.0),
			Vector2(346.0, 238.0),
			Vector2(188.0, 244.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0,
	)
	draw_colored_polygon(
		PackedVector2Array([Vector2(238.0, 202.0), Vector2(258.0, 200.0), Vector2(260.0, 215.0), Vector2(240.0, 217.0)]),
		cups_color,
	)
	draw_colored_polygon(
		PackedVector2Array([Vector2(278.0, 200.0), Vector2(298.0, 199.0), Vector2(300.0, 214.0), Vector2(280.0, 215.0)]),
		cups_color,
	)
	draw_line(Vector2(318.0, 210.0), Vector2(334.0, 209.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	var return_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.48)
	draw_line(Vector2(440.0, 224.0), Vector2(604.0, 218.0), return_color, 1.5)
	draw_line(Vector2(520.0, 232.0), Vector2(604.0, 228.0), VectorStageStyle.shade(return_color, 0.32), 1.0)


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
