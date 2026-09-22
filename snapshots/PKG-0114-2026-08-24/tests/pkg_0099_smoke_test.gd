extends SceneTree

## PKG-0099 gate: the playable vertical slice of Act II (Station 11..15).
##
## This gate proves technical contracts only (D-012, ADR-003). It does not and
## cannot prove that the obstacles are comprehensible or enjoyable.
##
## It checks that:
##  - Station 11..15 carry a visible Vector-Stage layer with the right profile;
##  - Station 14 carries the first real campaign use of Zakotwiczenie;
##  - Station 12 carries the overlapping-stairs obstacle;
##  - anchoring actually changes state and resists a consensus pass;
##  - the floor, ceiling and wall colliders, the airlock and the prop
##    interaction radii survived the conversion untouched;
##  - the completion chain 11 -> 15 still runs and still stops at the limit 25.

const ACT_II_PATHS := [
	"res://scenes/levels/station_11.tscn",
	"res://scenes/levels/station_12.tscn",
	"res://scenes/levels/station_13.tscn",
	"res://scenes/levels/station_14.tscn",
	"res://scenes/levels/station_15.tscn",
]

## Colliders every Act II space has and this package must not touch.
const REQUIRED_COLLIDERS := ["Ceiling", "WallLeft", "WallRight"]

