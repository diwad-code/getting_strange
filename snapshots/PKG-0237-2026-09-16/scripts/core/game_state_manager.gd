extends Node

## Versioned local campaign state, pause UI and station transition coordinator.
## Save data is deliberately small, JSON-only and recoverable from malformed files.

signal checkpoint_changed(station_id: StringName, spawn_position: Vector2)
signal clue_collected(clue_id: StringName)
signal decision_recorded(decision_id: StringName, value: Variant)
signal campaign_saved(save_path: String)
signal campaign_reloaded()
signal campaign_reset()
signal pause_changed(is_paused: bool)
signal transition_started(target_scene: String)
signal transition_finished(target_scene: String)
signal campaign_completed(finale_id: StringName)
signal settings_changed(master_volume: float, text_speed_cps: float, fullscreen: bool)
signal accessibility_changed(text_scale: float, locale: String)
signal input_map_changed()
signal remap_changed(action: StringName, success: bool, reason: String, conflict_action: StringName)

const SAVE_SCHEMA_VERSION := 1
const SAVE_PATH := "user://getting_strange_campaign_v1.json"
const SETTINGS_PATH := "user://getting_strange_settings_v1.json"
const RUNTIME_TRACE_PATH_ENV := "GS_RUNTIME_TRACE_PATH"
const SETTINGS_SCHEMA_VERSION := 1
const P7_MUTUAL_TEST_MIGRATION_REVISION := 1
const P7_MUTUAL_TEST_MIGRATION_KEY := &"p7.mutual_test.migration_revision"
const P7_MUTUAL_TEST_ENTRY_STATION := &"station_22"
const P7_MUTUAL_TEST_ENTRY_POSITION := Vector2(60.0, 296.0)
const P7_MUTUAL_TEST_STATIONS: Array[StringName] = [
	&"station_22", &"station_23", &"station_24", &"station_25",
]
## PKG-0191: `marta_boundary_accepted` was removed from this legacy-erasure
## list. It is now a permanent CAMPAIGN_MAP canonical fact with a single
## audited writer (`station_10.gd`'s `accept_marta_boundary()`), not P7-only
## dialogue contamination, so a reload must no longer strip it.
## PKG-0194 (D-211): `mechanic_cost_observed` graduates the same way. It is a
## permanent P9 fact with a single audited writer (`station_16.gd`'s
## `_commit_cost()`) and a Station 17 donor requirement; the P9 route never
## stamps `p7.mutual_test.migration_revision`, so keeping it here stripped the
## live cost on every reload. Detected by the CR-B save/reload gate.
const P7_MUTUAL_TEST_LEGACY_DECISION_KEYS: Array[StringName] = [
	&"anchor_yield_named",
	&"s24_disposition",
	&"s25_jakub_recognized",
	&"station_22_dock_locked",
	&"station_23_breaker_tripped",
	&"ucp_offer_rejected",
]

## P7 early waves migrate independently. Their static sequence data stays in
## Resources; this table only owns legacy-save recovery and safe checkpoint entry.
const P7_EARLY_SEQUENCE_MIGRATIONS := [
	{
		"sequence_id": &"sample_and_promise",
		"revision": 1,
		"entry_station": &"station_01",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_01", &"station_02", &"station_03"],
		"legacy_keys": [&"station_01_measurement_completed", &"station_01_sensor_checked"],
	},
	{
		"sequence_id": &"return_under_control",
		"revision": 1,
		"entry_station": &"station_04",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_04", &"station_05"],
		"legacy_keys": [&"station_06_bus_exit_corrected"],
	},
	{
		"sequence_id": &"address_and_record",
		"revision": 1,
		"entry_station": &"station_06",
		"entry_position": Vector2(80.0, 296.0),
		"stations": [&"station_06", &"station_07", &"station_08"],
		"legacy_keys": [&"station_07_stairwell_corrected", &"station_08_entry_retried"],
	},
	{
		"sequence_id": &"foreign_daily_life",
		"revision": 1,
		"entry_station": &"station_09",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_09", &"station_10", &"station_11"],
		# PKG-0192: checked against source — no current station_09/10/11 writer
		# uses these three legacy key names, so shortening would not remove any
		# dead reference; kept unchanged to still erase them from genuinely old
		# saves. Station 10/11's own per-fact keys moved to
		# `p9.threshold_obstacle.foreign_daily_life.*` (D-205 §4) and are no
		# longer erased by the blanket `p7.foreign_daily_life.` prefix sweep
		# below — this is intended: they are permanent P9 bookkeeping now, not
		# stale P7 markers.
		"legacy_keys": [&"station_09_planter_reset", &"station_10_threshold_reset", &"station_11_sideboard_reset"],
	},
	{
		"sequence_id": &"marta_threshold",
		"revision": 1,
		"entry_station": &"station_12",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_12", &"station_13", &"station_14"],
		# PKG-0191: `marta_relationship_disclosed` removed below. It is now a
		# permanent CAMPAIGN_MAP canonical fact with a single audited writer
		# (`station_08.gd`'s `speak_with_neighbour()`), not P7-only dialogue
		# contamination, so a reload must no longer strip it.
		# PKG-0192: checked against source — no current station_12/13/14 writer
		# uses these three legacy key names; kept unchanged, same reasoning as
		# `foreign_daily_life` above. Station 12/13's own per-fact keys moved to
		# `p9.threshold_obstacle.marta_threshold.*` (D-205 §4).
		"legacy_keys": [&"station_12_playback_muffled", &"station_13_papers_scattered", &"station_14_mug_broken"],
	},
	{
		"sequence_id": &"work_history_and_record",
		"revision": 1,
		"entry_station": &"station_15",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_15", &"station_16", &"station_17"],
		# PKG-0191: `marta_memories_conflict`, `local_lena_ucp_profile_found` and
		# `parallel_test_trace_found` removed below. They are now permanent
		# CAMPAIGN_MAP canonical facts with single audited writers in
		# `station_10.gd`/`station_11.gd`.
		"legacy_keys": [
			&"station_15_table_rushed", &"station_16_scanner_blocked", &"station_17_alarm_delayed",
		],
	},
	{
		"sequence_id": &"three_place_proofs",
		"revision": 1,
		"entry_station": &"station_18",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_18", &"station_19", &"station_20", &"station_21"],
		# PKG-0191: `jakub_public_history_verified`, `jakub_voice_heard`,
		# `jakub_met_as_person`, `recognition_evidence_public`,
		# `recognition_evidence_relational`, `recognition_evidence_carried`,
		# `world_recognized` and `local_lena_search_committed` removed below. They
		# are now permanent CAMPAIGN_MAP canonical facts with single audited
		# writers in `station_11.gd`/`station_12.gd`/`station_13.gd`.
		# `local_lena_search_started` has no PKG-0191 writer and stays erased.
		"legacy_keys": [
			&"station_18_registry_timeout", &"station_19_call_interrupted",
			&"station_20_boundary_violated", &"station_21_incomplete_synthesis",
			&"local_lena_search_started",
		],
	},
	{
		"sequence_id": &"interrupted_trial_and_small_cost",
		"revision": 1,
		"entry_station": &"station_26",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_26", &"station_27", &"station_28"],
		"legacy_keys": [
			&"station_26_isolation_partition_corrected", &"s26_motivation_anchored",
			&"s27_pulses_sent", &"s28_carriage_travel_completed",
		],
	},
	{
		"sequence_id": &"jakub_boundary_and_forecasts",
		"revision": 1,
		"entry_station": &"station_29",
		"entry_position": Vector2(70.0, 296.0),
		"stations": [&"station_29", &"station_30"],
		"legacy_keys": [
			&"s29_power_balanced", &"station_30_witness_relay_corrected",
			&"s30_three_models_resolved",
		],
	},
	{
		"sequence_id": &"archive_countermodel",
		"revision": 1,
		"entry_station": &"station_31",
		"entry_position": Vector2(50.0, 240.0),
		"stations": [&"station_31", &"station_32", &"station_33"],
		# PKG-0194 (D-211): `local_lena_intent_found` graduates out of erasure.
		# Permanent P9 canonical fact with a single audited writer
		# (`station_15.gd`'s `read_abort_note()`); the P9 route never stamps
		# `p7.archive_countermodel.migration_revision`, so reload stripped it.
		"legacy_keys": [
			&"s31_adaptation_refused", &"s31_wierzbicka_adaptation_rejected",
			&"s32_glass_memory_witnessed", &"s32_memory_trace_anchored",
			&"s33_abort_condition_found", &"s33_local_lena_intent_found",
			&"station_32_observed_glass_corrected", &"station_33_dual_witness_corrected",
		],
	},
	{
		"sequence_id": &"pair_cost_and_echo",
		"revision": 1,
		"entry_station": &"station_34",
		"entry_position": Vector2(50.0, 240.0),
		"stations": [&"station_34", &"station_35", &"station_36"],
		# PKG-0194 (D-211): `home_echo_verified` and `ucp_cost_ledger_found`
		# graduate out of erasure. Permanent P9 canonical facts with single
		# audited writers (`station_16.gd`'s `confirm_home_echo()`,
		# `station_17.gd`'s `read_cost_ledger()`); the P9 route never stamps
		# `p7.pair_cost_and_echo.migration_revision`, so reload stripped them
		# and broke the Station 17 donor gate. Detected by CR-B save/reload.
		"legacy_keys": [
			&"s34_pair_registry_unlocked", &"s35_home_echo_processed", &"s35_home_echo_verified",
			&"s36_line4_ledger_revealed",
		],
	},
	{
		"sequence_id": &"consent_and_rescue_boundary",
		"revision": 1,
		"entry_station": &"station_37",
		"entry_position": Vector2(50.0, 240.0),
		"stations": [&"station_37", &"station_38"],
		"legacy_keys": [
			&"s37_living_signal_bridged", &"s38_marta_truth_state",
			&"station_38_jakub_rescue_corrected",
		],
	},
	{
		"sequence_id": &"branch_clarity_and_irreversible_choice",
		"revision": 1,
		"entry_station": &"station_39",
		"entry_position": Vector2(65.0, 248.0),
		"stations": [&"station_39", &"station_40", &"station_41"],
		"legacy_keys": [
			&"s39_method_reviewed", &"s40_negotiations_completed",
			&"s41_operation_committed",
		],
	},
	{
		"sequence_id": &"conscious_silence_and_presence",
		"revision": 1,
		"entry_station": &"station_42a",
		"entry_position": Vector2(65.0, 248.0),
		"stations": [&"station_42a", &"station_42b", &"station_42c", &"station_43"],
		"legacy_keys": [
			&"s42a_return_completed", &"s42b_closure_completed",
			&"s42c_mutual_completed", &"s43_epilogue_completed",
		],
	},
]
## PKG-0176 (D-195). `Nowa gra` prowadzi przez warstwe A zimnego otwarcia, nie
## wprost do Station 01. Zimne otwarcie NIE jest adresem kampanii: nie ma go w
## `CAMPAIGN_ROUTE`, nie liczy sie do budzetu 20 adresow i nie da sie go wybrac
## z selektora stacji (`COLD_OPEN_SPEC.md` §7).
const COLD_OPEN_SCENE := "res://scenes/shell/cold_open.tscn"
const STATION_SCENE_PREFIX := "res://scenes/levels/station_"
const STATION_SCENE_SUFFIX := ".tscn"
const CAMPAIGN_TRANSITION_LIMIT := 18
const LEGACY_CAMPAIGN_TRANSITION_LIMIT := 41
const CAMPAIGN_ROUTE: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18",
]
const CAMPAIGN_LEGACY_STATIONS: Array[StringName] = [
	&"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41",
]
const CAMPAIGN_FINALES: Array[StringName] = [&"station_42a", &"station_42b", &"station_42c"]
const CAMPAIGN_EPILOGUE := &"station_43"
const CAMPAIGN_SELECTOR_STATIONS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_42a", &"station_43",
]
const OPERATION_TO_FINALE := {"A": &"station_42a", "B": &"station_42b", "C": &"station_42c"}
const DEFAULT_MASTER_VOLUME := 0.85
const DEFAULT_TEXT_SPEED_CPS := 42.0
const DEFAULT_TEXT_SCALE := 1.0
## PKG-0141 (D-151). Kanon wizualny 3.0 jest kanonem ruchomym, wiec tryb
## ograniczonego ruchu jest domyslnie wylaczony i wlacza go wylacznie gracz.
const DEFAULT_REDUCED_MOTION := false
const MIN_TEXT_SCALE := 0.85
const MAX_TEXT_SCALE := 1.15
## Remap remains deliberately small and deterministic. Analog movement keeps
## its authored keyboard and pad bindings; these five discrete actions are
## safe to capture from a physical keyboard or controller button.
const REMAPPABLE_ACTIONS: Array[StringName] = [
	&"jump", &"interact", &"pause", &"restart", &"trigger_correction",
]

