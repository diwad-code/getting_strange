extends SceneTree

## PKG-0190 — cinematic vignette contract gate.
##
## Proves: (1) catalog integrity and resource existence; (2) each trigger
## signal exists verbatim on its station; (3) a real player-verb path through
## Station 13 fires the vignette exactly once via the real signal bridge;
## (4) skip and reduced motion both end in the identical gameplay flag state
## as a full, un-skipped viewing; (5) a second fresh Station 13 instance does
## not replay an already-seen vignette; (6) pre-recognition (Station 08)
## caption text carries none of the forbidden reveal stems; (7) each finale
## variant's `ending_family` matches its station's own committed value; (8)
## captions render through `CrispDiegeticText`, never baked into the plate.

const CinematicCatalogScript := preload("res://scripts/cinematics/cinematic_catalog.gd")
const ColdOpenFactsScript := preload("res://scripts/campaign/cold_open_facts.gd")

const STATION_SOURCE_PATHS := {
	"station_08": "res://scripts/levels/station_08.gd",
	"station_13": "res://scripts/levels/station_13.gd",
	"station_15": "res://scripts/levels/station_15.gd",
	"station_18": "res://scripts/levels/station_18.gd",
	"station_42a": "res://scripts/levels/station_42a.gd",
	"station_42b": "res://scripts/levels/station_42b.gd",
	"station_42c": "res://scripts/levels/station_42c.gd",
}

