class_name Station42A
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Domowy stół z dwoma kubkami i czytnikiem stanowi punkt powrotu po wykonaniu operacji wymuszenia.
## PRZESZKODA — czego wymaga od Leny: Sprawdzenia kubków, konfrontacji z domową Martą i przyjęcia nieodwracalnej ceny zerwanego kontaktu.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; powrót jest trwały, a domowa relacja wymaga bezpośredniej rozmowy.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal cups_inspected
signal phone_inspected
signal chamber_a_witnessed
signal exit_unlocked

const FACT_ENTRY := &"p7.branch_clarity_and_irreversible_choice.trace"
const FACT_CHAMBER_ENTERED := &"p7.conscious_silence_and_presence.chamber_a_entered"
const FACT_WITNESSED := &"p7.conscious_silence_and_presence.final_chamber_witnessed"
const FACT_FEEDBACK := &"p7.conscious_silence_and_presence.safe_trial_feedback"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_cups_inspected: bool = false
var is_phone_inspected: bool = false
var is_chamber_a_witnessed: bool = false

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
	_register_beat(&"s42a_return_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s42a_return_echo", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Własny pokój. Powrót nastąpił, ale obietnice mają realną cenę.", "Own room. Return happened, but promises carry a real cost.", &"", "")
	_register_beat(&"s42a_return_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Powrót z 21:45 ujawnia obecność domowej Marty i dorosłego Jakuba na fotografii.", "Return from 21:45 reveals presence of domestic Marta and adult Jakub on the photo.", &"domestic_presence_with_gaps", "witness_chamber_a")
	_register_beat(&"s42a_return_action", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam kubki na stole, wysłucham rozmowy i udam się do epilogu miejskiego.", "Inspect cups on table, listen to conversation and proceed to city epilogue.", &"", "witness_chamber_a")
	_register_beat(&"s42a_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zbadaj stół z kubkami, by wysłuchać finałowej rozmowy.", "HINT: Inspect the table with cups to hear final dialogue.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_42a"
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


func inspect_cups() -> bool:
	if is_cups_inspected:
		return false
	is_cups_inspected = true
	cups_inspected.emit()
	interaction_triggered.emit("prop_return_cups")
	_activate_prop_by_id("prop_return_cups")
	_activate_prop_by_id("return_cups")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	witness_chamber_a()
	queue_redraw()
	return true


func inspect_phone() -> bool:
	if is_phone_inspected:
		return false
	is_phone_inspected = true
	phone_inspected.emit()
	interaction_triggered.emit("prop_return_phone")
	_activate_prop_by_id("prop_return_phone")
	_activate_prop_by_id("return_phone")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	witness_chamber_a()
	queue_redraw()
	return true


func witness_chamber_a() -> bool:
	if is_chamber_a_witnessed:
		return false
	is_chamber_a_witnessed = true
	_record(FACT_WITNESSED, true)
	chamber_a_witnessed.emit()
	unlock_exit()
	queue_redraw()
	return true


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"return_cups", "prop_return_cups", "Station42ACups":
			inspect_cups()
		"return_phone", "prop_return_phone", "Station42APhone":
			inspect_phone()
		"station_42a_exit", "prop_station_42a_exit", "Station42AExit":
			if is_exit_unlocked:
				_complete_level()
			else:
				witness_chamber_a()
		_:
			match prop_type:
				197:
					inspect_cups()
				196:
					if is_exit_unlocked:
						_complete_level()
					else:
						witness_chamber_a()


func advance_dialogue() -> void:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		witness_chamber_a()
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
	_activate_prop_by_id("Station42AExit")
	_activate_prop_by_id("station_42a_exit")
	_activate_prop_by_id("prop_station_42a_exit")
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


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
