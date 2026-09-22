extends SceneTree

## PKG-0163 gate — P9 BUNDLE-22, Station 15 mutual signal test (family 6).
## Technical proof only: reconstruction of the 20:40 trial, two identical
## control impulses answered by an identical echo, a third impulse with a
## deliberate error answered by a selective correction, the abort-note read,
## naming strictly after performed behaviors, no softlock, semantic input and
## the inherited Station 14 entry fact. Does NOT prove comprehension or fun.

const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")

const FORBIDDEN_STATION_15_TERMS: Array[String] = [
	"inny świat",
	"miejscowa lena",
	"wierzbicka",
	"anchor/yield",
	"mechanic_cost_observed",
	"duplikat",
	"podstruktura",
]

const ENTRY_TRACE := &"p7.marta_threshold.trace"
const ENTRY_VALUE := "dead_circuit_lesson_observed"
const FACT_LOG := &"p9.mechanics.mutual_signal.log_reconstructed"
const FACT_CONTROL := &"p9.mechanics.mutual_signal.control_echo_observed"
const FACT_CORRECTIVE := &"p9.mechanics.mutual_signal.corrective_response_observed"
const FACT_NOTE := &"p9.mechanics.mutual_signal.abort_note_read"
const FACT_TRACE := &"p9.mechanics.mutual_signal.trace"
const FACT_FEEDBACK := &"p9.mechanics.mutual_signal.safe_trial_feedback"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0163 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state != null:
		state.campaign_auto_transition_enabled = false
		await _test_safe_rejection(state)
		await _test_control_echo(state)
		await _test_corrective_response_and_note(state)
		await _test_no_softlock_and_completion(state)
		_test_vocabulary_and_input()
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	_finish()


