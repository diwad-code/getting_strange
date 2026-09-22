class_name Station09
extends Node2D

## Station 09 — P9, dowod materialny: cudzy salon (S-13, PKG-0230).
## Dwa komplety rzeczy i fotografia; Lena oglada dwa zycia, porownuje
## fotografie z wlasna pamiecia i szanuje granice sypialni
## (two_lives → relation_photo → private_boundary).
## Warstwa dawcy P7 (klatka schodowa: floor_record, donica StairwellPlanter,
## sasiadka) jest nieaktywna w trasie, ale callable dla testow.

## PRZESZKODA — dlaczego to tu jest: Salon trzyma rzeczy dwoch osob w jednym rzedzie, a sypialnia ma granice bez zamka.
## PRZESZKODA — czego wymaga od Leny: obejrzenia obu kompletow, porownania fotografii i uszanowania granicy bez wchodzenia.
## PRZESZKODA — koszt porażki: wyjscie bez odczytu zostawia luke w GapLedger, nie blokade.

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

const PLANTER_CLEAR_X := 300.0
## PKG-0219 (V4): kontrakt sufitu mieszkalnej (rodzina 3,
## LOCATION_FAMILY_BIBLE §5): przeswit nad glowa Leny 20-45 px. Lena stoi na
## y=296 przy wzroscie 87 px (WORLD_SCALE §3, FRAME_LAYOUT_AUDIT §1), wiec
## glowa ~y=209, a spod masy nad glowa ma byc w y 164..189. Drzwi 109 px
## i collidery nietkniete (kolider sufitu w .tscn zostaje 0..30).
const LENA_HEAD_Y := 209.0
const RESIDENTIAL_CEILING_BOTTOM := 172.0
const FACT_S03_TRACE := &"p7.address_and_record.trace"
const FACT_FLOOR := &"p7.foreign_daily_life.floor_record_observed"
const FACT_NEIGHBOUR := &"p7.foreign_daily_life.neighbour_account"
const FACT_FEEDBACK := &"p7.foreign_daily_life.safe_trial_feedback"

const P9_TWO_LIVES := &"p9.mystery.home.two_lives_observed"
const P9_RELATION_PHOTO := &"p9.mystery.home.relation_photo_observed"
const P9_BOUNDARY := &"p9.mystery.home.boundary_respected"
const P9_TRACE := &"p9.mystery.home.trace"
signal clue_inspected(id: String, prop_type: int)
signal neighbour_answered()
signal passage_cleared()
signal level_completed()
signal previous_level_requested()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = StationCameraRig.resolve(self)
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var stairwell_planter: MovableAnchorableProp = $Geometry/StairwellPlanter
@onready var airlock_zone: Area2D = $AirlockZone
@onready var guidance_service: NarrativeGuidanceService = $NarrativeGuidanceService

var is_floor_record_observed := false
var is_neighbour_answered := false
var is_passage_clear := false
var is_exit_unlocked := false
var is_level_completed := false


func _ready() -> void:
	var presentation := preload("res://scripts/levels/creative_scene_presentation.gd").new()
	presentation.name = "CreativeScenePresentation"
	add_child(presentation)
	camera = StationCameraRig.bind(self, player)
	_setup_guidance()
	_connect_props()
	if airlock_zone != null and not airlock_zone.body_entered.is_connected(_on_airlock_body_entered):
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	queue_redraw()


