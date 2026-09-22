extends SceneTree

## PKG-0142 Smoke Test — Station 01 right-edge composition and visual-mode
## contracts. The renderer is intentionally not exercised here: normal-driver
## image evidence lives in tools/capture_pkg_0142.gd. This gate holds the
## structural and runtime invariants that must survive the visual pass.
##
## 1. Station 01 exposes a semantic airlock-bulkhead composition anchor, keeps
##    the diegetic label in the 90..190 band, and adds no gameplay geometry.
## 2. PKG-0141's Camera/Player/snap contract still holds on all 45 scenes in
##    both normal and reduced-motion runtime modes.
## 3. Reduced motion removes peripheral camera shake without removing the
##    camera, stage, framing budget, or atmosphere nodes.
##
## This test never calls `_draw()` directly. Rendering proof is produced only
## by the normal-driver capture and manual frame inspection.

const CAMPAIGN_DIR := "res://scenes/levels"
const VIEW_SIZE := Vector2(640.0, 360.0)
const STEP := 1.0 / 60.0
const EXPECTED_STATION_01_COLLIDERS: Array[StringName] = [
	&"Floor", &"WallLeft", &"WallRight", &"Ceiling", &"OperatorDesk", &"ConsoleBench",
]
const ALL_CAMPAIGN_SCENE_IDS: Array[StringName] = [
	&"station_01", &"station_02", &"station_03", &"station_04", &"station_05",
	&"station_06", &"station_07", &"station_08", &"station_09", &"station_10",
	&"station_11", &"station_12", &"station_13", &"station_14", &"station_15",
	&"station_16", &"station_17", &"station_18", &"station_19", &"station_20",
	&"station_21", &"station_22", &"station_23", &"station_24", &"station_25",
	&"station_26", &"station_27", &"station_28", &"station_29", &"station_30",
	&"station_31", &"station_32", &"station_33", &"station_34", &"station_35",
	&"station_36", &"station_37", &"station_38", &"station_39", &"station_40",
	&"station_41", &"station_42a", &"station_42b", &"station_42c", &"station_43",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("FAIL: " + message)


func _run() -> void:
	print("================================================================================")
	print("  PKG-0142 SMOKE TEST: Station 01 visual contract + 45-scene camera parity")
	print("================================================================================")
	MotionAccessibility.reset()

	print("1. Station 01 right-edge role, label band and collider invariants...")
	await _test_station_01_layout()

	print("2. PKG-0141 camera contract on all 45 scenes (normal mode)...")
	await _test_camera_binding_all(false)

	print("3. PKG-0141 camera contract on all 45 scenes (reduced-motion mode)...")
	await _test_camera_binding_all(true)

	print("4. Reduced motion preserves stage, framing and atmosphere nodes...")
	await _test_reduced_motion_preserves_information()

	MotionAccessibility.reset()
	_finish()


func _test_station_01_layout() -> void:
	var packed := load("%s/station_01.tscn" % CAMPAIGN_DIR) as PackedScene
	_expect(packed != null, "station_01 musi dac sie zaladowac")
	if packed == null:
		return

	var station := packed.instantiate() as Node2D
	_expect(station != null, "station_01 musi miec korzen Node2D")
	if station == null:
		return
	root.add_child(station)
	await process_frame
	await physics_frame

	var stage := station.get_node_or_null("VectorStageEnvironment") as VectorStageEnvironment
	_expect(stage != null, "station_01 musi posiadac VectorStageEnvironment")
	if stage != null:
		_expect(stage.station_number == 1, "VectorStageEnvironment musi znac station_number=1")
		_expect(stage.world_size == VIEW_SIZE, "scenografia stacji 01 musi pracowac w kadrze 640x360")
		_expect(
			VectorStageEnvironment.STATION_01_RIGHT_EDGE_ROLE == &"airlock_bulkhead",
			"prawa krawedz stacji 01 musi miec semantyczna role airlock_bulkhead"
		)
		_expect(
			stage.get_child_count() == 0,
			"prawa kompozycja stacji 01 nie moze dodawac wezlow ani colliderow do rig-u"
		)

	var geometry := station.get_node_or_null("Geometry")
	var collider_names: Array[StringName] = []
	if geometry != null:
		_collect_static_bodies(geometry, collider_names)
	collider_names.sort()
	var expected_names := EXPECTED_STATION_01_COLLIDERS.duplicate()
	expected_names.sort()
	_expect(
		collider_names == expected_names,
		"kompozycja stacji 01 nie moze dodac collidera; znaleziono %s" % str(collider_names)
	)

	var label := station.get_node_or_null("CrispDiegeticText_Terminal") as Node2D
	_expect(label != null, "station_01 musi zachowac podpis terminala")
	if label != null:
		_expect(
			label.position.y >= 90.0 and label.position.y <= 190.0,
			"podpis terminala musi pozostac w pasmie 90..190, otrzymano y=%.1f" % label.position.y
		)
		_expect(
			label.position.y + 16.0 < 209.0,
			"podpis terminala nie moze wejsc w linie glowy aktora"
		)

	root.remove_child(station)
	station.free()
	await process_frame


func _test_camera_binding_all(reduced_motion: bool) -> void:
	MotionAccessibility.set_reduced_motion(reduced_motion)
	var checked := 0
	for scene_id in ALL_CAMPAIGN_SCENE_IDS:
		var station := await _open_station(scene_id)
		if station == null:
			continue
		checked += 1

		var cameras := _collect_cameras(station)
		_expect(
			cameras.size() == 1,
			"%s (%s): stacja musi miec dokladnie jedna kamere kinowa (ma %d)" % [scene_id, _mode_name(reduced_motion), cameras.size()]
		)
		var camera := StationCameraRig.resolve(station)
		var player := station.get_node_or_null("Player") as Node2D
		_expect(
			camera != null,
			"%s (%s): StationCameraRig musi znalezc kamere" % [scene_id, _mode_name(reduced_motion)]
		)
		if camera != null:
			_expect(
				camera.target == player and player != null,
				"%s (%s): target kamery musi wskazywac Player" % [scene_id, _mode_name(reduced_motion)]
			)
			_expect(
				not camera.chamber_bounds.is_empty(),
				"%s (%s): kamera musi miec niepusta liste komor" % [scene_id, _mode_name(reduced_motion)]
			)
			if not camera.chamber_bounds.is_empty():
				_expect(
					camera.get_active_chamber_rect().size == VIEW_SIZE,
					"%s (%s): komora kamery musi miec rozmiar 640x360" % [scene_id, _mode_name(reduced_motion)]
				)
			_expect(
				camera.view_size == VIEW_SIZE,
				"%s (%s): kamera musi kadrowac 640x360" % [scene_id, _mode_name(reduced_motion)]
			)
			_expect(
				camera.pixel_snap_enabled,
				"%s (%s): snap 2 px musi pozostac wlaczony" % [scene_id, _mode_name(reduced_motion)]
			)
			camera._physics_process(STEP)
			_expect(
				camera.is_on_pixel_grid(),
				"%s (%s): kadr musi pozostac na siatce 2 px" % [scene_id, _mode_name(reduced_motion)]
			)
			if reduced_motion:
				camera.add_trauma(1.0)
				camera._physics_process(STEP)
				_expect(
					camera.offset == Vector2.ZERO,
					"%s: reduced-motion nie moze dodac wstrzasu do kadru" % scene_id
				)
				_expect(
					camera.is_on_pixel_grid(),
					"%s: reduced-motion musi zachowac snap 2 px" % scene_id
				)

		_close_station(station)
		await process_frame

	_expect(
		checked == ALL_CAMPAIGN_SCENE_IDS.size(),
		"kontrakt kamery (%s) musi objac wszystkie 45 scen, objal %d" % [_mode_name(reduced_motion), checked]
	)
	print("   45 scen (%s): Camera, Player, komora i snap 2 px." % _mode_name(reduced_motion))


func _test_reduced_motion_preserves_information() -> void:
	MotionAccessibility.set_reduced_motion(true)
	_expect(MotionAccessibility.is_reduced_motion(), "tryb ograniczonego ruchu musi byc wlaczony")
	_expect(is_zero_approx(MotionAccessibility.motion_scale()), "tryb musi zerowac amplitude ruchu")
	_expect(not MotionAccessibility.allows_camera_shake(), "tryb musi zdejmowac wstrzas kamery")
	_expect(not MotionAccessibility.allows_micro_particles(), "tryb musi gasic tylko mikro-czastki dekoracyjne")

	var station := await _open_station(&"station_38")
	if station != null:
		var camera := StationCameraRig.resolve(station)
		var stage := _find(station, func(n): return n is VectorStageEnvironment) as VectorStageEnvironment
		var atmosphere := _find(station, func(n): return n is AtmosphereRig) as AtmosphereRig
		_expect(camera != null, "stacja 38 musi zachowac kamere w reduced-motion")
		_expect(stage != null, "stacja 38 musi zachowac scenografie w reduced-motion")
		_expect(atmosphere != null, "stacja 38 musi zachowac AtmosphereRig w reduced-motion")
		if camera != null:
			_expect(camera.dialogue_framing_offset > 0.0, "reduced-motion nie moze usuwac kadru dialogowego")
			_expect(
				is_equal_approx(camera.stage_apron, VectorStageStyle.STAGE_APRON),
				"reduced-motion nie moze zmieniac budzetu malowanej scenografii"
			)
			camera.add_trauma(1.0)
			camera._physics_process(STEP)
			_expect(camera.offset == Vector2.ZERO, "reduced-motion musi zostawic kadr bez wstrzasu")
			_expect(camera.is_on_pixel_grid(), "reduced-motion musi zachowac snap 2 px")
		if stage != null:
			_expect(stage.visible, "reduced-motion nie moze ukrywac scenografii")
		if atmosphere != null:
			_expect(
				atmosphere.get_particle_node_count() > 0,
				"reduced-motion ma wygasic emisje, nie usunac emiterow"
			)
			_expect(
				not atmosphere.is_emitting_micro_particles(),
				"stacja uruchomiona w reduced-motion musi miec wylaczone mikro-czastki"
			)
		_close_station(station)
		await process_frame

	MotionAccessibility.reset()


func _open_station(scene_id: StringName) -> Node2D:
	var packed := load("%s/%s.tscn" % [CAMPAIGN_DIR, scene_id]) as PackedScene
	_expect(packed != null, "%s: scena musi dac sie zaladowac" % scene_id)
	if packed == null:
		return null
	var station := packed.instantiate() as Node2D
	_expect(station != null, "%s: korzen sceny musi byc Node2D" % scene_id)
	if station == null:
		return null
	root.add_child(station)
	await process_frame
	await physics_frame
	return station


func _close_station(station: Node) -> void:
	if not is_instance_valid(station):
		return
	if station.get_parent() == root:
		root.remove_child(station)
	station.free()


func _collect_static_bodies(node: Node, out: Array[StringName]) -> void:
	if node is StaticBody2D:
		out.append(StringName(node.name))
	for child in node.get_children():
		_collect_static_bodies(child, out)


func _find(node: Node, pred: Callable) -> Node:
	if pred.call(node):
		return node
	for child in node.get_children():
		var found := _find(child, pred)
		if found != null:
			return found
	return null


func _collect_cameras(node: Node) -> Array[CinematicCamera]:
	var found: Array[CinematicCamera] = []
	if node is CinematicCamera:
		found.append(node as CinematicCamera)
	for child in node.get_children():
		found.append_array(_collect_cameras(child))
	return found


func _mode_name(reduced_motion: bool) -> String:
	return "reduced" if reduced_motion else "normal"


func _finish() -> void:
	print("--------------------------------------------------------------------------------")
	if _failures.is_empty():
		print("PKG-0142: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		printerr("PKG-0142: %d FAILURE(S)." % _failures.size())
		for failure in _failures:
			printerr("  - " + failure)
		quit(1)
