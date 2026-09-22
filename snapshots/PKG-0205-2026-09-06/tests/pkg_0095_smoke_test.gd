extends SceneTree

const ACT_II_PATHS := [
	"res://scenes/levels/station_11.tscn",
	"res://scenes/levels/station_12.tscn",
	"res://scenes/levels/station_13.tscn",
	"res://scenes/levels/station_14.tscn",
	"res://scenes/levels/station_15.tscn",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0095: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		state.reset_campaign(true)
		state.complete_station(&"station_10", false)
		_expect(state.has_reached_station(&"station_11"), "completing station 10 must unlock station 11")
		state.complete_station(&"station_11", false)
		state.complete_station(&"station_12", false)
		state.complete_station(&"station_13", false)
		state.complete_station(&"station_14", false)
		_expect(state.has_reached_station(&"station_15"), "completing station 14 must unlock station 15")
		state.complete_station(&"station_15", false)
		_expect(state.has_reached_station(&"station_16"), "station 15 must unlock station 16 in the production route")
		_expect(
			ResourceLoader.exists("res://scenes/levels/station_" + String(state.get_next_campaign_station(&"station_10")).trim_prefix("station_") + ".tscn"),
			"campaign station identifier must resolve to a real scene path"
		)
		state.campaign_auto_transition_enabled = false

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
		_expect(stage != null, "Act II Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number == expected_number, "Act II station profile mismatch: %s" % path)
		_expect(station.get_node_or_null("AtmosphereRig") is AtmosphereRig, "Act II atmosphere rig missing: %s" % path)
		_expect(station.get_node_or_null("CRTDialogueBox") is CRTDialogueBox, "Act II CRT surface missing: %s" % path)
		var cue := station.get_node_or_null("OpeningDialogueCue")
		_expect(cue != null and cue.get_script() != null, "Act II checkpoint cue missing: %s" % path)
		_expect(station.get_node_or_null("Geometry") != null, "Act II geometry root missing: %s" % path)
		_expect(station.has_signal(&"level_completed"), "Act II level completion signal missing: %s" % path)
		if expected_number == 11 and state:
			station.level_completed.emit()
			await process_frame
			_expect(state.has_reached_station(&"station_12"), "Station 11 completion signal must unlock station 12")
		station.queue_free()
		await process_frame

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	if _failures.is_empty():
		print("PKG-0095 SMOKE PASS: Act II Vector-Stage and campaign unlock chain")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0095 FAILURE: " + failure)
		quit(1)