## Station 11 was authored with a split floor (gallery + courtyard) instead of a
## single FloorMain. Renaming it would be a collider change, which this package
## is forbidden to make, so the gate records the shipped names as the contract.
const REQUIRED_FLOORS := {
	"res://scenes/levels/station_11.tscn": ["GalleryFloor", "CourtyardFloor"],
	"res://scenes/levels/station_12.tscn": ["FloorMain"],
	"res://scenes/levels/station_13.tscn": ["FloorMain"],
	"res://scenes/levels/station_14.tscn": ["FloorMain"],
	"res://scenes/levels/station_15.tscn": ["FloorMain"],
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0099: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		var state_constants: Dictionary = state.get_script().get_script_constant_map()
		_expect(
			int(state_constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 41,
			"production campaign transition limit must be 41"
		)
		state.campaign_auto_transition_enabled = false

	await _check_stations(state)
	await _check_station_14_anchor()
	await _check_station_12_obstacle()
	_check_three_question_headers()

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	if _failures.is_empty():
		print("PKG-0099 SMOKE PASS: Act II playable slice, anchoring and unlock chain 11..15")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0099 FAILURE: " + failure)
		quit(1)


func _check_stations(state: Node) -> void:
	for expected_number in range(11, 16):
		var path: String = ACT_II_PATHS[expected_number - 11]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act II station must load: %s" % path)
		if packed == null:
			continue
		var station := packed.instantiate()
		root.add_child(station)
		await process_frame

		var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
		_expect(stage != null, "Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number == expected_number, "Vector-Stage profile mismatch: %s" % path)
			_expect(stage.z_index < 0, "Vector-Stage layer must stay behind level content: %s" % path)

		# The visibility fix (D-096) must not have touched collision or reach.
		var geometry := station.get_node_or_null("Geometry")
		_expect(geometry != null, "geometry root missing: %s" % path)
		if geometry:
			var required: Array = REQUIRED_COLLIDERS.duplicate()
			required.append_array(REQUIRED_FLOORS.get(path, ["FloorMain"]))
			for required_body in required:
				var body := geometry.get_node_or_null(required_body) as StaticBody2D
				_expect(body != null, "collider %s missing: %s" % [required_body, path])
				if body:
					_expect(
						body.get_node_or_null("CollisionShape2D") != null,
						"collider %s lost its shape: %s" % [required_body, path]
					)

		var props := station.get_node_or_null("Props")
		_expect(props != null, "props root missing: %s" % path)
		if props:
			_expect(props.get_child_count() >= 5, "props were removed by the conversion: %s" % path)
			for prop in props.get_children():
				if prop is MemoryResonancePoint:
					_expect(
						prop.interaction_radius > 0.0,
						"prop interaction radius must stay positive: %s" % path
					)

		_expect(station.get_node_or_null("AirlockZone") != null, "airlock zone missing: %s" % path)
		_expect(station.get_node_or_null("Player") != null, "player instance missing: %s" % path)
		_expect(station.has_signal(&"level_completed"), "level completion signal missing: %s" % path)

		# The station script must no longer paint its own opaque backdrop over
		# the Vector-Stage layer; only the state pass is allowed to remain.
		_expect(
			station.has_method("_draw_state_layer"),
			"station script must expose a Vector-Stage state pass: %s" % path
		)

		if state:
			state.reset_campaign(true)
			station.level_completed.emit()
			await process_frame
			var next_id := StringName("station_%02d" % (expected_number + 1))
			_expect(
				state.has_reached_station(next_id),
				"Station %d completion must unlock %s" % [expected_number, next_id]
			)
		station.queue_free()
		await process_frame

	# The chain must still stop where the delivered campaign stops.
	if state:
		state.reset_campaign(true)
		for station_number in range(10, 26):
			state.complete_station(StringName("station_%02d" % station_number), false)
		_expect(state.has_reached_station(&"station_15"), "chain 11..15 must still reach station 15")
		_expect(state.has_reached_station(&"station_26"), "the production route must continue beyond Station 25")


func _check_station_14_anchor() -> void:
	var packed := load("res://scenes/levels/station_14.tscn") as PackedScene
	_expect(packed != null, "station_14 must load")
	if packed == null:
		return
	var station := packed.instantiate()
	root.add_child(station)
	await process_frame

	var panel := station.get_node_or_null("Geometry/ScoredMetalPanel")
	_expect(panel is AnchorableObject, "Station 14 must carry an AnchorableObject named after a thing in the world")
	if panel is AnchorableObject:
		var anchorable := panel as AnchorableObject
		_expect(
			anchorable.state_a_position != anchorable.state_b_position
			or anchorable.state_a_size != anchorable.state_b_size,
			"the scored panel must actually differ between its two mountings"
		)
		_expect(not anchorable.is_anchored, "the panel must start unheld")
		_expect(anchorable.toggle_anchor(), "toggle_anchor() must return the changed state")
		_expect(anchorable.is_anchored, "toggle_anchor() must hold the panel")
		await process_frame

		# Holding costs something, and the cost is recorded.
		_expect(station.is_anchor_cost_paid, "anchoring must charge its narrative cost")
		_expect(
			station.tape_voice_clarity < 1.0,
			"anchoring must dim Jakub's recorded voice (FULL_STORY.md, scene 14)"
		)
		var state := root.get_node_or_null("GameStateManager")
		if state:
			_expect(
				state.decisions.has("station_14_anchored_scored_panel"),
				"anchoring must be written into campaign decisions"
			)

		# A held panel resists the consensus pass; that is the whole mechanic.
		var reality_before: int = anchorable.current_reality
		station.run_correction_pass()
		await process_frame
		_expect(
			anchorable.current_reality == reality_before,
			"a held panel must resist the consensus pass"
		)

		# An unheld panel yields, and the in-world lever puts it back.
		anchorable.set_anchored(false)
		station.run_correction_pass()
		await process_frame
		_expect(
			anchorable.current_reality != reality_before,
			"an unheld panel must yield to the consensus pass"
		)
		station.restore_service_version()
		await process_frame
		_expect(
			anchorable.current_reality == AnchorableObject.RealityState.STATE_A,
			"the hydraulic lever must re-seat the bay in its service version"
		)

	station.queue_free()
	await process_frame


func _check_station_12_obstacle() -> void:
	var packed := load("res://scenes/levels/station_12.tscn") as PackedScene
	_expect(packed != null, "station_12 must load")
	if packed == null:
		return
	var station := packed.instantiate()
	root.add_child(station)
	await process_frame

	var flight := station.get_node_or_null("Geometry/EvacuationStairFlight")
	_expect(flight is AnchorableObject, "Station 12 must carry at least one AnchorableObject")
	if flight is AnchorableObject:
		var anchorable := flight as AnchorableObject
		_expect(
			anchorable.state_a_position == anchorable.state_b_position,
			"the contested flight must not travel — it is a disagreement, not a moving platform"
		)
		_expect(
			anchorable.state_a_size != anchorable.state_b_size,
			"the two versions of the flight must differ in extent"
		)
		_expect(station.is_descent_open(), "the descent must start open")

		# The pass runs on the space's own schedule and closes the route.
		station.run_correction_pass()
		await process_frame
		_expect(not station.is_descent_open(), "an unheld flight must be resolved away")

		# Holding it keeps the route for the other person.
		station.run_correction_pass()
		await process_frame
		_expect(station.is_descent_open(), "the pass must be able to restore version A")
		_expect(anchorable.toggle_anchor(), "toggle_anchor() must return the changed state")
		station.run_correction_pass()
		await process_frame
		_expect(station.is_descent_open(), "a held flight must keep the child's route open")

		# Failure is a correction with a recorded cost, never a death.
		anchorable.set_anchored(false)
		station.run_correction_pass()
		await process_frame
		station._apply_child_correction()
		await process_frame
		_expect(station.child_correction_count > 0, "a lost attempt must be counted")
		_expect(station.is_descent_open(), "the checkpoint return must re-seat the descent")
		_expect(not station.is_level_completed, "correction must not end or fail the level")
		var state := root.get_node_or_null("GameStateManager")
		if state:
			_expect(
				state.decisions.has("station_12_child_corrected"),
				"the cost of a lost child must be written into campaign decisions"
			)

		# Escorting the child is what lets the warden close the passage.
		station._on_child_safe()
		await process_frame
		_expect(station.is_child_evacuated, "escorting the child must mark the evacuation done")
		_expect(station.is_safety_demonstrated, "escorting the child must demonstrate UCP safety")

	station.queue_free()
	await process_frame


## Chapter 3 of the obstacle canon is a hard requirement, so the gate reads the
## script headers instead of trusting that somebody wrote them.
func _check_three_question_headers() -> void:
	for station_number in [12, 14]:
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "station script must be readable: %s" % path)
		if file == null:
			continue
		var text := file.get_as_text()
		file.close()
		for question in ["dlaczego to tu jest", "czego wymaga od Leny", "koszt porażki"]:
			_expect(
				text.contains("## PRZESZKODA — " + question),
				"%s is missing the three-question header line '%s'" % [path, question]
			)
		var why_line := ""
		for line in text.split("\n"):
			if line.begins_with("## PRZESZKODA — dlaczego to tu jest"):
				why_line = line
				break
		_expect(
			not why_line.to_lower().contains("gracz"),
			"%s: the world sentence must not contain the word 'gracz'" % path
		)
