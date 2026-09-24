extends SceneTree

## PKG-0232 gate — łańcuch przyczynowy kampanii (decyzja D-244, pakiet A+D1/D3/D4).
##
## Dowodzi wyłącznie mierzalnych kontraktów runtime, nie odbioru (D-012, ADR-003).
## Zakres: inwariant przejść i wiedzy na punktach nieodwracalnych, brak
## domyślnego 42A na normalnej ścieżce, kolejność wykonanie→stan→skutek w
## 42A/B/C, atomowy epilog 43 oraz powrót→ponowny marsz bez blokady
## `_handled_completions` (S-07). Wyjścia pozostają otwarte od wejścia (D-227);
## strażnicy stoją na completion, nie na drzwiach.
##
## 1. zero-interaction route nie fabrykuje wiedzy;
## 2. 18 bez metody nie osiąga 42A/B/C (normalna ścieżka progowa);
## 3. odmowa Jakuba nadal blokuje wszystkie trzy metody (D-242);
## 4. każdy wariant 42 odrzuca krok 2 przed krokiem 1 i krok 3 przed krokiem 2;
## 5. 43 odrzuca bezpośredni blackout (progowy i funkcyjny);
## 6. pięć linii epilogu jest osiągalnych przed końcem;
## 7. przód→powrót→przód na macierzy: zwykła krawędź, 17→18, 18→42, 42→43;
## 8. save/reload zachowuje spójność method → finale → executed → ending_family.

const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")
const CampaignChain := preload("res://tests/support/campaign_chain.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0232 FAILURE: " + message)


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


## PKG-0242 (R1): since PKG-0239 18 reads Jakub's scope conversation from 17
## and the finales accept only a chain NarrativeRules.committed recognises.
## Seeds are the recorded pre-17 input run plus the real 17/18 scenes.
func _seed_18_entry(state: Node, scope: String) -> void:
	CampaignChain.seed_before_17(state)
	_expect(await CampaignChain.record_scope(self, scope), "17 zapisuje zakres %s" % scope)


func _seed_18_answered(state: Node, method: String, marta: String) -> void:
	await _seed_18_entry(state, "granted")
	_expect(await CampaignChain.propose_method(self, method, marta), "18 nazywa %s" % method)
	_expect(await CampaignChain.answer_method(self, "accepted"), "17 odpowiada na %s" % method)


func _seed_42_entry(state: Node, method: String, marta: String, scope: String) -> void:
	CampaignChain.seed_before_17(state)
	_expect(await CampaignChain.commit_chain(self, method, marta, scope), "lancuch %s/%s/%s zatwierdzony" % [method, marta, scope])


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istniec")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	state.test_mode_enabled = true
	await _test_zero_interaction(state)
	await _test_18_guards(state)
	await _test_42a_order(state)
	await _test_42b_order(state)
	await _test_42c_order(state)
	await _test_43_epilogue(state)
	await _test_save_reload(state)
	await _test_forward_back_forward(state)
	state.campaign_auto_transition_enabled = true
	state.test_mode_enabled = false
	state.reset_campaign(true)
	_finish()


# ─── 1. zero-interaction ─────────────────────────────────────────────────

