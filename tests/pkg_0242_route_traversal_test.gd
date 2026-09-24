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
## Second half — who owns the `interact` press (D-228 MRP > Threshold):
## * on every address the exit keeps a stretch where no reading point is in
##   reach, so a press there always leaves;
## * where a reading point and the open exit overlap (18: the mutual-passage
##   side of the method post) the reading point owns the press while it
##   still has something to do; after the commit the exit wins there;
## * an exit the station cannot use yet (18 without a committed method)
##   refuses before the entry animation and Lena says what is missing;
## * a reading point pressed before its in-room prerequisite names that
##   step instead of sending Lena back to an earlier address;
## * each side of the 16/17/18 side-choices is a band at least MIN_SIDE_BAND
##   wide (the 18 post used to leave 12 px per side);
## * reading points no longer share one resized CircleShape2D;
## * every address re-opens cleanly after each finished route (revisit by
##   the ReturnZone): Station 16 used to raise a script error there and
##   abort its restore. Any error fails this gate through the log policy.
##
## Proves physics, placement and input routing only; it does not prove
## comprehension or fun.

const ROUTE: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]
const FRAME_BUDGET := 1500
const APERTURE_FLOOR_TOLERANCE := 1.5
const Focus := preload("res://scripts/interactables/interaction_focus.gd")
const CampaignChain := preload("res://tests/support/campaign_chain.gd")
const MIN_SIDE_BAND := 30.0
## [station, point, dead zone of its side choice]
const SIDE_CHOICES := [
	["station_16", "Props/CostSelector", 10.0],
	["station_17", "Props/ConsentScopeDesk", 24.0],
	["station_18", "Props/MartaTruthTable", 24.0],
	["station_18", "Props/MethodCommitPost", 40.0],
]

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
	for id in ROUTE:
		await _check_free_exit(state, id)
	for choice in SIDE_CHOICES:
		await _check_side_bands(state, choice)
	await _check_post_beats_door(state)
	await _check_door_after_commit(state)
	await _check_door_refusal(state)
	await _check_in_room_step_line(state)
	await _check_unique_shapes(state)
	await _check_revisits(state)
	_finish()


func _check_revisits(state: Node) -> void:
	for spec in [["force_home", "partial"], ["close_equal_recover_local", "partial"], ["mutual_passage", "full"]]:
		CampaignChain.seed_before_17(state)
		_expect(await CampaignChain.commit_chain(self, spec[0], spec[1], "granted"), "revisit: %s chain must commit" % spec[0])
		var finale := CampaignChain.finale_for(spec[0])
		_expect(await CampaignChain.play_finale(self, finale), "revisit: %s must play" % finale)
		for id in ROUTE:
			if id.begins_with("station_42") and id != finale:
				continue
			var station := (load("res://scenes/levels/%s.tscn" % id) as PackedScene).instantiate() as Node2D
			root.add_child(station)
			for _f in range(6):
				await physics_frame
			_expect(bool(station.get("is_exit_unlocked")) or id == "station_43", "revisit %s after %s: the exit must stay open" % [id, spec[0]])
			await _close(station)


func _press_interact() -> void:
	var event := InputEventAction.new()
	event.action = &"interact"
	event.pressed = true
	root.push_input(event, true)
	var release := InputEventAction.new()
	release.action = &"interact"
	root.push_input(release, true)
	await process_frame


func _drain_dialogue(station: Node) -> void:
	var box := station.get_node("CRTDialogueBox") as CRTDialogueBox
	var presenter := station.get_node_or_null("CreativeScenePresentation")
	for _i in range(120):
		if box.is_presenting():
			box.advance_dialogue()
		elif presenter == null or not bool(presenter.call("is_busy")):
			return
		await process_frame


