class_name Station11
extends Node2D

## Station 11 (Przestrzeń 11: Pierwsza korekta / Dziedziniec za osiedlem i interwencja UCP) for Getting Strange Vertical Slice.
## Represents the elevated technical corridor with observation window overlooking the courtyard at dawn,
## and the ground-level courtyard where a UCP intervention team stabilizes an elderly resident and erases a doorway seam.
## Implements observation of UCP intervention (Clue R-03), dialogue with Marta Kurek, masonry smoothing,
## inspection of the erased doorway trace, and opening of the exit portal to Space 12.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 11), and CONTINUITY_TRACKER.md (Clue R-03).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_DAWN_SKY := Color("1a2a36")
const COLOR_MIST := Color(0.65, 0.78, 0.85, 0.18)
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Marta / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Stabilizer field / Consensus)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Discontinuity / Fading seam)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_BRICK := Color("38261e")
const COLOR_BRICK_DARK := Color("281b15")
const COLOR_CONCRETE := Color("2d3840")
const COLOR_CONCRETE_LIGHT := Color("3d4b54")

signal clue_inspected(id: String, prop_type: int)
signal observation_started()
signal ucp_intervention_triggered()
signal masonry_smoothed()
signal marta_dialogue_started()
signal marta_dialogue_advanced(line_idx: int)
signal marta_dialogue_completed()
signal courtyard_airlock_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone

var window_inspected: bool = false
var ucp_team_inspected: bool = false
var resident_inspected: bool = false
var doorway_inspected: bool = false
var marta_inspected: bool = false
var airlock_inspected: bool = false

var is_intervention_active: bool = false
var is_intervention_completed: bool = false
var is_masonry_smoothed: bool = false
var is_airlock_unlocked: bool = false
var is_level_completed: bool = false

var marta_dialogue_active: bool = false
var marta_dialogue_index: int = -1
var is_marta_dialogue_completed: bool = false

var _door_open_progress: float = 0.0
var _smoothing_progress: float = 0.0
var _pulse_time: float = 0.0
var _step_timer: float = 0.0

# Observation & Dialogue lines for Space 11 (per FULL_STORY.md Scene 11 and NEXT_SESSION_PROMPT.md)
var observation_and_dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "KOBIETA (MIESZKANKA)",
		"text": "Tu było wejście do klatki B. Schody były z tej strony, pamiętam mosiężny próg.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": true,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "OPERATOR UCP",
		"text": "Dziękujemy. Już sprawdziliśmy. Wejście jest dwadzieścia metrów dalej, przy numerze czwartym.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": true,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Operator uruchamia stabilizator polowy. Cichy impuls rezonansu przepływa przez ceglany mur.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": true
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Obrys dawnego wejścia bezpowrotnie wygładza się w litą ścianę. Ani jednej szczeliny.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": true
	},
	{
		"speaker": "KOBIETA (MIESZKANKA)",
		"text": "Rzeczywiście... Przecież zawsze tam wchodziłam. Przepraszam za kłopot.",
		"is_lena": false,
		"is_marta": false,
		"is_elderly": true,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Zgłosiłam ją, bo bałam się, że skończy jak te drzwi.",
		"is_lena": false,
		"is_marta": true,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Jak te drzwi?",
		"is_lena": true,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Że jeśli nikt jej nie poszuka, nikt nie zauważy, kiedy zniknie szew.",
		"is_lena": false,
		"is_marta": true,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "UCP jej nie skrzywdziło. Pomogli jej bezpiecznie trafić do domu.",
		"is_lena": true,
		"is_marta": false,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "Uratowali ją. I wymazali jej wspomnienie. To nie to samo co krzywda, ale kosztuje tyle samo.",
		"is_lena": false,
		"is_marta": true,
		"is_elderly": false,
		"is_ucp": false,
		"is_stage_direction": false
	}
]

var _ambience_player: AudioStreamPlayer
var _stabilizer_player: AudioStreamPlayer
var _masonry_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer


func _ready() -> void:
	_setup_audio_players()
	_connect_signals()
	_configure_camera()
	observation_started.emit()


