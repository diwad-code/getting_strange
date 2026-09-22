class_name Station32
extends Node2D

## Station 32: Ślad w szkle / Korytarz Luster (Vertical Slice - Scene 32)
## Location: Deep Substructure corridor flanked by stress-compensation glass panes.
## Narrative: Lena and Jakub inspect glass panes remembering discarded versions of reality:
## an intact calm morning, a cracked traumatic impact, and sterile UCP consensus.
## By tracing the Trace with her finger on steamed glass, Lena reveals the hidden
## access hatch to the vertical service shaft leading to the Core Engine Room.

## PRZESZKODA — dlaczego to tu jest: Tafla kompensacyjna przywraca blokującą
## konfigurację, gdy obserwowany ślad zostaje poza bezpośrednią uwagą.
## PRZESZKODA — czego wymaga od Leny: Podejścia do śladu, utrzymania wersji A
## i przejścia dopiero po zakotwiczeniu jednej konkretnej właściwości.
## PRZESZKODA — koszt porażki: Korekta zapisuje koszt, odsyła Lenę do checkpointu
## i wygasza krawędź śladu, bez śmierci i bez trwałego zamknięcia drogi.

signal level_completed

const LEVEL_ID := "station_32"
const LEVEL_NAME := "Przestrzeń 32: Ślad w szkle"
const SCENE_SUBTITLE := "Korytarz Luster / Pamięć Materiału"

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var observed_glass: AnchorableObject = get_node_or_null("Geometry/ObservedGlassTrace") as AnchorableObject

var is_steamed_pane_inspected: bool = false
var is_cracked_pane_inspected: bool = false
var is_trace_etched: bool = false
var is_polished_pane_inspected: bool = false
var is_exit_unlocked: bool = false
var is_dialogue_completed: bool = false
var is_level_completed: bool = false

var dialogue_index: int = 0
var dialogue_active: bool = true
var _exit_open_progress: float = 0.0
var is_glass_anchored: bool = false
var glass_observation_correction_count: int = 0
var glass_detail_faded: bool = false
var observation_boundary_crossed: bool = false

const CHECKPOINT_POSITION := Vector2(50.0, 240.0)

# 11 dialogue lines for Scene 32 from FULL_STORY.md & DIALOGUE_SCRIPT.md
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Długi korytarz Podstruktury przecinają pionowe tafle szkła kompensacyjnego. Każda tafla odbija inną wersję tego samego korytarza."
	},
	{
		"speaker": "LENA",
		"text": "Spójrz na tę taflę po lewej. Jest zupełnie nienaruszona, a w odbiciu widać puste torowisko o świcie, jakby nic się nie stało."
	},
	{
		"speaker": "JAKUB",
		"text": "A ta po prawej jest gęsto popękana. Szkło zapamiętało falę uderzeniową i zapach spalenizny, którego oficjalnie nie było."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Kondensacja pary wodnej osadza się na szkle w geometryczne wzory siatki naprężeń Podstruktury."
	},
	{
		"speaker": "LENA",
		"text": "Gdy dotykam zaparowanej powierzchni i przeciągam palcem, słyszę dźwięk tamtego poranka. Ślad pamięta to, co wymazano z dokumentów."
	},
	{
		"speaker": "JAKUB",
		"text": "Szkło pamięta kształt naprężenia, Lena, ale nie ma woli. Jeśli odtworzysz pęknięcie, materiał pęknie naprawdę pod naszymi stopami."
	},
	{
		"speaker": "LENA",
		"text": "Nie odtwarzam zniszczenia, Jakub. Oczyszczam taflę z fałszywego spokoju, by zobaczyć drogę naprzód."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Pod wpływem Śladu zaparowane szkło rozjaśnia się chłodnym błękitem. W poprzek korytarza ujawnia się ukryty właz techniczny."
	},
	{
		"speaker": "JAKUB",
		"text": "To wejście do pionowego szybu technicznego. Drabina prowadzi prosto do Maszynowni Głównej Podstruktury."
	},
	{
		"speaker": "LENA",
		"text": "Jesteśmy tuż pod rdzeniem. Chodźmy, zanim UCP zrekonfiguruje naprężenia w korytarzu."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Ciężki stalowy właz rewizyjny rozszczelnia się. W głąb szybu opada metalowa drabina serwisowa."
	}
]


