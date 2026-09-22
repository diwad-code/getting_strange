class_name Station18
extends Node2D

## Station 18 — P9, trzy prognozy metod, zestawienie zgód i braków, fizyczne
## zatwierdzenie jednej metody. Ulica z 05 po zmianie: otwarte niebo, fasady,
## witryna i latarnia. Lena zestawia trzy drogi z aktualnym zakresem zgody
## Jakuba, mówi Marcie prawdę albo jej część i zatwierdza jedną metodę.
## Pytanie, z którym gracz wychodzi: „którą metodę wykonuję — i czego mi w niej
## brakuje?".

## PRZESZKODA — dlaczego to tu jest: Tablica prognoz stoi na chodniku, bo
## trzy trasy rozchodzą się z tej samej ulicy; witryna Marty i słupek zatwierdzenia
## są tu, bo zgoda i koszt muszą być widoczne przed ruchem dalej.
## PRZESZKODA — czego wymaga od Leny: zestawienia trzech prognoz z aktualnymi
## zgodami, jawnego stanu prawdy przekazanej Marcie i fizycznego zatwierdzenia
## jednej metody.
## PRZESZKODA — koszt porażki: niepełne zestawienie albo brakująca zgoda zostawia
## fakt informacyjny i nie zamyka drogi; zatwierdzenie bez zestawienia nie
## powstaje.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")

const FACT_DONOR_TRACE := &"p7.work_history_and_record.trace"
const FACT_DONOR_LEDGER := &"p9.consent_and_cost.cost_ledger_read"
const FACT_DONOR_OFFER := &"p9.consent_and_cost.adaptation_offer"
const FACT_DONOR_SCOPE := &"p9.consent_and_cost.jakub_consent_scope"
const FACT_CANONICAL_SCOPE := &"jakub_consent_state"
const FACT_FORECASTS_COMPARED := &"p9.method_commitment.forecasts_compared"
const FACT_FORECASTS := &"p9.method_commitment.forecasts"
const FACT_CANONICAL_MAPPED := &"route_hypotheses_mapped"
const FACT_MARTA := &"p9.method_commitment.marta_truth_state"
const FACT_CANONICAL_MARTA := &"marta_truth_state"
const FACT_METHOD := &"p9.method_commitment.method_committed"
const FACT_CANONICAL_METHOD := &"method_committed"
const FACT_TRACE := &"p9.method_commitment.trace"
const FACT_FEEDBACK := &"p9.method_commitment.safe_trial_feedback"

const DONOR_TRACE_VALUE := "cost_ledger_and_consent_scope_recorded"
const DONOR_OFFER_VALUE := "rejected"
const TRACE_VALUE := "method_committed_after_forecast_and_consent_inventory"
const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"
const MARTA_FULL := &"full"
const MARTA_PARTIAL := &"partial"
const MARTA_WITHHELD := &"withheld"
const METHOD_FORCE_HOME := &"force_home"
const METHOD_CLOSE_EQUAL := &"close_equal_recover_local"
const METHOD_MUTUAL := &"mutual_passage"
const VALID_CONSENT_STATES: Array[String] = [SCOPE_GRANTED, SCOPE_LIMITED, SCOPE_REFUSED]

signal clue_inspected(id: String, prop_type: int)
signal forecasts_compared()
signal marta_truth_disclosed(truth_state: StringName)
signal method_committed(method_id: StringName)
signal operation_selected(operation: String)
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var are_forecasts_compared := false
var is_marta_truth_disclosed := false
var is_method_committed := false
var marta_truth_state: StringName = &""
var committed_method: StringName = &""
var jakub_consent_state := ""
var forecasts: Dictionary = {}
var is_exit_unlocked := false
var is_level_completed := false
var last_feedback: StringName = &""

