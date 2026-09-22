extends SceneTree

## PKG-0211 gate — spis i pin silnika syntezy ProceduralAudio
## (decyzja D-225: audyt architektoniczny i kontrakt techniczny audio).
##
## Pinuje mierzalne kontrakty w kodzie i runtime silnika proceduralnego audio:
## (1) Spis statyczny: 265 funkcji statycznych, 256 generatorów create_*,
##     250 bezparametrowych, 6 sparametryzowanych, 9 funkcji pomocniczych;
## (2) Kontrakt fali PCM: AudioStreamWAV, FORMAT_16_BITS, 44100 Hz, mono (stereo == false),
##     parzysty rozmiar bufora bajtów data.size() > 0;
## (3) Kontrakt pętli: generator generate_looping_wav (LOOP_FORWARD, loop_begin == 0,
##     loop_end > 0) w create_anchor_sustain_tone_sound i create_prop_drag_scrape_sound;
## (4) Cykl życia pamięci podręcznej: get_cached_sound zwraca tę samą instancję,
##     get_sound_cache_size, clear_sound_cache zeruje bufor;
## (5) Oczyszczanie odtwarzaczy: drain_playback zatrzymuje odtwarzanie i zeruje
##     strumień we wszystkich AudioStreamPlayer / AudioStreamPlayer2D / 3D w drzewie.

const AUDIO_PATH := "res://scripts/audio/procedural_audio.gd"

const EXPECTED_TOTAL_STATIC_FUNCS := 265
const EXPECTED_CREATE_FUNCS := 256
const EXPECTED_PARAMETRIZED_FUNCS := 6
const EXPECTED_HELPER_FUNCS := 9
const EXPECTED_SAMPLE_RATE := 44100

const PARAMETRIZED_NAMES: Array[String] = [
	"create_land_sound",
	"create_dialogue_blip_sound",
	"create_crosswalk_signal_sound",
	"create_bus_engine_sound",
	"create_surface_land_sound",
	"create_dialogue_blip_for_speaker",
]

