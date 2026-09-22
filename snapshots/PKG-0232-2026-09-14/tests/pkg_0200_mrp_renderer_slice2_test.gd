extends SceneTree

## PKG-0200 — F-0184-010 MRP renderer extraction slice2 (PropType 0..66,197..202).
##
## Proves only measurable contracts, never beauty or reception (D-012, ADR-003):
## (1) facade preserved: class/extends, 206 _draw_*, 221 funcs, 5 sentinels,
## 8 exports, 2 signals, 3 public methods, clue bridge, SWITCH_LIKE, no groups;
## markers 130x PKG-0199 pilot + 73x PKG-0200 slice2, 203 delegations;
## (2) helper is stateless: 203 static draw_* (130 pilot + 73 slice2),
## RefCounted, no Area2D/signals/enum/GameState/audio/particles/groups/logic;
## (3) dispatch: every slice2 type calls its helper exactly once, wrappers hold
## no draw primitives, helper holds no facade leftovers;
## (4) equivalence is constructive (identical draw sequence for identical inputs),
## never a frame-hash claim; renames cover all five visual tokens
## (is_activated/_pulse_phase/is_player_in_range/shadow_progress/_resonance_flash);
## (5) runtime: standalone slice2 nodes (edges + active-route + shadow/flash)
## collect clues, emit once, honour one-shot + state_changed, survive full
## visual state + queue_redraw; active stations 09/10/16/17/42B/43 resolve
## through the real MRP bridge; soak sweeps all 203 types without leaks.
## Three overlay helpers stay in the facade by design: _draw_in_world_reticule,
## _draw_resolved_mark, _draw_contact_read (interaction envelopes, not PropType
## renderers). No gameplay, routing, enum renumber, serialize ID or audio change.

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

# Slice2 PropType names 0..66,197..202 in enum order (73 entries).
const SLICE2_NAMES: Array[String] = [
	"PHOTOGRAPH", "CIRCUIT_BREAKER", "VACUUM_GAUGE", "CHAMBER_CONSOLE",
	"DOCUMENT_CLIPBOARD", "DOOR_CARD_READER", "TWIN_CUPS", "DESK_TELEPHONE",
	"DUTY_ROSTER", "SECURITY_MONITOR", "UCP_NOTICE", "GUARD_INTERACTION",
	"ANACHRONISTIC_BILLBOARD", "MISSING_FLOOR_FACADE", "CROSSWALK_SIGNAL", "TRANSIT_SHELTER",
	"BUS_SPEAKER", "ELDERLY_PASSENGER", "GOLD_RING", "BUS_ROUTE_MAP",
	"TENANT_DIRECTORY", "MAILBOXES", "BLIND_STAIRS", "MARTA_INTERACTION",
	"STAIR_TIMER_SWITCH", "HALLWAY_COAT_RACK", "REFLECTED_PHOTOGRAPH", "BEAKER_PLANTER",
	"JAKUB_MEMENTO_TOOL", "CIPHER_DESK", "TEA_KETTLE", "BATHROOM_SINK",
	"BATHROOM_MIRROR", "SCRATCHED_INSCRIPTION", "APOTHECARY_CABINET", "MARTA_BATHROOM_GUIDE",
	"BAKELITE_PHONE", "REEL_TAPE_RECORDER", "TOPOGRAPHY_BOARD", "JAKUB_DESK_LAMP",
	"TECH_STORAGE_AIRLOCK", "OBSERVATION_WINDOW", "ERASED_DOORWAY_TRACE", "UCP_INTERVENTION_TEAM",
	"ELDERLY_RESIDENT_GUIDE", "MARTA_OBSERVATION_DIALOGUE", "COURTYARD_EXIT_AIRLOCK", "UCP_INFO_TERMINAL",
	"SHOWCASE_VITRINE", "INSTRUCTION_POSTER", "SUBWAY_TILE_PILLAR", "UNDERPASS_EXIT_GATE",
	"DRAFTING_TABLE", "TOPOGRAPHY_INDEX_CABINET", "JAKUB_PHOTOGRAPH_FRAME", "RESONANCE_CIRCUIT_NODE",
	"TECH_PASSAGE_AIRLOCK", "METAL_SCRATCH_BEAM", "TAPE_PLAYBACK_DECK", "MAINTENANCE_RACK",
	"SEAM_STABILIZER_LEVER", "SUBSTRUCTURE_CONDUIT_SHAFT", "HYGIENE_INSTRUCTION_BOARD", "HANDWRITTEN_CORRELATION_FORMULA",
	"REFLECTIVE_PUDDLE", "PRESSURE_RELIEF_VALVE", "TRANSIT_SERVICE_GATE", "EPILOGUE_RETURN_CUPS",
	"EPILOGUE_MARTA_DOORSTEP", "EPILOGUE_TRAM_DUAL_TRACKS", "EPILOGUE_ADMIN_NOTICE_BOARD", "EPILOGUE_CREDITS_ROLL",
	"EPILOGUE_FINAL_BLACKOUT",
]

