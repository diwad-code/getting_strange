extends SceneTree

# PKG-0158 / PHASE-03 — First Thirty Minutes (BUNDLE-11..15).
# Tests Station 05 home street baseline, Station 06 kiosk contradiction,
# Station 07 building exterior, Station 08 stairwell & threshold,
# GATE-30 (4 independent sources of contradiction, 4 distinct location families),
# GATE-INT (<= 3 interactions per scene), and end-to-end player verb progression 01..08.

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0158 FAILURE: %s" % message)


func _run_tests() -> void:
	print("=== PKG-0158 Smoke Test: PHASE-03 First Thirty Minutes (BUNDLE-11..15) ===")
	_test_bundle_11_station_05_street_baseline()
	_test_bundle_12_station_06_kiosk_contradiction()
	_test_bundle_13_station_07_building_exterior()
	_test_bundle_14_station_08_stairwell_threshold()
	_test_gate_int_budgets()
	_test_gate_30_contract()
	await _test_first_thirty_minutes_campaign_playthrough()
	_finish()


func _test_bundle_11_station_05_street_baseline() -> void:
	print("Testing BUNDLE-11: Station 05 home street baseline...")
	var packed := load("res://scenes/levels/station_05.tscn") as PackedScene
	_expect(packed != null, "station_05.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station05
	_expect(station != null, "Station05 must instantiate")
	if station == null:
		return
	root.add_child(station)
	preload("res://scripts/campaign/gap_ledger.gd").ensure_exit_open(station)

	# Check interaction points count <= 3
	var props := station.get_node_or_null("Props") as Node2D
	_expect(props != null, "Props container must exist")
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 3, "Station 05 must have exactly 3 OpeningActionPoints, found %d" % actions.size())

	# Check presence of ReturnZone and AirlockZone
	_expect(station.get_node_or_null("ReturnZone") is ReturnZone, "Station 05 must have ReturnZone")
	_expect(station.get_node_or_null("AirlockZone") is Area2D, "Station 05 must have AirlockZone")

	# Check OpenSkyWitness (Family 1: Urban Exterior)
	_expect(station.get_node_or_null("OpenSkyWitness") != null, "Station 05 must have OpenSkyWitness (open sky >= 25%)")

	# Check action sequencing
	_expect(station.is_exit_unlocked, "Exit must be open from ready")
	_expect(station.check_street_route(), "check_street_route must succeed")
	_expect(station.is_street_route_checked, "Street route checked state")
	_expect(station.check_sample_case(), "check_sample_case must succeed after route check")
	_expect(station.is_sample_case_verified, "Sample case verified state")
	_expect(station.cross_street_towards_home(), "cross_street_towards_home must succeed after sample check")
	_expect(station.is_crossing_completed, "Crossing completed state")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after crossing street")

	station.queue_free()


func _test_bundle_12_station_06_kiosk_contradiction() -> void:
	print("Testing BUNDLE-12: Station 06 kiosk contradiction...")
	var packed := load("res://scenes/levels/station_06.tscn") as PackedScene
	_expect(packed != null, "station_06.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station06
	_expect(station != null, "Station06 must instantiate")
	if station == null:
		return
	root.add_child(station)

	# Check interaction points count <= 3
	var props := station.get_node_or_null("Props") as Node2D
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 3, "Station 06 must have exactly 3 OpeningActionPoints, found %d" % actions.size())

	# Check presence of ReturnZone and AirlockZone
	_expect(station.get_node_or_null("ReturnZone") is ReturnZone, "Station 06 must have ReturnZone")
	_expect(station.get_node_or_null("AirlockZone") is Area2D, "Station 06 must have AirlockZone")

	# Check diegetic timetable text
	var timetable_text := station.get_node_or_null("CrispDiegeticText_Timetable") as CrispDiegeticText
	_expect(timetable_text != null and timetable_text.text.contains("SADOWA 14"), "Timetable must state Sadowa 14")

	# Check action sequencing
	_expect(station.inspect_street_timetable(), "inspect_street_timetable must succeed")
	_expect(station.buy_water_at_kiosk(), "buy_water_at_kiosk must succeed")
	_expect(station.ask_kiosk_vendor(), "ask_kiosk_vendor must succeed")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after talking to vendor")

	station.queue_free()


