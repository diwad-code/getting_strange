class_name Station12
extends Node2D

## Station 12 (Przestrzeń 12: Pokaz bezpieczeństwa / Przejście podziemne i punkt informacyjny UCP) for Getting Strange Vertical Slice.
## Represents the subterranean underpass under the city square at dawn, featuring ceramic subway tiles,
## institutional neon signage, a dual overlapping staircase anomaly being stabilized by a UCP safety warden,
## and a public UCP information terminal revealing local Lena's Level 3 clearance and role in Substructure nodes.
## Conforms to VISUAL_DESIGN.md, FULL_STORY.md (Scene 12), and CONTINUITY_TRACKER.md (Clue R-03, ucp_benefit_witnessed).
##
## PRZESZKODA — dlaczego to tu jest: dwie wersje zejścia z podestu nakładają się w tym przejściu
## i uzgodnienie po kolei kasuje jedną z nich, podczas gdy trwa ewakuacja.
## PRZESZKODA — czego wymaga od Leny: utrzymać jeden bieg schodów w polu widzenia i dłonią przy
## nim, dopóki dziecko nie zejdzie na dół; sama tą drogą nie idzie.
## PRZESZKODA — koszt porażki: dziecko zostaje skorygowane przez przestrzeń, a z posadzki przy
## schodach znika ślad używania; Lena wraca do punktu kontrolnego, świat pamięta różnicę.

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("182126") # Sea graphite
const COLOR_UNDERPASS_CEILING := Color("151f26")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Stabilizer field / Consensus)
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Discontinuity / Fading anomaly)
const COLOR_DARK_STEEL := Color("263943")
const COLOR_SUBWAY_TILE := Color("2d3c45")
const COLOR_SUBWAY_TILE_LIGHT := Color("3a4e5a")
const COLOR_CONCRETE := Color("27343d")

## The consensus pass runs on the underpass's own schedule, not on the player's.
const CORRECTION_PERIOD := 7.0
## Seconds the pass is visible and audible before it lands (kanon przeszkód §5.2).
const CORRECTION_WARNING := 2.5
## How long the child waits at a break before the space resolves against her.
const CHILD_PATIENCE := 6.0
## The evacuation is already under way when Lena walks in.
const CHILD_START_DELAY := 3.0
const CHILD_WALK_SPEED := 34.0

enum ChildStage {
	WAITING = 0,
	DESCENDING = 1,
	BLOCKED = 2,
	SAFE = 3,
}

## Feet positions the child walks through on the way down to the warden.
## Index 1 -> 2 is the contested link carried by EvacuationStairFlight.
const CHILD_PATH: Array[Vector2] = [
	Vector2(72.0, 200.0),
	Vector2(98.0, 200.0),
	Vector2(127.0, 220.0),
	Vector2(102.0, 240.0),
	Vector2(77.0, 260.0),
	Vector2(58.0, 280.0),
	Vector2(150.0, 280.0),
]
const CHILD_CONTESTED_LEG := 1

signal clue_inspected(id: String, prop_type: int)
signal underpass_entered()
signal stabilization_triggered()
signal child_evacuated()
signal terminal_scanned()
signal safety_dialogue_started()
signal safety_dialogue_advanced(line_idx: int)
signal safety_dialogue_completed()
signal underpass_gate_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var stair_flight: AnchorableObject = get_node_or_null("Geometry/EvacuationStairFlight") as AnchorableObject

var terminal_inspected: bool = false
var vitrine_inspected: bool = false
var poster_inspected: bool = false
var pillar_inspected: bool = false
var gate_inspected: bool = false

var is_stabilization_active: bool = false
var is_child_evacuated: bool = false
var is_safety_demonstrated: bool = false
var is_gate_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _gate_open_progress: float = 0.0
var _stabilizer_beam_progress: float = 0.0
var _child_pos_x: float = 72.0
var _child_pos_y: float = 200.0
var _pulse_time: float = 0.0
var _neon_flicker: float = 1.0

var _child_stage: int = ChildStage.WAITING
var _child_leg: int = 0
var _child_delay: float = CHILD_START_DELAY
var _child_wait: float = 0.0
var _correction_warning: float = 0.0
var _correction_timer: float = CORRECTION_PERIOD

## Permanent record of what the space took while Lena was holding the route.
var child_correction_count: int = 0
var is_child_corrected: bool = false
var is_flight_anchored: bool = false