func _setup_audio_players() -> void:
	_ambience_player = AudioStreamPlayer.new()
	_ambience_player.name = "AmbienceAudioPlayer"
	_ambience_player.stream = ProceduralAudio.create_morning_ambience_sound()
	_ambience_player.bus = &"Master"
	_ambience_player.volume_db = -6.0
	add_child(_ambience_player)
	_ambience_player.play()

	_stabilizer_player = AudioStreamPlayer.new()
	_stabilizer_player.name = "StabilizerAudioPlayer"
	_stabilizer_player.stream = ProceduralAudio.create_ucp_stabilizer_beam_sound()
	_stabilizer_player.bus = &"Master"
	add_child(_stabilizer_player)

	_masonry_player = AudioStreamPlayer.new()
	_masonry_player.name = "MasonryAudioPlayer"
	_masonry_player.stream = ProceduralAudio.create_masonry_smooth_sound()
	_masonry_player.bus = &"Master"
	add_child(_masonry_player)

	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.bus = &"Master"
	add_child(_blip_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.bus = &"Master"
	add_child(_door_player)


func _connect_signals() -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint:
				child.resonance_triggered.connect(_on_prop_resonance)

	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_entered)


func _configure_camera() -> void:
	if camera:
		var bounds: Array[Rect2] = [
			Rect2(Vector2.ZERO, VIEW_SIZE)
		]
		camera.setup_chambers(bounds)
		camera.set_chamber(0, true)


func _process(delta: float) -> void:
	_pulse_time += delta

	# Footsteps on gallery/stairs/courtyard
	if player and player.is_on_floor() and absf(player.velocity.x) > 10.0:
		_step_timer += delta
		if _step_timer >= 0.30:
			_step_timer = 0.0
			if player.has_node("StepAudioPlayer"):
				var sp := player.get_node("StepAudioPlayer") as AudioStreamPlayer2D
				if sp:
					if player.global_position.x < 240.0 and player.global_position.y < 180.0:
						sp.stream = ProceduralAudio.create_footstep_metal_sound()
					else:
						sp.stream = ProceduralAudio.create_footstep_linoleum_sound()
					sp.pitch_scale = randf_range(0.95, 1.05)
					sp.play()

	# Masonry smoothing animation
	if is_masonry_smoothed and _smoothing_progress < 1.0:
		_smoothing_progress = minf(1.0, _smoothing_progress + delta * 0.8)
		queue_redraw()

	# Airlock door opening transition
	if is_airlock_unlocked and _door_open_progress < 1.0:
		_door_open_progress = minf(1.0, _door_open_progress + delta * 0.9)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if marta_dialogue_active:
		if event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump"):
			advance_marta_dialogue()
			get_viewport().set_input_as_handled()


func _on_prop_resonance(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)

	match prop_type:
		MemoryResonancePoint.PropType.OBSERVATION_WINDOW:
			window_inspected = true
			if not marta_dialogue_active and not is_marta_dialogue_completed:
				start_marta_dialogue()
		MemoryResonancePoint.PropType.UCP_INTERVENTION_TEAM:
			ucp_team_inspected = true
			if not is_intervention_active and not is_intervention_completed:
				trigger_intervention_procedure()
		MemoryResonancePoint.PropType.ELDERLY_RESIDENT_GUIDE:
			resident_inspected = true
			if not is_intervention_completed:
				trigger_intervention_procedure()
		MemoryResonancePoint.PropType.ERASED_DOORWAY_TRACE:
			doorway_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.MARTA_OBSERVATION_DIALOGUE:
			marta_inspected = true
			if not marta_dialogue_active and not is_marta_dialogue_completed:
				start_marta_dialogue()
		MemoryResonancePoint.PropType.COURTYARD_EXIT_AIRLOCK:
			airlock_inspected = true

	queue_redraw()


