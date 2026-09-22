extends SceneTree

## PKG-0100 gate: Act I visual state pass and one diegetic obstacle per Station 06..10.
##
## This gate proves technical contracts only (D-012, ADR-003). It does not and
## cannot prove that the spaces are fun, emotionally effective, or comprehensible
## to an external person.

const ACT_I_PATHS := [
	"res://scenes/levels/station_01.tscn",
	"res://scenes/levels/station_02.tscn",
	"res://scenes/levels/station_03.tscn",
	"res://scenes/levels/station_04.tscn",
	"res://scenes/levels/station_05.tscn",
	"res://scenes/levels/station_06.tscn",
	"res://scenes/levels/station_07.tscn",
	"res://scenes/levels/station_08.tscn",
	"res://scenes/levels/station_09.tscn",
	"res://scenes/levels/station_10.tscn",
]

## These are the authored floor names in the ten shipped scenes. The test
## records them explicitly so a visibility pass cannot silently rename a route.
const REQUIRED_FLOORS := {
	"res://scenes/levels/station_01.tscn": ["Floor"],
	"res://scenes/levels/station_02.tscn": ["Floor"],
	"res://scenes/levels/station_03.tscn": ["Floor"],
	"res://scenes/levels/station_04.tscn": ["Floor"],
	"res://scenes/levels/station_05.tscn": ["Floor"],
	"res://scenes/levels/station_06.tscn": ["Floor"],
	"res://scenes/levels/station_07.tscn": ["Floor"],
	"res://scenes/levels/station_08.tscn": ["Floor"],
	"res://scenes/levels/station_09.tscn": ["Floor"],
	"res://scenes/levels/station_10.tscn": ["Floor"],
}

const REQUIRED_SHELLS := {
	"res://scenes/levels/station_01.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_02.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_03.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_04.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_05.tscn": ["WallLeft", "WallRight"],
	"res://scenes/levels/station_06.tscn": ["WallLeft", "WallRight"],
	"res://scenes/levels/station_07.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_08.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_09.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_10.tscn": ["WallLeft", "WallRight", "Ceiling"],
}

