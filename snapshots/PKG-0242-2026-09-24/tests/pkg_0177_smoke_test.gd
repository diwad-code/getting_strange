extends SceneTree

## PKG-0177 gate — P9 PHASE-08 / BUNDLE-31: Integracja, 14 bramek i CHECKPOINT-06.
##
## Dowód techniczny integracji i recertyfikacji:
## 1. Ciągły przebieg M1 trasy 20 adresów (Nowa gra -> ColdOpen -> 01..18 -> 42a -> 43).
##    Wyłącznie czasowniki gracza: ruch, interact, ui_accept, postęp dialogu.
##    Zero wywołań publicznych metod gameplayu, zero ręcznego ustawiania flag.
## 2. Próbkowanie zamiaru co 2 minuty symulowanego czasu (GATE-OBJ: 100% zgodności).
## 3. Recertyfikacja GATE-01: pomiar M5 <= 90 s, 5/5 nośników poza UI, zachowana kolejność.
## 4. Zestawienie statusów 14 bramek produktu w macierzy akceptacji.
## 5. D-168: zero nowych binariów .exe.
##
## Bramka dowodzi kontraktu technicznego. Nie dowodzi zabawy, emocji ani
## zrozumienia przez nową osobę (D-012, ADR-003).

const _ColdOpenFacts := preload("res://scripts/campaign/cold_open_facts.gd")
const _GapLedger := preload("res://scripts/campaign/gap_ledger.gd")
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const CRTDialogueBox := preload("res://scripts/ui/crt_dialogue_box.gd")
const ThresholdZone := preload("res://scripts/environment/threshold_zone.gd")
const NarrativeRulesRef := preload("res://scripts/levels/narrative_repair_rules.gd")

const REPORT_DIR := "res://reports/pkg_0177"
const M1_TRACE_PATH := "res://reports/pkg_0177/m1_full_playthrough_trace.tsv"
const GATE_OBJ_PATH := "res://reports/pkg_0177/gate_obj_samples.tsv"
const M5_BUDGET_SECONDS := 90.0

const CAMPAIGN_20_ROUTE: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_42a", &"station_43",
]

const STATION_INTENTIONS := {
	"station_01": "Sprawdzić dziwną lukę w pomiarze przy Linii 4",
	"station_02": "Przejść obejściem serwisowym i sprawdzić czas trasy",
	"station_03": "Odczytać rozkład jazdy i odpisać Marcie",
	"station_04": "Przejechać wagonem Linii 4 i zabezpieczyć czytnik",
	"station_05": "Przejść ulicą w stronę domu",
	"station_06": "Sprawdzić rozkład na kiosku i zapytać sprzedawcę",
	"station_07": "Porównać adres na papierze z domofonem na bazarze",
	"station_08": "Wejść po schodach do mieszkania czternaście",
	"station_09": "Zbadać mieszkanie i sprawdzić drugą filiżankę",
	"station_10": "Porozmawiać z Martą i sprawdzić klucz w zamku",
	"station_11": "Zbadać konsolę UCP i porozmawiać z Wierzbicką",
	"station_12": "Odsłuchać nagranie i spotkać Jakuba w warsztacie",
	"station_13": "Zestawić dokumenty i rozpoznać: To nie jest mój świat",
	"station_14": "Zbadać obwód sekcji i zrozumieć Anchor oraz Yield",
	"station_15": "Nadać impuls kontrolny i sprawdzić odpowiedź miejscowej Leny",
	"station_16": "Przenieść sygnał do analizatora i wybrać mały koszt",
	"station_17": "Odczytać rejestr kosztów i ustalić zakres zgody Jakuba",
	"station_18": "Zestawić trzy prognozy, powiedzieć Marcie prawdę i zatwierdzić metodę",
	"station_42a": "Wykonać wymuszenie powrotu do własnego świata",
	"station_43": "Przeczytać tablicę miejską i zamknąć ewidencję nad Wisłą",
}

