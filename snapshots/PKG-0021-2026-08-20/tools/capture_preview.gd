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

	# 3. Station 01 (Vertical Slice - Scene 01) captures
	var packed_station := load("res://scenes/levels/station_01.tscn") as PackedScene
	if packed_station:
		# Capture A: Initial state at desk
		var station_inst := packed_station.instantiate() as Station01
		root.add_child(station_inst)
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img1 := root.get_texture().get_image()
		if img1:
			var path1 := output_dir.path_join("station_01.png")
			img1.save_png(path1)
			print("CAPTURE PASS: " + path1)

		station_inst.queue_free()
		await process_frame

		# Capture B: Active / unlocked procedure state
		var station_inst2 := packed_station.instantiate() as Station01
		root.add_child(station_inst2)
		await process_frame

		var p := station_inst2.get_node_or_null("Props")
		if p:
			var c1 := p.get_node_or_null("CircuitAlpha") as MemoryResonancePoint
			var c2 := p.get_node_or_null("CircuitBeta") as MemoryResonancePoint
			var c3 := p.get_node_or_null("CircuitGamma") as MemoryResonancePoint
			var vg := p.get_node_or_null("VacuumManometer") as MemoryResonancePoint
			var ph := p.get_node_or_null("PhotoDesk") as MemoryResonancePoint
			if c1: c1.is_activated = true
			if c2: c2.is_activated = true
			if c3: c3.is_activated = true
			if vg: vg.is_activated = true
			if ph: ph.is_activated = true
			station_inst2.circuit_alpha_on = true
			station_inst2.circuit_beta_on = true
			station_inst2.circuit_gamma_on = true
			station_inst2.vacuum_checked = true
			station_inst2.photo_inspected = true
			station_inst2.is_procedure_completed = true
			station_inst2._door_open_progress = 1.0
			if station_inst2.chamber_door:
				station_inst2.chamber_door.position.y -= 70.0
			if station_inst2.player:
				station_inst2.player.reset_to(Vector2(530.0, 296.0))
			station_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img2 := root.get_texture().get_image()
		if img2:
			var path2 := output_dir.path_join("station_01_active.png")
			img2.save_png(path2)
			print("CAPTURE PASS: " + path2)

		station_inst2.queue_free()
		await process_frame

	# 4. Station 02 (Vertical Slice - Scene 02 Korelacja) captures
	var packed_st2 := load("res://scenes/levels/station_02.tscn") as PackedScene
	if packed_st2:
		# Capture A: Initial state at console (Keyframe 1: Lena on left third, symmetrical chamber)
		var st2_inst := packed_st2.instantiate() as Station02
		root.add_child(st2_inst)
		if st2_inst.player:
			st2_inst.player.reset_to(Vector2(160.0, 296.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st2_1 := root.get_texture().get_image()
		if img_st2_1:
			var path_st2_1 := output_dir.path_join("station_02.png")
			img_st2_1.save_png(path_st2_1)
			print("CAPTURE PASS: " + path_st2_1)

		st2_inst.queue_free()
		await process_frame

		# Capture B: Active correlation anomaly (Keyframe 1: Twin lights correlated, threshold exceeded, discontinuous shadow, WYNIK ZGODNY)
		var st2_inst2 := packed_st2.instantiate() as Station02
		root.add_child(st2_inst2)
		await process_frame

		st2_inst2.procedure_state = Station02.ProcedureState.ANOMALY_ACTIVE
		st2_inst2.correlation_ratio = 1.42
		st2_inst2.target_correlation_ratio = 1.42
		st2_inst2.is_threshold_exceeded = true
		st2_inst2.is_anomaly_active = true
		st2_inst2.is_verdict_printed = true
		st2_inst2.paper_feed_progress = 1.0
		st2_inst2._light_1_intensity = 1.0
		st2_inst2._light_2_intensity = 1.0
		if st2_inst2.shadow_renderer:
			st2_inst2.shadow_renderer.is_secondary_light_active = true
			st2_inst2.shadow_renderer.is_anomaly_active = true
		if st2_inst2.player:
			st2_inst2.player.reset_to(Vector2(213.3, 296.0)) # Exact left third (640 / 3 = 213.3) per VISUAL_DESIGN.md Keyframe 1

		st2_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st2_2 := root.get_texture().get_image()
		if img_st2_2:
			var path_st2_2 := output_dir.path_join("station_02_correlation.png")
			img_st2_2.save_png(path_st2_2)
			print("CAPTURE PASS: " + path_st2_2)

		st2_inst2.queue_free()
		await process_frame

	# 5. Station 03 (Vertical Slice - Scene 03 Puste laboratorium) captures
	var packed_st3 := load("res://scenes/levels/station_03.tscn") as PackedScene
	if packed_st3:
		# Capture A: Overview of deserted laboratory corridor with Lena returning
		var st3_inst := packed_st3.instantiate() as Station03
		root.add_child(st3_inst)
		if st3_inst.player:
			st3_inst.player.reset_to(Vector2(90.0, 296.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st3_1 := root.get_texture().get_image()
		if img_st3_1:
			var path_st3_1 := output_dir.path_join("station_03.png")
			img_st3_1.save_png(path_st3_1)
			print("CAPTURE PASS: " + path_st3_1)

		st3_inst.queue_free()
		await process_frame

		# Capture B: Active inspected clues (Twin cups, ringing phone with 14 calls from Marta, card reader "URLOP PRZERWANY")
		var st3_inst2 := packed_st3.instantiate() as Station03
		root.add_child(st3_inst2)
		await process_frame

		var p3 := st3_inst2.get_node_or_null("Props")
		if p3:
			var cups := p3.get_node_or_null("TwinCups") as MemoryResonancePoint
			var phone := p3.get_node_or_null("DeskPhone") as MemoryResonancePoint
			var roster := p3.get_node_or_null("DutyRoster") as MemoryResonancePoint
			var reader := p3.get_node_or_null("DoorCardReader") as MemoryResonancePoint
			if cups: cups.is_activated = true
			if phone: phone.is_activated = true
			if roster: roster.is_activated = true
			if reader: reader.is_activated = true
			st3_inst2.cups_inspected = true
			st3_inst2.phone_inspected = true
			st3_inst2.roster_inspected = true
			st3_inst2.card_reader_inspected = true
			st3_inst2.is_door_unlocked = true
			st3_inst2._door_open_progress = 1.0
			if st3_inst2.security_door:
				st3_inst2.security_door.position.y -= 70.0
			if st3_inst2.player:
				st3_inst2.player.reset_to(Vector2(210.0, 296.0)) # At operator desk between twin cups and phone
			st3_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st3_2 := root.get_texture().get_image()
		if img_st3_2:
			var path_st3_2 := output_dir.path_join("station_03_desk.png")
			img_st3_2.save_png(path_st3_2)
			print("CAPTURE PASS: " + path_st3_2)

		st3_inst2.queue_free()
		await process_frame

	quit(0)


