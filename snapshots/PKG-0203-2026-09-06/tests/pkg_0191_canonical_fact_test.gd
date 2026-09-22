extends SceneTree

## PKG-0191 — canonical CAMPAIGN_MAP fact alignment for Station 10-13.
##
## Dedicated player-verb + persistence gate for F-0184-012
## (`docs/rebuild/PKG_0189_RESIDUAL_BOUNDARY_SPEC.md` §3-4). This test never
## calls a station helper method to establish a canonical fact directly: every
## positive write is produced by calling the real `MemoryResonancePoint`
## node's `trigger_interaction()`, exactly as `_unhandled_input` would on a
## genuine `interact` press, so the assertion exercises the actual signal
## bridge (`resonance_triggered` -> `_on_prop_resonance_triggered`) rather
## than bypassing it. It proves structure and persistence only, not fun,
## emotion or player comprehension (D-012, ADR-003).

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0191 FAILURE: %s" % message)


func _run() -> void:
	print("=== PKG-0191 Smoke Test: Station 10-13 canonical-fact alignment ===")
	await _test_station_10_boundary_family()
	await _test_station_11_public_family()
	await _test_station_12_relational_family()
	await _test_station_13_gated_synthesis()
	await _test_save_reload_persistence()
	if _failures.is_empty():
		print("PKG-0191 PASS: Station 10-13 write all 12 canonical facts through the real MRP bridge, Station 13 synthesis is fully gated, and save/reload persists them.")
		quit(0)
	else:
		printerr("PKG-0191 FAIL: %d failure(s)." % _failures.size())
		quit(1)


func _state() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
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


func _prop(station: Node, resonance_id: String) -> MemoryResonancePoint:
	var props := station.get_node_or_null("Props")
	_expect(props != null, "%s must expose a Props container" % station)
	if props == null:
		return null
	for child in props.get_children():
		if child is MemoryResonancePoint and (child as MemoryResonancePoint).resonance_id == resonance_id:
			return child as MemoryResonancePoint
	_expect(false, "%s must expose a MemoryResonancePoint with resonance_id '%s'" % [station, resonance_id])
	return null


## The real player verb: trigger the actual MRP node, exactly as
## `_unhandled_input`'s `interact` press would, instead of calling the
## station's helper method directly.
func _press(station: Node, resonance_id: String) -> void:
	var prop := _prop(station, resonance_id)
	if prop != null:
		prop.trigger_interaction()
	await process_frame


func _decision(state: Node, key: StringName) -> Variant:
	return state.decisions.get(key, false)


## ---------------------------------------------------------------------
## Station 10 - marta_memories_conflict, marta_boundary_accepted.
## marta_relationship_disclosed is audited as station_08.gd's fact and is
## intentionally not exercised here; see pkg_0189_boundary_inventory_test.gd.
## ---------------------------------------------------------------------
func _test_station_10_boundary_family() -> void:
	var state := _state()
	if state == null:
		return
	state.reset_campaign(true)
	state.record_decision(&"p9.mystery.home.trace", "two_lives_without_claim")

	var station := await _open("res://scenes/levels/station_10.tscn") as Station10
	if station == null:
		return

	# Negative: pressing the boundary point before the home task and the day
	# account must write neither the P9 detail key nor the canonical fact.
	await _press(station, "marta_boundary")
	_expect(_decision(state, &"marta_boundary_accepted") != true, "PKG-0191: marta_boundary_accepted must not appear before the day account is heard")

	await _press(station, "home_task")
	_expect(_decision(state, &"marta_memories_conflict") != true, "PKG-0191: marta_memories_conflict must not appear from the home task alone")

	await _press(station, "marta_day")
	_expect(_decision(state, &"marta_memories_conflict") == true, "PKG-0191: hearing Marta's independent day must write marta_memories_conflict")

	await _press(station, "marta_boundary")
	_expect(_decision(state, &"marta_boundary_accepted") == true, "PKG-0191: accepting Marta's boundary must write marta_boundary_accepted")

	await _close(station)


## ---------------------------------------------------------------------
## Station 11 - local_lena_ucp_profile_found, jakub_public_history_verified,
## parallel_test_trace_found, recognition_evidence_public.
## ---------------------------------------------------------------------
func _test_station_11_public_family() -> void:
	var state := _state()
	if state == null:
		return

	var station := await _open("res://scenes/levels/station_11.tscn") as Station11
	if station == null:
		return

	# Negative: the terminal action attempted first must write nothing.
	await _press(station, "minimal_report")
	_expect(_decision(state, &"parallel_test_trace_found") != true, "PKG-0191: parallel_test_trace_found must not appear before the record is read")
	_expect(_decision(state, &"recognition_evidence_public") != true, "PKG-0191: recognition_evidence_public must not appear before the record is read")

	await _press(station, "identity_card")
	_expect(_decision(state, &"local_lena_ucp_profile_found") == true, "PKG-0191: biometric admission must write local_lena_ucp_profile_found")

	await _press(station, "record_186_days")
	_expect(_decision(state, &"jakub_public_history_verified") == true, "PKG-0191: reading the 186-day record must write jakub_public_history_verified")

	await _press(station, "minimal_report")
	_expect(_decision(state, &"parallel_test_trace_found") == true, "PKG-0191: requesting the minimal report must write parallel_test_trace_found")
	_expect(_decision(state, &"recognition_evidence_public") == true, "PKG-0191: requesting the minimal report must complete recognition_evidence_public")

	await _close(station)


