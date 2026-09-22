class_name Station39
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Pulpit sterujący rozdziela trzy obwody transmisyjne i blokuje impuls do czasu zatwierdzenia jednej metody z pełnym bilansem kosztów.
## PRZESZKODA — czego wymaga od Leny: Zbadania matrycy sześciu parametrów, porównania trzech metod i załączenia obwodu wybranego rozwiązania.
## PRZESZKODA — koszt porażki: Niezatwierdzone parametry uniemożliwiają załączenie przekaźnika mocy i wymagają ponownej weryfikacji matrycy.

signal level_completed
signal previous_level_requested
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
		"speaker": "ŚWIADECTWO",
		"text": "Pulpit Wyboru Metody. Serce Podstruktury. Trzy obwody transmisyjne reprezentują trzy odmienne wartości i koszty."
	},
	{
		"speaker": "JAKUB",
		"text": "Rozdzielnica trzyma most. Jeśli wybierzesz metodę, musisz zrobić to z pełną świadomością braków."
	},
	{
		"speaker": "LENA",
		"text": "Metoda A: Wymuszenie powrotu. Ustawiam domowy numer. Jeśli zamknie drugi sygnał, miejscowa Lena zostanie poza Równią."
	},
	{
		"speaker": "ŚLAD",
		"text": "METODA B: ZAMKNIĘCIE RÓWNI. NAJPIERW SPROWADZISZ MNIE DO MOJEGO ADRESU. DLA CIEBIE ZOSTANIE PRZEJŚCIE BEZ NUMERU."
	},
	{
		"speaker": "JAKUB",
		"text": "A Metoda C... Świadectwo. Publiczna sieć sprzecznych świadków. Dwie prawdy istniejące obok siebie."
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
		"text": "Pulpit wyboru zostaje uzbrojony. Wrota do Komory Ostatniego Impulsu (Station 40) stoją otworem."
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
	beat_start.beat_id = &"s39_method_selection"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Stół zgód i braków. Trzy metody bez moralizowania i bez łatwego wyjścia."
	beat_start.text_en = "Table of consents and gaps. Three methods without moralizing and without easy exits."
	guidance_service.register_beat(beat_start)


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
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_resonance_triggered):
				pt.resonance_triggered.connect(_on_prop_resonance_triggered)


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
		_show_dialogue_line(dialogue_index)
		
		# Line 9 triggers the Act IV ascent gateway unseal
		if dialogue_index >= 9:
			unlock_exit()
	else:
		is_dialogue_completed = true
		dialogue_active = false
		unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"s39_method_reviewed", true)


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
