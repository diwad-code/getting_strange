extends SceneTree

## PKG-0103 gate: Station 26..30 Act III Vector-Stage surfaces and the two
## deliberately auditable physical mechanisms in the opening of Act III.
##
## This gate proves technical contracts only (D-012, ADR-003). It cannot prove
## that a space is fun, emotionally effective, or comprehensible to a person.

const ACT_III_PATHS: Array[String] = [
	"res://scenes/levels/station_26.tscn",
	"res://scenes/levels/station_27.tscn",
	"res://scenes/levels/station_28.tscn",
	"res://scenes/levels/station_29.tscn",
	"res://scenes/levels/station_30.tscn",
]

const REQUIRED_PROP_RADII: Dictionary = {
	26: {
		"IsolationConsole": 42.0,
		"RoomDesignator": 40.0,
		"PASpeaker": 45.0,
		"MotivationAnchor": 45.0,
		"Station26Exit": 60.0,
	},
	27: {
		"WorkerBadge": 40.0,
		"JakubOperator": 48.0,
		"SurfaceMonitor": 42.0,
		"JunctionConsole": 45.0,
		"Station27Exit": 60.0,
	},
	28: {
		"DriverConsole": 45.0,
		"TransitWindow": 48.0,
		"ParadoxViewport": 52.0,
		"ClosingIntercom": 42.0,
		"Station28Exit": 60.0,
	},
	29: {
		"AbandonedTracks": 48.0,
		"FlickeringNeon": 45.0,
		"SubstructureWell": 48.0,
		"JakubBeacon": 46.0,
		"Station29Exit": 60.0,
	},
	30: {
		"MainDistributionBoard": 48.0,
		"TransformerBank": 46.0,
		"SectionBreakerLever": 45.0,
		"GridSchematicDisplay": 48.0,
		"Station30Exit": 60.0,
	},
}

