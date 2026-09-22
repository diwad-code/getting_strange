extends SceneTree

## PKG-0149 capture comparison evidence (headless-safe).
## Verifies every normal/reduced frame is readable, non-blank and 640x360,
## then requires each diagnostic state pair to differ by more than 50 samples.

const ROOT_DIR := "res://reports/pkg_0149"
const REPORT_PATH := "res://reports/pkg_0149_capture_diff_report.txt"
const SIZE := Vector2i(640, 360)
const DISTINCT_SAMPLE_MIN := 50
const NONBLANK_CONTENT_MIN := 1.0

const FRAMES: Array[String] = [
	"station_31_chairs_inspected.png",
	"station_31_adaptation_rejected.png",
	"station_32_steamed_and_cracked.png",
	"station_32_material_memory_anchored.png",
	"station_33_ladder_and_gauge.png",
	"station_33_intent_reconstructed.png",
	"station_34_reactor_and_desk.png",
	"station_34_pair_registry_unlocked.png",
	"station_35_cooling_pool.png",
	"station_35_home_echo_verified.png",
	"station_36_drain_current.png",
	"station_36_cost_ledger_revealed.png",
	"station_37_oscilloscope_and_patchbay.png",
	"station_37_living_signal_bridged.png",
	"station_38_calculator_and_accident.png",
	"station_38_truth_disclosed_full.png",
	"station_38_truth_disclosed_withheld.png",
]

const STATE_PAIRS: Array[Dictionary] = [
	{"a": "normal/station_31_chairs_inspected.png", "b": "normal/station_31_adaptation_rejected.png", "label": "S11 chairs vs rejection"},
	{"a": "normal/station_32_steamed_and_cracked.png", "b": "normal/station_32_material_memory_anchored.png", "label": "S11 glass vs anchored memory"},
	{"a": "normal/station_33_ladder_and_gauge.png", "b": "normal/station_33_intent_reconstructed.png", "label": "S11 shaft vs intent reconstructed"},
	{"a": "normal/station_34_reactor_and_desk.png", "b": "normal/station_34_pair_registry_unlocked.png", "label": "S12 reactor vs registry"},
	{"a": "normal/station_35_cooling_pool.png", "b": "normal/station_35_home_echo_verified.png", "label": "S12 pool vs echo"},
	{"a": "normal/station_36_drain_current.png", "b": "normal/station_36_cost_ledger_revealed.png", "label": "S12 current vs cost ledger"},
	{"a": "normal/station_37_oscilloscope_and_patchbay.png", "b": "normal/station_37_living_signal_bridged.png", "label": "S13 oscilloscope vs bridge"},
	{"a": "normal/station_38_calculator_and_accident.png", "b": "normal/station_38_truth_disclosed_full.png", "label": "S13 receiver vs full truth"},
	{"a": "normal/station_38_calculator_and_accident.png", "b": "normal/station_38_truth_disclosed_withheld.png", "label": "S13 receiver vs withheld truth"},
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
	lines.append("PKG-0149 CAPTURE DIFF REPORT")
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
			lines.append("  %-36s DISTINCT changed=%d mean=%.4f max=%.4f" % [pair["label"], changed, float(delta["mean_delta"]), float(delta["max_delta"])])
		else:
			_failures.append("state pair not distinct: " + String(pair["label"]))
			lines.append("  %-36s NOT DISTINCT changed=%d" % [pair["label"], changed])
	lines.append("")
	lines.append("NORMAL vs REDUCED (reported, not required to differ)")
	for frame in FRAMES:
		var normal := _load("normal/" + frame)
		var reduced := _load("reduced/" + frame)
		if normal == null or reduced == null:
			continue
		var delta := _diff(normal, reduced)
		lines.append("  %-42s changed=%d mean=%.4f max=%.4f" % [frame, int(delta["changed"]), float(delta["mean_delta"]), float(delta["max_delta"])])
	lines.append("")
	lines.append("BOUNDARY")
	lines.append("Diff proves rendered surfaces differ; it does not prove human readability or reception.")
	var file := FileAccess.open(REPORT_PATH, FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write " + REPORT_PATH)
	else:
		file.store_string("\n".join(lines) + "\n")
		file.close()
		print("PKG-0149 DIFF REPORT: " + REPORT_PATH)
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0149 DIFF PASS: all frames distinct and non-blank")
		quit(0)
	else:
		for f in _failures:
			printerr("PKG-0149 DIFF FAILURE: " + f)
		quit(1)