const OBSTACLE_PATHS := {
	6: "Geometry/ReplacementBusExitDoor",
	7: "Props/ShopCounter",
	8: "Geometry/BuildingEntranceDoor",
	9: "Geometry/StairwellPlanter",
	10: "Geometry/ApartmentDoor14",
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0100: " + message)


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
		state.reset_campaign(true)

	await _check_stations(state)
	_check_three_question_headers()
	_check_campaign_chain(state)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	if _failures.is_empty():
		print("PKG-0100 SMOKE PASS: Act I Vector-Stage state pass, obstacles and chain 01..10")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0100 FAILURE: " + failure)
		quit(1)


func _check_stations(state: Node) -> void:
	for expected_number in range(1, 11):
		var path: String = ACT_I_PATHS[expected_number - 1]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act I station must load: %s" % path)
		if packed == null:
			continue

		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame

		var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
		_expect(stage != null, "Vector-Stage environment missing: %s" % path)
		if stage:
			_expect(stage.station_number == expected_number, "Vector-Stage profile mismatch: %s" % path)
			_expect(stage.z_index < 0, "Vector-Stage layer must stay behind level content: %s" % path)

		var geometry := station.get_node_or_null("Geometry")
		_expect(geometry != null, "geometry root missing: %s" % path)
		if geometry:
			for floor_name in REQUIRED_FLOORS.get(path, []):
				_expect(
					geometry.get_node_or_null(floor_name) is StaticBody2D,
					"authored floor %s is missing: %s" % [floor_name, path]
				)
			for shell_name in REQUIRED_SHELLS.get(path, []):
				var shell := geometry.get_node_or_null(shell_name) as StaticBody2D
				_expect(shell != null, "shell collider %s is missing: %s" % [shell_name, path])
				if shell:
					_expect(shell.get_node_or_null("CollisionShape2D") != null, "shell collider lost its shape: %s" % path)

		var props := station.get_node_or_null("Props")
		_expect(props != null, "props root missing: %s" % path)
		if props:
			for prop in props.get_children():
				if prop is MemoryResonancePoint:
					_expect(prop.interaction_radius > 0.0, "prop interaction radius must stay positive: %s" % path)

		_expect(station.get_node_or_null("AirlockZone") is Area2D, "airlock zone missing: %s" % path)
		_expect(station.get_node_or_null("Player") is PrototypePlayer, "player instance missing: %s" % path)
		_expect(station.has_signal(&"level_completed"), "level completion signal missing: %s" % path)
		_check_state_pass_source(path)

		if expected_number >= 6:
			await _check_obstacle(expected_number, station, state)

		station.queue_free()
		await process_frame


func _check_state_pass_source(path: String) -> void:
	var station_number := int(path.get_file().trim_suffix(".tscn").trim_prefix("station_"))
	var script_path := "res://scripts/levels/station_%02d.gd" % station_number
	var file := FileAccess.open(script_path, FileAccess.READ)
	_expect(file != null, "station script must be readable: %s" % script_path)
	if file == null:
		return
	var source := file.get_as_text()
	file.close()
	var draw_start := source.find("func _draw() -> void:")
	var state_start := source.find("func _draw_state_layer() -> void:")
	_expect(draw_start >= 0 and state_start > draw_start, "station script must expose a state pass: %s" % script_path)
	if draw_start < 0 or state_start < 0:
		return
	var state_body := source.substr(state_start)
	var play_call := state_body.find("VectorStageStyle.draw_play_plane")
	var first_variable := state_body.find("\n\tvar ")
	_expect(play_call >= 0, "state pass must derive the route from Geometry: %s" % script_path)
	_expect(first_variable < 0 or play_call < first_variable, "play plane must be first in state pass: %s" % script_path)
	var draw_body := source.substr(draw_start, state_start - draw_start)
	for forbidden_call in [
		"draw_stage_background",
		"_draw_architecture()",
		"_draw_apartment_environment()",
		"_draw_bathroom_environment()",
		"_draw_study_room()",
	]:
		_expect(not draw_body.contains(forbidden_call), "opaque legacy draw remains in %s" % script_path)


func _check_obstacle(expected_number: int, station: Node2D, state: Node) -> void:
	var obstacle_path: String = OBSTACLE_PATHS[expected_number]
	var obstacle := station.get_node_or_null(obstacle_path)
	_expect(obstacle != null, "diegetic obstacle missing in Station %d" % expected_number)
	if obstacle == null:
		return

	match expected_number:
		6:
			var bus_door := obstacle as AnimatableBody2D
			_expect(bus_door != null, "Station 06 exit door must be AnimatableBody2D")
			var station_06 := station as Station06
			if station_06:
				station_06.open_bus_doors()
				for _frame in range(5):
					await physics_frame
				_expect(station_06.are_doors_open, "Station 06 doors must open")
		7:
			var counter := obstacle as MemoryResonancePoint
			_expect(counter != null, "Station 07 shop counter must be MemoryResonancePoint")
			var station_07 := station as Station07
			if station_07:
				station_07.start_shopkeeper_dialogue()
				_expect(station_07.shopkeeper_dialogue_active, "Station 07 shop dialogue must be active")
				station_07.purchase_water()
				_expect(station_07.is_water_purchased, "Station 07 water must be purchased")
		8:
			var entrance := obstacle as AnimatableBody2D
			_expect(entrance != null, "Station 08 building door must be AnimatableBody2D")
			var station_08 := station as Station08
			if entrance and station_08:
				var closed_y := entrance.position.y
				station_08.apply_entry_setback()
				await process_frame
				_expect(station_08.entry_attempt_count > 0, "Station 08 setback must count a lost attempt")
				_expect(not station_08.is_door_open, "Station 08 door must stay shut before verification")
				station_08.read_certificate()
				station_08.read_directory()
				station_08.use_keypad()
				_expect(station_08.is_entry_verified, "Station 08 must verify on three readings")
				for _frame in range(20):
					await process_frame
				_expect(entrance.position.y < closed_y, "Station 08 door must leave its closed mounting")
		9:
			var planter := obstacle as MovableAnchorableProp
			_expect(planter != null, "Station 09 planter must use MovableAnchorableProp")
			var station_09 := station as Station09
			if planter and station_09:
				var before_x := planter.position.x
				station_09.push_planter(1.0)
				for _frame in range(8):
					await physics_frame
				_expect(planter.position.x > before_x, "Station 09 planter must respond to a push")
				station_09.apply_planter_setback()
				await process_frame
				_expect(station_09.planter_setback_count > 0, "Station 09 setback must count a lost attempt")
				_expect(not station_09.is_level_completed, "Station 09 setback must not end the level")
		10:
			var apartment_door := obstacle as AnimatableBody2D
			_expect(apartment_door != null, "Station 10 threshold must be AnimatableBody2D")
			var station_10 := station as Station10
			if apartment_door and station_10:
				station_10.apply_threshold_setback()
				await process_frame
				_expect(station_10.threshold_setback_count > 0, "Station 10 setback must count a lost attempt")
				station_10.turn_key()
				_expect(not station_10.is_threshold_open, "Station 10 key alone must not open the threshold")
				station_10.set_bag_down()
				_expect(station_10.is_threshold_open, "Station 10 must open once the bag is down")
				for _frame in range(20):
					await process_frame
				_expect(apartment_door.position.y < 252.0, "Station 10 threshold must leave its closed mounting")


func _check_three_question_headers() -> void:
	for station_number in range(6, 11):
		var path := "res://scripts/levels/station_%02d.gd" % station_number
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "station script must be readable: %s" % path)
		if file == null:
			continue
		var source := file.get_as_text()
		file.close()
		for question in ["dlaczego to tu jest", "czego wymaga od Leny", "koszt porażki"]:
			_expect(
				source.contains("## PRZESZKODA — " + question),
				"%s is missing the three-question header '%s'" % [path, question]
			)
		var why_line := ""
		for line in source.split("\n"):
			if line.begins_with("## PRZESZKODA — dlaczego to tu jest"):
				why_line = line
				break
		_expect(not why_line.to_lower().contains("gracz"), "%s world sentence contains forbidden player wording" % path)


func _check_campaign_chain(state: Node) -> void:
	if state == null:
		return
	state.reset_campaign(true)
	for station_number in range(1, 10):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_10"), "Act I chain must reach Station 10")
	for station_number in range(10, 26):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_25"), "campaign chain must still reach Station 25")
	_expect(state.has_reached_station(&"station_26"), "production campaign chain must continue to Station 26")
