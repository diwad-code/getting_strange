class_name NarrativeGuidanceService
extends Node

## NarrativeGuidanceService — deterministyczny serwis prowadzenia narracyjnego (3.0)
## Zgodny ze specyfikacją docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md oraz kanonem 0.3
##
## Zasady:
## 1. Cooldown minimum 8.0 sekund między automatycznymi myślami.
## 2. Jedna myśl naraz.
## 3. Prawdziwy postęp w scenie resetuje timer utknięcia i zamyka bieżącą myśl.
## 4. Aktywny dialog CRT lub pauza wstrzymują system prowadzenia.
## 5. Jednorazowość beatów (brak powtórki bez zmiany stanu).
## 6. Zamknięte hipotezy dezaktywują przypisane do nich omylne myśli.

const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

signal thought_requested(beat: GuidanceBeat, text: String)
signal thought_dismissed()
signal hypothesis_closed(hypothesis_id: StringName)

const MIN_COOLDOWN_S: float = 8.0

var active_beats: Dictionary = {} # StringName -> GuidanceBeat
var triggered_beats: Dictionary = {} # StringName -> bool
var superseded_beats: Dictionary = {} # StringName -> bool
var closed_hypotheses: Dictionary = {} # StringName -> bool

var time_since_progress: float = 0.0
var cooldown_remaining: float = 0.0
var dialogue_active: bool = false
var is_active: bool = true
var current_beat: GuidanceBeat = null
var _dialogue_surface: CanvasLayer
var _dialogue_surface_resolved: bool = false
var _dialogue_active_manual: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


## The inner voice and the CRT dialogue box are two different speakers and must
## never share the frame. Only two stations set `dialogue_active` by hand, so the
## service also reads the station's dialogue surface directly (PKG-0136). This
## keeps the top band free while CinematicCamera holds its dialogue framing.
func _sync_dialogue_state() -> void:
	if not _dialogue_surface_resolved:
		_dialogue_surface_resolved = true
		var station := get_parent()
		if station != null:
			for child in station.get_children():
				if child is CanvasLayer and child.has_method("is_presenting"):
					_dialogue_surface = child as CanvasLayer
					break
	if _dialogue_surface == null or not is_instance_valid(_dialogue_surface):
		return
	if bool(_dialogue_surface.call("is_presenting")):
		# Set the flag directly: routing through set_dialogue_active() would mark
		# the suppression as manual and block the automatic release below.
		if not dialogue_active:
			dialogue_active = true
			if current_beat != null:
				dismiss_thought()
	elif dialogue_active and not _dialogue_active_manual:
		dialogue_active = false


func _process(delta: float) -> void:
	_sync_dialogue_state()
	if not is_active or get_tree().paused or dialogue_active:
		return
	
	if cooldown_remaining > 0.0:
		cooldown_remaining = maxf(0.0, cooldown_remaining - delta)
	
	time_since_progress += delta
	
	# Check automatic time-based stall beats
	if cooldown_remaining <= 0.0 and current_beat == null:
		_evaluate_stall_triggers()


func register_beat(beat: GuidanceBeat) -> void:
	if beat == null or beat.beat_id.is_empty():
		return
	active_beats[beat.beat_id] = beat


func trigger_beat(beat_id: StringName, force: bool = false) -> bool:
	if not active_beats.has(beat_id):
		return false
	
	var beat: GuidanceBeat = active_beats[beat_id]
	if not force:
		if superseded_beats.get(beat_id, false):
			return false
		if not beat.hypothesis_id.is_empty() and closed_hypotheses.get(beat.hypothesis_id, false):
			return false
		if beat.once_per_state and triggered_beats.get(beat_id, false):
			return false
		if cooldown_remaining > 0.0:
			return false
		if dialogue_active or get_tree().paused:
			return false
	
	# Mark superseded
	if not beat.supersedes.is_empty():
		superseded_beats[beat.supersedes] = true
	
	triggered_beats[beat_id] = true
	current_beat = beat
	cooldown_remaining = maxf(MIN_COOLDOWN_S, beat.cooldown_s)
	
	var game_state := get_node_or_null("/root/GameStateManager")
	var locale := "pl"
	if game_state and game_state.has_method("get_locale"):
		locale = game_state.get_locale()
	elif LocalizationManager:
		locale = LocalizationManager.current_locale
	
	var text := beat.get_localized_text(locale)
	thought_requested.emit(beat, text)
	return true


func dismiss_thought() -> void:
	if current_beat != null:
		current_beat = null
		thought_dismissed.emit()


func report_progress(_progress_id: StringName = &"") -> void:
	time_since_progress = 0.0
	dismiss_thought()


func report_failed_attempt(_attempt_id: StringName = &"") -> void:
	# A failed attempt accelerates directional guidance if appropriate
	time_since_progress += 10.0


func close_hypothesis(hyp_id: StringName) -> void:
	if hyp_id.is_empty():
		return
	closed_hypotheses[hyp_id] = true
	hypothesis_closed.emit(hyp_id)
	if current_beat and current_beat.hypothesis_id == hyp_id:
		dismiss_thought()


func set_dialogue_active(active: bool) -> void:
	_dialogue_active_manual = active
	dialogue_active = active
	if active and current_beat != null:
		dismiss_thought()


func reset_for_scene(_scene_id: StringName) -> void:
	active_beats.clear()
	triggered_beats.clear()
	superseded_beats.clear()
	closed_hypotheses.clear()
	time_since_progress = 0.0
	cooldown_remaining = 0.0
	current_beat = null
	dialogue_active = false
	_dialogue_active_manual = false


func _evaluate_stall_triggers() -> void:
	# Evaluate L2 contextual thought if stalled >= 20.0s
	# Evaluate L3 directional thought if stalled >= 45.0s
	for beat_id in active_beats:
		var beat: GuidanceBeat = active_beats[beat_id]
		if triggered_beats.get(beat_id, false) or superseded_beats.get(beat_id, false):
			continue
		if not beat.hypothesis_id.is_empty() and closed_hypotheses.get(beat.hypothesis_id, false):
			continue
		
		if beat.tier == GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT and time_since_progress >= 20.0:
			trigger_beat(beat_id)
			return
		elif beat.tier == GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT and time_since_progress >= 45.0:
			trigger_beat(beat_id)
			return

