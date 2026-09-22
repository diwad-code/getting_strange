class_name Station31
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Magazyn dowodów przechowuje ewidencję i depozyt przedmiotów z wypadku na Linii 4, odciętych od oficjalnych rejestrów miasta.
## PRZESZKODA — czego wymaga od Leny: Zbadania ewidencji pasażerów, odrzucenia oferty adaptacji UCP i zachowania domowego nośnika przed przejściem dalej.
## PRZESZKODA — koszt porażki: Próba przyjęcia skrótu adaptacji zaciera domowy indeks próbki, wymagając cofnięcia i ponownego ugruntowania tożsamości.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("090d11")
const COLOR_PANEL_BASE := Color("141c22")
const COLOR_PANEL_CORE := Color("1c2630")
const COLOR_INFRASTRUCTURE := Color("3d5866")
const COLOR_AMBER := Color("d39a62")
const COLOR_AMBER_WARM := Color("e2b060")
const COLOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION := Color("c65d58")

signal level_completed
signal previous_level_requested
signal clue_inspected(id: String, prop_type: int)
signal station_entered
signal chairs_inspected
signal holoterminal_inspected
signal twelfth_chair_inspected
signal ledger_inspected
signal exit_unlocked
signal dialogue_started
signal dialogue_advanced(line_idx: int)
signal dialogue_completed

const LEVEL_ID := "station_31"
const LEVEL_NAME := "Przestrzeń 31: Magazyn Dowodów"
const SCENE_SUBTITLE := "Oferta adaptacji / Dwieście krzeseł i ewidencja Linii 4"

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

var is_chairs_inspected: bool = false
var is_holoterminal_inspected: bool = false
var is_twelfth_chair_inspected: bool = false
var is_ledger_inspected: bool = false
var is_exit_unlocked: bool = false
var is_dialogue_completed: bool = false
var is_level_completed: bool = false

var dialogue_index: int = 0
var dialogue_active: bool = true
var _exit_open_progress: float = 0.0

var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Magazyn dowodów pod Podstrukturą. Rząd drewnianych krzeseł tramwajowych przechowuje przedmioty pasażerów odciętych od oficjalnych kronik.",
		"is_witness": true
	},
	{
		"speaker": "LENA",
		"text": "Płaszcz kolejowy z biletami w kieszeni... skórzana teczka z nutami... dziecięca rękawiczka. Wszystko z tamtego dnia na Linii 4.",
		"is_lena": true
	},
	{
		"speaker": "JAKUB",
		"text": "Oficjalny raport UCP nie odnotował żadnej ofiary, ale ich rzeczy zdeponowano w tym korytarzu.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Zimnoniebieski holoterminal na ścianie uaktywnia się. Projekcja dr Heleny Wierzbickiej patrzy na zdeponowane przedmioty.",
		"is_witness": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Zachowamy ciało, adres i relacje. Sprzeczne wspomnienia wygasną.",
		"is_wierzbicka": true
	},
	{
		"speaker": "LENA",
		"text": "Czyje relacje?",
		"is_lena": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Te, które już są stabilne. Pani Wolski jest tutaj. Marta czeka w mieszkaniu czternaście. Wystarczy odłożyć obcy czytnik.",
		"is_wierzbicka": true
	},
	{
		"speaker": "LENA",
		"text": "A dwunaste krzesło? To jest legitymacja Jakuba z mojego świata. Chce pani, żebym udawała, że tamtego wypadku nie było?",
		"is_lena": true
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Wybierałam stabilność całej sieci, nie pojedynczy los. Sprzeciw tylko wydłuża dekompensację.",
		"is_wierzbicka": true
	},
	{
		"speaker": "JAKUB",
		"text": "Nie jesteśmy pani zmiennymi, doktor Wierzbicka. Ocaliła pani infrastrukturę, a my zachowamy prawdę o obu stronach.",
		"is_jakub": true
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Śluza analityczna rozszczelnia się z metalicznym sykiem. Korytarz prowadzi w stronę stanowiska pamięci materiału.",
		"is_witness": true
	}
]


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	_setup_camera()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	_setup_props()
	_setup_guidance()
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
	beat_start.beat_id = &"s31_adaptation_refusal"
	beat_start.tier = GuidanceBeat.Tier.L1_REACTION
	beat_start.thought_kind = &"observation"
	beat_start.text_pl = "Magazyn dowodów. Ewidencja pasażerów i propozycja uciszenia sprzeczności."
	beat_start.text_en = "Evidence archive. Passenger ledger and the offer to silence contradiction."
	guidance_service.register_beat(beat_start)


func _process(delta: float) -> void:
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
			state.record_decision(&"s31_adaptation_refused", true)
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
			inspect_chairs()
		4:
			inspect_holoterminal()
		7:
			inspect_twelfth_chair()
		8:
			inspect_ledger()
		10:
			_unlock_exit()


