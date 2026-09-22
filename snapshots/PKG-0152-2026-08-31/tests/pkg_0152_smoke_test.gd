extends SceneTree

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0152 FAILURE: %s" % message)


func _run_tests() -> void:
	print("=== PKG-0152 Smoke Test: P8 release surface audit ===")
	_test_release_surface_documents()
	_test_export_presets()
	_test_export_workflow_guard_and_quarantine()
	await _test_runtime_release_surfaces()
	_finish()


func _test_release_surface_documents() -> void:
	var licenses_text := FileAccess.get_file_as_string("res://docs/LICENSES.md")
	_expect(not licenses_text.is_empty(), "docs/LICENSES.md must exist")
	_expect(licenses_text.contains("Zero-Asset Architecture"), "LICENSES.md must preserve Zero-Asset Architecture heading")
	_expect(licenses_text.contains("assets/characters/lena/"), "LICENSES.md must acknowledge Lena runtime sprite assets")
	_expect(licenses_text.contains("assets/characters/portraits/"), "LICENSES.md must acknowledge CRT portrait assets")
	_expect(licenses_text.to_lower().contains("materiały źródłowe procesu"), "LICENSES.md must describe non-shipping source materials")
	_expect(licenses_text.contains("Godot Engine v4.7.2.stable.official.ed1daf0bf"), "LICENSES.md must state the verified engine build")

	var release_text := FileAccess.get_file_as_string("res://docs/RELEASE_NOTES.md")
	_expect(not release_text.is_empty(), "docs/RELEASE_NOTES.md must exist")
	_expect(release_text.contains("RELEASE CANDIDATE 1 (RC1)"), "RELEASE_NOTES.md must preserve the RC1 historical label")
	_expect(release_text.contains("15 sekwencji diagnostycznych"), "RELEASE_NOTES.md must describe the current 15-sequence runtime")
	_expect(release_text.contains("43 adresy narracyjne"), "RELEASE_NOTES.md must describe the 43-address campaign")
	_expect(release_text.contains("45 technicznych zasobów scenicznych"), "RELEASE_NOTES.md must describe the 45 technical scenes")
	_expect(release_text.contains("historyczne artefakty `dist/`"), "RELEASE_NOTES.md must mark dist artifacts as historical")
	_expect(release_text.contains("nie jest gotowy do nowego pakietu release"), "RELEASE_NOTES.md must record the PKG-0152 release verdict")


func _test_export_presets() -> void:
	var export_cfg := ConfigFile.new()
	var err := export_cfg.load("res://export_presets.cfg")
	_expect(err == OK, "export_presets.cfg must exist and load successfully")
	if err != OK:
		return
	_expect(export_cfg.get_value("preset.0", "name", "") == "Windows Desktop", "Preset 0 must remain Windows Desktop")
	_expect(export_cfg.get_value("preset.0", "platform", "") == "Windows Desktop", "Preset 0 platform must remain Windows Desktop")
	_expect(export_cfg.get_value("preset.0", "export_path", "") == "dist/windows/GettingStrange.exe", "Preset 0 export path must remain dist/windows/GettingStrange.exe")
	_expect(export_cfg.get_value("preset.0.options", "custom_template/release", "") == "", "Preset 0 must rely on default export templates")
	_expect(export_cfg.get_value("preset.1", "name", "") == "Linux Desktop", "Preset 1 must remain Linux Desktop")
	_expect(export_cfg.get_value("preset.1", "platform", "") == "Linux", "Preset 1 platform must remain Linux")
	_expect(export_cfg.get_value("preset.1", "export_path", "") == "dist/linux/GettingStrange.x86_64", "Preset 1 export path must remain dist/linux/GettingStrange.x86_64")
	_expect(export_cfg.get_value("preset.1.options", "custom_template/release", "") == "", "Preset 1 must rely on default export templates")


func _test_export_workflow_guard_and_quarantine() -> void:
	var export_script := FileAccess.get_file_as_string("res://tools/export_builds.ps1")
	_expect(not export_script.is_empty(), "tools/export_builds.ps1 must exist")
	_expect(export_script.contains("[switch] $AllowBinaryBuild"), "export_builds.ps1 must require explicit binary-build approval")
	_expect(export_script.contains("D-125"), "export_builds.ps1 must cite D-125 guard")
	_expect(export_script.contains("Binary build blocked"), "export_builds.ps1 must block binary builds by default")
	_expect(FileAccess.file_exists("res://assets/characters/lena/raw/.gdignore"), "assets/characters/lena/raw/.gdignore must exist")
	_expect(FileAccess.file_exists("res://assets/characters/lena/logs/.gdignore"), "assets/characters/lena/logs/.gdignore must exist")


func _test_runtime_release_surfaces() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist for runtime release surface audit")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	var title_packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
	_expect(title_packed != null, "Title screen scene must load")
	if title_packed != null:
		var title := title_packed.instantiate() as Control
		root.add_child(title)
		await process_frame
		_expect(title.get_node_or_null("TitlePanel") != null, "Title screen must expose TitlePanel")
		_expect(title.get_node_or_null("SettingsPanel") != null, "Title screen must expose SettingsPanel")
		var build_label := title.get_node_or_null("TitlePanel/BuildLabel") as Label
		_expect(build_label != null, "Title screen must expose BuildLabel")
		if build_label != null:
			_expect(not build_label.text.is_empty(), "BuildLabel text must not be empty")
		title.queue_free()
		await process_frame

	var station_packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	_expect(station_packed != null, "Station 43 scene must load")
	if station_packed != null:
		var station := station_packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		await physics_frame
		_expect(station.has_node("Props/AdminNoticeBoard"), "Station 43 must expose AdminNoticeBoard")
		_expect(station.has_node("Props/CreditsRoll"), "Station 43 must expose CreditsRoll")
		_expect(station.has_node("Props/FinalBlackout"), "Station 43 must expose FinalBlackout")
		_expect(station.has_method("inspect_credits"), "Station 43 must expose inspect_credits()")
		if station.has_method("inspect_credits"):
			_expect(bool(station.call("inspect_credits")), "Station 43 credits inspection must succeed")
			_expect(bool(station.get("is_credits_inspected")), "Station 43 must record credits inspection")
			if state != null:
				_expect(state.decisions.get(&"p7.conscious_silence_and_presence.epilogue_credits_read", false) == true, "Station 43 credits inspection must persist trace state")
		station.queue_free()
		await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0152 SMOKE PASS: release docs, export surface, quarantine and runtime shell audit")
		quit(0)
		return
	for failure in _failures:
		printerr(" - %s" % failure)
	quit(1)
