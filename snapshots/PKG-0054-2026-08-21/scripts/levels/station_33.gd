class_name Station33
extends Node2D

## Space 33: Szyb Techniczny / Drabina do Maszynowni Głównej (Act III: Podstruktura)
## Vertical shaft connecting Podstruktura with Main Core Engine Room (-40m depth)
## Narrative & Mechanical Beat: D-13, Scene 33 from DIALOGUE_SCRIPT.md & FULL_STORY.md

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_ladder_inspected: bool = false
var is_gauge_inspected: bool = false
var is_cable_trunk_inspected: bool = false
var is_work_light_inspected: bool = false

# Internal visuals
var _bg_color: Color = Color("070a0e")
var _pulse_phase: float = 0.0
var _exit_open_progress: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: Camera2D = get_node_or_null("Camera2D")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")

const DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Pionowy szyb serwisowy opada stromo w głąb ziemi. Z każdym pokonanym szczeblem szum ulicy cichnie, ustępując miejsca głuchym uderzeniom tłoków."
	},
	{
		"speaker": "LENA",
		"text": "Powietrze robi się gęste i pachnie nagrzanym olejem transformatorowym. Ile metrów dzieli nas od powierzchni?"
	},
	{
		"speaker": "JAKUB",
		"text": "Manometr wskazuje minus czterdzieści metrów. Jesteśmy poniżej fundamentów całego Osiedla Tarasowego."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wzdłuż ścian szybu biegną grube wiązki kabli transmisyjnych. Każdy impuls światła to tysiące wymazanych danych o pasażerach."
	},
	{
		"speaker": "LENA",
		"text": "Słyszysz te rytmiczne uderzenia z dołu? To brzmi jak potężne metalowe serce."
	},
	{
		"speaker": "JAKUB",
		"text": "To Rdzeń Wymiany Maszynowni Głównej. Tam UCP przetwarza sprzeczności i przypisuje nowe trajektorie biograficzne."
	},
	{
		"speaker": "LENA",
		"text": "Jeśli zejdziemy na sam dół, odetniemy sobie możliwość powrotu tą samą drogą."
	},
	{
		"speaker": "JAKUB",
		"text": "UCP automatycznie rygluje wyższe poziomy szybu przy wykryciu dekompensacji. Gdy otworzymy dolny właz, droga powrotna przestanie istnieć."
	},
	{
		"speaker": "LENA",
		"text": "Nie przyszłam tu, żeby wracać tą samą drogą, Jakub. Przyszłam, żeby zatrzymać ten mechanizm."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Wskaźnik ciśnienia sprzeczności osiąga wartość krytyczną. Dolny właz dekompresyjny Maszynowni zostaje odryglowany."
	},
	{
		"speaker": "JAKUB",
		"text": "Trzymaj się poręczy. Schodzimy prosto w serce Maszynowni Głównej."
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
	_pulse_phase += delta * 2.5
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.8)
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
			is_ladder_inspected = true
			_activate_prop_by_id("prop_ladder_array")
		2:
			is_gauge_inspected = true
			_activate_prop_by_id("prop_depth_gauge")
		3:
			is_cable_trunk_inspected = true
			_activate_prop_by_id("prop_cable_trunk")
		4:
			is_work_light_inspected = true
			_activate_prop_by_id("prop_work_light")
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
		"prop_ladder_array":
			is_ladder_inspected = true
		"prop_depth_gauge":
			is_gauge_inspected = true
		"prop_cable_trunk":
			is_cable_trunk_inspected = true
		"prop_work_light":
			is_work_light_inspected = true
		"prop_station_33_exit":
			if not is_exit_unlocked and is_dialogue_completed:
				_unlock_exit()


func _unlock_exit() -> void:
	is_exit_unlocked = true
	var exit_prop := _get_prop_by_id("prop_station_33_exit")
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
	# Technical shaft background: deep blue-black abyss with steel casing rings
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Vertical shaft depth gradient and ribbing
	for r in range(12):
		var rx: float = 30.0 + float(r) * 50.0
		draw_line(Vector2(rx, 40.0), Vector2(rx, 268.0), Color("172028", 0.35), 1.0)
	
	# Horizontal shaft casing rings
	for c in range(6):
		var cy: float = 50.0 + float(c) * 40.0
		draw_line(Vector2(20.0, cy), Vector2(620.0, cy), Color("2f4452", 0.4), 1.5)
		draw_line(Vector2(20.0, cy + 2.0), Vector2(620.0, cy + 2.0), Color("0e141a", 0.8), 1.0)
	
	# Heavy vertical conduit bundles spanning the shaft
	draw_line(Vector2(80.0, 40.0), Vector2(80.0, 268.0), Color("24333d"), 3.0)
	draw_line(Vector2(90.0, 40.0), Vector2(90.0, 268.0), Color("1e2a33"), 2.0)
	draw_line(Vector2(510.0, 40.0), Vector2(510.0, 268.0), Color("24333d"), 3.0)
	
	# Service catwalk / grating floor platform
	var floor_rect := Rect2(20.0, 268.0, 600.0, 20.0)
	draw_rect(floor_rect, Color("141c22"))
	draw_rect(floor_rect, Color("2e414e"), false, 1.2)
	
	# Grating mesh lines
	for g in range(40):
		var gx: float = 25.0 + float(g) * 15.0
		draw_line(Vector2(gx, 268.0), Vector2(gx, 288.0), Color("1c2830"), 1.0)
	
	# Lower abyss void below catwalk
	draw_rect(Rect2(0.0, 288.0, 640.0, 72.0), Color("05070a"))
	
	# Depth and pressure signage on top beam
	var banner_rect := Rect2(180.0, 32.0, 280.0, 16.0)
	draw_rect(banner_rect, Color("0a0f14"))
	draw_rect(banner_rect, Color("d39a62" if is_exit_unlocked else "354b59"), false, 1.0)
	
	var default_font := ThemeDB.fallback_font
	if default_font:
		draw_string(default_font, Vector2(192.0, 44.0), "SZYB S-4 // POZIOM -40 M // MASZYNOWNIA GŁÓWNA", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, Color("d39a62" if is_exit_unlocked else "8aa4b3"))
	
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