var _lamp_phase := 0.0


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	jakub_consent_state = _read_jakub_consent()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_lamp_phase = fmod(_lamp_phase + delta, TAU)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s18_street_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s18_forecast_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Trzy drogi na jednej tablicy. Każda ma inną zależność od zgody Jakuba.", "Three routes on one board. Each depends differently on Jakub's consent.", &"", "")
	_register_beat(&"s18_single_route_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może wystarczy wybrać jedną i iść. Braki pokażą, czy to prawda.", "Maybe picking one and walking is enough. The gaps will show if that is true.", &"single_route_sufficient", "compare_forecast_consent_dependencies")
	_register_beat(&"s18_commit_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zestawię trzy prognozy, powiem Marcie prawdę albo jej część i zatwierdzę jedną metodę.", "Compare the three forecasts, tell Marta the truth or part of it, and commit one method.", &"", "commit_force_home")
	_register_beat(&"s18_method_recorded", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Metoda jest zatwierdzona tak, jak padła, z jawnymi brakami.", "The method is committed exactly as stated, with the gaps named.", &"", "")
	_register_beat(&"s18_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Tablica trzech prognoz, witryna Marty, słupek zatwierdzenia metody.", "HINT: Three-forecast board, Marta's window, method commit post.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_18"
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
		"forecast_comparator":
			compare_forecast_consent_dependencies()
		"marta_truth_table":
			choose_marta_truth_from_player_side()
		"method_commit_post":
			choose_method_from_player_side()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func compare_forecast_consent_dependencies() -> bool:
	if are_forecasts_compared:
		return false
	if not _has_donor_context():
		_record_feedback(&"consent_scope_required")
		return false
	jakub_consent_state = _read_jakub_consent()
	forecasts = _build_forecasts(jakub_consent_state)
	are_forecasts_compared = true
	_record(FACT_FORECASTS_COMPARED, true)
	_record(FACT_FORECASTS, forecasts)
	_record(FACT_CANONICAL_MAPPED, true)
	if guidance_service:
		guidance_service.close_hypothesis(&"single_route_sufficient")
		guidance_service.trigger_beat(&"s18_forecast_contact")
	_report_progress(&"s18_forecasts_compared")
	forecasts_compared.emit()
	queue_redraw()
	return true


func disclose_marta_truth_full() -> bool:
	return _commit_marta_truth(MARTA_FULL)


func disclose_marta_truth_partial() -> bool:
	return _commit_marta_truth(MARTA_PARTIAL)


func disclose_marta_truth_withheld() -> bool:
	return _commit_marta_truth(MARTA_WITHHELD)


func choose_marta_truth_from_player_side() -> bool:
	if is_marta_truth_disclosed:
		return false
	if props == null or player == null:
		_record_feedback(&"marta_table_missing")
		return false
	var table := props.get_node_or_null("MartaTruthTable") as Node2D
	if table == null:
		_record_feedback(&"marta_table_missing")
		return false
	var offset := player.global_position.x - table.global_position.x
	if offset < -24.0:
		return _commit_marta_truth(MARTA_WITHHELD)
	if offset > 24.0:
		return _commit_marta_truth(MARTA_FULL)
	return _commit_marta_truth(MARTA_PARTIAL)


func commit_force_home() -> bool:
	return _commit_method(METHOD_FORCE_HOME)


func commit_close_equal() -> bool:
	return _commit_method(METHOD_CLOSE_EQUAL)


func commit_mutual_passage() -> bool:
	return _commit_method(METHOD_MUTUAL)


func select_operation(op: String) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("select_finale_operation"):
		state.select_finale_operation(op)
	if not _has_donor_context():
		_record(FACT_DONOR_TRACE, DONOR_TRACE_VALUE)
		_record(FACT_DONOR_LEDGER, true)
		_record(FACT_DONOR_OFFER, DONOR_OFFER_VALUE)
		_record(FACT_CANONICAL_SCOPE, SCOPE_GRANTED)
		_record(FACT_DONOR_SCOPE, SCOPE_GRANTED)
	if not are_forecasts_compared:
		compare_forecast_consent_dependencies()
	if not is_marta_truth_disclosed:
		disclose_marta_truth_full()
	is_method_committed = false
	match op.to_upper():
		"A":
			commit_force_home()
		"B":
			commit_close_equal()
		"C":
			commit_mutual_passage()
	operation_selected.emit(op)


func choose_method_from_player_side() -> bool:
	if is_method_committed:
		return false
	if props == null or player == null:
		_record_feedback(&"commit_post_missing")
		return false
	var post := props.get_node_or_null("MethodCommitPost") as Node2D
	if post == null:
		_record_feedback(&"commit_post_missing")
		return false
	var offset := player.global_position.x - post.global_position.x
	if offset < -24.0:
		return _commit_method(METHOD_FORCE_HOME)
	if offset > 24.0:
		return _commit_method(METHOD_MUTUAL)
	return _commit_method(METHOD_CLOSE_EQUAL)


func _commit_marta_truth(truth_state: StringName) -> bool:
	if is_marta_truth_disclosed:
		return false
	if not are_forecasts_compared:
		_record_feedback(&"forecast_comparison_required")
		return false
	is_marta_truth_disclosed = true
	marta_truth_state = truth_state
	_record(FACT_MARTA, String(truth_state))
	_record(FACT_CANONICAL_MARTA, String(truth_state))
	if guidance_service:
		guidance_service.trigger_beat(&"s18_commit_plan")
	_report_progress(&"s18_marta_truth_disclosed")
	marta_truth_disclosed.emit(truth_state)
	queue_redraw()
	return true


func _commit_method(method_id: StringName) -> bool:
	if is_method_committed:
		return false
	if not are_forecasts_compared or not is_marta_truth_disclosed:
		if not are_forecasts_compared:
			_record_feedback(&"forecast_and_consent_inventory_required")
		else:
			_record_feedback(&"marta_truth_required")
		return false
	is_method_committed = true
	committed_method = method_id
	_record(FACT_METHOD, String(method_id))
	_record(FACT_CANONICAL_METHOD, String(method_id))
	var finale_id: StringName = &"station_42a"
	match method_id:
		METHOD_FORCE_HOME:
			finale_id = &"station_42a"
		METHOD_CLOSE_EQUAL:
			finale_id = &"station_42b"
		METHOD_MUTUAL:
			finale_id = &"station_42c"
	_record(&"campaign_finale", String(finale_id))
	_record(FACT_TRACE, TRACE_VALUE)
	if guidance_service:
		guidance_service.trigger_beat(&"s18_method_recorded")
	_report_progress(&"s18_method_committed")
	method_committed.emit(method_id)
	_unlock_exit()
	queue_redraw()
	return true


func _build_forecasts(consent: String) -> Dictionary:
	return {
		"force_home": _forecast_entry("force_home", "42A", ["granted"], consent),
		"close_equal_recover_local": _forecast_entry("close_equal_recover_local", "42B", ["granted", "limited"], consent),
		"mutual_passage": _forecast_entry("mutual_passage", "42C", ["granted"], consent),
	}


func _forecast_entry(route_id: String, finale: String, allowed: Array, consent: String) -> Dictionary:
	var available := allowed.has(consent)
	var gap := "" if available else "jakub_consent_missing"
	return {
		"route_id": route_id,
		"finale": finale,
		"consent_states": allowed,
		"available": available,
		"gap": gap,
	}


func _record_feedback(value: StringName) -> void:
	last_feedback = value
	_record(FACT_FEEDBACK, String(value))
	if guidance_service:
		guidance_service.report_failed_attempt(&"s18_" + value)


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


func _has_donor_context() -> bool:
	var trace_value := str(_read_decision(FACT_DONOR_TRACE))
	var offer_value := str(_read_decision(FACT_DONOR_OFFER))
	jakub_consent_state = _read_jakub_consent()
	return trace_value == DONOR_TRACE_VALUE \
		and _has(FACT_DONOR_LEDGER) \
		and offer_value == DONOR_OFFER_VALUE \
		and VALID_CONSENT_STATES.has(jakub_consent_state)


func _read_jakub_consent() -> String:
	var scoped := str(_read_decision(FACT_DONOR_SCOPE))
	if VALID_CONSENT_STATES.has(scoped):
		return scoped
	var canonical := str(_read_decision(FACT_CANONICAL_SCOPE))
	if VALID_CONSENT_STATES.has(canonical):
		return canonical
	return ""


func _has(key: StringName) -> bool:
	var value: Variant = _read_decision(key)
	if value == null:
		return false
	if value is String or value is StringName:
		return not String(value).is_empty()
	return bool(value)


func _read_decision(key: StringName) -> Variant:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return null
	return state.decisions.get(key, null)


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"forecast_comparator": return are_forecasts_compared
		"marta_truth_table": return is_marta_truth_disclosed
		"method_commit_post": return is_method_committed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	_draw_city_street()
	_draw_forecast_board()
	_draw_marta_window()
	_draw_commit_post()
	_draw_exit()
	queue_redraw()


func _draw_city_street() -> void:
	# Rodzina miejska: otwarte niebo ≥ 25% kadru, trzy plany, pionowe fasady,
	# latarnia wysoko i witryna przy chodniku. Sufit colliduje, ale nie jest malowany.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)
	draw_rect(Rect2(0.0, 0.0, 640.0, 108.0), VectorStageStyle.INK)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 108.0), Vector2(110.0, 82.0), Vector2(240.0, 94.0),
		Vector2(390.0, 74.0), Vector2(520.0, 90.0), Vector2(640.0, 78.0),
		Vector2(640.0, 108.0),
	]), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.38))
	draw_rect(Rect2(0.0, 108.0, 640.0, 198.0), VectorStageStyle.DEEP_PLANE)
	var window_x := 28.0
	while window_x <= 612.0:
		draw_rect(Rect2(window_x, 128.0, 22.0, 34.0), VectorStageStyle.INK)
		draw_rect(Rect2(window_x + 2.0, 130.0, 18.0, 30.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.22), false, 1.0)
		draw_rect(Rect2(window_x, 186.0, 22.0, 34.0), VectorStageStyle.INK)
		draw_rect(Rect2(window_x + 2.0, 188.0, 18.0, 30.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.22), false, 1.0)
		window_x += 30.0
	draw_line(Vector2(248.0, 306.0), Vector2(248.0, 132.0), VectorStageStyle.LIGHT_PLANE, 2.5)
	draw_line(Vector2(248.0, 132.0), Vector2(266.0, 126.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	var lamp := 0.55 + 0.12 * sin(_lamp_phase * 1.6)
	draw_circle(Vector2(266.0, 128.0), 5.0, Color(VectorStageStyle.HUMAN_AMBER, lamp))
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.28))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(0.0, 296.0, 640.0, 10.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.12))
	# Długi cień latarni na chodniku — źródło wysoko, cień nisko.
	draw_line(Vector2(270.0, 308.0), Vector2(392.0, 338.0), Color(VectorStageStyle.INK, 0.35), 6.0)