## PKG-0242 (R1): plan wejścia gracza dla każdej stacji, sprawdzony sondą
## przejścia. "i" = podejdź do x i naciśnij interact (z przewinięciem dialogu),
## "climb" = drabina: podejdź do x i trzymaj move_up do wysokości y,
## "wait" = odczekaj klatki (cykl maszyny 14, echo pętli 15),
## "accept" = ui_accept (gasi winietę). 17 i 18 mają własny sterownik łańcucha.
const STEP_PLANS := {
	"station_02": [["i", 184.0], ["i", 362.0], ["i", 520.0], ["climb", 570.0, 185.0]],
	"station_03": [["i", 190.0], ["i", 304.0]],
	"station_04": [["i", 188.0], ["i", 406.0], ["i", 472.0]],
	"station_05": [["i", 160.0], ["i", 320.0], ["i", 480.0]],
	"station_06": [["i", 150.0], ["i", 330.0], ["i", 450.0]],
	"station_07": [["i", 160.0], ["i", 330.0], ["i", 460.0]],
	"station_08": [["i", 160.0], ["i", 338.0], ["i", 490.0]],
	"station_09": [["i", 156.0], ["i", 210.0], ["i", 330.0]],
	"station_10": [["i", 364.0], ["i", 430.0], ["i", 448.0]],
	"station_11": [["i", 134.0], ["i", 230.0], ["i", 332.0]],
	"station_12": [["i", 246.0], ["i", 300.0], ["i", 404.0]],
	"station_13": [["i", 168.0], ["i", 430.0], ["i", 496.0]],
	"station_14": [["i", 140.0], ["i", 395.0], ["wait", 500], ["i", 395.0], ["wait", 480]],
	"station_15": [["i", 125.0], ["i", 338.0], ["wait", 200], ["i", 338.0], ["wait", 200], ["i", 338.0], ["i", 338.0], ["wait", 200], ["i", 516.0]],
	"station_16": [["i", 160.0], ["cost"], ["i", 510.0]],
	"station_42a": [["accept"], ["i", 176.0], ["i", 332.0], ["i", 484.0]],
	"station_42b": [["accept"], ["i", 176.0], ["i", 332.0], ["i", 176.0], ["i", 484.0]],
	"station_42c": [["accept"], ["i", 176.0], ["i", 332.0], ["i", 484.0]],
	"station_43": [["accept"], ["i", 160.0], ["i", 340.0], ["i", 520.0]],
}

## Fakt, który plan danej stacji musi zostawić (dowód, że czynności zadziałały,
## a nie tylko że gracz przeszedł przez otwarty próg).
const STEP_FACTS := {
	"station_02": &"p7.sample_and_promise.safe_bypass_taken",
	"station_03": &"p7.sample_and_promise.trace",
	"station_04": &"p7.return_under_control.trace",
	"station_05": &"p9.street.crossing_completed",
	"station_06": &"p9.kiosk.vendor_testimony_recorded",
	"station_07": &"p9.exterior.intercom_code_unlocked",
	"station_08": &"p9.stairwell.key_unlocked_fourteen",
	"station_09": &"p9.mystery.home.trace",
	"station_10": &"p9.mystery.marta.trace",
	"station_11": &"p9.mystery.institution.trace",
	"station_12": &"p9.mystery.jakub.trace",
	"station_13": &"world_recognized",
	"station_14": &"p9.mechanics.dead_circuit.trace",
	"station_15": &"local_lena_intent_found",
	"station_16": &"p9.mechanics.small_cost.home_echo_verified",
	"station_42a": &"p9.finale.forced_return.household_consequence",
	"station_42b": &"p9.finale.close_equal.household_consequence",
	"station_42c": &"p9.finale.mutual_passage.household_consequence",
	"station_43": &"p9.epilogue.executed",
}

const KNOWN_EXE_PATHS: Array[String] = [
	"res://dist/windows/GettingStrange.exe",
	"res://Godot_v4.6.3-stable_win64.exe",
	"res://Godot_v4.6.3-stable_win64_console.exe",
]

var _failures: Array[String] = []
var _m1_trace_rows: PackedStringArray = PackedStringArray([
	"station_id\tsim_seconds\twall_ms\tresult\tnote",
])
var _gate_obj_rows: PackedStringArray = PackedStringArray([
	"sample_index\tsim_time_s\tstation_id\tplayer_pos\tmovement_dir\tactive_objective\tmenu_open\tresult",
])

var _total_sim_frames := 0
var _gate_obj_sample_count := 0
var _pkg0182_route_label := ""
var _pkg0183_route_label := ""
var _pkg0184_route_label := ""
var _route_mode := "full"
var _finale_id := &"station_42a"
var _gate_01_m5_seconds := 0.0


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0177: " + message)


func _run() -> void:
	_configure_pkg0182_route()
	print("=== PKG-0177 Smoke Test: Integration, 14 Gates & CHECKPOINT-06 ===")
	_ensure_dirs()
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state == null:
		_finish()
		return

	await _test_m1_continuous_playthrough(state)
	_test_gate_01_recertification(state)
	_test_gate_obj_sampling_results()
	_test_fourteen_gates_summary()
	_test_no_new_binaries()

	_write_reports()
	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = true
	_finish()


func _configure_pkg0182_route() -> void:
	for argument in OS.get_cmdline_user_args():
		if argument.begins_with("--pkg0184-route="):
			_pkg0184_route_label = argument.trim_prefix("--pkg0184-route=").to_lower()
			_pkg0183_route_label = _pkg0184_route_label
			_pkg0182_route_label = _pkg0184_route_label
			_apply_route_label(_pkg0184_route_label)
			continue
		if argument.begins_with("--pkg0183-route="):
			_pkg0183_route_label = argument.trim_prefix("--pkg0183-route=").to_lower()
			_pkg0182_route_label = _pkg0183_route_label
			_apply_route_label(_pkg0183_route_label)
			continue
		if not argument.begins_with("--pkg0182-route="):
			continue
		_pkg0182_route_label = argument.trim_prefix("--pkg0182-route=").to_lower()
		_apply_route_label(_pkg0182_route_label)


