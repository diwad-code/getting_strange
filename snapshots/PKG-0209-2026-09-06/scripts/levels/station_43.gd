class_name Station43
extends Node2D

## PRZESZKODA — dlaczego to tu jest: Tablice ogłoszeń, karty spraw i rozkłady jazdy w mieście utrwalają stan podmiotów po rozstrzygnięciu.
## PRZESZKODA — czego wymaga od Leny: Odczytania tablicy miejskiej, przejścia przez napisy końcowe i wykonania ostatniej diegetycznej czynności.
## PRZESZKODA — koszt porażki: Nie ma fizycznego kosztu porażki; epilog jest zapisem nieodwracalnej nowej ciągłości i zamyka grę.

signal level_completed
signal previous_level_requested
signal interaction_triggered(id: String)
signal dialogue_advanced(line_index: int)
signal clue_inspected(id: String, prop_type: int)
signal notice_inspected
signal credits_inspected
signal blackout_inspected
signal epilogue_completed
signal exit_unlocked

const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")

const FACT_ENTRY := &"p7.conscious_silence_and_presence.final_chamber_witnessed"
const FACT_NOTICE := &"p7.conscious_silence_and_presence.epilogue_noticed"
const FACT_CREDITS := &"p7.conscious_silence_and_presence.epilogue_credits_read"
const FACT_COMPLETED := &"p7.conscious_silence_and_presence.epilogue_completed"
const FACT_COMMITMENT := &"p7.conscious_silence_and_presence.commitment"
const FACT_TRACE := &"p7.conscious_silence_and_presence.trace"
const FACT_FEEDBACK := &"p7.conscious_silence_and_presence.safe_trial_feedback"

const FACT_P9_ADMIN_NOTICE := &"p9.epilogue.admin_notice_inspected"
const FACT_P9_CREDITS := &"p9.epilogue.credits_read"
const FACT_P9_EXECUTED := &"p9.epilogue.executed"
const FACT_P9_ENDING_FAMILY := &"p9.epilogue.ending_family"
const FACT_P9_ENDING_STABILITY := &"p9.epilogue.ending_stability"
const FACT_P9_FEEDBACK := &"p9.epilogue.safe_trial_feedback"
const CANONICAL_EPILOGUE_WITNESSED := &"epilogue_witness_completed"

const METHOD_FORCE_HOME := "force_home"
const METHOD_CLOSE_EQUAL := "close_equal_recover_local"
const METHOD_MUTUAL := "mutual_passage"

@export var is_notice_inspected: bool = false
@export var is_credits_inspected: bool = false
@export var is_blackout_inspected: bool = false
@export var is_exit_unlocked: bool = false
@export var is_level_completed: bool = false
@export var is_dialogue_completed: bool = false
@export var dialogue_active: bool = true
@export var dialogue_index: int = 0

var ending_family: String = "unseeded"
var ending_stability: String = "unseeded"
var marta_truth_state: String = ""
var jakub_consent_state: String = ""
var household_consequence: Dictionary = {}
var last_feedback: StringName = &""

var _pulse_phase: float = 0.0

@onready var player: Node2D = get_node_or_null("Player")
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = get_node_or_null("Geometry")
@onready var props: Node2D = get_node_or_null("Props")
@onready var airlock_zone: Area2D = get_node_or_null("AirlockZone")
@onready var return_zone: Area2D = get_node_or_null("ReturnZone")
@onready var dialogue_box: CanvasLayer = get_node_or_null("CRTDialogueBox")
@onready var guidance_service: NarrativeGuidanceService = get_node_or_null("NarrativeGuidanceService")

