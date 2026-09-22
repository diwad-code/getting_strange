class_name Station14
extends Node2D

## Station 14 (Przestrzeń 14: Zakotwiczenie / Schowek techniczny, rysa w metalu i degradacja nagrania) for Getting Strange Vertical Slice.
## Represents the cramped technical closet / maintenance chamber behind apartment 14's wall.
## Features shifting structural frames, maintenance tool racks, an observed scratch in the steel column acting
## as the primary anchor, a hydraulic seam stabilizer lever, an archival reel tape player exhibiting voice degradation,
## the 3rd-second silence clue proving Lena's home branch was previously corrected (Clue R-04/R-05), and the Substructure conduit shaft.
## Conforms to VISUAL_DESIGN.md (Section 6.1 Zakotwiczenie, Cyan holds one edge), FULL_STORY.md (Scene 14), and CONTINUITY_TRACKER.md (Clues R-04 and R-05).
##
## PRZESZKODA — dlaczego to tu jest: schowek techniczny istnieje w dwóch wersjach montażu i
## panel serwisowy z rysą jest w jednej z nich przykręcony jako stopień pod wlotem szybu, a w
## drugiej złożony płasko na ścianie bagażnika instalacyjnego.
## PRZESZKODA — czego wymaga od Leny: zauważyć jeden konkretny szczegół powierzchni, utrzymać go
## przy sobie mimo przejścia uzgodnienia i dopiero potem wspiąć się do szybu.
## PRZESZKODA — koszt porażki: głos Jakuba na archiwalnej taśmie traci wyrazistość na stałe;
## przedmiot użyty jako kotwica oddaje część prywatnego znaczenia (FULL_STORY.md, scena 14).

const VIEW_SIZE := Vector2(640.0, 360.0)
const LEVEL_WIDTH := 640.0

const COLOR_BACKGROUND := Color("141c21") # Dark sea graphite
const COLOR_CHAMBER_WALL := Color("192329")
const COLOR_INFRASTRUCTURE := Color("a8b2ac") # Grey sage
const COLOR_AMBER := Color("d39a62") # Muted amber (Lena / Warmth)
const COLOR_CYAN := Color("75c7c3") # Cool cyan (Anchor Resonance / "cyjan zatrzymuje jedną krawędź")
const COLOR_CORRECTION := Color("c65d58") # Oxide cinnabar (Seam tension / Discontinuity)
const COLOR_DARK_STEEL := Color("24333b")
const COLOR_CONCRETE := Color("202a30")
const COLOR_BEAM_FRAME := Color("2c3c46")

## Seconds the space announces an approaching consensus pass before it lands.
## The threat must be readable while it is still harmless (kanon przeszkód §5.2).
const CORRECTION_WARNING := 2.5
## How much of Jakub's recorded voice survives one anchoring (FULL_STORY.md, scene 14).
const ANCHOR_VOICE_COST := 0.55

signal clue_inspected(id: String, prop_type: int)
signal station_entered()
signal rack_searched()
signal scratch_anchored()
signal seam_clamped()
signal tape_playback_started()
signal silence_gap_discovered()
signal substructure_shaft_unlocked()
signal dialogue_started()
signal dialogue_advanced(line_idx: int)
signal dialogue_completed()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var scored_panel: AnchorableObject = get_node_or_null("Geometry/ScoredMetalPanel") as AnchorableObject

var rack_inspected: bool = false
var is_scratch_anchored: bool = false
var is_seam_clamped: bool = false
var is_tape_playing: bool = false
var is_silence_discovered: bool = false
var is_shaft_unlocked: bool = false
var is_level_completed: bool = false

var dialogue_active: bool = false
var dialogue_index: int = -1
var is_dialogue_completed: bool = false

var _seam_drift_phase: float = 0.0
var _anchor_glow_progress: float = 0.0
var _tape_progress: float = 0.0
var _shaft_open_progress: float = 0.0
var _pulse_time: float = 0.0
var _correction_warning: float = 0.0
var _correction_passes: int = 0

## Remaining clarity of Jakub's voice on the archival reel. Anchoring spends it.
var tape_voice_clarity: float = 1.0
var is_panel_anchored: bool = false
var is_anchor_cost_paid: bool = false

