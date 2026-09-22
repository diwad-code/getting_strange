extends SceneTree

## PKG-0170 gate — P9 PHASE-06, Station 43 administrative closure, credits and epilogue.
## Technical proof only: entry from all three finale branches and unseeded fallback,
## three distinct consequence props, branch-adaptive dialogue answering what stayed in
## the city after us, exact license/credits manifests preserved, JSON-safe persistence
## round-trip, camera and return zone conformance. It does not claim comprehension,
## emotion, fun or PRODUCT GO.

const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")

const FACT_ENTRY := &"p7.conscious_silence_and_presence.final_chamber_witnessed"
const FACT_NOTICE := &"p7.conscious_silence_and_presence.epilogue_noticed"
const FACT_CREDITS := &"p7.conscious_silence_and_presence.epilogue_credits_read"
const FACT_COMPLETED := &"p7.conscious_silence_and_presence.epilogue_completed"
const FACT_COMMITMENT := &"p7.conscious_silence_and_presence.commitment"
const FACT_TRACE := &"p7.conscious_silence_and_presence.trace"

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

const EXPECTED_LICENSE_LINES: Array[String] = [
	"LICENCJE // MANIFEST RUNTIME",
	"AUDIO: ZERO-ASSET SYNTH",
	"ŚWIAT: PROCEDURAL PIXEL-STAGE",
	"LENA 4.1: 22 PNG 64x104",
	"PORTRETY CRT: 5 PNG",
	"GODOT 4.7.2 (MIT)"
]

