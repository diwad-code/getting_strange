extends SceneTree

# PKG-0160 — Personal Mystery: five addresses, three-source synthesis and family repayment.

var _failures: Array[String] = []

func _initialize() -> void:
	call_deferred(&"_run")

func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0160 FAILURE: %s" % message)

func _run() -> void:
	print("=== PKG-0160 Smoke Test: personal mystery ===")
	await _test_personal_mystery_chain()
	if _failures.is_empty():
		print("PKG-0160 PASS: 09–13 deliver bounded personal evidence and explicit synthesis.")
		quit(0)
	else:
		printerr("PKG-0160 FAIL: %d failure(s)." % _failures.size())
		quit(1)

func _state() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.foreign_daily_life.trace", "threshold_crossed")
	return state

func _open(path: String) -> Node:
	var packed := load(path) as PackedScene
	_expect(packed != null, "%s must load" % path)
	if packed == null:
		return null
	var station := packed.instantiate()
	root.add_child(station)
	for _frame in range(3):
		await process_frame
	return station

func _close(station: Node) -> void:
	if station:
		station.queue_free()
		await process_frame

func _interaction_count(station: Node) -> int:
	var props := station.get_node_or_null("Props")
	if props == null:
		return 0
	var count := 0
	for child in props.get_children():
		if child is MemoryResonancePoint:
			count += 1
	return count

func _call_bool(station: Node, method_name: StringName) -> bool:
	return station != null and station.has_method(method_name) and bool(station.call(method_name))

func _test_personal_mystery_chain() -> void:
	var state := _state()
	if state == null:
		return
	var station_09 := await _open("res://scenes/levels/station_09.tscn") as Station09
	if station_09 == null:
		return
	_expect(_interaction_count(station_09) <= 3, "Station 09 must keep at most three meaningful interactions")
	_expect(station_09.get_node_or_null("DomesticBlockout") != null, "Station 09 must expose a dedicated domestic blockout")
	_expect(_call_bool(station_09, &"observe_two_lives"), "Station 09 must establish two occupied lives")
	_expect(_call_bool(station_09, &"observe_relation_photo"), "Station 09 must establish a relation photograph")
	_expect(_call_bool(station_09, &"respect_private_boundary"), "Station 09 must close on respecting private boundary")
	_expect(state.decisions.get(&"p9.mystery.home.trace", "") == "two_lives_without_claim", "Station 09 must persist the private-home trace")
	await _close(station_09)

	var station_10 := await _open("res://scenes/levels/station_10.tscn") as Station10
	_expect(_interaction_count(station_10) <= 3, "Station 10 must keep at most three meaningful interactions")
	_expect(station_10.get_node_or_null("MartaBlockout") != null, "Station 10 must stage Marta as a person")
	_expect(_call_bool(station_10, &"perform_home_task"), "Station 10 must begin with an ordinary shared task")
	_expect(_call_bool(station_10, &"hear_marta_day"), "Station 10 must receive Marta's independent version of the day")
	_expect(_call_bool(station_10, &"accept_marta_boundary"), "Station 10 must allow Marta's boundary without a softlock")
	_expect(state.decisions.get(&"p9.mystery.marta.trace", "") == "independent_day_with_boundary", "Station 10 must preserve Marta's independent account")
	await _close(station_10)

	var station_11 := await _open("res://scenes/levels/station_11.tscn") as Station11
	_expect(_interaction_count(station_11) <= 3, "Station 11 must keep at most three meaningful interactions")
	_expect(station_11.get_node_or_null("InstitutionalBlockout") != null, "Station 11 must expose a dedicated institutional blockout")
	_expect(_call_bool(station_11, &"present_identity_card"), "Station 11 must contrast the card with biometric admission")
	_expect(_call_bool(station_11, &"read_186_day_record"), "Station 11 must expose the physical 186-day activity record")
	_expect(_call_bool(station_11, &"request_minimal_report"), "Station 11 must request only the minimal report")
	_expect(state.decisions.get(&"p9.mystery.institution.trace", "") == "biometric_history_186_days", "Station 11 must persist the institutional history")
	await _close(station_11)

	var station_12 := await _open("res://scenes/levels/station_12.tscn") as Station12
	_expect(_interaction_count(station_12) <= 3, "Station 12 must keep at most three meaningful interactions")
	_expect(station_12.get_node_or_null("WorkshopBlockout") != null, "Station 12 must expose a dedicated workshop blockout")
	_expect(_call_bool(station_12, &"ask_jakub_control_questions"), "Station 12 must ask Jakub control questions before proof")
	_expect(_call_bool(station_12, &"meet_jakub"), "Station 12 must stage a bodily meeting with Jakub")
	_expect(_call_bool(station_12, &"accept_jakub_refusal"), "Station 12 must make Jakub's refusal continuable")
	_expect(state.decisions.get(&"p9.mystery.jakub.trace", "") == "voluntary_proof_after_refusal", "Station 12 must preserve voluntary technical proof")
	await _close(station_12)

	var station_13 := await _open("res://scenes/levels/station_13.tscn") as Station13
	_expect(_interaction_count(station_13) <= 3, "Station 13 must keep at most three meaningful interactions")
	_expect(not state.decisions.get(&"world_recognized", false), "Collecting sources must not automatically recognize the world")
	_expect(station_13.get_node_or_null("SynthesisTable") != null, "Station 13 must stage a shared synthesis table")
	_expect(_call_bool(station_13, &"synthesize_world_difference"), "Station 13 must require an explicit synthesis action")
	_expect(state.decisions.get(&"world_recognized", false) == true, "Explicit synthesis alone must persist world_recognized")
	_expect(state.decisions.get(&"p9.mystery.synthesis.trace", "") == "this_is_not_my_world", "Station 13 must persist the first-mystery trace")
	await _close(station_13)
