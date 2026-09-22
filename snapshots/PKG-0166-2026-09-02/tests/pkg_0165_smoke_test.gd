extends SceneTree

## PKG-0165 gate — P9 BUNDLE-24, Station 17 cost ledger and explicit consent scope.
## Technical proof only: entry requires the Station 16 donor facts, three
## meaningful interactions are performable, incomplete attempts stay informational,
## the adaptation offer is rejectable without closing the route, consent scope has
## explicit variants without a moral score, the exit never softlocks, the save
## payload stays JSON-safe, topology and semantic input are preserved.
## It does not prove comprehension, emotion, fun or product GO.

const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")

const DONOR_TRIAL_FACT := &"p7.work_history_and_record.institution_trial_result"
const DONOR_MANIFESTED_FACT := &"p9.mechanics.small_cost.manifested"
const DONOR_HOME_ECHO_FACT := &"p9.mechanics.small_cost.home_echo_verified"
const DONOR_MECHANIC_COST_FACT := &"mechanic_cost_observed"
const DONOR_HOME_ECHO_CANONICAL := &"home_echo_verified"

const LEDGER_FACT := &"p9.consent_and_cost.cost_ledger_read"
const CANONICAL_LEDGER_FACT := &"ucp_cost_ledger_found"
const OFFER_FACT := &"p9.consent_and_cost.adaptation_offer"
const SCOPE_FACT := &"p9.consent_and_cost.jakub_consent_scope"
const CANONICAL_SCOPE_FACT := &"jakub_consent_state"
const TRACE_FACT := &"p9.consent_and_cost.trace"
const FEEDBACK_FACT := &"p9.consent_and_cost.safe_trial_feedback"
const P7_TRACE_FACT := &"p7.work_history_and_record.trace"

const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"
const OFFER_REJECTED := "rejected"
const DONOR_TRIAL_VALUE := "small_cost_and_home_echo_confirmed"
const P7_TRACE_VALUE := "cost_ledger_and_consent_scope_recorded"

