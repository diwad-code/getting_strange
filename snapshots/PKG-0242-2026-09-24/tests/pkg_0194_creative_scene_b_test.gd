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
## PKG-0242 (R1): runs follow the PKG-0239 two-visit chain (17 scope → 18
## names the method → 17 Jakub answers → 18 commits) and the owner's text.
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")
const GapLedger := preload("res://scripts/campaign/gap_ledger.gd")
const NarrativeRules := preload("res://scripts/levels/narrative_repair_rules.gd")
const CampaignChain := preload("res://tests/support/campaign_chain.gd")

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


## PKG-0242 (R1, PKG-0239): the method is a conversation across two visits.
## First visit to 18: forecasts, Marta's truth by side, and one method named
## at the post. A repeated press at the same side must not commit and must not
## replay the risk table; for mutual passage Marta answers about the key.
func run_18_propose(state: Node, truth: String, method: String, sync := "") -> void:
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
	await name_method(station, method)
	expect(String(state.decisions.get(NarrativeRules.PROPOSED_KEY, "")) == method, "18 must name " + method)
	expect(not state.decisions.has(&"method_committed"), "18 must name before committing")
	var lines_before := delivered.size()
	await act(station, "method_commit_post")
	expect(not state.decisions.has(&"method_committed"), "a named method without Jakub's answer must not commit")
	var repeat := "\n".join(delivered.slice(lines_before))
	expect(not repeat.contains("CZYTNIK — PROGNOZA"), "a repeated press must not replay the risk table")
	expect(repeat.contains("wrócę do Jakuba") or repeat.contains("odpowiedział: nie"), "a repeated press must say what is still missing")
	if not sync.is_empty():
		player.global_position = Vector2(table.global_position.x + (60.0 if sync == "accepted" else -60.0), 296.0)
		await act(station, "marta_truth_table")
		expect(String(state.decisions.get(NarrativeRules.SYNC_KEY, "")) == sync, "Marta must answer about the key: " + sync)
	# No close_station gap check: the s18 gap is legitimately open until the
	# method is committed on the return visit.
	station.queue_free()
	await process_frame


func name_method(station: Node, method: String) -> void:
	var post := station.get_node("Props/MethodCommitPost") as Node2D
	var player := station.get_node("Player") as PrototypePlayer
	if method == "force_home":
		player.global_position = Vector2(post.global_position.x - 60.0, 296.0)
	elif method == "mutual_passage":
		player.global_position = Vector2(post.global_position.x + 60.0, 296.0)
	else:
		player.global_position = Vector2(post.global_position.x, 296.0)
	await act(station, "method_commit_post")


## Return visit to 17: Jakub answers the one proposed method at the desk
## (right side: agreement, left side: refusal).
func run_17_answer(state: Node, reply: String) -> void:
	var station := await open_station(17)
	var desk := station.get_node("Props/ConsentScopeDesk") as Node2D
	var player := station.get_node("Player") as PrototypePlayer
	player.global_position = Vector2(desk.global_position.x + (60.0 if reply == "accepted" else -60.0), 296.0)
	await act(station, "consent_scope_desk")
	var method := String(state.decisions.get(NarrativeRules.PROPOSED_KEY, ""))
	expect(NarrativeRules.response(state.decisions, method) == reply, "17 must record Jakub's %s for %s" % [reply, method])
	await close_station(station)


