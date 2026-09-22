class_name Station31
extends Node2D

## Station 31: Magazyn Dowodów / Jedenaście Krzeseł (Vertical Slice - Scene 31)
## Location: Underground evidence archive of discarded histories and erased citizens.
## Narrative: Lena and Jakub discover the 11 chairs with personal artefacts of erased
## passengers. Dr. Helena Wierzbicka connects remotely, reciting all 11 names from memory
## and explaining that she chose the stable timeline variant, not the individual.

## PRZESZKODA — dlaczego to tu jest: Sala przechowuje przedmioty jedenaściorga
## przesuniętych, ponieważ oficjalna historia nie potrafi utrzymać ich nazwisk.
## PRZESZKODA — czego wymaga od Leny: Obejrzenia krzeseł, wysłuchania imion i
## rozdzielenia odpowiedzialności Wierzbickiej od technicznego rachunku wariantu.
## PRZESZKODA — koszt porażki: Nie ma korekty fizycznej; scena nie dodaje próby
## ruchowej, bo jej stawką jest świadectwo, nie pokonanie geometrii.

signal level_completed

const LEVEL_ID := "station_31"
const LEVEL_NAME := "Przestrzeń 31: Magazyn Dowodów"
const SCENE_SUBTITLE := "Jedenaście Krzeseł / Archiwum Wymazanych Świadectw"

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

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

# 11 dialogue lines for Scene 31 from FULL_STORY.md & DIALOGUE_SCRIPT.md
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ciszę podziemnego magazynu przerywa widok jedenastu drewnianych krzeseł. Na każdym leży starannie ułożony przedmiot codziennego użytku."
	},
	{
		"speaker": "LENA",
		"text": "Płaszcz kolejowy z biletami w kieszeni... skórzana teczka z nutami... dziecięca rękawiczka. Kim byli ci ludzie?"
	},
	{
		"speaker": "JAKUB",
		"text": "To pasażerowie z tamtego dnia. Oficjalna kronika nie odnotowała żadnej ofiary, ale oni nigdy nie wrócili do domów."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Zimnoniebieski holoterminal na ścianie uaktywnia się. Projekcja dr Heleny Wierzbickiej patrzy prosto na zgromadzone krzesła."
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Janina Kowalczyk. Adam Sikora. Maria Zawadzka. Piotr Wójcik... Pamiętam wszystkich jedenaścioro. Bez wahania i bez pomyłki."
	},
	{
		"speaker": "LENA",
		"text": "Pamięta pani ich imiona, a mimo to zamknęła ich w tym podziemnym archiwum jako koszt operacji?"
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Pamięć o nich to mój osobisty ciężar, pani Leno. Gdybym nie wybrała tego wariantu, zginęłoby ponad dwa tysiące pasażerów w całej sieci."
	},
	{
		"speaker": "LENA",
		"text": "A dwunaste nazwisko? Dlaczego na dwunastym krześle leży legitymacja Jakuba?"
	},
	{
		"speaker": "WIERZBICKA",
		"text": "Wybierałam stabilny wariant historii, nie konkretnego człowieka. Nie wiem, dlaczego to akurat pan Wolski się utrzymał."
	},
	{
		"speaker": "JAKUB",
		"text": "Bo nie jestem pani wyborem, doktor Wierzbicka. Ocaliła pani układ linii, a my ocalimy prawdę o tych krzesłach."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Przeszklona śluza ciśnieniowa rozszczelnia się z długim sykiem powietrza. W ciemności korytarza zaczynają jarzyć się tafle szkła."
	}
]


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	
	_connect_prop_signals()


func _process(delta: float) -> void:
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if dialogue_active:
			advance_dialogue()


func advance_dialogue() -> int:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		_apply_dialogue_state(dialogue_index)
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
			is_chairs_inspected = true
			_activate_prop_by_id("prop_eleven_chairs")
		4:
			is_holoterminal_inspected = true
			_activate_prop_by_id("prop_wierzbicka_holoterminal")
		7:
			is_twelfth_chair_inspected = true
			_activate_prop_by_id("prop_jakub_twelfth_chair")
		8:
			is_ledger_inspected = true
			_activate_prop_by_id("prop_variant_ledger")
		10:
			_unlock_exit()


func _unlock_exit() -> void:
	is_exit_unlocked = true
	_activate_prop_by_id("prop_station_31_exit")


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and child.resonance_id == id:
				child.is_activated = true
				child.queue_redraw()


func _connect_prop_signals() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_resonance_triggered)


