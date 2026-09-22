extends SceneTree

## Live passability + interaction audit for every campaign station.
## Instantiates each scene, walks the floor, fires MemoryResonancePoint,
## calls known unlock methods, then walks again. Reports physics blocks
## separately from story/dialogue gates. Does not prove fun (ADR-003).

const STATIONS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41", &"station_42a", &"station_42b", &"station_42c", &"station_43",
]

const UNLOCK_METHODS: Array[StringName] = [
	&"unlock_exit_door", &"_unlock_exit_door", &"unlock_security_door",
	&"unlock_turnstile", &"open_bus_doors", &"_open_bus_doors",
	&"_open_entrance_door", &"_unlock_exit", &"unlock_exit",
	&"_complete_procedure", &"_check_unlock_condition", &"_check_unlock",
	&"_check_completion_condition", &"_check_threshold_conditions",
]

var _physics_blocks: Array[String] = []
var _story_gates: Array[String] = []
var _contract_gaps: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	print("================================================================================")
	print("     CAMPAIGN PLAYABILITY AUDIT: walk, interact, exit, return — 45 scenes     ")
	print("================================================================================")
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm:
		gsm.set("campaign_auto_transition_enabled", false)
	for station_id in STATIONS:
		await _audit_station(station_id)
	print("================================================================================")
	print("PHYSICS BLOCKS: %d" % _physics_blocks.size())
	for line in _physics_blocks:
		print("  BLOCK  " + line)
	print("STORY/DIALOGUE GATES (physics open): %d" % _story_gates.size())
	for line in _story_gates:
		print("  GATE   " + line)
	print("CONTRACT GAPS: %d" % _contract_gaps.size())
	for line in _contract_gaps:
		print("  GAP    " + line)
	if _physics_blocks.is_empty() and _contract_gaps.is_empty():
		print("PLAYABILITY AUDIT PASS: every station is physically traversable after interact/unlock.")
		quit(0)
	else:
		print("PLAYABILITY AUDIT FAIL: see BLOCK/GAP lines.")
		quit(1)



func _audit_station(station_id: StringName) -> void:
	var path := "res://scenes/levels/%s.tscn" % String(station_id)
	var packed := load(path) as PackedScene
	if packed == null:
		_contract_gaps.append("%s scene missing" % station_id)
		print("--- %s --- MISSING" % station_id)
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	await physics_frame

	var notes: Array[String] = []
	if not station.has_signal(&"level_completed"):
		_contract_gaps.append("%s missing level_completed" % station_id)
		notes.append("no level_completed")
	if station_id != &"station_01" and not station.has_signal(&"previous_level_requested"):
		_contract_gaps.append("%s missing previous_level_requested" % station_id)
		notes.append("no back signal")
	if station_id != &"station_01":
		var zone := station.get_node_or_null("ReturnZone")
		if zone == null:
			_contract_gaps.append("%s missing ReturnZone" % station_id)
			notes.append("no ReturnZone")

	var player := _find_player(station)
	var airlock := _find_named(station, "AirlockZone") as Area2D
	if player == null:
		_contract_gaps.append("%s missing Player" % station_id)
		print("--- %s --- no player" % station_id)
		station.queue_free()
		await process_frame
		return
	if airlock == null:
		_contract_gaps.append("%s missing AirlockZone" % station_id)
		notes.append("no AirlockZone")

	player.set_physics_process(false)
	var props := _collect_resonance(station)
	var target_x := airlock.global_position.x if airlock else 600.0

	var walk_before := await _walk_to(player, target_x)
	for prop in props:
		prop.is_player_in_range = true
		prop.trigger_interaction()
		prop.trigger_interaction()
	await process_frame
	for method_name in UNLOCK_METHODS:
		if station.has_method(method_name):
			station.call(method_name)
	await process_frame
	await physics_frame

	var walk_after := await _walk_to(player, target_x)
	var near_exit := absf(player.global_position.x - target_x) <= 36.0
	var unlocked := _station_unlocked(station)
	var leftover := _blocking_door_name(station, player.global_position.y)

	var status := "PASS"
	if not near_exit:
		status = "BLOCK"
		var hit: String = leftover if leftover != "" else ("x=%.1f" % walk_after)
		_physics_blocks.append("%s cannot reach exit x=%.0f (at x=%.0f, hit=%s)" % [
			station_id, target_x, player.global_position.x, hit
		])
	elif not unlocked:
		status = "GATE"
		_story_gates.append("%s physically open, story flag still locked after props+unlock calls" % station_id)


	print("--- %s --- %s | props=%d | unlock=%s | x=%.0f→%.0f | before=%s | notes=%s" % [
		station_id, status, props.size(), str(unlocked), walk_before, player.global_position.x,
		"ok" if absf(float(walk_before) - target_x) <= 36.0 else "blocked",
		", ".join(notes) if not notes.is_empty() else "-"
	])

	station.queue_free()
	for _i in 2:
		await process_frame


