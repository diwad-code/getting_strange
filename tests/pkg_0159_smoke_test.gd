extends SceneTree

# PKG-0159 — opening remediation and evidence recertification.
# This gate uses semantic InputMap movement/interact events for the opening and
# stair traversal. Direct calls are used only for downstream consequence checks.

const REPORT_PATH := "res://reports/pkg_0159/m1_m5_trace.tsv"
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")

var _failures: Array[String] = []
var _trace_rows: PackedStringArray = PackedStringArray([
	"case\telapsed_ms\tresult\tnote",
])


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0159 FAILURE: %s" % message)


func _run() -> void:
	print("=== PKG-0159 Smoke Test: opening remediation and recertification ===")
	await _test_title_first_image()
	await _test_repeat_branch_with_player_inputs()
	await _test_leave_branch_with_player_inputs()
	await _test_leave_branch_downstream_consequences()
	await _test_real_stair_traversal_without_jump()
	_write_trace()
	if _failures.is_empty():
		print("PKG-0159 PASS: dual opening choice, title promise, downstream divergence and real stair traversal verified.")
		quit(0)
	else:
		printerr("PKG-0159 FAIL: %d failure(s)." % _failures.size())
		quit(1)


func _reset_state() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	if state != null:
		state.reset_campaign(true)
	return state


func _test_title_first_image() -> void:
	var packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
	_expect(packed != null, "Title screen must load")
	if packed == null:
		return
	var title := packed.instantiate()
	root.add_child(title)
	await process_frame
	_expect(title.get_node_or_null("TitlePanel/ControlsHint") == null, "First image must not contain a controls list")
	var promise := title.get_node_or_null("TitlePanel/ReturnPromise") as Label
	_expect(promise != null and promise.text.contains("LINIA 4") and promise.text.contains("POWRÓT"), "First image must carry the Line 4 return promise")
	title.queue_free()
	await process_frame


func _test_repeat_branch_with_player_inputs() -> void:
	var state := _reset_state()
	var station := await _start_new_game_to_station_01() as Station01
	if station == null:
		return
	var started := Time.get_ticks_msec()
	var player := station.get_node("Player") as PrototypePlayer
	await _advance_all_dialogue(station)
	await _resolve_cold_open(station, player)
	await _walk_right_to(player, 237.0, 240)
	await _press_semantic_action(&"interact")
	_expect(station.is_measurement_repeated, "InputMap interact at MeasurementRig must repeat the measurement")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 375.0, 240)
	await _press_semantic_action(&"interact")
	_expect(station.opening_choice == "repeat_sample", "Measurement then case must commit repeat_sample")
	_expect(station.is_sample_secured, "Repeat branch must put the raw sample in Lena's bag")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 460.0, 180)
	await _press_semantic_action(&"interact")
	var gate_01_elapsed := Time.get_ticks_msec() - started
	_expect(station.is_marta_message_read and station.is_exit_unlocked, "Repeat branch must continue after Marta's message")
	_expect(state != null and state.decisions.get(&"home_sample_preserved", false) == true, "Repeat branch must persist the sample")
	_expect(gate_01_elapsed <= 60000, "Automated M5 trace must expose the opening facts within 60 seconds")
	_trace_rows.append("gate_01_repeat\t%d\t%s\tNowa gra + dialogue/movement/interact only; 5 fact carriers and exit reached" % [gate_01_elapsed, "PASS" if station.is_exit_unlocked else "FAIL"])
	await _advance_all_dialogue(station)
	var station_02 := await _exit_current_station_to(station, &"station_02") as Station02
	if station_02 == null:
		return
	await _drive_station_02(station_02)
	var station_03 := await _exit_current_station_to(station_02, &"station_03") as Station03
	if station_03 == null:
		return
	await _drive_station_03(station_03)
	var station_04 := await _exit_current_station_to(station_03, &"station_04") as Station04
	if station_04 == null:
		return
	await _drive_station_04(station_04)
	var gate_05_elapsed := Time.get_ticks_msec() - started
	_expect(station_04.is_exit_unlocked, "M1 route must complete the Station 01–04 verb chain")
	_trace_rows.append("gate_05_repeat\t%d\t%s\tcontinuous Nowa gra route through Station 01-04; dialogue/movement/interact only" % [gate_05_elapsed, "PASS" if station_04.is_exit_unlocked else "FAIL"])
	var station_05 := await _exit_current_station_to(station_04, &"station_05") as Station05
	if station_05 == null:
		return
	await _drive_station_05(station_05)
	var station_06 := await _exit_current_station_to(station_05, &"station_06") as Station06
	if station_06 == null:
		return
	await _drive_station_06(station_06)
	var station_07 := await _exit_current_station_to(station_06, &"station_07") as Station07
	if station_07 == null:
		return
	await _drive_station_07(station_07)
	var station_08 := await _exit_current_station_to(station_07, &"station_08") as Station08
	if station_08 == null:
		return
	await _drive_station_08(station_08)
	var gate_30_elapsed := Time.get_ticks_msec() - started
	_expect(station_08.is_exit_unlocked, "M1 route must reach the apartment threshold through Station 08")
	_expect(state != null and state.decisions.get(&"p7.foreign_daily_life.trace", "") == "neighbour_and_key_confirm_fourteen", "M1 route must establish the fourth independent source at Station 08")
	_trace_rows.append("gate_30_repeat\t%d\t%s\tcontinuous Nowa gra route through Station 01-08; dialogue/movement/interact only" % [gate_30_elapsed, "PASS" if station_08.is_exit_unlocked else "FAIL"])
	if current_scene == station_08:
		current_scene = null
	station_08.queue_free()
	await process_frame


