extends SceneTree

## Independent PCM survey of ProceduralAudio create_* methods with no required args.
## Meters are not a mix-quality claim.

const OUTPUT_PATH := "res://reports/pkg_0184/audio/audio_full_measurements.tsv"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports/pkg_0184/audio"))
	var source := FileAccess.get_file_as_string("res://scripts/audio/procedural_audio.gd")
	var names: Array[String] = []
	var search_from := 0
	while true:
		var hit := source.find("static func create_", search_from)
		if hit < 0:
			break
		var start := hit + "static func ".length()
		var open_paren := source.find("(", start)
		var method_name := source.substr(start, open_paren - start)
		var close_paren := source.find(")", open_paren)
		var signature := source.substr(open_paren, close_paren - open_paren + 1)
		if not signature.contains("=") and signature != "()":
			search_from = close_paren + 1
			continue
		if signature == "()" or signature.contains("="):
			names.append(method_name)
		search_from = close_paren + 1

	var rows := PackedStringArray([
		"generator\tmix_rate\tframes\tpeak_abs\tclipped_samples\tdc_offset\tstatus",
	])
	var measured := 0
	var clipped_total := 0
	for method_name in names:
		var callable := Callable(ProceduralAudio, StringName(method_name))
		if not callable.is_valid():
			continue
		var stream: AudioStreamWAV = null
		if method_name in ["create_land_sound", "create_dialogue_blip_sound", "create_crosswalk_signal_sound", "create_bus_engine_sound"]:
			stream = callable.call() as AudioStreamWAV
		else:
			stream = callable.call() as AudioStreamWAV
		if stream == null:
			continue
		var metrics := _measure_wav(stream)
		var status := "PASS"
		if metrics.clipped > 0 or metrics.peak >= 1.0:
			status = "FAIL"
			clipped_total += metrics.clipped
			_failures.append("%s clipped=%d peak=%.6f" % [method_name, metrics.clipped, metrics.peak])
		measured += 1
		rows.append("%s\t%d\t%d\t%.6f\t%d\t%.6f\t%s" % [
			method_name, stream.mix_rate, metrics.frames, metrics.peak, metrics.clipped, metrics.dc, status,
		])

	_expect(measured >= 40, "must measure a large slice of generators (got %d)" % measured)
	var file := FileAccess.open(ProjectSettings.globalize_path(OUTPUT_PATH), FileAccess.WRITE)
	if file == null:
		_failures.append("cannot write audio_full_measurements.tsv")
	else:
		file.store_string("\n".join(rows) + "\n")
		file.close()
	print("PKG-0184 AUDIO: measured=%d clipped_total=%d failures=%d" % [measured, clipped_total, _failures.size()])
	ProceduralAudio.clear_sound_cache()
	await create_timer(0.15).timeout
	if _failures.is_empty():
		print("PKG-0184 AUDIO PASS: %d generators below full scale." % measured)
		quit(0)
	else:
		for failure in _failures:
			push_error("PKG-0184 AUDIO: " + failure)
		quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _measure_wav(stream: AudioStreamWAV) -> Dictionary:
	var data := stream.data
	var frame_count := data.size() / 2
	var peak := 0.0
	var total := 0.0
	var clipped := 0
	for index in range(frame_count):
		var value := float(data.decode_s16(index * 2)) / 32768.0
		peak = maxf(peak, absf(value))
		total += value
		if absf(value) >= 0.999969:
			clipped += 1
	return {
		"frames": frame_count,
		"peak": peak,
		"clipped": clipped,
		"dc": total / maxf(1.0, float(frame_count)),
	}
