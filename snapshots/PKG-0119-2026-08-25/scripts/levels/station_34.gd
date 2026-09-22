class_name Station34
extends Node2D

## Space 34: Maszynownia Główna / Rdzeń Wymiany (Act III: Podstruktura)
## Central core engine room of the Substructure where biographies and contradiction vectors are processed
## Narrative & Mechanical Beat: Scene 34 from DIALOGUE_SCRIPT.md & FULL_STORY.md

## PRZESZKODA — dlaczego to tu jest: Rdzeń wymiany przetwarza osad sprzeczności,
## ponieważ UCP utrzymuje infrastrukturę kosztem nieobserwowanych biografii.
## PRZESZKODA — czego wymaga od Leny: Rekonstrukcji własnej nocy identyfikacji
## i rozpoznania śladów wcześniejszej korekty bez uciekania w abstrakcyjny test.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; cisza chroni osobisty
## ciężar sceny i nie zamienia pamięci kostnicy w tor zręcznościowy.

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_reactor_inspected: bool = false
var is_desk_inspected: bool = false
var is_thermal_inspected: bool = false
var is_probe_inspected: bool = false

# Internal visuals
var _bg_color: Color = Color("070a0e")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Maszynownia Główna dudni niskim, wibrującym tonem. W centrum sali obraca się potężny Rdzeń Wymiany — urządzenie, w którym pamięć miasta jest bezustannie przepisywana."
	},
	{
		"speaker": "LENA",
		"text": "To tutaj UCP decyduje, które wspomnienia zostają, a które idą na przemiał?"
	},
	{
		"speaker": "JAKUB",
		"text": "Rdzeń nie podejmuje decyzji moralnych. On tylko równoważy wektory sprzeczności. Jeśli dziesięć osób pamięta wypadek, a sto nie — konsensus wymusza wyzerowanie tej dziesiątki."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na pulpicie alokacji widoczne są nazwiska pasażerów Linii 4. Suwaki przesunięto do pozycji zerowej — status: NIEISTNIEJĄCY."
	},
	{
		"speaker": "LENA",
		"text": "Popatrz na wskaźnik termiczny. Rdzeń pracuje na granicy przegrzania. Sprzeczności narastają szybciej, niż maszyna jest w stanie je wygasić."
	},
	{
		"speaker": "JAKUB",
		"text": "Bo prawda nie znika, Lena. Ona odkłada się w filtrach sedacyjnych jako toksyczny osad poznawczy."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Próbnik diagnostyczny Jakuba rejestruje gwałtowny skok ciśnienia sprzeczności. System przygotowuje zrzut zanieczyszczeń do Sektora Filtracji."
	},
	{
		"speaker": "LENA",
		"text": "Jeśli zablokujemy suwaki alokacji, maszyna nie zdoła nadpisać kolejnych świadków."
	},
	{
		"speaker": "JAKUB",
		"text": "Zablokowanie alokacji wywoła dekompensację rdzenia. Następna komora to Sektor Filtracji — tam gromadzą się odfiltrowane wspomnienia."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Zawory dekompresyjne Rdzenia otwierają się z ogłuszającym rykiem pary. Brama filtracyjna zostaje odryglowana."
	},
	{
		"speaker": "LENA",
		"text": "Idziemy do filtrów. Pora zobaczyć, co UCP próbowało utopić w osadnikach."
	}
]

var dialogue_lines: Array[Dictionary] = DIALOGUE_LINES


func _ready() -> void:
	if player:
		player.position = Vector2(65.0, 248.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	
	_connect_prop_signals()


func _process(delta: float) -> void:
	_pulse_phase += delta * 2.8
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.6)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if dialogue_active:
			advance_dialogue()


func advance_dialogue() -> int:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		_apply_dialogue_state(dialogue_index)
		dialogue_advanced.emit(dialogue_index)
		queue_redraw()
		return dialogue_index
	else:
		dialogue_active = false
		is_dialogue_completed = true
		_unlock_exit()
		queue_redraw()
		return -1


