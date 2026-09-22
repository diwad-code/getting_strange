extends SceneTree

## PKG-0167 gate — P9 PHASE-06, Station 42A forced return of the arrived Lena.
## Technical proof only: entry requires method_committed = force_home, three
## consequence points are performable, incomplete attempts stay informational
## and do not close the path to 43, limited consent and withheld Marta truth
## remain continuable, the save payload stays JSON-safe, topology and semantic
## input are preserved. It does not prove comprehension, emotion, fun or
## product GO.

const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")

const DONOR_METHOD_FACT := &"p9.method_commitment.method_committed"
const CANONICAL_METHOD_FACT := &"method_committed"
const DONOR_MAPPED_FACT := &"route_hypotheses_mapped"
const DONOR_MARTA_FACT := &"p9.method_commitment.marta_truth_state"
const CANONICAL_MARTA_FACT := &"marta_truth_state"
const DONOR_SCOPE_FACT := &"p9.consent_and_cost.jakub_consent_scope"
const CANONICAL_SCOPE_FACT := &"jakub_consent_state"

const RETURN_FACT := &"p9.finale.forced_return.executed"
const SEALED_FACT := &"p9.finale.forced_return.local_lena_sealed"
const HOUSEHOLD_FACT := &"p9.finale.forced_return.household_consequence"
const TRACE_FACT := &"p9.finale.forced_return.trace"
const FEEDBACK_FACT := &"p9.finale.forced_return.safe_trial_feedback"
const ENDING_FAMILY_FACT := &"ending_family"
const ENDING_STABILITY_FACT := &"ending_stability"
const LEGACY_CHAMBER_FACT := &"p7.conscious_silence_and_presence.chamber_a_entered"
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
const TRACE_VALUE := "forced_return_local_lena_sealed"
const ENDING_FAMILY_VALUE := "force_home"

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
	printerr("PKG-0167 FAILURE: " + message)


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
	await _test_full_return_path(state)
	await _test_limited_and_withheld_path(state)
	await _test_incomplete_attempt_keeps_exit(state)
	_test_vocabulary_and_input()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _seed_donor_facts(state: Node, method: String, marta: String, scope: String) -> void:
	state.reset_campaign(true)
	state.record_decision(DONOR_METHOD_FACT, method)
	state.record_decision(CANONICAL_METHOD_FACT, method)
	state.record_decision(DONOR_MAPPED_FACT, true)
	state.record_decision(DONOR_MARTA_FACT, marta)
	state.record_decision(CANONICAL_MARTA_FACT, marta)
	state.record_decision(DONOR_SCOPE_FACT, scope)
	state.record_decision(CANONICAL_SCOPE_FACT, scope)


func _open_station(state: Node, seed_donor: bool, method: String = METHOD_FORCE_HOME, marta: String = MARTA_FULL, scope: String = SCOPE_GRANTED) -> Station42A:
	if seed_donor:
		_seed_donor_facts(state, method, marta, scope)
	else:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_42a.tscn") as PackedScene
	_expect(packed != null, "Scena station_42a musi się ładować")
	if packed == null:
		return null
	var station := packed.instantiate() as Station42A
	_expect(station != null, "Scena station_42a musi instantować jako Station42A")
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
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "Station 42A musi mieć WorldPixelCompositor")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "Station 42A musi mieć NarrativeGuidanceService")
	_expect(station.get_node_or_null("ReturnZone") != null, "Station 42A musi zachować ReturnZone")
	_expect(station.get_node_or_null("AirlockZone") != null, "Station 42A musi zachować AirlockZone")
	_expect(station.get_node_or_null("Player") != null, "Station 42A musi zachować gracza")
	var props := station.get_node_or_null("Props") as Node2D
	_expect(props != null, "Station 42A musi mieć Props")
	if props != null:
		var points := 0
		for child in props.get_children():
			if child is MemoryResonancePoint:
				points += 1
		_expect(points == 3, "Station 42A musi utrzymać budżet trzech istotnych interakcji, jest %d" % points)
		_expect(props.get_node_or_null("ForcedReturnLatch") != null, "Station 42A musi mieć rygiel wymuszonego powrotu")
		_expect(props.get_node_or_null("SealedThreshold") != null, "Station 42A musi mieć zapieczętowany próg drugiej Leny")
		_expect(props.get_node_or_null("HouseholdTrace") != null, "Station 42A musi mieć ślad skutku dla osób w mieszkaniu")
	_expect(not station.is_level_completed, "Wejście do stacji nie może kończyć sceny")
	_expect(station.is_exit_unlocked, "Wejście bez force_home nie może otworzyć drogi do 43")
	var state_body := JSON.stringify(state.decisions)
	_expect(not state_body.is_empty(), "Decyzje muszą być serializowalne do JSON")
	await _close_station(station)


