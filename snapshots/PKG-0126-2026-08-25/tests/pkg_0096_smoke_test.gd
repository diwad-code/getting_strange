extends SceneTree

const ACT_IIB_PATHS := [
	"res://scenes/levels/station_16.tscn",
	"res://scenes/levels/station_17.tscn",
	"res://scenes/levels/station_18.tscn",
	"res://scenes/levels/station_19.tscn",
	"res://scenes/levels/station_20.tscn",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0096: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		state.reset_campaign(true)
		state.complete_station(&"station_15", false)
		_expect(state.has_reached_station(&"station_16"), "completing station 15 must unlock station 16")
		state.complete_station(&"station_16", false)
		_expect(state.has_reached_station(&"station_17"), "completing station 16 must unlock station 17")
		state.complete_station(&"station_17", false)
		_expect(state.has_reached_station(&"station_18"), "completing station 17 must unlock station 18")
		state.complete_station(&"station_18", false)
		_expect(state.has_reached_station(&"station_19"), "completing station 18 must unlock station 19")
		state.complete_station(&"station_19", false)
		_expect(state.has_reached_station(&"station_20"), "completing station 19 must unlock station 20")
		state.complete_station(&"station_20", false)
		_expect(state.has_reached_station(&"station_21"), "completing station 20 must unlock station 21")
		_expect(
			ResourceLoader.exists("res://scenes/levels/station_" + String(state.get_next_campaign_station(&"station_16")).trim_prefix("station_") + ".tscn"),
			"campaign station identifier must resolve to a real scene path"
		)
		state.campaign_auto_transition_enabled = false

	for expected_number in range(16, 21):
		var path: String = ACT_IIB_PATHS[expected_number - 16]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act IIb station must load: %s" % path)
		if packed == null:
			continue
		var station := packed.instantiate()
		root.add_child(station)
		await process_frame
		var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
		_expect(stage != null, "Act IIb Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number == expected_number, "Act IIb station profile mismatch: %s" % path)
		_expect(station.get_node_or_null("AtmosphereRig") is AtmosphereRig, "Act IIb atmosphere rig missing: %s" % path)
		_expect(station.get_node_or_null("CRTDialogueBox") is CRTDialogueBox, "Act IIb CRT surface missing: %s" % path)
		var cue := station.get_node_or_null("OpeningDialogueCue")
		_expect(cue != null and cue.get_script() != null, "Act IIb checkpoint cue missing: %s" % path)
		_expect(station.get_node_or_null("Geometry") != null, "Act IIb geometry root missing: %s" % path)
		_expect(station.has_signal(&"level_completed"), "Act IIb level completion signal missing: %s" % path)
		if expected_number == 16 and state:
			station.level_completed.emit()
			await process_frame
			_expect(state.has_reached_station(&"station_17"), "Station 16 completion signal must unlock station 17")
		station.queue_free()
		await process_frame

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)
	if _failures.is_empty():
		print("PKG-0096 SMOKE PASS: Act IIb Vector-Stage and campaign unlock chain 16..20")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0096 FAILURE: " + failure)
		quit(1)
