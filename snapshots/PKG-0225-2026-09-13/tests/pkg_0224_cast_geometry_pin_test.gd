extends SceneTree

## PKG-0224 gate — cast rigs + family geometry (V7+V3, faza R7, decyzja D-237).
##
## V7 (obsada): wszystkie obecne klatki 5 postaci na plotnie 64x104;
## face-forward standing (idle/talk/listen/gesture/work) 84-92 px;
## seated 56-60 px (marta/wierzbicka/jakub po naprawie spod raw 0172);
## turn_away uziemiony i rozny od idle (korona zwolniona: odwrocona glowa);
## jawne wyjatki vendor/neighbour (brak surowcow raw 0186, brak generacji
## w pakiecie): vendor bez turn_away/seated/work/gesture, neighbour bez
## turn_away/seated/work; rig spada do idle dla brakujacych stanow, a stacje
## 06/08 nigdy ich nie wywoluja.
## V3 (geometria): profil miejski 06 vs mieszkalny 08 nieidentyczny na
## >= 4 pozycjach inwentarza; progi wylacznie z ThresholdZone.aperture_rect
## (rysunek + kolizja z jednego zrodla, wymiary 08 = spec Bindera).
## Pinuje kontrakt mierzalny, nie odbior (D-012, ADR-003).

const ALPHA := 0.4
const CHARS: Array[String] = ["marta", "jakub", "wierzbicka", "vendor", "neighbour"]
const FACE_STATES: Array[String] = ["idle", "talk_0", "talk_1", "listen", "gesture", "work"]
const FULL_CAST: Array[String] = ["marta", "jakub", "wierzbicka"]
const VENDOR_MISSING: Array[String] = ["turn_away", "seated", "work", "gesture"]
const NEIGHBOUR_MISSING: Array[String] = ["turn_away", "seated", "work"]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0224: " + message)


func _run() -> void:
	_test_canvas_and_standing()
	_test_seated()
	_test_turn_away()
	_test_missing_state_exceptions()
	await _test_rig_fallback_runtime()
	_test_family_non_identity()
	_test_aperture_single_source()
	_finish()


func _test_canvas_and_standing() -> void:
	for character_id: String in CHARS:
		for state: String in FACE_STATES:
			var path := "res://assets/characters/%s/%s.png" % [character_id, state]
			var full := FULL_CAST.has(character_id)
			var missing := VENDOR_MISSING.has(state) if character_id == "vendor" else (NEIGHBOUR_MISSING.has(state) if character_id == "neighbour" else false)
			if not full and missing:
				_expect(not FileAccess.file_exists(path), "%s %s must stay absent (D-237 exception)" % [character_id, state])
				continue
			_expect(FileAccess.file_exists(path), "%s %s must exist" % [character_id, state])
			if not FileAccess.file_exists(path):
				continue
			var m := _metrics(path)
			_expect(m.ok, "%s %s must load" % [character_id, state])
			if not m.ok:
				continue
			_expect(m.w == 64 and m.h == 104, "%s %s canvas must be 64x104" % [character_id, state])
			_expect(m.vis_h >= 84 and m.vis_h <= 92, "%s %s standing visible height must be 84-92 (got %d)" % [character_id, state, m.vis_h])


func _test_seated() -> void:
	for character_id: String in FULL_CAST:
		var path := "res://assets/characters/%s/seated.png" % character_id
		_expect(FileAccess.file_exists(path), "%s seated must exist" % character_id)
		if not FileAccess.file_exists(path):
			continue
		var m := _metrics(path)
		_expect(m.vis_h >= 56 and m.vis_h <= 60, "%s seated visible height must be 56-60 (got %d)" % [character_id, m.vis_h])
		var idle := _load_image("res://assets/characters/%s/idle.png" % character_id)
		var seated := _load_image(path)
		_expect(idle != null and seated != null, "%s seated/idle must load" % character_id)
		if idle != null and seated != null:
			_expect(not _same_bytes(idle, seated), "%s seated must not duplicate idle bytes" % character_id)