var reached_stations: Dictionary = {}
var collected_clues: Dictionary = {}
var decisions: Dictionary = {}
## PKG-0175 / D-192: consequential readings skipped on departure.
var open_gaps: Dictionary = {}
var last_checkpoint_station: StringName = &""
var last_checkpoint_position := Vector2.ZERO
var test_mode_enabled := false
## Test harnesses may disable scene changes while retaining the real unlock chain.
var campaign_auto_transition_enabled := true
var master_volume_linear: float = DEFAULT_MASTER_VOLUME
var text_speed_cps: float = DEFAULT_TEXT_SPEED_CPS
var fullscreen_enabled := false
var text_scale: float = DEFAULT_TEXT_SCALE
## PKG-0141 (D-151). Jeden przelacznik dostepnosci tlumiacy ruch peryferyjny.
## Prawda runtime zyje w `MotionAccessibility`; tu zyje jej trwalosc na dysku.
var reduced_motion := DEFAULT_REDUCED_MOTION
## PKG-0176 (D-195). Warstwa A zimnego otwarcia jest pomijalna dopiero po
## pierwszym ukonczeniu. Flaga zyje w pliku ustawien, a nie w zapisie kampanii,
## bo `Nowa gra` kasuje zapis kampanii — a raz obejrzana sekwencja pozostaje
## obejrzana takze w kolejnym przebiegu. Starszy plik ustawien nie ma tego
## klucza; brak klucza to nie blad, tylko gracz sprzed tej opcji.
var cold_open_seen := false
## PKG-0190. Fakt o obejrzanych krótkich sekwencjach cinematic vignette,
## klucz -> `true`. Tak jak `cold_open_seen`, żyje w pliku ustawień (nie w
## zapisie kampanii), bo jest faktem o przebytej sekwencji, nie decyzją
## fabularną — brak klucza w starszym pliku ustawień to gracz sprzed tej
## opcji, nie błąd.
var cinematics_seen: Dictionary = {}
var locale_code := "pl"
var target_spawn_side: StringName = &"left"
var _restore_saved_position := false

var _transition_layer: CanvasLayer
var _fade_rect: ColorRect
var _pause_layer: CanvasLayer
var _station_grid: GridContainer
var _status_label: Label
var _pause_settings_panel: SettingsOverlay
var _transitioning := false
var _save_valid := false
var _handled_completions: Dictionary = {}
var _default_input_events: Dictionary = {}
var _custom_input_bindings: Dictionary = {}
var _runtime_trace_path := ""


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_capture_default_input_map()
	reload_settings_from_disk()
	reload_campaign_from_disk()
	_ensure_transition_overlay()
	_ensure_pause_menu()
	get_tree().node_added.connect(_observe_campaign_station)
	_runtime_trace_path = OS.get_environment(RUNTIME_TRACE_PATH_ENV).strip_edges()
	if not _runtime_trace_path.is_empty():
		campaign_saved.connect(_on_runtime_trace_campaign_saved)
		transition_finished.connect(_on_runtime_trace_transition_finished)
		call_deferred("_record_runtime_trace_ready")


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed(&"pause") or event.is_echo() or _transitioning:
		return
	set_pause_menu_visible(not get_tree().paused)
	get_viewport().set_input_as_handled()


func _record_runtime_trace_ready() -> void:
	await get_tree().process_frame
	_append_runtime_trace(
		"ready current_scene=%s save_valid=%s checkpoint=%s"
		% [
			"null" if get_tree().current_scene == null else String(get_tree().current_scene.name),
			str(_save_valid),
			String(last_checkpoint_station)
		]
	)


func _on_runtime_trace_campaign_saved(_save_path: String) -> void:
	_append_runtime_trace(
		"campaign_saved checkpoint=%s position=%s completed=%s"
		% [
			String(last_checkpoint_station),
			str(last_checkpoint_position),
			str(is_campaign_completed())
		]
	)


func _on_runtime_trace_transition_finished(target_scene: String) -> void:
	_append_runtime_trace(
		"transition_finished target=%s current_scene=%s"
		% [
			target_scene,
			"null" if get_tree().current_scene == null else String(get_tree().current_scene.name)
		]
	)


func _append_runtime_trace(line: String) -> void:
	if _runtime_trace_path.is_empty():
		return
	var trace_path := _runtime_trace_path
	if trace_path.begins_with("user://") or trace_path.begins_with("res://"):
		trace_path = ProjectSettings.globalize_path(trace_path)
	DirAccess.make_dir_recursive_absolute(trace_path.get_base_dir())
	var file := FileAccess.open(trace_path, FileAccess.WRITE_READ)
	if file == null:
		push_warning("GameStateManager could not open runtime trace path: %s" % trace_path)
		return
	file.seek_end()
	file.store_line(line)
	file.close()


func mark_station_reached(station_id: StringName) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if normalized_id.is_empty() or reached_stations.has(normalized_id):
		return
	reached_stations[normalized_id] = true
	save_campaign()


func set_checkpoint(station_id: StringName, spawn_position: Vector2) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if normalized_id.is_empty():
		return
	reached_stations[normalized_id] = true
	last_checkpoint_station = normalized_id
	last_checkpoint_position = spawn_position
	save_campaign()
	checkpoint_changed.emit(normalized_id, spawn_position)


func collect_clue(clue_id: StringName) -> void:
	if clue_id.is_empty() or collected_clues.has(clue_id):
		return
	collected_clues[clue_id] = true
	save_campaign()
	clue_collected.emit(clue_id)


func has_collected_clue(clue_id: StringName) -> bool:
	return collected_clues.has(clue_id)


func record_decision(decision_id: StringName, value: Variant) -> bool:
	if decision_id.is_empty():
		return false
	var sanitized := _sanitize_json_value(value)
	if not bool(sanitized.get("valid", false)):
		return false
	var json_value: Variant = sanitized.get("value")
	decisions[decision_id] = json_value
	_mark_p7_migration_revision(decision_id)
	preload("res://scripts/campaign/gap_ledger.gd").after_decision(decision_id, json_value)
	save_campaign()
	decision_recorded.emit(decision_id, json_value)
	return true


func open_gap(gap_id: StringName, record: Dictionary) -> void:
	if gap_id.is_empty() or open_gaps.has(String(gap_id)):
		return
	open_gaps[String(gap_id)] = record
	save_campaign()


func close_gap(gap_id: StringName) -> void:
	if not open_gaps.has(String(gap_id)):
		return
	open_gaps.erase(String(gap_id))
	save_campaign()


func has_open_gap(gap_id: StringName) -> bool:
	return open_gaps.has(String(gap_id))


