extends SceneTree

## PKG-0151 capture comparison evidence (headless-safe).
## Verifies every normal/reduced frame is readable, non-blank and 640x360,
## then requires major campaign-state pairs to differ by more than 50 samples.

const ROOT_DIR := "res://reports/pkg_0151"
const REPORT_PATH := "res://reports/pkg_0151_capture_diff_report.txt"
const SIZE := Vector2i(640, 360)
const DISTINCT_SAMPLE_MIN := 50
const NONBLANK_CONTENT_MIN := 1.0

const FRAMES: Array[String] = [
	"station_01_sample_committed.png",
	"station_04_reader_trial_committed.png",
	"station_08_intercom_completed.png",
	"station_14_threshold_respected.png",
	"station_21_synthesis_executed.png",
	"station_25_paired_with_notes.png",
	"station_28_shared_drift_yielded.png",
	"station_30_dependencies_compared.png",
	"station_33_intent_reconstructed.png",
	"station_36_cost_ledger_revealed.png",
	"station_38_truth_disclosed_full.png",
	"station_41_operation_committed_a.png",
	"station_41_operation_committed_b.png",
	"station_41_operation_committed_c.png",
	"station_42a_chamber_a_witnessed.png",
	"station_42b_chamber_b_witnessed.png",
	"station_42c_chamber_c_witnessed.png",
	"station_43_epilogue_completed.png",
]

const STATE_PAIRS: Array[Dictionary] = [
	{"a": "normal/station_01_sample_committed.png", "b": "normal/station_04_reader_trial_committed.png", "label": "S01 vs S02 committed"},
	{"a": "normal/station_08_intercom_completed.png", "b": "normal/station_14_threshold_respected.png", "label": "S03 vs S05 committed"},
	{"a": "normal/station_21_synthesis_executed.png", "b": "normal/station_25_paired_with_notes.png", "label": "S07 recognition vs S08 buffer"},
	{"a": "normal/station_28_shared_drift_yielded.png", "b": "normal/station_30_dependencies_compared.png", "label": "S09 cost vs S10 forecasts"},
	{"a": "normal/station_33_intent_reconstructed.png", "b": "normal/station_36_cost_ledger_revealed.png", "label": "S11 intent vs S12 ledger"},
	{"a": "normal/station_38_truth_disclosed_full.png", "b": "normal/station_41_operation_committed_a.png", "label": "S13 truth vs S14 method A"},
	{"a": "normal/station_41_operation_committed_a.png", "b": "normal/station_41_operation_committed_b.png", "label": "S14 method A vs B"},
	{"a": "normal/station_41_operation_committed_b.png", "b": "normal/station_41_operation_committed_c.png", "label": "S14 method B vs C"},
	{"a": "normal/station_42a_chamber_a_witnessed.png", "b": "normal/station_42b_chamber_b_witnessed.png", "label": "S15 chamber A vs B"},
	{"a": "normal/station_42b_chamber_b_witnessed.png", "b": "normal/station_42c_chamber_c_witnessed.png", "label": "S15 chamber B vs C"},
	{"a": "normal/station_42c_chamber_c_witnessed.png", "b": "normal/station_43_epilogue_completed.png", "label": "S15 chamber C vs epilogue"},
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _load(path: String) -> Image:
	var file_path := ProjectSettings.globalize_path(ROOT_DIR.path_join(path))
	if not FileAccess.file_exists(file_path):
		_failures.append("missing frame: " + path)
		return null
	var image := Image.load_from_file(file_path)
	if image == null:
		_failures.append("unreadable frame: " + path)
		return null
	if image.get_size() != SIZE:
		_failures.append("wrong frame size: %s is %s" % [path, image.get_size()])
		return null
	return image


func _diff(a: Image, b: Image) -> Dictionary:
	var changed := 0
	var sampled := 0
	var max_delta := 0.0
	var sum_delta := 0.0
	for y in range(0, a.get_height(), 2):
		for x in range(0, a.get_width(), 2):
			var pa := a.get_pixel(x, y)
			var pb := b.get_pixel(x, y)
			var delta := absf(pa.r - pb.r) + absf(pa.g - pb.g) + absf(pa.b - pb.b)
			sampled += 1
			sum_delta += delta
			max_delta = maxf(max_delta, delta)
			if delta > 0.02:
				changed += 1
	return {"changed": changed, "sampled": sampled, "mean_delta": sum_delta / float(sampled) if sampled > 0 else 0.0, "max_delta": max_delta}


func _content(image: Image) -> float:
	var sum := 0.0
	for y in range(0, image.get_height(), 8):
		for x in range(0, image.get_width(), 8):
			var pixel := image.get_pixel(x, y)
			sum += pixel.r + pixel.g + pixel.b
	return sum


func _all_frame_paths() -> Array[String]:
	var paths: Array[String] = []
	for mode in ["normal", "reduced"]:
		for frame in FRAMES:
			paths.append("%s/%s" % [mode, frame])
	return paths


func _run() -> void:
	print("=== PKG-0151 Visual Diff Certification ===")
	var lines: Array[String] = []
	lines.append("PKG-0151 visual capture diff report")
	lines.append("Generated at: " + Time.get_datetime_string_from_system())
	lines.append("")
	var images: Dictionary = {}
	for path in _all_frame_paths():
		var image := _load(path)
		if image != null:
			var content := _content(image)
			if content < NONBLANK_CONTENT_MIN:
				_failures.append("blank or near-black frame: %s (content score %.2f)" % [path, content])
			images[path] = image
	lines.append("=== Visual State Comparison ===")
	for pair in STATE_PAIRS:
		var a_path: String = pair["a"]
		var b_path: String = pair["b"]
		if not images.has(a_path) or not images.has(b_path):
			continue
		var result := _diff(images[a_path], images[b_path])
		lines.append(" - %s: changed_samples=%d mean_delta=%.4f" % [pair["label"], int(result["changed"]), float(result["mean_delta"])])
		if int(result["changed"]) < DISTINCT_SAMPLE_MIN:
			_failures.append("state pair '%s' lacks visual distinction" % String(pair["label"]))
	lines.append("")
	lines.append("=== Normal vs Reduced Motion Comparison ===")
	for frame in FRAMES:
		var normal_path := "normal/" + frame
		var reduced_path := "reduced/" + frame
		if not images.has(normal_path) or not images.has(reduced_path):
			continue
		var result := _diff(images[normal_path], images[reduced_path])
		lines.append(" - %s: changed_samples=%d mean_delta=%.4f" % [frame, int(result["changed"]), float(result["mean_delta"])])
	var report := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if report != null:
		report.store_string("\n".join(lines) + "\n")
		report.close()
	if _failures.is_empty():
		print("PKG-0151 Visual Diff Certification: PASS")
		quit(0)
	else:
		printerr("PKG-0151 Visual Diff Certification: FAIL (%d errors)" % _failures.size())
		for failure in _failures:
			printerr(" - " + failure)
		quit(1)
