extends SceneTree

## PKG-0168 gate — P9 PHASE-06, Station 42B closure of the Plane and recovered local Lena.
## Technical proof only: entry requires method_committed = close_equal_recover_local, three
## consequence points are performable, incomplete attempts stay informational
## and do not close the path to 43, limited consent and withheld Marta truth
## remain continuable, the save payload stays JSON-safe, topology and semantic
## input are preserved. It does not prove comprehension, emotion, fun or
## product GO.

const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")
## PKG-0242 (R1): the finale accepts only chains a player can reach (PKG-0239).
const CampaignChain := preload("res://tests/support/campaign_chain.gd")

const DONOR_METHOD_FACT := &"p9.method_commitment.method_committed"
const CANONICAL_METHOD_FACT := &"method_committed"
const DONOR_MAPPED_FACT := &"route_hypotheses_mapped"
const DONOR_MARTA_FACT := &"p9.method_commitment.marta_truth_state"
const CANONICAL_MARTA_FACT := &"marta_truth_state"
const DONOR_SCOPE_FACT := &"p9.consent_and_cost.jakub_consent_scope"
const CANONICAL_SCOPE_FACT := &"jakub_consent_state"

const FLOW_CLOSED_FACT := &"p9.finale.close_equal.flow_closed"
const EXECUTED_FACT := &"p9.finale.close_equal.executed"
const LOCAL_RECOVERED_FACT := &"p9.finale.close_equal.local_lena_recovered"
const HOUSEHOLD_FACT := &"p9.finale.close_equal.household_consequence"
const TRACE_FACT := &"p9.finale.close_equal.trace"
const FEEDBACK_FACT := &"p9.finale.close_equal.safe_trial_feedback"
const ENDING_FAMILY_FACT := &"ending_family"
const ENDING_STABILITY_FACT := &"ending_stability"
const LEGACY_CHAMBER_FACT := &"p7.conscious_silence_and_presence.chamber_b_entered"
const LEGACY_WITNESSED_FACT := &"p7.conscious_silence_and_presence.final_chamber_witnessed"

const METHOD_FORCE_HOME := "force_home"
const METHOD_CLOSE_EQUAL := "close_equal_recover_local"
const METHOD_MUTUAL := "mutual_passage"
const MARTA_FULL := "full"
const MARTA_PARTIAL := "partial"
const MARTA_WITHHELD := "withheld"
const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"
const TRACE_VALUE := "close_equal_local_lena_recovered"
const ENDING_FAMILY_VALUE := "close_equal_recover_local"

