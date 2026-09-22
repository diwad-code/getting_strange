extends SceneTree

## PKG-0192 — retire the callable P7 surface from Station 10-13 (D-205 §4,
## second dependency step after PKG-0191's canonical-fact alignment).
##
## This package does not remove the still-callable P7 methods themselves
## (tests keep calling `inspect_key_wear()`, `close_balcony()`,
## `open_drawer()` etc. directly — none of them are wired to a real
## `MemoryResonancePoint` node, so they stay dead in real play exactly as
## before). What it retires is the `p7.foreign_daily_life.*` /
## `p7.marta_threshold.*` fact namespace: those methods now write under
## `p9.threshold_obstacle.*` instead. `HallwaySideboard` (Station 11),
## `BalconyDoor` (Station 12) and `DeskDrawer` (Station 13) are explicitly
## retained as P9 diegetic obstacles, documented as such in each station's
## header comment, not left as unnamed P7 mechanics.
##
## Real MRP-triggered route and save/reload persistence for the 12 canonical
## CAMPAIGN_MAP facts are unchanged by this package and stay covered by
## `tests/pkg_0191_canonical_fact_test.gd`; this gate does not duplicate that
## coverage.

const STATION_PATHS: Array[String] = [
	"res://scripts/levels/station_10.gd",
	"res://scripts/levels/station_11.gd",
	"res://scripts/levels/station_12.gd",
	"res://scripts/levels/station_13.gd",
]
const RETIRED_WRITE_LITERALS := [
	"&\"p7.foreign_daily_life.",
	"&\"p7.marta_threshold.",
]
const DIEGETIC_DECISION_MARKERS := {
	"res://scripts/levels/station_11.gd": ["HallwaySideboard", "ZOSTAJE jako"],
	"res://scripts/levels/station_12.gd": ["BalconyDoor", "ZOSTAJE jako"],
	"res://scripts/levels/station_13.gd": ["DeskDrawer", "ZOSTAJE jako"],
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0192 FAILURE: %s" % message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var source := file.get_as_text()
	file.close()
	return source


func _run() -> void:
	_check_namespace_retired()
	_check_diegetic_decisions_documented()
	await _check_renamed_facts_at_runtime()
	_check_migration_idempotent()
	if _failures.is_empty():
		print("PKG-0192 PASS: Station 10-13 no longer write p7.foreign_daily_life.*/p7.marta_threshold.*; HallwaySideboard/BalconyDoor/DeskDrawer are documented P9 diegetic obstacles; legacy-save migration stays idempotent.")
		quit(0)
	else:
		printerr("PKG-0192 FAIL: %d failure(s)." % _failures.size())
		quit(1)


func _check_namespace_retired() -> void:
	var combined := ""
	for path in STATION_PATHS:
		combined += _read(path)
	for literal in RETIRED_WRITE_LITERALS:
		_expect(not combined.contains(literal), "retired P7 write-literal must not remain in Station 10-13: %s" % literal)
	_expect(combined.contains("p9.threshold_obstacle.foreign_daily_life."), "renamed foreign_daily_life obstacle namespace must be present")
	_expect(combined.contains("p9.threshold_obstacle.marta_threshold."), "renamed marta_threshold obstacle namespace must be present")


func _check_diegetic_decisions_documented() -> void:
	for path in DIEGETIC_DECISION_MARKERS:
		var source := _read(path)
		for marker in DIEGETIC_DECISION_MARKERS[path]:
			_expect(source.contains(marker), "%s must document its explicit P9 diegetic-element decision (missing: %s)" % [path, marker])


func _state() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	return state


func _open(path: String) -> Node:
	var packed := load(path) as PackedScene
	_expect(packed != null, "%s must load" % path)
	if packed == null:
		return null
	var station := packed.instantiate()
	root.add_child(station)
	for _frame in range(3):
		await process_frame
	return station


func _close(station: Node) -> void:
	if station:
		station.queue_free()
		await process_frame


## Exercises the still-callable, still-dead-in-real-play P7 chain directly
## (as every pre-existing test in this repo already does) and proves each
## renamed fact lands under `p9.threshold_obstacle.*`, never the retired
## `p7.*` namespace, while the method's return-value contract (used by
## smoke_test.gd, pkg_0099/0100/0119/0138/0146) is unchanged.
func _check_renamed_facts_at_runtime() -> void:
	var state := _state()
	if state == null:
		return
	state.reset_campaign(true)

	var s10 := await _open("res://scenes/levels/station_10.tscn")
	if s10:
		state.record_decision(&"p9.threshold_obstacle.foreign_daily_life.neighbour_account", "twelve_lower_fourteen_home")
		_expect(bool(s10.call(&"inspect_key_wear")), "station_10.inspect_key_wear() must still succeed")
		_expect(bool(s10.call(&"test_key_without_claiming_home")), "station_10.test_key_without_claiming_home() must still succeed")
		_expect(
			String(state.decisions.get(&"p9.threshold_obstacle.foreign_daily_life.key_trial_result", "")) == "key_matches_foreign_history",
			"station_10 must write the renamed key_trial_result fact"
		)
		_expect(not state.decisions.has(&"p7.foreign_daily_life.key_trial_result"), "station_10 must not write the retired key_trial_result fact")
		await _close(s10)

	var s11 := await _open("res://scenes/levels/station_11.tscn")
	if s11:
		s11.set(&"is_passage_clear", true)
		_expect(bool(s11.call(&"inspect_private_photograph")), "station_11.inspect_private_photograph() must still succeed")
		_expect(bool(s11.call(&"inspect_equipment_wear")), "station_11.inspect_equipment_wear() must still succeed")
		_expect(bool(s11.call(&"inspect_reader_arrangement")), "station_11.inspect_reader_arrangement() must still succeed")
		_expect(bool(s11.call(&"compare_private_material")), "station_11.compare_private_material() must still succeed")
		_expect(
			String(state.decisions.get(&"p9.threshold_obstacle.foreign_daily_life.trace", "")) == "foreign_address_and_photograph",
			"station_11 must write the renamed trace fact"
		)
		_expect(not state.decisions.has(&"p7.foreign_daily_life.trace"), "station_11 must not write the retired trace fact")
		await _close(s11)

	var s12 := await _open("res://scenes/levels/station_12.tscn")
	if s12:
		_expect(bool(s12.call(&"close_balcony")), "station_12.close_balcony() must still succeed once the (renamed) trace is present")
		_expect(bool(s12.call(&"listen_to_message")), "station_12.listen_to_message() must still succeed")
		_expect(bool(s12.call(&"verify_caller_identity")), "station_12.verify_caller_identity() must still succeed")
		_expect(bool(s12.call(&"prepare_independent_questions")), "station_12.prepare_independent_questions() must still succeed")
		_expect(
			state.decisions.get(&"p9.threshold_obstacle.marta_threshold.independent_questions_ready", false) == true,
			"station_12 must write the renamed independent_questions_ready fact"
		)
		_expect(not state.decisions.has(&"p7.marta_threshold.independent_questions_ready"), "station_12 must not write the retired independent_questions_ready fact")
		await _close(s12)

	var s13 := await _open("res://scenes/levels/station_13.tscn")
	if s13:
		_expect(bool(s13.call(&"observe_field_certificate")), "station_13.observe_field_certificate() must still succeed")
		_expect(bool(s13.call(&"open_drawer")), "station_13.open_drawer() must still succeed once the (renamed) questions fact is present")
		_expect(bool(s13.call(&"observe_tenancy_contract")), "station_13.observe_tenancy_contract() must still succeed")
		_expect(bool(s13.call(&"verify_document_independence")), "station_13.verify_document_independence() must still succeed")
		_expect(bool(s13.call(&"compare_document_versions")), "station_13.compare_document_versions() must still succeed")
		_expect(state.decisions.get(&"conflicting_documents_found", false) == true, "station_13 must keep writing conflicting_documents_found unchanged")
		_expect(bool(s13.call(&"request_independent_description")), "station_13.request_independent_description() must still succeed")
		_expect(
			state.decisions.get(&"p9.threshold_obstacle.marta_threshold.recall_requested", false) == true,
			"station_13 must write the renamed recall_requested fact"
		)
		_expect(not state.decisions.has(&"p7.marta_threshold.recall_requested"), "station_13 must not write the retired recall_requested fact")
		await _close(s13)

	state.reset_campaign(true)


## Simulates an old save that still carries the retired P7 namespaces (as a
## save written before this package would) and proves `_migrate_p7_early_sequences()`
## still erases them, still fabricates no P9 fact, and is idempotent — a
## second application changes nothing further.
func _check_migration_idempotent() -> void:
	var state := _state()
	if state == null:
		return
	state.reset_campaign(true)
	state.decisions[&"p7.foreign_daily_life.neighbour_account"] = "twelve_lower_fourteen_home"
	state.decisions[&"p7.foreign_daily_life.trace"] = "foreign_address_and_photograph"
	state.decisions[&"p7.marta_threshold.independent_questions_ready"] = true
	state.decisions[&"p7.marta_threshold.recall_requested"] = true
	state.decisions.erase(&"p7.foreign_daily_life.migration_revision")
	state.decisions.erase(&"p7.marta_threshold.migration_revision")
	var pre_snapshot: Dictionary = state.decisions.duplicate()

	var migrated_once: bool = bool(state.call(&"_migrate_p7_early_sequences"))
	_expect(migrated_once, "a legacy save carrying retired P7 keys must trigger migration")
	_expect(not state.decisions.has(&"p7.foreign_daily_life.neighbour_account"), "migration must erase the stale foreign_daily_life decision")
	_expect(not state.decisions.has(&"p7.foreign_daily_life.trace"), "migration must erase the stale foreign_daily_life trace")
	_expect(not state.decisions.has(&"p7.marta_threshold.independent_questions_ready"), "migration must erase the stale marta_threshold decision")
	_expect(not state.decisions.has(&"p7.marta_threshold.recall_requested"), "migration must erase the stale marta_threshold decision")
	for fact in [
		&"marta_memories_conflict", &"marta_boundary_accepted", &"local_lena_ucp_profile_found",
		&"parallel_test_trace_found", &"jakub_public_history_verified", &"jakub_voice_heard",
		&"jakub_met_as_person", &"recognition_evidence_public", &"recognition_evidence_relational",
		&"recognition_evidence_carried", &"world_recognized", &"local_lena_search_committed",
	]:
		_expect(not state.decisions.has(fact), "migration must not fabricate canonical CAMPAIGN_MAP fact %s" % fact)
	for fact in [
		&"p9.threshold_obstacle.foreign_daily_life.neighbour_account",
		&"p9.threshold_obstacle.foreign_daily_life.trace",
		&"p9.threshold_obstacle.marta_threshold.independent_questions_ready",
		&"p9.threshold_obstacle.marta_threshold.recall_requested",
	]:
		_expect(not state.decisions.has(fact), "migration must not fabricate a renamed P9 obstacle fact out of nothing: %s" % fact)

	var post_first_size: int = state.decisions.size()
	var post_first_keys: Array = state.decisions.keys().duplicate()
	var migrated_twice: bool = bool(state.call(&"_migrate_p7_early_sequences"))
	_expect(not migrated_twice, "a second application on an already-migrated save must be a no-op (idempotent)")
	_expect(state.decisions.size() == post_first_size, "a second migration pass must not add or remove any decision")
	for key in post_first_keys:
		_expect(state.decisions.has(key), "a second migration pass must not erase decision %s that survived the first pass" % key)
	_expect(pre_snapshot.size() >= 4, "test setup sanity: at least the four seeded stale keys must have existed before migration")

	state.reset_campaign(true)
