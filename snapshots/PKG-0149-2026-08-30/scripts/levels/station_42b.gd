class_name Station42B
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Próg mieszkania 14 i obcy przystanek wyznaczają rozdzielone punkty przebywania obu Len po zamknięciu Równi.
## PRZESZKODA — czego wymaga od Leny: Sprawdzenia progu, przyjęcia faktu nieindeksowanej ciągłości i wysłania wiadomości bez adresata w sieci.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; zamknięcie Równi jest definitywne i chroni miejscową społeczność.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal doorstep_inspected
signal chamber_b_witnessed
signal exit_unlocked

const FACT_ENTRY := &"p7.branch_clarity_and_irreversible_choice.trace"
const FACT_CHAMBER_ENTERED := &"p7.conscious_silence_and_presence.chamber_b_entered"
const FACT_WITNESSED := &"p7.conscious_silence_and_presence.final_chamber_witnessed"
const FACT_FEEDBACK := &"p7.conscious_silence_and_presence.safe_trial_feedback"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_doorstep_inspected: bool = false
var is_chamber_b_witnessed: bool = false

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
		"speaker": "MARTA",
		"text": "Jak się poznaliśmy?"
	},
	{
		"speaker": "LENA",
		"text": "Na odbiorze budynku IKP. Pomyliłaś zawór z czujnikiem."
	},
	{
		"speaker": "MARTA",
		"text": "Ona tak mówiła. Ja niczego nie pomyliłam. Następne pytanie."
	},
	{
		"speaker": "MARTA",
		"text": "Dlaczego po to wróciłaś?"
	},
	{
		"speaker": "LENA",
		"text": "Bo kiedy pierwszy raz cię zobaczyłam, uznałam cię za dowód. Nie chcę drugi raz zrobić tego samego."
	},
	{
		"speaker": "MARTA",
		"text": "Kawa. Jedna. Potem zobaczymy."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Nie wybrałam pana. Wybrałam wariant."
	},
	{
		"speaker": "JAKUB",
		"text": "A ja nie jestem wariantem."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena poprawia obrączkę, zatrzymuje dłoń i dociska paznokieć do szwu palca. Oba gesty pozostają."
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
	_register_beat(&"s42b_closure_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s42b_closure_echo", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Miejsce po niej. Miejscowa Lena wraca do domu, a przybyła Lena staje na obcym przystanku.", "Her place. Local Lena returns home, and arrival Lena stands at a foreign stop.", &"", "")
	_register_beat(&"s42b_closure_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Zamknięcie Równi pozwala na obecność obu Len w ich właściwych przestrzeniach bez instytucjonalnego fałszerstwa.", "Closing the Plane allows presence of both Lenas in their proper spaces without institutional forgery.", &"local_anchoring_in_foreign_city", "witness_chamber_b")
	_register_beat(&"s42b_closure_action", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zbadam próg mieszkania, wysłucham Marty i przejdę do epilogu miejskiego.", "Inspect apartment doorstep, listen to Marta and proceed to city epilogue.", &"", "witness_chamber_b")
	_register_beat(&"s42b_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Zbadaj próg mieszkania 14, by usłyszeć finałowy dialog.", "HINT: Inspect the doorstep of apartment 14 to hear final dialogue.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_42b"
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


func inspect_doorstep() -> bool:
	if is_doorstep_inspected:
		return false
	is_doorstep_inspected = true
	doorstep_inspected.emit()
	interaction_triggered.emit("prop_return_doorstep")
	_activate_prop_by_id("prop_return_doorstep")
	_activate_prop_by_id("return_doorstep")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	witness_chamber_b()
	queue_redraw()
	return true


func witness_chamber_b() -> bool:
	if is_chamber_b_witnessed:
		return false
	is_chamber_b_witnessed = true
	_record(FACT_WITNESSED, true)
	chamber_b_witnessed.emit()
	unlock_exit()
	queue_redraw()
	return true


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"return_doorstep", "prop_return_doorstep", "Station42BDoorstep":
			inspect_doorstep()
		"station_42b_exit", "prop_station_42b_exit", "Station42BExit":
			if is_exit_unlocked:
				_complete_level()
			else:
				witness_chamber_b()
		_:
			match prop_type:
				198:
					inspect_doorstep()
				196:
					if is_exit_unlocked:
						_complete_level()
					else:
						witness_chamber_b()


func advance_dialogue() -> void:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		witness_chamber_b()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
	queue_redraw()


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "MARTA"), line.get("text", ""))


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("Station42BExit")
	_activate_prop_by_id("station_42b_exit")
	_activate_prop_by_id("prop_station_42b_exit")
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
	var door_color := VectorStageStyle.HUMAN_AMBER if is_doorstep_inspected else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.46)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(204.0, 154.0),
			Vector2(294.0, 148.0),
			Vector2(304.0, 242.0),
			Vector2(196.0, 248.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0,
	)
	draw_rect(Rect2(228.0, 168.0, 42.0, 72.0), VectorStageStyle.INK)
	draw_rect(Rect2(228.0, 168.0, 42.0, 72.0), door_color, false, 1.2)
	draw_line(Vector2(264.0, 206.0), Vector2(266.0, 206.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	var route_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.48)
	draw_line(Vector2(430.0, 224.0), Vector2(604.0, 218.0), route_color, 1.5)
	draw_line(Vector2(510.0, 232.0), Vector2(604.0, 228.0), VectorStageStyle.shade(route_color, 0.32), 1.0)


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
