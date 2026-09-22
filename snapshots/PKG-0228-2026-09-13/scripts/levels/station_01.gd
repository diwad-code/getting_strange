class_name Station01
extends Node2D

## Station 01 — human worksite.
## Lena is finishing one vibration reading near Line 4. The machine works without
## her; she chooses between a clean repeat and keeping her promise to Marta.
##
## PKG-0176 (DEF-1, `COLD_OPEN_SPEC.md` §4) dokłada warstwę B zimnego otwarcia
## przed rozwidleniem: gracz podchodzi do stanowiska, uruchamia jeden przebieg
## pomiaru, widzi rozbieżność zapisu i wiadomość Marty na tym samym ekranie
## przyrządu, i dopiero wtedy otwierają się dwie drogi stacji. Nie powstaje nowy
## adres ani czwarty punkt interakcji: rejestrator jest tą samą `MeasurementRig`,
## która już istniała, tylko użytą raz przed rozwidleniem (spec §7).
##
## PRZESZKODA — dlaczego to tu jest: Stanowisko pomiarowe wymaga domknięcia jednej serii, bo surowy zapis i powtórka muszą dać się porównać po zakończeniu zmiany.
## PRZESZKODA — czego wymaga od Leny: wyboru między powtórką z zachowaniem próbki a spakowaniem sprzętu i wyjściem zgodnie z obietnicą.
## PRZESZKODA — koszt porażki: powtórka kosztuje Martę kolejne minuty, a wyjście na czas pozostawia lukę bez drugiego pomiaru.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")
const ColdOpenFactsScript := preload("res://scripts/campaign/cold_open_facts.gd")
const VibrationTraceDisplayScript := preload("res://scripts/visual/vibration_trace_display.gd")

const FACT_GAP := &"p7.sample_and_promise.gap_observed"
const FACT_MOUNT := &"p7.sample_and_promise.mount_checked"
const FACT_RAW := &"p7.sample_and_promise.raw_record_checked"
const FACT_RESULT := &"p7.sample_and_promise.measurement_result"
const FACT_SAMPLE := &"p7.sample_and_promise.sample_preserved"
const FACT_FEEDBACK := &"p7.sample_and_promise.safe_trial_feedback"
const OPENING_CHOICE := &"p9.opening.choice"
const CHOICE_REPEAT := "repeat_sample"
const CHOICE_LEAVE := "leave_on_time"

## PKG-0222 (M10): adres bez przeszkody fizycznej — stanowisko wymaga wyboru
## miedzy powtorka z zachowaniem probki a wyjsciem zgodnie z obietnica,
## nie pokonywania geometrii. Maszyna pracuje sama (D-197).
const IS_PHYSICAL_OBSTACLE_FREE := true

## Warstwa B. `AWAIT_MEASUREMENT` to jedyny stan, w którym cokolwiek działa;
## `DONE` oznacza otwarte rozwidlenie stacji.
enum ColdOpenStage { AWAIT_MEASUREMENT, MEASURING, RESULT, MESSAGE, DONE }

## Przyrząd ma własny czas: jeden przebieg pomiaru trwa tyle samo niezależnie od
## tego, jak szybko gracz klika (spec §4.1 krok 3).
const MEASUREMENT_PASS_SECONDS := 3.5
const RESULT_DWELL_SECONDS := 1.1
const MESSAGE_DWELL_SECONDS := 0.8

## PKG-0219 (V6): rodzina 5 (LOCATION_FAMILY_BIBLE §7) — swiatlo robocze na
## stanowisko + zimne wypelnienie z gory; cien kontaktowy w prawo, 0.48,
## konwencja 01/06/08. Pozycje w logical px (640x360).
const WORK_LIGHT_POS := Vector2(247.0, 188.0)
const WORK_LIGHT_CONE_ALPHA := 0.12
const COLD_FILL_ALPHA := 0.06
const CONTACT_SHADOW_ALPHA := 0.48

signal measurement_repeated()
signal sample_secured()
signal marta_message_read()
signal cold_open_measurement_started()
signal cold_open_fork_opened()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var dialogue: CRTDialogueBox = $CRTDialogueBox
@onready var instrument_trace: VibrationTraceDisplay = $InstrumentTrace
@onready var marta_screen_message: CrispDiegeticText = $CrispDiegeticText_MartaMessage

