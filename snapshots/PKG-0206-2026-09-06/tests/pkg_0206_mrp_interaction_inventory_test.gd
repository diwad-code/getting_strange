extends SceneTree

## PKG-0206 gate — inwentaryzacja interakcji/audio MRP poza rendererami
## (dlug F-0184-010, decyzja D-221: HOLD logiki, specyfikacja dwoch krokow).
##
## Pinuje wylacznie kontrakty mierzalne na dysku i runtime, nigdy slusznosc
## ekstrakcji ani odbior (D-012, ADR-003). Zero zmian w scripts/scenes:
## bramka czyta fasade i tworzy wlasne wezly. Wzor: PKG-0200 (kontrakt
## fasady + runtime prawdziwym mostem) i PKG-0205 (normalizacja CRLF,
## jawne typy, brak chr()).
##
## Fakty pinowane:
## (1) fasada: 221 funkcji, 206 _draw_*, sentinele, 8 exportow, 2 sygnaly,
## 3 metody publiczne, most clue-before-activation, SWITCH_LIKE 6 nazw,
## brak grup, markery 130x pilot + 73x slice2, delegacje 203;
## (2) trigger: 1x if CIRCUIT_BREAKER + 181x elif + else z _memory_sound
## (183 przypisania stream i pitch), 179x latch + 4x toggle z nazw,
## haptyka pierwsza (detent vs probe_brush), one-shot przed haptyka,
## 1x emit, flash/particles/redraw, PHOTOGRAPH fallback, SHOWCASE_VITRINE
## paper_rustle;
## (3) audio: match prop_type, 165 ramion PropType + fallback _:,
## 183 typy jawne (20 fallbackow), 173x ProceduralAudio.create_ w pliku
## (170 setup + 3 haptic cached), 3 dzwieki haptyczne;
## (4) runtime: wezly 0/1/48 zbieraja clue, emituja raz, latch/toggle,
## state_changed, 2 klatki bez bledow; one-shot typ 5 polyka drugi press.

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
const SWITCH_LIKE_NAMES: Array[String] = [
	"PropType.CIRCUIT_BREAKER",
	"PropType.JAKUB_DESK_LAMP",
	"PropType.STAIR_TIMER_SWITCH",
	"PropType.SEAM_STABILIZER_LEVER",
	"PropType.PRESSURE_RELIEF_VALVE",
	"PropType.DOOR_CARD_READER",
]
const TOGGLE_NAMES: Array[String] = [
	"PropType.CIRCUIT_BREAKER",
	"PropType.SEAM_STABILIZER_LEVER",
	"PropType.REFLECTIVE_PUDDLE",
	"PropType.PRESSURE_RELIEF_VALVE",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0206: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _count(source: String, snippet: String) -> int:
	var hits: int = 0
	var from: int = 0
	while true:
		var at: int = source.find(snippet, from)
		if at < 0:
			break
		hits += 1
		from = at + snippet.length()
	return hits


func _run() -> void:
	_check_facade_contract()
	_check_trigger_inventory()
	_check_audio_inventory()
	await _check_runtime_interaction()
	await _check_runtime_oneshot()
	_finish()


# ─── 1. Fasada nietknieta (pin sasiedzki) ─────────────────────────────

func _check_facade_contract() -> void:
	var source: String = _read(MRP_PATH)
	if source.is_empty():
		return
	_expect(source.contains("class_name MemoryResonancePoint"), "facade class identity must remain")
	_expect(source.contains("extends Area2D"), "facade Area2D boundary must remain")
	_expect(_count(source, "func _draw_") == 206, "facade must keep 206 _draw_*")
	_expect(_count(source, "func ") == 221, "facade must keep 221 functions")
	for sentinel: String in MRP_SENTINELS:
		_expect(source.contains(sentinel), "enum sentinel missing: %s" % sentinel)
	for export_line: String in MRP_EXPORTS:
		_expect(source.contains(export_line), "export missing: %s" % export_line)
	_expect(source.contains("signal resonance_triggered(id: String, prop_type: int)"), "signal resonance_triggered must remain")
	_expect(source.contains("signal state_changed(is_active: bool)"), "signal state_changed must remain")
	for method_name: String in ["func get_contact_progress()", "func get_touch_flash()", "func trigger_interaction()"]:
		_expect(source.contains(method_name), "public method missing: %s" % method_name)
	_expect(source.contains("game_state.collect_clue(StringName(resonance_id))"), "clue-before-activation bridge must remain")
	_expect(source.contains("const SWITCH_LIKE_PROPS"), "switch-like grouping must remain")
	for sw: String in SWITCH_LIKE_NAMES:
		_expect(source.contains(sw), "SWITCH_LIKE_PROPS must list %s" % sw)
	_expect(not source.contains("add_to_group("), "facade must not silently switch to Node groups")
	_expect(_count(source, "PKG-0199 pilot") == 130, "facade must keep 130 pilot markers")
	_expect(_count(source, "PKG-0200 slice2") == 73, "facade must keep 73 slice2 markers")
	_expect(_count(source, "MrpLegacyRenderer.draw_") == 203, "facade must delegate 203 types to the helper")
	var helper: String = _read(HELPER_PATH)
	_expect(helper.contains("extends RefCounted"), "helper must stay stateless RefCounted")


# ─── 2. Trigger: 182 galezie jawne + else ─────────────────────────────

func _trigger_segment(source: String) -> String:
	var start: int = source.find("func trigger_interaction()")
	if start < 0:
		return ""
	var stop: int = source.find("func _draw()", start)
	if stop < 0:
		return source.substr(start)
	return source.substr(start, stop - start)


func _check_trigger_inventory() -> void:
	var source: String = _read(MRP_PATH)
	if source.is_empty():
		return
	var trg: String = _trigger_segment(source)
	_expect(not trg.is_empty(), "trigger_interaction segment must exist")
	_expect(trg.contains("if prop_type == PropType.CIRCUIT_BREAKER:"), "trigger must keep initial CIRCUIT_BREAKER if")
	_expect(_count(trg, "elif prop_type == PropType.") == 181, "trigger must keep 181 elif branches (182 explicit total)")
	_expect(trg.contains("else:\n\t\tis_activated = true"), "trigger must keep else fallback latching true")
	_expect(trg.contains("_audio_player.stream = _memory_sound"), "trigger else must play generic _memory_sound")
	_expect(_count(trg, "_audio_player.stream =") == 183, "trigger must assign audio stream 183 times (182 + else)")
	_expect(_count(trg, "pitch_scale =") == 183, "trigger must assign pitch 183 times (182 + else)")
	_expect(_count(trg, "is_activated = true") >= 179, "trigger must latch true in at least 179 branches")
	_expect(_count(trg, "is_activated = not is_activated") == 4, "trigger must toggle in exactly 4 branches")
	for tg: String in TOGGLE_NAMES:
		_expect(trg.contains("prop_type == %s:" % tg), "toggle branch missing: %s" % tg)
	# Haptyka pierwsza i zawsze, przed clue (D-147).
	_expect(trg.contains("_touch_flash = 1.0"), "trigger must raise touch flash first")
	_expect(trg.contains("_play_haptic(_detent_sound"), "trigger must play detent for switch-like")
	_expect(trg.contains("_play_haptic(_probe_brush_sound)"), "trigger must play probe brush otherwise")
	var haptic_at: int = trg.find("_play_haptic(")
	var clue_at: int = trg.find("game_state.collect_clue(")
	_expect(haptic_at >= 0 and clue_at > haptic_at, "haptic layer must precede clue collection")
	# One-shot przed haptyka.
	_expect(trg.contains("if is_one_shot and is_activated:"), "trigger must swallow one-shot second press")
	var oneshot_at: int = trg.find("if is_one_shot and is_activated:")
	_expect(oneshot_at >= 0 and oneshot_at < haptic_at, "one-shot guard must precede haptic layer")
	# Emisja dokladnie raz + flash/particles/redraw.
	_expect(_count(trg, "resonance_triggered.emit(") == 1, "trigger must emit resonance_triggered exactly once")
	_expect(trg.contains("_resonance_flash = 1.0"), "trigger must raise resonance flash on activation")
	_expect(trg.contains("_particles.restart()"), "trigger must restart particles on activation")
	# PHOTOGRAPH jedzie fallbackiem, SHOWCASE_VITRINE ma wlasna galaz.
	_expect(not trg.contains("prop_type == PropType.PHOTOGRAPH:"), "PHOTOGRAPH must stay fallback without own trigger branch")
	_expect(trg.contains("prop_type == PropType.SHOWCASE_VITRINE:"), "SHOWCASE_VITRINE must keep own trigger branch")
	_expect(trg.contains("_paper_rustle_sound"), "SHOWCASE_VITRINE branch must use paper_rustle")


# ─── 3. Audio: match + 165 ramion + fallback ──────────────────────────

func _audio_segment(source: String) -> String:
	var start: int = source.find("func _setup_audio()")
	if start < 0:
		return ""
	var stop: int = source.find("func _setup_haptic_layer()", start)
	if stop < 0:
		return source.substr(start)
	return source.substr(start, stop - start)


func _extract_audio_types(seg: String) -> Dictionary:
	var types: Dictionary = {}
	for raw_line: String in seg.split("\n"):
		var line: String = raw_line.strip_edges()
		if not line.begins_with("PropType."):
			continue
		var rest: String = line
		while true:
			var at: int = rest.find("PropType.")
			if at < 0:
				break
			var tail: String = rest.substr(at + String("PropType.").length())
			var end: int = tail.length()
			for i: int in range(tail.length()):
				var ch: String = tail.substr(i, 1)
				if not ((ch >= "A" and ch <= "Z") or (ch >= "0" and ch <= "9") or ch == "_"):
					end = i
					break
			var pname: String = tail.substr(0, end)
			if not pname.is_empty():
				types[pname] = true
			rest = tail.substr(end)
	return types


func _check_audio_inventory() -> void:
	var source: String = _read(MRP_PATH)
	if source.is_empty():
		return
	var seg: String = _audio_segment(source)
	_expect(not seg.is_empty(), "_setup_audio segment must exist")
	_expect(seg.contains("_setup_haptic_layer()"), "_setup_audio must call haptic layer first")
	_expect(seg.contains("match prop_type:"), "_setup_audio must match on prop_type")
	var arm_lines: int = 0
	for raw_line: String in seg.split("\n"):
		if raw_line.strip_edges().begins_with("PropType."):
			arm_lines += 1
	_expect(arm_lines == 165, "audio match must keep 165 PropType arms (got %d)" % arm_lines)
	_expect(seg.contains("_:\n\t\t\t_memory_sound = ProceduralAudio.create_memory_resonance_sound()"), "audio match must keep generic _: fallback creating _memory_sound")
	var types: Dictionary = _extract_audio_types(seg)
	_expect(types.size() == 183, "audio setup must cover 183 unique PropTypes (got %d)" % types.size())
	_expect(203 - types.size() == 20, "audio setup must leave 20 PropTypes on generic fallback")
	_expect(_count(source, "ProceduralAudio.create_") == 173, "file must keep 173 ProceduralAudio.create_ calls total")
	_expect(_count(seg, "ProceduralAudio.create_") == 170, "audio setup must keep 170 create_ calls")
	# Haptyka: 3 dzwieki przez cache.
	_expect(source.contains("&\"contact_tap\""), "haptic layer must keep contact_tap")
	_expect(source.contains("&\"probe_brush\""), "haptic layer must keep probe_brush")
	_expect(source.contains("&\"switch_detent\""), "haptic layer must keep switch_detent")


# ─── 4. Runtime: 0/1/48 + one-shot 5 ─────────────────────────────────

func _state() -> Node:
	var state: Node = root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager autoload must exist")
	return state


func _make_prop(prop_type: int, resonance_id: String, one_shot: bool) -> MemoryResonancePoint:
	var prop := MemoryResonancePoint.new()
	prop.resonance_id = resonance_id
	prop.prop_type = prop_type as MemoryResonancePoint.PropType
	prop.is_one_shot = one_shot
	root.add_child(prop)
	return prop


func _check_runtime_interaction() -> void:
	var state: Node = _state()
	if state == null:
		return
	var cases: Array = [
		{"type": 0, "id": "pkg206_photograph_0", "mode": "fallback"},
		{"type": 1, "id": "pkg206_breaker_1", "mode": "toggle"},
		{"type": 48, "id": "pkg206_vitrine_48", "mode": "paper"},
	]
	for spec: Dictionary in cases:
		var ptype: int = int(spec.get("type"))
		var rid: String = String(spec.get("id"))
		var mode: String = String(spec.get("mode"))
		var prop: MemoryResonancePoint = _make_prop(ptype, rid, false)
		_expect(prop != null and is_instance_valid(prop), "prop %d must instantiate" % ptype)
		if prop == null:
			continue
		await process_frame
		await process_frame
		_expect(not prop.is_activated, "prop %d must start inactive" % ptype)
		var fired: Array = [0]
		prop.resonance_triggered.connect(func(_id: String, _pt: int) -> void:
			fired[0] += 1
		)
		var changed: Array = [0]
		prop.state_changed.connect(func(_active: bool) -> void:
			changed[0] += 1
		)
		prop.trigger_interaction()
		await process_frame
		_expect(fired[0] == 1, "prop %d must emit exactly once" % ptype)
		_expect(prop.is_activated, "prop %d must latch active after trigger" % ptype)
		_expect(changed[0] >= 1, "prop %d must emit state_changed" % ptype)
		_expect(state.get("collected_clues").has(StringName(rid)), "prop %d must collect its clue" % ptype)
		var player: AudioStreamPlayer2D = prop.get("_audio_player") as AudioStreamPlayer2D
		_expect(player != null and player.stream != null, "prop %d must assign an audio stream" % ptype)
		if player != null and player.stream != null:
			if mode == "fallback":
				var mem: AudioStreamWAV = prop.get("_memory_sound") as AudioStreamWAV
				_expect(player.stream == mem, "PHOTOGRAPH must play generic _memory_sound")
			elif mode == "paper":
				var paper: AudioStreamWAV = prop.get("_paper_rustle_sound") as AudioStreamWAV
				_expect(player.stream == paper, "SHOWCASE_VITRINE must play _paper_rustle_sound")
			elif mode == "toggle":
				var sw: AudioStreamWAV = prop.get("_switch_sound") as AudioStreamWAV
				_expect(player.stream == sw, "CIRCUIT_BREAKER must play _switch_sound")
				prop.trigger_interaction()
				await process_frame
				_expect(not prop.is_activated, "CIRCUIT_BREAKER must toggle back off on second press")
		prop.queue_free()
		await process_frame


func _check_runtime_oneshot() -> void:
	var once: MemoryResonancePoint = _make_prop(5, "pkg206_oneshot_5", true)
	await process_frame
	await process_frame
	var hits: Array = [0]
	once.resonance_triggered.connect(func(_id: String, _pt: int) -> void:
		hits[0] += 1
	)
	once.trigger_interaction()
	await process_frame
	once.trigger_interaction()
	await process_frame
	_expect(hits[0] == 1, "one-shot must emit exactly once across two presses")
	once.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0206 MRP INTERACTION INVENTORY PASS: trigger 182+else, audio 183+20, runtime 0/1/48 + one-shot.")
		quit(0)
	else:
		print("PKG-0206 MRP INTERACTION INVENTORY FAIL: %d failures" % _failures.size())
		for failure: String in _failures:
			print(" - %s" % failure)
		quit(1)
