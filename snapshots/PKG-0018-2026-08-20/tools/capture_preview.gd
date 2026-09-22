extends SceneTree


func _initialize() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(640, 360)
	var output_dir := ProjectSettings.globalize_path("res://reports")
	var directory_error := DirAccess.make_dir_recursive_absolute(output_dir)
	if directory_error != OK:
		push_error("CAPTURE: cannot create reports directory")
		quit(1)
		return

	# 1. Movement Lab capture
	var packed_mov := load("res://scenes/prototype/movement_lab.tscn") as PackedScene
	if packed_mov:
		var mov_inst := packed_mov.instantiate()
		root.add_child(mov_inst)
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var image := root.get_texture().get_image()
		if image:
			image.save_png(output_dir.path_join("movement_lab.png"))
			print("CAPTURE PASS: " + output_dir.path_join("movement_lab.png"))
		mov_inst.queue_free()
		await process_frame

	# 2. Anchor Lab captures across 3 cinematic chambers
	var packed_anchor := load("res://scenes/prototype/anchor_lab.tscn") as PackedScene
	if packed_anchor:
		var anchor_inst := packed_anchor.instantiate() as AnchorLab
		root.add_child(anchor_inst)
		await process_frame

		var chamber_captures := [
			{"file": "anchor_lab.png", "chamber": 0, "player_pos": Vector2(60.0, 296.0), "reality": AnchorableObject.RealityState.STATE_A, "anchor_bridge3": false, "lockdown": 0.0},
			{"file": "anchor_lab_ch2.png", "chamber": 1, "player_pos": Vector2(745.0, 296.0), "reality": AnchorableObject.RealityState.STATE_A, "anchor_bridge3": false, "lockdown": 0.0},
			{"file": "anchor_lab_ch3.png", "chamber": 2, "player_pos": Vector2(1340.0, 176.0), "reality": AnchorableObject.RealityState.STATE_A, "anchor_bridge3": false, "lockdown": 0.0},
			{"file": "anchor_lab_ch3_solved.png", "chamber": 2, "player_pos": Vector2(1805.0, 176.0), "reality": AnchorableObject.RealityState.STATE_B, "anchor_bridge3": true, "lockdown": 0.0},
			{"file": "anchor_lab_ch3_locked.png", "chamber": 2, "player_pos": Vector2(1850.0, 176.0), "reality": AnchorableObject.RealityState.STATE_B, "anchor_bridge3": true, "lockdown": 0.65},
		]

		for item in chamber_captures:
			var ch_idx: int = item["chamber"]
			var filename: String = item["file"]
			var p_pos: Vector2 = item["player_pos"]
			var reality: AnchorableObject.RealityState = item["reality"]
			var anchor_b3: bool = item["anchor_bridge3"]
			var lockdown: float = item.get("lockdown", 0.0)

			anchor_inst._respawn()
			if anchor_inst.player:
				anchor_inst.player.reset_to(p_pos)
			if anchor_inst.camera:
				anchor_inst.camera.set_chamber(ch_idx, true)

			var b3 := anchor_inst.anchorables.get_node_or_null("Chamber3Bridge") as AnchorableObject
			var g3 := anchor_inst.anchorables.get_node_or_null("Chamber3Gate") as AnchorableObject

			if anchor_b3 and b3 != null and g3 != null:
				anchor_inst.set_active_anchor(b3)
				anchor_inst.current_reality = reality
				g3.apply_reality_shift(reality, false)
				b3.apply_reality_shift(reality, false)
			elif reality != AnchorableObject.RealityState.STATE_A:
				anchor_inst.trigger_correction_pulse()

			if lockdown > 0.0:
				anchor_inst._goal_reached = true
				anchor_inst._airlock_lockdown_progress = lockdown
				anchor_inst.queue_redraw()

			for frame in range(8):
				await process_frame
			await RenderingServer.frame_post_draw

			var img := root.get_texture().get_image()
			if img:
				var path := output_dir.path_join(filename)
				img.save_png(path)
				print("CAPTURE PASS: " + path)

		anchor_inst.queue_free()
		await process_frame

	quit(0)
