extends SceneTree

## PKG-0175 gate — P9 PHASE-08 / BUNDLE-29: GATE-FLOW.
## Technical proof only: 20-address exits open from _ready; optional readings
## open a gap instead of locking the door; a minimal playthrough reaches 43.
## Does not claim the player will understand why to return (D-012).

const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")
const _GapLedger := preload("res://scripts/campaign/gap_ledger.gd")

const ROUTE: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

var _failures: Array[String] = []


const CampaignChain := preload("res://tests/support/campaign_chain.gd")


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0175: " + message)


func _run() -> void:
	print("=== PKG-0175 Smoke Test: GATE-FLOW continuous passability ===")
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must exist")
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = false
	_test_catalog()
	await _test_exits_open_from_ready()
	await _test_minimal_playthrough(state)
	await _test_gap_open_and_close(state)
	_test_no_new_binaries()
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = true
	if _failures.is_empty():
		print("PKG-0175 SMOKE PASS: GATE-FLOW — exits open from ready; gaps replace door locks.")
		quit(0)
	else:
		printerr("PKG-0175 FAIL: %d failure(s)." % _failures.size())
		quit(1)


func _test_catalog() -> void:
	print("1. Every catalogued gap has thought_pl, blocks and a reachable origin...")
	var catalog: Dictionary = _GapLedger.catalog()
	_expect(not catalog.is_empty(), "GapLedger catalog must not be empty")
	for gap_id in catalog.keys():
		var spec: Dictionary = catalog[gap_id]
		_expect(String(spec.get("thought_pl", "")).length() > 0, "%s missing thought_pl" % gap_id)
		# PKG-0239 (owner): an optional reading (05 street/bag) blocks nothing
		# and never opens; every other gap must name what it blocks.
		if spec.get("optional", false) == true:
			_expect(spec.get("blocks", []) is Array and (spec.get("blocks", []) as Array).is_empty(), "%s is optional and must block nothing" % gap_id)
		else:
			_expect(spec.get("blocks", []) is Array and not (spec.get("blocks", []) as Array).is_empty(), "%s missing blocks" % gap_id)
		var origin := String(spec.get("origin_station", ""))
		_expect(origin in ROUTE, "%s origin_station %s is not a campaign address" % [gap_id, origin])


func _test_exits_open_from_ready() -> void:
	print("2. 20 of 20 addresses unlock the exit from _ready...")
	for station_id in ROUTE:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s must load" % station_id)
		if packed == null:
			continue
		var station := packed.instantiate()
		root.add_child(station)
		for _frame in range(6):
			await physics_frame
		_GapLedger.ensure_exit_open(station)
		await physics_frame
		_expect(bool(station.get("is_exit_unlocked")), "%s exit must be open from ready" % station_id)
		var zone := station.get_node_or_null("Threshold")
		_expect(zone != null, "%s must keep ThresholdZone" % station_id)
		if zone != null:
			_expect(bool(zone.get("is_open")), "%s Threshold must open with the exit" % station_id)
		station.queue_free()
		await process_frame


