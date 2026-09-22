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
	_test_marta_visual_identity()
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

func _test_marta_visual_identity() -> void:
	var resonance_source := FileAccess.get_file_as_string("res://scripts/interactables/memory_resonance_point.gd")
	_expect(resonance_source.contains("Long pink hair"), "Marta's shared encounter silhouettes must declare long pink hair")
	_expect(resonance_source.contains("steel septum"), "Marta's shared encounter silhouettes must declare a steel septum")
	for renderer in ["_draw_marta_interaction", "_draw_marta_observation_dialogue", "_draw_marta_witness_station"]:
		var start := resonance_source.find("func %s" % renderer)
		var end := resonance_source.find("\nfunc ", start + 1)
		if end < 0:
			end = resonance_source.length()
		_expect(start >= 0 and resonance_source.substr(start, end - start).contains("d45b9a"), "%s must render Marta's pink hair" % renderer)
	_expect(resonance_source.count("draw_arc(") >= 2, "Marta's legacy close silhouettes must retain a septum arc")
	_expect(ResourceLoader.exists("res://scripts/characters/character_visual_rig.gd"), "Campaign Marta must be a CharacterVisualRig, not an MRP primitive")
	_expect(ResourceLoader.exists("res://assets/characters/marta/idle.png"), "Campaign Marta must have a 64x104 idle sprite")
	var station_20_source := FileAccess.get_file_as_string("res://scripts/levels/station_20.gd")
	_expect(station_20_source.contains("Wide-shot Marta") and station_20_source.contains("d45b9a"), "Station 20 wide shot must retain Marta's pink hair")
	var station_40_source := FileAccess.get_file_as_string("res://scripts/levels/station_40.gd")
	_expect(station_40_source.contains("Marta's pink hair and steel septum"), "Station 40 witness shot must retain Marta's distinct identity")
	var marta_tex := load("res://assets/characters/portraits/marta.png") as Texture2D
	_expect(marta_tex != null, "Marta portrait texture must load")
	var portrait := marta_tex.get_image() if marta_tex != null else null
	_expect(portrait != null, "Marta portrait image must be available")
	var pink_pixels := 0
	if portrait != null:
		for y in range(0, portrait.get_height(), 4):
			for x in range(0, portrait.get_width(), 4):
				var pixel := portrait.get_pixel(x, y)
				if pixel.r > 0.65 and pixel.b > 0.40 and pixel.g < 0.52:
					pink_pixels += 1
	_expect(pink_pixels >= 20, "Marta's CRT portrait must retain a substantial pink-hair accent")

func _test_personal_mystery_chain() -> void:
	var state := _state()
	if state == null:
		return
	var station_09 := await _open("res://scenes/levels/station_09.tscn") as Station09
	if station_09 == null:
		return
	_expect(_interaction_count(station_09) <= 3, "Station 09 must keep at most three meaningful interactions")
	_expect(station_09.get_node_or_null("DomesticBlockout") != null, "Station 09 must expose a dedicated domestic blockout")
	_expect(not (station_09.get_node_or_null("AtmosphereRig") as CanvasItem).visible, "Station 09 must suppress generic overhead lighting in favour of local domestic practicals")
	_expect((station_09.get_node_or_null("Props/ExtinguisherBracket") as MemoryResonancePoint).prop_type == MemoryResonancePoint.PropType.TWIN_CUPS, "Station 09 two-lives clue must remain visibly domestic")
	_expect((station_09.get_node_or_null("Props/FloorPlate") as MemoryResonancePoint).prop_type == MemoryResonancePoint.PropType.PHOTOGRAPH, "Station 09 relation clue must remain a domestic photograph")
	_expect((station_09.get_node_or_null("Props/NeighbourDialogue") as MemoryResonancePoint).prop_type == MemoryResonancePoint.PropType.HALLWAY_COAT_RACK, "Station 09 boundary clue must remain a domestic threshold")
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
	# PKG-0191: synthesis now also gates on the three canonical evidence
	# families (already true after 09-12 above) plus both local source
	# markers, laid out here through the station's own real actions.
	_expect(not _call_bool(station_13, &"synthesize_world_difference"), "PKG-0191: synthesis must reject before both local source markers are laid out")
	_expect(not state.decisions.get(&"world_recognized", false), "PKG-0191: a rejected synthesis must not write world_recognized")
	_expect(not state.decisions.get(&"local_lena_search_committed", false), "PKG-0191: a rejected synthesis must not write local_lena_search_committed")
	_expect(_call_bool(station_13, &"mark_marta_source_seen"), "Station 13 must mark the home-carried source before synthesis")
	_expect(state.decisions.get(&"recognition_evidence_carried", false) == true, "PKG-0191: marking the home source must write recognition_evidence_carried")
	_expect(_call_bool(station_13, &"mark_institution_source_seen"), "Station 13 must mark the institutional source before synthesis")
	_expect(_call_bool(station_13, &"synthesize_world_difference"), "Station 13 must require an explicit synthesis action")
	_expect(state.decisions.get(&"world_recognized", false) == true, "Explicit synthesis alone must persist world_recognized")
	_expect(state.decisions.get(&"local_lena_search_committed", false) == true, "PKG-0191: an accepted synthesis must persist local_lena_search_committed")
	_expect(state.decisions.get(&"p9.mystery.synthesis.trace", "") == "this_is_not_my_world", "Station 13 must persist the first-mystery trace")
	await _close(station_13)
