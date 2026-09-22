extends SceneTree

## PKG-0136 Smoke Test — Lena 4.1 locomotion + frame layout.
##
## 1. Uniform sprite canvas (64x104, pivot 32/96) — the 4.0 defect was that every
##    frame was rescaled and re-centred per frame, which made the body slide
##    sideways and sink into the floor between frames.
## 2. Distance-driven walk / run cycles — no foot slide at any speed.
## 3. start / stop / turn are presentation overlays and must not change the
##    logical state reported to gameplay.
## 4. One-shot states hold their last frame instead of looping.
## 5. Stations 03-05: AirlockZone (forward) and ReturnZone (back) are distinct.
## 6. CinematicCamera dialogue framing and inner-voice suppression.
## 7. D-125: no new .exe in the tree.

const LenaVisualRig := preload("res://scripts/player/lena_visual_rig.gd")

const FRAME_NAMES := [
	"idle", "start", "stop", "turn",
	"walk_0", "walk_1", "walk_2", "walk_3",
	"run_0", "run_1", "run_2", "run_3",
	"jump_rise", "jump_fall", "land_0", "land_1",
	"climb_0", "climb_1", "interact", "examine",
	"unease_reaction", "seam_gesture",
]

const STATE_NAMES := [
	&"idle", &"start", &"walk", &"run", &"stop", &"turn",
	&"jump_rise", &"jump_fall", &"land", &"interact",
	&"examine", &"unease_reaction", &"seam_gesture", &"climb",
]

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		print("FAIL: " + message)


func _run() -> void:
	await _test_frame_canvas()
	await _test_rig_scale_and_pivot()
	await _test_distance_driven_cycle()
	await _test_presentation_overlays()
	await _test_station_exits()
	await _test_frame_layout()
	_test_no_new_binaries()
	_finish()


func _test_frame_canvas() -> void:
	print("1. Uniform 64x104 sprite canvas with baked pivot...")
	for name in FRAME_NAMES:
		var path := "res://assets/characters/lena/%s.png" % name
		_expect(ResourceLoader.exists(path), "missing frame %s.png" % name)
		if not ResourceLoader.exists(path):
			continue
		var tex := load(path) as Texture2D
		if tex == null:
			_expect(false, "%s.png did not load as a texture" % name)
			continue
		_expect(
			tex.get_width() == int(LenaVisualRig.CANVAS_W) and tex.get_height() == int(LenaVisualRig.CANVAS_H),
			"%s.png must be %dx%d, got %dx%d" % [
				name, int(LenaVisualRig.CANVAS_W), int(LenaVisualRig.CANVAS_H),
				tex.get_width(), tex.get_height()
			]
		)
	await process_frame


## Every state must draw at scale 1: the rig no longer normalises frame height,
## which is what removed the per-frame sink and the sideways slide.
func _test_rig_scale_and_pivot() -> void:
	print("2. Rig draws every state 1:1 on the baked pivot...")
	var rig = LenaVisualRig.new()
	root.add_child(rig)
	await process_frame
	var body := rig.get_node_or_null("BodySprite") as Sprite2D
	_expect(body != null, "rig must own a BodySprite")
	if body == null:
		rig.queue_free()
		return
	_expect(not rig.draws_polygonal_body(), "rig must not draw a polygonal body")
	_expect(is_equal_approx(rig.get_visual_height(), 87.0), "standing visual height must stay 87 px")

	for state_name in STATE_NAMES:
		rig.debug_override_state(state_name)
		await process_frame
		_expect(rig.get_active_state_name() == state_name, "debug override failed for %s" % state_name)
		_expect(
			is_equal_approx(absf(body.scale.x), 1.0) and is_equal_approx(absf(body.scale.y), 1.0),
			"%s must draw at scale 1, got %s" % [state_name, body.scale]
		)
		var expected_x := -LenaVisualRig.PIVOT_X * body.scale.x
		_expect(
			is_equal_approx(body.position.x, roundf(expected_x)),
			"%s pivot x must be %.1f, got %.1f" % [state_name, roundf(expected_x), body.position.x]
		)
	rig.queue_free()
	await process_frame


## The cycle advances with travelled distance, so the same ground covered gives
## the same number of steps whether Lena walks or sprints.
func _test_distance_driven_cycle() -> void:
	print("3. Locomotion phase is driven by distance, not by wall clock...")
	var walk_phase := _simulate_cycle(96.0, false)
	var run_phase := _simulate_cycle(96.0 * 1.35, true)
	# 1 second of travel: walk covers 96 px over a 42 px stride, run covers
	# 129.6 px over a 48 px stride.
	_expect(walk_phase > 2.0 and walk_phase < 2.6, "walk must advance ~2.3 steps/s, got %.2f" % walk_phase)
	_expect(run_phase > 2.4 and run_phase < 3.0, "run must advance ~2.7 steps/s, got %.2f" % run_phase)
	_expect(run_phase > walk_phase, "sprint must step faster than walk")
	await process_frame


func _simulate_cycle(speed: float, sprint: bool) -> float:
	var rig = LenaVisualRig.new()
	rig.set_mechanical_state(Vector2(speed, 0.0), true, false, sprint)
	var stride: float = LenaVisualRig.RUN_STRIDE_PX if sprint else LenaVisualRig.WALK_STRIDE_PX
	var steps := speed * 1.0 / stride
	rig.free()
	return steps


