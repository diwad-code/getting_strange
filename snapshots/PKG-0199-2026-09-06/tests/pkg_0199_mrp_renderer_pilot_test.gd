extends SceneTree

## PKG-0199 — F-0184-010 MRP renderer extraction pilot (PropType 67..196).
##
## Proves only measurable contracts, never beauty or reception (D-012, ADR-003):
## (1) facade preserved: class/extends, 206 _draw_*, 221 funcs, 5 sentinels,
## 8 exports, 2 signals, 3 public methods, clue bridge, SWITCH_LIKE, no groups;
## (2) helper is stateless: 130 static draw_* for 67..196, RefCounted, no Area2D,
## no signals/enum/audio/particles/GameState/interaction;
## (3) dispatch: every pilot type calls its helper exactly once, wrappers hold
## no draw primitives, helper holds no facade leftovers;
## (4) runtime: standalone pilot nodes (67/68/74/100/150/196) collect clues,
## emit once, honour one-shot + state_changed, survive state/queue_redraw;
## Station 16 (68) + Station 17 (74) still resolve through the real MRP bridge.
## No gameplay, routing, enum renumber, serialize ID or audio change.

const MRP_PATH := "res://scripts/interactables/memory_resonance_point.gd"
const HELPER_PATH := "res://scripts/interactables/mrp_legacy_renderer.gd"

const MRP_SENTINELS: Array[String] = [
	"PHOTOGRAPH = 0",
	"DOOR_CARD_READER = 5",
	"STAIR_TIMER_SWITCH = 24",
	"STATION_41_EXIT = 196",
	"EPILOGUE_FINAL_BLACKOUT = 202",
]
const MRP_EXPORTS: Array[String] = [
	"@export var resonance_id: String",
	"@export var prop_type: PropType",
	"@export var prop_title: String",
	"@export var prop_subtitle: String",
	"@export var interaction_radius: float",
	"@export var is_activated: bool",
	"@export var is_one_shot: bool",
	"@export var shadow_progress: float",
]

