extends SceneTree

const CSV_PATH := "res://resources/localization/getting_strange_locales.csv"
const CSV_IMPORT_PATH := CSV_PATH + ".import"
const CSV_EN_TRANSLATION_PATH := "res://resources/localization/getting_strange_locales.en.translation"
const CSV_PL_TRANSLATION_PATH := "res://resources/localization/getting_strange_locales.pl.translation"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0188: " + message)


func _run() -> void:
	_test_single_pcm_boundary()
	_test_retired_locale_donor_routing()
	if _failures.is_empty():
		print("PKG-0188 HYGIENE PASS: one PCM saturation boundary; legacy CSV locale donor is retired and unregistered.")
		quit(0)
		return
	for failure in _failures:
		print("PKG-0188 FAILURE: " + failure)
	quit(1)


func _test_single_pcm_boundary() -> void:
	var source := FileAccess.get_file_as_string("res://scripts/audio/procedural_audio.gd")
	_expect(source.contains("tanh(raw) * 0.94"), "PCM encoding must apply tanh(raw) * 0.94")
	_expect(
		source.count("tanh(raw) * 0.94") == 1,
		"the exact PCM saturation contract must occur once, in generate_wav"
	)
	_expect(not source.contains("return clampf("), "audio factories must return raw samples; only generate_wav may constrain PCM")

	var wav := ProceduralAudio.generate_wav(1.0 / float(ProceduralAudio.SAMPLE_RATE), func(_t: float, _duration: float) -> float:
		return 4.0
	)
	_expect(wav != null and wav.data.size() == 2, "one-sample signal must encode as 16-bit PCM")
	if wav == null or wav.data.size() != 2:
		return
	var encoded := float(wav.data.decode_s16(0)) / 32767.0
	var expected := tanh(4.0) * 0.94
	_expect(absf(encoded - expected) < 0.002, "raw overload must reach tanh boundary; pre-clamp would encode about 0.716, got %.3f" % encoded)
	_expect(encoded > 0.90 and encoded < 0.95, "PCM headroom must retain tanh * 0.94, got %.3f" % encoded)


func _test_retired_locale_donor_routing() -> void:
	_expect(FileAccess.file_exists(CSV_PATH), "retired CSV donor must remain auditable on disk")
	_expect(FileAccess.file_exists(CSV_IMPORT_PATH), "retired CSV donor must retain its import manifest")
	_expect(FileAccess.file_exists(CSV_EN_TRANSLATION_PATH), "retired CSV donor must retain EN import output")
	_expect(FileAccess.file_exists(CSV_PL_TRANSLATION_PATH), "retired CSV donor must retain PL import output")
	var csv := FileAccess.get_file_as_string(CSV_PATH)
	_expect(csv.contains("[C / SHIFT]"), "retired CSV proof must retain the stale pre-InputMap binding")
	var project := FileAccess.get_file_as_string("res://project.godot")
	_expect(not project.contains("getting_strange_locales"), "retired CSV must not be registered by project settings")
	var localization_source := FileAccess.get_file_as_string("res://scripts/core/localization_manager.gd")
	_expect(not localization_source.contains("getting_strange_locales"), "LocalizationManager must not route through the retired CSV donor")
	_expect(LocalizationManager.tr_key("MENU_NEW_GAME") == "NOWA GRA", "runtime PL localization must come from LocalizationManager")
	LocalizationManager.set_locale("en")
	_expect(LocalizationManager.tr_key("MENU_NEW_GAME") == "NEW GAME", "runtime EN localization must come from LocalizationManager")
	LocalizationManager.set_locale("pl")