# Dialogue & Narrative Readouts for Space 14 (per FULL_STORY.md Scene 14, CONTINUITY_TRACKER.md R-04/R-05, NEXT_SESSION_PROMPT.md)
var dialogue_lines: Array[Dictionary] = [
	{
		"speaker": "LENA",
		"text": "Schowek techniczny za ścianą czternastki... Przestrzeń jest niestabilna. Dwie wersje konstrukcji nakładają się na siebie.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "MARTA",
		"text": "To szew konstrukcyjny. Jeśli nie utrzymasz jednego stałego punktu, ściana przesunie się i odetnie szyb.",
		"is_witness": false,
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Trzymanie szwu... Muszę skupić uwagę na jednym fizycznym detalu. Ta rysa na stalowej belce — pojedyncza bruzda w metalu.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Obserwujesz rysę w metalu. Krawędź rozbłyskuje chłodnym cyjanem. Drżenie konstrukcji zwalnia, gdy reszta pomieszczenia dopasowuje się do kotwicy.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "MARTA",
		"text": "Działa. Trzymasz szew. W dokumentach UCP nazywają to Zakotwiczeniem.",
		"is_witness": false,
		"is_lena": false,
		"is_marta": true,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Kotwica utrzymała geometrię, ale... coś się zmieniło. Taśma w odtwarzaczu. Nagranie głosu Jakuba.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Uruchamiasz odtwarzacz taśmowy. Głos brata jest przytłumiony, jakby oddalił się o kilkanaście lat.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Głos uległ degradacji... Użycie kotwicy niszczy prywatne znaczenie przedmiotu. Szukam miejsca, w którym taśma ucierpiała...",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Odsłuchujesz taśmę od początku. W trzeciej sekundzie pojawia się nagła, idealna cisza.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	},
	{
		"speaker": "LENA",
		"text": "Ta cisza w trzeciej sekundzie... To nie dzisiejsza kotwica. To nagranie zawsze miało tę przerwę.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "LENA",
		"text": "Mój świat... moja gałąź także nosiła ślady korekty na długo przed moim przybyciem. Nie ma pierwotnego oryginału.",
		"is_witness": false,
		"is_lena": true,
		"is_marta": false,
		"is_stage_direction": false
	},
	{
		"speaker": "ŚWIADECTWO PAMIĘCI",
		"text": "Stabilizator szwu rygluje się. Właz pionowego szybu do Podstruktury staje otworem.",
		"is_witness": true,
		"is_lena": false,
		"is_marta": false,
		"is_stage_direction": true
	}
]


func _ready() -> void:
	if camera:
		camera.chamber_bounds = [Rect2(Vector2.ZERO, VIEW_SIZE)]
		camera.set_chamber(0, true)
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_zone_body_entered)
	
	_connect_prop_signals()
	_connect_scored_panel()
	station_entered.emit()
	queue_redraw()


func _connect_scored_panel() -> void:
	if scored_panel == null:
		return
	scored_panel.anchor_state_changed.connect(_on_scored_panel_anchor_changed)
	# The bay starts in the version where the panel is bolted down as a step.
	scored_panel.apply_reality_shift(AnchorableObject.RealityState.STATE_A, false)


func _physics_process(_delta: float) -> void:
	if scored_panel and is_instance_valid(player):
		scored_panel.update_player_distance(player.global_position)


func _connect_prop_signals() -> void:
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			child.resonance_triggered.connect(_on_prop_resonance_triggered)


func _process(delta: float) -> void:
	_pulse_time += delta
	
	# Seam drift oscillation when unanchored vs locked
	if not is_scratch_anchored:
		_seam_drift_phase += delta * 3.5
	else:
		_seam_drift_phase = lerpf(_seam_drift_phase, 0.0, delta * 4.0)
		_anchor_glow_progress = minf(1.0, _anchor_glow_progress + delta * 2.0)
	
	# Tape playback progress
	if is_tape_playing and _tape_progress < 1.0:
		_tape_progress = minf(1.0, _tape_progress + delta * 0.45)
		if _tape_progress >= 0.5 and not is_silence_discovered:
			is_silence_discovered = true
			silence_gap_discovered.emit()
	
	# An announced consensus pass. It runs on the space's own schedule once the
	# recording has drawn attention to the seam; it never waits for the player.
	if _correction_warning > 0.0:
		_correction_warning = maxf(0.0, _correction_warning - delta)
		if _correction_warning <= 0.0:
			run_correction_pass()

	# Substructure shaft unlock animation
	if is_shaft_unlocked and _shaft_open_progress < 1.0:
		_shaft_open_progress = minf(1.0, _shaft_open_progress + delta * 1.4)
	
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		if dialogue_active:
			advance_dialogue()
		else:
			_check_player_interactions()


