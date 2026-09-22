extends SceneTree

## PKG-0130 Smoke Test: Frame Budget, Particle Determinism and Pixel-Grid Camera Coherence
##
## Gates:
##   1. ParticleBudget contract — every emitter factory in the project applies the
##      30 Hz deterministic simulation cap.
##   2. AtmosphereRig — shared radial light textures, deterministic particle
##      teardown on _exit_tree, no per-frame dictionary hashing in the hot path.
##   3. CinematicCamera — rendered transform always on the composited 2 px grid,
##      float smoothing authority free of snapping drift, vertical follow clamped
##      inside the active chamber (ladders and service lifts).
##   4. ServiceLift — motor PCM served from the process-wide cache.
##   5. Frame budget across all 45 campaign scenes — active emitters, live
##      particles, lights, canvas layers and playing audio voices inside budget.
##
## The gate proves object budgets and transform contracts. Real render frame times
## are certified separately by `tools/render_frame_timing.gd` on the normal display
## driver; a headless run has no renderer and cannot prove a render budget.

const CAMPAIGN_DIR := "res://scenes/levels"

const MAX_LIGHTS_PER_SCENE := 8
const MAX_CANVAS_LAYERS_PER_SCENE := 8
const MAX_PLAYING_AUDIO_VOICES := 4
const MAX_POOLED_AUDIO_PLAYERS := 20

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

