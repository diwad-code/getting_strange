class_name Station38
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Śluza przedkomorowa wymaga synchronizacji zgód radiowych Marty i nastaw rozdzielnicy Jakuba przed otwarciem komory wyboru.
## PRZESZKODA — czego wymaga od Leny: Skonfrontowania Marty z procedurą miejscowej Leny, ustalenia stanu zgód i otwarcia śluzy decyzyjnej.
## PRZESZKODA — koszt porażki: Zatajenie faktów ogranicza dostępne warianty synchronizacji i wymaga ponownego odczytu rejestru przed odblokowaniem przejścia.

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_calculator_inspected: bool = false
var is_accident_field_inspected: bool = false
var is_jakub_shadow_inspected: bool = false
var is_rescue_tether_anchored: bool = false
var rescue_correction_count: int = 0
var rescue_detail_faded: bool = false
var rescue_boundary_crossed: bool = false

# Internal visuals
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var rescue_bulkhead: AnchorableObject = get_node_or_null("Geometry/JakubRescueBulkhead") as AnchorableObject
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Strefa Decyzji. Śluza przedkomorowa wymaga synchronizacji zgód radiowych Marty i nastaw rozdzielnicy Jakuba."
	},
	{
		"speaker": "JAKUB",
		"text": "Zabezpieczyłem rozdzielnicę. Jeśli odetniesz zasilanie bez synchronizacji, stracimy kanał powrotny."
	},
	{
		"speaker": "LENA",
		"text": "Oto notatka miejscowej Leny. Zapis procedury z warunkiem przerwania po trzech sekundach."
	},
	{
		"speaker": "MARTA",
		"text": "Ona wiedziała?"
	},
	{
		"speaker": "JAKUB",
		"text": "Wiedziała, że ktoś może odpowiedzieć."
	},
	{
		"speaker": "LENA",
		"text": "Nie po to zeszłam do Podstruktury, żeby złożyć kogokolwiek w ofierze. Potrzebujemy twojej zgody, Marto."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Marta wydaje zgodę na procedurę ratunkową z zachowaniem własnych granic. Przewód synchronizacji zostaje podpięty."
	},
	{
		"speaker": "JAKUB",
		"text": "Moja rozdzielnica jest gotowa. Dziesięć sekund synchronizacji, moja ręka na wyłączniku."
	},
	{
		"speaker": "LENA",
		"text": "Dziękuję, Jakub. Wchodzimy do komory wyboru."
	},
	{
		"speaker": "JAKUB",
		"text": "Możemy to sprawdzić razem. Chodźmy do Pulpitu Wyboru Metody."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Śluza do Komory Wyboru Metody ustępuje. Przed wami rozpościera się serce Podstruktury i ostateczny wybór."
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
	
	_setup_rescue_bulkhead()
	_connect_prop_signals()
	_setup_guidance()
	if dialogue_active:
		_show_dialogue_line(dialogue_index)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	var beat_start := GuidanceBeat.new()
	beat_start.beat_id = &"s38_marta_consent"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Strefa decyzji. Marta stawia granice, a Jakub pilnuje rozdzielnicy."
	beat_start.text_en = "Decision zone. Marta sets boundaries, and Jakub watches the switchboard."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
	_pulse_phase += delta * 2.8
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.6)
		queue_redraw()


func _physics_process(_delta: float) -> void:
	if rescue_bulkhead and player:
		rescue_bulkhead.update_player_distance(player.global_position)
		if is_dialogue_completed and not rescue_boundary_crossed and player.global_position.x > 430.0:
			rescue_boundary_crossed = true
			run_rescue_bulkhead_correction_pass()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"trigger_correction") and not event.is_echo():
		run_rescue_bulkhead_correction_pass()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if dialogue_active:
			advance_dialogue()
			get_viewport().set_input_as_handled()
			return
	if event.is_action_pressed(&"interact") and rescue_bulkhead and rescue_bulkhead.is_player_in_range:
		rescue_bulkhead.toggle_anchor()
		get_viewport().set_input_as_handled()


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
	
	if id in ["coordinate_calc", "prop_coordinate_calc"] or prop_type == 180:
		is_calculator_inspected = true
		if dialogue_index == 0 or dialogue_index == 1:
			advance_dialogue()
	elif id in ["accident_field", "prop_accident_field"] or prop_type == 177:
		is_accident_field_inspected = true
		if dialogue_index in [2, 3]:
			advance_dialogue()
	elif id in ["jakub_shadow", "prop_jakub_shadow"] or prop_type == 178:
		is_jakub_shadow_inspected = true
		if dialogue_index in [4, 5]:
			advance_dialogue()
	elif id in ["rescue_tether", "prop_rescue_tether"] or prop_type == 179:
		is_rescue_tether_anchored = true
		if dialogue_index in [6, 7, 8]:
			advance_dialogue()
	elif id in ["station_38_exit", "prop_reference_exit"] or prop_type == 181:
		if is_exit_unlocked:
			_complete_level()


