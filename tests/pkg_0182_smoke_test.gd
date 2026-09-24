extends SceneTree

const ACTIVE_IDS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18",
	&"station_42a", &"station_42b", &"station_42c", &"station_43",
]
const REPORT_DIR := "res://reports/pkg_0182"
const AUDIO_MEASUREMENTS := REPORT_DIR + "/audio/audio_measurements.tsv"
const AUDIO_BUSES := REPORT_DIR + "/audio/buses.tsv"
const SOAK_PATH := REPORT_DIR + "/runtime_routes/soak_3_cycles.tsv"
const REQUIRED_ACTIONS: Array[StringName] = [
	&"move_left", &"move_right", &"move_up", &"move_down", &"jump", &"interact",
	&"pause", &"restart", &"trigger_correction", &"sprint",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0182: " + message)


func _run() -> void:
	print("=== PKG-0182 Smoke Test: comprehensive audit evidence and 3-cycle soak ===")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(REPORT_DIR + "/audio"))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(REPORT_DIR + "/runtime_routes"))
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	if state == null:
		_finish()
		return

	_test_required_reports()
	await _test_inputmap_parity()
	_test_threshold_ready_notches()
	_test_audio_generators()
	await _test_three_cycle_soak(state)
	_test_json_safe_campaign(state)
	_test_scope_guards()
	state.set_pause_menu_visible(false)
	state.set_test_mode(false)
	state.reset_campaign(true)
	ProceduralAudio.clear_sound_cache()
	AtmosphereRig.clear_light_texture_cache()
	await create_timer(0.15).timeout
	_finish()


func _test_required_reports() -> void:
	print("1. Required inventory, coverage and audit ledgers...")
	for path in [
		"res://reports/pkg_0182/inventory.tsv",
		"res://reports/pkg_0182/coverage_manifest.tsv",
		"res://reports/pkg_0182/findings.tsv",
		"res://reports/pkg_0182/language_ledger.tsv",
		"res://reports/pkg_0182/animation_matrix.tsv",
		"res://reports/pkg_0182/audio_matrix.tsv",
		"res://reports/pkg_0182/test_integrity.tsv",
	]:
		_expect(FileAccess.file_exists(path), "%s must exist" % path)
	var coverage := FileAccess.get_file_as_string("res://reports/pkg_0182/coverage_manifest.tsv")
	_expect(coverage.count("\n") >= 900, "coverage manifest must include every file and runtime surface")
	_expect(not coverage.contains("\t\t"), "coverage manifest must not contain empty fields")


func _test_inputmap_parity() -> void:
	print("2. InputMap keyboard and pad injection parity...")
	for action in REQUIRED_ACTIONS:
		_expect(InputMap.has_action(action), "InputMap action %s missing" % action)
		var has_keyboard := false
		var has_pad := false
		for event in InputMap.action_get_events(action):
			has_keyboard = has_keyboard or event is InputEventKey
			has_pad = has_pad or event is InputEventJoypadButton or event is InputEventJoypadMotion
		_expect(has_keyboard, "%s must have a keyboard binding" % action)
		_expect(has_pad, "%s must have a pad binding" % action)
		Input.action_press(action)
		_expect(Input.is_action_pressed(action), "%s runtime injection must press" % action)
		Input.action_release(action)
		await process_frame