func _test_turn_away() -> void:
	for character_id: String in FULL_CAST:
		var path := "res://assets/characters/%s/turn_away.png" % character_id
		_expect(FileAccess.file_exists(path), "%s turn_away must exist" % character_id)
		if not FileAccess.file_exists(path):
			continue
		var m := _metrics(path)
		_expect(m.w == 64 and m.h == 104, "%s turn_away canvas must be 64x104" % character_id)
		_expect(m.grounded, "%s turn_away must stay grounded at the pivot line" % character_id)
		var idle := _load_image("res://assets/characters/%s/idle.png" % character_id)
		var away := _load_image(path)
		if idle != null and away != null:
			_expect(not _same_bytes(idle, away), "%s turn_away must differ from idle" % character_id)


func _test_missing_state_exceptions() -> void:
	var s06 := FileAccess.get_file_as_string("res://scripts/levels/station_06.gd")
	var s08 := FileAccess.get_file_as_string("res://scripts/levels/station_08.gd")
	for state: String in VENDOR_MISSING:
		_expect(not s06.contains("set_state(&\"%s\")" % state), "station_06 must never request missing vendor state %s" % state)
	for state: String in NEIGHBOUR_MISSING:
		_expect(not s08.contains("set_state(&\"%s\")" % state), "station_08 must never request missing neighbour state %s" % state)
	_expect(s06.contains("rig.set_state(&\"talk\")") and s06.contains("rig.set_state(&\"listen\")"), "station_06 must drive vendor only via talk/listen/idle")
	_expect(s08.contains("rig.set_state(&\"talk\")") and s08.contains("rig.set_state(&\"listen\")"), "station_08 must drive neighbour only via talk/listen/idle")


func _test_rig_fallback_runtime() -> void:
	var rig_script := load("res://scripts/characters/character_visual_rig.gd") as Script
	_expect(rig_script != null, "CharacterVisualRig script must load")
	if rig_script == null:
		return
	var vendor: Node2D = rig_script.new() as Node2D
	vendor.set("character_id", &"vendor")
	root.add_child(vendor)
	await process_frame
	vendor.call("set_state", &"idle")
	var vendor_idle_tex: Texture2D = (vendor.get("_body") as Sprite2D).texture
	for state: String in VENDOR_MISSING:
		vendor.call("set_state", StringName(state))
		var shown: Texture2D = (vendor.get("_body") as Sprite2D).texture
		_expect(shown == vendor_idle_tex, "vendor missing %s must render idle pixels (no crash, no empty sprite)" % state)
	var neighbour: Node2D = rig_script.new() as Node2D
	neighbour.set("character_id", &"neighbour")
	root.add_child(neighbour)
	await process_frame
	neighbour.call("set_state", &"idle")
	var neighbour_idle_tex: Texture2D = (neighbour.get("_body") as Sprite2D).texture
	for state: String in NEIGHBOUR_MISSING:
		neighbour.call("set_state", StringName(state))
		var shown_n: Texture2D = (neighbour.get("_body") as Sprite2D).texture
		_expect(shown_n == neighbour_idle_tex, "neighbour missing %s must render idle pixels (no crash, no empty sprite)" % state)
	vendor.free()
	neighbour.free()
	await process_frame


func _test_family_non_identity() -> void:
	var s06 := FileAccess.get_file_as_string("res://scenes/levels/station_06.tscn")
	var s08 := FileAccess.get_file_as_string("res://scenes/levels/station_08.tscn")
	_expect(not s06.is_empty() and not s08.is_empty(), "station_06/08 scenes must load as text")
	var score := 0
	if not s06.contains("[node name=\"Ceiling\"") and s08.contains("[node name=\"Ceiling\""):
		score += 1
	if not s06.contains("StairStepUp01") and s08.contains("StairStepUp01") and s08.contains("StairLanding"):
		score += 1
	if not s06.contains("ApartmentDoor14") and s08.contains("ApartmentDoor14"):
		score += 1
	if s06.contains("KioskBlockout") and not s08.contains("KioskBlockout"):
		score += 1
	if s06.contains("OpenSkyWitness") and not s08.contains("OpenSkyWitness"):
		score += 1
	if s06.contains("TimetableStand") and not s08.contains("TimetableStand"):
		score += 1
	_expect(score >= 4, "urban 06 vs residential 08 must differ on >= 4 inventory positions (got %d)" % score)
	_expect(s06.contains("character_id = &\"vendor\""), "station_06 must carry the vendor rig")
	_expect(s08.contains("character_id = &\"neighbour\""), "station_08 must carry the neighbour rig")