## Return visit to 18: the same side commits.
func run_18_commit(state: Node, method: String) -> void:
	var station := await open_station(18)
	await name_method(station, method)
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
	# PKG-0230: auto-transition wylaczony jak w 0166/smoke/0222. Przy wlaczonym
	# completion 17 laduje w tle druga 18 (change_scene), ktorej prezentacja
	# zjada pressy foregroundu — wyscig niemozliwy w grze (zmiana sceny
	# podmienia), mierzony wylacznie stabilnoscia tego harnessa.
	state.campaign_auto_transition_enabled = false
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
	await run_18_propose(state, "full", "force_home")
	await run_17_answer(state, "accepted")
	await run_18_commit(state, "force_home")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42a", "force_home must route 18->42A")
	var joined_a := "\n".join(delivered)
	# PKG-0242 (R1): pins follow the owner's PKG-0239 text (14-18 rewritten).
	for required in ["Zakotwiczenie i uległość", "Kontakt nastąpił przy pierwszym odczycie", "Powtórka dała mi próbkę", "Próbę zaczęła ona", "Impuls kontrolny wraca identyczny", "Poprawiony został tylko mój błąd", "Bez jej zgody nie powtarzaj", "własną pamięć rozmowy o kurtce", "Powiedziałam: na kaloryferze", "Zgłosiłam twoje zaginięcie", "podważa prostą zamianę", "Linia 4: utrzymanie wyniku lokalnego", "Wpiszemy panią w miejsce Leny Wolskiej", "Nie podpiszę", "Najpierw pokaż konkretną metodę", "przed końcem zmiany", "Jakub dopuszcza rozmowę o próbie", "Chciała zmierzyć eksport kosztu", "Pomogę ją wyciągnąć", "wrócę do Jakuba", "Potwierdzę wskazanie", "Wybieram własny powrót"]:
		expect(joined_a.contains(required), "run A delivered line: " + required)
	ordered(joined_a, "Wybierz nośnik ubytku", "Wybieram własną pamięć dzisiejszego zdania", "alternatives must precede the concrete loss")
	ordered(joined_a, "W trzecim odwracam tylko ostatni impuls", "Poprawiony został tylko mój błąd", "arming must precede the correction")
	ordered(joined_a, "Linia 4: utrzymanie wyniku lokalnego", "Wpiszemy panią w miejsce", "ledger must precede the offer")
	ordered(joined_a, "Nie podpiszę", "Najpierw pokaż konkretną metodę", "offer must precede the consent answer")
	ordered(joined_a, "Jakub dopuszcza rozmowę o próbie", "Chciała zmierzyć eksport kosztu", "forecasts must precede the truth")
	ordered(joined_a, "Pomogę ją wyciągnąć", "wrócę do Jakuba", "truth must precede the proposal")
	ordered(joined_a, "wrócę do Jakuba", "Potwierdzę wskazanie", "the proposal must precede Jakub's answer")
	ordered(joined_a, "Potwierdzę wskazanie", "Wybieram własny powrót", "Jakub's answer must precede the commit")
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
	await run_18_propose(state, "partial", "close_equal_recover_local")
	await run_17_answer(state, "accepted")
	await run_18_commit(state, "close_equal_recover_local")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42b", "close_equal must route 18->42B")
	var joined_b := "\n".join(delivered)
	for required in ["20:40:07 — fragment utracony", "Dzisiejszą rozmowę z Martą pamiętam", "bez podłączenia do człowieka", "Ten zakres zostaje", "Jakub dopuszcza tylko wskazania", "Mamy sposób, żeby spróbować ją odzyskać", "Na razie jej nie pokażę", "Tylko wskazania. Na to się zgadzam", "Wybieram odzyskanie miejscowej"]:
		expect(joined_b.contains(required), "run B delivered line: " + required)
	# Run C: no sample carried, sample cost from the reader buffer, refusal,
	# withheld truth. After the refusal Jakub takes part in no method; mutual
	# passage is named and blocked, then only the separate reading-only
	# proposal for recovering the local Lena may be asked (PKG-0239) —
	# Jakub accepts it and closure commits to 42B. The run must never speak of
	# a kept full carrier.
	state.reset_campaign(true)
	state.cinematics_seen.clear()
	delivered.clear()
	seed_recognition(state, false)
	await run_14(state)
	await run_15(state)
	await run_16(state, "sample_second", false)
	await run_17(state, "refused", false)
	var blocked := await open_station(18)
	await act(blocked, "forecast_comparator")
	expect(bool(state.decisions.get(&"route_hypotheses_mapped", false)), "blocked run must still map forecasts")
	var btable := blocked.get_node("Props/MartaTruthTable") as Node2D
	var bplayer := blocked.get_node("Player") as PrototypePlayer
	bplayer.global_position = Vector2(btable.global_position.x - 60.0, 296.0)
	await act(blocked, "marta_truth_table")
	expect(String(state.decisions.get(&"marta_truth_state", "")) == "withheld", "blocked run keeps withheld truth")
	await name_method(blocked, "mutual_passage")
	await name_method(blocked, "mutual_passage")
	expect(not state.decisions.has(&"method_committed"), "refusal must block the commit")
	await name_method(blocked, "close_equal_recover_local")
	expect(String(state.decisions.get(NarrativeRules.PROPOSED_KEY, "")) == "close_equal_recover_local", "after the block Lena may name the reading-only recovery")
	blocked.queue_free()
	await process_frame
	await run_17_answer(state, "accepted")
	expect(String(state.decisions.get(&"p9.consent_and_cost.revised_reading_response", "")) == "accepted", "Jakub must answer the separate reading-only proposal")
	expect(String(state.decisions.get(&"jakub_consent_state", "")) == "limited", "an accepted reading-only proposal narrows the scope to limited")
	await run_18_commit(state, "close_equal_recover_local")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42b", "revised reading must route 18->42B")
	var joined_c := "\n".join(delivered)
	for required in ["Nie mam pełnej próbki. Wybieram sekundę bufora", "Nie zgadzam się na podłączenie", "Mogę zaproponować osobno sam odczyt", "Nie zgodzę się w ciemno na twój plan", "Teraz proszę tylko o odczyt przy odzyskaniu jej", "Wybieram odzyskanie miejscowej"]:
		expect(joined_c.contains(required), "run C delivered line: " + required)
	expect(not joined_c.contains("surowej próbki"), "branch without a kept sample must not speak of a full carrier")
	# Run D: mutual passage needs Jakub's granted scope, the full record and
	# Marta's separate answer about the key. 14-16 are the recorded pre-17
	# input run (CampaignChain), so this run adds only the 18 vignette.
	CampaignChain.seed_before_17(state, "repeat_sample", "marta_memory")
	state.cinematics_seen.clear()
	delivered.clear()
	await run_17(state, "granted", false)
	await run_18_propose(state, "full", "mutual_passage", "accepted")
	await run_17_answer(state, "accepted")
	await run_18_commit(state, "mutual_passage")
	expect(String(state.decisions.get(&"campaign_finale", "")) == "station_42c", "mutual_passage must route 18->42C")
	var joined_d := "\n".join(delivered)
	for required in ["Pytasz o synchronizację", "Zgadzam się użyć klucza", "Biorę udział. Wyłącznik zostaje przy mnie", "Wybieram przejście wzajemne"]:
		expect(joined_d.contains(required), "run D delivered line: " + required)
	ordered(joined_d, "Zgadzam się użyć klucza", "Biorę udział. Wyłącznik zostaje przy mnie", "Marta's key must be asked before Jakub answers")
	# Vignettes: runs A-C play the 15 signal and the 18 commit (2 + 2 + 2),
	# run D only the 18 commit; the proposal visits play none.
	expect(vignette_count == 7, "routes must display and skip vignettes, got %d" % vignette_count)
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
	state.campaign_auto_transition_enabled = true
	if capture:
		var manifest := FileAccess.open("res://reports/pkg_0194/visual_final/frames.tsv", FileAccess.WRITE)
		manifest.store_string("path\tphase\tlast_line\n" + "\n".join(capture_rows))
		manifest.close()
	if failures.is_empty():
		print("PKG-0194 PASS: real MRP input, delivered CR-B conversations, cost branches, three scopes, three truths, knowledge gate, reload, skip and text scales")
		quit(0)
	else:
		quit(1)
