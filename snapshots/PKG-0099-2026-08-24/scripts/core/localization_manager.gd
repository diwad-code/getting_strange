class_name LocalizationManager
extends RefCounted

## LocalizationManager for Getting Strange (Godot 4.7)
## Handles bilingual runtime localization (PL / EN) with fallback and signal emission.

const SUPPORTED_LOCALES: Array[String] = ["pl", "en"]
static var current_locale: String = "pl"

static var _translations: Dictionary = {
	"pl": {
		"UI_START_EXPERIMENT": "ROZPOCZNIJ POMIAR (21:45)",
		"UI_MOVEMENT_PROFILE": "PROFIL RUCHU:",
		"UI_PROFILE_A": "PROFIL A: BAZOWY (IKP STANDARD)",
		"UI_PROFILE_B": "PROFIL B: SPRĘŻYSTY (SZYBKI)",
		"UI_PROFILE_C": "PROFIL C: INERCYJNY (MASA)",
		"UI_RESTART_HINT": "[R] RESTART KOMORY",
		"UI_ANCHOR_HINT": "[C / SHIFT] ZAKOTWICZENIE MATERII",
		"UI_INTERACT_HINT": "[E / SPACJA] INTERAKCJA / REZONANS"
	},
	"en": {
		"UI_START_EXPERIMENT": "START EXPERIMENT (21:45)",
		"UI_MOVEMENT_PROFILE": "MOVEMENT PROFILE:",
		"UI_PROFILE_A": "PROFILE A: BASELINE (IKP STANDARD)",
		"UI_PROFILE_B": "PROFILE B: SNAPPY (FAST)",
		"UI_PROFILE_C": "PROFILE C: INERTIAL (HEAVY)",
		"UI_RESTART_HINT": "[R] RESTART CHAMBER",
		"UI_ANCHOR_HINT": "[C / SHIFT] ANCHOR MATTER",
		"UI_INTERACT_HINT": "[E / SPACE] INTERACT / RESONANCE"
	}
}


static func set_locale(locale_code: String) -> void:
	if locale_code in SUPPORTED_LOCALES:
		current_locale = locale_code
		TranslationServer.set_locale(locale_code)


static func get_locale() -> String:
	return current_locale


static func tr_key(key: String, fallback: String = "") -> String:
	var dict: Dictionary = _translations.get(current_locale, _translations["pl"])
	if dict.has(key):
		return dict[key]
	var engine_tr: String = TranslationServer.translate(key)
	if engine_tr != "" and engine_tr != key:
		return engine_tr
	return fallback if fallback != "" else key