func _setup_guidance() -> void:
	if guidance_service == null:
		return
	_register_beat(&"s09_floor_source", GuidanceBeat.Tier.L0_COMPOSITION, &"observation", &"factual", "", "", &"", "")
	_register_beat(&"s09_floor_contact", GuidanceBeat.Tier.L1_REACTION, &"observation", &"factual", "Dwie filiżanki. Przyjrzę się zdjęciu.", "Two cups. I will look at the photograph.", &"", "")
	_register_beat(&"s09_renumbering_hypothesis", GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT, &"interpretation", &"fallible", "Może tylko przypominam osobę ze zdjęcia. Przyjrzę się jej dłoni.", "Perhaps I only resemble her. I will look at her hand.", &"renumbering", "observe_relation_photo")
	_register_beat(&"s09_neighbour_question", GuidanceBeat.Tier.L3_DIRECTIONAL_THOUGHT, &"intention", &"procedural", "Obejrzę rzeczy i fotografię. Do sypialni nie wejdę.", "I will inspect the belongings and photo. I will leave the bedroom alone.", &"", "")
	_register_beat(&"s09_system_hint", GuidanceBeat.Tier.L4_RESCUE_HINT, &"system_hint", &"system", "WSKAZÓWKA: Dwa nakrycia, fotografia, zamknięta sypialnia.", "HINT: Two settings, photograph, closed bedroom.", &"", "")


func _register_beat(beat_id: StringName, tier: GuidanceBeat.Tier, thought_kind: StringName, truth_scope: StringName, text_pl: String, text_en: String, hypothesis_id: StringName, predicted_check: String) -> void:
	var beat := GuidanceBeat.new()
	beat.beat_id = beat_id
	beat.scene_id = &"station_09"
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


func _physics_process(_delta: float) -> void:
	if is_instance_valid(player) and is_instance_valid(stairwell_planter) and not stairwell_planter.is_anchored:
		var diff := stairwell_planter.global_position - player.global_position
		if absf(diff.x) < 42.0 and absf(diff.y) < stairwell_planter.crate_size.y * 0.5 + 40.0:
			var push_direction := signf(player.velocity.x)
			if push_direction > 0.0 and signf(diff.x) == push_direction:
				stairwell_planter.receive_push(push_direction)
	if not is_passage_clear and is_instance_valid(stairwell_planter) and stairwell_planter.position.x >= PLANTER_CLEAR_X:
		is_passage_clear = true
		passage_cleared.emit()
		_report_progress(&"s09_passage_cleared")
		queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"two_lives":
			observe_two_lives()
		"relation_photo":
			observe_relation_photo()
		"private_boundary":
			respect_private_boundary()
	prop.is_activated = _is_resolved(id)
	clue_inspected.emit(id, prop_type)


func observe_floor_record() -> bool:
	if is_floor_record_observed or not _has(FACT_S03_TRACE):
		_record_feedback(&"identifier_trace_required")
		return false
	is_floor_record_observed = true
	_record(FACT_FLOOR, true)
	_report_progress(&"s09_floor_record_observed")
	queue_redraw()
	return true


func ask_neighbour_without_leading() -> bool:
	if is_neighbour_answered:
		return false
	if not is_floor_record_observed:
		_record_feedback(&"floor_record_required")
		return false
	if not is_passage_clear:
		_record_feedback(&"passage_required")
		return false
	is_neighbour_answered = true
	_record(FACT_NEIGHBOUR, "twelve_lower_fourteen_home")
	neighbour_answered.emit()
	if guidance_service:
		guidance_service.close_hypothesis(&"renumbering")
	_report_progress(&"s09_neighbour_answered")
	_unlock_exit()
	queue_redraw()
	return true


func push_planter(direction: float) -> void:
	if stairwell_planter != null:
		stairwell_planter.receive_push(direction)


func apply_planter_setback() -> void:
	if is_passage_clear:
		return
	_record_feedback(&"planter_returned_to_step")
	if stairwell_planter != null:
		stairwell_planter.reset_to_spawn()
	if player != null:
		player.reset_to(Vector2(70.0, 296.0))
	queue_redraw()


func _record_feedback(value: StringName) -> void:
	_record(FACT_FEEDBACK, String(value))
	GapLedger.annotate_feedback(self, value) # PKG-0215 (D-228): blocked verb speaks its gap, if any.
	if guidance_service:
		guidance_service.report_failed_attempt(&"s09_" + value)


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
	is_level_completed = true
	level_completed.emit()


