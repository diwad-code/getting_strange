class_name Station20
extends Node2D

## Station 20 — S07, próba relacyjna.
## Jakub jest osobą z własną granicą, nie materiałem dowodowym. Odmawia
## pokazania blizny, a mimo tego sam otwiera lokalną bazę serwisową, do której
## ma zawodowy dostęp. Dopiero zestawienie numeru czytnika z tą bazą zamyka
## hipotezę oszusta.

## PRZESZKODA — dlaczego to tu jest: Warsztatowy wózek z częściami rozdziela przestrzeń rozmowy, a stół montażowy jest miejscem pracy Jakuba, nie stanowiskiem badania.
## PRZESZKODA — czego wymaga od Leny: odsunięcia wózka, rozmowy twarzą w twarz, przyjęcia odmowy pokazania blizny i zestawienia numeru czytnika z lokalną bazą.
## PRZESZKODA — koszt porażki: prośba o skan przed przyjęciem odmowy zostawia informację o naruszonej granicy i nie otwiera bazy serwisowej.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const FACT_S07_VOICE := &"p7.three_place_proofs.voice_trial_result"
const FACT_TROLLEY := &"p7.three_place_proofs.trolley_moved"
const FACT_WITNESS := &"p7.three_place_proofs.marta_witness_present"
const FACT_MET := &"p7.three_place_proofs.jakub_met"
const FACT_REFUSAL := &"p7.three_place_proofs.scar_refusal_respected"
const FACT_SCAN := &"p7.three_place_proofs.reader_scan_volunteered"
const FACT_TRIAL := &"p7.three_place_proofs.relational_trial_result"
const FACT_FEEDBACK := &"p7.three_place_proofs.safe_trial_feedback"

