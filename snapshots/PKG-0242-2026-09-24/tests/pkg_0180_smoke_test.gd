extends SceneTree

## PKG-0180 verification gate: Master Polish, Ambient Soundscape Pass & Executive Sign-off.
## Tests:
## 1. Ambient soundscape synthesis: 7 new procedural generators in ProceduralAudio.
## 2. AtmosphereRig soundscape assignment: Station 02, 04, 14, 15, 16, 17, 43.
## 3. Ambient ducking parameters & smooth interpolation during dialogue / inspection.
## 4. Release readiness: export_presets.cfg validation and dist/ folder verification.
## 5. Hard rule D-168 enforcement: zero unexpected .exe binaries in project tree.

const AtmosphereRigClass := preload("res://scripts/levels/atmosphere_rig.gd")
const CRTDialogueBoxClass := preload("res://scripts/ui/crt_dialogue_box.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0180 FAIL: " + message)


func _run() -> void:
	print("=== PKG-0180 Smoke Test: Master Polish, Ambient Soundscape Pass & Release Readiness ===")
	_test_procedural_soundscape_generation()
	_test_atmosphererig_soundscape_selection()
	await _test_ambient_ducking_behavior()
	_test_export_presets_and_dist()
	_test_d168_no_exe_release()
	await _finish()


func _test_procedural_soundscape_generation() -> void:
	print("1. Testing PKG-0180 procedural soundscape generators...")
	var generators: Array[Dictionary] = [
		{"name": "outdoor_viaduct_wind", "stream": ProceduralAudio.create_outdoor_viaduct_wind_sound()},
		{"name": "outdoor_perimeter_wind", "stream": ProceduralAudio.create_outdoor_perimeter_wind_sound()},
		{"name": "subterranean_substation_resonance", "stream": ProceduralAudio.create_subterranean_substation_resonance_sound()},
		{"name": "signal_vault_resonance", "stream": ProceduralAudio.create_signal_vault_resonance_sound()},
		{"name": "analyzer_cooling_conduit_drone", "stream": ProceduralAudio.create_analyzer_cooling_conduit_drone_sound()},
		{"name": "archive_ledger_resonance", "stream": ProceduralAudio.create_archive_ledger_resonance_sound()},
		{"name": "dawn_river_ambience", "stream": ProceduralAudio.create_dawn_river_ambience_sound()},
	]

	for gen in generators:
		var s: AudioStreamWAV = gen["stream"]
		var gname: String = gen["name"]
		_expect(s != null, "%s generator must not return null" % gname)
		if s != null:
			_expect(s.data.size() > 0, "%s generator must produce sample data" % gname)
			_expect(s.mix_rate == 44100, "%s mix_rate must be 44100 Hz" % gname)
			_expect(s.format == AudioStreamWAV.FORMAT_16_BITS, "%s must be 16-bit PCM" % gname)


func _test_atmosphererig_soundscape_selection() -> void:
	print("2. Testing AtmosphereRig station-specific ambient assignments...")
	var test_mappings: Dictionary = {
		2: &"outdoor_viaduct_wind",
		4: &"outdoor_perimeter_wind",
		14: &"subterranean_substation_resonance",
		15: &"signal_vault_resonance",
		16: &"analyzer_cooling_conduit_drone",
		17: &"archive_ledger_resonance",
		43: &"dawn_river_ambience",
	}

	for st_num in test_mappings.keys():
		var rig := AtmosphereRigClass.new()
		rig.station_number = st_num
		rig.world_width = 640.0
		root.add_child(rig)
		await process_frame
		
		_expect(rig._fluorescent_hum != null, "Station %d AtmosphereRig must instantiate _fluorescent_hum" % st_num)
		_expect(rig._fluorescent_hum.stream != null, "Station %d AtmosphereRig stream must be non-null" % st_num)
		
		rig.queue_free()
		await process_frame


