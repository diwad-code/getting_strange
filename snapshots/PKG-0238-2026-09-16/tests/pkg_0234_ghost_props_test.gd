extends SceneTree

## PKG-0234 gate — Pakiet A: duchy w pokojach (decyzja D-246).
##
## Dowodzi wylacznie mierzalnych kontraktow runtime, nie odbioru (D-012, ADR-003).
## Kryteria (NEXT_SESSION_PROMPT PKG-0234):
## 1. wezly StairwellPlanter / HallwaySideboard / BalconyDoor / DeskDrawer
##    zostaja w drzewie (piny 0100/0119/0135/0146/smoke/0192);
## 2. kampania 09 odblokowuje prog tryptykiem P9 bez is_passage_clear;
## 3. kampania 11 odblokowuje prog wyciagiem bez pchania komody;
## 4. binder 12 nie wskazuje BalconyDoor jako blocking_body progu;
## 5. synteza 13 nie czeka na szuflade;
## 6. collidery duchow nie stoja na drodze do prawej krawedzi;
## 7. pin 0192: fraza ZOSTAJE jako w komentarzach 11/12/13.

const ThresholdBinderScript := preload("res://scripts/environment/threshold_binder.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	printerr("PKG-0234 FAILURE: " + message)


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
	station.queue_free()
	await process_frame


func _shape_disabled(body: Node) -> bool:
	if body == null:
		return false
	var shape := body.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape != null:
		return shape.disabled
	var poly := body.get_node_or_null("CollisionPolygon2D") as CollisionPolygon2D
	if poly != null:
		return poly.disabled
	return false


func _walk_right(station: Node2D, target_x: float) -> float:
	var player := station.get_node_or_null("Player") as PrototypePlayer
	_expect(player != null, "%s must have Player" % station.name)
	if player == null:
		return -1.0
	player.set_physics_process(false)
	var frames := 360
	while frames > 0:
		frames -= 1
		var dx := target_x - player.global_position.x
		if absf(dx) <= 8.0:
			break
		if not player.is_on_floor():
			player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
		else:
			player.velocity.y = 0.0
		player.velocity.x = signf(dx) * 120.0
		player.move_and_slide()
		if player.has_method("try_curb_step"):
			player.try_curb_step(dx)
		await physics_frame
	return player.global_position.x


func _run() -> void:
	await _test_nodes_remain()
	await _test_station_09_campaign()
	await _test_station_11_campaign()
	await _test_station_12_binder()
	await _test_station_13_synthesis()
	await _test_walk_off_ghosts()
	_test_pin_0192()
	_finish()


func _test_nodes_remain() -> void:
	print("1. Ghost prop nodes remain in the tree...")
	var s09 := await _open(9)
	if s09 != null:
		_expect(s09.get_node_or_null("Geometry/StairwellPlanter") is MovableAnchorableProp,
			"station_09 StairwellPlanter must remain")
		_expect(s09.get_node_or_null("Geometry/StairFlight") is StaticBody2D,
			"station_09 StairFlight node must remain")
		await _close(s09)
	var s11 := await _open(11)
	if s11 != null:
		_expect(s11.get_node_or_null("Geometry/HallwaySideboard") is MovableAnchorableProp,
			"station_11 HallwaySideboard must remain")
		await _close(s11)
	var s12 := await _open(12)
	if s12 != null:
		_expect(s12.get_node_or_null("Geometry/BalconyDoor") is AnimatableBody2D,
			"station_12 BalconyDoor must remain")
		await _close(s12)
	var s13 := await _open(13)
	if s13 != null:
		_expect(s13.get_node_or_null("Geometry/DeskDrawer") is AnimatableBody2D,
			"station_13 DeskDrawer must remain")
		await _close(s13)


func _test_station_09_campaign() -> void:
	print("2. Station 09 campaign unlocks without is_passage_clear...")
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p7.foreign_daily_life.trace", "two_lives_source")
	var station := await _open(9)
	if station == null:
		return
	station.set("is_passage_clear", false)
	_expect(station.observe_two_lives(), "09 two_lives must register")
	_expect(station.observe_relation_photo(), "09 relation_photo must register")
	_expect(station.respect_private_boundary(), "09 private_boundary must register without passage")
	_expect(station.get("is_exit_unlocked") == true, "09 exit unlocks on P9 triptych, not planter")
	_expect(station.get("is_passage_clear") == false, "09 campaign must not set is_passage_clear")
	await _close(station)


func _test_station_11_campaign() -> void:
	print("3. Station 11 campaign unlocks without pushing the sideboard...")
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p9.mystery.marta.trace", "boundary_respected")
	var station := await _open(11)
	if station == null:
		return
	station.set("is_passage_clear", false)
	_expect(station.present_identity_card(), "11 card must register")
	_expect(station.read_186_day_record(), "11 record must register")
	_expect(station.request_minimal_report(), "11 report must register without passage")
	_expect(station.get("is_exit_unlocked") == true, "11 exit unlocks on P9 triptych, not sideboard")
	_expect(station.get("is_passage_clear") == false, "11 campaign must not set is_passage_clear")
	await _close(station)


func _test_station_12_binder() -> void:
	print("4. Station 12 binder must not use BalconyDoor as the threshold body...")
	var spec: Dictionary = ThresholdBinderScript.spec_for("station_12")
	_expect(not spec.is_empty(), "binder spec for station_12 must exist")
	var door := String(spec.get("door", "MISSING"))
	_expect(door.find("BalconyDoor") < 0, "binder door for 12 must not name BalconyDoor (got %s)" % door)
	_expect(int(spec.get("family", -1)) == 0, "station_12 threshold family must stay DOOR")
	var station := await _open(12)
	if station == null:
		return
	ThresholdBinderScript.install(station)
	await process_frame
	var zone := station.get_node_or_null("Threshold")
	_expect(zone != null, "station_12 must receive a Binder threshold")
	if zone != null:
		var path := String(zone.get("blocking_body_path"))
		_expect(path.find("BalconyDoor") < 0,
			"installed 12 threshold must not block on BalconyDoor (got %s)" % path)
	var balcony := station.get_node_or_null("Geometry/BalconyDoor") as AnimatableBody2D
	_expect(balcony != null, "BalconyDoor node must remain")
	if balcony != null:
		_expect(_shape_disabled(balcony), "BalconyDoor collider must be off the walking route")
		_expect(balcony.position.x < 480.0, "BalconyDoor must not sit on the right-edge exit")
	await _close(station)


func _test_station_13_synthesis() -> void:
	print("5. Station 13 synthesis must not wait on the drawer...")
	var state := root.get_node_or_null("GameStateManager")
	if state:
		state.reset_campaign(true)
		state.record_decision(&"p9.mystery.home.trace", "two_lives_without_claim")
		state.record_decision(&"p9.mystery.institution.trace", "biometric_history_186_days")
		state.record_decision(&"p9.mystery.jakub.trace", "voluntary_proof_after_refusal")
		state.record_decision(&"recognition_evidence_public", true)
		state.record_decision(&"recognition_evidence_relational", true)
	var station := await _open(13)
	if station == null:
		return
	station.set("is_drawer_open", false)
	_expect(station.mark_marta_source_seen(), "13 marta source must register")
	_expect(station.mark_institution_source_seen(), "13 institution source must register")
	_expect(station.synthesize_world_difference(), "13 synthesis must close without opening the drawer")
	_expect(station.get("is_exit_unlocked") == true, "13 exit unlocks on synthesis, not drawer")
	_expect(station.get("is_drawer_open") == false, "13 synthesis must not open the drawer")
	var drawer := station.get_node_or_null("Geometry/DeskDrawer") as AnimatableBody2D
	if drawer != null:
		_expect(_shape_disabled(drawer), "DeskDrawer collider must stay off the walking route")
	await _close(station)


func _test_walk_off_ghosts() -> void:
	print("6. Walking 09/11/12/13 to the right edge must not require ghost pushes...")
	for num in [9, 11, 12, 13]:
		var station := await _open(num)
		if station == null:
			continue
		if num == 9:
			var stairs := station.get_node_or_null("Geometry/StairFlight")
			_expect(_shape_disabled(stairs), "station_09 StairFlight must not block the salon")
		var x := await _walk_right(station, 560.0)
		_expect(x >= 540.0, "station_%02d player must reach the right edge without ghost bodies (x=%.1f)" % [num, x])
		await _close(station)


func _test_pin_0192() -> void:
	print("7. Pin 0192 comments keep HallwaySideboard/BalconyDoor/DeskDrawer + ZOSTAJE jako...")
	var required := {
		"res://scripts/levels/station_11.gd": ["HallwaySideboard", "ZOSTAJE jako"],
		"res://scripts/levels/station_12.gd": ["BalconyDoor", "ZOSTAJE jako"],
		"res://scripts/levels/station_13.gd": ["DeskDrawer", "ZOSTAJE jako"],
	}
	for path in required.keys():
		var text := _read(path)
		for needle: String in required[path]:
			_expect(text.find(needle) >= 0, "%s must keep %s" % [path, needle])


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0234 PASS: ghost props off the campaign route; nodes remain; P9 verbs unlock 09/11/13; binder 12 is not a balcony.")
		quit(0)
	else:
		print("PKG-0234 FAIL: %d" % _failures.size())
		for item in _failures:
			print("  - ", item)
		quit(1)
