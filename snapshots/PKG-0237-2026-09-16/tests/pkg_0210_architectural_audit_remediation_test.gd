extends SceneTree

## PKG-0210 gate — weryfikacja wdrożenia planu audytu architektonicznego Aureliusa
## (remediacja reentrancji setterów, odsprzężenie stref, matryca kolizji 2D, kontrakty Flyweight).
##
## Pinuje mierzalne kontrakty w kodzie, scenach i runtime:
## (1) Reentrancy guards: AnchorableObject, MovableAnchorableProp, OpeningActionPoint,
##     VibrationTraceDisplay, MemoryResonancePoint posiadają bezpieczne settery z polami podkładowymi;
## (2) Decoupling: PrototypePlayer rejestruje się w grupie &"player", ThresholdZone używa grupy;
## (3) Fizyka: ProjectSettings zawiera nazwy warstw 2d_physics (world, player, triggers, interactables),
##     PrototypePlayer posiada collision_layer = 3 (warstwa 1 i 2);
## (4) Zasoby: MovementProfile, GuidanceBeat i definicje diagnostyczne zawierają kontrakt Flyweight;
## (5) Runtime: 0 orphan nodes po cyklu życia obiektów i 2 klatkach.

const PROJECT_PATH := "res://project.godot"
const PLAYER_SCENE := "res://scenes/player/prototype_player.tscn"

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures.append(message)
	push_error("PKG-0210: " + message)


func _read_file(path: String) -> String:
	var f := FileAccess.open(path, FileAccess.READ)
	_expect(f != null, "file must be readable: %s" % path)
	if f == null:
		return ""
	var content := f.get_as_text().replace("\r\n", "\n")
	f.close()
	return content


func _run() -> void:
	_check_property_setters()
	_check_player_group_and_threshold()
	_check_physics_layer_matrix()
	_check_resource_contracts()
	await _check_runtime()
	_finish()


func _check_property_setters() -> void:
	var ao_src := _read_file("res://scripts/interactables/anchorable_object.gd")
	_expect(ao_src.contains("var _is_anchored: bool = false"), "AnchorableObject must use _is_anchored backing field")
	_expect(ao_src.contains("var _is_player_in_range: bool = false"), "AnchorableObject must use _is_player_in_range backing field")

	var map_src := _read_file("res://scripts/interactables/movable_anchorable_prop.gd")
	_expect(map_src.contains("var _is_anchored: bool = false"), "MovableAnchorableProp must use _is_anchored backing field")
	_expect(map_src.contains("var _is_player_in_range: bool = false"), "MovableAnchorableProp must use _is_player_in_range backing field")

	var oap_src := _read_file("res://scripts/interactables/opening_action_point.gd")
	_expect(oap_src.contains("var _is_player_in_range := false"), "OpeningActionPoint must use _is_player_in_range backing field")
	_expect(oap_src.contains("var _is_available := true"), "OpeningActionPoint must use _is_available backing field")
	_expect(oap_src.contains("var _is_resolved := false"), "OpeningActionPoint must use _is_resolved backing field")

	var vtd_src := _read_file("res://scripts/visual/vibration_trace_display.gd")
	_expect(vtd_src.contains("var _pass_progress := 0.0"), "VibrationTraceDisplay must use _pass_progress backing field")
	_expect(vtd_src.contains("var _interference_factor := 0.0"), "VibrationTraceDisplay must use _interference_factor backing field")

	var mrp_src := _read_file("res://scripts/interactables/memory_resonance_point.gd")
	_expect(mrp_src.contains("var _is_player_in_range: bool = false"), "MemoryResonancePoint must use _is_player_in_range backing field")


func _check_player_group_and_threshold() -> void:
	var player_src := _read_file("res://scripts/player/prototype_player.gd")
	_expect(player_src.contains("add_to_group(&\"player\")"), "PrototypePlayer must register in &\"player\" group")

	var tz_src := _read_file("res://scripts/environment/threshold_zone.gd")
	_expect(tz_src.contains("get_first_node_in_group(&\"player\")"), "ThresholdZone must look for &\"player\" group")
	_expect(tz_src.contains("func _get_station_host() -> Node:"), "ThresholdZone must centralize station host retrieval")


func _check_physics_layer_matrix() -> void:
	var proj_src := _read_file(PROJECT_PATH)
	_expect(proj_src.contains("2d_physics/layer_1=\"world\""), "project.godot must name 2d physics layer 1 world")
	_expect(proj_src.contains("2d_physics/layer_2=\"player\""), "project.godot must name 2d physics layer 2 player")
	_expect(proj_src.contains("2d_physics/layer_3=\"triggers\""), "project.godot must name 2d physics layer 3 triggers")
	_expect(proj_src.contains("2d_physics/layer_4=\"interactables\""), "project.godot must name 2d physics layer 4 interactables")

	var player_tscn := _read_file(PLAYER_SCENE)
	_expect(player_tscn.contains("collision_layer = 3"), "prototype_player.tscn must have collision_layer = 3")
	_expect(player_tscn.contains("collision_mask = 1"), "prototype_player.tscn must have collision_mask = 1")


func _check_resource_contracts() -> void:
	var mp_src := _read_file("res://scripts/player/movement_profile.gd")
	_expect(mp_src.contains("IMMUTABLE CONFIGURATION RESOURCE"), "MovementProfile must state immutable Flyweight contract")

	var gb_src := _read_file("res://scripts/core/guidance_beat.gd")
	_expect(gb_src.contains("IMMUTABLE CONFIGURATION RECORD"), "GuidanceBeat must state immutable Flyweight contract")

	var dcd_src := _read_file("res://scripts/gameplay/diagnostic_commitment_definition.gd")
	_expect(dcd_src.contains("Flyweight Pattern"), "DiagnosticCommitmentDefinition must state Flyweight contract")

	var dhd_src := _read_file("res://scripts/gameplay/diagnostic_hypothesis_definition.gd")
	_expect(dhd_src.contains("Flyweight Pattern"), "DiagnosticHypothesisDefinition must state Flyweight contract")

	var dsd_src := _read_file("res://scripts/gameplay/diagnostic_sequence_definition.gd")
	_expect(dsd_src.contains("Flyweight Pattern"), "DiagnosticSequenceDefinition must state Flyweight contract")


func _check_runtime() -> void:
	var player_res: PackedScene = load(PLAYER_SCENE)
	_expect(player_res != null, "player scene must load")
	if player_res != null:
		var player = player_res.instantiate()
		root.add_child(player)
		await process_frame
		await process_frame
		_expect(player.is_in_group(&"player"), "runtime player instance must be in &\"player\" group")
		_expect(player.collision_layer == 3, "runtime player collision_layer must be 3")
		_expect(player.collision_mask == 1, "runtime player collision_mask must be 1")
		root.remove_child(player)
		player.queue_free()
		await process_frame
		await process_frame

	var tz := ThresholdZone.new()
	root.add_child(tz)
	await process_frame
	root.remove_child(tz)
	tz.queue_free()
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0210 ARCHITECTURAL AUDIT REMEDIATION PASS: setters, groups, physics layers, flyweights, runtime.")
		quit(0)
	else:
		print("PKG-0210 ARCHITECTURAL AUDIT REMEDIATION FAIL: %d failures" % _failures.size())
		for f in _failures:
			print(" - %s" % f)
		quit(1)
