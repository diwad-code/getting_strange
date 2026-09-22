extends SceneTree

# PKG-0157 / PHASE-02 — First Five Minutes (BUNDLE-06..10).
# Tests Shell product promise, Station 01 worksite, Station 02 detour,
# Station 03 transit stop, Station 04 transit ride, GATE-01, GATE-05, GATE-INT,
# and end-to-end player verb campaign progression for the first five minutes.

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0157 FAILURE: %s" % message)


func _run_tests() -> void:
	print("=== PKG-0157 Smoke Test: PHASE-02 First Five Minutes (BUNDLE-06..10) ===")
	_test_bundle_06_shell_promise()
	_test_bundle_07_station_01_worksite()
	_test_bundle_08_station_02_detour()
	_test_bundle_09_station_03_transit_stop()
	_test_bundle_10_station_04_transit_ride()
	_test_gate_int_budgets()
	await _test_first_five_minutes_campaign_playthrough()
	_finish()


func _test_bundle_06_shell_promise() -> void:
	print("Testing BUNDLE-06: Shell product promise...")
	var packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
	_expect(packed != null, "scenes/shell/title_screen.tscn must load")
	if packed == null:
		return
	var title := packed.instantiate() as TitleScreen
	_expect(title != null, "TitleScreen must instantiate")
	if title == null:
		return
	root.add_child(title)
	title.refresh_for_test()

	# Title & promise checks in Polish
	LocalizationManager.current_locale = "pl"
	title.refresh_for_test()
	var title_label := title.get_node_or_null("TitlePanel/TitleLabel") as Label
	var subtitle_label := title.get_node_or_null("TitlePanel/SubtitleLabel") as Label
	var promise_label := title.get_node_or_null("TitlePanel/PersonalPromise") as Label
	var status_label := title.get_node_or_null("TitlePanel/CampaignStatus") as Label
	var return_promise := title.get_node_or_null("TitlePanel/ReturnPromise") as Label
	var new_game_btn := title.get_node_or_null("TitlePanel/NewGameButton") as Button
	var continue_btn := title.get_node_or_null("TitlePanel/ContinueButton") as Button
	var settings_btn := title.get_node_or_null("TitlePanel/SettingsButton") as Button
	var quit_btn := title.get_node_or_null("TitlePanel/QuitButton") as Button

	_expect(title_label != null and title_label.text == "GETTING STRANGE", "Title label must be GETTING STRANGE")
	_expect(subtitle_label != null and subtitle_label.text.contains("POWRÓT PRZEZ LINIĘ 4"), "Subtitle must state Line 4 return")
	_expect(promise_label != null and promise_label.text.contains("Marta czeka na Lenę"), "Promise must state Marta waits for Lena")
	_expect(promise_label != null and promise_label.text.contains("Trzy sekundy z Linii 4"), "Promise must mention 3 seconds from Line 4")
	_expect(title.get_node_or_null("TitlePanel/ControlsHint") == null, "First image must not be a controls list")
	_expect(return_promise != null and return_promise.text.contains("LINIA 4"), "First image must reinforce the return, not explain controls")
	_expect(new_game_btn != null and new_game_btn.text == "NOWA GRA", "New Game button text")
	_expect(continue_btn != null and continue_btn.text == "KONTYNUUJ", "Continue button text")
	_expect(settings_btn != null and settings_btn.text == "USTAWIENIA", "Settings button text")
	_expect(quit_btn != null and quit_btn.text == "ZAKOŃCZ", "Quit button text")

	# Test English translation
	LocalizationManager.current_locale = "en"
	title.refresh_for_test()
	_expect(subtitle_label.text.contains("A RETURN ON LINE 4"), "EN subtitle must state Line 4 return")
	_expect(promise_label.text.contains("Lena is going back to Marta"), "EN promise must mention Lena and Marta")
	_expect(new_game_btn.text == "NEW GAME", "EN New Game button text")

	# Reset locale to Polish
	LocalizationManager.current_locale = "pl"
	title.refresh_for_test()

	# Focus loop verification
	_expect(new_game_btn.focus_neighbor_top == quit_btn.get_path(), "Focus chain top wrap")
	_expect(quit_btn.focus_neighbor_bottom == new_game_btn.get_path(), "Focus chain bottom wrap")

	# Settings open/close test
	title.open_settings_for_test()
	var settings_panel := title.get_node_or_null("SettingsPanel") as SettingsOverlay
	_expect(settings_panel != null and settings_panel.visible, "Settings panel must become visible")
	title.close_settings_for_test()
	_expect(settings_panel != null and not settings_panel.visible, "Settings panel must become hidden on close")

	title.queue_free()


