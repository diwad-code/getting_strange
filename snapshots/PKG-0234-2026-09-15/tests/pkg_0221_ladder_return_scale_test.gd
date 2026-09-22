extends SceneTree

## PKG-0221 gate — ladder intent in zone + no jump-off + Return as Threshold + GATE-SCALE
## (M9+M3+M1-czesc, faza R5 planu PKG-0213 §8, decyzja D-234).
##
## Pinuje wylacznie kontrakty mierzalne, nigdy odbior (D-012, ADR-003):
## (1) M9 drabina: overlap to kandydatura, nigdy przypiecie — _on_body_entered
##     LadderZone nie wola attach_to_ladder; intencje ocenia STREFA (interact
##     albo stop+gora), nie gracz; 10 prob biegu na drabine = 0 przypiec,
##     zatrzymanie + gora = wspinaczka; koniec jump-off (skok na drabinie nie
##     wypina; zejscie = dol / koniec strefy, D-123/§7.5);
## (2) M3 powrot: ReturnZone jako drugi ThresholdZone — body_entered NIGDY nie
##     emituje previous_level_requested; powrot wylacznie trigger_return
##     (interact), jak prog wprost; target_station = poprzedni wg GSM;
##     apertura/rodzina jak prog wprost (THRESHOLD §7.1); is_open zawsze;
## (3) M1-czesc skale: GATE-SCALE 0 naruszen — grafika vs kolizja drabiny
##     (pion <= 2 px, x <= 1 px), dol drabiny na podlodze (<= 2 px),
##     wystawanie ponad podest/wlaz 8-14 px tam, gdzie podest istnieje
##     (02 ladowisko, 15 wlaz; 16 to drabina wejsciowa bez ladowiska w scenie —
##     pinowany fakt, nie furtka); apertury Bindera nietkniete (re-pin
##     read-only); zero statycznych wezlow Threshold (D-227 stoi);
##     drabin nie doklejono (route: tylko 02/15/16).
## (4) Fail-closed: kontrola one-shot (goly ReturnZone bez stacji: fallback
##     54x114 DOOR, pusty target) oraz brak reakcji poza zasiegiem.
## Nie jest PRODUCT GO. Nie dowodzi odbioru ani wygody wspinaczki.
##
## Konwencja: zero konstruktorow bool()/String()/float() na Variantach —
## wylacznie porownania, jawne typy i formatowanie %s.

const LADDER_PATH := "res://scripts/environment/ladder_zone.gd"
const PLAYER_PATH := "res://scripts/player/prototype_player.gd"
const RETURN_PATH := "res://scripts/environment/return_zone.gd"
const PLAYER_SCENE := "res://scenes/player/prototype_player.tscn"

const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")

const FAMILY_DOOR := 0
const FAMILY_VEHICLE := 1
const FAMILY_HATCH := 2

const ROUTE: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const LADDER_ROUTE_IDS: Array[String] = ["station_02", "station_15", "station_16"]

const EXPECTED_PREV := {
	"station_02": "station_01",
	"station_15": "station_14",
	"station_16": "station_15",
}

# Wlaz 15 to rysunek stacji (station_15.gd, Rect2(576,148,48,10)): prog sill y=158.
const STATION_15_HATCH_SILL_Y := 158.0

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0221: " + message)


func _t(v: Variant) -> bool:
	return v == true