# Dialogue & Terminal Readouts for Space 12 (per FULL_STORY.md Scene 12 and NEXT_SESSION_PROMPT.md)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "KOMUNIKAT PA",
		"text": "Uwaga pasażerowie. W korytarzu zachodnim występuje lokalna rozbieżność geometryczna. Prosimy o zachowanie spokoju.",
		"is_pa": true,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "STRAŻNIK EWAKUACJI UCP",
		"text": "Nie bój się, mała. Zespół trzyma szew. Za chwilę zejdziesz na peron.",
		"is_pa": false,
		"is_warden": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Dwie wersje schodów nakładają się w przestrzeni. Stopnie rozchodzą się o pół metra w powietrzu.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Pomogę wam. Przełączam zasilanie stabilizatora pomostu.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Wiązka stabilizatora blokuje stopnie w jednym, bezpiecznym ciągu. Dziewczynka zbiega bezpiecznie do strażnika.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": true
	},
	{
		"speaker": "STRAŻNIK EWAKUACJI UCP",
		"text": "Dziękuję za asystę. Rozbieżność zabezpieczona bez urazów. Wpisuję do rejestru Punktu 6.",
		"is_pa": false,
		"is_warden": true,
		"is_lena": false,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "TERMINAL INFORMACYJNY UCP",
		"text": "[AUTORYZACJA POZIOMU 3: INŻ. LENA WOLSKA — PRACOWNIK KWALIFIKOWANY SIATEK PODSTRUKTURY]",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Poziom 3...? Lokalna Lena nie tylko uciekała przed UCP. Ona współtworzyła ten system.",
		"is_pa": false,
		"is_warden": false,
		"is_lena": true,
		"is_terminal": false,
		"is_stage_direction": false
	},
	{
		"speaker": "TERMINAL INFORMACYJNY UCP",
		"text": "[ZASADA 01: PAMIĘĆ TO NIE POMIAR. W PRZYPADKU NIEZGODNOŚCI ZGŁOŚ SIĘ DO PUNKTU ZGODNOŚCI 6].",
		"is_pa": false,
		"is_warden": false,
		"is_lena": false,
		"is_terminal": true,
		"is_stage_direction": false
	}
]

var _subway_player: AudioStreamPlayer
var _neon_player: AudioStreamPlayer
var _pa_player: AudioStreamPlayer
var _terminal_player: AudioStreamPlayer
var _door_player: AudioStreamPlayer
var _blip_player: AudioStreamPlayer


func _ready() -> void:
	_setup_audio_players()
	_connect_signals()
	_connect_stair_flight()
	_configure_camera()
	underpass_entered.emit()


func _connect_stair_flight() -> void:
	if stair_flight == null:
		return
	stair_flight.anchor_state_changed.connect(_on_stair_flight_anchor_changed)
	stair_flight.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)


func _physics_process(_delta: float) -> void:
	if stair_flight and is_instance_valid(player):
		stair_flight.update_player_distance(player.global_position)


func _setup_audio_players() -> void:
	_subway_player = AudioStreamPlayer.new()
	_subway_player.name = "SubwayHumPlayer"
	_subway_player.stream = ProceduralAudio.create_subway_hum_sound()
	_subway_player.bus = &"Master"
	_subway_player.volume_db = -6.0
	add_child(_subway_player)
	_subway_player.play()

	_neon_player = AudioStreamPlayer.new()
	_neon_player.name = "NeonFlickerPlayer"
	_neon_player.stream = ProceduralAudio.create_neon_flicker_sound()
	_neon_player.bus = &"Master"
	_neon_player.volume_db = -10.0
	add_child(_neon_player)
	_neon_player.play()

	_pa_player = AudioStreamPlayer.new()
	_pa_player.name = "PaChimePlayer"
	_pa_player.stream = ProceduralAudio.create_pa_chime_sound()
	_pa_player.bus = &"Master"
	_pa_player.volume_db = -4.0
	add_child(_pa_player)

	_terminal_player = AudioStreamPlayer.new()
	_terminal_player.name = "TerminalPlayer"
	_terminal_player.stream = ProceduralAudio.create_terminal_keypress_sound()
	_terminal_player.bus = &"Master"
	_terminal_player.volume_db = -2.0
	add_child(_terminal_player)

	_door_player = AudioStreamPlayer.new()
	_door_player.name = "DoorAudioPlayer"
	_door_player.stream = ProceduralAudio.create_apartment_door_sound()
	_door_player.bus = &"Master"
	add_child(_door_player)

	_blip_player = AudioStreamPlayer.new()
	_blip_player.name = "BlipAudioPlayer"
	_blip_player.bus = &"Master"
	add_child(_blip_player)


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
	_neon_flicker = 0.85 + 0.15 * sin(_pulse_time * 18.0) * cos(_pulse_time * 42.0)

	if is_stabilization_active and _stabilizer_beam_progress < 1.0:
		_stabilizer_beam_progress = minf(1.0, _stabilizer_beam_progress + delta * 1.5)
		queue_redraw()

	_update_correction_cycle(delta)
	_update_child(delta)

	if is_gate_unlocked and _gate_open_progress < 1.0:
		_gate_open_progress = minf(1.0, _gate_open_progress + delta * 0.9)
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if dialogue_active:
		if event.is_action_pressed(&"interact") or event.is_action_pressed(&"jump"):
			advance_dialogue()
			get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed(&"interact") and stair_flight and stair_flight.is_player_in_range:
		stair_flight.toggle_anchor()
		get_viewport().set_input_as_handled()


