extends SceneTree

## PKG-0242 gate — physical traversal of every campaign address.
##
## For each of the 22 route scenes (01–18, 42A/B/C, 43) Lena is driven only by
## the semantic InputMap actions a player holds: move_right / move_left, and
## move_up / move_down at a ladder. Success means her body really enters the
## exit Threshold on the right and the ReturnZone on the left (01 has none).
## Nothing here calls station verbs, teleports the player, forces
## `is_player_in_range` or completes a station.
##
## Why: Station 14 shipped with a 60 px machine housing between Lena and the
## exit while her jump peaks at ~44 px (D-123 caps a step at 18 px). Every
## older gate called the station's verbs directly, so no gate noticed that a
## player could not cross the room. The exit apertures of 16–18, 42A–C and 43
## were also placed on a floor height the scenes no longer had.
##
## Proves physics and placement only; it does not prove comprehension or fun.

const ROUTE: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]
const FRAME_BUDGET := 1500
const APERTURE_FLOOR_TOLERANCE := 1.5

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0242 TRAVERSAL: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state == null:
		_finish()
		return
	state.set("campaign_auto_transition_enabled", false)
	for id in ROUTE:
		await _traverse(state, id)
	_finish()


func _traverse(state: Node, id: String) -> void:
	state.reset_campaign(true)
	var packed := load("res://scenes/levels/%s.tscn" % id) as PackedScene
	_expect(packed != null, "%s scene must load" % id)
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	for _f in range(12):
		await physics_frame
	var player := station.get_node_or_null("Player") as CharacterBody2D
	var threshold := station.get_node_or_null("Threshold") as ThresholdZone
	var back := station.get_node_or_null("ReturnZone") as Area2D
	_expect(player != null, "%s has a Player" % id)
	_expect(threshold != null, "%s has a runtime Threshold" % id)
	if player == null or threshold == null:
		await _close(station)
		return
	# The exit aperture stands on the surface Lena walks on at the exit.
	var floor_top := ThresholdBinder.floor_top_at(station, threshold.position.x)
	var aperture_bottom := threshold.position.y + threshold.aperture_rect.end.y
	_expect(absf(aperture_bottom - floor_top) <= APERTURE_FLOOR_TOLERANCE,
		"%s exit aperture bottom %.1f must stand on the floor %.1f" % [id, aperture_bottom, floor_top])
	# Forward: from the spawn to the exit Threshold.
	var reached_exit: bool = await _hold_until(player, &"move_right", func() -> bool: return threshold.is_player_in_range)
	_expect(reached_exit, "%s: Lena must walk from the spawn into the exit Threshold (stopped at x=%.0f y=%.0f)" % [id, player.global_position.x, player.global_position.y])
	# Backward: from the exit to the ReturnZone (or the left wall on 01).
	var left_goal := func() -> bool:
		if back != null:
			return back.get("is_player_in_range") == true
		return player.global_position.x <= 48.0
	var reached_back: bool = await _hold_until(player, &"move_left", left_goal)
	_expect(reached_back, "%s: Lena must walk back to the %s (stopped at x=%.0f y=%.0f)" % [id, "ReturnZone" if back != null else "left edge", player.global_position.x, player.global_position.y])
	print("PKG-0242 TRAVERSAL %s: exit=%s back=%s aperture=%.0f floor=%.0f" % [id, reached_exit, reached_back, aperture_bottom, floor_top])
	await _close(station)


## Holds one direction; when Lena stalls at a ladder she climbs it with the
## same intent a player uses (stop + up, or down when the way on is below).
func _hold_until(player: CharacterBody2D, action: StringName, goal: Callable) -> bool:
	var last_x := player.global_position.x
	var stall := 0
	var climbing := StringName()
	Input.action_press(action)
	for _frame in range(FRAME_BUDGET):
		await physics_frame
		if goal.call():
			_release_all()
			return true
		if not climbing.is_empty():
			if bool(player.get("is_climbing")):
				stall = 0
			else:
				stall += 1
			if stall > 8:
				Input.action_release(climbing)
				climbing = StringName()
				Input.action_press(action)
				stall = 0
				last_x = player.global_position.x
			continue
		if absf(player.global_position.x - last_x) < 0.25:
			stall += 1
		else:
			stall = 0
		last_x = player.global_position.x
		if stall == 20 and _ladder_in_reach(player):
			Input.action_release(action)
			climbing = &"move_up" if action == &"move_right" else &"move_down"
			for _f in range(4):
				await physics_frame
			Input.action_press(climbing)
			stall = 0
		elif stall > 90:
			break
	_release_all()
	return goal.call()


func _ladder_in_reach(player: Node) -> bool:
	for node in player.get_tree().get_nodes_in_group(&"gs_ladder"):
		if node.get("is_player_in_range") == true:
			return true
	var station := player.get_parent()
	for node in station.find_children("*", "LadderZone", true, false):
		if node.get("is_player_in_range") == true:
			return true
	return false


func _release_all() -> void:
	for action in [&"move_left", &"move_right", &"move_up", &"move_down"]:
		Input.action_release(action)


func _close(station: Node) -> void:
	_release_all()
	station.queue_free()
	for _f in range(4):
		await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0242 ROUTE TRAVERSAL PASS: 22 addresses walkable spawn → exit → return by input only.")
		quit(0)
	else:
		print("PKG-0242 ROUTE TRAVERSAL FAIL (%d)" % _failures.size())
		quit(1)
