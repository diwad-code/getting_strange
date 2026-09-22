extends SceneTree

## PKG-0184 / BUNDLE-34 final independent recertification gate.
## Every PKG-0182 and PKG-0183 PASS is a hypothesis until this script and the
## fresh reports/pkg_0184 artefacts agree. Direct method calls are not a
## campaign route; player-verb M1 lives in pkg_0177 -- --pkg0184-route=.

const ACTIVE_IDS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18",
	&"station_42a", &"station_42b", &"station_42c", &"station_43",
]
const SEQUENCE_PATHS: Array[String] = [
	"res://resources/gameplay/sample_and_promise_sequence.tres",
	"res://resources/gameplay/return_under_control_sequence.tres",
	"res://resources/gameplay/address_and_record_sequence.tres",
	"res://resources/gameplay/foreign_daily_life_sequence.tres",
	"res://resources/gameplay/marta_threshold_sequence.tres",
	"res://resources/gameplay/work_history_and_record_sequence.tres",
	"res://resources/gameplay/three_place_proofs_sequence.tres",
	"res://resources/gameplay/mutual_test_sequence.tres",
	"res://resources/gameplay/interrupted_trial_and_small_cost_sequence.tres",
	"res://resources/gameplay/jakub_boundary_and_forecasts_sequence.tres",
	"res://resources/gameplay/archive_countermodel_sequence.tres",
	"res://resources/gameplay/pair_cost_and_echo_sequence.tres",
	"res://resources/gameplay/consent_and_rescue_boundary_sequence.tres",
	"res://resources/gameplay/branch_clarity_and_irreversible_choice_sequence.tres",
	"res://resources/gameplay/conscious_silence_and_presence_sequence.tres",
]
const REQUIRED_ACTIONS: Array[StringName] = [
	&"move_left", &"move_right", &"move_up", &"move_down", &"jump", &"interact",
	&"pause", &"restart", &"trigger_correction", &"sprint",
]
const REPORT_DIR := "res://reports/pkg_0184"
const SOAK_PATH := REPORT_DIR + "/runtime_routes/soak_3_cycles.tsv"
const AUDIO_PATH := REPORT_DIR + "/audio/audio_measurements.tsv"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0184: " + message)


func _run() -> void:
	print("=== PKG-0184 Smoke Test: final independent recertification ===")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(REPORT_DIR + "/runtime_routes"))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(REPORT_DIR + "/audio"))
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	if state == null:
		_finish()
		return

	_test_runtime_canon()
	_test_inherited_false_pass_repairs()
	_test_pause_copy_matches_twenty_address_campaign(state)
	_test_resources_are_live()
	_test_csv_locale_is_not_registered()
	_test_opening_lines_match_live_stations()
	await _test_shell_localization(state)
	await _test_inputmap_parity()
	await _test_threshold_notches_in_campaign_scene()
	await _test_pixel_stage_does_not_cover_text()
	_test_audio_headroom_sample()
	await _test_three_cycle_soak(state)
	_test_json_and_truncated_saves(state)
	_test_seventeen_gate_rollup_is_not_a_measurement()
	_test_scope_guards()
	state.set_pause_menu_visible(false)
	state.set_test_mode(false)
	state.set_locale("pl", false)
	state.reset_campaign(true)
	ProceduralAudio.clear_sound_cache()
	AtmosphereRig.clear_light_texture_cache()
	await create_timer(0.15).timeout
	_finish()


func _test_runtime_canon() -> void:
	print("1. Viewport, physics and Godot 4.7 canon...")
	_expect(int(ProjectSettings.get_setting("display/window/size/viewport_width")) == 640, "logical width must be 640")
	_expect(int(ProjectSettings.get_setting("display/window/size/viewport_height")) == 360, "logical height must be 360")
	_expect(int(Engine.physics_ticks_per_second) == 60, "physics must run at 60 Hz")
	_expect(
		int(ProjectSettings.get_setting("physics/common/physics_ticks_per_second", 0)) == 60,
		"project.godot must pin physics_ticks_per_second = 60"
	)
	var features: PackedStringArray = ProjectSettings.get_setting("application/config/features", PackedStringArray())
	_expect("4.7" in features, "project features must declare 4.7")