func _sanitize_json_value(value: Variant, depth: int = 0) -> Dictionary:
	if depth > 32:
		return {"valid": false}
	match typeof(value):
		TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_STRING:
			return {"valid": true, "value": value}
		TYPE_FLOAT:
			return {"valid": is_finite(float(value)), "value": value}
		TYPE_STRING_NAME:
			return {"valid": true, "value": String(value)}
		TYPE_ARRAY:
			var copied_array: Array = []
			for item in value as Array:
				var copied_item := _sanitize_json_value(item, depth + 1)
				if not bool(copied_item.get("valid", false)):
					return {"valid": false}
				copied_array.append(copied_item.get("value"))
			return {"valid": true, "value": copied_array}
		TYPE_DICTIONARY:
			var copied_dictionary: Dictionary = {}
			for key in value as Dictionary:
				if not (key is String or key is StringName):
					return {"valid": false}
				var copied_item := _sanitize_json_value((value as Dictionary)[key], depth + 1)
				if not bool(copied_item.get("valid", false)):
					return {"valid": false}
				copied_dictionary[String(key)] = copied_item.get("value")
			return {"valid": true, "value": copied_dictionary}
		_:
			return {"valid": false}

func _mark_p7_migration_revision(decision_id: StringName) -> void:
	var decision_text := String(decision_id)
	if decision_text.begins_with("p7.mutual_test."):
		decisions[P7_MUTUAL_TEST_MIGRATION_KEY] = P7_MUTUAL_TEST_MIGRATION_REVISION
		return
	for migration in P7_EARLY_SEQUENCE_MIGRATIONS:
		var sequence_id := StringName(migration.get("sequence_id", ""))
		if decision_text.begins_with("p7.%s." % sequence_id):
			var revision_key := StringName("p7.%s.migration_revision" % sequence_id)
			decisions[revision_key] = int(migration.get("revision", 1))
			return


func _mark_all_p7_migration_revisions() -> void:
	decisions[P7_MUTUAL_TEST_MIGRATION_KEY] = P7_MUTUAL_TEST_MIGRATION_REVISION
	for migration in P7_EARLY_SEQUENCE_MIGRATIONS:
		var sequence_id := StringName(migration.get("sequence_id", ""))
		var revision := int(migration.get("revision", 1))
		var revision_key := StringName("p7.%s.migration_revision" % sequence_id)
		decisions[revision_key] = revision


func has_reached_station(station_id: StringName) -> bool:
	return reached_stations.has(station_id)


func get_reached_station_ids() -> Array[StringName]:
	var result: Array[StringName] = []
	for station_id in reached_stations:
		result.append(StringName(station_id))
	return result


func get_selectable_stations(include_test_only: bool = false) -> Array[StringName]:
	var stations: Array[StringName] = CAMPAIGN_SELECTOR_STATIONS.duplicate()
	var selected_finale := get_selected_finale_id()
	if not selected_finale.is_empty() and stations.size() > 18:
		stations[18] = selected_finale
	if include_test_only or test_mode_enabled:
		return stations
	var unlocked: Array[StringName] = [&"station_01"]
	for station_id in stations:
		if has_reached_station(station_id) and not unlocked.has(station_id):
			unlocked.append(station_id)
	return unlocked


func get_all_campaign_scene_ids() -> Array[StringName]:
	var result: Array[StringName] = CAMPAIGN_ROUTE.duplicate()
	result.append_array(CAMPAIGN_FINALES)
	result.append(CAMPAIGN_EPILOGUE)
	return result


func get_all_scene_ids(include_legacy: bool = false) -> Array[StringName]:
	var result: Array[StringName] = get_all_campaign_scene_ids()
	if include_legacy:
		result.append_array(CAMPAIGN_LEGACY_STATIONS)
	return result


func get_legacy_campaign_scene_ids() -> Array[StringName]:
	return CAMPAIGN_LEGACY_STATIONS.duplicate()


func set_test_mode(enabled: bool) -> void:
	test_mode_enabled = enabled
	_refresh_station_buttons()


func restart_from_checkpoint() -> void:
	if last_checkpoint_station.is_empty():
		return
	set_pause_menu_visible(false)
	_restore_saved_position = true
	transition_to_station(last_checkpoint_station)


func get_next_campaign_station(station_id: StringName) -> StringName:
	var normalized_id := _normalize_station_id(station_id)
	var route_index := CAMPAIGN_ROUTE.find(normalized_id)
	if route_index >= 0 and route_index < CAMPAIGN_ROUTE.size() - 1:
		return CAMPAIGN_ROUTE[route_index + 1]
	if normalized_id == &"station_18":
		return get_selected_finale_id()
	if normalized_id == &"station_41":
		return get_selected_finale_id()
	if normalized_id in CAMPAIGN_FINALES:
		return CAMPAIGN_EPILOGUE
	var legacy_index := CAMPAIGN_LEGACY_STATIONS.find(normalized_id)
	if legacy_index >= 0 and legacy_index < CAMPAIGN_LEGACY_STATIONS.size() - 1:
		return CAMPAIGN_LEGACY_STATIONS[legacy_index + 1]
	return &""


func get_previous_campaign_station(station_id: StringName) -> StringName:
	var normalized_id := _normalize_station_id(station_id)
	var route_index := CAMPAIGN_ROUTE.find(normalized_id)
	if route_index > 0:
		return CAMPAIGN_ROUTE[route_index - 1]
	if normalized_id in CAMPAIGN_FINALES:
		if has_reached_station(&"station_41") and not has_reached_station(&"station_18"):
			return &"station_41"
		return &"station_18"
	if normalized_id == CAMPAIGN_EPILOGUE:
		var finale := get_selected_finale_id()
		return finale if not finale.is_empty() else &"station_42a"
	var legacy_index := CAMPAIGN_LEGACY_STATIONS.find(normalized_id)
	if legacy_index > 0:
		return CAMPAIGN_LEGACY_STATIONS[legacy_index - 1]
	if normalized_id == &"station_19":
		return &"station_18"
	return &""


func transition_to_station_bidirectional(station_id: StringName, spawn_side: StringName = &"left") -> void:
	target_spawn_side = spawn_side
	transition_to_station(station_id)


# PKG-0230 (P2-1, S-05): strona wejscia zgodna z fikcja. Trzy fabularne
# powroty do znanych przestrzeni wchodza z prawej (12 → 13: powrot do
# mieszkania; 17 → 18: powrot na ulice z 05). Reszta trasy wchodzi z lewej.
# Realizacja istniejacym mechanizmem (target_spawn_side + Threshold po
# stronie wejscia, D-227); zadnych nowych wezlow ani geometrii.
func arrival_side_for(from_station: StringName, to_station: StringName) -> StringName:
	if from_station == &"station_12" and to_station == &"station_13":
		return &"right"
	if from_station == &"station_17" and to_station == &"station_18":
		return &"right"
	return &"left"


## PKG-0232 (D-244, pakiet A): polityka faktów i rozdzielenie writerów od
## nawigacji.
## - `REQUIRED_FOR_NEXT_SCENE`: łańcuch nieodwracalny (metoda → finał →
##   wykonanie → skutek → epilog). Bez metody nie ma finału na normalnej
##   ścieżce (strażnik stoi w station_18._trigger_level_completion); jawne
##   wejścia testowe/selektora (select_finale_*, bezpośredni complete_station
##   w harnessach) zachowują dotychczasowy routing, w tym dotychczasowy
##   fallback 42A dla wywołań bezpośrednich.
## - `OPTIONAL_WITH_GAP`: wszystkie luki liniowe 01–18 (GapLedger); pominięcie
##   jest legalne, następna scena nie czyta luk (osobny pakiet content).
## - `LOCAL_FLAVOUR`: reszta — bez wpływu na późniejszą wiedzę.
## `_handled_completions` chroni rozliczenie writerów (dokładnie raz), ale NIE
## blokuje ponownej nawigacji: powrót ReturnZone i ponowny marsz naprzód
## (N→N+1→N→N+1) przechodzi bez powielania faktów (S-07).
## PKG-0232 (D-244, S-07): ponowna nawigacja po rozliczonej stacji. Nie dopisuje
## faktów (te stoją w decisions), tylko odtwarza przejście naprzód — dzięki
## temu ReturnZone nie jest pułapką jednokierunkową.
func _repeat_navigate(normalized_id: StringName, should_transition: bool) -> void:
	if not should_transition:
		return
	if normalized_id == &"station_18":
		var repeat_finale := get_selected_finale_id()
		if repeat_finale.is_empty():
			return
		mark_station_reached(repeat_finale)
		transition_to_station(repeat_finale)
		return
	if normalized_id in CAMPAIGN_FINALES:
		if normalized_id != get_selected_finale_id() and not get_selected_finale_id().is_empty():
			return
		mark_station_reached(CAMPAIGN_EPILOGUE)
		transition_to_station(CAMPAIGN_EPILOGUE)
		return
	if normalized_id == CAMPAIGN_EPILOGUE:
		return
	var repeat_next := get_next_campaign_station(normalized_id)
	if repeat_next.is_empty():
		return
	mark_station_reached(repeat_next)
	transition_to_station_bidirectional(repeat_next, arrival_side_for(normalized_id, repeat_next))


func complete_station(station_id: StringName, should_transition: bool = true) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if normalized_id.is_empty():
		return
	if _handled_completions.has(normalized_id):
		_repeat_navigate(normalized_id, should_transition)
		return

	if normalized_id == &"station_18":
		var finale_id := get_selected_finale_id()
		if finale_id.is_empty():
			finale_id = &"station_42a"
			decisions[&"campaign_finale"] = "station_42a"
		_handled_completions[normalized_id] = true
		mark_station_reached(normalized_id)
		mark_station_reached(finale_id)
		if should_transition:
			transition_to_station(finale_id)
		return

	if normalized_id == &"station_41":
		var finale_id := get_selected_finale_id()
		if finale_id.is_empty():
			finale_id = &"station_42a"
		_handled_completions[normalized_id] = true
		mark_station_reached(normalized_id)
		mark_station_reached(finale_id)
		if should_transition:
			transition_to_station(finale_id)
		return

	if normalized_id in CAMPAIGN_FINALES:
		if normalized_id != get_selected_finale_id() and not get_selected_finale_id().is_empty():
			return
		_handled_completions[normalized_id] = true
		mark_station_reached(normalized_id)
		mark_station_reached(CAMPAIGN_EPILOGUE)
		if should_transition:
			transition_to_station(CAMPAIGN_EPILOGUE)
		return

	if normalized_id == CAMPAIGN_EPILOGUE:
		_handled_completions[normalized_id] = true
		mark_station_reached(normalized_id)
		decisions[&"campaign_completed"] = true
		save_campaign()
		campaign_completed.emit(get_selected_finale_id())
		if should_transition and campaign_auto_transition_enabled:
			return_to_title()
		return

	var route_index := CAMPAIGN_ROUTE.find(normalized_id)
	var legacy_index := CAMPAIGN_LEGACY_STATIONS.find(normalized_id)
	if route_index < 0 and legacy_index < 0:
		return
	_handled_completions[normalized_id] = true
	mark_station_reached(normalized_id)
	var next_station := get_next_campaign_station(normalized_id)
	if next_station.is_empty():
		return
	mark_station_reached(next_station)
	if should_transition:
		# PKG-0230 (P2-1, S-05): wejscie z prawej dla fabularnych powrotow
		# (12 → 13, 17 → 18); reszta z lewej jak dotychczas.
		transition_to_station_bidirectional(next_station, arrival_side_for(normalized_id, next_station))