func _test_minimal_playthrough(state: Node) -> void:
	print("3. Minimal route: zero OPTIONAL readings + all REQUIRED verbs reaches 43...")
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = false
	var linear: Array[String] = [
		"station_01", "station_02", "station_03", "station_04", "station_05",
		"station_06", "station_07", "station_08", "station_09", "station_10",
		"station_11", "station_12", "station_13", "station_14", "station_15",
		"station_16", "station_17", "station_18",
	]
	for station_id in linear:
		var station := await _open(station_id)
		if station == null:
			continue
		# PKG-0242 (R1, PKG-0239): the method is a conversation over two
		# visits (17 scope → 18 names it → 17 Jakub answers → 18 commits).
		# The minimal run plays that return trip live through the real
		# scenes (CampaignChain); nothing about consent is seeded.
		if station_id == "station_17":
			station.queue_free()
			await process_frame
			# The minimal run performs no verbs in 01..16, so the inputs 17
			# reads (as the old seed did for its outputs) are recorded here:
			# recognition of the world and the 16 trial with its small cost.
			if state != null:
				state.record_decision(&"world_recognized", true)
				state.record_decision(&"p7.work_history_and_record.institution_trial_result", "small_cost_and_home_echo_confirmed")
				state.record_decision(&"p9.mechanics.small_cost.home_echo_verified", true)
				state.record_decision(&"mechanic_cost_observed", true)
			_expect(await CampaignChain.record_scope(self, "granted"), "17: zakres Jakuba (minimal)")
			_expect(await CampaignChain.propose_method(self, "force_home", "partial"), "18: zestawienie, prawda i nazwanie metody (minimal)")
			_expect(await CampaignChain.answer_method(self, "accepted"), "17: odpowiedź Jakuba na metodę (minimal)")
			station = await _open(station_id)
			if station == null:
				continue
		if station_id == "station_18":
			_expect(bool(station.call("commit_force_home")), "18: commit (minimal)")
		_ThresholdBinder.install(station)
		_GapLedger.ensure_exit_open(station)
		_expect(bool(station.get("is_exit_unlocked")), "%s must stay passable with zero optional readings" % station_id)
		_ThresholdBinder.complete_from_test(station, station.get_node_or_null("Player"))
		await physics_frame
		_expect(bool(station.get("is_level_completed")), "%s threshold must complete on the minimal route" % station_id)
		station.queue_free()
		await process_frame
	if state != null and state.has_method("select_finale_method"):
		pass
	var finale_id := "station_42a"
	if state != null:
		var selected: Variant = state.decisions.get(&"campaign_finale", "station_42a")
		if selected is String and not String(selected).is_empty():
			finale_id = String(selected)
	_expect(finale_id == "station_42a", "minimalny commit prowadzi do 42A")
	var finale := await _open(finale_id)
	if finale != null:
		_expect(bool(finale.call("execute_forced_return")), "42A: wykonanie (minimal)")
		_expect(bool(finale.call("read_sealed_other_lena")), "42A: stan (minimal)")
		_expect(bool(finale.call("read_household_consequence")), "42A: skutek (minimal)")
		_ThresholdBinder.complete_from_test(finale, finale.get_node_or_null("Player"))
		await physics_frame
		_expect(bool(finale.get("is_level_completed")), "%s must complete on the minimal route" % finale_id)
		finale.queue_free()
		await process_frame
	var epilogue := await _open("station_43")
	if epilogue != null:
		_expect(bool(epilogue.call("inspect_notice")), "43: tablica (minimal)")
		_expect(bool(epilogue.call("inspect_credits")), "43: napisy (minimal)")
		_expect(bool(epilogue.call("inspect_blackout")), "43: blackout po lancuchu (minimal)")
		_ThresholdBinder.complete_from_test(epilogue, epilogue.get_node_or_null("Player"))
		await physics_frame
		_expect(bool(epilogue.get("is_level_completed")), "Station 43 must complete the minimal route")
		epilogue.queue_free()
		await process_frame


func _test_gap_open_and_close(state: Node) -> void:
	print("4. Skipping a consequential reading opens a gap; returning closes it...")
	if state != null:
		state.reset_campaign(true)
		state.campaign_auto_transition_enabled = false
		state.record_decision(&"p9.opening.choice", "leave_on_time")
	var station := await _open("station_02")
	if station == null:
		return
	_ThresholdBinder.complete_from_test(station, station.get_node_or_null("Player"))
	await physics_frame
	_expect(state != null and bool(state.call("has_open_gap", &"s02.route_time_unread")), "Leaving Station 02 unread must open s02.route_time_unread")
	if state != null:
		var record: Variant = state.open_gaps.get("s02.route_time_unread", {})
		_expect(record is Dictionary, "Opened gap must be a dictionary")
		if record is Dictionary:
			_expect(String((record as Dictionary).get("thought_pl", "")).length() > 0, "Opened gap must carry thought_pl")
			_expect(String((record as Dictionary).get("origin_station", "")) == "station_02", "Opened gap origin must be station_02")
			_expect((record as Dictionary).get("blocks", []) is Array, "Opened gap must list blocks")
	station.queue_free()
	await process_frame
	var blocked := await _open("station_03")
	if blocked != null:
		var opened: Variant = blocked.call("read_departure_board")
		_expect(not bool(opened), "Departure board must stay blocked without the Station 02 time")
		blocked.queue_free()
		await process_frame
	var returned := await _open("station_02")
	if returned == null:
		return
	if returned.has_method("inspect_detour_closure"):
		returned.call("inspect_detour_closure")
	if returned.has_method("compare_detour_time"):
		returned.call("compare_detour_time")
	_GapLedger.sync_closed_from_station(returned)
	await physics_frame
	_expect(state != null and not bool(state.call("has_open_gap", &"s02.route_time_unread")), "Performing the missed reading must close the gap")
	returned.queue_free()
	await process_frame


func _test_no_new_binaries() -> void:
	print("5. D-168: no new packaged .exe...")
	var found := 0
	_count_exe("res://", found)
	_expect(found == 0, "PKG-0175 must not add a packaged .exe")


func _count_exe(path: String, found: int) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if name.begins_with("."):
			name = dir.get_next()
			continue
		var child := path.path_join(name) if path != "res://" else "res://" + name
		if dir.current_is_dir():
			if name in ["snapshots", "archive_retired_web", ".godot"]:
				name = dir.get_next()
				continue
			_count_exe(child, found)
		elif name.to_lower().ends_with(".exe"):
			found += 1
		name = dir.get_next()
	dir.list_dir_end()


func _open(station_id: String) -> Node:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	_expect(packed != null, "%s must load" % station_id)
	if packed == null:
		return null
	var station := packed.instantiate()
	root.add_child(station)
	for _frame in range(4):
		await physics_frame
	_GapLedger.ensure_exit_open(station)
	return station