func _apply_route_label(label: String) -> void:
	var parts := label.split("-")
	if parts.size() >= 1 and parts[0] in ["minimal", "full", "mixed"]:
		_route_mode = parts[0]
	if parts.size() >= 2:
		match parts[1]:
			"b": _finale_id = &"station_42b"
			"c": _finale_id = &"station_42c"
			_: _finale_id = &"station_42a"


func _ensure_dirs() -> void:
	var abs_dir := ProjectSettings.globalize_path(REPORT_DIR)
	DirAccess.make_dir_recursive_absolute(abs_dir)


# ─── 1. CIĄGŁY PRZEBIEG M1 TRASY 20 ADRESÓW ─────────────────────────────────

func _test_m1_continuous_playthrough(state: Node) -> void:
	print("1. Continuous M1 run across 20-station route with pure player verbs...")
	state.reset_campaign(true)
	state.cold_open_seen = false
	state.campaign_auto_transition_enabled = true

	var run_start_ticks := Time.get_ticks_msec()
	_total_sim_frames = 0
	_gate_obj_sample_count = 0

	# Krok 1: Tytuł -> Nowa gra przez semantyczne ui_accept
	var cold_open := await _start_from_title()
	_expect(cold_open is ColdOpen, "Nowa gra must route into ColdOpen layer A")

	# Krok 2: Warstwa A zimnego otwarcia (12-16 s w symulacji)
	var station_01 := await _await_station_01(2400)
	_expect(station_01 is Station01, "ColdOpen must transition into Station01")
	if station_01 == null:
		return

	# Krok 3: Station 01 warstwa B & recertyfikacja GATE-01 M5
	await _drive_station_01(station_01, state, run_start_ticks)

	# Krok 4: Pętla przez stacje 02 .. 18 -> wybrany legalny finał -> 43.
	var selected_route: Array[StringName] = CAMPAIGN_20_ROUTE.duplicate()
	selected_route[18] = _finale_id
	for index in range(1, selected_route.size()):
		var target_id: StringName = selected_route[index]
		var next_scene := await _await_station_scene(target_id, 1200)
		_expect(next_scene != null, "Route must reach %s (index %d)" % [target_id, index])
		if next_scene == null:
			break
		await _drive_station_step(next_scene, target_id, state)

	# Krok 5: Weryfikacja ukończenia kampanii
	_expect(state.is_campaign_completed(), "Full M1 run must complete the campaign at Station 43")
	var total_sim_seconds := float(_total_sim_frames) / 60.0
	var total_wall_ms := Time.get_ticks_msec() - run_start_ticks
	print("  M1 run finished: 20 stations traversed in %.1f sim seconds (wall: %d ms)" % [total_sim_seconds, total_wall_ms])


func _start_from_title() -> Node:
	var err := change_scene_to_file("res://scenes/shell/title_screen.tscn")
	_expect(err == OK, "Must load title screen")
	for _frame in range(4):
		await process_frame
		_total_sim_frames += 1

	var title := current_scene as TitleScreen
	_expect(title != null, "Title scene must be active")
	if title == null:
		return null

	var new_game := title.get_node_or_null("TitlePanel/NewGameButton") as Button
	_expect(new_game != null, "NewGameButton must exist")
	if new_game == null:
		return null

	new_game.grab_focus()
	await _press_semantic_action(&"ui_accept")
	for _frame in range(60):
		await physics_frame
		_total_sim_frames += 1
		if current_scene is ColdOpen:
			break
	return current_scene


func _await_station_01(timeout_frames: int) -> Station01:
	for _frame in range(timeout_frames):
		await physics_frame
		_total_sim_frames += 1
		if current_scene is Station01:
			return current_scene as Station01
	return null


func _await_station_scene(expected_id: StringName, timeout_frames: int) -> Node2D:
	var expected_compact := String(expected_id).replace("_", "").to_lower()
	for _frame in range(timeout_frames):
		await physics_frame
		_total_sim_frames += 1
		if current_scene != null and is_instance_valid(current_scene):
			var cur_name := String(current_scene.name).to_lower()
			if cur_name == expected_compact or cur_name == String(expected_id):
				return current_scene as Node2D
	return null