func start_new_game() -> void:
	reset_campaign(true)
	transition_to_scene(COLD_OPEN_SCENE)


func continue_campaign() -> void:
	var target := last_checkpoint_station
	if not has_valid_campaign_save() or target.is_empty() or not _is_known_campaign_id(target):
		target = &"station_01"
	_restore_saved_position = true
	transition_to_station(target)


func return_to_title() -> void:
	get_tree().paused = false
	if is_instance_valid(_pause_layer):
		_pause_layer.visible = false
	if is_instance_valid(_pause_settings_panel):
		_pause_settings_panel.visible = false
	transition_to_scene("res://scenes/shell/title_screen.tscn")


func has_valid_campaign_save() -> bool:
	return _save_valid


func is_transitioning() -> bool:
	return _transitioning


func is_campaign_completed() -> bool:
	return bool(_get_decision(&"campaign_completed", false))


func get_selected_finale_id() -> StringName:
	var saved_id := String(_get_decision(&"campaign_finale", ""))
	var finale_id := StringName(saved_id.to_lower())
	if finale_id in CAMPAIGN_FINALES:
		return finale_id
	var method := String(_get_decision(&"p9.method_commitment.method_committed", ""))
	if method.is_empty():
		method = String(_get_decision(&"method_committed", ""))
	match method:
		"force_home":
			return &"station_42a"
		"close_equal_recover_local":
			return &"station_42b"
		"mutual_passage":
			return &"station_42c"
	return &""


func select_finale_operation(operation: String) -> StringName:
	var normalized_operation := operation.to_upper()
	if not OPERATION_TO_FINALE.has(normalized_operation):
		return &""
	var finale_id: StringName = OPERATION_TO_FINALE[normalized_operation]
	decisions[&"station_41_operation"] = normalized_operation
	decisions[&"campaign_finale"] = String(finale_id)
	match normalized_operation:
		"A":
			decisions[&"method_committed"] = "force_home"
			decisions[&"p9.method_commitment.method_committed"] = "force_home"
		"B":
			decisions[&"method_committed"] = "close_equal_recover_local"
			decisions[&"p9.method_commitment.method_committed"] = "close_equal_recover_local"
		"C":
			decisions[&"method_committed"] = "mutual_passage"
			decisions[&"p9.method_commitment.method_committed"] = "mutual_passage"
	save_campaign()
	decision_recorded.emit(&"station_41_operation", normalized_operation)
	decision_recorded.emit(&"campaign_finale", String(finale_id))
	_refresh_station_buttons()
	return finale_id


func select_finale_method(method: String) -> StringName:
	var finale_id: StringName = &""
	var op := ""
	match method:
		"force_home":
			finale_id = &"station_42a"
			op = "A"
		"close_equal_recover_local":
			finale_id = &"station_42b"
			op = "B"
		"mutual_passage":
			finale_id = &"station_42c"
			op = "C"
		_:
			return &""
	decisions[&"p9.method_commitment.method_committed"] = method
	decisions[&"method_committed"] = method
	decisions[&"station_41_operation"] = op
	decisions[&"campaign_finale"] = String(finale_id)
	save_campaign()
	decision_recorded.emit(&"method_committed", method)
	decision_recorded.emit(&"campaign_finale", String(finale_id))
	_refresh_station_buttons()
	return finale_id


func get_save_path() -> String:
	return SAVE_PATH


func get_settings_path() -> String:
	return SETTINGS_PATH


func get_settings_schema_version() -> int:
	return SETTINGS_SCHEMA_VERSION


func get_locale() -> String:
	return locale_code


func get_remappable_actions() -> Array[StringName]:
	return REMAPPABLE_ACTIONS.duplicate()


func set_master_volume(linear_value: float, persist: bool = true) -> void:
	master_volume_linear = clampf(linear_value, 0.0, 1.0)
	_apply_audio_setting()
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)


func set_text_speed_cps(speed: float, persist: bool = true) -> void:
	text_speed_cps = clampf(speed, 10.0, 90.0)
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)


func set_fullscreen(enabled: bool, persist: bool = true) -> void:
	fullscreen_enabled = enabled
	_apply_window_setting()
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)


## PKG-0141 (D-151). Tryb ograniczonego ruchu. Tlumi ruch peryferyjny — migotanie
## i pulsowanie swiatla, wstrzas kamery, oddech pola kotwiczenia i emisje
## dekoracyjnych mikro-czastek — bez zmiany logiki rozgrywki i bez zabierania
## jakiejkolwiek informacji diegetycznej. Snap 2 px kompozytora (D-120) nie
## zalezy od trybu.
func set_reduced_motion(enabled: bool, persist: bool = true) -> void:
	reduced_motion = enabled
	MotionAccessibility.set_reduced_motion(reduced_motion)
	if persist:
		save_settings_to_disk()
	accessibility_changed.emit(text_scale, locale_code)


func is_reduced_motion() -> bool:
	return reduced_motion


## PKG-0176 (D-195). Czy warstwa A zimnego otwarcia zostala juz raz ukonczona.
func is_cold_open_seen() -> bool:
	return cold_open_seen


func mark_cold_open_seen(persist: bool = true) -> void:
	if cold_open_seen:
		return
	cold_open_seen = true
	if persist:
		save_settings_to_disk()


## PKG-0190. Czy dana krótka sekwencja cinematic vignette została już
## obejrzana (w pełni lub pominięta) w tym lub poprzednim przebiegu.
func is_cinematic_seen(vignette_id: StringName) -> bool:
	return bool(cinematics_seen.get(String(vignette_id), false))


func mark_cinematic_seen(vignette_id: StringName, persist: bool = true) -> void:
	var key := String(vignette_id)
	if bool(cinematics_seen.get(key, false)):
		return
	cinematics_seen[key] = true
	if persist:
		save_settings_to_disk()


func set_text_scale(scale_value: float, persist: bool = true) -> void:
	text_scale = clampf(scale_value, MIN_TEXT_SCALE, MAX_TEXT_SCALE)
	apply_text_scale_to_tree()
	if persist:
		save_settings_to_disk()
	accessibility_changed.emit(text_scale, locale_code)


func set_locale(new_locale: String, persist: bool = true) -> bool:
	var normalized := new_locale.to_lower()
	if normalized not in LocalizationManager.SUPPORTED_LOCALES:
		return false
	locale_code = normalized
	LocalizationManager.set_locale(locale_code)
	if persist:
		save_settings_to_disk()
	accessibility_changed.emit(text_scale, locale_code)
	_refresh_pause_localization()
	return true


func restore_default_settings(persist: bool = true) -> void:
	master_volume_linear = DEFAULT_MASTER_VOLUME
	text_speed_cps = DEFAULT_TEXT_SPEED_CPS
	fullscreen_enabled = false
	text_scale = DEFAULT_TEXT_SCALE
	reduced_motion = DEFAULT_REDUCED_MOTION
	MotionAccessibility.set_reduced_motion(reduced_motion)
	# `cold_open_seen` nie jest preferencja, tylko faktem o przebytej sekwencji.
	# Przywrocenie domyslnych ustawien go nie cofa (PKG-0176).
	locale_code = "pl"
	_custom_input_bindings.clear()
	_restore_default_input_map()
	LocalizationManager.set_locale(locale_code)
	_apply_audio_setting()
	_apply_window_setting()
	apply_text_scale_to_tree()
	if persist:
		save_settings_to_disk()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)
	accessibility_changed.emit(text_scale, locale_code)
	input_map_changed.emit()
	_refresh_pause_localization()


func reload_settings_from_disk() -> bool:
	master_volume_linear = DEFAULT_MASTER_VOLUME
	text_speed_cps = DEFAULT_TEXT_SPEED_CPS
	fullscreen_enabled = false
	text_scale = DEFAULT_TEXT_SCALE
	reduced_motion = DEFAULT_REDUCED_MOTION
	MotionAccessibility.set_reduced_motion(reduced_motion)
	cold_open_seen = false
	cinematics_seen = {}
	locale_code = "pl"
	_custom_input_bindings.clear()
	_restore_default_input_map()
	LocalizationManager.set_locale(locale_code)
	var loaded := false
	if not FileAccess.file_exists(SETTINGS_PATH):
		loaded = false
	else:
		var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		if file != null:
			var json := JSON.new()
			var parse_error := json.parse(file.get_as_text())
			file.close()
			if parse_error == OK and json.data is Dictionary:
				loaded = _apply_loaded_settings(true, json.data as Dictionary)
	if not loaded:
		_apply_loaded_settings(false, {})
	_apply_audio_setting()
	_apply_window_setting()
	apply_text_scale_to_tree()
	settings_changed.emit(master_volume_linear, text_speed_cps, fullscreen_enabled)
	accessibility_changed.emit(text_scale, locale_code)
	input_map_changed.emit()
	_refresh_pause_localization()
	return loaded


