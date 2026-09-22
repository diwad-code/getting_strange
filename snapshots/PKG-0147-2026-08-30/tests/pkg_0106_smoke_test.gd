extends SceneTree

## PKG-0106 gate: Station 41 Vector-Stage choice chamber, shared presentation
## contract, conscious mechanical silence and the delivered campaign boundary.
##
## This gate proves technical contracts only (D-012, ADR-003). It cannot prove
## that the choice is fun, emotionally effective, or comprehensible to a person.

const STATION_PATH := "res://scenes/levels/station_41.tscn"
const REQUIRED_FLOOR_SIZE := Vector2(640.0, 80.0)
const REQUIRED_CEILING_SIZE := Vector2(640.0, 48.0)
const REQUIRED_WALL_SIZE := Vector2(20.0, 360.0)
const REQUIRED_AIRLOCK_SIZE := Vector2(50.0, 70.0)
const CHECKPOINT_POSITION := Vector2(65.0, 248.0)
const REQUIRED_PROP_RADII: Dictionary = {
	"TopographyDisplay": 48.0,
	"ConsoleReturnA": 48.0,
	"ConsoleReconciliationB": 48.0,
	"ConsoleTestimonyC": 48.0,
	"Station41Exit": 60.0,
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0106: " + message)


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
			"this package must preserve the delivered save schema"
		)
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	await _check_station(state)
	_check_three_question_headers()
	await _check_campaign_boundary(state)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	if _failures.is_empty():
		print("PKG-0106 SMOKE PASS: Station 41 Vector-Stage choice chamber, conscious silence and production chain")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0106 FAILURE: " + failure)
		quit(1)


