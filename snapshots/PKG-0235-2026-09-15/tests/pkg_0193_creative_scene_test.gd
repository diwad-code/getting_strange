extends SceneTree

## Real MRP input -> station writer -> delivered CRT lines, plus reload/skip.
## The harness selects an input target explicitly; it does not prove traversal.
const IDS := {
	9: ["two_lives", "relation_photo", "private_boundary"],
	10: ["home_task", "marta_day", "marta_boundary"],
	11: ["identity_card", "record_186_days", "minimal_report"],
	12: ["jakub_questions", "jakub_meeting", "jakub_refusal"],
	13: ["marta_source", "institution_source", "synthesize"],
}
var failures: Array[String] = []
var delivered: Array[String] = []
var action_count := 0
var capture := false
var capture_index := 0
var station_number := 0
var scale_tag := "100"
var vignette_count := 0
var last_line := ""
var capture_rows: Array[String] = []

func _initialize() -> void:
	call_deferred("run")

func expect(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
		printerr("PKG-0193 FAILURE: " + message)

func press() -> void:
	var event := InputEventAction.new()
	event.action = &"interact"
	event.pressed = true
	root.push_input(event, true)
	event = InputEventAction.new()
	event.action = &"interact"
	root.push_input(event, true)
	await process_frame

func frame_capture(label: String) -> void:
	if not capture:
		return
	await RenderingServer.frame_post_draw
	var path := "res://reports/pkg_0193/visual_final/s%02d_%s_%03d_%s.png" % [station_number, scale_tag, capture_index, label]
	expect(root.get_texture().get_image().save_png(path) == OK, "save capture " + path)
	capture_rows.append(path + "\t" + label + "\t" + last_line)
	capture_index += 1

func drain(station: Node) -> void:
	var box := station.get_node("CRTDialogueBox") as CRTDialogueBox
	for tick in range(220):
		var vignette := station.get_node_or_null("CinematicVignette_vig_synthesis")
		if vignette != null and not vignette.is_queued_for_deletion():
			vignette_count += 1
			expect(not box.is_presenting(), "cinematic and CRT must not overlap")
			await frame_capture("vignette")
			await press() # semantic skip, not skip_for_test
		elif box.is_presenting():
			var before := action_count
			if bool(box.get("_typing")):
				await press()
				var label := box.get_node("CRTDialoguePanel/DialogueText") as RichTextLabel
				expect(label.get_content_height() <= label.size.y + 1.0, "dialogue text must fit at scale " + scale_tag)
				await frame_capture("line")
			else:
				await press()
			expect(action_count == before, "dialogue advance must not trigger MRP")
		else:
			await process_frame
			if not station.get_node("CreativeScenePresentation").is_busy():
				await frame_capture("rest")
				return
	expect(false, "conversation did not drain")

func open_station(number: int) -> Node:
	station_number = number
	var station := (load("res://scenes/levels/station_%02d.tscn" % number) as PackedScene).instantiate()
	root.add_child(station)
	station.get_node("CRTDialogueBox").line_started.connect(func(speaker: StringName, text: String) -> void:
		last_line = String(speaker) + ": " + text
		delivered.append(last_line))
	station.clue_inspected.connect(func(_id: String, _type: int) -> void: action_count += 1)
	for i in range(3):
		await process_frame
	await drain(station)
	return station

func act(station: Node, id: String) -> void:
	for prop in station.get_node("Props").get_children():
		if prop is MemoryResonancePoint:
			prop.is_player_in_range = prop.resonance_id == id
	var before := action_count
	await press()
	expect(action_count == before + 1, "real input must reach exactly one point: " + id)
	await drain(station)

func run() -> void:
	capture = OS.get_cmdline_user_args().has("--capture")
	root.size = Vector2i(640, 360)
	if capture:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports/pkg_0193/visual_final"))
	var state := root.get_node("GameStateManager")
	var old_scale: float = state.text_scale
	for sample in [false, true]:
		state.reset_campaign(true)
		state.cinematics_seen.clear() # Settings lifetime differs from campaign lifetime.
		state.text_scale = 1.0
		state.record_decision(&"p7.foreign_daily_life.trace", "threshold_crossed")
		state.record_decision(&"home_sample_preserved", sample)
		MotionAccessibility.set_reduced_motion(sample)
		for number in IDS:
			var station := await open_station(number)
			if number == 12:
				expect(station.get_node("WorkshopBlockout/Jakub").get_active_state_name() == &"work", "Jakub works before the bodily meeting")
			if number == 13:
				await act(station, "synthesize")
				expect(state.decisions.get(&"world_recognized", false) != true, "failed synthesis grants no knowledge")
			for id in IDS[number]:
				await act(station, id)
				if id == "jakub_questions":
					expect(station.get_node("WorkshopBlockout/Jakub").get_active_state_name() == &"work", "phone questions do not yet stop his work")
			GapLedger.record_on_depart(station)
			for gap_id in state.open_gaps:
				expect(state.open_gaps[gap_id].get("origin_station", "") != "station_%02d" % number, "resolved current facts must close this station's gap")
			station.queue_free()
			await process_frame
		expect(state.decisions.get(&"world_recognized", false) == true, "real route synthesis")
		expect(state.is_cinematic_seen(&"vig_synthesis"), "semantic skip records seen")
		expect(state.save_campaign(), "save")
		state.reset_campaign(false)
		expect(state.reload_campaign_from_disk(), "reload")
		var revisit := await open_station(13)
		await act(revisit, "synthesize")
		expect(revisit.get_node_or_null("CinematicVignette_vig_synthesis") == null, "reread does not replay vignette")
		revisit.queue_free()
		await process_frame
	var joined := "\n".join(delivered)
	expect(vignette_count == 2, "both fresh routes must actually display and skip a vignette")
	for required in ["Kurtkę zostawiłaś na kaloryferze", "Oddałaś mi ją na parkingu", "REJESTR SZPITALNY:", "REJESTR SERWISOWY:", "Co było pod schodami u babci?", "W którym tunelu?", "Pokaż bliznę.", "Jakub: Nie.", "Marta: Więc gdzie jest ona?", "Lena: Nie wiem.", "Nie mam zabezpieczonej surowej próbki", "surowa próbka z powtórzonego pomiaru"]:
		expect(joined.contains(required), "delivered line: " + required)
	expect(joined.find("To nie jest mój świat.") < joined.find("Więc gdzie jest ona?"), "recognition precedes question")
	# Missing-source entry must never speak as though an absent report exists.
	state.reset_campaign(true)
	delivered.clear()
	var empty := await open_station(13)
	await act(empty, "institution_source")
	expect(not "\n".join(delivered).contains("Wyciąg UCP: 186 dni"), "missing report is not invented")
	await act(empty, "synthesize")
	expect(not "\n".join(delivered).contains("To nie jest mój świat."), "unseeded route has no reveal")
	empty.queue_free()
	await process_frame
	# Font scales and replay go through the same live action presentation.
	for scale_value in [0.85, 1.0, 1.15]:
		scale_tag = str(roundi(scale_value * 100))
		state.text_scale = scale_value
		state.record_decision(&"p9.mystery.home.trace", "two_lives_without_claim")
		var scaled := await open_station(10)
		for id in IDS[10]:
			await act(scaled, id)
		scaled.queue_free()
		await process_frame
	state.text_scale = old_scale
	MotionAccessibility.set_reduced_motion(false)
	if capture:
		var manifest := FileAccess.open("res://reports/pkg_0193/visual_final/frames.tsv", FileAccess.WRITE)
		manifest.store_string("path\tphase\tlast_line\n" + "\n".join(capture_rows))
		manifest.close()
	if failures.is_empty():
		print("PKG-0193 PASS: real MRP input, delivered conversations, advance isolation, missing sources, sample branches, reload, skip and text scales")
		quit(0)
	else:
		quit(1)