var is_measurement_repeated := false
var is_sample_secured := false
var is_marta_message_read := false
var is_exit_unlocked := false
var is_level_completed := false
var opening_choice := ""

var cold_open_stage: ColdOpenStage = ColdOpenStage.DONE
var _stage_time := 0.0

## PKG-0197 (ZERO REWIZJA, D-214): maszyna ma własny czas, niezależny od gracza.
## Bęben rejestratora obraca się powoli zawsze (odpowiedź na test kanonu
## przeszkód: robiłaby to samo, gdyby gracza tu nie było), a szum hali ma
## słyszalne źródło w kadrze przy maszynie. Warstwa czysto wizualno-dźwiękowa:
## zero writerów, flag, sygnałów i zmian routingu.
var _machine_time := 0.0
var _machine_hum: AudioStreamPlayer2D = null


func _ready() -> void:
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_action_points()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	_set_action_available(&"read_marta_message", false)
	_setup_cold_open()
	_setup_machine_hum()
	queue_redraw()


## PKG-0197: słyszalne źródło cyklu maszyny w kadrze (przy rejestratorze).
## Dźwięk hali gra zawsze, niezależnie od czynności gracza.
func _setup_machine_hum() -> void:
	if has_node("MachineHum"):
		_machine_hum = get_node("MachineHum") as AudioStreamPlayer2D
		return
	_machine_hum = AudioStreamPlayer2D.new()
	_machine_hum.name = "MachineHum"
	_machine_hum.position = Vector2(210.0, 190.0)
	_machine_hum.volume_db = -24.0
	_machine_hum.stream = ProceduralAudio.get_cached_sound(&"s01_machine_hum", ProceduralAudio.create_act1_fluorescent_ballast_hum_sound)
	add_child(_machine_hum)
	_machine_hum.play()


func _process(_delta: float) -> void:
	_machine_time += _delta
	queue_redraw()


# ─── Warstwa B zimnego otwarcia ──────────────────────────────────────────────

func _setup_cold_open() -> void:
	var state := get_node_or_null("/root/GameStateManager")
	var already_done := ColdOpenFactsScript.is_cold_open_completed(state)
	cold_open_stage = ColdOpenStage.DONE if already_done else ColdOpenStage.AWAIT_MEASUREMENT
	_stage_time = 0.0
	if marta_screen_message != null:
		marta_screen_message.text = "" if not already_done else ColdOpenFactsScript.TEXT_MARTA_MESSAGE
	if instrument_trace != null:
		instrument_trace.mode = (
			VibrationTraceDisplayScript.Mode.ARCHIVE if already_done
			else VibrationTraceDisplayScript.Mode.IDLE
		)
	# `OpeningDialogueCue` wypowiada słowo „drgań” przy wejściu na stację. To
	# jest pierwsze miejsce, w którym pada, i pada po czterech krokach obrazu z
	# warstwy A — dlatego zgłaszamy je jako ostatni krok kolejności §4.3.
	var cue := get_node_or_null("OpeningDialogueCue")
	if cue != null and String(cue.get("opening_line")).to_lower().contains("drga"):
		ColdOpenFactsScript.record_step.call_deferred(ColdOpenFactsScript.STEP_WORD_SPOKEN)


func is_cold_open_active() -> bool:
	return cold_open_stage != ColdOpenStage.DONE


## Wymuszona czynność zimnego otwarcia: jeden przebieg pomiaru na rejestratorze.
## To ta sama interakcja, która prowadzi później do powtórki — tu użyta raz,
## przed rozwidleniem, żeby rozbieżność była obserwowana, a nie zapowiedziana.
func run_opening_measurement() -> bool:
	if cold_open_stage != ColdOpenStage.AWAIT_MEASUREMENT:
		return false
	cold_open_stage = ColdOpenStage.MEASURING
	_stage_time = 0.0
	if instrument_trace != null:
		instrument_trace.mode = VibrationTraceDisplayScript.Mode.LIVE
		instrument_trace.pass_progress = 0.0
	ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_TOOL_PROCEDURE)
	_record(&"p9.cold_open.opening_measurement_run", true)
	cold_open_measurement_started.emit()
	queue_redraw()
	return true


