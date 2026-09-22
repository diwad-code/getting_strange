extends SceneTree

## PKG-0233 gate — drugi mega-pakiet sensu: B + C/D2/D5 (decyzja D-245).
##
## Dowodzi wylacznie mierzalnych kontraktow runtime, nie odbioru (D-012, ADR-003).
## Zakres (plan PKG-0231, kryteria 1-9 z NEXT_SESSION_PROMPT):
## 1. mysl 10 nie stwierdza pracy w UCP przed biometryka 11;
## 2. zaswiadczenie m. 12 ma materialne zrodlo w 01 i ciaglosc 07->13;
## 3. czytnik ma jawny status proceduralny po 11 (pokwitowanie, pamietane w 12/13);
## 4. synteza 13 ma fizyczny korelat (dwa urzadzenia, ta sama luka);
## 5. 13->14 ma widoczny most czasu/miejsca; 14 nie wraca do starego otwarcia;
## 6. 18->42 ma widoczna czynnosc zatwierdzenia i ciecie noc->swit;
## 7. 42B ma jednoznaczna kontrolowana postac;
## 8. migawka D2 jest atomowa (commit -> powrot -> zmiana -> spojnosc);
## 9. D5: prawda/zgoda/koszt widoczne w kazdym finale i epilogu;
## 10. zero regresji pinow (0226 FACT counts, 0215 NON_GAP, dlugosci linii CRT).
##
## Zero zmian w creative_scene_lines.gd (piny 0194/0195/0217/0226 nietkniete).

const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0233 FAILURE: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "plik musi byc czytelny: %s" % path)
	if file == null:
		return ""
	var text := file.get_as_text()
	file.close()
	return text


func _open(state: Node, num: int) -> Node2D:
	var packed := load("res://scenes/levels/station_%02d.tscn" % num) as PackedScene
	_expect(packed != null, "scena station_%02d musi sie ladowac" % num)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _open_named(_state: Node, station_id: String) -> Node2D:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	_expect(packed != null, "scena %s musi sie ladowac" % station_id)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close(station: Node) -> void:
	station.queue_free()
	await process_frame


func _seed_18_entry(state: Node, scope: String) -> void:
	state.record_decision(&"p7.work_history_and_record.trace", "cost_ledger_and_consent_scope_recorded")
	state.record_decision(&"p9.consent_and_cost.cost_ledger_read", true)
	state.record_decision(&"p9.consent_and_cost.adaptation_offer", "rejected")
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", scope)
	state.record_decision(&"jakub_consent_state", scope)
	state.record_decision(&"p9.mechanics.small_cost.choice", "marta_memory")


func _seed_42_entry(state: Node, method: String, marta: String, scope: String, cost: String) -> void:
	state.record_decision(&"p9.method_commitment.method_committed", method)
	state.record_decision(&"method_committed", method)
	state.record_decision(&"p9.method_commitment.marta_truth_state", marta)
	state.record_decision(&"marta_truth_state", marta)
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", scope)
	state.record_decision(&"jakub_consent_state", scope)
	state.record_decision(&"p9.mechanics.small_cost.choice", cost)


func _seed_recognition(state: Node, sample: bool) -> void:
	state.record_decision(&"home_sample_preserved", sample)
	state.record_decision(&"p9.mystery.home.trace", "two_lives_without_claim")
	state.record_decision(&"p9.mystery.institution.trace", "ucp_profile_against_memory")
	state.record_decision(&"p9.mystery.jakub.trace", "voice_before_person")
	state.record_decision(&"recognition_evidence_public", true)
	state.record_decision(&"recognition_evidence_relational", true)
	state.record_decision(&"recognition_evidence_carried", true)
	state.record_decision(&"p9.mystery.synthesis.marta_source_seen", true)
	state.record_decision(&"p9.mystery.synthesis.institution_source_seen", true)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istniec")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	state.test_mode_enabled = true
	_test_b1_ucp_hypothesis(state)
	await _test_b2_certificate_source(state)
	await _test_b3_reader_receipt(state)
	await _test_b4_device_correlate(state)
	_test_c1_bridge_13_to_14(state)
	await _test_c2_bridge_18_to_42(state)
	_test_c3_focalization_42b(state)
	await _test_d2_snapshot(state)
	await _test_d5_payoff(state)
	_test_pin_compat()
	state.campaign_auto_transition_enabled = true
	state.test_mode_enabled = false
	state.reset_campaign(true)
	_finish()


