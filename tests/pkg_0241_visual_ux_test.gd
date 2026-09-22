extends SceneTree
var results: Array[Dictionary] = []
func _initialize() -> void:
	call_deferred("_run")
func wait_frames(n: int = 3) -> void:
	for _i in range(n):
		await process_frame
func check(id: String, ok: bool, detail: String = "") -> void:
	results.append({"id": id, "pass": ok, "detail": detail})
	print("PROBE_0241 ", "PASS " if ok else "FAIL ", id, " ", detail)
func key(code: Key, pressed_value: bool = true) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed_value
	Input.parse_input_event(event)
func _run() -> void:
	var state := root.get_node("GameStateManager")
	var settings_path: String = state.get_settings_path()
	var settings_existed := FileAccess.file_exists(settings_path)
	var settings_backup := FileAccess.get_file_as_bytes(settings_path) if settings_existed else PackedByteArray()
	var save_path: String = state.get_save_path()
	var save_existed := FileAccess.file_exists(save_path)
	var save_backup := FileAccess.get_file_as_bytes(save_path) if save_existed else PackedByteArray()
	state.set_master_volume(0.0, false)
	state.restore_default_input_map(false)
	var host := Node2D.new()
	root.add_child(host)
	current_scene = host
	var box := CRTDialogueBox.new()
	host.add_child(box)
	var finished := [0]
	box.line_finished.connect(func(_speaker: StringName, _text: String) -> void: finished[0] += 1)
	box.show_line("Lena", "To jest pełne zdanie z [nawiasami], które zachowuje układ podczas pisania.")
	await wait_frames()
	check("full_text_layout", box._text_label.get_parsed_text() == box._current_text)
	box.advance_dialogue()
	check("skip_finishes_once", finished[0] == 1 and box._continue_label.visible, str(finished[0]))
	box.show_line("Lena", "Tekst podczas pauzy nie może znikać ani przesuwać się sam.")
	await wait_frames()
	paused = true
	var count := box._visible_characters
	await wait_frames(10)
	check("paused_typewriter_frozen", count == box._visible_characters, "%d -> %d" % [count, box._visible_characters])
	paused = false
	box.hide_box()
	var overlay := SettingsOverlay.new()
	host.add_child(overlay)
	overlay.open_panel()
	for language in ["pl", "en"]:
		LocalizationManager.set_locale(language)
		for text_scale in [0.85, 1.0, 1.15]:
			state.set_text_scale(text_scale, false)
			state.apply_text_scale_to_tree()
			overlay.refresh_for_test()
			await wait_frames()
			check("settings_footer_%s_%d" % [language, roundi(text_scale * 100.0)], overlay._settings_hint.get_rect().end.y <= overlay._settings_back_button.position.y and overlay._settings_hint.get_line_count() == 1)
	LocalizationManager.set_locale("pl")
	state.set_text_scale(1.0, false)
	state.apply_text_scale_to_tree()
	overlay._open_remap()
	await wait_frames()
	overlay._begin_rebind(&"interact")
	key(KEY_ENTER)
	await wait_frames()
	key(KEY_ENTER, false)
	await wait_frames()
	check("capture_enter_before_gui", overlay._pending_rebind_action.is_empty())
	overlay._pending_rebind_action = &""
	overlay._restore_defaults()
	check("defaults_feedback", overlay._remap_hint.text == LocalizationManager.tr_key("SETTINGS_REMAP_DEFAULTS_RESTORED"), overlay._remap_hint.text)
	overlay._remap_back_button.grab_focus()
	key(KEY_TAB)
	await wait_frames()
	key(KEY_TAB, false)
	var focus := root.gui_get_focus_owner()
	check("tab_stays_in_remap", focus != null and overlay._remap_panel.is_ancestor_of(focus), str(focus.get_path()) if focus else "none")
	overlay.close_panel()
	var rig := CharacterVisualRig.new()
	rig.character_id = &"marta"
	host.add_child(rig)
	rig.set_state(&"talk")
	rig._state_time = 0.21
	rig.set_state(&"talk")
	check("same_animation_state_preserves_phase", rig._state_time == 0.21)
	MotionAccessibility.set_reduced_motion(true)
	rig.set_state(&"idle")
	rig._breath_cycle = rig.BREATH_PERIOD / 4.0
	check("reduced_motion_stops_npc_breath", rig._breath_offset() == 0.0)
	MotionAccessibility.reset()
	for name in ["idle", "listen", "talk_0", "talk_1"]:
		check("vendor_asset_" + name, ResourceLoader.exists("res://assets/characters/vendor/%s.png" % name))
	# Pause all presentation clocks, not just gameplay physics.
	var thought := InnerThoughtSurface.new()
	host.add_child(thought)
	thought.present_thought(null, "To zdanie musi pozostać czytelne po powrocie z pauzy.")
	for scale_value in [0.85, 1.0, 1.15]:
		state.set_text_scale(scale_value, false)
		thought.present_thought(null, "Na oparciu kurtka odwrócona na lewą stronę. Marta nic nie mówi.")
		await wait_frames()
		check("thought_fits_%d" % roundi(scale_value * 100), thought._thought_label.get_content_height() <= thought._thought_label.size.y)
	state.set_text_scale(1.0, false)
	var cold := load("res://scripts/ui/cold_open.gd").new() as Node2D
	host.add_child(cold)
	var vignette := CinematicVignette.new()
	vignette.setup(&"vig_threshold", CinematicCatalog.CATALOG["vig_threshold"])
	host.add_child(vignette)
	await wait_frames()
	paused = true
	var thought_time := thought._dismiss_timer
	var cold_time: float = cold.get_elapsed_seconds()
	var vignette_time := vignette._elapsed
	await wait_frames(10)
	check("paused_thought_frozen", thought._dismiss_timer == thought_time)
	check("paused_cold_open_frozen", cold.get_elapsed_seconds() == cold_time)
	check("paused_vignette_frozen", vignette._elapsed == vignette_time)
	var advance := InputEventAction.new()
	advance.action = &"interact"
	advance.pressed = true
	vignette._unhandled_input(advance)
	check("paused_vignette_cannot_skip", not vignette.is_finished())
	paused = false
	thought.free()
	cold.free()
	vignette.free()
	var lena := LenaVisualRig.new()
	host.add_child(lena)
	MotionAccessibility.set_reduced_motion(true)
	lena._breath_cycle = lena.BREATH_PERIOD / 4.0
	check("reduced_motion_stops_lena_breath", lena._breath_offset(&"idle") == 0.0)
	MotionAccessibility.reset()
	# A confirmation is initially safe, cancellable, and emits at most once.
	var accepted := [0]
	var cancelled_count := [0]
	var modal := SafeActionDialog.new()
	host.add_child(modal)
	modal.confirmed.connect(func() -> void: accepted[0] += 1)
	modal.cancelled.connect(func() -> void: cancelled_count[0] += 1)
	modal.present("TEST", "Ta próba nie usuwa danych.", "USUŃ", null)
	await wait_frames()
	check("confirmation_default_is_cancel", root.gui_get_focus_owner() == modal._cancel)
	key(KEY_ESCAPE)
	await wait_frames()
	key(KEY_ESCAPE, false)
	check("confirmation_escape_never_accepts", accepted[0] == 0 and cancelled_count[0] == 1)
	modal = SafeActionDialog.new()
	host.add_child(modal)
	modal.confirmed.connect(func() -> void: accepted[0] += 1)
	modal.present("TEST", "Ta próba nie usuwa danych.", "USUŃ", null)
	modal.accept()
	modal.accept()
	check("confirmation_accepts_only_once", accepted[0] == 1)
	await wait_frames()
	for proof in [{"name": "board_vehicle_0", "x": 46, "y": 16}, {"name": "board_vehicle_1", "x": 32, "y": 70}, {"name": "climb_back_0", "x": 32, "y": 16}]:
		var texture := load("res://assets/characters/lena/%s.png" % proof.name) as Texture2D
		check("sprite_canvas_" + proof.name, texture.get_size() == Vector2(64.0, 104.0))
		check("no_baked_scenery_" + proof.name, texture.get_image().get_pixel(proof.x, proof.y).a == 0.0)
	state.restore_default_input_map(false)
	paused = false
	ProceduralAudio.drain_playback(host)
	host.free()
	current_scene = null
	# Both UI routes must ask before calling the destructive state API.
	var title := load("res://scenes/shell/title_screen.tscn").instantiate() as TitleScreen
	root.add_child(title)
	current_scene = title
	state._save_valid = true
	state.decisions[&"audit_sentinel"] = "keep"
	title._on_new_game_pressed()
	await wait_frames()
	var title_modal := title.get_node_or_null("SafeActionDialog") as SafeActionDialog
	check("new_game_requires_confirmation", title_modal != null and state.decisions.get(&"audit_sentinel") == "keep")
	if title_modal:
		title_modal.cancel()
	await wait_frames()
	check("cancel_new_game_preserves_progress", state.decisions.get(&"audit_sentinel") == "keep")
	key(KEY_ESCAPE)
	await wait_frames()
	key(KEY_ESCAPE, false)
	check("title_cannot_open_campaign_pause", not paused)
	title.free()
	current_scene = null
	state.set_pause_menu_visible(true)
	state._open_pause_settings()
	await wait_frames()
	check("pause_settings_hides_selector", not state._pause_layer.get_node("PanelContainer").visible)
	state._pause_settings_panel.close_panel()
	await wait_frames()
	check("pause_settings_restores_launch_focus", root.gui_get_focus_owner().name == "SettingsButton")
	state._request_reset_campaign()
	await wait_frames()
	var reset_modal := state.get_node_or_null("SafeActionDialog") as SafeActionDialog
	check("reset_requires_confirmation", reset_modal != null and state.decisions.get(&"audit_sentinel") == "keep")
	if reset_modal:
		reset_modal.cancel()
	await wait_frames()
	check("cancel_reset_preserves_progress", state.decisions.get(&"audit_sentinel") == "keep")
	state.set_pause_menu_visible(false)
	for id in ["station_42a", "station_42b", "station_42c"]:
		state.reset_campaign(false)
		var scene := load("res://scenes/levels/%s.tscn" % id).instantiate() as Node2D
		root.add_child(scene)
		current_scene = scene
		for _frame in range(60):
			await physics_frame
		var floor_shape := scene.get_node("Geometry/FloorMain/CollisionShape2D") as CollisionShape2D
		var floor_y := floor_shape.global_position.y - (floor_shape.shape as RectangleShape2D).size.y / 2.0
		var player := scene.get_node("Player") as Node2D
		var marta := scene.find_child("Marta", true, false) as Node2D
		check(id + "_floor_matches_art", is_equal_approx(floor_y, 306.0))
		check(id + "_player_supported", absf(player.global_position.y + 27.0 - floor_y) < 3.0, str(player.global_position.y))
		check(id + "_marta_supported", absf(marta.global_position.y + 27.0 - floor_y) <= 2.0)
		ProceduralAudio.drain_playback(scene)
		scene.free()
		await wait_frames()
	if settings_existed:
		FileAccess.open(settings_path, FileAccess.WRITE).store_buffer(settings_backup)
	else:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(settings_path))
	if save_existed:
		FileAccess.open(save_path, FileAccess.WRITE).store_buffer(save_backup)
	else:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	state.reload_settings_from_disk()
	var path := OS.get_environment("GS_PROBE_OUT")
	if path.is_empty():
		path = "res://reports/pkg_0241/regression.json"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path).get_base_dir())
	FileAccess.open(path, FileAccess.WRITE).store_string(JSON.stringify(results, "\t"))
	var count_failed := results.filter(func(row: Dictionary) -> bool: return not row["pass"]).size()
	print("PROBE_0241 total=%d failed=%d" % [results.size(), count_failed])
	quit(1 if count_failed else 0)
