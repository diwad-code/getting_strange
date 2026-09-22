extends SceneTree

## PKG-0230 gate — naprawa sensu fabularnego (story-sense repair).
## Dyspozycja wlasciciela z docs/narrative/STORY_SENSE_REPAIR_PROMPT.md
## (freeze D-241 zdjety dla tego zakresu; GATE-REL/release/.exe nadal D-168).
## Dowodzi wylacznie kontraktow mierzalnych, nie odbioru (D-012, ADR-003).
##
## P0-4: epilog 43 bez sprzecznosci Linii 4 (S-09).
## P0-3: WYKRESLONY — defekt S-04 obalony bramka 0214 (22/22 wyjsc bez
##   odczytow); otwieracz: GSM node_added → GapLedger.ensure_exit_open.
##   Tu: mechanizm powrotu (ReturnZone → poprzednik GSM) dziala runtime.
## P0-1: zgoda Jakuba blokuje metode; odmowa zamyka 3 drogi (S-02).
## P0-2: wskazanie vs zatwierdzenie; martwa strefa +-40; oznaczenia (S-03).
## P1-1+P1-4: ogniwa 13→14→15→16→17 + nazwanie celu.
## P1-3: ciala dla glosow (rig Marty 18/42A, lacze 17).
## P1-2: zawias Marty 10→13 (druga kwestia cue).
## P2-1: kierunek powrotow + pion (HATCH, nie winda).
## P2-3: naglowki i nazwy zgodne z runtime.