func _check_door_after_commit(state: Node) -> void:
	CampaignChain.seed_before_17(state)
	_expect(await CampaignChain.commit_chain(self, "force_home", "partial", "granted"), "18: chain must commit for the after-commit door check")
	var station := (load("res://scenes/levels/station_18.tscn") as PackedScene).instantiate() as Node2D
	root.add_child(station)
	for _f in range(4):
		await physics_frame
	ThresholdBinder.install(station)
	await _drain_dialogue(station)
	var post := station.get_node("Props/MethodCommitPost") as Node2D
	var threshold := station.get_node("Threshold") as ThresholdZone
	var player := station.get_node("Player") as CharacterBody2D
	var overlap_x := -1.0
	for x in range(int(post.global_position.x) + 42, int(post.global_position.x) + 90, 2):
		await _stand(player, float(x))
		if threshold.is_player_in_range and Focus.focused_point(station) == post:
			overlap_x = float(x)
			break
	_expect(overlap_x > 0.0, "18: after the commit the post still reaches into the doorway")
	if overlap_x > 0.0:
		await _press_interact()
		_expect(bool(threshold.get("_busy")) or bool(station.get("is_level_completed")), "18: after the commit the exit, not the read post, owns the press at x=%d" % int(overlap_x))
	await _close(station)


func _check_door_refusal(state: Node) -> void:
	for spec in [["station_18", "trzy prognozy na tablicy"], ["station_43", "ogłoszenia i napisy"]]:
		var id: String = spec[0]
		var station := await _open(state, id)
		await _drain_dialogue(station)
		var threshold := station.get_node("Threshold") as ThresholdZone
		var player := station.get_node("Player") as CharacterBody2D
		await _stand(player, threshold.global_position.x)
		_expect(threshold.is_player_in_range and Focus.focused_point(station) == null, "%s: the doorway itself is free of reading points" % id)
		await _press_interact()
		var thought := station.get_node_or_null("InnerThoughtSurface")
		_expect(not bool(threshold.get("_busy")), "%s: an exit the station cannot use yet must not start the entry sequence" % id)
		_expect(not bool(station.get("is_level_completed")), "%s: the refused exit must not complete" % id)
		var said := ""
		if thought != null:
			for label in thought.find_children("*", "Label", true, false):
				said += String((label as Label).text) + " "
			for label in thought.find_children("*", "RichTextLabel", true, false):
				said += String((label as RichTextLabel).text) + " "
		_expect(thought != null and bool(thought.get("visible")) and said.contains(String(spec[1])), "%s: the refused exit must say what is missing (got '%s')" % [id, said.strip_edges()])
		await _close(station)


func _check_in_room_step_line(state: Node) -> void:
	CampaignChain.seed_before_17(state)
	var station := (load("res://scenes/levels/station_17.tscn") as PackedScene).instantiate() as Node2D
	root.add_child(station)
	for _f in range(4):
		await physics_frame
	await _drain_dialogue(station)
	var said: Array[String] = []
	(station.get_node("CRTDialogueBox") as CRTDialogueBox).line_started.connect(func(_speaker: StringName, text: String) -> void: said.append(text))
	var offer := station.get_node("Props/AdaptationOfferTerminal") as Node2D
	var player := station.get_node("Player") as CharacterBody2D
	await _stand(player, offer.global_position.x)
	_expect(Focus.focused_point(station) == offer, "17: Lena stands at the offer terminal")
	await _press_interact()
	for _f in range(4):
		await process_frame
	var joined := " ".join(said)
	_expect(joined.contains("Najpierw odczytam rejestr kosztów przy konsoli"), "17: the offer before the ledger names the ledger (got '%s')" % joined)
	_expect(not joined.contains("Brakuje mi wcześniejszego źródła"), "17: an in-room step must not send Lena to an earlier address")
	await _close(station)


## Physics positions only: Lena stands, the areas report overlap themselves.
func _stand(player: CharacterBody2D, x: float) -> void:
	player.global_position = Vector2(x, 296.0)
	player.velocity = Vector2.ZERO
	for _f in range(3):
		await physics_frame


func _open(state: Node, id: String) -> Node2D:
	state.reset_campaign(true)
	var station := (load("res://scenes/levels/%s.tscn" % id) as PackedScene).instantiate() as Node2D
	root.add_child(station)
	for _f in range(4):
		await physics_frame
	ThresholdBinder.install(station)
	return station