func _on_prop_resonance(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)

	match prop_type:
		MemoryResonancePoint.PropType.UCP_INFO_TERMINAL:
			terminal_inspected = true
			if not dialogue_active and not is_dialogue_completed:
				start_dialogue()
			elif is_dialogue_completed:
				_check_unlock_conditions()
		MemoryResonancePoint.PropType.SHOWCASE_VITRINE:
			vitrine_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.INSTRUCTION_POSTER:
			poster_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.SUBWAY_TILE_PILLAR:
			pillar_inspected = true
			_check_unlock_conditions()
		MemoryResonancePoint.PropType.UNDERPASS_EXIT_GATE:
			gate_inspected = true

	queue_redraw()


## The consensus pass. It belongs to the underpass, runs to its own clock and
## would run exactly the same way with nobody standing here (kanon przeszkód §2.4).
func _update_correction_cycle(delta: float) -> void:
	if is_stabilization_active or _child_stage == ChildStage.SAFE:
		return

	if _correction_warning > 0.0:
		_correction_warning = maxf(0.0, _correction_warning - delta)
		if _correction_warning <= 0.0:
			run_correction_pass()
		queue_redraw()
		return

	_correction_timer = maxf(0.0, _correction_timer - delta)
	if _correction_timer <= 0.0:
		announce_correction_pass()


func announce_correction_pass() -> void:
	if _correction_warning > 0.0:
		return
	_correction_warning = CORRECTION_WARNING
	if _pa_player and not _pa_player.playing:
		_pa_player.play()
	queue_redraw()


## Resolves one version of the descent against the other. A held flight resists
## and the way down survives; an unheld flight is reduced to its bracket.
func run_correction_pass() -> void:
	_correction_warning = 0.0
	_correction_timer = CORRECTION_PERIOD
	if stair_flight == null:
		return
	var target := (
		AnchorableObject.RealityState.STATE_B
		if stair_flight.current_reality == AnchorableObject.RealityState.STATE_A
		else AnchorableObject.RealityState.STATE_A
	)
	stair_flight.apply_reality_shift(target, true)
	queue_redraw()


func is_descent_open() -> bool:
	if stair_flight == null:
		return true
	return stair_flight.current_reality == AnchorableObject.RealityState.STATE_A


func _on_stair_flight_anchor_changed(anchored: bool) -> void:
	is_flight_anchored = anchored
	queue_redraw()


## The child walks down because the warden told her to, at her own pace.
func _update_child(delta: float) -> void:
	if _child_stage == ChildStage.SAFE:
		return

	if _child_stage == ChildStage.WAITING:
		_child_delay = maxf(0.0, _child_delay - delta)
		if _child_delay <= 0.0:
			_child_stage = ChildStage.DESCENDING
		return

	var target: Vector2 = CHILD_PATH[_child_leg + 1]

	# The contested link. If this version of the flight is not there, she stops
	# at the edge — she does not fall and she does not jump.
	if _child_leg == CHILD_CONTESTED_LEG and not is_descent_open():
		if _child_stage != ChildStage.BLOCKED:
			_child_stage = ChildStage.BLOCKED
			_child_wait = CHILD_PATIENCE
		_child_wait = maxf(0.0, _child_wait - delta)
		if _child_wait <= 0.0:
			_apply_child_correction()
		queue_redraw()
		return

	if _child_stage == ChildStage.BLOCKED:
		_child_stage = ChildStage.DESCENDING

	var here := Vector2(_child_pos_x, _child_pos_y)
	var step := CHILD_WALK_SPEED * delta
	if here.distance_to(target) <= step:
		_child_pos_x = target.x
		_child_pos_y = target.y
		_child_leg += 1
		if _child_leg >= CHILD_PATH.size() - 1:
			_on_child_safe()
	else:
		var moved := here + here.direction_to(target) * step
		_child_pos_x = moved.x
		_child_pos_y = moved.y
	queue_redraw()


