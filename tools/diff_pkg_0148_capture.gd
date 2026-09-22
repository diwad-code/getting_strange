extends SceneTree

## PKG-0148 capture comparison evidence (headless-safe).
## Verifies every normal/reduced frame is readable, non-blank and 640x360,
## then requires each diagnostic state pair to differ by more than 50 samples.

const ROOT_DIR := "res://reports/pkg_0148"
const REPORT_PATH := "res://reports/pkg_0148_capture_diff_report.txt"
const SIZE := Vector2i(640, 360)
const DISTINCT_SAMPLE_MIN := 50
const NONBLANK_CONTENT_MIN := 1.0

const FRAMES: Array[String] = [
	"station_26_interrupted_log.png",
	"station_26_intervention_reconstructed.png",
	"station_27_identical_pulse_pair.png",
	"station_27_error_correction_compared.png",
	"station_28_price_disclosed.png",
	"station_28_home_trace_anchored.png",
	"station_28_shared_drift_yielded.png",
	"station_29_boundary_evidence.png",
	"station_29_consent_refused.png",
	"station_30_three_forecasts.png",
	"station_30_dependencies_compared.png",
]

const STATE_PAIRS: Array[Dictionary] = [
	{"a": "normal/station_26_interrupted_log.png", "b": "normal/station_26_intervention_reconstructed.png", "label": "S09 log vs reconstruction"},
	{"a": "normal/station_27_identical_pulse_pair.png", "b": "normal/station_27_error_correction_compared.png", "label": "S09 pair vs correction"},
	{"a": "normal/station_28_price_disclosed.png", "b": "normal/station_28_home_trace_anchored.png", "label": "S09 price vs Anchor"},
	{"a": "normal/station_28_price_disclosed.png", "b": "normal/station_28_shared_drift_yielded.png", "label": "S09 price vs Yield"},
	{"a": "normal/station_28_home_trace_anchored.png", "b": "normal/station_28_shared_drift_yielded.png", "label": "S09 Anchor vs Yield"},
	{"a": "normal/station_29_boundary_evidence.png", "b": "normal/station_29_consent_refused.png", "label": "S10 boundary vs refusal"},
	{"a": "normal/station_30_three_forecasts.png", "b": "normal/station_30_dependencies_compared.png", "label": "S10 forecasts vs dependency map"},
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
	return {
		"changed": changed,
		"sampled": sampled,
		"mean_delta": sum_delta / float(sampled) if sampled > 0 else 0.0,
		"max_delta": max_delta,
	}


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
			paths.append(String(mode).path_join(frame))
	return paths


func _run() -> void:
	var lines: Array[String] = []
	lines.append("PKG-0148 CAPTURE DIFF REPORT")
	lines.append("Programmatic frame evidence only. No line claims comprehension, appeal, emotion or comfort.")
	lines.append("")
	lines.append("CONTENT CHECK (must be non-blank and 640x360)")
	for path in _all_frame_paths():
		var image := _load(path)
		if image == null:
			continue
		var content_sum := _content(image)
		if content_sum <= NONBLANK_CONTENT_MIN:
			_failures.append("blank frame: " + path)
			lines.append("  %-54s BLANK content_sum=%.1f" % [path, content_sum])
		else:
			lines.append("  %-54s NONBLANK content_sum=%.1f" % [path, content_sum])
	lines.append("")
	lines.append("STATE PAIR DIFFERENCES (DISTINCT requires changed > 50)")
	for pair in STATE_PAIRS:
		var a := _load(pair["a"])
		var b := _load(pair["b"])
		if a == null or b == null:
			continue
		var delta := _diff(a, b)
		var changed := int(delta["changed"])
		if changed > DISTINCT_SAMPLE_MIN:
			lines.append("  %-32s DISTINCT changed=%d mean=%.4f max=%.4f" % [pair["label"], changed, float(delta["mean_delta"]), float(delta["max_delta"])])
		else:
			_failures.append("state pair not distinct: " + String(pair["label"]))
			lines.append("  %-32s NOT DISTINCT changed=%d" % [pair["label"], changed])
	lines.append("")
	lines.append("NORMAL vs REDUCED (reported, not required to differ)")
	for frame in FRAMES:
		var normal := _load("normal/" + frame)
		var reduced := _load("reduced/" + frame)
		if normal == null or reduced == null:
			continue
		var delta := _diff(normal, reduced)
		lines.append("  %-38s changed=%d mean=%.4f max=%.4f" % [frame, int(delta["changed"]), float(delta["mean_delta"]), float(delta["max_delta"])])
	lines.append("")
	lines.append("BOUNDARY")
	lines.append("Diff proves rendered surfaces differ; it does not prove human readability or reception.")
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write " + REPORT_PATH)
	else:
		file.store_string("\n".join(lines) + "\n")
		file.close()
		print("PKG-0148 DIFF REPORT: " + REPORT_PATH)
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0148 DIFF PASS: 22 frames valid and non-blank; all state pairs DISTINCT > 50")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0148 DIFF FAILURE: " + failure)
	quit(1)