func save_settings_to_disk() -> bool:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_error("GameStateManager cannot write settings: %s" % SETTINGS_PATH)
		return false
	file.store_string(JSON.stringify({
		"settings_version": SETTINGS_SCHEMA_VERSION,
		"master_volume": master_volume_linear,
		"text_speed_cps": text_speed_cps,
		"fullscreen": fullscreen_enabled,
		"text_scale": text_scale,
		"reduced_motion": reduced_motion,
		"cold_open_seen": cold_open_seen,
		"cinematics_seen": cinematics_seen,
		"locale": locale_code,
		"remap": _serialize_input_bindings(),
	}))
	file.close()
	return true


func _apply_loaded_settings(should_load: bool, data: Dictionary) -> bool:
	if not should_load:
		return false
	if int(data.get("settings_version", -1)) != SETTINGS_SCHEMA_VERSION:
		push_warning("GameStateManager ignored unsupported settings schema; using defaults.")
		return false
	if data.has("master_volume") and not _is_numeric(data["master_volume"]):
		return false
	if data.has("text_speed_cps") and not _is_numeric(data["text_speed_cps"]):
		return false
	if data.has("text_scale") and not _is_numeric(data["text_scale"]):
		return false
	if data.has("fullscreen") and not data["fullscreen"] is bool:
		return false
	if data.has("reduced_motion") and not data["reduced_motion"] is bool:
		return false
	if data.has("cold_open_seen") and not data["cold_open_seen"] is bool:
		return false
	if data.has("cinematics_seen"):
		var raw_cinematics: Variant = data["cinematics_seen"]
		if not raw_cinematics is Dictionary:
			return false
		for key in (raw_cinematics as Dictionary).keys():
			if not key is String or not (raw_cinematics as Dictionary)[key] is bool:
				return false
	var saved_locale := String(data.get("locale", "pl")).to_lower()
	if saved_locale not in LocalizationManager.SUPPORTED_LOCALES:
		return false
	var saved_remap: Variant = data.get("remap", {})
	if not saved_remap is Dictionary:
		return false
	var parsed_bindings: Dictionary = {}
	for raw_action in (saved_remap as Dictionary).keys():
		if not raw_action is String:
			return false
		var action := StringName(raw_action)
		if action not in REMAPPABLE_ACTIONS:
			return false
		var event_variant: Variant = _deserialize_input_event((saved_remap as Dictionary)[raw_action])
		if not event_variant is InputEvent:
			return false
		var event := event_variant as InputEvent
		var conflict := _find_conflicting_action(event, action)
		if not conflict.is_empty():
			return false
		parsed_bindings[action] = event

	master_volume_linear = clampf(float(data.get("master_volume", DEFAULT_MASTER_VOLUME)), 0.0, 1.0)
	text_speed_cps = clampf(float(data.get("text_speed_cps", DEFAULT_TEXT_SPEED_CPS)), 10.0, 90.0)
	text_scale = clampf(float(data.get("text_scale", DEFAULT_TEXT_SCALE)), MIN_TEXT_SCALE, MAX_TEXT_SCALE)
	fullscreen_enabled = bool(data.get("fullscreen", false))
	# Klucz doszedl w PKG-0141. Brak klucza w starszym pliku ustawien to nie blad,
	# tylko gracz sprzed tej opcji — dostaje wartosc domyslna, nie odrzucony plik.
	reduced_motion = bool(data.get("reduced_motion", DEFAULT_REDUCED_MOTION))
	MotionAccessibility.set_reduced_motion(reduced_motion)
	# Klucz doszedl w PKG-0176. Migracja przyjmuje starszy plik bez niego:
	# gracz sprzed zimnego otwarcia zobaczy warstwe A raz, jak kazdy.
	cold_open_seen = bool(data.get("cold_open_seen", false))
	# PKG-0190: klucz doszedł po `cold_open_seen`; ten sam wzorzec migracji —
	# brak klucza w starszym pliku ustawień to gracz sprzed tej opcji.
	cinematics_seen = (data.get("cinematics_seen", {}) as Dictionary).duplicate()
	locale_code = saved_locale
	_custom_input_bindings = parsed_bindings
	_restore_default_input_map()
	for action in parsed_bindings:
		_replace_event_of_matching_type(action, parsed_bindings[action] as InputEvent)
	LocalizationManager.set_locale(locale_code)
	return true


func _replace_event_of_matching_type(action: StringName, new_event: InputEvent) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	var remaining: Array[InputEvent] = []
	for existing in InputMap.action_get_events(action):
		if new_event is InputEventKey and not existing is InputEventKey:
			remaining.append(existing)
		elif new_event is InputEventJoypadButton and not (existing is InputEventJoypadButton or existing is InputEventJoypadMotion):
			remaining.append(existing)
	InputMap.action_erase_events(action)
	for ev in remaining:
		InputMap.action_add_event(action, ev)
	InputMap.action_add_event(action, new_event.duplicate())


func _is_numeric(value: Variant) -> bool:
	return value is int or value is float


func _capture_default_input_map() -> void:
	if not _default_input_events.is_empty():
		return
	for action in REMAPPABLE_ACTIONS:
		var events: Array[InputEvent] = []
		if InputMap.has_action(action):
			for event in InputMap.action_get_events(action):
				events.append(event.duplicate() as InputEvent)
		_default_input_events[action] = events


func _restore_default_input_map() -> void:
	if _default_input_events.is_empty():
		return
	for action in REMAPPABLE_ACTIONS:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		InputMap.action_erase_events(action)
		for event in _default_input_events.get(action, []):
			InputMap.action_add_event(action, (event as InputEvent).duplicate())


func restore_default_input_map(persist: bool = true) -> void:
	_restore_default_input_map()
	_custom_input_bindings.clear()
	if persist:
		save_settings_to_disk()
	input_map_changed.emit()
	remap_changed.emit(&"", true, "defaults", &"")


func remap_action(action: StringName, event: InputEvent) -> Dictionary:
	if action not in REMAPPABLE_ACTIONS:
		var unsupported := {"ok": false, "reason": "unsupported", "conflict_action": ""}
		remap_changed.emit(action, false, "unsupported", &"")
		return unsupported
	var normalized := _normalise_input_event(event)
	if normalized == null:
		var invalid := {"ok": false, "reason": "unsupported", "conflict_action": ""}
		remap_changed.emit(action, false, "unsupported", &"")
		return invalid
	var conflict := _find_conflicting_action(normalized, action)
	if not conflict.is_empty():
		var conflict_result := {"ok": false, "reason": "conflict", "conflict_action": String(conflict)}
		remap_changed.emit(action, false, "conflict", conflict)
		return conflict_result
	_replace_event_of_matching_type(action, normalized)
	_custom_input_bindings[action] = normalized
	if not save_settings_to_disk():
		_restore_default_input_map()
		_custom_input_bindings.erase(action)
		var persistence_failure := {"ok": false, "reason": "persistence", "conflict_action": ""}
		remap_changed.emit(action, false, "persistence", &"")
		return persistence_failure
	input_map_changed.emit()
	remap_changed.emit(action, true, "ok", &"")
	return {"ok": true, "reason": "ok", "conflict_action": ""}


func get_action_binding_text(action: StringName) -> String:
	if not InputMap.has_action(action):
		return "—"
	var prompts: Array[String] = []
	for event in InputMap.action_get_events(action):
		var prompt := get_input_event_prompt(event)
		if not prompt.is_empty() and not prompts.has(prompt):
			prompts.append(prompt)
	return " / ".join(prompts) if not prompts.is_empty() else "—"


func get_input_event_prompt(event: InputEvent) -> String:
	if event is InputEventKey:
		var key_text := event.as_text()
		var separator := key_text.find(" - ")
		return key_text.left(separator) if separator > 0 else key_text
	if event is InputEventJoypadButton:
		var button := (event as InputEventJoypadButton).button_index
		var button_names := {
			0: "PAD A", 1: "PAD B", 2: "PAD X", 3: "PAD Y",
			4: "PAD LB", 5: "PAD RB", 6: "PAD BACK", 7: "PAD START",
			8: "PAD L3", 9: "PAD R3", 10: "PAD D↑", 11: "PAD D↓",
			12: "PAD D←", 13: "PAD D→",
		}
		return String(button_names.get(button, "PAD %d" % button))
	if event is InputEventJoypadMotion:
		var motion := event as InputEventJoypadMotion
		var axis_name := "PAD L" if motion.axis < 2 else "PAD R"
		var axis_direction := "←" if motion.axis_value < 0.0 else "→"
		if motion.axis % 2 == 1:
			axis_direction = "↑" if motion.axis_value < 0.0 else "↓"
		return axis_name + axis_direction
	return event.as_text()


func _find_conflicting_action(event: InputEvent, except_action: StringName) -> StringName:
	var identity := _input_event_identity(event)
	if identity.is_empty():
		return &""
	for action in REMAPPABLE_ACTIONS:
		if action == except_action or not InputMap.has_action(action):
			continue
		for existing in InputMap.action_get_events(action):
			if _input_event_identity(existing) == identity:
				return action
	return &""


func _normalise_input_event(event: InputEvent) -> InputEvent:
	if not event is InputEventKey and not event is InputEventJoypadButton:
		return null
	var normalized := event.duplicate() as InputEvent
	if normalized is InputEventKey:
		(normalized as InputEventKey).pressed = false
		(normalized as InputEventKey).echo = false
	if normalized is InputEventJoypadButton:
		(normalized as InputEventJoypadButton).pressed = false
	return normalized


func _input_event_identity(event: InputEvent) -> String:
	if event is InputEventKey:
		var key := event as InputEventKey
		return "key|%d|%d|%d|%d|%d|%d|%d|%d|%d" % [
			key.keycode, key.physical_keycode, key.key_label, key.unicode, key.location,
			int(key.alt_pressed), int(key.ctrl_pressed), int(key.shift_pressed), int(key.meta_pressed),
		]
	if event is InputEventJoypadButton:
		var button := event as InputEventJoypadButton
		return "joy_button|%d" % button.button_index
	return ""