func _check_station(state: Node) -> void:
	var packed := load(STATION_PATH) as PackedScene
	_expect(packed != null, "Station 41 scene must load")
	if packed == null:
		return

	var station := packed.instantiate() as Station41
	_expect(station != null, "Station 41 script class is missing")
	if station == null:
		return
	root.add_child(station)
	await process_frame

	var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
	_expect(stage != null, "Station 41 Vector-Stage environment is missing")
	if stage:
		_expect(stage.station_number == 41, "Station 41 Vector-Stage profile number must be 41")
		_expect(stage.stage_seed == 41, "Station 41 Vector-Stage stage seed must be 41")
		_expect(stage.z_index < 0, "Vector-Stage environment must stay behind level content")

	var atmosphere := station.get_node_or_null("AtmosphereRig") as AtmosphereRig
	_expect(atmosphere != null, "Station 41 atmosphere rig is missing")
	if atmosphere:
		_expect(atmosphere.station_number == 41, "Station 41 atmosphere profile number must be 41")
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	_expect(dialogue != null, "Station 41 CRT dialogue surface is missing")
	var cue := station.get_node_or_null("OpeningDialogueCue") as StationDialogueCue
	_expect(cue != null, "Station 41 opening dialogue cue is missing")
	if cue:
		_expect(cue.station_id == &"station_41", "Station 41 cue id must be station_41")
		_expect(not cue.opening_line.is_empty(), "Station 41 cue must carry an opening line")

	var player := station.get_node_or_null("Player") as PrototypePlayer
	var props := station.get_node_or_null("Props") as Node2D
	var airlock := station.get_node_or_null("AirlockZone") as Area2D
	_expect(player != null, "Station 41 player instance is missing")
	_expect(props != null, "Station 41 props root is missing")
	_expect(airlock != null, "Station 41 airlock zone is missing")
	_expect(station.has_signal(&"level_completed"), "Station 41 level_completed signal is missing")
	_expect(station.has_signal(&"operation_selected"), "Station 41 operation_selected signal is missing")
	_expect(station.has_method("select_operation"), "Station 41 select_operation method is missing")

	_check_geometry(station)
	_check_airlock(airlock)
	_check_prop_radii(props)
	_check_state_pass_source()

	if props == null or player == null:
		station.queue_free()
		await process_frame
		return

	var topography := props.get_node_or_null("TopographyDisplay") as MemoryResonancePoint
	var console_a := props.get_node_or_null("ConsoleReturnA") as MemoryResonancePoint
	var console_b := props.get_node_or_null("ConsoleReconciliationB") as MemoryResonancePoint
	var console_c := props.get_node_or_null("ConsoleTestimonyC") as MemoryResonancePoint
	var exit_prop := props.get_node_or_null("Station41Exit") as MemoryResonancePoint
	_expect(topography != null, "Station 41 topography display prop is missing")
	_expect(console_a != null, "Station 41 Operation A console is missing")
	_expect(console_b != null, "Station 41 Operation B console is missing")
	_expect(console_c != null, "Station 41 Operation C console is missing")
	_expect(exit_prop != null, "Station 41 resolution gate prop is missing")

	var obstacle_count := 0
	var unexpected_static_count := 0
	var geometry := station.get_node_or_null("Geometry") as Node2D
	if geometry:
		for child in geometry.get_children():
			if child is AnimatableBody2D:
				obstacle_count += 1
			if child is StaticBody2D and child.name not in ["FloorMain", "Ceiling", "WallLeft", "WallRight"]:
				unexpected_static_count += 1
	_expect(obstacle_count == 0, "Station 41 conscious silence must contain zero AnimatableBody2D obstacles")
	_expect(unexpected_static_count == 0, "Station 41 geometry must not gain a static obstacle")

	_expect(station.chosen_operation.is_empty(), "Station 41 must start without a chosen operation")
	_expect(not station.is_exit_unlocked, "Station 41 resolution gate must start locked")
	if state:
		_expect(state.last_checkpoint_station == &"station_41", "Station 41 cue must establish the station checkpoint")
		_expect(state.last_checkpoint_position == CHECKPOINT_POSITION, "Station 41 cue must preserve the declared checkpoint")

	for operation in ["A", "B", "C"]:
		station.select_operation(operation)
		await process_frame
		_expect(station.chosen_operation == operation, "Station 41 must expose operation variant %s" % operation)
		_expect(station.is_exit_unlocked, "Station 41 gate must unlock after operation %s" % operation)
		_expect(console_a.is_activated == (operation == "A"), "Operation A activation must follow the selected variant")
		_expect(console_b.is_activated == (operation == "B"), "Operation B activation must follow the selected variant")
		_expect(console_c.is_activated == (operation == "C"), "Operation C activation must follow the selected variant")

	if topography:
		player.global_position = Vector2(130.0, 246.0)
		await physics_frame
		topography.trigger_interaction()
		_expect(station.is_topography_inspected, "Station 41 topography inspection must remain available")

	if console_a and console_b and console_c:
		player.global_position = Vector2(220.0, 246.0)
		console_a.trigger_interaction()
		_expect(station.is_op_a_inspected, "Station 41 console A interaction must remain available")
		player.global_position = Vector2(330.0, 246.0)
		console_b.trigger_interaction()
		_expect(station.is_op_b_inspected, "Station 41 console B interaction must remain available")
		player.global_position = Vector2(440.0, 246.0)
		console_c.trigger_interaction()
		_expect(station.is_op_c_inspected, "Station 41 console C interaction must remain available")

	for frame in range(25):
		await physics_frame
	_expect(station._exit_open_progress > 0.1, "Station 41 resolution gate animation must advance")

	if exit_prop:
		_expect(exit_prop.is_activated, "Station 41 exit prop must be active after a choice")
	player.global_position = Vector2(610.0, 245.0)
	for frame in range(5):
		await physics_frame
	_expect(station.is_level_completed, "Station 41 must complete at its existing airlock after a choice")

	station.queue_free()
	await process_frame


func _check_geometry(station: Station41) -> void:
	var geometry := station.get_node_or_null("Geometry") as Node2D
	_expect(geometry != null, "Station 41 geometry root is missing")
	if geometry == null:
		return
	_check_rectangle_body(geometry.get_node_or_null("FloorMain") as StaticBody2D, REQUIRED_FLOOR_SIZE, "floor")
	_check_rectangle_body(geometry.get_node_or_null("Ceiling") as StaticBody2D, REQUIRED_CEILING_SIZE, "ceiling")
	_check_rectangle_body(geometry.get_node_or_null("WallLeft") as StaticBody2D, REQUIRED_WALL_SIZE, "left wall")
	_check_rectangle_body(geometry.get_node_or_null("WallRight") as StaticBody2D, REQUIRED_WALL_SIZE, "right wall")