func _test_donor_entry_requirement(state: Node) -> void:
	var station := await _open_station(state, false)
	if station == null:
		return
	_expect(not station.execute_forced_return(), "Wymuszenie powrotu bez force_home musi pozostać bezpieczne")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "method_force_home_required", "Wejście bez donora musi zostawić fakt informacyjny")
	_expect(not state.decisions.has(RETURN_FACT), "Kanoniczny powrót nie może powstać z wejścia")
	_expect(not state.decisions.has(ENDING_FAMILY_FACT), "ending_family nie może powstać z wejścia")
	_expect(not station.read_sealed_other_lena(), "Odczyt zapieczętowanej Leny bez force_home musi być informacyjny")
	_expect(not station.read_household_consequence(), "Odczyt skutku dla osób bez force_home musi być informacyjny")
	_expect(station.is_exit_unlocked, "Brak force_home nie może odblokować wyjścia")
	await _close_station(station)


func _test_wrong_method_rejection(state: Node) -> void:
	var station := await _open_station(state, true, METHOD_CLOSE_EQUAL, MARTA_PARTIAL, SCOPE_LIMITED)
	if station == null:
		return
	_expect(not station.execute_forced_return(), "Metoda close_equal nie może wykonać 42A")
	_expect(state.decisions.get(FEEDBACK_FACT, "") == "method_force_home_required", "Obca metoda musi zostać nazwana jako brak force_home")
	_expect(not state.decisions.has(ENDING_FAMILY_FACT), "Obca metoda nie może zapisać ending_family w 42A")
	_expect(station.is_exit_unlocked, "Obca metoda nie może otworzyć 42A do 43")
	await _close_station(station)


func _test_full_return_path(state: Node) -> void:
	var station := await _open_station(state, true, METHOD_FORCE_HOME, MARTA_FULL, SCOPE_GRANTED)
	if station == null:
		return
	_expect(station.is_exit_unlocked, "Wybrany wariant 42A musi zostawić drogę do 43 otwartą od wejścia")
	_expect(state.decisions.get(LEGACY_CHAMBER_FACT, false) == true, "Wejście 42A musi zapisać dawcowy chamber_a_entered")
	_expect(station.execute_forced_return(), "Wymuszenie powrotu po force_home musi przejść")
	_expect(state.decisions.get(RETURN_FACT, false) == true, "Namespaced executed musi powstać po rygłu")
	_expect(state.decisions.get(ENDING_FAMILY_FACT, "") == ENDING_FAMILY_VALUE, "Kanoniczny ending_family musi być force_home")
	_expect(not station.execute_forced_return(), "Powrotu nie wolno wykonać dwukrotnie")
	_expect(station.read_sealed_other_lena(), "Odczyt zapieczętowanej drugiej Leny musi przejść")
	_expect(state.decisions.get(SEALED_FACT, false) == true, "Namespaced local_lena_sealed musi powstać")
	_expect(state.decisions.get(LEGACY_WITNESSED_FACT, false) == true, "Dawca final_chamber_witnessed powstaje po odczycie zapieczętowania")
	_expect(station.read_household_consequence(), "Odczyt skutku dla osób w mieszkaniu musi przejść")
	var household: Variant = state.decisions.get(HOUSEHOLD_FACT, {})
	_expect(household is Dictionary, "Skutek dla osób musi być JSON-safe słownikiem")
	if household is Dictionary:
		var body := JSON.stringify(household)
		_expect(body.contains("marta") and body.contains("jakub"), "Słownik skutku musi nazwać Martę i Jakuba")
		_expect(not body.contains("good") and not body.contains("bad"), "Skutek nie może być rankingiem moralnym")
	_expect(state.decisions.get(TRACE_FACT, "") == TRACE_VALUE, "Lokalny ślad musi wskazywać zapieczętowanie po powrocie")
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
	_expect(station.is_level_completed, "Ścieżka force_home musi kończyć się w AirlockZone")
	var decisions_text := JSON.stringify(state.decisions)
	_expect(decisions_text.contains(METHOD_FORCE_HOME), "Zapis musi być JSON-safe dla force_home")
	_expect(decisions_text.contains(TRACE_VALUE), "Zapis musi być JSON-safe dla śladu 42A")
	await _close_station(station)