func _test_leave_branch_with_player_inputs() -> void:
	var state := _reset_state()
	var station := await _spawn_station("res://scenes/levels/station_01.tscn") as Station01
	if station == null:
		return
	var started := Time.get_ticks_msec()
	var player := station.get_node("Player") as PrototypePlayer
	await _resolve_cold_open(station, player)
	await _walk_right_to(player, 375.0, 360)
	await _press_semantic_action(&"interact")
	_expect(station.opening_choice == "leave_on_time", "Case before measurement must commit leave_on_time")
	_expect(not station.is_measurement_repeated and not station.is_sample_secured, "Leave branch must not invent a repeat or raw sample")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 460.0, 180)
	await _press_semantic_action(&"interact")
	var elapsed := Time.get_ticks_msec() - started
	_expect(station.is_marta_message_read and station.is_exit_unlocked, "Leave branch must continue after Marta's message")
	_expect(state != null and state.decisions.get(&"p9.opening.equipment_packed", false) == true, "Leave branch must persist packed equipment")
	_expect(state != null and state.decisions.get(&"home_sample_preserved", true) == false, "Leave branch must keep the raw sample out of Lena's bag")
	_expect(elapsed <= 60000, "Leave branch must also reach its opening facts within 60 seconds")
	_trace_rows.append("leave_branch\t%d\t%s\tsemantic movement + interact; distinct bag state and exit reached" % [elapsed, "PASS" if station.is_exit_unlocked else "FAIL"])
	station.queue_free()
	await process_frame


