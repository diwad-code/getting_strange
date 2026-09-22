extends SceneTree

## Normal-driver measurement for every active address. Thresholds are
## workstation baselines, not a product frame-time budget.

const ACTIVE_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]
const WARMUP_FRAMES := 20
const SAMPLE_FRAMES := 90
const OUTPUT_PATH := "res://reports/pkg_0184/performance.tsv"

var _rows := PackedStringArray([
	"station\tdriver\trenderer\tsamples\tp50_ms\tp95_ms\tp99_ms\tmax_ms\tstatic_memory_bytes\tobject_count\tnode_count\tdraw_calls\titems_2d\tprimitives\tphysics_2d_active\taudio_latency_s\tstatus\tevidence_class",
])
var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	Engine.max_fps = 0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var driver := DisplayServer.get_name()
	var renderer := RenderingServer.get_current_rendering_method()
	print("PKG-0184 PERFORMANCE: driver=%s renderer=%s gpu=%s" % [driver, renderer, RenderingServer.get_video_adapter_name()])
	if driver == "headless":
		_failures.append("normal Windows display driver required")

	for station_id in ACTIVE_IDS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		if packed == null:
			_failures.append("%s failed to load" % station_id)
			continue
		var station := packed.instantiate()
		root.add_child(station)
		for _warmup in range(WARMUP_FRAMES):
			await RenderingServer.frame_post_draw

		var samples := PackedFloat32Array()
		var previous := Time.get_ticks_usec()
		for _sample in range(SAMPLE_FRAMES):
			await RenderingServer.frame_post_draw
			var now := Time.get_ticks_usec()
			samples.append(float(now - previous) / 1000.0)
			previous = now
		var stats := _summary(samples)
		var viewport_rid := root.get_viewport_rid()
		var canvas_objects := RenderingServer.viewport_get_render_info(
			viewport_rid, RenderingServer.VIEWPORT_RENDER_INFO_TYPE_CANVAS,
			RenderingServer.VIEWPORT_RENDER_INFO_OBJECTS_IN_FRAME
		)
		var canvas_primitives := RenderingServer.viewport_get_render_info(
			viewport_rid, RenderingServer.VIEWPORT_RENDER_INFO_TYPE_CANVAS,
			RenderingServer.VIEWPORT_RENDER_INFO_PRIMITIVES_IN_FRAME
		)
		_rows.append("%s\t%s\t%s\t%d\t%.4f\t%.4f\t%.4f\t%.4f\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%.6f\tMEASURED-BASELINE\tRUNTIME-MEASURED" % [
			station_id, driver, renderer, SAMPLE_FRAMES,
			stats.p50, stats.p95, stats.p99, stats.maximum,
			int(Performance.get_monitor(Performance.MEMORY_STATIC)),
			int(Performance.get_monitor(Performance.OBJECT_COUNT)),
			int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
			int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
			canvas_objects,
			canvas_primitives,
			int(Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)),
			Performance.get_monitor(Performance.AUDIO_OUTPUT_LATENCY),
		])
		print("  %s p50=%.3f p95=%.3f p99=%.3f ms" % [station_id, stats.p50, stats.p95, stats.p99])
		station.free()
		await RenderingServer.frame_post_draw

	var file := FileAccess.open(ProjectSettings.globalize_path(OUTPUT_PATH), FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write performance.tsv")
	else:
		file.store_string("\n".join(_rows) + "\n")
		file.close()
	ProceduralAudio.clear_sound_cache()
	await create_timer(0.15).timeout
	if _failures.is_empty():
		print("PKG-0184 PERFORMANCE PASS: %d active addresses measured on normal driver." % ACTIVE_IDS.size())
		quit(0)
	else:
		for failure in _failures:
			push_error("PKG-0184 PERFORMANCE: " + failure)
		quit(1)


func _summary(samples: PackedFloat32Array) -> Dictionary:
	var sorted := samples.duplicate()
	sorted.sort()
	var count := sorted.size()
	return {
		"p50": sorted[mini(count - 1, int(floor(float(count - 1) * 0.50)))],
		"p95": sorted[mini(count - 1, int(floor(float(count - 1) * 0.95)))],
		"p99": sorted[mini(count - 1, int(floor(float(count - 1) * 0.99)))],
		"maximum": sorted[count - 1],
	}
