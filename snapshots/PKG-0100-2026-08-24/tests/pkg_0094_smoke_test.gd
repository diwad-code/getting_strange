extends SceneTree

const ACT_I_PATHS := [
	"res://scenes/levels/station_06.tscn",
	"res://scenes/levels/station_07.tscn",
	"res://scenes/levels/station_08.tscn",
	"res://scenes/levels/station_09.tscn",
	"res://scenes/levels/station_10.tscn",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0094: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		state.reset_campaign(true)
		_expect(state.get_selectable_stations().size() == 1, "normal campaign must initially expose station 01 only")
		_expect(state.get_selectable_stations(true).size() == 43, "test selection must expose all 43 spaces")
		state.set_checkpoint(&"station_06", Vector2(80.0, 296.0))
		state.collect_clue(&"pkg_0094_clue")
		state.record_decision(&"pkg_0094_decision", "retain")
		_expect(state.save_campaign(), "campaign save must write")
		state.reset_campaign(false)
		_expect(state.reload_campaign_from_disk(), "campaign must reload its current schema")
		_expect(state.last_checkpoint_station == &"station_06", "checkpoint station must survive reload")
		_expect(state.last_checkpoint_position == Vector2(80.0, 296.0), "checkpoint position must survive reload")
		_expect(state.has_collected_clue(&"pkg_0094_clue"), "clue must survive reload")
		_expect(state.decisions.get(&"pkg_0094_decision") == "retain", "decision must survive reload")
		state.set_test_mode(true)
		_expect(state.get_selectable_stations().size() == 43, "enabled test mode must expose all spaces")
		state.set_test_mode(false)
		state.set_pause_menu_visible(true)
		_expect(paused, "pause menu must pause the scene tree")
		state.set_pause_menu_visible(false)
		_expect(not paused, "closing pause menu must resume the scene tree")
		_expect(state.get_next_campaign_station(&"station_01") == &"station_02", "station 01 must lead to station 02")
		_expect(state.get_next_campaign_station(&"station_14") == &"station_15", "station 14 must lead to station 15")
		_expect(state.get_next_campaign_station(&"station_20").is_empty(), "station 20 must not bypass the next authored campaign batch")

	for path in ACT_I_PATHS:
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act I station must load: %s" % path)
		if packed == null:
			continue
		var station := packed.instantiate()
		root.add_child(station)
		await process_frame
		var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
		_expect(stage != null, "Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number >= 6 and stage.station_number <= 10, "Act I stage profile missing: %s" % path)
		_expect(station.get_node_or_null("AtmosphereRig") is AtmosphereRig, "atmosphere rig missing: %s" % path)
		_expect(station.get_node_or_null("CRTDialogueBox") is CRTDialogueBox, "CRT cue surface missing: %s" % path)
		var cue := station.get_node_or_null("OpeningDialogueCue")
		_expect(cue != null and cue.get_script() != null, "checkpoint cue missing: %s" % path)
		_expect(station.get_node_or_null("Geometry/Floor/CollisionShape2D") != null, "floor collision changed: %s" % path)
		station.queue_free()
		await process_frame

	if state:
		state.reset_campaign(true)
	if _failures.is_empty():
		print("PKG-0094 SMOKE PASS: campaign save, menu, Act I Vector-Stage and cues")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0094 FAILURE: " + failure)
		quit(1)