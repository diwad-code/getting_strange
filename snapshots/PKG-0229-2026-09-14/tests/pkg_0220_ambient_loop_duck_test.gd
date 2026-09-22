extends SceneTree

## PKG-0220 gate — ambient loops + duck (A1+A2 z domieszka A3/A4, faza R4 planu PKG-0213 §8).
##
## Pinuje wylacznie kontrakty mierzalne, nigdy odbior (D-012, ADR-003):
## (1) A1 petle: 7 ambientow PKG-0180 (viaduct/perimeter/substation/vault/analyzer/
##     ledger/dawn river) na generate_looping_wav (LOOP_FORWARD, begin 0, end > 0),
##     kontrakt PCM (16-bit, 44100, mono, bufor parzysty), dlugosci jak przed pakietem
##     (2.20/2.40/2.20/2.30/2.20/2.10/2.60 s), krawedzie slyszalne (RMS > progu —
##     koniec szczeliny retriggera), szew bez pelnoskalowego trzasku, f0 nietkniete
##     (statyczny grep czestotliwosci + generate_looping_wav w kazdej funkcji);
## (2) A2 duck: wszystkie 3 playery rigu (hum + sub + unease) schodza o >= 5 dB
##     przy dialogu i wracaja po koncu (wczesniej tylko hum+sub);
## (3) A3 busy/komentarz: busy Ambient/Dialogue istnieja, playery rigu na Ambient,
##     komentarz o celowo niepozycjonowanym ambiencie w pliku;
## (4) A1 double-buffer: _ambient_back istnieje, niesie te sama zapetlona instancje
##     co primary (hot spare, wyciszony), zero retriggera finished->play;
## (5) A4 drain: ProceduralAudio.drain_playback w _exit_tree (grep), drain idempotentny
##     (2x bez bledu, strumienie null, cache nietkniety, double clear bezpieczny);
## (6) Fail-closed: kontrola one-shot (anchor) ma LOOP_NONE — test rozroznia petle;
## (7) Census D-225 stoi: 265 staticow w procedural_audio.gd (zero nowych helperow).

const RigClass := preload("res://scripts/levels/atmosphere_rig.gd")

const AUDIO_PATH := "res://scripts/audio/procedural_audio.gd"
const RIG_PATH := "res://scripts/levels/atmosphere_rig.gd"

const EXPECTED_STATIC_FUNCS := 265
const SAMPLE_RATE := 44100
const EDGE_SAMPLES := 4410
const EDGE_RMS_MIN := 500.0
const SEAM_STEP_MAX := 12000

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0220: " + message)