## Failure model 5.1 — correction, never death. The space resolves against the
## child, the world keeps the cost, and Lena returns to the checkpoint.
func _apply_child_correction() -> void:
	if _child_stage == ChildStage.SAFE:
		return
	child_correction_count += 1
	is_child_corrected = true

	var state_manager := get_node_or_null("/root/GameStateManager")
	if state_manager and state_manager.has_method("record_decision"):
		state_manager.record_decision(&"station_12_child_corrected", child_correction_count)

	return_to_checkpoint()


## Puts the attempt back where it started without taking the scene away. The
## recorded cost stays; only the attempt is reset (kanon przeszkód §5.1, §5.3).
func return_to_checkpoint() -> void:
	_child_stage = ChildStage.WAITING
	_child_leg = 0
	_child_delay = CHILD_START_DELAY
	_child_wait = 0.0
	_child_pos_x = CHILD_PATH[0].x
	_child_pos_y = CHILD_PATH[0].y
	_correction_warning = 0.0
	_correction_timer = CORRECTION_PERIOD
	if stair_flight:
		stair_flight.set_anchored(false)
		stair_flight.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)
	if is_instance_valid(player):
		player.reset_to(Vector2(35.0, 260.0))
	if camera:
		camera.add_trauma(0.22)
	queue_redraw()


func _on_child_safe() -> void:
	if _child_stage == ChildStage.SAFE:
		return
	_child_stage = ChildStage.SAFE
	var state_manager := get_node_or_null("/root/GameStateManager")
	if state_manager and state_manager.has_method("record_decision"):
		state_manager.record_decision(&"station_12_child_escorted", true)
	trigger_stabilization_procedure()


## The warden can only close the passage once the stairs are empty. Reached
## either by escorting the child down or by the safety briefing at the terminal.
func trigger_stabilization_procedure() -> void:
	is_stabilization_active = true
	stabilization_triggered.emit()

	# With the field up, the descent is stable and the child is off the stairs.
	if _child_stage != ChildStage.SAFE:
		_child_stage = ChildStage.SAFE
		_child_leg = CHILD_PATH.size() - 1
		_child_pos_x = CHILD_PATH[CHILD_PATH.size() - 1].x
		_child_pos_y = CHILD_PATH[CHILD_PATH.size() - 1].y
	_correction_warning = 0.0

	is_child_evacuated = true
	child_evacuated.emit()

	is_safety_demonstrated = true
	_check_unlock_conditions()
	queue_redraw()


func start_dialogue() -> void:
	dialogue_active = true
	dialogue_index = 0
	safety_dialogue_started.emit()
	_play_line_audio(0)
	queue_redraw()


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1

	dialogue_index += 1

	# Line 4: Trigger stabilization & child evacuation
	if dialogue_index == 4 and not is_stabilization_active:
		trigger_stabilization_procedure()

	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		safety_dialogue_completed.emit()
		_check_unlock_conditions()
		queue_redraw()
		return -1

	safety_dialogue_advanced.emit(dialogue_index)
	_play_line_audio(dialogue_index)
	queue_redraw()
	return dialogue_index


