extends SceneTree

## PKG-0145 contract gate — P7 vertical slice Station 22–25.
## The first RED assertion pins JSON-safe decision persistence before the
## diagnostic sequence is introduced.

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("PKG-0145 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istnieć")
	if state != null:
		state.reset_campaign(true)
		var before: Dictionary = state.decisions.duplicate(true)
		var unsafe_node := Node.new()
		var accepted: Variant = state.record_decision(&"p7.mutual_test.unsafe_node", unsafe_node)
		_expect(accepted == false, "record_decision musi odrzucić Node")
		_expect(state.decisions == before, "Odrzucony Node nie może mutować decisions")
		unsafe_node.free()
		var unsafe_resource := Resource.new()
		before = state.decisions.duplicate(true)
		accepted = state.record_decision(&"p7.mutual_test.unsafe_resource", unsafe_resource)
		_expect(accepted == false, "record_decision musi odrzucić Resource")
		_expect(state.decisions == before, "Odrzucony Resource nie może mutować decisions")
		var unsafe_callable := Callable(self, "_finish")
		before = state.decisions.duplicate(true)
		accepted = state.record_decision(&"p7.mutual_test.unsafe_callable", unsafe_callable)
		_expect(accepted == false, "record_decision musi odrzucić Callable")
		_expect(state.decisions == before, "Odrzucony Callable nie może mutować decisions")
		var unsafe_nested_node := Node.new()
		before = state.decisions.duplicate(true)
		accepted = state.record_decision(&"p7.mutual_test.nested_unsafe", {"payload": [unsafe_nested_node]})
		_expect(accepted == false, "record_decision musi odrzucić Node zagnieżdżony w danych")
		_expect(state.decisions == before, "Odrzucone dane zagnieżdżone nie mogą mutować decisions")
		unsafe_nested_node.free()
		var nested := {
			"outcome": "anchor",
			"facts": [true, {"cost": "adjacent_relay_heat"}],
		}
		accepted = state.record_decision(&"pkg_0145.nested_json", nested)
		_expect(accepted == true, "record_decision musi przyjąć zagnieżdżony JSON")
		_expect(state.save_campaign(), "Zagnieżdżony JSON musi dać się zapisać")
		state.reset_campaign(false)
		_expect(state.reload_campaign_from_disk(), "Zagnieżdżony JSON musi dać się odczytać")
		_expect(
			state.decisions.get(&"pkg_0145.nested_json", {}) == nested,
			"Zagnieżdżony JSON musi przetrwać zapis i odczyt"
		)
		_test_sequence_definition()
		_test_anchor_exclusivity()
		_test_mutual_test_save_migration(state)
		_test_p7_decision_versioning(state)
		await _test_guidance_bounds(state)
		await _test_end_to_end_persistence(state)
		_test_migrated_source_cutover()
		await _test_station_22_gate(state)
		await _test_station_23_trial(state)
		await _test_station_24_boundary(state)
		await _test_station_25_trace(state)
		state.reset_campaign(true)
	_finish()


func _test_sequence_definition() -> void:
	const sequence_path := "res://resources/gameplay/mutual_test_sequence.tres"
	_expect(ResourceLoader.exists(sequence_path), "Sekwencja mutual_test musi istnieć jako Resource")
	if not ResourceLoader.exists(sequence_path):
		return
	var sequence := load(sequence_path) as Resource
	_expect(sequence != null, "Resource mutual_test musi się ładować")
	if sequence == null:
		return
	_expect(sequence.get("sequence_id") == &"mutual_test", "Sekwencja musi mieć stabilne id mutual_test")
	_expect(sequence.get("entry_gate") == &"world_recognized", "Sekwencja musi wymagać world_recognized")
	_expect(sequence.get("station_ids") == [&"station_22", &"station_23", &"station_24", &"station_25"], "Sekwencja musi obejmować dokładnie 22–25")
	_expect(int(sequence.get("migration_revision")) == 1, "Sekwencja musi deklarować rewizję migracji 1")
	var hypothesis_ids: Array[String] = []
	var hypotheses: Array = sequence.get("hypotheses")
	for hypothesis in hypotheses:
		if hypothesis is Resource:
			hypothesis_ids.append(String(hypothesis.get("hypothesis_id")))
			_expect(
				not String(hypothesis.get("predicted_outcome")).is_empty(),
				"Każda hipoteza musi zawierać przewidywalny wynik"
			)
	hypothesis_ids.sort()
	_expect(
		hypothesis_ids == ["adjacent_state_response", "signal_echo"],
		"Sekwencja musi zawierać dwie rozróżnialne hipotezy sygnału"
	)
	var commitment_ids: Array[String] = []
	var commitments: Array = sequence.get("commitments")
	for commitment in commitments:
		if commitment is Resource:
			commitment_ids.append(String(commitment.get("commitment_id")))
			_expect(
				not String(commitment.get("known_cost")).is_empty(),
				"Każde zobowiązanie musi ujawnić koszt"
			)
			_expect(
				not commitment.has_method("get_moral_score"),
				"Zobowiązanie nie może wprowadzać moral score"
			)
	commitment_ids.sort()
	_expect(
		commitment_ids == ["marta_declines_access", "marta_limited_access"],
		"Sekwencja musi zawierać ograniczony dostęp i odmowę Marty"
	)


