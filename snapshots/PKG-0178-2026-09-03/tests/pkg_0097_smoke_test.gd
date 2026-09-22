extends SceneTree

## PKG-0097 gate: Act IIc Vector-Stage conversion (Station 21..25) and the real
## campaign completion chain reaching the new delivered limit of 25.

const ACT_IIC_PATHS := [
	"res://scenes/levels/station_21.tscn",
	"res://scenes/levels/station_22.tscn",
	"res://scenes/levels/station_23.tscn",
	"res://scenes/levels/station_24.tscn",
	"res://scenes/levels/station_25.tscn",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0097: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		var state_constants: Dictionary = state.get_script().get_script_constant_map()
		_expect(
			int(state_constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 18,
			"production campaign transition limit must be 18"
		)
		state.reset_campaign(true)
		state.complete_station(&"station_20", false)
		_expect(state.has_reached_station(&"station_21"), "completing station 20 must unlock station 21")
		state.complete_station(&"station_21", false)
		_expect(state.has_reached_station(&"station_22"), "completing station 21 must unlock station 22")
		state.complete_station(&"station_22", false)
		_expect(state.has_reached_station(&"station_23"), "completing station 22 must unlock station 23")
		state.complete_station(&"station_23", false)
		_expect(state.has_reached_station(&"station_24"), "completing station 23 must unlock station 24")
		state.complete_station(&"station_24", false)
		_expect(state.has_reached_station(&"station_25"), "completing station 24 must unlock station 25")
		state.complete_station(&"station_25", false)
		_expect(state.has_reached_station(&"station_26"), "station 25 must unlock station 26 in the production route")
		_expect(
			state.get_next_campaign_station(&"station_25") == &"station_26",
			"station 25 must report station 26 as its successor"
		)
		for station_number in range(21, 26):
			var station_id := StringName("station_%02d" % station_number)
			var next_id: StringName = state.get_next_campaign_station(station_id)
			if station_number == 25:
				continue
			_expect(
				ResourceLoader.exists(
					"res://scenes/levels/station_" + String(next_id).trim_prefix("station_") + ".tscn"
				),
				"campaign successor of %s must resolve to a real scene" % station_id
			)
		_expect(
			int(state_constants.get("SAVE_SCHEMA_VERSION", -1)) == 1,
			"campaign save schema must stay at version 1"
		)
		state.campaign_auto_transition_enabled = false

	for expected_number in range(21, 26):
		var path: String = ACT_IIC_PATHS[expected_number - 21]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act IIc station must load: %s" % path)
		if packed == null:
			continue
		var station := packed.instantiate()
		root.add_child(station)
		await process_frame

		var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
		_expect(stage != null, "Act IIc Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number == expected_number, "Act IIc station profile mismatch: %s" % path)
			_expect(stage.z_index < 0, "Vector-Stage layer must stay behind level content: %s" % path)
		_expect(station.get_node_or_null("AtmosphereRig") is AtmosphereRig, "Act IIc atmosphere rig missing: %s" % path)
		_expect(station.get_node_or_null("CRTDialogueBox") is CRTDialogueBox, "Act IIc CRT surface missing: %s" % path)

		var cue := station.get_node_or_null("OpeningDialogueCue")
		_expect(cue != null and cue.get_script() != null, "Act IIc checkpoint cue missing: %s" % path)
		if cue:
			_expect(
				String(cue.station_id) == "station_%d" % expected_number,
				"Act IIc cue must checkpoint its own station: %s" % path
			)
			_expect(not String(cue.opening_line).is_empty(), "Act IIc cue must carry an opening line: %s" % path)

		# The conversion must not touch collision, geometry or interaction contracts.
		var geometry := station.get_node_or_null("Geometry")
		_expect(geometry != null, "Act IIc geometry root missing: %s" % path)
		if geometry:
			for required_body in ["FloorMain", "Ceiling", "WallLeft", "WallRight"]:
				var body := geometry.get_node_or_null(required_body) as StaticBody2D
				_expect(body != null, "Act IIc collider %s missing: %s" % [required_body, path])
				if body:
					_expect(
						body.get_node_or_null("CollisionShape2D") != null,
						"Act IIc collider %s lost its shape: %s" % [required_body, path]
					)
		var props := station.get_node_or_null("Props")
		_expect(props != null, "Act IIc props root missing: %s" % path)
		if props:
			_expect(props.get_child_count() >= 5, "Act IIc props were removed by the conversion: %s" % path)
			for prop in props.get_children():
				if prop is MemoryResonancePoint:
					_expect(
						prop.interaction_radius > 0.0,
						"Act IIc interaction radius must stay positive: %s" % path
					)
		_expect(station.get_node_or_null("AirlockZone") != null, "Act IIc airlock zone missing: %s" % path)
		_expect(station.get_node_or_null("Player") != null, "Act IIc player instance missing: %s" % path)
		_expect(station.has_signal(&"level_completed"), "Act IIc level completion signal missing: %s" % path)

		if state:
			state.reset_campaign(true)
			station.level_completed.emit()
			await process_frame
			var next_id := StringName("station_%02d" % (expected_number + 1))
			if expected_number < 25:
				_expect(
					state.has_reached_station(next_id),
					"Station %d completion signal must unlock %s" % [expected_number, next_id]
				)
			else:
				_expect(state.has_reached_station(next_id), "Station 25 completion must unlock Station 26")
		station.queue_free()
		await process_frame

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	if _failures.is_empty():
		print("PKG-0097 SMOKE PASS: Act IIc Vector-Stage and campaign unlock chain 21..25")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0097 FAILURE: " + failure)
		quit(1)
