extends SceneTree

## PKG-0104 gate: Station 31..35 Act IIIb Vector-Stage surfaces and the two
## deliberately auditable physical mechanisms selected by the traversal audit.
##
## This gate proves technical contracts only (D-012, ADR-003). It cannot prove
## that a space is fun, emotionally effective, or comprehensible to a person.

const ACT_III_B_PATHS: Array[String] = [
	"res://scenes/levels/station_31.tscn",
	"res://scenes/levels/station_32.tscn",
	"res://scenes/levels/station_33.tscn",
	"res://scenes/levels/station_34.tscn",
	"res://scenes/levels/station_35.tscn",
]

const REQUIRED_PROP_RADII: Dictionary = {
	31: {
		"ElevenChairsRow": 48.0,
		"WierzbickaHoloterminal": 46.0,
		"JakubTwelfthChair": 45.0,
		"VariantChoiceLedger": 48.0,
		"Station31Exit": 60.0,
	},
	32: {
		"SteamedGlassPaneA": 46.0,
		"CrackedGlassPaneB": 46.0,
		"CondensationTraceEtcher": 48.0,
		"PolishedGlassPaneC": 46.0,
		"Station32Exit": 60.0,
	},
	33: {
		"VerticalLadderArray": 48.0,
		"DepthPressureGauge": 46.0,
		"MemoryBusCableTrunk": 48.0,
		"ShaftWorkLightBeacon": 46.0,
		"Station33Exit": 60.0,
	},
	34: {
		"MainExchangeCoreReactor": 50.0,
		"BiographyAllocationDesk": 46.0,
		"ThermalOverloadIndicator": 46.0,
		"JakubCoreDiagnosticPort": 48.0,
		"Station34Exit": 60.0,
	},
	35: {
		"SedationBasinPool": 52.0,
		"SludgeDrainValveWheel": 46.0,
		"ChemicalSedationSampler": 46.0,
		"JakubSedationMonitor": 48.0,
		"Station35Exit": 60.0,
	},
}

const REQUIRED_CEILING_SIZES: Dictionary = {
	31: Vector2(640.0, 40.0),
	32: Vector2(640.0, 48.0),
	33: Vector2(640.0, 48.0),
	34: Vector2(640.0, 48.0),
	35: Vector2(640.0, 48.0),
}

const REQUIRED_FLOOR_SIZE := Vector2(640.0, 80.0)
const REQUIRED_WALL_SIZE := Vector2(20.0, 360.0)
const REQUIRED_AIRLOCK_SIZE := Vector2(50.0, 70.0)
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0104: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		var state_constants: Dictionary = state.get_script().get_script_constant_map()
		_expect(
			int(state_constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 41,
			"production campaign transition limit must be 41"
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
		print("PKG-0104 SMOKE PASS: Act IIIb Vector-Stage route, R6/R1 mechanisms and production chain")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0104 FAILURE: " + failure)
		quit(1)


func _check_stations(state: Node) -> void:
	for index in range(ACT_III_B_PATHS.size()):
		var expected_number := 31 + index
		var path: String = ACT_III_B_PATHS[index]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act IIIb station must load: %s" % path)
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
			_check_rectangle_body(geometry.get_node_or_null("Ceiling") as StaticBody2D, REQUIRED_CEILING_SIZES[expected_number], "ceiling", path)
			_check_rectangle_body(geometry.get_node_or_null("WallLeft") as StaticBody2D, REQUIRED_WALL_SIZE, "left wall", path)
			_check_rectangle_body(geometry.get_node_or_null("WallRight") as StaticBody2D, REQUIRED_WALL_SIZE, "right wall", path)
			var expected_obstacle_name := ""
			if expected_number == 32:
				expected_obstacle_name = "ObservedGlassTrace"
			elif expected_number == 33:
				expected_obstacle_name = "DualWitnessFrame"
			var obstacle_count := 0
			for child in geometry.get_children():
				if child is AnimatableBody2D:
					obstacle_count += 1
					_expect(child.name == expected_obstacle_name, "unexpected physical obstacle in Station %d: %s" % [expected_number, child.name])
			_expect(obstacle_count == (1 if expected_number in [32, 33] else 0), "Station %d must carry exactly the audited obstacle count" % expected_number)

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

		if expected_number == 32:
			await _check_station_32(station as Station32, state)
		elif expected_number == 33:
			await _check_station_33(station as Station33, state)

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
			_expect(is_equal_approx(prop.interaction_radius, float(expected[prop_name])), "prop interaction radius changed: %s/%s" % [path, prop_name])


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
		"_draw_corridor_background()",
		"_draw_glass_reflections()",
		"draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)",
	]:
		_expect(not draw_body.contains(forbidden_call), "opaque legacy draw remains in %s" % script_path)


func _check_three_question_headers() -> void:
	for station_number in range(31, 36):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "station script must be readable: %s" % path)
		if file == null:
			continue
		var source := file.get_as_text()
		file.close()
		for question in ["dlaczego to tu jest", "czego wymaga od Leny", "koszt porażki"]:
			_expect(source.contains("## PRZESZKODA — " + question), "%s is missing the three-question header '%s'" % [path, question])
		var why_line := ""
		for line in source.split("\n"):
			if line.begins_with("## PRZESZKODA — dlaczego to tu jest"):
				why_line = line
				break
		_expect(not why_line.to_lower().contains("gracz"), "%s world sentence contains forbidden player wording" % path)