## ---------------------------------------------------------------------
## Station 12 - jakub_voice_heard, jakub_met_as_person, recognition_evidence_relational.
## ---------------------------------------------------------------------
func _test_station_12_relational_family() -> void:
	var state := _state()
	if state == null:
		return

	var station := await _open("res://scenes/levels/station_12.tscn") as Station12
	if station == null:
		return

	await _press(station, "jakub_refusal")
	_expect(_decision(state, &"recognition_evidence_relational") != true, "PKG-0191: recognition_evidence_relational must not appear before the meeting happens")

	await _press(station, "jakub_questions")
	_expect(_decision(state, &"jakub_voice_heard") == true, "PKG-0191: the control questions through the link must write jakub_voice_heard")

	await _press(station, "jakub_meeting")
	_expect(_decision(state, &"jakub_met_as_person") == true, "PKG-0191: the bodily meeting must write jakub_met_as_person")

	await _press(station, "jakub_refusal")
	_expect(_decision(state, &"recognition_evidence_relational") == true, "PKG-0191: accepting the refusal must complete recognition_evidence_relational")

	await _close(station)


## ---------------------------------------------------------------------
## Station 13 - recognition_evidence_carried, world_recognized,
## local_lena_search_committed. Synthesis must reject until all three
## canonical evidence families and both local source markers exist, and a
## rejection must write neither terminal fact.
## ---------------------------------------------------------------------
func _test_station_13_gated_synthesis() -> void:
	var state := _state()
	if state == null:
		return

	var station := await _open("res://scenes/levels/station_13.tscn") as Station13
	if station == null:
		return

	# GDScript lambdas capture locals by value, not by reference, so a plain
	# int would not observe increments from inside the callable. An Array is
	# a reference type and stays shared between the outer scope and the
	# connected lambda.
	var synthesized_signal_count := [0]
	station.world_difference_synthesized.connect(func() -> void: synthesized_signal_count[0] += 1)

	# Preconditions from Stations 10-12 above: p9.mystery.marta.trace,
	# p9.mystery.institution.trace and p9.mystery.jakub.trace are already set,
	# and so are recognition_evidence_public and recognition_evidence_relational.
	# recognition_evidence_carried and both local markers are still missing.
	_expect(_decision(state, &"recognition_evidence_public") == true, "test setup: recognition_evidence_public must already hold from Station 11")
	_expect(_decision(state, &"recognition_evidence_relational") == true, "test setup: recognition_evidence_relational must already hold from Station 12")
	_expect(_decision(state, &"recognition_evidence_carried") != true, "test setup: recognition_evidence_carried must not yet hold")

	await _press(station, "synthesize")
	_expect(_decision(state, &"world_recognized") != true, "PKG-0191: synthesis must reject before recognition_evidence_carried and the local markers exist")
	_expect(_decision(state, &"local_lena_search_committed") != true, "PKG-0191: a rejected synthesis must write neither terminal fact")
	_expect(synthesized_signal_count[0] == 0, "PKG-0191: a rejected synthesis must not emit world_difference_synthesized")

	await _press(station, "marta_source")
	_expect(_decision(state, &"recognition_evidence_carried") == true, "PKG-0191: laying out the home-carried source must write recognition_evidence_carried")

	await _press(station, "synthesize")
	_expect(_decision(state, &"world_recognized") != true, "PKG-0191: synthesis must still reject with only one of the two local markers present")

	await _press(station, "institution_source")
	await _press(station, "synthesize")
	_expect(_decision(state, &"world_recognized") == true, "PKG-0191: a fully-gated synthesis must write world_recognized")
	_expect(_decision(state, &"local_lena_search_committed") == true, "PKG-0191: a fully-gated synthesis must write local_lena_search_committed")
	_expect(state.decisions.get(&"p9.mystery.synthesis.trace", "") == "this_is_not_my_world", "Station 13 must still persist the first-mystery trace")
	_expect(synthesized_signal_count[0] == 1, "PKG-0190 contract: world_difference_synthesized must still fire exactly once for CinematicDirector's VIG-02 hook")

	await _close(station)


## ---------------------------------------------------------------------
## Save/reload: the twelve facts established above through real MRP
## interaction must survive a disk roundtrip untouched.
## ---------------------------------------------------------------------
func _test_save_reload_persistence() -> void:
	var state := _state()
	if state == null:
		return
	var facts: Array[StringName] = [
		&"marta_memories_conflict",
		&"marta_boundary_accepted",
		&"local_lena_ucp_profile_found",
		&"parallel_test_trace_found",
		&"jakub_public_history_verified",
		&"recognition_evidence_public",
		&"jakub_voice_heard",
		&"jakub_met_as_person",
		&"recognition_evidence_relational",
		&"recognition_evidence_carried",
		&"world_recognized",
		&"local_lena_search_committed",
	]
	for fact in facts:
		_expect(_decision(state, fact) == true, "test setup: %s must hold before the save/reload roundtrip" % fact)

	_expect(state.save_campaign(), "PKG-0191: canonical-fact campaign state must save")
	state.reset_campaign(false)
	for fact in facts:
		_expect(_decision(state, fact) != true, "test setup: reset_campaign must clear in-memory %s before reload" % fact)
	_expect(state.reload_campaign_from_disk(), "PKG-0191: canonical-fact campaign state must reload")
	for fact in facts:
		_expect(_decision(state, fact) == true, "PKG-0191: %s must survive save/reload" % fact)