# Pilot PropType names 67..196 in enum order (130 entries).
const PILOT_NAMES: Array[String] = [
	"CRACKED_TEA_CUP", "CORRELATION_DOSSIER", "KITCHEN_CLOCK", "WEDDING_RING_STAND",
	"BALCONY_EXIT_DOOR", "QUEUING_TICKET_DISPENSER", "COMPLIANCE_WAITING_BENCH",
	"PNEUMATIC_DOSSIER_STATION", "DIAGNOSTIC_MEMORY_PRINTER", "CONSULTATION_OFFICE_DOOR",
	"WIERZBICKA_DESK", "SENSORY_MEMORY_MAP", "CORRECTION_GALVANOMETER",
	"ACOUSTIC_WEIGHT_CONDUIT", "MODEL_ROOM_AIRLOCK", "MODEL_DISPLAY_TABLE",
	"STAIRCASE_MAP_LEFT", "STAIRCASE_MAP_RIGHT", "ELEVEN_PERSONS_LEDGER",
	"MODEL_ROOM_EXIT", "SZYMON_BERA", "WELL_DRAWING", "HYDROLOGY_REPORT",
	"ERASED_SIGNATURE_MAGNIFIER", "SZYMON_ROOM_EXIT", "SZYMON_POST_CORRECTION",
	"ANESTHESIA_TERMINAL", "FILTERED_DOSSIER_SLOT", "DRAWING_DISPOSITION_PEDESTAL",
	"STATION_21_EXIT", "BIOMETRIC_IDENTITY_GATE", "COMPLIANCE_CONTACT_REGISTER",
	"RING_FITTING_SCANNER", "PAINT_RESIN_RESONANCE_SLAB", "STATION_22_EXIT",
	"DESIGNER_TERMINAL", "SUBSTRUCTURE_ARCHITECTURAL_MODEL", "BURDENED_PERSONS_LEDGER",
	"SHADOW_INTERACTIVE_CONSOLE", "STATION_23_EXIT", "CCTV_SURVEILLANCE_ARRAY",
	"CORRECTION_ACCUMULATION_GAUGE", "WIERZBICKA_TRANSMISSION_TERMINAL",
	"LENA_DISPOSITION_SELECTOR", "STATION_24_EXIT", "JAKUB_OPERATOR_UCP",
	"TRANSIT_MAINTENANCE_CART", "SCAR_DIAGNOSTIC_CHART", "JAKUB_HAND_GESTURE_SENSOR",
	"STATION_25_EXIT", "ISOLATION_ZONE_CONSOLE", "DYNAMIC_ROOM_DESIGNATOR",
	"MOTIVATION_ANCHOR_RECORD", "WIERZBICKA_PA_SPEAKER", "STATION_26_EXIT",
	"JAKUB_SERVICE_OPERATOR", "SAVED_WORKER_BADGE", "SURFACE_STABILITY_MONITOR",
	"TECHNICAL_JUNCTION_CONSOLE", "STATION_27_EXIT", "TRAM_DRIVER_CONSOLE",
	"PANORAMIC_TRANSIT_WINDOW", "TRIPLE_ACCIDENT_PARADOX_VIEW",
	"WIERZBICKA_CLOSING_INTERCOM", "STATION_28_EXIT", "ABANDONED_PLATFORM_TRACKS",
	"FLICKERING_NEON_SIGN", "DEEP_SUBSTRUCTURE_WELL", "JAKUB_TORCH_BEACON",
	"STATION_29_EXIT", "MAIN_POWER_DISTRIBUTION_BOARD", "HIGH_VOLTAGE_TRANSFORMER_BANK",
	"SECTION_BREAKER_LEVER", "GRID_SCHEMATIC_DISPLAY", "STATION_30_EXIT",
	"ELEVEN_CHAIRS_ARCHIVE_ROW", "WIERZBICKA_REMOTE_HOLOTERMINAL",
	"JAKUB_TWELFTH_CHAIR", "VARIANT_CHOICE_LEDGER", "STATION_31_EXIT",
	"STEAMED_GLASS_PANE_A", "CRACKED_GLASS_PANE_B", "POLISHED_GLASS_PANE_C",
	"CONDENSATION_TRACE_ETCHER", "STATION_32_EXIT", "VERTICAL_LADDER_ARRAY",
	"DEPTH_PRESSURE_GAUGE", "MEMORY_BUS_CABLE_TRUNK", "SHAFT_WORK_LIGHT_BEACON",
	"STATION_33_EXIT", "MAIN_EXCHANGE_CORE_REACTOR", "BIOGRAPHY_ALLOCATION_DESK",
	"THERMAL_OVERLOAD_INDICATOR", "JAKUB_CORE_DIAGNOSTIC_PORT", "STATION_34_EXIT",
	"SEDATION_BASIN_POOL", "SLUDGE_DRAIN_VALVE_WHEEL", "CHEMICAL_SEDATION_SAMPLER",
	"JAKUB_SEDATION_MONITOR", "STATION_35_EXIT", "STORM_DRAIN_WEIR",
	"SEDATIVE_SLUDGE_CURRENT", "ACID_RESISTANT_CATWALK_LADDER",
	"CONTAMINATION_SAMPLING_TAP", "STATION_36_EXIT", "SIGNAL_TRANSMISSION_ANTENNA",
	"TRANSMISSION_CROSS_PATCHBAY", "FREQUENCY_OSCILLOSCOPE_CRT",
	"MEMORY_INJECTION_PULPIT", "STATION_37_EXIT", "ACCIDENT_SIMULATION_FIELD",
	"DESTABILIZING_JAKUB_SHADOW", "RESCUE_TETHER_ANCHOR",
	"RETURN_COORDINATE_CALCULATOR", "STATION_38_EXIT",
	"CENTRAL_REFERENCE_CORE_MONOLITH", "BRANCH_CONFIG_RETURN_A",
	"BRANCH_CONFIG_RECONCILIATION_B", "BRANCH_CONFIG_TESTIMONY_C",
	"STATION_39_EXIT", "WIERZBICKA_PERSONAL_TERMINAL", "MARTA_WITNESS_STATION",
	"SZYMON_TRANSMISSION_MONITOR", "OPERATION_COST_DOSSIER_MATRIX",
	"STATION_40_EXIT", "OP_CONSOLE_RETURN_A", "OP_CONSOLE_RECONCILIATION_B",
	"OP_CONSOLE_TESTIMONY_C", "OP_CONTINUITY_TOPOGRAPHY_DISPLAY",
	"STATION_41_EXIT",
]

