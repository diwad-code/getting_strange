extends SceneTree

## PKG-0166 gate — P9 BUNDLE-25, Station 18 three forecasts, consent gaps and
## physical method_committed. Technical proof only: entry requires the Station 17
## donor facts, three meaningful interactions are performable, incomplete
## inventories stay informational, method_committed is written only after costs
## and current consents are listed, the exit never softlocks, the save payload
## stays JSON-safe, topology and semantic input are preserved.
## It does not prove comprehension, emotion, fun or product GO.

const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")

const DONOR_TRACE_FACT := &"p7.work_history_and_record.trace"
const DONOR_LEDGER_FACT := &"p9.consent_and_cost.cost_ledger_read"
const DONOR_OFFER_FACT := &"p9.consent_and_cost.adaptation_offer"
const DONOR_SCOPE_FACT := &"p9.consent_and_cost.jakub_consent_scope"
const DONOR_CANONICAL_SCOPE_FACT := &"jakub_consent_state"

const FORECAST_FACT := &"p9.method_commitment.forecasts_compared"
const CANONICAL_MAPPED_FACT := &"route_hypotheses_mapped"
const MARTA_FACT := &"p9.method_commitment.marta_truth_state"
const CANONICAL_MARTA_FACT := &"marta_truth_state"
const METHOD_FACT := &"p9.method_commitment.method_committed"
const CANONICAL_METHOD_FACT := &"method_committed"
const TRACE_FACT := &"p9.method_commitment.trace"
const FEEDBACK_FACT := &"p9.method_commitment.safe_trial_feedback"

const DONOR_TRACE_VALUE := "cost_ledger_and_consent_scope_recorded"
const DONOR_OFFER_VALUE := "rejected"
const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"
const MARTA_FULL := "full"
const MARTA_PARTIAL := "partial"
const MARTA_WITHHELD := "withheld"
const METHOD_FORCE_HOME := "force_home"
const METHOD_CLOSE_EQUAL := "close_equal_recover_local"
const METHOD_MUTUAL := "mutual_passage"
const TRACE_VALUE := "method_committed_after_forecast_and_consent_inventory"

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
	printerr("PKG-0166 FAILURE: " + message)


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
	await _test_granted_commit_path(state)
	await _test_limited_commit_path(state)
	await _test_refused_and_withheld_path(state)
	_test_vocabulary_and_input()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _seed_donor_facts(state: Node, scope: String) -> void:
	state.reset_campaign(true)
	state.record_decision(DONOR_TRACE_FACT, DONOR_TRACE_VALUE)
	state.record_decision(DONOR_LEDGER_FACT, true)
	state.record_decision(DONOR_OFFER_FACT, DONOR_OFFER_VALUE)
	state.record_decision(DONOR_SCOPE_FACT, scope)
	state.record_decision(DONOR_CANONICAL_SCOPE_FACT, scope)


func _open_station(state: Node, seed_donor: bool, scope: String = SCOPE_GRANTED) -> Station18:
	if seed_donor:
		_seed_donor_facts(state, scope)
	else:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_18.tscn") as PackedScene
	_expect(packed != null, "Scena station_18 musi się ładować")
	if packed == null:
		return null
	var station := packed.instantiate() as Station18
	_expect(station != null, "Scena station_18 musi instantować jako Station18")
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
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "Station 18 musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "Station 18 musi mieć NarrativeGuidanceService")
	_expect(station.get_node_or_null("ReturnZone") != null, "Station 18 musi zachować ReturnZone")
	_expect(station.get_node_or_null("AirlockZone") != null, "Station 18 musi zachować AirlockZone")
	_expect(station.get_node_or_null("Player") != null, "Station 18 musi zachować gracza")
	var props := station.get_node_or_null("Props") as Node2D
	_expect(props != null, "Station 18 musi mieć Props")
	if props != null:
		var points := 0
		for child in props.get_children():
			if child is MemoryResonancePoint:
				points += 1
		_expect(points == 3, "Station 18 musi utrzymać budżet trzech istotnych interakcji, jest %d" % points)
	_expect(station.is_exit_unlocked, "Wejście do stacji nie może odblokować wyjścia")
	_expect(not station.is_level_completed, "Wejście do stacji nie może kończyć sceny")
	var state_body := JSON.stringify(state.decisions)
	_expect(not state_body.is_empty(), "Decyzje muszą być serializowalne do JSON")
	await _close_station(station)