const FORBIDDEN_TERMS: Array[String] = [
	"anchor/yield",
	"golden ending",
	"moral score",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0168 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	await _test_scene_contract(state)
	await _test_donor_entry_requirement(state)
	await _test_wrong_method_rejection(state)
	await _test_full_close_equal_path(state)
	await _test_limited_and_withheld_path(state)
	await _test_incomplete_attempt_keeps_exit(state)
	_test_vocabulary_and_input()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _seed_donor_facts(state: Node, method: String, marta: String, scope: String) -> bool:
	# PKG-0242 (R1): real 17 → 18 → 17 → 18 conversations on the state of an
	# input-only 01–16 run; hand-written method/truth/scope keys no longer
	# describe a reachable state after PKG-0239.
	CampaignChain.seed_before_17(state)
	return await CampaignChain.commit_chain(self, method, marta, scope)


func _open_station(state: Node, seed_donor: bool, method: String = METHOD_CLOSE_EQUAL, marta: String = MARTA_FULL, scope: String = SCOPE_GRANTED) -> Station42B:
	if seed_donor:
		_expect(await _seed_donor_facts(state, method, marta, scope), "Łańcuch %s/%s/%s musi się zatwierdzić" % [method, marta, scope])
	else:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_42b.tscn") as PackedScene
	_expect(packed != null, "Scena station_42b musi się ładować")
	if packed == null:
		return null
	var station := packed.instantiate() as Station42B
	_expect(station != null, "Scena station_42b musi instantować jako Station42B")
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
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "Station 42B musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "Station 42B musi mieć NarrativeGuidanceService")
	_expect(station.get_node_or_null("ReturnZone") != null, "Station 42B musi zachować ReturnZone")
	_expect(station.get_node_or_null("AirlockZone") != null, "Station 42B musi zachować AirlockZone")
	_expect(station.get_node_or_null("Player") != null, "Station 42B musi zachować gracza")
	var props := station.get_node_or_null("Props") as Node2D
	_expect(props != null, "Station 42B musi mieć Props")
	if props != null:
		var points := 0
		for child in props.get_children():
			if child is MemoryResonancePoint:
				points += 1
		_expect(points == 3, "Station 42B musi utrzymać budżet trzech istotnych interakcji, jest %d" % points)
		_expect(props.get_node_or_null("FlowClosureLatch") != null, "Station 42B musi mieć zabezpieczenie przewodu Równi")
		_expect(props.get_node_or_null("LocalLenaThreshold") != null, "Station 42B musi mieć próg odzyskanej miejscowej Leny")
		_expect(props.get_node_or_null("HouseholdTrace") != null, "Station 42B musi mieć ślad nieindeksowanej obecności")
	_expect(not station.is_level_completed, "Wejście do stacji nie może kończyć sceny")
	_expect(station.is_exit_unlocked, "Wejście bez close_equal_recover_local nie może otworzyć drogi do 43")
	var state_body := JSON.stringify(state.decisions)
	_expect(not state_body.is_empty(), "Decyzje muszą być serializowalne do JSON")
	await _close_station(station)


func _test_donor_entry_requirement(state: Node) -> void:
	var station := await _open_station(state, false)
	if station == null:
		return
	_expect(not station.execute_close_flow(), "Zamknięcie przepływu bez close_equal_recover_local musi pozostać bezpieczne")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "method_close_equal_required", "Wejście bez donora musi zostawić fakt informacyjny")
	_expect(not state.decisions.has(FLOW_CLOSED_FACT), "Kanoniczne zamknięcie przepływu nie może powstać z wejścia")
	_expect(not state.decisions.has(ENDING_FAMILY_FACT), "ending_family nie może powstać z wejścia")
	_expect(not station.read_local_lena_recovered(), "Odczyt odzyskanej Leny bez close_equal_recover_local musi być informacyjny")
	_expect(not station.read_household_consequence(), "Odczyt skutku dla osób bez close_equal_recover_local musi być informacyjny")
	_expect(station.is_exit_unlocked, "Brak close_equal_recover_local nie może odblokować wyjścia")
	await _close_station(station)


func _test_wrong_method_rejection(state: Node) -> void:
	var station := await _open_station(state, true, METHOD_FORCE_HOME, MARTA_PARTIAL, SCOPE_GRANTED)
	if station == null:
		return
	_expect(not station.execute_close_flow(), "Metoda force_home nie może wykonać 42B")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "method_close_equal_required", "Obca metoda musi zostać nazwana jako brak close_equal_recover_local")
	_expect(not state.decisions.has(ENDING_FAMILY_FACT), "Obca metoda nie może zapisać ending_family w 42B")
	_expect(station.is_exit_unlocked, "Obca metoda nie może otworzyć 42B do 43")
	await _close_station(station)