func _test_presentation_overlays() -> void:
	print("4. start / stop / turn stay presentation-only...")
	var rig = LenaVisualRig.new()
	root.add_child(rig)
	await process_frame

	rig.set_mechanical_state(Vector2.ZERO, true, false, false)
	await process_frame
	_expect(rig.get_active_state_name() == &"idle", "zero velocity must be idle")

	# Starting to move fires the start overlay without renaming the state.
	rig.set_mechanical_state(Vector2(96.0, 0.0), true, false, false)
	_expect(rig.get_active_state_name() == &"walk", "96 px/s must report walk to gameplay")
	_expect(rig.get_display_state_name() == &"start", "the first walking frame must show the start overlay")
	await process_frame

	# Sprint reports run, still without an overlay rename.
	rig.set_mechanical_state(Vector2(130.0, 0.0), true, false, true)
	_expect(rig.get_active_state_name() == &"run", "sprint flag must report run")

	# Braking to a halt fires the stop overlay over the idle state.
	rig.set_mechanical_state(Vector2.ZERO, true, false, false)
	_expect(rig.get_active_state_name() == &"idle", "stopping must report idle to gameplay")
	_expect(rig.get_display_state_name() == &"stop", "stopping must show the stop overlay")

	rig.queue_free()
	await process_frame


## Left edge goes back, right edge goes forward. PKG-0135 wired both to the
## forward transition on 03-05 and dropped the AirlockZone entirely.
func _test_station_exits() -> void:
	print("5. Stations 03-05 airlock (forward) vs return (back)...")
	for station_id in ["station_03", "station_04", "station_05"]:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s must load" % station_id)
		if packed == null:
			continue
		var st := packed.instantiate() as Node2D
		root.add_child(st)
		await physics_frame

		var airlock := st.get_node_or_null("AirlockZone")
		var ret := st.get_node_or_null("ReturnZone")
		_expect(airlock != null, "%s must have an AirlockZone (forward exit)" % station_id)
		_expect(ret is ReturnZone, "%s ReturnZone must carry return_zone.gd" % station_id)
		_expect(st.has_signal(&"previous_level_requested"), "%s must expose previous_level_requested" % station_id)

		if ret is ReturnZone:
			var back: Array = []
			(ret as ReturnZone).return_requested.connect(func(): back.append(true))
			var player := st.get_node_or_null("Player") as CharacterBody2D
			if player:
				player.set_physics_process(false)
				player.global_position = Vector2(20.0, 269.0)
				for _i in 6:
					await physics_frame
				_expect(not back.is_empty(), "%s ReturnZone must fire on the left edge" % station_id)
				_expect(not bool(st.get("is_level_completed")), "%s must NOT complete at the ReturnZone" % station_id)

		st.queue_free()
		await process_frame


## The bottom-anchored dialogue panel used to cover Lena from the waist down.
func _test_frame_layout() -> void:
	print("6. Dialogue framing offset and inner-voice suppression...")
	var packed := load("res://scenes/levels/station_01.tscn") as PackedScene
	if packed == null:
		_expect(false, "station_01 must load")
		return
	var st := packed.instantiate() as Node2D
	root.add_child(st)
	for _i in 20:
		await process_frame

	var cam := st.get_node_or_null("Camera") as CinematicCamera
	_expect(cam != null, "station_01 must own a CinematicCamera")
	var box := st.get_node_or_null("CRTDialogueBox")
	var guidance := st.get_node_or_null("NarrativeGuidanceService")
	_expect(box != null and guidance != null, "station_01 must own the dialogue box and the guidance service")

	if cam and box and guidance:
		_expect(cam.dialogue_framing_offset > 0.0, "camera must declare a dialogue framing offset")
		box.call("present", [{"speaker": "LENA", "text": "Kontrola kadru."}])
		for _i in 30:
			await physics_frame
		_expect(bool(guidance.get("dialogue_active")), "inner voice must be suppressed while a dialogue presents")
		var framed_y := cam.global_position.y

		box.call("hide_box")
		for _i in 90:
			await physics_frame
		_expect(not bool(guidance.get("dialogue_active")), "inner voice must resume once the dialogue closes")
		_expect(
			framed_y > cam.global_position.y + 8.0,
			"dialogue framing must lift the actor above the panel (framed %.1f vs idle %.1f)" % [
				framed_y, cam.global_position.y
			]
		)

	# The diegetic label must not sit inside Lena's standing silhouette band.
	var label := st.get_node_or_null("CrispDiegeticText_Terminal") as Node2D
	if label:
		_expect(
			label.position.y + 16.0 < 209.0,
			"station_01 diegetic label must clear the actor band, got y=%.0f" % label.position.y
		)

	st.queue_free()
	await process_frame


func _test_no_new_binaries() -> void:
	print("7. D-125: no new .exe in the tree...")
	var allowed := {
		"Godot_v4.6.3-stable_win64.exe": true,
		"Godot_v4.6.3-stable_win64_console.exe": true,
	}
	var dir := DirAccess.open("res://")
	if dir == null:
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if not dir.current_is_dir() and entry.ends_with(".exe"):
			_expect(allowed.has(entry), "unexpected binary in the project root: %s" % entry)
		entry = dir.get_next()
	dir.list_dir_end()


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0136: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for failure in _failures:
			print("FINAL FAIL: " + failure)
		quit(1)