func _test_donor_entry_requirement(state: Node) -> void:
	var station := await _open_station(state, false)
	if station == null:
		return
	_expect(not station.compare_forecast_consent_dependencies(), "Prognozy bez donor faktów Station 17 muszą pozostać bezpieczne")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "consent_scope_required", "Wejście bez donora musi zostawić fakt informacyjny")
	_expect(not state.decisions.has(CANONICAL_MAPPED_FACT), "Kanoniczny route_hypotheses_mapped nie może powstać z wejścia")
	_expect(not state.decisions.has(CANONICAL_MARTA_FACT), "Kanoniczny marta_truth_state nie może powstać z wejścia")
	_expect(not state.decisions.has(CANONICAL_METHOD_FACT), "Kanoniczny method_committed nie może powstać z wejścia")
	await _close_station(station)


func _test_safe_rejections(state: Node) -> void:
	var station := await _open_station(state, true, SCOPE_LIMITED)
	if station == null:
		return
	_expect(not station.disclose_marta_truth_partial(), "Prawda Marty przed prognozami musi być bezpieczna")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "forecast_comparison_required", "Wczesna prawda Marty musi dać informację o braku prognoz")
	_expect(not state.decisions.has(MARTA_FACT), "Wczesna prawda nie może zapisać stanu Marty")
	# PKG-0230 (P0-1): commit bez zestawienia/prawdy nie przechodzi —
	# zostawia istniejacy feedback i mowi luka, bez commita (S-02).
	_expect(not station.commit_force_home(), "Zatwierdzenie bez zestawienia nie przechodzi")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "forecast_and_consent_inventory_required", "Commit bez zestawienia zostawia luke inwentarza")
	_expect(not state.decisions.has(CANONICAL_METHOD_FACT), "Kanoniczny method_committed nie moze powstac bez zestawienia")
	_expect(station.compare_forecast_consent_dependencies(), "Zestawienie trzech prognoz po donor faktach musi przejść")
	_expect(state.decisions.get(FORECAST_FACT, false) == true, "Prognozy muszą być zapisane namespaced")
	_expect(state.decisions.get(CANONICAL_MAPPED_FACT, false) == true, "Kanoniczny route_hypotheses_mapped powstaje po zestawieniu")
	_expect(not station.compare_forecast_consent_dependencies(), "Prognoz nie wolno zestawiać dwukrotnie")
	_expect(station.is_exit_unlocked, "Samo zestawienie prognoz nie może otworzyć wyjścia")
	_expect(station.disclose_marta_truth_partial(), "Prawda po zestawieniu wychodzi")
	# PKG-0230 (P0-1): limited nie domyka force_home — luka zamiast commita.
	_expect(not station.commit_force_home(), "Ograniczona zgoda blokuje force_home")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "jakub_consent_missing", "Blokada zostawia luke zgody")
	_expect(station.commit_close_equal(), "Ograniczona zgoda pozwala close_equal")
	_expect(state.decisions.get(METHOD_FACT, "") == METHOD_CLOSE_EQUAL, "Namespaced metoda musi być close_equal")
	_expect(not station.commit_close_equal(), "Zatwierdzonej metody nie wolno nadpisać")
	await _close_station(station)


