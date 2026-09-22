class_name Station17
extends Node2D

## Station 17 — P9, rejestr par kosztów Linii 4 i jawny zakres zgody Jakuba.
## Utrzymanie ruchu prowadzi tu instytucjonalną halę z długą osią w głąb.
## Lena odczytuje pary kosztów (kto utrzymuje zapis, kto zapłacił), odrzuca
## ofertę adaptacji zaproponowaną przez system i negocjuje z Jakubem jawny
## zakres zgody: pełny, ograniczony albo odmowę — bez rankingu moralnego.
## Pytanie, z którym gracz wychodzi: „kto poniósł koszt mojego bezpieczeństwa?".

## PRZESZKODA — dlaczego to tu jest: Rejestr jest prowadzony ręcznie przez
## utrzymanie ruchu i otwiera się wyłącznie dla osoby z wykonaną próbą
## instytucjonalną; lada kontrolna dzieli halę na stronę dokumentów i stronę
## decyzji.
## PRZESZKODA — czego wymaga od Leny: odczytania par kosztów, odrzucenia
## oferty adaptacji i zapisania jawnego zakresu zgody przy biurku.
## PRZESZKODA — koszt porażki: próba przed odczytem rejestru zostawia tylko
## informację o brakującym kroku; odmowa zakresu nie zamyka wyjscia z 17,
## ale zamyka udział w metodach. Nowa propozycja po odmowie: tylko odrębny odczyt do B.
## RYTM (P2-2, PKG-0230): punkt zgody to osoba (Jakub przez lacze, P1-3),
## nie przedmiot — odstepstwo od trzech rekwizytow w akcie II.

const NarrativeRules := preload("res://scripts/levels/narrative_repair_rules.gd")

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")

const FACT_DONOR_TRIAL := &"p7.work_history_and_record.institution_trial_result"
const FACT_DONOR_HOME_ECHO := &"p9.mechanics.small_cost.home_echo_verified"
const FACT_DONOR_MECHANIC_COST := &"mechanic_cost_observed"
const FACT_LEDGER := &"p9.consent_and_cost.cost_ledger_read"
const FACT_CANONICAL_LEDGER := &"ucp_cost_ledger_found"
const FACT_OFFER := &"p9.consent_and_cost.adaptation_offer"
const FACT_SCOPE := &"p9.consent_and_cost.jakub_consent_scope"
const FACT_CANONICAL_SCOPE := &"jakub_consent_state"
const FACT_TRACE := &"p9.consent_and_cost.trace"
const FACT_FEEDBACK := &"p9.consent_and_cost.safe_trial_feedback"
const FACT_P7_TRACE := &"p7.work_history_and_record.trace"

const DONOR_TRIAL_VALUE := "small_cost_and_home_echo_confirmed"
const P7_TRACE_VALUE := "cost_ledger_and_consent_scope_recorded"
const SCOPE_GRANTED := &"granted"
const SCOPE_LIMITED := &"limited"
const SCOPE_REFUSED := &"refused"

signal clue_inspected(id: String, prop_type: int)
signal cost_ledger_read()
signal adaptation_offer_rejected()
signal jakub_consent_scope_recorded(scope: StringName)
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_cost_ledger_read := false
var is_adaptation_offer_rejected := false
var is_consent_scope_recorded := false
var jakub_consent_scope: StringName = &""
var is_exit_unlocked := false
var is_level_completed := false
var last_feedback: StringName = &""

var pending_consent_pairs: Array = []
var _pending_scope: StringName = &""
var _pending_method := ""
var _pending_reply := ""
var _pending_revised := false
var _desk_phase := 0.0


func _ready() -> void:
	var presentation := preload("res://scripts/levels/creative_scene_presentation.gd").new()
	presentation.name = "CreativeScenePresentation"
	add_child(presentation)
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	_restore_consent_state()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _physics_process(delta: float) -> void:
	_desk_phase = fmod(_desk_phase + delta, TAU)