func _seed_entry(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(ENTRY_TRACE, ENTRY_VALUE)

func _open_station(state: Node) -> Node2D:
	_seed_entry(state)
	var packed := load("res://scenes/levels/station_15.tscn") as PackedScene
	_expect(packed != null, "Scena station_15 musi się ładować")
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	_expect(station != null, "Scena station_15 musi instantować jako Node2D")
	if station == null:
		return null
	root.add_child(station)
	await process_frame
	await physics_frame
	_expect(station.get_node_or_null("ReturnZone") != null and station.has_signal(&"previous_level_requested"),
		"Station 15 musi zachować ReturnZone i sygnał powrotu")
	_expect(station.get_node_or_null("AirlockZone") != null and station.has_signal(&"level_completed"),
		"Station 15 musi zachować AirlockZone i sygnał ukończenia")
	_expect(station.get_node_or_null("Geometry/ReceiverHousing") is StaticBody2D,
		"Korpus odbieracza musi być stałą geometrią świata")
	_expect(station.get_node_or_null("Props/ServiceLadder") != null,
		"Wyjście w górę musi być drabiną serwisową")
	var interactions := 0
	for prop in station.get_node_or_null("Props").get_children():
		if prop is MemoryResonancePoint:
			interactions += 1
	_expect(interactions <= 3, "Station 15 musi mieścić się w budżecie trzech istotnych interakcji")
	return station


func _close_station(station: Node) -> void:
	if station == null:
		return
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame

func _test_safe_rejection(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	_expect(not bool(station.call(&"send_corrective_impulse")),
		"Celowo błędny impuls bez dwóch kontroli musi być bezpiecznie odrzucony")
	_expect(String(state.decisions.get(FACT_FEEDBACK, "")) == "controls_incomplete",
		"Odrzucona próba musi zostawić fakt informacyjny")
	_expect(not state.decisions.has(&"local_lena_signal_confirmed"),
		"Odrzucona próba nie może nadać kanonicznego faktu sygnału")
	_expect(bool(station.get("is_exit_unlocked")), "Wyjście musi pozostać zamknięte bez próby")
	_close_station(station)


func _test_control_echo(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	_expect(bool(station.call(&"observe_signal_log")), "Log 20:40 musi zostać odtworzony")
	_expect(String(state.decisions.get(FACT_LOG, "")) == "trial_2040_ucp_correction",
		"Rekonstrukcja musi wskazać zewnętrzną korektę próby 20:40")
	_expect(bool(state.decisions.get(&"ucp_intervention_reconstructed", false)),
		"Rekonstrukcja musi nadać kanoniczny motyw działania UCP")
	_expect(bool(station.call(&"send_control_impulse")), "Pierwszy impuls kontrolny musi wyjść")
	station.call(&"run_response_cycle")
	_expect(bool(station.call(&"send_control_impulse")), "Drugi impuls kontrolny musi wyjść")
	station.call(&"run_response_cycle")
	_expect(String(state.decisions.get(FACT_CONTROL, "")) == "echo_repeats_identically",
		"Echo na kontrolach musi wrócić identyczne")
	_expect(not state.decisions.has(&"local_lena_signal_confirmed"),
		"Dwa kontrolne echa nie mogą potwierdzić sprawczej odpowiedzi")
	_expect(bool(station.get("is_exit_unlocked")), "Kontrolne echo nie może otworzyć wyjścia")
	_expect(not bool(station.call(&"read_abort_note")),
		"Notatka z warunkiem przerwania musi być nieczytelna przed potwierdzeniem sygnału")
	_close_station(station)

func _test_corrective_response_and_note(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	station.call(&"observe_signal_log")
	station.call(&"send_control_impulse")
	station.call(&"run_response_cycle")
	station.call(&"send_control_impulse")
	station.call(&"run_response_cycle")
	_expect(bool(station.call(&"send_corrective_impulse")), "Trzeci impuls z celowym błędem musi wyjść po kontrolach")
	station.call(&"run_response_cycle")
	_expect(String(state.decisions.get(FACT_CORRECTIVE, "")) == "deliberate_error_corrected_selectively",
		"Odpowiedź musi poprawić wyłącznie celowy błąd")
	_expect(String(state.decisions.get(FACT_TRACE, "")) == "living_response_confirmed",
		"Potwierdzenie musi zostawić ślad sekwencji trzech impulsów")
	_expect(bool(state.decisions.get(&"local_lena_signal_confirmed", false)),
		"Selektywna korekta musi nadać kanoniczny fakt sygnału")
	var guidance := station.get_node_or_null("NarrativeGuidanceService")
	if guidance != null:
		_expect(bool(guidance.get("closed_hypotheses").get(&"living_response", false)),
			"Wykonana selektywna korekta musi zamknąć hipotezę żywej odpowiedzi")
	_expect(bool(station.get("is_exit_unlocked")), "Potwierdzenie sygnału samo nie otwiera wyjścia")
	_expect(bool(station.call(&"read_abort_note")), "Notatka musi stać się czytelna po potwierdzeniu sygnału")
	_expect(String(state.decisions.get(FACT_NOTE, "")) == "abort_condition_before_cost",
		"Odczyt notatki musi wskazać warunek przerwania przed kosztem")
	_expect(bool(state.decisions.get(&"local_lena_intent_found", false)),
		"Notatka musi nadać kanoniczny fakt zamiaru")
	_expect(bool(station.get("is_exit_unlocked")), "Odczyt notatki musi otworzyć wyjście")
	_close_station(station)

func _test_no_softlock_and_completion(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	station.call(&"observe_signal_log")
	station.call(&"send_control_impulse")
	station.call(&"run_response_cycle")
	station.call(&"send_corrective_impulse")
	station.call(&"run_response_cycle")
	_expect(not state.decisions.has(&"local_lena_signal_confirmed"),
		"Protokół pominięty musi pozostać niewykonany — bez nadania faktu")
	station.call(&"send_control_impulse")
	station.call(&"run_response_cycle")
	station.call(&"send_corrective_impulse")
	station.call(&"run_response_cycle")
	_expect(bool(state.decisions.get(&"local_lena_signal_confirmed", false)),
		"Porządek protokołu musi być osiągalny bez resetu sceny (brak softlocka)")
	station.call(&"read_abort_note")
	_expect(bool(station.get("is_exit_unlocked")), "Wyjście pozostaje osiągalne w dowolnym momencie po lekcji")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "Station 15 musi mieć Lenę")
	if player != null:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
		_expect(bool(station.get("is_level_completed")), "Station 15 kończy się w AirlockZone przy włazie w górę")
	_close_station(station)


func _test_vocabulary_and_input() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_15.gd").to_lower()
	for term in FORBIDDEN_STATION_15_TERMS:
		_expect(not source.contains(term), "station_15.gd nie może zawierać terminu: %s" % term)
	_expect(not source.contains("key_"), "station_15.gd nie może hardkodować klawiszy; wyłącznie semantyczny InputMap")
	for station_number in range(1, 15):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Skrypt wcześniejszej stacji musi być czytelny: %s" % path)
		if file == null:
			continue
		var early_source := file.get_as_text().to_lower()
		file.close()
		for term in ["inny świat", "miejscowa lena", "anchor/yield", "mechanic_cost_observed"]:
			_expect(not early_source.contains(term), "%s nie może zawierać terminu: %s" % [path, term])


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0163 PASS: P9 BUNDLE-22 mutual signal test contracts")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0163 FAILURE: " + failure)
	quit(1)