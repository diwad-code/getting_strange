class_name Station42C
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Dwa równoległe tory tramwajowe wyznaczają przestrzeń wspólnej obecności obu wersji rzeczywistości.
## PRZESZKODA — czego wymaga od Leny: Sprawdzenia torów, rozpoznania obu kierunków i podjęcia decyzji o wspólnym zachowaniu świadectwa.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; przejście wzajemne utrzymuje most i wymaga wzajemnej uważności.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal tram_inspected
signal chamber_c_witnessed
signal exit_unlocked

const FACT_ENTRY := &"p7.branch_clarity_and_irreversible_choice.trace"
const FACT_CHAMBER_ENTERED := &"p7.conscious_silence_and_presence.chamber_c_entered"
const FACT_WITNESSED := &"p7.conscious_silence_and_presence.final_chamber_witnessed"
const FACT_FEEDBACK := &"p7.conscious_silence_and_presence.safe_trial_feedback"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_tram_inspected: bool = false
var is_chamber_c_witnessed: bool = false

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
	_setup_camera()
	_setup_guidance()
	_connect_prop_signals()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	_record(FACT_CHAMBER_ENTERED, true)
	if dialogue_active:
		_show_dialogue_line(dialogue_index)
	queue_redraw()


func _setup_guidance() -> void:
	if not guidance_service:
		return
	_register_beat(&"s42c_mutual_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s42c_mutual_echo", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Świadectwo. Obie obecności istnieją równolegle w przestrzeni miejskiej.", "Witness. Both presences exist in parallel in the urban space.", &"", "")
	_register_beat(&"s42c_mutual_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Przejście wzajemne utrzymuje dwie równoległe wersje bez konieczności redukcji do jednej.", "Mutual transition maintains two parallel versions without forced reduction to one.", &"dual_continuity_coexistence", "witness_chamber_c")
	_register_beat(&"s42c_mutual_action", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam tory tramwajowe, wysłucham świadków i przejdę do epilogu miejskiego.", "Inspect tram tracks, listen to witnesses and proceed to city epilogue.", &"", "witness_chamber_c")
	_register_beat(&"s42c_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zbadaj rozwidlenie torów tramwajowych, by wysłuchać finałowej rozmowy.", "HINT: Inspect the tram track fork to hear final dialogue.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_42c"
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


func inspect_tram() -> bool:
	if is_tram_inspected:
		return false
	is_tram_inspected = true
	tram_inspected.emit()
	interaction_triggered.emit("prop_return_tram")
	_activate_prop_by_id("prop_return_tram")
	_activate_prop_by_id("return_tram")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	witness_chamber_c()
	queue_redraw()
	return true


func witness_chamber_c() -> bool:
	if is_chamber_c_witnessed:
		return false
	is_chamber_c_witnessed = true
	_record(FACT_WITNESSED, true)
	chamber_c_witnessed.emit()
	unlock_exit()
	queue_redraw()
	return true


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"return_tram", "prop_return_tram", "Station42CTram":
			inspect_tram()
		"station_42c_exit", "prop_station_42c_exit", "Station42CExit":
			if is_exit_unlocked:
				_complete_level()
			else:
				witness_chamber_c()
		_:
			match prop_type:
				199:
					inspect_tram()
				196:
					if is_exit_unlocked:
						_complete_level()
					else:
						witness_chamber_c()


func advance_dialogue() -> void:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		witness_chamber_c()
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
	exit_unlocked.emit()
	_activate_prop_by_id("Station42CExit")
	_activate_prop_by_id("station_42c_exit")
	_activate_prop_by_id("prop_station_42c_exit")
	queue_redraw()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and (child.resonance_id == id or child.name == id):
				child.is_activated = true
				child.queue_redraw()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or (body != null and body.name == "Player"):
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


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var tram_color := VectorStageStyle.CORRECTION_OXIDE if is_tram_inspected else VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.46)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(160.0, 196.0),
			Vector2(360.0, 186.0),
			Vector2(370.0, 244.0),
			Vector2(150.0, 252.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0,
	)
	draw_line(Vector2(160.0, 206.0), Vector2(360.0, 196.0), tram_color, 2.0)
	draw_line(Vector2(150.0, 242.0), Vector2(370.0, 234.0), tram_color, 2.0)
	for index in range(7):
		var tie_progress := float(index) / 6.0
		var top_point := Vector2(160.0, 206.0).lerp(Vector2(360.0, 196.0), tie_progress)
		var bottom_point := Vector2(150.0, 242.0).lerp(Vector2(370.0, 234.0), tie_progress)
		draw_line(top_point, bottom_point, VectorStageStyle.LIGHT_PLANE, 1.0)
	var witness_route_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.48)
	draw_line(Vector2(430.0, 224.0), Vector2(604.0, 218.0), witness_route_color, 1.5)
	draw_line(Vector2(510.0, 232.0), Vector2(604.0, 228.0), VectorStageStyle.shade(witness_route_color, 0.32), 1.0)


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