func _find_player(root_node: Node) -> CharacterBody2D:
	var node := root_node.get_node_or_null("Player")
	if node is CharacterBody2D:
		return node as CharacterBody2D
	return _find_by_class(root_node, "PrototypePlayer") as CharacterBody2D


func _find_named(node: Node, wanted: String) -> Node:
	if node.name == wanted:
		return node
	for child in node.get_children():
		var found: Node = _find_named(child, wanted)
		if found:
			return found
	return null


func _find_by_class(node: Node, cls: String) -> Node:
	var script_res: Script = node.get_script() as Script
	if node.get_class() == cls or (script_res != null and String(script_res.resource_path).get_file().begins_with(cls.to_lower())):
		if node is CharacterBody2D:
			return node
	if String(node.name) == "Player":
		return node
	for child in node.get_children():
		var found: Node = _find_by_class(child, cls)
		if found:
			return found
	return null



func _collect_resonance(node: Node) -> Array[MemoryResonancePoint]:
	var out: Array[MemoryResonancePoint] = []
	if node is MemoryResonancePoint:
		out.append(node as MemoryResonancePoint)
	for child in node.get_children():
		out.append_array(_collect_resonance(child))
	return out


func _walk_to(player: CharacterBody2D, target_x: float) -> float:
	var frames := 220
	while frames > 0:
		frames -= 1
		var dx := target_x - player.global_position.x
		if absf(dx) <= 8.0:
			break
		if not player.is_on_floor():
			player.velocity.y = minf(player.velocity.y + 720.0 / 60.0, 360.0)
		else:
			player.velocity.y = 0.0
		player.velocity.x = signf(dx) * 96.0
		player.move_and_slide()
		if player.has_method("try_curb_step"):
			player.try_curb_step(dx)
		await physics_frame
	return player.global_position.x




func _station_unlocked(station: Node) -> bool:
	var flags := [
		"is_procedure_completed", "is_door_unlocked", "is_turnstile_unlocked",
		"are_doors_open", "is_door_open", "is_threshold_open", "is_passage_clear",
		"is_exit_unlocked", "is_neighbour_dialogue_completed", "is_evidence_complete",
		"are_questions_written", "is_meeting_requested", "is_marta_dialogue_completed",
		"is_dialogue_completed", "is_header_copied", "are_public_sources_verified",
		"is_phone_completed",
	]
	for flag in flags:
		if flag in station and bool(station.get(flag)):
			return true
	# Stations with no gate (airlock always live) count as unlocked.
	if not ("is_level_completed" in station):
		return true
	var gated := false
	for flag in flags:
		if flag in station:
			gated = true
			break
	return not gated


func _blocking_door_name(station: Node, player_y: float) -> String:
	return _scan_bodies(station, player_y, station as Node2D)


func _scan_bodies(node: Node, player_y: float, origin: Node2D) -> String:
	if node is CollisionShape2D:
		var shape_node := node as CollisionShape2D
		if shape_node.disabled:
			return ""
		var parent := shape_node.get_parent()
		if parent == null:
			return ""
		var pname := String(parent.name).to_lower()
		var is_doorish := (
			pname.contains("door") or pname.contains("barrier") or pname.contains("turnstile")
			or pname.contains("bulkhead") or pname.contains("gate")
		)
		if not is_doorish:
			return ""
		if parent is CharacterBody2D:
			return ""
		var shape: Shape2D = shape_node.shape
		if shape is RectangleShape2D:
			var rect := shape as RectangleShape2D
			var pos := shape_node.global_position
			var half := rect.size * 0.5
			var top := pos.y - half.y
			var bot := pos.y + half.y
			if pos.x >= 430.0 and top < player_y - 8.0 and bot > player_y - 70.0:
				return String(parent.name)
	for child in node.get_children():
		var found := _scan_bodies(child, player_y, origin)
		if found != "":
			return found
	return ""