func _test_limited_and_withheld_path(state: Node) -> void:
	var station := await _open_station(state, true, METHOD_FORCE_HOME, MARTA_WITHHELD, SCOPE_LIMITED)
	if station == null:
		return
	_expect(station.is_exit_unlocked, "Ograniczona zgoda i wstrzymanie nie mogą zablokować 42A")
	_expect(station.execute_forced_return(), "Wymuszenie powrotu przy wstrzymanej prawdzie musi przejść")
	_expect(station.read_sealed_other_lena(), "Zapieczętowanie musi być czytelne przy ograniczonej zgodzie")
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
	var station := await _open_station(state, true, METHOD_FORCE_HOME, MARTA_PARTIAL, SCOPE_REFUSED)
	if station == null:
		return
	_expect(station.execute_forced_return(), "Niepełna próba może wykonać tylko rygiel")
	_expect(state.decisions.get(RETURN_FACT, false) == true, "Niepełna próba zapisuje wykonany powrót")
	_expect(not state.decisions.has(SEALED_FACT), "Niepełna próba nie fabrykuje zapieczętowania")
	_expect(not state.decisions.has(HOUSEHOLD_FACT), "Niepełna próba nie fabrykuje skutku dla osób")
	_expect(station.is_exit_unlocked, "Niepełna próba nie zamyka drogi do 43, jeśli 42A jest wybranym wariantem")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player != null:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
	_expect(station.is_level_completed, "Niepełna próba w wybranym 42A musi dać się domknąć w AirlockZone")
	await _close_station(station)


func _test_vocabulary_and_input() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_42a.gd").to_lower()
	for term in FORBIDDEN_TERMS:
		_expect(not source.contains(term), "station_42a.gd nie może zawierać zabronionego terminu: %s" % term)
	_expect(source.contains("ending_family"), "Station 42A musi zapisywać kanoniczną rodzinę finału")
	_expect(source.contains("ending_stability"), "Station 42A musi zapisywać kanoniczną stabilność finału")
	_expect(source.contains("force_home"), "Station 42A musi wymagać force_home jako wejścia")
	_expect(source.contains("p9.finale.forced_return"), "Station 42A musi zapisywać namespaced fakty P9")
	_expect(source.contains("func execute_forced_return"), "Station 42A musi wystawić czasownik wymuszenia powrotu")
	_expect(source.contains("func read_sealed_other_lena"), "Station 42A musi wystawić odczyt zapieczętowanej Leny")
	_expect(source.contains("func read_household_consequence"), "Station 42A musi wystawić odczyt skutku dla osób")
	_expect(source.contains("func _draw_state_layer() -> void:"), "Station 42A musi mieć lokalny przebieg stanu")
	_expect(source.find("vectorstagestyle.draw_play_plane") < source.find("_draw_dawn_apartment"), "Lokalny rysunek musi wywołać play plane przed stanem stacji")
	_expect(source.contains("_draw_dawn_apartment"), "Station 42A musi malować znaną mieszkalną bryłę o świcie")
	_expect(not source.contains("draw_string("), "Nowa treść nie może być rysowana jako tekst w Layer 0")
	_expect(not source.contains("key_"), "Station 42A nie może hardkodować klawisza")
	_expect(not source.contains("inspect_phone"), "Wycofana ścieżka telefonu musi zostać usunięta")
	_expect(InputMap.has_action(&"interact"), "Projekt musi udostępniać semantyczną akcję interact")
	_expect(InputMap.has_action(&"move_left") and InputMap.has_action(&"move_right"), "Semantyczne osie ruchu muszą pozostać")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0167 PASS: P9 PHASE-06 Station 42A forced return contracts")
		quit(0)
		return
	printerr("PKG-0167 FAIL: %d failure(s)" % _failures.size())
	quit(1)