const DEFAULT_DIALOGUE_LINES: Array[Dictionary] = [
	{
		"speaker": "ŚWIADECTWO",
		"text": "Napisy pojawiają się na zwyczajnych elementach miasta: rozkładach jazdy, kartach spraw, tablicach pracowni."
	},
	{
		"speaker": "POWRÓT",
		"text": "Radio podaje: »Linia 4 zamknięta do odwołania. Prosimy korzystać z wyznaczonego obejścia.« W mieście Leny ta linia według niej nigdy nie istniała."
	},
	{
		"speaker": "UZGODNIENIE",
		"text": "Karta zgłoszenia podaje: »Pęknięcie oznaczone. Data kontroli: po przybyciu osoby zgłaszającej.« Marta dopisuje datę ręcznie, bez komentarza."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Tablica UCP podaje: »W tej części budynku utrzymują się dwie kolejności. Przed przejściem ustal kierunek z drugą osobą.« Nikt nie usuwa żadnej z nich."
	},
	{
		"speaker": "ŚWIADECTWO",
		"text": "Lena odkłada klucze na blat. Miasto żyje dalej z nienazwanym wyborem."
	}
]

var dialogue_lines: Array[Dictionary] = DEFAULT_DIALOGUE_LINES


func _ready() -> void:
	if player:
		player.position = Vector2(65.0, 248.0)
	_read_campaign_state()
	_setup_dialogue_for_branch()
	_setup_camera()
	_setup_guidance()
	_connect_prop_signals()
	if airlock_zone and not airlock_zone.body_entered.is_connected(_on_airlock_zone_entered):
		airlock_zone.body_entered.connect(_on_airlock_zone_entered)
	if return_zone and not return_zone.body_entered.is_connected(_on_return_zone_entered):
		return_zone.body_entered.connect(_on_return_zone_entered)
	if dialogue_active:
		_show_dialogue_line(dialogue_index)
	queue_redraw()


func _read_campaign_state() -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state == null:
		return
	
	var fam = state.decisions.get("ending_family", "")
	if fam != null and not String(fam).is_empty():
		ending_family = String(fam)
	else:
		var method = state.decisions.get("p9.method_commitment.method_committed", "")
		if method == null or String(method).is_empty():
			method = state.decisions.get("method_committed", "")
		if method != null and not String(method).is_empty():
			ending_family = String(method)
		else:
			if bool(state.decisions.get("p9.finale.forced_return.executed", false)):
				ending_family = METHOD_FORCE_HOME
			elif bool(state.decisions.get("p9.finale.close_equal.executed", false)):
				ending_family = METHOD_CLOSE_EQUAL
			elif bool(state.decisions.get("p9.finale.mutual_passage.executed", false)):
				ending_family = METHOD_MUTUAL
			else:
				ending_family = "unseeded"

	var stab = state.decisions.get("ending_stability", "")
	if stab != null and not String(stab).is_empty():
		ending_stability = String(stab)
	else:
		ending_stability = "unseeded"

	var m_truth = state.decisions.get("p9.method_commitment.marta_truth_state", "")
	if m_truth == null or String(m_truth).is_empty():
		m_truth = state.decisions.get("marta_truth_state", "")
	marta_truth_state = String(m_truth)

	var j_scope = state.decisions.get("p9.consent_and_cost.jakub_consent_scope", "")
	if j_scope == null or String(j_scope).is_empty():
		j_scope = state.decisions.get("jakub_consent_state", "")
	jakub_consent_state = String(j_scope)

	match ending_family:
		METHOD_FORCE_HOME:
			var hc = state.decisions.get("p9.finale.forced_return.household_consequence", null)
			if hc is Dictionary:
				household_consequence = hc.duplicate(true)
		METHOD_CLOSE_EQUAL:
			var hc = state.decisions.get("p9.finale.close_equal.household_consequence", null)
			if hc is Dictionary:
				household_consequence = hc.duplicate(true)
		METHOD_MUTUAL:
			var hc = state.decisions.get("p9.finale.mutual_passage.household_consequence", null)
			if hc is Dictionary:
				household_consequence = hc.duplicate(true)