func _check_player_interactions() -> void:
	# Holding the scored panel takes precedence: it is the thing Lena is looking at.
	if scored_panel and scored_panel.is_player_in_range:
		scored_panel.toggle_anchor()
		return
	if not props:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint and child.is_player_in_range:
			child.trigger_interaction()
			break


func _on_prop_resonance_triggered(id: String, type_idx: int) -> void:
	clue_inspected.emit(id, type_idx)
	
	if id == "prop_maintenance_rack":
		rack_inspected = true
		rack_searched.emit()
		if not dialogue_active and dialogue_index < 0:
			start_dialogue(0)
	elif id == "prop_scratch_beam":
		anchor_scratch()
	elif id == "prop_seam_lever":
		toggle_seam_stabilizer()
	elif id == "prop_tape_deck":
		start_tape_playback()
	elif id == "prop_conduit_shaft":
		if is_shaft_unlocked:
			complete_level()


func anchor_scratch() -> void:
	if is_scratch_anchored:
		return
	is_scratch_anchored = true
	scratch_anchored.emit()
	
	var beam_prop := props.get_node_or_null("MetalScratchBeam") as MemoryResonancePoint
	if beam_prop:
		beam_prop.is_activated = true
		beam_prop.shadow_progress = 1.0
	
	if camera:
		camera.add_trauma(0.35)
	
	if not dialogue_active or dialogue_index < 2:
		start_dialogue(2)


func toggle_seam_stabilizer() -> void:
	is_seam_clamped = not is_seam_clamped
	seam_clamped.emit()
	
	var lever_prop := props.get_node_or_null("SeamStabilizerLever") as MemoryResonancePoint
	if lever_prop:
		lever_prop.is_activated = is_seam_clamped

	# The hydraulic clamp re-seats the bay in its service version, so the step is
	# back and no attempt is ever lost for good.
	if is_seam_clamped:
		restore_service_version()

	# If scratch is anchored and lever is engaged, unlock the conduit shaft
	if is_scratch_anchored and is_seam_clamped:
		unlock_substructure_shaft()


func start_tape_playback() -> void:
	if is_tape_playing:
		return
	is_tape_playing = true
	tape_playback_started.emit()
	
	var tape_prop := props.get_node_or_null("TapePlaybackDeck") as MemoryResonancePoint
	if tape_prop:
		tape_prop.is_activated = true

	# The reel draws the bay's attention to its own seam. Consensus announces
	# itself and then arrives; nothing here is timed to a jump.
	announce_correction_pass()

	if not dialogue_active or dialogue_index < 5:
		start_dialogue(5)


## Starts the readable warning window before the next consensus pass.
func announce_correction_pass() -> void:
	if _correction_warning > 0.0:
		return
	_correction_warning = CORRECTION_WARNING


## Applies one consensus pass to the bay. A held panel resists and the step
## survives; an unheld panel is re-mounted flat against the wall and the way up
## is simply not there any more.
func run_correction_pass() -> void:
	_correction_warning = 0.0
	_correction_passes += 1
	if scored_panel == null:
		return
	var target := (
		AnchorableObject.RealityState.STATE_B
		if scored_panel.current_reality == AnchorableObject.RealityState.STATE_A
		else AnchorableObject.RealityState.STATE_A
	)
	scored_panel.apply_reality_shift(target, true)
	if camera:
		camera.add_trauma(0.18)
	queue_redraw()


## Re-seats the bay in the version where the panel is bolted down as a step.
## This is the in-world undo: the hydraulic lever is what a maintenance worker
## would reach for, so failure never costs the player a restart.
func restore_service_version() -> void:
	if scored_panel == null:
		return
	scored_panel.apply_reality_shift(AnchorableObject.RealityState.STATE_A, true)
	queue_redraw()


func _on_scored_panel_anchor_changed(anchored: bool) -> void:
	is_panel_anchored = anchored
	if anchored:
		anchor_scratch()
		_apply_anchor_cost()
	queue_redraw()


