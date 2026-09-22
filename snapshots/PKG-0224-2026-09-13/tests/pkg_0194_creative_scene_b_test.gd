extends SceneTree

## PKG-0194 / CR-B: odpowiedź, koszt i cudza zgoda (stacje 14-18).
##
## Real MRP input -> station writer -> delivered CRT lines, plus reload/skip.
## The harness selects an input target explicitly; it does not prove traversal.
## Covers: both dead-circuit behaviors (14), conscious arming of the third
## impulse in the same transmitter (15), two cost branches with carrier
## variants (16), three consent scopes incl. the equal `limited` line (17),
## three truth states and consent-dependent forecasts (18), missing sources,
## the D-211 knowledge gate replacing the old pkg_0165 static vocabulary ban,
## save/reload before/after commit, finale routing 18->42A/B/C, text scales.
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")
const GapLedger := preload("res://scripts/campaign/gap_ledger.gd")

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
		printerr("PKG-0194 FAILURE: " + message)


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
	var path := "res://reports/pkg_0194/visual_final/s%02d_%s_%03d_%s.png" % [station_number, scale_tag, capture_index, label]
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


func open_station(number: int) -> Node:
	station_number = number
	var station := (load("res://scenes/levels/station_%02d.tscn" % number) as PackedScene).instantiate()
	root.add_child(station)
	expect(station.get_node_or_null("CreativeScenePresentation") != null, "station %d must attach the local presentation owner" % number)
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


func close_station(station: Node) -> void:
	GapLedger.record_on_depart(station)
	var state := root.get_node("GameStateManager")
	for gap_id in state.open_gaps:
		expect(state.open_gaps[gap_id].get("origin_station", "") != "station_%02d" % station_number, "resolved current facts must close this station's gap")
	station.queue_free()
	await process_frame


## Full 13-synthesis chain: contact at the mandatory first reading, both
## opening branches, all three evidence families and both source markers.
## CR-D §2 causality: layer-B reading establishes contact on both branches;
## only the repeat secures the full sample and delays the return.
func seed_recognition(state: Node, sample: bool) -> void:
	state.record_decision(&"home_sample_preserved", sample)
	state.record_decision(&"p9.mystery.home.trace", "two_lives_without_claim")
	state.record_decision(&"p9.mystery.institution.trace", "ucp_profile_against_memory")
	state.record_decision(&"p9.mystery.jakub.trace", "voice_before_person")
	state.record_decision(&"recognition_evidence_public", true)
	state.record_decision(&"recognition_evidence_relational", true)
	state.record_decision(&"recognition_evidence_carried", true)
	state.record_decision(&"p9.mystery.synthesis.marta_source_seen", true)
	state.record_decision(&"p9.mystery.synthesis.institution_source_seen", true)
	state.record_decision(&"world_recognized", true)
	state.record_decision(&"local_lena_search_committed", true)


func run_14(state: Node) -> void:
	var station := await open_station(14)
	await act(station, "relay_logbook")
	expect(state.decisions.has(&"p9.mechanics.dead_circuit.cycle_observed"), "14 must observe the machine cycle")
	expect(bool(station.call("hold_observed_element")), "14 must hold the bridge")
	station.call("run_correction_pulse")
	expect(bool(station.get("has_anchored_through_pulse")), "14 must keep one behavior through the pulse")
	expect(bool(station.call("release_observed_element")), "14 must yield the bridge")
	station.call("run_correction_pulse")
	expect(bool(station.get("has_yielded_to_pulse")), "14 must keep the second behavior")
	station.call("run_correction_pulse")
	expect(bool(station.get("are_behaviors_named")), "14 must name both behaviors")
	await act(station, "relay_logbook")
	await close_station(station)


func run_15(state: Node) -> void:
	var station := await open_station(15)
	await act(station, "loop_logbook")
	expect(bool(state.decisions.get(&"ucp_intervention_reconstructed", false)), "15 log must separate local intent from the later UCP intervention")
	await act(station, "signal_sender")
	station.call("run_response_cycle")
	await drain(station)
	await act(station, "signal_sender")
	station.call("run_response_cycle")
	await drain(station)
	expect(String(state.decisions.get(&"p9.mechanics.mutual_signal.control_echo_observed", "")) == "echo_repeats_identically", "15 controls must return an identical echo")
	await act(station, "signal_sender")
	expect(bool(station.get("is_error_pattern_armed")), "15 third pattern must be armed by an explicit act in the same transmitter")
	expect(not bool(state.decisions.get(&"local_lena_signal_confirmed", false)), "arming alone must confirm nothing")
	await act(station, "signal_sender")
	station.call("run_response_cycle")
	await drain(station)
	expect(bool(state.decisions.get(&"local_lena_signal_confirmed", false)), "15 selective correction must confirm the living signal")
	await act(station, "abort_note")
	expect(bool(state.decisions.get(&"local_lena_intent_found", false)), "15 note must carry abort-after-silence without prior consent")
	expect(bool(station.get("is_exit_unlocked")), "15 note must open the hatch")
	await close_station(station)


