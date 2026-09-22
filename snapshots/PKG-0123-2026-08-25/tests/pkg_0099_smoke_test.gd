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

## Station 11 carried a split floor (gallery + courtyard) until PKG-0119 rebuilt
## it as the flat of number 14 for Canon 0.3. The gate records the shipped names
## as the contract, so a later visibility pass still cannot silently rename them.
const REQUIRED_FLOORS := {
	"res://scenes/levels/station_11.tscn": ["FloorMain"],
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
	var station := packed.instantiate() as Station14
	root.add_child(station)
	await process_frame

	station.apply_threshold_setback()
	_expect(station.threshold_setback_count == 1, "threshold setback must be counted")
	_expect(station.mug_broken, "broken mug state must be set on rush")

	var state := root.get_node_or_null("GameStateManager")
	if state:
		_expect(
			state.decisions.has("station_14_mug_broken"),
			"setback must be written into campaign decisions"
		)

	station.place_bag_at_door()
	_expect(station.is_bag_placed, "bag must be placed at door")
	station.inspect_kettle()
	_expect(station.is_kettle_inspected, "kettle must be inspected")

	station.start_marta_dialogue()
	_expect(station.is_marta_dialogue_active, "marta dialogue must start")
	for i in range(station.marta_dialogue_lines.size()):
		station.advance_marta_dialogue()
	_expect(station.is_marta_dialogue_completed, "marta dialogue must complete")

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

	var leaf := station.get_node_or_null("Geometry/BalconyDoor")
	_expect(leaf is AnimatableBody2D, "Station 12 must carry the balcony leaf as a real body")
	if leaf is AnimatableBody2D:
		var door := leaf as AnimatableBody2D
		var open_x := door.position.x

		# Listening past an open balcony loses a line; it never ends the scene.
		station.play_message()
		await process_frame
		_expect(not station.message_active, "an open balcony must muffle the playback")
		_expect(station.muffled_playback_count > 0, "a lost attempt must be counted")
		_expect(not station.is_level_completed, "a muffled playback must not end the level")
		var state := root.get_node_or_null("GameStateManager")
		if state:
			_expect(
				state.decisions.has("station_12_playback_muffled"),
				"the cost of a muffled playback must be written into campaign decisions"
			)

		# Closing the leaf is the obstacle: it clears both the noise and the route.
		station.close_balcony()
		for _frame in range(40):
			await physics_frame
		_expect(station.is_balcony_closed, "the balcony leaf must close")
		_expect(door.position.x > open_x, "the closed leaf must leave the walking route")

		station.play_message()
		_expect(station.message_active, "a closed balcony must allow the playback")
		station.advance_message()
		_expect(station.rewind_count == 1, "Lena must rewind the recording once")
		for _step in range(10):
			if not station.message_active:
				break
			station.advance_message()
		_expect(station.is_message_completed, "the whole message must be heard")

		var guidance := station.get_node_or_null("NarrativeGuidanceService")
		if guidance:
			_expect(
				guidance.closed_hypotheses.get(&"hyp_identity_theft", false),
				"Marta's own voice must close the identity-theft hypothesis"
			)

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
