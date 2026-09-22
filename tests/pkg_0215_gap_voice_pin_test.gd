extends SceneTree

## PKG-0215 gate — GapLedger 1:1 voice pin + interact priority (decyzja D-228).
##
## M6: every blocked verb on route stations 01-18 must name its gap
## (FEEDBACK_TO_GAP), a station-qualified override, or a documented
## NON_GAP_FEEDBACKS background entry — fail-closed on new literals.
## s09-s14 gaps carry real station flags. Blocked verbs speak their gap
## thought via GapLedger.annotate_feedback (wired in every 01-18
## _record_feedback), guarded by one-thought-at-a-time and never over CRT.
## M4: in Station 14 a ready Threshold wins over the anchor toggle.
##
## Technical proof only: tables, flags, wiring and input routing.
## No claim about fun, beauty, comprehension or reception (D-012, ADR-003).

const GapLedgerScript := preload("res://scripts/campaign/gap_ledger.gd")

const ROUTE_18: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
]

const ROUTE_22: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const FLAG_STATIONS: Array[String] = [
	"station_09", "station_10", "station_11",
	"station_12", "station_13", "station_14",
]

const STATION_14_FEEDBACK_KEY := &"p9.mechanics.dead_circuit.safe_trial_feedback"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0215: " + message)


func _read(path: String) -> String:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "file must be readable: %s" % path)
	if file == null:
		return ""
	var text: String = file.get_as_text().replace("\r\n", "\n")
	file.close()
	return text


func _feedback_literals(script_text: String) -> Array[String]:
	var out: Array[String] = []
	var marker: String = "_record_feedback(&\""
	var from: int = 0
	while true:
		var at: int = script_text.find(marker, from)
		if at < 0:
			break
		var start: int = at + marker.length()
		var stop: int = script_text.find("\"", start)
		if stop < 0:
			break
		out.append(script_text.substr(start, stop - start))
		from = stop + 1
	return out


func _run() -> void:
	_test_table_coverage()
	_test_wiring()
	_test_flags()
	await _test_interact_priority()
	_finish()


# ─── 1. Every route literal is mapped, overridden or allowlisted ────────

func _test_table_coverage() -> void:
	print("1. Route feedback literals must resolve to a gap or a background entry...")
	var catalog: Dictionary = GapLedgerScript.CATALOG
	var table: Dictionary = GapLedgerScript.FEEDBACK_TO_GAP
	var overrides: Dictionary = GapLedgerScript.STATION_FEEDBACK_OVERRIDES
	var nongap: Array = GapLedgerScript.NON_GAP_FEEDBACKS
	for target: String in table.values():
		_expect(catalog.has(target), "mapping target is not a catalog gap: %s" % target)
	for key: String in overrides.keys():
		_expect(key.contains("|"), "override key must be station|feedback: %s" % key)
		var parts: PackedStringArray = key.split("|")
		_expect(parts.size() == 2, "override key must have two parts: %s" % key)
		if parts.size() == 2:
			_expect(ROUTE_18.has(parts[0]), "override station off-route: %s" % key)
			_expect(catalog.has(String(overrides[key])), "override target is not a catalog gap: %s" % key)
	var all_route: Dictionary = {}
	for station_id: String in ROUTE_22:
		var text: String = _read("res://scripts/levels/%s.gd" % station_id)
		if text.is_empty():
			continue
		for lit: String in _feedback_literals(text):
			all_route[lit] = true
			if not ROUTE_18.has(station_id):
				continue
			var station_key: String = station_id + "|" + lit
			var resolved: bool = table.has(lit) or overrides.has(station_key) or nongap.has(lit)
			_expect(resolved, "%s feedback has no gap, override or background entry: %s" % [station_id, lit])
	for entry: Variant in nongap:
		_expect(all_route.has(String(entry)), "dead background entry (unused by the route): %s" % String(entry))
	var used_gaps: Dictionary = {}
	for lit: String in table.keys():
		used_gaps[String(table[lit])] = true
	for key: String in overrides.keys():
		used_gaps[String(overrides[key])] = true
	for gap_id: String in catalog.keys():
		_expect(used_gaps.has(gap_id), "catalog gap unreachable from any feedback: %s" % gap_id)


# ─── 2. Voice wiring present in every 01-18 _record_feedback ────────────

func _test_wiring() -> void:
	print("2. Blocked verbs must speak through GapLedger...")
	var ledger_text: String = _read("res://scripts/campaign/gap_ledger.gd")
	_expect(ledger_text.contains("InnerThoughtSurface") and ledger_text.contains("visible"),
		"speak must guard on the thought surface")
	_expect(ledger_text.contains("is_presenting"),
		"speak must guard on CRT dialogue")
	for station_id: String in ROUTE_18:
		var text: String = _read("res://scripts/levels/%s.gd" % station_id)
		if text.is_empty():
			continue
		_expect(text.contains("GapLedger.annotate_feedback(self, value)"),
			"%s _record_feedback must speak its gap" % station_id)