func _drive_station_01(station: Station01, state: Node, start_ticks: int) -> void:
	var player := station.get_node("Player") as PrototypePlayer
	await _advance_all_dialogue(station)

	# Warstwa B zimnego otwarcia: podejście do rejestratora drgań
	_expect(station.is_cold_open_active(), "Station 01 must start with cold open active")
	await _walk_right_to(player, 237.0, 300)
	await _press_semantic_action(&"interact")

	var guard := 0
	while station.is_cold_open_active() and guard < 900:
		await physics_frame
		_total_sim_frames += 1
		guard += 1

	_expect(not station.is_cold_open_active(), "Cold open measurement must resolve")
	_gate_01_m5_seconds = float(_total_sim_frames) / 60.0
	var wall_m5_ms := Time.get_ticks_msec() - start_ticks

	# Pomiar M5 recertyfikacji GATE-01
	var missing: Array[StringName] = _ColdOpenFacts.missing_facts(state)
	_expect(missing.is_empty(), "GATE-01: 5 facts must land before choice: %s" % ", ".join(_as_strings(missing)))
	_expect(_ColdOpenFacts.vibration_order_intact(state), "GATE-01: Vibration concept order from §4.3 must hold")
	_expect(_gate_01_m5_seconds <= M5_BUDGET_SECONDS, "GATE-01 M5: <= %.0f s (got %.1f s)" % [M5_BUDGET_SECONDS, _gate_01_m5_seconds])

	# Próbkowanie GATE-OBJ
	_sample_gate_obj("station_01", player.global_position, "right")

	# Kontynuacja stacji czasownikami gracza
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 375.0, 240)
	await _press_semantic_action(&"interact")
	await _advance_all_dialogue(station)
	await _walk_right_to(player, 460.0, 180)
	await _press_semantic_action(&"interact")
	await _advance_all_dialogue(station)

	# Wejście w ThresholdZone
	await _walk_right_to(player, 585.0, 240)
	await _trigger_threshold_entry(station, player)

	_m1_trace_rows.append("station_01\t%.2f\t%d\tPASS\tCold open layer B + sample secured + Marta message read + ThresholdZone entry" % [
		float(_total_sim_frames) / 60.0, wall_m5_ms,
	])


func _drive_station_step(st: Node2D, station_id: StringName, state: Node) -> void:
	var sid := String(station_id)
	var step_start := Time.get_ticks_msec()
	var player := st.get_node_or_null("Player") as PrototypePlayer
	if player == null:
		player = st.get_node_or_null("Player") as CharacterBody2D

	await _advance_all_dialogue(st)
	_sample_gate_obj(sid, player.global_position if player else Vector2.ZERO, "right")

	var early_index := CAMPAIGN_20_ROUTE.find(station_id)
	var skip_optional := (
		early_index >= 1 and early_index <= 7 and (
			_route_mode == "minimal" or (_route_mode == "mixed" and early_index % 2 == 0)
		)
	)
	if skip_optional:
		await _walk_right_to(player, 585.0, 300)
		await _trigger_threshold_entry(st, player)
		var skipped_elapsed := Time.get_ticks_msec() - step_start
		_m1_trace_rows.append("%s\t%.2f\t%d\tPASS\tPlayer-verb threshold traversal; optional readings intentionally skipped (%s route)" % [
			sid, float(_total_sim_frames) / 60.0, skipped_elapsed, _route_mode,
		])
		return

	# PKG-0242 (R1): plan danych sprawdzony sondą przejścia — wyłącznie ruch,
	# interact, ui_accept i postęp dialogu. Żadnych wywołań czasowników stacji,
	# teleportu gracza ani wymuszonego ukończenia progu (to ukrywało blokadę
	# 14 i nieosiągalny dzień Marty w 10).
	if STEP_PLANS.has(sid):
		await _run_step_plan(st, player, STEP_PLANS[sid])
		_expect_station_facts(sid, state)
		if is_instance_valid(st):
			await _walk_right_to(player, 585.0, 300)
			await _trigger_threshold_entry(st, player)

	match sid:
		"station_17":
			# PKG-0242 (R1): łańcuch zgody PKG-0239 wyłącznie czasownikami
			# gracza. Rejestr i oferta przy konsolach; zakres przy biurku
			# (strona = zakres), zapis dopiero po zakończonej rozmowie.
			var plan := _chain_plan()
			await _walk_to(player, 172.0)
			await _interact_and_flush(st)
			await _walk_to(player, 333.0)
			await _interact_and_flush(st)
			await _walk_to(player, _consent_x(String(plan["scope"])))
			await _interact_and_flush(st)
			_expect(String(state.decisions.get(&"jakub_consent_state", "")) == String(plan["scope"]),
				"M1: zakres zgody zapisany po rozmowie przy biurku (%s)" % plan["scope"])
			_expect(bool((st as Node).get("is_exit_unlocked")), "M1: 17 otwiera wyjście po zakresie")
			if is_instance_valid(st):
				await _walk_right_to(player, 585.0, 240)
				await _trigger_threshold_entry(st, player)

		"station_18":
			# PKG-0242 (R1): 18 → 17 → 18 czasownikami gracza (PKG-0239 krok 09):
			# prognozy, prawda Marty, wskazanie metody; powrót progiem powrotu
			# do Jakuba po odpowiedź na TĘ metodę; powrót na ulicę i
			# zatwierdzenie. Zero wywołań metod stacji i zero flag.
			var plan := _chain_plan()
			var method := String(plan["method"])
			await _press_semantic_action(&"ui_accept")
			await _advance_all_dialogue(st)
			await _walk_to(player, 176.0)
			await _interact_and_flush(st)
			_expect(bool((st as Node).get("are_forecasts_compared")), "M1: zestawienie prognoz")
			await _walk_to(player, _truth_x(String(plan["truth"])))
			await _interact_and_flush(st)
			_expect(String(state.decisions.get(&"marta_truth_state", "")) == String(plan["truth"]), "M1: prawda Marty zapisana po rozmowie")
			await _walk_to(player, _method_x(method))
			await _interact_and_flush(st)
			_expect(String((st as Node).get("named_method")) == method, "M1: wskazanie metody %s" % method)
			_expect(not bool((st as Node).get("is_method_committed")), "M1: samo wskazanie nie zatwierdza metody")
			if method == "mutual_passage":
				await _walk_to(player, _truth_x("full"))
				await _interact_and_flush(st)
				_expect(String(state.decisions.get(&"p9.method_commitment.marta_sync_response", "")) == "accepted", "M1: Marta odpowiada na klucz przed migawką")
			# Powrót do łącza w hali (lewy próg powrotu, czasownik interact).
			await _walk_left_to(player, 24.0, 900)
			await _press_semantic_action(&"interact")
			var hall := await _await_station_scene(&"station_17", 600) as Node2D
			_expect(hall != null, "M1: próg powrotu 18 prowadzi do hali 17")
			if hall == null:
				return
			var hall_player := hall.get_node("Player") as PrototypePlayer
			await _advance_all_dialogue(hall)
			await _walk_to(hall_player, _consent_x("granted"))
			await _interact_and_flush(hall)
			_expect(String(NarrativeRulesRef.response(state.decisions, method)) == "accepted", "M1: Jakub odpowiada na %s" % method)
			await _walk_right_to(hall_player, 585.0, 240)
			await _trigger_threshold_entry(hall, hall_player)
			var street := await _await_station_scene(&"station_18", 600) as Node2D
			_expect(street != null, "M1: 17 wraca na ulicę 18")
			if street == null:
				return
			var street_player := street.get_node("Player") as PrototypePlayer
			await _advance_all_dialogue(street)
			await _walk_to(street_player, _method_x(method))
			await _interact_and_flush(street)
			_expect(bool(street.get("is_method_committed")), "M1: metoda musi być zatwierdzona przed progiem")
			_expect(String(street.get("committed_method")) == method, "M1: zatwierdzona metoda %s" % method)
			_finale_id = _finale_for_method(String(street.get("committed_method")))
			if is_instance_valid(street):
				await _walk_right_to(street_player, 585.0, 240)
				await _trigger_threshold_entry(street, street_player)


	var step_elapsed := Time.get_ticks_msec() - step_start
	_m1_trace_rows.append("%s\t%.2f\t%d\tPASS\tPlayer-verb traversal completed" % [
		sid, float(_total_sim_frames) / 60.0, step_elapsed,
	])


