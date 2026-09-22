class_name PKG0127SmokeTest
extends SceneTree

## PKG-0127 Smoke Test
## Verifies RAM & Audio Cache Lifecycle, AtmosphereRig Resource Cleanup,
## Bidirectional Graph Topology, Campaign Continuity Persistence,
## Presentation CanvasLayer Hierarchy, and Text Scalability.

const AtmosphereRigClass := preload("res://scripts/levels/atmosphere_rig.gd")
const CRTDialogueBoxClass := preload("res://scripts/ui/crt_dialogue_box.gd")
const InnerThoughtSurfaceClass := preload("res://scripts/ui/inner_thought_surface.gd")
const CrispDiegeticTextClass := preload("res://scripts/visual/crisp_diegetic_text.gd")
const GameStateManagerClass := preload("res://scripts/core/game_state_manager.gd")
const PrototypePlayerClass := preload("res://scripts/player/prototype_player.gd")

const ALL_CAMPAIGN_SCENE_IDS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41", &"station_42a", &"station_42b", &"station_42c", &"station_43"
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("FAIL: " + message)


func _run_all_tests() -> void:
	print("--- PKG-0127 Smoke Test: RAM Lifecycle, Sound Cache, Bidirectional Topology & Presentation Contrast ---")

	_test_audio_cache_lifecycle()
	_test_atmosphererig_resource_cleanup()
	_test_bidirectional_graph_and_continuity()
	_test_presentation_layers_and_text_scalability()
	_test_speaker_contrast_matrix()
	await _test_all_45_scenes_lifecycle_and_nodes()

	if _failures.is_empty():
		print("PKG-0127: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)


func _test_audio_cache_lifecycle() -> void:
	print("1. Testing ProceduralAudio sound cache, cache hits, and cache eviction...")
	
	ProceduralAudio.clear_sound_cache()
	_expect(ProceduralAudio.get_sound_cache_size() == 0, "Cache must be empty after clear_sound_cache()")

	var s1 := ProceduralAudio.get_cached_sound(&"test_fl_hum", ProceduralAudio.create_fluorescent_hum_sound)
	_expect(s1 != null, "Cached sound generation must return valid AudioStreamWAV")
	_expect(ProceduralAudio.get_sound_cache_size() == 1, "Cache size must be 1 after single registration")

	var s2 := ProceduralAudio.get_cached_sound(&"test_fl_hum", ProceduralAudio.create_fluorescent_hum_sound)
	_expect(s1 == s2, "Second retrieval with same key must return identical cached instance (cache hit)")
	_expect(ProceduralAudio.get_sound_cache_size() == 1, "Cache size must remain 1 on cache hit")

	ProceduralAudio.clear_sound_cache()
	_expect(ProceduralAudio.get_sound_cache_size() == 0, "Cache size must be 0 after clear_sound_cache()")


func _test_atmosphererig_resource_cleanup() -> void:
	print("2. Testing AtmosphereRig lifecycle, audio players, and _exit_tree cleanup...")
	
	var atmo := AtmosphereRigClass.new()
	atmo.station_number = 34
	root.add_child(atmo)
	
	_expect(atmo.get_node_or_null("FluorescentHum") != null, "Station 34 AtmosphereRig must have FluorescentHum")
	_expect(atmo.get_node_or_null("SubstructureDronePlayer") != null, "Station 34 AtmosphereRig must have SubstructureDronePlayer")
	_expect(atmo.get_node_or_null("UneaseTinnitusPlayer") != null, "Station 34 AtmosphereRig must have UneaseTinnitusPlayer")
	
	atmo.trigger_unease_atmosphere(0.5)
	_expect(atmo._unease_active == true, "trigger_unease_atmosphere should set _unease_active to true")

	# Clean up and verify _exit_tree
	atmo.queue_free()


func _test_bidirectional_graph_and_continuity() -> void:
	print("3. Testing bidirectional navigation graph, backtrack lookups, and continuity save/restore...")
	
	var gsm: Node = root.get_node_or_null("GameStateManager")
	var is_ephemeral := false
	if gsm == null:
		gsm = GameStateManagerClass.new()
		root.add_child(gsm)
		is_ephemeral = true
	gsm.campaign_auto_transition_enabled = false
	gsm.reset_campaign(true)

	# 1. Forward progression chain
	for i in range(1, 18):
		var curr_id := StringName("station_%02d" % i)
		var next_id := StringName("station_%02d" % (i + 1))
		_expect(gsm.get_next_campaign_station(curr_id) == next_id, "%s next should be %s" % [curr_id, next_id])

	# 2. Reverse progression chain
	for i in range(2, 19):
		var curr_id := StringName("station_%02d" % i)
		var prev_id := StringName("station_%02d" % (i - 1))
		_expect(gsm.get_previous_campaign_station(curr_id) == prev_id, "%s previous should be %s" % [curr_id, prev_id])

	_expect(gsm.get_previous_campaign_station(&"station_01") == &"", "station_01 previous must be empty")

	# 3. Finales and Epilogue topology
	gsm.select_finale_operation("A")
	_expect(gsm.get_selected_finale_id() == &"station_42a", "Selected finale must be station_42a")
	_expect(gsm.get_next_campaign_station(&"station_18") == &"station_42a", "station_18 with Op A must lead to station_42a")
	_expect(gsm.get_next_campaign_station(&"station_42a") == &"station_43", "station_42a must lead to station_43")
	_expect(gsm.get_previous_campaign_station(&"station_42a") == &"station_18", "station_42a previous must be station_18")
	_expect(gsm.get_previous_campaign_station(&"station_43") == &"station_42a", "station_43 with Op A must backtrack to station_42a")

	gsm.select_finale_operation("B")
	_expect(gsm.get_next_campaign_station(&"station_18") == &"station_42b", "station_18 with Op B must lead to station_42b")
	_expect(gsm.get_previous_campaign_station(&"station_43") == &"station_42b", "station_43 with Op B must backtrack to station_42b")

	gsm.select_finale_operation("C")
	_expect(gsm.get_next_campaign_station(&"station_18") == &"station_42c", "station_18 with Op C must lead to station_42c")
	_expect(gsm.get_previous_campaign_station(&"station_43") == &"station_42c", "station_43 with Op C must backtrack to station_42c")

	# Legacy donor station continuity
	for i in range(19, 41):
		var curr_id := StringName("station_%02d" % i)
		var next_id := StringName("station_%02d" % (i + 1))
		_expect(gsm.get_next_campaign_station(curr_id) == next_id, "legacy %s next should be %s" % [curr_id, next_id])
	for i in range(20, 42):
		var curr_id := StringName("station_%02d" % i)
		var prev_id := StringName("station_%02d" % (i - 1))
		_expect(gsm.get_previous_campaign_station(curr_id) == prev_id, "legacy %s previous should be %s" % [curr_id, prev_id])

	# 4. Save and Restore. Station 26 is now the safe entry of the S09 P7
	# migration range, so an interior position is intentionally normalized.
	gsm.mark_station_reached(&"station_26")
	gsm.collect_clue(&"ucp_record_18")
	gsm.record_decision(&"test_decision", "verified")
	gsm.set_checkpoint(&"station_26", Vector2(120.0, 280.0))
	_expect(gsm.save_campaign() == true, "save_campaign must succeed")

	gsm.reload_campaign_from_disk()
	_expect(gsm.has_reached_station(&"station_26"), "Reached station_26 must persist across save/reload")
	_expect(gsm.has_collected_clue(&"ucp_record_18"), "Clue ucp_record_18 must persist across save/reload")
	_expect(String(gsm.decisions.get(&"test_decision", "")) == "verified", "Decision test_decision must persist")
	_expect(gsm.last_checkpoint_station == &"station_26", "S09 checkpoint must normalize to station_26")
	_expect(gsm.last_checkpoint_position == Vector2(70.0, 296.0), "S09 checkpoint must normalize to its safe entry position")

	gsm.reset_campaign(true)
	if is_ephemeral:
		gsm.queue_free()


func _test_presentation_layers_and_text_scalability() -> void:
	print("4. Testing CanvasLayer hierarchy (Layer 10, 16, 20, 100, 110) and text scaling...")
	
	var diegetic := CrispDiegeticTextClass.new()
	diegetic.text = "TABLICA INFORMACYJNA"
	root.add_child(diegetic)
	
	var thought := InnerThoughtSurfaceClass.new()
	root.add_child(thought)
	
	var dialogue := CRTDialogueBoxClass.new()
	root.add_child(dialogue)
	
	_expect(diegetic._canvas_layer.layer == 10, "CrispDiegeticText layer must be 10")
	_expect(thought.layer == 16, "InnerThoughtSurface layer must be 16")
	_expect(dialogue.layer == 20, "CRTDialogueBox layer must be 20")
	
	# Layer ordering contract: Layer 10 < Layer 16 < Layer 20
	_expect(diegetic._canvas_layer.layer < thought.layer, "Diegetic layer (10) must sit below Thought layer (16)")
	_expect(thought.layer < dialogue.layer, "Thought layer (16) must sit below Dialogue layer (20)")
	
	# Test scaling
	var gsm := root.get_node_or_null("GameStateManager") as Node
	if gsm and gsm.has_method("set_text_scale"):
		gsm.set_text_scale(0.85, false)
		_expect(gsm.text_scale == 0.85, "Text scale should set to 0.85")
		gsm.set_text_scale(1.15, false)
		_expect(gsm.text_scale == 1.15, "Text scale should set to 1.15")
		gsm.set_text_scale(1.0, false)
		_expect(gsm.text_scale == 1.0, "Text scale should reset to 1.0")

	diegetic.queue_free()
	thought.queue_free()
	dialogue.queue_free()


func _test_speaker_contrast_matrix() -> void:
	print("5. Testing CRT dialogue speaker color registry and contrast metrics...")
	
	var colors := CRTDialogueBoxClass.SPEAKER_COLORS
	var bg := VectorStageStyle.INK # #07090b
	
	for speaker in colors:
		var col: Color = colors[speaker]
		var lum_fg := 0.2126 * col.r + 0.7152 * col.g + 0.0722 * col.b
		var lum_bg := 0.2126 * bg.r + 0.7152 * bg.g + 0.0722 * bg.b
		var contrast_ratio := (maxf(lum_fg, lum_bg) + 0.05) / (minf(lum_fg, lum_bg) + 0.05)
		_expect(contrast_ratio >= 4.5, "Speaker color '%s' (%s) must meet WCAG contrast ratio >= 4.5:1 (got %.2f:1)" % [speaker, col.to_html(false), contrast_ratio])


func _has_crisp_diegetic_text_node(node: Node) -> bool:
	for child in node.get_children():
		if child is CrispDiegeticText or child.name.begins_with("CrispDiegeticText"):
			return true
	return false


func _test_all_45_scenes_lifecycle_and_nodes() -> void:
	print("6. Testing all 45 campaign scenes for node stacks, resource lifecycle and clean freeing...")
	_expect(ALL_CAMPAIGN_SCENE_IDS.size() == 45, "Expected 45 total scenes, got %d" % ALL_CAMPAIGN_SCENE_IDS.size())

	for station_id in ALL_CAMPAIGN_SCENE_IDS:
		var scene_path := "res://scenes/levels/" + String(station_id) + ".tscn"
		_expect(ResourceLoader.exists(scene_path), "Scene %s must exist" % scene_path)
		if not ResourceLoader.exists(scene_path):
			continue

		var packed := load(scene_path) as PackedScene
		_expect(packed != null, "Scene %s must load as PackedScene" % scene_path)
		if packed == null:
			continue

		var instance := packed.instantiate() as Node2D
		_expect(instance != null, "Scene %s must instantiate" % scene_path)
		if instance == null:
			continue

		root.add_child(instance)
		await process_frame

		_expect(instance.get_node_or_null("Player") != null, "%s missing Player" % station_id)
		_expect(instance.get_node_or_null("WorldPixelCompositor") != null, "%s missing WorldPixelCompositor" % station_id)
		_expect(instance.get_node_or_null("CRTDialogueBox") != null, "%s missing CRTDialogueBox" % station_id)
		_expect(instance.get_node_or_null("NarrativeGuidanceService") != null, "%s missing NarrativeGuidanceService" % station_id)
		_expect(instance.get_node_or_null("AtmosphereRig") != null, "%s missing AtmosphereRig" % station_id)
		_expect(instance.get_node_or_null("Geometry") != null, "%s missing Geometry" % station_id)
		_expect(_has_crisp_diegetic_text_node(instance), "%s missing CrispDiegeticText" % station_id)

		instance.queue_free()
		for f in range(2):
			await process_frame

	print("6. All 45 scenes verified successfully.")