## The cost of Zakotwiczenie. The object used as an anchor gives up part of its
## private meaning: Jakub's voice on the reel loses definition, permanently.
func _apply_anchor_cost() -> void:
	if is_anchor_cost_paid:
		return
	is_anchor_cost_paid = true
	tape_voice_clarity = maxf(0.0, tape_voice_clarity - ANCHOR_VOICE_COST)

	var state_manager := get_node_or_null("/root/GameStateManager")
	if state_manager and state_manager.has_method("record_decision"):
		state_manager.record_decision(&"station_14_anchored_scored_panel", true)
		state_manager.record_decision(&"station_14_tape_voice_clarity", tape_voice_clarity)

	if props:
		var tape_prop := props.get_node_or_null("TapePlaybackDeck") as MemoryResonancePoint
		if tape_prop:
			tape_prop.prop_subtitle = "Nagranie Jakuba — głos mniej wyraźny"
	queue_redraw()


func unlock_substructure_shaft() -> void:
	if is_shaft_unlocked:
		return
	is_shaft_unlocked = true
	substructure_shaft_unlocked.emit()
	
	var shaft_prop := props.get_node_or_null("SubstructureConduitShaft") as MemoryResonancePoint
	if shaft_prop:
		shaft_prop.is_activated = true


func start_dialogue(start_idx: int = 0) -> void:
	dialogue_active = true
	dialogue_index = start_idx
	dialogue_started.emit()
	queue_redraw()


func advance_dialogue() -> int:
	if not dialogue_active:
		return -1
	
	dialogue_index += 1
	
	# Narrative progression triggers tied to dialogue beats
	if dialogue_index == 3:
		# Observation of scratch locks anchor
		if not is_scratch_anchored:
			is_scratch_anchored = true
			scratch_anchored.emit()
			var beam_prop := props.get_node_or_null("MetalScratchBeam") as MemoryResonancePoint
			if beam_prop:
				beam_prop.is_activated = true
				beam_prop.shadow_progress = 1.0
			if camera:
				camera.add_trauma(0.35)
	elif dialogue_index == 6:
		# Tape starts playback and degradation is noticed
		if not is_tape_playing:
			is_tape_playing = true
			tape_playback_started.emit()
			var tape_prop := props.get_node_or_null("TapePlaybackDeck") as MemoryResonancePoint
			if tape_prop:
				tape_prop.is_activated = true
	elif dialogue_index == 9:
		# 3rd-second silence discovered
		is_silence_discovered = true
		silence_gap_discovered.emit()
	elif dialogue_index == 11:
		# Final realization: unlock the conduit shaft
		is_seam_clamped = true
		var lever_prop := props.get_node_or_null("SeamStabilizerLever") as MemoryResonancePoint
		if lever_prop:
			lever_prop.is_activated = true
		unlock_substructure_shaft()
	
	if dialogue_index >= dialogue_lines.size():
		dialogue_active = false
		is_dialogue_completed = true
		dialogue_completed.emit()
		queue_redraw()
		return -1
	
	dialogue_advanced.emit(dialogue_index)
	queue_redraw()
	return dialogue_index


func complete_level() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _on_airlock_zone_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_shaft_unlocked:
		complete_level()


func _draw() -> void:
	# Vector-Stage state pass (D-096). The service-closet frame belongs to
	# VectorStageEnvironment (station_number = 14); this pass only moves the
	# plane relations that carry state (VISUAL_DESIGN.md §2, §3.2). The scored
	# panel is playable geometry and draws itself.
	_draw_state_layer()

	if dialogue_active and dialogue_index >= 0 and dialogue_index < dialogue_lines.size():
		_draw_dialogue_box()