func _setup_rescue_bulkhead() -> void:
	if rescue_bulkhead == null:
		return
	if not rescue_bulkhead.anchor_state_changed.is_connected(_on_rescue_bulkhead_anchor_changed):
		rescue_bulkhead.anchor_state_changed.connect(_on_rescue_bulkhead_anchor_changed)
	rescue_bulkhead.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("has_recorded_decision"):
		rescue_detail_faded = state.has_recorded_decision(&"station_38_jakub_rescue_corrected")
	elif state:
		var decisions: Variant = state.get("decisions")
		if decisions is Dictionary:
			rescue_detail_faded = (decisions as Dictionary).has(&"station_38_jakub_rescue_corrected")


func _on_rescue_bulkhead_anchor_changed(anchored: bool) -> void:
	is_rescue_tether_anchored = anchored
	queue_redraw()


func run_rescue_bulkhead_correction_pass() -> void:
	if rescue_bulkhead == null:
		return
	rescue_bulkhead.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	if rescue_bulkhead.current_reality == AnchorableObject.RealityState.STATE_B and not rescue_bulkhead.is_anchored:
		_apply_rescue_bulkhead_correction()


func _apply_rescue_bulkhead_correction() -> void:
	rescue_correction_count += 1
	rescue_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("record_decision"):
		state.record_decision(&"station_38_jakub_rescue_corrected", rescue_correction_count)
	var tether_prop: MemoryResonancePoint = null
	if props:
		tether_prop = props.get_node_or_null("RescueTetherAnchor") as MemoryResonancePoint
	if tether_prop:
		tether_prop.prop_subtitle = "Węzeł ratunkowy — przewód Jakuba wyblakł po korekcie"
	rescue_bulkhead.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if player and player.has_method("reset_to"):
		player.reset_to(CHECKPOINT_POSITION)
	elif player:
		player.position = CHECKPOINT_POSITION
	rescue_boundary_crossed = false
	queue_redraw()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		
		# Line 9 triggers the reference chamber vault unseal
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
			state.record_decision(&"s38_marta_truth_state", "full")


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
		var exit_prop := props.get_node_or_null("Station38Exit") as MemoryResonancePoint
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
	var field_color := VectorStageStyle.CORRECTION_OXIDE if is_accident_field_inspected else VectorStageStyle.MID_PLANE
	draw_colored_polygon(PackedVector2Array([Vector2(212.0, 164.0), Vector2(310.0, 150.0), Vector2(326.0, 218.0), Vector2(224.0, 232.0)]), field_color)
	var shadow_color := VectorStageStyle.HUMAN_AMBER if is_jakub_shadow_inspected else VectorStageStyle.LIGHT_PLANE
	draw_colored_polygon(PackedVector2Array([Vector2(318.0, 174.0), Vector2(348.0, 168.0), Vector2(358.0, 238.0), Vector2(326.0, 244.0)]), shadow_color)
	var bulkhead_color := VectorStageStyle.CORRECTION_OXIDE if rescue_detail_faded else VectorStageStyle.ANCHOR_CYAN
	if is_rescue_tether_anchored:
		bulkhead_color = VectorStageStyle.ANCHOR_CYAN
	draw_line(Vector2(470.0, 58.0), Vector2(470.0, 270.0), bulkhead_color, 2.0)
	draw_line(Vector2(478.0, 58.0), Vector2(478.0, 270.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	if is_rescue_tether_anchored:
		draw_line(Vector2(398.0, 214.0), Vector2(452.0, 214.0), VectorStageStyle.ANCHOR_CYAN, 1.5)
	if is_exit_unlocked:
		draw_line(Vector2(522.0, 222.0), Vector2(606.0, 222.0), VectorStageStyle.HUMAN_AMBER, 2.0)