const EXPECTED_CREDITS_LINES: Array[String] = [
	"CREDITS // PRODUCTION",
	"GETTING STRANGE",
	"LEAD PROGRAMMER & ART DIRECTOR",
	"KANON FABUŁY 0.3",
	"RENDER: PIXEL-STAGE 640x360",
	"AUDIO: PROCEDURAL WAVEFORM SYNTH",
	"PL / EN SHELL // SUBTITLES"
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0170 FAILURE: " + message)


func _run() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must exist")
	if state == null:
		_finish()
		return
	state.campaign_auto_transition_enabled = false
	
	await _test_scene_contract(state)
	await _test_unseeded_fallback_flow(state)
	await _test_branch_42a_flow(state)
	await _test_branch_42b_flow(state)
	await _test_branch_42c_flow(state)
	await _test_persistence_round_trip(state)
	await _test_return_zone(state)
	
	state.campaign_auto_transition_enabled = true
	state.reset_campaign(true)
	_finish()


func _test_scene_contract(state: Object) -> void:
	state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	_expect(packed != null, "station_43.tscn must load")
	if packed == null:
		return
	
	var station := packed.instantiate() as Station43
	_expect(station != null, "station_43.tscn must instantiate as Station43")
	if station == null:
		return
	
	root.add_child(station)
	await process_frame
	await physics_frame
	
	_expect(station.get_node_or_null("VectorStageEnvironment") != null, "VectorStageEnvironment must exist")
	_expect(station.get_node_or_null("AtmosphereRig") != null, "AtmosphereRig must exist")
	_expect(station.get_node_or_null("WorldPixelCompositor") != null, "WorldPixelCompositor must exist")
	_expect(station.get_node_or_null("NarrativeGuidanceService") != null, "NarrativeGuidanceService must exist")
	_expect(station.get_node_or_null("CRTDialogueBox") != null, "CRTDialogueBox must exist")
	_expect(station.get_node_or_null("Player") != null, "Player must exist")
	_expect(station.get_node_or_null("Camera") != null, "Camera must exist")
	_expect(station.get_node_or_null("AirlockZone") != null, "AirlockZone must exist")
	_expect(station.get_node_or_null("ReturnZone") != null, "ReturnZone must exist")
	
	var props := station.get_node_or_null("Props")
	_expect(props != null, "Props container must exist")
	if props != null:
		var notice := props.get_node_or_null("AdminNoticeBoard") as MemoryResonancePoint
		var credits := props.get_node_or_null("CreditsRoll") as MemoryResonancePoint
		var blackout := props.get_node_or_null("FinalBlackout") as MemoryResonancePoint
		_expect(notice != null, "AdminNoticeBoard prop must exist")
		_expect(credits != null, "CreditsRoll prop must exist")
		_expect(blackout != null, "FinalBlackout prop must exist")
		if notice:
			_expect(notice.prop_type == 200, "AdminNoticeBoard prop_type must be 200")
			_expect(notice.resonance_id == "prop_admin_notice_board", "AdminNoticeBoard id must be prop_admin_notice_board")
		if credits:
			_expect(credits.prop_type == 201, "CreditsRoll prop_type must be 201")
			_expect(credits.resonance_id == "prop_credits_roll", "CreditsRoll id must be prop_credits_roll")
		if blackout:
			_expect(blackout.prop_type == 202, "FinalBlackout prop_type must be 202")
			_expect(blackout.resonance_id == "prop_final_blackout", "FinalBlackout id must be prop_final_blackout")
	
	var license_manifest := station.get_node_or_null("CrispDiegeticText_LicenseManifest") as CrispDiegeticText
	var credits_manifest := station.get_node_or_null("CrispDiegeticText_CreditsManifest") as CrispDiegeticText
	_expect(license_manifest != null, "License manifest must exist")
	_expect(credits_manifest != null, "Credits manifest must exist")
	if license_manifest != null:
		for line in EXPECTED_LICENSE_LINES:
			_expect(license_manifest.text.contains(line), "License manifest must contain '%s'" % line)
	if credits_manifest != null:
		for line in EXPECTED_CREDITS_LINES:
			_expect(credits_manifest.text.contains(line), "Credits manifest must contain '%s'" % line)
	
	_expect(station.has_signal(&"level_completed"), "level_completed signal must exist")
	_expect(station.has_signal(&"previous_level_requested"), "previous_level_requested signal must exist")
	_expect(station.has_signal(&"notice_inspected"), "notice_inspected signal must exist")
	_expect(station.has_signal(&"credits_inspected"), "credits_inspected signal must exist")
	_expect(station.has_signal(&"blackout_inspected"), "blackout_inspected signal must exist")
	_expect(station.has_signal(&"epilogue_completed"), "epilogue_completed signal must exist")
	_expect(station.has_signal(&"exit_unlocked"), "exit_unlocked signal must exist")
	
	station.queue_free()
	await process_frame


func _test_unseeded_fallback_flow(state: Object) -> void:
	state.reset_campaign(true)
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	var station := packed.instantiate() as Station43
	root.add_child(station)
	await process_frame
	await physics_frame
	
	_expect(station.ending_family == "unseeded", "Default ending_family is unseeded")
	_expect(station.dialogue_lines.size() >= 5, "Unseeded dialogue has >= 5 lines")
	_expect(not station.is_notice_inspected, "Notice not inspected initially")
	_expect(not station.is_credits_inspected, "Credits not inspected initially")
	_expect(not station.is_blackout_inspected, "Blackout not inspected initially")
	_expect(station.is_exit_unlocked, "Exit must be open from ready")
	_expect(not station.is_level_completed, "Level not completed initially")
	
	_expect(station.inspect_notice(), "inspect_notice must return true")
	_expect(station.is_notice_inspected, "Notice is inspected")
	_expect(state.decisions.get(FACT_NOTICE) == true, "P7 epilogue_noticed recorded")
	_expect(state.decisions.get(FACT_P9_ADMIN_NOTICE) == true, "P9 admin_notice_inspected recorded")
	
	_expect(station.inspect_credits(), "inspect_credits must return true")
	_expect(station.is_credits_inspected, "Credits is inspected")
	_expect(state.decisions.get(FACT_CREDITS) == true, "P7 epilogue_credits_read recorded")
	_expect(state.decisions.get(FACT_P9_CREDITS) == true, "P9 credits_read recorded")
	
	_expect(station.inspect_blackout(), "inspect_blackout must return true")
	_expect(station.is_blackout_inspected, "Blackout is inspected")
	_expect(station.is_exit_unlocked, "Exit is unlocked")
	_expect(station.is_level_completed, "Level is completed")
	_expect(state.decisions.get(FACT_COMPLETED) == true, "P7 epilogue_completed recorded")
	_expect(state.decisions.get(CANONICAL_EPILOGUE_WITNESSED) == true, "Canonical epilogue_witness_completed recorded")
	_expect(state.decisions.get(FACT_TRACE) == "conscious_silence_and_presence_witnessed", "P7 trace recorded")
	_expect(state.decisions.get(FACT_P9_EXECUTED) == true, "P9 epilogue executed recorded")
	_expect(state.decisions.get(FACT_P9_FEEDBACK) == "epilogue_completed_cleanly", "P9 safe trial feedback recorded")
	
	station.queue_free()
	await process_frame


func _test_branch_42a_flow(state: Object) -> void:
	state.reset_campaign(true)
	state.record_decision(&"ending_family", METHOD_FORCE_HOME)
	state.record_decision(&"ending_stability", "named_gaps")
	state.record_decision(&"p9.method_commitment.marta_truth_state", "partial")
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "granted")
	state.record_decision(&"p9.finale.forced_return.executed", true)
	state.record_decision(&"p9.finale.forced_return.household_consequence", {
		"marta": "partial",
		"jakub": "granted",
		"local_lena": "sealed_between_addresses",
		"arrived_lena": "returned_home"
	})
	
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	var station := packed.instantiate() as Station43
	root.add_child(station)
	await process_frame
	await physics_frame
	
	_expect(station.ending_family == METHOD_FORCE_HOME, "Branch 42A ending_family recognized")
	_expect(station.dialogue_lines.size() >= 5, "Branch 42A dialogue has >= 5 lines")
	_expect(station.dialogue_lines[0]["text"].contains("Linia 4 zamknięta do odwołania"), "Branch 42A line 1 mentions Line 4 closure")
	_expect(station.dialogue_lines[1]["text"].contains("Marta odłożyła klucze na blat"), "Branch 42A line 2 mentions Marta's consequence")
	_expect(station.dialogue_lines[3]["text"].contains("Przybyła Lena"), "Branch 42A line 4 mentions arrived Lena")
	
	station.inspect_notice()
	station.inspect_credits()
	station.inspect_blackout()
	
	_expect(state.decisions.get(FACT_P9_ENDING_FAMILY) == METHOD_FORCE_HOME, "Epilogue records force_home ending family")
	_expect(state.decisions.get(FACT_P9_ENDING_STABILITY) == "named_gaps", "Epilogue records named_gaps stability")
	_expect(state.decisions.get(CANONICAL_EPILOGUE_WITNESSED) == true, "epilogue_witness_completed recorded")
	
	station.queue_free()
	await process_frame


