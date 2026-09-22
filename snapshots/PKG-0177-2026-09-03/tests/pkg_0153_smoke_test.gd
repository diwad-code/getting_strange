extends SceneTree

var _failures: Array[String] = []

const EXPECTED_LICENSE_LINES: Array[String] = [
	"LICENCJE // MANIFEST RUNTIME",
	"AUDIO: ZERO-ASSET SYNTH",
	"ŚWIAT: PROCEDURAL PIXEL-STAGE",
	"LENA 4.1: 22 PNG 64x104",
	"PORTRETY CRT: 5 PNG",
	"GODOT 4.7.2 (MIT)"
]

const EXPECTED_CREDITS_LINES: Array[String] = [
	"CREDITS // PRODUCTION",
	"GETTING STRANGE",
	"LEAD PROGRAMMER & ART DIRECTOR",
	"KANON FABUŁY 0.3",
	"RENDER: PIXEL-STAGE 640x360",
	"AUDIO: PROCEDURAL WAVEFORM SYNTH",
	"PL / EN SHELL // SUBTITLES"
]


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0153 FAILURE: %s" % message)


func _run_tests() -> void:
	print("=== PKG-0153 Smoke Test: P8 runtime release surface ===")
	_test_version_sync_between_project_and_export_presets()
	await _test_title_screen_runtime_version_label()
	await _test_station_43_release_surface()
	_finish()


func _test_version_sync_between_project_and_export_presets() -> void:
	var version := String(ProjectSettings.get_setting("application/config/version", ""))
	_expect(not version.is_empty(), "Project version must not be empty")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_width") == 640, "Viewport width must remain 640")
	_expect(ProjectSettings.get_setting("display/window/size/viewport_height") == 360, "Viewport height must remain 360")

	var export_cfg := ConfigFile.new()
	var err := export_cfg.load("res://export_presets.cfg")
	_expect(err == OK, "export_presets.cfg must load")
	if err != OK:
		return
	_expect(String(export_cfg.get_value("preset.0.options", "application/file_version", "")) == version, "Windows file_version must match ProjectSettings version")
	_expect(String(export_cfg.get_value("preset.0.options", "application/product_version", "")) == version, "Windows product_version must match ProjectSettings version")
	_expect(String(export_cfg.get_value("preset.0.options", "application/version", "")) == version, "Windows application/version must match ProjectSettings version")
	_expect(String(export_cfg.get_value("preset.0", "export_path", "")) == "dist/windows/GettingStrange.exe", "Windows preset path must remain stable")
	_expect(String(export_cfg.get_value("preset.1", "export_path", "")) == "dist/linux/GettingStrange.x86_64", "Linux preset path must remain stable")


func _test_title_screen_runtime_version_label() -> void:
	var original_locale := LocalizationManager.get_locale()
	var version := String(ProjectSettings.get_setting("application/config/version", ""))
	var viewport_width := int(ProjectSettings.get_setting("display/window/size/viewport_width", 640))
	var viewport_height := int(ProjectSettings.get_setting("display/window/size/viewport_height", 360))
	var physics_hz := int(Engine.physics_ticks_per_second)

	var title_packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
	_expect(title_packed != null, "Title screen scene must load")
	if title_packed == null:
		LocalizationManager.set_locale(original_locale)
		return

	var title := title_packed.instantiate() as TitleScreen
	_expect(title != null, "Title screen must instantiate as TitleScreen")
	if title == null:
		LocalizationManager.set_locale(original_locale)
		return

	root.add_child(title)
	await process_frame

	var build_label := title.get_node_or_null("TitlePanel/BuildLabel") as Label
	_expect(build_label != null, "Title screen must expose BuildLabel")
	if build_label != null:
		var pl_text := build_label.text
		_expect(pl_text.contains(version), "PL build label must contain ProjectSettings version")
		_expect(pl_text.contains("%dx%d" % [viewport_width, viewport_height]), "PL build label must contain logical viewport")
		_expect(pl_text.contains(str(physics_hz)), "PL build label must contain physics tick rate")

		LocalizationManager.set_locale("en")
		title.refresh_for_test()
		await process_frame
		var en_text := build_label.text
		_expect(en_text.contains(version), "EN build label must contain ProjectSettings version")
		_expect(en_text.contains("%dx%d" % [viewport_width, viewport_height]), "EN build label must contain logical viewport")
		_expect(en_text.contains(str(physics_hz)), "EN build label must contain physics tick rate")
		_expect(en_text != pl_text, "Build label must localize between PL and EN")

	LocalizationManager.set_locale(original_locale)
	title.refresh_for_test()
	title.queue_free()
	await process_frame


