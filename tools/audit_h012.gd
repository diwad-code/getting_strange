extends SceneTree

## PKG-0108 / H-012: deterministic Vector-Stage raster audit.
##
## Run with the normal Windows display driver, not --headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/audit_h012.gd
##
## This tool measures rendered pixels only. It does not claim human readability,
## comprehension, fun, emotion or playtest evidence.

const PACKAGE_ID := "PKG-0108"
const LOGICAL_SIZE := Vector2i(640, 360)
const OUTPUT_ROOT := "res://reports/pkg_0108"
const COLOR_TOLERANCE := 0.10

const CASES: Array[Dictionary] = [
	{"id": "station_01", "path": "res://scenes/levels/station_01.tscn", "group": "opening", "ui": true},
	{"id": "station_14", "path": "res://scenes/levels/station_14.tscn", "group": "middle_anchor", "ui": false},
	{"id": "station_22", "path": "res://scenes/levels/station_22.tscn", "group": "middle_yield", "ui": true},
	{"id": "station_38", "path": "res://scenes/levels/station_38.tscn", "group": "mechanical_slice", "ui": false},
	{"id": "station_41", "path": "res://scenes/levels/station_41.tscn", "group": "choice_chamber", "ui": false},
	{"id": "station_42a", "path": "res://scenes/levels/station_42a.tscn", "group": "final_return", "ui": false},
	{"id": "station_42b", "path": "res://scenes/levels/station_42b.tscn", "group": "final_reconciliation", "ui": false},
	{"id": "station_42c", "path": "res://scenes/levels/station_42c.tscn", "group": "final_testimony", "ui": false},
	{"id": "station_43", "path": "res://scenes/levels/station_43.tscn", "group": "epilogue", "ui": true},
]

var _failures: Array[String] = []
var _measurements: Array[Dictionary] = []
var _scale_results: Array[Dictionary] = []
var _transform_results: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = LOGICAL_SIZE
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	if DirAccess.make_dir_recursive_absolute(output_dir) != OK:
		push_error(PACKAGE_ID + ": cannot create " + output_dir)
		quit(1)
		return

	_write_metadata()
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.campaign_auto_transition_enabled = false
		state.reset_campaign(true)

	for case_data in CASES:
		await _capture_case(case_data, false)
		if bool(case_data["ui"]):
			await _capture_case(case_data, true)

	if state:
		state.campaign_auto_transition_enabled = true
		state.reset_campaign(true)

	_write_measurement_files()
	if _failures.is_empty():
		print("PKG-0108 AUDIT PASS: %d frame captures, %d raster measurements, %d scale checks" % [
			_measurement_frame_count(), _measurements.size(), _scale_results.size()
		])
		quit(0)
	else:
		for failure in _failures:
			print("PKG-0108 AUDIT FAILURE: " + failure)
		quit(1)


func _capture_case(case_data: Dictionary, show_dialogue: bool) -> void:
	var path: String = case_data["path"]
	var packed := load(path) as PackedScene
	if packed == null:
		_failures.append("cannot load scene: " + path)
		return
	var station := packed.instantiate() as Node2D
	if station == null:
		_failures.append("scene root is not Node2D: " + path)
		return
	root.add_child(station)
	for _frame in range(12):
		await process_frame

	_apply_control_pose(station, String(case_data["id"]))
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	station.set("dialogue_active", false)
	if show_dialogue:
		if dialogue:
			dialogue.show()
			dialogue.present([{"speaker": "Lena", "text": "POMIAR H-012 // RASTR 640x360"}])
	else:
		if dialogue:
			dialogue.hide()
	station.queue_redraw()
	for _frame in range(8):
		await process_frame
	await RenderingServer.frame_post_draw

	var texture := root.get_texture()
	var image: Image = texture.get_image() if texture else null
	if image == null:
		_failures.append("viewport image is null: " + path)
	else:
		if image.get_size() != LOGICAL_SIZE:
			_failures.append("unexpected viewport size %s for %s" % [image.get_size(), path])
		var frame_kind := "ui" if show_dialogue else "world"
		var frame_id := String(case_data["id"]) + "_" + frame_kind
		var frame_dir := OUTPUT_ROOT.path_join(frame_kind)
		_save_png(image, frame_dir.path_join(String(case_data["id"]) + ".png"), frame_id)
		_measure_frame(image, frame_id, String(case_data["id"]), frame_kind, case_data)
		_write_scale_variants(image, frame_id, frame_dir)
		_write_transform_variants(image, frame_id, frame_dir)

	station.queue_free()
	await process_frame