func trigger_intervention_procedure() -> void:
	is_intervention_active = true
	ucp_intervention_triggered.emit()
	if _stabilizer_player:
		_stabilizer_player.play()

	# Smooth masonry seam
	is_masonry_smoothed = true
	masonry_smoothed.emit()
	if _masonry_player:
		_masonry_player.play()

	# Update ErasedDoorwayTrace prop state
	if props:
		var doorway_prop := props.get_node_or_null("ErasedDoorwayTrace") as MemoryResonancePoint
		if doorway_prop:
			doorway_prop.is_activated = true

	is_intervention_completed = true
	_check_unlock_conditions()
	queue_redraw()


func start_marta_dialogue() -> void:
	marta_dialogue_active = true
	marta_dialogue_index = 0
	marta_dialogue_started.emit()
	_play_line_audio(0)
	queue_redraw()


func advance_marta_dialogue() -> int:
	if not marta_dialogue_active:
		return -1

	marta_dialogue_index += 1

	# Line 2 trigger stabilizer sound & masonry smooth if not yet triggered
	if marta_dialogue_index == 2 and not is_masonry_smoothed:
		trigger_intervention_procedure()

	if marta_dialogue_index >= observation_and_dialogue_lines.size():
		marta_dialogue_active = false
		is_marta_dialogue_completed = true
		marta_dialogue_completed.emit()
		_check_unlock_conditions()
		queue_redraw()
		return -1

	marta_dialogue_advanced.emit(marta_dialogue_index)
	_play_line_audio(marta_dialogue_index)
	queue_redraw()
	return marta_dialogue_index


