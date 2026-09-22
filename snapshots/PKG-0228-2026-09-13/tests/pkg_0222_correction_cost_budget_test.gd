extends SceneTree

## PKG-0222 gate — korekta z kosztem + budżety (M7+M5+M10, faza R5 planu PKG-0213 §8).
## Decyzja D-235. Dowodzi wylacznie kontraktow mierzalnych, nie odbioru (D-012, ADR-003).
##
## M7 (korekta §5.1, 14/15): puszczony most/krok = stan kosztu + linia L2 +
## zapis kosztu + zanik wizualny; zero KillZone w kampanii. Wyjscia sa otwarte
## z automatu (D-227: GSM node_added → GapLedger.ensure_exit_open), wiec bramka
## NIE uzywa is_exit_unlocked jako dowodu sciezki — dowodzi faktow i stanow.
## M5 (budzety): 15/18 ≤3 interakcje — distinct MRP ≤3 (0163 pinuje 15; tu pin
## dla 18) + sciezka krytyczna ≤3 distinct czasownikow tresci (15: log /
## kontrola / korekta z auto-notatka; 18: zestawienie / prawda / zatwierdzenie
## po usunieciu auto-domykania donora). Lancuch MRP 15 (4 fazy nadajnika)
## pozostaje ZAPINOWANY przez pkg_0194 (swiadome uzbrojenie) — nietkniety.
## M10 (rodziny): select_operation to wylacznie routing (GSM, D-223 intact),
## zero fabrykacji donora/zestawienia/prawdy/metody; brak inwentarza -> luka
## istniejacym feedbackiem (mapa na s18.method_uncommitted, bez zmian GapLedger);
## 01/18 oznaczone constem jako adresy bez przeszkody fizycznej.

const FACT_14_COST := &"p9.mechanics.dead_circuit.yield_cost_observed"
const FACT_15_FEEDBACK := &"p9.mechanics.mutual_signal.safe_trial_feedback"
const FACT_15_COST := &"p9.mechanics.mutual_signal.yield_cost_observed"
const FACT_15_CORRECTIVE := &"p9.mechanics.mutual_signal.corrective_response_observed"
const FACT_15_NOTE := &"p9.mechanics.mutual_signal.abort_note_read"
const FACT_18_METHOD := &"p9.method_commitment.method_committed"
const DONOR_TRACE := &"p7.work_history_and_record.trace"
const DONOR_TRACE_VALUE := "cost_ledger_and_consent_scope_recorded"
const DONOR_LEDGER := &"p9.consent_and_cost.cost_ledger_read"
const DONOR_OFFER := &"p9.consent_and_cost.adaptation_offer"
const DONOR_SCOPE := &"p9.consent_and_cost.jakub_consent_scope"

var _failures: Array[String] = []
var _op_seen: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0222 FAILURE: " + message)


func _on_op_selected(op: String) -> void:
	_op_seen.append(op)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istniec")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	await _test_14_cost(state)
	await _test_15_cost_and_budget(state)
	await _test_18_select_and_budget(state)
	_test_markers()
	_test_no_killzone()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _open_station(state: Node, num: int) -> Node2D:
	var packed := load("res://scenes/levels/station_%02d.tscn" % num) as PackedScene
	_expect(packed != null, "Scena station_%02d musi sie ladowac" % num)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	_expect(station != null, "Scena station_%02d musi instantowac" % num)
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


func _mrp_count(station: Node) -> int:
	var props := station.get_node_or_null("Props")
	if props == null:
		return -1
	var interactions := 0
	for prop in props.get_children():
		if prop is MemoryResonancePoint:
			interactions += 1
	return interactions


func _triggered(station: Node, beat_id: StringName) -> bool:
	var guidance := station.get_node_or_null("NarrativeGuidanceService")
	if guidance == null:
		return false
	var raw: Variant = guidance.get("triggered_beats")
	if not (raw is Dictionary):
		return false
	return bool((raw as Dictionary).get(beat_id, false))


# ─── M7: stacja 14 — puszczony most ───────────────────────────────────────