func _test_inherited_false_pass_repairs() -> void:
	print("1b. PKG-0183 false-PASS repairs must still be present...")
	var src_0179 := FileAccess.get_file_as_string("res://tests/pkg_0179_smoke_test.gd")
	_expect(src_0179.contains("await _test_objectdb_and_signal_hygiene()"), "pkg_0179 must await ObjectDB hygiene")
	_expect(src_0179.contains("await _test_kinematics_step_down()"), "pkg_0179 must await kinematics")
	_expect(src_0179.contains("await _test_sensory_innovations()"), "pkg_0179 must await sensory innovations")
	_expect(src_0179.contains("print(\"1. ObjectDB"), "pkg_0179 must log step 1 so a PASS cannot hide skipped tests")
	_expect(src_0179.contains("print(\"6. D-168"), "pkg_0179 must log its last step")
	var src_0180 := FileAccess.get_file_as_string("res://tests/pkg_0180_smoke_test.gd")
	_expect(src_0180.contains("await _finish()"), "pkg_0180 must await its teardown coroutine")
	var generate := FileAccess.get_file_as_string("res://scripts/audio/procedural_audio.gd")
	var generate_fn := generate.substr(generate.find("static func generate_wav"), 700)
	_expect(generate_fn.contains("tanh(raw) * 0.94"), "generate_wav must apply tanh headroom before PCM encode")
	_expect(
		not generate_fn.contains("clampf(raw"),
		"generate_wav itself must tanh before any clampf(raw) of the generator output"
	)
	var gsm := FileAccess.get_file_as_string("res://scripts/core/game_state_manager.gd")
	_expect(gsm.contains("PAUSE_STATION_TOOLTIP"), "pause station tooltip must use the localized key")
	_expect(
		not gsm.contains('tooltip_text = "Przestrzeń "'),
		"pause tooltip must not hardcode Polish when locale can be EN"
	)
	var threshold := FileAccess.get_file_as_string("res://scripts/environment/threshold_zone.gd")
	_expect(
		not threshold.contains("bool("),
		"ThresholdZone must not use bool(Variant) on optional parent flags"
	)


func _test_pause_copy_matches_twenty_address_campaign(state: Node) -> void:
	print("2. Pause copy must describe the 20-address campaign...")
	var selectable: Array = state.get_selectable_stations(true)
	_expect(selectable.size() == 20, "selector must expose 20 campaign addresses (got %d)" % selectable.size())
	for locale_code in ["pl", "en"]:
		LocalizationManager.set_locale(locale_code)
		var status: String = LocalizationManager.tr_key("PAUSE_STATUS")
		_expect(not status.contains("/43"), "%s PAUSE_STATUS still advertises /43: %s" % [locale_code, status])
		_expect(
			status.contains("%d/%d"),
			"%s PAUSE_STATUS must format discovered/total as two integers (got %s)" % [locale_code, status]
		)
		if status.contains("%d/%d"):
			var formatted: String = status % [selectable.size(), selectable.size(), "OFF"]
			_expect(formatted.contains("/20"), "%s formatted pause status must show /20 (got %s)" % [locale_code, formatted])
	state.set_locale("pl", false)


func _test_resources_are_live() -> void:
	print("3. Runtime resources omitted by PKG-0182 inventory must still load...")
	for path in SEQUENCE_PATHS:
		_expect(ResourceLoader.exists(path), "%s must exist" % path)
		var sequence := load(path) as DiagnosticSequenceDefinition
		_expect(sequence != null, "%s must load as DiagnosticSequenceDefinition" % path)
		if sequence != null:
			_expect(not String(sequence.sequence_id).is_empty(), "%s must have a sequence_id" % path)
	for profile_id in ["a", "b", "c"]:
		var profile_path := "res://resources/movement/profile_%s.tres" % profile_id
		_expect(load(profile_path) != null, "%s must load" % profile_path)