func _draw_forecast_board() -> void:
	var board_color := VectorStageStyle.ANCHOR_CYAN if are_forecasts_compared else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(128.0, 214.0, 96.0, 84.0), Color("16222a"))
	draw_rect(Rect2(128.0, 214.0, 96.0, 84.0), board_color, false, 1.0)
	var card_x := 136.0
	var methods: Array[StringName] = [METHOD_FORCE_HOME, METHOD_CLOSE_EQUAL, METHOD_MUTUAL]
	for method_id in methods:
		var card_color := VectorStageStyle.shade(board_color, 0.45)
		if are_forecasts_compared:
			var entry: Variant = forecasts.get(String(method_id), {})
			var available := entry is Dictionary and bool(entry.get("available", false))
			card_color = VectorStageStyle.ANCHOR_CYAN if available else VectorStageStyle.CORRECTION_OXIDE
		draw_rect(Rect2(card_x, 226.0, 24.0, 58.0), card_color, false, 1.0)
		if are_forecasts_compared:
			draw_line(Vector2(card_x + 4.0, 238.0), Vector2(card_x + 20.0, 238.0), card_color, 1.0)
			draw_line(Vector2(card_x + 4.0, 248.0), Vector2(card_x + 16.0, 248.0), VectorStageStyle.shade(card_color, 0.3), 1.0)
		card_x += 30.0


