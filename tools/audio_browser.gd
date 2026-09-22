extends SceneTree

## PKG-0227 / K28 — Dev-Audio-Browser (NIE bramka, TYLKO test_mode).
##
## Koniec szukania "ktory create_ to ten brzek": lista generatorow
## ProceduralAudio + info (format/mix/dlugosc/hash) + play wybranego
## klucza. Narzedzie developerskie: NIE jest rejestrowane w
## tools/verify.ps1, gra go nie referencjonuje (pinuje to bramka
## pkg_0227: devtool_isolation), a bez flagi odmawia startu.
##
## Uzycie (wylacznie reczne):
##   godot --headless --path . --script res://tools/audio_browser.gd -- --allow-audio-browser --list
##   godot --headless --path . --script res://tools/audio_browser.gd -- --allow-audio-browser --info=lena
##   godot --path . --script res://tools/audio_browser.gd -- --allow-audio-browser --play=marta
##
## Klucz to fragment nazwy generatora (np. "lena", "marta", "jakub",
## "wierzbicka", "szymon", "system", "ambient", "footstep").

const SOURCE_PATH := "res://scripts/audio/procedural_audio.gd"
const HASH_CAP := 65536


func _initialize() -> void:
	call_deferred("_run")


func _list_generators(source: String) -> Array[String]:
	var out: Array[String] = []
	var re := RegEx.new()
	if re.compile("static func (create_[A-Za-z0-9_]+)") != OK:
		return out
	var pos := 0
	while true:
		var hit: RegExMatch = re.search(source, pos)
		if hit == null:
			break
		out.append(hit.get_string(1))
		pos = hit.get_end()
		if pos >= source.length():
			break
	return out


func _fnv1a(data: PackedByteArray, cap: int) -> String:
	var h: int = 2166136261
	var n: int = mini(data.size(), cap)
	for i in range(n):
		h = h ^ data[i]
		h = (h * 16777619) & 0xFFFFFFFF
	return "%08x" % h


func _describe(stream: AudioStreamWAV) -> String:
	var frames: int = stream.get_length() * stream.mix_rate if stream.mix_rate > 0 else 0
	var hash_note := ""
	if stream.data != null and not stream.data.is_empty():
		var capped := ""
		if stream.data.size() > HASH_CAP:
			capped = ",capped"
		hash_note = " hash=%s%s" % [_fnv1a(stream.data, HASH_CAP), capped]
	return "format=%d mix=%d stereo=%s len=%.3fs%s" % [
		stream.format, stream.mix_rate, str(stream.stereo),
		stream.get_length(), hash_note]


func _make(key: String) -> AudioStreamWAV:
	match key:
		"lena":
			return ProceduralAudio.create_dialogue_lena_blip_sound()
		"marta":
			return ProceduralAudio.create_dialogue_marta_blip_sound()
		"jakub":
			return ProceduralAudio.create_dialogue_jakub_blip_sound()
		"wierzbicka":
			return ProceduralAudio.create_dialogue_wierzbicka_blip_sound()
		"szymon":
			return ProceduralAudio.create_szymon_dialogue_blip_sound()
		"system":
			return ProceduralAudio.create_dialogue_system_blip_sound()
		"elderly":
			return ProceduralAudio.create_dialogue_elderly_woman_sound()
	return null


func _run() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if not args.has("--allow-audio-browser"):
		print("AUDIO-BROWSER: test_mode only — pass --allow-audio-browser (never from game code).")
		quit(1)
		return
	var file: FileAccess = FileAccess.open(SOURCE_PATH, FileAccess.READ)
	if file == null:
		push_error("AUDIO-BROWSER: cannot read " + SOURCE_PATH)
		quit(1)
		return
	var source: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	var generators: Array[String] = _list_generators(source)
	for arg: String in args:
		if arg == "--list":
			print("AUDIO-BROWSER: %d generators" % generators.size())
			for g: String in generators:
				print(" - " + g)
			quit(0)
			return
		if arg.begins_with("--info="):
			var key: String = arg.trim_prefix("--info=").to_lower()
			var stream: AudioStreamWAV = _make(key)
			if stream == null:
				print("AUDIO-BROWSER: unknown voice key '%s' (try lena/marta/jakub/wierzbicka/szymon/system/elderly)" % key)
				quit(1)
				return
			print("AUDIO-BROWSER: %s -> %s" % [key, _describe(stream)])
			quit(0)
			return
		if arg.begins_with("--play="):
			var pkey: String = arg.trim_prefix("--play=").to_lower()
			var pstream: AudioStreamWAV = _make(pkey)
			if pstream == null:
				print("AUDIO-BROWSER: unknown voice key '%s'" % pkey)
				quit(1)
				return
			var player := AudioStreamPlayer.new()
			root.add_child(player)
			player.stream = pstream
			player.play()
			await create_timer(pstream.get_length() + 0.2).timeout
			print("AUDIO-BROWSER: played %s (%s)" % [pkey, _describe(pstream)])
			player.queue_free()
			quit(0)
			return
	print("AUDIO-BROWSER: %d generators; use --list, --info=<voice>, --play=<voice>" % generators.size())
	quit(0)
