class_name PKG0123SmokeTest
extends SceneTree

const SCENE_PATHS: Array[String] = [
	"res://scenes/levels/station_38.tscn",
	"res://scenes/levels/station_39.tscn",
	"res://scenes/levels/station_40.tscn",
	"res://scenes/levels/station_41.tscn",
	"res://scenes/levels/station_42a.tscn",
	"res://scenes/levels/station_42b.tscn",
	"res://scenes/levels/station_42c.tscn",
	"res://scenes/levels/station_43.tscn"
]

const SCRIPT_PATHS: Array[String] = [
	"res://scripts/levels/station_38.gd",
	"res://scripts/levels/station_39.gd",
	"res://scripts/levels/station_40.gd",
	"res://scripts/levels/station_41.gd",
	"res://scripts/levels/station_42a.gd",
	"res://scripts/levels/station_42b.gd",
	"res://scripts/levels/station_42c.gd",
	"res://scripts/levels/station_43.gd"
]

var _failures: Array[String] = []


func _init() -> void:
	call_deferred(&"_run_tests")


func _run_tests() -> void:
	print("--- PKG-0123 Smoke Test: Sequence X & Content Lock 3.0 ---")
	
	_test_script_lint_and_draw_contracts()
	await _test_scene_node_stacks()
	await _test_interaction_flows()
	await _test_campaign_branching_and_completion()
	
	if _failures.is_empty():
		print("PKG-0123: ALL TESTS PASSED.")
		quit(0)
	else:
		printerr("PKG-0123: FAILURES ENCOUNTERED:")
		for failure in _failures:
			printerr(" - ", failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("FAIL: ", message)


func _test_script_lint_and_draw_contracts() -> void:
	print("Testing script contracts, obstacle lint, and zero draw_string in Layer 0...")
	for path in SCRIPT_PATHS:
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Script file must open: %s" % path)
		if file == null:
			continue
		var content := file.get_as_text()
		
		# Prohibit draw_string in layer 0
		_expect(not content.contains("draw_string("), "%s contains prohibited draw_string in Layer 0" % path)
		
		# Obstacle lint checks
		_expect(content.contains("## PRZESZKODA — dlaczego to tu jest:"), "%s missing question 1" % path)
		_expect(content.contains("## PRZESZKODA — czego wymaga od Leny:"), "%s missing question 2" % path)
		_expect(content.contains("## PRZESZKODA — koszt porażki:"), "%s missing question 3" % path)
		
		# D-099 no player word in header
		var lines := content.split("\n")
		for line in lines:
			if line.begins_with("## PRZESZKODA —"):
				_expect(not line.to_lower().contains("gracz"), "%s obstacle header contains forbidden word 'gracz': %s" % [path, line])


func _test_scene_node_stacks() -> void:
	print("Testing scene node stacks for Pixel-Stage architecture...")
	for path in SCENE_PATHS:
		var packed := load(path) as PackedScene
		_expect(packed != null, "Scene must load: %s" % path)
		if packed == null:
			continue
		var instance := packed.instantiate() as Node2D
		root.add_child(instance)
		await process_frame
		
		_expect(instance.get_node_or_null("WorldPixelCompositor") != null, "%s missing WorldPixelCompositor" % path)
		_expect(instance.get_node_or_null("CrispDiegeticText") != null, "%s missing CrispDiegeticText" % path)
		_expect(instance.get_node_or_null("InnerThoughtSurface") != null, "%s missing InnerThoughtSurface" % path)
		_expect(instance.get_node_or_null("CRTDialogueBox") != null, "%s missing CRTDialogueBox" % path)
		_expect(instance.get_node_or_null("NarrativeGuidanceService") != null, "%s missing NarrativeGuidanceService" % path)
		_expect(instance.get_node_or_null("AtmosphereRig") != null, "%s missing AtmosphereRig" % path)
		_expect(instance.get_node_or_null("VectorStageEnvironment") != null, "%s missing VectorStageEnvironment" % path)
		_expect(instance.get_node_or_null("OpeningDialogueCue") != null, "%s missing OpeningDialogueCue" % path)
		_expect(instance.get_node_or_null("Geometry") != null, "%s missing Geometry" % path)
		_expect(instance.get_node_or_null("Props") != null, "%s missing Props" % path)
		_expect(instance.get_node_or_null("Player") != null, "%s missing Player" % path)
		_expect(instance.get_node_or_null("Camera2D") != null, "%s missing Camera2D" % path)
		_expect(instance.get_node_or_null("AirlockZone") != null, "%s missing AirlockZone" % path)
		
		instance.queue_free()
		await process_frame


func _test_interaction_flows() -> void:
	print("Testing interactive flows across Stations 38-43...")
	
	# Station 38
	var s38_packed := load("res://scenes/levels/station_38.tscn") as PackedScene
	var s38 := s38_packed.instantiate() as Station38
	root.add_child(s38)
	await process_frame
	_expect(s38.dialogue_lines.size() == 11, "Station 38 dialogue count must be 11")
	s38.advance_dialogue()
	s38.advance_dialogue()
	s38.advance_dialogue()
	s38.advance_dialogue()
	s38.advance_dialogue()
	s38.advance_dialogue()
	s38.advance_dialogue()
	s38.advance_dialogue()
	s38.advance_dialogue()
	_expect(s38.is_exit_unlocked, "Station 38 exit must unlock after dialogue")
	s38.queue_free()
	await process_frame
	
	# Station 39
	var s39_packed := load("res://scenes/levels/station_39.tscn") as PackedScene
	var s39 := s39_packed.instantiate() as Station39
	root.add_child(s39)
	await process_frame
	_expect(s39.dialogue_lines.size() == 11, "Station 39 dialogue count must be 11")
	for i in range(10):
		s39.advance_dialogue()
	_expect(s39.is_exit_unlocked, "Station 39 exit must unlock after dialogue")
	s39.queue_free()
	await process_frame
	
	# Station 40
	var s40_packed := load("res://scenes/levels/station_40.tscn") as PackedScene
	var s40 := s40_packed.instantiate() as Station40
	root.add_child(s40)
	await process_frame
	_expect(s40.dialogue_lines.size() == 13, "Station 40 dialogue count must be 13")
	for i in range(12):
		s40.advance_dialogue()
	_expect(s40.is_exit_unlocked, "Station 40 exit must unlock after dialogue")
	s40.queue_free()
	await process_frame
	
	# Station 41
	var s41_packed := load("res://scenes/levels/station_41.tscn") as PackedScene
	var s41 := s41_packed.instantiate() as Station41
	root.add_child(s41)
	await process_frame
	_expect(s41.chosen_operation == "", "Station 41 chosen_operation starts empty")
	s41.select_operation("A")
	_expect(s41.chosen_operation == "A", "Station 41 selected operation A")
	_expect(s41.is_exit_unlocked, "Station 41 exit unlocked after selecting A")
	s41.queue_free()
	await process_frame


func _test_campaign_branching_and_completion() -> void:
	print("Testing full campaign branching and completion logic...")
	var state := root.get_node_or_null("GameStateManager") as GameStateManager
	_expect(state != null, "GameStateManager autoload must be present")
	if state == null:
		return
	
	# Test Branch A
	state.reset_campaign(true)
	state.complete_station(&"station_37", false)
	_expect(state.get_next_campaign_station(&"station_37") == &"station_38", "Station 37 leads to 38")
	state.complete_station(&"station_38", false)
	_expect(state.get_next_campaign_station(&"station_38") == &"station_39", "Station 38 leads to 39")
	state.complete_station(&"station_39", false)
	_expect(state.get_next_campaign_station(&"station_39") == &"station_40", "Station 39 leads to 40")
	state.complete_station(&"station_40", false)
	_expect(state.get_next_campaign_station(&"station_40") == &"station_41", "Station 40 leads to 41")
	
	state.select_finale_operation("A")
	state.complete_station(&"station_41", false)
	_expect(state.get_next_campaign_station(&"station_41") == &"station_42a", "Station 41 with A leads to 42a")
	state.complete_station(&"station_42a", false)
	_expect(state.get_next_campaign_station(&"station_42a") == &"station_43", "Station 42a leads to 43")
	state.complete_station(&"station_43", false)
	_expect(state.is_campaign_completed(), "Campaign must be marked completed after Station 43")
	
	# Test Branch B
	state.reset_campaign(true)
	state.select_finale_operation("B")
	state.complete_station(&"station_40", false)
	state.complete_station(&"station_41", false)
	_expect(state.get_next_campaign_station(&"station_41") == &"station_42b", "Station 41 with B leads to 42b")
	state.complete_station(&"station_42b", false)
	_expect(state.get_next_campaign_station(&"station_42b") == &"station_43", "Station 42b leads to 43")
	state.complete_station(&"station_43", false)
	_expect(state.is_campaign_completed(), "Campaign completed on Branch B")
	
	# Test Branch C
	state.reset_campaign(true)
	state.select_finale_operation("C")
	state.complete_station(&"station_40", false)
	state.complete_station(&"station_41", false)
	_expect(state.get_next_campaign_station(&"station_41") == &"station_42c", "Station 41 with C leads to 42c")
	state.complete_station(&"station_42c", false)
	_expect(state.get_next_campaign_station(&"station_42c") == &"station_43", "Station 42c leads to 43")
	state.complete_station(&"station_43", false)
	_expect(state.is_campaign_completed(), "Campaign completed on Branch C")
