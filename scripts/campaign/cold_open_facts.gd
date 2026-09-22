class_name ColdOpenFacts
extends RefCounted

## PKG-0176 / GATE-INTRO — rejestr faktów zimnego otwarcia (D-193, D-195).
##
## `COLD_OPEN_SPEC.md` §4.2 przypisuje każdemu z pięciu faktów z
## `PLAYER_CONTRACT.md` §3 dokładnie jeden nośnik i zakazuje nośników z warstwy
## menu, ekranu tekstu i promptu UI. Ten moduł jest jedynym miejscem, w którym
## ta tabela żyje w kodzie: warstwa A (`ColdOpen`) i warstwa B (`Station01`)
## zgłaszają tu fakty, a bramka `tests/pkg_0176_smoke_test.gd` czyta stąd
## katalog zamiast powtarzać go u siebie.
##
## Moduł jest `RefCounted` ze statycznym API — tak jak `GapLedger` i
## `MotionAccessibility` — bo czytają go również bramki nagłówkowe bez sceny.

# ─── Fakty (PLAYER_CONTRACT.md §3) ────────────────────────────────────────────

const FACT_IDENTITY_WORK := &"p9.cold_open.fact.identity_work"
const FACT_WORKPLACE := &"p9.cold_open.fact.workplace"
const FACT_TOOL_PROCEDURE := &"p9.cold_open.fact.tool_procedure"
const FACT_MEASUREMENT_OFF := &"p9.cold_open.fact.measurement_off"
const FACT_SOMEONE_WAITS := &"p9.cold_open.fact.someone_waits"

## Nośniki dozwolone: obraz, maszyna, czynność gracza, ekran przyrządu.
const ALLOWED_CARRIER_KINDS: Array[String] = [
	"silhouette", "machine", "player_action", "instrument_screen",
]
## Nośniki zakazane wprost przez spec §4.2 i `ACCEPTANCE_MATRIX.md` §6.
const FORBIDDEN_CARRIER_KINDS: Array[String] = [
	"menu", "text_screen", "ui_prompt", "dialogue_only",
]

const CATALOG := {
	"p9.cold_open.fact.identity_work": {
		"contract_row": "jestem kobietą przy pracy technicznej",
		"carrier": "lena_silhouette_and_gloved_hand",
		"carrier_kind": "silhouette",
		"layer": "A",
	},
	"p9.cold_open.fact.workplace": {
		"contract_row": "to jest miejsce pracy, nie laboratorium fabuły",
		"carrier": "tram_passes_without_player",
		"carrier_kind": "machine",
		"layer": "A",
	},
	"p9.cold_open.fact.measurement_off": {
		"contract_row": "coś jest nie tak z pomiarem",
		"carrier": "live_trace_versus_archive_gap",
		"carrier_kind": "instrument_screen",
		"layer": "A+B",
	},
	"p9.cold_open.fact.tool_procedure": {
		"contract_row": "mam narzędzie i procedurę",
		"carrier": "forced_measurement_run",
		"carrier_kind": "player_action",
		"layer": "B",
	},
	"p9.cold_open.fact.someone_waits": {
		"contract_row": "ktoś na mnie czeka",
		"carrier": "marta_message_on_instrument",
		"carrier_kind": "instrument_screen",
		"layer": "B",
	},
}

# ─── Kolejność pojęcia „drgania” (COLD_OPEN_SPEC.md §4.3) ─────────────────────

const STEP_TRAM_PASSED := &"p9.cold_open.vibration.tram_passed"
const STEP_TRACE_SPIKED := &"p9.cold_open.vibration.trace_spiked"
const STEP_TRACE_REST := &"p9.cold_open.vibration.trace_returned_to_noise"
const STEP_ARCHIVE_GAP := &"p9.cold_open.vibration.archive_flat_line"
const STEP_WORD_SPOKEN := &"p9.cold_open.vibration.word_spoken"

## Kolejność obowiązkowa: przyczyna, skutek, spoczynek, anomalia, dopiero potem
## słowo. Bramka porównuje porządkowe, nie czas zegarowy.
const VIBRATION_ORDER: Array[StringName] = [
	STEP_TRAM_PASSED, STEP_TRACE_SPIKED, STEP_TRACE_REST, STEP_ARCHIVE_GAP,
	STEP_WORD_SPOKEN,
]

const STEP_COUNTER := &"p9.cold_open.step_counter"
const LAYER_A_DONE := &"p9.cold_open.layer_a_done"
const LAYER_B_DONE := &"p9.cold_open.completed"
const SEEN := &"p9.cold_open.seen"

# ─── Teksty zimnego otwarcia ─────────────────────────────────────────────────
#
# Jedyne źródło prawdy o tym, co zimne otwarcie wypisuje na ekranie. Warstwy
# czytają stąd swoje napisy, a lint §5 sprawdza dokładnie tę listę, nie jej
# przybliżenie.

const TEXT_TRACK_LABEL := "LINIA 4"
const TEXT_TIME_LEFT := "-20 s"
const TEXT_TIME_MID := "-10 s"
const TEXT_TIME_RIGHT := "0 s"
const TEXT_GAP_MARKER := "-03,0 s"
const TEXT_ARCHIVE_LABEL := "ARCHIWUM  20:14"
const TEXT_MARTA_MESSAGE := "MARTA  20:31\nJeden odczyt i wychodzisz? Herbata czeka."
const TEXT_SKIP_HINT := "POMIŃ ▸"
const LINE_LENA_GAP := "Przejazd był. Drgania są. Trzech sekund zapisu nie ma."