func _setup_dialogue_for_branch() -> void:
	match ending_family:
		METHOD_FORCE_HOME:
			dialogue_lines = [
				{
					"speaker": "TABLICA MIEJSKA",
					"text": "Linia 4 zamknięta do odwołania. W rozkładzie na wiacie brakuje jednego nocnego kursu."
				},
				{
					"speaker": "MIESZKANIE 14",
					"text": "Marta odłożyła klucze na blat. W przedpokoju słychać zegar; nikt nie pyta o to, co wydarzyło się za progiem."
				},
				{
					"speaker": "EWIDENCJA UCP",
					"text": "Teczka sprawy Leny otrzymała adnotację: »sprawa zamknięta bez dalszych roszczeń«. Miasto żyje dawnym rytmem."
				},
				{
					"speaker": "ŚWIADECTWO",
					"text": "Przybyła Lena zniknęła z rejestrów. W mieście pozostała luka, której nikt urzędowo nie nazwie."
				},
				{
					"speaker": "ŚWIADECTWO",
					"text": "Lena oznacza próbkę datą. Rubrykę przyczyny zostawia pustą."
				}
			]
		METHOD_CLOSE_EQUAL:
			dialogue_lines = [
				{
					"speaker": "TABLICA MIEJSKA",
					"text": "Komunikat techniczny: »Odcinek torowiska ustabilizowany. Spoiny zalać zaprawą bez zacierania faktury.«"
				},
				{
					"speaker": "MIESZKANIE 14",
					"text": "Miejscowa Lena wróciła na Sadową. W pracowni stoją dwa kubki, ale pije tylko z jednego."
				},
				{
					"speaker": "ULICA SADOWA",
					"text": "Marta domowa zostawiła drugie zgłoszenie o zaginięciu. Numeru zwrotnego nie dopisała."
				},
				{
					"speaker": "ŚWIADECTWO",
					"text": "Płaszczyzna została zamknięta. Miasto nie jest już rozdwojone, lecz nosi bliznę, której nikt nie ukrywa."
				},
				{
					"speaker": "ŚWIADECTWO",
					"text": "Na obcym przystanku Lena chowa czytnik do torby. Wiadomość `Jadę` zostaje bez adresata."
				}
			]
		METHOD_MUTUAL:
			dialogue_lines = [
				{
					"speaker": "TABLICA MIEJSKA",
					"text": "Na wiacie przystankowej wiszą dwa równorzędne rozkłady jazdy. Żadna z godzin odjazdu nie została przekreślona."
				},
				{
					"speaker": "MIESZKANIE 14",
					"text": "Marta rozpoznaje kubek ze zdjęcia. Wie, że po drugiej stronie ktoś patrzy teraz na pustą półkę."
				},
				{
					"speaker": "ZARZĄD MIEJSKI",
					"text": "Biuletyn UCP podaje: »W tym sektorze zaleca się uzgodnienie kierunku przed przejściem.« Obie kolejności trwają obok siebie."
				},
				{
					"speaker": "ŚWIADECTWO",
					"text": "Dwie Leny żyją w swoich światach, połączone cienką nicią pamięci i obustronnej zgody."
				},
				{
					"speaker": "ŚWIADECTWO",
					"text": "Lena odkłada kubek na pustą półkę. Drugi zostaje po jej stronie."
				}
			]
		_:
			dialogue_lines = DEFAULT_DIALOGUE_LINES.duplicate(true)