func _serialize_input_bindings() -> Dictionary:
	var result: Dictionary = {}
	for action in _custom_input_bindings:
		var data := _serialize_input_event(_custom_input_bindings[action] as InputEvent)
		if not data.is_empty():
			result[String(action)] = data
	return result


func _serialize_input_event(event: InputEvent) -> Dictionary:
	if event is InputEventKey:
		var key := event as InputEventKey
		return {
			"type": "key",
			"keycode": key.keycode,
			"physical_keycode": key.physical_keycode,
			"key_label": key.key_label,
			"unicode": key.unicode,
			"location": key.location,
			"alt": key.alt_pressed,
			"ctrl": key.ctrl_pressed,
			"shift": key.shift_pressed,
			"meta": key.meta_pressed,
		}
	if event is InputEventJoypadButton:
		var button := event as InputEventJoypadButton
		return {"type": "joy_button", "button_index": button.button_index}
	return {}


func _deserialize_input_event(data: Variant) -> Variant:
	if not data is Dictionary:
		return null
	var dict := data as Dictionary
	var event_type := String(dict.get("type", ""))
	if event_type == "key":
		var key := InputEventKey.new()
		key.keycode = int(dict.get("keycode", 0))
		key.physical_keycode = int(dict.get("physical_keycode", 0))
		key.key_label = int(dict.get("key_label", 0))
		key.unicode = int(dict.get("unicode", 0))
		key.location = int(dict.get("location", 0))
		key.alt_pressed = bool(dict.get("alt", false))
		key.ctrl_pressed = bool(dict.get("ctrl", false))
		key.shift_pressed = bool(dict.get("shift", false))
		key.meta_pressed = bool(dict.get("meta", false))
		return key
	if event_type == "joy_button":
		var button := InputEventJoypadButton.new()
		button.button_index = int(dict.get("button_index", -1))
		return button if button.button_index >= 0 else null
	return null


func apply_text_scale_to_tree() -> void:
	for node in get_tree().get_nodes_in_group("gs_scalable_text"):
		if not is_instance_valid(node) or not node.has_meta("gs_base_font_size"):
			continue
		var base_size := int(node.get_meta("gs_base_font_size"))
		var property_name := StringName(String(node.get_meta("gs_font_property", "font_size")))
		var scaled_size := maxi(1, roundi(float(base_size) * text_scale))
		if node is Control:
			(node as Control).add_theme_font_size_override(property_name, scaled_size)


func _refresh_pause_localization() -> void:
	if not is_instance_valid(_pause_layer):
		return
	var title := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/PauseTitle") as Label
	if title:
		title.text = LocalizationManager.tr_key("PAUSE_TITLE")
	var resume := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/ResumeButton") as Button
	if resume:
		resume.text = LocalizationManager.tr_key("PAUSE_RESUME")
	var checkpoint := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/CheckpointButton") as Button
	if checkpoint:
		checkpoint.text = LocalizationManager.tr_key("PAUSE_CHECKPOINT")
	var test_button := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/TestModeButton") as Button
	if test_button:
		test_button.text = LocalizationManager.tr_key("PAUSE_TEST_MODE") % ("ON" if test_mode_enabled else "OFF")
	var reset_button := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/ResetButton") as Button
	if reset_button:
		reset_button.text = LocalizationManager.tr_key("PAUSE_RESET_SAVE")
	var settings_button := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/SettingsButton") as Button
	if settings_button:
		settings_button.text = LocalizationManager.tr_key("PAUSE_SETTINGS")
	var footer := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/PauseFooter") as Label
	if footer:
		footer.text = LocalizationManager.tr_key("PAUSE_FOOTER")
	_refresh_station_button_labels()


func _refresh_station_button_labels() -> void:
	if not is_instance_valid(_station_grid):
		return
	for child in _station_grid.get_children():
		var button := child as Button
		if button:
			var station_id := StringName(String(button.get_meta("station_id", "")))
			button.tooltip_text = LocalizationManager.tr_key("PAUSE_STATION_TOOLTIP") % String(station_id).trim_prefix("station_")


func _apply_audio_setting() -> void:
	var master_bus := AudioServer.get_bus_index(&"Master")
	if master_bus >= 0:
		AudioServer.set_bus_mute(master_bus, master_volume_linear <= 0.001)
		AudioServer.set_bus_volume_linear(master_bus, maxf(master_volume_linear, 0.0001))


func _apply_window_setting() -> void:
	var mode := DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen_enabled else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)


func save_campaign() -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("GameStateManager cannot write campaign save: %s" % SAVE_PATH)
		_save_valid = false
		return false
	file.store_string(JSON.stringify(_serialize_campaign()))
	file.flush()
	file.close()
	_save_valid = true
	campaign_saved.emit(SAVE_PATH)
	return true


func reload_campaign_from_disk() -> bool:
	_clear_campaign_memory()
	_save_valid = false
	if not FileAccess.file_exists(SAVE_PATH):
		campaign_reloaded.emit()
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("GameStateManager could not open campaign save; using a clean campaign.")
		campaign_reloaded.emit()
		return false
	var content := file.get_as_text()
	file.close()
	if content.strip_edges().is_empty():
		campaign_reloaded.emit()
		return false
	var json := JSON.new()
	var parse_error := json.parse(content)
	if parse_error != OK or not json.data is Dictionary:
		push_warning("GameStateManager ignored malformed campaign save; using a clean campaign.")
		campaign_reloaded.emit()
		return false
	var data := json.data as Dictionary
	if int(data.get("schema_version", -1)) != SAVE_SCHEMA_VERSION:
		push_warning("GameStateManager ignored unsupported campaign schema; using a clean campaign.")
		campaign_reloaded.emit()
		return false
	var migrated := _restore_campaign(data)
	_save_valid = true
	if migrated:
		save_campaign()
	campaign_reloaded.emit()
	return true


func reset_campaign(delete_save: bool = true) -> void:
	_clear_campaign_memory()
	_save_valid = false
	_handled_completions.clear()
	ProceduralAudio.clear_sound_cache()
	if delete_save:
		if FileAccess.file_exists(SAVE_PATH):
			DirAccess.remove_absolute(SAVE_PATH)
			var global_path := ProjectSettings.globalize_path(SAVE_PATH)
			if FileAccess.file_exists(global_path):
				DirAccess.remove_absolute(global_path)
	campaign_reset.emit()
	_refresh_station_buttons()


func _exit_tree() -> void:
	# Process-wide procedural resources outlive individual station scenes. Stop
	# remaining players, drop caches, then give the mix thread a short headless
	# window so AudioStreamPlaybackWAV is not still referenced at ObjectDB cleanup
	# (Godot #76745). The delay is CLI-only; windowed play is unaffected.
	var tree := get_tree()
	if tree != null:
		ProceduralAudio.drain_playback(tree.root)
	ProceduralAudio.clear_sound_cache()
	AtmosphereRig.clear_light_texture_cache()
	if DisplayServer.get_name() == "headless":
		OS.delay_msec(150)


func transition_to_station(station_id: StringName) -> void:
	var normalized_id := _normalize_station_id(station_id)
	if not _is_known_campaign_id(normalized_id):
		push_error("GameStateManager cannot load unknown station: %s" % station_id)
		return
	if not test_mode_enabled and not _can_enter_station(normalized_id):
		push_warning("GameStateManager blocked locked station: %s" % normalized_id)
		return
	var scene_path := STATION_SCENE_PREFIX + String(normalized_id).trim_prefix("station_") + STATION_SCENE_SUFFIX
	if not ResourceLoader.exists(scene_path):
		push_error("GameStateManager cannot load station: %s" % station_id)
		return
	transition_to_scene(scene_path)


func transition_to_scene(scene_path: String) -> void:
	if _transitioning or scene_path.is_empty():
		return
	_transitioning = true
	_ensure_transition_overlay()
	transition_started.emit(scene_path)
	var tween := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_fade_rect, "color:a", 1.0, 0.22)
	await tween.finished
	var tree := get_tree()
	if tree != null:
		ProceduralAudio.drain_playback(tree.root)
	ProceduralAudio.clear_sound_cache()
	tree.change_scene_to_file(scene_path)
	await get_tree().process_frame
	var fade_in := create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_in.tween_property(_fade_rect, "color:a", 0.0, 0.28)
	await fade_in.finished
	_transitioning = false
	transition_finished.emit(scene_path)


func set_pause_menu_visible(is_visible: bool) -> void:
	_ensure_pause_menu()
	get_tree().paused = is_visible
	_pause_layer.visible = is_visible
	if not is_visible and is_instance_valid(_pause_settings_panel):
		_pause_settings_panel.visible = false
	if is_visible:
		_refresh_station_buttons()
		var resume := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/ResumeButton") as Button
		if resume:
			resume.grab_focus.call_deferred()
	pause_changed.emit(is_visible)


func _serialize_campaign() -> Dictionary:
	return {
		"schema_version": SAVE_SCHEMA_VERSION,
		"reached_stations": reached_stations.keys(),
		"collected_clues": collected_clues.keys(),
		"decisions": decisions,
		"open_gaps": open_gaps,
		"last_checkpoint_station": String(last_checkpoint_station),
		"last_checkpoint_position": {"x": last_checkpoint_position.x, "y": last_checkpoint_position.y},
	}


