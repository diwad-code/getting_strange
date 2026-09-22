class_name Station43
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Tablice ogłoszeń, karty spraw i rozkłady jazdy w mieście utrwalają stan sześciu podmiotów po rozstrzygnięciu.
## PRZESZKODA — czego wymaga od Leny: Odczytania tablicy miejskiej, przejścia przez napisy końcowe i wykonania ostatniej diegetycznej czynności.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; epilog jest zapisem nieodwracalnej nowej ciągłości i zamyka grę.

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

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
@onready var camera: Camera2D = get_node_or_null("Camera2D")
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
	beat_start.beat_id = &"s43_epilogue"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Epilog. Miasto żyje dalej z dokonanym wyborem i zapisanym stanem sześciu podmiotów."
	beat_start.text_en = "Epilogue. The city lives on with the choice made and the recorded state of six entities."
	guidance_service.register_beat(beat_start)


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


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	interaction_triggered.emit(id)
	
	if id in ["admin_notice_board", "prop_admin_notice_board"] or prop_type == 200:
		is_notice_inspected = true
		if dialogue_index < dialogue_lines.size() - 1:
			advance_dialogue()
	elif id in ["credits_roll", "prop_credits_roll"] or prop_type == 201:
		is_credits_inspected = true
		if dialogue_index < dialogue_lines.size() - 1:
			advance_dialogue()
	elif id in ["final_blackout", "prop_final_blackout"] or prop_type == 202:
		is_blackout_inspected = true
		unlock_exit()
		_complete_campaign()


func unlock_exit() -> void:
	is_exit_unlocked = true
	if props:
		var blackout_prop := props.get_node_or_null("FinalBlackout") as MemoryResonancePoint
		if blackout_prop:
			blackout_prop.is_activated = true
			blackout_prop.queue_redraw()
	queue_redraw()


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


func _complete_campaign() -> void:
	is_level_completed = true
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		if state.has_method("complete_station"):
			state.complete_station(&"station_43")
		else:
			state.set("campaign_completed", true)
	level_completed.emit()


func _on_airlock_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or body.name == "Player":
		_complete_campaign()


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
