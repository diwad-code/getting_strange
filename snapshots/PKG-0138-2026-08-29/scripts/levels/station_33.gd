class_name Station33
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Szyb wentylacyjny łączy poziom depozytów z centralną maszynownią Podstruktury.
## PRZESZKODA — czego wymaga od Leny: Zejścia po ciągu drabin, odczytania manometru i formuły przerwania testu oraz zestrojenia ramy świadectw.
## PRZESZKODA — koszt porażki: Zignorowanie warunku przerwania powoduje przesunięcie konfiguracji ramy i powrót do punktu kontrolnego.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

const COLOR_BACKGROUND := Color("080a0e")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal ladder_inspected
signal gauge_inspected
signal cable_trunk_inspected
signal work_light_inspected
signal exit_unlocked
signal dialogue_started
signal dialogue_advanced(line_idx: int)
signal dialogue_completed

const LEVEL_ID := "station_33"
const LEVEL_NAME := "Przestrzeń 33: Szyb wentylacyjny"
const SCENE_SUBTITLE := "Ciśnienie powrotne / Notatka z warunkiem przerwania"

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var is_ladder_inspected: bool = false
var is_gauge_inspected: bool = false
var is_cable_trunk_inspected: bool = false
var is_work_light_inspected: bool = false

var witness_frame_correction_count: int = 0
var last_witness_frame_correction_target: AnchorableObject.RealityState = AnchorableObject.RealityState.STATE_A
var witness_frame_detail_faded: bool = false
var is_witness_frame_anchored: bool = false

var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Node2D = get_node_or_null("Camera2D") if get_node_or_null("Camera2D") else get_node_or_null("Camera")
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")
@onready var witness_frame: AnchorableObject = get_node_or_null("Geometry/DualWitnessFrame")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Szyb wentylacyjny opada w głąb ziemi. Powietrze staje się gęste od ciśnienia powrotnego instalacji podziemnych.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Powietrze robi się gęste od ciśnienia powrotnego. Jesteśmy dokładnie pod fundamentami osiedla.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Manometr wskazuje minus czterdzieści metrów pod powierzchnią. Sprawdźmy skrzynkę kablową.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "W skrzynce kablowej Lena znajduje odręczną notatkę miejscowej Leny: »DWIE STRONY / DWA ODCZYTY / BRAK ODPOWIEDZI = PRZERWIJ / ABORT PO 3 S«.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Słyszysz te rytmiczne uderzenia z dołu? Ona wiedziała, że most korelacyjny zagraża obu wersjom.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "To Rdzeń Wymiany Maszynowni Głównej. Bilansuje wektory sprzeczności całej sieci.",
		"is_jakub": true
	},
	{
		"speaker": "LENA",
		"text": "Jeśli zejdziemy na sam dół, dotrzemy do rejestru par i odzyskamy jej współrzędne.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "UCP automatycznie rygluje wyższe poziomy szybu. Nie będzie odwrotu.",
		"is_jakub": true
	},
	{
		"speaker": "LENA",
		"text": "Nie przyszłam tu, żeby wracać tą samą drogą, Jakub. Przyszłam, żeby zatrzymać ten mechanizm.",
		"is_lena": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wskaźnik ciśnienia sprzeczności osiąga wartość krytyczną. Dolny właz dekompresyjny zostaje odryglowany.",
		"is_witness": true
	},
	{
		"speaker": "JAKUB",
		"text": "Trzymaj się poręczy. Schodzimy prosto w serce maszynowni.",
		"is_jakub": true
	}
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	_setup_props()
	_setup_guidance()
	_setup_witness_frame()
	station_entered.emit()
	if dialogue_active:
		_show_dialogue_line(dialogue_index)


func _setup_props() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_resonance_triggered):
				pt.resonance_triggered.connect(_on_resonance_triggered)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	var beat_start := GuidanceBeat.new()
	beat_start.beat_id = &"s33_abort_condition"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Notatka miejscowej Leny: warunek przerwania po trzech sekundach."
	beat_start.text_en = "Local Lena's note: abort condition after three seconds."
	guidance_service.register_beat(beat_start)


func _setup_witness_frame() -> void:
	if witness_frame == null:
		return
	if not witness_frame.anchor_state_changed.is_connected(_on_witness_frame_anchor_changed):
		witness_frame.anchor_state_changed.connect(_on_witness_frame_anchor_changed)
	witness_frame.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("has_recorded_decision"):
		witness_frame_detail_faded = state.has_recorded_decision(&"station_33_dual_witness_corrected")
	elif state:
		var decisions: Variant = state.get("decisions")
		if decisions is Dictionary:
			witness_frame_detail_faded = (decisions as Dictionary).has(&"station_33_dual_witness_corrected")


func _on_witness_frame_anchor_changed(anchored: bool) -> void:
	is_witness_frame_anchored = anchored
	queue_redraw()


