extends SceneTree

## PKG-0236 gate — Pakiet B: ciecia, nie teleporty (plan 2026-09-15, decyzja D-248).
##
## Dowodzi wylacznie mierzalnych kontraktow runtime, nie odbioru (D-012, ADR-003).
## Kryteria (NEXT_SESSION_PROMPT PKG-0236 / plan 2026-09-15 Pakiet B, B1–B4):
## 1. binder 13 wychodzi HATCH (jak 14/15); 09/10 zostaja DOOR (pokoj -> pokoj);
## 2. binder 12 zostaje DOOR i nie wskazuje BalconyDoor (pin A z PKG-0234 stoi);
## 3. mysl wyjscia 10 (s10_exit_ucp_record) nazywa wyjscie z domu do UCP
##    (telefon + wychodze) i zachowuje hipoteze pinowana bramka 0233;
## 4. 14 wita wlazem (opening_line_2), 13 nazywa wyjscie wlazem i sekcja;
## 5. routing: 12->13 i 17->18 z prawej, reszta odcinka 10-18 z lewej
##    (arrival_side_for bez nowych wyjatkow — B2 bez zmian w GSM);
## 6. most 11->12 (kontakt do warsztatu), wyjscie 12 do domu i wyjscie 16
##    do rejestru stoja; cue nocy przy slupku 42A/B/C nietkniete.

const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")

const FAMILY_DOOR := 0
const FAMILY_HATCH := 2

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0236 FAILURE: " + message)


func _read(path: String) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "plik musi byc czytelny: %s" % path)
	if file == null:
		return ""
	var text := file.get_as_text()
	file.close()
	return text


func _open(num: int) -> Node2D:
	var packed := load("res://scenes/levels/station_%02d.tscn" % num) as PackedScene
	_expect(packed != null, "scena station_%02d musi sie ladowac" % num)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close(station: Node) -> void:
	if station == null:
		return
	station.queue_free()
	await process_frame


func _run() -> void:
	_test_binder_13_hatch()
	_test_binder_12_not_balcony()
	await _test_live_13_hatch()
	_test_station_10_exit_sentence()
	_test_station_14_greets_hatch()
	_test_arrival_sides()
	_test_bridge_lines_intact()
	_finish()


func _test_binder_13_hatch() -> void:
	print("1. Binder 13 exits as HATCH; 09/10 stay DOOR...")
	var spec13: Dictionary = ThresholdBinderScript.spec_for("station_13")
	_expect(not spec13.is_empty(), "binder spec for station_13 must exist")
	_expect(int(spec13.get("family", -1)) == FAMILY_HATCH,
		"station_13 threshold family must be HATCH (got %s)" % str(spec13.get("family", -1)))
	_expect(float(spec13.get("width", 0.0)) >= 50.4 and float(spec13.get("width", 0.0)) <= 77.0,
		"station_13 HATCH width must be §7.1-legal")
	_expect(float(spec13.get("height", 0.0)) >= 50.4 and float(spec13.get("height", 0.0)) <= 77.0,
		"station_13 HATCH height must be §7.1-legal")
	_expect(String(spec13.get("door", "MISSING")).is_empty(),
		"station_13 HATCH must not block on a door body")
	for flat in ["station_09", "station_10"]:
		var spec: Dictionary = ThresholdBinderScript.spec_for(flat)
		_expect(int(spec.get("family", -1)) == FAMILY_DOOR,
			"%s stays DOOR (room to room, not a cut)" % flat)


func _test_binder_12_not_balcony() -> void:
	print("2. Binder 12 stays DOOR and never names BalconyDoor (pin A)...")
	var spec: Dictionary = ThresholdBinderScript.spec_for("station_12")
	_expect(not spec.is_empty(), "binder spec for station_12 must exist")
	_expect(int(spec.get("family", -1)) == FAMILY_DOOR,
		"station_12 threshold family must stay DOOR")
	_expect(String(spec.get("door", "MISSING")).find("BalconyDoor") < 0,
		"binder door for 12 must not name BalconyDoor")


func _test_live_13_hatch() -> void:
	print("3. Installed Threshold on 13 is a live HATCH...")
	var station := await _open(13)
	if station == null:
		return
	ThresholdBinderScript.install(station)
	await process_frame
	var zone := station.get_node_or_null("Threshold")
	_expect(zone != null, "station_13 must receive a Binder threshold")
	if zone != null:
		_expect(int(zone.get("entry_family")) == FAMILY_HATCH,
			"installed 13 threshold must be HATCH (got %s)" % str(zone.get("entry_family")))
	await _close(station)


