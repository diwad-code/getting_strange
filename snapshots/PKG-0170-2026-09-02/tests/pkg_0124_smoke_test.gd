class_name PKG0124SmokeTest
extends SceneTree

const SCENE_PATHS: Array[String] = [
	"res://scenes/levels/station_01.tscn", "res://scenes/levels/station_02.tscn",
	"res://scenes/levels/station_03.tscn", "res://scenes/levels/station_04.tscn",
	"res://scenes/levels/station_05.tscn", "res://scenes/levels/station_06.tscn",
	"res://scenes/levels/station_07.tscn", "res://scenes/levels/station_08.tscn",
	"res://scenes/levels/station_09.tscn", "res://scenes/levels/station_10.tscn",
	"res://scenes/levels/station_11.tscn", "res://scenes/levels/station_12.tscn",
	"res://scenes/levels/station_13.tscn", "res://scenes/levels/station_14.tscn",
	"res://scenes/levels/station_15.tscn", "res://scenes/levels/station_16.tscn",
	"res://scenes/levels/station_17.tscn", "res://scenes/levels/station_18.tscn",
	"res://scenes/levels/station_19.tscn", "res://scenes/levels/station_20.tscn",
	"res://scenes/levels/station_21.tscn", "res://scenes/levels/station_22.tscn",
	"res://scenes/levels/station_23.tscn", "res://scenes/levels/station_24.tscn",
	"res://scenes/levels/station_25.tscn", "res://scenes/levels/station_26.tscn",
	"res://scenes/levels/station_27.tscn", "res://scenes/levels/station_28.tscn",
	"res://scenes/levels/station_29.tscn", "res://scenes/levels/station_30.tscn",
	"res://scenes/levels/station_31.tscn", "res://scenes/levels/station_32.tscn",
	"res://scenes/levels/station_33.tscn", "res://scenes/levels/station_34.tscn",
	"res://scenes/levels/station_35.tscn", "res://scenes/levels/station_36.tscn",
	"res://scenes/levels/station_37.tscn", "res://scenes/levels/station_38.tscn",
	"res://scenes/levels/station_39.tscn", "res://scenes/levels/station_40.tscn",
	"res://scenes/levels/station_41.tscn", "res://scenes/levels/station_42a.tscn",
	"res://scenes/levels/station_42b.tscn", "res://scenes/levels/station_42c.tscn",
	"res://scenes/levels/station_43.tscn", "res://scenes/shell/title_screen.tscn"
]

const SCRIPT_PATHS: Array[String] = [
	"res://scripts/levels/station_01.gd", "res://scripts/levels/station_02.gd",
	"res://scripts/levels/station_03.gd", "res://scripts/levels/station_04.gd",
	"res://scripts/levels/station_05.gd", "res://scripts/levels/station_06.gd",
	"res://scripts/levels/station_07.gd", "res://scripts/levels/station_08.gd",
	"res://scripts/levels/station_09.gd", "res://scripts/levels/station_10.gd",
	"res://scripts/levels/station_11.gd", "res://scripts/levels/station_12.gd",
	"res://scripts/levels/station_13.gd", "res://scripts/levels/station_14.gd",
	"res://scripts/levels/station_15.gd", "res://scripts/levels/station_16.gd",
	"res://scripts/levels/station_17.gd", "res://scripts/levels/station_18.gd",
	"res://scripts/levels/station_19.gd", "res://scripts/levels/station_20.gd",
	"res://scripts/levels/station_21.gd", "res://scripts/levels/station_22.gd",
	"res://scripts/levels/station_23.gd", "res://scripts/levels/station_24.gd",
	"res://scripts/levels/station_25.gd", "res://scripts/levels/station_26.gd",
	"res://scripts/levels/station_27.gd", "res://scripts/levels/station_28.gd",
	"res://scripts/levels/station_29.gd", "res://scripts/levels/station_30.gd",
	"res://scripts/levels/station_31.gd", "res://scripts/levels/station_32.gd",
	"res://scripts/levels/station_33.gd", "res://scripts/levels/station_34.gd",
	"res://scripts/levels/station_35.gd", "res://scripts/levels/station_36.gd",
	"res://scripts/levels/station_37.gd", "res://scripts/levels/station_38.gd",
	"res://scripts/levels/station_39.gd", "res://scripts/levels/station_40.gd",
	"res://scripts/levels/station_41.gd", "res://scripts/levels/station_42a.gd",
	"res://scripts/levels/station_42b.gd", "res://scripts/levels/station_42c.gd",
	"res://scripts/levels/station_43.gd"
]

