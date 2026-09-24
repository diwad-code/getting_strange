extends SceneTree

## PKG-0196 / CR-D: rytm początku i spójność obrazu (stacje 01-08).
##
## Real InputMap input -> OpeningActionPoint -> station writer -> delivered CRT
## lines. Covers: both opening branches (repeat_sample keeps the raw carrier,
## leave_on_time packs the reader without it), single-time naming of the
## detour cost, domestic-concrete Marta reply in 03, buffer/carrier split in
## 04, branch-true sample case in 05 (E02), route/date timetable without the
## address in 06, vendor with his own closing intent and no shared-address
## reveal in 06, control question plus silence after the key in 08, missing
## premises staying informational, save/reload mid-route, reread granting
## nothing new, and text scales 85/100/115 through the same live presentation.
## The harness selects input targets explicitly; it does not prove traversal.

var failures: Array[String] = []
var delivered: Array[String] = []
var action_count := 0
var capture := false
var capture_index := 0
var station_number := 0
var scale_tag := "100"
var last_line := ""
var capture_rows: Array[String] = []


func _initialize() -> void:
	call_deferred("run")


func expect(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
		printerr("PKG-0196 FAILURE: " + message)


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
	var path := "res://reports/pkg_0196/visual_final/s%02d_%s_%03d_%s.png" % [station_number, scale_tag, capture_index, label]
	expect(root.get_texture().get_image().save_png(path) == OK, "save capture " + path)
	capture_rows.append(path + "\t" + label + "\t" + last_line)
	capture_index += 1


func drain(station: Node) -> void:
	var box := station.get_node("CRTDialogueBox") as CRTDialogueBox
	for tick in range(260):
		if box.is_presenting():
			var before := action_count
			if bool(box.get("_typing")):
				await press()
				var label := box.get_node("CRTDialoguePanel/DialogueText") as RichTextLabel
				expect(label.get_content_height() <= label.size.y + 1.0, "dialogue text must fit at scale " + scale_tag + ": " + last_line)
				await frame_capture("line")
			else:
				await press()
			expect(action_count == before, "dialogue advance must not trigger an action point")
		else:
			await process_frame
			return
	expect(false, "conversation did not drain")


func open_station(number: int) -> Node:
	station_number = number
	var station := (load("res://scenes/levels/station_%02d.tscn" % number) as PackedScene).instantiate()
	root.add_child(station)
	station.get_node("CRTDialogueBox").line_started.connect(func(speaker: StringName, text: String) -> void:
		last_line = String(speaker) + ": " + text
		delivered.append(last_line))
	for prop in station.get_node("Props").get_children():
		if prop is OpeningActionPoint:
			(prop as OpeningActionPoint).action_requested.connect(func(_id: StringName) -> void: action_count += 1)
	for i in range(3):
		await process_frame
	await drain(station)
	return station


func act(station: Node, action_id: String) -> void:
	for prop in station.get_node("Props").get_children():
		if prop is OpeningActionPoint:
			(prop as OpeningActionPoint).is_player_in_range = (prop as OpeningActionPoint).action_id == StringName(action_id)
	var before := action_count
	await press()
	expect(action_count == before + 1, "real input must reach exactly one point: " + action_id)
	for prop in station.get_node("Props").get_children():
		if prop is OpeningActionPoint:
			(prop as OpeningActionPoint).is_player_in_range = false
	await drain(station)


func close_station(station: Node) -> void:
	station.queue_free()
	await process_frame


## Station 01 cold open, driven for real: the single executable act starts the
## mandatory measurement, then the dwell timers walk RESULT -> MESSAGE -> fork.
## Dwell values are accelerated by seeding _stage_time; the path (measurement
## -> archive gap -> message -> fork) stays the production one.
func drive_cold_open(station: Node) -> void:
	await act(station, "repeat_line_four_measurement")
	expect(int(station.get("cold_open_stage")) != 4, "cold open must leave AWAIT on the real first act")
	for i in range(3):
		station.set("_stage_time", 999.0)
		await physics_frame
		await physics_frame
		await drain(station)
	expect(int(station.get("cold_open_stage")) == 4, "cold open must reach DONE through the real dwell chain")


func run_01(state: Node, branch: String) -> void:
	var station := await open_station(1)
	if branch == "repeat":
		await drive_cold_open(station)
		await act(station, "repeat_line_four_measurement")
		expect(not String(state.decisions.get(&"p7.sample_and_promise.measurement_result", "")).is_empty(), "01 repeat must record the retained gap")
		await act(station, "secure_raw_sample")
		expect(String(state.decisions.get(&"p9.opening.choice", "")) == "repeat_sample", "01 must commit repeat_sample")
		expect(bool(state.decisions.get(&"home_sample_preserved", false)), "repeat must keep the raw sample")
	else:
		state.record_decision(&"p9.cold_open.completed", true)
		station.queue_free()
		await process_frame
		station = await open_station(1)
		await act(station, "secure_raw_sample")
		expect(String(state.decisions.get(&"p9.opening.choice", "")) == "leave_on_time", "01 must commit leave_on_time")
		expect(not bool(state.decisions.get(&"home_sample_preserved", true)), "leave must keep the raw sample out of the bag")
	await act(station, "read_marta_message")
	expect(bool(state.decisions.get(&"p9.opening.marta_waiting", false)), "01 must confirm Marta waits")
	await close_station(station)


func run_02_04(state: Node) -> void:
	var s02 := await open_station(2)
	await act(s02, "inspect_detour_closure")
	await act(s02, "compare_detour_time")
	await act(s02, "take_service_ladder")
	await close_station(s02)
	var s03 := await open_station(3)
	await act(s03, "read_departure_board")
	await act(s03, "reply_to_marta")
	expect(bool(state.decisions.get(&"p9.opening.marta_knows_delay", false)), "03 must tell Marta about the delay")
	await close_station(s03)
	var s04 := await open_station(4)
	await act(s04, "observe_reader_buffer")
	await act(s04, "watch_line_four_memorial")
	await act(s04, "stow_reader_for_marta")
	await close_station(s04)


func run_05_08(state: Node) -> void:
	var s05 := await open_station(5)
	await act(s05, "check_street_route")
	await act(s05, "check_sample_case")
	await act(s05, "cross_street_towards_home")
	expect(bool(state.decisions.get(&"ordinary_return_complete", false)), "05 must complete the ordinary return")
	await close_station(s05)
	var s06 := await open_station(6)
	await act(s06, "inspect_street_timetable")
	await act(s06, "buy_water_at_kiosk")
	await act(s06, "ask_kiosk_vendor")
	expect(bool(state.decisions.get(&"unease_pattern_started", false)), "06 must start the unease pattern")
	await close_station(s06)
	var s07 := await open_station(7)
	await act(s07, "compare_address_document")
	await act(s07, "inspect_intercom_directory")
	await act(s07, "enter_intercom_code")
	expect(bool(state.decisions.get(&"local_address_confirmed", false)), "07 must confirm the local address")
	expect(bool(state.decisions.get(&"conflicting_documents_found", false)), "07 must record the document conflict")
	await close_station(s07)
	var s08 := await open_station(8)
	await act(s08, "inspect_floor_twelve")
	await act(s08, "speak_with_neighbour")
	expect(bool(state.decisions.get(&"marta_relationship_disclosed", false)), "08 must disclose the Marta relationship")
	await act(s08, "unlock_apartment_fourteen")
	await close_station(s08)


func ordered(joined: String, first: String, second: String, message: String) -> void:
	expect(joined.contains(first) and joined.contains(second) and joined.find(first) < joined.find(second), message)


func run() -> void:
	capture = OS.get_cmdline_user_args().has("--capture")
	root.size = Vector2i(640, 360)
	if capture:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports/pkg_0196/visual_final"))
	var state := root.get_node("GameStateManager")
	var old_scale: float = state.text_scale
	state.campaign_auto_transition_enabled = false
	# Run A: repeat_sample branch, full route 01-08.
	state.reset_campaign(true)
	state.text_scale = 1.0
	delivered.clear()
	await run_01(state, "repeat")
	await run_02_04(state)
	expect(state.save_campaign(), "save mid-route must succeed")
	state.reset_campaign(false)
	expect(state.reload_campaign_from_disk(), "reload mid-route must succeed")
	expect(String(state.decisions.get(&"p9.opening.choice", "")) == "repeat_sample", "reload must keep the opening choice")
	expect(bool(state.decisions.get(&"home_sample_preserved", false)), "reload must keep the raw sample")
	await run_05_08(state)
	var joined_a := "\n".join(delivered)
	for required in ["Marta poczeka dłużej", "Herbata stygnie", "Do mojego opóźnienia doszedł objazd", "Odwracam czytnik ekranem do dołu", "Próbka jedzie w torbie", "Surowa próbka drgań jest w torbie", "Linia 4 jedzie inaczej", "Zwijam kiosk po tej zmianie", "Kto mieszka pod dwunastką?", "Pan Kowalczyk", "Klucz działa"]:
		expect(joined_a.contains(required), "run A delivered line: " + required)
	for removed in ["Będę później o dwanaście minut", "Miałaś wrócić wcześniej. Napisz tylko, czy jedziesz", "Marta czeka. Czytnik odkładam do domu", "Mój klucz wchodzi gładko", "Od lat pod czternastką", "przeniesiono pod 14", "mieszkam pod dwunastką"]:
		expect(not joined_a.contains(removed), "run A must not serve the trimmed redundancy: " + removed)
	ordered(joined_a, "Nasyp doda mi dwanaście minut", "Marta poczeka dłużej", "detour cost must be named once, then gestured")
	# Reread grants nothing new.
	var revisit := await open_station(5)
	var facts_before := (state.decisions as Dictionary).size()
	await act(revisit, "check_street_route")
	expect((state.decisions as Dictionary).size() == facts_before, "reread of a resolved point must grant no new fact")
	await close_station(revisit)
	# Run B: leave_on_time branch. The carrier must never be spoken of.
	state.reset_campaign(true)
	delivered.clear()
	await run_01(state, "leave")
	await run_02_04(state)
	await run_05_08(state)
	expect(not bool(state.decisions.get(&"home_sample_preserved", true)), "leave must persist without the sample")
	var joined_b := "\n".join(delivered)
	for required in ["Jeden odczyt. Spakowałam sprzęt i wychodzę", "Wyszłam po jednym odczycie. Teraz czekam przez objazd", "W torbie spakowany czytnik", "Tyle z pracy na dziś", "Luka została bez drugiego pomiaru"]:
		expect(joined_b.contains(required), "run B delivered line: " + required)
	expect(not joined_b.contains("Surowa próbka drgań jest w torbie"), "leave branch must never claim the raw carrier")
	expect(not joined_b.contains("Próbka jedzie w torbie"), "leave branch must never claim the carried sample")
	# Missing premises stay informational and grant nothing.
	state.reset_campaign(true)
	delivered.clear()
	var bare02 := await open_station(2)
	await act(bare02, "compare_detour_time")
	expect(String(state.decisions.get(&"p7.sample_and_promise.safe_trial_feedback", "")) == "closure_required", "detour time without the closure must stay informational")
	expect(not state.decisions.has(&"p7.sample_and_promise.route_time_confirmed"), "failed attempt must grant no route time")
	await close_station(bare02)
	var bare05 := await open_station(5)
	# PKG-0242 (R1): PKG-0239 made the street and the bag optional reads;
	# crossing without the bag check must not invent a secured reader.
	await act(bare05, "cross_street_towards_home")
	expect(String(state.decisions.get(&"p7.return_under_control.trace", "")) == "ordinary_street_crossed", "crossing without the bag check must leave the plain crossing trace")
	expect(not state.decisions.has(&"p7.return_under_control.reader_secured"), "crossing without the bag check must grant no secured reader")
	await close_station(bare05)
	# Text scales through the same live action presentation.
	for scale_value in [0.85, 1.0, 1.15]:
		scale_tag = str(roundi(scale_value * 100))
		state.text_scale = scale_value
		state.reset_campaign(true)
		var scaled := await open_station(8)
		await act(scaled, "inspect_floor_twelve")
		await act(scaled, "speak_with_neighbour")
		await act(scaled, "unlock_apartment_fourteen")
		await close_station(scaled)
	state.text_scale = old_scale
	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = true
	if capture:
		var manifest := FileAccess.open("res://reports/pkg_0196/visual_final/frames.tsv", FileAccess.WRITE)
		manifest.store_string("path\tphase\tlast_line\n" + "\n".join(capture_rows))
		manifest.close()
	if failures.is_empty():
		print("PKG-0196 PASS: real input across 01-08, both opening branches, trimmed redundancies, branch-true carrier, missing premises, reload, reread and text scales")
		quit(0)
	else:
		quit(1)
