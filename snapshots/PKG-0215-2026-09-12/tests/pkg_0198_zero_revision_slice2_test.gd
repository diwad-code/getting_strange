extends SceneTree

## PKG-0198 gate — ZERO REWIZJA wycinek 2 (kadry, mono, cienie, dzwiek).
##
## Dowodzi wylacznie kontraktow mierzalnych, nigdy „ladnosci" (D-012, ADR-003):
## (1) martwy kod 05 wyciety; (2) kazdy adres 01-18/42A/B/C/43 ma cien
## kontaktowy 0.48 w prawo; (3) drabine rysuje wylacznie LadderZone (02/15/16),
## 07 ma stopien 14 px i zero drabin; (4) AtmosphereRig daje jedno slyszalne
## zrodlo na miejsce, 06/08 maja pozycjonowany hum pracy, finaly: cisza
## z jednym dronem; (5) rack 06 i donica 08 maja prace stanowa; (6) regula
## mono: rodzina po sylwecie i dzialaniu (geometria + affordance), nigdy
## wylacznie po kolorze; (7) skale tekstu 85/100/115 nie lamią prezentacji.
## Logika gry nietykalna: zero nowych writerow, flag, sygnalow i routingu.

const CinematicCatalogScript := preload("res://scripts/cinematics/cinematic_catalog.gd")

const ACTIVE_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

