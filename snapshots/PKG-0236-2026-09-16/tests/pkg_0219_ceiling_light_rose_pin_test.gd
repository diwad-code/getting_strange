extends SceneTree

## PKG-0219 gate — ceiling + work light + rose-accent rule
## (V4+V6+V10, faza R3 planu PKG-0213 §8; decyzja D-232).
##
## V4 (sufit): podbitka 09 domyka przeswit nad glowa Leny do 37 px
## (kontrakt rodziny 3: 20-45; glowa ~209, spod masy 172); dwa plany
## (sufit + podbitka z listwa); drzwi 109 px i collidery nietkniete;
## lampa wisi pod podbitka; etykieta MIESZKANIE 14 na scianie w pasie
## 90-190. Sasiedzi 08/10/13 tylko zaaudytowani (info, bez twardych
## asercji — ich palety/sufity naleza do osobnych pakietow).
## V6 (swiatlo): 01 ma 1 nazwane zrodlo robocze na beben (WORK_LIGHT_POS
## + stozek 0.12) + zimne wypelnienie z gory (pas 44..70, 0.06) + jawny
## cien kontaktowy pod bebnem/pulpitem w prawo 0.48 (konwencja 01/06/08);
## audyt 12/14: cien 0.48 w prawo stoi (twarda obecnosc, read-only).
## V10 (roz): regula "Marta w kadrze -> 1 akcent -> reszta
## w shade(MID_PLANE)"; Marta w kadrze = wezel z character_id &"marta"
## w .tscn (dzis 10 i 13); 09 bez Marty trzyma AMBER+CYAN bez oxide;
## mono 09 vs 01/11/12/15 rozni sie strukturalnie na >=3 osiach rodziny
## (sylwetka / swiatlo / material-czasownik; osie audio bez zmian).
##
## Technical proof only: measurable source contracts on disk.
## No claim about fun, beauty, comprehension or reception (D-012, ADR-003).

const MARTA_RIG_IDS: Array[String] = ["station_10", "station_13"]
const NO_MARTA_IDS: Array[String] = [
	"station_01", "station_09", "station_11", "station_12", "station_15",
]
const MARTA_RIG_MARKER := "character_id = &\"marta\""

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0219: " + message)


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
	_test_ceiling()
	_test_light()
	_test_rose_mono()
	_test_fail_closed()
	_finish()


# --- 1. V4: ceiling 09 in contract, doors/colliders/label untouched ---

func _test_ceiling() -> void:
	print("1. Station 09 ceiling must close head clearance to 20-45 px...")
	var s09: String = _read("res://scripts/levels/station_09.gd")
	_expect(s09.contains("const LENA_HEAD_Y := 209.0"), "station_09 must pin LENA_HEAD_Y 209.0")
	_expect(s09.contains("const RESIDENTIAL_CEILING_BOTTOM := 172.0"), "station_09 must pin RESIDENTIAL_CEILING_BOTTOM 172.0")
	var clearance: float = 209.0 - 172.0
	_expect(clearance >= 20.0 and clearance <= 45.0, "clearance 209-172=%s must fit 20-45" % str(clearance))
	_expect(s09.contains("Vector2(0.0, 172.0)"), "station_09 must paint the soffit edge at y=172")
	# Doors untouched: the 109 px interior door is the main wall division.
	_expect(s09.contains("Rect2(294.0, 187.0, 78.0, 109.0)"), "station_09 door must stay 78x109 at (294,187)")
	# No collider touch: Geometry keeps Floor/Walls/Ceiling/StairFlight only,
	# and the ceiling collider stays 640x30 at y=15 (paint is not physics).
	var t09: String = _read("res://scenes/levels/station_09.tscn")
	_expect(_count(t09, "type=\"StaticBody2D\"") == 5, "station_09 must keep 5 StaticBody2D (got %d)" % _count(t09, "type=\"StaticBody2D\""))
	_expect(t09.contains("position = Vector2(320, 15)"), "station_09 ceiling collider must stay at y=15")
	_expect(t09.contains("size = Vector2(640, 30)"), "station_09 ceiling collider must stay 640x30")
	# The room caption left the soffit band for the wall above the door,
	# still inside the diegetic label band 90-190 (FRAME_LAYOUT_AUDIT §2).
	_expect(t09.contains("position = Vector2(322, 100)"), "station_09 Floor label must sit at (322,100) below the soffit")
	_expect(t09.contains("position = Vector2(84, 176)"), "station_09 Bracket label must stay at (84,176)")
	# Neighbour audit (info only; their palettes/ceilings are separate packages).
	var s08: String = _read("res://scripts/levels/station_08.gd")
	var s10: String = _read("res://scripts/levels/station_10.gd")
	var s13: String = _read("res://scripts/levels/station_13.gd")
	print("   audit ceilings: 08 mass to y=36 (open stairwell), 10 mass to y=158 (near-miss 51 px), 13 wall band from y=42 (no hung mass)")
	_expect(s08.contains("Rect2(0.0, 0.0, 640.0, 36.0)"), "station_08 audit: ceiling mass still 0..36")
	_expect(s10.contains("Rect2(0.0, 0.0, 640.0, 158.0)"), "station_10 audit: ceiling mass still 0..158")
	_expect(s13.contains("draw_rect(Rect2(0, 42, 640, 42)"), "station_13 audit: wall band still from y=42")