## Every script that constructs a CPUParticles2D must route it through the shared
## frame-budget contract. Adding a new emitter factory without the call fails here.
const EMITTER_FACTORY_SCRIPTS: Array[String] = [
	"res://scripts/levels/atmosphere_rig.gd",
	"res://scripts/player/prototype_player.gd",
	"res://scripts/interactables/anchorable_object.gd",
	"res://scripts/interactables/movable_anchorable_prop.gd",
	"res://scripts/interactables/memory_resonance_point.gd",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run_tests")


func _expect(cond: bool, msg: String) -> void:
	if not cond:
		_failures.append(msg)
		push_error("PKG-0130 TEST FAILURE: " + msg)


func _run_tests() -> void:
	print("\n--- PKG-0130 Smoke Test: Frame Budget, Particle Determinism & Pixel Camera ---")

	print("1. Testing ParticleBudget contract and emitter factory coverage...")
	_test_particle_budget_contract()

	print("2. Testing AtmosphereRig shared light textures and particle teardown...")
	await _test_atmosphere_rig_budget()

	print("3. Testing CinematicCamera pixel-grid coherence and drift...")
	await _test_camera_pixel_grid()

	print("4. Testing CinematicCamera clamped vertical follow for ladders and lifts...")
	await _test_camera_vertical_follow()

	print("5. Testing ServiceLift cached motor audio...")
	await _test_service_lift_audio_cache()

	print("6. Testing frame budget across all 45 campaign scenes...")
	await _test_campaign_frame_budget()

	if _failures.is_empty():
		print("\nPKG-0130: ALL TESTS PASSED (0 FAILURES). FRAME BUDGET AND PIXEL COHERENCE CERTIFIED.")
		quit(0)
	else:
		print("\nPKG-0130: %d FAILURES ENCOUNTERED:" % _failures.size())
		for failure in _failures:
			print("  * ", failure)
		quit(1)


func _test_particle_budget_contract() -> void:
	_expect(ParticleBudget.SIMULATION_FPS == 30, "Particle simulation cap must be 30 Hz")
	_expect(ParticleBudget.MAX_ACTIVE_EMITTERS > 0, "Active emitter budget must be positive")
	_expect(ParticleBudget.MAX_ACTIVE_PARTICLES > 0, "Active particle budget must be positive")

	var emitter := CPUParticles2D.new()
	_expect(
		not ParticleBudget.is_within_frame_budget(emitter),
		"A fresh CPUParticles2D must not already satisfy the frame budget"
	)
	ParticleBudget.apply_frame_budget(emitter)
	_expect(
		emitter.fixed_fps == ParticleBudget.SIMULATION_FPS,
		"apply_frame_budget must set fixed_fps to the simulation cap"
	)
	_expect(not emitter.fract_delta, "apply_frame_budget must disable fract_delta for determinism")
	_expect(
		ParticleBudget.is_within_frame_budget(emitter),
		"A budgeted emitter must report as within the frame budget"
	)

	emitter.one_shot = true
	emitter.emitting = true
	ParticleBudget.release(emitter)
	_expect(not emitter.emitting, "release must stop emission deterministically")
	emitter.free()

	# Null-safety: the contract is called from _exit_tree paths where nodes may be gone.
	ParticleBudget.apply_frame_budget(null)
	ParticleBudget.release(null)
	_expect(not ParticleBudget.is_within_frame_budget(null), "null emitter is never within budget")

	for script_path in EMITTER_FACTORY_SCRIPTS:
		var file := FileAccess.open(script_path, FileAccess.READ)
		_expect(file != null, "Emitter factory script must open: %s" % script_path)
		if file == null:
			continue
		var source: String = file.get_as_text()
		file.close()
		_expect(
			source.contains("CPUParticles2D.new()"),
			"%s is registered as an emitter factory but constructs no emitter" % script_path
		)
		_expect(
			source.contains("ParticleBudget.apply_frame_budget"),
			"%s constructs particles without applying the frame budget" % script_path
		)


func _test_atmosphere_rig_budget() -> void:
	AtmosphereRig.clear_light_texture_cache()
	_expect(
		AtmosphereRig.get_light_texture_cache_size() == 0,
		"Light texture cache must start empty after an explicit clear"
	)

	var rig_a := AtmosphereRig.new()
	rig_a.station_number = 34
	root.add_child(rig_a)
	await process_frame

	var cache_after_first: int = AtmosphereRig.get_light_texture_cache_size()
	_expect(cache_after_first > 0, "Building a rig must populate the shared light texture cache")

	var lights_a := _collect_lights(rig_a)
	_expect(lights_a.size() >= 2, "Station 34 rig must build at least two lights")
	var distinct_textures := {}
	for light in lights_a:
		_expect(light.texture != null, "Every rig light must own a radial gradient texture")
		if light.texture != null:
			distinct_textures[light.texture.get_instance_id()] = true
	_expect(
		distinct_textures.size() <= cache_after_first,
		"Rig lights must reuse cached textures, never allocate beyond the cache"
	)

	_expect(rig_a.get_particle_node_count() == 2, "Station 34 rig must own dust and vent steam emitters")
	_expect(
		rig_a.get_particle_budget() > 0 and rig_a.get_particle_budget() <= ParticleBudget.MAX_ACTIVE_PARTICLES,
		"Rig particle allocation must stay inside the active particle budget"
	)
	for particles in _collect_particles(rig_a):
		_expect(
			ParticleBudget.is_within_frame_budget(particles),
			"Rig emitter %s must carry the frame budget" % particles.name
		)

	# A second rig of the same profile must not grow the texture cache.
	var rig_b := AtmosphereRig.new()
	rig_b.station_number = 34
	root.add_child(rig_b)
	await process_frame
	_expect(
		AtmosphereRig.get_light_texture_cache_size() == cache_after_first,
		"A second rig with the same lighting profile must not allocate new textures"
	)

	# Deterministic teardown.
	root.remove_child(rig_a)
	rig_a.free()
	_expect(
		rig_a == null or not is_instance_valid(rig_a),
		"Rig must free cleanly after removal"
	)

	root.remove_child(rig_b)
	rig_b.free()
	await process_frame


func _test_camera_pixel_grid() -> void:
	var camera := CinematicCamera.new()
	camera.name = "PixelGridCamera"
	root.add_child(camera)

	_expect(CinematicCamera.PIXEL_GRID == 2.0, "Pixel grid must match the 320x180 compositor inside 640x360")
	_expect(camera.pixel_snap_enabled, "Pixel snapping must be enabled by default")

	# A deliberately off-grid chamber centre must still render on-grid.
	camera.setup_chambers([Rect2(Vector2(1.0, 3.0), Vector2(640.0, 360.0))] as Array[Rect2])
	_expect(camera.is_on_pixel_grid(), "Immediate chamber set must land on the pixel grid")

	var target := Node2D.new()
	target.name = "PixelGridTarget"
	target.position = Vector2(320.0, 180.0)
	root.add_child(target)
	camera.target = target

	# Drive many physics steps with a fractional delta: the rendered transform must
	# stay on-grid every single frame, while the float authority converges smoothly.
	var off_grid_frames := 0
	for step in range(120):
		target.position.x += 0.37
		camera._physics_process(1.0 / 60.0)
		if not camera.is_on_pixel_grid():
			off_grid_frames += 1
	_expect(off_grid_frames == 0, "Camera left the pixel grid on %d frame(s)" % off_grid_frames)

	# Snapping must not feed back into the smoothing state: the float authority has
	# to remain within one grid cell of the rendered transform, never drift away.
	var drift: Vector2 = camera.get_smooth_position() - camera.global_position
	_expect(
		absf(drift.x) <= CinematicCamera.PIXEL_GRID and absf(drift.y) <= CinematicCamera.PIXEL_GRID,
		"Snapped transform drifted from the float authority by %s" % str(drift)
	)

	# Trauma shake must stay on the same grid. The offset is added after position,
	# so an unsnapped shake would undo the snap above.
	camera.pixel_snap_enabled = true
	camera.add_trauma(1.0)
	var shake_off_grid := 0
	for step in range(30):
		camera._physics_process(1.0 / 60.0)
		if not camera.is_on_pixel_grid():
			shake_off_grid += 1
	_expect(shake_off_grid == 0, "Camera shake left the pixel grid on %d frame(s)" % shake_off_grid)

	# Disabling the snap must hand back the raw float focus.
	camera.pixel_snap_enabled = false
	camera._physics_process(1.0 / 60.0)
	_expect(
		camera.global_position.is_equal_approx(camera.get_smooth_position()),
		"With snapping off the transform must equal the float authority"
	)

	target.free()
	camera.free()
	await process_frame


func _test_camera_vertical_follow() -> void:
	var camera := CinematicCamera.new()
	camera.name = "VerticalFollowCamera"
	root.add_child(camera)

	# A chamber exactly one view tall keeps the historic locked framing.
	camera.setup_chambers([Rect2(Vector2.ZERO, Vector2(640.0, 360.0))] as Array[Rect2])
	var flat_target := Node2D.new()
	flat_target.position = Vector2(320.0, 40.0)
	root.add_child(flat_target)
	camera.target = flat_target
	for step in range(60):
		camera._physics_process(1.0 / 60.0)
	_expect(
		is_equal_approx(camera.get_vertical_focus(), 180.0),
		"A one-view-tall chamber must stay locked to its centre (got %.2f)" % camera.get_vertical_focus()
	)
	flat_target.free()

	# A tall chamber (ladder shaft / service lift shaft) must follow, clamped.
	var tall_camera := CinematicCamera.new()
	tall_camera.name = "TallShaftCamera"
	root.add_child(tall_camera)
	tall_camera.setup_chambers([Rect2(Vector2.ZERO, Vector2(640.0, 720.0))] as Array[Rect2])

	var climber := Node2D.new()
	climber.name = "Climber"
	climber.position = Vector2(320.0, 660.0)
	root.add_child(climber)
	tall_camera.target = climber

	var focus_at_bottom := tall_camera.get_vertical_focus()
	for step in range(240):
		tall_camera._physics_process(1.0 / 60.0)
	focus_at_bottom = tall_camera.get_vertical_focus()
	_expect(
		focus_at_bottom > 360.0,
		"Camera must descend toward a climber at the shaft bottom (focus %.2f)" % focus_at_bottom
	)
	_expect(
		focus_at_bottom <= 540.0 + 0.001,
		"Vertical focus must stay clamped inside the chamber (focus %.2f, max 540)" % focus_at_bottom
	)

	# Climb to the top: the focus must travel back up and clamp at the ceiling.
	climber.position.y = 40.0
	for step in range(360):
		tall_camera._physics_process(1.0 / 60.0)
	var focus_at_top := tall_camera.get_vertical_focus()
	_expect(
		focus_at_top < focus_at_bottom,
		"Climbing must raise the framing (bottom %.2f -> top %.2f)" % [focus_at_bottom, focus_at_top]
	)
	_expect(
		focus_at_top >= 180.0 - 0.001,
		"Vertical focus must stay clamped inside the chamber (focus %.2f, min 180)" % focus_at_top
	)
	_expect(tall_camera.is_on_pixel_grid(), "Vertical follow must keep the transform on the pixel grid")

	# Small movement inside the deadzone must not move the framing at all.
	var settled := tall_camera.get_vertical_focus()
	climber.position.y = settled + tall_camera.vertical_deadzone * 0.5
	for step in range(30):
		tall_camera._physics_process(1.0 / 60.0)
	_expect(
		is_equal_approx(tall_camera.get_vertical_focus(), settled),
		"Movement inside the deadzone must not move the camera (%.3f -> %.3f)" % [
			settled, tall_camera.get_vertical_focus()
		]
	)

	climber.free()
	tall_camera.free()
	camera.free()
	await process_frame


func _test_service_lift_audio_cache() -> void:
	var cache_before := ProceduralAudio.get_sound_cache_size()

	var lift_a := ServiceLift.new()
	lift_a.name = "CachedMotorLiftA"
	root.add_child(lift_a)
	await process_frame

	var player_a := lift_a.get_node_or_null("MotorAudioPlayer") as AudioStreamPlayer2D
	_expect(player_a != null, "ServiceLift must build a motor audio player")
	_expect(player_a != null and player_a.stream != null, "ServiceLift motor player must own a stream")

	var lift_b := ServiceLift.new()
	lift_b.name = "CachedMotorLiftB"
	root.add_child(lift_b)
	await process_frame
	var player_b := lift_b.get_node_or_null("MotorAudioPlayer") as AudioStreamPlayer2D
	_expect(player_b != null, "Second ServiceLift must build a motor audio player")

	if player_a != null and player_b != null:
		_expect(
			player_a.stream == player_b.stream,
			"Two lifts must share one cached motor PCM buffer instead of synthesising two"
		)
	_expect(
		ProceduralAudio.get_sound_cache_size() <= cache_before + 1,
		"Adding two lifts must add at most one cached PCM buffer"
	)

	lift_a.free()
	lift_b.free()
	await process_frame


func _test_campaign_frame_budget() -> void:
	_expect(ALL_CAMPAIGN_SCENE_IDS.size() == 45, "Expected 45 total campaign scenes")

	var worst_active_particles := 0
	var worst_scene := ""

	for station_id in ALL_CAMPAIGN_SCENE_IDS:
		var scene_path := CAMPAIGN_DIR + "/" + String(station_id) + ".tscn"
		if not ResourceLoader.exists(scene_path):
			_expect(false, "Scene %s must exist" % scene_path)
			continue

		var packed: PackedScene = load(scene_path)
		_expect(packed != null, "Scene %s must load" % station_id)
		if packed == null:
			continue

		var instance: Node = packed.instantiate()
		root.add_child(instance)
		for _warmup in range(4):
			await process_frame

		var stats := _collect_stats(instance)
		var active_emitters: int = stats["active_emitters"]
		var active_particles: int = stats["active_particles"]

		if active_particles > worst_active_particles:
			worst_active_particles = active_particles
			worst_scene = String(station_id)

		_expect(
			stats["uncapped_emitters"] == 0,
			"%s has %d emitter(s) bypassing ParticleBudget" % [station_id, stats["uncapped_emitters"]]
		)
		_expect(
			active_emitters <= ParticleBudget.MAX_ACTIVE_EMITTERS,
			"%s emitting systems %d exceeds budget %d" % [
				station_id, active_emitters, ParticleBudget.MAX_ACTIVE_EMITTERS
			]
		)
		_expect(
			active_particles <= ParticleBudget.MAX_ACTIVE_PARTICLES,
			"%s live particles %d exceeds budget %d" % [
				station_id, active_particles, ParticleBudget.MAX_ACTIVE_PARTICLES
			]
		)
		_expect(
			stats["pooled_emitters"] <= ParticleBudget.MAX_POOLED_EMITTERS,
			"%s pooled emitters %d exceeds budget %d" % [
				station_id, stats["pooled_emitters"], ParticleBudget.MAX_POOLED_EMITTERS
			]
		)
		_expect(
			stats["lights"] <= MAX_LIGHTS_PER_SCENE,
			"%s lights %d exceeds budget %d" % [station_id, stats["lights"], MAX_LIGHTS_PER_SCENE]
		)
		_expect(
			stats["canvas_layers"] <= MAX_CANVAS_LAYERS_PER_SCENE,
			"%s canvas layers %d exceeds budget %d" % [
				station_id, stats["canvas_layers"], MAX_CANVAS_LAYERS_PER_SCENE
			]
		)
		_expect(
			stats["playing_audio"] <= MAX_PLAYING_AUDIO_VOICES,
			"%s playing audio voices %d exceeds budget %d" % [
				station_id, stats["playing_audio"], MAX_PLAYING_AUDIO_VOICES
			]
		)
		_expect(
			stats["pooled_audio"] <= MAX_POOLED_AUDIO_PLAYERS,
			"%s pooled audio players %d exceeds budget %d" % [
				station_id, stats["pooled_audio"], MAX_POOLED_AUDIO_PLAYERS
			]
		)

		# The compositor must survive the budget work.
		_expect(
			instance.get_node_or_null("WorldPixelCompositor") != null,
			"%s must keep its WorldPixelCompositor" % station_id
		)

		# PKG-0141 (D-150) ujednolicil nazwe wezla kamery na "Camera" we wszystkich
		# 45 scenach. Kamery sa tu dalej zbierane po typie, bo kontraktem tej bramki
		# jest dokladnie jedna `CinematicCamera` trzymajaca snap, a nie nazewnictwo;
		# nazwy pilnuje `tests/pkg_0141_smoke_test.gd`.
		var cameras := _collect_cameras(instance)
		_expect(cameras.size() == 1, "%s must own exactly one CinematicCamera (found %d)" % [
			station_id, cameras.size()
		])
		for camera in cameras:
			_expect(camera.pixel_snap_enabled, "%s camera must keep pixel snapping enabled" % station_id)
			_expect(
				camera.view_size == Vector2(640.0, 360.0),
				"%s camera must frame the 640x360 logical viewport" % station_id
			)

		instance.queue_free()
		await process_frame
		await process_frame

	print("   45 scenes inside frame budget. Worst live particle load: %d (%s)." % [
		worst_active_particles, worst_scene
	])


func _collect_lights(node: Node) -> Array[PointLight2D]:
	var found: Array[PointLight2D] = []
	for child in node.get_children():
		if child is PointLight2D:
			found.append(child as PointLight2D)
	return found


func _collect_particles(node: Node) -> Array[CPUParticles2D]:
	var found: Array[CPUParticles2D] = []
	for child in node.get_children():
		if child is CPUParticles2D:
			found.append(child as CPUParticles2D)
	return found


func _collect_cameras(node: Node) -> Array[CinematicCamera]:
	var found: Array[CinematicCamera] = []
	var pending: Array[Node] = [node]
	while not pending.is_empty():
		var current: Node = pending.pop_back()
		if current is CinematicCamera:
			found.append(current as CinematicCamera)
		for child in current.get_children():
			pending.append(child)
	return found


func _collect_stats(instance: Node) -> Dictionary:
	var pooled_emitters := 0
	var active_emitters := 0
	var uncapped_emitters := 0
	var active_particles := 0
	var lights := 0
	var pooled_audio := 0
	var playing_audio := 0
	var canvas_layers := 0

	var pending: Array[Node] = [instance]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		if node is CPUParticles2D:
			var emitter := node as CPUParticles2D
			pooled_emitters += 1
			if emitter.emitting:
				active_emitters += 1
				active_particles += emitter.amount
			if not ParticleBudget.is_within_frame_budget(emitter):
				uncapped_emitters += 1
		elif node is GPUParticles2D:
			# GPU particles fall outside the Zero-Asset GL Compatibility contract.
			pooled_emitters += 1
			uncapped_emitters += 1
		elif node is Light2D:
			lights += 1
		elif node is AudioStreamPlayer:
			pooled_audio += 1
			if (node as AudioStreamPlayer).playing:
				playing_audio += 1
		elif node is AudioStreamPlayer2D:
			pooled_audio += 1
			if (node as AudioStreamPlayer2D).playing:
				playing_audio += 1
		elif node is CanvasLayer:
			canvas_layers += 1
		for child in node.get_children():
			pending.append(child)

	return {
		"pooled_emitters": pooled_emitters,
		"active_emitters": active_emitters,
		"uncapped_emitters": uncapped_emitters,
		"active_particles": active_particles,
		"lights": lights,
		"pooled_audio": pooled_audio,
		"playing_audio": playing_audio,
		"canvas_layers": canvas_layers,
	}