func _test_14_cost(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open_station(state, 14)
	if station == null:
		return
	_expect(bool(station.call(&"is_section_live")), "14 swiezy most musi byc w wersji A")
	station.call(&"hold_observed_element")
	station.call(&"run_correction_pulse")
	_expect(bool(station.call(&"is_section_live")), "14 utrzymany most musi zachowac wersje A")
	station.call(&"release_observed_element")
	station.call(&"run_correction_pulse")
	_expect(not bool(station.call(&"is_section_live")), "14 puszczony most musi przejsc w wersje B")
	_expect(bool(station.get("has_yielded_to_pulse")), "14 musi pamietac stan kosztu")
	_expect(String(state.decisions.get(FACT_14_COST, "")) == "dead_section_downstream",
		"14 puszczony most musi zapisac koszt sekcji")
	_expect(_triggered(station, &"s14_cost_hypothesis"),
		"14 koszt musi wypowiedziec linie L2 (s14_cost_hypothesis)")
	station.call(&"release_observed_element")
	station.call(&"run_correction_pulse")
	_expect(bool(station.call(&"is_section_live")), "14 kolejny cykl musi przywrocic wersje A")
	_expect(bool(station.get("are_behaviors_named")), "14 oba zachowania musza nazwac metode")
	await _close_station(station)


# ─── M7+M5: stacja 15 — wymuszony krok + budzet ───────────────────────────

func _test_15_cost_and_budget(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.marta_threshold.trace", "dead_circuit_lesson_observed")
	var station := await _open_station(state, 15)
	if station == null:
		return
	# M7: proba odpowiedzi bez protokolu = koszt (stan + L2 + zapis), nie sygnal.
	_expect(not bool(station.call(&"send_corrective_impulse")),
		"15 impuls z bledem bez kontroli musi byc odrzucony")
	_expect(String(state.decisions.get(FACT_15_FEEDBACK, "")) == "controls_incomplete",
		"15 odrzucona proba musi zostawic fakt informacyjny")
	_expect(bool(station.get("has_cost_mark")), "15 swiat musi zapamietac koszt wymuszenia")
	_expect(String(state.decisions.get(FACT_15_COST, "")) == "corrective_forced_without_controls",
		"15 wymuszony krok musi zapisac koszt")
	_expect(_triggered(station, &"s15_living_response"),
		"15 koszt musi wypowiedziec linie L2 (s15_living_response)")
	_expect(not state.decisions.has(&"local_lena_signal_confirmed"),
		"15 wymuszony krok nie moze potwierdzic sygnalu")
	_expect(not bool(station.call(&"read_abort_note")),
		"15 notatka musi byc nieczytelna przed potwierdzeniem")
	# M5: pelna sciezka krytyczna = 3 distinct czasowniki (log / kontrola / korekta).
	_expect(bool(station.call(&"observe_signal_log")), "15 log 20:40 musi zostac odtworzony")
	_expect(bool(station.call(&"send_control_impulse")), "15 pierwsza kontrola musi wyjsc")
	station.call(&"run_response_cycle")
	_expect(bool(station.call(&"send_control_impulse")), "15 druga kontrola musi wyjsc")
	station.call(&"run_response_cycle")
	_expect(bool(station.call(&"send_corrective_impulse")), "15 korekta po kontrolach musi wyjsc")
	station.call(&"run_response_cycle")
	_expect(String(state.decisions.get(FACT_15_CORRECTIVE, "")) == "deliberate_error_corrected_selectively",
		"15 selektywna korekta musi byc jawnym wynikiem")
	_expect(String(state.decisions.get(FACT_15_NOTE, "")) == "abort_condition_before_cost",
		"15 potwierdzenie dorecza notatke (budzet 3 czasownikow)")
	_expect(bool(state.decisions.get(&"local_lena_intent_found", false)),
		"15 zamiar musi byc kanoniczny bez jawnego odczytu")
	_expect(bool(station.call(&"read_abort_note")),
		"15 jawny odczyt po potwierdzeniu musi byc idempotentny")
	# M5: distinct MRP ≤3 (192: 0163 pinuje; tu re-pin).
	_expect(_mrp_count(station) <= 3, "15 musi miescic sie w 3 interakcjach MRP")
	await _close_station(station)


# ─── M10+M5: stacja 18 — select bez auto-domykania + budzet ───────────────

func _seed_donor(state: Node) -> void:
	state.record_decision(DONOR_TRACE, DONOR_TRACE_VALUE)
	state.record_decision(DONOR_LEDGER, true)
	state.record_decision(DONOR_OFFER, "rejected")
	state.record_decision(DONOR_SCOPE, "limited")
	state.record_decision(&"jakub_consent_state", "limited")


func _test_18_select_and_budget(state: Node) -> void:
	# M10: golas (bez donora) — routing dziala, tresci brak, luka mowi.
	state.reset_campaign(true)
	_op_seen.clear()
	var bare := await _open_station(state, 18)
	if bare == null:
		return
	bare.connect(&"operation_selected", _on_op_selected)
	bare.call(&"select_operation", "B")
	_expect(String(state.call(&"get_selected_finale_id")) == "station_42b",
		"18 select musi routowac final B (D-223 intact)")
	_expect(not bool(bare.get("are_forecasts_compared")), "18 select nie moze auto-zestawiac")
	_expect(not bool(bare.get("is_marta_truth_disclosed")), "18 select nie moze auto-ujawniac")
	_expect(not bool(bare.get("is_method_committed")), "18 select nie moze auto-zatwierdzac")
	_expect(not state.decisions.has(DONOR_TRACE), "18 select nie moze fabrykowac sladu donora")
	_expect(not state.decisions.has(DONOR_LEDGER), "18 select nie moze fabrykowac ledgera")
	_expect(not state.decisions.has(DONOR_OFFER), "18 select nie moze fabrykowac oferty")
	_expect(not state.decisions.has(DONOR_SCOPE), "18 select nie moze fabrykowac zakresu")
	_expect(String(bare.get("last_feedback")) == "forecast_and_consent_inventory_required",
		"18 select bez inwentarza musi nazwac luke")
	_expect(_op_seen.size() == 1 and _op_seen[0] == "B", "18 select musi emitowac wybor operacji")
	await _close_station(bare)
	# M10: pelny inwentarz — select routuje cicho, bez luk i bez tresci.
	state.reset_campaign(true)
	_op_seen.clear()
	var full := await _open_station(state, 18)
	if full == null:
		return
	_seed_donor(state)
	_expect(bool(full.call(&"compare_forecast_consent_dependencies")), "18 zestawienie musi wyjsc")
	_expect(bool(full.call(&"disclose_marta_truth_partial")), "18 prawda musi wyjsc")
	full.connect(&"operation_selected", _on_op_selected)
	full.call(&"select_operation", "C")
	_expect(String(state.call(&"get_selected_finale_id")) == "station_42c",
		"18 select z inwentarzem musi routowac final C")
	_expect(String(full.get("last_feedback")) == "", "18 select z inwentarzem nie otwiera luki")
	_expect(not bool(full.get("is_method_committed")), "18 select nigdy nie zatwierdza metody")
	await _close_station(full)
	# M5: jawna sciezka tresci = 3 czasowniki (zestawienie / prawda / zatwierdzenie).
	state.reset_campaign(true)
	var path := await _open_station(state, 18)
	if path == null:
		return
	_seed_donor(state)
	_expect(bool(path.call(&"compare_forecast_consent_dependencies")), "18 krok 1/3 musi wyjsc")
	_expect(bool(path.call(&"disclose_marta_truth_partial")), "18 krok 2/3 musi wyjsc")
	_expect(bool(path.call(&"commit_close_equal")), "18 krok 3/3 musi wyjsc")
	_expect(String(state.decisions.get(FACT_18_METHOD, "")) == "close_equal_recover_local",
		"18 trzy czasowniki domykaja metode")
	_expect(_mrp_count(path) == 3, "18 musi miec dokladnie 3 interakcje MRP")
	await _close_station(path)


# ─── M10: oznaczenia adresow bez przeszkody ───────────────────────────────

func _test_markers() -> void:
	_expect(bool(Station01.IS_PHYSICAL_OBSTACLE_FREE), "01 musi byc oznaczona bez przeszkody")
	_expect(bool(Station18.IS_PHYSICAL_OBSTACLE_FREE), "18 musi byc oznaczona bez przeszkody")
	var s14 := FileAccess.get_file_as_string("res://scripts/levels/station_14.gd")
	_expect(not s14.contains("IS_PHYSICAL_OBSTACLE_FREE := true"), "14 ma fizyczna maszyne — bez oznaczenia")
	var s15 := FileAccess.get_file_as_string("res://scripts/levels/station_15.gd")
	_expect(not s15.contains("IS_PHYSICAL_OBSTACLE_FREE := true"), "15 ma fizyczna petle — bez oznaczenia")


# ─── M7: zero KillZone w kampanii ─────────────────────────────────────────

func _test_no_killzone() -> void:
	for entry in ["res://scripts/levels", "res://scenes/levels"]:
		var dir := DirAccess.open(entry)
		_expect(dir != null, "katalog musi byc czytelny: %s" % entry)
		if dir == null:
			continue
		dir.list_dir_begin()
		var fname := dir.get_next()
		while fname != "":
			if fname.ends_with(".gd") or fname.ends_with(".tscn"):
				var text := FileAccess.get_file_as_string(entry + "/" + fname)
				_expect(not text.contains("KillZone"), "kampania bez KillZone: %s" % fname)
			fname = dir.get_next()
		dir.list_dir_end()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0222 PASS: correction cost + budgets + select without auto-close")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0222 FAILURE: " + failure)
	quit(1)