func _apply_dialogue_state(idx: int) -> void:
	match idx:
		1:
			is_reactor_inspected = true
			_activate_prop_by_id("prop_core_reactor")
		3:
			is_desk_inspected = true
			_activate_prop_by_id("prop_allocation_desk")
		4:
			is_thermal_inspected = true
			_activate_prop_by_id("prop_thermal_gauge")
		6:
			is_probe_inspected = true
			_activate_prop_by_id("prop_jakub_probe")
		9, 10:
			_unlock_exit()


func _connect_prop_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_resonance_triggered)


func _on_resonance_triggered(id: String, _prop_type: int) -> void:
	interaction_triggered.emit(id)
	match id:
		"prop_core_reactor":
			is_reactor_inspected = true
		"prop_allocation_desk":
			is_desk_inspected = true
		"prop_thermal_gauge":
			is_thermal_inspected = true
		"prop_jakub_probe":
			is_probe_inspected = true
		"prop_station_34_exit":
			if not is_exit_unlocked and is_dialogue_completed:
				_unlock_exit()


func _unlock_exit() -> void:
	is_exit_unlocked = true
	var exit_prop := _get_prop_by_id("prop_station_34_exit")
	if exit_prop and not exit_prop.is_activated:
		exit_prop.trigger_interaction()


func _activate_prop_by_id(target_id: String) -> void:
	var prop := _get_prop_by_id(target_id)
	if prop and not prop.is_activated:
		prop.trigger_interaction()


func _get_prop_by_id(target_id: String) -> MemoryResonancePoint:
	if not props:
		return null
	for child in props.get_children():
		if child is MemoryResonancePoint and child.resonance_id == target_id:
			return child
	return null


func _on_airlock_zone_entered(body: Node2D) -> void:
	if is_exit_unlocked and body == player:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_state_layer()
	if dialogue_active:
		_draw_dialogue_hud()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var core_color := VectorStageStyle.ANCHOR_CYAN if is_probe_inspected else VectorStageStyle.LIGHT_PLANE
	var pressure_color := VectorStageStyle.CORRECTION_OXIDE if is_thermal_inspected else VectorStageStyle.MID_PLANE
	draw_colored_polygon(PackedVector2Array([Vector2(276, 92), Vector2(364, 86), Vector2(374, 224), Vector2(266, 228)]), core_color)
	draw_colored_polygon(PackedVector2Array([Vector2(304, 108), Vector2(348, 104), Vector2(354, 212), Vector2(298, 216)]), pressure_color)
	draw_line(Vector2(242.0, 76.0), Vector2(398.0, 76.0), VectorStageStyle.HUMAN_AMBER if is_exit_unlocked else VectorStageStyle.MID_PLANE, 2.0)
	if is_desk_inspected:
		draw_line(Vector2(190.0, 204.0), Vector2(254.0, 198.0), VectorStageStyle.CORRECTION_OXIDE, 1.5)
	if is_exit_unlocked:
		draw_line(Vector2(520.0, 222.0), Vector2(606.0, 222.0), VectorStageStyle.HUMAN_AMBER, 2.0)


