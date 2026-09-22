extends SceneTree

const STATION_PATHS := [
	"res://scenes/levels/station_01.tscn",
	"res://scenes/levels/station_02.tscn",
	"res://scenes/levels/station_03.tscn",
	"res://scenes/levels/station_04.tscn",
	"res://scenes/levels/station_05.tscn",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0091: " + message)


func _run() -> void:
	_expect(ProjectSettings.has_setting("autoload/GameStateManager"), "GameStateManager autoload is missing")
	var game_state := root.get_node_or_null("GameStateManager")
	_expect(game_state != null, "GameStateManager autoload did not instantiate")
	if game_state:
		game_state.set_checkpoint(&"station_01", Vector2(60.0, 296.0))
		game_state.collect_clue(&"pkg_0091_clue")
		game_state.record_decision(&"pkg_0091_decision", "confirm")
		_expect(game_state.has_reached_station(&"station_01"), "checkpoint does not record a reached station")
		_expect(game_state.collected_clues.has(&"pkg_0091_clue"), "clue collection is not recorded")
		_expect(game_state.decisions.get(&"pkg_0091_decision") == "confirm", "decision is not recorded")
		var selectable_stations: Array[StringName] = game_state.get_selectable_stations()
		_expect(selectable_stations.size() == 43, "level selection does not expose all 43 stations (%d)" % selectable_stations.size())

	var player_scene := load("res://scenes/player/prototype_player.tscn") as PackedScene
	_expect(player_scene != null, "prototype player scene does not load")
	if player_scene:
		var player := player_scene.instantiate() as PrototypePlayer
		root.add_child(player)
		await process_frame
		_expect(player.get_node_or_null("RunDust") is CPUParticles2D, "player run dust emitter is missing")
		_expect(player.get_node_or_null("LandingDust") is CPUParticles2D, "player landing dust emitter is missing")
		player.queue_free()
		await process_frame

	for path in STATION_PATHS:
		var packed := load(path) as PackedScene
		_expect(packed != null, "station does not load: %s" % path)
		if packed == null:
			continue
		var station := packed.instantiate()
		root.add_child(station)
		await process_frame
		_expect(station.get_node_or_null("AtmosphereRig") is AtmosphereRig, "atmosphere rig is missing: %s" % path)
		_expect(station.get_node_or_null("CRTDialogueBox") is CRTDialogueBox, "CRT dialogue is missing: %s" % path)
		var cue := station.get_node_or_null("OpeningDialogueCue")
		_expect(cue != null and cue.get_script() != null, "opening dialogue cue is missing: %s" % path)
		var rig := station.get_node_or_null("AtmosphereRig") as AtmosphereRig
		if rig:
			var fluorescent := rig.get_node_or_null("FluorescentLight") as PointLight2D
			_expect(fluorescent != null and fluorescent.texture != null, "gradient fluorescent light is missing: %s" % path)
			_expect(rig.get_node_or_null("VolumetricDust") is CPUParticles2D, "air dust particles are missing: %s" % path)
		station.queue_free()
		await process_frame

	if _failures.is_empty():
		print("PKG-0091 SMOKE PASS: player feel, atmosphere, CRT dialogue and game state")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0091 FAILURE: " + failure)
		print("PKG-0091 SMOKE FAIL: %d check(s) failed" % _failures.size())
		quit(1)