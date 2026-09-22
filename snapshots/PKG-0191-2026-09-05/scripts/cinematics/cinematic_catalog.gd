class_name CinematicCatalog
extends RefCounted

## PKG-0190 — katalog krótkich, ilustrowanych sekwencji "cinematic vignette".
##
## Wzorem `ColdOpenFacts` (PKG-0176) ten moduł jest jedynym miejscem, w którym
## żyje tabela: identyfikator winiety, stacja, sygnał wyzwalający, ścieżki
## klatek, podpisy i czas trwania. `CinematicDirector` i `CinematicVignette`
## czytają stąd dane zamiast duplikować je u siebie; bramka
## `tests/pkg_0190_cinematics_test.gd` czyta stąd katalog zamiast powtarzać go.
##
## Pełne prompty gen-ai dla każdej klatki (scena/kamera/funkcja
## kadru/światło/zachowanie/stan narracyjny) są udokumentowane w
## `docs/rebuild/PKG_0190_CINEMATIC_GENERATION_MANIFEST.md` §3–4.

const ID_THRESHOLD := &"vig_threshold"
const ID_SYNTHESIS := &"vig_synthesis"
const ID_SIGNAL := &"vig_signal"
const ID_COMMIT := &"vig_commit"
const ID_FINALE_A := &"vig_finale_a"
const ID_FINALE_B := &"vig_finale_b"
const ID_FINALE_C := &"vig_finale_c"

const ALL_IDS: Array[StringName] = [
	ID_THRESHOLD, ID_SYNTHESIS, ID_SIGNAL, ID_COMMIT,
	ID_FINALE_A, ID_FINALE_B, ID_FINALE_C,
]

## Sygnały bez argumentów (arity=0). `method_committed` jest jedynym
## sygnałem-wyzwalaczem z jednym argumentem (`method_id`) i jest specjalnie
## obsłużony w `CinematicDirector._bind()`.
const ONE_ARG_TRIGGER_SIGNALS: Array[StringName] = [&"method_committed"]

const CATALOG := {
	"vig_threshold": {
		"label": "Próg",
		"station_id": "station_08",
		"trigger_signal": "apartment_fourteen_unlocked",
		"frames": [
			"res://assets/cinematics/vig_threshold/frame_0.png",
			"res://assets/cinematics/vig_threshold/frame_1.png",
		],
		"captions": [
			"",
			"LENA: Nie jestem intruzem. Ale to nie jest też mój dom.",
		],
		"frame_seconds": [2.4, 2.8],
		"frame_seconds_reduced": [1.4, 1.6],
	},
	"vig_synthesis": {
		"label": "Synteza",
		"station_id": "station_13",
		"trigger_signal": "world_difference_synthesized",
		"frames": [
			"res://assets/cinematics/vig_synthesis/frame_0.png",
			"res://assets/cinematics/vig_synthesis/frame_1.png",
		],
		"captions": [
			"",
			"LENA: To nie jest mój świat.",
		],
		"frame_seconds": [2.2, 3.0],
		"frame_seconds_reduced": [1.3, 1.7],
	},
	"vig_signal": {
		"label": "Sygnał",
		"station_id": "station_15",
		"trigger_signal": "mutual_signal_test_completed",
		"frames": [
			"res://assets/cinematics/vig_signal/frame_0.png",
			"res://assets/cinematics/vig_signal/frame_1.png",
		],
		"captions": [
			"",
			"LENA: To nie echo. To odpowiedź.",
		],
		"frame_seconds": [2.0, 2.6],
		"frame_seconds_reduced": [1.2, 1.5],
	},
	"vig_commit": {
		"label": "Zatwierdzenie",
		"station_id": "station_18",
		"trigger_signal": "method_committed",
		"frames": [
			"res://assets/cinematics/vig_commit/frame_0.png",
			"res://assets/cinematics/vig_commit/frame_1.png",
		],
		"captions": [
			"",
			"LENA: Wybór jest jeden. Braki zostają nazwane.",
		],
		"frame_seconds": [2.2, 2.6],
		"frame_seconds_reduced": [1.3, 1.5],
	},
	"vig_finale_a": {
		"label": "Poranek — wymuszony powrót",
		"station_id": "station_42a",
		"trigger_signal": "household_consequence_read",
		"ending_family": "force_home",
		"frames": [
			"res://assets/cinematics/vig_finale_a/frame_0.png",
			"res://assets/cinematics/vig_finale_a/frame_1.png",
		],
		"captions": [
			"",
			"LENA: Zostawiłam ją między adresami.",
		],
		"frame_seconds": [2.4, 3.0],
		"frame_seconds_reduced": [1.4, 1.7],
	},
	"vig_finale_b": {
		"label": "Poranek — zamknięcie Równi",
		"station_id": "station_42b",
		"trigger_signal": "household_consequence_read",
		"ending_family": "close_equal_recover_local",
		"frames": [
			"res://assets/cinematics/vig_finale_b/frame_0.png",
			"res://assets/cinematics/vig_finale_b/frame_1.png",
		],
		"captions": [
			"",
			"LENA: Ona jest u siebie. Ja nie mam już adresu.",
		],
		"frame_seconds": [2.4, 3.0],
		"frame_seconds_reduced": [1.4, 1.7],
	},
	"vig_finale_c": {
		"label": "Poranek — wzajemne przejście",
		"station_id": "station_42c",
		"trigger_signal": "household_consequence_read",
		"ending_family": "mutual_passage",
		"frames": [
			"res://assets/cinematics/vig_finale_c/frame_0.png",
			"res://assets/cinematics/vig_finale_c/frame_1.png",
		],
		"captions": [
			"",
			"LENA: Most nie zgasł. Odpowiadamy obie.",
		],
		"frame_seconds": [2.2, 3.0],
		"frame_seconds_reduced": [1.3, 1.7],
	},
}


static func all_ids() -> Array[StringName]:
	return ALL_IDS.duplicate()


static func entry(id: StringName) -> Dictionary:
	return CATALOG.get(String(id), {}).duplicate(true)


static func has_entry(id: StringName) -> bool:
	return CATALOG.has(String(id))


static func station_id_of(id: StringName) -> StringName:
	return StringName(String(entry(id).get("station_id", "")))


static func trigger_signal_of(id: StringName) -> StringName:
	return StringName(String(entry(id).get("trigger_signal", "")))


static func is_one_arg_trigger(signal_name: StringName) -> bool:
	return signal_name in ONE_ARG_TRIGGER_SIGNALS