func _play_line_audio(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return

	var line := dialogue_lines[idx]
	if _blip_player:
		if line.get("is_pa", false):
			_blip_player.stream = ProceduralAudio.create_pa_chime_sound()
			_blip_player.pitch_scale = 1.0
			_blip_player.play()
		elif line.get("is_warden", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(false)
			_blip_player.pitch_scale = randf_range(0.94, 0.98)
			_blip_player.play()
		elif line.get("is_lena", false):
			_blip_player.stream = ProceduralAudio.create_dialogue_blip_sound(true)
			_blip_player.pitch_scale = randf_range(0.98, 1.02)
			_blip_player.play()
		elif line.get("is_terminal", false):
			_blip_player.stream = ProceduralAudio.create_terminal_keypress_sound()
			_blip_player.pitch_scale = randf_range(0.98, 1.02)
			_blip_player.play()
		elif line.get("is_stage_direction", false):
			_blip_player.stream = ProceduralAudio.create_ucp_stabilizer_beam_sound()
			_blip_player.pitch_scale = 1.0
			_blip_player.play()


func _check_unlock_conditions() -> void:
	# Unlock underpass security exit gate once safety demonstrated & terminal verified
	if is_safety_demonstrated and terminal_inspected and not is_gate_unlocked:
		is_gate_unlocked = true
		underpass_gate_unlocked.emit()
		if _door_player:
			_door_player.play()

		if props:
			var gate_prop := props.get_node_or_null("UnderpassExitGate") as MemoryResonancePoint
			if gate_prop:
				gate_prop.is_activated = true

		queue_redraw()


func _on_airlock_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and not is_level_completed:
		is_level_completed = true
		level_completed.emit()


func _draw() -> void:
	# Vector-Stage state pass (D-096). The underpass frame belongs to
	# VectorStageEnvironment (station_number = 12); this pass only moves the
	# plane relations that carry state (VISUAL_DESIGN.md §2, §3.2). The contested
	# stair flight is playable geometry and draws itself.
	_draw_state_layer()
	_draw_people()
	if dialogue_active:
		_draw_dialogue_overlay()


func _draw_state_layer() -> void:
	# Relation 1 — the other version of the descent. It is drawn as a second set
	# of the same treads, offset, so the disagreement is visible before anyone
	# steps into it (#observed-discontinuity).
	if not is_stabilization_active:
		var breath := 0.16 + 0.08 * sin(_pulse_time * 1.6)
		var offset := Vector2(16.0, 9.0)
		var ghost_treads: Array[Rect2] = [
			Rect2(40.0, 200.0, 60.0, 12.0),
			Rect2(114.0, 220.0, 26.0, 20.0),
			Rect2(89.0, 240.0, 26.0, 20.0),
			Rect2(64.0, 260.0, 26.0, 20.0),
		]
		for tread in ghost_treads:
			VectorStageStyle.draw_facet_polygon(
				self,
				PackedVector2Array([
					tread.position + offset,
					tread.position + offset + Vector2(tread.size.x, 0.0),
					tread.position + offset + tread.size,
					tread.position + offset + Vector2(0.0, tread.size.y),
				]),
				Color(VectorStageStyle.CORRECTION_OXIDE, breath),
				1.0
			)

	# The route sits on top of the version that lost. VISUAL_DESIGN.md §7.4 and
	# the obstacle canon both require the traversable way to hold the highest
	# contrast, so it is drawn from the colliders that actually carry it.
	VectorStageStyle.draw_play_plane(self, geometry)

	# Relation 2 — an announced consensus pass. The oxide edge crosses the
	# stairwell before it lands, so the danger is legible while still harmless
	# (kanon przeszkód §5.2).
	if _correction_warning > 0.0:
		var warn := 1.0 - clampf(_correction_warning / CORRECTION_WARNING, 0.0, 1.0)
		draw_line(
			Vector2(30.0, 176.0),
			Vector2(30.0 + 160.0 * warn, 176.0),
			Color(VectorStageStyle.CORRECTION_OXIDE, 0.35 + 0.45 * warn),
			2.0
		)

	# Relation 3 — the UCP field, once the warden can finally stabilise the
	# passage. A practical beam along the flight, not a screen wash.
	if is_stabilization_active:
		var reach := clampf(_stabilizer_beam_progress, 0.0, 1.0)
		draw_line(
			Vector2(40.0, 278.0),
			Vector2(40.0 + 128.0 * reach, 278.0 - 100.0 * reach),
			Color(VectorStageStyle.ANCHOR_CYAN, 0.28 + 0.30 * reach),
			2.0
		)

	# Relation 4 — what the space took. Where the child was corrected, the trace
	# of use on the tiles is simply gone: an over-smooth plane with no wear.
	if child_correction_count > 0:
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(196.0, 274.0),
				Vector2(268.0, 272.0),
				Vector2(272.0, 292.0),
				Vector2(192.0, 294.0),
			]),
			VectorStageStyle.shade(VectorStageStyle.CORRECTION_OXIDE, 0.34),
			1.0
		)

	# Relation 5 — the exit reads as an opening light plane.
	if _gate_open_progress > 0.0:
		var opening := 6.0 + _gate_open_progress * 20.0
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(604.0 - opening, 196.0),
				Vector2(604.0 + opening, 196.0),
				Vector2(604.0 + opening, 288.0),
				Vector2(604.0 - opening, 288.0),
			]),
			VectorStageStyle.LIGHT_PLANE,
			1.0
		)