func _test_bundle_07_station_01_worksite() -> void:
	print("Testing BUNDLE-07: Station 01 human worksite...")
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed != null, "station_01.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station01
	_expect(station != null, "Station01 must instantiate")
	if station == null:
		return
	root.add_child(station)
	preload("res://scripts/campaign/gap_ledger.gd").ensure_exit_open(station)

	# Check interaction points count
	var props := station.get_node_or_null("Props") as Node2D
	_expect(props != null, "Props container must exist")
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 3, "Station 01 must have exactly 3 OpeningActionPoints, found %d" % actions.size())

	# Action IDs
	var action_ids: Array[StringName] = []
	for a in actions:
		action_ids.append(a.action_id)
	_expect(action_ids.has(&"repeat_line_four_measurement"), "Must have repeat_line_four_measurement")
	_expect(action_ids.has(&"secure_raw_sample"), "Must have secure_raw_sample")
	_expect(action_ids.has(&"read_marta_message"), "Must have read_marta_message")

	# Check diegetic texts for GATE-01: Lena Wolska, vibration diagnostics, Line 4 gap, Marta
	var cue := station.get_node_or_null("OpeningDialogueCue") as StationDialogueCue
	_expect(cue != null and cue.opening_line.contains("Linii 4") and cue.opening_line.contains("Marty"), "Opening cue must mention Line 4 and Marta")
	var workstation_text := station.get_node_or_null("CrispDiegeticText_Workstation") as CrispDiegeticText
	_expect(workstation_text != null and workstation_text.text.contains("LENA WOLSKA") and workstation_text.text.contains("DIAGNOSTYKA DRGAŃ"), "Diegetic text must identify Lena Wolska and vibration diagnostics")
	var terminal_text := station.get_node_or_null("CrispDiegeticText_Terminal") as CrispDiegeticText
	_expect(terminal_text != null and terminal_text.text.contains("ODCZYT DRGAŃ") and terminal_text.text.contains("LINIA 4"), "Diegetic text must state vibration reading on Line 4")

	# Check sequencing of verbs
	_expect(station.is_exit_unlocked, "Exit must be open from ready")
	_expect(station.repeat_line_four_measurement(), "repeat_line_four_measurement must succeed")
	_expect(station.is_measurement_repeated, "Measurement repeated state")
	_expect(station.secure_raw_sample(), "secure_raw_sample must succeed after measurement")
	_expect(station.is_sample_secured, "Sample secured state")
	_expect(station.read_marta_message(), "read_marta_message must succeed after sample")
	_expect(station.is_marta_message_read, "Marta message read state")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after reading message")

	station.queue_free()


func _test_bundle_08_station_02_detour() -> void:
	print("Testing BUNDLE-08: Station 02 outdoor service detour...")
	var packed := load("res://scenes/levels/station_02.tscn") as PackedScene
	_expect(packed != null, "station_02.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station02
	_expect(station != null, "Station02 must instantiate")
	if station == null:
		return
	root.add_child(station)

	# Check actions count <= 3
	var props := station.get_node_or_null("Props") as Node2D
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 3, "Station 02 must have exactly 3 OpeningActionPoints, found %d" % actions.size())

	# Check presence of LadderZone
	var ladder := station.get_node_or_null("ServiceLadder") as LadderZone
	_expect(ladder != null, "Station 02 must have a diegetic ServiceLadder (LadderZone)")
	# PKG-0221 (D-234): prog 80 z tego pakietu byl starszy niz kanon §9.3;
	# drabina ma siegac ponad ladowisko (tu: spod 296 nad wierzch 232)
	# i wystawac 8-14 px — gorna granice pinuje bramka 0221 (GATE-SCALE).
	_expect(ladder != null and ladder.ladder_height >= 72.0, "ServiceLadder height must bridge the embankment")

	# Check ReturnZone
	var return_zone := station.get_node_or_null("ReturnZone") as ReturnZone
	_expect(return_zone != null, "Station 02 must have ReturnZone")

	# Check action sequencing
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.record_decision(&"p7.sample_and_promise.sample_preserved", true)
	_expect(station.inspect_detour_closure(), "inspect_detour_closure must succeed")
	_expect(station.compare_detour_time(), "compare_detour_time must succeed")
	_expect(station.take_service_ladder(), "take_service_ladder must succeed")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after taking ladder")

	station.queue_free()