func _test_csv_locale_is_not_registered() -> void:
	print("3b. Unused CSV translations must not silently override LocalizationManager...")
	var project := FileAccess.get_file_as_string("res://project.godot")
	_expect(
		not project.contains("getting_strange_locales"),
		"retired CSV/.translation must stay unregistered; LocalizationManager is the source of truth"
	)
	_expect(
		FileAccess.file_exists("res://resources/localization/getting_strange_locales.csv"),
		"retired CSV donor must remain on disk so the exclusion is auditable"
	)
	var csv := FileAccess.get_file_as_string("res://resources/localization/getting_strange_locales.csv")
	_expect(
		csv.contains("[C / SHIFT]"),
		"retired CSV still carries the pre-InputMap Anchor binding; registering it would lie to the player"
	)


func _test_opening_lines_match_live_stations() -> void:
	print("4. Station 10-13 opening lines must match the live scene, not leftover P7 photos...")
	var line_10 := _opening_line("res://scenes/levels/station_10.tscn")
	var line_11 := _opening_line("res://scenes/levels/station_11.tscn")
	var line_12 := _opening_line("res://scenes/levels/station_12.tscn")
	var line_13 := _opening_line("res://scenes/levels/station_13.tscn")
	_expect(not line_10.is_empty(), "station_10 must have an opening line")
	_expect(line_10.to_lower().contains("marta"), "station_10 opening must name Marta (P9 overlay lives here)")
	_expect(not line_11.to_lower().contains("tylko patrz"), "station_11 must not keep the leftover looking-only line")
	_expect(
		line_11.to_lower().contains("ślad") or line_11.to_lower().contains("porówn"),
		"station_11 opening must describe comparing traces (got: %s)" % line_11
	)
	_expect(
		line_12.to_lower().contains("balkon") or line_12.to_lower().contains("sekretark"),
		"station_12 opening must name the answering-machine / balcony beat the scene actually runs"
	)
	_expect(not line_13.contains("w terenie"), "station_13 must not keep the leftover field-companion line")
	_expect(
		line_13.to_lower().contains("dokument") or line_13.to_lower().contains("adres") or line_13.to_lower().contains("źród"),
		"station_13 opening must name the documents / sources the drawer actually holds (got: %s)" % line_13
	)


func _opening_line(scene_path: String) -> String:
	var source := FileAccess.get_file_as_string(scene_path)
	var marker := "opening_line = \""
	var start := source.find(marker)
	if start < 0:
		return ""
	start += marker.length()
	var finish := source.find("\"", start)
	if finish < 0:
		return ""
	return source.substr(start, finish - start)


func _test_shell_localization(state: Node) -> void:
	print("5. Shell ReturnPromise and cold-open skip must follow locale...")
	var packed := load("res://scenes/shell/title_screen.tscn") as PackedScene
	_expect(packed != null, "title_screen must load")
	if packed == null:
		return
	var title := packed.instantiate() as Control
	root.add_child(title)
	await process_frame
	await process_frame
	state.set_locale("pl", false)
	if title.has_method("refresh_for_test"):
		title.call("refresh_for_test")
	await process_frame
	var return_line := title.get_node_or_null("TitlePanel/ReturnPromise") as Label
	_expect(return_line != null, "title must expose ReturnPromise")
	if return_line != null:
		_expect(
			return_line.text.contains("LINIA 4") or return_line.text.contains("ODCZYT"),
			"PL ReturnPromise must stay a Line 4 return line (got: %s)" % return_line.text
		)
	var new_game := title.get_node_or_null("TitlePanel/NewGameButton") as Button
	_expect(new_game != null and new_game.text == "NOWA GRA", "PL New Game label")
	state.set_locale("en", false)
	if title.has_method("refresh_for_test"):
		title.call("refresh_for_test")
	await process_frame
	if return_line != null:
		_expect(
			not return_line.text.contains("LINIA 4"),
			"EN ReturnPromise must not keep the hardcoded Polish line (got: %s)" % return_line.text
		)
		_expect(
			return_line.text.contains("LINE 4") or return_line.text.contains("READING") or return_line.text.contains("RETURN"),
			"EN ReturnPromise must be an English Line 4 return line (got: %s)" % return_line.text
		)
	if new_game != null:
		_expect(new_game.text == "NEW GAME", "EN New Game label")
	title.free()
	state.set_locale("pl", false)

	var cold_src := FileAccess.get_file_as_string("res://scripts/ui/cold_open.gd")
	_expect(
		cold_src.contains("COLD_OPEN_SKIP") and cold_src.contains("tr_key"),
		"cold open skip hint must use a localization key, not a hardcoded Polish constant"
	)
	_expect(
		LocalizationManager.tr_key("COLD_OPEN_SKIP") != "COLD_OPEN_SKIP",
		"COLD_OPEN_SKIP must exist in LocalizationManager"
	)