func _test_branch_42b_flow(state: Object) -> void:
	state.reset_campaign(true)
	state.record_decision(&"ending_family", METHOD_CLOSE_EQUAL)
	state.record_decision(&"ending_stability", "partial_gaps")
	state.record_decision(&"p9.method_commitment.marta_truth_state", "withheld")
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "limited")
	state.record_decision(&"p9.finale.close_equal.executed", true)
	state.record_decision(&"p9.finale.close_equal.household_consequence", {
		"marta": "withheld",
		"jakub": "limited",
		"local_lena": "restored_to_marta",
		"arrived_lena": "unindexed_presence"
	})
	
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	var station := packed.instantiate() as Station43
	root.add_child(station)
	await process_frame
	await physics_frame
	
	_expect(station.ending_family == METHOD_CLOSE_EQUAL, "Branch 42B ending_family recognized")
	_expect(station.dialogue_lines.size() >= 5, "Branch 42B dialogue has >= 5 lines")
	_expect(station.dialogue_lines[0]["text"].contains("Odcinek torowiska ustabilizowany"), "Branch 42B line 1 mentions stabilized ground")
	_expect(station.dialogue_lines[1]["text"].contains("Miejscowa Lena wróciła"), "Branch 42B line 2 mentions local Lena's return")
	_expect(station.dialogue_lines[3]["text"].contains("Płaszczyzna została zamknięta"), "Branch 42B line 4 mentions Plane closure")
	
	station.inspect_notice()
	station.inspect_credits()
	station.inspect_blackout()
	
	_expect(state.decisions.get(FACT_P9_ENDING_FAMILY) == METHOD_CLOSE_EQUAL, "Epilogue records close_equal ending family")
	_expect(state.decisions.get(FACT_P9_ENDING_STABILITY) == "partial_gaps", "Epilogue records partial_gaps stability")
	_expect(state.decisions.get(CANONICAL_EPILOGUE_WITNESSED) == true, "epilogue_witness_completed recorded")
	
	station.queue_free()
	await process_frame


