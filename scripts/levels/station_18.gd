class_name Station18
extends Node2D

## Station 18 — P9, trzy prognozy metod, zestawienie zgód i braków, fizyczne
## zatwierdzenie jednej metody. Ulica z 05 po zmianie: otwarte niebo, fasady,
## witryna i latarnia. Lena zestawia trzy drogi z aktualnym zakresem zgody
## Jakuba, mówi Marcie prawdę albo jej część i zatwierdza jedną metodę.
## Pytanie, z którym gracz wychodzi: „którą metodę wykonuję — i czego mi w niej
## brakuje?".

## Lena wraca do Marty na ulicę z 05 z odpisami z hali i własnym czytnikiem.
## Opis prognozy nie jest zgodą na wykonanie. Z konkretną propozycją wraca
## do istniejącego łącza z Jakubem. Odmowa nie znika przy ponownym wejściu.

const NarrativeRules := preload("res://scripts/levels/narrative_repair_rules.gd")

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")

const FACT_DONOR_TRACE := &"p7.work_history_and_record.trace"
const FACT_DONOR_LEDGER := &"p9.consent_and_cost.cost_ledger_read"
const FACT_DONOR_OFFER := &"p9.consent_and_cost.adaptation_offer"
const FACT_DONOR_SCOPE := &"p9.consent_and_cost.jakub_consent_scope"
const FACT_CANONICAL_SCOPE := &"jakub_consent_state"
const FACT_FORECASTS_COMPARED := &"p9.method_commitment.forecasts_compared"
const FACT_FORECASTS := &"p9.method_commitment.forecasts"
const FACT_CANONICAL_MAPPED := &"route_hypotheses_mapped"
const FACT_MARTA := &"p9.method_commitment.marta_truth_state"
const FACT_CANONICAL_MARTA := &"marta_truth_state"
const FACT_METHOD := &"p9.method_commitment.method_committed"
const FACT_CANONICAL_METHOD := &"method_committed"
const FACT_TRACE := &"p9.method_commitment.trace"
const FACT_FEEDBACK := &"p9.method_commitment.safe_trial_feedback"

const DONOR_TRACE_VALUE := "cost_ledger_and_consent_scope_recorded"
const DONOR_OFFER_VALUE := "rejected"
const TRACE_VALUE := "method_committed_after_forecast_and_consent_inventory"
const SCOPE_GRANTED := "granted"
const SCOPE_LIMITED := "limited"
const SCOPE_REFUSED := "refused"
const MARTA_FULL := &"full"
const MARTA_PARTIAL := &"partial"
const MARTA_WITHHELD := &"withheld"
const METHOD_FORCE_HOME := &"force_home"
const METHOD_CLOSE_EQUAL := &"close_equal_recover_local"
const METHOD_MUTUAL := &"mutual_passage"
const VALID_CONSENT_STATES: Array[String] = [SCOPE_GRANTED, SCOPE_LIMITED, SCOPE_REFUSED]

## PKG-0222 (M10): adres bez przeszkody fizycznej — ulica wymaga zestawienia
## trzech prognoz, nazwania prawdy i zatwierdzenia metody, nie pokonywania
## geometrii. Znacznik rozwiazuje pytanie o rodzine fizyczna 18.
const IS_PHYSICAL_OBSTACLE_FREE := true

## PKG-0225 (K6): ulica-rym 05/18 — ten sam szyld nocnych prac UCP co w 05
## (płyta RHYME_SIGN_SIZE z odpryskiem w prawym górnym rogu) i ten sam cykl
## lampy co w 05, spóźniony o dokładnie jedną klatkę fizyki (60 Hz).
const RHYME_SIGN_SIZE := Vector2(28.0, 14.0)
const RHYME_BLINK_SPEED := 1.6
const RHYME_FRAME_DELAY := 1.6 / 60.0

signal clue_inspected(id: String, prop_type: int)
signal forecasts_compared()
signal marta_truth_disclosed(truth_state: StringName)
signal method_committed(method_id: StringName)
signal operation_selected(operation: String)
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var are_forecasts_compared := false
var is_marta_truth_disclosed := false
var is_method_committed := false
var marta_truth_state: StringName = &""
var committed_method: StringName = &""
# PKG-0230 (P0-2, S-03): metoda wskazana pierwszym podejsciem do slupka.
# Zatwierdza dopiero drugie podejscie do TEJ SAMEJ metody.
var named_method: StringName = &""
var jakub_consent_state := ""
var forecasts: Dictionary = {}
var is_exit_unlocked := false
var is_level_completed := false
var last_feedback: StringName = &""
## PKG-0226 (N6-reszta): stan sześciu pozycji stołu (FULL_STORY §39) —
## próbka, sygnał, Marta, Jakub, rejestr, węzeł. Cache odświeżany przy
## każdej zmianie stanu; _draw tylko czyta.
var commit_table_marks: Array[bool] = [false, false, false, false, false, false]

