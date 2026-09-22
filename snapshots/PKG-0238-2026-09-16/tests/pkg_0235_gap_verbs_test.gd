extends SceneTree

## PKG-0235 gate — Pakiet C: luki mowia o tej grze (decyzja D-247).
##
## Dowodzi wylacznie mierzalnych kontraktow runtime, nie odbioru (D-012, ADR-003).
## Kryteria (NEXT_SESSION_PROMPT PKG-0235 / plan 2026-09-15 Pakiet C):
## 1. flagi 09/10/11/15 sa czasownikami P9, nie P7 (15 nie jest martwa nazwa);
## 2. mysli 09/10/11 nie nazywaja rekordu pietra / klucza / fotografii;
## 3. wyjscie z 10 po tryptyku Marty nie otwiera s10.key_untried;
## 4. wyjscie z 10 bez granicy Marty otwiera luke o stole; 11 nie przyjmie karty;
## 5. P7-proba klucza w 10 nie zamyka luki P9;
## 6. wyjscie z 11 po wyciagu nie otwiera luki o fotografii;
## 7. C2: passage_required na 11 i key_trial_required na 11 nie mapuja na fotografie.

const GapLedgerScript := preload("res://scripts/campaign/gap_ledger.gd")
const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0235 FAILURE: " + message)


func _open(num: int) -> Node2D:
	var packed := load("res://scenes/levels/station_%02d.tscn" % num) as PackedScene
	_expect(packed != null, "scena station_%02d musi sie ladowac" % num)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close(station: Node) -> void:
	if station == null:
		return
	station.queue_free()
	await process_frame


func _state() -> Node:
	return root.get_node_or_null("GameStateManager")


func _reset() -> Node:
	var state := _state()
	if state:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = false
	return state


func _depart(station: Node) -> void:
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))


func _thought(state: Node, gap_id: String) -> String:
	if state == null:
		return ""
	var record: Variant = state.open_gaps.get(gap_id, {})
	if record is Dictionary:
		return String((record as Dictionary).get("thought_pl", ""))
	return ""


func _resolved(station_id: String, feedback: String) -> String:
	var overrides: Dictionary = GapLedgerScript.STATION_FEEDBACK_OVERRIDES
	var mapped := String(overrides.get(station_id + "|" + feedback, ""))
	if mapped.is_empty():
		mapped = String(GapLedgerScript.FEEDBACK_TO_GAP.get(feedback, ""))
	return mapped


func _run() -> void:
	_test_catalog_verbs()
	_test_feedback_maps()
	await _test_station_10_p9_triptych_closes()
	await _test_station_10_skip_opens_table()
	await _test_station_10_p7_key_does_not_close()
	await _test_station_11_extract_closes()
	await _test_station_11_card_needs_marta_trace()
	_finish()


func _test_catalog_verbs() -> void:
	print("1. Catalog flags and thoughts must name P9 verbs...")
	var catalog: Dictionary = GapLedgerScript.CATALOG
	var s09: Dictionary = catalog.get("s09.floor_record_unread", {})
	var s10: Dictionary = catalog.get("s10.key_untried", {})
	var s11: Dictionary = catalog.get("s11.photograph_unread", {})
	var s15: Dictionary = catalog.get("s15.signal_unconfirmed", {})
	_expect(not s09.is_empty() and not s10.is_empty() and not s11.is_empty() and not s15.is_empty(),
		"catalog must keep s09/s10/s11/s15 gaps")
	_expect(String(s09.get("station_flag", "")) != "is_floor_record_observed",
		"s09 flag must not be the P7 floor-record var")
	_expect(String(s10.get("station_flag", "")) != "is_key_trial_completed",
		"s10 flag must not be the P7 key-trial var")
	_expect(String(s11.get("station_flag", "")) != "is_private_photograph_inspected",
		"s11 flag must not be the P7 photograph var")
	_expect(String(s15.get("station_flag", "")) != "is_local_signal_confirmed",
		"s15 flag must not be the dead is_local_signal_confirmed name")
	_expect(String(s15.get("station_flag", "")) == "is_signal_confirmed",
		"s15 flag must be the real is_signal_confirmed var")
	var t09 := String(s09.get("thought_pl", "")).to_lower()
	var t10 := String(s10.get("thought_pl", "")).to_lower()
	var t11 := String(s11.get("thought_pl", "")).to_lower()
	_expect(t09.contains("sypialni") or t09.contains("fotograf"),
		"s09 thought must be about the living-room triptych, not a floor record")
	_expect(not t09.contains("rekord"), "s09 thought must not name a floor record")
	_expect(t10.contains("mart") and t10.contains("stol"),
		"s10 thought must be about Marta at the table")
	_expect(not t10.contains("klucz"), "s10 thought must not name the key")
	_expect(t11.contains("wyciag") or t11.contains("rejestr"),
		"s11 thought must be about the UCP extract")
	_expect(not t11.contains("fotograf"), "s11 thought must not name the photograph")
	var s09_text := FileAccess.get_file_as_string("res://scripts/levels/station_09.gd")
	var s10_text := FileAccess.get_file_as_string("res://scripts/levels/station_10.gd")
	var s11_text := FileAccess.get_file_as_string("res://scripts/levels/station_11.gd")
	var s15_text := FileAccess.get_file_as_string("res://scripts/levels/station_15.gd")
	_expect(s09_text.contains("var " + String(s09.get("station_flag", ""))),
		"station_09 must declare the catalog flag")
	_expect(s10_text.contains("var " + String(s10.get("station_flag", ""))),
		"station_10 must declare the catalog flag")
	_expect(s11_text.contains("var " + String(s11.get("station_flag", ""))),
		"station_11 must declare the catalog flag")
	_expect(s15_text.contains("var is_signal_confirmed"),
		"station_15 must keep var is_signal_confirmed")