func _setup_guidance() -> void:
	if not guidance_service:
		return
	_register_beat(&"s43_epilogue_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s43_epilogue", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Epilog. Miasto żyje dalej z dokonanym wyborem i zapisanym stanem podmiotów.", "Epilogue. The city lives on with the choice made and recorded entity states.", &"", "")
	_register_beat(&"s43_epilogue_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Zapisane relacje i stan infrastruktury utrwalają wykonany wybór; braki zostają nazwane.", "Recorded relations and infrastructure state preserve the committed choice; the gaps stay named.", &"domestic_presence_with_gaps", "complete_epilogue")
	_register_beat(&"s43_epilogue_action", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Odczytam tablicę ogłoszeń, przejrzę napisy końcowe i zamknę podróż.", "Read notice board, review credits roll and conclude journey.", &"", "complete_epilogue")
	_register_beat(&"s43_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Odczytaj tablicę ogłoszeń i napisy końcowe, by zamknąć grę.", "HINT: Read notice board and credits to complete the game.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_43"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)


func _process(delta: float) -> void:
	_pulse_phase += delta * 2.0 * MotionAccessibility.motion_scale()
	queue_redraw()


func _connect_prop_signals() -> void:
	if props == null:
		return
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var pt := child as MemoryResonancePoint
			if not pt.resonance_triggered.is_connected(_on_prop_resonance_triggered):
				pt.resonance_triggered.connect(_on_prop_resonance_triggered)


func inspect_notice() -> bool:
	if is_notice_inspected:
		return false
	is_notice_inspected = true
	_record(FACT_NOTICE, true)
	_record(FACT_P9_ADMIN_NOTICE, true)
	_record_feedback(&"admin_notice_inspected")
	notice_inspected.emit()
	interaction_triggered.emit("prop_admin_notice_board")
	_activate_prop_by_id("prop_admin_notice_board")
	_activate_prop_by_id("admin_notice_board")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	queue_redraw()
	return true


func inspect_credits() -> bool:
	if is_credits_inspected:
		return false
	is_credits_inspected = true
	_record(FACT_CREDITS, true)
	_record(FACT_P9_CREDITS, true)
	_record_feedback(&"credits_inspected")
	credits_inspected.emit()
	interaction_triggered.emit("prop_credits_roll")
	_activate_prop_by_id("prop_credits_roll")
	_activate_prop_by_id("credits_roll")
	if dialogue_index < dialogue_lines.size() - 1:
		advance_dialogue()
	queue_redraw()
	return true


func inspect_blackout() -> bool:
	if is_blackout_inspected:
		return false
	is_blackout_inspected = true
	_record(FACT_COMPLETED, true)
	_record(CANONICAL_EPILOGUE_WITNESSED, true)
	_record(FACT_COMMITMENT, "epilogue_presence_witnessed")
	_record(FACT_TRACE, "conscious_silence_and_presence_witnessed")
	_record(FACT_P9_EXECUTED, true)
	_record(FACT_P9_ENDING_FAMILY, ending_family)
	_record(FACT_P9_ENDING_STABILITY, ending_stability)
	_record(FACT_P9_FEEDBACK, "epilogue_completed_cleanly")
	_record_feedback(&"epilogue_completed_cleanly")
	if guidance_service:
		guidance_service.close_hypothesis(&"domestic_presence_with_gaps")
	blackout_inspected.emit()
	interaction_triggered.emit("prop_final_blackout")
	_activate_prop_by_id("prop_final_blackout")
	_activate_prop_by_id("final_blackout")
	unlock_exit()
	_complete_campaign()
	queue_redraw()
	return true


func _on_prop_resonance_triggered(id: String, prop_type: int) -> void:
	clue_inspected.emit(id, prop_type)
	match id:
		"admin_notice_board", "prop_admin_notice_board":
			inspect_notice()
		"credits_roll", "prop_credits_roll":
			inspect_credits()
		"final_blackout", "prop_final_blackout":
			inspect_blackout()
		_:
			match prop_type:
				200:
					inspect_notice()
				201:
					inspect_credits()
				202:
					inspect_blackout()


func advance_dialogue() -> void:
	if dialogue_index < dialogue_lines.size() - 1:
		dialogue_index += 1
		dialogue_advanced.emit(dialogue_index)
		_show_dialogue_line(dialogue_index)
	else:
		is_dialogue_completed = true
		dialogue_active = false
		unlock_exit()
		if dialogue_box and dialogue_box.has_method("hide_box"):
			dialogue_box.hide_box()
	queue_redraw()


func _show_dialogue_line(idx: int) -> void:
	if idx < 0 or idx >= dialogue_lines.size():
		return
	var line: Dictionary = dialogue_lines[idx]
	if dialogue_box and dialogue_box.has_method("show_line"):
		dialogue_box.show_line(line.get("speaker", "ŚWIADECTWO"), line.get("text", ""))


func unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	exit_unlocked.emit()
	_activate_prop_by_id("FinalBlackout")
	_activate_prop_by_id("final_blackout")
	_activate_prop_by_id("prop_final_blackout")
	queue_redraw()


func _activate_prop_by_id(id: String) -> void:
	if props:
		for child in props.get_children():
			if child is MemoryResonancePoint and (child.resonance_id == id or child.name == id):
				child.is_activated = true
				child.queue_redraw()


func _complete_campaign() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	_record(FACT_COMPLETED, true)
	_record(CANONICAL_EPILOGUE_WITNESSED, true)
	_record(FACT_COMMITMENT, "epilogue_presence_witnessed")
	_record(FACT_TRACE, "conscious_silence_and_presence_witnessed")
	_record(FACT_P9_EXECUTED, true)
	_record(FACT_P9_ENDING_FAMILY, ending_family)
	_record(FACT_P9_ENDING_STABILITY, ending_stability)
	_record(FACT_P9_FEEDBACK, "epilogue_completed_cleanly")
	epilogue_completed.emit()
	
	var state := get_node_or_null("/root/GameStateManager")
	if state:
		if state.has_method("complete_station"):
			var should_trans: bool = bool(state.campaign_auto_transition_enabled) if "campaign_auto_transition_enabled" in state else false
			state.complete_station(&"station_43", should_trans)
		else:
			state.set("campaign_completed", true)
	level_completed.emit()


func _on_airlock_zone_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


func _on_return_zone_entered(body: Node2D) -> void:
	if body is PrototypePlayer or (body != null and body.name == "Player"):
		previous_level_requested.emit()


func _record_feedback(val: StringName) -> void:
	last_feedback = val
	_record(FACT_FEEDBACK, String(val))


func _record(fact_key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null and state.has_method("record_decision"):
		state.record_decision(fact_key, value)


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	# Rodzina 7 (Finałowa / Epilogiczna):
	# Przestrzeń już odwiedzona (wiata i torowisko ze Stacji 03 / 05 / 18),
	# armatura bez zmian, pora świtu (świt na horyzoncie),
	# dokładnie jeden zmieniony fakt o ludziach, cisza z jednym źródłem.
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)

	# 1. Niebo o świcie: chłodny granat z miękkim bursztynowo-szarym brzaskiem przy horyzoncie
	draw_rect(Rect2(0.0, 0.0, 640.0, 114.0), Color("0d151e"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 86.0), Vector2(640.0, 86.0),
		Vector2(640.0, 116.0), Vector2(0.0, 116.0)
	]), Color(0.18, 0.22, 0.26, 0.7))
	draw_line(Vector2(0.0, 114.0), Vector2(640.0, 114.0), Color(0.32, 0.30, 0.26, 0.6), 1.0)

	# 2. Sylwetka budynków w tle (rozpoznawalna z 05/18)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, 114.0),
		Vector2(40.0, 98.0), Vector2(110.0, 98.0), Vector2(130.0, 110.0),
		Vector2(210.0, 92.0), Vector2(290.0, 92.0), Vector2(320.0, 106.0),
		Vector2(410.0, 86.0), Vector2(490.0, 86.0), Vector2(520.0, 104.0),
		Vector2(610.0, 96.0), Vector2(640.0, 96.0),
		Vector2(640.0, 126.0), Vector2(0.0, 126.0)
	]), VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.32))

	# 3. Ściana i szkielet geometryczny peronu
	VectorStageStyle.draw_play_plane(self, geometry)

	# 4. Wiata przystankowa ze Stacji 03: zadaszenie i stalowe słupy
	draw_colored_polygon(PackedVector2Array([
		Vector2(44.0, 90.0), Vector2(330.0, 76.0),
		Vector2(346.0, 102.0), Vector2(52.0, 116.0)
	]), VectorStageStyle.MID_PLANE)
	draw_line(Vector2(44.0, 90.0), Vector2(330.0, 76.0), VectorStageStyle.LIGHT_PLANE, 1.5)
	draw_line(Vector2(56.0, 114.0), Vector2(58.0, 280.0), VectorStageStyle.LIGHT_PLANE, 3.5)
	draw_line(Vector2(300.0, 102.0), Vector2(304.0, 280.0), VectorStageStyle.LIGHT_PLANE, 3.5)

	# Ławka przystankowa (znana ze Stacji 03)
	draw_rect(Rect2(104.0, 236.0, 132.0, 14.0), VectorStageStyle.DEEP_PLANE)
	draw_line(Vector2(104.0, 236.0), Vector2(236.0, 236.0), VectorStageStyle.LIGHT_PLANE, 1.5)
	draw_line(Vector2(120.0, 250.0), Vector2(120.0, 280.0), VectorStageStyle.MID_PLANE, 2.0)
	draw_line(Vector2(220.0, 250.0), Vector2(220.0, 280.0), VectorStageStyle.MID_PLANE, 2.0)

	# 5. Zmieniony fakt dotyczący ludzi (kontrakt Rodziny 7)
	_draw_branch_changed_fact()

	# 6. Nawierzchnia peronu i szyny tramwajowe
	draw_rect(Rect2(0.0, 280.0, 640.0, 80.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.26))
	draw_line(Vector2(0.0, 280.0), Vector2(640.0, 280.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(0.0, 298.0, 640.0, 22.0), VectorStageStyle.INK)
	draw_line(Vector2(0.0, 302.0), Vector2(640.0, 302.0), VectorStageStyle.LIGHT_PLANE, 1.5)
	draw_line(Vector2(0.0, 316.0), Vector2(640.0, 316.0), VectorStageStyle.LIGHT_PLANE, 1.5)
	var sleeper_x := 12.0
	while sleeper_x < 630.0:
		draw_line(Vector2(sleeper_x, 299.0), Vector2(sleeper_x + 8.0, 319.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.4), 1.5)
		sleeper_x += 36.0

	# 7. Tablica ogłoszeń miejskich (AdminNoticeBoard at x=160)
	_draw_notice_board()

	# 8. Kolumna napisów i licencji (CreditsRoll at x=340)
	_draw_credits_board()

	# 9. Sygnalizator zakończenia i nowej ciągłości (FinalBlackout at x=520)
	_draw_blackout_beacon()
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy ławki peronu w prawo, 0.48,
	# zgodnie ze światłem świtu. Finał: cisza z jednym źródłem (dron świtu
	# rigu); brak dodatkowego pozycjonowanego humu — decyzja jawna.
	draw_colored_polygon(PackedVector2Array([
		Vector2(96.0, 278.0), Vector2(244.0, 276.0),
		Vector2(252.0, 284.0), Vector2(104.0, 286.0),
	]), Color(VectorStageStyle.INK, 0.48))


func _draw_branch_changed_fact() -> void:
	match ending_family:
		METHOD_FORCE_HOME:
			# Pusta ławka z taśmą zamknięcia linii na słupie
			draw_line(Vector2(50.0, 142.0), Vector2(68.0, 184.0), VectorStageStyle.CORRECTION_OXIDE, 2.5)
			draw_line(Vector2(52.0, 146.0), Vector2(66.0, 180.0), VectorStageStyle.HUMAN_AMBER, 1.0)
		METHOD_CLOSE_EQUAL:
			# Skrzynka narzędziowa na ławce i spoina naprawionego gruntu
			draw_rect(Rect2(124.0, 222.0, 22.0, 14.0), VectorStageStyle.MID_PLANE)
			draw_line(Vector2(124.0, 222.0), Vector2(146.0, 222.0), VectorStageStyle.HUMAN_AMBER, 1.5)
			draw_line(Vector2(135.0, 218.0), Vector2(135.0, 222.0), VectorStageStyle.LIGHT_PLANE, 1.5)
			draw_line(Vector2(170.0, 280.0), Vector2(250.0, 280.0), VectorStageStyle.HUMAN_AMBER, 2.0)
		METHOD_MUTUAL:
			# Dwa znaczniki obecności na krawędzi peronu i podwójna gablota
			draw_circle(Vector2(140.0, 276.0), 3.0, VectorStageStyle.HUMAN_AMBER)
			draw_circle(Vector2(200.0, 276.0), 3.0, VectorStageStyle.ANCHOR_CYAN)
			draw_rect(Rect2(286.0, 132.0, 10.0, 16.0), VectorStageStyle.HUMAN_AMBER, false, 1.0)
			draw_rect(Rect2(302.0, 132.0, 10.0, 16.0), VectorStageStyle.ANCHOR_CYAN, false, 1.0)
		_:
			# Domyślny / nieseedowany epilog: pusta ławka miejska
			pass


func _draw_notice_board() -> void:
	var notice_color := VectorStageStyle.HUMAN_AMBER if is_notice_inspected else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.44)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(110.0, 110.0),
			Vector2(210.0, 104.0),
			Vector2(218.0, 172.0),
			Vector2(104.0, 178.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0,
	)
	draw_line(Vector2(118.0, 126.0), Vector2(202.0, 122.0), notice_color, 1.5)
	draw_line(Vector2(118.0, 138.0), Vector2(188.0, 134.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(118.0, 150.0), Vector2(196.0, 146.0), VectorStageStyle.shade(notice_color, 0.6), 1.0)
	# Podstawa słupka
	draw_line(Vector2(160.0, 174.0), Vector2(160.0, 280.0), VectorStageStyle.LIGHT_PLANE, 2.0)


func _draw_credits_board() -> void:
	var credits_color := VectorStageStyle.ANCHOR_CYAN if is_credits_inspected else VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.46)
	VectorStageStyle.draw_facet_polygon(
		self,
		PackedVector2Array([
			Vector2(290.0, 100.0),
			Vector2(390.0, 94.0),
			Vector2(398.0, 168.0),
			Vector2(284.0, 174.0),
		]),
		VectorStageStyle.MID_PLANE,
		1.0,
	)
	draw_line(Vector2(298.0, 116.0), Vector2(382.0, 112.0), credits_color, 1.5)
	draw_line(Vector2(298.0, 128.0), Vector2(368.0, 124.0), VectorStageStyle.LIGHT_PLANE, 1.0)
	draw_line(Vector2(298.0, 140.0), Vector2(376.0, 136.0), VectorStageStyle.shade(credits_color, 0.6), 1.0)
	# Podstawa słupka
	draw_line(Vector2(340.0, 170.0), Vector2(340.0, 280.0), VectorStageStyle.LIGHT_PLANE, 2.0)


func _draw_blackout_beacon() -> void:
	var blackout_color := VectorStageStyle.LIGHT_PLANE if is_blackout_inspected else (VectorStageStyle.HUMAN_AMBER if is_exit_unlocked else VectorStageStyle.MID_PLANE)
	var pulse := sin(_pulse_phase * 2.0) * 2.0 * MotionAccessibility.motion_scale()
	draw_circle(Vector2(520.0, 244.0), 12.0, blackout_color)
	draw_circle(Vector2(520.0, 244.0), 16.0 + pulse, VectorStageStyle.shade(blackout_color, 0.4))
	if is_exit_unlocked:
		draw_line(Vector2(520.0, 244.0), Vector2(520.0, 100.0), Color(VectorStageStyle.HUMAN_AMBER, 0.25), 2.0)


func _setup_camera() -> void:
	camera = StationCameraRig.bind(self, player)