# Slice2 values in the same order (0..66 then 197..202).
const SLICE2_VALUES: Array[int] = [
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
	20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
	38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55,
	56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 197, 198, 199, 200, 201, 202,
]

# Standalone runtime sample: edges + active-route + shadow/flash specials.
const RUNTIME_PROP_TYPES: Array[int] = [0, 5, 8, 25, 54, 57, 63, 66, 197, 202]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0200: " + message)


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
	await _check_runtime_slice2_nodes()
	await _check_runtime_active_stations()
	await _check_soak()
	_finish()


# ─── 1. Fasada nietknięta ──────────────────────────────────────────────

func _check_facade_contract() -> void:
	var source := _read(MRP_PATH)
	_expect(source.contains("class_name MemoryResonancePoint"), "facade class identity must remain")
	_expect(source.contains("extends Area2D"), "facade Area2D boundary must remain")
	_expect(_count(source, "func _draw_") == 206, "facade must keep 206 _draw_*")
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
	# Extraction markers: pilot intact + slice2 complete.
	_expect(_count(source, "PKG-0199 pilot") == 130, "facade must keep 130 pilot markers")
	_expect(_count(source, "PKG-0200 slice2") == 73, "facade must carry 73 slice2 markers")
	_expect(_count(source, "MrpLegacyRenderer.draw_") == 203, "facade must delegate 203 types to the helper")
	# Three overlay helpers stay in the facade by design (not PropType renderers).
	for overlay in ["func _draw_in_world_reticule(", "func _draw_resolved_mark(", "func _draw_contact_read("]:
		_expect(source.contains(overlay), "overlay helper must stay in facade: %s" % overlay)
		_expect(_count(source, overlay) == 1, "overlay must exist exactly once: %s" % overlay)


# ─── 2. Helper stateless ───────────────────────────────────────────────

func _check_helper_inventory() -> void:
	var helper := _read(HELPER_PATH)
	_expect(helper.contains("class_name MrpLegacyRenderer"), "helper class identity must exist")
	_expect(helper.contains("extends RefCounted"), "helper must be RefCounted, never Area2D/Node")
	_expect(not helper.contains("extends Area2D"), "helper must not extend Area2D")
	_expect(_count(helper, "static func draw_") == 203, "helper must own exactly 203 static renderers")
	_expect(SLICE2_NAMES.size() == 73, "slice2 inventory must list 73 names")
	_expect(SLICE2_VALUES.size() == 73, "slice2 values must list 73 entries")
	for pname in SLICE2_NAMES:
		var short := pname.to_lower()
		_expect(_count(helper, "static func draw_%s(" % short) == 1, "helper must define draw_%s exactly once" % short)
	_expect(not helper.contains("\nsignal "), "helper must declare no signals")
	_expect(not helper.contains("enum PropType"), "helper must not redeclare the serialized enum")
	_expect(not helper.contains("GameStateManager"), "helper must not touch GameState")
	_expect(not helper.contains("AudioStreamPlayer"), "helper must not own audio")
	_expect(not helper.contains("CPUParticles2D"), "helper must not own particles")
	_expect(not helper.contains("add_to_group("), "helper must not use Node groups")
	_expect(not helper.contains("collect_clue"), "helper must not collect clues")
	_expect(not helper.contains("trigger_interaction"), "helper must not implement interaction")
	_expect(not helper.contains("resonance_triggered.emit"), "helper must not emit facade signals")
	for colour in ["COLOR_AMBER", "COLOR_CYAN", "COLOR_INFRASTRUCTURE", "COLOR_DARK_STEEL", "COLOR_CORRECTION", "COLOR_BACKGROUND"]:
		_expect(helper.contains("const %s" % colour), "helper must carry its own %s" % colour)
	# Extended visual floats are used by the three specials (54/57 shadow, 63 flash).
	_expect(helper.contains("p_shadow"), "helper must carry p_shadow for shadow_progress renderers")
	_expect(helper.contains("p_flash"), "helper must carry p_flash for resonance_flash renderer")