func _draw_people() -> void:
	# Two silhouettes, read by value and pose before detail
	# (#silhouette-before-detail). Neither is decoration: the warden is doing his
	# job, the child is the reason the route has to hold.
	var warden_x := 165.0
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(warden_x - 6.0, 250.0),
			Vector2(warden_x + 6.0, 250.0),
			Vector2(warden_x + 5.0, 280.0),
			Vector2(warden_x - 5.0, 280.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0
	)
	draw_circle(Vector2(warden_x, 245.0), 4.0, VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	# The stabiliser wand only reads cyan while it is actually holding something.
	draw_line(
		Vector2(warden_x - 6.0, 258.0),
		Vector2(warden_x - 17.0, 251.0),
		VectorStageStyle.LIGHT_PLANE if not is_stabilization_active else VectorStageStyle.ANCHOR_CYAN,
		1.5
	)

	var cx := _child_pos_x
	var cy := _child_pos_y
	# The child is the only warm plane on the stairs. If the space corrected the
	# child, the same plane loses its warmth and keeps its shape.
	var coat := VectorStageStyle.HUMAN_AMBER
	if is_child_corrected:
		coat = VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.28)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(cx - 4.0, cy - 14.0),
			Vector2(cx + 4.0, cy - 14.0),
			Vector2(cx + 3.0, cy),
			Vector2(cx - 3.0, cy),
		]),
		coat,
		1.0
	)
	draw_circle(Vector2(cx, cy - 17.0), 3.0, VectorStageStyle.shade(coat, 0.24))

	# The child waiting at the break: a held pose, not a flashing marker.
	if _child_stage == ChildStage.BLOCKED:
		draw_line(
			Vector2(cx + 6.0, cy - 20.0),
			Vector2(cx + 6.0, cy - 8.0),
			Color(VectorStageStyle.CORRECTION_OXIDE, 0.40 + 0.35 * sin(_pulse_time * 3.0)),
			1.5
		)


func _draw_dialogue_overlay() -> void:
	if dialogue_index < 0 or dialogue_index >= dialogue_lines.size():
		return

	var line := dialogue_lines[dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_lena: bool = line.get("is_lena", false)
	var is_terminal: bool = line.get("is_terminal", false)
	var is_stage: bool = line.get("is_stage_direction", false)

	var box_y := 16.0
	var box_rect := Rect2(60.0, box_y, LEVEL_WIDTH - 120.0, 52.0)

	# Institutional dialogue substrate
	draw_rect(box_rect, Color(0.09, 0.13, 0.16, 0.92))
	var border_col := COLOR_CYAN if is_terminal else (COLOR_AMBER if is_lena else (COLOR_CORRECTION if is_stage else COLOR_INFRASTRUCTURE))
	draw_rect(box_rect, border_col, false, 1.2)

	# Speaker Badge
	var badge_rect := Rect2(72.0, box_y - 8.0, 195.0, 14.0)
	draw_rect(badge_rect, Color("121b21"))
	draw_rect(badge_rect, border_col, false, 0.8)

	var font: Font = ThemeDB.fallback_font
	if font:
		draw_string(font, Vector2(76.0, box_y + 3.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, 190.0, 10, border_col)
		# Subtitle / Line text
		var text_col := Color("edf2ee") if not is_terminal else COLOR_CYAN
		draw_string(font, Vector2(74.0, box_y + 24.0), text, HORIZONTAL_ALIGNMENT_LEFT, LEVEL_WIDTH - 120.0, 9, text_col)
		# Advance hint
		var prompt_str := "[SPACJA / E: DALEJ]"
		draw_string(font, Vector2(LEVEL_WIDTH - 170.0, box_y + 44.0), prompt_str, HORIZONTAL_ALIGNMENT_RIGHT, 100.0, 9, COLOR_INFRASTRUCTURE * 0.7)
