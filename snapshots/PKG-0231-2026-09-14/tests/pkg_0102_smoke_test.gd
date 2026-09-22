extends SceneTree

## PKG-0102 gate: Station 21..25 Vector-Stage route visibility and the single
## auditable R2 threshold in Station 22.
##
## This gate proves technical contracts only (D-012, ADR-003). It cannot prove
## that a space is fun, emotionally effective, or comprehensible to a person.

const ACT_IIC_PATHS: Array[String] = [
	"res://scenes/levels/station_21.tscn",
	"res://scenes/levels/station_22.tscn",
	"res://scenes/levels/station_23.tscn",
	"res://scenes/levels/station_24.tscn",
	"res://scenes/levels/station_25.tscn",
]

const REQUIRED_PROP_RADII: Dictionary = {
	21: {
		"AnesthesiaTerminal": 40.0,
		"SzymonPostCorrection": 50.0,
		"DrawingDispositionPedestal": 40.0,
		"FilteredDossierSlot": 40.0,
		"Station21Exit": 60.0,
	},
	22: {
		"UcpOfferConsole": 44.0,
		"OscilloscopeDisplay": 44.0,
		"SignalSpectrumPlot": 44.0,
		"ArchiveTerminal": 44.0,
		"DockingStation": 44.0,
	},
	23: {
		"DeadCircuitPort": 44.0,
		"ShuntFuseSwitch": 44.0,
		"ThermalOverloadGauge": 44.0,
		"SubstationJunction": 44.0,
		"TransformerCore": 44.0,
	},
	24: {
		"CCTVArray": 45.0,
		"CorrectionGauge": 40.0,
		"TransmissionTerminal": 40.0,
		"DispositionSelector": 45.0,
		"Station24Exit": 60.0,
	},
	25: {
		"MaintenanceCart": 45.0,
		"ScarChart": 40.0,
		"JakubOperator": 48.0,
		"GestureSensor": 40.0,
		"Station25Exit": 60.0,
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
		push_error("PKG-0102: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		var state_constants: Dictionary = state.get_script().get_script_constant_map()
		_expect(
			int(state_constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 18,
			"production campaign transition limit must be 18"
		)
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	await _check_stations(state)
	_check_three_question_headers()
	await _check_campaign_signal_chain(state)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	if _failures.is_empty():
		print("PKG-0102 SMOKE PASS: Act IIc Vector-Stage route, single R2 gate and chain 21..25")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0102 FAILURE: " + failure)
		quit(1)


func _check_stations(state: Node) -> void:
	for index in range(ACT_IIC_PATHS.size()):
		var expected_number := 21 + index
		var path: String = ACT_IIC_PATHS[index]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act IIc station must load: %s" % path)
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

		var geometry := station.get_node_or_null("Geometry") as Node2D
		_expect(geometry != null, "geometry root missing: %s" % path)
		if geometry:
			_check_rectangle_body(geometry.get_node_or_null("FloorMain") as StaticBody2D, REQUIRED_FLOOR_SIZE, "floor", path)
			_check_rectangle_body(geometry.get_node_or_null("Ceiling") as StaticBody2D, REQUIRED_CEILING_SIZE, "ceiling", path)
			_check_rectangle_body(geometry.get_node_or_null("WallLeft") as StaticBody2D, REQUIRED_WALL_SIZE, "left wall", path)
			_check_rectangle_body(geometry.get_node_or_null("WallRight") as StaticBody2D, REQUIRED_WALL_SIZE, "right wall", path)
			for child in geometry.get_children():
				if child is AnimatableBody2D:
					_expect(false, "unexpected physical obstacle in Station %d: %s" % [expected_number, child.name])

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

		if expected_number == 22:
			await _check_station_22_gate(station, state)

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
	_expect(draw_start >= 0, "station script must expose a state pass: %s" % script_path)
	if draw_start < 0:
		return
	var state_body := source.substr(draw_start)
	var play_call := state_body.find("VectorStageStyle.draw_play_plane")
	var first_variable := state_body.find("\n\tvar ")
	_expect(play_call >= 0, "state pass must derive the route from Geometry: %s" % path)
	_expect(first_variable < 0 or play_call < first_variable, "play plane must be first in state pass: %s" % path)
	var draw_body := source.substr(draw_start)
	for forbidden_call in [
		"draw_stage_background",
		"_draw_architecture()",
		"_draw_apartment_environment()",
		"_draw_bathroom_environment()",
		"_draw_study_room()",
		"draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)",
	]:
		_expect(not draw_body.contains(forbidden_call), "opaque legacy draw remains in %s" % script_path)


func _check_station_22_gate(station: Node2D, state: Node) -> void:
	var station_22 := station as Station22
	_expect(station_22 != null, "Station 22 script class is missing")
	if station_22 == null:
		return

	if state:
		state.record_decision(&"world_recognized", true)
	_expect(station_22.observe_signal_echo(), "echo observation must succeed after world recognition")
	_expect(station_22.observe_adjacent_state(), "adjacent-state observation must succeed after world recognition")
	_expect(station_22.is_hypotheses_opened, "two observed behaviours must open the diagnostic hypotheses")
	if state:
		_expect(state.decisions.has(&"p7.mutual_test.signal_echo_observed"), "echo must be recorded namespaced")
		_expect(state.decisions.has(&"p7.mutual_test.adjacent_state_observed"), "adjacent response must be recorded namespaced")
		_expect(not state.decisions.has(&"mechanic_cost_observed"), "Station 22 must not set the mechanic cost")


func _check_three_question_headers() -> void:
	var path := "res://scripts/levels/station_22.gd"
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "station script must be readable: %s" % path)
	if file == null:
		return
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


func _check_campaign_signal_chain(state: Node) -> void:
	if state == null:
		return
	state.reset_campaign(true)
	state.campaign_auto_transition_enabled = false
	for expected_number in range(21, 26):
		var path := "res://scenes/levels/station_%02d.tscn" % expected_number
		var packed := load(path) as PackedScene
		_expect(packed != null, "campaign chain station must load: %s" % path)
		if packed == null:
			continue
		var station := packed.instantiate()
		root.add_child(station)
		await process_frame
		station.level_completed.emit()
		await process_frame
		if expected_number < 25:
			var next_id := StringName("station_%02d" % (expected_number + 1))
			_expect(state.has_reached_station(next_id), "Station %d completion must unlock %s" % [expected_number, next_id])
		station.queue_free()
		await process_frame
	_expect(state.has_reached_station(&"station_25"), "campaign chain must reach Station 25")
	_expect(state.has_reached_station(&"station_26"), "production campaign chain must continue to Station 26")
