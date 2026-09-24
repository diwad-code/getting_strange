extends SceneTree
## PKG-0242 diagnostic frames of the release surfaces and the choice rooms.
## NOT a campaign playthrough or product GO. Requires a real display driver
## (e.g. xvfb-run), not --headless. GS_AUDIT_OUT selects an absolute output
## directory; no screenshots enter source control.
##
## Frames: title (PL/EN), credits & licences, release pause menu, the three
## side-choice rooms (16 selector, 17 desk, 18 table + post) with their
## legends, the 18 refused exit, the four finale/epilogue openings.

const CampaignChain := preload("res://tests/support/campaign_chain.gd")

var out_dir := ""
var frames: Array[String] = []
var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _wait(count: int = 3) -> void:
	for _frame in range(count):
		await process_frame


func _run() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("PKG-0242 capture requires a display driver")
		quit(2)
		return
	root.size = Vector2i(640, 360)
	out_dir = OS.get_environment("GS_AUDIT_OUT")
	if out_dir.is_empty():
		out_dir = ProjectSettings.globalize_path("res://reports/pkg_0242/visual")
	DirAccess.make_dir_recursive_absolute(out_dir)
	var state := root.get_node("GameStateManager")
	state.set_master_volume(0.0, false)
	state.set_text_scale(1.0, false)
	state.campaign_auto_transition_enabled = false
	await _shell(state)
	await _choice_rooms(state)
	await _finales(state)
	print("CAPTURE_0242 frames=%d failures=%d" % [frames.size(), failures])
	quit(0 if failures == 0 else 1)


func _shell(state: Node) -> void:
	state.reset_campaign(false)
	var title := load("res://scenes/shell/title_screen.tscn").instantiate() as TitleScreen
	root.add_child(title)
	current_scene = title
	for language in ["pl", "en"]:
		state.set_locale(language, false)
		await _wait(6)
		await _shot("title_" + language)
		title.call("_on_credits_pressed")
		await _wait(6)
		await _shot("credits_" + language)
		var credits := title.find_child("CreditsPanel", true, false)
		if credits != null:
			credits.call("close_panel")
	state.set_locale("pl", false)
	current_scene = null
	title.free()
	await _wait()
	var s01 := (load("res://scenes/levels/station_01.tscn") as PackedScene).instantiate()
	root.add_child(s01)
	current_scene = s01
	await _wait(30)
	state.set_pause_menu_visible(true)
	await _wait(10)
	await _shot("pause_release_pl")
	state.set_pause_menu_visible(false)
	current_scene = null
	s01.free()
	await _wait()


func _open(id: String) -> Node:
	var scene := (load("res://scenes/levels/%s.tscn" % id) as PackedScene).instantiate()
	root.add_child(scene)
	current_scene = scene
	await _wait(40)
	var box := scene.find_child("CRTDialogueBox", true, false) as CRTDialogueBox
	for _i in range(40):
		if box == null or not box.is_presenting():
			break
		box.advance_dialogue()
		await _wait(2)
	await _wait(20)
	return scene


func _close(scene: Node) -> void:
	current_scene = null
	ProceduralAudio.drain_playback(scene)
	scene.free()
	await _wait()


func _stand(scene: Node, x: float) -> void:
	var player := scene.get_node("Player") as Node2D
	player.global_position = Vector2(x, 296.0)
	await _wait(12)


func _choice_rooms(state: Node) -> void:
	CampaignChain.seed_before_17(state)
	# 16 is played already in the seed; re-open it to frame the selector room.
	var s16 := await _open("station_16")
	var selector := s16.get_node("Props/CostSelector") as Node2D
	await _stand(s16, selector.global_position.x - 30.0)
	await _shot("s16_selector_left")
	await _close(s16)
	state.decisions.erase(&"p9.consent_and_cost.cost_ledger_read")
	var s17 := await _open("station_17")
	s17.call("read_cost_ledger")
	s17.call("reject_adaptation_offer")
	var desk := s17.get_node("Props/ConsentScopeDesk") as Node2D
	await _stand(s17, desk.global_position.x + 30.0)
	await _shot("s17_desk_scope_right")
	await _close(s17)
	CampaignChain.seed_before_17(state)
	await CampaignChain.record_scope(self, "granted")
	var s18 := await _open("station_18")
	s18.call("compare_forecast_consent_dependencies")
	var table := s18.get_node("Props/MartaTruthTable") as Node2D
	await _stand(s18, table.global_position.x + 30.0)
	await _shot("s18_table_legend")
	var threshold := s18.get_node_or_null("Threshold") as Node2D
	if threshold != null:
		await _stand(s18, threshold.global_position.x)
		var press := InputEventAction.new()
		press.action = &"interact"
		press.pressed = true
		root.push_input(press, true)
		await _wait(8)
		await _shot("s18_exit_refused")
	var post := s18.get_node("Props/MethodCommitPost") as Node2D
	await _stand(s18, post.global_position.x + 50.0)
	await _shot("s18_post_mutual_side")
	await _close(s18)


func _finales(state: Node) -> void:
	for spec in [["force_home", "partial", "granted"], ["close_equal_recover_local", "partial", "limited"], ["mutual_passage", "full", "granted"]]:
		CampaignChain.seed_before_17(state)
		await CampaignChain.commit_chain(self, spec[0], spec[1], spec[2])
		var finale_id := CampaignChain.finale_for(spec[0])
		var finale := await _open(finale_id)
		await _shot(finale_id + "__opening_done")
		await _close(finale)
		await CampaignChain.play_finale(self, finale_id)
		var epilogue := await _open("station_43")
		await _shot("station_43__" + spec[0])
		await _close(epilogue)


func _shot(id: String) -> void:
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var error := image.save_png(out_dir.path_join(id + ".png"))
	if error != OK:
		failures += 1
	frames.append(id)
	print("FRAME_0242 ", id)