func _ready() -> void:
	if player:
		player.position = Vector2(50.0, 240.0)
	if camera:
		camera.position = Vector2(320.0, 180.0)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	
	_setup_observed_glass()
	_connect_prop_signals()


func _process(delta: float) -> void:
	if is_exit_unlocked and _exit_open_progress < 1.0:
		_exit_open_progress = minf(1.0, _exit_open_progress + delta * 1.5)
		queue_redraw()


func _physics_process(_delta: float) -> void:
	if observed_glass and player:
		observed_glass.update_player_distance(player.global_position)
		if not observation_boundary_crossed and player.global_position.x > 430.0:
			observation_boundary_crossed = true
			run_glass_observation_check()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"trigger_correction") and not event.is_echo():
		run_glass_observation_check()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		if dialogue_active:
			advance_dialogue()
			get_viewport().set_input_as_handled()
			return
	if event.is_action_pressed(&"interact") and observed_glass and observed_glass.is_player_in_range:
		observed_glass.toggle_anchor()
		get_viewport().set_input_as_handled()


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
			is_steamed_pane_inspected = true
			_activate_prop_by_id("prop_steamed_glass_pane_a")
		2:
			is_cracked_pane_inspected = true
			_activate_prop_by_id("prop_cracked_glass_pane_b")
		4:
			is_trace_etched = true
			_activate_prop_by_id("prop_trace_etcher")
		7:
			is_polished_pane_inspected = true
			_activate_prop_by_id("prop_polished_glass_pane_c")
		10:
			_unlock_exit()


func _unlock_exit() -> void:
	is_exit_unlocked = true
	var exit_prop := _get_prop_by_id("prop_station_32_exit")
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


func _connect_prop_signals() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _on_prop_resonance_triggered(prop_id: String, prop_type: int) -> void:
	match prop_type:
		MemoryResonancePoint.PropType.STEAMED_GLASS_PANE_A:
			is_steamed_pane_inspected = true
			if dialogue_active and dialogue_index == 0:
				advance_dialogue()
		MemoryResonancePoint.PropType.CRACKED_GLASS_PANE_B:
			is_cracked_pane_inspected = true
			if dialogue_active and dialogue_index == 1:
				advance_dialogue()
		MemoryResonancePoint.PropType.CONDENSATION_TRACE_ETCHER:
			is_trace_etched = true
			if dialogue_active and (dialogue_index == 2 or dialogue_index == 3):
				advance_dialogue()
		MemoryResonancePoint.PropType.POLISHED_GLASS_PANE_C:
			is_polished_pane_inspected = true
			if dialogue_active and dialogue_index < 7:
				dialogue_index = 6
				advance_dialogue()
		MemoryResonancePoint.PropType.STATION_32_EXIT:
			if is_exit_unlocked:
				_on_airlock_zone_body_entered(player)


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if is_level_completed:
		return
	if body is PrototypePlayer or body == player or body.name == "Player":
		is_level_completed = true
		level_completed.emit()


func _setup_observed_glass() -> void:
	if observed_glass == null:
		return
	observed_glass.anchor_state_changed.connect(_on_glass_anchor_state_changed)
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("has_recorded_decision"):
		glass_detail_faded = state.has_recorded_decision(&"station_32_observed_glass_corrected")
	elif state:
		var decisions: Variant = state.get("decisions")
		if decisions is Dictionary:
			glass_detail_faded = (decisions as Dictionary).has(&"station_32_observed_glass_corrected")


func _on_glass_anchor_state_changed(anchored: bool) -> void:
	is_glass_anchored = anchored
	queue_redraw()


