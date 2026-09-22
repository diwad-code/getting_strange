class_name Station43
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Tablice ogłoszeń, karty spraw i rozkłady jazdy w mieście utrwalają stan sześciu podmiotów po rozstrzygnięciu.
## PRZESZKODA — czego wymaga od Leny: Odczytania tablicy miejskiej, przejścia przez napisy końcowe i wykonania ostatniej diegetycznej czynności.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; epilog jest zapisem nieodwracalnej nowej ciągłości i zamyka grę.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal notice_inspected
signal credits_inspected
signal blackout_inspected
signal epilogue_completed
signal exit_unlocked

const FACT_ENTRY := &"p7.conscious_silence_and_presence.final_chamber_witnessed"
const FACT_NOTICE := &"p7.conscious_silence_and_presence.epilogue_noticed"
const FACT_CREDITS := &"p7.conscious_silence_and_presence.epilogue_credits_read"
const FACT_COMPLETED := &"p7.conscious_silence_and_presence.epilogue_completed"
const FACT_COMMITMENT := &"p7.conscious_silence_and_presence.commitment"
const FACT_TRACE := &"p7.conscious_silence_and_presence.trace"
const FACT_FEEDBACK := &"p7.conscious_silence_and_presence.safe_trial_feedback"

@export var is_notice_inspected: bool = false
@export var is_credits_inspected: bool = false
@export var is_blackout_inspected: bool = false
@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var _pulse_phase: float = 0.0

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
	_register_beat(&"s43_epilogue_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s43_epilogue", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Epilog. Miasto żyje dalej z dokonanym wyborem i zapisanym stanem sześciu podmiotów.", "Epilogue. The city lives on with the choice made and the recorded state of six entities.", &"", "")
	_register_beat(&"s43_epilogue_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Zapisane relacje i stan infrastruktury utrwalają wykonany wybór bez fałszywego happy endu.", "Recorded relations and infrastructure state preserve the committed choice without false happy endings.", &"domestic_presence_with_gaps", "complete_epilogue")
	_register_beat(&"s43_epilogue_action", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Odczytam tablicę ogłoszeń, przejrzę napisy końcowe i zamknę podróż.", "Read notice board, review credits roll and conclude journey.", &"", "complete_epilogue")
	_register_beat(&"s43_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odczytaj tablicę ogłoszeń i napisy końcowe, by zamknąć grę.", "HINT: Read notice board and credits to complete the game.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_43"
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
	_pulse_phase += delta * 2.0
	queue_redraw()


func _connect_prop_signals() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_resonance_triggered):
				pt.resonance_triggered.connect(_on_prop_resonance_triggered)


func inspect_notice() -> bool:
	if is_notice_inspected:
		return false
	is_notice_inspected = true
	_record(FACT_NOTICE, true)
	notice_inspected.emit()
	interaction_triggered.emit("prop_admin_notice_board")
	_activate_prop_by_id("prop_admin_notice_board")
	_activate_prop_by_id("admin_notice_board")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	queue_redraw()
	return true


func inspect_credits() -> bool:
	if is_credits_inspected:
		return false
	is_credits_inspected = true
	_record(FACT_CREDITS, true)
	credits_inspected.emit()
	interaction_triggered.emit("prop_credits_roll")
	_activate_prop_by_id("prop_credits_roll")
	_activate_prop_by_id("credits_roll")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	queue_redraw()
	return true


func inspect_blackout() -> bool:
	if is_blackout_inspected:
		return false
	is_blackout_inspected = true
	_record(FACT_COMPLETED, true)
	_record(&"epilogue_witness_completed", true)
	_record(FACT_COMMITMENT, "epilogue_presence_witnessed")
	_record(FACT_TRACE, "conscious_silence_and_presence_witnessed")
	blackout_inspected.emit()
	interaction_triggered.emit("prop_final_blackout")
	_activate_prop_by_id("prop_final_blackout")
	_activate_prop_by_id("final_blackout")
	unlock_exit()
	_complete_campaign()
	queue_redraw()
	return true


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"admin_notice_board", "prop_admin_notice_board":
			inspect_notice()
		"credits_roll", "prop_credits_roll":
			inspect_credits()
		"final_blackout", "prop_final_blackout":
			inspect_blackout()
		_:
			match prop_type:
				200:
					inspect_notice()
				201:
					inspect_credits()
				202:
					inspect_blackout()


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
	exit_unlocked.emit()
	_activate_prop_by_id("FinalBlackout")
	_activate_prop_by_id("final_blackout")
	_activate_prop_by_id("prop_final_blackout")
	queue_redraw()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and (child.resonance_id == id or child.name == id):
				child.is_activated = true
				child.queue_redraw()


func _complete_campaign() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	_record(FACT_COMPLETED, true)
	_record(&"epilogue_witness_completed", true)
	_record(FACT_COMMITMENT, "epilogue_presence_witnessed")
	_record(FACT_TRACE, "conscious_silence_and_presence_witnessed")
	epilogue_completed.emit()
	
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		if state.has_method("complete_station"):
			state.complete_station(&"station_43")
		else:
			state.set("campaign_completed", true)
	level_completed.emit()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or (body != null and body.name == "Player"):
		if not is_level_completed:
			_complete_campaign()
		else:
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
	var notice_color := VectorStageStyle.HUMAN_AMBER if is_notice_inspected else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.44)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(110.0, 110.0),
			Vector2(210.0, 104.0),
			Vector2(218.0, 172.0),
			Vector2(104.0, 178.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0,
	)
	draw_line(Vector2(118.0, 126.0), Vector2(202.0, 122.0), notice_color, 1.5)
	draw_line(Vector2(118.0, 138.0), Vector2(188.0, 134.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(118.0, 150.0), Vector2(196.0, 146.0), VectorStageStyle.shade(notice_color, 0.6), 1.0)

	var credits_color := VectorStageStyle.ANCHOR_CYAN if is_credits_inspected else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.46)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(290.0, 100.0),
			Vector2(390.0, 94.0),
			Vector2(398.0, 168.0),
			Vector2(284.0, 174.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0,
	)
	draw_line(Vector2(298.0, 116.0), Vector2(382.0, 112.0), credits_color, 1.5)
	draw_line(Vector2(298.0, 128.0), Vector2(368.0, 124.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(298.0, 140.0), Vector2(376.0, 136.0), VectorStageStyle.shade(credits_color, 0.6), 1.0)

	var blackout_color := VectorStageStyle.LIGHT_PLANE if is_blackout_inspected else VectorStageStyle.MID_PLANE
	draw_circle(Vector2(520.0, 244.0), 12.0, blackout_color)
	draw_circle(Vector2(520.0, 244.0), 16.0 + sin(_pulse_phase * 2.0) * 2.0, VectorStageStyle.shade(blackout_color, 0.4))


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