# ─── 3. s09-s14 gaps carry real station flags ───────────────────────────

func _test_flags() -> void:
	print("3. s09-s14 gaps must name real station flags...")
	var catalog: Dictionary = GapLedgerScript.CATALOG
	for station_id: String in FLAG_STATIONS:
		var station_text: String = _read("res://scripts/levels/%s.gd" % station_id)
		if station_text.is_empty():
			continue
		var found_flag: String = ""
		for gap_id: String in catalog.keys():
			var spec: Dictionary = catalog[gap_id]
			if String(spec.get("opened_from", "")) != station_id:
				continue
			var flag: String = String(spec.get("station_flag", ""))
			_expect(not flag.is_empty(), "%s gap must name a station flag" % gap_id)
			if flag.is_empty():
				continue
			_expect(station_text.contains("var " + flag),
				"%s must declare flag var %s" % [station_id, flag])
			found_flag = flag
		_expect(not found_flag.is_empty(), "%s must own at least one catalog gap" % station_id)
		var packed: PackedScene = load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s.tscn must load" % station_id)
		if packed == null:
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		await process_frame
		for gap_id: String in catalog.keys():
			var spec2: Dictionary = catalog[gap_id]
			if String(spec2.get("opened_from", "")) != station_id:
				continue
			var flag2: String = String(spec2.get("station_flag", ""))
			if flag2.is_empty():
				continue
			_expect(station.get(flag2) != null, "%s runtime must expose %s" % [station_id, flag2])
		station.queue_free()
		await process_frame


# ─── 4. Ready Threshold wins over the Station 14 anchor ────────────────

func _press_interact(station: Node) -> void:
	var ev := InputEventAction.new()
	ev.action = &"interact"
	ev.pressed = true
	ev.strength = 1.0
	station.call("_unhandled_input", ev)


func _feedback_value(gsm: Node) -> Variant:
	if gsm == null:
		return null
	var decisions: Variant = gsm.get("decisions")
	if not (decisions is Dictionary):
		return null
	return (decisions as Dictionary).get(STATION_14_FEEDBACK_KEY, null)


func _test_interact_priority() -> void:
	print("4. Ready Threshold must win over the anchor toggle (10 presses)...")
	var packed: PackedScene = load("res://scenes/levels/station_14.tscn") as PackedScene
	_expect(packed != null, "station_14.tscn must load")
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await process_frame
	await process_frame
	var gsm: Node = root.get_node_or_null("GameStateManager")
	_expect(gsm != null, "GameStateManager autoload must exist")
	var player := station.get_node_or_null("Player") as Node2D
	_expect(player != null, "Station 14 must carry the Player")
	var zone := station.get_node_or_null("Threshold") as Area2D
	_expect(zone != null, "Station 14 must carry the Binder Threshold")
	var bridge: Node = station.get_node_or_null("Machine/TractionBridge")
	_expect(bridge != null, "Station 14 must carry the TractionBridge")
	if player == null or zone == null or bridge == null:
		station.queue_free()
		await process_frame
		return
	_expect(bool(zone.get("is_open")), "Threshold must be open with zero readings")
	var zone2d := zone as Node2D
	player.global_position = zone2d.to_global(Vector2(0.0, 20.0))
	for _i: int in range(6):
		await physics_frame
	_expect(bool(zone.call("is_ready_for_entry")), "Threshold must be ready at the door")
	var anchored_before: Variant = bridge.get("is_anchored")
	var feedback_before: Variant = _feedback_value(gsm)
	for _press: int in range(10):
		_press_interact(station)
	_expect(bridge.get("is_anchored") == anchored_before,
		"10 presses at a ready Threshold must not toggle the anchor")
	_expect(_feedback_value(gsm) == feedback_before,
		"10 presses at a ready Threshold must not record a miss")
	_expect(bool(zone.call("is_ready_for_entry")), "Threshold must stay ready after the probe")
	player.global_position = (bridge as Node2D).global_position
	for _j: int in range(4):
		await physics_frame
	_press_interact(station)
	_expect(bool(bridge.get("is_anchored")) != bool(anchored_before),
		"anchor must still toggle far from the Threshold")
	station.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0215 GAP VOICE PASS: 01-18 literals resolve, s09-s14 flags real, Threshold wins in 14.")
		quit(0)
	else:
		print("PKG-0215 GAP VOICE FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