func run_witness_frame_correction_pass() -> void:
	if witness_frame == null:
		return
	last_witness_frame_correction_target = (
		AnchorableObject.RealityState.STATE_B
		if witness_frame.current_reality == AnchorableObject.RealityState.STATE_A
		else AnchorableObject.RealityState.STATE_A
	)
	witness_frame.apply_reality_shift(last_witness_frame_correction_target, false)
	if witness_frame.current_reality == last_witness_frame_correction_target and not witness_frame.is_anchored:
		_apply_witness_frame_correction()
	queue_redraw()


func _apply_witness_frame_correction() -> void:
	witness_frame_correction_count += 1
	witness_frame_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("record_decision"):
		state.record_decision(&"station_33_dual_witness_corrected", witness_frame_correction_count)
	if player:
		if player.has_method("reset_to"):
			player.reset_to(CHECKPOINT_POSITION)
		else:
			player.global_position = CHECKPOINT_POSITION
	queue_redraw()


func _process(delta: float) -> void:
	_pulse_phase += delta
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 2.0)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if dialogue_active:
			advance_dialogue()


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	dialogue_index += 1
	if dialogue_index < dialogue_lines.size():
		_apply_dialogue_state(dialogue_index)
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
		queue_redraw()
		return dialogue_index
	else:
		dialogue_active = false
		is_dialogue_completed = true
		_unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
		var state := get_node_or_null("/root/GameStateManager")
		if state:
			state.record_decision(&"s33_abort_condition_found", true)
		dialogue_completed.emit()
		queue_redraw()
		return -1


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "ŚWIADECTWO"), line.get("text", ""))


func _apply_dialogue_state(idx: int) -> void:
	match idx:
		1:
			inspect_gauge()
		2:
			inspect_ladder()
		3:
			inspect_cable_trunk()
		7:
			inspect_work_light()
		9:
			_unlock_exit()


func inspect_ladder() -> void:
	if is_ladder_inspected:
		return
	is_ladder_inspected = true
	_activate_prop_by_id("prop_ladder")
	ladder_inspected.emit()
	interaction_triggered.emit("prop_ladder")
	_check_unlock()


func inspect_gauge() -> void:
	if is_gauge_inspected:
		return
	is_gauge_inspected = true
	_activate_prop_by_id("prop_depth_gauge")
	gauge_inspected.emit()
	interaction_triggered.emit("prop_depth_gauge")
	_check_unlock()


func inspect_cable_trunk() -> void:
	if is_cable_trunk_inspected:
		return
	is_cable_trunk_inspected = true
	_activate_prop_by_id("prop_cable_trunk")
	cable_trunk_inspected.emit()
	interaction_triggered.emit("prop_cable_trunk")
	_check_unlock()


func inspect_work_light() -> void:
	if is_work_light_inspected:
		return
	is_work_light_inspected = true
	_activate_prop_by_id("prop_work_light")
	work_light_inspected.emit()
	interaction_triggered.emit("prop_work_light")
	_check_unlock()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_33_exit")
	queue_redraw()


func _check_unlock() -> void:
	if is_ladder_inspected and is_gauge_inspected and is_cable_trunk_inspected and is_work_light_inspected and not is_exit_unlocked:
		_unlock_exit()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_ladder":
			inspect_ladder()
		"prop_depth_gauge":
			inspect_gauge()
		"prop_cable_trunk":
			inspect_cable_trunk()
		"prop_work_light":
			inspect_work_light()
		"prop_station_33_exit":
			if is_exit_unlocked:
				_trigger_level_completion()
	clue_inspected.emit(id, prop_type)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body == player or (body and body.name == "Player"):
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)

	# Vertical ladder rails
	draw_line(Vector2(120.0, 40.0), Vector2(120.0, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	draw_line(Vector2(140.0, 40.0), Vector2(140.0, 280.0), COLOR_INFRASTRUCTURE, 2.0)
	for y in range(40, 280, 20):
		draw_line(Vector2(120.0, float(y)), Vector2(140.0, float(y)), COLOR_PANEL_BASE, 1.5)

	# Depth pressure gauge dial
	var gauge_col := COLOR_AMBER if is_gauge_inspected else COLOR_INFRASTRUCTURE
	draw_circle(Vector2(235.0, 245.0), 14.0, COLOR_PANEL_BASE)
	draw_circle(Vector2(235.0, 245.0), 14.0, gauge_col)

	# Cable trunk box with note
	var cable_col := COLOR_CYAN if is_cable_trunk_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(330.0, 210.0), Vector2(30.0, 50.0)), COLOR_PANEL_CORE, true)
	draw_line(Vector2(335.0, 230.0), Vector2(355.0, 230.0), cable_col, 2.0)

	# Work light cone
	if is_work_light_inspected:
		draw_circle(Vector2(455.0, 200.0), 8.0, COLOR_AMBER_WARM)

	# Exit hatch frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)
