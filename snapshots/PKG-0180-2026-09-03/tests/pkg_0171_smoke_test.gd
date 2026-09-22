extends SceneTree

## PKG-0171 gate — P9 PHASE-07 / BUNDLE-25: Clean Cutover, Legacy Shims Cleanup,
## Campaign Route Integrity and Presentation Defect Audit.
## Technical proof only: 18-station linear campaign route, 20-station selector,
## isolation of legacy stations 19..41, finale branching from station_18,
## epilogue routing to station_43, and technical donor class preservation.
## It does not claim comprehension, emotion, fun or PRODUCT GO.

const AnchorExclusivityController := preload("res://scripts/interactables/anchor_exclusivity_controller.gd")
const AnchorableObject := preload("res://scripts/interactables/anchorable_object.gd")
const MovableAnchorableProp := preload("res://scripts/interactables/movable_anchorable_prop.gd")
const ServiceLift := preload("res://scripts/environment/service_lift.gd")
const LadderZone := preload("res://scripts/environment/ladder_zone.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0171: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state == null:
		_finish()
		return

	_test_campaign_route_cutover(state)
	_test_selector_cutover(state)
	_test_legacy_isolation_and_shims(state)
	_test_station_18_finale_branching(state)
	_test_technical_donors_preservation()

	state.reset_campaign(true)
	_finish()


func _test_campaign_route_cutover(state: Node) -> void:
	var constants: Dictionary = state.get_script().get_script_constant_map()
	_expect(int(constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 18, "CAMPAIGN_TRANSITION_LIMIT must be 18")
	_expect(int(constants.get("LEGACY_CAMPAIGN_TRANSITION_LIMIT", -1)) == 41, "LEGACY_CAMPAIGN_TRANSITION_LIMIT must be 41")

	var route: Array = constants.get("CAMPAIGN_ROUTE", [])
	_expect(route.size() == 18, "CAMPAIGN_ROUTE must contain exactly 18 stations (got %d)" % route.size())
	for index in range(18):
		var expected_id := StringName("station_%02d" % (index + 1))
		_expect(index < route.size() and route[index] == expected_id, "Route index %d must be %s" % [index, expected_id])

	for legacy_num in range(19, 42):
		var legacy_id := StringName("station_%02d" % legacy_num)
		_expect(not route.has(legacy_id), "Legacy station %s must not be in CAMPAIGN_ROUTE" % legacy_id)

	var all_ids: Array[StringName] = state.get_all_campaign_scene_ids()
	_expect(all_ids.size() == 22, "get_all_campaign_scene_ids must return 22 resources (18 + 3 finales + epilogue), got %d" % all_ids.size())


func _test_selector_cutover(state: Node) -> void:
	state.reset_campaign(true)
	var selector: Array[StringName] = state.get_selectable_stations(true)
	_expect(selector.size() == 20, "Selector must expose exactly 20 stations in test mode (got %d)" % selector.size())

	# Initial default (no finale selected yet)
	_expect(selector[0] == &"station_01", "Selector index 0 must be station_01")
	_expect(selector[17] == &"station_18", "Selector index 17 must be station_18")
	_expect(selector[18] in [&"station_42a", &"station_42b", &"station_42c"], "Selector index 18 must be a finale variant")
	_expect(selector[19] == &"station_43", "Selector index 19 must be station_43")

	state.reset_campaign(false)
	var normal_unlocked: Array[StringName] = state.get_selectable_stations(false)
	_expect(normal_unlocked.size() == 1 and normal_unlocked[0] == &"station_01", "Normal campaign must initially unlock only station_01")


func _test_legacy_isolation_and_shims(state: Node) -> void:
	var constants: Dictionary = state.get_script().get_script_constant_map()
	var legacy_stations: Array = constants.get("CAMPAIGN_LEGACY_STATIONS", [])
	_expect(legacy_stations.size() == 23, "CAMPAIGN_LEGACY_STATIONS must retain 23 donor stations (19..41), got %d" % legacy_stations.size())

	# Verify legacy stepping shims
	_expect(state.get_next_campaign_station(&"station_19") == &"station_20", "Legacy step station_19 -> station_20 must work")
	_expect(state.get_next_campaign_station(&"station_40") == &"station_41", "Legacy step station_40 -> station_41 must work")
	_expect(state.get_previous_campaign_station(&"station_19") == &"station_18", "Legacy previous from station_19 must lead back to station_18")
	_expect(state.get_previous_campaign_station(&"station_20") == &"station_19", "Legacy previous from station_20 must lead to station_19")

	# Test all scene ids helper
	var combined: Array[StringName] = state.get_all_scene_ids(true)
	_expect(combined.size() == 45, "Combined scene IDs (active 22 + legacy 23) must equal 45, got %d" % combined.size())


func _test_station_18_finale_branching(state: Node) -> void:
	var branch_map := {
		"A": &"station_42a",
		"B": &"station_42b",
		"C": &"station_42c",
	}

	for branch in ["A", "B", "C"]:
		state.reset_campaign(true)
		var expected_finale: StringName = branch_map[branch]
		var chosen: StringName = state.select_finale_operation(branch)
		_expect(chosen == expected_finale, "select_finale_operation(%s) must return %s" % [branch, expected_finale])
		_expect(state.get_selected_finale_id() == expected_finale, "get_selected_finale_id must return %s" % expected_finale)

		# Station 18 routing to chosen finale
		_expect(state.get_next_campaign_station(&"station_18") == expected_finale, "station_18 must lead to %s for branch %s" % [expected_finale, branch])
		_expect(state.get_previous_campaign_station(expected_finale) == &"station_18", "Previous from %s must be station_18" % expected_finale)

		# Finale routing to epilogue
		_expect(state.get_next_campaign_station(expected_finale) == &"station_43", "%s must lead to station_43" % expected_finale)
		_expect(state.get_previous_campaign_station(&"station_43") == expected_finale, "Previous from station_43 must lead to %s" % expected_finale)

		# Selector slot 18 must reflect chosen finale
		var selectable: Array[StringName] = state.get_selectable_stations(true)
		_expect(selectable.size() == 20, "Selectable count must be 20")
		_expect(selectable[18] == expected_finale, "Selectable[18] must be %s for branch %s" % [expected_finale, branch])

		# Simulating station 18 completion
		state.complete_station(&"station_18", false)
		_expect(state.has_reached_station(&"station_18"), "station_18 must be marked reached")
		_expect(state.has_reached_station(expected_finale), "%s must be marked reached after station_18 completion" % expected_finale)

		# Completing finale leads to epilogue
		state.complete_station(expected_finale, false)
		_expect(state.has_reached_station(expected_finale), "%s must be reached" % expected_finale)
		_expect(state.has_reached_station(&"station_43"), "station_43 must be reached after %s completion" % expected_finale)

		# Completing epilogue completes campaign
		state.complete_station(&"station_43", false)
		_expect(state.is_campaign_completed(), "Campaign must be marked completed after station_43")


func _test_technical_donors_preservation() -> void:
	# AnchorExclusivityController
	var aec := AnchorExclusivityController.new()
	_expect(aec != null, "AnchorExclusivityController must instantiate")
	if aec:
		_expect(aec.has_method("set_active_anchor"), "AnchorExclusivityController must have set_active_anchor")
		_expect(aec.has_method("clear_active_anchor"), "AnchorExclusivityController must have clear_active_anchor")
		aec.free()

	# AnchorableObject
	var ao := AnchorableObject.new()
	_expect(ao != null, "AnchorableObject must instantiate")
	if ao:
		_expect("is_anchored" in ao, "AnchorableObject must expose is_anchored")
		ao.free()

	# MovableAnchorableProp
	var map := MovableAnchorableProp.new()
	_expect(map != null, "MovableAnchorableProp must instantiate")
	if map:
		_expect("push_speed_max" in map, "MovableAnchorableProp must expose push_speed_max")
		_expect("is_anchored" in map, "MovableAnchorableProp must expose is_anchored")
		map.free()

	# ServiceLift
	var lift := ServiceLift.new()
	_expect(lift != null, "ServiceLift must instantiate")
	if lift:
		_expect("travel_distance" in lift, "ServiceLift must expose travel_distance")
		lift.free()

	# LadderZone
	var lz := LadderZone.new()
	_expect(lz != null, "LadderZone must instantiate")
	if lz:
		_expect("ladder_height" in lz, "LadderZone must expose ladder_height")
		lz.free()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0171 SMOKE PASS: 20-station cutover, legacy shims, and donor integrity verified.")
		quit(0)
	else:
		print("PKG-0171 SMOKE FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