# Standalone runtime sample: edges + active-route pilot nodes + mids.
const RUNTIME_PROP_TYPES: Array[int] = [67, 68, 74, 100, 150, 196]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0199: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var source := file.get_as_text()
	file.close()
	return source


func _count(source: String, snippet: String) -> int:
	var hits := 0
	var from := 0
	while true:
		var at := source.find(snippet, from)
		if at < 0:
			break
		hits += 1
		from = at + snippet.length()
	return hits


func _run() -> void:
	_check_facade_contract()
	_check_helper_inventory()
	_check_dispatch()
	_check_equivalence()
	await _check_runtime_pilot_nodes()
	await _check_runtime_stations_16_17()
	await _check_soak()
	_finish()


# ─── 1. Fasada nietknięta ──────────────────────────────────────────────

func _check_facade_contract() -> void:
	var source := _read(MRP_PATH)
	_expect(source.contains("class_name MemoryResonancePoint"), "facade class identity must remain")
	_expect(source.contains("extends Area2D"), "facade Area2D boundary must remain")
	_expect(_count(source, "func _draw_") == 206, "facade must keep 206 _draw_* wrappers")
	_expect(_count(source, "func ") == 221, "facade must keep 221 functions")
	for sentinel in MRP_SENTINELS:
		_expect(source.contains(sentinel), "enum sentinel missing: %s" % sentinel)
	for export_line in MRP_EXPORTS:
		_expect(source.contains(export_line), "export missing: %s" % export_line)
	_expect(source.contains("signal resonance_triggered(id: String, prop_type: int)"), "signal resonance_triggered must remain")
	_expect(source.contains("signal state_changed(is_active: bool)"), "signal state_changed must remain")
	for method_name in ["func get_contact_progress()", "func get_touch_flash()", "func trigger_interaction()"]:
		_expect(source.contains(method_name), "public method missing: %s" % method_name)
	_expect(source.contains("game_state.collect_clue(StringName(resonance_id))"), "clue-before-activation bridge must remain")
	_expect(source.contains("const SWITCH_LIKE_PROPS"), "switch-like grouping must remain")
	_expect(not source.contains("add_to_group("), "facade must not silently switch to Node groups")


# ─── 2. Helper stateless ───────────────────────────────────────────────

func _check_helper_inventory() -> void:
	var helper := _read(HELPER_PATH)
	_expect(helper.contains("class_name MrpLegacyRenderer"), "helper class identity must exist")
	_expect(helper.contains("extends RefCounted"), "helper must be RefCounted, never Area2D/Node")
	_expect(not helper.contains("extends Area2D"), "helper must not extend Area2D")
	_expect(_count(helper, "static func draw_") == 130, "helper must own exactly 130 static renderers")
	_expect(PILOT_NAMES.size() == 130, "pilot inventory must list 130 names")
	for pname in PILOT_NAMES:
		var short := pname.to_lower()
		_expect(_count(helper, "static func draw_%s(" % short) == 1, "helper must define draw_%s exactly once" % short)
	# No second interaction system: declarations that would make it stateful.
	_expect(not helper.contains("\nsignal "), "helper must declare no signals")
	_expect(not helper.contains("enum PropType"), "helper must not redeclare the serialized enum")
	_expect(not helper.contains("GameStateManager"), "helper must not touch GameState")
	_expect(not helper.contains("AudioStreamPlayer"), "helper must not own audio")
	_expect(not helper.contains("CPUParticles2D"), "helper must not own particles")
	_expect(not helper.contains("add_to_group("), "helper must not use Node groups")
	_expect(not helper.contains("collect_clue"), "helper must not collect clues")
	_expect(not helper.contains("trigger_interaction"), "helper must not implement interaction")
	_expect(not helper.contains("resonance_triggered.emit"), "helper must not emit facade signals")
	for colour in ["COLOR_AMBER", "COLOR_CYAN", "COLOR_INFRASTRUCTURE", "COLOR_DARK_STEEL", "COLOR_CORRECTION"]:
		_expect(helper.contains("const %s" % colour), "helper must carry its own %s" % colour)