func _on_resonance_triggered(id: String, _pt: int) -> void:
	match id:
		"prop_eleven_chairs":
			is_chairs_inspected = true
		"prop_wierzbicka_holoterminal":
			is_holoterminal_inspected = true
		"prop_jakub_twelfth_chair":
			is_twelfth_chair_inspected = true
		"prop_variant_ledger":
			is_ledger_inspected = true
		"prop_station_31_exit":
			if is_exit_unlocked:
				_on_airlock_zone_body_entered(player)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body == player or (body and body.name == "Player"):
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	_draw_state_layer()
	_draw_dialogue_hud()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var chair_color := VectorStageStyle.HUMAN_AMBER if is_chairs_inspected else VectorStageStyle.LIGHT_PLANE
	for chair_index in range(6):
		var chair_x := 88.0 + float(chair_index) * 42.0
		draw_line(Vector2(chair_x, 238.0), Vector2(chair_x + 16.0, 238.0), chair_color, 2.0)
		draw_line(Vector2(chair_x + 2.0, 239.0), Vector2(chair_x, 268.0), chair_color, 1.0)
		draw_line(Vector2(chair_x + 14.0, 239.0), Vector2(chair_x + 16.0, 268.0), chair_color, 1.0)
	var witness_color := VectorStageStyle.ANCHOR_CYAN if is_holoterminal_inspected else VectorStageStyle.MID_PLANE
	draw_line(Vector2(224.0, 116.0), Vector2(256.0, 116.0), witness_color, 2.0)
	if is_twelfth_chair_inspected:
		draw_colored_polygon(PackedVector2Array([Vector2(338, 222), Vector2(362, 220), Vector2(364, 262), Vector2(340, 264)]), VectorStageStyle.HUMAN_AMBER)
	if is_ledger_inspected:
		draw_line(Vector2(444.0, 204.0), Vector2(492.0, 198.0), VectorStageStyle.CORRECTION_OXIDE, 2.0)
	if is_exit_unlocked:
		draw_line(Vector2(548.0, 222.0), Vector2(606.0, 222.0), VectorStageStyle.ANCHOR_CYAN, 2.0)


func _draw_background_environment() -> void:
	# Archive of Discarded Histories & Evidence: 640x360
	# Stone arch vaulting, specimen shelves, numbered document drawers, concrete floor
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("090d11"))
	
	# Concrete vaulted ceiling arches
	for a in range(8):
		var ax := float(a) * 90.0
		draw_line(Vector2(ax, 0.0), Vector2(ax + 45.0, 80.0), Color("151c22"), 8.0)
		draw_line(Vector2(ax + 45.0, 80.0), Vector2(ax + 90.0, 0.0), Color("151c22"), 8.0)
		draw_line(Vector2(ax + 45.0, 0.0), Vector2(ax + 45.0, 280.0), Color("1c242c"), 2.0)
	
	# Archive shelving with numbered evidence boxes in background
	for s in range(5):
		var sx := 40.0 + float(s) * 120.0
		draw_rect(Rect2(sx, 90.0, 60.0, 90.0), Color("11171d"))
		draw_rect(Rect2(sx, 90.0, 60.0, 90.0), Color("26343e"), false, 1.0)
		# Shelves
		draw_line(Vector2(sx, 120.0), Vector2(sx + 60.0, 120.0), Color("202c35"), 1.5)
		draw_line(Vector2(sx, 150.0), Vector2(sx + 60.0, 150.0), Color("202c35"), 1.5)
		# Evidence boxes
		draw_rect(Rect2(sx + 8.0, 100.0, 18.0, 14.0), Color("2f3e4a"))
		draw_rect(Rect2(sx + 34.0, 100.0, 18.0, 14.0), Color("384a58"))
		draw_rect(Rect2(sx + 8.0, 130.0, 20.0, 14.0), Color("384a58"))
		draw_rect(Rect2(sx + 34.0, 130.0, 18.0, 14.0), Color("2f3e4a"))
		draw_rect(Rect2(sx + 8.0, 160.0, 44.0, 14.0), Color("25323c"))
	
	# Vault floor
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), Color("0d1216"))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), Color("26333c"), 2.0)
	
	# Floor evidence floor markings (1..11 numbered square spots)
	for m in range(11):
		var mx := 95.0 + float(m) * 7.0
		draw_rect(Rect2(mx, 276.0, 5.0, 4.0), Color("e2b060", 0.4), false, 0.8)


func _draw_dialogue_hud() -> void:
	if not dialogue_active or dialogue_index >= dialogue_lines.size():
		return
	
	var cur_line: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = cur_line.get("speaker", "")
	var text: String = cur_line.get("text", "")
	
	# Dialogue box container (bottom 75 px)
	var box_rect := Rect2(60.0, 285.0, 520.0, 65.0)
	draw_rect(box_rect, Color(0.04, 0.07, 0.09, 0.92))
	draw_rect(box_rect, Color("d39a62", 0.85), false, 1.0)
	
	# Speaker color distinction
	var speaker_col := Color("d39a62")
	if speaker == "JAKUB":
		speaker_col = Color("5da398")
	elif speaker == "LENA":
		speaker_col = Color("e2b060")
	elif speaker == "WIERZBICKA":
		speaker_col = Color(0.4, 0.85, 0.95)
	elif speaker == "ŚWIADECTWO":
		speaker_col = Color("a8b2ac")
	
	draw_line(Vector2(70.0, 290.0), Vector2(170.0, 290.0), speaker_col, 2.0)
	
	# Speaker badge & dialogue text
	var font := ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(70.0, 304.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 11, speaker_col)
		
		# Text wrapping
		var max_width := 500.0
		var words := text.split(" ")
		var line1 := ""
		var line2 := ""
		var cur_l := ""
		
		for w in words:
			var test_l = cur_l + (" " if cur_l != "" else "") + w
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