func _test_anchor_exclusivity() -> void:
	const controller_path := "res://scripts/interactables/anchor_exclusivity_controller.gd"
	_expect(ResourceLoader.exists(controller_path), "Lokalny AnchorExclusivityController musi istnieć")
	if not ResourceLoader.exists(controller_path):
		return
	var controller_script := load(controller_path) as GDScript
	var controller: Variant = controller_script.new()
	var first := AnchorableObject.new()
	var second := AnchorableObject.new()
	controller.register_anchor(first)
	controller.register_anchor(second)
	_expect(controller.set_active_anchor(first), "Kontroler musi zakotwiczyć pierwszy obiekt")
	_expect(first.is_anchored and controller.get_active_anchor() == first, "Pierwsza kotwica musi zostać aktywna")
	_expect(controller.set_active_anchor(second), "Kontroler musi pozwolić przełączyć kotwicę")
	_expect(not first.is_anchored and second.is_anchored, "Druga kotwica musi zwolnić pierwszą")
	_expect(controller.get_active_anchor() == second, "Kontroler musi przechowywać tylko aktywną drugą kotwicę")
	second.set_anchored(false)
	_expect(controller.get_active_anchor() == null, "Zewnętrzne zwolnienie musi wyczyścić aktywną kotwicę")
	first.free()
	second.free()
	controller.free()


func _test_mutual_test_save_migration(state: Node) -> void:
	state.reset_campaign(true)
	state.set_reduced_motion(true, false)
	state.record_decision(&"ucp_intervention_reconstructed", true)
	state.record_decision(&"mechanic_cost_observed", true)
	state.record_decision(&"marta_boundary_accepted", true)
	state.set_checkpoint(&"station_24", Vector2(410.0, 240.0))
	_expect(state.save_campaign(), "Legacy checkpoint wewnątrz 22–25 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Legacy checkpoint wewnątrz 22–25 musi dać się odczytać")
	_expect(
		state.last_checkpoint_station == &"station_22" and state.last_checkpoint_position == Vector2(60.0, 296.0),
		"Migracja musi wrócić checkpoint 22–25 do bezpiecznego wejścia Station 22"
	)
	_expect(state.decisions.get(&"ucp_intervention_reconstructed", false) == true, "Migracja musi zachować wcześniejsze fakty spoza migrowanych sekwencji")
	_expect(not state.decisions.has(&"world_recognized"), "PKG-0147: legacy world_recognized nie może przetrwać migracji S07")
	_expect(state.is_reduced_motion(), "Migracja kampanii nie może zmieniać ustawień użytkownika")
	_expect(
		int(state.decisions.get(&"p7.mutual_test.migration_revision", 0)) == 1,
		"Migracja musi zapisać rewizję mutual_test"
	)
	_expect(not state.decisions.has(&"mechanic_cost_observed"), "Legacy koszt nie może nadać stanu wycinka P7")
	# PKG-0191: `marta_boundary_accepted` graduated from P7-only mutual_test
	# contamination to a permanent CAMPAIGN_MAP canonical fact with a single
	# audited writer (`station_10.gd`'s `accept_marta_boundary()`). It no
	# longer appears in `P7_MUTUAL_TEST_LEGACY_DECISION_KEYS`, so it must
	# survive this migration like any other current-state decision.
	_expect(state.decisions.get(&"marta_boundary_accepted", false) == true, "PKG-0191: marta_boundary_accepted is canonical and must survive migration, not be erased as P7 mutual_test state")
	_expect(
		not state.decisions.has(&"p7.mutual_test.dead_circuit_outcome") and not state.decisions.has(&"p7.mutual_test.marta_boundary"),
		"Migracja nie może fabrykować wyniku próby ani zgody Marty"
	)
	state.set_reduced_motion(false, false)