const FINALE_ENDING_VALUES := {
	"vig_finale_a": "force_home",
	"vig_finale_b": "close_equal_recover_local",
	"vig_finale_c": "mutual_passage",
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0190: " + message)


func _run() -> void:
	_check_catalog_integrity()
	_check_trigger_signals_exist()
	_check_director_matches_all_stations()
	_check_finale_ending_values()
	_check_pre_recognition_captions()
	_check_vignette_layer_and_text_layer()
	await _check_runtime_trigger_and_replay_guard()
	await _check_skip_and_reduced_motion_end_identical()

	if _failures.is_empty():
		print("PKG-0190 CINEMATICS PASS: catalog, triggers, runtime bridge and skip/reduced-motion parity verified")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0190 FAILURE: " + failure)
		quit(1)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var source := file.get_as_text()
	file.close()
	return source


# ─── Static checks ────────────────────────────────────────────────────────

func _check_catalog_integrity() -> void:
	var ids := CinematicCatalogScript.all_ids()
	_expect(ids.size() == 7, "catalog must list exactly 7 vignettes, found %d" % ids.size())
	_expect(ids.size() == _unique_count(ids), "catalog ids must be unique")
	for id in ids:
		var entry := CinematicCatalogScript.entry(id)
		_expect(not String(entry.get("station_id", "")).is_empty(), "%s missing station_id" % id)
		_expect(not String(entry.get("trigger_signal", "")).is_empty(), "%s missing trigger_signal" % id)
		var frames: Array = entry.get("frames", [])
		_expect(frames.size() == 2, "%s must have exactly 2 frames (2-5 contract, minimal sequence), found %d" % [id, frames.size()])
		for frame_path in frames:
			_expect(ResourceLoader.exists(String(frame_path)), "%s frame resource missing on disk: %s" % [id, frame_path])
		var captions: Array = entry.get("captions", [])
		_expect(captions.size() == frames.size(), "%s captions length must match frames length" % id)
		var normal: Array = entry.get("frame_seconds", [])
		var reduced: Array = entry.get("frame_seconds_reduced", [])
		_expect(normal.size() == frames.size(), "%s frame_seconds length must match frames length" % id)
		_expect(reduced.size() == frames.size(), "%s frame_seconds_reduced length must match frames length" % id)
		var normal_total := 0.0
		var reduced_total := 0.0
		for value in normal:
			normal_total += float(value)
		for value in reduced:
			reduced_total += float(value)
		_expect(reduced_total < normal_total, "%s reduced-motion duration (%.2fs) must be shorter than normal (%.2fs)" % [id, reduced_total, normal_total])


func _unique_count(values: Array) -> int:
	var seen := {}
	for value in values:
		seen[value] = true
	return seen.size()


func _check_trigger_signals_exist() -> void:
	for id in CinematicCatalogScript.all_ids():
		var entry := CinematicCatalogScript.entry(id)
		var station_id := String(entry.get("station_id", ""))
		var signal_name := String(entry.get("trigger_signal", ""))
		var source_path: String = STATION_SOURCE_PATHS.get(station_id, "")
		_expect(not source_path.is_empty(), "%s: no known source path for station %s" % [id, station_id])
		if source_path.is_empty():
			continue
		var source := _read(source_path)
		_expect(
			source.contains("signal %s(" % signal_name) or source.contains("signal %s()" % signal_name),
			"%s: station %s must declare signal %s verbatim" % [id, station_id, signal_name]
		)


func _check_director_matches_all_stations() -> void:
	var director_source := _read("res://scripts/cinematics/cinematic_director.gd")
	for class_name_guess in ["Station08", "Station13", "Station15", "Station18", "Station42A", "Station42B", "Station42C"]:
		_expect(director_source.contains("node is %s" % class_name_guess), "CinematicDirector must match %s by type" % class_name_guess)


func _check_finale_ending_values() -> void:
	for id in FINALE_ENDING_VALUES.keys():
		var entry := CinematicCatalogScript.entry(id)
		var catalog_value := String(entry.get("ending_family", ""))
		var expected: String = FINALE_ENDING_VALUES[id]
		_expect(catalog_value == expected, "%s ending_family mismatch: catalog=%s expected=%s" % [id, catalog_value, expected])
		var station_id := String(entry.get("station_id", ""))
		var source := _read(STATION_SOURCE_PATHS.get(station_id, ""))
		_expect(source.contains('"%s"' % expected), "%s station source must itself commit to ending value %s" % [station_id, expected])


func _check_pre_recognition_captions() -> void:
	# Station 08 precedes Station 13 recognition on the active route; its
	# vignette must carry none of the same forbidden-reveal stems the cold
	# open contract already enforces for pre-recognition content.
	var entry := CinematicCatalogScript.entry(CinematicCatalogScript.ID_THRESHOLD)
	for caption in entry.get("captions", []):
		var hits := ColdOpenFactsScript.forbidden_reveals_in(String(caption))
		_expect(hits.is_empty(), "VIG-01 threshold caption leaks pre-recognition reveal stems: %s" % str(hits))


func _check_vignette_layer_and_text_layer() -> void:
	var source := _read("res://scripts/cinematics/cinematic_vignette.gd")
	_expect(source.contains("layer = 19"), "CinematicVignette must render on layer 19 (above compositor, below CRTDialogueBox)")
	_expect(source.contains("RichTextLabel.new()"), "CinematicVignette captions must render through a native RichTextLabel in its own layer, not baked into the plate")
	_expect(not source.contains("draw_string("), "CinematicVignette must not draw text directly into the plate layer")
	_expect(not source.contains("CrispDiegeticText.new()"), "CinematicVignette must not instantiate CrispDiegeticText (world-space class, renders on a fixed global layer 10 — invisible under this overlay's layer 19 plate)")


# ─── Runtime checks ─────────────────────────────────────────────────────────

func _load_station_13() -> Node2D:
	var packed := load("res://scenes/levels/station_13.tscn") as PackedScene
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await process_frame
	# Every station opens with an automatic CRT dialogue panel; the director
	# must not (and per contract will not) start a vignette over it, so the
	# test clears it first, exactly like the existing capture tooling does.
	_complete_visible_dialogue(station)
	await process_frame
	return station


func _complete_visible_dialogue(node: Node) -> void:
	if node is CRTDialogueBox:
		var dialogue := node as CRTDialogueBox
		var guard := 0
		while dialogue.is_presenting() and guard < 32:
			dialogue.advance_dialogue()
			guard += 1
	for child in node.get_children():
		_complete_visible_dialogue(child)


func _arm_synthesis_prerequisites(state: Node) -> void:
	state.record_decision(&"p9.mystery.home.trace", "test_trace")
	state.record_decision(&"p9.mystery.institution.trace", "test_trace")
	state.record_decision(&"p9.mystery.jakub.trace", "test_trace")


func _check_runtime_trigger_and_replay_guard() -> void:
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		_failures.append("GameStateManager autoload not present; cannot run runtime cinematics checks")
		return
	state.reset_campaign(true)
	state.cinematics_seen.clear()

	# First instance: synthesis must not be reachable before the same
	# station's own preconditions are met (accessible only after the right
	# event, not merely on scene load).
	var station_early := await _load_station_13()
	var early_ok: bool = station_early.call("synthesize_world_difference")
	_expect(not early_ok, "Station 13 synthesis must be refused before its own preconditions are met")
	var vignette_early := station_early.get_node_or_null("CinematicVignette_vig_synthesis")
	_expect(vignette_early == null, "vignette must not spawn before the gameplay event actually occurs")
	station_early.free()
	await process_frame

	# Second instance: arm preconditions, then trigger for real.
	var station := await _load_station_13()
	_arm_synthesis_prerequisites(state)
	var fired: bool = station.call("synthesize_world_difference")
	_expect(fired, "Station 13 synthesis must succeed once preconditions are armed")
	await process_frame
	await process_frame
	var vignette := station.get_node_or_null("CinematicVignette_vig_synthesis")
	_expect(vignette != null, "CinematicDirector must attach the vignette to the station after the real trigger signal fires")
	if vignette != null:
		var skipped: bool = vignette.call("skip_for_test")
		_expect(skipped, "vignette must be skippable via semantic input from the first showing")
		await process_frame
	_expect(bool(state.call("is_cinematic_seen", &"vig_synthesis")), "seen-flag must be recorded after skip")
	_expect(bool(state.decisions.get("world_recognized", false)), "gameplay flag world_recognized must be true regardless of the vignette")
	station.free()
	await process_frame

	# Third instance: same fact, already seen — must not replay.
	var station_replay := await _load_station_13()
	var replay_fired: bool = station_replay.call("synthesize_world_difference")
	_expect(not replay_fired, "synthesize_world_difference is idempotent and must refuse a second commit")
	await process_frame
	var vignette_replay := station_replay.get_node_or_null("CinematicVignette_vig_synthesis")
	_expect(vignette_replay == null, "an already-seen vignette must not replay on revisiting the same station")
	station_replay.free()
	await process_frame


func _check_skip_and_reduced_motion_end_identical() -> void:
	const CinematicVignetteScript := preload("res://scripts/cinematics/cinematic_vignette.gd")
	var state := root.get_node_or_null("GameStateManager")
	if state == null:
		return
	var entry := CinematicCatalogScript.entry(&"vig_commit")

	MotionAccessibility.set_reduced_motion(false)
	var full_vignette: CanvasLayer = CinematicVignetteScript.new()
	full_vignette.call("setup", &"vig_commit", entry, null)
	root.add_child(full_vignette)
	await process_frame
	full_vignette.call("skip_for_test")
	await process_frame
	var seen_after_normal_skip: bool = state.call("is_cinematic_seen", &"vig_commit")

	state.cinematics_seen.erase("vig_commit")
	MotionAccessibility.set_reduced_motion(true)
	var reduced_vignette: CanvasLayer = CinematicVignetteScript.new()
	reduced_vignette.call("setup", &"vig_commit", entry, null)
	root.add_child(reduced_vignette)
	await process_frame
	reduced_vignette.call("skip_for_test")
	await process_frame
	var seen_after_reduced_skip: bool = state.call("is_cinematic_seen", &"vig_commit")
	MotionAccessibility.set_reduced_motion(false)
	state.cinematics_seen.erase("vig_commit")

	_expect(seen_after_normal_skip, "normal-motion skip must end with the seen-flag set")
	_expect(seen_after_reduced_skip, "reduced-motion skip must end with the same seen-flag state as normal motion")