func _restore_campaign(data: Dictionary) -> bool:
	for station_id in data.get("reached_stations", []):
		if station_id is String and not String(station_id).is_empty():
			reached_stations[StringName(station_id)] = true
	for clue_id in data.get("collected_clues", []):
		if clue_id is String and not String(clue_id).is_empty():
			collected_clues[StringName(clue_id)] = true
	var saved_decisions: Variant = data.get("decisions", {})
	if saved_decisions is Dictionary:
		var sanitized_decisions := _sanitize_json_value(saved_decisions)
		if bool(sanitized_decisions.get("valid", false)):
			decisions.clear()
			var raw_dict: Dictionary = sanitized_decisions.get("value") as Dictionary
			for k in raw_dict:
				decisions[StringName(k)] = raw_dict[k]
	var saved_gaps: Variant = data.get("open_gaps", {})
	if saved_gaps is Dictionary:
		var sanitized_gaps := _sanitize_json_value(saved_gaps)
		if bool(sanitized_gaps.get("valid", false)):
			open_gaps = (sanitized_gaps.get("value") as Dictionary).duplicate(true)
		else:
			open_gaps.clear()
	var checkpoint_station: Variant = data.get("last_checkpoint_station", "")
	if checkpoint_station is String and not String(checkpoint_station).is_empty():
		last_checkpoint_station = StringName(checkpoint_station as String)
		reached_stations[last_checkpoint_station] = true
	var saved_position: Variant = data.get("last_checkpoint_position", {})
	if saved_position is Dictionary:
		var pos_dict: Dictionary = saved_position as Dictionary
		last_checkpoint_position = Vector2(float(pos_dict.get("x", 0.0)), float(pos_dict.get("y", 0.0)))
	var migrated := _migrate_p7_mutual_test()
	if _migrate_p7_early_sequences():
		migrated = true
	return migrated


func _migrate_p7_mutual_test() -> bool:
	if int(decisions.get(P7_MUTUAL_TEST_MIGRATION_KEY, 0)) >= P7_MUTUAL_TEST_MIGRATION_REVISION:
		return false
	for legacy_key in P7_MUTUAL_TEST_LEGACY_DECISION_KEYS:
		decisions.erase(legacy_key)
	for decision_key in decisions.keys():
		if String(decision_key).begins_with("p7.mutual_test."):
			decisions.erase(decision_key)
	decisions[P7_MUTUAL_TEST_MIGRATION_KEY] = P7_MUTUAL_TEST_MIGRATION_REVISION
	if last_checkpoint_station in P7_MUTUAL_TEST_STATIONS:
		last_checkpoint_station = P7_MUTUAL_TEST_ENTRY_STATION
		last_checkpoint_position = P7_MUTUAL_TEST_ENTRY_POSITION
		reached_stations[last_checkpoint_station] = true
	return true

func _migrate_p7_early_sequences() -> bool:
	var migrated := false
	for migration in P7_EARLY_SEQUENCE_MIGRATIONS:
		var sequence_id := StringName(migration.get("sequence_id", ""))
		var revision := int(migration.get("revision", 1))
		var revision_key := StringName("p7.%s.migration_revision" % sequence_id)
		if int(decisions.get(revision_key, 0)) >= revision:
			continue
		for legacy_key in migration.get("legacy_keys", []):
			decisions.erase(legacy_key)
			decisions.erase(String(legacy_key))
		for decision_key in decisions.keys():
			if String(decision_key).begins_with("p7.%s." % sequence_id):
				decisions.erase(decision_key)
		decisions[revision_key] = revision
		var stations: Array = migration.get("stations", [])
		if stations.has(last_checkpoint_station):
			last_checkpoint_station = StringName(migration.get("entry_station", ""))
			var entry_position: Variant = migration.get("entry_position", Vector2.ZERO)
			if entry_position is Vector2:
				last_checkpoint_position = entry_position
			reached_stations[last_checkpoint_station] = true
		migrated = true
	return migrated


func _clear_campaign_memory() -> void:
	reached_stations.clear()
	collected_clues.clear()
	decisions.clear()
	open_gaps.clear()
	last_checkpoint_station = &""
	last_checkpoint_position = Vector2.ZERO


func _ensure_transition_overlay() -> void:
	if is_instance_valid(_transition_layer):
		return
	_transition_layer = CanvasLayer.new()
	_transition_layer.name = "SceneTransitionLayer"
	_transition_layer.layer = 100
	add_child(_transition_layer)
	_fade_rect = ColorRect.new()
	_fade_rect.name = "FadeToBlack"
	_fade_rect.color = Color(0.0, 0.0, 0.0, 0.0)
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_transition_layer.add_child(_fade_rect)


func _ensure_pause_menu() -> void:
	if is_instance_valid(_pause_layer):
		return
	_pause_layer = CanvasLayer.new()
	_pause_layer.name = "CampaignPauseMenu"
	_pause_layer.layer = 110
	_pause_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	_pause_layer.visible = false
	add_child(_pause_layer)
	var shade := ColorRect.new()
	shade.color = Color(VectorStageStyle.BACKDROP, 0.96)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pause_layer.add_child(shade)
	var panel := PanelContainer.new()
	panel.name = "PanelContainer"
	panel.position = Vector2(36.0, 18.0)
	panel.size = Vector2(568.0, 324.0)
	_pause_layer.add_child(panel)
	var style := StyleBoxFlat.new()
	style.bg_color = VectorStageStyle.INK
	style.border_color = VectorStageStyle.LIGHT_PLANE
	style.set_border_width_all(1)
	style.border_width_left = 5
	style.content_margin_left = 12.0
	style.content_margin_right = 12.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	panel.add_theme_stylebox_override(&"panel", style)
	var content := VBoxContainer.new()
	content.name = "VBoxContainer"
	content.add_theme_constant_override(&"separation", 5)
	panel.add_child(content)
	var title := Label.new()
	title.name = "PauseTitle"
	title.text = "KAMPANIA  //  PAUZA"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	title.add_theme_font_size_override(&"font_size", 19)
	title.modulate = VectorStageStyle.HUMAN_AMBER
	_mark_scalable_text(title, 19)
	content.add_child(title)
	_status_label = Label.new()
	_status_label.name = "PauseStatus"
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_status_label.modulate = VectorStageStyle.light(VectorStageStyle.LIGHT_PLANE, 0.40)
	_status_label.add_theme_font_size_override(&"font_size", 11)
	_mark_scalable_text(_status_label, 11)
	content.add_child(_status_label)
	var actions := HBoxContainer.new()
	actions.name = "HBoxContainer"
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override(&"separation", 5)
	content.add_child(actions)
	_add_menu_button(actions, "WZNÓW", func() -> void: set_pause_menu_visible(false), "ResumeButton")
	_add_menu_button(actions, "CHECKPOINT", restart_from_checkpoint, "CheckpointButton")
	_add_menu_button(actions, "USTAWIENIA", _open_pause_settings, "SettingsButton")
	_add_menu_button(actions, "TRYB TESTOWY: OFF", _toggle_test_mode, "TestModeButton")
	_add_menu_button(actions, "RESET ZAPISU", func() -> void: reset_campaign(true), "ResetButton")
	content.add_child(HSeparator.new())
	_station_grid = GridContainer.new()
	_station_grid.name = "StationGrid"
	_station_grid.columns = 9
	_station_grid.add_theme_constant_override(&"h_separation", 4)
	_station_grid.add_theme_constant_override(&"v_separation", 4)
	_station_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(_station_grid)
	var footer := Label.new()
	footer.name = "PauseFooter"
	footer.text = "PAUZA: POWRÓT  //  INTERAKCJA: WYBÓR"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	footer.modulate = VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.12)
	footer.add_theme_font_size_override(&"font_size", 9)
	_mark_scalable_text(footer, 9)
	content.add_child(footer)

	_pause_settings_panel = SettingsOverlay.new()
	_pause_settings_panel.name = "PauseSettingsPanel"
	_pause_settings_panel.position = Vector2(174.0, 24.0)
	_pause_settings_panel.visible = false
	_pause_settings_panel.closed.connect(_on_pause_settings_closed)
	_pause_layer.add_child(_pause_settings_panel)
	_configure_pause_focus()
	_refresh_pause_localization()
	apply_text_scale_to_tree()


func _add_menu_button(parent: Container, text: String, callback: Callable, button_name: String = "") -> void:
	var button := Button.new()
	button.name = button_name
	button.text = text
	button.custom_minimum_size = Vector2(100.0, 24.0)
	button.focus_mode = Control.FOCUS_ALL
	_mark_scalable_text(button, 11)
	_style_pause_button(button, false)
	button.pressed.connect(callback)
	parent.add_child(button)


func _style_pause_button(button: Button, compact: bool) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = VectorStageStyle.DEEP_PLANE
	normal.border_color = VectorStageStyle.MID_PLANE
	normal.set_border_width_all(1)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = VectorStageStyle.MID_PLANE
	hover.border_color = VectorStageStyle.ANCHOR_CYAN
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = VectorStageStyle.shade(VectorStageStyle.ANCHOR_CYAN, 0.52)
	pressed.border_color = VectorStageStyle.ANCHOR_CYAN
	var disabled := normal.duplicate() as StyleBoxFlat
	disabled.bg_color = VectorStageStyle.shade(VectorStageStyle.DEEP_PLANE, 0.28)
	disabled.border_color = VectorStageStyle.shade(VectorStageStyle.MID_PLANE, 0.30)
	button.add_theme_stylebox_override(&"normal", normal)
	button.add_theme_stylebox_override(&"hover", hover)
	button.add_theme_stylebox_override(&"pressed", pressed)
	button.add_theme_stylebox_override(&"focus", hover)
	button.add_theme_stylebox_override(&"disabled", disabled)
	button.add_theme_color_override(&"font_color", VectorStageStyle.light(VectorStageStyle.LIGHT_PLANE, 0.46))
	button.add_theme_color_override(&"font_hover_color", Color.WHITE)
	button.add_theme_color_override(&"font_pressed_color", Color.WHITE)
	button.add_theme_color_override(&"font_disabled_color", VectorStageStyle.shade(VectorStageStyle.LIGHT_PLANE, 0.36))
	button.add_theme_font_size_override(&"font_size", 10 if compact else 11)
	button.focus_mode = Control.FOCUS_ALL


func _toggle_test_mode() -> void:
	set_test_mode(not test_mode_enabled)