func _play_line_audio(idx: int) -> void:
	if idx < 0 or idx >= observation_and_dialogue_lines.size():
		return

	var line := observation_and_dialogue_lines[idx]
	if _blip_player:
		if line.get("is_marta", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_marta_blip_sound()
			_blip_player.pitch_scale = randf_range(0.97, 1.03)
			_blip_player.play()
		elif line.get("is_lena", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
			_blip_player.pitch_scale = randf_range(0.98, 1.02)
			_blip_player.play()
		elif line.get("is_elderly", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_elderly_woman_sound()
			_blip_player.pitch_scale = randf_range(0.96, 1.04)
			_blip_player.play()
		elif line.get("is_ucp", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(false)
			_blip_player.pitch_scale = randf_range(0.95, 1.00)
			_blip_player.play()
		elif line.get("is_stage_direction", false):
			_blip_player.stream = ProceduralAudio.create_paper_rustle_sound()
			_blip_player.pitch_scale = 1.0
			_blip_player.play()


func _check_unlock_conditions() -> void:
	# Unlock courtyard exit airlock once dialogue / intervention is witnessed and doorway is smoothed
	if is_marta_dialogue_completed and is_masonry_smoothed and not is_airlock_unlocked:
		is_airlock_unlocked = true
		courtyard_airlock_unlocked.emit()
		if _door_player:
			_door_player.play()

		if props:
			var airlock_prop := props.get_node_or_null("CourtyardExitAirlock") as MemoryResonancePoint
			if airlock_prop:
				airlock_prop.is_activated = true

		queue_redraw()


func _on_airlock_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# Vector-Stage state pass (D-096). The courtyard frame itself belongs to
	# VectorStageEnvironment (station_number = 11) and is drawn behind this node.
	# This pass only moves the one or two plane relations that carry state, per
	# VISUAL_DESIGN.md §2 (hierarchia czytelności) and §3.2 (stan aktywny zmienia
	# 1–2 relacje płaszczyzn, nie całą paletę lub layout).
	_draw_state_layer()
	if marta_dialogue_active:
		_draw_dialogue_overlay()


func _draw_state_layer() -> void:
	# The route first. VISUAL_DESIGN.md §7.4 and the obstacle canon both require
	# the traversable way to hold the highest contrast in the frame, so it is
	# drawn from the colliders that actually carry it.
	VectorStageStyle.draw_play_plane(self, geometry)

	# Relation 1 — the erased entrance. While the seam still remembers the old
	# doorway it reads as a point oxide plane; once the masonry has been smoothed
	# it settles into the ordinary mid plane and the difference is simply gone.
	var seam := PackedVector2Array([
		Vector2(452.0, 182.0),
		Vector2(474.0, 179.0),
		Vector2(482.0, 288.0),
		Vector2(458.0, 291.0),
	])
	if is_masonry_smoothed:
		VectorStageStyle.draw_facet_polygon(self, seam, VectorStageStyle.MID_PLANE, 1.0)
	else:
		# An outline, not a lit surface: the accent stays punctual (VISUAL_DESIGN §4).
		var breath := 0.42 + 0.24 * sin(_pulse_time * 2.2)
		draw_polyline(seam, Color(VectorStageStyle.CORRECTION_OXIDE, breath), 1.5, true)
		draw_line(seam[0], seam[3], Color(VectorStageStyle.CORRECTION_OXIDE, breath), 1.5)

	# Relation 2 — the UCP field at work. A practical beam that runs from the
	# warden's wand to the wall it is smoothing. Point accent, never a screen glow.
	if is_intervention_active:
		var reach := clampf(_smoothing_progress, 0.0, 1.0)
		draw_line(
			Vector2(352.0, 252.0),
			Vector2(352.0 + 98.0 * reach, 214.0),
			Color(VectorStageStyle.ANCHOR_CYAN, 0.26 + 0.30 * reach),
			2.0
		)

	# Relation 3 — the way out reads as an opening light plane, not as a change
	# of room colour.
	if _door_open_progress > 0.0:
		var opening := 6.0 + _door_open_progress * 22.0
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(604.0 - opening, 198.0),
				Vector2(604.0 + opening, 198.0),
				Vector2(604.0 + opening, 292.0),
				Vector2(604.0 - opening, 292.0),
			]),
			VectorStageStyle.LIGHT_PLANE,
			1.0
		)


func _draw_dialogue_overlay() -> void:
	if marta_dialogue_index < 0 or marta_dialogue_index >= observation_and_dialogue_lines.size():
		return

	var line := observation_and_dialogue_lines[marta_dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_lena: bool = line.get("is_lena", false)
	var is_marta: bool = line.get("is_marta", false)
	var is_elderly: bool = line.get("is_elderly", false)
	var is_ucp: bool = line.get("is_ucp", false)
	var is_stage: bool = line.get("is_stage_direction", false)

	# Dialogue box in top center (x=110..530, y=24..76)
	var box_rect := Rect2(110.0, 24.0, 420.0, 52.0)
	draw_rect(box_rect, Color(0.08, 0.12, 0.15, 0.92))

	# Frame border color
	var frame_col := COLOR_AMBER if (is_lena or is_marta) else (COLOR_CYAN if is_ucp else (COLOR_CORRECTION if is_elderly else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, frame_col, false, 1.2)

	# Speaker accent bar on left
	draw_rect(Rect2(110.0, 24.0, 4.0, 52.0), frame_col)

	var font := ThemeDB.fallback_font
	if font:
		var speaker_col := COLOR_AMBER if is_lena else (Color("c9a638") if is_marta else (COLOR_CYAN if is_ucp else (Color("d8a287") if is_elderly else COLOR_INFRASTRUCTURE)))
		draw_string(font, Vector2(122.0, 40.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, speaker_col)

		var col_text := Color("ffffff") if not is_stage else COLOR_CYAN * 0.95
		draw_string(font, Vector2(122.0, 58.0), text, HORIZONTAL_ALIGNMENT_LEFT, 390, 11, col_text)

		# Advance hint [E] on bottom right
		var hint_pulse := sin(_pulse_time * 3.5) * 0.5 + 0.5
		var hint_col := Color(COLOR_AMBER.r, COLOR_AMBER.g, COLOR_AMBER.b, 0.4 + hint_pulse * 0.5)
		draw_string(font, Vector2(495.0, 68.0), "[E]", HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, hint_col)

	# Dialogue pulse progress line indicator at bottom of box
	draw_line(Vector2(120.0, 74.0), Vector2(120.0 + 380.0 * (float(marta_dialogue_index + 1) / float(observation_and_dialogue_lines.size())), 74.0), frame_col, 1.5)