func _check_rectangle_body(body: StaticBody2D, expected_size: Vector2, label: String) -> void:
	_expect(body != null, "Station 41 %s collider is missing" % label)
	if body == null:
		return
	var shape_node := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	_expect(shape_node != null, "Station 41 %s collider lost its shape" % label)
	if shape_node == null:
		return
	var rectangle := shape_node.shape as RectangleShape2D
	_expect(rectangle != null, "Station 41 %s collider must use a rectangle" % label)
	if rectangle:
		_expect(rectangle.size == expected_size, "Station 41 %s collider shape changed" % label)


func _check_airlock(airlock: Area2D) -> void:
	if airlock == null:
		return
	var shape_node := airlock.get_node_or_null("CollisionShape2D") as CollisionShape2D
	_expect(shape_node != null, "Station 41 airlock lost its shape")
	if shape_node == null:
		return
	var rectangle := shape_node.shape as RectangleShape2D
	_expect(rectangle != null, "Station 41 airlock must use a rectangle")
	if rectangle:
		_expect(rectangle.size == REQUIRED_AIRLOCK_SIZE, "Station 41 airlock shape changed")


func _check_prop_radii(props: Node2D) -> void:
	if props == null:
		return
	for prop_name in REQUIRED_PROP_RADII:
		var prop := props.get_node_or_null(String(prop_name)) as MemoryResonancePoint
		_expect(prop != null, "Station 41 prop missing from interaction contract: %s" % prop_name)
		if prop:
			_expect(
				is_equal_approx(prop.interaction_radius, float(REQUIRED_PROP_RADII[prop_name])),
				"Station 41 prop interaction radius changed: %s" % prop_name
			)


func _check_state_pass_source() -> void:
	var script_path := "res://scripts/levels/station_41.gd"
	var file := FileAccess.open(script_path, FileAccess.READ)
	_expect(file != null, "Station 41 script must be readable")
	if file == null:
		return
	var source := file.get_as_text()
	file.close()
	var draw_start := source.find("func _draw() -> void:")
	var state_start := source.find("func _draw_state_layer() -> void:")
	_expect(draw_start >= 0 and state_start > draw_start, "Station 41 must expose an active state pass")
	if draw_start < 0 or state_start < 0:
		return
	var draw_body := source.substr(draw_start, state_start - draw_start)
	var state_body := source.substr(state_start)
	var play_call := state_body.find("VectorStageStyle.draw_play_plane(self, geometry)")
	var first_variable := state_body.find("\n\tvar ")
	_expect(play_call >= 0, "Station 41 state pass must derive the route from Geometry")
	_expect(first_variable < 0 or play_call < first_variable, "Station 41 play plane must be first in the state pass")
	_expect(draw_body.contains("_draw_state_layer()"), "Station 41 _draw must invoke the state pass")
	for forbidden_call in [
		"draw_stage_background",
		"_draw_architecture()",
		"_draw_background_environment()",
		"_draw_corridor_background()",
		"_draw_glass_reflections()",
		"draw_rect(Rect2(0.0, 0.0, 640.0, 360.0)",
	]:
		_expect(not draw_body.contains(forbidden_call), "opaque legacy draw remains in Station 41 active _draw")


func _check_three_question_headers() -> void:
	var file := FileAccess.open("res://scripts/levels/station_41.gd", FileAccess.READ)
	_expect(file != null, "Station 41 script must be readable for traversal audit")
	if file == null:
		return
	var source := file.get_as_text()
	file.close()
	for question in ["dlaczego to tu jest", "czego wymaga od Leny", "koszt porażki"]:
		_expect(source.contains("## PRZESZKODA — " + question), "Station 41 is missing the three-question header '%s'" % question)
	var why_line := ""
	for line in source.split("\n"):
		if line.begins_with("## PRZESZKODA — dlaczego to tu jest"):
			why_line = line
			break
	_expect(not why_line.to_lower().contains("gracz"), "Station 41 world sentence contains forbidden player wording")


func _check_campaign_boundary(state: Node) -> void:
	if state == null:
		return
	state.reset_campaign(true)
	for station_number in range(1, 26):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_25"), "campaign chain must still reach Station 25")
	_expect(state.has_reached_station(&"station_26"), "PKG-0106 must preserve the production chain beyond Station 25")
	_expect(state.get_next_campaign_station(&"station_25") == &"station_26", "Station 25 must lead to Station 26")
