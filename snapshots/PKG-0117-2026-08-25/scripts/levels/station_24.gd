class_name Station24
extends Node2D

## Station 24 (Przestrzeń 24: Marta pod obserwacją / Monitoring mieszkania 14, transmisja Wierzbickiej, narastająca korekta i wybór Leny) for Getting Strange Vertical Slice.
## Features UCP Signal Monitoring & Analysis Chamber in Compliance Point 6.
## Implements Dialogue and disposition choice per FULL_STORY.md (Scene 24) & DIALOGUE_SCRIPT.md:
## Lena watches CCTV feed of Marta packing her toolbag in apartment 14 as correction accumulates around her,
## interacts with Dr Helena Wierzbicka's transmission offering protection in exchange for pattern registration,
## makes her disposition choice (0: Explicit Consent, 1: Apparent Cooperation, 2: Explicit Refusal),
## and unlocks the transit airlock towards Space 25 (Wejście Jakuba).
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 24).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("0f161a")
const COLOR_WALL_SLATE := Color("18242a")
const COLOR_WALL_DARK := Color("121b20")
const COLOR_INFRASTRUCTURE := Color("a8b2ac")
const COLOR_DARK_STEEL := Color("162228")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_AMBER_GLOW := Color(0.886, 0.690, 0.376, 0.22)
const COLOR_CRT_CYAN := Color("4f8f8b")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("d96b52")
const COLOR_CORRECTION_DEEP := Color("c65d58")

enum DispositionChoice {
	EXPLICIT_CONSENT = 0,
	APPARENT_COOPERATION = 1,
	EXPLICIT_REFUSAL = 2,
}

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal cctv_array_inspected()
signal gauge_inspected()
signal transmission_terminal_inspected()
signal disposition_selected(choice_idx: int)
signal marta_stress_escalated()
signal exit_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var is_cctv_inspected: bool = false
var is_gauge_inspected: bool = false
var is_terminal_inspected: bool = false
var is_disposition_made: bool = false
var is_stress_escalated: bool = false
var is_exit_unlocked: bool = false
var is_level_completed: bool = false

var selected_disposition: DispositionChoice = DispositionChoice.APPARENT_COOPERATION
var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _pulse_time: float = 0.0
var _exit_open_progress: float = 0.0
var _marta_stress_ratio: float = 0.84

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ściana kineskopów CCTV pokazuje mieszkanie 14: Marta pakuje torbę narzędziową. W tle drżą kontury mebli.",
		"is_witness": true,
		"is_lena": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Marta Kurek nie przyjmuje wersji o pani zniknięciu. Każda godzina jej oporu ściąga korektę na całe piętro.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Nie zrobicie jej tego.",
		"is_witness": false,
		"is_lena": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "My nie robimy niczego z zemsty. To czysta kumulacja sprzeczności. Jeśli pani nie ustabilizuje wzorca, mieszkanie zniknie z rejestru przed świtem.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wskaźnik naprężeń korelacyjnych bije w czerwone pole. Wierzbicka otwiera pulpit wyboru dyspozycji.",
		"is_witness": true,
		"is_lena": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Oferuję ochronę Marty. W zamian za zgodę na pełną rejestrację pani współrzędnych.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Podpiszę formularz. Ale sprawdzę każdy odczyt.",
		"is_witness": false,
		"is_lena": true,
		"is_wierzbicka": false,
		"is_stage_direction": false
	},
	{
		"speaker": "DR WIERZBICKA",
		"text": "Wybór został odnotowany w magistrali. Śluza do tranzytu Linii 4 stoi otwarta.",
		"is_witness": false,
		"is_lena": false,
		"is_wierzbicka": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Syrena naprężeń cichnie. Śluza ku Przestrzeni 25 odryglowuje się z sykiem pneumatyki.",
		"is_witness": true,
		"is_lena": false,
		"is_wierzbicka": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	_setup_station()
	_connect_signals()
	station_entered.emit()


func _process(delta: float) -> void:
	_pulse_time += delta
	if is_stress_escalated:
		_marta_stress_ratio = lerpf(_marta_stress_ratio, 0.98, delta * 2.0)
	elif is_disposition_made:
		_marta_stress_ratio = lerpf(_marta_stress_ratio, 0.35, delta * 2.5)
		
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
	queue_redraw()


func _setup_station() -> void:
	if camera:
		camera.setup_chambers([Rect2(Vector2.ZERO, VIEW_SIZE)])
		camera.set_chamber(0, false)
	if player:
		player.reset_to(Vector2(50.0, 240.0))


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_resonance_triggered)
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _on_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	match type_idx:
		MemoryResonancePoint.PropType.CCTV_SURVEILLANCE_ARRAY:
			is_cctv_inspected = true
			cctv_array_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.CORRECTION_ACCUMULATION_GAUGE:
			is_gauge_inspected = true
			gauge_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.WIERZBICKA_TRANSMISSION_TERMINAL:
			is_terminal_inspected = true
			transmission_terminal_inspected.emit()
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.LENA_DISPOSITION_SELECTOR:
			set_disposition(selected_disposition)
			if not is_dialogue_completed and not dialogue_active:
				start_dialogue()
		MemoryResonancePoint.PropType.STATION_24_EXIT:
			if is_exit_unlocked:
				_on_airlock_entered(player)


