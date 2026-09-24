extends RefCounted

## PKG-0242 (R1): authentic campaign state for gates that start after 16.
##
## PKG-0239 turned consent, Marta's truth and the method choice into
## conversations that are recorded only when the exchange finishes
## (`_on_narrative_dialogue_finished`), and the finales now accept only a
## chain `NarrativeRules.committed()` recognises. Hand-written seeds such as
## `method_committed = "force_home"` + `jakub_consent_state = "limited"` no
## longer describe any state a player can reach, so old gates failed on them.
##
## This helper never writes a narrative fact itself after loading the base
## state. It instantiates the real Station 17 and 18 scenes, calls the same
## verbs the reading points call, and closes each conversation through the
## same callback the CreativeScenePresentation uses. What it produces is what a
## player produces; pkg_0177 proves the same chain by input end to end.
##
## The base state (`campaign_state_before_17.json`) is the decisions dump of a
## real New Game → 01..16 run driven by player input only.

const NarrativeRules := preload("res://scripts/levels/narrative_repair_rules.gd")
const BASE_STATE_PATH := "res://tests/support/campaign_state_before_17.json"
const METHOD_X_OFFSET := {"force_home": -48.0, "close_equal_recover_local": 0.0, "mutual_passage": 48.0}


## Loads the pre-17 state. `opening` is "leave_on_time" or "repeat_sample"
## (Station 01), `cost` is "marta_memory" or "sample_second" (Station 16);
## every key those stations write for the choice is kept consistent.
static func seed_before_17(state: Node, opening := "leave_on_time", cost := "sample_second") -> void:
	state.reset_campaign(true)
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(BASE_STATE_PATH))
	var decisions: Dictionary = data.get("decisions", {})
	for key in decisions:
		state.decisions[StringName(key)] = decisions[key]
	for station_id in data.get("reached", []):
		state.mark_station_reached(StringName(station_id))
	var sample := opening == "repeat_sample"
	state.decisions[&"p9.opening.choice"] = opening
	state.decisions[&"home_sample_preserved"] = sample
	state.decisions[&"p7.sample_and_promise.sample_preserved"] = sample
	state.decisions[&"p9.opening.sample_carried_home"] = sample
	state.decisions[&"p9.opening.equipment_packed"] = not sample
	state.decisions[&"p7.sample_and_promise.measurement_result"] = "gap_retained_after_clean_repeat" if sample else "repeat_declined_equipment_packed"
	var manifested := "marta_first_meeting_detail_blurred" if cost == "marta_memory" else "sample_exact_second_lost"
	state.decisions[&"p9.mechanics.small_cost.choice"] = cost
	state.decisions[&"p9.mechanics.small_cost.manifested"] = manifested
	state.decisions[&"small_cost_manifested"] = manifested
	state.save_campaign()


## Plays the first visit to 17: ledger, offer, and Jakub's scope conversation.
static func record_scope(tree: SceneTree, scope: String) -> bool:
	var s17 := await _open(tree, "station_17")
	if s17 == null:
		return false
	var ok := bool(s17.call("read_cost_ledger")) or bool(s17.get("is_cost_ledger_read"))
	ok = (bool(s17.call("reject_adaptation_offer")) or bool(s17.get("is_adaptation_offer_rejected"))) and ok
	ok = bool(s17.call("record_jakub_consent_" + scope)) and ok
	s17.call("_on_narrative_dialogue_finished", "consent_scope_desk")
	ok = String(tree.root.get_node("GameStateManager").decisions.get(&"jakub_consent_state", "")) == scope and ok
	await _close(tree, s17)
	return ok


## First visit to 18: forecasts, Marta's truth, naming one method and — for
## mutual passage — Marta's separate answer about the key.
static func propose_method(tree: SceneTree, method: String, truth: String, sync := "accepted") -> bool:
	var s18 := await _open(tree, "station_18")
	if s18 == null:
		return false
	var ok := bool(s18.call("compare_forecast_consent_dependencies"))
	ok = bool(s18.call("disclose_marta_truth_" + truth)) and ok
	s18.call("_on_narrative_dialogue_finished", "marta_truth_table")
	ok = await _point_at_post(tree, s18, method) and ok
	if method == "mutual_passage" and truth == "full" and not sync.is_empty():
		ok = bool(s18.call("_request_marta_sync", sync == "accepted")) and ok
		s18.call("_on_narrative_dialogue_finished", "marta_truth_table")
	await _close(tree, s18)
	return ok


## Second visit to 17: Jakub answers the one proposed method.
static func answer_method(tree: SceneTree, reply := "accepted") -> bool:
	var s17 := await _open(tree, "station_17")
	if s17 == null:
		return false
	var side := "granted" if reply == "accepted" else "refused"
	var ok := bool(s17.call("record_jakub_consent_" + side))
	s17.call("_on_narrative_dialogue_finished", "consent_scope_desk")
	await _close(tree, s17)
	return ok


## Second visit to 18: commit at the same post side.
static func commit_method(tree: SceneTree, method: String) -> bool:
	var s18 := await _open(tree, "station_18")
	if s18 == null:
		return false
	var ok := await _point_at_post(tree, s18, method)
	ok = bool(s18.get("is_method_committed")) and ok
	await _close(tree, s18)
	return ok


## Full chain 17 → 18 → 17 → 18. Returns true only when the finale gate
## (`NarrativeRules.committed`) accepts the result.
static func commit_chain(tree: SceneTree, method: String, truth: String, scope := "granted") -> bool:
	var ok := await record_scope(tree, scope)
	ok = await propose_method(tree, method, truth) and ok
	ok = await answer_method(tree, "accepted") and ok
	ok = await commit_method(tree, method) and ok
	var decisions: Dictionary = tree.root.get_node("GameStateManager").decisions
	return NarrativeRules.committed(decisions, method) and ok


## Plays a finale's reading points in their order (execution → state →
## consequence; B closes the flow only after the local Lena answers).
static func play_finale(tree: SceneTree, finale_id: String) -> bool:
	var st := await _open(tree, finale_id)
	if st == null:
		return false
	var ok := false
	match finale_id:
		"station_42a":
			ok = bool(st.call("execute_forced_return")) and bool(st.call("read_sealed_other_lena")) and bool(st.call("read_household_consequence"))
		"station_42b":
			ok = bool(st.call("execute_close_flow")) and bool(st.call("read_local_lena_recovered")) \
				and bool(st.call("execute_close_flow")) and bool(st.call("read_household_consequence"))
		"station_42c":
			ok = bool(st.call("execute_mutual_passage")) and bool(st.call("read_memory_leak")) and bool(st.call("read_household_consequence"))
	await _close(tree, st)
	return ok


static func finale_for(method: String) -> String:
	match method:
		"close_equal_recover_local":
			return "station_42b"
		"mutual_passage":
			return "station_42c"
	return "station_42a"


static func _point_at_post(tree: SceneTree, s18: Node, method: String) -> bool:
	var player := s18.get_node("Player") as Node2D
	var post := s18.get_node("Props/MethodCommitPost") as Node2D
	player.global_position.x = post.global_position.x + float(METHOD_X_OFFSET.get(method, 0.0))
	await tree.physics_frame
	return bool(s18.call("choose_method_from_player_side"))


static func _open(tree: SceneTree, station_id: String) -> Node:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	if packed == null:
		return null
	var st := packed.instantiate()
	tree.root.add_child(st)
	await tree.physics_frame
	await tree.physics_frame
	return st


static func _close(tree: SceneTree, st: Node) -> void:
	if st != null and is_instance_valid(st):
		st.queue_free()
	for _f in range(3):
		await tree.process_frame