const GapLedgerScript := preload("res://scripts/campaign/gap_ledger.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0230 FAILURE: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "plik musi byc czytelny: %s" % path)
	if file == null:
		return ""
	var text := file.get_as_text()
	file.close()
	return text


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager musi istniec")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	await _test_epilogue_line(state)
	await _test_return_mechanism(state)
	await _test_consent_gates(state)
	await _test_two_step(state)
	_test_entry_exit_links()
	await _test_bodies(state)
	await _test_marta_hinge(state)
	_test_arrival_sides(state)
	_test_hygiene()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _open(state: Node, num: int) -> Node2D:
	var packed := load("res://scenes/levels/station_%02d.tscn" % num) as PackedScene
	_expect(packed != null, "scena station_%02d musi sie ladowac" % num)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _open_named(state: Node, station_id: String) -> Node2D:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	_expect(packed != null, "scena %s musi sie ladowac" % station_id)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close(station: Node) -> void:
	station.queue_free()
	await process_frame


func _seed_donor(state: Node, scope: String) -> void:
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", scope)
	state.record_decision(&"jakub_consent_state", scope)


func _seed_18_entry(state: Node, scope: String) -> void:
	state.record_decision(&"p7.work_history_and_record.trace", "cost_ledger_and_consent_scope_recorded")
	state.record_decision(&"p9.consent_and_cost.cost_ledger_read", true)
	state.record_decision(&"p9.consent_and_cost.adaptation_offer", "rejected")
	_seed_donor(state, scope)


# ─── P0-4 ────────────────────────────────────────────────────────────────

func _test_epilogue_line(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open_named(state, "station_43")
	if station == null:
		return
	_expect(String(station.get("ending_family")) == "unseeded", "golas 43 to unseeded")
	var lines: Array = station.get("dialogue_lines") as Array
	_expect(lines.size() >= 5, "unseeded ma >= 5 linii")
	var second := String((lines[1] as Dictionary).get("text", ""))
	_expect(not second.contains("nigdy nie istnia"), "epilog nie zaprzecza istnieniu Linii 4")
	_expect(second.contains("Linia 4"), "epilog mowi o Linii 4")
	_expect(second.contains("odbudowano"), "roznica w statusie linii, nie w istnieniu")
	await _close(station)


# ─── P0-3 (wykreslony; mechanizm powrotu) ────────────────────────────────

func _test_return_mechanism(state: Node) -> void:
	state.reset_campaign(true)
	_expect(String(state.call("get_previous_campaign_station", &"station_10")) == "station_09", "poprzednik 10 to 09")
	_expect(String(state.call("get_previous_campaign_station", &"station_18")) == "station_17", "poprzednik 18 to 17")
	var station := await _open(state, 10)
	if station == null:
		return
	var zone := station.get_node_or_null("ReturnZone")
	_expect(zone != null, "10 ma ReturnZone")
	if zone == null:
		await _close(station)
		return
	var seen: Array[bool] = [false]
	station.connect("previous_level_requested", func() -> void: seen[0] = true)
	_expect(bool(zone.call("trigger_return", null, true)), "trigger_return dziala instant")
	_expect(seen[0], "powrot emituje previous_level_requested")
	await _close(station)


# ─── P0-1 ────────────────────────────────────────────────────────────────

func _commit_attempt(state: Node, scope: String, method: StringName) -> Array:
	state.reset_campaign(true)
	var station := await _open(state, 18)
	if station == null:
		return [false, "", false]
	_seed_18_entry(state, scope)
	station.call("compare_forecast_consent_dependencies")
	station.call("disclose_marta_truth_partial")
	var result := bool(station.call(_commit_name(method)))
	var out := [result, String(station.get("last_feedback")), bool(station.get("is_method_committed"))]
	await _close(station)
	return out


func _commit_name(method: StringName) -> StringName:
	match method:
		&"force_home":
			return &"commit_force_home"
		&"close_equal_recover_local":
			return &"commit_close_equal"
	return &"commit_mutual_passage"


func _test_consent_gates(state: Node) -> void:
	# Odmowa zamyka wszystkie trzy drogi.
	for method in [&"force_home", &"close_equal_recover_local", &"mutual_passage"]:
		var r := await _commit_attempt(state, "refused", method)
		_expect(not r[0], "refused blokuje %s" % String(method))
		_expect(String(r[1]) == "jakub_consent_missing", "refused zostawia feedback")
		_expect(not r[2], "refused nie commituje")
	# Limited: tylko zamkniecie z odzyskaniem.
	var lf := await _commit_attempt(state, "limited", &"force_home")
	_expect(not lf[0], "limited blokuje force_home")
	var lc := await _commit_attempt(state, "limited", &"close_equal_recover_local")
	_expect(lc[0] and lc[2], "limited pozwala close_equal")
	var lm := await _commit_attempt(state, "limited", &"mutual_passage")
	_expect(not lm[0], "limited blokuje mutual_passage")
	# Granted: wszystko.
	for method in [&"force_home", &"close_equal_recover_local", &"mutual_passage"]:
		var g := await _commit_attempt(state, "granted", method)
		_expect(g[0] and g[2], "granted pozwala %s" % String(method))
	# Brak zestawienia / prawdy blokuje.
	state.reset_campaign(true)
	var bare := await _open(state, 18)
	if bare != null:
		_seed_18_entry(state, "granted")
		_expect(not bool(bare.call("commit_force_home")), "commit bez zestawienia nie przechodzi")
		_expect(String(bare.get("last_feedback")) == "forecast_and_consent_inventory_required", "brak zestawienia mowi luka")
		_expect(bool(bare.call("compare_forecast_consent_dependencies")), "zestawienie wychodzi")
		_expect(not bool(bare.call("commit_force_home")), "commit bez prawdy nie przechodzi")
		_expect(String(bare.get("last_feedback")) == "marta_truth_required", "brak prawdy mowi luka")
		await _close(bare)
	# Mapa feedback -> luka istnieje (bramka 0215 fail-closed).
	var table: Dictionary = GapLedgerScript.FEEDBACK_TO_GAP
	_expect(String(table.get("jakub_consent_missing", "")) == "s17.consent_unscoped", "jakub_consent_missing mowi luka 17")


# ─── P0-2 ────────────────────────────────────────────────────────────────

func _test_two_step(state: Node) -> void:
	state.reset_campaign(true)
	var station := await _open(state, 18)
	if station == null:
		return
	_seed_18_entry(state, "limited")
	_expect(bool(station.call("compare_forecast_consent_dependencies")), "zestawienie wychodzi")
	_expect(bool(station.call("disclose_marta_truth_partial")), "prawda wychodzi")
	var post := station.get_node("Props/MethodCommitPost") as Node2D
	var player := station.get_node("Player") as Node2D
	_expect(post != null and player != null, "slupek i gracz istnieja")
	if post == null or player == null:
		await _close(station)
		return
	# Pierwsze podejscie z lewej NAZYWA, nie zatwierdza.
	player.global_position = Vector2(post.global_position.x - 60.0, 296.0)
	_expect(bool(station.call("choose_method_from_player_side")), "pierwsze podejscie nazywa")
	_expect(not bool(station.get("is_method_committed")), "nazwanie nie commituje")
	_expect(StringName(station.get("named_method")) == &"force_home", "wskazana force_home")
	# Drugie podejscie do tej samej: proba commita, ale limited blokuje force_home.
	_expect(not bool(station.call("choose_method_from_player_side")), "limited blokuje force_home przy slupku")
	_expect(not bool(station.get("is_method_committed")), "nadal nie commit")
	# Srodek: nazwij, potem zatwierdz.
	player.global_position = Vector2(post.global_position.x, 296.0)
	_expect(bool(station.call("choose_method_from_player_side")), "srodek nazywa od nowa")
	_expect(StringName(station.get("named_method")) == &"close_equal_recover_local", "wskazana close_equal")
	_expect(bool(station.call("choose_method_from_player_side")), "drugie podejscie zatwierdza")
	_expect(bool(station.get("is_method_committed")), "commit po nazwaniu")
	_expect(String(state.decisions.get(&"method_committed", "")) == "close_equal_recover_local", "kanoniczna metoda")
	_expect(not bool(station.call("choose_method_from_player_side")), "po commicie slupek milczy")
	await _close(station)
	# Martwa strefa +-40: prog nie lezy w sylwetce.
	state.reset_campaign(true)
	var probe := await _open(state, 18)
	if probe == null:
		return
	_seed_18_entry(state, "granted")
	probe.call("compare_forecast_consent_dependencies")
	probe.call("disclose_marta_truth_partial")
	var p2 := probe.get_node("Props/MethodCommitPost") as Node2D
	var pl2 := probe.get_node("Player") as Node2D
	pl2.global_position = Vector2(p2.global_position.x + 30.0, 296.0)
	probe.call("choose_method_from_player_side")
	_expect(StringName(probe.get("named_method")) == &"close_equal_recover_local", "+-30 to nadal srodek")
	pl2.global_position = Vector2(p2.global_position.x + 50.0, 296.0)
	probe.call("choose_method_from_player_side")
	_expect(StringName(probe.get("named_method")) == &"mutual_passage", "+50 to juz bok")
	await _close(probe)


# ─── P1-1 + P1-4 (statyka tresci) ────────────────────────────────────────

func _cue(path: String) -> String:
	var text := _read(path)
	var marker := "opening_line = \""
	var start := text.find(marker)
	if start < 0:
		return ""
	start += marker.length()
	var finish := text.find("\"", start)
	if finish < 0:
		return ""
	return text.substr(start, finish - start)


func _test_entry_exit_links() -> void:
	_expect(_cue("res://scenes/levels/station_14.tscn").contains("20:40"), "14 wchodzi tropem przerwanej proby")
	_expect(_cue("res://scenes/levels/station_15.tscn").contains("czytnika brak w rejestrze"), "15 wchodzi wyciagiem z 11")
	_expect(_cue("res://scenes/levels/station_16.tscn").contains("poza obwodem"), "16 wchodzi przyrzadem spoza petli")
	_expect(_cue("res://scenes/levels/station_17.tscn").contains("rejestru par"), "17 wchodzi rejestrem par")
	_expect(_cue("res://scenes/levels/station_18.tscn").contains("Marta przy oknie"), "18 wchodzi ulica i Marta")
	var beats := {
		"res://scripts/levels/station_10.gd": "s10_exit_ucp_record",
		"res://scripts/levels/station_12.gd": "s12_exit_back_home",
		"res://scripts/levels/station_13.gd": "s13_exit_to_switchyard",
		"res://scripts/levels/station_14.gd": "s14_exit_to_loop",
		"res://scripts/levels/station_15.gd": "s15_exit_to_analyzer",
		"res://scripts/levels/station_16.gd": "s16_exit_to_ledger",
		"res://scripts/levels/station_17.gd": "s17_exit_to_street",
	}
	for path in beats:
		_expect(_read(path).contains(String(beats[path])), "%s ma zdanie wyjscia" % path)


# ─── P1-3 ────────────────────────────────────────────────────────────────

func _find_rig(node: Node, character_id: StringName) -> Node:
	if node.get_script() != null:
		var script_path := String(node.get_script().resource_path)
		if script_path.ends_with("character_visual_rig.gd"):
			if StringName(node.get("character_id")) == character_id:
				return node
	for child in node.get_children():
		var found := _find_rig(child, character_id)
		if found != null:
			return found
	return null


func _test_bodies(state: Node) -> void:
	var s18 := await _open(state, 18)
	if s18 != null:
		_expect(_find_rig(s18, &"marta") != null, "18 ma cialo Marty przy witrynie")
		await _close(s18)
	var s42a := await _open_named(state, "station_42a")
	if s42a != null:
		_expect(_find_rig(s42a, &"marta") != null, "42A ma cialo Marty przy stole")
		await _close(s42a)
	var lines: Dictionary = ((load("res://scripts/levels/creative_scene_lines.gd") as GDScript).get_script_constant_map().get("LINES", {}) as Dictionary)
	for key in ["consent_scope_desk_granted", "consent_scope_desk_limited", "consent_scope_desk_refused"]:
		var joined := JSON.stringify(lines.get(key, []))
		_expect(joined.contains("JAKUB (") and not joined.contains("\"JAKUB\""), "%s mowi przez lacze" % key)
	_expect(_read("res://scripts/levels/station_17.gd").contains("lacze"), "17 rysuje terminal lacza")


# ─── P1-2 ────────────────────────────────────────────────────────────────

func _test_marta_hinge(state: Node) -> void:
	var station := await _open(state, 13)
	if station == null:
		return
	var cue := station.get_node_or_null("OpeningDialogueCue")
	_expect(cue != null, "13 ma cue")
	if cue != null:
		_expect(String(cue.get("opening_line_2")).contains("grafiku"), "zawias Marty mowi o sprawdzeniu")
		_expect(StringName(cue.get("speaker_2")) == &"Marta", "zawias mowi Marta")
	await _close(station)


# ─── P2-1 ────────────────────────────────────────────────────────────────

func _test_arrival_sides(state: Node) -> void:
	_expect(String(state.call("arrival_side_for", &"station_12", &"station_13")) == "right", "12 → 13 wchodzi z prawej")
	_expect(String(state.call("arrival_side_for", &"station_17", &"station_18")) == "right", "17 → 18 wchodzi z prawej")
	_expect(String(state.call("arrival_side_for", &"station_13", &"station_14")) == "left", "13 → 14 z lewej")
	_expect(String(state.call("arrival_side_for", &"station_01", &"station_02")) == "left", "01 → 02 z lewej")
	_expect(String(state.call("arrival_side_for", &"station_18", &"station_42a")) == "left", "18 → 42A z lewej")


# ─── P2-3 ────────────────────────────────────────────────────────────────

func _test_hygiene() -> void:
	var s11 := _read("res://scenes/levels/station_11.tscn")
	for stale in ["WorkBoots", "CommodePhotograph", "FieldReaderDock", "LegacyDomesticWitness"]:
		_expect(not s11.contains(stale), "11 bez %s" % stale)
	for fresh in ["IdentityCardSlot", "DayRecordLedger", "MinimalReportWindow", "DonorTrace"]:
		_expect(s11.contains(fresh), "11 ma %s" % fresh)
	var s13 := _read("res://scenes/levels/station_13.tscn")
	_expect(not s13.contains("PhoneToMarta"), "13 bez PhoneToMarta")
	_expect(s13.contains("SharedTableReader"), "13 ma SharedTableReader")
	for path in ["res://scripts/levels/station_42a.gd", "res://scripts/levels/station_42b.gd", "res://scripts/levels/station_42c.gd"]:
		_expect(not _read(path).contains("else SCOPE_"), "%s bez domyslnej zgody" % path)
	_expect(_read("res://docs/narrative/FULL_STORY.md").contains("01–18"), "FULL_STORY z notka o numeracji")
	_expect(_read("res://docs/rebuild/CAMPAIGN_MAP.md").contains("arrival_side_for"), "MAPA z kierunkiem powrotow")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0230 PASS: story-sense repair contracts hold")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0230 FAILURE: " + failure)
	quit(1)