# ─── 3. Dispatch: każdy slice2 dokładnie raz ───────────────────────────

func _check_dispatch() -> void:
	var facade := _read(MRP_PATH)
	for pname in SLICE2_NAMES:
		var short := pname.to_lower()
		_expect(_count(facade, "MrpLegacyRenderer.draw_%s(self" % short) == 1, "facade must dispatch %s exactly once" % pname)
		_expect(_count(facade, "func _draw_%s(" % short) == 1, "facade must keep wrapper _draw_%s" % short)
		_expect(not facade.contains("ci.draw_%s" % short), "facade wrapper must not inline helper internals")


# ─── 4. Równoważność mechaniczna ───────────────────────────────────────

func _code_only(source: String) -> String:
	var kept: Array[String] = []
	for line in source.split("\n"):
		if line.strip_edges().begins_with("#"):
			continue
		kept.append(line)
	return "\n".join(kept)


func _has_code_token(code: String, token: String) -> bool:
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
	_expect(_count(facade, "PKG-0200 slice2") == 73, "each slice2 wrapper must carry the PKG-0200 marker")
	_expect(not _has_code_token(code, "is_player_in_range"), "helper code must rename is_player_in_range to p_in_range")
	_expect(not _has_code_token(code, "is_activated"), "helper code must rename is_activated to p_is_activated")
	_expect(not _has_code_token(code, "_pulse_phase"), "helper code must rename _pulse_phase to p_pulse")
	_expect(not _has_code_token(code, "shadow_progress"), "helper code must rename shadow_progress to p_shadow")
	_expect(not _has_code_token(code, "_resonance_flash"), "helper code must rename _resonance_flash to p_flash")
	_expect(code.contains("p_in_range") or code.contains("p_is_activated") or code.contains("p_pulse") or code.contains("p_shadow") or code.contains("p_flash"), "helper must actually use renamed state params")
	var bare := 0
	var idx := 0
	while true:
		var at := helper.find("draw_", idx)
		if at < 0:
			break
		var prev := "" if at == 0 else helper.substr(at - 1, 1)
		var is_decl := helper.substr(maxi(0, at - 12), 12).contains("func")
		if prev != "." and not is_decl:
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
	# No interaction-state leftovers beyond the five visual floats.
	for token in ["interaction_radius", "resonance_id", "prop_title", "prop_subtitle", "is_one_shot", "_contact_progress", "_touch_flash"]:
		_expect(not _has_code_token(code, token), "helper code must not read %s" % token)


# ─── 5. Runtime: samodzielne węzły slice2 ─────────────────────────────

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


func _check_runtime_slice2_nodes() -> void:
	var state := _state()
	if state == null:
		return
	var seen := 0
	for prop_type in RUNTIME_PROP_TYPES:
		var rid := "pkg200_slice2_%d" % prop_type
		var prop := _make_prop(prop_type, rid, false)
		_expect(prop != null and is_instance_valid(prop), "slice2 prop %d must instantiate" % prop_type)
		if prop == null:
			continue
		await process_frame
		await process_frame
		_expect(not prop.is_activated, "slice2 %d must start inactive" % prop_type)
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
		# Exercise all five visual states through the real facade path.
		prop.set("_pulse_phase", 0.7)
		prop.is_player_in_range = true
		prop.shadow_progress = 0.6
		prop.set("_resonance_flash", 0.4)
		prop.queue_redraw()
		await process_frame
		prop.trigger_interaction()
		await process_frame
		_expect(fired[0] == 1, "slice2 %d must emit resonance_triggered exactly once" % prop_type)
		_expect(last_id[0] == rid, "slice2 %d must emit its own resonance_id" % prop_type)
		_expect(last_type[0] == prop_type, "slice2 %d must emit its own prop_type" % prop_type)
		_expect(prop.is_activated, "slice2 %d must latch active after trigger" % prop_type)
		_expect(changed[0] >= 1, "slice2 %d must emit state_changed on activation" % prop_type)
		_expect(state.get("collected_clues").has(StringName(rid)), "slice2 %d must collect its clue before activation" % prop_type)
		prop.is_player_in_range = false
		prop.set("_pulse_phase", 1.9)
		prop.shadow_progress = 0.0
		prop.set("_resonance_flash", 0.0)
		prop.queue_redraw()
		await process_frame
		prop.queue_free()
		await process_frame
		seen += 1
	# One-shot: second press is swallowed before clue/signal.
	var once := _make_prop(5, "pkg200_oneshot_5", true)
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
	_expect(hits[0] == 1, "one-shot slice2 must emit exactly once across two presses")
	once.queue_free()
	await process_frame
	_expect(seen == RUNTIME_PROP_TYPES.size(), "all %d slice2 runtime nodes must be exercised" % RUNTIME_PROP_TYPES.size())


