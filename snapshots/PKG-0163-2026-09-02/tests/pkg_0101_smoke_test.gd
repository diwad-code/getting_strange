extends SceneTree

## PKG-0101 gate: Station 16..20 Vector-Stage visibility and diegetic obstacle contracts.
##
## This gate proves technical behavior only (D-012, ADR-003). It cannot prove
## that a space is fun, emotionally effective, or comprehensible to a person.

const ACT_IIB_PATHS := [
	"res://scenes/levels/station_16.tscn",
	"res://scenes/levels/station_17.tscn",
	"res://scenes/levels/station_18.tscn",
	"res://scenes/levels/station_19.tscn",
	"res://scenes/levels/station_20.tscn",
]

const REQUIRED_FLOORS := {
	"res://scenes/levels/station_16.tscn": ["FloorMain"],
	"res://scenes/levels/station_17.tscn": ["FloorMain"],
	"res://scenes/levels/station_18.tscn": ["FloorMain"],
	"res://scenes/levels/station_19.tscn": ["FloorMain"],
	"res://scenes/levels/station_20.tscn": ["FloorMain"],
}

const REQUIRED_SHELLS := {
	"res://scenes/levels/station_16.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_17.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_18.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_19.tscn": ["WallLeft", "WallRight", "Ceiling"],
	"res://scenes/levels/station_20.tscn": ["WallLeft", "WallRight", "Ceiling"],
}

const OBSTACLE_PATHS := {
	17: "Props/VentilationLever",
	19: "Props/PayphoneHandset",
	20: "Props/PartsTrolley",
}

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0101: " + message)


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
		print("PKG-0101 SMOKE PASS: Act IIb Vector-Stage state pass, diegetic obstacles and chain 16..20")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0101 FAILURE: " + failure)
		quit(1)


func _check_stations(state: Node) -> void:
	for expected_number in range(16, 21):
		var path: String = ACT_IIB_PATHS[expected_number - 16]
		var packed := load(path) as PackedScene
		_expect(packed != null, "Act IIb station must load: %s" % path)
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
			for floor_name in REQUIRED_FLOORS[path]:
				var floor := geometry.get_node_or_null(floor_name) as StaticBody2D
				_expect(floor != null, "authored floor %s is missing: %s" % [floor_name, path])
				_check_rectangle_shape(floor, Vector2(640.0, 80.0), "floor", path)
			for shell_name in REQUIRED_SHELLS[path]:
				var shell := geometry.get_node_or_null(shell_name) as StaticBody2D
				_expect(shell != null, "shell collider %s is missing: %s" % [shell_name, path])
				if shell:
					_expect(shell.get_node_or_null("CollisionShape2D") != null, "shell collider lost its shape: %s" % path)
			for child in geometry.get_children():
				if expected_number in [16, 18]:
					_expect(not child is AnimatableBody2D, "Station %d must keep the space free of an artificial obstacle" % expected_number)

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

		if expected_number in OBSTACLE_PATHS:
			await _check_obstacle(expected_number, station, state)

		station.queue_free()
		await process_frame


func _check_rectangle_shape(body: StaticBody2D, expected_size: Vector2, label: String, path: String) -> void:
	if body == null:
		return
	var shape_node := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	_expect(shape_node != null, "%s must carry a collision shape: %s" % [label, path])
	if shape_node:
		var rectangle := shape_node.shape as RectangleShape2D
		_expect(rectangle != null, "%s must use a rectangle shape: %s" % [label, path])
		if rectangle:
			_expect(rectangle.size == expected_size, "%s shape size changed: %s" % [label, path])


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
		"draw_rect(Rect2(Vector2.ZERO, VIEW_SIZE), COLOR_BACKGROUND)",
	]:
		_expect(not draw_body.contains(forbidden_call), "opaque legacy draw remains in %s" % script_path)


func _check_obstacle(expected_number: int, station: Node2D, state: Node) -> void:
	var obstacle := station.get_node_or_null(OBSTACLE_PATHS[expected_number])
	_expect(obstacle != null, "diegetic obstacle missing in Station %d" % expected_number)
	if obstacle == null:
		return

	match expected_number:
		17:
			var station_17 := station as Station17
			if station_17:
				if state:
					state.record_decision(&"p7.work_history_and_record.institution_trial_result", "persistent_chronology_confirmed")
				_expect(not station_17.copy_report_header(), "Station 17 must refuse an out-of-scope copy safely")
				_expect(
					state != null and state.decisions.get(&"p7.work_history_and_record.safe_trial_feedback", "") == "report_scope_incomplete",
					"Station 17 safe failure must leave a fact"
				)
				_expect(station_17.read_incident_report(), "Station 17 incident report must be readable")
				_expect(station_17.compare_signature_with_card(), "Station 17 signature must be comparable")
				_expect(station_17.release_service_route(), "Station 17 ventilation latch must release the route")
				_expect(station_17.copy_report_header(), "Station 17 route must be cleared by the scope commitment")
				_expect(station_17.is_report_scope_committed and station_17.is_service_route_released, "Station 17 must record scope and route")
		19:
			var station_19 := station as Station19
			if station_19:
				if state:
					state.record_decision(&"p7.three_place_proofs.public_trial_result", "two_systems_and_nine_years")
				_expect(not station_19.compare_control_answers(), "Station 19 must refuse an empty comparison safely")
				_expect(
					state != null and state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "control_answers_incomplete",
					"Station 19 safe failure must leave a fact"
				)
				_expect(station_19.shield_microphone(), "Station 19 shield panel must damp the arterial road")
				_expect(station_19.prepare_control_questions(), "Station 19 control questions must be prepared")
				_expect(station_19.answer_payphone(), "Station 19 payphone must open the contact")
				_expect(station_19.ask_control_questions(), "Station 19 must ask both control questions")
				_expect(station_19.compare_control_answers(), "Station 19 voice trial must resolve")
		20:
			var station_20 := station as Station20
			if station_20:
				if state:
					state.record_decision(&"p7.three_place_proofs.voice_trial_result", "impostor_and_recording_insufficient")
				_expect(station_20.move_parts_trolley(), "Station 20 parts trolley must open the conversation space")
				_expect(station_20.confirm_marta_presence(), "Station 20 must keep Marta present as witness")
				_expect(station_20.meet_jakub_face_to_face(), "Station 20 meeting must happen face to face")
				_expect(not station_20.request_voluntary_reader_scan(), "Station 20 must refuse a scan before the boundary is accepted")
				_expect(
					state != null and state.decisions.get(&"p7.three_place_proofs.safe_trial_feedback", "") == "boundary_not_respected",
					"Station 20 safe failure must record the violated boundary"
				)
				_expect(station_20.accept_scar_refusal(), "Station 20 must accept Jakub's refusal")
				_expect(station_20.request_voluntary_reader_scan(), "Station 20 scan must be volunteered after the refusal")
				_expect(station_20.compare_local_service_base(), "Station 20 relational trial must resolve")


func _check_three_question_headers() -> void:
	for station_number in [17, 19, 20]:
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
	for station_number in range(1, 20):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_20"), "campaign chain must reach Station 20")
	for station_number in range(20, 26):
		state.complete_station(StringName("station_%02d" % station_number), false)
	_expect(state.has_reached_station(&"station_25"), "campaign chain must still reach Station 25")
	_expect(state.has_reached_station(&"station_26"), "production campaign chain must continue to Station 26")
