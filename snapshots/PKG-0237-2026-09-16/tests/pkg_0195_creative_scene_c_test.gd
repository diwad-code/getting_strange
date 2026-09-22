extends SceneTree

## PKG-0195 / CR-C: metoda i skutek (finały 42A/B/C + epilog 43).
##
## Real MRP input -> station writer -> delivered CRT lines, plus reload/skip.
## The harness selects an input target explicitly; it does not prove traversal.
## Covers: execution/effect separation in all three families (latch/closure/
## passage first, consequence reading after — never the reverse), local Lena
## as a recognizable person (B: breathing, withheld key, her own answer about
## the test), the arrived-perspective cut to the index-less shelter (B), the
## concrete memory leak interrupting ordinary work (C), three Marta truth
## states, save/reload before and after the household reading, semantic skip
## of all three finale vignettes without replay on reread, the 43 epilogue
## without the orphaned Szymon line and without the author thesis, text scales.
const GapLedger := preload("res://scripts/campaign/gap_ledger.gd")

var failures: Array[String] = []
var delivered: Array[String] = []
var action_count := 0
var capture := false
var capture_index := 0
var station_tag := "42a"
var scale_tag := "100"
var vignette_count := 0
var last_line := ""
var capture_rows: Array[String] = []


func _initialize() -> void:
	call_deferred("run")