var pending_marta_pairs: Array = []
var _pending_truth: StringName = &""
var _pending_sync := ""
var _lamp_phase := 0.0


func _ready() -> void:
	var presentation := preload("res://scripts/levels/creative_scene_presentation.gd").new()
	presentation.name = "CreativeScenePresentation"
	add_child(presentation)
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	jakub_consent_state = _read_jakub_consent()
	_restore_commitment_from_decisions()
	_refresh_commit_table()
	_refresh_choice_legend()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_lamp_phase = fmod(_lamp_phase + delta, TAU)


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s18_street_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s18_forecast_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Mam trzy prognozy w czytniku. Każda wymaga innego udziału osób.", "Three forecasts in my reader. Each asks for different participation.", &"", "")
	_register_beat(&"s18_single_route_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Znam koszt. Muszę jeszcze sprawdzić, czy ludzie zgodzą się w nim uczestniczyć.", "I know the cost. I still need to ask whether people agree to take part.", &"single_route_sufficient", "compare_forecast_consent_dependencies")
	_register_beat(&"s18_commit_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Pokażę Marcie zapis. Z wybraną prognozą wrócę do łącza z Jakubem, zanim zatwierdzę metodę.", "Show Marta the record, then take one forecast back to Jakub before committing.", &"", "commit_force_home")
	_register_beat(&"s18_method_recorded", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Wybrałam metodę. Przy czytniku muszę jeszcze ją wykonać.", "I have chosen the method. It still needs to be carried out at the reader.", &"", "")
	# PKG-0230 (P0-1, S-02): kwestia Leny przy zablokowanym zatwierdzeniu —
	# odmowa zamyka droge, nie system. Wyjscie: wrocic do 17 i renegocjowac.
	_register_beat(&"s18_consent_refused_blocks", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Nie mam odpowiedzi potrzebnych do tej metody. Odmowy nie zmieni samo ponowienie pytania.", "I lack the responses this method requires. Repeating the question will not change a refusal.", &"", "")
	# PKG-0230 (P0-2, S-03): nazwanie wskazania — nazwa metody pada ZANIM
	# padnie zatwierdzenie; koszty i luki sa na tablicy i w linii slupka.
	_register_beat(&"s18_name_force_home", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Wymuszenie domu. Mój powrót kosztem miejscowej. Najpierw potrzebuję odpowiedzi Jakuba.", "Forcing home: my return at the local Lena's expense. I need Jakub's response first.", &"", "")
	_register_beat(&"s18_name_close_equal", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Odzyskanie miejscowej. Jakub ma tylko czytać wskazania, a ja stracę indeks powrotny.", "Local recovery: Jakub only reads indications, and I lose my return index.", &"", "")
	_register_beat(&"s18_name_mutual", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Przejście wzajemne. Bez odpowiedzi Jakuba i zgody Marty na klucz tego nie wykonam.", "Mutual passage: it requires Jakub's response and Marta's permission for the key.", &"", "")
	_register_beat(&"s18_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Prognoza → rozmowy o tej metodzie → zatwierdzenie. Sam odczyt nie jest zgodą.", "HINT: Forecast → responses to that method → commitment. Reading is not consent.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_18"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _connect_props() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			if not prop.resonance_triggered.is_connected(_on_prop_resonance_triggered.bind(prop)):
				prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"forecast_comparator":
			compare_forecast_consent_dependencies()
		"marta_truth_table":
			choose_marta_truth_from_player_side()
		"method_commit_post":
			choose_method_from_player_side()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func compare_forecast_consent_dependencies() -> bool:
	if _snapshot_taken() or _any_finale_executed():
		return false
	if not _has_donor_context():
		_record_feedback(&"consent_scope_required")
		return false
	jakub_consent_state = _read_jakub_consent()
	forecasts = _build_forecasts(jakub_consent_state)
	are_forecasts_compared = true
	_refresh_commit_table()
	_record(FACT_FORECASTS_COMPARED, true)
	_record(FACT_FORECASTS, forecasts)
	_record(FACT_CANONICAL_MAPPED, true)
	if guidance_service:
		guidance_service.close_hypothesis(&"single_route_sufficient")
		guidance_service.trigger_beat(&"s18_forecast_contact")
	_report_progress(&"s18_forecasts_compared")
	forecasts_compared.emit()
	_refresh_choice_legend()
	queue_redraw()
	return true


func disclose_marta_truth_full() -> bool:
	return _commit_marta_truth(MARTA_FULL)


func disclose_marta_truth_partial() -> bool:
	return _commit_marta_truth(MARTA_PARTIAL)


func disclose_marta_truth_withheld() -> bool:
	return _commit_marta_truth(MARTA_WITHHELD)


func choose_marta_truth_from_player_side() -> bool:
	if _snapshot_taken() or _any_finale_executed() or not pending_marta_pairs.is_empty():
		return false
	if props == null or player == null:
		_record_feedback(&"marta_table_missing")
		return false
	var table := props.get_node_or_null("MartaTruthTable") as Node2D
	if table == null:
		_record_feedback(&"marta_table_missing")
		return false
	var offset := player.global_position.x - table.global_position.x
	if marta_truth_state == MARTA_FULL and named_method == METHOD_MUTUAL:
		if _decisions().has(NarrativeRules.SYNC_KEY):
			pending_marta_pairs = [["Marta", "Już odpowiedziałam w sprawie klucza. To nie zmieniło się od twojego odejścia."]]
			return true
		if absf(offset) <= 24.0:
			pending_marta_pairs = [["Lena", "Synchronizacja wymaga twojego klucza. Przeciek może wracać. Na razie pytam o te warunki."],
				["WSKAZÓWKA", "Stół: lewa strona — odmowa klucza; prawa — zgoda na synchronizację. Środek nie daje zgody."]]
			return true
		return _request_marta_sync(offset > 24.0)
	if offset < -24.0:
		return _commit_marta_truth(MARTA_WITHHELD)
	if offset > 24.0:
		return _commit_marta_truth(MARTA_FULL)
	return _commit_marta_truth(MARTA_PARTIAL)


func commit_force_home() -> bool:
	return _commit_method(METHOD_FORCE_HOME)


func commit_close_equal() -> bool:
	return _commit_method(METHOD_CLOSE_EQUAL)


func commit_mutual_passage() -> bool:
	return _commit_method(METHOD_MUTUAL)


func select_operation(op: String) -> void:
	if NarrativeRules.locked(_decisions()):
		return
	# PKG-0222 (M10): wylacznie routing — zero auto-domykania donora,
	# zestawienia, prawdy i metody. Brak inwentarza -> luka (jak 43 unseeded):
	# istniejacy feedback z mapa na s18.method_uncommitted, bez nowych faktow.
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("select_finale_operation"):
		state.select_finale_operation(op)
	if not (_has_donor_context() and are_forecasts_compared and is_marta_truth_disclosed):
		_record_feedback(&"forecast_and_consent_inventory_required")
	operation_selected.emit(op)


func choose_method_from_player_side() -> bool:
	if not are_forecasts_compared:
		_record_feedback(&"forecast_comparison_required")
		return false
	if is_method_committed:
		return false
	if props == null or player == null:
		_record_feedback(&"commit_post_missing")
		return false
	var post := props.get_node_or_null("MethodCommitPost") as Node2D
	if post == null:
		_record_feedback(&"commit_post_missing")
		return false
	var offset := player.global_position.x - post.global_position.x
	var pointed := _method_for_offset(offset)
	# PKG-0230 (P0-2, S-03): wskazanie i zatwierdzenie to dwa osobne kroki.
	# Pierwsze podejscie NAZYWA metode (beat + znacznik w _draw) i pokazuje
	# jej koszty oraz luki z tablicy; dopiero drugie podejscie do TEJ SAMEJ
	# metody zatwierdza. Inna strefa nazywa od nowa. Bezposrednie czasowniki
	# commit_* (testy) ida wprost do _commit_method.
	if named_method != pointed:
		named_method = pointed
		_record(NarrativeRules.PROPOSED_KEY, String(pointed))
		_refresh_commit_table()
		if guidance_service:
			guidance_service.trigger_beat(_name_beat_for_method(pointed))
		_refresh_choice_legend()
		queue_redraw()
		return true
	return _commit_method(pointed)


# PKG-0230 (P0-2, S-03): martwa strefa srodka poszerzona z ±24 do ±40 px —
# krawedz decyzji nie lezy juz wewnatrz sylwetki Leny (87 px).
func _method_for_offset(offset: float) -> StringName:
	if offset < -40.0:
		return METHOD_FORCE_HOME
	if offset > 40.0:
		return METHOD_MUTUAL
	return METHOD_CLOSE_EQUAL


func _name_beat_for_method(method_id: StringName) -> StringName:
	match method_id:
		METHOD_FORCE_HOME:
			return &"s18_name_force_home"
		METHOD_MUTUAL:
			return &"s18_name_mutual"
	return &"s18_name_close_equal"


func _commit_marta_truth(truth_state: StringName) -> bool:
	if _snapshot_taken() or _any_finale_executed() or not pending_marta_pairs.is_empty():
		return false
	if not are_forecasts_compared:
		_record_feedback(&"forecast_comparison_required")
		return false
	var ranks := {"": -1, "withheld": 0, "partial": 1, "full": 2}
	if not ranks.has(String(truth_state)) or ranks[String(truth_state)] <= ranks.get(String(marta_truth_state), -1):
		return false
	_pending_truth = truth_state
	pending_marta_pairs = preload("res://scripts/levels/creative_scene_lines.gd").LINES.get("marta_truth_table_" + String(truth_state), []).duplicate(true)
	if is_marta_truth_disclosed:
		pending_marta_pairs.push_front(["Lena", "Wcześniej nie pokazałam ci wszystkiego. Dokładam to teraz, zanim cokolwiek zatwierdzę."])
	return true

func _request_marta_sync(accept: bool) -> bool:
	var decisions := _decisions()
	if NarrativeRules.locked(decisions) or marta_truth_state != MARTA_FULL or named_method != METHOD_MUTUAL:
		return false
	if decisions.has(NarrativeRules.SYNC_KEY):
		pending_marta_pairs = [["Marta", "Już odpowiedziałam w sprawie klucza. To nie zmieniło się od twojego odejścia."]]
		return false
	_pending_sync = "accepted" if accept else "refused"
	pending_marta_pairs = [
		["Lena", "Przejście wzajemne potrzebuje twojego klucza. Przecieku nie potrafimy potem wyłączyć."],
		["Marta", "Pytasz o synchronizację. Nie o to, czy ci wybaczam."],
	]
	if accept:
		pending_marta_pairs.append(["Marta", "Zgadzam się użyć klucza do tej metody. Chcę, żeby wróciła. Rozmowa z nią nas nie ominie."])
	else:
		pending_marta_pairs.append(["Marta", "Nie udostępnię klucza do synchronizacji. W odzyskaniu jej pomogę inaczej."])
	return true

func _decisions() -> Dictionary:
	var state := get_node_or_null("/root/GameStateManager")
	return state.decisions if state != null else {}

func _has_pending_narrative_dialogue(id: String) -> bool:
	return (id == "marta_truth_table" and not pending_marta_pairs.is_empty()) \
		or (id == "method_commit_post" and not named_method.is_empty() and not is_method_committed)

func _on_narrative_dialogue_finished(id: String) -> void:
	if id != "marta_truth_table" or pending_marta_pairs.is_empty():
		return
	var decisions := _decisions()
	if not NarrativeRules.locked(decisions):
		if not _pending_truth.is_empty():
			if not decisions.has(&"p9.method_commitment.marta_initial_truth"):
				_record(&"p9.method_commitment.marta_initial_truth", String(_pending_truth))
			if _pending_truth != MARTA_FULL:
				_record(&"p9.method_commitment.marta_was_incomplete", true)
			_record(FACT_MARTA, String(_pending_truth))
			_record(FACT_CANONICAL_MARTA, String(_pending_truth))
			marta_truth_state = _pending_truth
			is_marta_truth_disclosed = true
			marta_truth_disclosed.emit(_pending_truth)
			_report_progress(&"s18_marta_truth_disclosed")
		elif not _pending_sync.is_empty() and not decisions.has(NarrativeRules.SYNC_KEY):
			_record(NarrativeRules.SYNC_KEY, _pending_sync)
	pending_marta_pairs.clear()
	_pending_truth = &""
	_pending_sync = ""
	forecasts = _build_forecasts(_read_jakub_consent())
	_refresh_commit_table()
	_refresh_choice_legend()
	queue_redraw()


## PKG-0242 (UX): Marta's table decides by side like the commit post. The
## legend names the sides: how much of the record Lena shows, then — for
## mutual passage after the full record — Marta's answer about the key.
func _refresh_choice_legend() -> void:
	var sign := get_node_or_null("CrispDiegeticText_Window")
	if sign == null:
		return
	var text := "ODPISY DLA MARTY // ZAPIS I KLUCZ"
	var decisions := _decisions()
	if are_forecasts_compared and not _snapshot_taken() and not _any_finale_executed():
		if marta_truth_state == MARTA_FULL and named_method == METHOD_MUTUAL and not decisions.has(NarrativeRules.SYNC_KEY):
			text = "KLUCZ MARTY: ← ODMOWA • RYZYKO • ZGODA →"
		elif marta_truth_state != MARTA_FULL:
			text = "DLA MARTY: ← NIC • CZĘŚĆ • CAŁY ZAPIS →"
	sign.set("text", text)


func _commit_method(method_id: StringName) -> bool:
	if not pending_marta_pairs.is_empty() or named_method != method_id:
		_record_feedback(&"method_proposal_required")
		return false
	if is_method_committed:
		return false
	# PKG-0233 (D2): migawka decyzji jest zamrozona przy commicie. Zmiana
	# metody po powrocie nie zastepuje jej po cichu — jest niemozliwa
	# (odmowa z nazwana luka, bez zapisu). Jawne wejscia testowe/selektora
	# (select_finale_*, bezposredni complete_station w harnessach) bez zmian.
	if _snapshot_taken():
		_record_feedback(&"method_snapshot_locked")
		return false
	if _any_finale_executed():
		_record_feedback(&"finale_execution_started")
		return false
	# PKG-0230 (P0-1, S-02): brak zestawienia albo prawdy nie zatwierdza
	# metody — zostawia istniejacy feedback i mowi luka (D-228), bez commita.
	if not are_forecasts_compared:
		_record_feedback(&"forecast_and_consent_inventory_required")
		preload("res://scripts/campaign/gap_ledger.gd").annotate_feedback(self, &"forecast_and_consent_inventory_required")
		return false
	if not is_marta_truth_disclosed:
		_record_feedback(&"marta_truth_required")
		preload("res://scripts/campaign/gap_ledger.gd").annotate_feedback(self, &"marta_truth_required")
		return false
	# PKG-0230 (P0-1, S-02): zgoda Jakuba ma moc sprawcza. Droga, ktorej
	# prognoza jest niedostepna przy zapisanym zakresie, nie zatwierdza sie;
	# odmowa zamyka udział. Po odmowie podłączenia dopuszczona jest tylko
	# odrębna propozycja odczytu do B, z nową odpowiedzią i bez resetu odmowy.
	jakub_consent_state = _read_jakub_consent()
	var route_key := _route_key_for_method(method_id)
	var forecasts_now := _build_forecasts(jakub_consent_state)
	var entry: Dictionary = forecasts_now.get(route_key, {})
	if not bool(entry.get("available", false)):
		_record_feedback(StringName(entry.get("gap", "method_specific_response_required")))
		if guidance_service:
			guidance_service.trigger_beat(&"s18_consent_refused_blocks")
		_refresh_commit_table()
		queue_redraw()
		return false
	is_method_committed = true
	committed_method = method_id
	_refresh_commit_table()
	_record(FACT_METHOD, String(method_id))
	_record(FACT_CANONICAL_METHOD, String(method_id))
	var finale_id: StringName = &"station_42a"
	match method_id:
		METHOD_FORCE_HOME:
			finale_id = &"station_42a"
		METHOD_CLOSE_EQUAL:
			finale_id = &"station_42b"
		METHOD_MUTUAL:
			finale_id = &"station_42c"
	_record(&"campaign_finale", String(finale_id))
	_record(FACT_TRACE, TRACE_VALUE)
	# PKG-0233 (D2): atomowa migawka decyzji — metoda, prawda, zgoda, maly
	# koszt, dowody i wybrany wariant w JEDNYM zapisie. Literał inline (nie
	# const FACT_), zeby pin 0226 (14 constów) stal bez zmian.
	_record(&"p9.method_commitment.snapshot", _build_decision_snapshot(method_id, finale_id, forecasts_now))
	if guidance_service:
		guidance_service.trigger_beat(&"s18_method_recorded")
	_report_progress(&"s18_method_committed")
	method_committed.emit(method_id)
	_unlock_exit()
	_refresh_choice_legend()
	queue_redraw()
	return true


func _build_forecasts(consent: String) -> Dictionary:
	return {
		"force_home": _forecast_entry("force_home", "42A", ["granted"], consent),
		"close_equal_recover_local": _forecast_entry("close_equal_recover_local", "42B", ["granted", "limited"], consent),
		"mutual_passage": _forecast_entry("mutual_passage", "42C", ["granted"], consent),
	}


func _forecast_entry(route_id: String, finale: String, allowed: Array, consent: String) -> Dictionary:
	var decisions := _decisions()
	var scope_allowed := allowed.has(consent)
	var available := NarrativeRules.executable(decisions, route_id)
	var gap := ""
	if not scope_allowed:
		gap = "jakub_consent_missing"
	elif NarrativeRules.response(decisions, route_id) != "accepted":
		gap = "method_specific_response_required"
	elif route_id == "mutual_passage" and not available:
		gap = "marta_full_record_and_sync_required"
	return {"route_id": route_id, "finale": finale, "consent_states": allowed,
		"description_available": true, "scope_allows": scope_allowed,
		"available": available, "gap": gap}


func _route_key_for_method(method_id: StringName) -> String:
	match method_id:
		METHOD_FORCE_HOME:
			return "force_home"
		METHOD_CLOSE_EQUAL:
			return "close_equal_recover_local"
		METHOD_MUTUAL:
			return "mutual_passage"
	return ""


## PKG-0233 (D2): migawka decyzji + straznicy zamrozenia.
## Wszystkie wartosci sa typami JSON (String/bool/int/Dictionary) — przechodza
## przez _sanitize_json_value w GameStateManager bez utraty.
func _snapshot_taken() -> bool:
	var snap: Variant = _read_decision(&"p9.method_commitment.snapshot")
	return snap is Dictionary and not (snap as Dictionary).is_empty()


func _snapshot_method() -> String:
	var snap: Variant = _read_decision(&"p9.method_commitment.snapshot")
	if snap is Dictionary:
		return String((snap as Dictionary).get("method", ""))
	return ""


func _any_finale_executed() -> bool:
	return _has(&"p9.finale.forced_return.executed") \
		or _has(&"p9.finale.close_equal.executed") \
		or _has(&"p9.finale.mutual_passage.executed")


func _build_decision_snapshot(method_id: StringName, finale_id: StringName, forecasts_now: Dictionary) -> Dictionary:
	var available := 0
	for route_id: String in ["force_home", "close_equal_recover_local", "mutual_passage"]:
		var entry: Variant = forecasts_now.get(route_id, {})
		if entry is Dictionary and bool((entry as Dictionary).get("available", false)):
			available += 1
	var cost: Variant = _read_decision(&"p9.mechanics.small_cost.choice")
	return {
		"method": String(method_id),
		"marta_truth": String(marta_truth_state),
		"jakub_consent": jakub_consent_state,
		"jakub_method_response": NarrativeRules.response(_decisions(), String(method_id)),
		"marta_sync_response": str(_read_decision(NarrativeRules.SYNC_KEY)),
		"marta_initial_truth": str(_read_decision(&"p9.method_commitment.marta_initial_truth")),
		"marta_was_incomplete": _has(&"p9.method_commitment.marta_was_incomplete"),
		"small_cost": String(cost) if cost != null else "",
		"evidence": {
			"sample": _has(&"home_sample_preserved"),
			"signal": _has(&"p9.mechanics.mutual_signal.log_reconstructed"),
			"ledger": _has(&"p9.consent_and_cost.cost_ledger_read"),
			"forecasts_available": available,
		},
		"finale": String(finale_id),
	}


func _record_feedback(value: StringName) -> void:
	last_feedback = value
	_record(FACT_FEEDBACK, String(value))
	GapLedger.annotate_feedback(self, value) # PKG-0215 (D-228): blocked verb speaks its gap, if any.
	if guidance_service:
		guidance_service.report_failed_attempt(&"s18_" + value)


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	# PKG-0232 (D-244, D1): brak metody = brak finału na normalnej ścieżce.
	# Jawne wejścia testowe/selektora (select_finale_*, bezpośredni
	# complete_station w harnessach) działają bez zmian; próg wymaga commita.
	# Oba feedbacki istnieją w FEEDBACK_TO_GAP (bramka 0215 fail-closed).
	if not is_method_committed:
		if are_forecasts_compared and is_marta_truth_disclosed:
			_record_feedback(&"jakub_consent_missing")
		else:
			_record_feedback(&"forecast_and_consent_inventory_required")
		return
	is_level_completed = true
	level_completed.emit()


## PKG-0232 (D-244, pakiet A): rozdzielenie writerów od nawigacji. Decyzje
## (commity) rozliczają się dokładnie raz w GameStateManager; nawigacja może
## wracać. Świeża instancja po ReturnZone odtwarza lokalny stan z decyzji,
## żeby ponowny marsz naprzód nie wymagał ponownego commita.
func _restore_commitment_from_decisions() -> void:
	are_forecasts_compared = _read_decision(FACT_FORECASTS_COMPARED) == true
	marta_truth_state = StringName(_read_marta_truth_value())
	is_marta_truth_disclosed = not marta_truth_state.is_empty()
	jakub_consent_state = _read_jakub_consent()
	var proposed := str(_read_decision(NarrativeRules.PROPOSED_KEY))
	if NarrativeRules.METHODS.has(proposed):
		named_method = StringName(proposed)
	forecasts = _build_forecasts(jakub_consent_state) if are_forecasts_compared else {}
	var method := str(_read_decision(FACT_METHOD))
	if NarrativeRules.committed(_decisions(), method):
		committed_method = StringName(method)
		named_method = committed_method
		is_method_committed = true


func _read_marta_truth_value() -> String:
	return NarrativeRules.truth(_decisions())


func _has_donor_context() -> bool:
	# Odczyt ryzyka nie wymaga uprzedniej zgody na jego wykonanie.
	return _has(FACT_DONOR_LEDGER) \
		and str(_read_decision(FACT_DONOR_OFFER)) == DONOR_OFFER_VALUE \
		and _read_decision(&"world_recognized") == true


func _read_jakub_consent() -> String:
	return NarrativeRules.scope(_decisions())


func _has(key: StringName) -> bool:
	var value: Variant = _read_decision(key)
	if value == null:
		return false
	if value is String or value is StringName:
		return not String(value).is_empty()
	return bool(value)


func _refresh_commit_table() -> void:
	# PKG-0226 (N6-reszta): sześć pozycji stołu z istniejących decyzji
	# i flag lokalnych; zero nowych zapisów.
	var marks: Array[bool] = [false, false, false, false, false, false]
	marks[0] = _has(&"home_sample_preserved")
	marks[1] = _has(&"p9.mechanics.mutual_signal.log_reconstructed")
	marks[2] = is_marta_truth_disclosed
	marks[3] = not jakub_consent_state.is_empty()
	marks[4] = _has(&"p9.consent_and_cost.cost_ledger_read")
	marks[5] = are_forecasts_compared
	commit_table_marks = marks


func _read_decision(key: StringName) -> Variant:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return null
	return state.decisions.get(key, null)


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"forecast_comparator": return are_forecasts_compared
		"marta_truth_table": return is_marta_truth_disclosed
		"method_commit_post": return is_method_committed
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	# PKG-0218 (V1): stage apron first (D-136).
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	_draw_city_street()
	_draw_forecast_board()
	_draw_marta_window()
	_draw_commit_post()
	_draw_exit()
	queue_redraw()


func _draw_city_street() -> void:
	# Rodzina miejska: otwarte niebo ≥ 25% kadru, trzy plany, pionowe fasady,
	# latarnia wysoko i witryna przy chodniku. Sufit colliduje, ale nie jest malowany.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)
	draw_rect(Rect2(0.0, 0.0, 640.0, 108.0), VectorStageStyle.INK)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 108.0), Vector2(110.0, 82.0), Vector2(240.0, 94.0),
		Vector2(390.0, 74.0), Vector2(520.0, 90.0), Vector2(640.0, 78.0),
		Vector2(640.0, 108.0),
	]), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.38))
	draw_rect(Rect2(0.0, 108.0, 640.0, 198.0), VectorStageStyle.DEEP_PLANE)
	var window_x := 28.0
	while window_x <= 612.0:
		draw_rect(Rect2(window_x, 128.0, 22.0, 34.0), VectorStageStyle.INK)
		draw_rect(Rect2(window_x + 2.0, 130.0, 18.0, 30.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.22), false, 1.0)
		draw_rect(Rect2(window_x, 186.0, 22.0, 34.0), VectorStageStyle.INK)
		draw_rect(Rect2(window_x + 2.0, 188.0, 18.0, 30.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.22), false, 1.0)
		window_x += 30.0
	draw_line(Vector2(248.0, 306.0), Vector2(248.0, 132.0), VectorStageStyle.LIGHT_PLANE, 2.5)
	draw_line(Vector2(248.0, 132.0), Vector2(266.0, 126.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# PKG-0225 (K6): ten sam cykl co latarnia 05, spóźniony o RHYME_FRAME_DELAY.
	var lamp := 0.55 + 0.12 * sin(_lamp_phase * RHYME_BLINK_SPEED + RHYME_FRAME_DELAY)
	draw_circle(Vector2(266.0, 128.0), 5.0, Color(VectorStageStyle.HUMAN_AMBER, lamp))
	# PKG-0225 (K6): szyld nocnych prac UCP na fasadzie — ta sama płyta co w 05
	# (RHYME_SIGN_SIZE) z tym samym odpryskiem, w pasie między rzędami okien;
	# treść niesie beat s05_ucp_sign i tracker C-05, nie tekst w obrazie
	# (VISUAL_DESIGN §7).
	draw_rect(Rect2(64.0, 166.0, RHYME_SIGN_SIZE.x, RHYME_SIGN_SIZE.y), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.3), false, 1.5)
	draw_colored_polygon(
		PackedVector2Array([Vector2(86.0, 166.0), Vector2(92.0, 166.0), Vector2(92.0, 172.0)]),
		VectorStageStyle.DEEP_PLANE,
	)
	draw_rect(Rect2(0.0, 306.0, 640.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.28))
	draw_line(Vector2(0.0, 306.0), Vector2(640.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(0.0, 296.0, 640.0, 10.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.12))
	# Długi cień latarni na chodniku — źródło wysoko, cień nisko.
	draw_line(Vector2(270.0, 308.0), Vector2(392.0, 338.0), Color(VectorStageStyle.INK, 0.35), 6.0)


func _draw_forecast_board() -> void:
	var board_color := VectorStageStyle.ANCHOR_CYAN if are_forecasts_compared else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(128.0, 214.0, 96.0, 84.0), Color("16222a"))
	draw_rect(Rect2(128.0, 214.0, 96.0, 84.0), board_color, false, 1.0)
	var card_x := 136.0
	var methods: Array[StringName] = [METHOD_FORCE_HOME, METHOD_CLOSE_EQUAL, METHOD_MUTUAL]
	for method_id in methods:
		var card_color := VectorStageStyle.shade(board_color, 0.45)
		if are_forecasts_compared:
			var entry: Variant = forecasts.get(String(method_id), {})
			var available := entry is Dictionary and bool(entry.get("available", false))
			card_color = VectorStageStyle.ANCHOR_CYAN if available else VectorStageStyle.CORRECTION_OXIDE
		draw_rect(Rect2(card_x, 226.0, 24.0, 58.0), card_color, false, 1.0)
		if are_forecasts_compared:
			draw_line(Vector2(card_x + 4.0, 238.0), Vector2(card_x + 20.0, 238.0), card_color, 1.0)
			draw_line(Vector2(card_x + 4.0, 248.0), Vector2(card_x + 16.0, 248.0), VectorStageStyle.shade(card_color, 0.3), 1.0)
		card_x += 30.0


func _draw_marta_window() -> void:
	var window_color := VectorStageStyle.LIGHT_PLANE if is_marta_truth_disclosed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(286.0, 228.0, 92.0, 70.0), Color("121b22"))
	draw_rect(Rect2(286.0, 228.0, 92.0, 70.0), window_color, false, 1.0)
	draw_rect(Rect2(298.0, 238.0, 68.0, 40.0), Color(VectorStageStyle.HUMAN_AMBER, 0.18))
	draw_line(Vector2(332.0, 238.0), Vector2(332.0, 278.0), window_color, 1.0)
	draw_circle(Vector2(314.0, 286.0), 3.0, VectorStageStyle.shade(window_color, 0.25))
	draw_circle(Vector2(332.0, 286.0), 3.0, window_color)
	draw_circle(Vector2(350.0, 286.0), 3.0, VectorStageStyle.shade(window_color, 0.25))
	if is_marta_truth_disclosed:
		draw_line(Vector2(308.0, 268.0), Vector2(356.0, 268.0), window_color, 2.0)
		# PKG-0225 (K2): kubek-przeciek — ten sam biały kubek z 10/42, odstawiony
		# inaczej per truth_state (czyta istniejący marta_truth_state, zero
		# nowych faktów): full = oba obok siebie; partial = drugi schowany
		# (słaby zarys); withheld = drugi odwrócony do góry dnem.
		draw_rect(Rect2(306.0, 260.0, 10.0, 8.0), window_color, false, 1.5)
		if marta_truth_state == MARTA_FULL:
			draw_rect(Rect2(318.0, 260.0, 10.0, 8.0), window_color, false, 1.5)
		elif marta_truth_state == MARTA_PARTIAL:
			draw_rect(Rect2(318.0, 260.0, 10.0, 8.0), Color(window_color, 0.25), false, 1.0)
		else:
			draw_rect(Rect2(318.0, 264.0, 10.0, 4.0), Color(window_color, 0.6), false, 1.5)


func _draw_commit_post() -> void:
	var post_color := VectorStageStyle.ANCHOR_CYAN if is_method_committed else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(424.0, 236.0, 120.0, 62.0), Color("18232b"))
	draw_line(Vector2(484.0, 298.0), Vector2(484.0, 236.0), post_color, 2.0)
	draw_circle(Vector2(452.0, 268.0), 4.0, VectorStageStyle.shade(post_color, 0.25))
	draw_circle(Vector2(484.0, 268.0), 4.0, post_color)
	draw_circle(Vector2(516.0, 268.0), 4.0, VectorStageStyle.shade(post_color, 0.25))
	if is_method_committed:
		var pulse := 0.5 + 0.15 * sin(_lamp_phase * 2.0)
		draw_arc(Vector2(484.0, 264.0), 12.0, 0.0, TAU, 16, Color(post_color, pulse), 1.5)
	else:
		draw_line(Vector2(444.0, 250.0), Vector2(524.0, 250.0), Color("3c4d55"), 1.0)
		# PKG-0230 (P0-2, S-03): wskazana metoda ma jawny znacznik, zanim
		# padnie zatwierdzenie — Nazwana strefa, nie domysl.
		if named_method != &"":
			var named_x := 484.0
			if named_method == METHOD_FORCE_HOME:
				named_x = 452.0
			elif named_method == METHOD_MUTUAL:
				named_x = 516.0
			draw_arc(Vector2(named_x, 268.0), 8.0, 0.0, TAU, 16, VectorStageStyle.LIGHT_PLANE, 2.0)
	# PKG-0226 (N6-reszta): sześć kresek stołu pod słupkiem — pełna cyjanowa
	# kreska to pozycja znana, krótka bursztynowa to luka. Odczyt
	# commit_table_marks, zero logiki wejścia.
	var tick_x := 440.0
	for i: int in range(6):
		var known := false
		if i < commit_table_marks.size():
			known = commit_table_marks[i]
		var tick_color := VectorStageStyle.ANCHOR_CYAN if known else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.4)
		var tick_top := 284.0 if known else 288.0
		draw_line(Vector2(tick_x, tick_top), Vector2(tick_x, 292.0), tick_color, 2.0)
		tick_x += 16.0


func _draw_exit() -> void:
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(572.0, 146.0, 48.0, 12.0), exit_color, false, 1.5)
	draw_line(Vector2(610.0, 158.0), Vector2(610.0, 296.0), exit_color, 2.0)
	draw_line(Vector2(584.0, 296.0), Vector2(620.0, 296.0), exit_color, 2.0)
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy tablicy prognoz i słupka
	# w prawo, 0.48, zgodnie z latarnią (266,128) i konwencją 01/06/08.
	draw_colored_polygon(PackedVector2Array([
		Vector2(120.0, 296.0), Vector2(552.0, 294.0),
		Vector2(560.0, 302.0), Vector2(128.0, 304.0),
	]), Color(VectorStageStyle.INK, 0.48))
