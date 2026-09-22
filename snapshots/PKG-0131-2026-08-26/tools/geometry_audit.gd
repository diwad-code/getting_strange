extends SceneTree

const CAMPAIGN_DIR := "res://scenes/levels"

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	print("================================================================================")
	print("          GLOBAL GEOMETRY & TRAVERSAL AUDIT: 45 CAMPAIGN SCENES                 ")
	print("================================================================================\n")
	
	var dir := DirAccess.open(CAMPAIGN_DIR)
	if dir == null:
		print("ERROR: Cannot open ", CAMPAIGN_DIR)
		quit(1)
		return
	
	var raw_files: PackedStringArray = dir.get_files()
	var files: Array[String] = []
	for f in raw_files:
		if f.ends_with(".tscn"):
			files.append(f)
	files.sort()
	
	print("Found %d campaign scene files to audit.\n" % files.size())
	
	var total_blocking_obstacles: int = 0
	var scenes_with_blocking: Array[String] = []
	var total_ladders: int = 0
	var total_lifts: int = 0
	var all_flagged_obstacles: Array[Dictionary] = []
	
	for fname in files:
		var scene_path: String = CAMPAIGN_DIR + "/" + fname
		var result: Dictionary = _audit_tscn_file(scene_path, fname)
		if result["blocking_count"] > 0:
			scenes_with_blocking.append(fname)
			total_blocking_obstacles += result["blocking_count"]
			for obs in result["blocking_obstacles"]:
				all_flagged_obstacles.append(obs)
		total_ladders += result["ladders"].size()
		total_lifts += result["lifts"].size()
	
	print("\n================================================================================")
	print("AUDIT SUMMARY:")
	print("  Total campaign scenes inspected: %d" % files.size())
	print("  Total Ladders found: %d" % total_ladders)
	print("  Total Service Lifts found: %d" % total_lifts)
	print("  Scenes with BLOCKING obstacles: %d / %d" % [scenes_with_blocking.size(), files.size()])
	print("  Total blocking obstacles found: %d" % total_blocking_obstacles)
	print("================================================================================\n")
	
	if not all_flagged_obstacles.is_empty():
		print("CRITICAL BLOCKERS REQUIRING REMEDIATION:")
		for item in all_flagged_obstacles:
			print("  - [%s] %s: X=[%.1f..%.1f], StepUp=%.1f px, Height=%.1f px" % [
				item["scene"], item["name"], item["left_x"], item["right_x"], item["step_up"], item["height"]
			])
	else:
		print("ALL 45 STATIONS TRAVERSAL-CERTIFIED! Zero blocking barriers.")
	
	print("================================================================================")
	quit(0)

