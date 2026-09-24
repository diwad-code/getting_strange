class_name LocalizationManager
extends RefCounted

## LocalizationManager for Getting Strange (Godot 4.7)
## Handles bilingual runtime localization (PL / EN) with fallback and signal emission.

const SUPPORTED_LOCALES: Array[String] = ["pl", "en"]
static var current_locale: String = "pl"

static var _translations: Dictionary = {
	"pl": {
		"CONFIRM_CANCEL": "ANULUJ",
		"CONFIRM_NEW_TITLE": "ZACZĄĆ OD NOWA?",
		"CONFIRM_NEW_BODY": "Nowa gra usunie obecny zapis kampanii. Tej zmiany nie da się cofnąć.",
		"CONFIRM_RESET_TITLE": "USUNĄĆ ZAPIS?",
		"CONFIRM_RESET_BODY": "Postęp kampanii zostanie usunięty. Gra wróci do ekranu tytułowego.",
		"UI_START_EXPERIMENT": "ROZPOCZNIJ POMIAR (21:45)",
		"UI_MOVEMENT_PROFILE": "PROFIL RUCHU:",
		"UI_PROFILE_A": "PROFIL A: BAZOWY (IKP STANDARD)",
		"UI_PROFILE_B": "PROFIL B: SPRĘŻYSTY (SZYBKI)",
		"UI_PROFILE_C": "PROFIL C: INERCYJNY (MASA)",
		"UI_RESTART_HINT": "[R] RESTART KOMORY",
		"UI_ANCHOR_HINT": "[E] ZAKOTWICZENIE  //  [F] KOREKTA",
		"UI_INTERACT_HINT": "[E] INTERAKCJA",
		"TITLE_SUBTITLE": "OSOBISTY THRILLER // POWRÓT PRZEZ LINIĘ 4",
		"TITLE_PERSONAL_PROMISE": "Marta czeka na Lenę. Trzy sekundy z Linii 4 nie chcą zniknąć.",
		"TITLE_RETURN_PROMISE": "LINIA 4  //  OSTATNI ODCZYT  //  POWRÓT",
		"COLD_OPEN_SKIP": "POMIŃ ▸",
		"MENU_NEW_GAME": "NOWA GRA",
		"MENU_CONTINUE": "KONTYNUUJ",
		"MENU_REPLAY_EPILOGUE": "POWTÓRZ EPILOG",
		"MENU_SETTINGS": "USTAWIENIA",
		"MENU_QUIT": "ZAKOŃCZ",
		"STATUS_SAVE_ACTIVE": "WZNÓW // %s%s",
		"STATUS_COMPLETED": "UKOŃCZONO // %s",
		"STATUS_SAVE_NONE": "ZACZNIJ // OSTATNI ODCZYT PRZY LINII 4",
		"STATUS_COMPLETED_SUFFIX": "  //  UKOŃCZONA  //  %s",
		"CONTROLS_HEADER": "RUSZ SIĘ / ZBADAJ",
		"INPUT_ACTION_MOVE_LEFT": "W LEWO",
		"INPUT_ACTION_MOVE_RIGHT": "W PRAWO",
		"INPUT_ACTION_JUMP": "SKOK",
		"INPUT_ACTION_INTERACT": "INTERAKCJA",
		"INPUT_ACTION_PAUSE": "PAUZA",
		"INPUT_ACTION_RESTART": "RESTART",
		"INPUT_ACTION_TRIGGER_CORRECTION": "KOREKTA",
		"BUILD_LABEL": "WERSJA %s",
		"SETTINGS_TITLE": "USTAWIENIA",
		"SETTINGS_LANGUAGE": "JĘZYK",
		"SETTINGS_LANGUAGE_HINT": "Język menu i interfejsu.",
		"SETTINGS_MASTER_VOLUME": "GŁOŚNOŚĆ",
		"SETTINGS_TEXT_SPEED": "TEMPO TEKSTU  //  ZNAKI/S",
		"SETTINGS_TEXT_SCALE": "SKALA TEKSTU",
		"SETTINGS_FULLSCREEN": "TRYB PEŁNOEKRANOWY",
		"SETTINGS_REDUCED_MOTION": "OGRANICZONY RUCH",
		"SETTINGS_REDUCED_MOTION_HINT": "Tłumi migotanie świetlówek, pulsowanie pola kotwiczenia, wstrząs kamery i mikro-cząstki. Nic nie znika ze świata.",
		"SETTINGS_REMAP": "STEROWANIE  //  REMAP",
		"SETTINGS_HINT": "Ustawienia zapisują się same. Dialogi: PL.",
		"SETTINGS_REMAP_TITLE": "STEROWANIE  //  REMAP AKCJI",
		"SETTINGS_REMAP_HINT": "Wybierz akcję, potem naciśnij klawisz lub przycisk pada.",
		"SETTINGS_REMAP_PENDING": "NACIŚNIJ KLAWISZ LUB PRZYCISK PADA DLA: %s\nESC / B = ANULUJ",
		"SETTINGS_REMAP_WAITING": "OCZEKIWANIE…",
		"SETTINGS_REMAP_SAVED": "ZAPISANO: %s",
		"SETTINGS_REMAP_CONFLICT": "KONFLIKT: %s JUŻ UŻYWA TEGO WEJŚCIA",
		"SETTINGS_REMAP_UNSUPPORTED": "TYLKO KLAWISZ LUB PRZYCISK PADA",
		"SETTINGS_RESTORE_DEFAULTS": "DOMYŚLNE MAPOWANIA",
		"SETTINGS_REMAP_DEFAULTS_RESTORED": "PRZYWRÓCONO DOMYŚLNE MAPOWANIA",
		"UI_BACK": "POWRÓT",
		"PAUSE_TITLE": "PAUZA",
		"PAUSE_RESUME": "WZNÓW",
		"PAUSE_CHECKPOINT": "RESTART SCENY",
		"PAUSE_MAIN_MENU": "MENU GŁÓWNE",
		"PAUSE_SETTINGS": "USTAWIENIA",
		"PAUSE_TEST_MODE": "TRYB TESTOWY: %s",
		"PAUSE_RESET_SAVE": "RESET ZAPISU",
		"PAUSE_STATUS": "ODWIEDZONE ADRESY: %d/%d",
		"PAUSE_STATUS_DEBUG": "ODKRYTE: %d/%d   |   TRYB TESTOWY: %s",
		"PAUSE_FOOTER": "%s: POWRÓT  //  %s: WYBÓR",
		"PAUSE_STATION_TOOLTIP": "Adres %s: %s",
		"CRT_CONTINUE": "DALEJ  [%s]",
		"CRT_CHANNEL": "KANAŁ ŚWIADKA  //  ZAPIS AKTYWNY",
		"MENU_CREDITS": "TWÓRCY I LICENCJE",
		"CREDITS_TITLE": "TWÓRCY I LICENCJE",
		"SAVE_ACTIVE": "ZAPIS AKTYWNY",
		"SAVE_RELOADED": "ZAPIS WCZYTANY",
		"SAVE_RESET": "ZAPIS ZRESETOWANY",
	},
	"en": {
		"CONFIRM_CANCEL": "CANCEL",
		"CONFIRM_NEW_TITLE": "START OVER?",
		"CONFIRM_NEW_BODY": "A new game will delete the current campaign save. This cannot be undone.",
		"CONFIRM_RESET_TITLE": "DELETE THE SAVE?",
		"CONFIRM_RESET_BODY": "Campaign progress will be deleted and the game will return to the title screen.",
		"UI_START_EXPERIMENT": "START EXPERIMENT (21:45)",
		"UI_MOVEMENT_PROFILE": "MOVEMENT PROFILE:",
		"UI_PROFILE_A": "PROFILE A: BASELINE (IKP STANDARD)",
		"UI_PROFILE_B": "PROFILE B: SNAPPY (FAST)",
		"UI_PROFILE_C": "PROFILE C: INERTIAL (HEAVY)",
		"UI_RESTART_HINT": "[R] RESTART CHAMBER",
		"UI_ANCHOR_HINT": "[E] ANCHOR  //  [F] CORRECTION",
		"UI_INTERACT_HINT": "[E] INTERACT",
		"TITLE_SUBTITLE": "PERSONAL THRILLER // A RETURN ON LINE 4",
		"TITLE_PERSONAL_PROMISE": "Lena is going back to Marta. Three seconds from Line 4 refuse to disappear.",
		"TITLE_RETURN_PROMISE": "LINE 4  //  LAST READING  //  RETURN",
		"COLD_OPEN_SKIP": "SKIP ▸",
		"MENU_NEW_GAME": "NEW GAME",
		"MENU_CONTINUE": "CONTINUE",
		"MENU_REPLAY_EPILOGUE": "REPLAY EPILOGUE",
		"MENU_SETTINGS": "SETTINGS",
		"MENU_QUIT": "QUIT",
		"STATUS_SAVE_ACTIVE": "RESUME // %s%s",
		"STATUS_COMPLETED": "COMPLETED // %s",
		"STATUS_SAVE_NONE": "BEGIN // LAST READING AT LINE 4",
		"STATUS_COMPLETED_SUFFIX": "  //  COMPLETE  //  %s",
		"CONTROLS_HEADER": "MOVE / INVESTIGATE",
		"INPUT_ACTION_MOVE_LEFT": "MOVE LEFT",
		"INPUT_ACTION_MOVE_RIGHT": "MOVE RIGHT",
		"INPUT_ACTION_JUMP": "JUMP",
		"INPUT_ACTION_INTERACT": "INTERACT",
		"INPUT_ACTION_PAUSE": "PAUSE",
		"INPUT_ACTION_RESTART": "RESTART",
		"INPUT_ACTION_TRIGGER_CORRECTION": "CORRECTION",
		"BUILD_LABEL": "VERSION %s",
		"SETTINGS_TITLE": "SETTINGS",
		"SETTINGS_LANGUAGE": "LANGUAGE",
		"SETTINGS_LANGUAGE_HINT": "Menu and interface language.",
		"SETTINGS_MASTER_VOLUME": "VOLUME",
		"SETTINGS_TEXT_SPEED": "TEXT SPEED  //  CHARS/S",
		"SETTINGS_TEXT_SCALE": "TEXT SCALE",
		"SETTINGS_FULLSCREEN": "FULLSCREEN MODE",
		"SETTINGS_REDUCED_MOTION": "REDUCED MOTION",
		"SETTINGS_REDUCED_MOTION_HINT": "Damps fluorescent flicker, anchor field breathing, camera shake and micro-particles. Nothing leaves the world.",
		"SETTINGS_REMAP": "CONTROLS  //  REMAP",
		"SETTINGS_HINT": "Settings save automatically. Dialogue: PL.",
		"SETTINGS_REMAP_TITLE": "CONTROLS  //  ACTION REMAP",
		"SETTINGS_REMAP_HINT": "Choose an action, then press a key or controller button.",
		"SETTINGS_REMAP_PENDING": "PRESS A KEY OR CONTROLLER BUTTON FOR: %s\nESC / B = CANCEL",
		"SETTINGS_REMAP_WAITING": "WAITING…",
		"SETTINGS_REMAP_SAVED": "SAVED: %s",
		"SETTINGS_REMAP_CONFLICT": "CONFLICT: %s ALREADY USES THIS INPUT",
		"SETTINGS_REMAP_UNSUPPORTED": "KEY OR CONTROLLER BUTTONS ONLY",
		"SETTINGS_RESTORE_DEFAULTS": "DEFAULT MAPPINGS",
		"SETTINGS_REMAP_DEFAULTS_RESTORED": "DEFAULT MAPPINGS RESTORED",
		"UI_BACK": "BACK",
		"PAUSE_TITLE": "PAUSED",
		"PAUSE_RESUME": "RESUME",
		"PAUSE_CHECKPOINT": "RESTART SCENE",
		"PAUSE_MAIN_MENU": "MAIN MENU",
		"PAUSE_SETTINGS": "SETTINGS",
		"PAUSE_TEST_MODE": "TEST MODE: %s",
		"PAUSE_RESET_SAVE": "RESET SAVE",
		"PAUSE_STATUS": "ADDRESSES VISITED: %d/%d",
		"PAUSE_STATUS_DEBUG": "DISCOVERED: %d/%d   |   TEST MODE: %s",
		"PAUSE_FOOTER": "%s: BACK  //  %s: SELECT",
		"PAUSE_STATION_TOOLTIP": "Address %s: %s",
		"CRT_CONTINUE": "NEXT  [%s]",
		"CRT_CHANNEL": "WITNESS CHANNEL  //  SAVE ACTIVE",
		"MENU_CREDITS": "CREDITS & LICENSES",
		"CREDITS_TITLE": "CREDITS & LICENSES",
		"SAVE_ACTIVE": "SAVE ACTIVE",
		"SAVE_RELOADED": "SAVE RELOADED",
		"SAVE_RESET": "SAVE RESET",
	}
}