func set_disposition(choice: DispositionChoice) -> void:
	selected_disposition = choice
	is_disposition_made = true
	
	# Update Line 6 text according to choice
	match selected_disposition:
		DispositionChoice.EXPLICIT_CONSENT:
			dialogue_lines[6]["text"] = "Zgadzam się. Chrońcie Martę."
		DispositionChoice.APPARENT_COOPERATION:
			dialogue_lines[6]["text"] = "Podpiszę formularz. Ale sprawdzę każdy odczyt."
		DispositionChoice.EXPLICIT_REFUSAL:
			dialogue_lines[6]["text"] = "Nie kupię jej bezpieczeństwa waszym kłamstwem."
	
	disposition_selected.emit(int(selected_disposition))


func start_dialogue() -> void:
	if dialogue_active:
		return
	dialogue_active = true
	dialogue_index = 0
	dialogue_started.emit()
	dialogue_advanced.emit(0)


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		_finish_scene()
		return -1
	
	if dialogue_index == 4:
		# Line 4: Stress escalation
		is_stress_escalated = true
		marta_stress_escalated.emit()
	elif dialogue_index == 6:
		# Line 6: Disposition confirmed
		is_disposition_made = true
		disposition_selected.emit(int(selected_disposition))
	elif dialogue_index == 7:
		# Line 7: Exit unlocks
		_unlock_exit()
	
	dialogue_advanced.emit(dialogue_index)
	return dialogue_index


func _finish_scene() -> void:
	is_cctv_inspected = true
	is_gauge_inspected = true
	is_terminal_inspected = true
	is_disposition_made = true
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	if props:
		var exit_prop := props.get_node_or_null("Station24Exit") as MemoryResonancePoint
		if exit_prop:
			exit_prop.is_activated = true
		var selector_prop := props.get_node_or_null("DispositionSelector") as MemoryResonancePoint
		if selector_prop:
			selector_prop.is_activated = true
		var terminal_prop := props.get_node_or_null("TransmissionTerminal") as MemoryResonancePoint
		if terminal_prop:
			terminal_prop.is_activated = true
		var gauge_prop := props.get_node_or_null("CorrectionGauge") as MemoryResonancePoint
		if gauge_prop:
			gauge_prop.is_activated = true
		var cctv_prop := props.get_node_or_null("CCTVArray") as MemoryResonancePoint
		if cctv_prop:
			cctv_prop.is_activated = true


func _on_airlock_entered(body: Node2D) -> void:
	if not is_exit_unlocked:
		return
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# Vector-Stage state pass. The frame itself belongs to VectorStageEnvironment
	# (station_number = 24); this pass only moves the plane relations that carry state.
	_draw_state_layer()

	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_hud(dialogue_lines[dialogue_index])


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	# Telemetry bus over the console bank: one practical line, source-motivated.
	var pulse := sin(_pulse_time * 2.4) * 0.5 + 0.5
	draw_line(
		Vector2(28.0, 72.0),
		Vector2(512.0, 66.0),
		Color(VectorStageStyle.ANCHOR_CYAN, 0.24 + pulse * 0.22),
		1.5
	)
	# Correction accumulating around Marta: the oxide column grows with the stress ratio.
	var stress := clampf(_marta_stress_ratio, 0.0, 1.0)
	var column_top := 256.0 - 128.0 * stress
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(538.0, column_top),
			Vector2(560.0, column_top - 2.0),
			Vector2(560.0, 256.0),
			Vector2(536.0, 258.0),
		]),
		VectorStageStyle.CORRECTION_OXIDE,
		1.0
	)
	# Marta observed: her amber plane keeps a hard edge while the room reads her.
	if is_cctv_inspected:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([Vector2(158.0, 100.0), Vector2(206.0, 97.0), Vector2(210.0, 166.0), Vector2(160.0, 168.0)]),
			VectorStageStyle.light(VectorStageStyle.HUMAN_AMBER, 0.14),
			1.0
		)
	# Disposition recorded: the empty operator floor gains the one plane it was missing.
	if is_disposition_made:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([Vector2(232.0, 226.0), Vector2(340.0, 218.0), Vector2(348.0, 266.0), Vector2(226.0, 270.0)]),
			VectorStageStyle.MID_PLANE,
			1.0
		)
	if _exit_open_progress > 0.0:
		var opening := 4.0 + _exit_open_progress * 22.0
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(596.0 - opening, 180.0),
				Vector2(596.0 + opening, 180.0),
				Vector2(596.0 + opening, 268.0),
				Vector2(596.0 - opening, 268.0),
			]),
			VectorStageStyle.LIGHT_PLANE,
			1.0
		)


func _draw_dialogue_hud(line: Dictionary) -> void:
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_wierzbicka: bool = line.get("is_wierzbicka", false)
	
	var box_rect := Rect2(60.0, 285.0, 520.0, 60.0)
	draw_rect(box_rect, Color(0.05, 0.08, 0.10, 0.94))
	
	var border_color := COLOR_AMBER if is_lena else (COLOR_CYAN if is_wierzbicka else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_color * 0.75, false, 1.0)
	
	# Speaker header bar
	var bar_color := COLOR_AMBER if is_lena else (COLOR_CYAN if is_wierzbicka else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
	draw_rect(Rect2(64.0, 288.0, 140.0, 3.0), bar_color)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, bar_color)
		draw_string(font, Vector2(70.0, 324.0), text, HORIZONTAL_ALIGNMENT_LEFT, 500, 10, Color("dcebe4"))
