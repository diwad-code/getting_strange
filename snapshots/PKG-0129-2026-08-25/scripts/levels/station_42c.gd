class_name Station42C
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Dwa równoległe tory tramwajowe wyznaczają przestrzeń wspólnej obecności obu wersji rzeczywistości.
## PRZESZKODA — czego wymaga od Leny: Sprawdzenia torów, rozpoznania obu kierunków i podjęcia decyzji o wspólnym zachowaniu świadectwa.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; przejście wzajemne utrzymuje most i wymaga wzajemnej uważności.

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_tram_inspected: bool = false

var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

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
	beat_start.beat_id = &"s42c_testimony"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Świadectwo. Dwa tory i most, który przecieka, ale trzyma obie strony."
	beat_start.text_en = "Testimony. Two tracks and a bridge that leaks, but holds both sides."
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
	var track_color := VectorStageStyle.CORRECTION_OXIDE if is_tram_inspected else VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.44)
	draw_line(Vector2(60.0, 260.0), Vector2(580.0, 260.0), track_color, 2.0)
	draw_line(Vector2(60.0, 268.0), Vector2(580.0, 268.0), track_color, 2.0)
	for tx in range(80, 560, 24):
		draw_line(Vector2(float(tx), 256.0), Vector2(float(tx), 272.0), VectorStageStyle.MID_PLANE, 1.0)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(252.0, 168.0),
			Vector2(370.0, 160.0),
			Vector2(382.0, 238.0),
			Vector2(244.0, 244.0),
		]),
		VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.18),
		1.0,
	)
	draw_line(Vector2(252.0, 168.0), Vector2(370.0, 160.0), VectorStageStyle.ANCHOR_CYAN, 1.5)
	draw_line(Vector2(244.0, 244.0), Vector2(382.0, 238.0), VectorStageStyle.HUMAN_AMBER, 1.5)
	draw_line(Vector2(398.0, 222.0), Vector2(604.0, 218.0), VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.50), 1.5)
