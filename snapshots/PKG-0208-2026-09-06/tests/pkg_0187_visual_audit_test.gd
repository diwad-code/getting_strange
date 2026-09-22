extends SceneTree

## PKG-0187 gate — complete visual-audit evidence and non-primitive cast rules.
## This gate proves coverage, source-level presentation contracts and capture
## metadata. It deliberately does not claim beauty, fun or human readability.

const ACTIVE_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const FAMILY_BY_ID := {
	"station_01": "technical", "station_02": "urban", "station_03": "transit",
	"station_04": "transit", "station_05": "urban", "station_06": "urban",
	"station_07": "urban", "station_08": "residential", "station_09": "residential",
	"station_10": "residential", "station_11": "institutional", "station_12": "technical",
	"station_13": "residential", "station_14": "technical", "station_15": "liminal",
	"station_16": "liminal", "station_17": "institutional", "station_18": "urban",
	"station_42a": "final", "station_42b": "final", "station_42c": "final", "station_43": "final",
}

const CAST_RIGS := {
	"station_06": &"vendor",
	"station_08": &"neighbour",
	"station_10": &"marta",
	"station_11": &"wierzbicka",
	"station_12": &"jakub",
	"station_42b": &"marta",
	"station_42c": &"marta",
}

const AUDIT_PATH := "res://docs/rebuild/PKG_0187_VISUAL_AUDIT.md"
const MATRIX_PATH := "res://reports/pkg_0187/visual_matrix.tsv"
const VISUAL_DIR := "res://reports/pkg_0187/visual"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0187: " + message)


func _run() -> void:
	_test_audit_coverage()
	_test_active_scene_surface_contracts()
	_test_cast_is_rigged()
	_test_finale_has_no_circle_people()
	_test_fresh_windows_capture_evidence()
	_finish()


func _test_audit_coverage() -> void:
	_expect(FAMILY_BY_ID.size() == ACTIVE_IDS.size(), "family map must cover every active scene")
	_expect(FileAccess.file_exists(AUDIT_PATH), "visual audit document must exist")
	if not FileAccess.file_exists(AUDIT_PATH):
		return
	var audit := FileAccess.get_file_as_string(AUDIT_PATH)
	for station_id in ACTIVE_IDS:
		_expect(audit.contains("| %s |" % station_id), "%s must have a visual-audit row")
		_expect(audit.contains("`%s`" % station_id), "%s must name its capture evidence")


func _test_active_scene_surface_contracts() -> void:
	for station_id in ACTIVE_IDS:
		var scene_path := "res://scenes/levels/%s.tscn" % station_id
		var script_path := "res://scripts/levels/%s.gd" % station_id
		_expect(FileAccess.file_exists(scene_path), "%s scene must exist" % station_id)
		_expect(FileAccess.file_exists(script_path), "%s script must exist" % station_id)
		if not FileAccess.file_exists(scene_path) or not FileAccess.file_exists(script_path):
			continue
		var scene_text := FileAccess.get_file_as_string(scene_path)
		var script_text := FileAccess.get_file_as_string(script_path)
		# ThresholdBinder owns the runtime ThresholdZone; AirlockZone remains the
		# authored closure geometry, so the audit must not demand duplicate colliders.
		_expect(scene_text.contains("AirlockZone"), "%s must retain its AirlockZone closure geometry" % station_id)
		_expect(scene_text.contains("crisp_diegetic_text.gd"), "%s labels must use CrispDiegeticText" % station_id)
		_expect(script_text.contains("func _draw"), "%s must own a drawn world surface" % station_id)
		_expect(not script_text.contains("draw_string("), "%s must not put readable text in the pixelated world" % station_id)
		_expect(not script_text.contains("draw_multiline_string("), "%s must not put readable multiline text in the pixelated world" % station_id)


