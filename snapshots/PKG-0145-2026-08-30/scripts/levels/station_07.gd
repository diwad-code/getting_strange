class_name Station07
extends Node2D

## Station 07 (Przestrzeń 07: Herbata dla Marty / Kiosk) — Kanon 0.3
## Zgodny ze specyfikacją docs/narrative/FULL_STORY.md (07), DIALOGUE_SCRIPT.md oraz VISUAL_DESIGN.md
##
## Cel: Kupić wodę i upewnić się, że nie pomyliła bocznej ulicy.
## Przeszkoda: Sprzedawca zna imię Leny i pyta o tę samą herbatę dla Marty.
## Działanie: Lena zadaje jedno pytanie kontrolne o ostatnią wizytę.
## Pokaż: Sprzedawca wskazuje zwykły wpis sprzedaży, nie zna żadnej tajemnicy i zamyka sklep.
## Zmiana: Lena racjonalizuje płatnością kartą lub pomyłką klientki. Ciało zatrzymuje się przed wypowiedzią.

## PRZESZKODA — dlaczego to tu jest: Betonowy bieg schodów prowadzi do rzeczywistego półpiętra klatki, którego krawędź nie może wisieć w powietrzu.
## PRZESZKODA — czego wymaga od Leny: wejścia po przytwierdzonym biegu i rozpoznania, że górne półpiętro należy do tej samej klatki.
## PRZESZKODA — koszt porażki: korekta odsyła do dolnego spocznika, a oznaczenie brakującej kondygnacji zostaje wyblakłe.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const InnerThoughtSurface := preload("res://scripts/ui/inner_thought_surface.gd")

const VIEW_SIZE := Vector2(640.0, 360.0)

signal clue_inspected(id: String, prop_type: int)
signal shopkeeper_dialogue_started()
signal shopkeeper_dialogue_advanced(line_idx: int)
signal shopkeeper_dialogue_completed()
signal water_purchased()
signal door_opened()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var thought_surface: InnerThoughtSurface = $InnerThoughtSurface
@onready var dialogue_box: CRTDialogueBox = $CRTDialogueBox

var shopkeeper_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "SPRZEDAWCA",
		"text": "Zwykła dla pani, jaśminowa dla Marty?",
		"is_lena": false,
	},
	{
		"speaker": "LENA",
		"text": "Skąd pan zna Martę?",
		"is_lena": true,
	},
	{
		"speaker": "SPRZEDAWCA",
		"text": "Bo wczoraj tu była. Co się stało?",
		"is_lena": false,
	},
	{
		"speaker": "LENA",
		"text": "Nic. Poproszę wodę.",
		"is_lena": true,
	},
	{
		"speaker": "ŚWIADECTWO CIAŁA",
		"text": "Lena zatrzymuje dłoń nad ladą przed odebraniem butelki.",
		"is_lena": true,
		"is_stage_direction": true
	}
]

var shopkeeper_dialogue_active: bool = false
var shopkeeper_dialogue_index: int = -1
var is_shopkeeper_dialogue_completed: bool = false
var is_water_purchased: bool = false
var is_ledger_checked: bool = false
var is_door_open: bool = false
var is_level_completed: bool = false

var stair_correction_count: int = 0
var stair_flight_crossed: bool = false

var _pulse_time: float = 0.0


var _door_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _transition_player: AudioStreamPlayer


func _ready() -> void:
	_setup_camera()
	_setup_audio()
	_setup_guidance()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	queue_redraw()


## PKG-0141 (D-150). Jedna sciezka kamery dla calej kampanii: nazwa wezla,
## granice komory i kolejnosc podpiec zyja w `StationCameraRig`, nie w 45 kopiach.
func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)