const HELPER_NAMES: Array[String] = [
	"get_cached_sound",
	"clear_sound_cache",
	"drain_playback",
	"_stop_player",
	"_stop_player_2d",
	"_stop_player_3d",
	"get_sound_cache_size",
	"generate_wav",
	"generate_looping_wav",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0211: " + message)


func _read_file(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	_expect(f != null, "file must be readable: %s" % path)
	if f == null:
		return ""
	var content := f.get_as_text().replace("\r\n", "\n")
	f.close()
	return content


func _run() -> void:
	_check_static_census()
	_check_stream_pcm_contracts()
	_check_looping_sound_contracts()
	_check_cache_subsystem()
	_check_drain_playback()
	await _check_runtime_frames()
	_finish()


# ─── 1. Spis statyczny ProceduralAudio ───────────────────────────────────────

func _check_static_census() -> void:
	var src := _read_file(AUDIO_PATH)
	if src.is_empty():
		return

	_expect(src.contains("class_name ProceduralAudio"), "must define class_name ProceduralAudio")
	_expect(src.contains("extends RefCounted"), "must extend RefCounted")
	_expect(src.contains("const SAMPLE_RATE: int = 44100"), "SAMPLE_RATE must be 44100")

	var lines := src.split("\n")
	var static_funcs: Array[String] = []
	var create_funcs: Array[String] = []

	for line: String in lines:
		var trimmed := line.strip_edges()
		if trimmed.begins_with("static func "):
			static_funcs.append(trimmed)
			if trimmed.begins_with("static func create_"):
				create_funcs.append(trimmed)

	_expect(static_funcs.size() == EXPECTED_TOTAL_STATIC_FUNCS,
		"expected %d static funcs, got %d" % [EXPECTED_TOTAL_STATIC_FUNCS, static_funcs.size()])
	_expect(create_funcs.size() == EXPECTED_CREATE_FUNCS,
		"expected %d create_* funcs, got %d" % [EXPECTED_CREATE_FUNCS, create_funcs.size()])

	for helper: String in HELPER_NAMES:
		_expect(src.contains("static func " + helper), "helper function missing: %s" % helper)

	for param_func: String in PARAMETRIZED_NAMES:
		_expect(src.contains("static func " + param_func + "("), "parametrized func missing: %s" % param_func)

	_expect(src.contains("static func generate_wav(duration: float, generator_func: Callable) -> AudioStreamWAV:"),
		"generate_wav signature must match contract")
	_expect(src.contains("static func generate_looping_wav(duration: float, generator_func: Callable) -> AudioStreamWAV:"),
		"generate_looping_wav signature must match contract")


# ─── 2. Kontrakt fali PCM generowanych strumieni ────────────────────────────

func _verify_stream(stream: AudioStreamWAV, sound_name: String) -> void:
	_expect(stream != null, "%s must not be null" % sound_name)
	if stream == null:
		return
	_expect(stream.format == AudioStreamWAV.FORMAT_16_BITS,
		"%s format must be FORMAT_16_BITS (got %d)" % [sound_name, stream.format])
	_expect(stream.mix_rate == EXPECTED_SAMPLE_RATE,
		"%s mix_rate must be %d (got %d)" % [sound_name, EXPECTED_SAMPLE_RATE, stream.mix_rate])
	_expect(stream.stereo == false,
		"%s must be mono" % sound_name)
	_expect(stream.data.size() > 0,
		"%s PCM data buffer must not be empty" % sound_name)
	_expect(stream.data.size() % 2 == 0,
		"%s PCM data buffer must have even size for 16-bit samples" % sound_name)


func _check_stream_pcm_contracts() -> void:
	# Core player & locomotion
	_verify_stream(ProceduralAudio.create_footstep_linoleum_sound(), "create_footstep_linoleum_sound")
	_verify_stream(ProceduralAudio.create_footstep_metal_sound(), "create_footstep_metal_sound")
	_verify_stream(ProceduralAudio.create_ladder_rung_climb_sound(), "create_ladder_rung_climb_sound")
	_verify_stream(ProceduralAudio.create_land_sound(false), "create_land_sound(false)")
	_verify_stream(ProceduralAudio.create_land_sound(true), "create_land_sound(true)")
	_verify_stream(ProceduralAudio.create_surface_land_sound(0), "create_surface_land_sound(0)")

	# Core mechanics: Anchor & Yield
	_verify_stream(ProceduralAudio.create_anchor_sound(), "create_anchor_sound")
	_verify_stream(ProceduralAudio.create_unanchor_sound(), "create_unanchor_sound")
	_verify_stream(ProceduralAudio.create_anchor_grip_sound(), "create_anchor_grip_sound")
	_verify_stream(ProceduralAudio.create_anchor_release_sound(), "create_anchor_release_sound")
	_verify_stream(ProceduralAudio.create_yield_collapse_sound(), "create_yield_collapse_sound")
	_verify_stream(ProceduralAudio.create_resist_sound(), "create_resist_sound")

	# Dialogue speech blips
	_verify_stream(ProceduralAudio.create_dialogue_blip_sound(true), "create_dialogue_blip_sound(true)")
	_verify_stream(ProceduralAudio.create_dialogue_blip_sound(false), "create_dialogue_blip_sound(false)")
	for speaker: String in ["LENA", "MARTA", "JAKUB", "WIERZBICKA", "SZYMON", "UNKNOWN"]:
		_verify_stream(ProceduralAudio.create_dialogue_blip_for_speaker(speaker), "blip_for_" + speaker)

	# Crosswalk & Environmental
	_verify_stream(ProceduralAudio.create_crosswalk_signal_sound(false), "create_crosswalk_signal_sound(false)")
	_verify_stream(ProceduralAudio.create_crosswalk_signal_sound(true), "create_crosswalk_signal_sound(true)")
	_verify_stream(ProceduralAudio.create_bus_engine_sound(false), "create_bus_engine_sound(false)")
	_verify_stream(ProceduralAudio.create_bus_engine_sound(true), "create_bus_engine_sound(true)")
	_verify_stream(ProceduralAudio.create_bus_door_pneumatic_sound(), "create_bus_door_pneumatic_sound")
	_verify_stream(ProceduralAudio.create_tram_traction_sound(), "create_tram_traction_sound")

	# Station Family Samples (Act I..IV, Finales, Epilogue)
	_verify_stream(ProceduralAudio.create_act1_fluorescent_ballast_hum_sound(), "create_act1_fluorescent_ballast_hum_sound")
	_verify_stream(ProceduralAudio.create_phone_ring_pulse_sound(), "create_phone_ring_pulse_sound")
	_verify_stream(ProceduralAudio.create_apartment_door_sound(), "create_apartment_door_sound")
	_verify_stream(ProceduralAudio.create_teletype_relay_ambience_sound(), "create_teletype_relay_ambience_sound")
	_verify_stream(ProceduralAudio.create_flickering_neon_buzz_sound(), "create_flickering_neon_buzz_sound")
	_verify_stream(ProceduralAudio.create_transformer_oil_hum_sound(), "create_transformer_oil_hum_sound")
	_verify_stream(ProceduralAudio.create_high_voltage_spark_sound(), "create_high_voltage_spark_sound")
	_verify_stream(ProceduralAudio.create_high_voltage_hum_sound(), "create_high_voltage_hum_sound")
	_verify_stream(ProceduralAudio.create_finale_42a_forced_return_sound(), "create_finale_42a_forced_return_sound")
	_verify_stream(ProceduralAudio.create_finale_42b_closure_sound(), "create_finale_42b_closure_sound")
	_verify_stream(ProceduralAudio.create_finale_42c_reciprocal_passage_sound(), "create_finale_42c_reciprocal_passage_sound")
	_verify_stream(ProceduralAudio.create_epilogue_radio_announcement_sound(), "create_epilogue_radio_announcement_sound")
	_verify_stream(ProceduralAudio.create_epilogue_cup_clink_sound(), "create_epilogue_cup_clink_sound")
	_verify_stream(ProceduralAudio.create_epilogue_final_carrier_sound(), "create_epilogue_final_carrier_sound")

	# Cached Haptic Layer
	_verify_stream(ProceduralAudio.create_contact_tap_sound(), "create_contact_tap_sound")
	_verify_stream(ProceduralAudio.create_switch_detent_sound(), "create_switch_detent_sound")
	_verify_stream(ProceduralAudio.create_probe_brush_sound(), "create_probe_brush_sound")


# ─── 3. Kontrakt pętli (generate_looping_wav) ────────────────────────────────

func _check_looping_sound_contracts() -> void:
	var sustain: AudioStreamWAV = ProceduralAudio.create_anchor_sustain_tone_sound()
	_verify_stream(sustain, "create_anchor_sustain_tone_sound")
	_expect(sustain.loop_mode == AudioStreamWAV.LOOP_FORWARD, "sustain tone loop_mode must be LOOP_FORWARD")
	_expect(sustain.loop_begin == 0, "sustain tone loop_begin must be 0")
	_expect(sustain.loop_end > 0, "sustain tone loop_end must be > 0")

	var drag: AudioStreamWAV = ProceduralAudio.create_prop_drag_scrape_sound()
	_verify_stream(drag, "create_prop_drag_scrape_sound")
	_expect(drag.loop_mode == AudioStreamWAV.LOOP_FORWARD, "prop drag loop_mode must be LOOP_FORWARD")
	_expect(drag.loop_begin == 0, "prop drag loop_begin must be 0")
	_expect(drag.loop_end > 0, "prop drag loop_end must be > 0")


# ─── 4. Pamięć podręczna (Sound Cache) ───────────────────────────────────────

func _check_cache_subsystem() -> void:
	ProceduralAudio.clear_sound_cache()
	_expect(ProceduralAudio.get_sound_cache_size() == 0, "cache must be empty after clear")

	var key: StringName = &"pkg_0211_test_key"
	var gen_counter: Array[int] = [0]
	var gen := func() -> AudioStreamWAV:
		gen_counter[0] += 1
		return ProceduralAudio.create_anchor_sound()

	var s1 := ProceduralAudio.get_cached_sound(key, gen)
	_expect(s1 != null, "cached sound must not be null")
	_expect(gen_counter[0] == 1, "generator must be called on first fetch")
	_expect(ProceduralAudio.get_sound_cache_size() == 1, "cache size must be 1")

	var s2 := ProceduralAudio.get_cached_sound(key, gen)
	_expect(s1 == s2, "subsequent call with same key must return identical stream instance")
	_expect(gen_counter[0] == 1, "generator must not be called again on cache hit")
	_expect(ProceduralAudio.get_sound_cache_size() == 1, "cache size must remain 1 on hit")

	ProceduralAudio.clear_sound_cache()
	_expect(ProceduralAudio.get_sound_cache_size() == 0, "cache must be 0 after second clear")


# ─── 5. Oczyszczanie odtwarzaczy (drain_playback) ────────────────────────────

func _check_drain_playback() -> void:
	var container := Node2D.new()
	var p1 := AudioStreamPlayer.new()
	var p2 := AudioStreamPlayer2D.new()
	var child_node := Node2D.new()
	var p3 := AudioStreamPlayer2D.new()

	container.add_child(p1)
	container.add_child(p2)
	container.add_child(child_node)
	child_node.add_child(p3)

	var stream: AudioStreamWAV = ProceduralAudio.create_footstep_linoleum_sound()
	p1.stream = stream
	p2.stream = stream
	p3.stream = stream

	_expect(p1.stream != null, "p1 stream must be set before drain")
	_expect(p2.stream != null, "p2 stream must be set before drain")
	_expect(p3.stream != null, "p3 stream must be set before drain")

	ProceduralAudio.drain_playback(container)

	_expect(p1.stream == null, "p1 stream must be null after drain_playback")
	_expect(p2.stream == null, "p2 stream must be null after drain_playback")
	_expect(p3.stream == null, "p3 stream must be null after drain_playback")

	p3.queue_free()
	child_node.queue_free()
	p2.queue_free()
	p1.queue_free()
	container.queue_free()


# ─── 6. Runtime klatki ───────────────────────────────────────────────────────

func _check_runtime_frames() -> void:
	await process_frame
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0211 PROCEDURAL AUDIO CENSUS PASS: %d static funcs (%d create_*), PCM 16-bit 44.1kHz, loops, cache & drain verified." % [
			EXPECTED_TOTAL_STATIC_FUNCS,
			EXPECTED_CREATE_FUNCS
		])
		quit(0)
	else:
		print("PKG-0211 PROCEDURAL AUDIO CENSUS FAIL: %d failures" % _failures.size())
		for f: String in _failures:
			print(" - %s" % f)
		quit(1)