const FORBIDDEN_TERMS: Array[String] = [
	"rówień",
	"miejscowa lena",
	"inny świat",
	"anchor/yield",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0165 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	await _test_scene_contract(state)
	await _test_donor_entry_requirement(state)
	await _test_safe_rejections(state)
	await _test_granted_scope_path(state)
	await _test_limited_scope_path(state)
	await _test_refused_scope_path(state)
	_test_vocabulary_and_input()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _seed_donor_facts(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(DONOR_TRIAL_FACT, DONOR_TRIAL_VALUE)
	state.record_decision(DONOR_MANIFESTED_FACT, "marta_first_meeting_detail_blurred")
	state.record_decision(DONOR_HOME_ECHO_FACT, true)
	state.record_decision(DONOR_MECHANIC_COST_FACT, true)
	state.record_decision(DONOR_HOME_ECHO_CANONICAL, true)


func _open_station(state: Node, seed_donor: bool) -> Station17:
	if seed_donor:
		_seed_donor_facts(state)
	else:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_17.tscn") as PackedScene
	_expect(packed != null, "Scena station_17 musi się ładować")
	if packed == null:
		return null
	var station := packed.instantiate() as Station17
	_expect(station != null, "Scena station_17 musi instantować jako Station17")
	if station == null:
		return null
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close_station(station: Node) -> void:
	if station == null:
		return
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame

func _test_scene_contract(state: Node) -> void:
	var station := await _open_station(state, false)
	if station == null:
		return
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "Station 17 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "Station 17 musi mieć NarrativeGuidanceService")
	_expect(station.get_node_or_null("ReturnZone") != null, "Station 17 musi zachować ReturnZone")
	_expect(station.get_node_or_null("AirlockZone") != null, "Station 17 musi zachować AirlockZone")
	_expect(station.get_node_or_null("Player") != null, "Station 17 musi zachować gracza")
	var props := station.get_node_or_null("Props") as Node2D
	_expect(props != null, "Station 17 musi mieć Props")
	if props != null:
		var points := 0
		for child in props.get_children():
			if child is MemoryResonancePoint:
				points += 1
		_expect(points == 3, "Station 17 musi utrzymać budżet trzech istotnych interakcji, jest %d" % points)
	_expect(not station.is_exit_unlocked, "Wejście do stacji nie może odblokować wyjścia")
	_expect(not station.is_level_completed, "Wejście do stacji nie może kończyć sceny")
	var state_body := JSON.stringify(state.decisions)
	_expect(not state_body.is_empty(), "Decyzje muszą być serializowalne do JSON")
	await _close_station(station)


func _test_donor_entry_requirement(state: Node) -> void:
	var station := await _open_station(state, false)
	if station == null:
		return
	_expect(not station.read_cost_ledger(), "Ledger bez donor faktów Station 16 musi pozostać bezpieczny")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "institution_trial_required", "Wejście bez donora musi zostawić fakt informacyjny")
	_expect(not state.decisions.has(CANONICAL_LEDGER_FACT), "Kanoniczny ucp_cost_ledger_found nie może powstać z wejścia")
	_expect(not state.decisions.has(CANONICAL_SCOPE_FACT), "Kanoniczny jakub_consent_state nie może powstać z wejścia")
	_expect(not state.decisions.has(P7_TRACE_FACT), "Ślad p7 nie może powstać z samego wejścia")
	await _close_station(station)


func _test_safe_rejections(state: Node) -> void:
	var station := await _open_station(state, true)
	if station == null:
		return
	_expect(not station.reject_adaptation_offer(), "Oferta adaptacji przed ledgerem musi być bezpieczna")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "cost_ledger_required", "Wczesna oferta musi dać informację o braku ledgeru")
	_expect(not station.record_jakub_consent_granted(), "Zgoda przed ledgerem musi być bezpieczna")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "cost_ledger_required", "Wczesna zgoda musi dać informację o braku ledgeru")
	_expect(not state.decisions.has(OFFER_FACT), "Wczesna oferta nie może zapisać faktu oferty")
	_expect(not state.decisions.has(SCOPE_FACT), "Wczesna zgoda nie może zapisać zakresu")
	_expect(station.read_cost_ledger(), "Odczyt ledgeru po donor faktach musi przejść")
	_expect(state.decisions.get(LEDGER_FACT, false) == true, "Ledger musi być zapisany namespaced")
	_expect(state.decisions.get(CANONICAL_LEDGER_FACT, false) == true, "Kanoniczny ucp_cost_ledger_found powstaje po odczycie rejestru")
	_expect(not station.read_cost_ledger(), "Ledger nie może być czytany dwukrotnie")
	_expect(not station.is_exit_unlocked, "Ledger sam nie może otworzyć wyjścia")
	await _close_station(station)


func _test_granted_scope_path(state: Node) -> void:
	var station := await _open_station(state, true)
	if station == null:
		return
	_expect(station.read_cost_ledger(), "Pełna ścieżka musi zacząć od odczytu rejestru par")
	_expect(station.reject_adaptation_offer(), "Oferta adaptacji musi być odrzucalna")
	_expect(state.decisions.get(OFFER_FACT, "") == OFFER_REJECTED, "Odrzucona oferta musi zostawić fakt informacyjny")
	_expect(not station.reject_adaptation_offer(), "Odrzuconej oferty nie wolno nadpisać")
	_expect(station.record_jakub_consent_granted(), "Pełna zgoda musi być wykonalna")
	_expect(state.decisions.get(SCOPE_FACT, "") == SCOPE_GRANTED, "Namespaced zakres zgody musi być jawny")
	_expect(state.decisions.get(CANONICAL_SCOPE_FACT, "") == SCOPE_GRANTED, "Kanoniczny jakub_consent_state musi przechować pełną zgodę")
	_expect(state.decisions.get(TRACE_FACT, "") == "consent_scope_" + SCOPE_GRANTED, "Lokalny ślad zgody musi wskazywać zakres")
	_expect(state.decisions.get(P7_TRACE_FACT, "") == P7_TRACE_VALUE, "Ślad p7 musi przygotować wejście Station 18")
	_expect(station.is_exit_unlocked, "Pełna ścieżka musi odblokować wyjście")
	_expect(not station.is_level_completed, "Odblokowanie wyjścia nie może samo kończyć sceny")
	_expect(not station.record_jakub_consent_limited(), "Zakresu zgody nie wolno nadpisać")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		player.global_position = Vector2(606.0, 238.0)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "Ścieżka pełnej zgody musi kończyć się w AirlockZone")
	await _close_station(station)