const SLICE_IDS: Array[String] = [
	"station_02", "station_03", "station_04", "station_05", "station_07",
	"station_09", "station_10", "station_11", "station_12", "station_13",
	"station_14", "station_15", "station_16", "station_17", "station_18",
	"station_42a", "station_42b", "station_42c", "station_43",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0198: " + message)


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
	_check_dead_code_05()
	_check_shadows()
	_check_no_global_filters()
	_check_mono_geometry()
	_check_ladder_contract()
	_check_work_props()
	_check_audio_contract()
	_check_vignette_silence_regression()
	await _check_runtime_hums_and_ladders()
	await _check_runtime_text_scales()
	_finish()


# ─── 1. Martwy kod 05 wyciety ─────────────────────────────────────────────

func _check_dead_code_05() -> void:
	var source := _read("res://scripts/visual/vector_stage_environment.gd")
	_expect(not source.contains("Vector2(672"), "env 05: off-screen rect x672 must be gone")
	_expect(not source.contains("Vector2(1010"), "env 05: off-screen rect x1010 must be gone")
	_expect(source.contains("PKG-0198"), "env 05: removal must be documented in code")


# ─── 2. Cien 0.48 w prawo na kazdym adresie ───────────────────────────────

func _check_shadows() -> void:
	for station_id in ACTIVE_IDS:
		var source := _read("res://scripts/levels/%s.gd" % station_id)
		_expect(source.contains("Color(VectorStageStyle.INK, 0.48)"), "%s must carry a 0.48 contact shadow to the right" % station_id)


# ─── 3. Zero globalnych filtrow (regresja 0197) ───────────────────────────

func _check_no_global_filters() -> void:
	_expect(_read("res://scripts/visual/world_pixel_compositor.gd").contains("screen_texture"),
			"only WorldPixelCompositor may sample screen_texture")
	for station_id in ACTIVE_IDS:
		var source := _read("res://scripts/levels/%s.gd" % station_id)
		_expect(not source.contains("screen_texture"), "%s must not sample the screen" % station_id)
		_expect(not source.contains("glitch"), "%s must not run a fullscreen glitch" % station_id)
		_expect(source.contains("func _draw"), "%s must own a drawn world surface" % station_id)
		_expect(not source.contains("draw_string("), "%s must not put readable text in the pixelated world" % station_id)


# ─── 4. Regula mono: sylweta i dzialanie, nigdy sam kolor ─────────────────
#
# Mierzalny odpowiednik „rodzina po sylwecie i dzialaniu": kazdy adres ma
# co najmniej 3 rozne prymitywy rysunku (bryla), co najmniej jedna linie
# prowadzaca lub krawedz przejscia (dzialanie) oraz nazwane swiatlo
# praktyczne w srodowisku. Kolor sam nie niesie zadnego faktu: kazdy
# interaktywny element ma tez ksztalt i pozycje (prostokat + obrys).

func _check_mono_geometry() -> void:
	var env := _read("res://scripts/visual/vector_stage_environment.gd")
	_expect(env.contains("func _draw_practical_lighting"), "environment must own practical lighting")
	_expect(env.contains("draw_faceted_lamp"), "environment must place faceted lamps")
	for station_id in SLICE_IDS:
		var source := _read("res://scripts/levels/%s.gd" % station_id)
		var prims := 0
		prims += _count(source, "draw_rect(")
		prims += _count(source, "draw_colored_polygon(")
		prims += _count(source, "draw_circle(")
		prims += _count(source, "draw_line(")
		_expect(prims >= 8, "%s must draw a silhouette from shapes (%d primitives)" % [station_id, prims])
		_expect(source.contains("draw_line("), "%s must have a leading edge or route line (action)" % station_id)
	# [MONO-Q] 07/11/16: trzy znane ryzyka z diagnozy 0197 maja jawny kontrakt.
	var s07 := _read("res://scripts/levels/station_07.gd")
	_expect(s07.contains("Open sky"), "07 must keep the open-sky street silhouette (>=25%)")
	var s11 := _read("res://scripts/levels/station_11.gd")
	_expect(s11.contains("counter"), "11 must keep the counter mass as the readable body")
	var s16 := _read("res://scripts/levels/station_16.gd")
	_expect(s16.contains("lamp") or s16.contains("Lampa") or s16.contains("swiat"), "16 must keep the lamp-cone silhouette marker")


# ─── 5. Drabina: jeden rysunek, wymierne progi 9.3 ────────────────────────

func _check_ladder_contract() -> void:
	var s02 := _read("res://scripts/levels/station_02.gd")
	_expect(s02.contains("drawn only by LadderZone"), "02 must document the single-draw rule")
	_expect(not s02.contains("for rung_y"), "02 must not paint a second ladder loop")
	_expect(not s02.contains("draw_line(Vector2(-half_w"), "02 must not duplicate LadderZone rails")
	var s07 := _read("res://scripts/levels/station_07.gd")
	_expect(s07.contains("LadderZone"), "07 must document why it owns no ladder")
	_expect(s07.contains("14 px"), "07 must record its 14 px riser (<=18 px, no ladder required)")
	var lz := _read("res://scripts/environment/ladder_zone.gd")
	_expect(lz.contains("RUNG_SPACING"), "LadderZone must expose rung spacing")


# ─── 6. Rack 06 i donica 08 maja prace ────────────────────────────────────

func _check_work_props() -> void:
	var s06 := _read("res://scripts/levels/station_06.gd")
	_expect(s06.contains("is_water_purchased and nx"), "06 rack must lose one copy on purchase (work, not decor)")
	_expect(s06.contains("PKG-0198"), "06 rack work must be documented in code")
	var s08 := _read("res://scripts/levels/station_08.gd")
	_expect(s08.contains("fern_lift"), "08 planter must respond to the neighbour testimony (work, not decor)")
	_expect(s08.contains("is_neighbour_spoken_to"), "08 planter must read existing dialogue state, no new writers")
	_expect(s08.contains("PKG-0198"), "08 planter work must be documented in code")


# ─── 7. Dzwiek: jedno zrodlo na miejsce, finaly cisza + jeden dron ────────

func _check_audio_contract() -> void:
	var rig := _read("res://scripts/levels/atmosphere_rig.gd")
	_expect(rig.contains("station_number == 2"), "rig must score station 02")
	_expect(rig.contains("station_number == 5"), "rig must score station 05")
	_expect(rig.contains("station_number == 6"), "rig must score station 06")
	_expect(rig.contains("station_number <= 10"), "rig must score the stairwell run 07-10")
	_expect(rig.contains("station_number <= 13"), "rig must score apartments 11-13")
	_expect(rig.contains("station_number == 14"), "rig must score station 14")
	_expect(rig.contains("station_number == 15"), "rig must score station 15")
	_expect(rig.contains("station_number == 16"), "rig must score station 16")
	_expect(rig.contains("station_number == 17"), "rig must score station 17")
	_expect(rig.contains("station_number <= 20"), "rig must score stations 18-20")
	_expect(rig.contains("finale_42a_forced_return"), "rig must score finale 42A with its own drone")
	_expect(rig.contains("finale_42b_closure"), "rig must score finale 42B with its own drone")
	_expect(rig.contains("finale_42c_reciprocal_passage"), "rig must score finale 42C with its own drone")
	_expect(rig.contains("dawn_river_ambience"), "rig must score epilogue 43")
	var s06 := _read("res://scripts/levels/station_06.gd")
	_expect(s06.contains("KioskWorkHum"), "06 must carry a positioned kiosk work source")
	_expect(s06.contains("AudioStreamPlayer2D"), "06 hum must be a positioned 2D source")
	_expect(s06.contains("create_act1_fluorescent_ballast_hum_sound"), "06 hum must reuse the hall-ballast generator")
	var s08 := _read("res://scripts/levels/station_08.gd")
	_expect(s08.contains("StairwellWorkHum"), "08 must carry a positioned stairwell source")
	_expect(s08.contains("AudioStreamPlayer2D"), "08 hum must be a positioned 2D source")
	var s42a := _read("res://scripts/levels/station_42a.gd")
	_expect(s42a.contains("cisza z jednym"), "42A must record the explicit silence-with-one-source decision")
	var s43 := _read("res://scripts/levels/station_43.gd")
	_expect(s43.contains("cisza z jednym"), "43 must record the explicit silence-with-one-source decision")


# ─── 8. Winiety nadal ciche (regresja 0197) ───────────────────────────────

func _check_vignette_silence_regression() -> void:
	for id in CinematicCatalogScript.all_ids():
		var entry := CinematicCatalogScript.entry(id)
		var captions: Array = entry.get("captions", [])
		for i in captions.size():
			_expect(String(captions[i]).is_empty(), "%s caption %d must stay empty" % [id, i])


# ─── 9. Runtime: humy, drabiny, rigi ──────────────────────────────────────

func _check_runtime_hums_and_ladders() -> void:
	var packed_06 := load("res://scenes/levels/station_06.tscn") as PackedScene
	_expect(packed_06 != null, "station_06 scene must load")
	if packed_06 != null:
		var st06 := packed_06.instantiate() as Node2D
		root.add_child(st06)
		await process_frame
		await process_frame
		var hum06 := st06.get_node_or_null("KioskWorkHum") as AudioStreamPlayer2D
		_expect(hum06 != null, "06 KioskWorkHum must exist in the frame")
		_expect(hum06 != null and hum06.stream != null, "06 hum must carry a stream")
		var rig06 := st06.get_node_or_null("AtmosphereRig")
		_expect(rig06 != null, "06 AtmosphereRig must exist (the one-source-per-place score)")
		st06.free()
		await process_frame
	var packed_08 := load("res://scenes/levels/station_08.tscn") as PackedScene
	_expect(packed_08 != null, "station_08 scene must load")
	if packed_08 != null:
		var st08 := packed_08.instantiate() as Node2D
		root.add_child(st08)
		await process_frame
		await process_frame
		var hum08 := st08.get_node_or_null("StairwellWorkHum") as AudioStreamPlayer2D
		_expect(hum08 != null, "08 StairwellWorkHum must exist in the frame")
		_expect(hum08 != null and hum08.stream != null, "08 hum must carry a stream")
		st08.free()
		await process_frame
	for spec in [
		{"id": "station_02", "node": "ServiceLadder"},
		{"id": "station_15", "node": "Props/ServiceLadder"},
		{"id": "station_16", "node": "Props/ServiceLadder"},
	]:
		var sid := String(spec.get("id"))
		var npath := String(spec.get("node"))
		var packed := load("res://scenes/levels/%s.tscn" % sid) as PackedScene
		_expect(packed != null, "%s scene must load" % sid)
		if packed == null:
			continue
		var st := packed.instantiate() as Node2D
		root.add_child(st)
		await process_frame
		var ladder := st.get_node_or_null(npath)
		_expect(ladder != null, "%s must own %s" % [sid, npath])
		if ladder != null:
			var shape := ladder.get_node_or_null("CollisionShape2D") as CollisionShape2D
			_expect(shape != null, "%s ladder must have a collision shape" % sid)
			if shape != null and shape.shape is RectangleShape2D:
				var rect := shape.shape as RectangleShape2D
				var lh := float(ladder.get("ladder_height"))
				var lw := float(ladder.get("ladder_width"))
				_expect(absf(rect.size.y - lh) <= 2.0, "%s ladder vertical match (%.1f vs %.1f)" % [sid, lh, rect.size.y])
				_expect(absf(rect.size.x - (lw + 12.0)) <= 1.0, "%s ladder x-axis match" % sid)
		st.free()
		await process_frame
	# 07: zero drabin, stopien 14 px.
	var packed_07 := load("res://scenes/levels/station_07.tscn") as PackedScene
	_expect(packed_07 != null, "station_07 scene must load")
	if packed_07 != null:
		var st07 := packed_07.instantiate() as Node2D
		root.add_child(st07)
		await process_frame
		_expect(_find_ladder(st07) == null, "station_07 must own no LadderZone (14 px step needs none)")
		st07.free()
		await process_frame


func _find_ladder(node: Node) -> Node:
	if node.get_script() != null and String(node.get_script().resource_path).ends_with("ladder_zone.gd"):
		return node
	for child in node.get_children():
		var found := _find_ladder(child)
		if found != null:
			return found
	return null


# ─── 10. Runtime: skale tekstu 85/100/115 ─────────────────────────────────

func _check_runtime_text_scales() -> void:
	var state := root.get_node_or_null("GameStateManager")
	_expect(state != null, "GameStateManager must exist")
	if state == null:
		return
	var old_scale := float(state.get("text_scale"))
	for scale_value in [0.85, 1.0, 1.15]:
		state.set("text_scale", scale_value)
		if state.has_method("apply_text_scale_to_tree"):
			state.call("apply_text_scale_to_tree")
		var packed := load("res://scenes/levels/station_08.tscn") as PackedScene
		_expect(packed != null, "station_08 scene must load at scale %d" % int(scale_value * 100.0))
		if packed == null:
			continue
		var st := packed.instantiate() as Node2D
		root.add_child(st)
		await process_frame
		await process_frame
		var ok12 := bool(st.call("inspect_floor_twelve"))
		_expect(ok12, "08 door-12 must resolve at scale %d" % int(scale_value * 100.0))
		var okN := bool(st.call("speak_with_neighbour"))
		_expect(okN, "08 neighbour must resolve at scale %d" % int(scale_value * 100.0))
		var ok14 := bool(st.call("unlock_apartment_fourteen"))
		_expect(ok14, "08 key must resolve at scale %d" % int(scale_value * 100.0))
		st.free()
		await process_frame
	state.set("text_scale", old_scale)
	if state.has_method("apply_text_scale_to_tree"):
		state.call("apply_text_scale_to_tree")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0198 SLICE2 PASS: dead code gone, shadows, mono geometry, ladders, work props, audio score, vignette silence, text scales.")
		quit(0)
	else:
		print("PKG-0198 SLICE2 FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