func _check_station_32(station: Station32, state: Node) -> void:
	_expect(station != null, "Station 32 script class is missing")
	if station == null:
		return
	var glass := station.get_node_or_null("Geometry/ObservedGlassTrace") as AnchorableObject
	_expect(glass != null, "Station 32 observed glass is missing")
	if glass == null:
		return
	_expect(glass.state_a_position == glass.state_b_position, "Station 32 glass must stay in its mounted frame")
	_expect(not glass.state_a_solid and glass.state_b_solid, "Station 32 glass must open in A and block in B")
	_expect(glass.current_reality == AnchorableObject.RealityState.STATE_A, "Station 32 glass must start in observed state A")
	glass.set_anchored(true)
	station.run_glass_observation_check()
	await process_frame
	_expect(glass.current_reality == AnchorableObject.RealityState.STATE_A, "anchored Station 32 glass must resist the observation correction")
	_expect(station.glass_observation_correction_count == 0, "anchored Station 32 glass must not pay a correction cost")
	glass.set_anchored(false)
	station.run_glass_observation_check()
	_expect(station.glass_observation_correction_count == 1, "Station 32 correction must count the unobserved attempt")
	_expect(station.glass_detail_faded, "Station 32 correction must preserve a faded trace detail")
	_expect(glass.current_reality == AnchorableObject.RealityState.STATE_A, "Station 32 correction must restore the passable observed state for a new attempt")
	_expect(station.player.global_position == Station32.CHECKPOINT_POSITION, "Station 32 correction must reset Lena to the checkpoint")
	await process_frame
	if state:
		_expect(state.decisions.has(&"station_32_observed_glass_corrected"), "Station 32 correction must be recorded")


func _check_station_33(station: Station33, state: Node) -> void:
	_expect(station != null, "Station 33 script class is missing")
	if station == null:
		return
	var frame := station.get_node_or_null("Geometry/DualWitnessFrame") as AnchorableObject
	_expect(frame != null, "Station 33 dual witness frame is missing")
	if frame == null:
		return
	_expect(frame.state_a_position == frame.state_b_position, "Station 33 frame must stay in its machine bay")
	_expect(frame.state_a_size != frame.state_b_size, "Station 33 frame configurations must differ in extent")
	_expect(frame.current_reality == AnchorableObject.RealityState.STATE_A, "Station 33 frame must start in configuration A")
	frame.set_anchored(true)
	station.run_witness_frame_correction_pass()
	await process_frame
	_expect(frame.current_reality == AnchorableObject.RealityState.STATE_A, "anchored Station 33 frame must resist correction")
	_expect(station.witness_frame_correction_count == 0, "anchored Station 33 frame must not pay a correction cost")
	frame.set_anchored(false)
	station.run_witness_frame_correction_pass()
	_expect(station.last_witness_frame_correction_target == AnchorableObject.RealityState.STATE_B, "Station 33 correction must target the alternate frame configuration")
	_expect(station.witness_frame_correction_count == 1, "Station 33 correction must count the attempt")
	_expect(station.witness_frame_detail_faded, "Station 33 correction must preserve a faded witness detail")
	_expect(frame.current_reality == AnchorableObject.RealityState.STATE_B, "Station 33 correction must leave the alternate configuration visible")
	_expect(station.player.global_position == Station33.CHECKPOINT_POSITION, "Station 33 correction must reset Lena to the checkpoint")
	await process_frame
	if state:
		_expect(state.decisions.has(&"station_33_dual_witness_corrected"), "Station 33 correction must be recorded")


func _check_campaign_boundary(state: Node) -> void:
	if state == null:
		return
	state.reset_campaign(true)
	for station_number in range(1, 26):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_25"), "campaign chain must still reach Station 25")
	_expect(state.has_reached_station(&"station_26"), "PKG-0104 must preserve the production chain beyond Station 25")
	_expect(state.get_next_campaign_station(&"station_25") == &"station_26", "Station 25 must lead to Station 26")