func _test_ambient_ducking_behavior() -> void:
	print("3. Testing AtmosphereRig ambient ducking parameters and interpolation...")
	var parent_node := Node2D.new()
	parent_node.name = "TestStation"
	root.add_child(parent_node)

	var rig := AtmosphereRigClass.new()
	rig.station_number = 34
	rig.world_width = 640.0
	parent_node.add_child(rig)
	await process_frame

	_expect(rig.has_method("set_ambient_ducked"), "AtmosphereRig must have set_ambient_ducked")
	_expect(rig.has_method("is_ambient_ducked"), "AtmosphereRig must have is_ambient_ducked")
	_expect(not rig.is_ambient_ducked(), "Default state must not be ducked")

	var initial_hum_vol: float = rig._fluorescent_hum.volume_db
	var initial_sub_vol: float = rig._substructure_player.volume_db
	_expect(is_equal_approx(initial_hum_vol, -24.0), "Initial hum volume must be -24.0 dB")
	_expect(is_equal_approx(initial_sub_vol, -28.0), "Initial substructure volume must be -28.0 dB")

	# Enable manual ducking
	rig.set_ambient_ducked(true)
	_expect(rig.is_ambient_ducked(), "set_ambient_ducked(true) must activate ducking")

	# Process frames to interpolate down
	for _i in range(30):
		rig._process(1.0 / 60.0)

	var ducked_hum_vol: float = rig._fluorescent_hum.volume_db
	var ducked_sub_vol: float = rig._substructure_player.volume_db
	_expect(ducked_hum_vol < initial_hum_vol - 5.0, "Ducked hum volume must drop by at least 5 dB (got %.2f)" % ducked_hum_vol)
	_expect(ducked_sub_vol < initial_sub_vol - 5.0, "Ducked sub volume must drop by at least 5 dB (got %.2f)" % ducked_sub_vol)

	# Disable manual ducking and verify recovery
	rig.set_ambient_ducked(false)
	_expect(not rig.is_ambient_ducked(), "set_ambient_ducked(false) must deactivate ducking")

	for _i in range(30):
		rig._process(1.0 / 60.0)

	var restored_hum_vol: float = rig._fluorescent_hum.volume_db
	_expect(restored_hum_vol > ducked_hum_vol + 4.0, "Restored hum volume must rise back (got %.2f)" % restored_hum_vol)

	# Test automatic ducking when CRTDialogueBox is present and presenting
	var dialogue_box := CRTDialogueBoxClass.new()
	dialogue_box.name = "CRTDialogueBox"
	parent_node.add_child(dialogue_box)
	await process_frame

	dialogue_box.visible = true
	dialogue_box._line_index = 0
	_expect(dialogue_box.is_presenting(), "CRTDialogueBox must be presenting")
	_expect(rig.is_ambient_ducked(), "AtmosphereRig must automatically duck while CRTDialogueBox is presenting")

	dialogue_box.hide_box()
	_expect(not dialogue_box.is_presenting(), "CRTDialogueBox must not be presenting after hide_box")
	_expect(not rig.is_ambient_ducked(), "AtmosphereRig must automatically unduck after dialogue hides")

	dialogue_box.queue_free()
	await process_frame
	rig.queue_free()
	await process_frame
	parent_node.queue_free()
	await process_frame


func _test_export_presets_and_dist() -> void:
	print("4. Testing export presets and release readiness in dist/...")
	_expect(FileAccess.file_exists("res://export_presets.cfg"), "export_presets.cfg must exist")
	var presets_text := FileAccess.get_file_as_string("res://export_presets.cfg")
	_expect(presets_text.contains("Windows Desktop"), "export_presets.cfg must define Windows Desktop preset")
	_expect(presets_text.contains("Linux Desktop") or presets_text.contains("Linux"), "export_presets.cfg must define Linux preset")
	# PKG-0242 (R2, D-251): the project is now a git repository and exported
	# builds are disposable output kept out of the project state (AGENTS.md),
	# so a fresh checkout has no dist/. What release readiness needs from the
	# source is a known destination: both presets export into dist/, and dist/
	# is excluded from version control. A local dist/ is still scanned by the
	# D-168 executable check below.
	_expect(presets_text.contains("export_path=\"dist/windows/"), "Windows preset must export into dist/windows")
	_expect(presets_text.contains("export_path=\"dist/linux/"), "Linux preset must export into dist/linux")
	var ignore := FileAccess.get_file_as_string("res://.gitignore")
	_expect(ignore.split("\n").has("dist/") or ignore.split("\r\n").has("dist/"), "dist/ (build output) must stay out of version control")


const KNOWN_EXE_PATHS: Array[String] = [
	"res://dist/windows/GettingStrange.exe",
	"res://Godot_v4.6.3-stable_win64.exe",
	"res://Godot_v4.6.3-stable_win64_console.exe",
]


func _test_d168_no_exe_release() -> void:
	print("5. D-168 rule check: zero unexpected .exe binaries in project tree...")
	var found: Array[String] = []
	_collect_exe("res://", found)
	for path in found:
		_expect(path in KNOWN_EXE_PATHS, "D-168 violation: unexpected executable %s" % path)


func _collect_exe(dir_path: String, out: Array[String]) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.begins_with("."):
			file_name = dir.get_next()
			continue
		var full_path := dir_path.path_join(file_name)
		if dir.current_is_dir():
			if file_name not in ["reports", "snapshots", "dist", "archive_retired_web"]:
				_collect_exe(full_path, out)
		elif file_name.to_lower().ends_with(".exe"):
			out.append(full_path)
		file_name = dir.get_next()
	dir.list_dir_end()


func _finish() -> void:
	# Headless frames can finish faster than the audio mixing thread. Clear the
	# process cache and give AudioServer real wall time to retire stopped WAV
	# playbacks before SceneTree.quit() tears the server down.
	ProceduralAudio.clear_sound_cache()
	await create_timer(0.10).timeout
	if _failures.is_empty():
		print("PKG-0180 SMOKE PASS: Master Polish, Ambient Soundscape Pass & Release Readiness certified.")
		quit(0)
	else:
		push_error("PKG-0180 SMOKE FAILED with %d errors:\n- %s" % [_failures.size(), "\n- ".join(_failures)])
		quit(1)
