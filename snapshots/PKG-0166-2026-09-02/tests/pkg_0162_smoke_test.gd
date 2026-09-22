extends SceneTree

## PKG-0162 gate — P9 BUNDLE-21, first dead-circuit Anchor/Yield lesson in Station 14.
## Technical proof only: machine's own cycle, three handleable states
## (neutral / held version A / yielded version B with a small cost), safe
## reversal, naming strictly after both behaviors, no softlock, semantic input,
## inherited P7 sequence entry fact. Does NOT prove comprehension or fun.

const FORBIDDEN_STATION_14_TERMS: Array[String] = [
	"inny świat",
	"miejscowa lena",
	"wierzbicka",
	"anchor/yield",
]

const FORBIDDEN_EARLY_TERMS: Array[String] = [
	"inny świat",
	"miejscowa lena",
	"wierzbicka",
	"anchor/yield",
	"mechanic_cost_observed",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0162 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state != null:
		state.campaign_auto_transition_enabled = false
		await _test_neutral_and_yield(state)
		await _test_anchor_reversal_and_naming(state)
		await _test_no_softlock_and_completion(state)
		_test_vocabulary_and_input()
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	_finish()


func _open_station(state: Node) -> Node2D:
	if state != null:
		state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_14.tscn") as PackedScene
	_expect(packed != null, "Scena station_14 musi się ładować")
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	_expect(station != null, "Scena station_14 musi instantować jako Node2D")
	if station == null:
		return null
	root.add_child(station)
	await process_frame
	await physics_frame
	_expect(station.get_node_or_null("ReturnZone") != null and station.has_signal(&"previous_level_requested"),
		"Station 14 musi zachować ReturnZone i sygnał powrotu")
	_expect(station.get_node_or_null("Machine/TractionBridge") != null, "Station 14 musi mieć most sekcji jako AnchorableObject")
	_expect(station.get_node_or_null("Geometry/MachineHousing") is StaticBody2D, "Korpus maszyny musi być stałą geometrią świata")
	var interactions := 1
	for prop in station.get_node_or_null("Props").get_children():
		if prop is MemoryResonancePoint:
			interactions += 1
	_expect(interactions <= 3, "Station 14 musi mieścić się w budżecie trzech istotnych interakcji")
	return station


func _close_station(station: Node) -> void:
	if station == null:
		return
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame


func _test_neutral_and_yield(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	_expect(bool(station.call(&"is_section_live")), "Stan neutralny musi utrzymać wersję A i żywą sekcję")
	station.call(&"observe_machine_cycle")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.cycle_observed", "")) == "machine_cycle_independent",
		"Obserwacja cyklu maszyny musi zostać zapisana")
	station.call(&"release_observed_element")
	station.call(&"run_correction_pulse")
	_expect(not bool(station.call(&"is_section_live")), "Puszczony most musi przejść w wersję B")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.yield_cost_observed", "")) == "dead_section_downstream",
		"Yield musi zostawić jawny mały koszt w stanie, nie w ocenie")
	_expect(not state.decisions.has(&"p9.mechanics.dead_circuit.trace"),
		"Yield sam nie może nazwać metody")
	_close_station(station)


func _test_anchor_reversal_and_naming(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	# Pierwsza poprawna próba natychmiast po wejściu: bez L3/L4 i bez wcześniejszych faktów.
	station.call(&"hold_observed_element")
	station.call(&"run_correction_pulse")
	_expect(bool(station.call(&"is_section_live")), "Utrzymany most musi zachować wersję A")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.anchor_held_through_pulse", "")) == "version_maintained_under_wave",
		"Anchor musi zostać zapisany jako utrzymanie obserwowanej wersji pod falą")
	_expect(not state.decisions.has(&"p9.mechanics.dead_circuit.trace"),
		"Anchor sam nie może nazwać metody")
	# Yield z jawnym kosztem.
	station.call(&"release_observed_element")
	station.call(&"run_correction_pulse")
	_expect(not bool(station.call(&"is_section_live")), "Puszczony most musi przejść w wersję B")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.yield_cost_observed", "")) == "dead_section_downstream",
		"Yield musi zostawić jawny mały koszt w stanie, nie w ocenie")
	# Bezpieczne odwrócenie: kolejna fala bez utrzymania przywraca wersję A.
	station.call(&"run_correction_pulse")
	_expect(bool(station.call(&"is_section_live")), "Fala bez utrzymania musi bezpiecznie przywrócić wersję A")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.version_restored", "")) == "version_a_returned_by_cycle",
		"Bezpieczne odwrócenie musi zostać zapisane")
	_expect(String(state.decisions.get(&"p9.mechanics.dead_circuit.trace", "")) == "two_behaviors_before_named",
		"Nazwanie musi nastąpić po wykonaniu obu zachowań")
	_expect(String(state.decisions.get(&"p7.marta_threshold.trace", "")) == "dead_circuit_lesson_observed",
		"Lekcja musi zostawić dziedziczony ślad wejścia do Station 15")
	_expect(bool(station.get("is_exit_unlocked")), "Wyjście musi otworzyć się po obu zachowaniach")
	_close_station(station)


func _test_no_softlock_and_completion(state: Node) -> void:
	var station := await _open_station(state)
	if station == null:
		return
	station.call(&"release_observed_element")
	station.call(&"run_correction_pulse")
	station.call(&"hold_observed_element")
	station.call(&"run_correction_pulse")
	_expect(bool(station.get("is_exit_unlocked")), "Wyjście otwiera się po obu zachowaniach niezależnie od wersji")
	_expect(not bool(station.call(&"is_section_live")), "Utrzymana wersja B pozostaje martwa bez dodatkowej kary")
	station.call(&"release_observed_element")
	station.call(&"run_correction_pulse")
	_expect(bool(station.call(&"is_section_live")), "Bezpieczne odwrócenie dostępne w dowolnym momencie")
	_expect(bool(station.get("is_exit_unlocked")), "Wyjście pozostaje otwarte bez softlocka")
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "Station 14 musi mieć Lenę")
	if player != null:
		player.global_position = Vector2(596.0, 238.0)
		await physics_frame
		await physics_frame
		_expect(bool(station.get("is_level_completed")), "Station 14 kończy się w AirlockZone po lekcji")
	_close_station(station)


func _test_vocabulary_and_input() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/levels/station_14.gd").to_lower()
	for term in FORBIDDEN_STATION_14_TERMS:
		_expect(not source.contains(term), "station_14.gd nie może zawierać przedwczesnego terminu: %s" % term)
	for station_number in range(1, 14):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Skrypt wcześniejszej stacji musi być czytelny: %s" % path)
		if file == null:
			continue
		var early_source := file.get_as_text().to_lower()
		file.close()
		for term in FORBIDDEN_EARLY_TERMS:
			_expect(not early_source.contains(term), "%s nie może zawierać terminu: %s" % [path, term])
	_expect(not source.contains("key_"), "station_14.gd nie może hardkodować klawiszy; wyłącznie semantyczny InputMap")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0162 PASS: P9 BUNDLE-21 dead-circuit mechanic lesson contracts")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0162 FAILURE: " + failure)
	quit(1)