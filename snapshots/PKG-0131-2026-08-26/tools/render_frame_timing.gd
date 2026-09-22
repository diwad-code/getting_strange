extends SceneTree

## PKG-0130 — Real render frame-timing certification (60 Hz / 16.66 ms budget)
##
## The headless audit (`tools/frame_budget_audit.gd`) bounds object budgets and
## script cost, but a headless run has no renderer: it cannot prove the render
## budget. This probe runs with the normal Windows display driver, disables vsync
## and the FPS cap, and samples real post-draw frame intervals for the heaviest
## scenes in the campaign.
##
## Because vsync and the FPS cap are off, the measured interval is the true cost of
## producing one frame — world draw + WorldPixelCompositor screen-read shader +
## vector lights + CPU particles + every crisp UI layer.
##
## Usage (normal driver, NOT --headless):
##   godot --path . --script res://tools/render_frame_timing.gd --resolution 640x360
##
## Limits: this measures one machine and one driver. It proves the frame budget on
## this workstation only, and it says nothing about how the game feels (ADR-003).

const FRAME_BUDGET_MS := 16.66

## Frames sampled per scene after warm-up.
const SAMPLE_FRAMES := 180
const WARMUP_FRAMES := 30

## Fraction of sampled frames allowed to exceed the budget. A handful of long
## frames right after a scene enters the tree is shader/pipeline warm-up, not a
## sustained stall, so the gate is on the 99th percentile plus a hard ceiling.
const MAX_OVER_BUDGET_RATIO := 0.02

## Scenes chosen for load, not for coverage: the dense-steam machine chambers
## (34-37), the high-contrast finale lighting chambers (40-42), the junction with a
## ServiceLift (25), the ladder station (01) and the epilogue daylight wash (43).
const PROBE_SCENES: Array[String] = [
	"station_01",
	"station_25",
	"station_34",
	"station_35",
	"station_36",
	"station_37",
	"station_40",
	"station_41",
	"station_42a",
	"station_42b",
	"station_42c",
	"station_43",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	# Remove every pacing limiter so the sampled interval is the real frame cost.
	Engine.max_fps = 0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	print("================================================================================")
	print("     PKG-0130 RENDER FRAME-TIMING CERTIFICATION (60 Hz / %.2f ms budget)" % FRAME_BUDGET_MS)
	print("================================================================================")
	print("Driver: %s | vsync: disabled | max_fps: uncapped" % DisplayServer.get_name())
	print("Samples per scene: %d frames after %d warm-up frames." % [SAMPLE_FRAMES, WARMUP_FRAMES])
	print("Gate: p99 <= %.2f ms and at most %.0f%% of frames over budget.\n" % [
		FRAME_BUDGET_MS, MAX_OVER_BUDGET_RATIO * 100.0
	])

	var worst_p99 := 0.0
	var worst_scene := ""

	for station_id in PROBE_SCENES:
		var scene_path := "res://scenes/levels/%s.tscn" % station_id
		var packed: PackedScene = load(scene_path)
		if packed == null:
			_failures.append("%s: scene failed to load" % station_id)
			continue

		var instance: Node = packed.instantiate()
		root.add_child(instance)

		for _warmup in range(WARMUP_FRAMES):
			await RenderingServer.frame_post_draw

		var samples := PackedFloat32Array()
		var previous := Time.get_ticks_usec()
		for _frame in range(SAMPLE_FRAMES):
			await RenderingServer.frame_post_draw
			var now := Time.get_ticks_usec()
			samples.append(float(now - previous) / 1000.0)
			previous = now

		var report := _summarise(samples)
		var p99: float = report["p99"]
		var over_ratio: float = report["over_ratio"]

		if p99 > worst_p99:
			worst_p99 = p99
			worst_scene = station_id

		var verdict := "PASS"
		if p99 > FRAME_BUDGET_MS or over_ratio > MAX_OVER_BUDGET_RATIO:
			verdict = "FAIL"
			_failures.append("%s: p99 %.3f ms, %.2f%% frames over %.2f ms budget" % [
				station_id, p99, over_ratio * 100.0, FRAME_BUDGET_MS
			])

		print("--- %s: %s ---" % [station_id, verdict])
		print("  min %.3f | median %.3f | mean %.3f | p95 %.3f | p99 %.3f | max %.3f ms" % [
			report["min"], report["median"], report["mean"],
			report["p95"], p99, report["max"],
		])
		print("  effective fps (median): %.1f | frames over budget: %d / %d" % [
			1000.0 / maxf(0.001, report["median"]), int(report["over_count"]), samples.size()
		])

		instance.queue_free()
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw

	print("\n================================================================================")
	print("SUMMARY")
	print("  Scenes probed: %d" % PROBE_SCENES.size())
	print("  Worst p99 frame time: %.3f ms (%s)" % [worst_p99, worst_scene])
	print("  Budget: %.2f ms (60 Hz)" % FRAME_BUDGET_MS)
	print("================================================================================")

	if _failures.is_empty():
		print("RENDER TIMING: PASS — every probed scene holds the 60 Hz budget on this machine.")
		quit(0)
	else:
		print("RENDER TIMING: %d FAILURE(S)" % _failures.size())
		for failure in _failures:
			print("  * ", failure)
		quit(1)


func _summarise(samples: PackedFloat32Array) -> Dictionary:
	var sorted := samples.duplicate()
	sorted.sort()
	var count := sorted.size()
	if count == 0:
		return {
			"min": 0.0, "max": 0.0, "mean": 0.0, "median": 0.0,
			"p95": 0.0, "p99": 0.0, "over_count": 0, "over_ratio": 0.0,
		}

	var total := 0.0
	var over_count := 0
	for value in samples:
		total += value
		if value > FRAME_BUDGET_MS:
			over_count += 1

	return {
		"min": sorted[0],
		"max": sorted[count - 1],
		"mean": total / float(count),
		"median": sorted[count / 2],
		"p95": sorted[mini(count - 1, int(float(count) * 0.95))],
		"p99": sorted[mini(count - 1, int(float(count) * 0.99))],
		"over_count": over_count,
		"over_ratio": float(over_count) / float(count),
	}
