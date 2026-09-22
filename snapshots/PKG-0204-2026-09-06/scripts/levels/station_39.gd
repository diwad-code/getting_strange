class_name Station39
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Pulpit sterujący rozdziela trzy obwody transmisyjne i blokuje impuls do czasu zatwierdzenia jednej metody z pełnym bilansem kosztów.
## PRZESZKODA — czego wymaga od Leny: Zbadania matrycy sześciu parametrów, porównania trzech metod i załączenia obwodu wybranego rozwiązania.
## PRZESZKODA — koszt porażki: Niezatwierdzone parametry uniemożliwiają załączenie przekaźnika mocy i wymagają ponownej weryfikacji matrycy.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal config_a_inspected
signal config_b_inspected
signal reference_core_inspected
signal config_c_inspected
signal method_matrix_reviewed
signal exit_unlocked

const FACT_ENTRY := &"p7.consent_and_rescue_boundary.trace"
const FACT_CONFIG_A := &"p7.branch_clarity_and_irreversible_choice.config_a_inspected"
const FACT_CONFIG_B := &"p7.branch_clarity_and_irreversible_choice.config_b_inspected"
const FACT_CORE := &"p7.branch_clarity_and_irreversible_choice.reference_core_inspected"
const FACT_CONFIG_C := &"p7.branch_clarity_and_irreversible_choice.config_c_inspected"
const FACT_MATRIX := &"p7.branch_clarity_and_irreversible_choice.matrix_reviewed"
const FACT_FEEDBACK := &"p7.branch_clarity_and_irreversible_choice.safe_trial_feedback"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_config_a_inspected: bool = false
var is_config_b_inspected: bool = false
var is_reference_core_inspected: bool = false
var is_config_c_inspected: bool = false
var is_matrix_reviewed: bool = false

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
	_setup_camera()
	_setup_guidance()
	_connect_prop_signals()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	if dialogue_active:
		_show_dialogue_line(dialogue_index)
	queue_redraw()


func _setup_guidance() -> void:
	if not guidance_service:
		return
	_register_beat(&"s39_method_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s39_method_selection", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Stół zgód i braków. Trzy metody bez moralizowania i bez łatwego wyjścia.", "Table of consents and gaps. Three methods without moralizing and without easy exits.", &"", "")
	_register_beat(&"s39_method_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Pulpit nie ocenia intencji — każde z trzech ustawień ma ścisłą cenę ciągłości.", "The console does not judge intentions — each of the three configurations has a strict continuity cost.", &"forced_return_isolation", "review_method_matrix")
	_register_beat(&"s39_pulpit_action", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam konfiguracje A, B i C, sprawdzę rdzeń referencyjny i zatwierdzę matrycę metod.", "Inspect configurations A, B and C, check reference core and confirm method matrix.", &"", "review_method_matrix")
	_register_beat(&"s39_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zbadaj trzy konfiguracje pulpitu i rdzeń, by odryglować przejście.", "HINT: Inspect three console configurations and the core to unlock passage.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_39"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


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


func inspect_config_a() -> bool:
	if is_config_a_inspected:
		return false
	is_config_a_inspected = true
	_record(FACT_CONFIG_A, true)
	config_a_inspected.emit()
	interaction_triggered.emit("prop_config_a")
	_activate_prop_by_id("prop_config_a")
	_activate_prop_by_id("config_a")
	if dialogue_index == 0 or dialogue_index == 1:
		advance_dialogue()
	_check_matrix_ready()
	queue_redraw()
	return true


func inspect_config_b() -> bool:
	if is_config_b_inspected:
		return false
	is_config_b_inspected = true
	_record(FACT_CONFIG_B, true)
	config_b_inspected.emit()
	interaction_triggered.emit("prop_config_b")
	_activate_prop_by_id("prop_config_b")
	_activate_prop_by_id("config_b")
	if dialogue_index in [2, 3]:
		advance_dialogue()
	_check_matrix_ready()
	queue_redraw()
	return true


func inspect_reference_core() -> bool:
	if is_reference_core_inspected:
		return false
	is_reference_core_inspected = true
	_record(FACT_CORE, true)
	reference_core_inspected.emit()
	interaction_triggered.emit("prop_reference_core")
	_activate_prop_by_id("prop_reference_core")
	_activate_prop_by_id("reference_core")
	if dialogue_index in [4, 5, 6]:
		advance_dialogue()
	_check_matrix_ready()
	queue_redraw()
	return true


func inspect_config_c() -> bool:
	if is_config_c_inspected:
		return false
	is_config_c_inspected = true
	_record(FACT_CONFIG_C, true)
	config_c_inspected.emit()
	interaction_triggered.emit("prop_config_c")
	_activate_prop_by_id("prop_config_c")
	_activate_prop_by_id("config_c")
	if dialogue_index in [7, 8]:
		advance_dialogue()
	_check_matrix_ready()
	queue_redraw()
	return true


func review_method_matrix() -> bool:
	if is_matrix_reviewed:
		return false
	if not (is_config_a_inspected and is_config_b_inspected and is_reference_core_inspected and is_config_c_inspected):
		_record_feedback(&"matrix_elements_incomplete")
		return false
	is_matrix_reviewed = true
	_record(FACT_MATRIX, true)
	method_matrix_reviewed.emit()
	unlock_exit()
	queue_redraw()
	return true


func _check_matrix_ready() -> void:
	if is_config_a_inspected and is_config_b_inspected and is_reference_core_inspected and is_config_c_inspected:
		review_method_matrix()


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"config_a", "prop_config_a":
			inspect_config_a()
		"config_b", "prop_config_b":
			inspect_config_b()
		"reference_core", "prop_reference_core":
			inspect_reference_core()
		"config_c", "prop_config_c":
			inspect_config_c()
		"station_39_exit", "prop_act4_gateway", "Station39Exit":
			if is_exit_unlocked:
				_complete_level()
			else:
				_record_feedback(&"matrix_review_required")
		_:
			match prop_type:
				183:
					inspect_config_a()
				184:
					inspect_config_b()
				182:
					inspect_reference_core()
				185:
					inspect_config_c()
				186:
					if is_exit_unlocked:
						_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		if dialogue_index >= 9:
			unlock_exit()
	else:
		is_dialogue_completed = true
		dialogue_active = false
		unlock_exit()
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
	exit_unlocked.emit()
	_activate_prop_by_id("Station39Exit")
	_activate_prop_by_id("station_39_exit")
	_activate_prop_by_id("prop_act4_gateway")
	queue_redraw()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and (child.resonance_id == id or child.name == id):
				child.is_activated = true
				child.queue_redraw()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or (body != null and body.name == "Player"):
		if is_exit_unlocked:
			_complete_level()


func _complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has(fact_key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return true
	if state.decisions.has(fact_key):
		return true
	return state.decisions.has(String(fact_key))


func _record(fact_key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("record_decision"):
		state.record_decision(fact_key, value)


func _record_feedback(feedback_id: StringName) -> void:
	_record(FACT_FEEDBACK, String(feedback_id))


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


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