func _physics_process(delta: float) -> void:
	if instrument_trace != null and player != null:
		var dist := player.global_position.distance_to(instrument_trace.global_position)
		instrument_trace.interference_factor = clampf(1.0 - (dist / 140.0), 0.0, 1.0)
	if cold_open_stage == ColdOpenStage.DONE:
		return
	_stage_time += delta
	match cold_open_stage:
		ColdOpenStage.MEASURING:
			_tick_measurement_pass()
		ColdOpenStage.RESULT:
			_tick_result_dwell()
		ColdOpenStage.MESSAGE:
			_tick_message_dwell()
		_:
			pass


func _tick_measurement_pass() -> void:
	if instrument_trace == null:
		_enter_result()
		return
	instrument_trace.pass_progress = clampf(_stage_time / MEASUREMENT_PASS_SECONDS, 0.0, 1.0)
	if instrument_trace.has_reached_spike():
		ColdOpenFactsScript.record_step(ColdOpenFactsScript.STEP_TRACE_SPIKED)
	if instrument_trace.has_returned_to_noise():
		ColdOpenFactsScript.record_step(ColdOpenFactsScript.STEP_TRACE_REST)
	if _stage_time >= MEASUREMENT_PASS_SECONDS:
		_enter_result()


func _enter_result() -> void:
	cold_open_stage = ColdOpenStage.RESULT
	_stage_time = 0.0
	if instrument_trace != null:
		instrument_trace.mode = VibrationTraceDisplayScript.Mode.ARCHIVE
	ColdOpenFactsScript.record_step(ColdOpenFactsScript.STEP_ARCHIVE_GAP)
	ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_MEASUREMENT_OFF, "layer_b_live_vs_archive")
	_record(&"p9.opening.line_four_gap_seen", true)
	_record(FACT_GAP, true)
	_present([
		{"speaker": "LENA", "text": ColdOpenFactsScript.LINE_LENA_GAP},
	])
	queue_redraw()


func _tick_result_dwell() -> void:
	if _stage_time < RESULT_DWELL_SECONDS:
		return
	cold_open_stage = ColdOpenStage.MESSAGE
	_stage_time = 0.0
	if marta_screen_message != null:
		marta_screen_message.text = ColdOpenFactsScript.TEXT_MARTA_MESSAGE
	ColdOpenFactsScript.record_fact(ColdOpenFactsScript.FACT_SOMEONE_WAITS)
	_record(&"p9.cold_open.marta_message_displayed", true)
	_play_message_chime()
	queue_redraw()


func _tick_message_dwell() -> void:
	if _stage_time < MESSAGE_DWELL_SECONDS:
		return
	_open_opening_fork()


func _open_opening_fork() -> void:
	if cold_open_stage == ColdOpenStage.DONE:
		return
	cold_open_stage = ColdOpenStage.DONE
	_stage_time = 0.0
	if marta_screen_message != null:
		marta_screen_message.text = ColdOpenFactsScript.TEXT_MARTA_MESSAGE
	if instrument_trace != null:
		instrument_trace.mode = VibrationTraceDisplayScript.Mode.ARCHIVE
	_record(ColdOpenFactsScript.LAYER_B_DONE, true)
	cold_open_fork_opened.emit()
	queue_redraw()


func _play_message_chime() -> void:
	var voice := AudioStreamPlayer.new()
	voice.name = "MartaMessageChime"
	voice.stream = ProceduralAudio.get_cached_sound(&"s01_marta_message", ProceduralAudio.create_phone_ring_pulse_sound)
	add_child(voice)
	if DisplayServer.get_name() == "headless":
		get_tree().process_frame.connect(voice.queue_free, CONNECT_ONE_SHOT)
	else:
		voice.finished.connect(voice.queue_free)
	voice.play()


# ─── Interakcje stacji ───────────────────────────────────────────────────────

func _connect_action_points() -> void:
	for child in props.get_children():
		if child is OpeningActionPoint:
			var action := child as OpeningActionPoint
			if not action.action_requested.is_connected(_on_action_requested):
				action.action_requested.connect(_on_action_requested)


func _on_action_requested(action_id: StringName) -> void:
	if cold_open_stage != ColdOpenStage.DONE:
		# Jedna wykonalna czynność: uruchom pomiar. Reszta punktów zostaje
		# widoczna i odpowiada brakiem przesłanki, nie znika (PKG-0175).
		if action_id == &"repeat_line_four_measurement" and cold_open_stage == ColdOpenStage.AWAIT_MEASUREMENT:
			run_opening_measurement()
		else:
			_record_feedback(&"cold_open_measurement_required")
		return
	match action_id:
		&"repeat_line_four_measurement":
			repeat_line_four_measurement()
		&"secure_raw_sample":
			if is_measurement_repeated:
				secure_raw_sample()
			else:
				pack_equipment_for_marta()
		&"read_marta_message":
			read_marta_message()