func _test_granted_commit_path(state: Node) -> void:
	var station := await _open_station(state, true, SCOPE_GRANTED)
	if station == null:
		return
	_expect(station.compare_forecast_consent_dependencies(), "Pełna ścieżka musi zacząć od zestawienia trzech prognoz")
	_expect(station.disclose_marta_truth_full(), "Pełna prawda Marty musi być wykonalna")
	_expect(state.decisions.get(MARTA_FACT, "") == MARTA_FULL, "Namespaced stan prawdy Marty musi być jawny")
	_expect(state.decisions.get(CANONICAL_MARTA_FACT, "") == MARTA_FULL, "Kanoniczny marta_truth_state musi przechować pełną prawdę")
	_expect(not station.disclose_marta_truth_withheld(), "Stanu prawdy Marty nie wolno nadpisać")
	_expect(station.commit_force_home(), "Zatwierdzenie metody po zestawieniu i zgodach musi przejść")
	_expect(state.decisions.get(METHOD_FACT, "") == METHOD_FORCE_HOME, "Namespaced metoda musi być force_home")
	_expect(state.decisions.get(CANONICAL_METHOD_FACT, "") == METHOD_FORCE_HOME, "Kanoniczny method_committed musi przechować force_home")
	_expect(state.decisions.get(TRACE_FACT, "") == TRACE_VALUE, "Lokalny ślad musi wskazywać zatwierdzenie po zestawieniu")
	_expect(not station.commit_mutual_passage(), "Zatwierdzonej metody nie wolno nadpisać")
	_expect(station.is_exit_unlocked, "Pełna ścieżka musi odblokować wyjście")
	_expect(not station.is_level_completed, "Odblokowanie wyjścia nie może samo kończyć sceny")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "Ścieżka pełnej zgody musi kończyć się w AirlockZone")
	await _close_station(station)


func _test_limited_commit_path(state: Node) -> void:
	var station := await _open_station(state, true, SCOPE_LIMITED)
	if station == null:
		return
	_expect(station.compare_forecast_consent_dependencies(), "Ścieżka ograniczonej zgody musi zestawić prognozy")
	var forecasts: Variant = state.decisions.get(&"p9.method_commitment.forecasts", {})
	_expect(forecasts is Dictionary, "Trzy prognozy muszą być JSON-safe słownikiem")
	if forecasts is Dictionary:
		var body := JSON.stringify(forecasts)
		_expect(body.contains(METHOD_FORCE_HOME) and body.contains(METHOD_CLOSE_EQUAL) and body.contains(METHOD_MUTUAL), "Słownik musi zawierać trzy kanoniczne metody")
		_expect(body.contains("jakub_consent_missing") or body.contains("gap"), "Ograniczona zgoda musi zostawić jawny brak w prognozach")
	_expect(station.disclose_marta_truth_partial(), "Częściowa prawda Marty musi być wykonalna")
	_expect(state.decisions.get(CANONICAL_MARTA_FACT, "") == MARTA_PARTIAL, "Częściowa prawda musi mieć własny stan")
	_expect(station.commit_close_equal(), "Ograniczona zgoda musi pozwalać zatwierdzić dostępną metodę")
	_expect(state.decisions.get(CANONICAL_METHOD_FACT, "") == METHOD_CLOSE_EQUAL, "Kanoniczna metoda przy ograniczonej zgodzie to close_equal_recover_local")
	_expect(station.is_exit_unlocked, "Ograniczona zgoda nie może softlockować wyjścia")
	var desk := station.get_node_or_null("Props/MethodCommitPost") as Node2D
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if desk != null and player != null:
		player.global_position = Vector2(desk.global_position.x, 296.0)
		_expect(not station.choose_method_from_player_side(), "Wybór kierunkiem nie może nadpisać zatwierdzonej metody")
	await _close_station(station)