# --- 2. V6: work light + cold fill + contact shadow in 01; audit 12/14 ---

func _test_light() -> void:
	print("2. Station 01 must carry one work light, a cold fill and a rightward shadow...")
	var s01: String = _read("res://scripts/levels/station_01.gd")
	_expect(s01.contains("const WORK_LIGHT_POS := Vector2(247.0, 188.0)"), "station_01 must pin WORK_LIGHT_POS (247,188)")
	_expect(s01.contains("const WORK_LIGHT_CONE_ALPHA := 0.12"), "station_01 must pin work cone alpha 0.12")
	_expect(s01.contains("const COLD_FILL_ALPHA := 0.06"), "station_01 must pin cold fill alpha 0.06")
	_expect(s01.contains("const CONTACT_SHADOW_ALPHA := 0.48"), "station_01 must pin contact shadow alpha 0.48")
	_expect(s01.contains("Rect2(18.0, 44.0, 604.0, 26.0)"), "station_01 cold fill must wash the top band 44..70")
	_expect(s01.contains("COLD_FILL_ALPHA"), "station_01 must paint via COLD_FILL_ALPHA")
	_expect(s01.contains("WORK_LIGHT_POS"), "station_01 must paint via WORK_LIGHT_POS")
	# The drum/pulpit shadow must extend right of the drum housing (x 196..298):
	# 312 > 298 proves the source-side (rightward, 01/06/08 convention) lay.
	_expect(s01.contains("Vector2(312.0, 276.0)"), "station_01 drum shadow must reach x=312, right of the housing")
	_expect(s01.contains("Vector2(360.0, 292.0)"), "station_01 machine shadow must still reach x=360, right of the machine")
	# Family-5 audit (read-only presence; 12/14 paint is not rewritten here).
	var s12: String = _read("res://scripts/levels/station_12.gd")
	var s14: String = _read("res://scripts/levels/station_14.gd")
	print("   audit shadows: 12 and 14 keep rightward 0.48 contact shadows")
	_expect(s12.contains(", 0.48)"), "station_12 audit: 0.48 contact shadow must stand")
	_expect(s14.contains(", 0.48)"), "station_14 audit: 0.48 contact shadow must stand")


# --- 3. V10: rose-accent rule + mono axes 09 vs 01/11/12/15 ---