signal clue_inspected(id: String, prop_type: int)
signal scar_refusal_respected()
signal relational_trial_completed()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_trolley_moved := false
var is_marta_witness_present := false
var is_jakub_met := false
var is_scar_refusal_respected := false
var is_reader_scan_volunteered := false
var is_relational_trial_done := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s20_workshop_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s20_workshop_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Ciało żyje. Ma pracę, zmęczenie i własne granice.", "The body is alive. He has work, fatigue and his own boundaries.", &"", "")
	_register_beat(&"s20_evidence_reflex_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Odruchowo traktuję go jak materiał. Jego dostęp zawodowy jest lepszym testem.", "By reflex I treat him as material. His professional access is the better test.", &"impostor", "compare_local_service_base")
	_register_beat(&"s20_relational_trial", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Przyjmę odmowę, potem zestawię numer czytnika z lokalną bazą serwisową.", "Accept the refusal, then compare the reader number with the local service base.", &"", "compare_local_service_base")
	_register_beat(&"s20_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Wózek, Marta obok, rozmowa z Jakubem, stacja diagnostyczna, stół montażowy.", "HINT: Trolley, Marta nearby, talk with Jakub, diagnostic dock, workbench.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_20"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			if not prop.resonance_triggered.is_connected(_on_prop_resonance_triggered.bind(prop)):
				prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"parts_trolley":
			move_parts_trolley()
		"marta_presence":
			confirm_marta_presence()
		"jakub_presence":
			if not is_jakub_met:
				meet_jakub_face_to_face()
			else:
				accept_scar_refusal()
		"diagnostic_dock":
			request_voluntary_reader_scan()
		"workbench":
			compare_local_service_base()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func move_parts_trolley() -> bool:
	if is_trolley_moved:
		return false
	if not _has(FACT_S07_VOICE):
		_record_feedback(&"voice_trial_required")
		return false
	is_trolley_moved = true
	_record(FACT_TROLLEY, true)
	_report_progress(&"s20_trolley_moved")
	queue_redraw()
	return true


func confirm_marta_presence() -> bool:
	if is_marta_witness_present:
		return false
	if not is_trolley_moved:
		_record_feedback(&"trolley_required")
		return false
	is_marta_witness_present = true
	_record(FACT_WITNESS, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s20_workshop_contact")
	_report_progress(&"s20_marta_witness_present")
	queue_redraw()
	return true


func meet_jakub_face_to_face() -> bool:
	if is_jakub_met:
		return false
	if not is_marta_witness_present:
		_record_feedback(&"witness_required")
		return false
	is_jakub_met = true
	_record(FACT_MET, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s20_evidence_reflex_hypothesis")
	_report_progress(&"s20_jakub_met")
	queue_redraw()
	return true


## Granica Jakuba jest jego decyzją: Lena może poprosić, ale przyjęcie odmowy
## jest osobnym działaniem i warunkiem dalszej współpracy.
func accept_scar_refusal() -> bool:
	if is_scar_refusal_respected:
		return false
	if not is_jakub_met:
		_record_feedback(&"meeting_required")
		return false
	is_scar_refusal_respected = true
	_record(FACT_REFUSAL, "asked_and_declined")
	scar_refusal_respected.emit()
	_report_progress(&"s20_scar_refusal_respected")
	queue_redraw()
	return true


func request_voluntary_reader_scan() -> bool:
	if is_reader_scan_volunteered:
		return false
	if not is_scar_refusal_respected:
		_record_feedback(&"boundary_not_respected")
		return false
	is_reader_scan_volunteered = true
	_record(FACT_SCAN, "opened_by_jakub")
	_report_progress(&"s20_reader_scan_volunteered")
	queue_redraw()
	return true


func compare_local_service_base() -> bool:
	if is_relational_trial_done:
		return false
	if not (is_jakub_met and is_scar_refusal_respected and is_reader_scan_volunteered):
		_record_feedback(&"relational_sources_incomplete")
		return false
	is_relational_trial_done = true
	_record(FACT_TRIAL, "reader_absent_local_base")
	_record(&"jakub_met_as_person", true)
	_record(&"recognition_evidence_relational", true)
	_record(&"recognition_evidence_carried", true)
	relational_trial_completed.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"impostor")
		guidance_service.trigger_beat(&"s20_relational_trial")
	_report_progress(&"s20_relational_trial_done")
	_unlock_exit()
	queue_redraw()
	return true


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s20_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	call_deferred("_complete_if_player_already_in_airlock")


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_exit_unlocked:
		_trigger_level_completion()


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return false
	var value: Variant = state.decisions.get(key, null)
	if value == null:
		return false
	if value is String or value is StringName:
		return not String(value).is_empty()
	return bool(value)


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"parts_trolley": return is_trolley_moved
		"marta_presence": return is_marta_witness_present
		"jakub_presence": return is_scar_refusal_respected
		"diagnostic_dock": return is_reader_scan_volunteered
		"workbench": return is_relational_trial_done
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var trolley_color := VectorStageStyle.LIGHT_PLANE if is_trolley_moved else VectorStageStyle.HUMAN_AMBER
	var witness_color := VectorStageStyle.HUMAN_AMBER if is_marta_witness_present else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.5)
	var met_color := VectorStageStyle.CORRECTION_OXIDE if is_jakub_met else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.45)
	var refusal_color := VectorStageStyle.SEAM_RED if is_scar_refusal_respected else VectorStageStyle.shade(VectorStageStyle.SEAM_RED, 0.35)
	var scan_color := VectorStageStyle.ANCHOR_CYAN if is_reader_scan_volunteered else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35)
	var trial_color := VectorStageStyle.ANCHOR_CYAN if is_relational_trial_done else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.3)
	draw_rect(Rect2(Vector2(188.0, 250.0), Vector2(24.0, 16.0)), trolley_color, false, 1.0)
	draw_circle(Vector2(260.0, 248.0), 5.0, witness_color, false, 2.0)
	draw_circle(Vector2(320.0, 248.0), 6.0, met_color, false, 2.0)
	draw_line(Vector2(312.0, 262.0), Vector2(328.0, 262.0), refusal_color, 2.0)
	draw_rect(Rect2(Vector2(410.0, 244.0), Vector2(20.0, 16.0)), scan_color, false, 1.0)
	draw_rect(Rect2(Vector2(490.0, 246.0), Vector2(22.0, 14.0)), trial_color, true)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(584.0, 180.0), Vector2(584.0, 298.0), exit_color, 2.0)