func repeat_line_four_measurement() -> bool:
	if is_measurement_repeated or not opening_choice.is_empty():
		return false
	# Wywołanie z kodu (bramki dawnych pakietów) przed zamknięciem warstwy B
	# domyka ją, zamiast zostawiać stację w stanie pośrednim.
	if cold_open_stage != ColdOpenStage.DONE:
		_open_opening_fork()
	is_measurement_repeated = true
	_record(FACT_GAP, true)
	_record(FACT_MOUNT, true)
	_record(FACT_RAW, true)
	_record(FACT_RESULT, "gap_retained_after_clean_repeat")
	_record(&"p9.opening.line_four_gap_seen", true)
	_resolve_action(&"repeat_line_four_measurement")
	_set_action_available(&"secure_raw_sample", true)
	measurement_repeated.emit()
	_present([
		{"speaker": "LENA", "text": "Mocowanie jest czyste. Zapis dalej gubi trzy sekundy."},
	])
	_show_step_status("POMIAR // POWTÓRZONY")
	queue_redraw()
	return true


func secure_raw_sample() -> bool:
	if not is_measurement_repeated or is_sample_secured or not opening_choice.is_empty():
		_record_feedback(&"measurement_required")
		return false
	opening_choice = CHOICE_REPEAT
	is_sample_secured = true
	_record(FACT_SAMPLE, true)
	_record(&"home_sample_preserved", true)
	_record(&"p9.opening.sample_carried_home", true)
	_record(&"p9.opening.equipment_packed", false)
	_record(OPENING_CHOICE, opening_choice)
	_resolve_action(&"secure_raw_sample")
	_set_action_available(&"read_marta_message", true)
	sample_secured.emit()
	_present([
		{"speaker": "LENA", "text": "Biorę surową próbkę. Raport może poczekać."},
	])
	_show_step_status("PRÓBKA // ZABEZPIECZONA")
	queue_redraw()
	return true


func pack_equipment_for_marta() -> bool:
	if is_measurement_repeated or not opening_choice.is_empty():
		_record_feedback(&"choice_already_committed")
		return false
	if cold_open_stage != ColdOpenStage.DONE:
		_open_opening_fork()
	opening_choice = CHOICE_LEAVE
	_record(FACT_RESULT, "repeat_declined_equipment_packed")
	_record(FACT_SAMPLE, false)
	_record(&"home_sample_preserved", false)
	_record(&"p9.opening.sample_carried_home", false)
	_record(&"p9.opening.equipment_packed", true)
	_record(OPENING_CHOICE, opening_choice)
	_resolve_action(&"secure_raw_sample")
	_set_action_available(&"repeat_line_four_measurement", false)
	_set_action_available(&"read_marta_message", true)
	_present([
		{"speaker": "LENA", "text": "Nie robię drugiej próby. Pakuję czytnik i wychodzę do Marty."},
	])
	_show_step_status("SPRZĘT // SPAKOWANY")
	queue_redraw()
	return true


func read_marta_message() -> bool:
	if opening_choice.is_empty() or is_marta_message_read:
		_record_feedback(&"opening_choice_required")
		return false
	is_marta_message_read = true
	_record(&"p9.opening.marta_waiting", true)
	_resolve_action(&"read_marta_message")
	marta_message_read.emit()
	if opening_choice == CHOICE_REPEAT:
		_present([
			{"speaker": "MARTA", "text": "Miałyśmy zacząć o wpół do dziewiątej. Napisz tylko, czy jedziesz."},
			{"speaker": "LENA", "text": "Jadę. Powtórzyłam pomiar i zabrałam próbkę. Będę później."},
		])
	else:
		_present([
			{"speaker": "MARTA", "text": "Miałyśmy zacząć o wpół do dziewiątej. Herbata jeszcze jest gorąca."},
			{"speaker": "LENA", "text": "Spakowałam sprzęt. Jadę zgodnie z obietnicą."},
		])
	_unlock_exit()
	_show_step_status("WYJŚCIE // ODBLOKOWANE")
	queue_redraw()
	return true


func unlock_exit_for_return() -> void:
	_unlock_exit()