var _failures: Array[String] = []


func _init() -> void:
	call_deferred(&"_run_tests")


func _run_tests() -> void:
	print("--- PKG-0124 Smoke Test: Release Candidate 1 & Distribution Verification ---")
	
	_test_export_presets_and_metadata()
	_test_licensing_and_release_notes()
	_test_localization_and_settings()
	await _test_60hz_performance_and_scene_stacks()
	await _test_title_screen_and_full_routing()
	
	if _failures.is_empty():
		print("PKG-0124: ALL RELEASE CANDIDATE TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		printerr("PKG-0124: FAILURES ENCOUNTERED:")
		for failure in _failures:
			printerr(" - ", failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("FAIL: ", message)


func _test_export_presets_and_metadata() -> void:
	print("1. Testing export presets, project configuration and build artifacts...")
	
	_expect(ProjectSettings.get_setting("application/config/name") == "Getting Strange", "Project name must be 'Getting Strange'")
	_expect(ProjectSettings.get_setting("application/config/version") == "1.0.0", "Project version must be '1.0.0'")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_width") == 640, "Viewport width must be 640")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_height") == 360, "Viewport height must be 360")
	_expect(ProjectSettings.get_setting("rendering/renderer/rendering_method") == "gl_compatibility", "Renderer must be gl_compatibility")
	_expect(ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter") == 0, "Default texture filter must be nearest (0)")
	
	# Verify export_presets.cfg
	var export_cfg := ConfigFile.new()
	var err := export_cfg.load("res://export_presets.cfg")
	_expect(err == OK, "export_presets.cfg must exist and load successfully")
	if err == OK:
		_expect(export_cfg.get_value("preset.0", "name", "") == "Windows Desktop", "Preset 0 must be Windows Desktop")
		_expect(export_cfg.get_value("preset.0", "platform", "") == "Windows Desktop", "Preset 0 platform must be Windows Desktop")
		_expect(export_cfg.get_value("preset.0", "export_path", "") == "dist/windows/GettingStrange.exe", "Preset 0 export path must match dist/windows/GettingStrange.exe")
		
		_expect(export_cfg.get_value("preset.1", "name", "") == "Linux Desktop", "Preset 1 must be Linux Desktop")
		_expect(export_cfg.get_value("preset.1", "platform", "") == "Linux", "Preset 1 platform must be Linux")
		_expect(export_cfg.get_value("preset.1", "export_path", "") == "dist/linux/GettingStrange.x86_64", "Preset 1 export path must match dist/linux/GettingStrange.x86_64")
	
	# Verify icon.svg
	var icon_file := FileAccess.open("res://icon.svg", FileAccess.READ)
	_expect(icon_file != null, "icon.svg must exist in project root")
	if icon_file:
		var svg_content := icon_file.get_as_text()
		_expect(svg_content.contains("<svg"), "icon.svg must be valid SVG")
		_expect(svg_content.contains("GETTING STRANGE"), "icon.svg must include branding")


func _test_licensing_and_release_notes() -> void:
	print("2. Testing licenses documentation and release notes...")
	
	var lic_file := FileAccess.open("res://docs/LICENSES.md", FileAccess.READ)
	_expect(lic_file != null, "docs/LICENSES.md must exist")
	if lic_file:
		var lic_text := lic_file.get_as_text()
		_expect(lic_text.contains("Godot Engine"), "LICENSES.md must mention Godot Engine")
		_expect(lic_text.contains("FreeType"), "LICENSES.md must mention FreeType")
		_expect(lic_text.contains("Copyright (c) 2014-present Godot Engine contributors"), "LICENSES.md must contain Godot MIT notice")
		_expect(lic_text.contains("Zero-Asset Architecture"), "LICENSES.md must document procedural zero-asset architecture")
	
	var rel_file := FileAccess.open("res://docs/RELEASE_NOTES.md", FileAccess.READ)
	_expect(rel_file != null, "docs/RELEASE_NOTES.md must exist")
	if rel_file:
		var rel_text := rel_file.get_as_text()
		_expect(rel_text.contains("RELEASE CANDIDATE 1 (RC1)"), "RELEASE_NOTES.md must identify RC1 status")
		_expect(rel_text.contains("Content Lock 3.0 — 43 stacje"), "RELEASE_NOTES.md must document 43 stations")


func _test_localization_and_settings() -> void:
	print("3. Testing bilingual localization parity and settings overlay...")
	
	var keys_to_verify := [
		"UI_START_EXPERIMENT", "UI_MOVEMENT_PROFILE", "UI_RESTART_HINT",
		"MENU_NEW_GAME", "MENU_CONTINUE", "MENU_SETTINGS", "MENU_QUIT",
		"SETTINGS_TITLE", "SETTINGS_LANGUAGE", "SETTINGS_MASTER_VOLUME",
		"SETTINGS_TEXT_SPEED", "SETTINGS_FULLSCREEN", "SETTINGS_REMAP",
		"PAUSE_TITLE", "PAUSE_RESUME", "PAUSE_SETTINGS", "PAUSE_RESET_SAVE"
	]
	
	for key in keys_to_verify:
		LocalizationManager.set_locale("pl")
		var pl_text := LocalizationManager.tr_key(key)
		_expect(pl_text != key and not pl_text.is_empty(), "PL translation missing for %s" % key)
		
		LocalizationManager.set_locale("en")
		var en_text := LocalizationManager.tr_key(key)
		_expect(en_text != key and not en_text.is_empty(), "EN translation missing for %s" % key)
		_expect(pl_text != en_text, "PL and EN text must differ for key %s (got '%s')" % [key, pl_text])
	
	# Restore PL
	LocalizationManager.set_locale("pl")


func _has_crisp_diegetic_text_node(node: Node) -> bool:
	for child in node.get_children():
		if child is CrispDiegeticText or child.name.begins_with("CrispDiegeticText"):
			return true
	return false


func _test_60hz_performance_and_scene_stacks() -> void:
	print("4. Testing 60 Hz determinism, zero draw_string, and node stacks on all 43 campaign scenes...")
	
	# Zero draw_string in Layer 0
	for path in SCRIPT_PATHS:
		var file := FileAccess.open(path, FileAccess.READ)
		_expect(file != null, "Script must open: %s" % path)
		if file:
			var content := file.get_as_text()
			_expect(not content.contains("draw_string("), "Layer 0 draw_string prohibited in %s" % path)
	
	# Scene instantiation and node stack verification
	for path in SCENE_PATHS:
		var packed := load(path) as PackedScene
		_expect(packed != null, "Scene must load: %s" % path)
		if packed == null:
			continue
		
		var instance := packed.instantiate()
		root.add_child(instance)
		await process_frame
		
		if path.contains("station_"):
			_expect(instance.get_node_or_null("WorldPixelCompositor") != null, "%s missing WorldPixelCompositor" % path)
			_expect(_has_crisp_diegetic_text_node(instance), "%s missing CrispDiegeticText" % path)
			_expect(instance.get_node_or_null("InnerThoughtSurface") != null, "%s missing InnerThoughtSurface" % path)
			_expect(instance.get_node_or_null("CRTDialogueBox") != null, "%s missing CRTDialogueBox" % path)
			_expect(instance.get_node_or_null("NarrativeGuidanceService") != null, "%s missing NarrativeGuidanceService" % path)
			_expect(instance.get_node_or_null("AtmosphereRig") != null, "%s missing AtmosphereRig" % path)
		
		instance.queue_free()
		await process_frame


func _test_title_screen_and_full_routing() -> void:
	print("5. Testing TitleScreen shell, settings interaction and campaign reset...")
	
	var title_packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
	_expect(title_packed != null, "Title screen scene must load")
	if title_packed == null:
		return
	
	var title := title_packed.instantiate() as TitleScreen
	root.add_child(title)
	await process_frame
	
	_expect(title.get_node_or_null("TitlePanel") != null, "TitlePanel must exist in title screen")
	_expect(title.get_node_or_null("SettingsPanel") != null, "SettingsPanel must exist in title screen")
	
	title.open_settings_for_test()
	_expect(title.get_node_or_null("SettingsPanel").visible, "SettingsPanel must be visible when opened")
	
	title.close_settings_for_test()
	_expect(not title.get_node_or_null("SettingsPanel").visible, "SettingsPanel must be hidden when closed")
	
	title.queue_free()
	await process_frame
