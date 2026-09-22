extends SceneTree
## Reproducible diagnostic frames, NOT a campaign playthrough or product GO.
## Use a fresh OS user-data directory. Requires a real display driver, not --headless.
## GS_AUDIT_OUT selects an absolute output directory; no screenshots enter source control.
var out_dir := ""
var frames: Array[Dictionary] = []
var metrics: Array[Dictionary] = []
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _wait(count: int = 3) -> void:
	for _frame in range(count):
		await process_frame

func _run() -> void:
	if DisplayServer.get_name() == "headless":
		push_error("PKG-0241 capture requires a display driver")
		quit(2)
		return
	root.size = Vector2i(640, 360)
	seed(241)
	out_dir = OS.get_environment("GS_AUDIT_OUT")
	if out_dir.is_empty():
		out_dir = ProjectSettings.globalize_path("res://reports/pkg_0241/visual")
	DirAccess.make_dir_recursive_absolute(out_dir)
	var state := root.get_node("GameStateManager")
	state.set_master_volume(0.0, false)
	state.set_text_scale(1.0, false)
	state.set_locale("pl", false)
	var ids: Array[String] = []
	for number in range(1, 19):
		ids.append("station_%02d" % number)
	ids.append_array(["station_42a", "station_42b", "station_42c", "station_43"])
	for id in ids:
		state.reset_campaign(false)
		var packed := load("res://scenes/levels/%s.tscn" % id) as PackedScene
		if packed == null:
			failures += 1
			continue
		var scene := packed.instantiate()
		root.add_child(scene)
		current_scene = scene
		await _wait(60)
		var dialogue := scene.find_child("CRTDialogueBox", true, false) as CRTDialogueBox
		if dialogue and dialogue.is_presenting() and dialogue._typing:
			dialogue.advance_dialogue()
		await _wait()
		await _shot(id + "__opening")
		var lines: Array = dialogue._lines.duplicate(true) if dialogue else []
		if dialogue:
			# Layout probe only. Freeze owner to avoid actions being triggered by probe lines.
			for child in scene.get_children():
				if child.name == "CreativeScenePresentation":
					child.set_process(false)
			for scale_value in [0.85, 1.0, 1.15]:
				state.set_text_scale(scale_value, false)
				for i in range(lines.size()):
					dialogue.show_line(String(lines[i].get("speaker", "Lena")), String(lines[i].get("text", "")))
					if dialogue._typing:
						dialogue.advance_dialogue()
					await _wait(2)
					metrics.append({"scene": id, "scale": scale_value, "line": i,
						"text": dialogue._current_text, "height": dialogue._text_label.get_content_height(),
						"available": dialogue._text_label.size.y,
						"overflow": dialogue._text_label.get_content_height() > dialogue._text_label.size.y + 1.0})
					if scale_value == 1.15 and i == 0:
						await _shot(id + "__text115")
			state.set_text_scale(1.0, false)
			# No dialogue_finished emission: don't trigger a vignette/decision while composing.
			dialogue.visible = false
			dialogue.set_process(false)
		for thought in scene.find_children("*", "InnerThoughtSurface", true, false):
			thought.visible = false
			thought.set_process(false)
		await _wait(45)
		await _shot(id + "__world")
		if id == "station_01":
			for scale_value in [1.0, 1.15]:
				state.set_text_scale(scale_value, false)
				state.set_pause_menu_visible(true)
				await _wait()
				await _shot("pause_%d" % roundi(scale_value * 100))
				state._open_pause_settings()
				await _wait()
				await _shot("pause_settings_%d" % roundi(scale_value * 100))
				state._pause_settings_panel.close_panel()
				state.set_pause_menu_visible(false)
			state.set_text_scale(1.0, false)
		current_scene = null
		ProceduralAudio.drain_playback(scene)
		scene.free()
		await _wait()
	state.reset_campaign(false)
	var title := load("res://scenes/shell/title_screen.tscn").instantiate() as TitleScreen
	root.add_child(title)
	current_scene = title
	for language in ["pl", "en"]:
		state.set_locale(language, false)
		for scale_value in [0.85, 1.0, 1.15]:
			state.set_text_scale(scale_value, false)
			await _wait()
			var tag := "%s_%d" % [language, roundi(scale_value * 100)]
			await _shot("title_" + tag)
			title._on_settings_pressed()
			await _wait()
			await _shot("settings_" + tag)
			title._settings_panel._open_remap()
			await _wait()
			await _shot("remap_" + tag)
			title._settings_panel.close_panel()
	var report := {"engine": Engine.get_version_info(), "display": DisplayServer.get_name(),
		"scope": "22 independently reset scene entries; opening lines at 85/100/115%; PL/EN shell",
		"frames": frames, "dialogue_metrics": metrics, "capture_failures": failures}
	FileAccess.open(out_dir.path_join("manifest.json"), FileAccess.WRITE).store_string(JSON.stringify(report, "\t"))
	print("CAPTURE_0241 frames=%d lines=%d failures=%d" % [frames.size(), metrics.size(), failures])
	quit(0 if failures == 0 else 1)

func _shot(id: String) -> void:
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var filename := id + ".png"
	var error := image.save_png(out_dir.path_join(filename))
	if error != OK:
		failures += 1
	frames.append({"id": id, "file": filename, "width": image.get_width(), "height": image.get_height(), "error": error})
	print("FRAME_0241 ", id)