func _test_aperture_single_source() -> void:
	var spec06: Dictionary = ThresholdBinder.spec_for("station_06")
	_expect(float(spec06.get("width", 0.0)) == 54.0 and float(spec06.get("height", 0.0)) == 114.0, "binder aperture 06 must be 54x114")
	_expect(String(spec06.get("door", "?")) == "", "binder 06 must bind no drawn door mass")
	_expect(int(spec06.get("family", -1)) == ThresholdZone.Family.DOOR, "binder 06 must be DOOR family")
	var spec08: Dictionary = ThresholdBinder.spec_for("station_08")
	_expect(float(spec08.get("width", 0.0)) == 45.0 and float(spec08.get("height", 0.0)) == 109.0, "binder aperture 08 must be 45x109")
	_expect(String(spec08.get("door", "")) == "ApartmentDoor14", "binder 08 must bind ApartmentDoor14")
	var s08 := FileAccess.get_file_as_string("res://scenes/levels/station_08.tscn")
	_expect(s08.contains("size = Vector2(45, 109)"), "drawn door 08 must match binder aperture 45x109")
	var s06 := FileAccess.get_file_as_string("res://scenes/levels/station_06.tscn")
	_expect(not s06.contains("Rectangle_door"), "station_06 must not hand-draw a second threshold rect")
	_expect(not s06.contains("Door\" type=\"StaticBody2D\""), "station_06 must not carry a door mass outside the aperture")
	var zone_src := FileAccess.get_file_as_string("res://scripts/environment/threshold_zone.gd")
	_expect(zone_src.contains("var rect := aperture_rect"), "ThresholdZone draw must read aperture_rect as the single source")


func _metrics(path: String) -> Dictionary:
	var img := _load_image(path)
	if img == null:
		return {ok = false, vis_h = 0, grounded = false, w = 0, h = 0}
	var ymin := img.get_height()
	var ymax := -1
	for y in img.get_height():
		for x in img.get_width():
			if img.get_pixel(x, y).a <= ALPHA:
				continue
			ymin = mini(ymin, y)
			ymax = maxi(ymax, y)
	var vis_h := (ymax - ymin + 1) if ymax >= 0 else 0
	return {ok = true, vis_h = vis_h, grounded = ymax >= 94, w = img.get_width(), h = img.get_height()}


func _load_image(path: String) -> Image:
	if not FileAccess.file_exists(path):
		return null
	var tex := load(path) as Texture2D
	if tex == null:
		return null
	return tex.get_image()


func _same_bytes(a: Image, b: Image) -> bool:
	if a.get_width() != b.get_width() or a.get_height() != b.get_height():
		return false
	for y in range(0, a.get_height(), 2):
		for x in range(0, a.get_width(), 2):
			var pa := a.get_pixel(x, y)
			var pb := b.get_pixel(x, y)
			if absf(pa.r - pb.r) + absf(pa.g - pb.g) + absf(pa.b - pb.b) + absf(pa.a - pb.a) > 0.01:
				return false
	return true


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0224 CAST GEOMETRY PASS: rigs, exceptions, family profiles, aperture lint.")
		quit(0)
	else:
		print("PKG-0224 CAST GEOMETRY FAIL: %d failures" % _failures.size())
		for failure in _failures:
			print(" - %s" % failure)
		quit(1)