func _test_limited_scope_path(state: Node) -> void:
	var station := await _open_station(state, true)
	if station == null:
		return
	_expect(station.read_cost_ledger(), "Ścieżka ograniczonej zgody musi czytać rejestr")
	_expect(station.record_jakub_consent_limited(), "Ograniczona zgoda musi być wykonalna")
	_expect(state.decisions.get(SCOPE_FACT, "") == SCOPE_LIMITED, "Ograniczona zgoda musi mieć własny zakres")
	_expect(state.decisions.get(CANONICAL_SCOPE_FACT, "") == SCOPE_LIMITED, "Kanoniczny stan zgody musi przechować zakres ograniczony")
	_expect(station.is_exit_unlocked, "Ograniczona zgoda musi odblokować wyjście")
	var desk := station.get_node_or_null("Props/ConsentScopeDesk") as Node2D
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if desk != null and player != null:
		player.global_position = Vector2(desk.global_position.x, 296.0)
		_expect(not station.choose_consent_from_player_side(), "Wybór kierunkiem nie może nadpisać zapisanego zakresu")
	await _close_station(station)


func _test_refused_scope_path(state: Node) -> void:
	var station := await _open_station(state, true)
	if station == null:
		return
	_expect(station.read_cost_ledger(), "Ścieżka odmowy musi czytać rejestr")
	_expect(station.record_jakub_consent_refused(), "Odmowa zakresu musi być wykonalna")
	_expect(state.decisions.get(SCOPE_FACT, "") == SCOPE_REFUSED, "Odmowa musi być zapisana jako jawny zakres")
	_expect(state.decisions.get(CANONICAL_SCOPE_FACT, "") == SCOPE_REFUSED, "Kanoniczny stan zgody musi przechować odmowę")
	_expect(station.is_exit_unlocked, "Odmowa nie może softlockować wyjścia")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		player.global_position = Vector2(606.0, 238.0)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "Ścieżka odmowy musi domykać się w AirlockZone")
	var decisions_text := JSON.stringify(state.decisions)
	_expect(decisions_text.contains(SCOPE_REFUSED), "Zapis musi być JSON-safe dla odmowy")
	await _close_station(station)


func _test_vocabulary_and_input() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_17.gd").to_lower()
	for term in FORBIDDEN_TERMS:
		_expect(not source.contains(term), "station_17.gd nie może zawierać przedwczesnego terminu: %s" % term)
	_expect(source.contains("ucp_cost_ledger_found"), "Station 17 musi zapisywać kanoniczny rejestr par")
	_expect(source.contains("jakub_consent_state"), "Station 17 musi zapisywać kanoniczny stan zgody")
	_expect(source.contains("granted") and source.contains("limited") and source.contains("refused"), "Warianty zgody muszą być jawne")
	_expect(source.contains("func _complete_if_player_already_in_airlock"), "Station 17 musi domykać scenę dla gracza już w śluzie")
	_expect(source.contains("func _draw_state_layer() -> void:"), "Station 17 musi mieć lokalny przebieg stanu")
	_expect(source.find("VectorStageStyle.draw_play_plane") < source.find("_draw_ledger_hall"), "Lokalny rysunek musi wywołać play plane przed stanem stacji")
	_expect(not source.contains("draw_string("), "Nowa treść nie może być rysowana jako tekst w Layer 0")
	_expect(not source.contains("KEY_"), "Station 17 nie może hardkodować klawisza")
	_expect(not source.contains("copy_report_header"), "Wycofana ścieżka kopiowania raportu musi zostać usunięta")
	_expect(not source.contains("release_service_route"), "Wycofany rygiel wentylacji musi zostać usunięty")
	_expect(InputMap.has_action(&"interact"), "Projekt musi udostępniać semantyczną akcję interact")
	_expect(InputMap.has_action(&"move_left") and InputMap.has_action(&"move_right"), "Wybór zakresu musi korzystać ze semantycznych osi ruchu")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0165 PASS: P9 BUNDLE-24 Station 17 cost ledger and explicit consent scope contracts")
		quit(0)
		return
	printerr("PKG-0165 FAIL: %d failure(s)" % _failures.size())
	quit(1)