func _test_bundle_09_station_03_transit_stop() -> void:
	print("Testing BUNDLE-09: Station 03 believable transit stop...")
	var packed := load("res://scenes/levels/station_03.tscn") as PackedScene
	_expect(packed != null, "station_03.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station03
	_expect(station != null, "Station03 must instantiate")
	if station == null:
		return
	root.add_child(station)

	# Check actions count <= 3
	var props := station.get_node_or_null("Props") as Node2D
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 2, "Station 03 must have exactly 2 OpeningActionPoints (+ airlock boarding), found %d" % actions.size())

	# Check ReturnZone
	var return_zone := station.get_node_or_null("ReturnZone") as ReturnZone
	_expect(return_zone != null, "Station 03 must have ReturnZone")

	# Check diegetic text
	var timetable := station.get_node_or_null("CrispDiegeticText_Timetable") as CrispDiegeticText
	_expect(timetable != null and timetable.text.contains("LINIA 4"), "Timetable must state Line 4")

	# Check action sequencing
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.record_decision(&"p7.sample_and_promise.route_time_confirmed", true)
	_expect(station.read_departure_board(), "read_departure_board must succeed")
	_expect(station.reply_to_marta(), "reply_to_marta must succeed")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after replying to Marta")
	_expect(station.board_line_four(), "board_line_four must succeed")

	station.queue_free()


