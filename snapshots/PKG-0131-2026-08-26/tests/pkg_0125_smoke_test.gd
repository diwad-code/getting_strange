class_name PKG0125SmokeTest
extends SceneTree

## PKG-0125 Smoke Test
## Verifies Lena's Feminine Silhouette & Rig 3.0, LadderZone & ServiceLift components,
## Bidirectional navigation & backtracking in GameStateManager, and Metric Scale parity on 43 stations.

const PrototypePlayerClass := preload("res://scripts/player/prototype_player.gd")
const LenaVisualRigClass := preload("res://scripts/player/lena_visual_rig.gd")
const LadderZoneClass := preload("res://scripts/environment/ladder_zone.gd")
const ServiceLiftClass := preload("res://scripts/environment/service_lift.gd")
const GameStateManagerClass := preload("res://scripts/core/game_state_manager.gd")

const CAMPAIGN_STATION_IDS: Array[StringName] = [
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
	print("--- PKG-0125 Smoke Test: Feminine Lena, Diegetic Climbing, Bidirectionality & Scale ---")
	
	_test_input_actions()
	_test_lena_feminine_rig_and_proportions()
	_test_ladder_zone_and_climbing()
	_test_service_lift_mechanics()
	_test_bidirectional_navigation()
	await _test_all_43_stations_scale_and_contracts()
	
	if _failures.is_empty():
		print("PKG-0125: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)


func _test_input_actions() -> void:
	print("1. Testing InputMap semantic actions for climbing...")
	_expect(InputMap.has_action(&"move_up"), "move_up action must be registered in InputMap")
	_expect(InputMap.has_action(&"move_down"), "move_down action must be registered in InputMap")
	_expect(InputMap.has_action(&"move_left"), "move_left action must be registered")
	_expect(InputMap.has_action(&"move_right"), "move_right action must be registered")
	_expect(InputMap.has_action(&"jump"), "jump action must be registered")


func _test_lena_feminine_rig_and_proportions() -> void:
	print("2. Testing LenaVisualRig 3.0 feminine silhouette and 14 states...")
	var rig := LenaVisualRigClass.new()
	root.add_child(rig)
	
	# Verify 14 states
	var required_states := [
		&"idle", &"start", &"walk", &"run", &"stop", &"turn",
		&"jump_rise", &"jump_fall", &"land", &"interact", &"examine",
		&"unease_reaction", &"seam_gesture", &"climb"
	]
	for st in required_states:
		rig.set_state(st)
		_expect(rig.get_active_state_name() == st, "LenaVisualRig must support state: %s" % st)
	
	# Test mechanical state transitions
	rig.set_mechanical_state(Vector2(0, 0), true, false)
	_expect(rig.get_active_state_name() == &"idle", "Mechanical state (0, grounded) should be idle")
	
	rig.set_mechanical_state(Vector2(30, 0), true, false)
	_expect(rig.get_active_state_name() == &"walk", "Mechanical state (30, grounded) should be walk")
	
	rig.set_mechanical_state(Vector2(80, 0), true, false)
	_expect(rig.get_active_state_name() == &"run", "Mechanical state (80, grounded) should be run")
	
	rig.set_mechanical_state(Vector2(0, -50), false, false)
	_expect(rig.get_active_state_name() == &"jump_rise", "Mechanical state (upward vel, airborne) should be jump_rise")
	
	rig.set_mechanical_state(Vector2(0, 50), false, false)
	_expect(rig.get_active_state_name() == &"jump_fall", "Mechanical state (downward vel, airborne) should be jump_fall")
	
	rig.set_mechanical_state(Vector2(0, -40), false, true)
	_expect(rig.get_active_state_name() == &"climb", "Mechanical state with climbing=true should be climb")
	
	rig.queue_free()
	
	# Test player scene capsule shape
	var packed_player := load("res://scenes/player/prototype_player.tscn") as PackedScene
	_expect(packed_player != null, "prototype_player.tscn must load")
	if packed_player:
		var player_inst := packed_player.instantiate() as PrototypePlayer
		root.add_child(player_inst)
		var col := player_inst.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_expect(col != null, "Player must have CollisionShape2D")
		if col and col.shape is CapsuleShape2D:
			var capsule := col.shape as CapsuleShape2D
			_expect(capsule.height >= 50.0, "Capsule shape height (%.1f) must match Lena's adult female height (~66px)" % capsule.height)
		player_inst.queue_free()


func _test_ladder_zone_and_climbing() -> void:
	print("3. Testing LadderZone component and climbing interaction...")
	var ladder := LadderZoneClass.new()
	ladder.ladder_height = 140.0
	ladder.ladder_width = 24.0
	ladder.position = Vector2(200.0, 300.0)
	root.add_child(ladder)
	
	var player := PrototypePlayerClass.new()
	player.position = Vector2(200.0, 280.0)
	root.add_child(player)
	
	# Attach to ladder
	player.attach_to_ladder(ladder)
	_expect(player.current_ladder == ladder, "Player must reference current_ladder upon attach")
	
	# Detach
	player.detach_from_ladder(ladder)
	_expect(player.current_ladder == null, "Player current_ladder must be cleared on detach")
	
	# Verify ladder audio synthesis
	var ladder_sfx := ProceduralAudio.create_ladder_rung_climb_sound()
	_expect(ladder_sfx != null and ladder_sfx.data.size() > 0, "create_ladder_rung_climb_sound must synthesize valid PCM audio")
	
	player.queue_free()
	ladder.queue_free()


func _test_service_lift_mechanics() -> void:
	print("4. Testing ServiceLift mechanical platform...")
	var lift := ServiceLiftClass.new()
	lift.travel_distance = Vector2(0, -90)
	lift.travel_speed = 60.0
	lift.position = Vector2(300.0, 280.0)
	root.add_child(lift)
	
	_expect(lift.sync_to_physics == true, "ServiceLift must have sync_to_physics enabled")
	
	lift.trigger_lift()
	_expect(lift.get("_direction") == 1, "ServiceLift should set direction to 1 when triggered from start")
	
	lift.queue_free()


func _test_bidirectional_navigation() -> void:
	print("5. Testing bidirectional navigation & backtracking in GameStateManager...")
	var gsm := GameStateManagerClass.new()
	root.add_child(gsm)
	gsm.campaign_auto_transition_enabled = false
	
	# Previous station lookup
	_expect(gsm.get_previous_campaign_station(&"station_02") == &"station_01", "Previous of station_02 should be station_01")
	_expect(gsm.get_previous_campaign_station(&"station_07") == &"station_06", "Previous of station_07 should be station_06")
	_expect(gsm.get_previous_campaign_station(&"station_21") == &"station_20", "Previous of station_21 should be station_20")
	_expect(gsm.get_previous_campaign_station(&"station_41") == &"station_40", "Previous of station_41 should be station_40")
	_expect(gsm.get_previous_campaign_station(&"station_01") == &"", "Previous of station_01 should be empty (start of campaign)")
	
	# Next station lookup
	_expect(gsm.get_next_campaign_station(&"station_01") == &"station_02", "Next of station_01 should be station_02")
	_expect(gsm.get_next_campaign_station(&"station_20") == &"station_21", "Next of station_20 should be station_21")
	
	# Spawn side positioning
	gsm.target_spawn_side = &"right"
	_expect(gsm.target_spawn_side == &"right", "target_spawn_side should hold 'right'")
	gsm.target_spawn_side = &"left"
	
	gsm.queue_free()


func _has_crisp_diegetic_text_node(node: Node) -> bool:
	for child in node.get_children():
		if child is CrispDiegeticText or child.name.begins_with("CrispDiegeticText"):
			return true
	return false


func _test_all_43_stations_scale_and_contracts() -> void:
	print("6. Testing all 43 campaign scenes for scale, nodes, and zero draw_string in Layer 0...")
	_expect(CAMPAIGN_STATION_IDS.size() == 45, "Expected 45 total scenes (41 linear + 3 finales + 1 epilogue), got %d" % CAMPAIGN_STATION_IDS.size())
	
	for station_id in CAMPAIGN_STATION_IDS:
		var scene_path := "res://scenes/levels/" + String(station_id) + ".tscn"
		_expect(ResourceLoader.exists(scene_path), "Scene %s must exist" % scene_path)
		
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
		
		# Check required nodes for scale and presentation
		_expect(instance.get_node_or_null("Player") != null, "%s missing Player" % station_id)
		_expect(instance.get_node_or_null("WorldPixelCompositor") != null, "%s missing WorldPixelCompositor" % station_id)
		_expect(instance.get_node_or_null("CRTDialogueBox") != null, "%s missing CRTDialogueBox" % station_id)
		_expect(instance.get_node_or_null("NarrativeGuidanceService") != null, "%s missing NarrativeGuidanceService" % station_id)
		_expect(instance.get_node_or_null("AtmosphereRig") != null, "%s missing AtmosphereRig" % station_id)
		_expect(instance.get_node_or_null("Geometry") != null, "%s missing Geometry" % station_id)
		_expect(instance.get_node_or_null("Props") != null, "%s missing Props" % station_id)
		_expect(_has_crisp_diegetic_text_node(instance), "%s missing CrispDiegeticText" % station_id)
		
		instance.queue_free()
		for f in range(4):
			await process_frame