func _test_full_close_equal_path(state: Node) -> void:
	var station := await _open_station(state, true, METHOD_CLOSE_EQUAL, MARTA_FULL, SCOPE_GRANTED)
	if station == null:
		return
	_expect(station.is_exit_unlocked, "Wybrany wariant 42B musi zostawić drogę do 43 otwartą od wejścia")
	_expect(state.decisions.get(LEGACY_CHAMBER_FACT, false) == true, "Wejście 42B musi zapisać dawcowy chamber_b_entered")
	# PKG-0242 (R1, PKG-0239 B order): the first use starts the recovery, the
	# local Lena answers, and only the second use closes the flow.
	_expect(station.execute_close_flow(), "Rozpoczęcie odzyskania po close_equal_recover_local musi przejść")
	_expect(state.decisions.get(EXECUTED_FACT, false) == true, "Namespaced executed musi powstać")
	_expect(state.decisions.get(ENDING_FAMILY_FACT, "") == ENDING_FAMILY_VALUE, "Kanoniczny ending_family musi być close_equal_recover_local")
	_expect(not state.decisions.has(FLOW_CLOSED_FACT), "Kanał nie może się zamknąć, zanim miejscowa Lena odpowie")
	_expect(station.read_local_lena_recovered(), "Odczyt odzyskanej miejscowej Leny musi przejść")
	_expect(state.decisions.get(LOCAL_RECOVERED_FACT, false) == true, "Namespaced local_lena_recovered musi powstać")
	_expect(state.decisions.get(LEGACY_WITNESSED_FACT, false) == true, "Dawca final_chamber_witnessed powstaje po odczycie odzyskania")
	_expect(station.execute_close_flow(), "Zamknięcie przepływu po odzyskaniu musi przejść")
	_expect(state.decisions.get(FLOW_CLOSED_FACT, false) == true, "Namespaced flow_closed musi powstać po zamknięciu")
	_expect(not station.execute_close_flow(), "Zamknięcia przepływu nie wolno wykonać dwukrotnie")
	_expect(station.read_household_consequence(), "Odczyt skutku nieindeksowanej obecności musi przejść")
	var household: Variant = state.decisions.get(HOUSEHOLD_FACT, {})
	_expect(household is Dictionary, "Skutek dla osób musi być JSON-safe słownikiem")
	if household is Dictionary:
		var body := JSON.stringify(household)
		_expect(body.contains("marta") and body.contains("jakub"), "Słownik skutku musi nazwać Martę i Jakuba")
		_expect(body.contains("local_lena") and body.contains("arrived_lena"), "Słownik skutku musi nazwać obie Leny")
		_expect(not body.contains("good") and not body.contains("bad"), "Skutek nie może być rankingiem moralnym")
	_expect(state.decisions.get(TRACE_FACT, "") == TRACE_VALUE, "Lokalny ślad musi wskazywać odzyskanie miejscowej Leny")
	_expect(state.decisions.has(ENDING_STABILITY_FACT), "ending_stability musi powstać po odczycie skutku")
	_expect(not station.read_household_consequence(), "Skutku dla osób nie wolno nadpisać")
	_expect(station.is_exit_unlocked, "Pełna ścieżka musi zostawić wyjście otwarte")
	_expect(not station.is_level_completed, "Odblokowanie wyjścia nie może samo kończyć sceny")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "Ścieżka close_equal musi kończyć się w AirlockZone")
	var decisions_text := JSON.stringify(state.decisions)
	_expect(decisions_text.contains(METHOD_CLOSE_EQUAL), "Zapis musi być JSON-safe dla close_equal_recover_local")
	_expect(decisions_text.contains(TRACE_VALUE), "Zapis musi być JSON-safe dla śladu 42B")
	await _close_station(station)


func _test_limited_and_withheld_path(state: Node) -> void:
	var station := await _open_station(state, true, METHOD_CLOSE_EQUAL, MARTA_WITHHELD, SCOPE_LIMITED)
	if station == null:
		return
	_expect(station.is_exit_unlocked, "Ograniczona zgoda i wstrzymanie nie mogą zablokować 42B")
	_expect(station.execute_close_flow(), "Rozpoczęcie odzyskania przy wstrzymanej prawdzie musi przejść")
	_expect(station.read_local_lena_recovered(), "Odzyskanie Leny musi być czytelne przy ograniczonej zgodzie")
	_expect(station.execute_close_flow(), "Zamknięcie przepływu przy wstrzymanej prawdzie musi przejść")
	_expect(station.read_household_consequence(), "Skutek dla osób musi zapisać wstrzymanie i ograniczoną zgodę")
	var household: Variant = state.decisions.get(HOUSEHOLD_FACT, {})
	_expect(household is Dictionary, "Skutek przy wstrzymaniu musi pozostać słownikiem")
	if household is Dictionary:
		var body := JSON.stringify(household)
		_expect(body.contains(MARTA_WITHHELD) or body.contains("withheld"), "Skutek musi przechować wstrzymanie Marty")
		_expect(body.contains(SCOPE_LIMITED) or body.contains("limited"), "Skutek musi przechować ograniczoną zgodę Jakuba")
	_expect(station.is_exit_unlocked, "Wstrzymanie i ograniczona zgoda nie mogą softlockować wyjścia")
	await _close_station(station)


