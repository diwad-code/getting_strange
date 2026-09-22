extends SceneTree

## PKG-0227 / K26 — dev-raport 5 osi audio (NIE bramka, tylko test_mode).
##
## Liczy statycznie, z tresci scripts/audio/procedural_audio.gd, 5 osi
## dzwieku dla rodziny blipow dialogowych dyspozytora (LENA / MARTA /
## JAKUB / WIERZBICKA / SZYMON / SYSTEM + ELDERLY spoza dyspozytora):
## f0 (czestotliwosci TAU * N), obwiednia (exp-decay vs sine-window),
## czas trwania, skladowe noise/HF oraz AM/tremolo. Wzor: GATE-FAM
## wizualne (>= 3/5 osi na mono); audio nie ma pinu, raport lapie kolizje
## (Marta 440 vs elderly 480) przed czlowiekiem.
##
## Uzycie (wylacznie reczne, nigdy z gry ani z verify):
##   godot --headless --path . --script res://tools/audio_5axis_report.gd
##
## Uruchomienie: to narzedzie NIE jest rejestrowane w tools/verify.ps1.

const SOURCE_PATH := "res://scripts/audio/procedural_audio.gd"

## Glos -> funkcja generatora (6 z dyspozytora + elderly spoza niego).
const VOICES := {
	"LENA": "create_dialogue_lena_blip_sound",
	"MARTA": "create_dialogue_marta_blip_sound",
	"JAKUB": "create_dialogue_jakub_blip_sound",
	"WIERZBICKA": "create_dialogue_wierzbicka_blip_sound",
	"SZYMON": "create_szymon_dialogue_blip_sound",
	"SYSTEM": "create_dialogue_system_blip_sound",
	"ELDERLY": "create_dialogue_elderly_woman_sound",
}


func _initialize() -> void:
	call_deferred("_run")


func _slice_func(source: String, func_name: String) -> String:
	var start_marker: String = "static func " + func_name
	var start: int = source.find(start_marker)
	if start < 0:
		return ""
	var next: int = source.find("static func ", start + start_marker.length())
	if next < 0:
		return source.substr(start)
	return source.substr(start, next - start)


func _first_group(text: String, pattern: String) -> String:
	var re := RegEx.new()
	if re.compile(pattern) != OK:
		return "?"
	var hit: RegExMatch = re.search(text)
	if hit == null or hit.get_group_count() < 1:
		return "-"
	return hit.get_string(1)


func _all_groups(text: String, pattern: String) -> Array[String]:
	var out: Array[String] = []
	var re := RegEx.new()
	if re.compile(pattern) != OK:
		return out
	var pos := 0
	while true:
		var hit: RegExMatch = re.search(text, pos)
		if hit == null:
			break
		out.append(hit.get_string(1))
		pos = hit.get_end()
		if pos >= text.length():
			break
	return out


func _run() -> void:
	var file: FileAccess = FileAccess.open(SOURCE_PATH, FileAccess.READ)
	if file == null:
		push_error("AUDIO-5AXIS: cannot read " + SOURCE_PATH)
		quit(1)
		return
	var source: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	print("AUDIO-5AXIS REPORT (static, K26): voice | func | dur_s | f0_Hz | env | noise_HF | am_trem")
	for voice: String in VOICES.keys():
		var fname: String = VOICES[voice]
		var body: String = _slice_func(source, fname)
		if body.is_empty():
			print(" - %s | %s | MISSING" % [voice, fname])
			continue
		var dur: String = _first_group(body, "var duration := ([0-9]+\\.[0-9]+)")
		var raw_freqs: Array[String] = _all_groups(body, "TAU \\* \\(([0-9]+\\.[0-9]+)")
		var plain: Array[String] = _all_groups(body, "TAU \\* ([0-9]+\\.[0-9]+)")
		for f: String in plain:
			if not raw_freqs.has(f):
				raw_freqs.append(f)
		# f0 przez zmienna (np. Szymon: f0 := 260.0, harmoniczne f0 * 2.0/3.0).
		var base: String = _first_group(body, "f0 := ([0-9]+\\.[0-9]+)")
		if base != "-" and base.is_valid_float():
			if not raw_freqs.has(base):
				raw_freqs.append(base)
			var mults: Array[String] = _all_groups(body, "\\(f0 \\* ([0-9]+\\.[0-9]+)\\)")
			for m: String in mults:
				if m.is_valid_float():
					var h: String = "%.2f" % (base.to_float() * m.to_float())
					if not raw_freqs.has(h):
						raw_freqs.append(h)
		# Stopy modulacji (< 20 Hz) to os AM, nie f0.
		var freqs: Array[String] = []
		var rates: Array[String] = []
		for f: String in raw_freqs:
			if f.is_valid_float() and f.to_float() < 20.0:
				if not rates.has(f):
					rates.append(f)
			elif not freqs.has(f):
				freqs.append(f)
		var env := "?"
		if body.contains("exp(-t *"):
			env = "exp-decay"
		elif body.contains("sin((t / dur) * PI)"):
			env = "sine-window"
		var noise := "-"
		if body.contains("cos(t *"):
			noise = "grit"
		var hf := 0
		for f: String in freqs:
			if f.is_valid_float() and f.to_float() > 2000.0:
				hf += 1
		if hf > 0:
			noise = "%s+HFx%d" % [noise, hf] if noise != "-" else "HFx%d" % hf
		var am := "-"
		if not rates.is_empty():
			am = "rate:" + ",".join(rates)
		if body.contains("trem"):
			am = "trem" if am == "-" else am + "+trem"
		elif body.contains("tremolo"):
			am = "tremolo" if am == "-" else am + "+tremolo"
		if body.contains("TAU * 4.0") or body.contains("TAU * 3.5"):
			am = "slow-AM" if am == "-" else am + "+slow-AM"
		print(" - %s | %s | %s | %s | %s | %s | %s" % [
			voice, fname, dur, ",".join(freqs), env, noise, am])
	print("NOTE: dispatcher else-branch routes UNKNOWN speakers to system_blip;")
	print("UNKNOWN and SYSTEM are intentionally one sound (dispatcher audit).")
	print("AUDIO-5AXIS DONE.")
	quit(0)