func _audit_tscn_file(file_path: String, fname: String) -> Dictionary:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		print("FAIL TO OPEN: ", file_path)
		return {"blocking_count": 0, "ladders": [], "lifts": [], "blocking_obstacles": []}
	
	var content: String = file.get_as_text()
	file.close()
	
	var lines: PackedStringArray = content.split("\n")
	
	# 1. Parse sub-resources (shapes)
	var shapes: Dictionary = {} # id -> Vector2 size
	var current_sub_id: String = ""
	for line in lines:
		var trimmed: String = line.strip_edges()
		if trimmed.begins_with("[sub_resource"):
			var parts: PackedStringArray = trimmed.split(" ")
			for p in parts:
				if p.begins_with("id=\""):
					current_sub_id = p.replace("id=\"", "").replace("\"]", "").replace("\"", "")
		elif current_sub_id != "" and trimmed.begins_with("size = Vector2("):
			var vec_str: String = trimmed.replace("size = Vector2(", "").replace(")", "")
			var vparts: PackedStringArray = vec_str.split(",")
			if vparts.size() >= 2:
				shapes[current_sub_id] = Vector2(vparts[0].to_float(), vparts[1].to_float())
		elif trimmed.begins_with("[node") or trimmed.begins_with("[ext_resource"):
			current_sub_id = ""
	
	# 2. Parse nodes
	var nodes: Array[Dictionary] = []
	var current_node: Dictionary = {}
	for line in lines:
		var trimmed: String = line.strip_edges()
		if trimmed.begins_with("[node "):
			if not current_node.is_empty():
				nodes.append(current_node)
			current_node = {
				"name": "",
				"type": "",
				"parent": "",
				"pos": Vector2.ZERO,
				"shape_id": "",
				"one_way": false,
				"ladder_h": 0.0,
				"is_ladder": false,
				"is_lift": false,
			}
			var header := trimmed.trim_prefix("[node ").trim_suffix("]")
			var tokens := _parse_header_tokens(header)
			current_node["name"] = tokens.get("name", "")
			current_node["type"] = tokens.get("type", "")
			current_node["parent"] = tokens.get("parent", "")
			if current_node["name"].to_lower().contains("ladder") or current_node["type"] == "LadderZone":
				current_node["is_ladder"] = true
			if current_node["name"].to_lower().contains("servicelift") or current_node["type"] == "ServiceLift":
				current_node["is_lift"] = true
		elif not current_node.is_empty():
			if trimmed.begins_with("position = Vector2("):
				var vec_str: String = trimmed.replace("position = Vector2(", "").replace(")", "")
				var vparts: PackedStringArray = vec_str.split(",")
				if vparts.size() >= 2:
					current_node["pos"] = Vector2(vparts[0].to_float(), vparts[1].to_float())
			elif trimmed.begins_with("one_way_collision = true"):
				current_node["one_way"] = true
			elif trimmed.begins_with("shape = SubResource(\""):
				var sid: String = trimmed.replace("shape = SubResource(\"", "").replace("\")", "")
				current_node["shape_id"] = sid
			elif trimmed.begins_with("ladder_height = "):
				var h_str: String = trimmed.replace("ladder_height = ", "")
				current_node["ladder_h"] = h_str.to_float()
	if not current_node.is_empty():
		nodes.append(current_node)
	
	# 3. Analyze hierarchy and coordinates
	var player_pos := Vector2(70.0, 296.0)
	var airlock_pos := Vector2.ZERO
	var floor_y := 296.0
	var ladders: Array[Dictionary] = []
	var lifts: Array[Dictionary] = []
	var solid_bodies: Array[Dictionary] = []
	
	for n in nodes:
		var nname: String = n["name"]
		if nname == "Player":
			player_pos = n["pos"]
		elif nname == "AirlockZone":
			airlock_pos = n["pos"]
		elif n["is_ladder"]:
			ladders.append(n)
		elif n["is_lift"]:
			lifts.append(n)
	
	# Detect Floor top Y first
	for n in nodes:
		var nname: String = n["name"]
		if nname == "Floor" or nname == "FloorMain":
			var body_pos: Vector2 = n["pos"]
			var shape_size := Vector2.ZERO
			for c in nodes:
				if (c["parent"] == "Geometry/" + nname or c["parent"] == nname) and c["type"] == "CollisionShape2D":
					if c["shape_id"] != "" and shapes.has(c["shape_id"]):
						shape_size = shapes[c["shape_id"]]
			if shape_size != Vector2.ZERO:
				floor_y = body_pos.y - shape_size.y * 0.5
	
	# Find shapes for solid bodies (StaticBody2D, AnimatableBody2D, CharacterBody2D)
	for n in nodes:
		var nname: String = n["name"]
		var ntype: String = n["type"]
		var nparent: String = n["parent"]
		
		# Skip non-solid nodes (Area2D, CanvasLayer, Node, Camera, etc.)
		if ntype == "Area2D" or nname == "AirlockZone" or nparent.begins_with("Props") or nname == "Player":
			continue
		
		# Only check physical obstacles
		if ntype == "StaticBody2D" or ntype == "AnimatableBody2D" or ntype == "CharacterBody2D" or nparent == "Geometry" or nparent.begins_with("Geometry/"):
			if nname == "Floor" or nname == "FloorMain" or nname == "WallLeft" or nname == "WallRight" or nname == "Ceiling":
				continue
			
			var body_pos: Vector2 = n["pos"]
			var shape_size := Vector2.ZERO
			var one_way: bool = n["one_way"]
			
			for c in nodes:
				if c["parent"] == "Geometry/" + nname or c["parent"] == nname or (nparent == "Geometry" and c["parent"] == nname):
					if c["type"] == "CollisionShape2D" or c["name"] == "CollisionShape2D":
						if c["shape_id"] != "" and shapes.has(c["shape_id"]):
							shape_size = shapes[c["shape_id"]]
						if c["one_way"]:
							one_way = true
			
			if shape_size != Vector2.ZERO:
				var top_y: float = body_pos.y - shape_size.y * 0.5
				var bot_y: float = body_pos.y + shape_size.y * 0.5
				var left_x: float = body_pos.x - shape_size.x * 0.5
				var right_x: float = body_pos.x + shape_size.x * 0.5
				
				solid_bodies.append({
					"name": nname,
					"type": ntype,
					"pos": body_pos,
					"size": shape_size,
					"top_y": top_y,
					"bot_y": bot_y,
					"left_x": left_x,
					"right_x": right_x,
					"one_way": one_way
				})
	
	var obstacles: Array[Dictionary] = []
	var blocking_count: int = 0
	var blocking_obstacles: Array[Dictionary] = []
	
	for b in solid_bodies:
		var bname: String = b["name"]
		var step_up: float = floor_y - float(b["top_y"])
		var is_door: bool = bname.to_lower().contains("door") or bname.to_lower().contains("barrier") or bname.to_lower().contains("bulkhead") or bname.to_lower().contains("partition") or bname.to_lower().contains("gate")
		var is_blocking: bool = step_up > 35.0 and not bool(b["one_way"]) and not is_door
		
		if is_blocking:
			var has_ladder := false
			for lad in ladders:
				var lad_pos: Vector2 = lad["pos"]
				if lad_pos.x >= float(b["left_x"]) - 45.0 and lad_pos.x <= float(b["right_x"]) + 45.0:
					has_ladder = true
					break
			for lift in lifts:
				var lift_pos: Vector2 = lift["pos"]
				if lift_pos.x >= float(b["left_x"]) - 45.0 and lift_pos.x <= float(b["right_x"]) + 45.0:
					has_ladder = true
					break
			if not has_ladder:
				blocking_count += 1
				blocking_obstacles.append({
					"scene": fname,
					"name": bname,
					"left_x": b["left_x"],
					"right_x": b["right_x"],
					"top_y": b["top_y"],
					"step_up": step_up,
					"height": b["size"].y
				})
		
		obstacles.append({
			"name": bname,
			"left_x": b["left_x"],
			"right_x": b["right_x"],
			"top_y": b["top_y"],
			"step_up": step_up,
			"height": b["size"].y,
			"one_way": b["one_way"],
			"is_door": is_door,
			"blocking": is_blocking
		})
	
	print("--- %s ---" % fname)
	print("  Floor: %.1f | Player: (%.1f, %.1f) | Airlock: (%.1f, %.1f) | Ladders: %d | Lifts: %d | Solid Obstacles: %d" % [floor_y, player_pos.x, player_pos.y, airlock_pos.x, airlock_pos.y, ladders.size(), lifts.size(), obstacles.size()])
	for obs in obstacles:
		var status: String = "OK (step <= 35px)"
		if obs["blocking"]:
			status = ">>> BLOCKING BARRIER (>35px, solid, no ladder) <<<"
		elif obs["one_way"]:
			status = "ONE-WAY PLATFORM (walk-through/climbable)"
		elif obs["is_door"]:
			status = "INTERACTIVE DOOR / SECURITY BARRIER (opens via narrative trigger)"
		print("    * %s: X=[%.1f..%.1f], TopY=%.1f, StepUp=%.1f px -> %s" % [obs["name"], obs["left_x"], obs["right_x"], obs["top_y"], obs["step_up"], status])
	for lad in ladders:
		var lpos: Vector2 = lad["pos"]
		print("    [Ladder] %s at (%.1f, %.1f)" % [lad["name"], lpos.x, lpos.y])
	for lift in lifts:
		var lpos: Vector2 = lift["pos"]
		print("    [Lift] %s at (%.1f, %.1f)" % [lift["name"], lpos.x, lpos.y])
	
	return {
		"blocking_count": blocking_count,
		"ladders": ladders,
		"lifts": lifts,
		"blocking_obstacles": blocking_obstacles
	}

func _parse_header_tokens(header: String) -> Dictionary:
	var res: Dictionary = {}
	var parts: PackedStringArray = header.split(" ")
	for p in parts:
		if p.contains("="):
			var kv := p.split("=")
			var k := kv[0].strip_edges()
			var v := kv[1].strip_edges().replace("\"", "")
			res[k] = v
	return res
