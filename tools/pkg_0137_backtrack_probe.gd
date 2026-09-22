extends SceneTree

## Backtracking probe: after Lena has walked to the far side of the room, can she
## walk all the way back to the ReturnZone? One station per run, no neighbours in
## the tree, so nothing here is a harness artefact.
##
## This is the tool that caught D-138: the stair flights on stations 07 and 09
## were ramps from the west and vertical walls from the east, so backtracking
## was physically impossible. Reach for it whenever a station reports a return
## failure, and read the ray lines — they name the collider that is in the way.
##
##   Godot_v4.6.3-stable_win64_console.exe --headless --path . ##     --script res://tools/pkg_0137_backtrack_probe.gd -- station_09

var _id := "station_07"


func _initialize() -> void:
	call_deferred(&"_run")


func _find(node: Node, pred: Callable) -> Node:
	if pred.call(node):
		return node
	for c in node.get_children():
		var f: Node = _find(c, pred)
		if f:
			return f
	return null


func _run() -> void:
	var args := OS.get_cmdline_user_args()
	if not args.is_empty():
		_id = String(args[0])
	var st := (load("res://scenes/levels/%s.tscn" % _id) as PackedScene).instantiate() as Node2D
	root.add_child(st)
	for _i in 8:
		await process_frame
	var player := st.get_node_or_null("Player") as CharacterBody2D
	var airlock := _find(st, func(n): return String(n.name) == "AirlockZone") as Area2D
	player.set_physics_process(false)

	print("--- %s --- spawn=%s airlock=%s" % [
		_id, str(player.global_position), str(airlock.global_position)
	])
	await _drive(player, 1.0, "outbound", airlock.global_position.x)
	print("  outbound ended at %s" % str(player.global_position))
	await _drive(player, -1.0, "return", 16.0)
	print("  return ended at %s" % str(player.global_position))
	_dump_blockers(st, player)
	quit(0)


func _drive(player: CharacterBody2D, dir: float, label: String, target_x: float) -> void:
	var stall := 0
	var lastx: float = player.global_position.x
	for i in 900:
		if signf(target_x - player.global_position.x) != dir:
			print("  %s reached target at frame %d" % [label, i])
			return
		if not player.is_on_floor():
			player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
		else:
			player.velocity.y = 0.0
		player.velocity.x = dir * 96.0
		player.move_and_slide()
		if player.has_method("try_curb_step"):
			player.try_curb_step(dir)
		await physics_frame
		if absf(player.global_position.x - lastx) < 0.05:
			stall += 1
			if stall > 60:
				print("  %s STALLED at x=%.1f y=%.1f (frame %d)" % [
					label, player.global_position.x, player.global_position.y, i
				])
				return
		else:
			stall = 0
		lastx = player.global_position.x


## Everything solid within one body-width of where she stopped.
func _dump_blockers(node: Node, player: CharacterBody2D) -> void:
	var px: float = player.global_position.x
	var py: float = player.global_position.y
	# What is actually in the way, asked of the physics server rather than guessed.
	var space := player.get_world_2d().direct_space_state
	for dy in [-40.0, -20.0, 0.0, 14.0]:
		var from := Vector2(px, py + dy)
		var q := PhysicsRayQueryParameters2D.create(from, from + Vector2(-40.0, 0.0))
		q.exclude = [player.get_rid()]
		var hit := space.intersect_ray(q)
		if hit.is_empty():
			print("    ray dy=%+.0f: clear" % dy)
		else:
			var col: Object = hit["collider"]
			print("    ray dy=%+.0f: %s (%s) at %s" % [
				dy, col.name, col.get_class(), str(hit["position"])
			])
	var stack: Array[Node] = [node]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is CollisionShape2D:
			var cs := n as CollisionShape2D
			if not cs.disabled and cs.shape is RectangleShape2D:
				var half: Vector2 = (cs.shape as RectangleShape2D).size * 0.5
				var pos := cs.global_position
				if absf(pos.x - px) < half.x + 40.0 and absf(pos.y - py) < half.y + 60.0:
					print("    near: %s/%s at %s half=%s" % [
						cs.get_parent().name, cs.name, str(pos), str(half)
					])
		for c in n.get_children():
			stack.append(c)