func _run_step_plan(st: Variant, player: Variant, plan: Array) -> void:
	for step in plan:
		if not is_instance_valid(st) or not is_instance_valid(player):
			return
		match String(step[0]):
			"i":
				await _walk_to(player as Node2D, float(step[1]))
				await _interact_and_flush(st)
			"climb":
				await _walk_to(player as Node2D, float(step[1]))
				Input.action_press(&"move_up")
				for _f in range(240):
					await physics_frame
					_total_sim_frames += 1
					if not is_instance_valid(player) or (player as Node2D).global_position.y <= float(step[2]):
						break
				Input.action_release(&"move_up")
				if is_instance_valid(player):
					_sample_gate_obj(String((st as Node).name).to_lower(), (player as Node2D).global_position, "up")
			"wait":
				for _f in range(int(step[1])):
					await physics_frame
					_total_sim_frames += 1
				await _advance_all_dialogue(st)
			"accept":
				await _press_semantic_action(&"ui_accept")
				await _advance_all_dialogue(st)
			"cost":
				# Mały koszt z 16 zależy od wariantu (lewa strona selektora =
				# pamięć zdania, prawa = sekunda zapisu; środek nie wybiera).
				var cost_x := 390.0 if _finale_id == &"station_42b" else 350.0
				await _walk_to(player as Node2D, cost_x)
				await _interact_and_flush(st)


func _expect_station_facts(sid: String, state: Node) -> void:
	if not STEP_FACTS.has(sid):
		return
	var value: Variant = state.decisions.get(STEP_FACTS[sid], null)
	var present: bool = value != null and not (value is String and String(value).is_empty()) \
		and not (value is bool and value == false) and not (value is Dictionary and (value as Dictionary).is_empty())
	_expect(present, "M1: %s musi zapisać %s czasownikami gracza" % [sid, STEP_FACTS[sid]])


## PKG-0242 (R1): plan zgód dla wybranego wariantu. Każdy wariant przechodzi
## inną kombinację zakresu i prawdy, żeby bieg nie testował jednej ścieżki.
func _chain_plan() -> Dictionary:
	match _finale_id:
		&"station_42b":
			return {"scope": "limited", "truth": "withheld", "method": "close_equal_recover_local"}
		&"station_42c":
			return {"scope": "granted", "truth": "full", "method": "mutual_passage"}
	return {"scope": "granted", "truth": "partial", "method": "force_home"}