func inspect_chairs() -> void:
	if is_chairs_inspected:
		return
	is_chairs_inspected = true
	_activate_prop_by_id("prop_eleven_chairs")
	chairs_inspected.emit()
	_check_unlock()


func inspect_holoterminal() -> void:
	if is_holoterminal_inspected:
		return
	is_holoterminal_inspected = true
	_activate_prop_by_id("prop_wierzbicka_holoterminal")
	holoterminal_inspected.emit()
	_check_unlock()


func inspect_twelfth_chair() -> void:
	if is_twelfth_chair_inspected:
		return
	is_twelfth_chair_inspected = true
	_activate_prop_by_id("prop_jakub_twelfth_chair")
	twelfth_chair_inspected.emit()
	_check_unlock()


func inspect_ledger() -> void:
	if is_ledger_inspected:
		return
	is_ledger_inspected = true
	_activate_prop_by_id("prop_variant_ledger")
	ledger_inspected.emit()
	_check_unlock()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("prop_station_31_exit")
	queue_redraw()


func _check_unlock() -> void:
	if is_chairs_inspected and is_holoterminal_inspected and is_twelfth_chair_inspected and is_ledger_inspected and not is_exit_unlocked:
		_unlock_exit()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _on_resonance_triggered(id: String, prop_type: int) -> void:
	match id:
		"prop_eleven_chairs":
			inspect_chairs()
		"prop_wierzbicka_holoterminal":
			inspect_holoterminal()
		"prop_jakub_twelfth_chair":
			inspect_twelfth_chair()
		"prop_variant_ledger":
			inspect_ledger()
		"prop_station_31_exit":
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

	# Archive vaulted masonry ceiling arches
	for a in range(8):
		var ax := float(a) * 85.0
		draw_line(Vector2(ax, 0.0), Vector2(ax + 42.0, 70.0), Color("151c22"), 6.0)
		draw_line(Vector2(ax + 42.0, 70.0), Vector2(ax + 85.0, 0.0), Color("151c22"), 6.0)

	# Shelving racks with evidence boxes
	for s in range(4):
		var sx := 50.0 + float(s) * 140.0
		draw_rect(Rect2(Vector2(sx, 90.0), Vector2(70.0, 100.0)), COLOR_PANEL_BASE, true)
		draw_rect(Rect2(Vector2(sx, 90.0), Vector2(70.0, 100.0)), COLOR_INFRASTRUCTURE, false, 1.0)
		draw_line(Vector2(sx, 125.0), Vector2(sx + 70.0, 125.0), COLOR_PANEL_CORE, 2.0)
		draw_line(Vector2(sx, 160.0), Vector2(sx + 70.0, 160.0), COLOR_PANEL_CORE, 2.0)
		draw_rect(Rect2(Vector2(sx + 8.0, 102.0), Vector2(24.0, 18.0)), COLOR_AMBER.lerp(COLOR_BACKGROUND, 0.4), true)
		draw_rect(Rect2(Vector2(sx + 38.0, 102.0), Vector2(24.0, 18.0)), COLOR_INFRASTRUCTURE, true)

	# Row of chairs
	var chair_color := COLOR_AMBER_WARM if is_chairs_inspected else COLOR_INFRASTRUCTURE
	for chair_index in range(6):
		var chair_x := 88.0 + float(chair_index) * 42.0
		draw_line(Vector2(chair_x, 238.0), Vector2(chair_x + 16.0, 238.0), chair_color, 2.0)
		draw_line(Vector2(chair_x + 2.0, 239.0), Vector2(chair_x, 268.0), chair_color, 1.0)
		draw_line(Vector2(chair_x + 14.0, 239.0), Vector2(chair_x + 16.0, 268.0), chair_color, 1.0)

	# Holoterminal
	var witness_color := COLOR_CYAN if is_holoterminal_inspected else COLOR_INFRASTRUCTURE
	draw_rect(Rect2(Vector2(224.0, 116.0), Vector2(32.0, 32.0)), witness_color.lerp(COLOR_BACKGROUND, 0.5), true)
	draw_rect(Rect2(Vector2(224.0, 116.0), Vector2(32.0, 32.0)), witness_color, false, 1.5)

	# Twelfth chair / identity depot
	if is_twelfth_chair_inspected:
		draw_rect(Rect2(Vector2(338.0, 222.0), Vector2(24.0, 36.0)), COLOR_AMBER, true)

	# Ledger table
	if is_ledger_inspected:
		draw_line(Vector2(444.0, 230.0), Vector2(492.0, 230.0), COLOR_AMBER_WARM, 2.0)

	# Exit door frame
	var exit_color := COLOR_CYAN if is_exit_unlocked else COLOR_CORRECTION
	draw_rect(Rect2(Vector2(580.0, 200.0), Vector2(40.0, 80.0)), exit_color.lerp(COLOR_BACKGROUND, 0.5), true)
	if is_exit_unlocked:
		draw_line(Vector2(580.0, 200.0), Vector2(620.0, 200.0), COLOR_CYAN, 2.0)


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