func _read(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	_expect(f != null, "file must be readable: %s" % path)
	if f == null:
		return ""
	var text: String = f.get_as_text().replace("\r\n", "\n")
	f.close()
	return text


func _func_body(text: String, marker: String) -> String:
	var start: int = text.find(marker)
	if start < 0:
		return ""
	var next_func: int = text.find("\nfunc ", start + marker.length())
	if next_func < 0:
		return text.substr(start)
	return text.substr(start, next_func - start)


func _run() -> void:
	_check_static_contracts()	# Izolacja: auto-transzycje GSM (change_scene_to_file po sygnale powrotu)
	# dokladalyby stacje z zywymi graczami w tle i zatruwaly pomiary ciszy.
	# Wylaczenie na czas bramki; kazda bramka to osobny proces.
	var gsm0 := _gsm()
	if gsm0 != null:
		gsm0.set("campaign_auto_transition_enabled", false)
	await _check_fail_closed()
	await _check_ladder_intent_runtime()
	await _check_return_threshold_runtime()
	await _check_scale_lint()
	_finish()


# ─── 1. Statyka: intencja w strefie, koniec jump-off, powrot bez progresji ──

func _check_static_contracts() -> void:
	print("1. Static contracts: zone-owned intent, no jump-off, return without overlap progress...")
	var ladder := _read(LADDER_PATH)
	var player := _read(PLAYER_PATH)
	var ret := _read(RETURN_PATH)
	if ladder.is_empty() or player.is_empty() or ret.is_empty():
		return
	var entered_ladder := _func_body(ladder, "func _on_body_entered")
	_expect(not entered_ladder.is_empty(), "LadderZone must define _on_body_entered")
	_expect(not entered_ladder.contains("attach_to_ladder"),
		"LadderZone._on_body_entered must not attach (overlap is candidacy, D-234)")
	_expect(ladder.contains("func try_mount"),
		"LadderZone must own mounting via try_mount (intent in zone)")
	_expect(ladder.contains("is_player_in_range"),
		"LadderZone must expose is_player_in_range")
	_expect(ladder.contains("_unhandled_input") and ladder.contains("interact"),
		"LadderZone must mount on interact like ThresholdZone")
	_expect(not player.contains("Jump off ladder"),
		"PrototypePlayer must not implement jump-off from ladder (D-123/§7.5)")
	_expect(player.contains("func begin_climb"),
		"PrototypePlayer must expose begin_climb for zone-owned mounting")
	_expect(not player.contains("Attach is proximity"),
		"PrototypePlayer must not auto-mount on proximity (intent lives in the zone)")
	var entered_ret := _func_body(ret, "func _on_body_entered")
	_expect(not entered_ret.is_empty(), "ReturnZone must define _on_body_entered")
	_expect(not entered_ret.contains("emit"),
		"ReturnZone._on_body_entered must never emit (no body_entered progression, M3)")
	_expect(ret.contains("func trigger_return"),
		"ReturnZone must expose trigger_return (interact-only return)")
	_expect(ret.contains("target_station"),
		"ReturnZone must carry target_station (previous station)")
	_expect(ret.contains("aperture_rect"),
		"ReturnZone must carry aperture_rect like the forward Threshold")
	_expect(ret.contains("is_player_in_range"),
		"ReturnZone must expose is_player_in_range")
	_check_no_station_return_overlap_wiring()


func _check_no_station_return_overlap_wiring() -> void:
	print("1b. No station wires ReturnZone.body_entered to progression...")
	var dir := DirAccess.open("res://scripts/levels")
	_expect(dir != null, "scripts/levels must be listable")
	if dir == null:
		return
	var wired: Array[String] = []
	dir.list_dir_begin()
	var fname: String = dir.get_next()
	while fname != "":
		if fname.begins_with("station_") and fname.ends_with(".gd") and not dir.current_is_dir():
			var text := _read("res://scripts/levels/" + fname)
			if not text.is_empty() and text.contains("return_zone.body_entered.connect"):
				wired.append(fname)
		fname = dir.get_next()
	dir.list_dir_end()
	_expect(wired.is_empty(),
		"no station may progress the return from overlap (wired: %s)" % str(wired))


# ─── 2. Runtime drabiny: 10x bieg = 0 przypiec, stop+gora = wejscie ─────────

func _check_ladder_intent_runtime() -> void:
	print("2. Ladder intent at runtime: 10 running grazes mount nothing...")
	var world := Node2D.new()
	world.name = "LadderIntentWorld"
	root.add_child(world)
	var ladder := LadderZone.new()
	ladder.position = Vector2(200.0, 296.0)
	ladder.ladder_height = 86.0
	ladder.ladder_width = 22.0
	world.add_child(ladder)
	var packed := load(PLAYER_SCENE) as PackedScene
	_expect(packed != null, "prototype_player.tscn must load for ladder intent")
	if packed == null:
		world.queue_free()
		return
	var player := packed.instantiate() as CharacterBody2D
	player.position = Vector2(200.0, 269.0)
	world.add_child(player)
	for _i in range(10):
		await physics_frame
	_expect(_t(ladder.get("is_player_in_range")),
		"overlapping player must register as in range (candidacy, not a mount)")
	_expect(not _t(player.get("is_climbing")),
		"mere overlap must not climb without intent")
	if not ladder.has_method("try_mount"):
		_expect(false, "LadderZone.try_mount missing at runtime (zone-owned intent)")
		world.queue_free()
		await process_frame
		return
	var dirs: Array[float] = [-1.0, 1.0]
	for trial in range(10):
		player.global_position = Vector2(200.0, 269.0)
		player.set("current_ladder", null)
		player.set("is_climbing", false)
		var dir: float = dirs[trial % 2]
		player.set("velocity", Vector2(dir * (90.0 + trial * 5.0), 0.0))
		Input.action_press(&"move_up")
		if dir > 0.0:
			Input.action_press(&"move_right")
		else:
			Input.action_press(&"move_left")
		if trial % 3 == 2:
			Input.action_press(&"interact")
		for _i in range(6):
			await physics_frame
		Input.action_release(&"move_up")
		Input.action_release(&"move_right")
		Input.action_release(&"move_left")
		Input.action_release(&"interact")
		_expect(not _t(player.get("is_climbing")),
			"running graze %d must not pin Lena to the ladder" % (trial + 1))
	print("   stopped + up mounts; jump never dismounts...")
	player.global_position = Vector2(200.0, 269.0)
	player.set("current_ladder", null)
	player.set("is_climbing", false)
	player.set("velocity", Vector2.ZERO)
	Input.action_press(&"move_up")
	for _i in range(8):
		await physics_frame
	Input.action_release(&"move_up")
	_expect(_t(player.get("is_climbing")),
		"a stopped upward input at the ladder must start the climb")
	var held_ladder: Variant = player.get("current_ladder")
	_expect(held_ladder == ladder, "climb must hold the zone ladder")
	Input.action_press(&"jump")
	for _i in range(5):
		await physics_frame
	Input.action_release(&"jump")
	_expect(_t(player.get("is_climbing")),
		"jump while climbing must not dismount (exit is down / zone end)")
	_expect(player.get("current_ladder") == ladder,
		"jump while climbing must keep the ladder")
	print("   interact mounts a stopped player; leaving detaches...")
	player.set("is_climbing", false)
	player.set("current_ladder", null)
	player.set("velocity", Vector2.ZERO)
	_expect(_t(ladder.call("try_mount", player)),
		"try_mount must mount a stopped overlapping player (interact path)")
	_expect(_t(player.get("is_climbing")),
		"try_mount must leave the player climbing")
	player.global_position = Vector2(500.0, 100.0)
	for _i in range(6):
		await physics_frame
	_expect(not _t(player.get("is_climbing")),
		"leaving the zone must end the climb")
	_expect(player.get("current_ladder") == null,
		"leaving the zone must clear the ladder")
	_expect(not _t(ladder.get("is_player_in_range")),
		"leaving the zone must clear the range flag")
	world.queue_free()
	await process_frame


# ─── 3. Runtime powrotu: overlap milczy, interact wraca ─────────────────────

func _gsm() -> Node:
	return root.get_node_or_null("GameStateManager")


func _expected_prev(station_id: String) -> StringName:
	var gsm := _gsm()
	if gsm != null and gsm.has_method("get_previous_campaign_station"):
		var prev: Variant = gsm.call("get_previous_campaign_station", StringName(station_id))
		if prev is StringName:
			return prev
	return StringName("")


func _aperture_legal(family: int, size: Vector2) -> bool:
	var w: float = size.x
	var h: float = size.y
	if family == FAMILY_VEHICLE:
		return w >= 46.8 and w <= 70.4 and h >= 90.0 and h <= 121.0
	if family == FAMILY_HATCH:
		return w >= 50.4 and w <= 77.0 and h >= 50.4 and h <= 77.0
	var residential: bool = w >= 37.8 and w <= 52.8 and h >= 98.1 and h <= 119.9
	var technical: bool = w >= 43.2 and w <= 66.0 and h >= 98.1 and h <= 132.0
	return residential or technical


func _check_return_threshold_runtime() -> void:
	print("3. Return behaves like a Threshold: overlap is silent, interact returns...")
	for station_id in ["station_02", "station_15", "station_16"]:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s.tscn must load" % station_id)
		if packed == null:
			continue
		var station := packed.instantiate() as Node2D
		root.add_child(station)
		await process_frame
		await physics_frame
		await physics_frame
		var zone := station.get_node_or_null("ReturnZone") as ReturnZone
		_expect(zone != null, "%s must own a ReturnZone" % station_id)
		if zone == null:
			station.queue_free()
			await process_frame
			continue
		_expect(zone.get("target_station") == EXPECTED_PREV[station_id],
			"%s ReturnZone target_station must pin the previous station (got %s)" % [station_id, zone.get("target_station")])
		_expect(zone.get("target_station") == _expected_prev(station_id),
			"%s ReturnZone target must match GameStateManager previous" % station_id)
		var family: int = zone.get("entry_family")
		var aperture: Rect2 = zone.get("aperture_rect")
		_expect(_aperture_legal(family, aperture.size),
			"%s return aperture %.0fx%.0f (family %d) outside THRESHOLD §7.1" % [station_id, aperture.size.x, aperture.size.y, family])
		_expect(_t(zone.get("is_open")),
			"%s return must stay open (bidirectionality)" % station_id)
		_expect(not _t(zone.get("is_player_in_range")),
			"%s return must start out of range" % station_id)
		for conn in zone.body_entered.get_connections():
			var cb: Callable = conn["callable"]
			_expect(cb.get_object() == zone,
				"%s ReturnZone.body_entered must be zone-owned (no station progression)" % station_id)
		if not zone.has_method("trigger_return"):
			_expect(false, "%s trigger_return missing at runtime (interact-only return)" % station_id)
			station.queue_free()
			await process_frame
			continue
		var went_back: Array = []
		var zone_fired: Array = []
		if station.has_signal(&"previous_level_requested"):
			station.connect(&"previous_level_requested", func(): went_back.append(true))
		zone.return_requested.connect(func(): zone_fired.append(true))
		var player := station.get_node_or_null("Player") as Node2D
		_expect(player != null, "%s must own a Player" % station_id)
		if player != null:
			player.global_position = zone.global_position
			for _i in range(8):
				await physics_frame
			_expect(went_back.is_empty() and zone_fired.is_empty(),
				"%s overlap alone must not progress the return" % station_id)
			_expect(_t(zone.get("is_player_in_range")),
				"%s overlap must register range for interact" % station_id)
			_expect(_t(zone.trigger_return(player)),
				"%s trigger_return must accept a ranged player" % station_id)
			_expect(not went_back.is_empty(),
				"%s trigger_return must emit previous_level_requested" % station_id)
			_expect(not zone_fired.is_empty(),
				"%s trigger_return must emit return_requested" % station_id)
			_expect(not _t(station.get("is_level_completed")),
				"%s return must never complete the level" % station_id)
		station.queue_free()
		for _i in range(3):
			await process_frame
			await physics_frame


# ─── 4. GATE-SCALE: drabiny 02/15/16 + apertury bez naruszen ────────────────

func _floor_top(station: Node2D, names: Array[String]) -> float:
	for floor_name in names:
		var floor_node := station.get_node_or_null(floor_name) as Node2D
		if floor_node == null:
			continue
		var shape := floor_node.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if shape != null and shape.shape is RectangleShape2D:
			var rect := shape.shape as RectangleShape2D
			return floor_node.global_position.y - rect.size.y * 0.5
	return NAN


func _check_ladder_geometry(station_id: String, ladder_path: String, floor_names: Array[String]) -> void:
	var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
	_expect(packed != null, "%s.tscn must load for scale lint" % station_id)
	if packed == null:
		return
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	var ladder := station.get_node_or_null(ladder_path)
	_expect(ladder != null, "%s must own %s" % [station_id, ladder_path])
	if ladder == null:
		station.queue_free()
		await process_frame
		return
	var shape := (ladder as Node).get_node_or_null("CollisionShape2D") as CollisionShape2D
	_expect(shape != null, "%s ladder must have a collision shape" % station_id)
	if shape != null and shape.shape is RectangleShape2D:
		var rect := shape.shape as RectangleShape2D
		var center: Vector2 = (ladder as Node2D).to_global(shape.position)
		var col_top: float = center.y - rect.size.y * 0.5
		var col_bot: float = center.y + rect.size.y * 0.5
		var ladder_height: float = (ladder as Node).get("ladder_height")
		var vis_top: float = (ladder as Node2D).global_position.y - ladder_height
		var vis_bot: float = (ladder as Node2D).global_position.y
		_expect(absf(col_top - vis_top) <= 2.0,
			"%s ladder vertical top mismatch %.1f vs %.1f" % [station_id, vis_top, col_top])
		_expect(absf(col_bot - vis_bot) <= 2.0,
			"%s ladder vertical bottom mismatch %.1f vs %.1f" % [station_id, vis_bot, col_bot])
		_expect(absf(center.x - (ladder as Node2D).global_position.x) <= 1.0,
			"%s ladder x-axis mismatch" % station_id)
		var floor_top := _floor_top(station, floor_names)
		_expect(not is_nan(floor_top), "%s must expose a floor top for the lint" % station_id)
		if not is_nan(floor_top):
			_expect(absf(vis_bot - floor_top) <= 2.0,
				"%s ladder bottom must sit on the floor (%.1f vs %.1f)" % [station_id, vis_bot, floor_top])
	station.queue_free()
	await process_frame


func _check_scale_lint() -> void:
	print("4. GATE-SCALE: ladder drawing vs zone, floor contact, protrusion, apertures...")
	await _check_ladder_geometry("station_02", "ServiceLadder", ["Geometry/Floor"])
	await _check_ladder_geometry("station_15", "Props/ServiceLadder", ["Geometry/FloorMain"])
	await _check_ladder_geometry("station_16", "Props/ServiceLadder", ["Geometry/FloorMain"])
	# Wystawanie ponad podest/wlaz 8-14 px (TRAVERSE §9.3, WORLD_SCALE §7.4).
	var p02 := load("res://scenes/levels/station_02.tscn") as PackedScene
	var st02 := p02.instantiate() as Node2D
	root.add_child(st02)
	await process_frame
	var landing := st02.get_node_or_null("Geometry/ServiceLanding") as Node2D
	var lad02 := st02.get_node_or_null("ServiceLadder") as Node2D
	if landing != null and lad02 != null:
		var lshape := landing.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if lshape != null and lshape.shape is RectangleShape2D:
			var lrect := lshape.shape as RectangleShape2D
			var landing_top: float = landing.global_position.y - lrect.size.y * 0.5
			var lad02_height: float = lad02.get("ladder_height")
			var lad_top: float = lad02.global_position.y - lad02_height
			_expect(landing_top - lad_top >= 8.0 and landing_top - lad_top <= 14.0,
				"station_02 ladder must protrude 8-14 px above the landing (got %.1f)" % (landing_top - lad_top))
	st02.queue_free()
	await process_frame
	var p15 := load("res://scenes/levels/station_15.tscn") as PackedScene
	var st15 := p15.instantiate() as Node2D
	root.add_child(st15)
	await process_frame
	var lad15 := st15.get_node_or_null("Props/ServiceLadder") as Node2D
	if lad15 != null:
		var lad15_height: float = lad15.get("ladder_height")
		var lad_top15: float = lad15.global_position.y - lad15_height
		_expect(STATION_15_HATCH_SILL_Y - lad_top15 >= 8.0 and STATION_15_HATCH_SILL_Y - lad_top15 <= 14.0,
			"station_15 ladder must protrude 8-14 px above the hatch sill (got %.1f)" % (STATION_15_HATCH_SILL_Y - lad_top15))
	st15.queue_free()
	await process_frame
	# Drabin nie doklejono: na trasie tylko 02/15/16 maja wezel drabiny.
	for station_id in ROUTE:
		var text := _read("res://scenes/levels/%s.tscn" % station_id)
		if text.is_empty():
			continue
		var has_ladder := false
		for line in text.split("\n"):
			if line.begins_with("[node ") and line.contains("adder"):
				has_ladder = true
		_expect(has_ladder == LADDER_ROUTE_IDS.has(station_id),
			"%s ladder presence must stay route-pinned (02/15/16 only)" % station_id)
	# D-227 stoi: zero statycznych wezlow Threshold; apertury Bindera legalne.
	for station_id in ROUTE:
		var text := _read("res://scenes/levels/%s.tscn" % station_id)
		if text.is_empty():
			continue
		_expect(not text.contains('name="Threshold"'),
			"%s.tscn must not carry a static Threshold node (Binder sole owner)" % station_id)
	for station_id in ROUTE:
		var spec: Dictionary = ThresholdBinderScript.spec_for(station_id)
		_expect(not spec.is_empty(), "Binder spec missing for %s" % station_id)
		if spec.is_empty():
			continue
		var family: int = spec.get("family", -1)
		var size := Vector2(float(spec.get("width", 0.0)), float(spec.get("height", 0.0)))
		_expect(_aperture_legal(family, size),
			"%s Binder aperture %.0fx%.0f outside §7.1" % [station_id, size.x, size.y])


# ─── 5. Fail-closed: spasowany ReturnZone i brak reakcji poza zasiegiem ────

func _check_fail_closed() -> void:
	print("5. Fail-closed: fallback aperture, empty target, no reaction out of range...")
	var bare := ReturnZone.new()
	_expect(bare != null, "ReturnZone must instantiate standalone")
	if bare == null:
		return
	root.add_child(bare)
	await process_frame
	var bare_family: int = bare.get("entry_family")
	var bare_aperture: Rect2 = bare.get("aperture_rect")
	_expect(_aperture_legal(bare_family, bare_aperture.size),
		"standalone ReturnZone fallback aperture must be §7.1-legal")
	_expect(bare.get("target_station") == &"",
		"standalone ReturnZone without a station must keep an empty target")
	_expect(_t(bare.get("is_open")), "standalone ReturnZone must default open")
	_expect(not _t(bare.get("is_player_in_range")),
		"standalone ReturnZone must start out of range")
	if not bare.has_method("trigger_return"):
		_expect(false, "ReturnZone.trigger_return missing at runtime (fail-closed)")
		bare.queue_free()
		await process_frame
		return
	# Drenaz miedzysekcyjny: stacje z §3 (i ewentualne transzycje GSM po ich
	# triggerach) musza zniknac z drzewa, zanim zmierzymy cisze overlapu —
	# inaczej dogorywajacy gracz na starym progu dalby falszywy zasieg.
	for _i in range(4):
		await process_frame
		await physics_frame
	_expect(bare.get_overlapping_bodies().is_empty(),
		"fail-closed stage must start overlap-free")
	var world := Node2D.new()
	root.add_child(world)
	var ladder := LadderZone.new()
	ladder.position = Vector2(400.0, 296.0)
	world.add_child(ladder)
	var packed := load(PLAYER_SCENE) as PackedScene
	if packed != null:
		var player := packed.instantiate() as CharacterBody2D
		player.position = Vector2(100.0, 200.0)
		world.add_child(player)
		await physics_frame
		if ladder.has_method("try_mount"):
			_expect(not _t(ladder.call("try_mount", player)),
				"try_mount far from the zone must refuse")
		var fired: Array = []
		bare.return_requested.connect(func(): fired.append(true))
		_expect(not _t(bare.trigger_return(player)),
			"trigger_return out of range must refuse without instant")
		_expect(fired.is_empty(), "refused return must not emit")
	world.queue_free()
	bare.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0221 LADDER RETURN SCALE PASS: zone-owned intent, no jump-off, Threshold-like return, GATE-SCALE clean.")
		quit(0)
	else:
		print("PKG-0221 LADDER RETURN SCALE FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - %s" % failure)
		quit(1)