func _check_free_exit(state: Node, id: String) -> void:
	var station := await _open(state, id)
	var threshold := station.get_node_or_null("Threshold") as ThresholdZone
	var player := station.get_node_or_null("Player") as CharacterBody2D
	if threshold == null or player == null:
		_expect(false, "%s needs a Threshold and a Player" % id)
		await _close(station)
		return
	var free_stretch := 0
	for x in range(int(threshold.global_position.x) - 70, int(threshold.global_position.x) + 40, 4):
		player.global_position = Vector2(x, threshold.global_position.y + 20.0)
		player.velocity = Vector2.ZERO
		for _f in range(3):
			await physics_frame
		if threshold.is_player_in_range and Focus.focused_point(station) == null:
			free_stretch += 4
	_expect(free_stretch >= 24, "%s: the exit needs a stretch free of reading points (got %d px)" % [id, free_stretch])
	await _close(station)


func _check_side_bands(state: Node, choice: Array) -> void:
	var station := await _open(state, String(choice[0]))
	var point := station.get_node_or_null(String(choice[1])) as Node2D
	var player := station.get_node_or_null("Player") as CharacterBody2D
	if point == null or player == null:
		_expect(false, "%s needs %s" % [choice[0], choice[1]])
		await _close(station)
		return
	var dead: float = choice[2]
	var left := 0
	var right := 0
	for x in range(int(point.global_position.x) - 110, int(point.global_position.x) + 110, 2):
		await _stand(player, float(x))
		if Focus.focused_point(station) != point:
			continue
		var offset := float(x) - point.global_position.x
		if offset < -dead:
			left += 2
		elif offset > dead:
			right += 2
	_expect(left >= MIN_SIDE_BAND and right >= MIN_SIDE_BAND,
		"%s %s: each side must be a band of >= %d px (left %d, right %d)" % [choice[0], choice[1], int(MIN_SIDE_BAND), left, right])
	await _close(station)


func _check_post_beats_door(state: Node) -> void:
	var station := await _open(state, "station_18")
	var post := station.get_node("Props/MethodCommitPost") as Node2D
	var threshold := station.get_node("Threshold") as ThresholdZone
	var player := station.get_node("Player") as CharacterBody2D
	var pressed: Array[String] = []
	station.connect("clue_inspected", func(id: String, _type: int) -> void: pressed.append(id))
	var overlap_x := -1.0
	for x in range(int(post.global_position.x) + 42, int(post.global_position.x) + 90, 2):
		await _stand(player, float(x))
		if threshold.is_player_in_range and Focus.focused_point(station) == post:
			overlap_x = float(x)
			break
	_expect(overlap_x > 0.0, "18: the mutual side of the post must reach into the open doorway")
	# The opening line is still on screen; a press there only advances it.
	var box := station.get_node("CRTDialogueBox") as CRTDialogueBox
	for _i in range(40):
		if not box.is_presenting():
			break
		box.advance_dialogue()
		await process_frame
	if overlap_x > 0.0:
		var event := InputEventAction.new()
		event.action = &"interact"
		event.pressed = true
		root.push_input(event, true)
		await process_frame
		_expect(pressed.has("method_commit_post"), "18: at x=%d the post, not the door, must own the press" % int(overlap_x))
		_expect(not bool(threshold.get("_busy")), "18: the door must not start a crossing while the post owns the press")
	await _close(station)


func _check_unique_shapes(state: Node) -> void:
	var station := await _open(state, "station_18")
	var radii := {}
	for name in ["ForecastComparator", "MartaTruthTable", "MethodCommitPost"]:
		var shape := (station.get_node("Props/%s/CollisionShape2D" % name) as CollisionShape2D).shape as CircleShape2D
		radii[name] = shape.radius
	_expect(is_equal_approx(radii["ForecastComparator"], 44.0) and is_equal_approx(radii["MartaTruthTable"], 56.0) and is_equal_approx(radii["MethodCommitPost"], 72.0),
		"18: each reading point keeps its own reach (got %s)" % str(radii))
	await _close(station)


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
		print("PKG-0242 ROUTE TRAVERSAL PASS: 22 addresses walkable spawn → exit → return by input only; exits keep a free stretch; reading points own the press; side bands >= %d px." % int(MIN_SIDE_BAND))
		quit(0)
	else:
		print("PKG-0242 ROUTE TRAVERSAL FAIL (%d)" % _failures.size())
		quit(1)