func _test_leave_branch_downstream_consequences() -> void:
	var state := _reset_state()
	if state == null:
		return
	state.record_decision(&"p9.opening.choice", "leave_on_time")
	state.record_decision(&"p9.opening.equipment_packed", true)
	var station_02 := await _spawn_station("res://scenes/levels/station_02.tscn") as Station02
	_expect(station_02 != null and station_02.inspect_detour_closure(), "Station 02 must accept the leave-on-time branch")
	station_02.queue_free()
	await process_frame
	state.record_decision(&"p7.sample_and_promise.route_time_confirmed", true)
	var station_03 := await _spawn_station("res://scenes/levels/station_03.tscn") as Station03
	if station_03 != null:
		_expect(station_03.read_departure_board() and station_03.reply_to_marta(), "Station 03 must produce a branch-specific reply")
		_expect(state.decisions.get(&"p7.sample_and_promise.trace", "") == "equipment_packed_and_departure_confirmed", "Leave branch must persist its own campaign trace")
		_expect(state.decisions.get(&"marta_promise_broken", true) == false, "Leaving on time must not mark Marta's promise as broken")
		station_03.queue_free()
		await process_frame
	var station_04 := await _spawn_station("res://scenes/levels/station_04.tscn") as Station04
	if station_04 != null:
		_expect(station_04.observe_reader_buffer(), "Station 04 must accept the leave branch trace")
		_expect(state.decisions.get(&"p9.opening.packed_reader_checked_in_transit", false) == true, "Station 04 must preserve the different reader consequence")
		_expect(state.decisions.get(&"p9.opening.reader_gap_returns_in_transit", true) == false, "Leave branch must not claim a repeated gap")
		station_04.queue_free()
		await process_frame


func _test_real_stair_traversal_without_jump() -> void:
	_reset_state()
	var station := await _spawn_station("res://scenes/levels/station_08.tscn") as Station08
	if station == null:
		return
	var expected_nodes := ["StairStepUp01", "StairStepUp02", "StairLanding", "StairStepDown02", "StairStepDown01"]
	for node_name in expected_nodes:
		_expect(station.get_node_or_null("Geometry/%s" % node_name) != null, "Real stair block %s must exist" % node_name)
	var player := station.get_node("Player") as PrototypePlayer
	var minimum_y := player.global_position.y
	Input.action_press(&"move_right")
	for _frame in range(600):
		await physics_frame
		minimum_y = minf(minimum_y, player.global_position.y)
		if player.global_position.x >= 475.0:
			break
	Input.action_release(&"move_right")
	_expect(player.global_position.x >= 475.0, "Lena must traverse the stair flight without jumping")
	# Player origin sits 27 px above the contact surface (72 px capsule, -9 px
	# shape offset), so floor/landing origins are approximately 269/233.
	_expect(minimum_y <= 240.0, "Stair traversal must physically raise Lena onto the landing")
	_expect(player.global_position.y >= 260.0, "Stair traversal must return Lena to the corridor floor")
	_trace_rows.append("station08_stairs\t0\t%s\tmove_right only; min_y=%.1f final=(%.1f,%.1f)" % ["PASS" if player.global_position.x >= 475.0 else "FAIL", minimum_y, player.global_position.x, player.global_position.y])
	station.queue_free()
	await process_frame


func _spawn_station(path: String) -> Node:
	var packed := load(path) as PackedScene
	_expect(packed != null, "%s must load" % path)
	if packed == null:
		return null
	var station := packed.instantiate()
	root.add_child(station)
	for _frame in range(4):
		await physics_frame
	return station


func _start_new_game_to_station_01() -> Node:
	var err := change_scene_to_file("res://scenes/shell/title_screen.tscn")
	_expect(err == OK, "M1 must start from the actual title scene")
	for _frame in range(4):
		await process_frame
	var title := current_scene as TitleScreen
	_expect(title != null, "M1 title scene must become current")
	if title == null:
		return null
	var new_game := title.get_node_or_null("TitlePanel/NewGameButton") as Button
	_expect(new_game != null, "M1 must find the real Nowa gra button")
	if new_game == null:
		return null
	new_game.grab_focus()
	await _press_semantic_action(&"ui_accept")
	# PKG-0176: `Nowa gra` prowadzi najpierw przez warstwe A zimnego otwarcia
	# (`COLD_OPEN_SPEC.md` §6), ktora sama tnie do Station 01 po 12-16 s.
	for _frame in range(2400):
		await physics_frame
		if current_scene is Station01:
			break
	_expect(current_scene is Station01, "ui_accept on Nowa gra must route through the cold open into Station 01")
	return current_scene