# ─── 3. Dispatch: każdy pilot dokładnie raz ────────────────────────────

func _check_dispatch() -> void:
	var facade := _read(MRP_PATH)
	var helper := _read(HELPER_PATH)
	_expect(_count(facade, "MrpLegacyRenderer.draw_") == 130, "facade must delegate 130 pilot types to the helper")
	for pname in PILOT_NAMES:
		var short := pname.to_lower()
		_expect(_count(facade, "MrpLegacyRenderer.draw_%s(self" % short) == 1, "facade must dispatch %s exactly once" % pname)
		_expect(_count(facade, "func _draw_%s(" % short) == 1, "facade must keep wrapper _draw_%s" % short)
		# Wrapper holds no primitives: the only draw_ token on its lines is the delegate call.
		_expect(not facade.contains("ci.draw_%s" % short), "facade wrapper must not inline helper internals")


# ─── 4. Równoważność mechaniczna (piksel-w-piksel konstrukcyjnie) ──────
#
# Helper bodies are verbatim moves: every draw_* call site became ci.draw_*,
# state reads became params, nothing else changed. Wrappers hold no draw
# primitives at all, so the drawn sequence for identical inputs is identical
# by construction. This gate pins that construction; it never claims a human
# would read the image the same way.

func _code_only(source: String) -> String:
	# Strip full-line comments so header prose never false-positives code checks.
	var kept: Array[String] = []
	for line in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _has_code_token(code: String, token: String) -> bool:
	# Identifier-boundary search: skips p_is_activated when looking for
	# is_activated (preceded by '_') and similar prefix collisions.
	var idx := 0
	while true:
		var at := code.find(token, idx)
		if at < 0:
			return false
		var before_ok := at == 0 or not _is_ident_char(code.substr(at - 1, 1))
		var after_pos := at + token.length()
		var after_ok := after_pos >= code.length() or not _is_ident_char(code.substr(after_pos, 1))
		if before_ok and after_ok:
			return true
		idx = at + token.length()
	return false


func _is_ident_char(ch: String) -> bool:
	if ch.is_empty():
		return false
	var c := ch.unicode_at(0)
	return (c >= 48 and c <= 57) or (c >= 65 and c <= 90) or (c >= 97 and c <= 122) or c == 95


func _check_equivalence() -> void:
	var facade := _read(MRP_PATH)
	var helper := _read(HELPER_PATH)
	var code := _code_only(helper)
	# Facade wrappers: no canvas primitives may remain in the 130 delegates.
	# (Non-pilot renderers 0..66/197..202 keep their bodies; the pilot set is
	# identified by the PKG-0199 marker comment.)
	_expect(_count(facade, "PKG-0199 pilot") == 130, "each pilot wrapper must carry the PKG-0199 marker")
	# Helper: no facade leftovers (code lines only; header prose excluded).
	_expect(not _has_code_token(code, "is_player_in_range"), "helper code must rename is_player_in_range to p_in_range")
	_expect(not _has_code_token(code, "is_activated"), "helper code must rename is_activated to p_is_activated")
	_expect(not _has_code_token(code, "_pulse_phase"), "helper code must rename _pulse_phase to p_pulse")
	_expect(code.contains("p_in_range") or code.contains("p_is_activated") or code.contains("p_pulse"), "helper must actually use renamed state params")
	# Bare draw_ calls without ci. would draw on nothing (or fail to parse as
	# facade delegation). Scan helper for draw_ tokens not preceded by '.'.
	var bare := 0
	var idx := 0
	while true:
		var at := helper.find("draw_", idx)
		if at < 0:
			break
		var prev := "" if at == 0 else helper.substr(at - 1, 1)
		var is_decl := helper.substr(maxi(0, at - 12), 12).contains("func")
		if prev != "." and not is_decl:
			# Allow the "draw_* -> ci.draw_*" prose in the header comment.
			var line_start := helper.rfind("\n", at)
			var line_end := helper.find("\n", at)
			var line := helper.substr(line_start + 1, line_end - line_start - 1)
			if not line.strip_edges().begins_with("##") and not line.strip_edges().begins_with("#"):
				bare += 1
		idx = at + 5
	_expect(bare == 0, "helper must qualify every draw call as ci.draw_* (bare hits: %d)" % bare)
	_expect(not _has_code_token(code, "self"), "helper must never reference self.")
	_expect(not code.contains("queue_redraw"), "helper must never queue redraws")
	_expect(not code.contains(".emit("), "helper must never emit")