func expect(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
		printerr("PKG-0195 FAILURE: " + message)


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
	var path := "res://reports/pkg_0195/visual_final/s%s_%s_%03d_%s.png" % [station_tag, scale_tag, capture_index, label]
	expect(root.get_texture().get_image().save_png(path) == OK, "save capture " + path)
	capture_rows.append(path + "\t" + label + "\t" + last_line)
	capture_index += 1


func find_vignette(station: Node) -> Node:
	for child in station.get_children():
		if child is CanvasLayer and String(child.name).begins_with("CinematicVignette_"):
			if not child.is_queued_for_deletion():
				return child
	return null


func drain(station: Node) -> void:
	var box := station.get_node("CRTDialogueBox") as CRTDialogueBox
	for tick in range(260):
		var vignette := find_vignette(station)
		if vignette != null:
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


func open_finale(family: String) -> Node:
	station_tag = "42" + family
	var station := (load("res://scenes/levels/station_42%s.tscn" % family) as PackedScene).instantiate()
	root.add_child(station)
	expect(station.get_node_or_null("CreativeScenePresentation") != null, "station 42%s must attach the local presentation owner" % family)
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


func close_finale(station: Node, family: String) -> void:
	GapLedger.record_on_depart(station)
	var state := root.get_node("GameStateManager")
	for gap_id in state.open_gaps:
		expect(state.open_gaps[gap_id].get("origin_station", "") != "station_42" + family, "resolved current facts must close this station's gap")
	station.queue_free()
	# Robust teardown: the next station opens only after this instance is
	# actually gone (one process frame is not always enough once a vignette
	# was shown and skipped on the closing instance).
	for _i in range(30):
		if not is_instance_valid(station):
			break
		await process_frame
	await physics_frame
	expect(not is_instance_valid(station), "closed station must be freed before the next open")


## Donor state as a real 18->42 handoff leaves it: committed method, Marta
## truth and Jakub scope under both keys, mapped forecasts, recognition done.
func seed_finale(state: Node, method: String, marta: String, scope: String) -> void:
	state.reset_campaign(true)
	state.record_decision(&"p9.method_commitment.method_committed", method)
	state.record_decision(&"method_committed", method)
	state.record_decision(&"route_hypotheses_mapped", true)
	state.record_decision(&"p9.method_commitment.marta_truth_state", marta)
	state.record_decision(&"marta_truth_state", marta)
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", scope)
	state.record_decision(&"jakub_consent_state", scope)
	state.record_decision(&"world_recognized", true)
	state.record_decision(&"local_lena_search_committed", true)


func ordered(joined: String, first: String, second: String, message: String) -> void:
	expect(joined.contains(first) and joined.contains(second) and joined.find(first) < joined.find(second), message)


func run_a(state: Node) -> void:
	var station := await open_finale("a")
	await act(station, "forced_return_latch")
	expect(bool(state.decisions.get(&"p9.finale.forced_return.executed", false)), "42A latch must execute the return")
	expect(String(state.decisions.get(&"ending_family", "")) == "force_home", "42A must commit force_home")
	expect(state.save_campaign(), "save after 42A execution")
	state.reset_campaign(false)
	expect(state.reload_campaign_from_disk(), "reload after 42A execution")
	expect(bool(state.decisions.get(&"p9.finale.forced_return.executed", false)), "reload must keep the executed return")
	expect(String(state.decisions.get(&"ending_family", "")) == "force_home", "reload must keep the ending family")
	await act(station, "sealed_other_lena")
	expect(bool(state.decisions.get(&"p9.finale.forced_return.local_lena_sealed", false)), "42A must seal the other Lena without inventing her answer")
	await act(station, "household_consequence")
	var household: Variant = state.decisions.get(&"p9.finale.forced_return.household_consequence", {})
	expect(household is Dictionary, "42A household must be a JSON-safe dictionary")
	if household is Dictionary:
		expect(String(household.get("marta", "")) == "full", "42A must carry the full truth")
		expect(String(household.get("jakub", "")) == "granted", "42A must carry the granted scope")
	expect(String(state.decisions.get(&"p9.finale.forced_return.trace", "")) == "forced_return_local_lena_sealed", "42A trace must name the sealing")
	expect(state.decisions.has(&"ending_stability"), "42A must record ending_stability")
	await close_finale(station, "a")


func run_b(state: Node) -> void:
	var station := await open_finale("b")
	await act(station, "flow_closure")
	expect(bool(state.decisions.get(&"p9.finale.close_equal.flow_closed", false)), "42B must close the flow")
	expect(bool(state.decisions.get(&"p9.finale.close_equal.executed", false)), "42B must record execution")
	await act(station, "local_lena_recovered")
	expect(bool(state.decisions.get(&"p9.finale.close_equal.local_lena_recovered", false)), "42B must recover the local Lena as a recognizable person")
	await act(station, "household_consequence")
	var household: Variant = state.decisions.get(&"p9.finale.close_equal.household_consequence", {})
	expect(household is Dictionary, "42B household must be a JSON-safe dictionary")
	if household is Dictionary:
		expect(String(household.get("marta", "")) == "partial", "42B must carry the partial truth")
		expect(String(household.get("jakub", "")) == "limited", "42B must carry the limited scope")
		expect(String(household.get("local_lena", "")) == "recovered_in_body", "42B must name the recovered local Lena")
		expect(String(household.get("arrived_lena", "")) == "unindexed_presence", "42B must name the unindexed arrived presence")
	expect(String(state.decisions.get(&"p9.finale.close_equal.trace", "")) == "close_equal_local_lena_recovered", "42B trace must name the recovery")
	expect(state.save_campaign(), "save after 42B household")
	state.reset_campaign(false)
	expect(state.reload_campaign_from_disk(), "reload after 42B household")
	expect(bool(state.decisions.get(&"p9.finale.close_equal.local_lena_recovered", false)), "reload must keep the recovery")
	await close_finale(station, "b")


func run_c(state: Node) -> void:
	var station := await open_finale("c")
	await act(station, "mutual_passage")
	expect(bool(state.decisions.get(&"p9.finale.mutual_passage.passage_opened", false)), "42C must open the mutual passage")
	await act(station, "memory_leak")
	expect(bool(state.decisions.get(&"p9.finale.mutual_passage.memory_leak_accepted", false)), "42C must accept the concrete memory leak")
	await act(station, "household_consequence")
	var household: Variant = state.decisions.get(&"p9.finale.mutual_passage.household_consequence", {})
	expect(household is Dictionary, "42C household must be a JSON-safe dictionary")
	if household is Dictionary:
		expect(String(household.get("marta", "")) == "withheld", "42C must carry the withheld truth")
		expect(String(household.get("jakub", "")) == "refused", "42C must carry the refused scope")
	expect(String(state.decisions.get(&"ending_stability", "")) == "withheld_or_refused_gaps", "42C must record the gap quality")
	# Exit completion with the presenter attached is owned by PKG-0167..0169
	# (which instantiate these same scenes, presenter included, and drive the
	# ThresholdBinder path there); this gate owns delivery, facts and skip.
	await close_finale(station, "c")


func check_43_branch(state: Node, family: String, stability: String, marta: String, scope: String, household: Dictionary) -> Node:
	station_tag = "43" + family
	state.reset_campaign(true)
	state.record_decision(&"ending_family", family)
	state.record_decision(&"ending_stability", stability)
	state.record_decision(&"p9.method_commitment.marta_truth_state", marta)
	state.record_decision(&"jakub_consent_state", scope)
	if family == "force_home":
		state.record_decision(&"p9.finale.forced_return.executed", true)
		state.record_decision(&"p9.finale.forced_return.household_consequence", household)
	elif family == "close_equal_recover_local":
		state.record_decision(&"p9.finale.close_equal.executed", true)
		state.record_decision(&"p9.finale.close_equal.household_consequence", household)
	elif family == "mutual_passage":
		state.record_decision(&"p9.finale.mutual_passage.executed", true)
		state.record_decision(&"p9.finale.mutual_passage.household_consequence", household)
	var station := (load("res://scenes/levels/station_43.tscn") as PackedScene).instantiate()
	root.add_child(station)
	station.get_node("CRTDialogueBox").line_started.connect(func(speaker: StringName, text: String) -> void:
		last_line = String(speaker) + ": " + text
		delivered.append(last_line))
	for i in range(3):
		await process_frame
		await physics_frame
	return station


func settle_box(station: Node) -> void:
	var box := station.get_node("CRTDialogueBox") as CRTDialogueBox
	for i in range(150):
		if bool(box.get("_typing")):
			await process_frame
		else:
			break


func drive_43_props(state: Node, station: Node) -> void:
	var props := station.get_node("Props")
	for id in ["prop_admin_notice_board", "prop_credits_roll"]:
		for prop in props.get_children():
			if prop is MemoryResonancePoint and prop.resonance_id == id:
				prop.trigger_interaction()
				await process_frame
				await physics_frame
		await settle_box(station)
		await frame_capture("board")
	expect(bool(station.get("is_notice_inspected")), "43 notice must stay inspectable")
	expect(bool(station.get("is_credits_inspected")), "43 credits must stay inspectable")
	for prop in props.get_children():
		if prop is MemoryResonancePoint and prop.resonance_id == "prop_final_blackout":
			prop.trigger_interaction()
			await process_frame
			await physics_frame
	expect(bool(station.get("is_blackout_inspected")), "43 blackout must stay inspectable")
	# Blackout completes the campaign and returns to title by design; the
	# overlay below is the shell menu, not epilogue content.
	await frame_capture("totitle")


func run() -> void:
	capture = OS.get_cmdline_user_args().has("--capture")
	root.size = Vector2i(640, 360)
	if capture:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports/pkg_0195/visual_final"))
	var state := root.get_node("GameStateManager")
	# Settings hygiene: vignette views auto-save settings to disk, so a scale
	# loop that shows vignettes would otherwise persist the last scale (and
	# seen flags) for the next suite in this or a later process (this broke
	# PKG-0113's exact pause-panel size after a 1.15 run). Normalize on entry
	# and restore on exit.
	state.text_scale = 1.0
	state.cinematics_seen.clear()
	state.save_settings_to_disk()
	# Like PKG-0170: blackout must record completion without swapping the
	# live scene to title mid-harness (clean captures, stable node tree).
	state.campaign_auto_transition_enabled = false
	# Run A: forced home, full truth, granted scope.
	state.cinematics_seen.clear()
	delivered.clear()
	seed_finale(state, "force_home", "full", "granted")
	await run_a(state)
	var joined_a := "\n".join(delivered)
	for required in ["Numer domowy", "Kładę czytnik", "BŁĄD CZUJNIKA", "Najpierw wykonanie", "cisza, nie głos", "między adresami", "Gdzie byłaś?", "Najpierw posłuchaj próbki", "drugie", "pierwszej ręki", "Kontrola utrzymana"]:
		expect(joined_a.contains(required), "run A delivered line: " + required)
	ordered(joined_a, "Najpierw wykonanie", "cisza, nie głos", "42A execution must precede effect reading")
	ordered(joined_a, "Gdzie byłaś?", "Kontrola utrzymana", "42A household must follow the sealed reading")
	# Run B: closure, partial truth, limited scope.
	state.cinematics_seen.clear()
	delivered.clear()
	seed_finale(state, "close_equal_recover_local", "partial", "limited")
	await run_b(state)
	var joined_b := "\n".join(delivered)
	# PKG-0237 (D4): 42B nie zawiera wiaty z linii 03 (jedno miejsce na kwestie:
	# prog m. 14, "Stoję w progu. Czytnik nie ma tu adresu.").
	for required in ["Jej adres wrócił", "Wygaszam domową sygnaturę", "po jej powrocie", "Co wiedziałaś przed testem?", "Próbę zrobiłam sama", "twój oddech", "Stoję w progu", "brak w sieci", "bez szczegółu próby", "swoim zakresie", "Eksport kosztów"]:
		expect(joined_b.contains(required), "run B delivered line: " + required)
	ordered(joined_b, "Wygaszam domową sygnaturę", "Co wiedziałaś", "42B closure must precede the recovery scene")
	ordered(joined_b, "Co wiedziałaś", "Stoję w progu", "42B recovery scene must precede the arrived perspective cut")
	# Run C: mutual passage, withheld truth, refused scope.
	state.cinematics_seen.clear()
	delivered.clear()
	seed_finale(state, "mutual_passage", "withheld", "refused")
	await run_c(state)
	var joined_c := "\n".join(delivered)
	for required in ["Dwa adresy", "Otwieram, nie zabieram", "prosektorium", "mój pogrzeb", "Wracam do napędu", "brakująca sekunda", "Milczysz", "z zapisem", "odpowie za przeciek", "Przed własnymi domami", "wyłączności", "wspólny ubytek"]:
		expect(joined_c.contains(required), "run C delivered line: " + required)
	ordered(joined_c, "Otwieram, nie zabieram", "prosektorium", "42C opening must precede the leak reading")
	expect(vignette_count == 3, "three routes must each display and skip one finale vignette, got %d" % vignette_count)
	# Reread on the same instance after save/reload (0193 pattern): writers must
	# refuse a second commit (no new facts, no vignette replay) while the
	# household conversation is redelivered.
	expect(state.save_campaign(), "save after 42C household")
	state.reset_campaign(false)
	expect(state.reload_campaign_from_disk(), "reload after 42C household")
	expect(String(state.decisions.get(&"p9.finale.mutual_passage.trace", "")) == "mutual_passage_memory_leak_accepted", "reload must keep the 42C trace")
	var seen_before_reread: int = vignette_count
	state.cinematics_seen.clear()
	delivered.clear()
	var fresh_c := await open_finale("c")
	# Fresh instance, same committed facts: the camera shows the vignette once.
	await act(fresh_c, "mutual_passage")
	await act(fresh_c, "memory_leak")
	await act(fresh_c, "household_consequence")
	expect(vignette_count == seen_before_reread + 1, "fresh camera must show the vignette once")
	delivered.clear()
	await act(fresh_c, "household_consequence")
	expect("\n".join(delivered).contains("wyłączności"), "reread must redeliver the household conversation")
	expect(vignette_count == seen_before_reread + 1, "reread must not replay the seen vignette")
	expect(String(state.decisions.get(&"p9.finale.mutual_passage.trace", "")) == "mutual_passage_memory_leak_accepted", "reread must not rewrite the trace")
	await close_finale(fresh_c, "c")
	# Unseeded entry must stay informational and never invent voices.
	state.reset_campaign(true)
	delivered.clear()
	var bare := await open_finale("a")
	await act(bare, "forced_return_latch")
	expect(String(state.decisions.get(&"p9.finale.forced_return.safe_trial_feedback", "")) == "method_force_home_required", "latch without the method must stay informational")
	expect(not state.decisions.has(&"p9.finale.forced_return.executed"), "failed attempt must grant no execution")
	expect(not state.decisions.has(&"ending_family"), "failed attempt must grant no ending family")
	expect("\n".join(delivered).contains("Brakuje mi wcześniejszego źródła"), "unseeded latch must serve the missing-source fallback")
	expect(not "\n".join(delivered).contains("między adresami"), "unseeded latch must not speak the sealed effect")
	bare.queue_free()
	await process_frame
	# 43: branch consequences without the orphaned line and without the thesis.
	var s43a := await check_43_branch(state, "force_home", "named_gaps", "full", "granted", {"marta": "full", "jakub": "granted"})
	expect(s43a.dialogue_lines.size() >= 5, "43A dialogue keeps five lines")
	expect(s43a.dialogue_lines[4]["text"].contains("Rubrykę przyczyny"), "43A must close with the concrete sample gesture")
	await drive_43_props(state, s43a)
	s43a.queue_free()
	await process_frame
	var s43b := await check_43_branch(state, "close_equal_recover_local", "partial_gaps", "partial", "limited", {"marta": "partial", "jakub": "limited"})
	var joined_43b: String = ""
	for line in s43b.dialogue_lines:
		joined_43b += String(line.get("text", "")) + "\n"
	expect(s43b.dialogue_lines[2]["text"].contains("drugie zgłoszenie"), "43B must replace the orphaned line with the home-Marta consequence")
	expect(s43b.dialogue_lines[4]["text"].contains("Jadę"), "43B must close with the address-less message gesture")
	expect(not joined_43b.contains("Szymon"), "43B must carry no off-screen Szymon encounter")
	expect(not joined_43b.contains("Prawda nie wybiera"), "43 must carry no author thesis")
	expect(not joined_43b.contains("Koniec wycinka"), "43 must carry no cutting-room thesis")
	await drive_43_props(state, s43b)
	s43b.queue_free()
	await process_frame
	var s43c := await check_43_branch(state, "mutual_passage", "withheld_or_refused_gaps", "withheld", "refused", {"marta": "withheld", "jakub": "refused"})
	expect(s43c.dialogue_lines[4]["text"].contains("pustą półkę"), "43C must close with the concrete cup gesture")
	await drive_43_props(state, s43c)
	s43c.queue_free()
	await process_frame
	station_tag = "43u"
	var s43u := await check_43_branch(state, "unseeded", "unseeded", "", "", {})
	expect(s43u.dialogue_lines[4]["text"].contains("klucze na blat"), "43 unseeded must close with the concrete key gesture")
	await drive_43_props(state, s43u)
	s43u.queue_free()
	await process_frame
	var source_43 := FileAccess.get_file_as_string("res://scripts/levels/station_43.gd")
	expect(not source_43.contains("Szymon"), "station_43.gd must not stage Szymon on the route (CR-D01)")
	expect(not source_43.contains("Prawda nie wybiera"), "station_43.gd must not moralize in the author's voice")
	for path in ["res://scripts/levels/station_42a.gd", "res://scripts/levels/station_42b.gd", "res://scripts/levels/station_42c.gd"]:
		var source := FileAccess.get_file_as_string(path)
		for term in ["nie nagroda", "nie ocena", "Obie jesteście prawdziwe"]:
			expect(not source.to_lower().contains(term), "%s must not carry the author thesis: %s" % [path, term])
	# Text scales through the same live finale presentation.
	for scale_value in [0.85, 1.0, 1.15]:
		scale_tag = str(roundi(scale_value * 100))
		state.text_scale = scale_value
		state.cinematics_seen.clear()
		seed_finale(state, "close_equal_recover_local", "partial", "limited")
		var scaled := await open_finale("b")
		await act(scaled, "flow_closure")
		await act(scaled, "local_lena_recovered")
		await act(scaled, "household_consequence")
		await close_finale(scaled, "b")
	state.text_scale = 1.0
	state.cinematics_seen.clear()
	state.save_settings_to_disk()
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	if capture:
		var manifest := FileAccess.open("res://reports/pkg_0195/visual_final/frames.tsv", FileAccess.WRITE)
		manifest.store_string("path\tphase\tlast_line\n" + "\n".join(capture_rows))
		manifest.close()
	if failures.is_empty():
		print("PKG-0195 PASS: real MRP input, delivered CR-C finale conversations, perspective cut, concrete leak, 43 without Szymon or thesis, reload, skip and text scales")
		quit(0)
	else:
		quit(1)