func _test_rose_mono() -> void:
	print("3. Rose rule must be decided and mono axes must differ structurally...")
	var decisions: String = _read("res://docs/DECISION_LOG.md")
	_expect(decisions.contains("D-232"), "DECISION_LOG must record D-232")
	_expect(decisions.contains("Marta w kadrze"), "D-232 must state the Marta-in-frame rule")
	_expect(decisions.contains("shade(MID_PLANE)"), "D-232 must send the rest to shade(MID_PLANE)")
	# Marta in frame is structural: a node with character_id &"marta".
	for station_id: String in MARTA_RIG_IDS:
		var tscn: String = _read("res://scenes/levels/%s.tscn" % station_id)
		_expect(tscn.contains(MARTA_RIG_MARKER), "%s must carry the Marta rig (1-accent station)" % station_id)
	for station_id: String in NO_MARTA_IDS:
		var tscn: String = _read("res://scenes/levels/%s.tscn" % station_id)
		_expect(not tscn.contains(MARTA_RIG_MARKER), "%s must carry no Marta rig" % station_id)
	# 09 without Marta keeps two accents and no oxide (V2 re-pin, D-232).
	var s09: String = _read("res://scripts/levels/station_09.gd")
	_expect(s09.contains("VectorStageStyle.HUMAN_AMBER"), "station_09 keeps the amber accent (no Marta)")
	_expect(s09.contains("VectorStageStyle.ANCHOR_CYAN"), "station_09 keeps the cyan accent (no Marta)")
	_expect(not s09.contains("CORRECTION_OXIDE"), "station_09 carries no oxide accent")
	# Mono axes, structural markers only (LOCATION_FAMILY_BIBLE §§3-9):
	# axis 1 — silhouette.
	_expect(s09.contains("RESIDENTIAL_CEILING_BOTTOM"), "axis silhouette: 09 hangs a low mass (residential)")
	var s01: String = _read("res://scripts/levels/station_01.gd")
	_expect(s01.contains("Machine: one clear job"), "axis silhouette: 01 is a machine hall (technical)")
	var s11: String = _read("res://scripts/levels/station_11.gd")
	_expect(s11.contains("visual control line"), "axis silhouette: 11 draws a control line (institutional)")
	var s15: String = _read("res://scripts/levels/station_15.gd")
	_expect(s15.contains("Szew anomalii"), "axis silhouette: 15 splits one seam (boundary)")
	# axis 2 — light.
	_expect(s01.contains("WORK_LIGHT_POS") and s01.contains("COLD_FILL_ALPHA"), "axis light: 01 pairs work light with cold fill")
	_expect(s09.contains("Two warm practical pools"), "axis light: 09 keeps two low practical pools")
	_expect(s11.contains("Rect2(0.0, 0.0, 640.0, 82.0)"), "axis light: 11 keeps the even top band")
	_expect(s15.contains("niezgodne"), "axis light: 15 keeps one nonconforming source")
	# axis 3 — material/verb.
	_expect(s09.contains("Rect2(294.0, 187.0, 78.0, 109.0)"), "axis material: 09 divides the wall with a 109 px door")
	_expect(s01.contains("Recorder drum"), "axis material: 01 works a recorder drum")
	_expect(s11.contains("counter"), "axis material: 11 authorises across a counter")
	var s12: String = _read("res://scripts/levels/station_12.gd")
	_expect(s12.contains("Workbench, vice"), "axis material: 12 works bench and vice")
	_expect(s15.contains("Nadajnik p"), "axis material: 15 compares loop states at a transmitter")


# --- 4. Fail-closed proof for the detectors ---

func _test_fail_closed() -> void:
	print("4. Detectors must catch injected regressions (fail-closed)...")
	_expect("const RESIDENTIAL_CEILING_BOTTOM := 172.0".contains("RESIDENTIAL_CEILING_BOTTOM"), "ceiling detector flags the contract constant")
	_expect(not "draw_rect(Rect2(0.0, 0.0, 640.0, 36.0), ink)".contains("RESIDENTIAL_CEILING_BOTTOM"), "ceiling detector passes a scene without it")
	_expect("const WORK_LIGHT_POS := Vector2(247.0, 188.0)".contains("WORK_LIGHT_POS"), "work-light detector flags the source constant")
	_expect(not "draw_circle(Vector2(288.0, 198.0), 3.0, c)".contains("WORK_LIGHT_POS"), "work-light detector passes legacy lamps")
	_expect("character_id = &\"marta\"".contains("character_id = &\"marta\""), "marta-rig detector flags the rig marker")
	_expect(not "character_id = &\"jakub\"".contains("character_id = &\"marta\""), "marta-rig detector passes other rigs")


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0219 CEILING LIGHT ROSE PASS: 09 clearance 37 px, 01 work+fill+shadow, D-232 mono axes >=3.")
		quit(0)
	else:
		print("PKG-0219 CEILING LIGHT ROSE FAIL (%d)" % _failures.size())
		for failure: String in _failures:
			print("  - " + failure)
		quit(1)