func _test_feedback_maps() -> void:
	print("2. Feedback maps must not send 11's card/passage to a photograph...")
	_expect(_resolved("station_11", "passage_required") != "s11.photograph_unread",
		"station_11|passage_required must not map to the photograph gap")
	_expect(_resolved("station_11", "key_trial_required") != "s11.photograph_unread",
		"key_trial_required on 11 must not mean missing photograph")
	var nongap: Array = GapLedgerScript.NON_GAP_FEEDBACKS
	_expect(nongap.has("method_snapshot_locked"), "pin 0233: method_snapshot_locked stays NON_GAP")
	_expect(nongap.has("finale_execution_started"), "pin 0233: finale_execution_started stays NON_GAP")


func _test_station_10_p9_triptych_closes() -> void:
	print("3. Leaving 10 after Marta's triptych must not open s10.key_untried...")
	var state := _reset()
	if state:
		state.record_decision(&"p9.mystery.home.trace", "two_lives_without_claim")
	var station := await _open(10)
	if station == null:
		return
	_expect(bool(station.perform_home_task()), "10 home_task must register")
	_expect(bool(station.hear_marta_day()), "10 marta_day must register")
	_expect(bool(station.accept_marta_boundary()), "10 marta_boundary must register")
	_depart(station)
	await physics_frame
	_expect(state != null and not bool(state.call("has_open_gap", &"s10.key_untried")),
		"P9 triptych on 10 must close s10.key_untried")
	await _close(station)


func _test_station_10_skip_opens_table() -> void:
	print("4. Leaving 10 without the boundary opens a table thought; 11 refuses the card...")
	var state := _reset()
	var station := await _open(10)
	if station == null:
		return
	_depart(station)
	await physics_frame
	_expect(state != null and bool(state.call("has_open_gap", &"s10.key_untried")),
		"leaving 10 without Marta's boundary must open s10.key_untried")
	var thought := _thought(state, "s10.key_untried").to_lower()
	_expect(thought.contains("stol"), "opened 10 gap thought must be about the table")
	_expect(not thought.contains("klucz"), "opened 10 gap thought must not name the key")
	await _close(station)
	var desk := await _open(11)
	if desk == null:
		return
	_expect(not bool(desk.present_identity_card()),
		"11 must refuse the card without p9.mystery.marta.trace")
	await _close(desk)


func _test_station_10_p7_key_does_not_close() -> void:
	print("5. P7 key trial on 10 must not satisfy the P9 gap...")
	var state := _reset()
	if state:
		state.record_decision(&"p9.threshold_obstacle.foreign_daily_life.neighbour_account", "twelve_lower_fourteen_home")
	var station := await _open(10)
	if station == null:
		return
	_expect(bool(station.inspect_key_wear()), "P7 key wear stays callable")
	_expect(bool(station.test_key_without_claiming_home()), "P7 key trial stays callable")
	_expect(bool(station.get("is_key_trial_completed")), "P7 flag is set")
	_depart(station)
	await physics_frame
	_expect(state != null and bool(state.call("has_open_gap", &"s10.key_untried")),
		"P7 key trial must not close the P9 Marta-table gap")
	await _close(station)


func _test_station_11_extract_closes() -> void:
	print("6. Leaving 11 after the extract must not open a photograph gap...")
	var state := _reset()
	if state:
		state.record_decision(&"p9.mystery.marta.trace", "independent_day_with_boundary")
	var station := await _open(11)
	if station == null:
		return
	_expect(bool(station.present_identity_card()), "11 card must register")
	_expect(bool(station.read_186_day_record()), "11 record must register")
	_expect(bool(station.request_minimal_report()), "11 extract must register")
	_depart(station)
	await physics_frame
	_expect(state != null and not bool(state.call("has_open_gap", &"s11.photograph_unread")),
		"P9 extract on 11 must close s11.photograph_unread")
	await _close(station)


func _test_station_11_card_needs_marta_trace() -> void:
	print("7. Station 11 card still requires p9.mystery.marta.trace...")
	var state := _reset()
	var station := await _open(11)
	if station == null:
		return
	_expect(not bool(station.present_identity_card()),
		"11 card stays gated on marta.trace")
	if state:
		state.record_decision(&"p9.mystery.marta.trace", "independent_day_with_boundary")
	_expect(bool(station.present_identity_card()),
		"11 card accepts after marta.trace")
	await _close(station)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0235 PASS: gap verbs are P9; 10/11 departures name the missed campaign act.")
		quit(0)
	else:
		print("PKG-0235 FAIL: %d" % _failures.size())
		for item in _failures:
			print("  - ", item)
		quit(1)