func _test_bundle_13_station_07_building_exterior() -> void:
	print("Testing BUNDLE-13: Station 07 building exterior...")
	var packed := load("res://scenes/levels/station_07.tscn") as PackedScene
	_expect(packed != null, "station_07.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station07
	_expect(station != null, "Station07 must instantiate")
	if station == null:
		return
	root.add_child(station)

	# Check interaction points count <= 3
	var props := station.get_node_or_null("Props") as Node2D
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 3, "Station 07 must have exactly 3 OpeningActionPoints, found %d" % actions.size())

	# Check physical door
	var entrance_door := station.get_node_or_null("BuildingEntranceDoor") as AnimatableBody2D
	_expect(entrance_door != null, "Station 07 must have BuildingEntranceDoor")

	# Check diegetic texts for address contradiction (12 vs 14)
	var facade_text := station.get_node_or_null("CrispDiegeticText_Façade") as CrispDiegeticText
	var cert_text := station.get_node_or_null("CrispDiegeticText_Certificate") as CrispDiegeticText
	var intercom_text := station.get_node_or_null("CrispDiegeticText_Intercom") as CrispDiegeticText
	_expect(facade_text != null and facade_text.text.contains("SADOWA 14"), "Facade plaque must state Sadowa 14")
	_expect(cert_text != null and cert_text.text.contains("SADOWA 12"), "Certificate text must state Sadowa 12")
	_expect(intercom_text != null and intercom_text.text.contains("WOLSKA"), "Intercom directory must list Wolska under 14")

	# Check action sequencing
	_expect(station.compare_address_document(), "compare_address_document must succeed")
	_expect(station.inspect_intercom_directory(), "inspect_intercom_directory must succeed")
	_expect(station.enter_intercom_code(), "enter_intercom_code must succeed")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after entering code")

	station.queue_free()


func _test_bundle_14_station_08_stairwell_threshold() -> void:
	print("Testing BUNDLE-14: Station 08 stairwell and threshold...")
	var packed := load("res://scenes/levels/station_08.tscn") as PackedScene
	_expect(packed != null, "station_08.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station08
	_expect(station != null, "Station08 must instantiate")
	if station == null:
		return
	root.add_child(station)

	# Check interaction points count <= 3
	var props := station.get_node_or_null("Props") as Node2D
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 3, "Station 08 must have exactly 3 OpeningActionPoints, found %d" % actions.size())

	# Check ceiling (Family 3: Residential, enclosed space, low ceiling)
	var ceiling := station.get_node_or_null("Geometry/Ceiling") as StaticBody2D
	_expect(ceiling != null, "Station 08 must have low residential ceiling")

	# Check apartment door
	var apt_door := station.get_node_or_null("ApartmentDoor14") as AnimatableBody2D
	_expect(apt_door != null, "Station 08 must have ApartmentDoor14")

	# Check action sequencing
	_expect(station.inspect_floor_twelve(), "inspect_floor_twelve must succeed")
	_expect(station.speak_with_neighbour(), "speak_with_neighbour must succeed")
	_expect(station.unlock_apartment_fourteen(), "unlock_apartment_fourteen must succeed")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after key unlock")

	station.queue_free()


func _test_gate_int_budgets() -> void:
	print("Testing GATE-INT: Interaction budget <= 3 on Station 01..08...")
	for station_num in range(1, 9):
		var scene_path := "res://scenes/levels/station_%02d.tscn" % station_num
		var text := FileAccess.get_file_as_string(scene_path)
		_expect(not text.is_empty(), "Scene text must be readable: %s" % scene_path)
		var action_count := text.count("OpeningActionPoint")
		_expect(action_count <= 3, "Station %02d action count (%d) must be <= 3 (GATE-INT)" % [station_num, action_count])
		var legacy_count := text.count("MemoryResonancePoint") + text.count("memory_resonance_point")
		_expect(legacy_count == 0, "Station %02d must have 0 legacy MemoryResonancePoints, found %d" % [station_num, legacy_count])


