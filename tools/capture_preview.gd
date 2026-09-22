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

	var args := OS.get_cmdline_user_args()
	if args.has("--pkg0153"):
		await _capture_pkg_0153_subset(output_dir)
		quit(0)
		return
	if args.has("--pkg0164"):
		await _capture_pkg_0164_subset(output_dir)
		quit(0)
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

	# 4. Station 02 (Vertical Slice - Scene 02 Obejście serwisowe) captures
	var packed_st2 := load("res://scenes/levels/station_02.tscn") as PackedScene
	if packed_st2:
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

		var st2_inst2 := packed_st2.instantiate() as Station02
		root.add_child(st2_inst2)
		await process_frame

		st2_inst2.is_maintenance_inspected = true
		st2_inst2.is_subpanel_checked = true
		st2_inst2.is_door_unlocked = true
		st2_inst2._door_open_progress = 1.0
		if st2_inst2.chamber_door:
			st2_inst2.chamber_door.position.y -= 70.0
		if st2_inst2.player:
			st2_inst2.player.reset_to(Vector2(460.0, 296.0))
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

	# 5. Station 03 (Vertical Slice - Scene 03 Wiadomość Marty) captures
	var packed_st3 := load("res://scenes/levels/station_03.tscn") as PackedScene
	if packed_st3:
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

		var st3_inst2 := packed_st3.instantiate() as Station03
		root.add_child(st3_inst2)
		await process_frame

		var p3 := st3_inst2.get_node_or_null("Props")
		if p3:
			var board := p3.get_node_or_null("TransitBoard") as MemoryResonancePoint
			var msg := p3.get_node_or_null("PhoneMessage") as MemoryResonancePoint
			var bench := p3.get_node_or_null("ShelterBench") as MemoryResonancePoint
			if board: board.is_activated = true
			if msg: msg.is_activated = true
			if bench: bench.is_activated = true
			st3_inst2.is_transit_board_inspected = true
			st3_inst2.is_message_opened = true
			st3_inst2.is_response_sent = true
			st3_inst2.is_door_unlocked = true
			st3_inst2._door_open_progress = 1.0
			if st3_inst2.security_door:
				st3_inst2.security_door.position.y -= 70.0
			if st3_inst2.player:
				st3_inst2.player.reset_to(Vector2(300.0, 296.0))
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

	# 6. Station 04 (Vertical Slice - Scene 04 Przejazd wagonem) captures
	var packed_st4 := load("res://scenes/levels/station_04.tscn") as PackedScene
	if packed_st4:
		var st4_inst := packed_st4.instantiate() as Station04
		root.add_child(st4_inst)
		if st4_inst.player:
			st4_inst.player.reset_to(Vector2(90.0, 296.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st4_1 := root.get_texture().get_image()
		if img_st4_1:
			var path_st4_1 := output_dir.path_join("station_04.png")
			img_st4_1.save_png(path_st4_1)
			print("CAPTURE PASS: " + path_st4_1)

		st4_inst.queue_free()
		await process_frame

		var st4_inst2 := packed_st4.instantiate() as Station04
		root.add_child(st4_inst2)
		await process_frame

		if st4_inst2.player:
			st4_inst2.player.reset_to(Vector2(310.0, 296.0))

		st4_inst2.is_reader_restarted = true
		st4_inst2.is_card_secured = true
		st4_inst2.is_window_inspected = true
		st4_inst2.is_turnstile_unlocked = true
		if st4_inst2.turnstile_barrier:
			st4_inst2.turnstile_barrier.position.y -= 80.0
		st4_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st4_2 := root.get_texture().get_image()
		if img_st4_2:
			var path_st4_2 := output_dir.path_join("station_04_bramka.png")
			img_st4_2.save_png(path_st4_2)
			print("CAPTURE PASS: " + path_st4_2)

		st4_inst2.queue_free()
		await process_frame

	# 7. Station 05 (Vertical Slice - Scene 05 Znana ulica) captures
	var packed_st5 := load("res://scenes/levels/station_05.tscn") as PackedScene
	if packed_st5:
		var st5_inst := packed_st5.instantiate() as Station05
		root.add_child(st5_inst)
		if st5_inst.player:
			st5_inst.player.reset_to(Vector2(170.0, 296.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st5_1 := root.get_texture().get_image()
		if img_st5_1:
			var path_st5_1 := output_dir.path_join("station_05.png")
			img_st5_1.save_png(path_st5_1)
			print("CAPTURE PASS: " + path_st5_1)

		st5_inst.queue_free()
		await process_frame

		var st5_inst2 := packed_st5.instantiate() as Station05
		root.add_child(st5_inst2)
		await process_frame

		if st5_inst2.player:
			st5_inst2.player.reset_to(Vector2(330.0, 296.0))

		st5_inst2.is_ucp_notice_inspected = true
		st5_inst2.is_crosswalk_activated = true
		st5_inst2.is_street_corner_checked = true

		var p5 := st5_inst2.get_node_or_null("Props")
		if p5:
			var bb := p5.get_node_or_null("UCPNoticeBoard") as MemoryResonancePoint
			var cb := p5.get_node_or_null("CrosswalkSignal") as MemoryResonancePoint
			var sc := p5.get_node_or_null("StreetCorner") as MemoryResonancePoint
			if bb: bb.is_activated = true
			if cb: cb.is_activated = true
			if sc: sc.is_activated = true

		st5_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st5_2 := root.get_texture().get_image()
		if img_st5_2:
			var path_st5_2 := output_dir.path_join("station_05_crosswalk.png")
			img_st5_2.save_png(path_st5_2)
			print("CAPTURE PASS: " + path_st5_2)

		st5_inst2.queue_free()
		await process_frame

	# 8. Station 06 (Vertical Slice - Scene 06 Dwa rozkłady) captures
	var packed_st6 := load("res://scenes/levels/station_06.tscn") as PackedScene
	if packed_st6:
		var st6_inst := packed_st6.instantiate() as Station06
		root.add_child(st6_inst)
		if st6_inst.player:
			st6_inst.player.reset_to(Vector2(170.0, 296.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st6_1 := root.get_texture().get_image()
		if img_st6_1:
			var path_st6_1 := output_dir.path_join("station_06.png")
			img_st6_1.save_png(path_st6_1)
			print("CAPTURE PASS: " + path_st6_1)

		st6_inst.queue_free()
		await process_frame

		var st6_inst2 := packed_st6.instantiate() as Station06
		root.add_child(st6_inst2)
		await process_frame

		if st6_inst2.player:
			st6_inst2.player.reset_to(Vector2(460.0, 296.0))

		st6_inst2.is_paper_timetable_inspected = true
		st6_inst2.is_phone_app_inspected = true
		st6_inst2.is_bus_stop_checked = true
		st6_inst2.are_doors_open = true
		st6_inst2.door_open_progress = 1.0

		var p6 := st6_inst2.get_node_or_null("Props")
		if p6:
			var pt := p6.get_node_or_null("PaperTimetable") as MemoryResonancePoint
			var ps := p6.get_node_or_null("PhoneAppSchedule") as MemoryResonancePoint
			var bs := p6.get_node_or_null("BusArrivalStop") as MemoryResonancePoint
			if pt: pt.is_activated = true
			if ps: ps.is_activated = true
			if bs: bs.is_activated = true

		st6_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st6_2 := root.get_texture().get_image()
		if img_st6_2:
			var path_st6_2 := output_dir.path_join("station_06_arrival.png")
			img_st6_2.save_png(path_st6_2)
			print("CAPTURE PASS: " + path_st6_2)

		st6_inst2.queue_free()
		await process_frame

	# 9. Station 07 (Vertical Slice - Scene 07 Herbata dla Marty / Kiosk) captures
	var packed_st7 := load("res://scenes/levels/station_07.tscn") as PackedScene
	if packed_st7:
		var st7_inst := packed_st7.instantiate() as Station07
		root.add_child(st7_inst)
		if st7_inst.player:
			st7_inst.player.reset_to(Vector2(170.0, 296.0))
		st7_inst.shopkeeper_dialogue_active = true
		st7_inst.shopkeeper_dialogue_index = 0
		
		var p7 := st7_inst.get_node_or_null("Props")
		if p7:
			var sc := p7.get_node_or_null("ShopCounter") as MemoryResonancePoint
			var sl := p7.get_node_or_null("SalesLedger") as MemoryResonancePoint
			var wb := p7.get_node_or_null("WaterBottle") as MemoryResonancePoint
			if sc: sc.is_activated = true
			if sl: sl.is_activated = true
			if wb: wb.is_activated = true
		
		st7_inst.queue_redraw()
		
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st7_1 := root.get_texture().get_image()
		if img_st7_1:
			var path_st7_1 := output_dir.path_join("station_07.png")
			img_st7_1.save_png(path_st7_1)
			print("CAPTURE PASS: " + path_st7_1)

		st7_inst.queue_free()
		await process_frame

		var st7_inst2 := packed_st7.instantiate() as Station07
		root.add_child(st7_inst2)
		await process_frame

		if st7_inst2.player:
			st7_inst2.player.reset_to(Vector2(410.0, 296.0))

		st7_inst2.is_ledger_checked = true
		st7_inst2.is_shopkeeper_dialogue_completed = true
		st7_inst2.shopkeeper_dialogue_active = false
		st7_inst2.is_water_purchased = true
		st7_inst2.is_door_open = true

		st7_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st7_2 := root.get_texture().get_image()
		if img_st7_2:
			var path_st7_2 := output_dir.path_join("station_07_door.png")
			img_st7_2.save_png(path_st7_2)
			print("CAPTURE PASS: " + path_st7_2)

		st7_inst2.queue_free()
		await process_frame

	# 10. Station 08 (Kanon 0.3 — Numer czternaście) captures
	var packed_st8 := load("res://scenes/levels/station_08.tscn") as PackedScene
	if packed_st8:
		var st8_inst := packed_st8.instantiate() as Station08
		root.add_child(st8_inst)
		if st8_inst.player:
			st8_inst.player.reset_to(Vector2(280.0, 296.0))
		st8_inst.certificate_read = true
		st8_inst.directory_read = true
		st8_inst.queue_redraw()

		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st8_1 := root.get_texture().get_image()
		if img_st8_1:
			var path_st8_1 := output_dir.path_join("station_08.png")
			img_st8_1.save_png(path_st8_1)
			print("CAPTURE PASS: " + path_st8_1)

		st8_inst.queue_free()
		await process_frame

		var st8_inst2 := packed_st8.instantiate() as Station08
		root.add_child(st8_inst2)
		await process_frame
		if st8_inst2.player:
			st8_inst2.player.reset_to(Vector2(470.0, 296.0))
		st8_inst2.read_certificate()
		st8_inst2.read_directory()
		st8_inst2.use_keypad()
		st8_inst2.queue_redraw()

		for frame in range(40):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st8_2 := root.get_texture().get_image()
		if img_st8_2:
			var path_st8_2 := output_dir.path_join("station_08_open.png")
			img_st8_2.save_png(path_st8_2)
			print("CAPTURE PASS: " + path_st8_2)

		st8_inst2.queue_free()
		await process_frame

	# 11. Station 09 (Kanon 0.3 — Sąsiadka z trzeciego) captures
	var packed_st9 := load("res://scenes/levels/station_09.tscn") as PackedScene
	if packed_st9:
		var st9_inst := packed_st9.instantiate() as Station09
		root.add_child(st9_inst)
		if st9_inst.player:
			st9_inst.player.reset_to(Vector2(200.0, 296.0))
		st9_inst.queue_redraw()

		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st9_1 := root.get_texture().get_image()
		if img_st9_1:
			var path_st9_1 := output_dir.path_join("station_09.png")
			img_st9_1.save_png(path_st9_1)
			print("CAPTURE PASS: " + path_st9_1)

		st9_inst.queue_free()
		await process_frame

		var st9_inst2 := packed_st9.instantiate() as Station09
		root.add_child(st9_inst2)
		await process_frame
		if st9_inst2.player:
			st9_inst2.player.reset_to(Vector2(300.0, 296.0))
		st9_inst2.floor_plate_read = true
		st9_inst2.extinguisher_bracket_read = true
		st9_inst2.start_neighbour_dialogue()
		st9_inst2.advance_neighbour_dialogue()
		st9_inst2.advance_neighbour_dialogue()
		st9_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st9_2 := root.get_texture().get_image()
		if img_st9_2:
			var path_st9_2 := output_dir.path_join("station_09_neighbour.png")
			img_st9_2.save_png(path_st9_2)
			print("CAPTURE PASS: " + path_st9_2)

		st9_inst2.queue_free()
		await process_frame

	# 12. Station 10 (Kanon 0.3 — Klucz) captures
	var packed_st10 := load("res://scenes/levels/station_10.tscn") as PackedScene
	if packed_st10:
		var st10_inst := packed_st10.instantiate() as Station10
		root.add_child(st10_inst)
		if st10_inst.player:
			st10_inst.player.reset_to(Vector2(400.0, 296.0))
		st10_inst.number_plate_read = true
		st10_inst.queue_redraw()

		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st10_1 := root.get_texture().get_image()
		if img_st10_1:
			var path_st10_1 := output_dir.path_join("station_10.png")
			img_st10_1.save_png(path_st10_1)
			print("CAPTURE PASS: " + path_st10_1)

		st10_inst.queue_free()
		await process_frame

		var st10_inst2 := packed_st10.instantiate() as Station10
		root.add_child(st10_inst2)
		await process_frame
		if st10_inst2.player:
			st10_inst2.player.reset_to(Vector2(440.0, 296.0))
		st10_inst2.read_number_plate()
		st10_inst2.turn_key()
		st10_inst2.set_bag_down()
		st10_inst2.queue_redraw()

		for frame in range(40):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st10_2 := root.get_texture().get_image()
		if img_st10_2:
			var path_st10_2 := output_dir.path_join("station_10_threshold.png")
			img_st10_2.save_png(path_st10_2)
			print("CAPTURE PASS: " + path_st10_2)

		st10_inst2.queue_free()
		await process_frame

	# 13. Station 11 (Kanon 0.3 — Dwie osoby na zdjęciu) captures
	var packed_st11 := load("res://scenes/levels/station_11.tscn") as PackedScene
	if packed_st11:
		var st11_inst := packed_st11.instantiate() as Station11
		root.add_child(st11_inst)
		if st11_inst.player:
			st11_inst.player.reset_to(Vector2(150.0, 296.0))
		st11_inst.queue_redraw()

		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st11_1 := root.get_texture().get_image()
		if img_st11_1:
			var path_st11_1 := output_dir.path_join("station_11.png")
			img_st11_1.save_png(path_st11_1)
			print("CAPTURE PASS: " + path_st11_1)

		st11_inst.queue_free()
		await process_frame

		var st11_inst2 := packed_st11.instantiate() as Station11
		root.add_child(st11_inst2)
		await process_frame
		if st11_inst2.player:
			st11_inst2.player.reset_to(Vector2(232.0, 296.0))
		st11_inst2.examine_photograph()
		st11_inst2.boots_inspected = true
		st11_inst2.reader_dock_inspected = true
		st11_inst2.handwriting_inspected = true
		st11_inst2._check_evidence_complete()
		st11_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st11_2 := root.get_texture().get_image()
		if img_st11_2:
			var path_st11_2 := output_dir.path_join("station_11_photograph.png")
			img_st11_2.save_png(path_st11_2)
			print("CAPTURE PASS: " + path_st11_2)

		st11_inst2.queue_free()
		await process_frame

	# 14. Station 12 (Kanon 0.3 — Wiadomość głosowa) captures
	var packed_st12 := load("res://scenes/levels/station_12.tscn") as PackedScene
	if packed_st12:
		var st12_inst := packed_st12.instantiate() as Station12
		root.add_child(st12_inst)
		if st12_inst.player:
			st12_inst.player.reset_to(Vector2(500.0, 296.0))
		st12_inst.queue_redraw()

		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st12_1 := root.get_texture().get_image()
		if img_st12_1:
			var path_st12_1 := output_dir.path_join("station_12.png")
			img_st12_1.save_png(path_st12_1)
			print("CAPTURE PASS: " + path_st12_1)

		st12_inst.queue_free()
		await process_frame

		var st12_inst2 := packed_st12.instantiate() as Station12
		root.add_child(st12_inst2)
		await process_frame
		if st12_inst2.player:
			st12_inst2.player.reset_to(Vector2(250.0, 296.0))
		st12_inst2.close_balcony()
		st12_inst2.play_message()
		st12_inst2.advance_message()
		st12_inst2.number_checked = true
		st12_inst2.queue_redraw()

		for frame in range(40):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st12_2 := root.get_texture().get_image()
		if img_st12_2:
			var path_st12_2 := output_dir.path_join("station_12_message.png")
			img_st12_2.save_png(path_st12_2)
			print("CAPTURE PASS: " + path_st12_2)

		st12_inst2.queue_free()
		await process_frame

	# 15. Station 13 (Kanon 0.3 — Dwie ważne wersje) captures
	var packed_st13 := load("res://scenes/levels/station_13.tscn") as PackedScene
	if packed_st13:
		var st13_inst := packed_st13.instantiate() as Station13
		root.add_child(st13_inst)
		if st13_inst.player:
			st13_inst.player.reset_to(Vector2(180.0, 296.0))
		st13_inst.certificate_compared = true
		st13_inst.queue_redraw()

		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st13_1 := root.get_texture().get_image()
		if img_st13_1:
			var path_st13_1 := output_dir.path_join("station_13.png")
			img_st13_1.save_png(path_st13_1)
			print("CAPTURE PASS: " + path_st13_1)

		st13_inst.queue_free()
		await process_frame

		var st13_inst2 := packed_st13.instantiate() as Station13
		root.add_child(st13_inst2)
		await process_frame
		if st13_inst2.player:
			st13_inst2.player.reset_to(Vector2(300.0, 296.0))
		st13_inst2.compare_certificate()
		st13_inst2.toggle_drawer()
		st13_inst2.compare_contract()
		st13_inst2.verify_seals()
		st13_inst2.check_reader_log()
		st13_inst2.queue_redraw()

		for frame in range(40):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st13_2 := root.get_texture().get_image()
		if img_st13_2:
			var path_st13_2 := output_dir.path_join("station_13_documents.png")
			img_st13_2.save_png(path_st13_2)
			print("CAPTURE PASS: " + path_st13_2)

		st13_inst2.queue_free()
		await process_frame


	# 16. Station 14 (Canon 0.3 - Scene 14: Próg Marty) captures
	var packed_st14 := load("res://scenes/levels/station_14.tscn") as PackedScene
	if packed_st14:
		var st14_inst := packed_st14.instantiate() as Station14
		root.add_child(st14_inst)
		await process_frame
		if st14_inst.player:
			st14_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st14_1 := root.get_texture().get_image()
		if img_st14_1:
			var path_st14_1 := output_dir.path_join("station_14.png")
			img_st14_1.save_png(path_st14_1)
			print("CAPTURE PASS: " + path_st14_1)
		st14_inst.queue_free()
		await process_frame

		var st14_inst2 := packed_st14.instantiate() as Station14
		root.add_child(st14_inst2)
		await process_frame
		if st14_inst2.player:
			st14_inst2.player.reset_to(Vector2(200.0, 240.0))
		st14_inst2.place_bag_at_door()
		st14_inst2.inspect_kettle()
		st14_inst2.start_marta_dialogue()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st14_2 := root.get_texture().get_image()
		if img_st14_2:
			var path_st14_2 := output_dir.path_join("station_14_marta.png")
			img_st14_2.save_png(path_st14_2)
			print("CAPTURE PASS: " + path_st14_2)
		st14_inst2.queue_free()
		await process_frame

	# 17. Station 15 (Canon 0.3 - Scene 15: Rozbieżność w pamięci) captures
	var packed_st15 := load("res://scenes/levels/station_15.tscn") as PackedScene
	if packed_st15:
		var st15_inst := packed_st15.instantiate() as Station15
		root.add_child(st15_inst)
		await process_frame
		if st15_inst.player:
			st15_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st15_1 := root.get_texture().get_image()
		if img_st15_1:
			var path_st15_1 := output_dir.path_join("station_15.png")
			img_st15_1.save_png(path_st15_1)
			print("CAPTURE PASS: " + path_st15_1)
		st15_inst.queue_free()
		await process_frame

		var st15_inst2 := packed_st15.instantiate() as Station15
		root.add_child(st15_inst2)
		await process_frame
		if st15_inst2.player:
			st15_inst2.player.reset_to(Vector2(320.0, 240.0))
		st15_inst2.observe_signal_log()
		st15_inst2.send_control_impulse()
		st15_inst2.run_response_cycle()
		st15_inst2.send_control_impulse()
		st15_inst2.run_response_cycle()
		st15_inst2.send_corrective_impulse()
		st15_inst2.run_response_cycle()
		st15_inst2.read_abort_note()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st15_2 := root.get_texture().get_image()
		if img_st15_2:
			var path_st15_2 := output_dir.path_join("station_15_divergence.png")
			img_st15_2.save_png(path_st15_2)
			print("CAPTURE PASS: " + path_st15_2)
		st15_inst2.queue_free()
		await process_frame

	# 18. Station 16 (Canon 0.3 - Scene 16: Urząd UCP-4) captures
	var packed_st16 := load("res://scenes/levels/station_16.tscn") as PackedScene
	if packed_st16:
		var st16_inst := packed_st16.instantiate() as Station16
		root.add_child(st16_inst)
		await process_frame
		if st16_inst.player:
			st16_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st16_1 := root.get_texture().get_image()
		if img_st16_1:
			var path_st16_1 := output_dir.path_join("station_16.png")
			img_st16_1.save_png(path_st16_1)
			print("CAPTURE PASS: " + path_st16_1)
		st16_inst.queue_free()
		await process_frame

		var st16_inst2 := packed_st16.instantiate() as Station16
		root.add_child(st16_inst2)
		await process_frame
		if st16_inst2.player:
			st16_inst2.player.reset_to(Vector2(280.0, 240.0))
		var gsm_st16 := root.get_node_or_null("GameStateManager")
		if gsm_st16 != null:
			gsm_st16.record_decision(&"p7.work_history_and_record.own_record_requested", true)
		st16_inst2.transfer_response_to_safe_analyzer()
		st16_inst2.choose_sample_second_cost()
		st16_inst2.confirm_home_echo()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st16_2 := root.get_texture().get_image()
		if img_st16_2:
			var path_st16_2 := output_dir.path_join("station_16_biometrics.png")
			img_st16_2.save_png(path_st16_2)
			print("CAPTURE PASS: " + path_st16_2)
		st16_inst2.queue_free()
		await process_frame

	# 19. Station 17 (Canon 0.3 - Scene 17: Raport o zdarzeniu) captures
	var packed_st17 := load("res://scenes/levels/station_17.tscn") as PackedScene
	if packed_st17:
		var st17_inst := packed_st17.instantiate() as Station17
		root.add_child(st17_inst)
		await process_frame
		if st17_inst.player:
			st17_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st17_1 := root.get_texture().get_image()
		if img_st17_1:
			var path_st17_1 := output_dir.path_join("station_17.png")
			img_st17_1.save_png(path_st17_1)
			print("CAPTURE PASS: " + path_st17_1)
		st17_inst.queue_free()
		await process_frame

		var st17_inst2 := packed_st17.instantiate() as Station17
		root.add_child(st17_inst2)
		await process_frame
		if st17_inst2.player:
			st17_inst2.player.reset_to(Vector2(320.0, 240.0))
		var st17_state := root.get_node_or_null("/root/GameStateManager")
		if st17_state:
			st17_state.record_decision(&"p7.work_history_and_record.institution_trial_result", "small_cost_and_home_echo_confirmed")
			st17_state.record_decision(&"p9.mechanics.small_cost.home_echo_verified", true)
			st17_state.record_decision(&"mechanic_cost_observed", true)
		st17_inst2.read_cost_ledger()
		st17_inst2.reject_adaptation_offer()
		st17_inst2.record_jakub_consent_limited()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st17_2 := root.get_texture().get_image()
		if img_st17_2:
			var path_st17_2 := output_dir.path_join("station_17_incident.png")
			img_st17_2.save_png(path_st17_2)
			print("CAPTURE PASS: " + path_st17_2)
		st17_inst2.queue_free()
		await process_frame

	# 20. Station 18 (P9 BUNDLE-25 — trzy prognozy i method_committed) captures
	var packed_st18 := load("res://scenes/levels/station_18.tscn") as PackedScene
	if packed_st18:
		var st18_inst := packed_st18.instantiate() as Station18
		root.add_child(st18_inst)
		await process_frame
		if st18_inst.player:
			st18_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st18_1 := root.get_texture().get_image()
		if img_st18_1:
			var path_st18_1 := output_dir.path_join("station_18.png")
			img_st18_1.save_png(path_st18_1)
			print("CAPTURE PASS: " + path_st18_1)
		st18_inst.queue_free()
		await process_frame

		var st18_state := root.get_node_or_null("/root/GameStateManager")
		if st18_state:
			st18_state.record_decision(&"p7.work_history_and_record.trace", "cost_ledger_and_consent_scope_recorded")
			st18_state.record_decision(&"p9.consent_and_cost.cost_ledger_read", true)
			st18_state.record_decision(&"p9.consent_and_cost.adaptation_offer", "rejected")
			st18_state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "limited")
			st18_state.record_decision(&"jakub_consent_state", "limited")
		var st18_inst2 := packed_st18.instantiate() as Station18
		root.add_child(st18_inst2)
		await process_frame
		if st18_inst2.player:
			st18_inst2.player.reset_to(Vector2(320.0, 240.0))
		st18_inst2.compare_forecast_consent_dependencies()
		st18_inst2.disclose_marta_truth_partial()
		st18_inst2.commit_close_equal()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st18_2 := root.get_texture().get_image()
		if img_st18_2:
			var path_st18_2 := output_dir.path_join("station_18_archive.png")
			img_st18_2.save_png(path_st18_2)
			print("CAPTURE PASS: " + path_st18_2)
		st18_inst2.queue_free()
		await process_frame

	# 21. Station 19 (Canon 0.3 - Scene 19: Głos) captures
	var packed_st19 := load("res://scenes/levels/station_19.tscn") as PackedScene
	if packed_st19:
		var st19_inst := packed_st19.instantiate() as Station19
		root.add_child(st19_inst)
		await process_frame
		if st19_inst.player:
			st19_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st19_1 := root.get_texture().get_image()
		if img_st19_1:
			var path_st19_1 := output_dir.path_join("station_19.png")
			img_st19_1.save_png(path_st19_1)
			print("CAPTURE PASS: " + path_st19_1)
		st19_inst.queue_free()
		await process_frame

		var st19_inst2 := packed_st19.instantiate() as Station19
		root.add_child(st19_inst2)
		await process_frame
		if st19_inst2.player:
			st19_inst2.player.reset_to(Vector2(320.0, 240.0))
		st19_inst2.insert_coin()
		st19_inst2.dial_number()
		st19_inst2.answer_phone()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st19_2 := root.get_texture().get_image()
		if img_st19_2:
			var path_st19_2 := output_dir.path_join("station_19_phone.png")
			img_st19_2.save_png(path_st19_2)
			print("CAPTURE PASS: " + path_st19_2)
		st19_inst2.queue_free()
		await process_frame

	# 22. Station 20 (Canon 0.3 - Scene 20: Człowiek po tej dacie) captures
	var packed_st20 := load("res://scenes/levels/station_20.tscn") as PackedScene
	if packed_st20:
		var st20_inst := packed_st20.instantiate() as Station20
		root.add_child(st20_inst)
		await process_frame
		if st20_inst.player:
			st20_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st20_1 := root.get_texture().get_image()
		if img_st20_1:
			var path_st20_1 := output_dir.path_join("station_20.png")
			img_st20_1.save_png(path_st20_1)
			print("CAPTURE PASS: " + path_st20_1)
		st20_inst.queue_free()
		await process_frame

		var st20_inst2 := packed_st20.instantiate() as Station20
		root.add_child(st20_inst2)
		await process_frame
		if st20_inst2.player:
			st20_inst2.player.reset_to(Vector2(320.0, 240.0))
		st20_inst2.observe_scar()
		st20_inst2.dock_reader()
		st20_inst2.start_meeting_dialogue()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st20_2 := root.get_texture().get_image()
		if img_st20_2:
			var path_st20_2 := output_dir.path_join("station_20_jakub.png")
			img_st20_2.save_png(path_st20_2)
			print("CAPTURE PASS: " + path_st20_2)
		st20_inst2.queue_free()
		await process_frame

	# 23. Station 21 (Canon 0.3 - Scene 21: To nie jest mój świat) captures
	var packed_st21 := load("res://scenes/levels/station_21.tscn") as PackedScene
	if packed_st21:
		var st21_inst := packed_st21.instantiate() as Station21
		root.add_child(st21_inst)
		await process_frame
		if st21_inst.player:
			st21_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st21_1 := root.get_texture().get_image()
		if img_st21_1:
			var path_st21_1 := output_dir.path_join("station_21.png")
			img_st21_1.save_png(path_st21_1)
			print("CAPTURE PASS: " + path_st21_1)
		st21_inst.queue_free()
		await process_frame

		var st21_inst2 := packed_st21.instantiate() as Station21
		root.add_child(st21_inst2)
		await process_frame
		if st21_inst2.player:
			st21_inst2.player.reset_to(Vector2(320.0, 240.0))
		st21_inst2.place_sample_reader()
		st21_inst2.place_public_records()
		st21_inst2.place_relational_evidence()
		st21_inst2.synthesize_evidence()
		st21_inst2.start_recognition_dialogue()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st21_2 := root.get_texture().get_image()
		if img_st21_2:
			var path_st21_2 := output_dir.path_join("station_21_synthesis.png")
			img_st21_2.save_png(path_st21_2)
			print("CAPTURE PASS: " + path_st21_2)
		st21_inst2.queue_free()
		await process_frame

	# 24. Station 22 (Canon 0.3 - Scene 22: Dwie nazwy) captures
	var packed_st22 := load("res://scenes/levels/station_22.tscn") as PackedScene
	if packed_st22:
		var st22_inst := packed_st22.instantiate() as Station22
		root.add_child(st22_inst)
		await process_frame
		if st22_inst.player:
			st22_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st22_1 := root.get_texture().get_image()
		if img_st22_1:
			var path_st22_1 := output_dir.path_join("station_22.png")
			img_st22_1.save_png(path_st22_1)
			print("CAPTURE PASS: " + path_st22_1)
		st22_inst.queue_free()
		await process_frame

		var st22_inst2 := packed_st22.instantiate() as Station22
		root.add_child(st22_inst2)
		await process_frame
		if st22_inst2.player:
			st22_inst2.player.reset_to(Vector2(320.0, 240.0))
			var gsm22 := root.get_node_or_null("GameStateManager")
			if gsm22:
				gsm22.record_decision(&"world_recognized", true)
			st22_inst2.observe_signal_echo()
			st22_inst2.observe_adjacent_state()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st22_2 := root.get_texture().get_image()
		if img_st22_2:
			var path_st22_2 := output_dir.path_join("station_22_oscilloscope.png")
			img_st22_2.save_png(path_st22_2)
			print("CAPTURE PASS: " + path_st22_2)
		st22_inst2.queue_free()
		await process_frame

	# 25. Station 23 (Canon 0.3 - Scene 23: Martwy obwód) captures
	var packed_st23 := load("res://scenes/levels/station_23.tscn") as PackedScene
	if packed_st23:
		var st23_inst := packed_st23.instantiate() as Station23
		root.add_child(st23_inst)
		await process_frame
		if st23_inst.player:
			st23_inst.player.reset_to(Vector2(60.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st23_1 := root.get_texture().get_image()
		if img_st23_1:
			var path_st23_1 := output_dir.path_join("station_23.png")
			img_st23_1.save_png(path_st23_1)
			print("CAPTURE PASS: " + path_st23_1)
		st23_inst.queue_free()
		await process_frame

		var st23_inst2 := packed_st23.instantiate() as Station23
		root.add_child(st23_inst2)
		await process_frame
		if st23_inst2.player:
			st23_inst2.player.reset_to(Vector2(320.0, 240.0))
		st23_inst2.examine_circuit()
		st23_inst2.pull_shunt_switch()
		st23_inst2.observe_thermal_load()
		st23_inst2.start_circuit_dialogue()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw
		var img_st23_2 := root.get_texture().get_image()
		if img_st23_2:
			var path_st23_2 := output_dir.path_join("station_23_circuit.png")
			img_st23_2.save_png(path_st23_2)
			print("CAPTURE PASS: " + path_st23_2)
		st23_inst2.queue_free()
		await process_frame

	# 25. Station 24 (Vertical Slice - Scene 24 Marta pod obserwacją / Monitoring mieszkania 14 i wybór Leny) captures
	var packed_st24 := load("res://scenes/levels/station_24.tscn") as PackedScene
	if packed_st24:
		# Capture A: Default state of Signal Monitoring Chamber
		var st24_inst := packed_st24.instantiate() as Station24
		root.add_child(st24_inst)
		if st24_inst.player:
			st24_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st24_1 := root.get_texture().get_image()
		if img_st24_1:
			var path_st24_1 := output_dir.path_join("station_24.png")
			img_st24_1.save_png(path_st24_1)
			print("CAPTURE PASS: " + path_st24_1)

		st24_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 24 sequence — Lena at Transmission Terminal (x=370), Wierzbicka offer, CCTV live feed of Apt 14, stress gauge in red, unlocked transit airlock
		var st24_inst2 := packed_st24.instantiate() as Station24
		root.add_child(st24_inst2)
		await process_frame

		if st24_inst2.player:
			st24_inst2.player.reset_to(Vector2(370.0, 240.0)) # At Wierzbicka transmission terminal

		st24_inst2.is_cctv_inspected = true
		st24_inst2.is_gauge_inspected = true
		st24_inst2.is_terminal_inspected = true
		st24_inst2.is_stress_escalated = true
		st24_inst2._marta_stress_ratio = 0.95
		st24_inst2.is_scope_disclosed = true
		st24_inst2.is_risk_disclosed = true
		st24_inst2.is_cost_disclosed = true
		st24_inst2.choose_declined()

		var p24_2 := st24_inst2.get_node_or_null("Props")
		if p24_2:
			var cctv2 := p24_2.get_node_or_null("CCTVArray") as MemoryResonancePoint
			var gauge2 := p24_2.get_node_or_null("CorrectionGauge") as MemoryResonancePoint
			var term2 := p24_2.get_node_or_null("TransmissionTerminal") as MemoryResonancePoint
			var sel2 := p24_2.get_node_or_null("DispositionSelector") as MemoryResonancePoint
			var exit2 := p24_2.get_node_or_null("Station24Exit") as MemoryResonancePoint
			if cctv2: cctv2.is_activated = true
			if gauge2: gauge2.is_activated = true
			if term2: term2.is_activated = true
			if sel2: sel2.is_activated = true
			if exit2: exit2.is_activated = true

		st24_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st24_2 := root.get_texture().get_image()
		if img_st24_2:
			var path_st24_2 := output_dir.path_join("station_24_cctv.png")
			img_st24_2.save_png(path_st24_2)
			print("CAPTURE PASS: " + path_st24_2)

		st24_inst2.queue_free()
		await process_frame

	# 26. Station 25 (Vertical Slice - Scene 25 Wejście Jakuba / Tranzyt Linii 4 i dialog D-09) captures
	var packed_st25 := load("res://scenes/levels/station_25.tscn") as PackedScene
	if packed_st25:
		# Capture A: Default state of Line 4 Transit Concourse
		var st25_inst := packed_st25.instantiate() as Station25
		root.add_child(st25_inst)
		if st25_inst.player:
			st25_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st25_1 := root.get_texture().get_image()
		if img_st25_1:
			var path_st25_1 := output_dir.path_join("station_25.png")
			img_st25_1.save_png(path_st25_1)
			print("CAPTURE PASS: " + path_st25_1)

		st25_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 25 sequence — Lena confronting Jakub Wolski at x=380, Dialogue D-09 active, Jakub sitting, scar chart & gesture sensor active, transit airlock unlocked
		var st25_inst2 := packed_st25.instantiate() as Station25
		root.add_child(st25_inst2)
		await process_frame

		if st25_inst2.player:
			st25_inst2.player.reset_to(Vector2(320.0, 240.0)) # Facing Jakub at x=380

		st25_inst2.is_cart_inspected = true
		st25_inst2.is_chart_inspected = true
		st25_inst2.is_sensor_inspected = true
		st25_inst2.is_jakub_confronted = true
		st25_inst2.is_ventilation_observed = true
		st25_inst2.is_interlock_released = true
		st25_inst2.is_power_routed = true
		var gsm25 := root.get_node_or_null("GameStateManager")
		if gsm25:
			gsm25.record_decision(&"p7.mutual_test.marta_boundary", "limited_access")
		st25_inst2.retrieve_ucp_buffer()

		var p25_2 := st25_inst2.get_node_or_null("Props")
		if p25_2:
			var cart2 := p25_2.get_node_or_null("MaintenanceCart") as MemoryResonancePoint
			var chart2 := p25_2.get_node_or_null("ScarChart") as MemoryResonancePoint
			var jakub2 := p25_2.get_node_or_null("JakubOperator") as MemoryResonancePoint
			var sensor2 := p25_2.get_node_or_null("GestureSensor") as MemoryResonancePoint
			var exit2 := p25_2.get_node_or_null("Station25Exit") as MemoryResonancePoint
			if cart2: cart2.is_activated = true
			if chart2: chart2.is_activated = true
			if jakub2: jakub2.is_activated = true
			if sensor2: sensor2.is_activated = true
			if exit2: exit2.is_activated = true

		st25_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st25_2 := root.get_texture().get_image()
		if img_st25_2:
			var path_st25_2 := output_dir.path_join("station_25_jakub.png")
			img_st25_2.save_png(path_st25_2)
			print("CAPTURE PASS: " + path_st25_2)

		st25_inst2.queue_free()
		await process_frame

	# 27. Station 26 (Vertical Slice - Scene 26 Próba zamknięcia / Strefa łagodnej izolacji) captures
	var packed_st26 := load("res://scenes/levels/station_26.tscn") as PackedScene
	if packed_st26:
		# Capture A: Default state of Gentle Isolation Concourse
		var st26_inst := packed_st26.instantiate() as Station26
		root.add_child(st26_inst)
		if st26_inst.player:
			st26_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st26_1 := root.get_texture().get_image()
		if img_st26_1:
			var path_st26_1 := output_dir.path_join("station_26.png")
			img_st26_1.save_png(path_st26_1)
			print("CAPTURE PASS: " + path_st26_1)

		st26_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 26 sequence — Lena carving motivation anchor at x=470, Wierzbicka PA announcement active, dynamic designator in SEDATION mode, service airlock unlocked
		var st26_inst2 := packed_st26.instantiate() as Station26
		root.add_child(st26_inst2)
		await process_frame

		if st26_inst2.player:
			st26_inst2.player.reset_to(Vector2(440.0, 240.0)) # Facing Motivation Anchor at x=470

		st26_inst2.is_interrupted_ucp_log_observed = true
		st26_inst2.is_sample_clock_synchronized = true
		st26_inst2.is_ucp_command_clock_synchronized = true
		st26_inst2.is_local_generator_clock_synchronized = true
		st26_inst2.is_ucp_intervention_reconstructed = true
		st26_inst2.is_exit_unlocked = true
		st26_inst2._exit_open_progress = 1.0

		var p26_2 := st26_inst2.get_node_or_null("Props")
		if p26_2:
			var console2 := p26_2.get_node_or_null("IsolationConsole") as MemoryResonancePoint
			var desig2 := p26_2.get_node_or_null("RoomDesignator") as MemoryResonancePoint
			var spk2 := p26_2.get_node_or_null("PASpeaker") as MemoryResonancePoint
			var anc2 := p26_2.get_node_or_null("MotivationAnchor") as MemoryResonancePoint
			var exit2 := p26_2.get_node_or_null("Station26Exit") as MemoryResonancePoint
			if console2: console2.is_activated = true
			if desig2: desig2.is_activated = true
			if spk2: spk2.is_activated = true
			if anc2: anc2.is_activated = true
			if exit2: exit2.is_activated = true

		st26_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st26_2 := root.get_texture().get_image()
		if img_st26_2:
			var path_st26_2 := output_dir.path_join("station_26_isolation.png")
			img_st26_2.save_png(path_st26_2)
			print("CAPTURE PASS: " + path_st26_2)

		st26_inst2.queue_free()
		await process_frame

	# 28. Station 27 (Vertical Slice - Scene 27 Dług wdzięczności / Jakub otwiera wyjście serwisowe) captures
	var packed_st27 := load("res://scenes/levels/station_27.tscn") as PackedScene
	if packed_st27:
		# Capture A: Default state of Service Tunnel Junction
		var st27_inst := packed_st27.instantiate() as Station27
		root.add_child(st27_inst)
		if st27_inst.player:
			st27_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st27_1 := root.get_texture().get_image()
		if img_st27_1:
			var path_st27_1 := output_dir.path_join("station_27.png")
			img_st27_1.save_png(path_st27_1)
			print("CAPTURE PASS: " + path_st27_1)

		st27_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 27 sequence — Lena confronting Jakub Wolski at x=240, dialogue line 7 active, surface monitor in warning state, technical rollup gate unlatched
		var st27_inst2 := packed_st27.instantiate() as Station27
		root.add_child(st27_inst2)
		await process_frame

		if st27_inst2.player:
			st27_inst2.player.reset_to(Vector2(190.0, 240.0)) # Facing Jakub at x=240

		st27_inst2.is_pulse_reference_calibrated = true
		st27_inst2.is_first_identical_pulse_sent = true
		st27_inst2.is_second_identical_pulse_sent = true
		st27_inst2.is_deliberate_error_pulse_sent = true
		st27_inst2.is_response_correction_compared = true
		st27_inst2.is_exit_unlocked = true
		st27_inst2._exit_open_progress = 1.0

		var p27_2 := st27_inst2.get_node_or_null("Props")
		if p27_2:
			var badge2 := p27_2.get_node_or_null("WorkerBadge") as MemoryResonancePoint
			var jakub2 := p27_2.get_node_or_null("JakubOperator") as MemoryResonancePoint
			var mon2 := p27_2.get_node_or_null("SurfaceMonitor") as MemoryResonancePoint
			var con2 := p27_2.get_node_or_null("JunctionConsole") as MemoryResonancePoint
			var exit2 := p27_2.get_node_or_null("Station27Exit") as MemoryResonancePoint
			if badge2: badge2.is_activated = true
			if jakub2: jakub2.is_activated = true
			if mon2: mon2.is_activated = true
			if con2: con2.is_activated = true
			if exit2: exit2.is_activated = true

		st27_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st27_2 := root.get_texture().get_image()
		if img_st27_2:
			var path_st27_2 := output_dir.path_join("station_27_dialogue.png")
			img_st27_2.save_png(path_st27_2)
			print("CAPTURE PASS: " + path_st27_2)

		st27_inst2.queue_free()
		await process_frame

	# 29. Station 28 (Vertical Slice - Scene 28 Tramwaj bez pasażerów / Finał Aktu II: Korekta) captures
	var packed_st28 := load("res://scenes/levels/station_28.tscn") as PackedScene
	if packed_st28:
		# Capture A: Default state of Technical Tram Wagon
		var st28_inst := packed_st28.instantiate() as Station28
		root.add_child(st28_inst)
		if st28_inst.player:
			st28_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st28_1 := root.get_texture().get_image()
		if img_st28_1:
			var path_st28_1 := output_dir.path_join("station_28.png")
			img_st28_1.save_png(path_st28_1)
			print("CAPTURE PASS: " + path_st28_1)

		st28_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 28 sequence — Lena observing the Triple Paradox Viewport at x=360, dialogue line 9 active (Wierzbicka closing transmission), exit unlatched
		var st28_inst2 := packed_st28.instantiate() as Station28
		root.add_child(st28_inst2)
		await process_frame

		if st28_inst2.player:
			st28_inst2.player.reset_to(Vector2(360.0, 240.0))

		st28_inst2.is_transfer_constraint_observed = true
		st28_inst2.is_home_sample_trace_inspected = true
		st28_inst2.is_local_lena_signal_trace_inspected = true
		st28_inst2.is_transfer_price_disclosed = true
		st28_inst2.is_commitment_applied = true
		st28_inst2.is_exit_unlocked = true
		st28_inst2._exit_open_progress = 1.0

		var p28_2 := st28_inst2.get_node_or_null("Props")
		if p28_2:
			var con2 := p28_2.get_node_or_null("DriverConsole") as MemoryResonancePoint
			var win2 := p28_2.get_node_or_null("TransitWindow") as MemoryResonancePoint
			var par2 := p28_2.get_node_or_null("ParadoxViewport") as MemoryResonancePoint
			var ic2 := p28_2.get_node_or_null("ClosingIntercom") as MemoryResonancePoint
			var exit2 := p28_2.get_node_or_null("Station28Exit") as MemoryResonancePoint
			if con2: con2.is_activated = true
			if win2: win2.is_activated = true
			if par2: par2.is_activated = true
			if ic2: ic2.is_activated = true
			if exit2: exit2.is_activated = true

		st28_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st28_2 := root.get_texture().get_image()
		if img_st28_2:
			var path_st28_2 := output_dir.path_join("station_28_transit.png")
			img_st28_2.save_png(path_st28_2)
			print("CAPTURE PASS: " + path_st28_2)

		st28_inst2.queue_free()
		await process_frame

	# 30. Station 29 (Vertical Slice - Scene 29 Peron trzynasty / Otwarcie Aktu III: Podstruktura) captures
	var packed_st29 := load("res://scenes/levels/station_29.tscn") as PackedScene
	if packed_st29:
		# Capture A: Default state of Abandoned Platform 13
		var st29_inst := packed_st29.instantiate() as Station29
		root.add_child(st29_inst)
		if st29_inst.player:
			st29_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st29_1 := root.get_texture().get_image()
		if img_st29_1:
			var path_st29_1 := output_dir.path_join("station_29.png")
			img_st29_1.save_png(path_st29_1)
			print("CAPTURE PASS: " + path_st29_1)

		st29_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 29 sequence — Lena observing the Deep Substructure Well at x=360, Jakub illuminating the grate with his torch beacon, dialogue line 9 active, exit unlatched
		var st29_inst2 := packed_st29.instantiate() as Station29
		root.add_child(st29_inst2)
		await process_frame

		if st29_inst2.player:
			st29_inst2.player.reset_to(Vector2(360.0, 240.0))

		st29_inst2.is_ucp_jakub_contrast_inspected = true
		st29_inst2.is_jakub_ordinary_life_scope_observed = true
		st29_inst2.is_jakub_signal_risk_disclosed = true
		st29_inst2.is_jakub_transmitter_disabled = true
		st29_inst2.is_jakub_consent_recorded = true
		st29_inst2.jakub_consent_state = &"limited"
		st29_inst2.is_exit_unlocked = true
		st29_inst2._exit_open_progress = 1.0

		var p29_2 := st29_inst2.get_node_or_null("Props")
		if p29_2:
			var trk2 := p29_2.get_node_or_null("AbandonedTracks") as MemoryResonancePoint
			var neon2 := p29_2.get_node_or_null("FlickeringNeon") as MemoryResonancePoint
			var well2 := p29_2.get_node_or_null("SubstructureWell") as MemoryResonancePoint
			var bcn2 := p29_2.get_node_or_null("JakubBeacon") as MemoryResonancePoint
			var exit2 := p29_2.get_node_or_null("Station29Exit") as MemoryResonancePoint
			if trk2: trk2.is_activated = true
			if neon2: neon2.is_activated = true
			if well2: well2.is_activated = true
			if bcn2: bcn2.is_activated = true
			if exit2: exit2.is_activated = true

		st29_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st29_2 := root.get_texture().get_image()
		if img_st29_2:
			var path_st29_2 := output_dir.path_join("station_29_platform.png")
			img_st29_2.save_png(path_st29_2)
			print("CAPTURE PASS: " + path_st29_2)

		st29_inst2.queue_free()
		await process_frame

	# 31. Station 30 (Vertical Slice - Scene 30 Sektor Zasilania / Główna Rozdzielnia) captures
	var packed_st30 := load("res://scenes/levels/station_30.tscn") as PackedScene
	if packed_st30:
		# Capture A: Default state of Sektor Zasilania
		var st30_inst := packed_st30.instantiate() as Station30
		root.add_child(st30_inst)
		if st30_inst.player:
			st30_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st30_1 := root.get_texture().get_image()
		if img_st30_1:
			var path_st30_1 := output_dir.path_join("station_30.png")
			img_st30_1.save_png(path_st30_1)
			print("CAPTURE PASS: " + path_st30_1)

		st30_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 30 sequence — Lena throwing the section breaker at x=360, busbars glowing, grid schematic active, dialogue line 9 active, exit gate deionized
		var st30_inst2 := packed_st30.instantiate() as Station30
		root.add_child(st30_inst2)
		await process_frame

		if st30_inst2.player:
			st30_inst2.player.reset_to(Vector2(360.0, 240.0))

		st30_inst2.is_force_home_forecast_built = true
		st30_inst2.is_close_equal_recover_local_forecast_built = true
		st30_inst2.is_mutual_passage_forecast_built = true
		st30_inst2.are_forecast_consent_dependencies_compared = true
		st30_inst2.is_exit_unlocked = true
		st30_inst2._exit_open_progress = 1.0

		var p30_2 := st30_inst2.get_node_or_null("Props")
		if p30_2:
			var brd2 := p30_2.get_node_or_null("MainDistributionBoard") as MemoryResonancePoint
			var trn2 := p30_2.get_node_or_null("TransformerBank") as MemoryResonancePoint
			var brk2 := p30_2.get_node_or_null("SectionBreakerLever") as MemoryResonancePoint
			var sch2 := p30_2.get_node_or_null("GridSchematicDisplay") as MemoryResonancePoint
			var ext2 := p30_2.get_node_or_null("Station30Exit") as MemoryResonancePoint
			if brd2: brd2.is_activated = true
			if trn2: trn2.is_activated = true
			if brk2: brk2.is_activated = true
			if sch2: sch2.is_activated = true
			if ext2: ext2.is_activated = true

		st30_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st30_2 := root.get_texture().get_image()
		if img_st30_2:
			var path_st30_2 := output_dir.path_join("station_30_power.png")
			img_st30_2.save_png(path_st30_2)
			print("CAPTURE PASS: " + path_st30_2)

		st30_inst2.queue_free()
		await process_frame

	# 33. Station 31 (Vertical Slice - Scene 31 Magazyn Dowodów / Jedenaście Krzeseł) captures
	var packed_st31 := load("res://scenes/levels/station_31.tscn") as PackedScene
	if packed_st31:
		# Capture A: Overview of Evidence Archive, initial state with player at entrance
		var st31_inst := packed_st31.instantiate() as Station31
		root.add_child(st31_inst)
		if st31_inst.player:
			st31_inst.player.reset_to(Vector2(50.0, 240.0))
		for frame in range(6):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st31 := root.get_texture().get_image()
		if img_st31:
			var path_st31 := output_dir.path_join("station_31.png")
			img_st31.save_png(path_st31)
			print("CAPTURE PASS: " + path_st31)

		st31_inst.queue_free()
		await process_frame

		# Capture B: Active Scene 31 sequence — Lena examining the 12th chair and Wierzbicka reciting names, ledger active, dialogue line 4 active
		var st31_inst2 := packed_st31.instantiate() as Station31
		root.add_child(st31_inst2)
		await process_frame

		if st31_inst2.player:
			st31_inst2.player.reset_to(Vector2(350.0, 240.0))

		st31_inst2.is_chairs_inspected = true
		st31_inst2.is_holoterminal_inspected = true
		st31_inst2.is_twelfth_chair_inspected = true
		st31_inst2.is_ledger_inspected = true
		st31_inst2.dialogue_active = true
		st31_inst2.dialogue_index = 4 # Line 4: WIERZBICKA: »Janina Kowalczyk. Adam Sikora. Maria Zawadzka. Piotr Wójcik... Pamiętam wszystkich jedenaścioro.«
		st31_inst2.is_exit_unlocked = true
		st31_inst2._exit_open_progress = 1.0

		var p31_2 := st31_inst2.get_node_or_null("Props")
		if p31_2:
			var chr2 := p31_2.get_node_or_null("ElevenChairsRow") as MemoryResonancePoint
			var hol2 := p31_2.get_node_or_null("WierzbickaHoloterminal") as MemoryResonancePoint
			var twl2 := p31_2.get_node_or_null("JakubTwelfthChair") as MemoryResonancePoint
			var led2 := p31_2.get_node_or_null("VariantChoiceLedger") as MemoryResonancePoint
			var ext2 := p31_2.get_node_or_null("Station31Exit") as MemoryResonancePoint
			if chr2: chr2.is_activated = true
			if hol2: hol2.is_activated = true
			if twl2: twl2.is_activated = true
			if led2: led2.is_activated = true
			if ext2: ext2.is_activated = true

		st31_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st31_2 := root.get_texture().get_image()
		if img_st31_2:
			var path_st31_2 := output_dir.path_join("station_31_chairs.png")
			img_st31_2.save_png(path_st31_2)
			print("CAPTURE PASS: " + path_st31_2)

		st31_inst2.queue_free()
		await process_frame

	# ── 34. Space 32: Ślad w szkle / Korytarz Luster ───────────────────────
	var st32_scene := load("res://scenes/levels/station_32.tscn") as PackedScene
	if st32_scene:
		# 34a: Base scene capture
		var st32_inst := st32_scene.instantiate() as Node2D
		root.add_child(st32_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st32 := root.get_texture().get_image()
		if img_st32:
			var path_st32 := output_dir.path_join("station_32.png")
			img_st32.save_png(path_st32)
			print("CAPTURE PASS: " + path_st32)

		st32_inst.queue_free()
		await process_frame

		# 34b: Active dialogue / Trace etched capture at Condensation Trace Etcher
		var st32_inst2 := st32_scene.instantiate() as Station32
		root.add_child(st32_inst2)

		if st32_inst2.player:
			st32_inst2.player.reset_to(Vector2(345.0, 248.0)) # At trace etcher plate

		st32_inst2.is_steamed_pane_inspected = true
		st32_inst2.is_cracked_pane_inspected = true
		st32_inst2.is_trace_etched = true
		st32_inst2.is_polished_pane_inspected = true
		st32_inst2.dialogue_active = true
		st32_inst2.dialogue_index = 4 # Line 4: LENA: »Gdy dotykam zaparowanej powierzchni i przeciągam palcem, słyszę dźwięk tamtego poranka. Ślad pamięta to, co wymazano z dokumentów.«
		st32_inst2.is_exit_unlocked = true
		st32_inst2._exit_open_progress = 1.0

		var p32_2 := st32_inst2.get_node_or_null("Props")
		if p32_2:
			var stm2 := p32_2.get_node_or_null("SteamedGlassPaneA") as MemoryResonancePoint
			var crk2 := p32_2.get_node_or_null("CrackedGlassPaneB") as MemoryResonancePoint
			var trc2 := p32_2.get_node_or_null("CondensationTraceEtcher") as MemoryResonancePoint
			var pol2 := p32_2.get_node_or_null("PolishedGlassPaneC") as MemoryResonancePoint
			var ext2 := p32_2.get_node_or_null("Station32Exit") as MemoryResonancePoint
			if stm2: stm2.is_activated = true
			if crk2: crk2.is_activated = true
			if trc2: trc2.is_activated = true
			if pol2: pol2.is_activated = true
			if ext2: ext2.is_activated = true

		st32_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st32_2 := root.get_texture().get_image()
		if img_st32_2:
			var path_st32_2 := output_dir.path_join("station_32_glass.png")
			img_st32_2.save_png(path_st32_2)
			print("CAPTURE PASS: " + path_st32_2)

		st32_inst2.queue_free()
		await process_frame

	# ── 35. Space 33: Szyb Techniczny / Drabina do Maszynowni Głównej ───────
	var st33_scene := load("res://scenes/levels/station_33.tscn") as PackedScene
	if st33_scene:
		# 35a: Base scene capture
		var st33_inst := st33_scene.instantiate() as Node2D
		root.add_child(st33_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st33 := root.get_texture().get_image()
		if img_st33:
			var path_st33 := output_dir.path_join("station_33.png")
			img_st33.save_png(path_st33)
			print("CAPTURE PASS: " + path_st33)

		st33_inst.queue_free()
		await process_frame

		# 35b: Active dialogue / Descent capture at work light beacon & lower hatch
		var st33_inst2 := st33_scene.instantiate() as Station33
		root.add_child(st33_inst2)

		if st33_inst2.player:
			st33_inst2.player.reset_to(Vector2(455.0, 248.0)) # At work light / depth shaft

		st33_inst2.is_ladder_inspected = true
		st33_inst2.is_gauge_inspected = true
		st33_inst2.is_cable_trunk_inspected = true
		st33_inst2.is_work_light_inspected = true
		st33_inst2.dialogue_active = true
		st33_inst2.dialogue_index = 8 # Line 8: LENA: »Nie przyszłam tu, żeby wracać tą samą drogą, Jakub. Przyszłam, żeby zatrzymać ten mechanizm.«
		st33_inst2.is_exit_unlocked = true
		st33_inst2._exit_open_progress = 1.0

		var p33_2 := st33_inst2.get_node_or_null("Props")
		if p33_2:
			var lad2 := p33_2.get_node_or_null("VerticalLadderArray") as MemoryResonancePoint
			var gau2 := p33_2.get_node_or_null("DepthPressureGauge") as MemoryResonancePoint
			var cab2 := p33_2.get_node_or_null("MemoryBusCableTrunk") as MemoryResonancePoint
			var lig2 := p33_2.get_node_or_null("ShaftWorkLightBeacon") as MemoryResonancePoint
			var ext2 := p33_2.get_node_or_null("Station33Exit") as MemoryResonancePoint
			if lad2: lad2.is_activated = true
			if gau2: gau2.is_activated = true
			if cab2: cab2.is_activated = true
			if lig2: lig2.is_activated = true
			if ext2: ext2.is_activated = true

		st33_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st33_2 := root.get_texture().get_image()
		if img_st33_2:
			var path_st33_2 := output_dir.path_join("station_33_shaft.png")
			img_st33_2.save_png(path_st33_2)
			print("CAPTURE PASS: " + path_st33_2)

		st33_inst2.queue_free()
		await process_frame

	# ── 36. Space 34: Maszynownia Główna / Rdzeń Wymiany ────────────────────
	var st34_scene := load("res://scenes/levels/station_34.tscn") as PackedScene
	if st34_scene:
		# 36a: Base scene capture
		var st34_inst := st34_scene.instantiate() as Node2D
		root.add_child(st34_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st34 := root.get_texture().get_image()
		if img_st34:
			var path_st34 := output_dir.path_join("station_34.png")
			img_st34.save_png(path_st34)
			print("CAPTURE PASS: " + path_st34)

		st34_inst.queue_free()
		await process_frame

		# 36b: Active dialogue / Core reactor overload capture at thermal indicator & diagnostic probe
		var st34_inst2 := st34_scene.instantiate() as Station34
		root.add_child(st34_inst2)

		if st34_inst2.player:
			st34_inst2.player.reset_to(Vector2(445.0, 248.0)) # At Jakub's diagnostic probe

		st34_inst2.is_reactor_inspected = true
		st34_inst2.is_desk_inspected = true
		st34_inst2.is_thermal_inspected = true
		st34_inst2.is_probe_inspected = true
		st34_inst2.dialogue_active = true
		st34_inst2.dialogue_index = 8 # Line 8: JAKUB: »Zablokowanie alokacji wywoła dekompensację rdzenia. Następna komora to Sektor Filtracji...«
		st34_inst2.is_exit_unlocked = true
		st34_inst2._exit_open_progress = 1.0

		var p34_2 := st34_inst2.get_node_or_null("Props")
		if p34_2:
			var rct2 := p34_2.get_node_or_null("MainExchangeCoreReactor") as MemoryResonancePoint
			var dsk2 := p34_2.get_node_or_null("BiographyAllocationDesk") as MemoryResonancePoint
			var thm2 := p34_2.get_node_or_null("ThermalOverloadIndicator") as MemoryResonancePoint
			var prb2 := p34_2.get_node_or_null("JakubCoreDiagnosticPort") as MemoryResonancePoint
			var ext2 := p34_2.get_node_or_null("Station34Exit") as MemoryResonancePoint
			if rct2: rct2.is_activated = true
			if dsk2: dsk2.is_activated = true
			if thm2: thm2.is_activated = true
			if prb2: prb2.is_activated = true
			if ext2: ext2.is_activated = true

		st34_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st34_2 := root.get_texture().get_image()
		if img_st34_2:
			var path_st34_2 := output_dir.path_join("station_34_core.png")
			img_st34_2.save_png(path_st34_2)
			print("CAPTURE PASS: " + path_st34_2)

		st34_inst2.queue_free()
		await process_frame

	# ── 37. Space 35: Sektor Filtracji / Baseny Sedacyjne ───────────────────
	var st35_scene := load("res://scenes/levels/station_35.tscn") as PackedScene
	if st35_scene:
		# 37a: Base scene capture
		var st35_inst := st35_scene.instantiate() as Node2D
		root.add_child(st35_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st35 := root.get_texture().get_image()
		if img_st35:
			var path_st35 := output_dir.path_join("station_35.png")
			img_st35.save_png(path_st35)
			print("CAPTURE PASS: " + path_st35)

		st35_inst.queue_free()
		await process_frame

		# 37b: Active dialogue / Sedation drainage capture at monitor and unsealed drain sluice
		var st35_inst2 := st35_scene.instantiate() as Node2D
		root.add_child(st35_inst2)

		if st35_inst2.get("player"):
			st35_inst2.player.reset_to(Vector2(445.0, 248.0)) # At Jakub's sedation monitor

		st35_inst2.is_pool_inspected = true
		st35_inst2.is_valve_inspected = true
		st35_inst2.is_chemical_inspected = true
		st35_inst2.is_monitor_inspected = true
		st35_inst2.dialogue_active = true
		st35_inst2.dialogue_index = 8 # Line 8: JAKUB: »Odpływ prowadzi przez Zimny Ściek prosto do fundamentów Starej Pętli...«
		st35_inst2.is_exit_unlocked = true
		st35_inst2._exit_open_progress = 1.0

		var p35_2 := st35_inst2.get_node_or_null("Props")
		if p35_2:
			var pol2 := p35_2.get_node_or_null("SedationBasinPool") as MemoryResonancePoint
			var vlv2 := p35_2.get_node_or_null("SludgeDrainValveWheel") as MemoryResonancePoint
			var chm2 := p35_2.get_node_or_null("ChemicalSedationSampler") as MemoryResonancePoint
			var mnt2 := p35_2.get_node_or_null("JakubSedationMonitor") as MemoryResonancePoint
			var ext2 := p35_2.get_node_or_null("Station35Exit") as MemoryResonancePoint
			if pol2: pol2.is_activated = true
			if vlv2: vlv2.is_activated = true
			if chm2: chm2.is_activated = true
			if mnt2: mnt2.is_activated = true
			if ext2: ext2.is_activated = true

		st35_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st35_2 := root.get_texture().get_image()
		if img_st35_2:
			var path_st35_2 := output_dir.path_join("station_35_sedation.png")
			img_st35_2.save_png(path_st35_2)
			print("CAPTURE PASS: " + path_st35_2)

		st35_inst2.queue_free()
		await process_frame

	# ── 38. Space 36: Kanał Odpływowy / Zimny Ściek ─────────────────────────
	var st36_scene := load("res://scenes/levels/station_36.tscn") as PackedScene
	if st36_scene:
		# 38a: Base scene capture
		var st36_inst := st36_scene.instantiate() as Node2D
		root.add_child(st36_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st36 := root.get_texture().get_image()
		if img_st36:
			var path_st36 := output_dir.path_join("station_36.png")
			img_st36.save_png(path_st36)
			print("CAPTURE PASS: " + path_st36)

		st36_inst.queue_free()
		await process_frame

		# 38b: Active dialogue / Storm drain contamination capture at sampling tap & unsealed storm gate
		var st36_inst2 := st36_scene.instantiate() as Node2D
		root.add_child(st36_inst2)

		if st36_inst2.get("player"):
			st36_inst2.player.reset_to(Vector2(445.0, 248.0)) # At contamination sampling tap

		st36_inst2.is_weir_inspected = true
		st36_inst2.is_current_inspected = true
		st36_inst2.is_ladder_inspected = true
		st36_inst2.is_tap_inspected = true
		st36_inst2.dialogue_active = true
		st36_inst2.dialogue_index = 8 # Line 8: JAKUB: »Jeśli przejdziemy przez bramę przeciwsztormową, dotrzemy do Komory Sygnałowej...«
		st36_inst2.is_exit_unlocked = true
		st36_inst2._exit_open_progress = 1.0

		var p36_2 := st36_inst2.get_node_or_null("Props")
		if p36_2:
			var wer2 := p36_2.get_node_or_null("StormDrainWeir") as MemoryResonancePoint
			var cur2 := p36_2.get_node_or_null("SedativeSludgeCurrent") as MemoryResonancePoint
			var ldr2 := p36_2.get_node_or_null("AcidResistantCatwalkLadder") as MemoryResonancePoint
			var tap2 := p36_2.get_node_or_null("ContaminationSamplingTap") as MemoryResonancePoint
			var ext2 := p36_2.get_node_or_null("Station36Exit") as MemoryResonancePoint
			if wer2: wer2.is_activated = true
			if cur2: cur2.is_activated = true
			if ldr2: ldr2.is_activated = true
			if tap2: tap2.is_activated = true
			if ext2: ext2.is_activated = true

		st36_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st36_2 := root.get_texture().get_image()
		if img_st36_2:
			var path_st36_2 := output_dir.path_join("station_36_drain.png")
			img_st36_2.save_png(path_st36_2)
			print("CAPTURE PASS: " + path_st36_2)

		st36_inst2.queue_free()
		await process_frame

	# ── 39. Space 37: Komora Sygnałowa / Węzeł Nadawczy ─────────────────────
	var st37_scene := load("res://scenes/levels/station_37.tscn") as PackedScene
	if st37_scene:
		# 39a: Base scene capture
		var st37_inst := st37_scene.instantiate() as Node2D
		root.add_child(st37_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st37 := root.get_texture().get_image()
		if img_st37:
			var path_st37 := output_dir.path_join("station_37.png")
			img_st37.save_png(path_st37)
			print("CAPTURE PASS: " + path_st37)

		st37_inst.queue_free()
		await process_frame

		# 39b: Active dialogue / Signal broadcast injection capture at injection pulpit & unsealed gate
		var st37_inst2 := st37_scene.instantiate() as Node2D
		root.add_child(st37_inst2)

		if st37_inst2.get("player"):
			st37_inst2.player.reset_to(Vector2(445.0, 248.0)) # At memory injection pulpit

		st37_inst2.is_oscilloscope_inspected = true
		st37_inst2.is_patchbay_inspected = true
		st37_inst2.is_antenna_inspected = true
		st37_inst2.is_pulpit_inspected = true
		st37_inst2.dialogue_active = true
		st37_inst2.dialogue_index = 8 # Line 8: JAKUB: »Za śluzą transmisyjną zaczyna się rdzeń pamięci wypadku...«
		st37_inst2.is_exit_unlocked = true
		st37_inst2._exit_open_progress = 1.0

		var p37_2 := st37_inst2.get_node_or_null("Props")
		if p37_2:
			var crt2 := p37_2.get_node_or_null("FrequencyOscilloscopeCRT") as MemoryResonancePoint
			var ptc2 := p37_2.get_node_or_null("TransmissionCrossPatchbay") as MemoryResonancePoint
			var ant2 := p37_2.get_node_or_null("SignalTransmissionAntenna") as MemoryResonancePoint
			var pul2 := p37_2.get_node_or_null("MemoryInjectionPulpit") as MemoryResonancePoint
			var ext2 := p37_2.get_node_or_null("Station37Exit") as MemoryResonancePoint
			if crt2: crt2.is_activated = true
			if ptc2: ptc2.is_activated = true
			if ant2: ant2.is_activated = true
			if pul2: pul2.is_activated = true
			if ext2: ext2.is_activated = true

		st37_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st37_2 := root.get_texture().get_image()
		if img_st37_2:
			var path_st37_2 := output_dir.path_join("station_37_signal.png")
			img_st37_2.save_png(path_st37_2)
			print("CAPTURE PASS: " + path_st37_2)

		st37_inst2.queue_free()
		await process_frame

	# ── 40. Space 38: Sektor Pamięci Wypadku / Człowiek zamiast dowodu ─────
	var st38_scene := load("res://scenes/levels/station_38.tscn") as PackedScene
	if st38_scene:
		# 40a: Base scene capture
		var st38_inst := st38_scene.instantiate() as Node2D
		root.add_child(st38_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st38 := root.get_texture().get_image()
		if img_st38:
			var path_st38 := output_dir.path_join("station_38.png")
			img_st38.save_png(path_st38)
			print("CAPTURE PASS: " + path_st38)

		st38_inst.queue_free()
		await process_frame

		# 40b: Active dialogue / Relational tether rescue capture at brother's shadow & unsealed reference vault
		var st38_inst2 := st38_scene.instantiate() as Node2D
		root.add_child(st38_inst2)

		if st38_inst2.get("player"):
			st38_inst2.player.reset_to(Vector2(445.0, 248.0)) # At rescue tether anchor

		st38_inst2.is_calculator_inspected = true
		st38_inst2.is_accident_field_inspected = true
		st38_inst2.is_jakub_shadow_inspected = true
		st38_inst2.is_rescue_tether_anchored = true
		st38_inst2.dialogue_active = true
		st38_inst2.dialogue_index = 8 # Line 8: LENA: »Jesteś moim bratem, Jakub. Żywym człowiekiem z krwi i kości.«
		st38_inst2.is_exit_unlocked = true
		st38_inst2._exit_open_progress = 1.0

		var p38_2 := st38_inst2.get_node_or_null("Props")
		if p38_2:
			var clc2 := p38_2.get_node_or_null("ReturnCoordinateCalculator") as MemoryResonancePoint
			var fld2 := p38_2.get_node_or_null("AccidentSimulationField") as MemoryResonancePoint
			var jkb2 := p38_2.get_node_or_null("DestabilizingJakubShadow") as MemoryResonancePoint
			var rsc2 := p38_2.get_node_or_null("RescueTetherAnchor") as MemoryResonancePoint
			var ext2 := p38_2.get_node_or_null("Station38Exit") as MemoryResonancePoint
			if clc2: clc2.is_activated = true
			if fld2: fld2.is_activated = true
			if jkb2: jkb2.is_activated = true
			if rsc2: rsc2.is_activated = true
			if ext2: ext2.is_activated = true

		st38_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st38_2 := root.get_texture().get_image()
		if img_st38_2:
			var path_st38_2 := output_dir.path_join("station_38_rescue.png")
			img_st38_2.save_png(path_st38_2)
			print("CAPTURE PASS: " + path_st38_2)

		st38_inst2.queue_free()
		await process_frame

	# ── 41. Space 39: Komora Referencyjna / Finał Aktu III: Podstruktura ─────
	var st39_scene := load("res://scenes/levels/station_39.tscn") as PackedScene
	if st39_scene:
		# 41a: Base scene capture
		var st39_inst := st39_scene.instantiate() as Node2D
		root.add_child(st39_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st39 := root.get_texture().get_image()
		if img_st39:
			var path_st39 := output_dir.path_join("station_39.png")
			img_st39.save_png(path_st39)
			print("CAPTURE PASS: " + path_st39)

		st39_inst.queue_free()
		await process_frame

		# 41b: Active dialogue / Reference core triadic resonance at Ślad's control handover & unsealed Act IV gateway
		var st39_inst2 := st39_scene.instantiate() as Node2D
		root.add_child(st39_inst2)

		if st39_inst2.get("player"):
			st39_inst2.player.reset_to(Vector2(345.0, 248.0)) # At central reference core monolith

		st39_inst2.is_config_a_inspected = true
		st39_inst2.is_config_b_inspected = true
		st39_inst2.is_reference_core_inspected = true
		st39_inst2.is_config_c_inspected = true
		st39_inst2.dialogue_active = true
		st39_inst2.dialogue_index = 6 # Line 6: ŚLAD: »JEŚLI WYBIERZĘ JA... ZNOWU ZROBIĘ Z CIEBIE KOSZT.«
		st39_inst2.is_exit_unlocked = true
		st39_inst2._exit_open_progress = 1.0

		var p39_2 := st39_inst2.get_node_or_null("Props")
		if p39_2:
			var ca2 := p39_2.get_node_or_null("BranchConfigReturnA") as MemoryResonancePoint
			var cb2 := p39_2.get_node_or_null("BranchConfigReconciliationB") as MemoryResonancePoint
			var cr2 := p39_2.get_node_or_null("CentralReferenceCoreMonolith") as MemoryResonancePoint
			var cc2 := p39_2.get_node_or_null("BranchConfigTestimonyC") as MemoryResonancePoint
			var ext2 := p39_2.get_node_or_null("Station39Exit") as MemoryResonancePoint
			if ca2: ca2.is_activated = true
			if cb2: cb2.is_activated = true
			if cr2: cr2.is_activated = true
			if cc2: cc2.is_activated = true
			if ext2: ext2.is_activated = true

		st39_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st39_2 := root.get_texture().get_image()
		if img_st39_2:
			var path_st39_2 := output_dir.path_join("station_39_triad.png")
			img_st39_2.save_png(path_st39_2)
			print("CAPTURE PASS: " + path_st39_2)

		st39_inst2.queue_free()
		await process_frame

	# ── 42. Space 40: Sala Negocjacyjna / Otwarcie Aktu IV: Sygnał powrotu ─────
	var st40_scene := load("res://scenes/levels/station_40.tscn") as PackedScene
	if st40_scene:
		# 42a: Base scene capture
		var st40_inst := st40_scene.instantiate() as Node2D
		root.add_child(st40_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st40 := root.get_texture().get_image()
		if img_st40:
			var path_st40 := output_dir.path_join("station_40.png")
			img_st40.save_png(path_st40)
			print("CAPTURE PASS: " + path_st40)

		st40_inst.queue_free()
		await process_frame

		# 42b: Active negotiation dialogue D-14 at Dr Wierzbicka's terminal & unsealed operational choice portal
		var st40_inst2 := st40_scene.instantiate() as Node2D
		root.add_child(st40_inst2)

		if st40_inst2.get("player"):
			st40_inst2.player.reset_to(Vector2(245.0, 248.0)) # In center of negotiation deck between matrix and Marta

		st40_inst2.is_terminal_inspected = true
		st40_inst2.is_cost_matrix_inspected = true
		st40_inst2.is_marta_inspected = true
		st40_inst2.is_szymon_inspected = true
		st40_inst2.dialogue_active = true
		st40_inst2.dialogue_index = 11 # Line 11: LENA: »Nie szukamy już oryginału, doktor Wierzbicka. Szukamy odpowiedzialności.«
		st40_inst2.is_exit_unlocked = true
		st40_inst2._exit_open_progress = 1.0

		var p40_2 := st40_inst2.get_node_or_null("Props")
		if p40_2:
			var term2 := p40_2.get_node_or_null("WierzbickaPersonalTerminal") as MemoryResonancePoint
			var mat2 := p40_2.get_node_or_null("CostDossierMatrix") as MemoryResonancePoint
			var mrt2 := p40_2.get_node_or_null("MartaWitnessStation") as MemoryResonancePoint
			var szy2 := p40_2.get_node_or_null("SzymonTransmissionMonitor") as MemoryResonancePoint
			var ext2 := p40_2.get_node_or_null("Station40Exit") as MemoryResonancePoint
			if term2: term2.is_activated = true
			if mat2: mat2.is_activated = true
			if mrt2: mrt2.is_activated = true
			if szy2: szy2.is_activated = true
			if ext2: ext2.is_activated = true

		st40_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st40_2 := root.get_texture().get_image()
		if img_st40_2:
			var path_st40_2 := output_dir.path_join("station_40_proposal.png")
			img_st40_2.save_png(path_st40_2)
			print("CAPTURE PASS: " + path_st40_2)

		st40_inst2.queue_free()
		await process_frame

	# 43. Station 41 (Vertical Slice - Scene 41: Operational Choice) captures
	var st41_scene := load("res://scenes/levels/station_41.tscn") as PackedScene
	if st41_scene:
		# 43a: Base scene capture
		var st41_inst := st41_scene.instantiate() as Node2D
		root.add_child(st41_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st41 := root.get_texture().get_image()
		if img_st41:
			var path_st41 := output_dir.path_join("station_41.png")
			img_st41.save_png(path_st41)
			print("CAPTURE PASS: " + path_st41)

		st41_inst.queue_free()
		await process_frame

		# 43b: Active operational choice execution (Operation A selected, gate unsealed)
		var st41_inst2 := st41_scene.instantiate() as Node2D
		root.add_child(st41_inst2)

		if st41_inst2.get("player"):
			st41_inst2.player.reset_to(Vector2(220.0, 248.0)) # At Terminal A

		st41_inst2.is_topography_inspected = true
		st41_inst2.is_op_a_inspected = true
		st41_inst2.select_operation("A")
		st41_inst2.is_exit_unlocked = true
		st41_inst2._exit_open_progress = 1.0

		var p41_2 := st41_inst2.get_node_or_null("Props")
		if p41_2:
			var topo2 := p41_2.get_node_or_null("TopographyDisplay") as MemoryResonancePoint
			var opa2 := p41_2.get_node_or_null("ConsoleReturnA") as MemoryResonancePoint
			var ext2 := p41_2.get_node_or_null("Station41Exit") as MemoryResonancePoint
			if topo2: topo2.is_activated = true
			if opa2: opa2.is_activated = true
			if ext2: ext2.is_activated = true

		st41_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st41_2 := root.get_texture().get_image()
		if img_st41_2:
			var path_st41_2 := output_dir.path_join("station_41_execution.png")
			img_st41_2.save_png(path_st41_2)
			print("CAPTURE PASS: " + path_st41_2)

		st41_inst2.queue_free()
		await process_frame

	# 44. Station 42A (P9 PHASE-06 — forced return, dawn apartment)
	var st42a_scene := load("res://scenes/levels/station_42a.tscn") as PackedScene
	if st42a_scene:
		var st42a_inst := st42a_scene.instantiate() as Node2D
		root.add_child(st42a_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st42a := root.get_texture().get_image()
		if img_st42a:
			var path_st42a := output_dir.path_join("station_42a.png")
			img_st42a.save_png(path_st42a)
			print("CAPTURE PASS: " + path_st42a)

		st42a_inst.queue_free()
		await process_frame

	# 45. Station 42B (Vertical Slice - Scene 42B: Uzgodnienie — Miejsce po niej)
	var st42b_scene := load("res://scenes/levels/station_42b.tscn") as PackedScene
	if st42b_scene:
		var st42b_inst := st42b_scene.instantiate() as Node2D
		root.add_child(st42b_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st42b := root.get_texture().get_image()
		if img_st42b:
			var path_st42b := output_dir.path_join("station_42b.png")
			img_st42b.save_png(path_st42b)
			print("CAPTURE PASS: " + path_st42b)

		st42b_inst.queue_free()
		await process_frame

	# 46. Station 42C (Vertical Slice - Scene 42C: Świadectwo — Dwie prawdy)
	var st42c_scene := load("res://scenes/levels/station_42c.tscn") as PackedScene
	if st42c_scene:
		var st42c_inst := st42c_scene.instantiate() as Node2D
		root.add_child(st42c_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st42c := root.get_texture().get_image()
		if img_st42c:
			var path_st42c := output_dir.path_join("station_42c.png")
			img_st42c.save_png(path_st42c)
			print("CAPTURE PASS: " + path_st42c)

		st42c_inst.queue_free()
		await process_frame

	# 47. Station 43 (Vertical Slice - Scene 43: Napisy i epilog systemowy)
	var st43_scene := load("res://scenes/levels/station_43.tscn") as PackedScene
	if st43_scene:
		var st43_inst := st43_scene.instantiate() as Node2D
		root.add_child(st43_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st43 := root.get_texture().get_image()
		if img_st43:
			var path_st43 := output_dir.path_join("station_43.png")
			img_st43.save_png(path_st43)
			print("CAPTURE PASS: " + path_st43)

		st43_inst.queue_free()
		await process_frame

		var st43_release_inst := st43_scene.instantiate() as Station43
		root.add_child(st43_release_inst)
		await process_frame
		st43_release_inst.inspect_notice()
		st43_release_inst.inspect_credits()
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st43_release := root.get_texture().get_image()
		if img_st43_release:
			var path_st43_release := output_dir.path_join("station_43_release_surface.png")
			img_st43_release.save_png(path_st43_release)
			print("CAPTURE PASS: " + path_st43_release)

		st43_release_inst.queue_free()
		await process_frame

	# 48. Title screen runtime shell
	var title_scene := load("res://scenes/shell/title_screen.tscn") as PackedScene
	if title_scene:
		var title_inst := title_scene.instantiate() as Control
		root.add_child(title_inst)
		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_title := root.get_texture().get_image()
		if img_title:
			var path_title := output_dir.path_join("title_screen.png")
			img_title.save_png(path_title)
			print("CAPTURE PASS: " + path_title)

		title_inst.queue_free()
		await process_frame

	quit(0)

func _capture_pkg_0153_subset(output_dir: String) -> void:
	var pkg_dir := output_dir.path_join("pkg_0153")
	var dir_err := DirAccess.make_dir_recursive_absolute(pkg_dir)
	if dir_err != OK:
		push_error("CAPTURE: cannot create pkg_0153 output directory")
		quit(1)
		return

	var title_scene := load("res://scenes/shell/title_screen.tscn") as PackedScene
	if title_scene == null:
		push_error("CAPTURE: title_screen.tscn failed to load")
		quit(1)
		return
	var title_inst := title_scene.instantiate() as Control
	if title_inst == null:
		push_error("CAPTURE: title_screen.tscn failed to instantiate")
		quit(1)
		return
	root.add_child(title_inst)
	for _i in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	var title_img := root.get_texture().get_image()
	if title_img:
		var title_path := pkg_dir.path_join("title_screen_runtime_version.png")
		title_img.save_png(title_path)
		print("CAPTURE PASS: " + title_path)
	title_inst.queue_free()
	await process_frame

	var st43_scene := load("res://scenes/levels/station_43.tscn") as PackedScene
	if st43_scene == null:
		push_error("CAPTURE: station_43.tscn failed to load")
		quit(1)
		return

	var st43_initial := st43_scene.instantiate() as Station43
	if st43_initial == null:
		push_error("CAPTURE: station_43.tscn failed to instantiate")
		quit(1)
		return
	root.add_child(st43_initial)
	for _j in range(8):
		await process_frame
	await RenderingServer.frame_post_draw
	var initial_img := root.get_texture().get_image()
	if initial_img:
		var initial_path := pkg_dir.path_join("station_43_initial_runtime_surface.png")
		initial_img.save_png(initial_path)
		print("CAPTURE PASS: " + initial_path)
	st43_initial.queue_free()
	await process_frame

	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	var st43_release := st43_scene.instantiate() as Station43
	if st43_release == null:
		push_error("CAPTURE: station_43.tscn failed to instantiate release state")
		quit(1)
		return
	root.add_child(st43_release)
	await process_frame
	st43_release.inspect_notice()
	st43_release.inspect_credits()
	for _k in range(10):
		await process_frame
	await RenderingServer.frame_post_draw
	var release_img := root.get_texture().get_image()
	if release_img:
		var release_path := pkg_dir.path_join("station_43_release_surface.png")
		release_img.save_png(release_path)
		print("CAPTURE PASS: " + release_path)
	st43_release.queue_free()
	await process_frame


func _capture_pkg_0164_subset(output_dir: String) -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.set_pause_menu_visible(false)
		state.reset_campaign(true)
		state.record_decision(&"p7.work_history_and_record.own_record_requested", true)
	var packed := load("res://scenes/levels/station_16.tscn") as PackedScene
	if packed == null:
		push_error("CAPTURE: station_16.tscn failed to load")
		return
	var station := packed.instantiate() as Station16
	if station == null:
		push_error("CAPTURE: station_16.tscn failed to instantiate")
		return
	root.add_child(station)
	for _i in range(8):
		await process_frame
	station.transfer_response_to_safe_analyzer()
	station.choose_marta_memory_cost()
	station.confirm_home_echo()
	station.queue_redraw()
	for _j in range(12):
		await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.get_size() != Vector2i(640, 360):
		push_error("CAPTURE: Station 16 preview has wrong size")
	else:
		var path := output_dir.path_join("station_16_pkg0164_preview.png")
		if image.save_png(path) == OK:
			print("CAPTURE PASS: " + path)
		else:
			push_error("CAPTURE: cannot save " + path)
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()
	await process_frame