func _test_station_43_release_surface() -> void:
	var licenses_text := FileAccess.get_file_as_string("res://docs/LICENSES.md")
	_expect(licenses_text.contains("Proceduralny dźwięk (Zero-Asset SFX)"), "LICENSES.md must preserve the zero-asset audio manifest")
	_expect(licenses_text.contains("Proceduralna scenografia i świat Pixel-Stage"), "LICENSES.md must preserve the procedural world manifest")
	_expect(licenses_text.contains("assets/characters/lena/"), "LICENSES.md must preserve Lena runtime asset path")
	_expect(licenses_text.contains("assets/characters/portraits/"), "LICENSES.md must preserve portrait runtime asset path")
	_expect(licenses_text.contains("Godot Engine v4.7.2.stable.official.ed1daf0bf"), "LICENSES.md must preserve the verified engine build")

	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist for Station 43 release surface audit")
	if state != null:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	var station_packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	_expect(station_packed != null, "Station 43 scene must load")
	if station_packed == null:
		return

	var station := station_packed.instantiate() as Station43
	_expect(station != null, "Station 43 must instantiate as Station43")
	if station == null:
		return

	root.add_child(station)
	await process_frame
	await physics_frame

	var license_manifest := station.get_node_or_null("CrispDiegeticText_LicenseManifest") as CrispDiegeticText
	var credits_manifest := station.get_node_or_null("CrispDiegeticText_CreditsManifest") as CrispDiegeticText
	_expect(license_manifest != null, "Station 43 must expose a readable license manifest")
	_expect(credits_manifest != null, "Station 43 must expose a readable credits manifest")
	if license_manifest != null:
		for line in EXPECTED_LICENSE_LINES:
			_expect(license_manifest.text.contains(line), "Station 43 license manifest must contain '%s'" % line)
	if credits_manifest != null:
		for line in EXPECTED_CREDITS_LINES:
			_expect(credits_manifest.text.contains(line), "Station 43 credits manifest must contain '%s'" % line)

	_expect(station.has_method("inspect_notice"), "Station 43 must expose inspect_notice()")
	_expect(station.has_method("inspect_credits"), "Station 43 must expose inspect_credits()")
	if station.has_method("inspect_notice"):
		_expect(bool(station.call("inspect_notice")), "Station 43 notice inspection must succeed")
		_expect(bool(station.get("is_notice_inspected")), "Station 43 must record notice inspection")
		if state != null:
			_expect(state.decisions.get(&"p7.conscious_silence_and_presence.epilogue_noticed", false) == true, "Notice inspection must persist trace state")
	if station.has_method("inspect_credits"):
		_expect(bool(station.call("inspect_credits")), "Station 43 credits inspection must succeed")
		_expect(bool(station.get("is_credits_inspected")), "Station 43 must record credits inspection")
		if state != null:
			_expect(state.decisions.get(&"p7.conscious_silence_and_presence.epilogue_credits_read", false) == true, "Credits inspection must persist trace state")

	station.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0153 SMOKE PASS: runtime release surface, Station 43 manifests and title version sync")
		quit(0)
		return
	for failure in _failures:
		printerr(" - %s" % failure)
	quit(1)