# ─── 1. B1: mysl 10 jako hipoteza ────────────────────────────────────────

func _test_b1_ucp_hypothesis(_state: Node) -> void:
	var source := _read("res://scripts/levels/station_10.gd")
	_expect(source.contains("s10_exit_ucp_record"), "10 zachowuje zdanie wyjscia s10_exit_ucp_record (pin 0230)")
	_expect(source.contains("Marta twierdzi"), "mysl 10 zaczyna od twierdzenia Marty, nie od wiedzy Leny")
	_expect(source.contains("zanim uznam to za moje"), "mysl 10 odklda uznanie do sprawdzenia zapisu")
	_expect(not source.contains("W UCP, tam pracuj"), "mysl 10 nie stwierdza pracy w UCP przed biometryka 11")


# ─── 2. B2: zaswiadczenie m. 12 z torby w 01 ─────────────────────────────

func _test_b2_certificate_source(state: Node) -> void:
	# Galaz powtorki: pomiar + probka.
	state.reset_campaign(true)
	var rep := await _open(state, 1)
	if rep == null:
		return
	_expect(bool(rep.call("repeat_line_four_measurement")), "01: pomiar wychodzi")
	_expect(bool(rep.call("secure_raw_sample")), "01: probka wychodzi")
	_expect(String(state.decisions.get(&"p9.opening.field_certificate_packed", "")) == "sadowa_7_m12", "powtorka pakuje zaswiadczenie m. 12")
	await _close(rep)
	# Galaz obietnicy: pakowanie bez powtorki.
	state.reset_campaign(true)
	state.record_decision(&"p9.cold_open.completed", true)
	var lea := await _open(state, 1)
	if lea == null:
		return
	_expect(bool(lea.call("pack_equipment_for_marta")), "01: spakowanie wychodzi")
	_expect(String(state.decisions.get(&"p9.opening.field_certificate_packed", "")) == "sadowa_7_m12", "obietnica pakuje to samo zaswiadczenie")
	await _close(lea)
	# Ciaglosc 07->13 istnieje tekstowo na tym samym dokumencie.
	_expect(_read("res://scripts/levels/station_07.gd").contains("mieszkanie 12"), "07 wyjmuje dokument m. 12")
	var lines_script := load("res://scripts/levels/creative_scene_lines.gd") as GDScript
	var marta_pairs: Array = lines_script.call("lines_for", "marta_source", {&"home_sample_preserved": true, &"marta_memories_conflict": true})
	var marta_joined := ""
	for pair: Variant in marta_pairs:
		if pair is Dictionary:
			marta_joined += String((pair as Dictionary).get("text", "")) + "\n"
	_expect(marta_joined.contains("mieszkanie 12"), "13 kladzie na stole ten sam dokument m. 12")


# ─── 3. B3: pokwitowanie czytnika ────────────────────────────────────────

