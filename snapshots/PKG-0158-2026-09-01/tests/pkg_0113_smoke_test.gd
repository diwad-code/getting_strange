extends SceneTree

## PKG-0113 technical gate for the release-readiness truth pass and the largest
## safe visual/UI remediation. It proves structure and invocation coverage only;
## it cannot prove readability, appeal, comprehension, fun or audience response.

const STATION_01 := "res://scenes/levels/station_01.tscn"
const SMOKE_SOURCE := "res://tests/smoke_test.gd"
const ENVIRONMENT_SOURCE := "res://scripts/visual/vector_stage_environment.gd"
const CAPTURE_SOURCE := "res://tools/capture_pkg_0113.gd"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		push_error("PKG-0113: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload is missing")
	if state:
		var constants: Dictionary = state.get_script().get_script_constant_map()
		_expect(int(constants.get("CAMPAIGN_TRANSITION_LIMIT", -1)) == 41, "campaign transition limit must cover Station 01..41")
		_expect(int(constants.get("SAVE_SCHEMA_VERSION", -1)) == 1, "save schema must remain version 1")
		await _check_pause_surface(state)

	await _check_dialogue_surface()
	_check_full_smoke_invocation_source()
	_check_visual_pipeline_source()

	if state:
		state.set_pause_menu_visible(false)
		state.reset_campaign(true)
	if _failures.is_empty():
		print("PKG-0113 SMOKE PASS: 43-space smoke invocation, Vector-Stage practicals, CRT portrait and fitted pause UI")
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0113 FAILURE: " + failure)
		quit(1)


func _check_pause_surface(state: Node) -> void:
	state.set_test_mode(false)
	state.set_pause_menu_visible(true)
	await process_frame
	var pause_layer := state.get_node_or_null("CampaignPauseMenu") as CanvasLayer
	var panel := state.get_node_or_null("CampaignPauseMenu/PanelContainer") as PanelContainer
	var grid := state.get_node_or_null("CampaignPauseMenu/PanelContainer/VBoxContainer/StationGrid") as GridContainer
	_expect(pause_layer != null and pause_layer.visible, "pause layer must be visible on request")
	_expect(panel != null, "pause panel is missing")
	_expect(grid != null, "pause station grid is missing")
	if panel:
		_expect(panel.position == Vector2(36.0, 18.0), "pause panel position changed")
		_expect(panel.size == Vector2(568.0, 324.0), "pause panel must fit inside 640x360")
		_expect(panel.position.x >= 0.0 and panel.position.y >= 0.0, "pause panel begins outside the viewport")
		_expect(panel.position.x + panel.size.x <= 640.0 and panel.position.y + panel.size.y <= 360.0, "pause panel extends outside the viewport")
	if grid:
		_expect(grid.columns == 9, "pause grid must use nine columns so all 43 choices fit")
		_expect(grid.get_child_count() == 43, "pause grid must expose the established 43 selectable campaign entries")
		for child in grid.get_children():
			var button := child as Button
			_expect(button != null, "pause grid may contain only buttons")
			if button:
				_expect(button.custom_minimum_size == Vector2(52.0, 24.0), "station button sizing changed: " + button.name)
				_expect(button.has_theme_stylebox_override(&"normal"), "station button lacks Vector-Stage normal style: " + button.name)
				_expect(button.has_theme_stylebox_override(&"disabled"), "station button lacks explicit disabled style: " + button.name)
	state.set_pause_menu_visible(false)


func _check_dialogue_surface() -> void:
	var packed := load(STATION_01) as PackedScene
	_expect(packed != null, "Station 01 must load for dialogue surface inspection")
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	_expect(dialogue != null, "Station 01 CRT dialogue surface is missing")
	if dialogue:
		dialogue.present([{"speaker": "Lena", "text": "Kontrola powierzchni dialogowej."}])
		var panel := dialogue.get_node_or_null("CRTDialoguePanel") as Panel
		var portrait := dialogue.get_node_or_null("CRTDialoguePanel/WitnessPortrait") as CRTPortrait
		var continue_action := dialogue.get_node_or_null("CRTDialoguePanel/ContinueAction") as Label
		_expect(panel != null, "CRT dialogue panel is missing")
		_expect(portrait != null, "CRT dialogue must use the procedural witness portrait")
		_expect(continue_action != null, "CRT semantic continue action is missing")
		if panel:
			_expect(panel.position == Vector2(24.0, 238.0), "CRT panel position changed")
			_expect(panel.size == Vector2(592.0, 102.0), "CRT panel size changed")
		if portrait:
			_expect(portrait.speaker == &"Lena", "CRT portrait did not receive the current speaker")
		if continue_action:
			_expect(continue_action.text == "INTERAKCJA  >", "CRT continue prompt must name the semantic action")
	station.queue_free()
	await process_frame


func _check_full_smoke_invocation_source() -> void:
	var source := FileAccess.get_file_as_string(SMOKE_SOURCE)
	_expect(not source.is_empty(), "cannot read the main smoke source")
	for station_number in range(1, 42):
		var station_id := "station_%02d" % station_number
		_expect(source.contains("await _test_%s()" % station_id), "main smoke does not invoke " + station_id)
	for variant in ["station_42a", "station_42b", "station_42c", "station_43"]:
		_expect(source.contains("await _test_%s()" % variant), "main smoke does not invoke " + variant)
	_expect(source.contains("ObservedGlassTrace must anchor before crossing"), "Station 32 smoke must exercise its Anchor boundary")
	_expect(source.contains("JakubRescueBulkhead must anchor before crossing"), "Station 38 smoke must exercise its Anchor boundary")


func _check_visual_pipeline_source() -> void:
	var environment := FileAccess.get_file_as_string(ENVIRONMENT_SOURCE)
	_expect(not environment.is_empty(), "cannot read the Vector-Stage environment source")
	_expect(not environment.contains("var lamp_positions"), "the repeated three-pendant template must not return")
	_expect(environment.contains("func _draw_practical_lighting()"), "chapter practical-light profiles are missing")
	_expect(environment.contains("func _draw_stage_frame()"), "Vector-Stage proscenium frame is missing")
	var capture := FileAccess.get_file_as_string(CAPTURE_SOURCE)
	_expect(not capture.is_empty(), "PKG-0113 before/after capture tool is missing")
	_expect(capture.contains("--capture-phase=before") and capture.contains("--capture-phase=after"), "capture tool must retain both evidence phases")