func _draw_marta_window() -> void:
	var window_color := VectorStageStyle.LIGHT_PLANE if is_marta_truth_disclosed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(286.0, 228.0, 92.0, 70.0), Color("121b22"))
	draw_rect(Rect2(286.0, 228.0, 92.0, 70.0), window_color, false, 1.0)
	draw_rect(Rect2(298.0, 238.0, 68.0, 40.0), Color(VectorStageStyle.HUMAN_AMBER, 0.18))
	draw_line(Vector2(332.0, 238.0), Vector2(332.0, 278.0), window_color, 1.0)
	draw_circle(Vector2(314.0, 286.0), 3.0, VectorStageStyle.shade(window_color, 0.25))
	draw_circle(Vector2(332.0, 286.0), 3.0, window_color)
	draw_circle(Vector2(350.0, 286.0), 3.0, VectorStageStyle.shade(window_color, 0.25))
	if is_marta_truth_disclosed:
		draw_line(Vector2(308.0, 268.0), Vector2(356.0, 268.0), window_color, 2.0)


func _draw_commit_post() -> void:
	var post_color := VectorStageStyle.ANCHOR_CYAN if is_method_committed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(424.0, 236.0, 120.0, 62.0), Color("18232b"))
	draw_line(Vector2(484.0, 298.0), Vector2(484.0, 236.0), post_color, 2.0)
	draw_circle(Vector2(452.0, 268.0), 4.0, VectorStageStyle.shade(post_color, 0.25))
	draw_circle(Vector2(484.0, 268.0), 4.0, post_color)
	draw_circle(Vector2(516.0, 268.0), 4.0, VectorStageStyle.shade(post_color, 0.25))
	if is_method_committed:
		var pulse := 0.5 + 0.15 * sin(_lamp_phase * 2.0)
		draw_arc(Vector2(484.0, 264.0), 12.0, 0.0, TAU, 16, Color(post_color, pulse), 1.5)
	else:
		draw_line(Vector2(444.0, 250.0), Vector2(524.0, 250.0), Color("3c4d55"), 1.0)


func _draw_exit() -> void:
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(572.0, 146.0, 48.0, 12.0), exit_color, false, 1.5)
	draw_line(Vector2(610.0, 158.0), Vector2(610.0, 296.0), exit_color, 2.0)
	draw_line(Vector2(584.0, 296.0), Vector2(620.0, 296.0), exit_color, 2.0)