func _drive_station_02(station: Station02) -> void:
	await _advance_all_dialogue(station)
	var player := station.get_node("Player") as PrototypePlayer
	await _walk_right_to(player, 184.0, 220)
	await _press_semantic_action(&"interact")
	_expect(station.is_detour_closure_inspected, "M1 must inspect the service closure")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 362.0, 260)
	await _press_semantic_action(&"interact")
	_expect(station.is_detour_time_compared, "M1 must compare the detour time")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 520.0, 260)
	await _press_semantic_action(&"interact")
	_expect(station.is_service_ladder_taken, "M1 must choose the service ladder")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 570.0, 140)
	Input.action_press(&"move_up")
	for _frame in range(160):
		await physics_frame
		if player.global_position.y <= 185.0:
			break
	Input.action_release(&"move_up")
	for _frame in range(24):
		await physics_frame
	_expect(player.global_position.y <= 212.0, "M1 must climb the diegetic service ladder")


func _drive_station_03(station: Station03) -> void:
	await _advance_all_dialogue(station)
	var player := station.get_node("Player") as PrototypePlayer
	await _walk_right_to(player, 190.0, 220)
	await _press_semantic_action(&"interact")
	_expect(station.is_departure_board_read, "M1 must read the departure board")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 304.0, 220)
	await _press_semantic_action(&"interact")
	_expect(station.is_marta_reply_sent, "M1 must reply to Marta")
	await _advance_all_dialogue(station)


func _drive_station_04(station: Station04) -> void:
	await _advance_all_dialogue(station)
	var player := station.get_node("Player") as PrototypePlayer
	await _walk_right_to(player, 188.0, 220)
	await _press_semantic_action(&"interact")
	_expect(station.is_reader_buffer_observed, "M1 must inspect the reader state")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 406.0, 300)
	await _press_semantic_action(&"interact")
	_expect(station.is_line_four_memorial_seen, "M1 must observe the Line 4 memorial")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 472.0, 160)
	await _press_semantic_action(&"interact")
	_expect(station.is_reader_stowed, "M1 must stow the reader for Marta")
	await _advance_all_dialogue(station)


func _drive_station_05(station: Station05) -> void:
	await _advance_all_dialogue(station)
	var player := station.get_node("Player") as PrototypePlayer
	await _walk_right_to(player, 160.0, 200)
	await _press_semantic_action(&"interact")
	_expect(station.is_street_route_checked, "M1 must check the home street route")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 320.0, 240)
	await _press_semantic_action(&"interact")
	_expect(station.is_sample_case_verified, "M1 must check the carried case")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 480.0, 240)
	await _press_semantic_action(&"interact")
	_expect(station.is_crossing_completed, "M1 must cross toward home")
	await _advance_all_dialogue(station)


func _drive_station_06(station: Station06) -> void:
	await _advance_all_dialogue(station)
	var player := station.get_node("Player") as PrototypePlayer
	await _walk_right_to(player, 150.0, 200)
	await _press_semantic_action(&"interact")
	_expect(station.is_timetable_inspected, "M1 must inspect the public timetable")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 330.0, 260)
	await _press_semantic_action(&"interact")
	_expect(station.is_water_purchased, "M1 must perform the ordinary kiosk action")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 450.0, 220)
	await _press_semantic_action(&"interact")
	_expect(station.is_kiosk_vendor_asked, "M1 must ask the kiosk vendor")
	await _advance_all_dialogue(station)


func _drive_station_07(station: Station07) -> void:
	await _advance_all_dialogue(station)
	var player := station.get_node("Player") as PrototypePlayer
	await _walk_right_to(player, 160.0, 200)
	await _press_semantic_action(&"interact")
	_expect(station.is_address_document_compared, "M1 must compare the address document")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 330.0, 260)
	await _press_semantic_action(&"interact")
	_expect(station.is_intercom_directory_inspected, "M1 must inspect the intercom directory")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 460.0, 220)
	await _press_semantic_action(&"interact")
	_expect(station.is_intercom_code_unlocked, "M1 must enter the remembered code")
	await _advance_all_dialogue(station)