func run_glass_observation_check() -> void:
	if observed_glass == null:
		return
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	if observed_glass.current_reality == AnchorableObject.RealityState.STATE_B:
		_apply_glass_correction()


func _apply_glass_correction() -> void:
	glass_observation_correction_count += 1
	glass_detail_faded = true
	var state := get_node_or_null("/root/GameStateManager")
	if state and state.has_method("record_decision"):
		state.record_decision(&"station_32_observed_glass_corrected", glass_observation_correction_count)
	var trace_prop := _get_prop_by_id("prop_trace_etcher")
	if trace_prop:
		trace_prop.prop_subtitle = "Ślad w szkle — krawędź wyblakła po korekcie"
	observed_glass.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if player:
		player.reset_to(CHECKPOINT_POSITION)
	observation_boundary_crossed = false
	queue_redraw()


func _draw() -> void:
	_draw_state_layer()
	if dialogue_active:
		_draw_dialogue_hud()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var trace_color := VectorStageStyle.CORRECTION_OXIDE if glass_detail_faded else VectorStageStyle.ANCHOR_CYAN
	if is_glass_anchored:
		trace_color = VectorStageStyle.ANCHOR_CYAN
	draw_line(Vector2(348.0, 82.0), Vector2(348.0, 248.0), trace_color, 2.0)
	draw_line(Vector2(356.0, 88.0), Vector2(356.0, 244.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	if is_exit_unlocked:
		draw_line(Vector2(528.0, 220.0), Vector2(606.0, 220.0), VectorStageStyle.HUMAN_AMBER, 2.0)


func _draw_corridor_background() -> void:
	# Deep glass mirror corridor background (640x360)
	# Palette: #080d11, #101820, #1a2630, #364f60, #d39a62, #e2b060, #5da398, #c65d58
	var floor_rect := Rect2(0.0, 276.0, 640.0, 84.0)
	draw_rect(floor_rect, Color("080d11"))
	
	# High-gloss dark glass corridor floor tiles with cyan sheen lines
	for x in range(0, 640, 40):
		draw_line(Vector2(x, 276.0), Vector2(x, 360.0), Color("101820"), 1.0)
		draw_line(Vector2(x + 2.0, 276.0), Vector2(x + 2.0, 278.0), Color("5da398", 0.4), 1.0)
	draw_line(Vector2(0.0, 276.0), Vector2(640.0, 276.0), Color("364f60"), 2.0)
	
	# Ceiling structural mullions & cable conduits
	var ceiling_rect := Rect2(0.0, 0.0, 640.0, 48.0)
	draw_rect(ceiling_rect, Color("06090c"))
	draw_line(Vector2(0.0, 48.0), Vector2(640.0, 48.0), Color("1a2630"), 2.0)
	
	# Vertical glass partition frames along back wall
	for p in range(8):
		var px: float = 20.0 + p * 78.0
		# Steel stanchion
		draw_line(Vector2(px, 48.0), Vector2(px, 276.0), Color("131e26"), 3.0)
		draw_line(Vector2(px, 48.0), Vector2(px, 276.0), Color("263845"), 1.0)
		# Glass pane background panel
		var pane_bg := Rect2(px + 4.0, 60.0, 70.0, 206.0)
		draw_rect(pane_bg, Color("091016"))
		draw_rect(pane_bg, Color("1a2935"), false, 1.0)


func _draw_glass_reflections() -> void:
	# Diagonal ambient refraction streaks across the corridor
	for i in range(6):
		var start_x: float = 40.0 + i * 105.0
		draw_line(Vector2(start_x, 60.0), Vector2(start_x + 50.0, 270.0), Color("5da398", 0.06), 2.5)
		draw_line(Vector2(start_x + 10.0, 60.0), Vector2(start_x + 60.0, 270.0), Color("e2b060", 0.04), 1.5)


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
	elif speaker == "WIERZBICKA":
		accent_col = Color("4ea8de")
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