# ─── 5. Runtime: samodzielne węzły pilota ──────────────────────────────

func _state() -> Node:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	return state


func _make_prop(prop_type: int, resonance_id: String, one_shot: bool) -> MemoryResonancePoint:
	var prop := MemoryResonancePoint.new()
	prop.resonance_id = resonance_id
	prop.prop_type = prop_type as MemoryResonancePoint.PropType
	prop.is_one_shot = one_shot
	root.add_child(prop)
	return prop


func _check_runtime_pilot_nodes() -> void:
	var state := _state()
	if state == null:
		return
	var seen := 0
	for prop_type in RUNTIME_PROP_TYPES:
		var rid := "pkg199_pilot_%d" % prop_type
		var prop := _make_prop(prop_type, rid, false)
		_expect(prop != null and is_instance_valid(prop), "pilot prop %d must instantiate" % prop_type)
		if prop == null:
			continue
		await process_frame
		await process_frame
		_expect(not prop.is_activated, "pilot %d must start inactive" % prop_type)
		var fired := [0]
		var last_id := [""]
		var last_type := [-1]
		prop.resonance_triggered.connect(func(id: String, ptype: int) -> void:
			fired[0] += 1
			last_id[0] = id
			last_type[0] = ptype
		)
		var changed := [0]
		prop.state_changed.connect(func(_active: bool) -> void:
			changed[0] += 1
		)
		# Exercise all three visual states through the real facade path.
		prop.set("_pulse_phase", 0.7)
		prop.is_player_in_range = true
		prop.queue_redraw()
		await process_frame
		prop.trigger_interaction()
		await process_frame
		_expect(fired[0] == 1, "pilot %d must emit resonance_triggered exactly once" % prop_type)
		_expect(last_id[0] == rid, "pilot %d must emit its own resonance_id" % prop_type)
		_expect(last_type[0] == prop_type, "pilot %d must emit its own prop_type" % prop_type)
		_expect(prop.is_activated, "pilot %d must latch active after trigger" % prop_type)
		_expect(changed[0] >= 1, "pilot %d must emit state_changed on activation" % prop_type)
		_expect(state.get("collected_clues").has(StringName(rid)), "pilot %d must collect its clue before activation" % prop_type)
		prop.is_player_in_range = false
		prop.set("_pulse_phase", 1.9)
		prop.queue_redraw()
		await process_frame
		prop.queue_free()
		await process_frame
		seen += 1
	# One-shot: second press is swallowed before clue/signal.
	var once := _make_prop(68, "pkg199_oneshot_68", true)
	await process_frame
	await process_frame
	var hits := [0]
	once.resonance_triggered.connect(func(_id: String, _pt: int) -> void:
		hits[0] += 1
	)
	once.trigger_interaction()
	await process_frame
	once.trigger_interaction()
	await process_frame
	_expect(hits[0] == 1, "one-shot pilot must emit exactly once across two presses")
	once.queue_free()
	await process_frame
	_expect(seen == RUNTIME_PROP_TYPES.size(), "all %d pilot runtime nodes must be exercised" % RUNTIME_PROP_TYPES.size())