func run_16(state: Node, cost: String, sample: bool) -> void:
	var station := await open_station(16)
	await act(station, "safe_analyzer")
	var selector := station.get_node("Props/CostSelector") as MemoryResonancePoint
	var player := station.get_node("Player") as PrototypePlayer
	if cost == "sample_second":
		player.global_position = Vector2(selector.global_position.x + 60.0, 296.0)
	else:
		player.global_position = Vector2(selector.global_position.x - 60.0, 296.0)
	await act(station, "cost_selector")
	if cost == "sample_second":
		expect(String(state.decisions.get(&"small_cost_manifested", "")) == "sample_exact_second_lost", "16 sample branch must blur the exact second")
	else:
		expect(String(state.decisions.get(&"small_cost_manifested", "")) == "marta_first_meeting_detail_blurred", "16 memory branch must blur the meeting detail")
	await act(station, "home_echo_receiver")
	expect(bool(state.decisions.get(&"home_echo_verified", false)), "16 echo must exclude the simple swap")
	await close_station(station)


func run_17(state: Node, scope: String, with_completion: bool) -> void:
	var station := await open_station(17)
	await act(station, "cost_ledger_console")
	expect(bool(state.decisions.get(&"ucp_cost_ledger_found", false)), "17 ledger must name the Line 4 pair")
	await act(station, "adaptation_offer_terminal")
	expect(String(state.decisions.get(&"p9.consent_and_cost.adaptation_offer", "")) == "rejected", "17 offer must stay rejectable")
	var desk := station.get_node("Props/ConsentScopeDesk") as Node2D
	var player := station.get_node("Player") as PrototypePlayer
	if scope == "granted":
		player.global_position = Vector2(desk.global_position.x + 60.0, 296.0)
	elif scope == "refused":
		player.global_position = Vector2(desk.global_position.x - 60.0, 296.0)
	else:
		player.global_position = Vector2(desk.global_position.x, 296.0)
	await act(station, "consent_scope_desk")
	expect(String(state.decisions.get(&"jakub_consent_state", "")) == scope, "17 must record the explicit scope " + scope)
	expect(bool(station.get("is_exit_unlocked")), "17 scope must never softlock the exit")
	if with_completion:
		_ThresholdBinder.install(station)
		_ThresholdBinder.complete_from_test(station, player)
		await physics_frame
		await physics_frame
		expect(bool(station.get("is_level_completed")), "17 must complete in the AirlockZone")
	await close_station(station)


func run_18(state: Node, truth: String, method: String, scope: String) -> void:
	var station := await open_station(18)
	await act(station, "forecast_comparator")
	expect(bool(state.decisions.get(&"route_hypotheses_mapped", false)), "18 must map forecasts against the current consent")
	var table := station.get_node("Props/MartaTruthTable") as Node2D
	var player := station.get_node("Player") as PrototypePlayer
	if truth == "full":
		player.global_position = Vector2(table.global_position.x + 60.0, 296.0)
	elif truth == "withheld":
		player.global_position = Vector2(table.global_position.x - 60.0, 296.0)
	else:
		player.global_position = Vector2(table.global_position.x, 296.0)
	await act(station, "marta_truth_table")
	expect(String(state.decisions.get(&"marta_truth_state", "")) == truth, "18 must record the truth state " + truth)
	var post := station.get_node("Props/MethodCommitPost") as Node2D
	if method == "force_home":
		player.global_position = Vector2(post.global_position.x - 60.0, 296.0)
	elif method == "mutual_passage":
		player.global_position = Vector2(post.global_position.x + 60.0, 296.0)
	else:
		player.global_position = Vector2(post.global_position.x, 296.0)
	await act(station, "method_commit_post")
	expect(String(state.decisions.get(&"method_committed", "")) == method, "18 must commit " + method)
	await close_station(station)


func ordered(joined: String, first: String, second: String, message: String) -> void:
	expect(joined.contains(first) and joined.contains(second) and joined.find(first) < joined.find(second), message)


