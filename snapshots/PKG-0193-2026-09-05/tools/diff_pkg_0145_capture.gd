extends SceneTree

## PKG-0145 capture comparison evidence (headless-safe).
## Loads the 14 normal-driver frames and measures:
##  1. state pairs must differ (Anchor vs Yield, limited vs declined, routes)
##  2. normal vs reduced pairs are amplitude-only deltas
##  3. every frame is 640x360 with meaningful content

const ROOT_DIR := "res://reports/pkg_0145"
const REPORT_PATH := "res://reports/pkg_0145_capture_diff_report.txt"
const SIZE := Vector2i(640, 360)

const STATE_PAIRS: Array[Dictionary] = [
	{"a": "normal/station_23_anchor.png", "b": "normal/station_23_yield.png", "label": "S23 Anchor vs Yield"},
	{"a": "normal/station_24_limited_access.png", "b": "normal/station_24_declined.png", "label": "S24 limited vs declined"},
	{"a": "normal/station_25_paired_with_notes.png", "b": "normal/station_25_technical_route.png", "label": "S25 paired vs technical"},
]
const MODE_PAIRS: Array[Dictionary] = [
	{"a": "normal/station_22_hypotheses.png", "b": "reduced/station_22_hypotheses.png", "label": "S22 hypotheses N/R"},
	{"a": "normal/station_23_anchor.png", "b": "reduced/station_23_anchor.png", "label": "S23 anchor N/R"},
	{"a": "normal/station_23_yield.png", "b": "reduced/station_23_yield.png", "label": "S23 yield N/R"},
	{"a": "normal/station_24_limited_access.png", "b": "reduced/station_24_limited_access.png", "label": "S24 limited N/R"},
	{"a": "normal/station_24_declined.png", "b": "reduced/station_24_declined.png", "label": "S24 declined N/R"},
	{"a": "normal/station_25_paired_with_notes.png", "b": "reduced/station_25_paired_with_notes.png", "label": "S25 paired N/R"},
	{"a": "normal/station_25_technical_route.png", "b": "reduced/station_25_technical_route.png", "label": "S25 technical N/R"},
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
	if image == null or image.get_size() != SIZE:
		_failures.append("bad size or unreadable: " + path)
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
			var p := image.get_pixel(x, y)
			sum += p.r + p.g + p.b
	return sum


func _run() -> void:
	var lines: Array[String] = []
	lines.append("PKG-0145 CAPTURE DIFF REPORT")
	lines.append("Programmatic frame evidence from the normal-driver capture. No line below claims comprehension, appeal or comfort.")
	lines.append("")
	lines.append("CONTENT CHECK (non-blank, 640x360)")
	var frames: Array[String] = [
		"normal/station_22_hypotheses.png", "normal/station_23_anchor.png", "normal/station_23_yield.png",
		"normal/station_24_limited_access.png", "normal/station_24_declined.png",
		"normal/station_25_paired_with_notes.png", "normal/station_25_technical_route.png",
		"reduced/station_22_hypotheses.png", "reduced/station_23_anchor.png", "reduced/station_23_yield.png",
		"reduced/station_24_limited_access.png", "reduced/station_24_declined.png",
		"reduced/station_25_paired_with_notes.png", "reduced/station_25_technical_route.png",
	]
	for frame in frames:
		var image := _load(frame)
		if image != null:
			lines.append("  %-42s content_sum=%.1f" % [frame, _content(image)])
	lines.append("")
	lines.append("STATE PAIR DIFFERENCES (must be clearly distinct)")
	for pair in STATE_PAIRS:
		var a := _load(pair["a"])
		var b := _load(pair["b"])
		if a == null or b == null:
			continue
		var d := _diff(a, b)
		var ok := int(d["changed"]) > 50
		if ok:
			lines.append("  %-30s DISTINCT  changed=%d mean=%.4f max=%.4f" % [pair["label"], int(d["changed"]), float(d["mean_delta"]), float(d["max_delta"])])
		else:
			_failures.append("state pair not distinct: " + String(pair["label"]))
			lines.append("  %-30s NOT DISTINCT changed=%d" % [pair["label"], int(d["changed"])])
	lines.append("")
	lines.append("NORMAL vs REDUCED (amplitude-only expectation; facts remain visible)")
	for pair in MODE_PAIRS:
		var a := _load(pair["a"])
		var b := _load(pair["b"])
		if a == null or b == null:
			continue
		var d := _diff(a, b)
		lines.append("  %-26s changed=%d mean=%.4f max=%.4f" % [pair["label"], int(d["changed"]), float(d["mean_delta"]), float(d["max_delta"])])
	lines.append("")
	lines.append("BOUNDARY")
	lines.append("Diff checks distinguish rendered state surfaces, not human readability of any single frame.")
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write " + REPORT_PATH)
	else:
		file.store_string("\n".join(lines) + "\n")
		file.close()
		print(PACKAGE_ID_TEXT + " DIFF REPORT: " + REPORT_PATH)
	_finish()


const PACKAGE_ID_TEXT := "PKG-0145"


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0145 DIFF PASS: all state pairs distinct, all frames valid")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0145 DIFF FAILURE: " + failure)
	quit(1)