func _test_station_10_exit_sentence() -> void:
	print("4. Station 10 names leaving home for UCP, keeps the 0233 hypothesis...")
	var source := _read("res://scripts/levels/station_10.gd")
	_expect(source.contains("s10_exit_ucp_record"), "10 keeps the exit beat id (pin 0230)")
	_expect(source.contains("Marta twierdzi"), "10 starts from Marta's claim (pin 0233)")
	_expect(source.contains("zanim uznam to za moje"), "10 defers the claim to the record check (pin 0233)")
	_expect(not source.contains("W UCP, tam pracuj"), "10 does not claim UCP work before biometrics (pin 0233)")
	_expect(source.to_lower().contains("wychodz"), "10 names the act of leaving home")
	_expect(source.to_lower().contains("telefon"), "10 leaves the phone with Marta")
	_expect(source.contains("UCP"), "10 names the UCP record as the destination")
	_expect(not source.contains("teleport"), "10 never names a teleport")
	_expect(not source.contains("Równi"), "10 never names Równia (Pakiet D)")


func _test_station_14_greets_hatch() -> void:
	print("5. Station 14 greets with the hatch; 13 names flat + hatch + section...")
	var cue14 := _read("res://scenes/levels/station_14.tscn")
	_expect(cue14.contains("włazem serwisowym") or cue14.contains("wlazem"),
		"14 greets the arrival with the service hatch")
	_expect(cue14.contains("20:40"), "14 keeps the 20:40 trail (pin 0230)")
	var s13 := _read("res://scripts/levels/station_13.gd")
	_expect(s13.contains("s13_exit_to_switchyard"), "13 keeps its exit beat (pin 0230)")
	_expect(s13.contains("Wychodzę z mieszkania"), "13 names leaving the flat")
	_expect(s13.contains("włazem serwisowym") or s13.contains("wlazem"),
		"13 names the descent as HATCH, matching its threshold family")
	_expect(s13.contains("sekcj"), "13 points at the switchyard section from the extract")


func _arrival(from_id: String, to_id: String) -> String:
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm == null or not gsm.has_method("arrival_side_for"):
		_expect(false, "GameStateManager.arrival_side_for must exist")
		return ""
	return String(gsm.call("arrival_side_for", StringName(from_id), StringName(to_id)))


func _test_arrival_sides() -> void:
	print("6. Routing 10-18: story returns from the right, the rest from the left...")
	_expect(_arrival("station_12", "station_13") == "right", "12 -> 13 enters from the right (return home)")
	_expect(_arrival("station_17", "station_18") == "right", "17 -> 18 enters from the right (return to the street)")
	_expect(_arrival("station_10", "station_11") == "left", "10 -> 11 enters from the left (UCP hall entrance)")
	_expect(_arrival("station_11", "station_12") == "left", "11 -> 12 enters from the left (workshop entrance)")
	_expect(_arrival("station_13", "station_14") == "left", "13 -> 14 enters from the left (switchyard bottom)")
	_expect(_arrival("station_14", "station_15") == "left", "14 -> 15 enters from the left (loop chamber)")
	_expect(_arrival("station_15", "station_16") == "left", "15 -> 16 enters from the left (analyzer room)")
	_expect(_arrival("station_16", "station_17") == "left", "16 -> 17 enters from the left (first entry to the hall)")


func _test_bridge_lines_intact() -> void:
	print("7. Workshop contact, home return, ledger exit and 42 night cues intact...")
	var lines := _read("res://scripts/levels/creative_scene_lines.gd")
	_expect(lines.contains("kontakt do warsztatu"), "11 keeps the workshop contact (bridge 11 -> 12)")
	_expect(_read("res://scripts/levels/station_12.gd").contains("s12_exit_back_home"),
		"12 keeps its exit home (pin 0230)")
	_expect(_read("res://scripts/levels/station_16.gd").contains("s16_exit_to_ledger"),
		"16 keeps its ledger exit (pin 0230)")
	for finale in ["station_42a", "station_42b", "station_42c"]:
		var cue := _read("res://scenes/levels/%s.tscn" % finale)
		_expect(cue.contains("W nocy przy słupku"), "%s keeps the night-at-the-post opening" % finale)


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0236 PASS: every right exit reads as a world sentence; 13 exits HATCH, 14 greets HATCH.")
		quit(0)
	else:
		print("PKG-0236 FAIL: %d" % _failures.size())
		for item in _failures:
			print("  - ", item)
		quit(1)