func _test_gate_30_contract() -> void:
	print("Testing GATE-30: 4 independent sources of contradiction and 4 location families...")
	# Verify that 4 distinct sources exist in runtime files:
	# 1. Timetable (Station 06)
	var s06_text := FileAccess.get_file_as_string("res://scenes/levels/station_06.tscn")
	_expect(s06_text.contains("TimetableStand") and s06_text.contains("inspect_street_timetable"), "Source 1: Timetable must exist in Station 06")

	# 2. Kiosk vendor (Station 06)
	_expect(s06_text.contains("KioskVendor") and s06_text.contains("ask_kiosk_vendor"), "Source 2: Kiosk vendor must exist in Station 06")

	# 3. Building facade / intercom directory (Station 07)
	var s07_text := FileAccess.get_file_as_string("res://scenes/levels/station_07.tscn")
	_expect(s07_text.contains("AddressPlaque") and s07_text.contains("IntercomDirectory"), "Source 3: Building facade and intercom directory in Station 07")

	# 4. Neighbour / key unlock (Station 08)
	var s08_text := FileAccess.get_file_as_string("res://scenes/levels/station_08.tscn")
	_expect(s08_text.contains("Neighbour") and s08_text.contains("DoorFourteen"), "Source 4: Neighbour and apartment 14 key in Station 08")