func _setup_audio() -> void:
	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.volume_db = -4.0
	_door_player.bus = &"Master"
	add_child(_door_player)
	
	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(false)
	_blip_player.volume_db = -6.0
	_blip_player.bus = &"Master"
	add_child(_blip_player)
	
	_transition_player = AudioStreamPlayer.new()
	_transition_player.name = "TransitionAudioPlayer"
	_transition_player.stream = ProceduralAudio.create_airlock_seal_sound()
	_transition_player.volume_db = -6.0
	_transition_player.bus = &"Master"
	add_child(_transition_player)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	
	var beat_obs := GuidanceBeat.new()
	beat_obs.beat_id = &"s07_shopkeeper_name_obs"
	beat_obs.scene_id = &"station_07"
	beat_obs.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_obs.thought_kind = &"observation"
	beat_obs.text_pl = "Sprzedawca zna moje imię i herbatę Marty."
	beat_obs.text_en = "Shopkeeper knows my name and Marta's tea."
	beat_obs.cooldown_s = 8.0
	guidance_service.register_beat(beat_obs)
	
	var beat_hyp := GuidanceBeat.new()
	beat_hyp.beat_id = &"s07_shopkeeper_card_hyp"
	beat_hyp.scene_id = &"station_07"
	beat_hyp.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
	beat_hyp.thought_kind = &"interpretation"
	beat_hyp.text_pl = "Imię zobaczył na karcie płatniczej. Najprostsze."
	beat_hyp.text_en = "Saw the name on the payment card. Most likely."
	beat_hyp.cooldown_s = 8.0
	beat_hyp.hypothesis_id = &"hyp_card_name"
	beat_hyp.predicted_check = "ask_recent_visit"
	beat_hyp.supersedes = &"s07_shopkeeper_name_obs"
	guidance_service.register_beat(beat_hyp)
	
	var beat_intent := GuidanceBeat.new()
	beat_intent.beat_id = &"s07_address_check_intent"
	beat_intent.scene_id = &"station_07"
	beat_intent.tier = GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT
	beat_intent.thought_kind = &"intention"
	beat_intent.text_pl = "Biorę wodę i sprawdzę adres na domofonie."
	beat_intent.text_en = "Taking the water and checking the intercom address."
	beat_intent.cooldown_s = 8.0
	beat_intent.supersedes = &"s07_shopkeeper_card_hyp"
	guidance_service.register_beat(beat_intent)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.0
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	prop.is_activated = true
	match id:
		"shop_counter", "marta_interaction", "tenant_directory":
			if not is_shopkeeper_dialogue_completed:
				if not shopkeeper_dialogue_active:
					start_shopkeeper_dialogue()
				else:
					advance_shopkeeper_dialogue()
			clue_inspected.emit(id, prop_type)
			
		"sales_ledger", "mailboxes":
			is_ledger_checked = true
			if _blip_player:
				_blip_player.play()
			if player and player.has_method("play_visual_cue"):
				player.play_visual_cue(&"examine", 0.7)
			if guidance_service:
				guidance_service.trigger_beat(&"s07_shopkeeper_name_obs")
			clue_inspected.emit(id, prop_type)
			_check_completion_condition()
			
		"water_bottle", "stair_timer_switch", "blind_stairs":
			if not is_water_purchased:
				purchase_water()
			clue_inspected.emit(id, prop_type)
			_check_completion_condition()


func start_shopkeeper_dialogue() -> void:
	if is_shopkeeper_dialogue_completed or shopkeeper_dialogue_active:
		return
	
	shopkeeper_dialogue_active = true
	shopkeeper_dialogue_index = 0
	_play_dialogue_blip(false)
	shopkeeper_dialogue_started.emit()
	queue_redraw()


func advance_shopkeeper_dialogue() -> int:
	if not shopkeeper_dialogue_active:
		start_shopkeeper_dialogue()
		return shopkeeper_dialogue_index
	
	shopkeeper_dialogue_index += 1
	if shopkeeper_dialogue_index >= shopkeeper_dialogue_lines.size():
		shopkeeper_dialogue_active = false
		is_shopkeeper_dialogue_completed = true
		purchase_water()
		shopkeeper_dialogue_completed.emit()
		queue_redraw()
		return -1
	
	var current_line: Dictionary = shopkeeper_dialogue_lines[shopkeeper_dialogue_index]
	var is_lena: bool = current_line.get("is_lena", false)
	_play_dialogue_blip(is_lena)
	
	if current_line.get("is_stage_direction", false) and player and player.has_method("play_visual_cue"):
		player.play_visual_cue(&"unease_reaction", 0.9)
	
	shopkeeper_dialogue_advanced.emit(shopkeeper_dialogue_index)
	queue_redraw()
	return shopkeeper_dialogue_index


func purchase_water() -> void:
	if is_water_purchased:
		return
	is_water_purchased = true
	is_door_open = true
	water_purchased.emit()
	door_opened.emit()
	
	if _door_player:
		_door_player.play()
	
	if guidance_service:
		guidance_service.report_progress(&"water_bought")
		guidance_service.trigger_beat(&"s07_shopkeeper_card_hyp")


func _check_completion_condition() -> void:
	if (is_water_purchased or is_shopkeeper_dialogue_completed) and not is_door_open:
		is_door_open = true
		door_opened.emit()


func _play_dialogue_blip(is_lena: bool) -> void:
	if _blip_player:
		_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(is_lena)
		_blip_player.play()


func _apply_stairwell_correction() -> void:
	stair_correction_count += 1
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		state.record_decision(&"station_07_stairwell_corrected", stair_correction_count)
	if player:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _physics_process(_delta: float) -> void:
	if player and not stair_flight_crossed and player.global_position.x >= 470.0:
		stair_flight_crossed = true
		queue_redraw()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_door_open:
		if not is_level_completed:
			is_level_completed = true
			if _transition_player:
				_transition_player.play()
			level_completed.emit()



func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	
	# Kiosk counter & exit illumination
	var status_col := VectorStageStyle.ANCHOR_CYAN if is_door_open else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(530.0, 180.0), Vector2(530.0, 310.0), status_col, 2.0)
	draw_line(Vector2(470.0, 250.0), Vector2(550.0, 250.0), status_col, 1.5)