func _test_p7_decision_versioning(state: Node) -> void:
	state.reset_campaign(true)
	_expect(
		state.record_decision(&"p7.mutual_test.signal_echo_observed", true),
		"Nowy fakt P7 musi zostać zapisany"
	)
	_expect(
		int(state.decisions.get(&"p7.mutual_test.migration_revision", 0)) == 1,
		"Nowy fakt P7 musi natychmiast oznaczyć rewizję migracji"
	)
	_expect(state.save_campaign(), "Stan P7 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Stan P7 musi dać się odczytać")
	_expect(
		state.decisions.get(&"p7.mutual_test.signal_echo_observed", false) == true,
		"Nowy fakt P7 nie może zostać skasowany jako legacy podczas odczytu"
	)


func _call_bool(node: Node, method_name: StringName, message: String) -> bool:
	if node == null or not node.has_method(method_name):
		_expect(false, message)
		return false
	return bool(node.call(method_name))


func _call_void(node: Node, method_name: StringName, message: String) -> void:
	if node == null or not node.has_method(method_name):
		_expect(false, message)
		return
	node.call(method_name)


func _open_station(station_id: StringName) -> Node2D:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	_expect(packed != null, "%s musi się ładować" % station_id)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	_expect(station != null, "%s musi mieć korzeń Node2D" % station_id)
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