func _test_refused_and_withheld_path(state: Node) -> void:
	var station := await _open_station(state, true, SCOPE_REFUSED)
	if station == null:
		return
	_expect(station.compare_forecast_consent_dependencies(), "Ścieżka odmowy musi zestawić prognozy")
	_expect(station.disclose_marta_truth_withheld(), "Wstrzymanie prawdy Marty musi być wykonalne i kontynuowalne")
	_expect(state.decisions.get(CANONICAL_MARTA_FACT, "") == MARTA_WITHHELD, "Kanoniczny stan prawdy musi przechować wstrzymanie")
	# PKG-0230 (P0-1, S-02): odmowa Jakuba zamyka wszystkie trzy metody.
	# Wyjscie ze stanu: powrot do 17 i renegocjacja (petla w 0194 run C).
	_expect(not station.commit_mutual_passage(), "Odmowa Jakuba blokuje zatwierdzenie")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "jakub_consent_missing", "Blokada zostawia luke zgody")
	_expect(not state.decisions.has(CANONICAL_METHOD_FACT), "Kanoniczna metoda nie powstaje przy odmowie")
	_expect(station.is_exit_unlocked, "Blokada commita nie zamyka drogi powrotu do 17")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "Scena z odmowa domyka sie w AirlockZone bez commita")
	var decisions_text := JSON.stringify(state.decisions)
	_expect(decisions_text.contains(SCOPE_REFUSED), "Zapis musi być JSON-safe dla odmowy Jakuba")
	_expect(decisions_text.contains(MARTA_WITHHELD), "Zapis musi być JSON-safe dla wstrzymania Marty")
	_expect(not state.decisions.has(CANONICAL_METHOD_FACT), "Zapis nie zawiera niezatwierdzonej metody")
	await _close_station(station)


func _test_vocabulary_and_input() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_18.gd").to_lower()
	for term in FORBIDDEN_TERMS:
		_expect(not source.contains(term), "station_18.gd nie może zawierać przedwczesnego terminu: %s" % term)
	_expect(source.contains("route_hypotheses_mapped"), "Station 18 musi zapisywać kanoniczne zestawienie prognoz")
	_expect(source.contains("marta_truth_state"), "Station 18 musi zapisywać kanoniczny stan prawdy Marty")
	_expect(source.contains("method_committed"), "Station 18 musi zapisywać kanoniczne zatwierdzenie metody")
	_expect(source.contains("force_home") and source.contains("close_equal_recover_local") and source.contains("mutual_passage"), "Trzy metody muszą być jawne")
	_expect(source.contains("full") and source.contains("partial") and source.contains("withheld"), "Warianty prawdy Marty muszą być jawne")
	_expect(source.contains("func _complete_if_player_already_in_airlock"), "Station 18 musi domykać scenę dla gracza już w śluzie")
	_expect(source.contains("func _draw_state_layer() -> void:"), "Station 18 musi mieć lokalny przebieg stanu")
	_expect(source.find("VectorStageStyle.draw_play_plane") < source.find("_draw_city_street"), "Lokalny rysunek musi wywołać play plane przed stanem stacji")
	_expect(not source.contains("draw_string("), "Nowa treść nie może być rysowana jako tekst w Layer 0")
	_expect(not source.contains("KEY_"), "Station 18 nie może hardkodować klawisza")
	_expect(not source.contains("search_municipal_death_registry"), "Wycofana ścieżka rejestru miejskiego musi zostać usunięta")
	_expect(not source.contains("compare_independent_registries"), "Wycofana próba publiczna na mikrofiszach musi zostać usunięta")
	_expect(not source.contains("error_copy"), "Wycofana hipoteza error_copy musi zostać usunięta")
	_expect(InputMap.has_action(&"interact"), "Projekt musi udostępniać semantyczną akcję interact")
	_expect(InputMap.has_action(&"move_left") and InputMap.has_action(&"move_right"), "Wybór metody i prawdy musi korzystać ze semantycznych osi ruchu")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0166 PASS: P9 BUNDLE-25 Station 18 forecasts, consent gaps and method_committed contracts")
		quit(0)
		return
	printerr("PKG-0166 FAIL: %d failure(s)" % _failures.size())
	quit(1)
