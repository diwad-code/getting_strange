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

	# 22. Station 20 (Vertical Slice - Scene 20 Sala Szymona) captures
	var packed_st20 := load("res://scenes/levels/station_20.tscn") as PackedScene
	if packed_st20:
		# Capture A: Overview of Sala Szymona — clinical adaptive room, Szymon Bera on therapeutic bed, table with well drawing
		var st20_inst := packed_st20.instantiate() as Station20
		root.add_child(st20_inst)
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

		# Capture B: Active D-08 dialogue & door shift — Lena at table with well drawing, Iga's name spoken, door shifted
		var st20_inst2 := packed_st20.instantiate() as Station20
		root.add_child(st20_inst2)
		await process_frame

		if st20_inst2.player:
			st20_inst2.player.reset_to(Vector2(300.0, 240.0)) # At WellDrawing table facing Szymon

		st20_inst2.is_szymon_approached = true
		st20_inst2.is_drawing_inspected = true
		st20_inst2.is_report_inspected = true
		st20_inst2.is_magnifier_inspected = true
		st20_inst2.is_door_shifted = true
		st20_inst2._door_shift_offset = 14.0
		st20_inst2.dialogue_active = true
		st20_inst2.dialogue_index = 8 # D-08 Line 8: ŚWIADECTWO: »Drzwi sali przesuwają się o kilka centymetrów.«
		st20_inst2.drawing_choice = Station20.DrawingChoice.ANCHOR_DRAWING
		st20_inst2.is_exit_unlocked = true
		st20_inst2._exit_open_progress = 1.0

		var p20_2 := st20_inst2.get_node_or_null("Props")
		if p20_2:
			var szymon2 := p20_2.get_node_or_null("SzymonBera") as MemoryResonancePoint
			var drawing2 := p20_2.get_node_or_null("WellDrawing") as MemoryResonancePoint
			var report2 := p20_2.get_node_or_null("HydrologyReport") as MemoryResonancePoint
			var mag2 := p20_2.get_node_or_null("ErasedSignatureMagnifier") as MemoryResonancePoint
			var exit2 := p20_2.get_node_or_null("SzymonRoomExit") as MemoryResonancePoint
			if szymon2: szymon2.is_activated = true
			if drawing2: drawing2.is_activated = true
			if report2: report2.is_activated = true
			if mag2: mag2.is_activated = true
			if exit2: exit2.is_activated = true

		st20_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st20_2 := root.get_texture().get_image()
		if img_st20_2:
			var path_st20_2 := output_dir.path_join("station_20_szymon.png")
			img_st20_2.save_png(path_st20_2)
			print("CAPTURE PASS: " + path_st20_2)

		st20_inst2.queue_free()
		await process_frame

	# 23. Station 21 (Vertical Slice - Scene 21 Cena ulgi / Pokój zabiegowy Szymona) captures
	var packed_st21 := load("res://scenes/levels/station_21.tscn") as PackedScene
	if packed_st21:
		# Capture A: Overview of Sala Zabiegowa 21 — clinical sedation console, Szymon Bera in adaptive recliner, pedestal, dossier slot, exit airlock
		var st21_inst := packed_st21.instantiate() as Station21
		root.add_child(st21_inst)
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

		# Capture B: Active Scene 21 dialogue & sedation telemetry — Lena facing pacified Szymon, erased name stage direction, unlocked exit airlock
		var st21_inst2 := packed_st21.instantiate() as Station21
		root.add_child(st21_inst2)
		await process_frame

		if st21_inst2.player:
			st21_inst2.player.reset_to(Vector2(220.0, 240.0)) # Facing Szymon in recliner

		st21_inst2.is_szymon_approached = true
		st21_inst2.is_terminal_inspected = true
		st21_inst2.is_dossier_inspected = true
		st21_inst2.is_pedestal_inspected = true
		st21_inst2.is_erased_name_attempted = true
		st21_inst2.dialogue_active = true
		st21_inst2.dialogue_index = 2 # Line 2: ŚWIADECTWO: »Szymon próbuje powtórzyć. Aparat sedacji emituje szum...«
		st21_inst2.is_exit_unlocked = true
		st21_inst2._exit_open_progress = 1.0

		var p21_2 := st21_inst2.get_node_or_null("Props")
		if p21_2:
			var term2 := p21_2.get_node_or_null("AnesthesiaTerminal") as MemoryResonancePoint
			var szymon2 := p21_2.get_node_or_null("SzymonPostCorrection") as MemoryResonancePoint
			var ped2 := p21_2.get_node_or_null("DrawingDispositionPedestal") as MemoryResonancePoint
			var slot2 := p21_2.get_node_or_null("FilteredDossierSlot") as MemoryResonancePoint
			var exit2 := p21_2.get_node_or_null("Station21Exit") as MemoryResonancePoint
			if term2: term2.is_activated = true
			if szymon2: szymon2.is_activated = true
			if ped2: ped2.is_activated = true
			if slot2: slot2.is_activated = true
			if exit2: exit2.is_activated = true

		st21_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st21_2 := root.get_texture().get_image()
		if img_st21_2:
			var path_st21_2 := output_dir.path_join("station_21_szymon.png")
			img_st21_2.save_png(path_st21_2)
			print("CAPTURE PASS: " + path_st21_2)

		st21_inst2.queue_free()
		await process_frame

	# 24. Station 22 (Vertical Slice - Scene 22 Uległość / Biometryczna bramka tożsamości) captures
	var packed_st22 := load("res://scenes/levels/station_22.tscn") as PackedScene
	if packed_st22:
		# Capture A: Overview of transit hall and biometric verification portal (Lena entering at x=60)
		var st22_inst := packed_st22.instantiate() as Station22
		root.add_child(st22_inst)
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

		# Capture B: Active Scene 22 Yield sequence — Lena at memory slab, paint memory influx, erased nurse face, amber warmth, unlocked transit portal
		var st22_inst2 := packed_st22.instantiate() as Station22
		root.add_child(st22_inst2)
		await process_frame

		if st22_inst2.player:
			st22_inst2.player.reset_to(Vector2(370.0, 240.0)) # At paint memory slab

		st22_inst2.is_gate_scanned = true
		st22_inst2.is_contact_inspected = true
		st22_inst2.is_ring_inspected = true
		st22_inst2.is_paint_recalled = true
		st22_inst2.is_biographical_erasure_measured = true
		st22_inst2.is_yield_accepted = true
		st22_inst2._yield_warmth_progress = 1.0
		st22_inst2.dialogue_active = true
		st22_inst2.dialogue_index = 5 # Line 5: ŚWIADECTWO: »Napływa obce, ciepłe wspomnienie: zapach świeżej farby emulsyjnej...«
		st22_inst2.is_exit_unlocked = true
		st22_inst2._exit_open_progress = 1.0

		var p22_2 := st22_inst2.get_node_or_null("Props")
		if p22_2:
			var reg2 := p22_2.get_node_or_null("ComplianceContactRegister") as MemoryResonancePoint
			var ring2 := p22_2.get_node_or_null("RingFittingScanner") as MemoryResonancePoint
			var paint2 := p22_2.get_node_or_null("PaintResinResonanceSlab") as MemoryResonancePoint
			var gate2 := p22_2.get_node_or_null("BiometricIdentityGate") as MemoryResonancePoint
			var exit2 := p22_2.get_node_or_null("Station22Exit") as MemoryResonancePoint
			if reg2: reg2.is_activated = true
			if ring2: ring2.is_activated = true
			if paint2: paint2.is_activated = true
			if gate2: gate2.is_activated = true
			if exit2: exit2.is_activated = true

		st22_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st22_2 := root.get_texture().get_image()
		if img_st22_2:
			var path_st22_2 := output_dir.path_join("station_22_yield.png")
			img_st22_2.save_png(path_st22_2)
			print("CAPTURE PASS: " + path_st22_2)

		st22_inst2.queue_free()
		await process_frame

	# 25. Station 23 (Vertical Slice - Scene 23 Pokój projektantki / Model Podstruktury i uciekający kursor) captures
	var packed_st23 := load("res://scenes/levels/station_23.tscn") as PackedScene
	if packed_st23:
		# Capture A: Overview of local Lena's workstation in Podstruktura (Lena entering at x=60)
		var st23_inst := packed_st23.instantiate() as Station23
		root.add_child(st23_inst)
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

		# Capture B: Active Scene 23 D-16 sequence — Lena interacting at Shadow console (x=490), displaced cursor, burdened list, model with note, unlocked exit airlock
		var st23_inst2 := packed_st23.instantiate() as Station23
		root.add_child(st23_inst2)
		await process_frame

		if st23_inst2.player:
			st23_inst2.player.reset_to(Vector2(490.0, 240.0)) # At interactive Shadow console

		st23_inst2.is_terminal_inspected = true
		st23_inst2.is_model_inspected = true
		st23_inst2.is_ledger_inspected = true
		st23_inst2.is_cursor_shifted = true
		st23_inst2._shadow_cursor_offset = 1.0
		st23_inst2.is_burden_list_scrolled = true
		st23_inst2.is_purpose_revealed = true
		st23_inst2.is_archive_confirmed = true
		st23_inst2.dialogue_active = true
		st23_inst2.dialogue_index = 2 # Line 2: ŚWIADECTWO: »Lena otwiera polecenie nadpisania wzorca. Kursor sam odsuwa się o jedno pole...«
		st23_inst2.is_exit_unlocked = true
		st23_inst2._exit_open_progress = 1.0

		var p23_2 := st23_inst2.get_node_or_null("Props")
		if p23_2:
			var term2 := p23_2.get_node_or_null("DesignerTerminal") as MemoryResonancePoint
			var model2 := p23_2.get_node_or_null("SubstructureModel") as MemoryResonancePoint
			var ledger2 := p23_2.get_node_or_null("BurdenedLedger") as MemoryResonancePoint
			var console2 := p23_2.get_node_or_null("ShadowInteractiveConsole") as MemoryResonancePoint
			var exit2 := p23_2.get_node_or_null("Station23Exit") as MemoryResonancePoint
			if term2: term2.is_activated = true
			if model2: model2.is_activated = true
			if ledger2: ledger2.is_activated = true
			if console2: console2.is_activated = true
			if exit2: exit2.is_activated = true

		st23_inst2.queue_redraw()

		for frame in range(8):
			await process_frame
		await RenderingServer.frame_post_draw

		var img_st23_2 := root.get_texture().get_image()
		if img_st23_2:
			var path_st23_2 := output_dir.path_join("station_23_terminal.png")
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
		st24_inst2.set_disposition(Station24.DispositionChoice.APPARENT_COOPERATION)
		st24_inst2.dialogue_active = true
		st24_inst2.dialogue_index = 5 # Line 5: DR WIERZBICKA: »Oferuję ochronę Marty. W zamian za zgodę na pełną rejestrację pani współrzędnych.«
		st24_inst2.is_exit_unlocked = true
		st24_inst2._exit_open_progress = 1.0

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
		st25_inst2._jakub_sitting = true
		st25_inst2.dialogue_active = true
		st25_inst2.dialogue_index = 11 # Line 11: JAKUB: »Nie jestem twoim wspomnieniem. Jeśli chcesz wyjść, pomogę osobie. Nie żałobie.«
		st25_inst2.is_exit_unlocked = true
		st25_inst2._exit_open_progress = 1.0

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

		st26_inst2.is_console_inspected = true
		st26_inst2.is_designator_inspected = true
		st26_inst2.is_speaker_inspected = true
		st26_inst2.is_motivation_anchored = true
		st26_inst2.current_room_state = Station26.RoomState.SEDATION
		st26_inst2.dialogue_active = true
		st26_inst2.dialogue_index = 8 # Line 8: ŚWIADECTWO: »Lena wyciąga stalowy rysik i z naciskiem ryje na ścianie Podstruktury: PAMIĘTAM DLACZEGO PRZYSZŁAM. NIE JESTEM ADAPTACJĄ.«
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

		st27_inst2.is_badge_inspected = true
		st27_inst2.is_jakub_interacted = true
		st27_inst2.is_monitor_inspected = true
		st27_inst2.is_console_inspected = true
		st27_inst2.dialogue_active = true
		st27_inst2.dialogue_index = 7 # Line 7: JAKUB: »Więc udowodnij to. Zanim otworzę drogę do składu technicznego, obiecaj, że nie zrobisz z nich długu.«
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

		st28_inst2.is_console_interacted = true
		st28_inst2.is_window_inspected = true
		st28_inst2.is_paradox_inspected = true
		st28_inst2.is_intercom_inspected = true
		st28_inst2.dialogue_active = true
		st28_inst2.dialogue_index = 9 # Line 9: WIERZBICKA: »Nie ścigam państwa. Zamykam drogę, którą otwieracie za sobą.«
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

		st29_inst2.is_tracks_inspected = true
		st29_inst2.is_neon_inspected = true
		st29_inst2.is_well_inspected = true
		st29_inst2.is_beacon_inspected = true
		st29_inst2.dialogue_active = true
		st29_inst2.dialogue_index = 9 # Line 9: LENA: »Nie wracamy, Jakub. Otwórzmy to.«
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

		st30_inst2.is_board_inspected = true
		st30_inst2.is_transformer_inspected = true
		st30_inst2.is_breaker_thrown = true
		st30_inst2.is_schematic_inspected = true
		st30_inst2.dialogue_active = true
		st30_inst2.dialogue_index = 9 # Line 9: JAKUB: »Zrobione. Obwody nadzoru zgasły. Droga do Magazynu Dowodów stoi otworem.«
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

	quit(0)