func _test_incomplete_attempt_keeps_exit(state: Node) -> void:
	var station := await _open_station(state, true, METHOD_CLOSE_EQUAL, MARTA_PARTIAL, SCOPE_LIMITED)
	if station == null:
		return
	_expect(station.execute_close_flow(), "Niepełna próba może tylko rozpocząć odzyskanie")
	_expect(state.decisions.get(EXECUTED_FACT, false) == true, "Niepełna próba zapisuje rozpoczęte wykonanie")
	_expect(not station.execute_close_flow(), "Kanału nie da się zamknąć przed odpowiedzią miejscowej Leny")
	_expect(not state.decisions.has(FLOW_CLOSED_FACT), "Niepełna próba nie fabrykuje zamknięcia przepływu")
	_expect(not state.decisions.has(LOCAL_RECOVERED_FACT), "Niepełna próba nie fabrykuje odzyskania miejscowej Leny")
	_expect(not state.decisions.has(HOUSEHOLD_FACT), "Niepełna próba nie fabrykuje skutku dla osób")
	_expect(station.is_exit_unlocked, "Niepełna próba nie zamyka drogi do 43, jeśli 42B jest wybranym wariantem")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
	# PKG-0232 (D-244, D3, kontrolowana aktualizacja): próg 43 dopiero po
	# pełnym łańcuchu (wykonanie → stan → skutek). Samo zamknięcie nie domyka.
	_expect(not station.is_level_completed, "Niepełna próba (samo zamknięcie) nie domyka progu 43")
	_expect(String(station.get("last_feedback")) == "finale_sequence_incomplete", "Próg bez łańcucha nazywa lukę")
	_expect(station.read_local_lena_recovered(), "Stan po wykonaniu przechodzi")
	_expect(station.execute_close_flow(), "Zamknięcie po odzyskaniu przechodzi")
	_expect(station.read_household_consequence(), "Skutek po stanie przechodzi")
	_ThresholdBinder.complete_from_test(station, player)
	await physics_frame
	await physics_frame
	_expect(station.is_level_completed, "Pełny łańcuch 42B domyka się w AirlockZone")
	await _close_station(station)


func _test_vocabulary_and_input() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_42b.gd").to_lower()
	for term in FORBIDDEN_TERMS:
		_expect(not source.contains(term), "station_42b.gd nie może zawierać zabronionego terminu: %s" % term)
	_expect(source.contains("ending_family"), "Station 42B musi zapisywać kanoniczną rodzinę finału")
	_expect(source.contains("ending_stability"), "Station 42B musi zapisywać kanoniczną stabilność finału")
	_expect(source.contains("close_equal_recover_local"), "Station 42B musi wymagać close_equal_recover_local jako wejścia")
	_expect(source.contains("p9.finale.close_equal"), "Station 42B musi zapisywać namespaced fakty P9")
	_expect(source.contains("func execute_close_flow"), "Station 42B musi wystawić czasownik zamknięcia przepływu")
	_expect(source.contains("func read_local_lena_recovered"), "Station 42B musi wystawić odczyt odzyskanej miejscowej Leny")
	_expect(source.contains("func read_household_consequence"), "Station 42B musi wystawić odczyt skutku dla osób")
	_expect(source.contains("func _draw_state_layer() -> void:"), "Station 42B musi mieć lokalny przebieg stanu")
	_expect(source.find("vectorstagestyle.draw_play_plane") < source.find("_draw_dawn_apartment_b"), "Lokalny rysunek musi wywołać play plane przed stanem stacji")
	_expect(source.contains("_draw_dawn_apartment_b"), "Station 42B musi malować znaną mieszkalną bryłę o świcie")
	_expect(not source.contains("draw_string("), "Nowa treść nie może być rysowana jako tekst w Layer 0")
	_expect(not source.contains("key_"), "Station 42B nie może hardkodować klawisza")
	_expect(InputMap.has_action(&"interact"), "Projekt musi udostępniać semantyczną akcję interact")
	_expect(InputMap.has_action(&"move_left") and InputMap.has_action(&"move_right"), "Semantyczne osie ruchu muszą pozostać")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0168 PASS: P9 PHASE-06 Station 42B closure of the Plane and recovered local Lena contracts")
		quit(0)
		return
	printerr("PKG-0168 FAIL: %d failure(s)" % _failures.size())
	quit(1)