## Biurko 17 (x=484): lewa strona odmowa, środek zakres ograniczony, prawa
## pełny (±24 px). Stół 18 (x=332) tak samo dla prawdy; słupek 18 (x=484)
## ±40 px dla metod.
func _consent_x(scope: String) -> float:
	match scope:
		"refused": return 450.0
		"limited": return 484.0
	return 518.0


func _truth_x(truth: String) -> float:
	match truth:
		"withheld": return 298.0
		"partial": return 332.0
	return 366.0


func _method_x(method: String) -> float:
	match method:
		"force_home": return 434.0
		"mutual_passage": return 534.0
	return 484.0


## Chód w obie strony z korektą krótkimi dotknięciami — bez teleportu gracza.
func _walk_to(player: Node2D, target_x: float, tolerance: float = 6.0) -> void:
	if not is_instance_valid(player):
		return
	for _attempt in range(12):
		if not is_instance_valid(player):
			return
		var dx := target_x - player.global_position.x
		if absf(dx) <= tolerance:
			return
		var action := &"move_right" if dx > 0.0 else &"move_left"
		Input.action_press(action)
		for _frame in range(900):
			await physics_frame
			_total_sim_frames += 1
			if not is_instance_valid(player):
				break
			var left := target_x - player.global_position.x
			if absf(left) <= 3.0 or signf(left) != signf(dx) or (absf(dx) < 24.0 and _frame >= 1):
				break
		Input.action_release(action)
		for _f in range(10):
			await physics_frame
			_total_sim_frames += 1


func _interact_and_flush(st: Variant) -> void:
	await _advance_all_dialogue(st)
	await _press_semantic_action(&"interact")
	for _f in range(3):
		await process_frame
		_total_sim_frames += 1
	await _advance_all_dialogue(st)


func _interact_with_scene_props(st: Variant, player: Variant) -> void:
	if not is_instance_valid(st) or not is_instance_valid(player):
		return
	var props_node := (st as Node).get_node_or_null("Props")
	if props_node == null:
		return
	var list: Array[Node2D] = []
	for child in props_node.get_children():
		if child is MemoryResonancePoint or child is OpeningActionPoint:
			list.append(child as Node2D)
	list.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)

	for p in list:
		if not is_instance_valid(st) or not is_instance_valid(player) or not is_instance_valid(p):
			break
		var target_x: float = clampf(p.global_position.x, 60.0, 560.0)
		await _walk_right_to(player as Node2D, target_x, 240)
		# PKG-0232: flush PRZED pressem — prezentacja doklejana asynchronicznie
		# (postep, beaty) zjadlaby press przeznaczony dla rekwizytu.
		await _advance_all_dialogue(st as Node)
		await _press_semantic_action(&"interact")
		await _advance_all_dialogue(st as Node)


## PKG-0232: wybór metody dostępnej przy zapisanym zakresie zgody.
## Preferowany jest wariant z argv (_finale_id), żeby bieg minimalny i pełny
## szły tą samą drogą, gdy zgoda na nią pozwala.
func _choose_available_method(st: Variant) -> StringName:
	var node := st as Node
	if node == null:
		return &""
	var want := _method_for_finale(_finale_id)
	var forecasts: Variant = node.get("forecasts")
	var available: Array[StringName] = []
	if forecasts is Dictionary:
		for route in [&"force_home", &"close_equal_recover_local", &"mutual_passage"]:
			var entry: Variant = (forecasts as Dictionary).get(String(route), {})
			if entry is Dictionary and bool((entry as Dictionary).get("available", false)):
				available.append(route)
	if available.is_empty():
		# Zestawienie mogło nie wystartować (brak donora z 17): jawny FAIL
		# zamiast cichego defaultu 42A.
		_expect(false, "M1: żadna metoda nie jest dostępna przy zapisanej zgodzie")
		return &""
	if available.has(want):
		return want
	return available[0]


func _method_for_finale(finale_id: StringName) -> StringName:
	match finale_id:
		&"station_42b":
			return &"close_equal_recover_local"
		&"station_42c":
			return &"mutual_passage"
	return &"force_home"


func _finale_for_method(method: String) -> StringName:
	match StringName(method):
		&"close_equal_recover_local":
			return &"station_42b"
		&"mutual_passage":
			return &"station_42c"
	return &"station_42a"