## §5 — czego zimne otwarcie nie wolno ujawnić. Lint działa na rdzeniach, nie na
## pełnych słowach, żeby odmiana nie przepuściła ujawnienia.
const FORBIDDEN_REVEAL_STEMS: Array[String] = [
	"jakub", "anchor", "yield", "ucp", "kotwic", "ulegan",
	"inny świat", "innego świata", "innym świecie", "katastrof", "brat",
]


static func all_texts() -> Array[String]:
	var texts: Array[String] = [
		TEXT_TRACK_LABEL, TEXT_TIME_LEFT, TEXT_TIME_MID, TEXT_TIME_RIGHT,
		TEXT_GAP_MARKER, TEXT_ARCHIVE_LABEL, TEXT_MARTA_MESSAGE,
		TEXT_SKIP_HINT, LINE_LENA_GAP,
	]
	return texts


## Zwraca rdzenie zakazanych ujawnień znalezione w podanym tekście.
static func forbidden_reveals_in(text: String) -> Array[String]:
	var found: Array[String] = []
	var haystack := text.to_lower()
	for stem in FORBIDDEN_REVEAL_STEMS:
		if haystack.contains(stem):
			found.append(stem)
	return found


static func catalog() -> Dictionary:
	return CATALOG.duplicate(true)


static func fact_ids() -> Array[StringName]:
	var ids: Array[StringName] = []
	for key in CATALOG.keys():
		ids.append(StringName(String(key)))
	return ids


static func carrier_kind_of(fact_id: StringName) -> String:
	var spec: Dictionary = CATALOG.get(String(fact_id), {})
	return String(spec.get("carrier_kind", ""))


# ─── Zapis ───────────────────────────────────────────────────────────────────

static func _state() -> Node:
	var loop := Engine.get_main_loop()
	if loop is SceneTree:
		return (loop as SceneTree).root.get_node_or_null("GameStateManager")
	return null


## Zapis kampanii normalizuje klucze do `StringName`, ale świeżo wczytany JSON
## potrafi je jeszcze trzymać jako `String`. Czytamy obie postacie, tak jak
## `GameStateManager._get_decision`.
static func _read(state: Node, key: StringName, fallback: Variant = null) -> Variant:
	if state == null:
		return fallback
	var decisions: Dictionary = state.decisions
	if decisions.has(key):
		return decisions[key]
	var as_string := String(key)
	if decisions.has(as_string):
		return decisions[as_string]
	return fallback


## Zgłasza fakt razem z nośnikiem. Fakt spoza katalogu jest odrzucany, więc
## warstwa nie może zaliczyć bramki przypadkowym napisem.
static func record_fact(fact_id: StringName, note: String = "shown") -> bool:
	var spec: Dictionary = CATALOG.get(String(fact_id), {})
	if spec.is_empty():
		push_warning("ColdOpenFacts: unknown fact %s" % fact_id)
		return false
	var state := _state()
	if state == null:
		return false
	return bool(state.record_decision(fact_id, "%s:%s" % [String(spec.get("carrier", "")), note]))


## Zapisuje krok pojęcia „drgania” z rosnącym porządkowym. Powtórne zgłoszenie
## tego samego kroku nie przesuwa porządkowej — kolejność jest faktem o
## pierwszym pokazaniu, nie o ostatnim.
static func record_step(step_id: StringName, note: String = "shown") -> bool:
	if step_id not in VIBRATION_ORDER:
		push_warning("ColdOpenFacts: unknown vibration step %s" % step_id)
		return false
	var state := _state()
	if state == null:
		return false
	if _read(state, step_id) != null:
		return false
	var ordinal := int(_read(state, STEP_COUNTER, 0)) + 1
	state.record_decision(STEP_COUNTER, ordinal)
	return bool(state.record_decision(step_id, "%d:%s" % [ordinal, note]))


static func step_ordinal(state: Node, step_id: StringName) -> int:
	var raw := String(_read(state, step_id, ""))
	if raw.is_empty():
		return -1
	return int(raw.get_slice(":", 0))


static func has_fact(state: Node, fact_id: StringName) -> bool:
	return _read(state, fact_id) != null


static func fact_note(state: Node, fact_id: StringName) -> String:
	return String(_read(state, fact_id, ""))


static func missing_facts(state: Node) -> Array[StringName]:
	var missing: Array[StringName] = []
	for fact_id in fact_ids():
		if not has_fact(state, fact_id):
			missing.append(fact_id)
	return missing


## Czy kolejność §4.3 jest zachowana w bieżącym zapisie kampanii.
static func vibration_order_intact(state: Node) -> bool:
	var previous := 0
	for step_id in VIBRATION_ORDER:
		var ordinal := step_ordinal(state, step_id)
		if ordinal <= previous:
			return false
		previous = ordinal
	return true


static func is_layer_a_done(state: Node) -> bool:
	return bool(_read(state, LAYER_A_DONE, false))


static func is_cold_open_completed(state: Node) -> bool:
	return bool(_read(state, LAYER_B_DONE, false))