func _draw_legacy() -> void:
	# Deep industrial reactor hall background: #070a0e
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Vaulted ceiling steel arches
	for a in range(7):
		var ax: float = 30.0 + float(a) * 95.0
		draw_line(Vector2(ax, 30.0), Vector2(ax, 268.0), Color("17222c", 0.45), 2.0)
		draw_line(Vector2(ax, 30.0), Vector2(ax + 30.0, 70.0), Color("243340", 0.35), 1.5)
	
	# Overhead heavy steam/cooling pipe manifold
	draw_line(Vector2(20.0, 48.0), Vector2(620.0, 48.0), Color("2a3b4a"), 4.0)
	draw_line(Vector2(20.0, 52.0), Vector2(620.0, 52.0), Color("18222a"), 2.0)
	draw_line(Vector2(20.0, 68.0), Vector2(620.0, 68.0), Color("344b5c"), 3.0)
	
	# Vertical pipe drops into reactor core
	draw_line(Vector2(140.0, 48.0), Vector2(140.0, 215.0), Color("2b3d4c"), 3.0)
	draw_line(Vector2(160.0, 68.0), Vector2(160.0, 215.0), Color("21303d"), 2.5)
	
	# Raised catwalk floor / steel treadplate
	var floor_rect := Rect2(20.0, 268.0, 600.0, 20.0)
	draw_rect(floor_rect, Color("131c24"))
	draw_rect(floor_rect, Color("2d4150"), false, 1.2)
	
	# Steel grating treads
	for g in range(40):
		var gx: float = 25.0 + float(g) * 15.0
		draw_line(Vector2(gx, 268.0), Vector2(gx, 288.0), Color("1c2833"), 1.0)
	
	# Lower sump / oil channel under catwalk
	draw_rect(Rect2(0.0, 288.0, 640.0, 72.0), Color("040608"))
	
	# Reactor ambient contradiction heat shimmer
	var heat_pulse := sin(_pulse_phase * 2.0) * 0.5 + 0.5
	draw_rect(Rect2(100.0, 190.0, 100.0, 78.0), Color("5da398", 0.04 + heat_pulse * 0.03))
	
	# Top signage banner "MASZYNOWNIA GŁÓWNA // SEKTOR 0-RDZEŃ"
	var banner_rect := Rect2(150.0, 24.0, 340.0, 16.0)
	draw_rect(banner_rect, Color("080c10"))
	draw_rect(banner_rect, Color("d39a62" if is_exit_unlocked else "354b59"), false, 1.0)
	
	var default_font := ThemeDB.fallback_font
	if default_font:
		draw_string(default_font, Vector2(158.0, 36.0), "MASZYNOWNIA GŁÓWNA // SEKTOR 0-RDZEŃ // KOMORA WYMIANY", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color("d39a62" if is_exit_unlocked else "8aa4b3"))
	
	# Draw dialogue HUD if active
	if dialogue_active:
		_draw_dialogue_hud()


func _draw_dialogue_hud() -> void:
	if dialogue_index < 0 or dialogue_index >= dialogue_lines.size():
		return
	
	var cur: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur.get("speaker", "")
	var text: String = cur.get("text", "")
	
	var box_rect := Rect2(60.0, 284.0, 520.0, 66.0)
	draw_rect(box_rect, Color(0.04, 0.07, 0.09, 0.94))
	
	var accent_col := Color("5da398")
	if speaker == "LENA":
		accent_col = Color("5da398")
	elif speaker == "JAKUB":
		accent_col = Color("d39a62")
	elif speaker == "ŚWIADECTWO":
		accent_col = Color("e2b060")
	
	draw_rect(box_rect, accent_col * 0.8, false, 1.5)
	draw_line(Vector2(70.0, 290.0), Vector2(170.0, 290.0), accent_col, 2.0)
	
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, accent_col)
		
		# Word wrap to 2 lines max
		var words := text.split(" ")
		var line1 := ""
		var line2 := ""
		var cur_l := ""
		var max_width := 490.0
		
		for w in words:
			var test_l := cur_l + (" " if cur_l != "" else "") + w
			if font.get_string_size(test_l, HORIZONTAL_ALIGNMENT_LEFT, -1, 10).x > max_width:
				if line1 == "":
					line1 = cur_l
					cur_l = w
				else:
					line2 = cur_l
					cur_l = w
			else:
				cur_l = test_l
		
		if line1 == "":
			line1 = cur_l
		else:
			line2 = cur_l
		
		draw_string(font, Vector2(70.0, 322.0), line1, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("e5ece9"))
		if line2 != "":
			draw_string(font, Vector2(70.0, 338.0), line2, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color("e5ece9"))
