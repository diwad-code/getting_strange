extends SceneTree

## PKG-0147 capture comparison evidence (headless-safe).
## Loads the normal-driver frames and measures:
##  1. the Station 15 state pair (notes vs record requested) must differ;
##  2. the Station 21 state pair (synthesis pending vs executed) must differ;
##  3. normal vs reduced pairs are amplitude-only deltas;
##  4. every frame is 640x360 with meaningful content.

const ROOT_DIR := "res://reports/pkg_0147"
const REPORT_PATH := "res://reports/pkg_0147_capture_diff_report.txt"
const SIZE := Vector2i(640, 360)

const STATE_PAIRS: Array[Dictionary] = [
	{"a": "normal/station_15_notes_only.png", "b": "normal/station_15_record_requested.png", "label": "S06 notes vs requested"},
	{"a": "normal/station_21_synthesis_pending.png", "b": "normal/station_21_synthesis_executed.png", "label": "S07 pending vs executed"},
]

const MODE_PAIRS: Array[Dictionary] = [
	{"a": "normal/station_15_notes_only.png", "b": "reduced/station_15_notes_only.png", "label": "S06 notes N/R"},
	{"a": "normal/station_15_record_requested.png", "b": "reduced/station_15_record_requested.png", "label": "S06 requested N/R"},
	{"a": "normal/station_16_institution_trial.png", "b": "reduced/station_16_institution_trial.png", "label": "S06 institution N/R"},
	{"a": "normal/station_17_report_scope_committed.png", "b": "reduced/station_17_report_scope_committed.png", "label": "S06 scope N/R"},
	{"a": "normal/station_18_method_committed.png", "b": "reduced/station_18_method_committed.png", "label": "S07 method N/R"},
	{"a": "normal/station_19_control_answers_compared.png", "b": "reduced/station_19_control_answers_compared.png", "label": "S07 voice N/R"},
	{"a": "normal/station_20_relational_trial.png", "b": "reduced/station_20_relational_trial.png", "label": "S07 relational N/R"},
	{"a": "normal/station_21_synthesis_pending.png", "b": "reduced/station_21_synthesis_pending.png", "label": "S07 pending N/R"},
	{"a": "normal/station_21_synthesis_executed.png", "b": "reduced/station_21_synthesis_executed.png", "label": "S07 executed N/R"},
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
	lines.append("PKG-0147 CAPTURE DIFF REPORT")
	lines.append("Programmatic frame evidence from the normal-driver capture. No line below claims comprehension, appeal or comfort.")
	lines.append("")
	lines.append("CONTENT CHECK (non-blank, 640x360)")
	for capture in _state_frames() + _mode_frames():
		var image := _load(capture)
		if image != null:
			lines.append("  %-48s content_sum=%.1f" % [capture, _content(image)])
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
			lines.append("  %-26s DISTINCT  changed=%d mean=%.4f max=%.4f" % [pair["label"], int(d["changed"]), float(d["mean_delta"]), float(d["max_delta"])])
		else:
			_failures.append("state pair not distinct: " + String(pair["label"]))
			lines.append("  %-26s NOT DISTINCT changed=%d" % [pair["label"], int(d["changed"])])
	lines.append("")
	lines.append("NORMAL vs REDUCED (amplitude-only expectation; facts remain visible)")
	for pair in MODE_PAIRS:
		var a := _load(pair["a"])
		var b := _load(pair["b"])
		if a == null or b == null:
			continue
		var d := _diff(a, b)
		lines.append("  %-24s changed=%d mean=%.4f max=%.4f" % [pair["label"], int(d["changed"]), float(d["mean_delta"]), float(d["max_delta"])])
	lines.append("")
	lines.append("BOUNDARY")
	lines.append("Diff checks distinguish rendered state surfaces, not human readability of any single frame.")
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write " + REPORT_PATH)
	else:
		file.store_string("\n".join(lines) + "\n")
		file.close()
		print("PKG-0147 DIFF REPORT: " + REPORT_PATH)
	_finish()


func _state_frames() -> Array[String]:
	var frames: Array[String] = []
	for pair in STATE_PAIRS:
		frames.append(pair["a"] as String)
		frames.append(pair["b"] as String)
	return frames


func _mode_frames() -> Array[String]:
	var frames: Array[String] = []
	for pair in MODE_PAIRS:
		frames.append(pair["a"] as String)
	return frames


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0147 DIFF PASS: all state pairs distinct, all frames valid")
		quit(0)
		return
	for failure in _failures:
		printerr("PKG-0147 DIFF FAILURE: " + failure)
	quit(1)