func run() -> void:
	capture = OS.get_cmdline_user_args().has("--capture")
	root.size = Vector2i(640, 360)
	if capture:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports/pkg_0194/visual_final"))
	var state := root.get_node("GameStateManager")
	var old_scale: float = state.text_scale
	# Run A: sample kept, memory cost, full consent, full truth, forced home.
	state.reset_campaign(true)
	state.cinematics_seen.clear()
	state.text_scale = 1.0
	delivered.clear()
	seed_recognition(state, true)
	await run_14(state)
	await run_15(state)
	await run_16(state, "marta_memory", true)
	expect(state.save_campaign(), "save before consent inventory")
	state.reset_campaign(false)
	expect(state.reload_campaign_from_disk(), "reload before consent inventory")
	expect(String(state.decisions.get(&"p9.mechanics.small_cost.choice", "")) == "marta_memory", "reload must keep the cost choice")
	expect(bool(state.decisions.get(&"home_echo_verified", false)), "reload must keep the home echo")
	await run_17(state, "granted", true)
	await run_18(state, "full", "force_home", "granted")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42a", "force_home must route 18->42A")
	var joined_a := "\n".join(delivered)
	for required in ["fala korekty co siedem sekund", "Zakotwiczenie i uległość", "Kontakt przy pierwszym odczycie", "Wyjście na czas: sam czytnik", "Próbę ktoś przerwał z zewnątrz", "Dwa identyczne echa", "poprawiła tylko mój celowy błąd", "Bez jej zgody nie powtarzaj", "kurtka na kaloryferze", "Twoja kurtka była", "zgłosiłam zaginięcie", "nie podmiana", "Ktoś utrzymuje zapis", "wygodnym zastępstwem", "przed końcem zmiany", "Dziesięć.", "Wiedziała czy zapytała", "Pomogę ją wyciągnąć", "Staję przy słupku sama"]:
		expect(joined_a.contains(required), "run A delivered line: " + required)
	ordered(joined_a, "Albo szczegół spotkania", "Twoja kurtka była", "alternatives must precede the concrete loss")
	ordered(joined_a, "Dwa identyczne echa", "poprawiła tylko mój celowy błąd", "arming must precede the correction")
	ordered(joined_a, "Ktoś utrzymuje zapis", "wygodnym zastępstwem", "ledger must precede the offer")
	ordered(joined_a, "wygodnym zastępstwem", "Mój nadajnik, moja ręka na wyłączniku", "offer must precede the consent answer")
	ordered(joined_a, "chroni mój powrót", "Wiedziała czy zapytała", "forecasts must precede the truth")
	ordered(joined_a, "Pomogę ją wyciągnąć", "Staję przy słupku sama", "truth must precede the commit")
	expect(state.save_campaign(), "save after commit")
	state.reset_campaign(false)
	expect(state.reload_campaign_from_disk(), "reload after commit")
	expect(String(state.decisions.get(&"method_committed", "")) == "force_home", "reload must keep the committed method")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42a", "reload must keep finale routing")
	var revisit := await open_station(18)
	expect(find_vignette(revisit) == null, "post-commit revisit must not replay the vignette")
	revisit.queue_free()
	await process_frame
	# Run B: sample kept, sample cost, limited consent, partial truth, closure.
	state.reset_campaign(true)
	state.cinematics_seen.clear()
	delivered.clear()
	seed_recognition(state, true)
	await run_14(state)
	await run_15(state)
	await run_16(state, "sample_second", true)
	await run_17(state, "limited", false)
	await run_18(state, "partial", "close_equal_recover_local", "limited")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42b", "close_equal must route 18->42B")
	var joined_b := "\n".join(delivered)
	for required in ["Sekunda 20:40:07", "Pamięć Marty zostaje cała", "Nadajnika do mnie nie podłączysz", "Tyle wystarczy", "Wymuszenie domu: brak", "Mówię Marcie o sygnale", "Nie przy legendzie", "Oddaję jej miejsce"]:
		expect(joined_b.contains(required), "run B delivered line: " + required)
	# Run C: no sample carried, sample cost from the reader buffer, refusal,
	# withheld truth, mutual passage. Must never speak of a kept full carrier.
	state.reset_campaign(true)
	state.cinematics_seen.clear()
	delivered.clear()
	seed_recognition(state, false)
	await run_14(state)
	await run_15(state)
	await run_16(state, "sample_second", false)
	await run_17(state, "refused", false)
	await run_18(state, "withheld", "mutual_passage", "refused")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42c", "mutual_passage must route 18->42C")
	var joined_c := "\n".join(delivered)
	for required in ["Próbki nie zabezpieczyłam", "Odmowa zamyka metody na jego relacji", "Nie ze mną, Lena", "Milczysz. To też jest odpowiedź", "Otwieram, nie zabieram"]:
		expect(joined_c.contains(required), "run C delivered line: " + required)
	expect(not joined_c.contains("surowej próbki"), "branch without a kept sample must not speak of a full carrier")
	expect(vignette_count == 6, "three routes must each display and skip both vignettes, got %d" % vignette_count)
	# Missing sources must stay informational and never invent content.
	state.reset_campaign(true)
	delivered.clear()
	var bare15 := await open_station(15)
	await act(bare15, "signal_sender")
	expect(String(state.decisions.get(&"p9.mechanics.mutual_signal.safe_trial_feedback", "")) == "sender_not_armed", "sender without the log must stay informational")
	expect(not state.decisions.has(&"local_lena_signal_confirmed"), "failed attempt must grant no signal")
	bare15.queue_free()
	await process_frame
	var bare17 := await open_station(17)
	await act(bare17, "cost_ledger_console")
	expect(String(state.decisions.get(&"p9.consent_and_cost.safe_trial_feedback", "")) == "institution_trial_required", "ledger without donor facts must stay informational")
	expect(not state.decisions.has(&"ucp_cost_ledger_found"), "failed ledger must grant no canonical fact")
	bare17.queue_free()
	await process_frame
	var bare18 := await open_station(18)
	await act(bare18, "forecast_comparator")
	expect(String(state.decisions.get(&"p9.method_commitment.safe_trial_feedback", "")) == "consent_scope_required", "forecasts without donor facts must stay informational")
	expect(not state.decisions.has(&"route_hypotheses_mapped"), "failed forecasts must grant no canonical fact")
	bare18.queue_free()
	await process_frame
	expect(not "\n".join(delivered).contains("Równi"), "missing sources must never speak recognition vocabulary")
	# D-211 knowledge gate: resolved mechanics without recognition serve the
	# knowledge fallback; after recognition the same point serves the ledger.
	# This is the named replacement for the old pkg_0165 static vocabulary ban:
	# station_17.gd stays free of the terms AND presented text is gated on
	# knowledge state instead of being banned everywhere.
	state.reset_campaign(true)
	state.record_decision(&"p7.work_history_and_record.institution_trial_result", "small_cost_and_home_echo_confirmed")
	state.record_decision(&"p9.mechanics.small_cost.manifested", "marta_first_meeting_detail_blurred")
	state.record_decision(&"p9.mechanics.small_cost.home_echo_verified", true)
	state.record_decision(&"mechanic_cost_observed", true)
	state.record_decision(&"home_echo_verified", true)
	delivered.clear()
	var gated := await open_station(17)
	await act(gated, "cost_ledger_console")
	expect(bool(state.decisions.get(&"ucp_cost_ledger_found", false)), "ledger mechanics must resolve on donor facts alone")
	expect("\n".join(delivered).contains("Najpierw muszę nazwać"), "unrecognized ledger must serve the knowledge fallback")
	expect(not "\n".join(delivered).contains("Równi"), "unrecognized ledger must withhold recognition vocabulary")
	state.record_decision(&"world_recognized", true)
	await act(gated, "cost_ledger_console")
	expect("\n".join(delivered).contains("Równi"), "reread after recognition must serve the ledger pair")
	var station17_source := FileAccess.get_file_as_string("res://scripts/levels/station_17.gd").to_lower()
	for term in ["rówień", "miejscowa lena", "inny świat", "anchor/yield"]:
		expect(not station17_source.contains(term), "D-211: station_17.gd keeps the pkg_0165 ban: " + term)
	gated.queue_free()
	await process_frame
	# Text scales through the same live action presentation.
	for scale_value in [0.85, 1.0, 1.15]:
		scale_tag = str(roundi(scale_value * 100))
		state.text_scale = scale_value
		state.reset_campaign(true)
		state.cinematics_seen.clear()
		seed_recognition(state, true)
		state.record_decision(&"p7.work_history_and_record.institution_trial_result", "small_cost_and_home_echo_confirmed")
		state.record_decision(&"p9.mechanics.small_cost.manifested", "marta_first_meeting_detail_blurred")
		state.record_decision(&"p9.mechanics.small_cost.home_echo_verified", true)
		state.record_decision(&"mechanic_cost_observed", true)
		state.record_decision(&"home_echo_verified", true)
		var scaled := await open_station(17)
		await act(scaled, "cost_ledger_console")
		await act(scaled, "adaptation_offer_terminal")
		var desk := scaled.get_node("Props/ConsentScopeDesk") as Node2D
		var player := scaled.get_node("Player") as PrototypePlayer
		player.global_position = Vector2(desk.global_position.x, 296.0)
		await act(scaled, "consent_scope_desk")
		scaled.queue_free()
		await process_frame
	state.text_scale = old_scale
	if capture:
		var manifest := FileAccess.open("res://reports/pkg_0194/visual_final/frames.tsv", FileAccess.WRITE)
		manifest.store_string("path\tphase\tlast_line\n" + "\n".join(capture_rows))
		manifest.close()
	if failures.is_empty():
		print("PKG-0194 PASS: real MRP input, delivered CR-B conversations, cost branches, three scopes, three truths, knowledge gate, reload, skip and text scales")
		quit(0)
	else:
		quit(1)