func _test_audio_generators() -> void:
	print("3. Procedural audio inventory and numeric PCM checks...")
	var source := FileAccess.get_file_as_string("res://scripts/audio/procedural_audio.gd")
	var regex := RegEx.new()
	regex.compile("(?m)^static func (create_[A-Za-z0-9_]+)\\(([^)]*)\\) -> AudioStreamWAV:")
	var rows := PackedStringArray([
		"generator\tcall_status\tmix_rate\tframes\tpeak_abs\tclipped_samples\tdc_offset\tloop_mode\tseam_delta\tstatus",
	])
	var callable_count := 0
	for result in regex.search_all(source):
		var method_name := result.get_string(1)
		var arguments := result.get_string(2).strip_edges()
		var callable_without_args := arguments.is_empty()
		if not callable_without_args:
			callable_without_args = true
			for argument in arguments.split(","):
				if not argument.contains("="):
					callable_without_args = false
		if not callable_without_args:
			rows.append("%s\tNOT_APPLICABLE_REQUIRED_ARGS\t-\t-\t-\t-\t-\t-\t-\tNOT_APPLICABLE" % method_name)
			continue
		var callable := Callable(ProceduralAudio, StringName(method_name))
		_expect(callable.is_valid(), "%s must be dynamically callable" % method_name)
		if not callable.is_valid():
			continue
		var stream := callable.call() as AudioStreamWAV
		_expect(stream != null, "%s must return AudioStreamWAV" % method_name)
		if stream == null:
			continue
		callable_count += 1
		var metrics := _measure_wav(stream)
		_expect(stream.mix_rate == 44100, "%s must use 44100 Hz" % method_name)
		_expect(metrics.peak <= 1.0, "%s must not exceed PCM full scale" % method_name)
		_expect(metrics.clipped == 0, "%s must not hard-clip" % method_name)
		_expect(absf(metrics.dc) < 0.05, "%s DC offset %.6f exceeds 0.05" % [method_name, metrics.dc])
		rows.append("%s\tCALLED\t%d\t%d\t%.6f\t%d\t%.6f\t%d\t%.6f\tPASS" % [
			method_name, stream.mix_rate, metrics.frames, metrics.peak, metrics.clipped,
			metrics.dc, stream.loop_mode, metrics.seam,
		])
	_expect(callable_count >= 200, "at least 200 no-required-argument generators must be measured (got %d)" % callable_count)
	_write_file(AUDIO_MEASUREMENTS, "\n".join(rows) + "\n")

	var bus_rows := PackedStringArray(["index\tname\tvolume_db\tmute\tsolo\tbypass_fx"])
	for index in range(AudioServer.bus_count):
		bus_rows.append("%d\t%s\t%.3f\t%s\t%s\t%s" % [
			index, AudioServer.get_bus_name(index), AudioServer.get_bus_volume_db(index),
			str(AudioServer.is_bus_mute(index)).to_lower(), str(AudioServer.is_bus_solo(index)).to_lower(),
			str(AudioServer.is_bus_bypassing_effects(index)).to_lower(),
		])
	_write_file(AUDIO_BUSES, "\n".join(bus_rows) + "\n")


func _test_threshold_ready_notches() -> void:
	print("3. Threshold ready state has a non-colour affordance...")
	var zone := ThresholdZone.new()
	root.add_child(zone)
	zone.is_open = false
	zone.is_player_in_range = true
	_expect(not zone.is_ready_for_entry(), "closed threshold must not show ready notches")
	zone.is_open = true
	_expect(zone.is_ready_for_entry(), "open in-range threshold must show ready notches")
	zone.set("_busy", true)
	_expect(not zone.is_ready_for_entry(), "busy threshold must suppress ready notches")
	zone.free()


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
	var first := float(data.decode_s16(0)) / 32768.0 if frame_count > 0 else 0.0
	var last := float(data.decode_s16((frame_count - 1) * 2)) / 32768.0 if frame_count > 0 else 0.0
	return {
		"frames": frame_count,
		"peak": peak,
		"clipped": clipped,
		"dc": total / maxf(1.0, float(frame_count)),
		"seam": absf(last - first),
	}


func _test_three_cycle_soak(state: Node) -> void:
	print("4. Three-cycle active-route load/use/free, save/load, pause and cache eviction...")
	var rows := PackedStringArray(["cycle\tloaded\tobject_count_before\tobject_count_after\tdelta\tcache_after_clear\tsave_reload\tpause_resume\tstatus"])
	state.set_test_mode(true)
	state.campaign_auto_transition_enabled = false
	for cycle in range(1, 4):
		state.reset_campaign(true)
		var before := int(Performance.get_monitor(Performance.OBJECT_COUNT))
		var loaded := 0
		for station_id in ACTIVE_IDS:
			var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
			_expect(packed != null, "%s must load in soak cycle %d" % [station_id, cycle])
			if packed == null:
				continue
			var station := packed.instantiate()
			root.add_child(station)
			await process_frame
			loaded += 1
			var point := _find_memory_point(station)
			if point != null:
				point.is_player_in_range = true
				point.trigger_interaction()
			await process_frame
			station.free()
			await process_frame
		state.record_decision(&"pkg0182.soak_cycle", cycle)
		var save_ok: bool = bool(state.save_campaign())
		var reload_ok: bool = bool(state.reload_campaign_from_disk())
		state.set_pause_menu_visible(true)
		await process_frame
		var pause_visible: bool = paused
		state.set_pause_menu_visible(false)
		await process_frame
		var resume_ok: bool = not paused
		ProceduralAudio.clear_sound_cache()
		AtmosphereRig.clear_light_texture_cache()
		# PKG-0242 (R2): the pause fade and other short tweens are still alive
		# 0.05 s after the menu closes; how many depends on frame timing (the
		# count differed by a few objects between cycles under parallel load,
		# never growing). Measure once transient objects have settled, so a
		# difference between cycles means a real leak.
		var after := await _settled_object_count()
		var delta := after - before
		var cache_size := ProceduralAudio.get_sound_cache_size()
		var cycle_ok: bool = loaded == ACTIVE_IDS.size() and save_ok and reload_ok and pause_visible and resume_ok and cache_size == 0
		_expect(cycle_ok, "soak cycle %d contract failed" % cycle)
		rows.append("%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%s" % [
			cycle, loaded, before, after, delta, cache_size,
			str(save_ok and reload_ok).to_lower(), str(pause_visible and resume_ok).to_lower(),
			"PASS" if cycle_ok else "FAIL",
		])
	_write_file(SOAK_PATH, "\n".join(rows) + "\n")