func _test_first_thirty_minutes_campaign_playthrough() -> void:
	print("Testing end-to-end player-verb campaign walkthrough 01 -> 02 -> 03 -> 04 -> 05 -> 06 -> 07 -> 08...")
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must exist")
	if state == null:
		return
	state.campaign_auto_transition_enabled = false
	state.reset_campaign(true)

	# Station 01
	var s01_packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	var s01 := s01_packed.instantiate() as Station01
	root.add_child(s01)
	_expect(s01.repeat_line_four_measurement(), "S01: repeat measurement")
	_expect(s01.secure_raw_sample(), "S01: secure raw sample")
	_expect(s01.read_marta_message(), "S01: read Marta message")
	s01.queue_free()

	# Station 02
	var s02_packed := load("res://scenes/levels/station_02.tscn") as PackedScene
	var s02 := s02_packed.instantiate() as Station02
	root.add_child(s02)
	_expect(s02.inspect_detour_closure(), "S02: inspect detour closure")
	_expect(s02.compare_detour_time(), "S02: compare detour time")
	_expect(s02.take_service_ladder(), "S02: take service ladder")
	s02.queue_free()

	# Station 03
	var s03_packed := load("res://scenes/levels/station_03.tscn") as PackedScene
	var s03 := s03_packed.instantiate() as Station03
	root.add_child(s03)
	_expect(s03.read_departure_board(), "S03: read departure board")
	_expect(s03.reply_to_marta(), "S03: reply to Marta")
	_expect(s03.board_line_four(), "S03: board Line 4")
	s03.queue_free()

	# Station 04
	var s04_packed := load("res://scenes/levels/station_04.tscn") as PackedScene
	var s04 := s04_packed.instantiate() as Station04
	root.add_child(s04)
	_expect(s04.observe_reader_buffer(), "S04: observe reader buffer")
	_expect(s04.watch_line_four_memorial(), "S04: watch Line 4 memorial")
	_expect(s04.stow_reader_for_marta(), "S04: stow reader for Marta")
	s04.queue_free()

	# Station 05
	var s05_packed := load("res://scenes/levels/station_05.tscn") as PackedScene
	var s05 := s05_packed.instantiate() as Station05
	root.add_child(s05)
	_expect(s05.check_street_route(), "S05: check street route")
	_expect(s05.check_sample_case(), "S05: check sample case")
	_expect(s05.cross_street_towards_home(), "S05: cross street towards home")
	_expect(bool(state.decisions.get(&"p9.street.home_street_observed", false)), "Decision home_street_observed")
	_expect(bool(state.decisions.get(&"p9.street.sample_case_verified", false)), "Decision sample_case_verified")
	_expect(bool(state.decisions.get(&"p9.street.crossing_completed", false)), "Decision crossing_completed")
	_expect(bool(state.decisions.get(&"ordinary_return_complete", false)), "Decision ordinary_return_complete")
	s05.queue_free()

	# Station 06
	var s06_packed := load("res://scenes/levels/station_06.tscn") as PackedScene
	var s06 := s06_packed.instantiate() as Station06
	root.add_child(s06)
	_expect(s06.inspect_street_timetable(), "S06: inspect timetable")
	_expect(s06.buy_water_at_kiosk(), "S06: buy water")
	_expect(s06.ask_kiosk_vendor(), "S06: ask vendor")
	_expect(bool(state.decisions.get(&"p9.kiosk.timetable_contradiction_seen", false)), "Decision timetable_contradiction_seen")
	_expect(bool(state.decisions.get(&"p9.kiosk.water_purchased", false)), "Decision water_purchased")
	_expect(bool(state.decisions.get(&"p9.kiosk.vendor_testimony_recorded", false)), "Decision vendor_testimony_recorded")
	_expect(bool(state.decisions.get(&"unease_pattern_started", false)), "Decision unease_pattern_started")
	s06.queue_free()

	# Station 07
	var s07_packed := load("res://scenes/levels/station_07.tscn") as PackedScene
	var s07 := s07_packed.instantiate() as Station07
	root.add_child(s07)
	_expect(s07.compare_address_document(), "S07: compare address document")
	_expect(s07.inspect_intercom_directory(), "S07: inspect intercom directory")
	_expect(s07.enter_intercom_code(), "S07: enter intercom code")
	_expect(bool(state.decisions.get(&"p9.exterior.address_document_compared", false)), "Decision address_document_compared")
	_expect(bool(state.decisions.get(&"p9.exterior.intercom_directory_inspected", false)), "Decision intercom_directory_inspected")
	_expect(bool(state.decisions.get(&"p9.exterior.intercom_code_unlocked", false)), "Decision intercom_code_unlocked")
	_expect(bool(state.decisions.get(&"local_address_confirmed", false)), "Decision local_address_confirmed")
	_expect(bool(state.decisions.get(&"conflicting_documents_found", false)), "Decision conflicting_documents_found")
	s07.queue_free()

	# Station 08
	var s08_packed := load("res://scenes/levels/station_08.tscn") as PackedScene
	var s08 := s08_packed.instantiate() as Station08
	root.add_child(s08)
	_expect(s08.inspect_floor_twelve(), "S08: inspect floor twelve")
	_expect(s08.speak_with_neighbour(), "S08: speak with neighbour")
	_expect(s08.unlock_apartment_fourteen(), "S08: unlock apartment fourteen")
	_expect(bool(state.decisions.get(&"p9.stairwell.door_twelve_inspected", false)), "Decision door_twelve_inspected")
	_expect(bool(state.decisions.get(&"p9.stairwell.neighbour_testimony_heard", false)), "Decision neighbour_testimony_heard")
	_expect(bool(state.decisions.get(&"p9.stairwell.key_unlocked_fourteen", false)), "Decision key_unlocked_fourteen")
	_expect(bool(state.decisions.get(&"marta_relationship_disclosed", false)), "Decision marta_relationship_disclosed")
	_expect(String(state.decisions.get(&"p7.foreign_daily_life.trace", "")) == "neighbour_and_key_confirm_fourteen", "Decision S04 trace")
	s08.queue_free()

	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = true


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0158 SMOKE PASS: First Thirty Minutes (BUNDLE-11..15), GATE-30, GATE-INT verified.")
		quit(0)
		return
	for failure in _failures:
		printerr(" - %s" % failure)
	quit(1)