const REQUIRED_FLOOR_SIZE := Vector2(640.0, 80.0)
const REQUIRED_CEILING_SIZE := Vector2(640.0, 40.0)
const REQUIRED_WALL_SIZE := Vector2(20.0, 360.0)
const REQUIRED_AIRLOCK_SIZE := Vector2(50.0, 70.0)
const CHECKPOINT_POSITION := Vector2(50.0, 240.0)

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0103: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		var state_constants: Dictionary = state.get_script().get_script_constant_map()
		_expect(
			int(state_constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 25,
			"this package must not change the delivered campaign transition limit"
		)
		_expect(
			int(state_constants.get("SAVE_SCHEMA_VERSION", -1)) == 1,
			"this package must not change the delivered save schema"
		)
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	await _check_stations(state)
	_check_three_question_headers()
	await _check_campaign_boundary(state)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	if _failures.is_empty():
		print("PKG-0103 SMOKE PASS: Act III Vector-Stage route, R5/R1 mechanisms and chain boundary 25")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0103 FAILURE: " + failure)
		quit(1)


func _check_stations(state: Node) -> void:
	for index in range(ACT_III_PATHS.size()):
		var expected_number := 26 + index
		var path: String = ACT_III_PATHS[index]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act III station must load: %s" % path)
		if packed == null:
			continue

		if state:
			state.reset_campaign(true)
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame

		var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
		_expect(stage != null, "Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number == expected_number, "Vector-Stage profile mismatch: %s" % path)
			_expect(stage.z_index < 0, "Vector-Stage layer must stay behind level content: %s" % path)
		_expect(station.get_node_or_null("AtmosphereRig") != null, "atmosphere rig missing: %s" % path)
		_expect(station.get_node_or_null("CRTDialogueBox") != null, "CRT dialogue surface missing: %s" % path)
		_expect(station.get_node_or_null("OpeningDialogueCue") != null, "opening dialogue cue missing: %s" % path)

		var geometry := station.get_node_or_null("Geometry") as Node2D
		_expect(geometry != null, "geometry root missing: %s" % path)
		if geometry:
			_check_rectangle_body(geometry.get_node_or_null("FloorMain") as StaticBody2D, REQUIRED_FLOOR_SIZE, "floor", path)
			_check_rectangle_body(geometry.get_node_or_null("Ceiling") as StaticBody2D, REQUIRED_CEILING_SIZE, "ceiling", path)
			_check_rectangle_body(geometry.get_node_or_null("WallLeft") as StaticBody2D, REQUIRED_WALL_SIZE, "left wall", path)
			_check_rectangle_body(geometry.get_node_or_null("WallRight") as StaticBody2D, REQUIRED_WALL_SIZE, "right wall", path)
			var obstacle_count := 0
			for child in geometry.get_children():
				if child is AnimatableBody2D:
					obstacle_count += 1
					_expect(
						(expected_number == 26 and child.name == "AdaptiveIsolationPartition") or
						(expected_number == 30 and child.name == "WitnessRelayBank"),
						"unexpected physical obstacle in Station %d: %s" % [expected_number, child.name]
					)
			_expect(
				obstacle_count == (1 if expected_number in [26, 30] else 0),
				"Station %d must carry exactly the audited obstacle count" % expected_number
			)

		var airlock := station.get_node_or_null("AirlockZone") as Area2D
		_expect(airlock != null, "airlock zone missing: %s" % path)
		if airlock:
			var airlock_shape := airlock.get_node_or_null("CollisionShape2D") as CollisionShape2D
			_expect(airlock_shape != null, "airlock zone lost its shape: %s" % path)
			if airlock_shape:
				var rectangle := airlock_shape.shape as RectangleShape2D
				_expect(rectangle != null, "airlock zone must use a rectangle: %s" % path)
				if rectangle:
					_expect(rectangle.size == REQUIRED_AIRLOCK_SIZE, "airlock shape changed: %s" % path)

		_expect(station.get_node_or_null("Player") is PrototypePlayer, "player instance missing: %s" % path)
		_expect(station.has_signal(&"level_completed"), "level completion signal missing: %s" % path)
		_check_prop_radii(expected_number, station.get_node_or_null("Props") as Node2D, path)
		_check_state_pass_source(expected_number, path)

		if expected_number == 26:
			await _check_station_26(station as Station26, state)
		elif expected_number == 30:
			await _check_station_30(station as Station30, state)

		station.queue_free()
		await process_frame


func _check_rectangle_body(body: StaticBody2D, expected_size: Vector2, label: String, path: String) -> void:
	_expect(body != null, "%s collider is missing: %s" % [label, path])
	if body == null:
		return
	var shape_node := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	_expect(shape_node != null, "%s collider lost its shape: %s" % [label, path])
	if shape_node == null:
		return
	var rectangle := shape_node.shape as RectangleShape2D
	_expect(rectangle != null, "%s collider must use a rectangle: %s" % [label, path])
	if rectangle:
		_expect(rectangle.size == expected_size, "%s collider shape changed: %s" % [label, path])


func _check_prop_radii(expected_number: int, props: Node2D, path: String) -> void:
	_expect(props != null, "props root missing: %s" % path)
	if props == null:
		return
	var expected: Dictionary = REQUIRED_PROP_RADII[expected_number]
	for prop_name in expected:
		var prop := props.get_node_or_null(String(prop_name)) as MemoryResonancePoint
		_expect(prop != null, "prop missing from interaction contract: %s/%s" % [path, prop_name])
		if prop:
			_expect(
				is_equal_approx(prop.interaction_radius, float(expected[prop_name])),
				"prop interaction radius changed: %s/%s" % [path, prop_name]
			)


func _check_state_pass_source(expected_number: int, path: String) -> void:
	var script_path := "res://scripts/levels/station_%02d.gd" % expected_number
	var file := FileAccess.open(script_path, FileAccess.READ)
	_expect(file != null, "station script must be readable: %s" % script_path)
	if file == null:
		return
	var source := file.get_as_text()
	file.close()
	var draw_start := source.find("func _draw() -> void:")
	var state_start := source.find("func _draw_state_layer() -> void:")
	_expect(draw_start >= 0 and state_start > draw_start, "station script must expose a state pass: %s" % script_path)
	if draw_start < 0 or state_start < 0:
		return
	var state_body := source.substr(state_start)
	var play_call := state_body.find("VectorStageStyle.draw_play_plane")
	var first_variable := state_body.find("\n\tvar ")
	_expect(play_call >= 0, "state pass must derive the route from Geometry: %s" % path)
	_expect(first_variable < 0 or play_call < first_variable, "play plane must be first in state pass: %s" % path)
	var draw_body := source.substr(draw_start, state_start - draw_start)
	for forbidden_call in [
		"draw_stage_background",
		"_draw_architecture()",
		"_draw_background_environment()",
		"_draw_apartment_environment()",
		"_draw_bathroom_environment()",
		"_draw_study_room()",
		"draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)",
	]:
		_expect(not draw_body.contains(forbidden_call), "opaque legacy draw remains in %s" % script_path)


func _check_three_question_headers() -> void:
	for station_number in range(26, 31):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "station script must be readable: %s" % path)
		if file == null:
			continue
		var source := file.get_as_text()
		file.close()
		for question in ["dlaczego to tu jest", "czego wymaga od Leny", "koszt porażki"]:
			_expect(
				source.contains("## PRZESZKODA — " + question),
				"%s is missing the three-question header '%s'" % [path, question]
			)
		var why_line := ""
		for line in source.split("\n"):
			if line.begins_with("## PRZESZKODA — dlaczego to tu jest"):
				why_line = line
				break
		_expect(not why_line.to_lower().contains("gracz"), "%s world sentence contains forbidden player wording" % path)


func _check_station_26(station: Station26, state: Node) -> void:
	_expect(station != null, "Station 26 script class is missing")
	if station == null:
		return
	var partition := station.get_node_or_null("Geometry/AdaptiveIsolationPartition") as AnimatableBody2D
	_expect(partition != null, "Station 26 adaptive partition is missing")
	if partition == null:
		return
	var closed_position := partition.position
	station.partition_cycle_time = 0.0
	station._update_partition_cycle()
	_expect(not station.is_partition_open, "Station 26 partition must start its cycle closed")
	station.current_room_state = Station26.RoomState.SEDATION
	station.partition_cycle_time = 2.0
	station._update_partition_cycle()
	await process_frame
	_expect(station.is_partition_open, "Station 26 partition must expose an isolation cycle open phase")
	_expect(partition.position.x > closed_position.x + 10.0, "Station 26 partition must move because the isolation system works")
	station._apply_isolation_correction()
	_expect(station.partition_correction_count == 1, "Station 26 correction must count the attempt")
	_expect(station.partition_detail_faded, "Station 26 correction must preserve a faded detail")
	_expect(station.current_room_state == Station26.RoomState.RESIDENTIAL, "Station 26 correction must restore the local room state")
	_expect(station.player.global_position == CHECKPOINT_POSITION, "Station 26 correction must reset Lena to the checkpoint")
	if state:
		_expect(state.decisions.has(&"station_26_isolation_partition_corrected"), "Station 26 correction must be recorded")


func _check_station_30(station: Station30, state: Node) -> void:
	_expect(station != null, "Station 30 script class is missing")
	if station == null:
		return
	var relay := station.get_node_or_null("Geometry/WitnessRelayBank") as AnchorableObject
	_expect(relay != null, "Station 30 witness relay is missing")
	if relay == null:
		return
	_expect(relay.state_a_position == relay.state_b_position, "Station 30 relay must stay in its machine bay")
	_expect(relay.state_a_size != relay.state_b_size, "Station 30 relay configurations must differ in extent")
	_expect(relay.current_reality == AnchorableObject.RealityState.STATE_A, "Station 30 relay must start in configuration A")
	_expect(not relay.is_anchored, "Station 30 relay must start unanchored")
	_expect(relay.toggle_anchor(), "Station 30 relay must be holdable")
	station.run_witness_relay_correction_pass()
	await process_frame
	_expect(relay.current_reality == AnchorableObject.RealityState.STATE_A, "held Station 30 relay must resist correction")
	_expect(station.witness_relay_correction_count == 0, "held Station 30 relay must not pay a correction cost")
	relay.set_anchored(false)
	station.run_witness_relay_correction_pass()
	_expect(station.last_witness_relay_correction_target == AnchorableObject.RealityState.STATE_B, "Station 30 correction must target the alternate relay configuration")
	_expect(station.witness_relay_correction_count == 1, "Station 30 correction must count the attempt")
	_expect(station.witness_relay_detail_faded, "Station 30 correction must preserve a faded detail")
	_expect(relay.current_reality == AnchorableObject.RealityState.STATE_B, "Station 30 correction must leave the alternate relay configuration visible")
	_expect(station.player.global_position == CHECKPOINT_POSITION, "Station 30 correction must reset Lena to the checkpoint")
	if state:
		_expect(state.decisions.has(&"station_30_witness_relay_corrected"), "Station 30 correction must be recorded")


func _check_campaign_boundary(state: Node) -> void:
	if state == null:
		return
	state.reset_campaign(true)
	for station_number in range(1, 26):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_25"), "campaign chain must still reach Station 25")
	_expect(not state.has_reached_station(&"station_26"), "PKG-0103 must not raise the delivered campaign boundary")
	_expect(state.get_next_campaign_station(&"station_25").is_empty(), "Station 25 must remain the delivered chain endpoint")