func _test_inputmap_parity() -> void:
	print("6. InputMap keyboard and pad bindings...")
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


func _test_threshold_notches_in_campaign_scene() -> void:
	print("7. Campaign ThresholdZone ready-state notches...")
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	_expect(packed != null, "station_01 must load")
	if packed == null:
		return
	var station := packed.instantiate()
	root.add_child(station)
	for _frame in range(3):
		await process_frame
	var zone := _find_threshold(station)
	_expect(zone != null, "station_01 must install a ThresholdZone at runtime")
	if zone != null:
		zone.is_open = false
		zone.is_player_in_range = true
		_expect(not zone.is_ready_for_entry(), "closed campaign threshold must not be ready")
		zone.is_open = true
		_expect(zone.is_ready_for_entry(), "open in-range campaign threshold must be ready")
		_expect(zone.has_method("_draw_ready_notches"), "ThresholdZone must draw non-colour ready notches")
	station.free()


func _find_threshold(node: Node) -> ThresholdZone:
	if node is ThresholdZone:
		return node as ThresholdZone
	for child in node.get_children():
		var found := _find_threshold(child)
		if found != null:
			return found
	return null


func _test_pixel_stage_does_not_cover_text() -> void:
	print("8. Pixel-Stage compositor sits below crisp text layers...")
	var compositor := WorldPixelCompositor.new()
	_expect(compositor.layer == 5, "WorldPixelCompositor must stay on layer 5")
	var crisp := CrispDiegeticText.new()
	root.add_child(crisp)
	await process_frame
	var crisp_layer := crisp.get_node_or_null("CrispDiegeticLayer") as CanvasLayer
	_expect(crisp_layer != null, "CrispDiegeticText must install CrispDiegeticLayer")
	if crisp_layer != null:
		_expect(crisp_layer.layer == 10, "diegetic text layer must be 10")
		_expect(crisp_layer.layer > compositor.layer, "crisp text must render above the pixel compositor")
	compositor.free()
	crisp.free()


func _test_audio_headroom_sample() -> void:
	print("9. Sampled procedural generators stay below full scale...")
	var rows := PackedStringArray([
		"generator\tmix_rate\tframes\tpeak_abs\tclipped_samples\tdc_offset\tstatus",
	])
	var measured := 0
	for method_name in [
		"create_anchor_sound", "create_unanchor_sound", "create_correction_pulse_sound",
		"create_footstep_linoleum_sound", "create_tile_footstep_sound",
		"create_memory_resonance_sound", "create_tram_traction_sound",
	]:
		var callable := Callable(ProceduralAudio, StringName(method_name))
		if not callable.is_valid():
			continue
		var stream := callable.call() as AudioStreamWAV
		if stream == null:
			continue
		measured += 1
		var metrics := _measure_wav(stream)
		_expect(stream.mix_rate == 44100, "%s mix_rate" % method_name)
		_expect(metrics.clipped == 0, "%s must not hard-clip" % method_name)
		_expect(metrics.peak < 1.0, "%s peak must stay below full scale" % method_name)
		rows.append("%s\t%d\t%d\t%.6f\t%d\t%.6f\tPASS" % [
			method_name, stream.mix_rate, metrics.frames, metrics.peak, metrics.clipped, metrics.dc,
		])
	_expect(measured >= 5, "must measure at least five generators")
	_write_file(AUDIO_PATH, "\n".join(rows) + "\n")


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


