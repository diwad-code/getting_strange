extends SceneTree

## PKG-0107 gate: Station 42A..42C and 43 finale Vector-Stage presentation,
## conscious mechanical silence and preservation of the delivered finale logic.
##
## This gate proves technical contracts only (D-012, ADR-003). It cannot prove
## that a finale is fun, emotionally effective, readable to a new person or
## comprehensible without human observation.

const FINAL_SCENE_CASES: Array[Dictionary] = [
	{
		"path": "res://scenes/levels/station_42a.tscn",
		"station_id": &"station_42a",
		"station_number": 42,
		"stage_seed": 42,
		"stage_variant": &"return",
		"prop_radii": {"ForcedReturnLatch": 44.0, "SealedThreshold": 44.0, "HouseholdTrace": 44.0},
		"dialogue_count": 4,
		"checkpoint": Vector2(60.0, 296.0),
		"airlock_position": Vector2(590.0, 238.0),
		"airlock_size": Vector2(60.0, 120.0),
		"ceiling_size": Vector2(640.0, 30.0),
		"seed_force_home": true,
	},
	{
		"path": "res://scenes/levels/station_42b.tscn",
		"station_id": &"station_42b",
		"station_number": 42,
		"stage_seed": 42,
		"stage_variant": &"reconciliation",
		"prop_radii": {"FlowClosureLatch": 44.0, "LocalLenaThreshold": 44.0, "HouseholdTrace": 44.0},
		"dialogue_count": 4,
		"checkpoint": Vector2(60.0, 296.0),
		"airlock_position": Vector2(590.0, 238.0),
		"airlock_size": Vector2(60.0, 120.0),
		"ceiling_size": Vector2(640.0, 30.0),
		"seed_close_equal": true,
	},
	{
		"path": "res://scenes/levels/station_42c.tscn",
		"station_id": &"station_42c",
		"station_number": 42,
		"stage_seed": 42,
		"stage_variant": &"testimony",
		"prop_radii": {"MutualPassageLatch": 44.0, "MemoryLeakThreshold": 44.0, "HouseholdTrace": 44.0},
		"dialogue_count": 4,
		"checkpoint": Vector2(60.0, 296.0),
		"airlock_position": Vector2(590.0, 238.0),
		"airlock_size": Vector2(60.0, 120.0),
		"ceiling_size": Vector2(640.0, 30.0),
		"seed_mutual_passage": true,
	},
	{
		"path": "res://scenes/levels/station_43.tscn",
		"station_id": &"station_43",
		"station_number": 43,
		"stage_seed": 43,
		"stage_variant": &"epilogue",
		"prop_radii": {"AdminNoticeBoard": 48.0, "CreditsRoll": 48.0, "FinalBlackout": 60.0},
		"dialogue_count": 5,
	},
]

const REQUIRED_FLOOR_SIZE := Vector2(640.0, 80.0)
const REQUIRED_CEILING_SIZE := Vector2(640.0, 48.0)
const REQUIRED_WALL_SIZE := Vector2(20.0, 360.0)
const REQUIRED_AIRLOCK_SIZE := Vector2(50.0, 70.0)
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