func _draw_state_layer() -> void:
	# The route first. VISUAL_DESIGN.md §7.4 and the obstacle canon both require
	# the traversable way to hold the highest contrast in the frame, so it is
	# drawn from the colliders that actually carry it.
	VectorStageStyle.draw_play_plane(self, geometry)

	# Relation 1 — the seam. Unheld, the two versions of the bay disagree and the
	# oxide edge drifts. Held, the same edge stops moving and turns cyan: one
	# observed detail stays Lena's own (VISUAL_DESIGN.md §6.1, Zakotwiczenie).
	var drift := sin(_seam_drift_phase) * 4.0
	var seam_top := Vector2(268.0, 96.0)
	var seam_bottom := Vector2(268.0 + drift, 272.0)
	if is_scratch_anchored:
		var hold := clampf(_anchor_glow_progress, 0.0, 1.0)
		draw_line(seam_top, seam_bottom, Color(VectorStageStyle.ANCHOR_CYAN, 0.34 + 0.30 * hold), 2.0)
	else:
		draw_line(
			seam_top,
			seam_bottom,
			Color(VectorStageStyle.CORRECTION_OXIDE, 0.44 + 0.26 * absf(sin(_seam_drift_phase * 0.5))),
			2.0
		)

	# Relation 2 — the correction pass announcing itself before it arrives.
	# The threat is readable while it is still harmless (kanon przeszkód §5.2).
	if _correction_warning > 0.0:
		var warn := clampf(_correction_warning / CORRECTION_WARNING, 0.0, 1.0)
		draw_line(
			Vector2(496.0, 52.0),
			Vector2(496.0, 278.0),
			Color(VectorStageStyle.CORRECTION_OXIDE, 0.20 + 0.55 * (1.0 - warn)),
			2.0
		)

	# Relation 3 — the recording. The amber plane is Jakub's voice on the tape;
	# anchoring costs part of it, and the plane loses value permanently.
	if is_tape_playing:
		var reel := clampf(_tape_progress, 0.0, 1.0)
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(438.0, 244.0),
				Vector2(438.0 + 64.0 * reel, 242.0),
				Vector2(438.0 + 64.0 * reel, 254.0),
				Vector2(438.0, 256.0),
			]),
			Color(VectorStageStyle.HUMAN_AMBER, 0.30 + 0.55 * tape_voice_clarity),
			1.0
		)
		# The third-second silence: a gap Lena decides was always there.
		if is_silence_discovered:
			draw_line(
				Vector2(452.0, 240.0),
				Vector2(452.0, 258.0),
				Color(VectorStageStyle.INK, 0.85),
				2.0
			)

	# Relation 4 — the conduit shaft opening as a light plane.
	if _shaft_open_progress > 0.0:
		var opening := 4.0 + _shaft_open_progress * 18.0
		VectorStageStyle.draw_facet_polygon(
			self,
			PackedVector2Array([
				Vector2(590.0 - opening, 208.0),
				Vector2(590.0 + opening, 208.0),
				Vector2(590.0 + opening, 268.0),
				Vector2(590.0 - opening, 268.0),
			]),
			VectorStageStyle.LIGHT_PLANE,
			1.0
		)


func _draw_dialogue_box() -> void:
	var line: Dictionary = dialogue_lines[dialogue_index]
	var speaker: String = line.get("speaker", "")
	var text: String = line.get("text", "")
	var is_witness: bool = line.get("is_witness", false)
	var is_lena: bool = line.get("is_lena", false)
	var is_marta: bool = line.get("is_marta", false)
	var is_stage_direction: bool = line.get("is_stage_direction", false)
	
	var box_rect := Rect2(60.0, 280.0, 520.0, 68.0)
	draw_rect(box_rect, Color(0.07, 0.11, 0.14, 0.95))
	
	# Border color
	var border_color := COLOR_INFRASTRUCTURE
	if is_witness:
		border_color = COLOR_CORRECTION
	elif is_lena:
		border_color = COLOR_AMBER
	elif is_marta:
		border_color = COLOR_CYAN
	
	draw_rect(box_rect, border_color, false, 1.2)
	
	# Header bar with speaker name
	var header_rect := Rect2(60.0, 280.0, 520.0, 18.0)
	draw_rect(header_rect, Color(0.11, 0.16, 0.20, 0.96))
	draw_line(Vector2(60.0, 298.0), Vector2(580.0, 298.0), border_color * 0.7, 1.0)
	
	# Speaker tag
	var default_font := ThemeDB.fallback_font
	if default_font:
		var speaker_col := COLOR_AMBER if is_lena else (COLOR_CYAN if is_marta else (COLOR_CORRECTION if is_witness else COLOR_INFRASTRUCTURE))
		draw_string(default_font, Vector2(72.0, 294.0), speaker, HORIZONTAL_ALIGNMENT_LEFT, -1, 11, speaker_col)
		
		# Text content
		var text_col := Color("e6ece8") if not is_stage_direction else Color("a2b5ac")
		draw_string(default_font, Vector2(72.0, 314.0), text, HORIZONTAL_ALIGNMENT_LEFT, 496, 11, text_col)
		
		# Next prompt indicator
		var pulse := sin(_pulse_time * 4.0) * 0.5 + 0.5
		var prompt_str := "[E] Dalej..." if dialogue_index < dialogue_lines.size() - 1 else "[E] Zamknij"
		draw_string(default_font, Vector2(510.0, 340.0), prompt_str, HORIZONTAL_ALIGNMENT_RIGHT, -1, 9, Color(border_color.r, border_color.g, border_color.b, 0.5 + pulse * 0.5))