func _refresh_station_buttons() -> void:
	if not is_instance_valid(_station_grid):
		return
	for child in _station_grid.get_children():
		child.queue_free()
	for station_id in get_selectable_stations(true):
		var button := Button.new()
		var unlocked := test_mode_enabled or station_id == &"station_01" or has_reached_station(station_id)
		button.text = String(station_id).trim_prefix("station_").to_upper()
		button.tooltip_text = LocalizationManager.tr_key("PAUSE_STATION_TOOLTIP") % button.text
		button.disabled = not unlocked
		button.custom_minimum_size = Vector2(52.0, 24.0)
		button.focus_mode = Control.FOCUS_ALL
		button.set_meta("station_id", String(station_id))
		_mark_scalable_text(button, 10)
		_style_pause_button(button, true)
		button.pressed.connect(_on_station_requested.bind(station_id))
		_station_grid.add_child(button)
	if is_instance_valid(_status_label):
		_status_label.text = LocalizationManager.tr_key("PAUSE_STATUS") % [
			get_selectable_stations().size(),
			CAMPAIGN_SELECTOR_STATIONS.size(),
			"ON" if test_mode_enabled else "OFF",
		]
	var test_button := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/TestModeButton") as Button
	if test_button:
		test_button.text = LocalizationManager.tr_key("PAUSE_TEST_MODE") % ("ON" if test_mode_enabled else "OFF")
	_refresh_pause_localization()
	_configure_pause_focus()


func _on_station_requested(station_id: StringName) -> void:
	set_pause_menu_visible(false)
	transition_to_station(station_id)


func _open_pause_settings() -> void:
	if not is_instance_valid(_pause_settings_panel):
		return
	_pause_settings_panel.open_panel()


func _on_pause_settings_closed() -> void:
	if is_instance_valid(_pause_settings_panel):
		_pause_settings_panel.visible = false
	var resume := _pause_layer.get_node_or_null("PanelContainer/VBoxContainer/HBoxContainer/ResumeButton") as Button
	if resume:
		resume.grab_focus.call_deferred()


func _mark_scalable_text(control: Control, base_font_size: int) -> void:
	control.add_to_group("gs_scalable_text")
	control.set_meta("gs_base_font_size", base_font_size)
	control.set_meta("gs_font_property", "font_size")


func _configure_pause_focus() -> void:
	if not is_instance_valid(_pause_layer):
		return
	var action_buttons: Array[Button] = []
	for child in _pause_layer.get_node("PanelContainer/VBoxContainer/HBoxContainer").get_children():
		if child is Button:
			action_buttons.append(child as Button)
	var grid_buttons: Array[Button] = []
	if is_instance_valid(_station_grid):
		for child in _station_grid.get_children():
			if child is Button:
				grid_buttons.append(child as Button)
	var linear_buttons: Array[Button] = []
	linear_buttons.append_array(action_buttons)
	linear_buttons.append_array(grid_buttons)
	if linear_buttons.is_empty():
		return
	for index in range(linear_buttons.size()):
		var current := linear_buttons[index]
		var previous := linear_buttons[(index - 1 + linear_buttons.size()) % linear_buttons.size()]
		var next := linear_buttons[(index + 1) % linear_buttons.size()]
		current.focus_neighbor_top = previous.get_path()
		current.focus_neighbor_bottom = next.get_path()
	for index in range(grid_buttons.size()):
		var button := grid_buttons[index]
		var column := index % _station_grid.columns
		var row_start := index - column
		var left_index := row_start + ((column - 1 + _station_grid.columns) % _station_grid.columns)
		var right_index := row_start + ((column + 1) % _station_grid.columns)
		if left_index < grid_buttons.size():
			button.focus_neighbor_left = grid_buttons[left_index].get_path()
		if right_index < grid_buttons.size():
			button.focus_neighbor_right = grid_buttons[right_index].get_path()
		if index - _station_grid.columns >= 0:
			button.focus_neighbor_top = grid_buttons[index - _station_grid.columns].get_path()
		if index + _station_grid.columns < grid_buttons.size():
			button.focus_neighbor_bottom = grid_buttons[index + _station_grid.columns].get_path()


func _install_threshold(node: Node) -> void:
	if node == null or not is_instance_valid(node):
		return
	ThresholdBinder.install(node)


func _observe_campaign_station(node: Node) -> void:
	if not node is Node2D:
		return
	var station_id := _station_id_from_node(node)
	if station_id.is_empty():
		return
	if not _is_known_campaign_id(station_id):
		return
	if ThresholdBinder.is_route_station(station_id):
		_install_threshold.call_deferred(node)
		preload("res://scripts/campaign/gap_ledger.gd").ensure_exit_open.call_deferred(node)
	if node.has_signal(&"level_completed"):
		var completion_callback := _on_campaign_station_completed.bind(station_id, node)
		if not node.is_connected(&"level_completed", completion_callback):
			node.connect(&"level_completed", completion_callback)
	if node.has_signal(&"previous_level_requested"):
		var backtrack_callback := _on_campaign_previous_level_requested.bind(station_id)
		if not node.is_connected(&"previous_level_requested", backtrack_callback):
			node.connect(&"previous_level_requested", backtrack_callback)
		_ensure_return_zone(node, station_id)
	if (station_id == &"station_41" or station_id == &"station_18") and node.has_signal(&"operation_selected"):
		var operation_callback := _on_campaign_operation_selected.bind(station_id)
		if not node.is_connected(&"operation_selected", operation_callback):
			node.connect(&"operation_selected", operation_callback)
	
	# Handle bidirectional player spawn positioning
	if target_spawn_side == &"right":
		_apply_spawn_side_deferred.call_deferred(node, target_spawn_side)
		target_spawn_side = &"left"
	elif _restore_saved_position and station_id == last_checkpoint_station:
		_apply_checkpoint_position_deferred.call_deferred(node)
		_restore_saved_position = false


func _apply_spawn_side_deferred(node: Node, side: StringName) -> void:
	if not is_instance_valid(node):
		return
	if side != &"right":
		return
	if node.has_method("unlock_turnstile"):
		node.call("unlock_turnstile")
	if node.has_method("unlock_security_door"):
		node.call("unlock_security_door")
	if node.has_method("unlock_exit_door"):
		node.call("unlock_exit_door")
	if node.has_method("unlock_chamber_door"):
		node.call("unlock_chamber_door")
	if node.has_method("unlock_exit_for_return"):
		node.call("unlock_exit_for_return")
	var player := node.get_node_or_null("Player") as PrototypePlayer
	if player == null or not player.is_inside_tree():
		return
	var spawn_y := player.global_position.y
	var spawn_x := 560.0
	for _i in 16:
		player.reset_to(Vector2(spawn_x, spawn_y))
		if not player.test_move(player.global_transform, Vector2.ZERO):
			break
		spawn_x -= 18.0
	if player.visual_rig:
		player.visual_rig.set_facing(-1.0)


func _apply_checkpoint_position_deferred(node: Node) -> void:
	if not is_instance_valid(node):
		return
	if last_checkpoint_position == Vector2.ZERO:
		return
	var player := node.get_node_or_null("Player") as PrototypePlayer
	if player == null or not player.is_inside_tree():
		return
	player.reset_to(last_checkpoint_position)


func _ensure_return_zone(station_node: Node, station_id: StringName) -> void:
	if station_id == &"station_01":
		return
	if station_node.get_node_or_null("ReturnZone") != null:
		return
	var zone_script := load("res://scripts/environment/return_zone.gd") as GDScript
	var zone: Area2D = zone_script.new()
	zone.name = "ReturnZone"
	station_node.add_child(zone)

func _on_campaign_previous_level_requested(station_id: StringName) -> void:
	var prev_station := get_previous_campaign_station(station_id)
	if not prev_station.is_empty():
		mark_station_reached(prev_station)
		if campaign_auto_transition_enabled:
			transition_to_station_bidirectional(prev_station, &"right")


func _on_campaign_station_completed(station_id: StringName, source_node: Node) -> void:
	if station_id == &"station_41" and source_node != null:
		var chosen_operation := String(source_node.get("chosen_operation"))
		if get_selected_finale_id().is_empty() and not chosen_operation.is_empty():
			select_finale_operation(chosen_operation)
	elif station_id == &"station_18" and source_node != null:
		var committed_method := String(source_node.get("committed_method"))
		if get_selected_finale_id().is_empty() and not committed_method.is_empty():
			select_finale_method(committed_method)
	complete_station(station_id, campaign_auto_transition_enabled)


func _on_campaign_operation_selected(operation: String, _station_id: StringName) -> void:
	select_finale_operation(operation)


func _station_id_from_node(node: Node) -> StringName:
	var suffix := String(node.name).trim_prefix("Station").to_lower()
	if suffix.is_valid_int():
		return StringName("station_%02d" % suffix.to_int())
	if suffix in ["42a", "42b", "42c"]:
		return StringName("station_" + suffix)
	return &""


func _normalize_station_id(station_id: StringName) -> StringName:
	var normalized := String(station_id).to_lower()
	if normalized.begins_with("station") and not normalized.begins_with("station_"):
		normalized = "station_" + normalized.trim_prefix("station")
	if normalized.begins_with("station_"):
		var suffix := normalized.trim_prefix("station_")
		if suffix.is_valid_int():
			return StringName("station_%02d" % suffix.to_int())
		if suffix in ["42a", "42b", "42c", "43"]:
			return StringName(normalized)
	return &""


func _is_known_campaign_id(station_id: StringName) -> bool:
	return station_id in CAMPAIGN_ROUTE or station_id in CAMPAIGN_FINALES or station_id == CAMPAIGN_EPILOGUE or station_id in CAMPAIGN_LEGACY_STATIONS


func _can_enter_station(station_id: StringName) -> bool:
	if station_id == &"station_01":
		return true
	return has_reached_station(station_id)


func _get_decision(decision_id: StringName, fallback: Variant) -> Variant:
	if decisions.has(decision_id):
		return decisions[decision_id]
	var string_id := String(decision_id)
	if decisions.has(string_id):
		return decisions[string_id]
	return fallback