func _test_b3_reader_receipt(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p9.mystery.marta.trace", "independent_day_with_boundary")
	var s11 := await _open(state, 11)
	if s11 == null:
		return
	_expect(bool(s11.call("present_identity_card")), "11: karta wychodzi")
	_expect(bool(s11.call("read_186_day_record")), "11: rejestr wychodzi")
	_expect(bool(s11.call("request_minimal_report")), "11: wyciag wychodzi")
	_expect(String(state.decisions.get(&"p9.mystery.institution.reader_custody_receipt", "")) == "conditional_custody_minimal_scope", "11 wydaje warunkowe pokwitowanie")
	_expect(_read("res://scripts/levels/station_11.gd").contains("s11_reader_receipt"), "11 nazywa pokwitowanie beatem")
	await _close(s11)
	# 12 pamieta status: fakt trwaly + beat przy pierwszym pytaniu.
	var s12 := await _open(state, 12)
	if s12 == null:
		return
	_expect(state.decisions.has(&"p9.mystery.institution.reader_custody_receipt"), "pokwitowanie dociera z 11 do 12")
	_expect(bool(s12.call("ask_jakub_control_questions")), "12: pytania wychodza")
	_expect(_read("res://scripts/levels/station_12.gd").contains("s12_reader_receipt"), "12 wypowiada status pokwitowania")
	await _close(s12)
	# 13 pamieta status: rysunek pokwitowania przy wylozonym zrodle.
	_expect(_read("res://scripts/levels/station_13.gd").contains("reader_custody_receipt"), "13 pamieta pokwitowanie przy stole")


# ─── 4. B4: fizyczny korelat syntezy ─────────────────────────────────────

func _test_b4_device_correlate(state: Node) -> void:
	state.reset_campaign(true)
	_seed_recognition(state, true)
	var s13 := await _open(state, 13)
	if s13 == null:
		return
	_expect(bool(s13.call("mark_marta_source_seen")), "13: zrodlo Marty wychodzi")
	_expect(bool(s13.call("mark_institution_source_seen")), "13: zrodlo UCP wychodzi")
	_expect(bool(s13.call("synthesize_world_difference")), "13: synteza z korelatem wychodzi")
	_expect(bool(state.decisions.get(&"world_recognized", false)), "synteza zapisuje world_recognized")
	await _close(s13)
	var source := _read("res://scripts/levels/station_13.gd")
	_expect(source.contains("s13_device_correlate"), "13 nazywa korelat beatem")
	_expect(source.contains("Dwa urządzenia, jeden niemożliwy brak") or source.contains("Dwa urzadzenia"), "korelat mowi o dwoch urzadzeniach i jednej luce")
	var lines: Dictionary = ((load("res://scripts/levels/creative_scene_lines.gd") as GDScript).get_script_constant_map().get("LINES", {}) as Dictionary)
	_expect(JSON.stringify(lines.get("synthesize", [])).contains("To nie jest mój świat"), "kanoniczna linia syntezy nietknieta (pin 0217)")


# ─── 5. C1: most 13->14 ──────────────────────────────────────────────────

func _test_c1_bridge_13_to_14(state: Node) -> void:
	var s13 := _read("res://scripts/levels/station_13.gd")
	_expect(s13.contains("s13_exit_to_switchyard"), "13 zachowuje beat wyjscia (pin 0230)")
	_expect(s13.contains("Wychodzę z mieszkania"), "wyjscie 13 nazywa opuszczenie mieszkania")
	_expect(s13.contains("włazem serwisowym") or s13.contains("wlazem"), "wyjscie 13 nazywa zejscie wlazem HATCH")
	_expect(s13.contains("sekcj") , "wyjscie 13 wskazuje sekcje rozdzielni z wyciagu")
	_expect(not s13.contains("ktoś przerwał z zewnątrz"), "wyjscie 13 nie przesadza wiedzy z 15 (S-02)")
	var cue14 := _read("res://scenes/levels/station_14.tscn")
	_expect(cue14.contains("20:40"), "wejscie 14 trzyma trop 20:40 (pin 0230)")
	_expect(not cue14.contains("przerwał z zewnątrz"), "wejscie 14 nie zna zewnetrznego przerwania")
	_expect(cue14.contains("włazem serwisowym") or cue14.contains("wlazem"), "wejscie 14 nazywa przybycie wlazem")
	_expect(String(state.call("arrival_side_for", &"station_13", &"station_14")) == "left", "13 -> 14 wchodzi z lewej (pin 0230)")


# ─── 6. C2: most 18->42 ──────────────────────────────────────────────────

func _test_c2_bridge_18_to_42(state: Node) -> void:
	state.reset_campaign(true)
	_seed_18_entry(state, "granted")
	var live18 := await _open(state, 18)
	if live18 == null:
		return
	_expect(bool(live18.call("compare_forecast_consent_dependencies")), "18: zestawienie wychodzi")
	_expect(bool(live18.call("disclose_marta_truth_partial")), "18: prawda wychodzi")
	_expect(bool(live18.call("commit_force_home")), "18: commit wychodzi")
	_expect(state.decisions.has(&"p9.method_commitment.snapshot"), "commit zapisuje migawke (most zaczyna sie przy slupku)")
	await _close(live18)
	for entry: Array in [["station_42a", "zatwierdziłam powrót"], ["station_42b", "zamknęłam przepływ"], ["station_42c", "otworzyłam przejście"]]:
		var cue := _read("res://scenes/levels/%s.tscn" % String(entry[0]))
		_expect(cue.contains("W nocy przy słupku"), "%s nazywa nocna czynnosc zatwierdzenia" % String(entry[0]))
		_expect(cue.contains("O świcie") or cue.contains("Swit") or cue.contains("świcie"), "%s trzyma ciecie w swit" % String(entry[0]))
		_expect(cue.contains(String(entry[1])), "%s nazywa wykonana metode" % String(entry[0]))
	_expect(String(state.call("arrival_side_for", &"station_18", &"station_42a")) == "left", "18 -> 42 wchodzi z lewej (pin 0230)")


# ─── 7. C3: fokalizacja 42B ──────────────────────────────────────────────

func _test_c3_focalization_42b(_state: Node) -> void:
	var cue := _read("res://scenes/levels/station_42b.tscn")
	_expect(cue.contains("przybyłą Leną"), "42B nazywa kontrolowana postac: przybyla Lena")
	_expect(cue.contains("progu"), "42B stawia ja w progu, nie we wnetrzu")
	var script := load("res://scripts/levels/station_42b.gd") as GDScript
	var consts: Dictionary = script.get_script_constant_map()
	_expect((consts.get("DIALOGUE_LINES", []) as Array).size() == 4, "42B trzyma 4 kwestie (pin 0107)")


# ─── 8. D2: atomowa migawka ──────────────────────────────────────────────

func _snapshot(state: Node) -> Dictionary:
	var snap: Variant = state.decisions.get(&"p9.method_commitment.snapshot", {})
	return snap as Dictionary if snap is Dictionary else {}


func _test_d2_snapshot(state: Node) -> void:
	# (a) commit zapisuje jedna spojna migawke.
	state.reset_campaign(true)
	_seed_18_entry(state, "granted")
	var live18 := await _open(state, 18)
	if live18 == null:
		return
	_expect(bool(live18.call("compare_forecast_consent_dependencies")), "D2: zestawienie wychodzi")
	_expect(bool(live18.call("disclose_marta_truth_partial")), "D2: prawda wychodzi")
	_expect(bool(live18.call("commit_force_home")), "D2: commit wychodzi")
	var snap := _snapshot(state)
	for key: String in ["method", "marta_truth", "jakub_consent", "small_cost", "evidence", "finale"]:
		_expect(snap.has(key), "migawka niesie klucz: %s" % key)
	_expect(String(snap.get("method", "")) == "force_home", "migawka: metoda")
	_expect(String(snap.get("marta_truth", "")) == "partial", "migawka: prawda")
	_expect(String(snap.get("jakub_consent", "")) == "granted", "migawka: zgoda")
	_expect(not String(snap.get("small_cost", "")).is_empty(), "migawka: maly koszt z 16")
	var evidence: Dictionary = snap.get("evidence", {}) as Dictionary
	for key: String in ["sample", "signal", "ledger", "forecasts_available"]:
		_expect(evidence.has(key), "migawka: dowod %s" % key)
	_expect(String(snap.get("finale", "")) == "station_42a", "migawka: final wynika z metody")
	await _close(live18)
	# (b) powrot + proba zmiany metody: odmowa, migawka nietknieta.
	var back18 := await _open(state, 18)
	if back18 == null:
		return
	_expect(bool(back18.get("is_method_committed")), "po powrocie commit jest odtworzony")
	_expect(not bool(back18.call("commit_close_equal")), "zmiana metody po powrocie odrzucona")
	_expect(String(_snapshot(state).get("method", "")) == "force_home", "migawka nietknieta po probie zmiany")
	await _close(back18)
	# (c) lock migawki na swiezej instancji z obcym snapshotem.
	state.reset_campaign(true)
	_seed_18_entry(state, "granted")
	state.record_decision(&"p9.method_commitment.snapshot", {"method": "force_home", "finale": "station_42a"})
	var locked := await _open(state, 18)
	if locked == null:
		return
	locked.call("compare_forecast_consent_dependencies")
	locked.call("disclose_marta_truth_partial")
	_expect(not bool(locked.call("commit_close_equal")), "obca migawka blokuje inny commit")
	_expect(String(locked.get("last_feedback")) == "method_snapshot_locked", "blokada migawki nazywa luke")
	await _close(locked)
	# (d) rozpoczecie wykonania w 42 blokuje kazdy commit.
	state.reset_campaign(true)
	_seed_18_entry(state, "granted")
	state.record_decision(&"p9.finale.forced_return.executed", true)
	var exe := await _open(state, 18)
	if exe == null:
		return
	exe.call("compare_forecast_consent_dependencies")
	exe.call("disclose_marta_truth_partial")
	_expect(not bool(exe.call("commit_force_home")), "wykonanie w 42 blokuje commit")
	_expect(String(exe.get("last_feedback")) == "finale_execution_started", "blokada wykonania nazywa luke")
	await _close(exe)
	# (e) save/reload trzyma migawke spojnie z metoda i finalem.
	state.reset_campaign(true)
	_seed_18_entry(state, "granted")
	var sav := await _open(state, 18)
	if sav == null:
		return
	sav.call("compare_forecast_consent_dependencies")
	sav.call("disclose_marta_truth_partial")
	sav.call("commit_force_home")
	await _close(sav)
	_expect(bool(state.call("save_campaign")), "zapis z migawka wychodzi")
	_expect(bool(state.call("reload_campaign_from_disk")), "odczyt z migawka wychodzi")
	_expect(String(_snapshot(state).get("method", "")) == "force_home", "reload: migawka trzyma metode")
	_expect(String(state.call("get_selected_finale_id")) == "station_42a", "reload: final spojny z migawka")


# ─── 9. D5: wyplata w finalach i epilogu ─────────────────────────────────

func _test_d5_payoff(state: Node) -> void:
	var methods := {"station_42a": "force_home", "station_42b": "close_equal_recover_local", "station_42c": "mutual_passage"}
	var exec_verbs := {"station_42a": "execute_forced_return", "station_42b": "execute_close_flow", "station_42c": "execute_mutual_passage"}
	var state_verbs := {"station_42a": "read_sealed_other_lena", "station_42b": "read_local_lena_recovered", "station_42c": "read_memory_leak"}
	for finale_id: String in methods.keys():
		for truth: String in ["full", "partial", "withheld"]:
			for scope: String in ["granted", "limited", "refused"]:
				for cost: String in ["marta_memory", "sample_second"]:
					state.reset_campaign(true)
					_seed_42_entry(state, String(methods[finale_id]), truth, scope, cost)
					var station := await _open_named(state, finale_id)
					if station == null:
						return
					_expect(bool(station.call(String(exec_verbs[finale_id]))), "%s: wykonanie (%s/%s/%s)" % [finale_id, truth, scope, cost])
					_expect(bool(station.call(String(state_verbs[finale_id]))), "%s: stan (%s/%s/%s)" % [finale_id, truth, scope, cost])
					_expect(bool(station.call("read_household_consequence")), "%s: skutek (%s/%s/%s)" % [finale_id, truth, scope, cost])
					var household: Variant = station.get("household_consequence")
					_expect(household is Dictionary, "%s: skutek to slownik" % finale_id)
					if household is Dictionary:
						_expect(String((household as Dictionary).get("marta", "")) == truth, "%s: prawda w slowniku" % finale_id)
						_expect(String((household as Dictionary).get("jakub", "")) == scope, "%s: zgoda w slowniku" % finale_id)
						_expect(String((household as Dictionary).get("cost", "")) == cost, "%s: koszt w slowniku" % finale_id)
					_expect(String(station.get("payoff_cost")) == cost, "%s: koszt w zmiennej wyplaty" % finale_id)
					station.set("is_household_read", true)
					station.queue_redraw()
					await process_frame
					await _close(station)
	# Epilog: kazda rodzina x prawda x zgoda x koszt daje linie z trzema klauzulami.
	var families := {"force_home": "Teczka.", "close_equal_recover_local": "drugie zgłoszenie", "mutual_passage": "Dwa rozkłady."}
	var truth_marks := {"full": "pełny zapis", "partial": "część zapisu", "withheld": "zapis wstrzymany", "": "nieustalony"}
	var scope_marks := {"granted": "wyłączniku", "limited": "wskazania", "refused": "odmowa", "": "nieustalony"}
	var cost_marks := {"marta_memory": "kurtki", "sample_second": "wykresu", "": "nieustalony"}
	for family: String in families.keys():
		for truth: String in ["full", "partial", "withheld", ""]:
			for scope: String in ["granted", "limited", "refused", ""]:
				for cost: String in ["marta_memory", "sample_second", ""]:
					state.reset_campaign(true)
					state.record_decision(&"ending_family", family)
					state.record_decision(&"ending_stability", "named_gaps")
					if not truth.is_empty():
						state.record_decision(&"marta_truth_state", truth)
					if not scope.is_empty():
						state.record_decision(&"jakub_consent_state", scope)
					if not cost.is_empty():
						state.record_decision(&"p9.mechanics.small_cost.choice", cost)
					var epilogue := await _open_named(state, "station_43")
					if epilogue == null:
						return
					var lines: Array = epilogue.get("dialogue_lines") as Array
					_expect(lines.size() == 5, "43 %s trzyma 5 linii (pin 0232/0170)" % family)
					var payoff := String((lines[2] as Dictionary).get("text", ""))
					_expect(payoff.contains(String(families[family])), "43 %s: linia niesie znacznik rodziny" % family)
					_expect(payoff.contains(String(truth_marks[truth])), "43 %s/%s: linia niesie prawde" % [family, truth])
					_expect(payoff.contains(String(scope_marks[scope])), "43 %s/%s: linia niesie zgode" % [family, scope])
					_expect(payoff.contains(String(cost_marks[cost])), "43 %s/%s: linia niesie koszt" % [family, cost])
					_expect(payoff.length() <= 115, "43 linia wyplaty miesci sie w pudle CRT: %s" % payoff)
					epilogue.queue_redraw()
					await process_frame
					await _close(epilogue)


# ─── 10. Zgodnosc pinow ──────────────────────────────────────────────────

func _fact_const_count(source: String) -> int:
	var count := 0
	for line: String in source.split("\n"):
		if line.strip_edges().begins_with("const FACT_"):
			count += 1
	return count


func _test_pin_compat() -> void:
	# Pin 0226: zero nowych const FACT_ w 18/42 (migawka i koszt ida literalami).
	_expect(_fact_const_count(_read("res://scripts/levels/station_18.gd")) == 14, "18 trzyma 14 const FACT_ (pin 0226)")
	_expect(_fact_const_count(_read("res://scripts/levels/station_42a.gd")) == 15, "42A trzyma 15 const FACT_ (pin 0226)")
	_expect(_fact_const_count(_read("res://scripts/levels/station_42b.gd")) == 16, "42B trzyma 16 const FACT_ (pin 0226)")
	_expect(_fact_const_count(_read("res://scripts/levels/station_42c.gd")) == 16, "42C trzyma 16 const FACT_ (pin 0226)")
	# Pin 0215: nowe feedbacki 18 maja wpisy NON_GAP.
	var ledger := _read("res://scripts/campaign/gap_ledger.gd")
	_expect(ledger.contains("method_snapshot_locked"), "NON_GAP zna method_snapshot_locked (pin 0215)")
	_expect(ledger.contains("finale_execution_started"), "NON_GAP zna finale_execution_started (pin 0215)")
	# Piny 0194/0195 (fit-at-scale): nowe linie cue krotsze niz 100 znakow.
	for path: String in ["res://scenes/levels/station_14.tscn", "res://scenes/levels/station_42a.tscn", "res://scenes/levels/station_42b.tscn", "res://scenes/levels/station_42c.tscn"]:
		var text := _read(path)
		var marker := "opening_line_2 = \""
		var at := text.find(marker)
		_expect(at >= 0, "%s ma druga linie cue" % path)
		if at >= 0:
			var start := at + marker.length()
			var finish := text.find("\"", start)
			_expect(finish > start and finish - start <= 100, "%s: cue_2 miesci sie w skali (pin 0194/0195)" % path)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0233 PASS: story-sense bridges hold (B/C/D2/D5, pins intact)")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0233 FAILURE: " + failure)
	quit(1)