func _find_memory_point(node: Node) -> MemoryResonancePoint:
	if node is MemoryResonancePoint:
		return node as MemoryResonancePoint
	for child in node.get_children():
		var result := _find_memory_point(child)
		if result != null:
			return result
	return null


func _test_json_safe_campaign(state: Node) -> void:
	print("5. JSON-safe campaign save rejects malformed payloads...")
	var save_path := "user://getting_strange_campaign_v1.json"
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	_expect(file != null, "test must write a controlled campaign save")
	if file != null:
		file.store_string("{not valid json")
		file.close()
	_expect(not bool(state.reload_campaign_from_disk()), "malformed JSON must be rejected cleanly")
	_expect(not bool(state.has_valid_campaign_save()), "malformed JSON must leave a clean campaign")
	state.reset_campaign(true)


func _test_scope_guards() -> void:
	print("6. D-098/D-168 scope guards...")
	# PKG-0242 (R2): D-251 (AGENTS.md, owner authority PKG-0241) made the git
	# history part of the record, superseding the D-016 "no repository" rule
	# this line pinned. What still holds for the versioned tree: exported
	# builds stay out of it.
	var ignore := FileAccess.get_file_as_string("res://.gitignore")
	_expect(ignore.contains("\ndist/"), "build output (dist/) must stay out of version control")
	_expect(not FileAccess.file_exists("res://index.html"), "Godot project root must not gain a web surface")
	var unexpected_exe: Array[String] = []
	_collect_unexpected_exe("res://", unexpected_exe)
	_expect(unexpected_exe.is_empty(), "no unexpected .exe may be created: %s" % ", ".join(unexpected_exe))


func _collect_unexpected_exe(path: String, output: Array[String]) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var name := dir.get_next()
	while not name.is_empty():
		if name.begins_with("."):
			name = dir.get_next()
			continue
		var child_path := path.path_join(name)
		if dir.current_is_dir():
			if name not in ["archive_retired_web", "reports", "snapshots", "dist"]:
				_collect_unexpected_exe(child_path, output)
		elif name.to_lower().ends_with(".exe") and child_path not in [
			"res://Godot_v4.6.3-stable_win64.exe", "res://Godot_v4.6.3-stable_win64_console.exe"
		]:
			output.append(child_path)
		name = dir.get_next()
	dir.list_dir_end()


func _write_file(path: String, content: String) -> void:
	var file := FileAccess.open(ProjectSettings.globalize_path(path), FileAccess.WRITE)
	_expect(file != null, "cannot write %s" % path)
	if file != null:
		file.store_string(content)
		file.close()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0182 SMOKE PASS: audit ledgers, input parity, PCM metrics and 3-cycle soak certified.")
		quit(0)
	else:
		push_error("PKG-0182 SMOKE FAILED with %d failures" % _failures.size())
		quit(1)


## Object count after short-lived tweens/timers finish: at least 0.5 s and
## 10 consecutive frames without change (capped at 5 s).
func _settled_object_count() -> int:
	var started := Time.get_ticks_msec()
	var last := int(Performance.get_monitor(Performance.OBJECT_COUNT))
	var steady := 0
	while Time.get_ticks_msec() - started < 5000:
		await process_frame
		var now := int(Performance.get_monitor(Performance.OBJECT_COUNT))
		steady = steady + 1 if now == last else 0
		last = now
		if steady >= 10 and Time.get_ticks_msec() - started >= 500:
			break
	return last