func _test_cast_is_rigged() -> void:
	for station_id in CAST_RIGS:
		var scene_path := "res://scenes/levels/%s.tscn" % station_id
		var character_id: StringName = CAST_RIGS[station_id]
		var scene_text := FileAccess.get_file_as_string(scene_path)
		_expect(scene_text.contains("character_visual_rig.gd"), "%s must use CharacterVisualRig" % station_id)
		_expect(scene_text.contains("character_id = &\"%s\"" % String(character_id)), "%s must carry %s as CharacterVisualRig" % [station_id, character_id])


func _test_finale_has_no_circle_people() -> void:
	var b := FileAccess.get_file_as_string("res://scripts/levels/station_42b.gd")
	var c := FileAccess.get_file_as_string("res://scripts/levels/station_42c.gd")
	_expect(not b.contains("draw_circle(Vector2(332.0, 208.0)"), "42B local Lena must not be a circle-head")
	_expect(not b.contains("draw_line(Vector2(332.0, 214.0), Vector2(332.0, 260.0)"), "42B local Lena must not be a line-body")
	_expect(not c.contains("draw_circle(Vector2(317.0, 208.0)"), "42C first Lena must not be a circle-head")
	_expect(not c.contains("draw_circle(Vector2(347.0, 208.0)"), "42C second Lena must not be a circle-head")
	_expect(not c.contains("draw_line(Vector2(317.0, 213.0), Vector2(317.0, 258.0)"), "42C first Lena must not be a line-body")
	_expect(not c.contains("draw_line(Vector2(347.0, 213.0), Vector2(347.0, 258.0)"), "42C second Lena must not be a line-body")


func _test_fresh_windows_capture_evidence() -> void:
	_expect(FileAccess.file_exists(MATRIX_PATH), "PKG-0187 visual matrix must exist")
	if not FileAccess.file_exists(MATRIX_PATH):
		return
	var matrix := FileAccess.get_file_as_string(MATRIX_PATH)
	for station_id in ACTIVE_IDS:
		for mode in ["normal", "opening_panel", "threshold", "mono"]:
			var frame_path := "%s/%s__%s.png" % [VISUAL_DIR, station_id, mode]
			_expect(FileAccess.file_exists(frame_path), "%s/%s frame must exist" % [station_id, mode])
			if FileAccess.file_exists(frame_path):
				var image := Image.load_from_file(ProjectSettings.globalize_path(frame_path))
				_expect(image != null and image.get_width() == 640 and image.get_height() == 360, "%s/%s must be 640x360" % [station_id, mode])
			_expect(matrix.contains("%s\t%s\t" % [station_id, mode]), "%s/%s must be indexed in visual_matrix.tsv" % [station_id, mode])
	_expect(matrix.contains("\tWindows\t640\t360\t"), "capture matrix must record the normal Windows driver")
	for shell_surface in ["shell_title__pl", "settings__pl", "pause__campaign", "cold_open__initial"]:
		_expect(FileAccess.file_exists("%s/%s.png" % [VISUAL_DIR, shell_surface]), "%s shell capture must exist" % shell_surface)
	for npc_station in CAST_RIGS:
		_expect(FileAccess.file_exists("%s/%s__npc_frame.png" % [VISUAL_DIR, npc_station]), "%s NPC close-up must exist" % npc_station)
	for portrait_id in ["lena", "marta", "jakub", "wierzbicka", "szymon"]:
		_expect(FileAccess.file_exists("%s/panel_portrait__%s.png" % [VISUAL_DIR, portrait_id]), "%s CRT portrait capture must exist" % portrait_id)
	_expect(FileAccess.file_exists("%s/panel_dialogue__marta_then_lena.png" % VISUAL_DIR), "Marta/Lena dialogue capture must exist")
	_expect(FileAccess.file_exists("%s/panel_thought__lena.png" % VISUAL_DIR), "Lena thought capture must exist")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0187 VISUAL AUDIT PASS: full active-route coverage and evidence contracts.")
		quit(0)
	else:
		print("PKG-0187 VISUAL AUDIT FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