func _test_branch_42c_flow(state: Object) -> void:
	state.reset_campaign(true)
	state.record_decision(&"ending_family", METHOD_MUTUAL)
	state.record_decision(&"ending_stability", "withheld_or_refused_gaps")
	state.record_decision(&"p9.method_commitment.marta_truth_state", "full")
	state.record_decision(&"p9.consent_and_cost.jakub_consent_scope", "refused")
	state.record_decision(&"p9.finale.mutual_passage.executed", true)
	state.record_decision(&"p9.finale.mutual_passage.household_consequence", {
		"marta": "full",
		"jakub": "refused",
		"local_lena": "returned_to_marta_with_leak",
		"arrived_lena": "returned_home_with_leak"
	})
	
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	var station := packed.instantiate() as Station43
	root.add_child(station)
	await process_frame
	await physics_frame
	
	_expect(station.ending_family == METHOD_MUTUAL, "Branch 42C ending_family recognized")
	_expect(station.dialogue_lines.size() >= 5, "Branch 42C dialogue has >= 5 lines")
	_expect(station.dialogue_lines[0]["text"].contains("dwa równorzędne rozkłady"), "Branch 42C line 1 mentions twin schedules")
	_expect(station.dialogue_lines[1]["text"].contains("Marta rozpoznaje kubek"), "Branch 42C line 2 mentions mug and empty shelf")
	_expect(station.dialogue_lines[3]["text"].contains("Dwie Leny"), "Branch 42C line 4 mentions both Lenas")
	
	station.inspect_notice()
	station.inspect_credits()
	station.inspect_blackout()
	
	_expect(state.decisions.get(FACT_P9_ENDING_FAMILY) == METHOD_MUTUAL, "Epilogue records mutual_passage ending family")
	_expect(state.decisions.get(FACT_P9_ENDING_STABILITY) == "withheld_or_refused_gaps", "Epilogue records stability")
	_expect(state.decisions.get(CANONICAL_EPILOGUE_WITNESSED) == true, "epilogue_witness_completed recorded")
	
	station.queue_free()
	await process_frame


func _test_persistence_round_trip(state: Object) -> void:
	state.reset_campaign(true)
	state.record_decision(&"ending_family", METHOD_MUTUAL)
	state.record_decision(&"ending_stability", "named_gaps")
	
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	var station := packed.instantiate() as Station43
	root.add_child(station)
	await process_frame
	await physics_frame
	
	station.inspect_notice()
	station.inspect_credits()
	station.inspect_blackout()
	
	_expect(state.decisions.get(CANONICAL_EPILOGUE_WITNESSED) == true, "epilogue_witness_completed set before save")
	_expect(state.decisions.get(FACT_P9_EXECUTED) == true, "p9.epilogue.executed set before save")
	
	state.save_campaign()
	state.reload_campaign_from_disk()
	
	_expect(state.decisions.get(CANONICAL_EPILOGUE_WITNESSED) == true, "epilogue_witness_completed survived save/load")
	_expect(state.decisions.get(FACT_P9_EXECUTED) == true, "p9.epilogue.executed survived save/load")
	_expect(state.decisions.get(FACT_P9_ENDING_FAMILY) == METHOD_MUTUAL, "ending_family survived save/load")
	_expect(state.decisions.get(FACT_P9_ADMIN_NOTICE) == true, "admin_notice_inspected survived save/load")
	_expect(state.decisions.get(FACT_P9_CREDITS) == true, "credits_read survived save/load")
	_expect(state.decisions.get(FACT_TRACE) == "conscious_silence_and_presence_witnessed", "P7 trace survived save/load")
	
	station.queue_free()
	await process_frame


func _test_return_zone(state: Object) -> void:
	var packed := load("res://scenes/levels/station_43.tscn") as PackedScene
	var station := packed.instantiate() as Station43
	root.add_child(station)
	await process_frame
	await physics_frame
	
	var signal_fired := [false]
	station.previous_level_requested.connect(func() -> void: signal_fired[0] = true)
	
	var player := station.get_node_or_null("Player") as Node2D
	_expect(player != null, "Player exists")
	if player != null:
		station._on_return_zone_entered(player)
		_expect(signal_fired[0], "Return zone emits previous_level_requested")
	
	station.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0170 PASS: P9 PHASE-06 Station 43 epilogue and administrative closure contracts certified.")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)