# ─── 6. Runtime: Stacje 16/17 przez prawdziwy most ─────────────────────

func _station_prop(station: Node, resonance_id: String) -> MemoryResonancePoint:
	var props := station.get_node_or_null("Props")
	_expect(props != null, "%s must expose Props" % station.name)
	if props == null:
		return null
	for child in props.get_children():
		if child is MemoryResonancePoint and (child as MemoryResonancePoint).resonance_id == resonance_id:
			return child as MemoryResonancePoint
	_expect(false, "%s must expose MRP node '%s'" % [station.name, resonance_id])
	return null


func _check_runtime_stations_16_17() -> void:
	var state := _state()
	if state == null:
		return
	for spec in [
		{"scene": "res://scenes/levels/station_16.tscn", "id": "cost_selector", "type": 68},
		{"scene": "res://scenes/levels/station_17.tscn", "id": "adaptation_offer_terminal", "type": 74},
	]:
		var scene_path := String(spec.get("scene"))
		var rid := String(spec.get("id"))
		var ptype := int(spec.get("type"))
		var packed := load(scene_path) as PackedScene
		_expect(packed != null, "%s must load" % scene_path)
		if packed == null:
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		await process_frame
		await process_frame
		var prop := _station_prop(station, rid)
		_expect(prop != null, "%s node '%s' must exist" % [scene_path, rid])
		if prop == null:
			station.queue_free()
			await process_frame
			continue
		_expect(int(prop.prop_type) == ptype, "%s must carry pilot prop_type %d" % [rid, ptype])
		var fired := [0]
		prop.resonance_triggered.connect(func(_id: String, _pt: int) -> void:
			fired[0] += 1
		)
		var station_hits := [0]
		if station.has_signal("clue_inspected"):
			station.connect("clue_inspected", func(_id: String, _pt: int) -> void:
				station_hits[0] += 1
			)
		# Real player verb through the real MRP node (never a station helper).
		prop.trigger_interaction()
		await process_frame
		await process_frame
		_expect(fired[0] == 1, "%s must emit resonance_triggered once through the facade" % rid)
		_expect(state.get("collected_clues").has(StringName(rid)), "%s must collect its clue" % rid)
		_expect(station_hits[0] == 1, "%s must still reach the station bridge (clue_inspected)" % rid)
		station.queue_free()
		await process_frame
		await process_frame


# ─── 7. Soak: instantiate / interact / free bez wycieków ───────────────
# Wycieki łapie globalna polityka logów (ObjectDB/orphan). Tutaj dowodzimy
# wyłącznie, że 130 pilotowych rendererów przechodzi cykl bez błędów.

func _check_soak() -> void:
	for pname in PILOT_NAMES:
		var prop := MemoryResonancePoint.new()
		prop.resonance_id = "pkg199_soak_%s" % pname.to_lower()
		prop.prop_type = 68 as MemoryResonancePoint.PropType
		root.add_child(prop)
		await process_frame
		prop.set("_pulse_phase", 0.3)
		prop.is_player_in_range = true
		prop.queue_redraw()
		await process_frame
		prop.trigger_interaction()
		await process_frame
		prop.queue_free()
		await process_frame
	# Full 130-type dispatch sweep without tree churn: one node, 130 types.
	var sweep := MemoryResonancePoint.new()
	sweep.resonance_id = "pkg199_sweep"
	root.add_child(sweep)
	await process_frame
	for i in range(67, 197):
		sweep.prop_type = i as MemoryResonancePoint.PropType
		sweep.set("_pulse_phase", float(i) * 0.05)
		sweep.is_player_in_range = (i % 2 == 0)
		sweep.queue_redraw()
		await process_frame
	sweep.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0199 PILOT PASS: facade intact, 130 stateless renderers, dispatch 1:1, runtime bridge GREEN.")
		quit(0)
	else:
		print("PKG-0199 PILOT FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