func _test_station_22_gate(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open_station(&"station_22")
	if station == null:
		return
	_expect(
		not _call_bool(station, &"observe_signal_echo", "Station 22 musi wystawiać obserwację sygnału echo"),
		"Station 22 nie może uruchomić metody bez world_recognized"
	)
	_expect(
		not state.decisions.has(&"p7.mutual_test.signal_echo_observed") and not state.decisions.has(&"mechanic_cost_observed"),
		"Zablokowana Station 22 nie może nadawać hipotezy ani kosztu"
	)
	state.record_decision(&"world_recognized", true)
	_expect(_call_bool(station, &"observe_signal_echo", "Station 22 musi wystawiać obserwację sygnału echo"), "Pierwszy sygnał musi otworzyć hipotezę echo")
	_expect(_call_bool(station, &"observe_adjacent_state", "Station 22 musi wystawiać obserwację sąsiedniego stanu"), "Drugi sygnał musi otworzyć hipotezę sąsiedniego stanu")
	_expect(
		station.get("is_hypotheses_opened") == true,
		"Dwa niezależne zachowania Station 22 muszą otworzyć hipotezy"
	)
	_expect(
		not state.decisions.has(&"mechanic_cost_observed"),
		"Station 22 nie może ustawić kosztu przed próbą martwego obwodu"
	)
	_close_station(station)


func _test_station_23_trial(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open_station(&"station_23")
	if station == null:
		return
	_expect(
		not _call_bool(station, &"perform_anchor_trial", "Station 23 musi wystawiać próbę Anchor"),
		"Błędna bezpieczna próba bez porównania nie może wyprodukować wyniku"
	)
	_expect(
		state.decisions.get(&"p7.mutual_test.safe_trial_feedback", "") == "comparison_incomplete",
		"Błędna bezpieczna próba musi dać nowy fakt"
	)
	state.record_decision(&"world_recognized", true)
	state.record_decision(&"p7.mutual_test.signal_echo_observed", true)
	state.record_decision(&"p7.mutual_test.adjacent_state_observed", true)
	_expect(_call_bool(station, &"perform_anchor_trial", "Station 23 musi wystawiać próbę Anchor"), "Anchor musi wykonać próbę przez API obiektu")
	_expect(
		state.decisions.get(&"p7.mutual_test.dead_circuit_outcome", "") == "anchor",
		"Próba Anchor musi zapisać własny wynik"
	)
	_expect(
		state.decisions.get(&"p7.mutual_test.dead_circuit_cost", "") == "adjacent_relay_heat" and state.decisions.get(&"mechanic_cost_observed", false),
		"Próba Anchor musi ujawnić koszt dopiero po realnym działaniu"
	)
	_expect(_call_bool(station, &"perform_yield_trial", "Station 23 musi wystawiać próbę Yield"), "Yield musi wykonać alternatywną próbę przez API obiektu")
	_expect(
		state.decisions.get(&"p7.mutual_test.dead_circuit_outcome", "") == "yield" and state.decisions.get(&"p7.mutual_test.dead_circuit_cost", "") == "address_marker_blurred",
		"Próba Yield musi dać rozróżnialny wynik i koszt"
	)
	_close_station(station)


func _test_station_24_boundary(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"mechanic_cost_observed", true)
	var station := await _open_station(&"station_24")
	if station == null:
		return
	_expect(
		not _call_bool(station, &"choose_limited_access", "Station 24 musi wystawiać ograniczony dostęp Marty"),
		"Marta nie może udzielić ograniczonego dostępu przed ujawnieniem zakresu i kosztu"
	)
	_call_void(station, &"disclose_marta_scope", "Station 24 musi wystawiać ujawnienie zakresu Marty")
	_call_void(station, &"disclose_marta_risk", "Station 24 musi wystawiać ujawnienie ryzyka Marty")
	_call_void(station, &"disclose_marta_cost", "Station 24 musi wystawiać ujawnienie kosztu Marty")
	_expect(_call_bool(station, &"choose_limited_access", "Station 24 musi wystawiać ograniczony dostęp Marty"), "Ograniczony dostęp Marty musi być jawnym wyborem po ujawnieniu")
	_expect(
		state.decisions.get(&"p7.mutual_test.marta_boundary", "") == "limited_access" and state.decisions.get(&"marta_boundary_accepted", false),
		"Ograniczony dostęp musi zachować stan dostępu i kanoniczny szacunek granicy"
	)
	_close_station(station)
	state.reset_campaign(true)
	state.record_decision(&"mechanic_cost_observed", true)
	station = await _open_station(&"station_24")
	if station == null:
		return
	_call_void(station, &"disclose_marta_scope", "Station 24 musi wystawiać ujawnienie zakresu Marty")
	_call_void(station, &"disclose_marta_risk", "Station 24 musi wystawiać ujawnienie ryzyka Marty")
	_call_void(station, &"disclose_marta_cost", "Station 24 musi wystawiać ujawnienie kosztu Marty")
	_expect(_call_bool(station, &"open_boundary_choice", "Station 24 musi otwierać jawną decyzję Marty"), "Po ujawnieniu musi otworzyć się wybór granicy")
	var select_declined := InputEventAction.new()
	select_declined.action = &"move_right"
	select_declined.pressed = true
	station._unhandled_input(select_declined)
	var confirm_boundary := InputEventAction.new()
	confirm_boundary.action = &"interact"
	confirm_boundary.pressed = true
	station._unhandled_input(confirm_boundary)
	_expect(station.get("committed_boundary") == &"declined", "Sterowanie semantyczne musi zatwierdzać jawną odmowę Marty")
	_expect(
		state.decisions.get(&"p7.mutual_test.marta_boundary", "") == "declined" and state.decisions.get(&"marta_boundary_accepted", false),
		"Odmowa musi zachować własny stan i kanoniczny szacunek granicy"
	)
	_close_station(station)


func _test_station_25_trace(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p7.mutual_test.marta_boundary", "limited_access")
	var station := await _open_station(&"station_25")
	if station == null:
		return
	_call_void(station, &"observe_ventilation_cycle", "Station 25 musi wystawiać odczyt wentylacji")
	_call_void(station, &"release_interlock", "Station 25 musi wystawiać obsługę rygla")
	_call_void(station, &"route_power", "Station 25 musi wystawiać drogę zasilania")
	_expect(_call_bool(station, &"retrieve_ucp_buffer", "Station 25 musi wystawiać pobranie bufora UCP"), "Droga z ograniczonym dostępem musi dać się technicznie wykonać")
	_expect(
		state.decisions.get(&"p7.mutual_test.ucp_buffer_trace", "") == "paired_with_notes",
		"Ograniczony dostęp musi zostawić ślad paired_with_notes"
	)
	_expect(not state.decisions.has(&"jakub_consent_state"), "Station 25 nie może wyprzedzać późniejszej zgody Jakuba")
	_close_station(station)
	state.reset_campaign(true)
	state.record_decision(&"p7.mutual_test.marta_boundary", "declined")
	station = await _open_station(&"station_25")
	if station == null:
		return
	_call_void(station, &"observe_ventilation_cycle", "Station 25 musi wystawiać odczyt wentylacji")
	_call_void(station, &"release_interlock", "Station 25 musi wystawiać obsługę rygla")
	_call_void(station, &"route_power", "Station 25 musi wystawiać drogę zasilania")
	_expect(_call_bool(station, &"retrieve_ucp_buffer", "Station 25 musi wystawiać pobranie bufora UCP"), "Droga techniczna po odmowie musi dać się wykonać")
	_expect(
		state.decisions.get(&"p7.mutual_test.ucp_buffer_trace", "") == "technical_route",
		"Odmowa musi zostawić ślad technical_route"
	)
	_close_station(station)

func _test_guidance_bounds(state: Node) -> void:
	state.reset_campaign(true)
	var station22 := await _open_station(&"station_22")
	if station22 != null:
		_expect_guidance_tiers(station22, &"station_22")
		var guidance22 := station22.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
		var before22: Dictionary = state.decisions.duplicate(true)
		if guidance22 != null:
			guidance22.trigger_beat(&"s22_system_hint", true)
		_expect(state.decisions == before22, "L4 Station 22 nie może wybrać metody ani ustawić kosztu")
		_close_station(station22)
	state.reset_campaign(true)
	state.record_decision(&"mechanic_cost_observed", true)
	var station24 := await _open_station(&"station_24")
	if station24 != null:
		_expect_guidance_tiers(station24, &"station_24")
		var guidance24 := station24.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
		var before24: Dictionary = state.decisions.duplicate(true)
		if guidance24 != null:
			guidance24.trigger_beat(&"s24_system_hint", true)
		_expect(
			state.decisions == before24 and station24.get("is_boundary_committed") != true,
			"L4 Station 24 nie może wybrać zgody Marty"
		)
		_close_station(station24)


func _expect_guidance_tiers(station: Node2D, station_id: StringName) -> void:
	var guidance := station.get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	_expect(guidance != null, "%s musi mieć NarrativeGuidanceService" % station_id)
	if guidance == null:
		return
	var tiers: Dictionary = {}
	for beat_id in guidance.active_beats:
		var beat := guidance.active_beats[beat_id] as GuidanceBeat
		if beat != null:
			tiers[beat.tier] = true
	_expect(
		tiers.has(GuidanceBeat.Tier.L0_COMPOSITION)
		and tiers.has(GuidanceBeat.Tier.L1_REACTION)
		and tiers.has(GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT)
		and tiers.has(GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT)
		and tiers.has(GuidanceBeat.Tier.L4_RESCUE_HINT),
		"%s musi rejestrować pełną drabinę guidance L0–L4" % station_id
	)


func _test_end_to_end_persistence(state: Node) -> void:
	state.reset_campaign(true)
	state.record_decision(&"world_recognized", true)
	var station22 := await _open_station(&"station_22")
	if station22 == null:
		return
	station22.observe_signal_echo()
	station22.observe_adjacent_state()
	_close_station(station22)
	var station23 := await _open_station(&"station_23")
	if station23 == null:
		return
	station23.perform_anchor_trial()
	_close_station(station23)
	var station24 := await _open_station(&"station_24")
	if station24 == null:
		return
	station24.disclose_marta_scope()
	station24.disclose_marta_risk()
	station24.disclose_marta_cost()
	station24.choose_declined()
	_close_station(station24)
	var station25 := await _open_station(&"station_25")
	if station25 == null:
		return
	station25.observe_ventilation_cycle()
	station25.release_interlock()
	station25.route_power()
	station25.retrieve_ucp_buffer()
	_close_station(station25)
	_expect(state.save_campaign(), "Kompletny wycinek P7 musi dać się zapisać")
	state.reset_campaign(false)
	_expect(state.reload_campaign_from_disk(), "Kompletny wycinek P7 musi dać się odczytać")
	_expect(
		state.decisions.get(&"p7.mutual_test.dead_circuit_outcome", "") == "anchor"
		and state.decisions.get(&"p7.mutual_test.marta_boundary", "") == "declined"
		and state.decisions.get(&"p7.mutual_test.ucp_buffer_trace", "") == "technical_route",
		"Wynik próby, granica Marty i ślad UCP muszą przetrwać zapis/odczyt"
	)
	_expect(
		state.decisions.get(&"marta_boundary_accepted", false) == true
		and state.decisions.get(&"mechanic_cost_observed", false) == true,
		"Fakty kanoniczne wycinka muszą przetrwać zapis/odczyt"
	)


func _test_migrated_source_cutover() -> void:
	for station_number in [22, 23, 24, 25]:
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Skrypt migrowanej stacji musi być czytelny: %s" % path)
		if file == null:
			continue
		var source := file.get_as_text()
		file.close()
		_expect(not source.contains("_check_unlock("), "%s nie może zachować checklist unlocku" % path)
		_expect(not source.contains("APPARENT_COOPERATION"), "%s nie może zachować pozornej współpracy" % path)
		_expect(not source.contains("set_campaign_flag"), "%s nie może używać legacy flag API" % path)
		_expect(not source.contains("current_reality ="), "%s nie może bezpośrednio mutować rzeczywistości kotwicy" % path)



func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0145 PASS: P7 vertical-slice contracts")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0145 FAILURE: " + failure)
	quit(1)