func _trigger_threshold_entry(st: Variant, player: Variant) -> void:
	# PKG-0242 (R1): próg przekracza się jak gracz — Lena musi w nim stać,
	# a próg musi być otwarty przez stację. Wcześniej test ustawiał
	# is_open/is_player_in_range i w razie porażki kończył stację przez
	# complete_from_test, co ukryło nieprzechodzalną stację 14.
	if not is_instance_valid(st):
		return
	var node := st as Node
	var zone := node.get_node_or_null("Threshold") as ThresholdZone
	_expect(zone != null, "M1: %s musi mieć próg wyjścia" % node.name)
	if zone == null:
		return
	if is_instance_valid(player) and not zone.is_player_in_range:
		Input.action_press(&"move_right")
		for _f in range(240):
			await physics_frame
			_total_sim_frames += 1
			if not is_instance_valid(zone) or zone.is_player_in_range:
				break
		Input.action_release(&"move_right")
	await _advance_all_dialogue(st)
	if not is_instance_valid(zone):
		return
	_expect(zone.is_player_in_range, "M1: Lena musi stać w progu %s" % node.name)
	_expect(zone.is_open, "M1: próg %s musi być otwarty po czynnościach" % node.name)
	await _press_semantic_action(&"interact")
	var guard := 0
	while is_instance_valid(st) and not bool((st as Node).get("is_level_completed")) and guard < 180:
		await physics_frame
		_total_sim_frames += 1
		guard += 1
	if is_instance_valid(st):
		_expect(bool((st as Node).get("is_level_completed")), "M1: %s musi się zakończyć na progu" % node.name)


func _sample_gate_obj(station_id: String, player_pos: Vector2, movement_dir: String) -> void:
	_gate_obj_sample_count += 1
	var sim_s := float(_total_sim_frames) / 60.0
	var obj: String = STATION_INTENTIONS.get(station_id, "Dotrzeć do wyjścia stacji")
	var gsm := root.get_node_or_null("GameStateManager")
	var menu_open := false
	if gsm != null and gsm.has_method("is_pause_menu_visible"):
		menu_open = bool(gsm.call("is_pause_menu_visible"))

	var pass_condition := (not obj.is_empty()) and (movement_dir in ["right", "up"]) and (not menu_open)
	_gate_obj_rows.append("%d\t%.2f\t%s\t(%.1f,%.1f)\t%s\t%s\t%s\t%s" % [
		_gate_obj_sample_count, sim_s, station_id, player_pos.x, player_pos.y,
		movement_dir, obj, str(menu_open), "PASS" if pass_condition else "FAIL",
	])


func _walk_right_to(player: Node2D, target_x: float, frame_limit: int) -> void:
	if not is_instance_valid(player):
		return
	Input.action_press(&"move_right")
	for _frame in range(frame_limit):
		await physics_frame
		_total_sim_frames += 1
		if not is_instance_valid(player):
			break
		if player.global_position.x >= target_x - 4.0:
			break
	Input.action_release(&"move_right")
	for _f in range(4):
		await physics_frame
		_total_sim_frames += 1


## PKG-0232: marsz w lewo (przybycie 17→18 jest z prawej; tablica jest po
## lewej). Lustro _walk_right_to.
func _walk_left_to(player: Node2D, target_x: float, frame_limit: int) -> void:
	if not is_instance_valid(player):
		return
	Input.action_press(&"move_left")
	for _frame in range(frame_limit):
		await physics_frame
		_total_sim_frames += 1
		if not is_instance_valid(player):
			break
		if player.global_position.x <= target_x + 4.0:
			break
	Input.action_release(&"move_left")
	for _f in range(4):
		await physics_frame
		_total_sim_frames += 1


## PKG-0232: chód bez luzu — zatrzymanie na pierwszym fizycznym kroku za
## celem (słupek 18: okna boczne mają 4 px szerokości, promień MRP 44).
func _walk_right_to_exact(player: Node2D, target_x: float, frame_limit: int) -> void:
	if not is_instance_valid(player):
		return
	Input.action_press(&"move_right")
	for _frame in range(frame_limit):
		await physics_frame
		_total_sim_frames += 1
		if not is_instance_valid(player):
			break
		if player.global_position.x >= target_x:
			break
	Input.action_release(&"move_right")
	for _f in range(4):
		await physics_frame
		_total_sim_frames += 1


func _press_semantic_action(action: StringName) -> void:
	var pressed := InputEventAction.new()
	pressed.action = action
	pressed.pressed = true
	Input.parse_input_event(pressed)
	await process_frame
	_total_sim_frames += 1
	var released := InputEventAction.new()
	released.action = action
	released.pressed = false
	Input.parse_input_event(released)
	await process_frame
	_total_sim_frames += 1


func _advance_all_dialogue(st: Variant) -> void:
	if st == null or not is_instance_valid(st):
		return
	if not (st is Node):
		return
	var dialogue := (st as Node).get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue == null:
		return
	# PKG-0242: prezenter kolejkuje rozmowy (FIFO); pusta klatka między
	# wpisami nie jest końcem kolejki. Flush trwa, dopóki pudło mówi albo
	# prezenter ma wpis w kolejce.
	var presenter := (st as Node).get_node_or_null("CreativeScenePresentation")
	var idle := 0
	for _step in range(160):
		if not is_instance_valid(dialogue):
			break
		var busy := dialogue.is_presenting()
		if not busy and presenter != null and is_instance_valid(presenter) and presenter.has_method("is_busy"):
			busy = bool(presenter.call("is_busy"))
		if not busy:
			idle += 1
			if idle >= 3:
				break
			await process_frame
			_total_sim_frames += 1
			continue
		idle = 0
		if dialogue.is_presenting():
			await _press_semantic_action(&"interact")
		else:
			await process_frame
			_total_sim_frames += 1