## PKG-0242 (UX): player-facing names of campaign addresses (title status,
## pause grid). Taken from each scene's own signage; no story is revealed.
const STATION_NAMES := {
	"pl": {
		"station_01": "Stanowisko pomiarowe", "station_02": "Obejście serwisowe",
		"station_03": "Przystanek Linii 4", "station_04": "Wagon Linii 4",
		"station_05": "Ulica Wiejska", "station_06": "Kiosk",
		"station_07": "Sadowa 7", "station_08": "Klatka schodowa",
		"station_09": "Mieszkanie 14", "station_10": "Mieszkanie 14, rano",
		"station_11": "Ewidencja UCP", "station_12": "Warsztat Linii 4",
		"station_13": "Wspólny stół", "station_14": "Rozdzielnia Linii 4",
		"station_15": "Pętla pomiarowa", "station_16": "Analizator",
		"station_17": "Hala UCP", "station_18": "Znana ulica",
		"station_42a": "Świt", "station_42b": "Świt", "station_42c": "Świt",
		"station_43": "Pierwszy kurs",
	},
	"en": {
		"station_01": "Measuring post", "station_02": "Service detour",
		"station_03": "Line 4 stop", "station_04": "Line 4 carriage",
		"station_05": "Wiejska Street", "station_06": "Kiosk",
		"station_07": "7 Sadowa Street", "station_08": "Stairwell",
		"station_09": "Flat 14", "station_10": "Flat 14, morning",
		"station_11": "UCP records", "station_12": "Line 4 workshop",
		"station_13": "The shared table", "station_14": "Line 4 substation",
		"station_15": "Measurement loop", "station_16": "Analyser",
		"station_17": "UCP hall", "station_18": "A familiar street",
		"station_42a": "Dawn", "station_42b": "Dawn", "station_42c": "Dawn",
		"station_43": "First service",
	},
}


static func station_display_name(station_id: String) -> String:
	var table: Dictionary = STATION_NAMES.get(current_locale, STATION_NAMES["pl"])
	return String(table.get(station_id.to_lower(), station_id))


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