func _test_three_cycle_soak(state: Node) -> void:
	print("10. Three-cycle load/free soak with object-count stability gate...")
	var rows := PackedStringArray([
		"cycle\tloaded\tobject_count_before\tobject_count_after\tdelta\tcache_after_clear\tsave_reload\tpause_resume\tstatus",
	])
	state.set_test_mode(true)
	state.campaign_auto_transition_enabled = false
	var stable_after := -1
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
			await process_frame
			loaded += 1
			station.free()
			await process_frame
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
		await create_timer(0.05).timeout
		var after := int(Performance.get_monitor(Performance.OBJECT_COUNT))
		var delta := after - before
		var cache_size := ProceduralAudio.get_sound_cache_size()
		if stable_after < 0:
			stable_after = after
		var cycle_ok: bool = (
			loaded == ACTIVE_IDS.size()
			and save_ok
			and reload_ok
			and pause_visible
			and resume_ok
			and cache_size == 0
			and after == stable_after
		)
		_expect(cycle_ok, "soak cycle %d contract failed (loaded=%d after=%d expected_after=%d cache=%d)" % [
			cycle, loaded, after, stable_after, cache_size,
		])
		rows.append("%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%s" % [
			cycle, loaded, before, after, delta, cache_size,
			str(save_ok and reload_ok).to_lower(), str(pause_visible and resume_ok).to_lower(),
			"PASS" if cycle_ok else "FAIL",
		])
	_write_file(SOAK_PATH, "\n".join(rows) + "\n")


func _test_json_and_truncated_saves(state: Node) -> void:
	print("11. Malformed and truncated campaign saves fall back cleanly...")
	var save_path := "user://getting_strange_campaign_v1.json"
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	_expect(file != null, "test must write a controlled campaign save")
	if file != null:
		file.store_string("{not valid json")
		file.close()
	_expect(not bool(state.reload_campaign_from_disk()), "malformed JSON must be rejected")
	_expect(not bool(state.has_valid_campaign_save()), "malformed JSON must leave a clean campaign")
	file = FileAccess.open(save_path, FileAccess.WRITE)
	if file != null:
		file.store_string('{"schema_version":1,"reached_stations":["station_01"]')
		file.close()
	_expect(not bool(state.reload_campaign_from_disk()), "truncated JSON must be rejected")
	state.reset_campaign(true)


func _test_seventeen_gate_rollup_is_not_a_measurement() -> void:
	print("12. PKG-0177 fourteen-gate summary remains a status rollup, not a measurement...")
	var src := FileAccess.get_file_as_string("res://tests/pkg_0177_smoke_test.gd")
	_expect(src.contains('"GATE-01": "PASS (RECERTIFIED)"'), "0177 still ships a hardcoded gate-status table")
	_expect(src.contains("Input.parse_input_event") or src.contains("ui_accept"), "0177 M1 path must still drive player verbs")
	_expect(src.contains("--pkg0184-route="), "0177 must accept an independent PKG-0184 route namespace")


func _test_scope_guards() -> void:
	print("13. D-098/D-016/D-168 scope guards...")
	_expect(not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://.git")), "project must remain unversioned")
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
		print("PKG-0184 SMOKE PASS: inherited repairs hold; shell locale, openings, crisp layers, soak and JSON fallback recertified.")
		quit(0)
	else:
		push_error("PKG-0184 SMOKE FAILED with %d failures" % _failures.size())
		for failure in _failures:
			push_error("  - " + failure)
		quit(1)