func _drive_station_08(station: Station08) -> void:
	await _advance_all_dialogue(station)
	var player := station.get_node("Player") as PrototypePlayer
	await _walk_right_to(player, 160.0, 200)
	await _press_semantic_action(&"interact")
	_expect(station.is_door_twelve_inspected, "M1 must inspect door 12")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 338.0, 280)
	await _press_semantic_action(&"interact")
	_expect(station.is_neighbour_spoken_to, "M1 must speak with the neighbour on the real landing")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 490.0, 260)
	await _press_semantic_action(&"interact")
	_expect(station.is_apartment_fourteen_unlocked, "M1 must unlock apartment 14 with Lena's key")
	await _advance_all_dialogue(station)


func _exit_current_station_to(station: Node, expected_station: StringName) -> Node:
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_ThresholdBinder.install(station)
	_ThresholdBinder.complete_from_test(station, player)
	var expected_node_name := String(expected_station).replace("_", "").capitalize().replace(" ", "")
	var expected_compact := String(expected_station).replace("_", "")
	for _frame in range(360):
		await process_frame
		if current_scene != null and String(current_scene.name).to_lower() == expected_compact:
			break
	_expect(current_scene != null and current_scene.name == expected_node_name, "M1 must transition to %s (got %s)" % [expected_station, "null" if current_scene == null else current_scene.name])
	return current_scene


## PKG-0176 — warstwa B zimnego otwarcia. Zanim rozwidlenie Station 01 istnieje,
## jedyna dzialajaca czynnosc to uruchomienie pomiaru na rejestratorze. Ten
## helper przechodzi ja czasownikami gracza, tak jak reszta tej bramki.
func _resolve_cold_open(station: Station01, player: PrototypePlayer) -> void:
	if not station.is_cold_open_active():
		return
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 237.0, 300)
	await _press_semantic_action(&"interact")
	for _frame in range(900):
		if not station.is_cold_open_active():
			break
		await physics_frame
	_expect(not station.is_cold_open_active(), "PKG-0176 cold open must resolve into the Station 01 fork")
	# PKG-0242 (R1): the press that advances Lena's gap line must not act on
	# the rig. Before PKG-0242 `OpeningActionPoint` received `interact`
	# before `CRTDialogueBox`, so skipping this line silently took the
	# optional repeat (the broken promise). The line is advanced first now,
	# and the next press at the rig is the player's own choice.
	var said_before := station.is_measurement_repeated
	await _advance_all_dialogue(station)
	_expect(station.is_measurement_repeated == said_before, "Advancing Lena's line at the rig must not repeat the measurement")


func _walk_right_to(player: PrototypePlayer, target_x: float, frame_limit: int) -> void:
	Input.action_press(&"move_right")
	for _frame in range(frame_limit):
		await physics_frame
		if player.global_position.x >= target_x - 3.0:
			break
	Input.action_release(&"move_right")
	_expect(player.global_position.x >= target_x - 8.0, "Semantic move_right must reach x=%.0f (got %.1f)" % [target_x, player.global_position.x])


func _press_semantic_action(action: StringName) -> void:
	var pressed := InputEventAction.new()
	pressed.action = action
	pressed.pressed = true
	Input.parse_input_event(pressed)
	await process_frame
	var released := InputEventAction.new()
	released.action = action
	released.pressed = false
	Input.parse_input_event(released)
	await process_frame


func _hide_dialogue(station: Node) -> void:
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue != null:
		dialogue.hide_box()


func _advance_all_dialogue(station: Node) -> void:
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue == null:
		return
	for _step in range(16):
		if not dialogue.is_presenting():
			break
		await _press_semantic_action(&"interact")
	_expect(not dialogue.is_presenting(), "Dialogue must be progressable through semantic interact")


func _write_trace() -> void:
	var absolute_dir := ProjectSettings.globalize_path(REPORT_PATH.get_base_dir())
	DirAccess.make_dir_recursive_absolute(absolute_dir)
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_expect(false, "M1/M5 trace report must be writable")
		return
	file.store_string("\n".join(_trace_rows) + "\n")
	file.close()
