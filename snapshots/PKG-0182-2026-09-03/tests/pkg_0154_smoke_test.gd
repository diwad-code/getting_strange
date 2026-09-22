extends SceneTree

var _failures: Array[String] = []

const EXPECTED_EXCLUDE_PATTERNS: Array[String] = [
	"godot-mcp/*",
	"vibe-eyes/*",
	"tests/*",
	"tools/*",
	"docs/*",
	"reports/*",
	"snapshots/*",
	"logs/*",
	"playtest_panel_*/*",
	"scripts/levels/logs/*",
	"skills/*"
]

const EXPECTED_SCRIPT_SNIPPETS: Array[String] = [
	"Ensure-ExportTemplates",
	"downloads.godotengine.org",
	"windows_release_x86_64.exe",
	"linux_release.x86_64",
	"Forbidden export surface detected",
	"D-125 guard: Binary build blocked."
]

const EXPECTED_TITLE_SNIPPETS: Array[String] = [
	"GS_BOOT_CAPTURE_PATH",
	"GS_AUTOMATION_ACTION",
	"TITLE_SCREEN_CAPTURE",
	"TITLE_SCREEN_AUTOMATION action=new_game",
	"TITLE_SCREEN_AUTOMATION action=continue"
]


func _initialize() -> void:
	call_deferred(&"_run_tests")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0154 FAILURE: %s" % message)


func _run_tests() -> void:
	print("=== PKG-0154 Smoke Test: export rehearsal hardening ===")
	_test_export_preset_quarantine()
	_test_export_script_preflight_and_surface_guard()
	_test_title_screen_release_harness()
	_finish()


func _test_export_preset_quarantine() -> void:
	var export_cfg := ConfigFile.new()
	var err := export_cfg.load("res://export_presets.cfg")
	_expect(err == OK, "export_presets.cfg must load")
	if err != OK:
		return

	for preset_section in ["preset.0", "preset.1"]:
		var exclude_filter := String(export_cfg.get_value(preset_section, "exclude_filter", ""))
		_expect(not exclude_filter.is_empty(), "%s must define an export exclude_filter" % preset_section)
		for pattern in EXPECTED_EXCLUDE_PATTERNS:
			_expect(exclude_filter.contains(pattern), "%s exclude_filter must quarantine %s" % [preset_section, pattern])


func _test_export_script_preflight_and_surface_guard() -> void:
	var export_script := FileAccess.get_file_as_string("res://tools/export_builds.ps1")
	_expect(not export_script.is_empty(), "tools/export_builds.ps1 must exist")
	if export_script.is_empty():
		return
	for snippet in EXPECTED_SCRIPT_SNIPPETS:
		_expect(export_script.contains(snippet), "export_builds.ps1 must contain '%s'" % snippet)



func _test_title_screen_release_harness() -> void:
	var title_script := FileAccess.get_file_as_string("res://scripts/ui/title_screen.gd")
	_expect(not title_script.is_empty(), "scripts/ui/title_screen.gd must exist")
	if title_script.is_empty():
		return
	for snippet in EXPECTED_TITLE_SNIPPETS:
		_expect(title_script.contains(snippet), "title_screen.gd must contain '%s'" % snippet)

func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0154 SMOKE PASS: export preset quarantine and template preflight are enforced")
		quit(0)
		return
	for failure in _failures:
		printerr(" - %s" % failure)
	quit(1)