func _unlock_exit() -> void:
	if is_exit_unlocked:
		return
	is_exit_unlocked = true
	if chamber_door != null:
		ExitClearance.disable_collision(chamber_door)
	pass  # PKG-0174: ThresholdZone requires interact


func _complete_if_player_already_in_airlock() -> void:
	if airlock_zone != null and player != null and airlock_zone.overlaps_body(player):
		_trigger_level_completion()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s01_composition", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s01_door_blocked", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Zostawię surowy odczyt, jutro będę tu wracać z raportem. Zbieram torbę.", "I will leave the raw reading; I will return here tomorrow with the report. Packing the bag.", &"", "")

func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_01"
	beat.tier = tier
	beat.thought_kind = thought_kind
	beat.truth_scope = truth_scope
	beat.text_pl = text_pl
	beat.text_en = text_en
	beat.cooldown_s = 8.0
	beat.hypothesis_id = hypothesis_id
	beat.predicted_check = predicted_check
	guidance_service.register_beat(beat)

func _on_airlock_body_entered(_body: Node2D) -> void:
	# PKG-0174: AirlockZone is a closure zone, not a trigger.
	pass


func _trigger_level_completion() -> void:
	if is_level_completed:
		return
	is_level_completed = true
	level_completed.emit()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	GapLedger.annotate_feedback(self, value) # PKG-0215 (D-228): blocked verb speaks its gap, if any.


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _resolve_action(action_id: StringName) -> void:
	var action := _find_action(action_id)
	if action != null:
		action.resolve()


func _set_action_available(action_id: StringName, available: bool) -> void:
	var action := _find_action(action_id)
	if action != null:
		action.set_available(available)


func _find_action(action_id: StringName) -> OpeningActionPoint:
	for child in props.get_children():
		if child is OpeningActionPoint and (child as OpeningActionPoint).action_id == action_id:
			return child as OpeningActionPoint
	return null


func _present(lines: Array) -> void:
	if dialogue != null:
		dialogue.present(lines)


## PKG-0186 (playtest lead L03). The world checkmark for the step that just
## resolved (`_draw()` below) sits under the CRT dialogue panel while a
## confirming line is on screen, so the confirmation also has to live on the
## panel that is covering it, not only on the world beneath it.
func _show_step_status(status_text: String) -> void:
	if dialogue != null:
		dialogue.set_step_status(status_text)