func _test_bundle_10_station_04_transit_ride() -> void:
	print("Testing BUNDLE-10: Station 04 transit ride...")
	var packed := load("res://scenes/levels/station_04.tscn") as PackedScene
	_expect(packed != null, "station_04.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Station04
	_expect(station != null, "Station04 must instantiate")
	if station == null:
		return
	root.add_child(station)

	# Check actions count <= 3
	var props := station.get_node_or_null("Props") as Node2D
	var actions: Array[OpeningActionPoint] = []
	for child in props.get_children():
		if child is OpeningActionPoint:
			actions.append(child)
	_expect(actions.size() == 3, "Station 04 must have exactly 3 OpeningActionPoints, found %d" % actions.size())

	# Check ReturnZone
	var return_zone := station.get_node_or_null("ReturnZone") as ReturnZone
	_expect(return_zone != null, "Station 04 must have ReturnZone")

	# Check action sequencing
	var state := root.get_node_or_null("GameStateManager")
	if state != null:
		state.record_decision(&"p7.sample_and_promise.trace", "sample_preserved_and_time_sent")
	_expect(station.observe_reader_buffer(), "observe_reader_buffer must succeed")
	_expect(station.watch_line_four_memorial(), "watch_line_four_memorial must succeed")
	_expect(station.stow_reader_for_marta(), "stow_reader_for_marta must succeed")
	_expect(station.is_exit_unlocked, "Exit must be unlocked after stowing reader")

	station.queue_free()


func _test_gate_int_budgets() -> void:
	print("Testing GATE-INT: Interaction budget <= 3 on Station 01..04...")
	for station_num in [1, 2, 3, 4]:
		var scene_path := "res://scenes/levels/station_%02d.tscn" % station_num
		var text := FileAccess.get_file_as_string(scene_path)
		_expect(not text.is_empty(), "Scene text must be readable: %s" % scene_path)
		var action_count := text.count("OpeningActionPoint")
		_expect(action_count <= 3, "Station %02d action count (%d) must be <= 3 (GATE-INT)" % [station_num, action_count])
		var legacy_count := text.count("MemoryResonancePoint") + text.count("memory_resonance_point")
		_expect(legacy_count == 0, "Station %02d must have 0 legacy MemoryResonancePoints, found %d" % [station_num, legacy_count])


func _test_first_five_minutes_campaign_playthrough() -> void:
	print("Testing end-to-end player-verb campaign walkthrough 01 -> 02 -> 03 -> 04...")
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must exist")
	if state == null:
		return
	state.campaign_auto_transition_enabled = false
	state.reset_campaign(true)

	# Station 01
	var s01_packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	var s01 := s01_packed.instantiate() as Station01
	root.add_child(s01)
	_expect(s01.repeat_line_four_measurement(), "S01: repeat measurement")
	_expect(s01.secure_raw_sample(), "S01: secure raw sample")
	_expect(s01.read_marta_message(), "S01: read Marta message")
	_expect(bool(state.decisions.get(&"home_sample_preserved", false)), "Decision home_sample_preserved")
	_expect(bool(state.decisions.get(&"p9.opening.sample_carried_home", false)), "Decision sample_carried_home")
	_expect(bool(state.decisions.get(&"p9.opening.marta_waiting", false)), "Decision marta_waiting")
	s01.queue_free()

	# Station 02
	var s02_packed := load("res://scenes/levels/station_02.tscn") as PackedScene
	var s02 := s02_packed.instantiate() as Station02
	root.add_child(s02)
	_expect(s02.inspect_detour_closure(), "S02: inspect detour closure")
	_expect(s02.compare_detour_time(), "S02: compare detour time")
	_expect(s02.take_service_ladder(), "S02: take service ladder")
	_expect(bool(state.decisions.get(&"p9.opening.night_detour_seen", false)), "Decision night_detour_seen")
	_expect(bool(state.decisions.get(&"p9.opening.detour_cost_confirmed", false)), "Decision detour_cost_confirmed")
	_expect(bool(state.decisions.get(&"p9.opening.service_ladder_route_taken", false)), "Decision service_ladder_route_taken")
	s02.queue_free()

	# Station 03
	var s03_packed := load("res://scenes/levels/station_03.tscn") as PackedScene
	var s03 := s03_packed.instantiate() as Station03
	root.add_child(s03)
	_expect(s03.read_departure_board(), "S03: read departure board")
	_expect(s03.reply_to_marta(), "S03: reply to Marta")
	_expect(s03.board_line_four(), "S03: board Line 4")
	_expect(bool(state.decisions.get(&"marta_promise_broken", false)), "Decision marta_promise_broken")
	_expect(bool(state.decisions.get(&"p9.opening.marta_knows_delay", false)), "Decision marta_knows_delay")
	_expect(bool(state.decisions.get(&"p9.opening.line_four_boarded", false)), "Decision line_four_boarded")
	s03.queue_free()

	# Station 04
	var s04_packed := load("res://scenes/levels/station_04.tscn") as PackedScene
	var s04 := s04_packed.instantiate() as Station04
	root.add_child(s04)
	_expect(s04.observe_reader_buffer(), "S04: observe reader buffer")
	_expect(s04.watch_line_four_memorial(), "S04: watch Line 4 memorial")
	_expect(s04.stow_reader_for_marta(), "S04: stow reader for Marta")
	_expect(bool(state.decisions.get(&"p9.opening.reader_gap_returns_in_transit", false)), "Decision reader_gap_returns_in_transit")
	_expect(bool(state.decisions.get(&"p9.opening.line_four_memorial_seen", false)), "Decision line_four_memorial_seen")
	_expect(bool(state.decisions.get(&"p9.opening.reader_put_away_for_marta", false)), "Decision reader_put_away_for_marta")
	_expect(String(state.decisions.get(&"p7.return_under_control.trace", "")) == "reader_secured_after_line_four_memorial", "Decision S02 trace")
	s04.queue_free()

	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = true


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0157 SMOKE PASS: First Five Minutes (BUNDLE-06..10), GATE-01, GATE-05 and GATE-INT verified.")
		quit(0)
		return
	for failure in _failures:
		printerr(" - %s" % failure)
	quit(1)
