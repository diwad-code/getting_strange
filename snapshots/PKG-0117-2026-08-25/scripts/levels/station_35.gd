class_name Station35
extends Node2D

## Space 35: Sektor Filtracji / Baseny Sedacyjne (Act III: Podstruktura)
## Subterranean filtration sector and cognitive sludge sedimentation pools
## Narrative & Mechanical Beat: Scene 35 / D-14 from DIALOGUE_SCRIPT.md & FULL_STORY.md

## PRZESZKODA — dlaczego to tu jest: Baseny sedacyjne zbierają osad poznawczy,
## ponieważ infrastruktura UCP odprowadza koszty korekty z miejskiej sieci.
## PRZESZKODA — czego wymaga od Leny: Odczytania basenu, zaworu i stężenia
## sedacji jako świadectwa działania systemu, nie pokonania toru przeszkód.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; scena zachowuje ciszę,
## aby odpływ i jego konsekwencje pozostały pracą świata.

signal level_completed
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)

@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

# Narrative progress tracking flags
var is_pool_inspected: bool = false
var is_valve_inspected: bool = false
var is_chemical_inspected: bool = false
var is_monitor_inspected: bool = false

# Internal visuals
var _bg_color: Color = Color("060b0e")
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
		"text": "Sektor Filtracji to olbrzymia podziemna hala wypełniona betonowymi basenami. W mętnej, fosforyzującej cieczy unoszą się nieostre smugi — odrzucone warianty pamięci."
	},
	{
		"speaker": "LENA",
		"text": "Ta woda... ona świeci tym samym odcieniem, co skażenie studni na rysunku Szymona Bery."
	},
	{
		"speaker": "JAKUB",
		"text": "To nie jest zwykła woda, Lena. To roztwór sedacyjny nasycony osadem poznawczym. Wszystko, co UCP wymazało z pamięci miasta, spływa tutaj i ulega powolnemu rozkładowi."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Na dnie basenu widoczne są kontury przedmiotów: tablica z numerem tramwaju 4, dziecięcy but, teczka z aktami wypadku z 1988 roku."
	},
	{
		"speaker": "LENA",
		"text": "Szymon mówił prawdę o skażeniu. UCP dodawało sedację do miejskiej sieci wodociągowej, żeby stłumić powracające wspomnienia o wypadku."
	},
	{
		"speaker": "JAKUB",
		"text": "Uznano, że masowy spokój jest cenniejszy niż prawda o jedenastu ofiarach. Wierzbicka nazywała to »higieną emocjonalną populacji«."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Próbnik chemiczny Jakuba wskazuje stężenie sedacji trzykrotnie przekraczające normę krytyczną. Filtry są zapchane i grożą przelaniem."
	},
	{
		"speaker": "LENA",
		"text": "Jeśli otworzymy zawór spustowy, osad spłynie do kanałów burzowych i cała prawda wyjdzie na powierzchnię."
	},
	{
		"speaker": "JAKUB",
		"text": "Odpływ prowadzi przez Zimny Ściek prosto do fundamentów Starej Pętli. Jeśli tam wejdziemy, nie będzie już żadnego znieczulenia."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Koło zaworu spustowego obraca się z głuchym trzaskiem. Zasuwa śluzy odpływowej unosi się, otwierając drogę do Kanału Odpływowego."
	},
	{
		"speaker": "LENA",
		"text": "Nie potrzebujemy znieczulenia, Jakub. Idziemy do Zimnego Ścieku."
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


func _connect_prop_signals() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	interaction_triggered.emit(id)
	
	if id in ["sedation_basin_pool", "prop_sedation_basin"] or prop_type == 162:
		is_pool_inspected = true
		if dialogue_index == 0:
			advance_dialogue()
	elif id in ["sludge_drain_valve_wheel", "prop_sludge_valve"] or prop_type == 163:
		is_valve_inspected = true
		if dialogue_index in [3, 4, 7]:
			advance_dialogue()
	elif id in ["chemical_sedation_sampler", "prop_chemical_sampler"] or prop_type == 164:
		is_chemical_inspected = true
		if dialogue_index in [1, 2, 5, 6]:
			advance_dialogue()
	elif id in ["jakub_sedation_monitor", "prop_jakub_monitor"] or prop_type == 165:
		is_monitor_inspected = true
		if dialogue_index in [6, 7, 8]:
			advance_dialogue()
	elif id in ["station_35_exit", "prop_sluice_exit"] or prop_type == 166:
		if is_exit_unlocked:
			_complete_level()


func advance_dialogue() -> void:
	if not dialogue_active:
		return
	
	if dialogue_index < DIALOGUE_LINES.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		
		# Line 9 triggers the sludge valve release and unlocks the exit sluice gate
		if dialogue_index >= 9:
			unlock_exit()
	else:
		is_dialogue_completed = true
		unlock_exit()


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	
	if props:
		var exit_prop := props.get_node_or_null("Station35Exit") as MemoryResonancePoint
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
	if dialogue_active:
		_draw_dialogue_hud()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var basin_color := VectorStageStyle.CORRECTION_OXIDE if is_chemical_inspected else VectorStageStyle.DEEP_PLANE
	var route_color := VectorStageStyle.HUMAN_AMBER if is_exit_unlocked else VectorStageStyle.LIGHT_PLANE
	draw_colored_polygon(PackedVector2Array([Vector2(48, 222), Vector2(264, 216), Vector2(270, 274), Vector2(42, 278)]), basin_color)
	draw_colored_polygon(PackedVector2Array([Vector2(332, 218), Vector2(536, 214), Vector2(544, 274), Vector2(326, 278)]), VectorStageStyle.DEEP_PLANE)
	draw_line(Vector2(278.0, 186.0), Vector2(364.0, 182.0), VectorStageStyle.CORRECTION_OXIDE if is_pool_inspected else VectorStageStyle.MID_PLANE, 2.0)
	draw_line(Vector2(84.0, 212.0), Vector2(246.0, 208.0), route_color, 1.5)
	if is_valve_inspected:
		draw_line(Vector2(228.0, 176.0), Vector2(260.0, 204.0), VectorStageStyle.ANCHOR_CYAN, 1.5)
	if is_exit_unlocked:
		draw_line(Vector2(520.0, 222.0), Vector2(606.0, 222.0), VectorStageStyle.HUMAN_AMBER, 2.0)


func _draw_legacy() -> void:
	# Deep filtration background
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), _bg_color)
	
	# Overhead concrete filtration ceiling arches & overhead pipes
	var arch_color := Color("0d171c")
	var line_color := Color("172a30")
	var pipe_color := Color("20333d")
	
	for col in range(6):
		var cx: float = float(col) * 115.0 + 35.0
		# Concrete pillars with sediment water-level lines
		draw_rect(Rect2(cx - 8.0, 35.0, 16.0, 225.0), arch_color)
		draw_line(Vector2(cx - 8.0, 35.0), Vector2(cx - 8.0, 260.0), line_color, 1.2)
		draw_line(Vector2(cx + 8.0, 35.0), Vector2(cx + 8.0, 260.0), line_color, 1.2)
		# Horizontal water stain rings on pillars
		for st in range(4):
			var sy: float = 140.0 + float(st) * 25.0
			draw_line(Vector2(cx - 8.0, sy), Vector2(cx + 8.0, sy), Color("2d4f59", 0.6), 1.0)
	
	# Overhead slurry pipes and drainage ducts
	draw_rect(Rect2(0.0, 42.0, 640.0, 12.0), pipe_color)
	draw_line(Vector2(0.0, 42.0), Vector2(640.0, 42.0), line_color, 1.4)
	draw_line(Vector2(0.0, 54.0), Vector2(640.0, 54.0), line_color, 1.4)
	
	# Secondary pipe with flange joints
	draw_rect(Rect2(0.0, 62.0, 640.0, 6.0), Color("142229"))
	for fj in range(8):
		var fx: float = float(fj) * 85.0 + 20.0
		draw_rect(Rect2(fx, 60.0, 6.0, 10.0), Color("2b424d"))
	
	# Platform cat-walk metal grating floor
	var floor_rect := Rect2(0.0, 260.0, 640.0, 100.0)
	draw_rect(floor_rect, Color("0a1217"))
	draw_line(Vector2(0.0, 260.0), Vector2(640.0, 260.0), Color("344d5c"), 2.0)
	
	# Grate pattern and drainage troughs below cat-walk
	for g in range(32):
		var gx: float = float(g) * 20.0
		draw_line(Vector2(gx, 260.0), Vector2(gx, 275.0), Color("1a2a33"), 1.0)
		draw_line(Vector2(gx, 275.0), Vector2(gx + 10.0, 275.0), Color("142028"), 1.0)
	
	# Basin sludge trenches beneath the floor (visible greenish glow through grates)
	var trench_pulse: float = 0.5 + 0.5 * sin(_pulse_phase * 1.8)
	draw_rect(Rect2(80.0, 280.0, 240.0, 50.0), Color(0.07, 0.18, 0.20, 0.7 + trench_pulse * 0.2))
	
	# Top Level Banner
	var banner_rect := Rect2(120.0, 14.0, 400.0, 18.0)
	draw_rect(banner_rect, Color("081014", 0.9))
	draw_rect(banner_rect, Color("d39a62", 0.8), false, 1.2)
	
	# Render Dialogue Subtitle overlay if dialogue active
	if dialogue_active and dialogue_index < DIALOGUE_LINES.size():
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
		
		# Draw Level title on top banner
		draw_string(font, Vector2(130.0, 27.0), "SEKTOR FILTRACJI // BASENY SEDACYJNE // POZIOM -40 M", HORIZONTAL_ALIGNMENT_CENTER, 380.0, 9, Color("e2b060"))