func _has(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and not String(state.decisions.get(key, "")).is_empty()


func _record(key: StringName, value: Variant) -> void:
	var state := get_node_or_null("/root/GameStateManager")
	if state != null:
		state.record_decision(key, value)


func _is_resolved(id: String) -> bool:
	match id:
		"two_lives": return _decision_bool(P9_TWO_LIVES)
		"relation_photo": return _decision_bool(P9_RELATION_PHOTO)
		"private_boundary": return _decision_bool(P9_BOUNDARY)
	return false


func _report_progress(progress_id: StringName) -> void:
	if guidance_service:
		guidance_service.report_progress(progress_id)


func _draw() -> void:
	# Preserve the campaign state-pass contract: route derives from Geometry
	# before the opaque, local residential composition is painted over it.
	# PKG-0218 (V1): stage apron first, so the dialogue framing offset (36)
	# spends painted floor (STAGE_APRON 40), never engine clear colour (D-136).
	VectorStageStyle.draw_stage_apron(self, Vector2(640.0, 360.0))
	VectorStageStyle.draw_play_plane(self, geometry)
	# PKG-0161: a closed, occupied room. The silhouette has one low ceiling and
	# only two depths: the back wall and a near furniture/floor plane.
	# PKG-0218 (V2): palette rewritten to VectorStageStyle only (D-231:
	# MAX_PALETTE_COLORS 8, canon VISUAL_DESIGN §4 8-16). Zero raw hex here;
	# domestic warmth comes from HUMAN_AMBER accents + practical pools,
	# never from ad-hoc mauves/browns. Bases used: INK / DEEP / MID / LIGHT
	# + AMBER + CYAN (6) with shade() derivations.
	var ink := VectorStageStyle.INK
	var ceiling := VectorStageStyle.DEEP_PLANE
	var wallpaper := VectorStageStyle.DEEP_PLANE
	var wallpaper_shadow := VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.20)
	var wood_dark := VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30)
	var wood := VectorStageStyle.HUMAN_AMBER
	var fabric_dark := VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.35)
	var fabric := VectorStageStyle.MID_PLANE
	var ceramic := VectorStageStyle.HUMAN_AMBER

	# Low ceiling and dropped soffit: no sky, gallery wall or public-depth axis.
	draw_rect(Rect2(0.0, 0.0, 640.0, 78.0), ink)
	draw_rect(Rect2(0.0, 42.0, 640.0, 36.0), ceiling)
	draw_rect(Rect2(0.0, 78.0, 640.0, 12.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_line(Vector2(0.0, 90.0), Vector2(640.0, 90.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# Soft wallpaper and a darker domestic rail; sparse seams avoid an office grid.
	draw_rect(Rect2(0.0, 90.0, 640.0, 206.0), wallpaper)
	draw_rect(Rect2(0.0, 220.0, 640.0, 76.0), wallpaper_shadow)
	draw_line(Vector2(0.0, 220.0), Vector2(640.0, 220.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.40), 2.0)
	# PKG-0218 (V5): construction seams are 2 px logical (0.5 px final at
	# 320x180 nearest would alias; PIXEL_ARCH §5 + VISUAL_DESIGN §3).
	draw_line(Vector2(42.0, 96.0), Vector2(42.0, 214.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.30), 2.0)
	draw_line(Vector2(454.0, 96.0), Vector2(454.0, 214.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.30), 2.0)
	# PKG-0219 (V4): opuszczona podbitka nad strefa wejscia i sofa (x 0..300).
	# Spod y=172 (RESIDENTIAL_CEILING_BOTTOM) domyka przeswit nad glowa Leny
	# do 209 - 172 = 37 px (kontrakt 20-45). Dwa plany: sufit + podbitka
	# z listwa; drzwi 109 px nietkniete; zero colliderow (farba, nie fizyka;
	# OVERHEAD_FLOOR=86 dotyczy podwieszen w halach, tu wygrywa kontrakt
	# niskiego sufitu mieszkalnej jak w precedensie 10, a etykieta
	# MIESZKANIE 14 schodzi pod podbitke na sciane).
	draw_rect(Rect2(0.0, 90.0, 300.0, 76.0), ceiling)
	draw_rect(Rect2(0.0, 166.0, 300.0, 6.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_rect(Rect2(296.0, 90.0, 4.0, 82.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.45))
	draw_line(Vector2(0.0, 172.0), Vector2(300.0, 172.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	# Near plane: worn wood with a single rug, rather than a public counter.
	draw_rect(Rect2(0.0, 296.0, 640.0, 64.0), wood_dark)
	for plank_y in [310.0, 330.0, 348.0]:
		draw_line(Vector2(0.0, plank_y), Vector2(640.0, plank_y), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.30), 2.0)
	draw_rect(Rect2(54.0, 282.0, 248.0, 30.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.35))
	draw_rect(Rect2(58.0, 286.0, 240.0, 22.0), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.55), false, 2.0)

	# Left: broad fabric sofa, two unlike cushions and a folded throw.
	draw_rect(Rect2(52.0, 220.0, 178.0, 64.0), ink)
	draw_rect(Rect2(60.0, 226.0, 162.0, 52.0), fabric_dark)
	draw_rect(Rect2(68.0, 204.0, 146.0, 34.0), fabric)
	draw_rect(Rect2(76.0, 210.0, 54.0, 21.0), VectorStageStyle.HUMAN_AMBER)
	draw_rect(Rect2(139.0, 210.0, 62.0, 21.0), VectorStageStyle.ANCHOR_CYAN)
	draw_rect(Rect2(64.0, 250.0, 154.0, 10.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.20))
	draw_line(Vector2(60.0, 278.0), Vector2(82.0, 292.0), ink, 3.0)
	draw_line(Vector2(202.0, 278.0), Vector2(218.0, 292.0), ink, 3.0)
	# Table: the primary two-person daily-life shape, with two settings and ceramic.
	draw_rect(Rect2(126.0, 258.0, 148.0, 13.0), ink)
	draw_rect(Rect2(132.0, 254.0, 136.0, 13.0), wood)
	draw_line(Vector2(142.0, 267.0), Vector2(136.0, 290.0), wood_dark, 4.0)
	draw_line(Vector2(258.0, 267.0), Vector2(264.0, 290.0), wood_dark, 4.0)
	draw_circle(Vector2(160.0, 257.0), 7.0, ceramic)
	draw_circle(Vector2(238.0, 257.0), 7.0, VectorStageStyle.ANCHOR_CYAN)
	draw_circle(Vector2(160.0, 257.0), 3.0, VectorStageStyle.INK)
	draw_circle(Vector2(238.0, 257.0), 3.0, VectorStageStyle.INK)
	# A 109 px interior door is the main wall division; it is closed and private.
	draw_rect(Rect2(294.0, 187.0, 78.0, 109.0), ink)
	draw_rect(Rect2(300.0, 193.0, 66.0, 103.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30))
	draw_rect(Rect2(306.0, 201.0, 54.0, 70.0), VectorStageStyle.MID_PLANE, false, 2.0)
	draw_circle(Vector2(352.0, 246.0), 3.0, ceramic)
	# Small sideboard: a framed two-person photograph, keys and a ceramic pot.
	draw_rect(Rect2(384.0, 242.0, 62.0, 42.0), ink)
	draw_rect(Rect2(390.0, 248.0, 50.0, 30.0), wood)
	draw_rect(Rect2(396.0, 230.0, 22.0, 17.0), VectorStageStyle.INK)
	draw_rect(Rect2(399.0, 233.0, 16.0, 11.0), VectorStageStyle.LIGHT_PLANE)
	draw_circle(Vector2(404.0, 238.0), 2.0, VectorStageStyle.INK)
	draw_circle(Vector2(410.0, 238.0), 2.0, VectorStageStyle.INK)
	draw_rect(Rect2(425.0, 235.0, 10.0, 12.0), ceramic)
	draw_circle(Vector2(430.0, 231.0), 6.0, VectorStageStyle.ANCHOR_CYAN)
	# Right: curtained window and a narrow bookcase, never a glazed public facade.
	draw_rect(Rect2(476.0, 112.0, 112.0, 100.0), ink)
	draw_rect(Rect2(484.0, 122.0, 96.0, 78.0), VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.20))
	draw_line(Vector2(532.0, 122.0), Vector2(532.0, 200.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(484.0, 161.0), Vector2(580.0, 161.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_rect(Rect2(470.0, 106.0, 20.0, 112.0), VectorStageStyle.shade(VectorStageStyle.HUMAN_AMBER, 0.35))
	draw_rect(Rect2(574.0, 106.0, 20.0, 112.0), VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.35))
	draw_rect(Rect2(468.0, 206.0, 124.0, 8.0), wood_dark)
	draw_rect(Rect2(500.0, 228.0, 74.0, 54.0), VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.35))
	draw_line(Vector2(506.0, 246.0), Vector2(568.0, 246.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(506.0, 263.0), Vector2(568.0, 263.0), VectorStageStyle.LIGHT_PLANE, 2.0)
	for book_x in [510.0, 520.0, 542.0, 552.0]:
		draw_rect(Rect2(book_x, 232.0, 6.0, 12.0), VectorStageStyle.HUMAN_AMBER)
		draw_rect(Rect2(book_x, 249.0, 6.0, 12.0), VectorStageStyle.ANCHOR_CYAN)
	# Two warm practical pools: a reading lamp and window spill, not overhead fluorescents.
	# PKG-0219 (V4): lampa do czytania wisi pod podbitka (spod y=172) — jawne
	# zrodlo-obiekt dla kaluzy i cienia w prawo 0.48 (konwencja 01/06/08).
	draw_colored_polygon(PackedVector2Array([Vector2(230.0, 184.0), Vector2(188.0, 250.0), Vector2(272.0, 250.0)]), Color(VectorStageStyle.HUMAN_AMBER, 0.14))
	draw_rect(Rect2(226.0, 172.0, 8.0, 8.0), wood_dark)
	draw_circle(Vector2(230.0, 184.0), 10.0, VectorStageStyle.HUMAN_AMBER)
	draw_colored_polygon(PackedVector2Array([Vector2(574.0, 170.0), Vector2(462.0, 276.0), Vector2(604.0, 276.0)]), Color(VectorStageStyle.LIGHT_PLANE, 0.10))
	# PKG-0198 (ZERO wycinek 2): cień kontaktowy sofy i stołu w prawo, 0.48,
	# zgodnie z lampą do czytania (230,156) i konwencją 01/06/08.
	draw_colored_polygon(PackedVector2Array([
		Vector2(48.0, 290.0), Vector2(300.0, 286.0),
		Vector2(308.0, 294.0), Vector2(56.0, 298.0),
	]), Color(VectorStageStyle.INK, 0.48))


func observe_two_lives() -> bool:
	if _decision_bool(P9_TWO_LIVES) or not _has(&"p7.foreign_daily_life.trace"):
		return false
	_record(P9_TWO_LIVES, true)
	queue_redraw()
	return true

func observe_relation_photo() -> bool:
	if _decision_bool(P9_RELATION_PHOTO) or not _decision_bool(P9_TWO_LIVES):
		return false
	_record(P9_RELATION_PHOTO, true)
	queue_redraw()
	return true

func respect_private_boundary() -> bool:
	if _decision_bool(P9_BOUNDARY) or not _decision_bool(P9_RELATION_PHOTO):
		return false
	_record(P9_BOUNDARY, true)
	_record(P9_TRACE, "two_lives_without_claim")
	_unlock_exit()
	queue_redraw()
	return true

func _decision_bool(key: StringName) -> bool:
	var state := get_node_or_null("/root/GameStateManager")
	return state != null and state.decisions.get(key, false) == true
