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

	# 6. Station 04 (Vertical Slice - Scene 04 Bramka / Recepcja IKP) captures
	var packed_st4 := load("res://scenes/levels/station_04.tscn") as PackedScene
	if packed_st4:
		# Capture A: Overview of Reception Gate, initial state with lamp lit and guard seated
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

		# Capture B: Active dialogue D-01 at counter: "Jakub nie żyje", camera lamp extinguished, guard shielding lens, turnstile unlatched
		var st4_inst2 := packed_st4.instantiate() as Station04
		root.add_child(st4_inst2)
		await process_frame

		if st4_inst2.player:
			st4_inst2.player.reset_to(Vector2(200.0, 296.0)) # In front of reception counter

		st4_inst2.is_dialogue_active = true
		st4_inst2.dialogue_index = 5 # Lena: "Jakub nie żyje."
		st4_inst2.camera_lamp_lit = false
		st4_inst2.camera_lamp_alpha = 0.0
		st4_inst2.guard_blocks_camera = true
		st4_inst2.guard_shift_offset = 14.0
		st4_inst2.is_turnstile_unlocked = true
		st4_inst2.turnstile_rotation_progress = 1.0
		st4_inst2.ucp_notice_inspected = true
		st4_inst2.monitor_inspected = true
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

	# 7. Station 05 (Vertical Slice - Scene 05 Rówień nocą) captures
	var packed_st5 := load("res://scenes/levels/station_05.tscn") as PackedScene
	if packed_st5:
		# Capture A: Overview of Chamber 0 (Institute exit, street, billboard, missing floor building)
		var st5_inst := packed_st5.instantiate() as Station05
		root.add_child(st5_inst)
		if st5_inst.player:
			st5_inst.player.reset_to(Vector2(180.0, 296.0)) # Next to Anachronistic Billboard
		if st5_inst.camera:
			st5_inst.camera.set_chamber(0, true)
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

		# Capture B: Chamber 1 (Active Crosswalk Beacon, Tram Tracks & Transit Shelter)
		var st5_inst2 := packed_st5.instantiate() as Station05
		root.add_child(st5_inst2)
		await process_frame

		if st5_inst2.player:
			st5_inst2.player.reset_to(Vector2(730.0, 296.0)) # At Crosswalk Signal Beacon
		if st5_inst2.camera:
			st5_inst2.camera.set_chamber(1, true)

		st5_inst2.billboard_inspected = true
		st5_inst2.missing_floor_inspected = true
		st5_inst2.crosswalk_signal_triggered = true
		st5_inst2.crosswalk_lamp_green = true
		st5_inst2.schedule_inspected = true
		st5_inst2.restless_grid_shifted = true

		var p5 := st5_inst2.get_node_or_null("Props")
		if p5:
			var bb := p5.get_node_or_null("Billboard") as MemoryResonancePoint
			var mf := p5.get_node_or_null("MissingFloorMarker") as MemoryResonancePoint
			var cb := p5.get_node_or_null("CrosswalkBeacon") as MemoryResonancePoint
			var tt := p5.get_node_or_null("TransitTimetable") as MemoryResonancePoint
			if bb: bb.is_activated = true
			if mf: mf.is_activated = true
			if cb: cb.is_activated = true
			if tt: tt.is_activated = true

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

	# 8. Station 06 (Vertical Slice - Scene 06 Linia Zastępcza / Autobus Linii 4) captures
	var packed_st6 := load("res://scenes/levels/station_06.tscn") as PackedScene
	if packed_st6:
		# Capture A: Bus in transit with scrolling street & passenger
		var st6_inst := packed_st6.instantiate() as Station06
		root.add_child(st6_inst)
		if st6_inst.player:
			st6_inst.player.reset_to(Vector2(200.0, 296.0)) # Walking down aisle
		st6_inst.speaker_announcement_triggered = true
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

		# Capture B: Bus arrival at Osiedle Tarasowe (Open doors, inspected gold ring on seat, passenger dialogue completed)
		var st6_inst2 := packed_st6.instantiate() as Station06
		root.add_child(st6_inst2)
		await process_frame

		if st6_inst2.player:
			st6_inst2.player.reset_to(Vector2(450.0, 296.0)) # At Gold Ring seat

		st6_inst2.speaker_announcement_triggered = true
		st6_inst2.route_map_inspected = true
		st6_inst2.is_passenger_dialogue_completed = true
		st6_inst2.passenger_dialogue_active = false
		st6_inst2.is_finger_checked = true
		st6_inst2.is_ring_inspected = true
		st6_inst2.is_arriving = true
		st6_inst2.is_bus_stopped = true
		st6_inst2.is_bus_moving = false
		st6_inst2.bus_speed = 0.0
		st6_inst2.are_doors_open = true
		st6_inst2.door_open_progress = 1.0

		var p6 := st6_inst2.get_node_or_null("Props")
		if p6:
			var rm := p6.get_node_or_null("BusRouteMap") as MemoryResonancePoint
			var sp := p6.get_node_or_null("BusSpeaker") as MemoryResonancePoint
			var ep := p6.get_node_or_null("ElderlyPassenger") as MemoryResonancePoint
			var gr := p6.get_node_or_null("GoldRing") as MemoryResonancePoint
			if rm: rm.is_activated = true
			if sp: sp.is_activated = true
			if ep: ep.is_activated = true
			if gr: gr.is_activated = true

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

	# 9. Station 07 (Vertical Slice - Scene 07 „Wróciłaś” / Klatka schodowa na Osiedlu Tarasowym) captures
	var packed_st7 := load("res://scenes/levels/station_07.tscn") as PackedScene
	if packed_st7:
		# Capture A: Marta Kurek in doorway, initial conversation D-02
		var st7_inst := packed_st7.instantiate() as Station07
		root.add_child(st7_inst)
		if st7_inst.player:
			st7_inst.player.reset_to(Vector2(380.0, 296.0)) # Facing Marta at doorway
		st7_inst.tenant_directory_inspected = true
		st7_inst.mailboxes_inspected = true
		st7_inst.marta_dialogue_active = true
		st7_inst.marta_dialogue_index = 0
		
		var p7 := st7_inst.get_node_or_null("Props")
		if p7:
			var td := p7.get_node_or_null("TenantDirectory") as MemoryResonancePoint
			var mb := p7.get_node_or_null("Mailboxes") as MemoryResonancePoint
			var mp := p7.get_node_or_null("MartaInteraction") as MemoryResonancePoint
			if td: td.is_activated = true
			if mb: mb.is_activated = true
			if mp: mp.is_activated = true
		
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

		# Capture B: Completed dialogue D-02, wide open apartment doorway with warm light, entry into Apt 14
		var st7_inst2 := packed_st7.instantiate() as Station07
		root.add_child(st7_inst2)
		await process_frame

		if st7_inst2.player:
			st7_inst2.player.reset_to(Vector2(510.0, 296.0)) # At threshold of open apartment

		st7_inst2.tenant_directory_inspected = true
		st7_inst2.mailboxes_inspected = true
		st7_inst2.blind_stairs_inspected = true
		st7_inst2.stair_timer_inspected = true
		st7_inst2.is_marta_dialogue_completed = true
		st7_inst2.marta_dialogue_active = false
		st7_inst2.is_finger_gesture_done = true
		st7_inst2.is_door_open = true
		st7_inst2.door_open_progress = 1.0

		var p7_2 := st7_inst2.get_node_or_null("Props")
		if p7_2:
			var td2 := p7_2.get_node_or_null("TenantDirectory") as MemoryResonancePoint
			var mb2 := p7_2.get_node_or_null("Mailboxes") as MemoryResonancePoint
			var bs2 := p7_2.get_node_or_null("BlindStairs") as MemoryResonancePoint
			var ts2 := p7_2.get_node_or_null("StairTimerSwitch") as MemoryResonancePoint
			var mp2 := p7_2.get_node_or_null("MartaInteraction") as MemoryResonancePoint
			if td2: td2.is_activated = true
			if mb2: mb2.is_activated = true
			if bs2: bs2.is_activated = true
			if ts2: ts2.is_activated = true
			if mp2: mp2.is_activated = true

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

	# 10. Station 08 (Vertical Slice - Scene 08 „Mieszkanie po kimś” / Wnętrze mieszkania Marty i Leny) captures
	var packed_st8 := load("res://scenes/levels/station_08.tscn") as PackedScene
	if packed_st8:
		# Capture A: Marta and Lena in living area, initial conversation, steaming kettle, dual-purpose props
		var st8_inst := packed_st8.instantiate() as Station08
		root.add_child(st8_inst)
		if st8_inst.player:
			st8_inst.player.reset_to(Vector2(295.0, 296.0)) # Near table and beaker planter facing Marta
		st8_inst.coat_rack_inspected = true
		st8_inst.reflected_photo_inspected = true
		st8_inst.beaker_planter_inspected = true
		st8_inst.jakub_memento_inspected = true
		st8_inst.tea_kettle_inspected = true
		st8_inst.marta_dialogue_active = true
		st8_inst.marta_dialogue_index = 0
		
		var p8 := st8_inst.get_node_or_null("Props")
		if p8:
			var cr := p8.get_node_or_null("CoatRack") as MemoryResonancePoint
			var rp := p8.get_node_or_null("ReflectedPhoto") as MemoryResonancePoint
			var tk := p8.get_node_or_null("TeaKettle") as MemoryResonancePoint
			var bp := p8.get_node_or_null("BeakerPlanter") as MemoryResonancePoint
			var jm := p8.get_node_or_null("JakubMemento") as MemoryResonancePoint
			var mp := p8.get_node_or_null("MartaInteraction") as MemoryResonancePoint
			if cr: cr.is_activated = true
			if rp: rp.is_activated = true
			if tk: tk.is_activated = true
			if bp: bp.is_activated = true
			if jm: jm.is_activated = true
			if mp: mp.is_activated = true
		
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

		# Capture B: Unlocked cipher desk with open drawer, revealed Substructure blueprint, window with night rain
		var st8_inst2 := packed_st8.instantiate() as Station08
		root.add_child(st8_inst2)
		await process_frame

		if st8_inst2.player:
			st8_inst2.player.reset_to(Vector2(465.0, 296.0)) # At study desk

		st8_inst2.coat_rack_inspected = true
		st8_inst2.reflected_photo_inspected = true
		st8_inst2.beaker_planter_inspected = true
		st8_inst2.jakub_memento_inspected = true
		st8_inst2.tea_kettle_inspected = true
		st8_inst2.cipher_drawer_unlocked_state = true
		st8_inst2.is_marta_dialogue_completed = true
		st8_inst2.marta_dialogue_active = false

		var p8_2 := st8_inst2.get_node_or_null("Props")
		if p8_2:
			var cr2 := p8_2.get_node_or_null("CoatRack") as MemoryResonancePoint
			var rp2 := p8_2.get_node_or_null("ReflectedPhoto") as MemoryResonancePoint
			var tk2 := p8_2.get_node_or_null("TeaKettle") as MemoryResonancePoint
			var bp2 := p8_2.get_node_or_null("BeakerPlanter") as MemoryResonancePoint
			var jm2 := p8_2.get_node_or_null("JakubMemento") as MemoryResonancePoint
			var mp2 := p8_2.get_node_or_null("MartaInteraction") as MemoryResonancePoint
			var cd2 := p8_2.get_node_or_null("CipherDesk") as MemoryResonancePoint
			if cr2: cr2.is_activated = true
			if rp2: rp2.is_activated = true
			if tk2: tk2.is_activated = true
			if bp2: bp2.is_activated = true
			if jm2: jm2.is_activated = true
			if mp2: mp2.is_activated = true
			if cd2: cd2.is_activated = true

		st8_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st8_2 := root.get_texture().get_image()
		if img_st8_2:
			var path_st8_2 := output_dir.path_join("station_08_desk.png")
			img_st8_2.save_png(path_st8_2)
			print("CAPTURE PASS: " + path_st8_2)

		st8_inst2.queue_free()
		await process_frame

	# 10. Station 09 (Vertical Slice - Scene 09: Pokój, który nie czeka) captures
	var packed_st9 := load("res://scenes/levels/station_09.tscn") as PackedScene
	if packed_st9:
		# Capture A: Entrance state near washbasin & mirror (Space 09 default)
		var st9_inst := packed_st9.instantiate() as Station09
		root.add_child(st9_inst)
		if st9_inst.player:
			st9_inst.player.reset_to(Vector2(140.0, 296.0)) # Standing near washbasin and mirror
		
		var p9 := st9_inst.get_node_or_null("Props")
		if p9:
			var sink := p9.get_node_or_null("BathroomSink") as MemoryResonancePoint
			var mirror := p9.get_node_or_null("BathroomMirror") as MemoryResonancePoint
			var apoth := p9.get_node_or_null("ApothecaryCabinet") as MemoryResonancePoint
			if sink: sink.is_activated = true
			if mirror: mirror.is_activated = true
			if apoth: apoth.is_activated = true
		
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

		# Capture B: Oblique angle view with revealed inscription "NIE SZUKAJ ORYGINAŁU", active D-03 dialogue, stabilized corridor and unlatched doorway
		var st9_inst2 := packed_st9.instantiate() as Station09
		root.add_child(st9_inst2)
		await process_frame

		if st9_inst2.player:
			st9_inst2.player.reset_to(Vector2(240.0, 296.0)) # At oblique angle facing mirror

		st9_inst2.sink_inspected = true
		st9_inst2.mirror_inspected = true
		st9_inst2.apothecary_inspected = true
		st9_inst2.marta_guide_inspected = true
		st9_inst2.inscription_revealed = true
		st9_inst2.is_oblique_angle = true
		st9_inst2.is_looking_at_mirror = true
		st9_inst2.is_corridor_stabilized = true
		st9_inst2.is_door_unlocked = true
		st9_inst2._door_open_progress = 0.85
		st9_inst2.marta_dialogue_active = true
		st9_inst2.marta_dialogue_index = 0 # Marta's D-03 instruction: "Nie patrz na drzwi. Patrz na nie w lustrze."

		var p9_2 := st9_inst2.get_node_or_null("Props")
		if p9_2:
			var sink2 := p9_2.get_node_or_null("BathroomSink") as MemoryResonancePoint
			var mirror2 := p9_2.get_node_or_null("BathroomMirror") as MemoryResonancePoint
			var inscr2 := p9_2.get_node_or_null("ScratchedInscription") as MemoryResonancePoint
			var apoth2 := p9_2.get_node_or_null("ApothecaryCabinet") as MemoryResonancePoint
			var guide2 := p9_2.get_node_or_null("MartaBathroomGuide") as MemoryResonancePoint
			if sink2: sink2.is_activated = true
			if mirror2: mirror2.is_activated = true
			if inscr2: inscr2.is_activated = true
			if apoth2: apoth2.is_activated = true
			if guide2: guide2.is_activated = true

		st9_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st9_2 := root.get_texture().get_image()
		if img_st9_2:
			var path_st9_2 := output_dir.path_join("station_09_mirror.png")
			img_st9_2.save_png(path_st9_2)
			print("CAPTURE PASS: " + path_st9_2)

		st9_inst2.queue_free()
		await process_frame

	# 11. Station 10 (Vertical Slice - Scene 10: Telefon Jakuba) captures
	var packed_st10 := load("res://scenes/levels/station_10.tscn") as PackedScene
	if packed_st10:
		# Capture A: Default state (Study room with ringing Bakelite phone, desk lamp, topography board, tape deck)
		var st10_inst := packed_st10.instantiate() as Station10
		root.add_child(st10_inst)
		if st10_inst.player:
			st10_inst.player.reset_to(Vector2(160.0, 296.0)) # Standing in study near bookshelf
		
		var p10 := st10_inst.get_node_or_null("Props")
		if p10:
			var board := p10.get_node_or_null("TopographyBoard") as MemoryResonancePoint
			var lamp := p10.get_node_or_null("JakubDeskLamp") as MemoryResonancePoint
			if board: board.is_activated = true
			if lamp: lamp.is_activated = false # Lit
		
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

		# Capture B: Active phone dialogue D-04 with Jakub ("Podaj datę wypadku. — Którego?"), tape spinning & unlocked technical airlock
		var st10_inst2 := packed_st10.instantiate() as Station10
		root.add_child(st10_inst2)
		await process_frame

		if st10_inst2.player:
			st10_inst2.player.reset_to(Vector2(255.0, 296.0)) # Standing at phone desk

		st10_inst2.phone_inspected = true
		st10_inst2.is_phone_answered = true
		st10_inst2.is_phone_ringing = false
		st10_inst2.tape_inspected = true
		st10_inst2.is_tape_playing = true
		st10_inst2.board_inspected = true
		st10_inst2.lamp_inspected = true
		st10_inst2.is_airlock_unlocked = true
		st10_inst2._door_open_progress = 0.85
		st10_inst2.jakub_dialogue_active = true
		st10_inst2.jakub_dialogue_index = 4 # LENA: "Podaj datę wypadku."

		var p10_2 := st10_inst2.get_node_or_null("Props")
		if p10_2:
			var phone2 := p10_2.get_node_or_null("BakelitePhone") as MemoryResonancePoint
			var board2 := p10_2.get_node_or_null("TopographyBoard") as MemoryResonancePoint
			var lamp2 := p10_2.get_node_or_null("JakubDeskLamp") as MemoryResonancePoint
			var tape2 := p10_2.get_node_or_null("ReelTapeRecorder") as MemoryResonancePoint
			var airlock2 := p10_2.get_node_or_null("TechStorageAirlock") as MemoryResonancePoint
			if phone2: phone2.is_activated = true
			if board2: board2.is_activated = true
			if lamp2: lamp2.is_activated = false
			if tape2: tape2.is_activated = true
			if airlock2: airlock2.is_activated = true

		st10_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st10_2 := root.get_texture().get_image()
		if img_st10_2:
			var path_st10_2 := output_dir.path_join("station_10_phone.png")
			img_st10_2.save_png(path_st10_2)
			print("CAPTURE PASS: " + path_st10_2)

		st10_inst2.queue_free()
		await process_frame

	# 13. Station 11 (Vertical Slice - Scene 11 Pierwsza korekta) captures
	var packed_st11 := load("res://scenes/levels/station_11.tscn") as PackedScene
	if packed_st11:
		# Capture A: Overview from elevated gallery with observation window overlooking misty courtyard
		var st11_inst := packed_st11.instantiate() as Station11
		root.add_child(st11_inst)
		if st11_inst.player:
			st11_inst.player.reset_to(Vector2(70.0, 146.0))
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

		# Capture B: Active intervention, dialogue with Marta ("Zgłosiłam ją..."), smoothed masonry seam & open exit airlock
		var st11_inst2 := packed_st11.instantiate() as Station11
		root.add_child(st11_inst2)
		await process_frame

		if st11_inst2.player:
			st11_inst2.player.reset_to(Vector2(210.0, 146.0)) # Beside Marta at gallery railing

		st11_inst2.window_inspected = true
		st11_inst2.ucp_team_inspected = true
		st11_inst2.resident_inspected = true
		st11_inst2.doorway_inspected = true
		st11_inst2.marta_inspected = true
		st11_inst2.is_intervention_active = true
		st11_inst2.is_intervention_completed = true
		st11_inst2.is_masonry_smoothed = true
		st11_inst2._smoothing_progress = 1.0
		st11_inst2.is_airlock_unlocked = true
		st11_inst2._door_open_progress = 0.85
		st11_inst2.marta_dialogue_active = true
		st11_inst2.marta_dialogue_index = 5 # MARTA: "Zgłosiłam ją, bo bałam się, że skończy jak te drzwi."

		var p11_2 := st11_inst2.get_node_or_null("Props")
		if p11_2:
			var win2 := p11_2.get_node_or_null("ObservationWindow") as MemoryResonancePoint
			var marta2 := p11_2.get_node_or_null("MartaObservationDialogue") as MemoryResonancePoint
			var ucp2 := p11_2.get_node_or_null("UcpInterventionTeam") as MemoryResonancePoint
			var res2 := p11_2.get_node_or_null("ElderlyResidentGuide") as MemoryResonancePoint
			var door2 := p11_2.get_node_or_null("ErasedDoorwayTrace") as MemoryResonancePoint
			var airlock2 := p11_2.get_node_or_null("CourtyardExitAirlock") as MemoryResonancePoint
			if win2: win2.is_activated = true
			if marta2: marta2.is_activated = true
			if ucp2: ucp2.is_activated = true
			if res2: res2.is_activated = true
			if door2: door2.is_activated = true
			if airlock2: airlock2.is_activated = true

		st11_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st11_2 := root.get_texture().get_image()
		if img_st11_2:
			var path_st11_2 := output_dir.path_join("station_11_intervention.png")
			img_st11_2.save_png(path_st11_2)
			print("CAPTURE PASS: " + path_st11_2)

		st11_inst2.queue_free()
		await process_frame

	# 14. Station 12 (Vertical Slice - Scene 12 Pokaz bezpieczeństwa) captures
	var packed_st12 := load("res://scenes/levels/station_12.tscn") as PackedScene
	if packed_st12:
		# Capture A: Overview of subterranean underpass with subway tiles, overlapping stairs, UCP safety warden & child
		var st12_inst := packed_st12.instantiate() as Station12
		root.add_child(st12_inst)
		if st12_inst.player:
			st12_inst.player.reset_to(Vector2(60.0, 260.0))
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

		# Capture B: Active terminal readout (Level 3 clearance), stabilized stairs beam, child evacuated & open underpass exit gate
		var st12_inst2 := packed_st12.instantiate() as Station12
		root.add_child(st12_inst2)
		await process_frame

		if st12_inst2.player:
			st12_inst2.player.reset_to(Vector2(490.0, 260.0)) # At CRT workstation terminal

		st12_inst2.terminal_inspected = true
		st12_inst2.vitrine_inspected = true
		st12_inst2.poster_inspected = true
		st12_inst2.pillar_inspected = true
		st12_inst2.is_stabilization_active = true
		st12_inst2._stabilizer_beam_progress = 1.0
		st12_inst2.is_child_evacuated = true
		st12_inst2._child_pos_x = 140.0
		st12_inst2._child_pos_y = 275.0
		st12_inst2.is_safety_demonstrated = true
		st12_inst2.is_gate_unlocked = true
		st12_inst2._gate_open_progress = 0.85
		st12_inst2.dialogue_active = true
		st12_inst2.dialogue_index = 6 # TERMINAL: "[AUTORYZACJA POZIOMU 3: INŻ. LENA WOLSKA...]"

		var p12_2 := st12_inst2.get_node_or_null("Props")
		if p12_2:
			var term2 := p12_2.get_node_or_null("UcpInfoTerminal") as MemoryResonancePoint
			var vit2 := p12_2.get_node_or_null("ShowcaseVitrine") as MemoryResonancePoint
			var post2 := p12_2.get_node_or_null("InstructionPoster") as MemoryResonancePoint
			var pil2 := p12_2.get_node_or_null("SubwayTilePillar") as MemoryResonancePoint
			var gate2 := p12_2.get_node_or_null("UnderpassExitGate") as MemoryResonancePoint
			if term2: term2.is_activated = true
			if vit2: vit2.is_activated = true
			if post2: post2.is_activated = true
			if pil2: pil2.is_activated = true
			if gate2: gate2.is_activated = true

		st12_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st12_2 := root.get_texture().get_image()
		if img_st12_2:
			var path_st12_2 := output_dir.path_join("station_12_terminal.png")
			img_st12_2.save_png(path_st12_2)
			print("CAPTURE PASS: " + path_st12_2)

		st12_inst2.queue_free()
		await process_frame

	# 15. Station 13 (Vertical Slice - Scene 13: Adres ciągłości) captures
	var packed_st13 := load("res://scenes/levels/station_13.tscn") as PackedScene
	if packed_st13:
		# Capture A: Initial archive state with empty photo frame
		var st13_inst := packed_st13.instantiate() as Station13
		root.add_child(st13_inst)
		await process_frame

		if st13_inst.player:
			st13_inst.player.reset_to(Vector2(60.0, 260.0))
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

		# Capture B: Photo inserted, adult shadow emergence, circuit aligned & tech airlock unlocked
		var st13_inst2 := packed_st13.instantiate() as Station13
		root.add_child(st13_inst2)
		await process_frame

		if st13_inst2.player:
			st13_inst2.player.reset_to(Vector2(450.0, 260.0)) # At photograph mounting frame

		st13_inst2.drafting_table_inspected = true
		st13_inst2.cabinet_inspected = true
		st13_inst2.circuit_inspected = true
		st13_inst2.photo_frame_inspected = true
		st13_inst2.is_photo_inserted = true
		st13_inst2._shadow_progress = 0.95
		st13_inst2.is_shadow_developed = true
		st13_inst2.is_circuit_aligned = true
		st13_inst2._circuit_energy_progress = 1.0
		st13_inst2.is_airlock_unlocked = true
		st13_inst2._airlock_open_progress = 0.90
		st13_inst2.dialogue_active = true
		st13_inst2.dialogue_index = 7 # LENA: "Zrobiłam to. Otworzyłam przejście, ale fotografia..."

		var p13_2 := st13_inst2.get_node_or_null("Props")
		if p13_2:
			var draft2 := p13_2.get_node_or_null("DraftingTable") as MemoryResonancePoint
			var cab2 := p13_2.get_node_or_null("TopographyIndexCabinet") as MemoryResonancePoint
			var circ2 := p13_2.get_node_or_null("ResonanceCircuitNode") as MemoryResonancePoint
			var phot2 := p13_2.get_node_or_null("JakubPhotographFrame") as MemoryResonancePoint
			var air2 := p13_2.get_node_or_null("TechPassageAirlock") as MemoryResonancePoint
			if draft2: draft2.is_activated = true
			if cab2: cab2.is_activated = true
			if circ2: circ2.is_activated = true
			if phot2:
				phot2.is_activated = true
				phot2.shadow_progress = 0.95
			if air2: air2.is_activated = true

		st13_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st13_2 := root.get_texture().get_image()
		if img_st13_2:
			var path_st13_2 := output_dir.path_join("station_13_photo.png")
			img_st13_2.save_png(path_st13_2)
			print("CAPTURE PASS: " + path_st13_2)

		st13_inst2.queue_free()
		await process_frame

	# 16. Station 14 (Vertical Slice - Scene 14: Zakotwiczenie / Schowek techniczny) captures
	var packed_st14 := load("res://scenes/levels/station_14.tscn") as PackedScene
	if packed_st14:
		# Capture A: Initial state at maintenance rack with unanchored shifting seam
		var st14_inst := packed_st14.instantiate() as Station14
		root.add_child(st14_inst)
		await process_frame

		if st14_inst.player:
			st14_inst.player.reset_to(Vector2(60.0, 260.0))
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

		# Capture B: Scratch anchored (cyan locked edge), seam clamped, tape playing & substructure shaft open
		var st14_inst2 := packed_st14.instantiate() as Station14
		root.add_child(st14_inst2)
		await process_frame

		if st14_inst2.player:
			st14_inst2.player.reset_to(Vector2(260.0, 260.0)) # At scratch beam

		st14_inst2.rack_inspected = true
		st14_inst2.is_scratch_anchored = true
		st14_inst2._anchor_glow_progress = 1.0
		st14_inst2.is_seam_clamped = true
		st14_inst2.is_tape_playing = true
		st14_inst2._tape_progress = 0.85
		st14_inst2.is_silence_discovered = true
		st14_inst2.is_shaft_unlocked = true
		st14_inst2._shaft_open_progress = 0.95
		st14_inst2.dialogue_active = true
		st14_inst2.dialogue_index = 3 # ŚWIADECTWO PAMIĘCI: "Obserwujesz rysę w metalu. Krawędź rozbłyskuje chłodnym cyjanem..."

		var p14_2 := st14_inst2.get_node_or_null("Props")
		if p14_2:
			var rack2 := p14_2.get_node_or_null("MaintenanceRack") as MemoryResonancePoint
			var scr2 := p14_2.get_node_or_null("MetalScratchBeam") as MemoryResonancePoint
			var lev2 := p14_2.get_node_or_null("SeamStabilizerLever") as MemoryResonancePoint
			var tap2 := p14_2.get_node_or_null("TapePlaybackDeck") as MemoryResonancePoint
			var shf2 := p14_2.get_node_or_null("SubstructureConduitShaft") as MemoryResonancePoint
			if rack2: rack2.is_activated = true
			if scr2:
				scr2.is_activated = true
				scr2.shadow_progress = 1.0
			if lev2: lev2.is_activated = true
			if tap2: tap2.is_activated = true
			if shf2: shf2.is_activated = true

		st14_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st14_2 := root.get_texture().get_image()
		if img_st14_2:
			var path_st14_2 := output_dir.path_join("station_14_anchored.png")
			img_st14_2.save_png(path_st14_2)
			print("CAPTURE PASS: " + path_st14_2)

		st14_inst2.queue_free()
		await process_frame

	# 17. Station 15 (Vertical Slice - Scene 15: Korytarz serwisowy / Pismo lokalnej Leny i odwrócone odbicie) captures
	var packed_st15 := load("res://scenes/levels/station_15.tscn") as PackedScene
	if packed_st15:
		# Capture A: Initial state at entrance catwalk with overhead pipeline
		var st15_inst := packed_st15.instantiate() as Station15
		root.add_child(st15_inst)
		await process_frame

		if st15_inst.player:
			st15_inst.player.reset_to(Vector2(60.0, 260.0))
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

		# Capture B: Formula discovered, puddle reflection vector revealed, pressure valve released & transit gate unlocked
		var st15_inst2 := packed_st15.instantiate() as Station15
		root.add_child(st15_inst2)
		await process_frame

		if st15_inst2.player:
			st15_inst2.player.reset_to(Vector2(370.0, 260.0)) # At reflective puddle

		st15_inst2.is_hygiene_inspected = true
		st15_inst2.is_formula_discovered = true
		st15_inst2.is_reflection_revealed = true
		st15_inst2.is_pressure_released = true
		st15_inst2._pressure_vent_progress = 1.0
		st15_inst2.is_gate_unlocked = true
		st15_inst2._gate_open_progress = 0.95
		st15_inst2.dialogue_active = true
		st15_inst2.dialogue_index = 7 # ŚWIADECTWO PAMIĘCI: "W bezpośrednim świetle znak wskazuje fałszywy kierunek... Dopiero w odbiciu kałuży ujawnia się właściwy wektor..."

		var p15_2 := st15_inst2.get_node_or_null("Props")
		if p15_2:
			var board2 := p15_2.get_node_or_null("HygieneInstructionBoard") as MemoryResonancePoint
			var form2 := p15_2.get_node_or_null("HandwrittenCorrelationFormula") as MemoryResonancePoint
			var pud2 := p15_2.get_node_or_null("ReflectivePuddle") as MemoryResonancePoint
			var val2 := p15_2.get_node_or_null("PressureReliefValve") as MemoryResonancePoint
			var gat2 := p15_2.get_node_or_null("TransitServiceGate") as MemoryResonancePoint
			if board2: board2.is_activated = true
			if form2:
				form2.is_activated = true
				form2.shadow_progress = 1.0
			if pud2: pud2.is_activated = true
			if val2: val2.is_activated = true
			if gat2: gat2.is_activated = true

		st15_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st15_2 := root.get_texture().get_image()
		if img_st15_2:
			var path_st15_2 := output_dir.path_join("station_15_reflection.png")
			img_st15_2.save_png(path_st15_2)
			print("CAPTURE PASS: " + path_st15_2)

		st15_inst2.queue_free()
		await process_frame

	# 18. Station 16 (Vertical Slice - Scene 16: Rozmowa przy stole) captures
	var packed_st16 := load("res://scenes/levels/station_16.tscn") as PackedScene
	if packed_st16:
		# Capture A: Initial kitchen overview at night (Marta gluing cup, table under amber light, dossier, clock)
		var st16_inst := packed_st16.instantiate() as Station16
		root.add_child(st16_inst)
		await process_frame

		if st16_inst.player:
			st16_inst.player.reset_to(Vector2(65.0, 240.0))
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

		# Capture B: Interactive ring choice at table with D-05 confrontation & unlocked balcony exit
		var st16_inst2 := packed_st16.instantiate() as Station16
		root.add_child(st16_inst2)
		await process_frame

		if st16_inst2.player:
			st16_inst2.player.reset_to(Vector2(370.0, 240.0)) # Standing by wedding ring stand and dossier

		st16_inst2.is_cup_inspected = true
		st16_inst2.is_dossier_reviewed = true
		st16_inst2.is_clock_inspected = true
		st16_inst2.make_ring_choice("leave")
		st16_inst2.dialogue_active = true
		st16_inst2.dialogue_index = 11 # D-05 Choice line: LENA: »To jest twoje.« — MARTA: »Nie. Ja swojej nie zgubiłam.«
		st16_inst2.is_balcony_unlocked = true
		st16_inst2._balcony_open_progress = 1.0

		var p16_2 := st16_inst2.get_node_or_null("Props")
		if p16_2:
			var clock2 := p16_2.get_node_or_null("KitchenClock") as MemoryResonancePoint
			var cup2 := p16_2.get_node_or_null("CrackedTeaCup") as MemoryResonancePoint
			var dos2 := p16_2.get_node_or_null("CorrelationDossier") as MemoryResonancePoint
			var ring2 := p16_2.get_node_or_null("WeddingRingStand") as MemoryResonancePoint
			var bal2 := p16_2.get_node_or_null("BalconyExitDoor") as MemoryResonancePoint
			if clock2: clock2.is_activated = true
			if cup2: cup2.is_activated = true
			if dos2: dos2.is_activated = true
			if ring2: ring2.is_activated = true
			if bal2: bal2.is_activated = true

		st16_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st16_2 := root.get_texture().get_image()
		if img_st16_2:
			var path_st16_2 := output_dir.path_join("station_16_choice.png")
			img_st16_2.save_png(path_st16_2)
			print("CAPTURE PASS: " + path_st16_2)

		st16_inst2.queue_free()
		await process_frame

	# 19. Station 17 (Vertical Slice - Scene 17 Punkt Zgodności 6 / Urząd UCP) captures
	var packed_st17 := load("res://scenes/levels/station_17.tscn") as PackedScene
	if packed_st17:
		# Capture A: Overview of luminous modernist waiting hall and reception
		var st17_inst := packed_st17.instantiate() as Station17
		root.add_child(st17_inst)
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

		# Capture B: Active D-06 interview & diagnostic printer with Dr. Helena Wierzbicka and unlocked consultation entrance
		var st17_inst2 := packed_st17.instantiate() as Station17
		root.add_child(st17_inst2)
		await process_frame

		if st17_inst2.player:
			st17_inst2.player.reset_to(Vector2(450.0, 240.0)) # At diagnostic memory printer

		st17_inst2.is_ticket_dispensed = true
		st17_inst2.is_bench_inspected = true
		st17_inst2.is_pneumatic_dispatched = true
		st17_inst2.is_diagnostic_initiated = true
		st17_inst2.dialogue_active = true
		st17_inst2.dialogue_index = 6 # D-06 Line 6: ŚWIADECTWO PAMIĘCI: »Aparat diagnostyczny drukuje w ciszy: KAWA / LINOLEUM / MOKRA WEŁNA.«
		st17_inst2.is_office_door_unlocked = true
		st17_inst2._door_open_progress = 1.0

		var p17_2 := st17_inst2.get_node_or_null("Props")
		if p17_2:
			var ticket2 := p17_2.get_node_or_null("QueuingTicketDispenser") as MemoryResonancePoint
			var bench2 := p17_2.get_node_or_null("ComplianceWaitingBench") as MemoryResonancePoint
			var pneu2 := p17_2.get_node_or_null("PneumaticDossierStation") as MemoryResonancePoint
			var diag2 := p17_2.get_node_or_null("DiagnosticMemoryPrinter") as MemoryResonancePoint
			var door2 := p17_2.get_node_or_null("ConsultationOfficeDoor") as MemoryResonancePoint
			if ticket2: ticket2.is_activated = true
			if bench2: bench2.is_activated = true
			if pneu2: pneu2.is_activated = true
			if diag2: diag2.is_activated = true
			if door2: door2.is_activated = true

		st17_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st17_2 := root.get_texture().get_image()
		if img_st17_2:
			var path_st17_2 := output_dir.path_join("station_17_interview.png")
			img_st17_2.save_png(path_st17_2)
			print("CAPTURE PASS: " + path_st17_2)

		st17_inst2.queue_free()
		await process_frame

	# 20. Station 18 (Vertical Slice - Scene 18 Wywiad zgodności / Gabinet dr Heleny Wierzbickiej) captures
	var packed_st18 := load("res://scenes/levels/station_18.tscn") as PackedScene
	if packed_st18:
		# Capture A: Overview of consultation room — sensory memory map lit, Wierzbicka at desk
		var st18_inst := packed_st18.instantiate() as Station18
		root.add_child(st18_inst)
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

		# Capture B: Active D-07 interview — Lena at desk, galvanometer deflected, strain conduit rising, lie recorded
		var st18_inst2 := packed_st18.instantiate() as Station18
		root.add_child(st18_inst2)
		await process_frame

		if st18_inst2.player:
			st18_inst2.player.reset_to(Vector2(300.0, 240.0)) # At Wierzbicka desk

		st18_inst2.is_desk_approached = true
		st18_inst2.is_map_inspected = true
		st18_inst2.is_galvanometer_triggered = true
		st18_inst2._strain_level = 0.6
		st18_inst2.dialogue_active = true
		st18_inst2.dialogue_index = 7 # ŚWIADECTWO: Za ścianą przesuwa się ciężar (lie accepted, weight shifts)

		var p18_2 := st18_inst2.get_node_or_null("Props")
		if p18_2:
			var desk2 := p18_2.get_node_or_null("WierzbickaDesk") as MemoryResonancePoint
			var map2 := p18_2.get_node_or_null("SensoryMemoryMap") as MemoryResonancePoint
			var galv2 := p18_2.get_node_or_null("CorrectionGalvanometer") as MemoryResonancePoint
			var cond2 := p18_2.get_node_or_null("AcousticWeightConduit") as MemoryResonancePoint
			if desk2: desk2.is_activated = true
			if map2: map2.is_activated = true
			if galv2: galv2.is_activated = true
			if cond2: cond2.is_activated = true

		st18_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st18_2 := root.get_texture().get_image()
		if img_st18_2:
			var path_st18_2 := output_dir.path_join("station_18_interview.png")
			img_st18_2.save_png(path_st18_2)
			print("CAPTURE PASS: " + path_st18_2)

		st18_inst2.queue_free()
		await process_frame

	# 21. Station 19 (Vertical Slice - Scene 19 Model bez oryginału / Sala Modeli) captures
	var packed_st19 := load("res://scenes/levels/station_19.tscn") as PackedScene
	if packed_st19:
		# Capture A: Overview of Sala Modeli — dual schematic maps on wall, central model display table, eleven persons ledger
		var st19_inst := packed_st19.instantiate() as Station19
		root.add_child(st19_inst)
		if st19_inst.player:
			st19_inst.player.reset_to(Vector2(70.0, 240.0))
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

		# Capture B: Active D-07 dialogue — Lena at model display table, dual models resonating, exit unlocked
		var st19_inst2 := packed_st19.instantiate() as Station19
		root.add_child(st19_inst2)
		await process_frame

		if st19_inst2.player:
			st19_inst2.player.reset_to(Vector2(310.0, 240.0)) # At ModelDisplayTable

		st19_inst2.is_table_approached = true
		st19_inst2.is_map_left_inspected = true
		st19_inst2.is_map_right_inspected = true
		st19_inst2.is_ledger_inspected = true
		st19_inst2.dialogue_active = true
		st19_inst2.dialogue_index = 2 # D-07 Line 2: WIERZBICKA: »Ta, po której za dwie minuty zejdzie sto czterdzieści osób.«
		st19_inst2.is_exit_unlocked = true
		st19_inst2._exit_open_progress = 1.0

		var p19_2 := st19_inst2.get_node_or_null("Props")
		if p19_2:
			var table2 := p19_2.get_node_or_null("ModelDisplayTable") as MemoryResonancePoint
			var map_l2 := p19_2.get_node_or_null("StaircaseMapLeft") as MemoryResonancePoint
			var map_r2 := p19_2.get_node_or_null("StaircaseMapRight") as MemoryResonancePoint
			var ledger2 := p19_2.get_node_or_null("ElevenPersonsLedger") as MemoryResonancePoint
			var exit2 := p19_2.get_node_or_null("ModelRoomExit") as MemoryResonancePoint
			if table2: table2.is_activated = true
			if map_l2: map_l2.is_activated = true
			if map_r2: map_r2.is_activated = true
			if ledger2: ledger2.is_activated = true
			if exit2: exit2.is_activated = true

		st19_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st19_2 := root.get_texture().get_image()
		if img_st19_2:
			var path_st19_2 := output_dir.path_join("station_19_models.png")
			img_st19_2.save_png(path_st19_2)
			print("CAPTURE PASS: " + path_st19_2)

		st19_inst2.queue_free()
		await process_frame

	quit(0)