func _apply_control_pose(station: Node2D, case_id: String) -> void:
	# Only the already-established PKG-0107 finale inspection pose is applied.
	# Other scenes remain at their deterministic initial state so this audit does
	# not exercise or mutate gameplay contracts.
	match case_id:
		"station_42a":
			station.set("is_exit_unlocked", true)
			station.set("is_cups_inspected", true)
		"station_42b":
			station.set("is_exit_unlocked", true)
			station.set("is_doorstep_inspected", true)
		"station_42c":
			station.set("is_exit_unlocked", true)
			station.set("is_tram_inspected", true)
		"station_43":
			station.set("is_exit_unlocked", true)
			station.set("is_notice_inspected", true)
			station.set("is_credits_inspected", true)
			station.set("is_blackout_inspected", true)


func _build_specs(case_id: String, is_ui: bool) -> Array[Dictionary]:
	var specs: Array[Dictionary] = [
		{
			"name": "route",
			"rect": Rect2(0.0, 260.0, 640.0, 40.0),
			"target": VectorStageStyle.LIGHT_PLANE,
		},
		{
			"name": "plan_boundary",
			"rect": Rect2(0.0, 30.0, 640.0, 230.0),
			"target": VectorStageStyle.LIGHT_PLANE,
		},
		{
			"name": "lena_silhouette_amber",
			"rect": Rect2(36.0, 210.0, 90.0, 100.0),
			"target": VectorStageStyle.HUMAN_AMBER,
		},
	]
	match case_id:
		"station_01":
			specs.append({"name": "correction_accent", "rect": Rect2(540.0, 140.0, 80.0, 150.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(345.0, 115.0, 40.0, 100.0), "target": VectorStageStyle.ANCHOR_CYAN, "mode": "cyan_family"})
		"station_14":
			specs.append({"name": "correction_accent", "rect": Rect2(230.0, 60.0, 90.0, 230.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(420.0, 220.0, 110.0, 50.0), "target": VectorStageStyle.HUMAN_AMBER, "mode": "amber_family"})
		"station_22":
			specs.append({"name": "correction_accent", "rect": Rect2(330.0, 35.0, 230.0, 250.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(280.0, 65.0, 270.0, 45.0), "target": VectorStageStyle.HUMAN_AMBER, "mode": "amber_family"})
		"station_38":
			specs.append({"name": "correction_accent", "rect": Rect2(190.0, 130.0, 180.0, 125.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(455.0, 45.0, 35.0, 235.0), "target": VectorStageStyle.ANCHOR_CYAN, "mode": "cyan_family"})
		"station_41":
			specs.append({"name": "correction_accent", "rect": Rect2(410.0, 190.0, 80.0, 80.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(190.0, 190.0, 80.0, 80.0), "target": VectorStageStyle.ANCHOR_CYAN, "mode": "cyan_family"})
		"station_42a":
			specs.append({"name": "correction_accent", "rect": Rect2(400.0, 80.0, 120.0, 150.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(420.0, 195.0, 200.0, 50.0), "target": VectorStageStyle.ANCHOR_CYAN, "mode": "cyan_family"})
		"station_42b":
			specs.append({"name": "correction_accent", "rect": Rect2(200.0, 170.0, 210.0, 100.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(390.0, 210.0, 220.0, 30.0), "target": VectorStageStyle.ANCHOR_CYAN, "mode": "cyan_family"})
		"station_42c":
			specs.append({"name": "correction_accent", "rect": Rect2(500.0, 200.0, 120.0, 50.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(145.0, 100.0, 300.0, 45.0), "target": VectorStageStyle.ANCHOR_CYAN, "mode": "cyan_family"})
		"station_43":
			specs.append({"name": "correction_accent", "rect": Rect2(200.0, 195.0, 250.0, 40.0), "target": VectorStageStyle.CORRECTION_OXIDE, "mode": "oxide_family"})
			specs.append({"name": "state_accent", "rect": Rect2(460.0, 80.0, 140.0, 125.0), "target": VectorStageStyle.ANCHOR_CYAN, "mode": "cyan_family"})
	if is_ui:
		specs.append({"name": "crt_frame", "rect": Rect2(24.0, 238.0, 592.0, 102.0), "target": VectorStageStyle.LIGHT_PLANE})
	return specs


func _measure_frame(image: Image, frame_id: String, case_id: String, frame_kind: String, case_data: Dictionary) -> void:
	for spec in _build_specs(case_id, frame_kind == "ui"):
		var rect: Rect2 = spec["rect"]
		var target: Color = spec["target"]
		var match_mode := String(spec.get("mode", "exact"))
		var measurement := _measure_mask(image, rect, target, match_mode)
		measurement["package"] = PACKAGE_ID
		measurement["frame_id"] = frame_id
		measurement["case_id"] = case_id
		measurement["group"] = String(case_data["group"])
		measurement["frame_kind"] = frame_kind
		measurement["element"] = String(spec["name"])
		measurement["source_rect_x"] = rect.position.x
		measurement["source_rect_y"] = rect.position.y
		measurement["source_rect_width"] = rect.size.x
		measurement["source_rect_height"] = rect.size.y
		measurement["target_color"] = target.to_html(false)
		measurement["match_mode"] = match_mode
		_measurements.append(measurement)
	print("PKG-0108 MEASURE: " + frame_id)


func _measure_mask(image: Image, rect: Rect2, target: Color, match_mode: String) -> Dictionary:
	var x0 := maxi(0, int(floor(rect.position.x)))
	var y0 := maxi(0, int(floor(rect.position.y)))
	var x1 := mini(image.get_width(), int(ceil(rect.end.x)))
	var y1 := mini(image.get_height(), int(ceil(rect.end.y)))
	var mask_count := 0
	var context_count := 0
	var mask_luma := 0.0
	var context_luma := 0.0
	var min_x := x1
	var min_y := y1
	var max_x := -1
	var max_y := -1
	var centroid_x := 0.0
	var centroid_y := 0.0

	for y in range(y0, y1):
		for x in range(x0, x1):
			var color := image.get_pixel(x, y)
			var luminance := _luminance(color)
			if _matches_color(color, target, match_mode):
				mask_count += 1
				mask_luma += luminance
				centroid_x += float(x)
				centroid_y += float(y)
				min_x = mini(min_x, x)
				min_y = mini(min_y, y)
				max_x = maxi(max_x, x)
				max_y = maxi(max_y, y)
			else:
				context_count += 1
				context_luma += luminance

	var result := {
		"status": "MEASURED" if mask_count > 0 else "ABSENT",
		"mask_pixels": mask_count,
		"region_pixels": maxi(0, (x1 - x0) * (y1 - y0)),
		"bbox_x": min_x if mask_count > 0 else -1,
		"bbox_y": min_y if mask_count > 0 else -1,
		"bbox_width": (max_x - min_x + 1) if mask_count > 0 else 0,
		"bbox_height": (max_y - min_y + 1) if mask_count > 0 else 0,
		"centroid_x": centroid_x / float(mask_count) if mask_count > 0 else -1.0,
		"centroid_y": centroid_y / float(mask_count) if mask_count > 0 else -1.0,
		"mean_luma": mask_luma / float(mask_count) if mask_count > 0 else -1.0,
		"context_luma": context_luma / float(context_count) if context_count > 0 else -1.0,
		"contrast_ratio": _contrast_ratio(mask_luma / float(mask_count), context_luma / float(context_count)) if mask_count > 0 and context_count > 0 else -1.0,
	}
	return result


func _write_scale_variants(image: Image, frame_id: String, frame_dir: String) -> void:
	for scale in range(1, 5):
		var scaled := image.duplicate()
		if scale > 1:
			scaled.resize(LOGICAL_SIZE.x * scale, LOGICAL_SIZE.y * scale, Image.INTERPOLATE_NEAREST)
		var path := frame_dir.path_join(frame_id.trim_suffix("_world").trim_suffix("_ui") + "_scale_%dx.png" % scale)
		_save_png(scaled, path, frame_id + "_scale_%dx" % scale)
		var mismatch := _nearest_neighbor_mismatch(image, scaled, scale)
		_scale_results.append({
			"frame_id": frame_id,
			"scale": scale,
			"width": scaled.get_width(),
			"height": scaled.get_height(),
			"interpolation": "nearest",
			"nearest_neighbor_mismatch": mismatch,
		})


func _nearest_neighbor_mismatch(source: Image, scaled: Image, scale: int) -> int:
	if scale == 1:
		return 0
	var mismatches := 0
	for source_y in range(source.get_height()):
		for source_x in range(source.get_width()):
			var expected := source.get_pixel(source_x, source_y)
			for offset_y in range(scale):
				for offset_x in range(scale):
					var actual := scaled.get_pixel(source_x * scale + offset_x, source_y * scale + offset_y)
					if not actual.is_equal_approx(expected):
						mismatches += 1
	return mismatches


func _write_transform_variants(image: Image, frame_id: String, frame_dir: String) -> void:
	for variant in ["grayscale", "deuteranopia", "protanopia"]:
		var transformed := image.duplicate()
		for y in range(transformed.get_height()):
			for x in range(transformed.get_width()):
				var source_color := image.get_pixel(x, y)
				transformed.set_pixel(x, y, _transform_color(source_color, variant))
		var path := frame_dir.path_join(frame_id.trim_suffix("_world").trim_suffix("_ui") + "_" + variant + ".png")
		_save_png(transformed, path, frame_id + "_" + variant)
		_transform_results.append({
			"frame_id": frame_id,
			"variant": variant,
			"width": transformed.get_width(),
			"height": transformed.get_height(),
			"path": path,
		})


func _transform_color(color: Color, variant: String) -> Color:
	if variant == "grayscale":
		var gray := _luminance(color)
		return Color(gray, gray, gray, color.a)
	var r := color.r
	var g := color.g
	var b := color.b
	var transformed_r := r
	var transformed_g := g
	var transformed_b := b
	if variant == "deuteranopia":
		# Published confusion-line approximation, applied as a technical raster
		# transform; this is not a clinical colour-vision assessment.
		transformed_r = 0.367322 * r + 0.860646 * g - 0.227968 * b
		transformed_g = 0.280085 * r + 0.672501 * g + 0.047413 * b
		transformed_b = -0.011820 * r + 0.042940 * g + 0.968881 * b
	else:
		# Published confusion-line approximation, applied as a technical raster
		# transform; this is not a clinical colour-vision assessment.
		transformed_r = 0.152286 * r + 1.052583 * g - 0.204868 * b
		transformed_g = 0.114503 * r + 0.786281 * g + 0.099216 * b
		transformed_b = -0.003882 * r - 0.048116 * g + 1.051998 * b
	return Color(clampf(transformed_r, 0.0, 1.0), clampf(transformed_g, 0.0, 1.0), clampf(transformed_b, 0.0, 1.0), color.a)


func _matches_color(actual: Color, target: Color, match_mode: String) -> bool:
	if match_mode == "oxide_family":
		return actual.r > 0.15 and actual.r >= actual.g + 0.08 and actual.r >= actual.b + 0.07 and absf(actual.g - actual.b) <= 0.12
	if match_mode == "cyan_family":
		return actual.g > 0.20 and actual.g >= actual.r + 0.14 and actual.b >= actual.r + 0.14
	if match_mode == "amber_family":
		return actual.r > 0.22 and actual.g > 0.20 and actual.r >= actual.b + 0.10 and actual.g >= actual.b + 0.10
	return absf(actual.r - target.r) <= COLOR_TOLERANCE and absf(actual.g - target.g) <= COLOR_TOLERANCE and absf(actual.b - target.b) <= COLOR_TOLERANCE


func _luminance(color: Color) -> float:
	var red := _srgb_to_linear(color.r)
	var green := _srgb_to_linear(color.g)
	var blue := _srgb_to_linear(color.b)
	return 0.2126 * red + 0.7152 * green + 0.0722 * blue


func _srgb_to_linear(value: float) -> float:
	return value / 12.92 if value <= 0.04045 else pow((value + 0.055) / 1.055, 2.4)


func _contrast_ratio(first: float, second: float) -> float:
	var bright := maxf(first, second)
	var dark := minf(first, second)
	return (bright + 0.05) / (dark + 0.05)


func _save_png(image: Image, project_path: String, label: String) -> void:
	var global_path := ProjectSettings.globalize_path(project_path)
	var parent := global_path.get_base_dir()
	DirAccess.make_dir_recursive_absolute(parent)
	if image.save_png(global_path) != OK:
		_failures.append("cannot save " + label + ": " + global_path)


func _write_metadata() -> void:
	var metadata := {
		"package": PACKAGE_ID,
		"tool": "res://tools/audit_h012.gd",
		"engine": Engine.get_version_info(),
		"viewport": {"width": LOGICAL_SIZE.x, "height": LOGICAL_SIZE.y},
		"driver_requirement": "normal Windows display driver / OpenGL; not headless",
		"color_tolerance": COLOR_TOLERANCE,
		"luminance": "sRGB to linear, 0.2126R + 0.7152G + 0.0722B",
		"contrast": "(Lmax + 0.05) / (Lmin + 0.05)",
		"scale_interpolation": "Image.INTERPOLATE_NEAREST",
		"transformations": ["grayscale", "deuteranopia", "protanopia"],
		"cases": CASES,
	}
	_write_text(OUTPUT_ROOT.path_join("metadata.json"), JSON.stringify(metadata, "\t"))


func _write_measurement_files() -> void:
	_write_text(OUTPUT_ROOT.path_join("measurements.json"), JSON.stringify({
		"package": PACKAGE_ID,
		"measurements": _measurements,
		"scales": _scale_results,
		"transforms": _transform_results,
	}, "\t"))
	var rows: Array[String] = [
		"frame_id\tcase_id\tgroup\tframe_kind\telement\tstatus\tmask_pixels\tregion_pixels\tbbox_x\tbbox_y\tbbox_width\tbbox_height\tcentroid_x\tcentroid_y\tmean_luma\tcontext_luma\tcontrast_ratio\ttarget_color\tmatch_mode"
	]
	for row in _measurements:
		rows.append("%s\t%s\t%s\t%s\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%.3f\t%.3f\t%.5f\t%.5f\t%.5f\t%s\t%s" % [
			row["frame_id"], row["case_id"], row["group"], row["frame_kind"], row["element"], row["status"], row["mask_pixels"], row["region_pixels"], row["bbox_x"], row["bbox_y"], row["bbox_width"], row["bbox_height"], row["centroid_x"], row["centroid_y"], row["mean_luma"], row["context_luma"], row["contrast_ratio"], row["target_color"], row["match_mode"],
		])
	_write_text(OUTPUT_ROOT.path_join("measurements.tsv"), "\n".join(rows) + "\n")


func _write_text(project_path: String, content: String) -> void:
	var global_path := ProjectSettings.globalize_path(project_path)
	DirAccess.make_dir_recursive_absolute(global_path.get_base_dir())
	var file := FileAccess.open(global_path, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write " + global_path)
		return
	file.store_string(content)
	file.close()


func _measurement_frame_count() -> int:
	var frame_ids: Dictionary = {}
	for row in _measurements:
		frame_ids[row["frame_id"]] = true
	return frame_ids.size()
