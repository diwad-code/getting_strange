class_name InteractionFocus
extends RefCounted

## PKG-0242 (R1/UX): one `interact` press reaches exactly one reading point.
##
## Before this helper, every MemoryResonancePoint / OpeningActionPoint in reach
## answered `_unhandled_input` in reverse tree order, so when two reading zones
## overlapped (09, 10, 12) the press always went to the node declared last,
## whatever Lena stood next to. In Station 10 that made Marta's account of the
## day unreachable from the obvious spot, which silently cut the chain
## 10 → 11 → 12 → 13. The focused point is now the one nearest to Lena along
## the floor (x first, then y), and only that point shows the contact cue.
## Points that can no longer act (a resolved opening action) do not take focus.

const GROUP := &"gs_interactable"


static func register(point: Node) -> void:
	if point != null and not point.is_in_group(GROUP):
		point.add_to_group(GROUP)


static func is_focused(point: Node2D) -> bool:
	return focused_point(point) == point


## Returns the point that owns the next `interact` press in `context`'s tree,
## or null when Lena is out of reach of every point.
static func focused_point(context: Node) -> Node2D:
	if context == null or not context.is_inside_tree():
		return null
	var tree := context.get_tree()
	var player := tree.get_first_node_in_group(&"player") as Node2D
	var best: Node2D = null
	var best_key := Vector2(INF, INF)
	for node in tree.get_nodes_in_group(GROUP):
		var point := node as Node2D
		if point == null or not point.is_inside_tree() or not point.is_visible_in_tree():
			continue
		if point.get("is_player_in_range") != true:
			continue
		if point.has_method("can_take_focus") and not bool(point.call("can_take_focus")):
			continue
		var key := Vector2.ZERO
		if player != null:
			var delta := point.global_position - player.global_position
			key = Vector2(absf(delta.x), absf(delta.y))
		if best == null or key.x < best_key.x - 0.5 \
				or (absf(key.x - best_key.x) <= 0.5 and key.y < best_key.y) \
				or (key == best_key and point.get_instance_id() < best.get_instance_id()):
			best = point
			best_key = key
	return best