func _read(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	_expect(f != null, "file must be readable: %s" % path)
	if f == null:
		return ""
	var text: String = f.get_as_text().replace("\r\n", "\n")
	f.close()
	return text


func _run() -> void:
	_check_static_contracts()
	_check_loop_streams()
	_check_fail_closed_control()
	await _check_duck_and_routing()
	_check_drain_idempotent()
	await _check_runtime_frames()
	_finish()


# ─── 1. Statyka: petle w 7 funkcjach, f0, census, rig ─────────────────────────

func _check_static_contracts() -> void:
	print("1. Static contracts: 7 loops, f0 markers, census 265, rig wiring...")
	var src := _read(AUDIO_PATH)
	if src.is_empty():
		return
	var names: Array[String] = [
		"create_outdoor_viaduct_wind_sound",
		"create_outdoor_perimeter_wind_sound",
		"create_subterranean_substation_resonance_sound",
		"create_signal_vault_resonance_sound",
		"create_analyzer_cooling_conduit_drone_sound",
		"create_archive_ledger_resonance_sound",
		"create_dawn_river_ambience_sound",
	]
	var markers: Array[String] = [
		"55.0",
		"42.0",
		"50.0",
		"44.0",
		"40.0",
		"52.0",
		"261.63",
	]
	for i in range(names.size()):
		var fname: String = names[i]
		var at := src.find("static func " + fname + "(")
		_expect(at >= 0, "ambient func missing: %s" % fname)
		if at < 0:
			continue
		var nxt := src.find("static func ", at + 10)
		var body := src.substr(at, (nxt - at) if nxt > at else 2400)
		_expect(body.contains("generate_looping_wav"), "%s must use generate_looping_wav" % fname)
		_expect(not body.contains("generate_wav(duration"), "%s must not use one-shot generate_wav" % fname)
		_expect(body.contains("var env := 1.0"), "%s must carry loop-safe envelope" % fname)
		_expect(body.contains(markers[i]), "%s must keep f0 marker %s" % [fname, markers[i]])
	var statics := 0
	for line: String in src.split("\n"):
		if line.strip_edges().begins_with("static func "):
			statics += 1
	_expect(statics == EXPECTED_STATIC_FUNCS, "procedural_audio must keep %d static funcs (got %d)" % [EXPECTED_STATIC_FUNCS, statics])
	var rig := _read(RIG_PATH)
	if rig.is_empty():
		return
	_expect(rig.contains("ProceduralAudio.drain_playback(self)"), "rig _exit_tree must drain via helper")
	_expect(rig.contains("niepozycjonowany"), "rig must document intentionally non-positioned ambient")
	_expect(rig.contains("_ambient_back"), "rig must carry double-buffer _ambient_back")
	_expect(rig.contains("BASE_UNEASE_VOLUME_DB"), "rig must pin unease base volume const")
	_expect(rig.contains("AMBIENT_BUS_NAME"), "rig must route via AMBIENT_BUS_NAME")
	_expect(not rig.contains("finished.connect(_fluorescent_hum.play)"), "rig must drop finished->play retrigger (hum)")
	_expect(not rig.contains("finished.connect(_substructure_player.play)"), "rig must drop finished->play retrigger (sub)")


# ─── 2. Petle w runtime: PCM + loop + dlugosc + krawedzie + szew ───────────────

func _stream_frames(s: AudioStreamWAV) -> int:
	return s.data.size() / 2


func _edge_rms(s: AudioStreamWAV, from_head: bool) -> float:
	var total := _stream_frames(s)
	var acc := 0.0
	for i in range(EDGE_SAMPLES):
		var idx := i if from_head else (total - EDGE_SAMPLES + i)
		var v := float(s.data.decode_s16(idx * 2))
		acc += v * v
	return sqrt(acc / float(EDGE_SAMPLES))


func _verify_loop(name: String, s: AudioStreamWAV, expected_len: float) -> void:
	_expect(s != null, "%s must not be null" % name)
	if s == null:
		return
	_expect(s.format == AudioStreamWAV.FORMAT_16_BITS, "%s must be 16-bit" % name)
	_expect(s.mix_rate == SAMPLE_RATE, "%s must be 44100 Hz" % name)
	_expect(s.stereo == false, "%s must be mono" % name)
	_expect(s.data.size() > 0 and s.data.size() % 2 == 0, "%s buffer must be non-empty even" % name)
	_expect(s.loop_mode == AudioStreamWAV.LOOP_FORWARD, "%s loop_mode must be LOOP_FORWARD" % name)
	_expect(s.loop_begin == 0, "%s loop_begin must be 0" % name)
	_expect(s.loop_end > 0, "%s loop_end must be > 0" % name)
	var frames := _stream_frames(s)
	_expect(s.loop_end == maxi(1, frames - 1), "%s loop_end must pin buffer end" % name)
	var length := float(frames) / float(SAMPLE_RATE)
	_expect(absf(length - expected_len) < 0.02, "%s length must stay %.2f s (got %.3f)" % [name, expected_len, length])
	_expect(_edge_rms(s, true) > EDGE_RMS_MIN, "%s head edge must be audible (no gap dip)" % name)
	_expect(_edge_rms(s, false) > EDGE_RMS_MIN, "%s tail edge must be audible (no gap dip)" % name)
	var first := s.data.decode_s16(0)
	var last := s.data.decode_s16((frames - 1) * 2)
	_expect(absi(last - first) < SEAM_STEP_MAX, "%s seam step must stay below click (got %d)" % [name, absi(last - first)])


func _check_loop_streams() -> void:
	print("2. Seven PKG-0180 ambients must loop gapless with f0 intact...")
	_verify_loop("viaduct", ProceduralAudio.create_outdoor_viaduct_wind_sound(), 2.20)
	_verify_loop("perimeter", ProceduralAudio.create_outdoor_perimeter_wind_sound(), 2.40)
	_verify_loop("substation", ProceduralAudio.create_subterranean_substation_resonance_sound(), 2.20)
	_verify_loop("vault", ProceduralAudio.create_signal_vault_resonance_sound(), 2.30)
	_verify_loop("analyzer", ProceduralAudio.create_analyzer_cooling_conduit_drone_sound(), 2.20)
	_verify_loop("ledger", ProceduralAudio.create_archive_ledger_resonance_sound(), 2.10)
	_verify_loop("dawn_river", ProceduralAudio.create_dawn_river_ambience_sound(), 2.60)
	# Wczesniejsze petle calkowito-okresowe stoja (crossfade w helperze ich nie lamie).
	var sustain: AudioStreamWAV = ProceduralAudio.create_anchor_sustain_tone_sound()
	_expect(sustain.loop_mode == AudioStreamWAV.LOOP_FORWARD, "sustain must stay LOOP_FORWARD")
	var drag: AudioStreamWAV = ProceduralAudio.create_prop_drag_scrape_sound()
	_expect(drag.loop_mode == AudioStreamWAV.LOOP_FORWARD, "drag must stay LOOP_FORWARD")


func _check_fail_closed_control() -> void:
	print("3. Fail-closed control: one-shot must read LOOP_DISABLED...")
	var one: AudioStreamWAV = ProceduralAudio.create_anchor_sound()
	_expect(one != null, "control stream must exist")
	if one != null:
		_expect(one.loop_mode == AudioStreamWAV.LOOP_DISABLED, "one-shot control must be LOOP_DISABLED (discriminates loops)")


# ─── 3. Duck x3 + busy + double-buffer ─────────────────────────────────────────

func _check_duck_and_routing() -> void:
	print("4. Rig must duck hum+sub+unease, sit on Ambient bus, double-buffer...")
	var rig := RigClass.new()
	rig.station_number = 34
	rig.world_width = 640.0
	root.add_child(rig)
	await process_frame
	await process_frame
	_expect(rig.get_node_or_null("FluorescentHum") != null, "rig must keep FluorescentHum node")
	_expect(rig.get_node_or_null("AmbientBackBuffer") != null, "rig must carry AmbientBackBuffer node")
	_expect(rig._fluorescent_hum != null and rig._fluorescent_hum.stream != null, "hum stream must exist")
	_expect(rig._ambient_back != null and rig._ambient_back.stream != null, "back stream must exist")
	if rig._fluorescent_hum != null and rig._ambient_back != null:
		_expect(rig._ambient_back.stream == rig._fluorescent_hum.stream, "back must mirror primary loop instance")
		_expect(not rig._ambient_back.playing, "back must stay stopped (0130 counts playing voices only)")
		# Stacja 34 niesie one-shot (tempered glass) — petle rigu dowodzi osobny rig stacji 02 nizej.
		_expect(not rig._fluorescent_hum.finished.is_connected(rig._fluorescent_hum.play), "hum must carry no retrigger")
		_expect(not rig._ambient_back.finished.is_connected(rig._ambient_back.play), "back must carry no retrigger")
		_expect(rig._fluorescent_hum.bus == &"Ambient", "hum must sit on Ambient bus")
		_expect(rig._ambient_back.bus == &"Ambient", "back must sit on Ambient bus")
	_expect(AudioServer.get_bus_index("Ambient") >= 0, "Ambient bus must exist")
	_expect(AudioServer.get_bus_index("Dialogue") >= 0, "Dialogue bus must exist")
	_expect(rig._unease_player != null, "unease player must exist")
	if rig._unease_player != null:
		_expect(rig._unease_player.bus == &"Ambient", "unease must sit on Ambient bus")
	if rig._substructure_player != null:
		_expect(rig._substructure_player.bus == &"Ambient", "sub must sit on Ambient bus")
		_expect(not rig._substructure_player.finished.is_connected(rig._substructure_player.play), "sub must carry no retrigger")
	var hum_base: float = rig._fluorescent_hum.volume_db
	var sub_base: float = rig._substructure_player.volume_db
	var unease_base: float = rig._unease_player.volume_db
	_expect(is_equal_approx(hum_base, -24.0), "hum base must be -24 dB")
	_expect(is_equal_approx(sub_base, -28.0), "sub base must be -28 dB")
	_expect(is_equal_approx(unease_base, -22.0), "unease base must be -22 dB")
	rig.set_ambient_ducked(true)
	for i in range(60):
		rig._process(1.0 / 60.0)
	_expect(rig._fluorescent_hum.volume_db < hum_base - 5.0, "ducked hum must drop >= 5 dB")
	_expect(rig._substructure_player.volume_db < sub_base - 5.0, "ducked sub must drop >= 5 dB")
	_expect(rig._unease_player.volume_db < unease_base - 5.0, "ducked unease must drop >= 5 dB")
	rig.set_ambient_ducked(false)
	for i in range(60):
		rig._process(1.0 / 60.0)
	_expect(rig._fluorescent_hum.volume_db > hum_base - 1.5, "hum must recover after unduck")
	_expect(rig._substructure_player.volume_db > sub_base - 1.5, "sub must recover after unduck")
	_expect(rig._unease_player.volume_db > unease_base - 1.5, "unease must recover after unduck")
	rig.queue_free()
	await process_frame


# ─── 4. Drain idempotentny ─────────────────────────────────────────────────────

func _check_drain_idempotent() -> void:
	print("5. Drain via helper must be idempotent, cache untouched...")
	var rig := RigClass.new()
	rig.station_number = 2
	rig.world_width = 640.0
	root.add_child(rig)
	await process_frame
	_expect(rig._fluorescent_hum.stream != null, "pre-drain hum stream must exist")
	_expect(rig._ambient_back.stream != null, "pre-drain back stream must exist")
	_expect(rig._unease_player.stream != null, "pre-drain unease stream must exist")
	# Stacja 02 niesie petle viaduct — rig dowodzi petle na zywo (stacja 34 w sekcji duck ma one-shot).
	_expect(rig._fluorescent_hum.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD, "station-02 rig hum must loop")
	_expect(rig._ambient_back.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD, "station-02 rig back must loop")
	var cache_before := ProceduralAudio.get_sound_cache_size()
	_expect(cache_before > 0, "cache must hold streams before drain")
	ProceduralAudio.drain_playback(rig)
	_expect(rig._fluorescent_hum.stream == null, "hum stream must be null after drain")
	_expect(rig._ambient_back.stream == null, "back stream must be null after drain")
	_expect(rig._unease_player.stream == null, "unease stream must be null after drain")
	ProceduralAudio.drain_playback(rig)
	_expect(rig._fluorescent_hum.stream == null, "second drain must stay null (idempotent)")
	_expect(rig._ambient_back.stream == null, "second drain must stay null (idempotent)")
	_expect(ProceduralAudio.get_sound_cache_size() == cache_before, "drain must not clear the cache")
	ProceduralAudio.clear_sound_cache()
	ProceduralAudio.clear_sound_cache()
	_expect(ProceduralAudio.get_sound_cache_size() == 0, "double clear must stay empty")
	rig.queue_free()
	await process_frame


func _check_runtime_frames() -> void:
	await process_frame
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0220 AMBIENT LOOP DUCK PASS: 7 loops gapless, duck x3, Ambient/Dialogue buses, double-buffer, idempotent drain.")
		quit(0)
	else:
		print("PKG-0220 AMBIENT LOOP DUCK FAIL: %d failures" % _failures.size())
		for f: String in _failures:
			print(" - %s" % f)
		quit(1)