var _failures: Array[String] = []
var _completion_count := 0


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0107: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		var state_constants: Dictionary = state.get_script().get_script_constant_map()
		_expect(int(state_constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 41, "campaign transition limit must cover Station 01..41")
		_expect(int(state_constants.get("SAVE_SCHEMA_VERSION", -1)) == 1, "save schema must remain version 1")
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	await _check_finale_scenes(state)
	_check_state_pass_source()
	_check_traversal_audit_source()
	_check_environment_profile_source()
	await _check_campaign_boundary(state)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	if _failures.is_empty():
		print("PKG-0107 SMOKE PASS: finale Vector-Stage, finale branches, conscious silence and production chain")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0107 FAILURE: " + failure)
		quit(1)


func _check_finale_scenes(state: Node) -> void:
	for case_data in FINAL_SCENE_CASES:
		var path: String = case_data["path"]
		var packed := load(path) as PackedScene
		_expect(packed != null, "finale scene must load: %s" % path)
		if packed == null:
			continue

		if state:
			state.reset_campaign(true)
			if bool(case_data.get("seed_force_home", false)):
				state.record_decision(&"p9.method_commitment.method_committed", "force_home")
				state.record_decision(&"method_committed", "force_home")
				state.record_decision(&"route_hypotheses_mapped", true)
				state.record_decision(&"marta_truth_state", "partial")
				state.record_decision(&"jakub_consent_state", "limited")
			elif bool(case_data.get("seed_close_equal", false)):
				state.record_decision(&"p9.method_commitment.method_committed", "close_equal_recover_local")
				state.record_decision(&"method_committed", "close_equal_recover_local")
				state.record_decision(&"route_hypotheses_mapped", true)
				state.record_decision(&"marta_truth_state", "partial")
				state.record_decision(&"jakub_consent_state", "limited")
			elif bool(case_data.get("seed_mutual_passage", false)):
				state.record_decision(&"p9.method_commitment.method_committed", "mutual_passage")
				state.record_decision(&"method_committed", "mutual_passage")
				state.record_decision(&"route_hypotheses_mapped", true)
				state.record_decision(&"marta_truth_state", "partial")
				state.record_decision(&"jakub_consent_state", "granted")
		var station := packed.instantiate() as Node2D
		_expect(station != null, "finale scene root must be Node2D: %s" % path)
		if station == null:
			continue
		root.add_child(station)
		await process_frame

		var expected_id: StringName = case_data["station_id"]
		var expected_number: int = case_data["station_number"]
		var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
		_expect(stage != null, "Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number == expected_number, "Vector-Stage station number mismatch: %s" % path)
			_expect(stage.stage_seed == int(case_data["stage_seed"]), "Vector-Stage seed mismatch: %s" % path)
			_expect(stage.stage_variant == StringName(case_data["stage_variant"]), "Vector-Stage variant mismatch: %s" % path)
			_expect(stage.z_index < 0, "Vector-Stage environment must stay behind level content: %s" % path)

		var atmosphere := station.get_node_or_null("AtmosphereRig") as AtmosphereRig
		_expect(atmosphere != null, "atmosphere rig missing: %s" % path)
		if atmosphere:
			_expect(atmosphere.station_number == expected_number, "atmosphere profile mismatch: %s" % path)
		var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
		_expect(dialogue != null, "CRT dialogue surface missing: %s" % path)
		var cue := station.get_node_or_null("OpeningDialogueCue") as StationDialogueCue
		_expect(cue != null, "opening dialogue cue missing: %s" % path)
		if cue:
			_expect(cue.station_id == expected_id, "opening cue station_id mismatch: %s" % path)
			_expect(not cue.opening_line.is_empty(), "opening cue must carry a line: %s" % path)
		if state:
			_expect(state.last_checkpoint_station == expected_id, "cue checkpoint mismatch: %s" % path)
			var expected_checkpoint: Vector2 = case_data.get("checkpoint", CHECKPOINT_POSITION)
			_expect(state.last_checkpoint_position == expected_checkpoint, "cue checkpoint position changed: %s" % path)

		var geometry := station.get_node_or_null("Geometry") as Node2D
		var props := station.get_node_or_null("Props") as Node2D
		var player := station.get_node_or_null("Player") as PrototypePlayer
		var airlock := station.get_node_or_null("AirlockZone") as Area2D
		_expect(geometry != null, "geometry root missing: %s" % path)
		_expect(props != null, "props root missing: %s" % path)
		_expect(player != null, "player instance missing: %s" % path)
		_expect(airlock != null, "airlock zone missing: %s" % path)
		_expect(station.has_signal(&"level_completed"), "level_completed signal missing: %s" % path)
		_check_geometry(geometry, path, case_data)
		_check_airlock(airlock, path, case_data)
		_check_prop_radii(props, case_data["prop_radii"], path)

		var dialogue_lines: Variant = station.get("dialogue_lines")
		_expect(dialogue_lines is Array, "finale dialogue lines must remain an Array: %s" % path)
		if dialogue_lines is Array:
			_expect((dialogue_lines as Array).size() == int(case_data["dialogue_count"]), "finale dialogue count changed: %s" % path)

		if expected_id == &"station_42a":
			await _exercise_42a(station as Station42A, props, player)
		elif expected_id == &"station_42b":
			await _exercise_42b(station as Station42B, props, player)
		elif expected_id == &"station_42c":
			await _exercise_42c(station as Station42C, props, player)
		elif expected_id == &"station_43":
			await _exercise_43(station as Station43, props, player)

		station.queue_free()
		await process_frame


func _exercise_42a(station: Station42A, props: Node2D, player: PrototypePlayer) -> void:
	_expect(station != null, "Station 42A script class is missing")
	if station == null or props == null or player == null:
		return
	_expect(station.is_exit_unlocked, "Station 42A must keep the path to 43 open when force_home is committed")
	var latch := props.get_node_or_null("ForcedReturnLatch") as MemoryResonancePoint
	var threshold := props.get_node_or_null("SealedThreshold") as MemoryResonancePoint
	var table := props.get_node_or_null("HouseholdTrace") as MemoryResonancePoint
	_expect(latch != null, "Station 42A return latch is missing")
	_expect(threshold != null, "Station 42A sealed threshold is missing")
	_expect(table != null, "Station 42A household trace is missing")
	_expect(station.execute_forced_return(), "Station 42A forced return must remain available")
	_expect(station.read_sealed_other_lena(), "Station 42A sealed other Lena must remain readable")
	_expect(station.read_household_consequence(), "Station 42A household consequence must remain readable")
	_expect(station.is_return_executed, "Station 42A must record the executed return")
	_expect(station.is_other_lena_sealed, "Station 42A must record the sealed other Lena")
	_expect(station.is_exit_unlocked, "Station 42A exit must stay open after consequence reading")
	await _exercise_existing_airlock(station, player, Vector2(590.0, 238.0))


func _exercise_42b(station: Station42B, props: Node2D, player: PrototypePlayer) -> void:
	_expect(station != null, "Station 42B script class is missing")
	if station == null or props == null or player == null:
		return
	_expect(station.is_exit_unlocked, "Station 42B must keep the path to 43 open when close_equal is committed")
	var latch := props.get_node_or_null("FlowClosureLatch") as MemoryResonancePoint
	var threshold := props.get_node_or_null("LocalLenaThreshold") as MemoryResonancePoint
	var table := props.get_node_or_null("HouseholdTrace") as MemoryResonancePoint
	_expect(latch != null, "Station 42B flow closure latch is missing")
	_expect(threshold != null, "Station 42B local lena threshold is missing")
	_expect(table != null, "Station 42B household trace is missing")
	_expect(station.execute_close_flow(), "Station 42B flow closure must remain available")
	_expect(station.read_local_lena_recovered(), "Station 42B recovered local Lena must remain readable")
	_expect(station.read_household_consequence(), "Station 42B household consequence must remain readable")
	_expect(station.is_flow_closed, "Station 42B must record the closed flow")
	_expect(station.is_local_lena_recovered, "Station 42B must record the recovered local Lena")
	_expect(station.is_exit_unlocked, "Station 42B exit must stay open after consequence reading")
	await _exercise_existing_airlock(station, player, Vector2(590.0, 238.0))


func _exercise_42c(station: Station42C, props: Node2D, player: PrototypePlayer) -> void:
	_expect(station != null, "Station 42C script class is missing")
	if station == null or props == null or player == null:
		return
	_expect(station.is_exit_unlocked, "Station 42C exit must start unlocked when seeded with mutual_passage")
	var latch := props.get_node_or_null("MutualPassageLatch") as MemoryResonancePoint
	var threshold := props.get_node_or_null("MemoryLeakThreshold") as MemoryResonancePoint
	var table := props.get_node_or_null("HouseholdTrace") as MemoryResonancePoint
	_expect(latch != null, "Station 42C mutual passage latch prop is missing")
	_expect(threshold != null, "Station 42C memory leak threshold prop is missing")
	_expect(table != null, "Station 42C household trace prop is missing")
	if latch:
		latch.trigger_interaction()
	_expect(station.is_passage_opened, "Station 42C passage must open after latch interaction")
	_expect(station.is_tram_inspected, "Station 42C compatibility flag must remain set")
	if threshold:
		threshold.trigger_interaction()
	_expect(station.is_memory_leak_read, "Station 42C memory leak must be read")
	if table:
		table.trigger_interaction()
	_expect(station.is_household_read, "Station 42C household consequence must be read")
	_exhaust_dialogue(station)
	_expect(station.is_dialogue_completed, "Station 42C dialogue must complete")
	_expect(station.is_exit_unlocked, "Station 42C exit must stay open after consequence reading")
	await _exercise_existing_airlock(station, player, Vector2(590.0, 238.0))


func _exercise_43(station: Station43, props: Node2D, player: PrototypePlayer) -> void:
	_expect(station != null, "Station 43 script class is missing")
	if station == null or props == null or player == null:
		return
	var notice := props.get_node_or_null("AdminNoticeBoard") as MemoryResonancePoint
	var credits := props.get_node_or_null("CreditsRoll") as MemoryResonancePoint
	var blackout := props.get_node_or_null("FinalBlackout") as MemoryResonancePoint
	_expect(notice != null, "Station 43 administrative notice prop is missing")
	_expect(credits != null, "Station 43 credits prop is missing")
	_expect(blackout != null, "Station 43 blackout prop is missing")
	if notice:
		notice.trigger_interaction()
	if credits:
		credits.trigger_interaction()
	_expect(station.is_notice_inspected, "Station 43 notice inspection must remain available")
	_expect(station.is_credits_inspected, "Station 43 credits inspection must remain available")
	if blackout:
		blackout.trigger_interaction()
	_expect(station.is_blackout_inspected, "Station 43 blackout inspection must remain available")
	_expect(station.is_exit_unlocked, "Station 43 epilogue exit must unlock")
	_exhaust_dialogue(station)
	_expect(station.is_dialogue_completed, "Station 43 epilogue dialogue must complete")
	await _exercise_existing_airlock(station, player)


func _exhaust_dialogue(station: Node) -> void:
	var lines: Array = station.get("dialogue_lines")
	for _index in range(lines.size() + 1):
		if bool(station.get("is_dialogue_completed")):
			break
		station.call("advance_dialogue")


func _exercise_existing_airlock(station: Node, player: PrototypePlayer, airlock_position: Vector2 = Vector2(610.0, 248.0)) -> void:
	_completion_count = 0
	var completion_callable := Callable(self, "_record_completion")
	station.connect(&"level_completed", completion_callable)
	player.global_position = airlock_position
	for _frame in range(5):
		await physics_frame
	_expect(bool(station.get("is_level_completed")), "finale must complete at its existing AirlockZone")
	_expect(_completion_count > 0, "finale must emit level_completed at the existing exit")
	if station.is_connected(&"level_completed", completion_callable):
		station.disconnect(&"level_completed", completion_callable)


func _record_completion() -> void:
	_completion_count += 1


func _check_geometry(geometry: Node2D, path: String, case_data: Dictionary = {}) -> void:
	if geometry == null:
		return
	_expect(geometry.get_child_count() == 4, "finale Geometry must retain exactly the four shell bodies: %s" % path)
	var ceiling_size: Vector2 = case_data.get("ceiling_size", REQUIRED_CEILING_SIZE)
	for body_name in ["FloorMain", "Ceiling", "WallLeft", "WallRight"]:
		var body := geometry.get_node_or_null(body_name) as StaticBody2D
		_expect(body != null, "finale shell body missing: %s/%s" % [path, body_name])
		if body == null:
			continue
		_expect(not body is AnimatableBody2D, "finale shell body must not become animatable: %s/%s" % [path, body_name])
		var expected_size := REQUIRED_FLOOR_SIZE if body_name == "FloorMain" else ceiling_size if body_name == "Ceiling" else REQUIRED_WALL_SIZE
		var shape_node := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_expect(shape_node != null, "finale shell shape missing: %s/%s" % [path, body_name])
		if shape_node:
			var rectangle := shape_node.shape as RectangleShape2D
			_expect(rectangle != null, "finale shell shape must remain rectangular: %s/%s" % [path, body_name])
			if rectangle:
				_expect(rectangle.size == expected_size, "finale shell collider changed: %s/%s" % [path, body_name])
	for child in geometry.get_children():
		_expect(not child is AnimatableBody2D, "finale conscious silence forbids AnimatableBody2D: %s/%s" % [path, child.name])
		if child is StaticBody2D:
			_expect(child.name in ["FloorMain", "Ceiling", "WallLeft", "WallRight"], "finale added a StaticBody2D outside the shell: %s/%s" % [path, child.name])


func _check_airlock(airlock: Area2D, path: String, case_data: Dictionary = {}) -> void:
	if airlock == null:
		return
	var expected_position: Vector2 = case_data.get("airlock_position", Vector2(610.0, 248.0))
	var expected_size: Vector2 = case_data.get("airlock_size", REQUIRED_AIRLOCK_SIZE)
	_expect(airlock.position == expected_position, "finale AirlockZone position changed: %s" % path)
	var shape_node := airlock.get_node_or_null("CollisionShape2D") as CollisionShape2D
	_expect(shape_node != null, "finale AirlockZone shape missing: %s" % path)
	if shape_node:
		var rectangle := shape_node.shape as RectangleShape2D
		_expect(rectangle != null, "finale AirlockZone must remain rectangular: %s" % path)
		if rectangle:
			_expect(rectangle.size == expected_size, "finale AirlockZone shape changed: %s" % path)


func _check_prop_radii(props: Node2D, expected: Dictionary, path: String) -> void:
	if props == null:
		return
	_expect(props.get_child_count() == expected.size(), "finale prop count changed: %s" % path)
	for prop_name in expected:
		var prop := props.get_node_or_null(String(prop_name)) as MemoryResonancePoint
		_expect(prop != null, "finale prop missing from interaction contract: %s/%s" % [path, prop_name])
		if prop:
			_expect(is_equal_approx(prop.interaction_radius, float(expected[prop_name])), "finale prop interaction radius changed: %s/%s" % [path, prop_name])


func _check_state_pass_source() -> void:
	for case_data in FINAL_SCENE_CASES:
		var path: String = case_data["path"]
		var script_path := path.replace("res://scenes/levels/", "res://scripts/levels/").replace(".tscn", ".gd")
		var file := FileAccess.open(script_path, FileAccess.READ)
		_expect(file != null, "finale script must be readable: %s" % script_path)
		if file == null:
			continue
		var source := file.get_as_text()
		file.close()
		var draw_start := source.find("func _draw() -> void:")
		var state_start := source.find("func _draw_state_layer() -> void:")
		_expect(draw_start >= 0 and state_start > draw_start, "finale script must expose an active state pass: %s" % script_path)
		if draw_start < 0 or state_start < 0:
			continue
		var draw_body := source.substr(draw_start, state_start - draw_start)
		var state_body := source.substr(state_start)
		var play_call := state_body.find("VectorStageStyle.draw_play_plane(self, geometry)")
		var first_variable := state_body.find("\n\tvar ")
		_expect(play_call >= 0, "finale state pass must derive the route from Geometry: %s" % script_path)
		_expect(first_variable < 0 or play_call < first_variable, "finale play plane must be first in state pass: %s" % script_path)
		_expect(draw_body.contains("_draw_state_layer()"), "finale _draw must invoke state pass: %s" % script_path)
		for forbidden_call in [
			"draw_stage_background",
			"draw_rect(Rect2(0.0, 0.0, 640.0, 360.0)",
		]:
			_expect(not draw_body.contains(forbidden_call), "opaque legacy full-frame drawing remains active: %s" % script_path)


func _check_traversal_audit_source() -> void:
	var file := FileAccess.open("res://docs/TRAVERSAL_ACT_IV_FINAL_AUDIT.md", FileAccess.READ)
	_expect(file != null, "finale traversal audit is missing")
	if file == null:
		return
	var source := file.get_as_text()
	file.close()
	for scene_label in ["42A", "42B", "42C", "43"]:
		_expect(source.contains("Scena " + scene_label), "finale traversal audit is missing scene %s" % scene_label)
	_expect(source.contains("Łączny budżet nowych przeszkód w PKG-0107 wynosi **0**"), "finale traversal audit must record conscious mechanical silence")


func _check_environment_profile_source() -> void:
	var file := FileAccess.open("res://scripts/visual/vector_stage_environment.gd", FileAccess.READ)
	_expect(file != null, "Vector-Stage environment script is missing")
	if file == null:
		return
	var source := file.get_as_text()
	file.close()
	_expect(source.contains("@export var stage_variant: StringName"), "Vector-Stage environment must expose deterministic finale variants")
	_expect(source.contains("func _draw_finale_42() -> void:"), "Vector-Stage 42 profile is missing")
	_expect(source.contains("func _draw_finale_43() -> void:"), "Vector-Stage 43 profile is missing")
	_expect(source.contains("42:\n\t\t\t_draw_finale_42()"), "Station 42 profile dispatch is missing")
	_expect(source.contains("43:\n\t\t\t_draw_finale_43()"), "Station 43 profile dispatch is missing")


func _check_campaign_boundary(state: Node) -> void:
	if state == null:
		return
	state.reset_campaign(true)
	for station_number in range(1, 26):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_25"), "campaign chain must still reach Station 25")
	_expect(state.has_reached_station(&"station_26"), "PKG-0107 must preserve Station 26 in the production chain")
	_expect(state.get_next_campaign_station(&"station_25") == &"station_26", "Station 25 must lead to Station 26")