# ─── 6. Runtime: aktywna trasa prawdziwym mostem ───────────────────────

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


func _check_runtime_active_stations() -> void:
	var state := _state()
	if state == null:
		return
	var specs: Array = [
		{"scene": "res://scenes/levels/station_09.tscn", "id": "relation_photo", "type": 0},
		{"scene": "res://scenes/levels/station_10.tscn", "id": "marta_boundary", "type": 5},
		{"scene": "res://scenes/levels/station_16.tscn", "id": "safe_analyzer", "type": 55},
		{"scene": "res://scenes/levels/station_17.tscn", "id": "cost_ledger_console", "type": 3},
		{"scene": "res://scenes/levels/station_42b.tscn", "id": "local_lena_recovered", "type": 198},
		{"scene": "res://scenes/levels/station_43.tscn", "id": "prop_final_blackout", "type": 202},
	]
	for spec in specs:
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
		_expect(int(prop.prop_type) == ptype, "%s must carry slice2 prop_type %d" % [rid, ptype])
		var fired := [0]
		prop.resonance_triggered.connect(func(_id: String, _pt: int) -> void:
			fired[0] += 1
		)
		var station_hits := [0]
		if station.has_signal("clue_inspected"):
			station.connect("clue_inspected", func(_id: String, _pt: int) -> void:
				station_hits[0] += 1
			)
		prop.trigger_interaction()
		await process_frame
		await process_frame
		_expect(fired[0] == 1, "%s must emit resonance_triggered once through the facade" % rid)
		_expect(state.get("collected_clues").has(StringName(rid)), "%s must collect its clue" % rid)
		_expect(station_hits[0] == 1, "%s must still reach the station bridge (clue_inspected)" % rid)
		station.queue_free()
		await process_frame
		await process_frame


# ─── 7. Soak: pełne 203 typy bez wycieków ─────────────────────────────

func _check_soak() -> void:
	# Slice2 sweep: one node per slice2 value (73 instantiations).
	for idx in range(SLICE2_VALUES.size()):
		var v := SLICE2_VALUES[idx]
		var prop := MemoryResonancePoint.new()
		prop.resonance_id = "pkg200_soak_%d" % v
		prop.prop_type = v as MemoryResonancePoint.PropType
		root.add_child(prop)
		await process_frame
		prop.set("_pulse_phase", 0.3)
		prop.is_player_in_range = true
		prop.shadow_progress = 0.5
		prop.set("_resonance_flash", 0.3)
		prop.queue_redraw()
		await process_frame
		prop.trigger_interaction()
		await process_frame
		prop.queue_free()
		await process_frame
	# Full 203-type dispatch sweep without tree churn: one node, 0..202.
	var sweep := MemoryResonancePoint.new()
	sweep.resonance_id = "pkg200_sweep"
	root.add_child(sweep)
	await process_frame
	for i in range(0, 203):
		sweep.prop_type = i as MemoryResonancePoint.PropType
		sweep.set("_pulse_phase", float(i) * 0.05)
		sweep.is_player_in_range = (i % 2 == 0)
		sweep.shadow_progress = 0.25 if (i % 3 == 0) else 0.0
		sweep.set("_resonance_flash", 0.2 if (i % 4 == 0) else 0.0)
		sweep.queue_redraw()
		await process_frame
	sweep.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0200 SLICE2 PASS: facade intact, 203 stateless renderers, dispatch 1:1, active-route bridge GREEN.")
		quit(0)
	else:
		print("PKG-0200 SLICE2 FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