func _draw() -> void:
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	draw_rect(Rect2(0.0, 0.0, 640.0, 360.0), VectorStageStyle.INK)
	draw_rect(Rect2(18.0, 44.0, 604.0, 262.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(18.0, 306.0, 604.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_line(Vector2(18.0, 306.0), Vector2(622.0, 306.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# PKG-0219 (V6): zimne wypelnienie z gory (rodzina 5: work light + cold
	# fill). Waski pas chlodnego wash nad stanowiskiem; maszyna i meble
	# maluja nad nim bez zmian.
	draw_rect(Rect2(18.0, 44.0, 604.0, 26.0), Color(VectorStageStyle.ANCHOR_CYAN, COLD_FILL_ALPHA))
	# Machine: one clear job, one moving recorder drum and a path to the exit.
	draw_colored_polygon(PackedVector2Array([
		Vector2(70.0, 92.0), Vector2(318.0, 76.0), Vector2(342.0, 286.0), Vector2(54.0, 294.0),
	]), VectorStageStyle.MID_PLANE)
	# PKG-0176: pulpit przyrządu. Wykres i wiadomość Marty dzielą jeden ekran,
	# bo tego wymaga `COLD_OPEN_SPEC.md` §4.1 krok 6 — jedna warstwa diegetyczna.
	draw_rect(Rect2(84.0, 90.0, 162.0, 72.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(84.0, 90.0, 162.0, 72.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.42), false, 1.0)
	draw_rect(Rect2(90.0, 96.0, 150.0, 60.0), VectorStageStyle.INK)
	# Recorder drum housing, below the console face and below the machine label.
	# PKG-0136 / PKG-0137 trzymaja etykiete diegetyczna nad pasem sylwetki Leny,
	# wiec pas y 162..190 nalezy do napisu, a nie do rysunku maszyny.
	draw_rect(Rect2(196.0, 190.0, 102.0, 84.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(212.0, 202.0, 72.0, 48.0), VectorStageStyle.INK)
	# PKG-0197: cień kontaktowy pod maszyną, zgodny z lampą praktyczną sceny
	# (lewe górne źródło VectorStageEnvironment): cień kładzie się w prawo.
	draw_colored_polygon(PackedVector2Array([
		Vector2(58.0, 292.0), Vector2(352.0, 284.0),
		Vector2(360.0, 292.0), Vector2(66.0, 300.0),
	]), Color(VectorStageStyle.INK, 0.48))
	# PKG-0219 (V6): swiatlo robocze na beben — lampa na obudowie, stozek na
	# stanowisko; jedyne nazwane zrodlo robocze sceny (rodzina 5).
	draw_line(Vector2(247.0, 150.0), Vector2(247.0, 184.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_circle(WORK_LIGHT_POS, 4.0, VectorStageStyle.HUMAN_AMBER)
	draw_colored_polygon(PackedVector2Array([
		WORK_LIGHT_POS, Vector2(202.0, 268.0), Vector2(292.0, 268.0),
	]), Color(VectorStageStyle.HUMAN_AMBER, WORK_LIGHT_CONE_ALPHA))
	# PKG-0219 (V6): jawny cien kontaktowy pod bebnem i pulpitem w prawo,
	# CONTACT_SHADOW_ALPHA, konwencja 01/06/08 (jak cien maszyny powyzej).
	draw_colored_polygon(PackedVector2Array([
		Vector2(192.0, 272.0), Vector2(304.0, 268.0),
		Vector2(312.0, 276.0), Vector2(200.0, 280.0),
	]), Color(VectorStageStyle.INK, CONTACT_SHADOW_ALPHA))
	var drum_color := VectorStageStyle.CORRECTION_OXIDE if is_measurement_repeated else VectorStageStyle.HUMAN_AMBER
	draw_circle(Vector2(247.0, 226.0), 20.0, drum_color, false, 3.0)
	# PKG-0197: bęben pracuje własnym cyklem (~9 s/obrót), niezależnie od gracza.
	# Dwa ramiona krzyża obracają się z _machine_time; pomiar gracza zmienia
	# tylko kolor obudowy (powyżej), nigdy ruch maszyny.
	var drum_angle := _machine_time * TAU / 9.0
	for offset in [0.0, PI * 0.5]:
		var a: float = drum_angle + float(offset)
		var dir := Vector2(cos(a), sin(a))
		draw_line(Vector2(247.0, 226.0) - dir * 18.0, Vector2(247.0, 226.0) + dir * 18.0, VectorStageStyle.LIGHT_PLANE, 1.0)
	# Lampka statusu: powolny oddech maszyny (~2,6 s, ten sam rząd co oddech Leny,
	# ale własne źródło — nie synchronizowana z postacią).
	var lamp_on := sin(_machine_time / 2.6 * TAU) > -0.2
	draw_circle(Vector2(288.0, 198.0), 3.0, VectorStageStyle.HUMAN_AMBER if lamp_on else VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.4))
	for x in [96.0, 126.0]:
		draw_line(Vector2(x, 196.0), Vector2(x + 26.0, 258.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.28), 4.0)
	for x in [314.0, 350.0, 382.0]:
		draw_line(Vector2(x, 84.0), Vector2(x + 28.0, 146.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.28), 4.0)
	# The sample case and phone establish the two private consequences of the job.
	var sample_color := VectorStageStyle.ANCHOR_CYAN if is_sample_secured else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(344.0, 250.0, 62.0, 28.0), sample_color, false, 2.0)
	draw_line(Vector2(350.0, 260.0), Vector2(400.0, 260.0), sample_color, 1.0)
	var phone_color := VectorStageStyle.LIGHT_PLANE if is_marta_message_read else VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.40)
	draw_rect(Rect2(444.0, 236.0, 30.0, 48.0), VectorStageStyle.INK)
	draw_rect(Rect2(448.0, 242.0, 22.0, 28.0), phone_color, false, 1.5)
	# Airlock reads as a door, not a terminal; it opens only after the message.
	draw_rect(Rect2(530.0, 82.0, 70.0, 210.0), VectorStageStyle.DEEP_PLANE)
	draw_rect(Rect2(540.0, 112.0, 48.0, 58.0), VectorStageStyle.LIGHT_PLANE)
	var exit_color := VectorStageStyle.ANCHOR_CYAN if is_exit_unlocked else VectorStageStyle.HUMAN_AMBER
	draw_line(Vector2(566.0, 176.0), Vector2(566.0, 292.0), exit_color, 3.0)