func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s17_ledger_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s17_ledger_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Pary Linii 4. Ktoś utrzymuje zapis, ktoś drugi zapłacił.", "Line 4 pairs. Someone keeps the record, someone else paid.", &"", "")
	_register_beat(&"s17_adaptation_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Czy proponuje mi powrót do pracy, czy zajęcie jej miejsca? Przeczytam warunki.", "Is she offering work, or someone else's place? I will read the terms.", &"cheap_adaptation", "reject_adaptation_offer")
	_register_beat(&"s17_consent_plan", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Sprawdzę rachunek i ofertę. Potem porozmawiam z Jakubem o tym, w czym może pomóc.", "Read the ledger and offer, then ask Jakub what help he is willing to consider.", &"", "record_jakub_consent_granted")
	# PKG-0230 (P1-1+P1-4): zdanie wyjscia — 17 → 18: zakres zamyka sprawe
	# rejestru; dalej ulica, trzy drogi i prawda dla Marty.
	_register_beat(&"s17_exit_to_street", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zabiorę odpisy do Marty na ulicę. Prognozy mam w czytniku. Wrócę z jedną propozycją dla Jakuba.", "I will take the copies to Marta on the street, then return with one proposal for Jakub.", &"", "")
	_register_beat(&"s17_consent_recorded", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Ten zakres znam. Nie mam zgody na dowolną próbę.", "I know this scope. It is not permission for any trial.", &"", "")
	_register_beat(&"s17_consent_refused", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "JAKUB: Przyszłaś po odczyt, a teraz każesz mi podpisać protokół in blanco. Nie ze mną, Lena.", "JAKUB: You came for a reading, and now you want me to sign a blank protocol. Not with me, Lena.", &"", "")
	_register_beat(&"s17_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Po prognozie wróć do łącza. Środek biurka przypomina ryzyko bez udzielania zgody.", "HINT: Return to the link with a forecast. The center reviews risk without giving consent.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_17"
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
		"cost_ledger_console":
			read_cost_ledger()
		"adaptation_offer_terminal":
			reject_adaptation_offer()
		"consent_scope_desk":
			choose_consent_from_player_side()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)

func read_cost_ledger() -> bool:
	if is_cost_ledger_read:
		return false
	if not _has_donor_context():
		_record_feedback(&"institution_trial_required")
		return false
	is_cost_ledger_read = true
	_record(FACT_LEDGER, true)
	_record(FACT_CANONICAL_LEDGER, true)
	if guidance_service:
		guidance_service.trigger_beat(&"s17_ledger_contact")
	_report_progress(&"s17_cost_ledger_read")
	cost_ledger_read.emit()
	queue_redraw()
	return true


func reject_adaptation_offer() -> bool:
	if is_adaptation_offer_rejected:
		return false
	if not is_cost_ledger_read:
		_record_feedback(&"cost_ledger_required")
		return false
	is_adaptation_offer_rejected = true
	_record(FACT_OFFER, "rejected")
	if guidance_service:
		guidance_service.close_hypothesis(&"cheap_adaptation")
	_report_progress(&"s17_adaptation_offer_rejected")
	adaptation_offer_rejected.emit()
	queue_redraw()
	return true


func record_jakub_consent_granted() -> bool:
	return _commit_consent(SCOPE_GRANTED)


func record_jakub_consent_limited() -> bool:
	return _commit_consent(SCOPE_LIMITED)


func record_jakub_consent_refused() -> bool:
	return _commit_consent(SCOPE_REFUSED)


func choose_consent_from_player_side() -> bool:
	if props == null or player == null:
		_record_feedback(&"consent_desk_missing")
		return false
	var desk := props.get_node_or_null("ConsentScopeDesk") as Node2D
	if desk == null:
		_record_feedback(&"consent_desk_missing")
		return false
	var offset := player.global_position.x - desk.global_position.x
	if offset < -24.0:
		return _commit_consent(SCOPE_REFUSED)
	if offset > 24.0:
		return _commit_consent(SCOPE_GRANTED)
	return _commit_consent(SCOPE_LIMITED)

func _commit_consent(scope: StringName) -> bool:
	var decisions := _decisions()
	if NarrativeRules.locked(decisions) or not pending_consent_pairs.is_empty():
		_record_feedback(&"consent_scope_locked")
		return false
	if decisions.get(&"world_recognized", false) != true:
		return false
	if not is_cost_ledger_read or not is_adaptation_offer_rejected:
		_record_feedback(&"cost_ledger_required")
		return false
	if scope not in [SCOPE_GRANTED, SCOPE_LIMITED, SCOPE_REFUSED]:
		return false
	if not is_consent_scope_recorded:
		# Pierwsza rozmowa dopuszcza rolę, nie wykonuje żadnej metody.
		_pending_scope = scope
		pending_consent_pairs = preload("res://scripts/levels/creative_scene_lines.gd").LINES.get("consent_scope_desk_" + String(scope), []).duplicate(true)
		return true
	var method := str(decisions.get(NarrativeRules.PROPOSED_KEY, ""))
	if not NarrativeRules.METHODS.has(method) or decisions.get(&"p9.method_commitment.forecasts_compared", false) != true:
		_record_feedback(&"method_forecast_required")
		pending_consent_pairs = [["Jakub (łącze)", "Najpierw sprawdź, co zamierzasz zrobić. Mój zakres się nie zmienił."]]
		return false
	if not NarrativeRules.response(decisions, method).is_empty():
		pending_consent_pairs = [["Jakub (łącze)", "Odpowiedziałem na tę propozycję. Nie pytaj mnie o nią ponownie."]]
		return false
	if jakub_consent_scope.is_empty():
		pending_consent_pairs = [["Lena", "Zapisy zgody są sprzeczne. Nie uznam ich za pozwolenie."]]
		return false
	var revised := jakub_consent_scope == SCOPE_REFUSED
	if revised and (method != "close_equal_recover_local" or decisions.has(&"p9.consent_and_cost.revised_reading_response")):
		pending_consent_pairs = [["Jakub (łącze)", "Nie zgodziłem się na podłączenie. To nadal ta sama granica."]]
		return false
	if not revised and not NarrativeRules.scope_allows(decisions, method):
		pending_consent_pairs = [["Jakub (łącze)", "Mogę odczytać wskazania. Ta metoda wymaga czegoś więcej. Odmawiam."]]
		return false
	pending_consent_pairs = NarrativeRules.risk_pairs(method).duplicate(true)
	if scope == SCOPE_LIMITED:
		pending_consent_pairs.append(["Lena", "Przyniosłam warunki tej jednej metody. Na razie tylko je odczytujemy."])
		pending_consent_pairs.append(["WSKAZÓWKA", "Biurko: lewa strona — odmowa; prawa — odpowiedź na tę metodę; środek — odczyt ryzyka."])
		return true
	if revised:
		pending_consent_pairs.append(["Lena", "Odmówiłeś podłączenia. Teraz proszę tylko o odczyt przy odzyskaniu jej, bez kabla do człowieka."])
	else:
		pending_consent_pairs.append(["Lena", "To ryzyko tej jednej metody. Zgadzasz się na swój udział, czy kończymy?"])
	_pending_method = method
	_pending_revised = revised
	_pending_reply = "refused" if scope == SCOPE_REFUSED else "accepted"
	if _pending_reply == "refused":
		pending_consent_pairs.append(["Jakub (łącze)", "Nie. Znam warunki i nie biorę w tym udziału."])
		pending_consent_pairs.append(["Lena", "Nie będę powtarzać tej prośby."])
	else:
		match method:
			"force_home":
				pending_consent_pairs.append(["Jakub (łącze)", "Potwierdzę wskazanie. Za zostawienie jej odpowiadasz ty. Ja mogę przerwać swój udział."])
			"close_equal_recover_local":
				pending_consent_pairs.append(["Jakub (łącze)", "Tylko wskazania. Na to się zgadzam. Bez podłączenia do człowieka."])
			"mutual_passage":
				pending_consent_pairs.append(["Jakub (łącze)", "Rozumiem, że przeciek może wracać. Biorę udział. Wyłącznik zostaje przy mnie."])
		pending_consent_pairs.append(["Jakub (łącze)", "Potem wracam do napędu. Ta zmiana nie zrobi się sama."])
	return true

func _decisions() -> Dictionary:
	var state := get_node_or_null("/root/GameStateManager")
	return state.decisions if state != null else {}

func _restore_consent_state() -> void:
	var decisions := _decisions()
	is_cost_ledger_read = decisions.get(FACT_LEDGER, false) == true
	is_adaptation_offer_rejected = decisions.get(FACT_OFFER, "") == "rejected"
	jakub_consent_scope = StringName(NarrativeRules.scope(decisions))
	is_consent_scope_recorded = decisions.has(FACT_SCOPE) or decisions.has(FACT_CANONICAL_SCOPE)
	if is_consent_scope_recorded:
		_unlock_exit()

func _has_pending_narrative_dialogue(id: String) -> bool:
	return id == "consent_scope_desk" and not pending_consent_pairs.is_empty()

func _on_narrative_dialogue_finished(id: String) -> void:
	if id != "consent_scope_desk" or pending_consent_pairs.is_empty():
		return
	var decisions := _decisions()
	if not NarrativeRules.locked(decisions):
		if not _pending_scope.is_empty():
			_record(&"p9.consent_and_cost.initial_scope", String(_pending_scope))
			_write_scope(_pending_scope)
		elif not _pending_method.is_empty():
			var stored: Variant = decisions.get(NarrativeRules.RESPONSE_KEY, {})
			var replies: Dictionary = stored.duplicate(true) if stored is Dictionary else {}
			if not replies.has(_pending_method):
				replies[_pending_method] = _pending_reply
				_record(NarrativeRules.RESPONSE_KEY, replies)
				if _pending_revised:
					_record(&"p9.consent_and_cost.revised_reading_response", _pending_reply)
					if _pending_reply == "accepted":
						_write_scope(SCOPE_LIMITED)
	pending_consent_pairs.clear()
	_pending_scope = &""
	_pending_method = ""
	_pending_reply = ""
	_pending_revised = false
	_restore_consent_state()
	queue_redraw()

func _write_scope(scope: StringName) -> void:
	_record(FACT_SCOPE, String(scope))
	_record(FACT_CANONICAL_SCOPE, String(scope))
	_record(FACT_TRACE, "consent_scope_" + String(scope))
	_record(FACT_P7_TRACE, P7_TRACE_VALUE)
	jakub_consent_scope = scope
	is_consent_scope_recorded = true
	_report_progress(&"s17_consent_scope_recorded")
	jakub_consent_scope_recorded.emit(scope)
	_unlock_exit()


func _record_feedback(value: StringName) -> void:
	last_feedback = value
	_record(FACT_FEEDBACK, String(value))
	GapLedger.annotate_feedback(self, value) # PKG-0215 (D-228): blocked verb speaks its gap, if any.
	if guidance_service:
		guidance_service.report_failed_attempt(&"s17_" + value)


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
	if not pending_consent_pairs.is_empty():
		return
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _has_donor_context() -> bool:
	var trial_value := str(_read_decision(FACT_DONOR_TRIAL))
	return trial_value == DONOR_TRIAL_VALUE \
		and _has(FACT_DONOR_HOME_ECHO) \
		and _has(FACT_DONOR_MECHANIC_COST)


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return false
	var value: Variant = state.decisions.get(key, null)
	if value == null:
		return false
	if value is String or value is StringName:
		return not String(value).is_empty()
	return bool(value)


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
		"cost_ledger_console": return is_cost_ledger_read
		"adaptation_offer_terminal": return is_adaptation_offer_rejected
		"consent_scope_desk": return is_consent_scope_recorded
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
	_draw_ledger_hall()
	_draw_ledger_console()
	_draw_offer_terminal()
	_draw_consent_desk()
	_draw_exit()


func _draw_ledger_hall() -> void:
	# Rodzina instytucjonalna: długa oś w głąb, równomierne górne światło,
	# brudna biel dokumentów, zero ciepłego punktu i zero domowego mebla.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), Color("10171c"))
	draw_rect(Rect2(0.0, 0.0, 640.0, 84.0), Color("1c262c"))
	draw_rect(Rect2(0.0, 84.0, 640.0, 190.0), Color("1f2b31"))
	draw_rect(Rect2(0.0, 274.0, 640.0, 54.0), Color("0c1216"))
	draw_line(Vector2(0.0, 274.0), Vector2(640.0, 274.0), Color("2c3b42"), 1.0)
	# Powtarzalny moduł 64 px w głąb hali i jawna linia kontroli (lada) na 104 px.
	var module_x := 32.0
	while module_x <= 640.0:
		draw_line(Vector2(module_x, 96.0), Vector2(module_x, 118.0), Color("2a3a44"), 2.0)
		module_x += 64.0
	draw_line(Vector2(0.0, 104.0), Vector2(640.0, 104.0), Color("3c4d55"), 1.0)
	# Równomierne górne światło: dwa zimne pasy, bez punktu ciepła.
	draw_rect(Rect2(60.0, 88.0, 200.0, 4.0), Color(VectorStageStyle.LIGHT_PLANE, 0.16))
	draw_rect(Rect2(400.0, 88.0, 200.0, 4.0), Color(VectorStageStyle.LIGHT_PLANE, 0.16))


func _draw_ledger_console() -> void:
	var ledger_color := VectorStageStyle.ANCHOR_CYAN if is_cost_ledger_read else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(128.0, 238.0, 88.0, 42.0), Color("16222a"))
	draw_rect(Rect2(128.0, 238.0, 88.0, 42.0), ledger_color, false, 1.0)
	if is_cost_ledger_read:
		var pair_y := 246.0
		while pair_y <= 266.0:
			draw_line(Vector2(138.0, pair_y), Vector2(170.0, pair_y), ledger_color, 1.0)
			draw_line(Vector2(178.0, pair_y), Vector2(206.0, pair_y), VectorStageStyle.CORRECTION_OXIDE, 1.0)
			pair_y += 10.0
	else:
		draw_line(Vector2(138.0, 252.0), Vector2(206.0, 252.0), VectorStageStyle.shade(ledger_color, 0.4), 1.0)
		draw_line(Vector2(138.0, 262.0), Vector2(190.0, 262.0), VectorStageStyle.shade(ledger_color, 0.5), 1.0)


func _draw_offer_terminal() -> void:
	var offer_color := VectorStageStyle.LIGHT_PLANE if is_adaptation_offer_rejected else VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.42)
	draw_rect(Rect2(296.0, 232.0, 74.0, 48.0), Color("121b22"))
	draw_rect(Rect2(296.0, 232.0, 74.0, 48.0), offer_color, false, 1.0)
	draw_line(Vector2(306.0, 246.0), Vector2(360.0, 246.0), offer_color, 1.0)
	# PKG-0223 (N9): oferta jako gest w przestrzeni, nie trzeci akt tekstowy.
	# Dopoki wisi, terminal wyciaga cienka projekcje w strone biurka zgody
	# (os 370 -> 424); po odrzuceniu projekcja znika, zostaje przekreslenie.
	if is_adaptation_offer_rejected:
		draw_line(Vector2(312.0, 260.0), Vector2(354.0, 274.0), VectorStageStyle.CORRECTION_OXIDE, 2.0)
		draw_line(Vector2(354.0, 260.0), Vector2(312.0, 274.0), VectorStageStyle.CORRECTION_OXIDE, 2.0)
	else:
		draw_circle(Vector2(333.0, 267.0), 5.0, Color(offer_color, 0.5))
		draw_line(Vector2(370.0, 256.0), Vector2(424.0, 258.0), Color(offer_color, 0.35), 1.5)


func _draw_consent_desk() -> void:
	var desk_color := VectorStageStyle.ANCHOR_CYAN if is_consent_scope_recorded else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(424.0, 252.0, 120.0, 26.0), Color("18232b"))
	draw_line(Vector2(424.0, 252.0), Vector2(544.0, 252.0), desk_color, 2.0)
	# Trzy strefy zakresu: cofnięcie, przy biurku, krok naprzód.
	draw_circle(Vector2(452.0, 268.0), 3.0, VectorStageStyle.shade(desk_color, 0.25))
	draw_circle(Vector2(484.0, 268.0), 3.0, desk_color)
	draw_circle(Vector2(516.0, 268.0), 3.0, VectorStageStyle.shade(desk_color, 0.25))
	if is_consent_scope_recorded:
		var pulse := 0.5 + 0.15 * sin(_desk_phase * 2.0)
		draw_arc(Vector2(484.0, 264.0), 10.0, 0.0, TAU, 16, Color(desk_color, pulse), 1.5)
	else:
		draw_line(Vector2(444.0, 258.0), Vector2(524.0, 258.0), Color("3c4d55"), 1.0)
	# PKG-0230 (P1-3, S-07): jawne lacze do warsztatu na wsporniku nad lada.
	# Glos Jakuba i bezosobowa strona Wierzbickiej mowia PRZEZ ten terminal,
	# nie z kadru — Jakub zostaje przy napedzie (12: oddaje przed koncem
	# zmiany), wiec jego nieobecnosc w hali jest konsekwencja, nie brakiem.
	draw_rect(Rect2(436.0, 208.0, 40.0, 34.0), Color("121b22"))
	draw_rect(Rect2(436.0, 208.0, 40.0, 34.0), desk_color, false, 1.5)
	draw_line(Vector2(442.0, 218.0), Vector2(470.0, 218.0), desk_color, 1.5)
	draw_line(Vector2(442.0, 226.0), Vector2(470.0, 226.0), VectorStageStyle.shade(desk_color, 0.5), 1.5)
	draw_line(Vector2(442.0, 234.0), Vector2(458.0, 234.0), VectorStageStyle.shade(desk_color, 0.5), 1.5)
	draw_circle(Vector2(466.0, 234.0), 2.5, desk_color)
	draw_line(Vector2(456.0, 242.0), Vector2(456.0, 252.0), desk_color, 2.0)


func _draw_exit() -> void:
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(572.0, 146.0, 48.0, 12.0), exit_color, false, 1.5)
	draw_line(Vector2(610.0, 158.0), Vector2(610.0, 296.0), exit_color, 2.0)
	draw_line(Vector2(584.0, 296.0), Vector2(620.0, 296.0), exit_color, 2.0)
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy lady zgody w prawo, 0.48,
	# zgodnie z górnym światłem hali i konwencją 01/06/08.
	draw_colored_polygon(PackedVector2Array([
		Vector2(416.0, 276.0), Vector2(552.0, 274.0),
		Vector2(560.0, 282.0), Vector2(424.0, 284.0),
	]), Color(VectorStageStyle.INK, 0.48))

	queue_redraw()