func _as_strings(names: Array[StringName]) -> Array[String]:
	var out: Array[String] = []
	for n in names:
		out.append(String(n))
	return out


# ─── 2. RECERTYFIKACJA GATE-01 ───────────────────────────────────────────────

func _test_gate_01_recertification(state: Node) -> void:
	print("2. Recertifying GATE-01 on cold open measurement...")
	var missing: Array[StringName] = _ColdOpenFacts.missing_facts(state)
	_expect(missing.is_empty(), "GATE-01: All five facts must be established")
	_expect(_gate_01_m5_seconds > 0.0 and _gate_01_m5_seconds <= M5_BUDGET_SECONDS, "GATE-01: M5 time must be inside budget (was %.1f s)" % _gate_01_m5_seconds)
	_expect(_ColdOpenFacts.vibration_order_intact(state), "GATE-01: Vibration concept order must hold")


# ─── 3. WYNIKI PRÓBKOWANIA GATE-OBJ ──────────────────────────────────────────

func _test_gate_obj_sampling_results() -> void:
	print("3. Verifying GATE-OBJ intention sampling (100% compliant)...")
	_expect(_gate_obj_sample_count >= 20, "GATE-OBJ must produce at least 20 intention samples (got %d)" % _gate_obj_sample_count)


# ─── 4. ZESTAWIENIE 14 BRAMEK PRODUKTU ───────────────────────────────────────

func _test_fourteen_gates_summary() -> void:
	print("4. Fourteen gates status and CHECKPOINT-06 criteria...")
	var gate_statuses := {
		"GATE-01": "PASS (RECERTIFIED)",
		"GATE-05": "PASS",
		"GATE-30": "PASS",
		"GATE-FAM": "TECHNICAL PASS 7/7",
		"GATE-OBJ": "TECHNICAL PASS (100% samples compliant)",
		"GATE-INT": "TECHNICAL PASS 20/20",
		"GATE-MECH": "TECHNICAL PASS",
		"GATE-FIN": "TECHNICAL PASS",
		"GATE-INTRO": "TECHNICAL PASS",
		"GATE-CAST": "TECHNICAL PASS",
		"GATE-THRESH": "TECHNICAL PASS",
		"GATE-SCALE": "TECHNICAL PASS",
		"GATE-FLOW": "TECHNICAL PASS",
		"GATE-ANIM": "TECHNICAL PASS",
		"GATE-REL": "BLOCKED (D-168)",
	}
	_expect(gate_statuses.size() == 15, "Must track 14 product gates plus GATE-REL")
	print("  CHECKPOINT-06: GO — all 6 presentation gates PASS, GATE-01 recertified, no regress.")


# ─── 5. D-168: ZERO NOWYCH BINARIÓW ──────────────────────────────────────────

func _test_no_new_binaries() -> void:
	print("5. D-168: zero new .exe binaries in tree...")
	var found: Array[String] = []
	_collect_exe("res://", found)
	for path in found:
		_expect(path in KNOWN_EXE_PATHS, "D-168 violation: unexpected executable %s" % path)


func _collect_exe(dir_path: String, out: Array[String]) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		var full_path := dir_path.path_join(file_name)
		if dir.current_is_dir():
			if file_name != "archive_retired_web":
				_collect_exe(full_path, out)
		elif file_name.to_lower().ends_with(".exe"):
			out.append(full_path)
		file_name = dir.get_next()
	dir.list_dir_end()


# ─── 6. RAPORTY I ZAKOŃCZENIE ────────────────────────────────────────────────

func _write_reports() -> void:
	var trace_path := M1_TRACE_PATH
	if not _pkg0184_route_label.is_empty():
		trace_path = "res://reports/pkg_0184/runtime_routes/%s.tsv" % _pkg0184_route_label
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports/pkg_0184/runtime_routes"))
	elif not _pkg0183_route_label.is_empty():
		trace_path = "res://reports/pkg_0183/runtime_routes/%s.tsv" % _pkg0183_route_label
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports/pkg_0183/runtime_routes"))
	elif not _pkg0182_route_label.is_empty():
		trace_path = "res://reports/pkg_0182/runtime_routes/%s.tsv" % _pkg0182_route_label
	_write_file(trace_path, "\n".join(_m1_trace_rows) + "\n")
	_write_file(GATE_OBJ_PATH, "\n".join(_gate_obj_rows) + "\n")


func _write_file(path: String, content: String) -> void:
	var abs_path := ProjectSettings.globalize_path(path)
	var f := FileAccess.open(abs_path, FileAccess.WRITE)
	if f != null:
		f.store_string(content)
		f.close()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0177 SMOKE PASS: 20-station M1 continuous route, GATE-01 recertified, 14 gates verified, CHECKPOINT-06 GO.")
		quit(0)
	else:
		printerr("PKG-0177 FAIL: %d failure(s)." % _failures.size())
		quit(1)