func _test_zero_interaction(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open(state, 18)
	if station == null:
		return
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(not bool(station.get("is_level_completed")), "18 bez metody nie commituje progu")
	_expect(not state.decisions.has(&"method_committed"), "zero-interaction nie fabrykuje metody")
	_expect(not state.decisions.has(&"p9.method_commitment.method_committed"), "zero-interaction nie fabrykuje metody (ns)")
	_expect(not state.decisions.has(&"campaign_finale"), "zero-interaction nie fabrykuje finalu")
	_expect(String(state.call("get_selected_finale_id")) == "", "zero-interaction nie wybiera finalu")
	await _close(station)


# ─── 2+3. guards 18 ──────────────────────────────────────────────────────

func _commit_name(method: StringName) -> StringName:
	match method:
		&"force_home":
			return &"commit_force_home"
		&"close_equal_recover_local":
			return &"commit_close_equal"
	return &"commit_mutual_passage"


func _test_18_guards(state: Node) -> void:
	for method in [&"force_home", &"close_equal_recover_local", &"mutual_passage"]:
		await _seed_18_entry(state, "refused")
		# The method is named at the post (first visit); Jakub has refused.
		_expect(await CampaignChain.propose_method(self, String(method), "partial"), "18 nazywa %s mimo odmowy" % String(method))
		var station := await _open(state, 18)
		if station == null:
			return
		_expect(not bool(station.call(_commit_name(method))), "refused blokuje %s" % String(method))
		_expect(not bool(station.get("is_method_committed")), "refused nie commituje")
		await _close(station)
	# granted: pełny łańcuch (zakres → nazwanie → odpowiedź) przechodzi i domyka próg.
	await _seed_18_answered(state, "force_home", "partial")
	var full := await _open(state, 18)
	if full == null:
		return
	_expect(bool(full.get("are_forecasts_compared")), "zestawienie wychodzi")
	_expect(bool(full.get("is_marta_truth_disclosed")), "prawda wychodzi")
	_expect(bool(full.call("commit_force_home")), "granted commituje force_home")
	ThresholdBinderScript.complete_from_test(full, full.get_node_or_null("Player"))
	await physics_frame
	_expect(bool(full.get("is_level_completed")), "18 z metoda commituje prog")
	_expect(String(state.decisions.get(&"method_committed", "")) == "force_home", "metoda zapisana")
	_expect(String(state.call("get_selected_finale_id")) == "station_42a", "finale wynika z metody")
	await _close(full)


# ─── 4. kolejność 42 ─────────────────────────────────────────────────────

func _test_42a_order(state: Node) -> void:
	await _seed_42_entry(state, "force_home", "partial", "granted")
	var station := await _open_named(state, "station_42a")
	if station == null:
		return
	_expect(not bool(station.call("read_sealed_other_lena")), "42A: stan przed wykonaniem odrzucony")
	_expect(String(station.get("last_feedback")) == "return_execution_required", "42A: luka nazywa wykonanie")
	_expect(not bool(station.call("read_household_consequence")), "42A: skutek przed stanem odrzucony")
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(not bool(station.get("is_level_completed")), "42A: golas nie commituje progu")
	_expect(not state.decisions.has(&"p9.finale.forced_return.household_consequence"), "42A: skutek nie powstaje przed wykonaniem")
	_expect(bool(station.call("execute_forced_return")), "42A: wykonanie przechodzi")
	_expect(not bool(station.call("read_household_consequence")), "42A: skutek przed stanem nadal odrzucony")
	_expect(String(station.get("last_feedback")) == "sealed_state_required", "42A: luka nazywa stan")
	_expect(bool(station.call("read_sealed_other_lena")), "42A: stan po wykonaniu przechodzi")
	_expect(bool(station.call("read_household_consequence")), "42A: skutek po stanie przechodzi")
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(bool(station.get("is_level_completed")), "42A: pelny lancuch commituje prog")
	await _close(station)


func _test_42b_order(state: Node) -> void:
	await _seed_42_entry(state, "close_equal_recover_local", "partial", "limited")
	var station := await _open_named(state, "station_42b")
	if station == null:
		return
	# PKG-0239 order: start the recovery → the local Lena answers → close the
	# flow → household.
	_expect(not bool(station.call("read_local_lena_recovered")), "42B: stan przed wykonaniem odrzucony")
	_expect(String(station.get("last_feedback")) == "recovery_preparation_required", "42B: luka nazywa wykonanie")
	_expect(not bool(station.call("read_household_consequence")), "42B: skutek przed stanem odrzucony")
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(not bool(station.get("is_level_completed")), "42B: golas nie commituje progu")
	_expect(bool(station.call("execute_close_flow")), "42B: wykonanie przechodzi")
	_expect(not bool(station.call("execute_close_flow")), "42B: kanal nie zamyka sie przed odpowiedzia miejscowej")
	_expect(String(station.get("last_feedback")) == "recovered_state_required", "42B: luka nazywa stan")
	_expect(bool(station.call("read_local_lena_recovered")), "42B: stan po wykonaniu przechodzi")
	_expect(not bool(station.call("read_household_consequence")), "42B: skutek przed zamknieciem odrzucony")
	_expect(String(station.get("last_feedback")) == "flow_closure_required", "42B: luka nazywa zamkniecie")
	_expect(bool(station.call("execute_close_flow")), "42B: zamkniecie po odpowiedzi przechodzi")
	_expect(bool(station.call("read_household_consequence")), "42B: skutek po stanie przechodzi")
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(bool(station.get("is_level_completed")), "42B: pelny lancuch commituje prog")
	await _close(station)


func _test_42c_order(state: Node) -> void:
	# Mutual passage needs the full record and Marta's key (PKG-0239).
	await _seed_42_entry(state, "mutual_passage", "full", "granted")
	var station := await _open_named(state, "station_42c")
	if station == null:
		return
	_expect(not bool(station.call("read_memory_leak")), "42C: stan przed wykonaniem odrzucony")
	_expect(String(station.get("last_feedback")) == "passage_execution_required", "42C: luka nazywa wykonanie")
	_expect(not bool(station.call("read_household_consequence")), "42C: skutek przed stanem odrzucony")
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(not bool(station.get("is_level_completed")), "42C: golas nie commituje progu")
	_expect(bool(station.call("execute_mutual_passage")), "42C: wykonanie przechodzi")
	_expect(not bool(station.call("read_household_consequence")), "42C: skutek przed stanem nadal odrzucony")
	_expect(String(station.get("last_feedback")) == "leak_state_required", "42C: luka nazywa stan")
	_expect(bool(station.call("read_memory_leak")), "42C: stan po wykonaniu przechodzi")
	_expect(bool(station.call("read_household_consequence")), "42C: skutek po stanie przechodzi")
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(bool(station.get("is_level_completed")), "42C: pelny lancuch commituje prog")
	await _close(station)


# ─── 5+6. epilog 43 ──────────────────────────────────────────────────────

func _test_43_epilogue(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open_named(state, "station_43")
	if station == null:
		return
	_expect(not bool(station.call("inspect_blackout")), "43: golas odrzuca blackout")
	_expect(String(station.get("last_feedback")) == "epilogue_sequence_incomplete", "43: luka nazywa sekwencje")
	_expect(not bool(station.get("is_level_completed")), "43: golas nie konczy kampanii")
	_expect(not bool(state.call("is_campaign_completed")), "43: golas nie zapisuje ukonczenia")
	ThresholdBinderScript.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(not bool(station.get("is_level_completed")), "43: prog bez lancucha nie konczy")
	_expect(bool(station.call("inspect_notice")), "43: tablica przechodzi")
	_expect(bool(station.call("inspect_credits")), "43: napisy przechodza")
	var lines: Array = station.get("dialogue_lines") as Array
	_expect(lines.size() >= 5, "43: epilog ma >= 5 linii")
	_expect(int(station.get("dialogue_index")) >= 4, "43: piec linii osiagalnych przed koncem")
	_expect(bool(station.call("inspect_blackout")), "43: blackout po lancuchu przechodzi")
	_expect(bool(station.get("is_level_completed")), "43: lancuch konczy kampanie")
	_expect(bool(state.call("is_campaign_completed")), "43: ukonczenie zapisane")
	await _close(station)


# ─── 8. save/reload ──────────────────────────────────────────────────────

func _test_save_reload(state: Node) -> void:
	state.reset_campaign(true)
	state.call("select_finale_method", "force_home")
	state.record_decision(&"p9.method_commitment.marta_truth_state", "partial")
	state.record_decision(&"marta_truth_state", "partial")
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "granted")
	state.record_decision(&"jakub_consent_state", "granted")
	state.record_decision(&"p9.finale.forced_return.executed", true)
	state.record_decision(&"p9.finale.forced_return.household_consequence", {"marta": "partial", "jakub": "granted"})
	state.record_decision(&"ending_family", "force_home")
	state.record_decision(&"ending_stability", "named_gaps")
	_expect(bool(state.call("save_campaign")), "zapis kampanii wychodzi")
	_expect(bool(state.call("reload_campaign_from_disk")), "odczyt kampanii wychodzi")
	_expect(String(state.call("get_selected_finale_id")) == "station_42a", "reload: finale wynika z metody")
	_expect(bool(state.decisions.get(&"p9.finale.forced_return.executed", false)), "reload: wykonanie trwa")
	var household: Variant = state.decisions.get(&"p9.finale.forced_return.household_consequence", {})
	_expect(household is Dictionary and str((household as Dictionary).get("marta", "")) == "partial", "reload: skutek trwa")
	var epilogue := await _open_named(state, "station_43")
	if epilogue == null:
		return
	_expect(String(epilogue.get("ending_family")) == "force_home", "reload: 43 czyta rodzine z metody")
	await _close(epilogue)


# ─── 7. przód→powrót→przód (prawdziwe tranzycje) ──────────────────────────

func _scene_id_of(state: Node, node: Node) -> String:
	var suffix := String(node.name).trim_prefix("Station").to_lower()
	return String(state.call("_normalize_station_id", StringName("station_" + suffix)))


func _await_scene(state: Node, station_id: String, timeout_s: float = 8.0) -> Node:
	var waited := 0.0
	while waited < timeout_s:
		await create_timer(0.25).timeout
		waited += 0.25
		var current: Node = current_scene
		if current != null and _scene_id_of(state, current) == station_id:
			# Tranzycja GSM kończy się fade-in już PO podmianie sceny;
			# kolejne przejście w trakcie fade przepadłoby w
			# transition_to_scene (flaga _transitioning). Czekamy na ciszę.
			var guard := 0
			while bool(state.call("is_transitioning")) and guard < 120:
				await process_frame
				guard += 1
			for f in range(6):
				await process_frame
				await physics_frame
			return current_scene as Node
	return null


func _go_to(state: Node, station_id: String) -> Node:
	state.call("transition_to_station", StringName(station_id))
	return await _await_scene(state, station_id)


func _complete_current(_state: Node) -> Node:
	var current: Node = current_scene
	_expect(current != null, "biezaca scena istnieje")
	if current == null:
		return null
	var player: Node = current.get_node_or_null("Player")
	ThresholdBinderScript.complete_from_test(current, player)
	return current


func _return_current(_state: Node) -> void:
	var current: Node = current_scene
	_expect(current != null, "biezaca scena istnieje (powrot)")
	if current == null:
		return
	var zone: Node = current.get_node_or_null("ReturnZone")
	_expect(zone != null, "%s ma ReturnZone" % String(current.name))
	if zone == null:
		return
	_expect(bool(zone.call("trigger_return", null, true)), "trigger_return dziala instant")


func _test_forward_back_forward(state: Node) -> void:
	state.campaign_auto_transition_enabled = true
	# Krawędź zwykła 10→11.
	state.reset_campaign(true)
	var at10 := await _go_to(state, "station_10")
	_expect(at10 != null, "dojscie do 10")
	if at10 != null:
		_complete_current(state)
		var at11 := await _await_scene(state, "station_11")
		_expect(at11 != null, "10 prowadzi do 11")
		if at11 != null:
			_return_current(state)
			var back10 := await _await_scene(state, "station_10")
			_expect(back10 != null, "powrot 11→10")
			if back10 != null:
				_complete_current(state)
				_expect(await _await_scene(state, "station_11") != null, "ponowny marsz 10→11")
	# Krawędź powrotu fabularnego 17→18 (wejście z prawej).
	state.reset_campaign(true)
	var at17 := await _go_to(state, "station_17")
	_expect(at17 != null, "dojscie do 17")
	if at17 != null:
		_complete_current(state)
		var at18 := await _await_scene(state, "station_18")
		_expect(at18 != null, "17 prowadzi do 18")
		if at18 != null:
			_return_current(state)
			var back17 := await _await_scene(state, "station_17")
			_expect(back17 != null, "powrot 18→17")
			if back17 != null:
				_complete_current(state)
				_expect(await _await_scene(state, "station_18") != null, "ponowny marsz 17→18")
	# Krawędź 18→42 z metodą (czasowniki na żywej instancji).
	state.campaign_auto_transition_enabled = false
	await _seed_18_answered(state, "force_home", "partial")
	state.campaign_auto_transition_enabled = true
	var live18 := await _go_to(state, "station_18")
	_expect(live18 != null, "dojscie do 18")
	if live18 != null:
		_expect(bool(live18.get("are_forecasts_compared")), "18: zestawienie (macierz)")
		_expect(bool(live18.get("is_marta_truth_disclosed")), "18: prawda (macierz)")
		_expect(bool(live18.call("commit_force_home")), "18: commit (macierz)")
		_complete_current(state)
		var at42 := await _await_scene(state, "station_42a")
		_expect(at42 != null, "18 z metoda prowadzi do 42A")
		if at42 != null:
			_return_current(state)
			var back18 := await _await_scene(state, "station_18")
			_expect(back18 != null, "powrot 42A→18")
			if back18 != null:
				_complete_current(state)
				_expect(await _await_scene(state, "station_42a") != null, "ponowny marsz 18→42A bez ponownego commita")
	# Krawędź 42→43 z pełnym łańcuchem.
	state.campaign_auto_transition_enabled = false
	await _seed_42_entry(state, "force_home", "partial", "granted")
	state.campaign_auto_transition_enabled = true
	var live42 := await _go_to(state, "station_42a")
	_expect(live42 != null, "dojscie do 42A")
	if live42 != null:
		_expect(bool(live42.call("execute_forced_return")), "42A: wykonanie (macierz)")
		_expect(bool(live42.call("read_sealed_other_lena")), "42A: stan (macierz)")
		_expect(bool(live42.call("read_household_consequence")), "42A: skutek (macierz)")
		_complete_current(state)
		var at43 := await _await_scene(state, "station_43")
		_expect(at43 != null, "42A z lancuchem prowadzi do 43")
		if at43 != null:
			_return_current(state)
			var back42 := await _await_scene(state, "station_42a")
			_expect(back42 != null, "powrot 43→42A")
			if back42 != null:
				_complete_current(state)
				_expect(await _await_scene(state, "station_43") != null, "ponowny marsz 42A→43 bez ponownego lancucha")
	state.campaign_auto_transition_enabled = false


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0232 PASS: causal chain holds (no default finale, ordered 42, atomic 43, repeat navigation, save coherence)")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0232 FAILURE: " + failure)
	quit(1)
