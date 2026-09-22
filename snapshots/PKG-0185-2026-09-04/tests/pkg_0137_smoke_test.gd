extends SceneTree

## PKG-0137 Smoke Test — live playthrough contract for the whole campaign.
##
## What the driven playthrough 01 -> 43 found after the D-133 dialogue framing
## change, and what this gate now holds shut:
##
## 1. Framing budget (D-136). The dialogue offset eased the camera 36 px below
##    the play plane on all 45 scenes, and the authored stage stopped at
##    world_size.y — the bottom of every framed shot was the engine clear
##    colour. The stage now paints an apron and the camera may never spend more
##    than the painted budget.
## 2. Diegetic labels stay clear of the dialogue panel and of the actor.
## 3. AirlockZone opens forward on every station once its condition is met.
## 4. ReturnZone goes back on 02-43 and never completes the level (D-132).
## 5. The locomotion cycle is driven by ground actually covered, not by intended
##    velocity, so it cannot skate on slopes or 18 px curb steps.

const LenaVisualRig := preload("res://scripts/player/lena_visual_rig.gd")
const _ThresholdBinder := preload("res://scripts/environment/threshold_binder.gd")

const STATIONS := [
	"station_01","station_02","station_03","station_04","station_05",
	"station_06","station_07","station_08","station_09","station_10",
	"station_11","station_12","station_13","station_14","station_15",
	"station_16","station_17","station_18","station_19","station_20",
	"station_21","station_22","station_23","station_24","station_25",
	"station_26","station_27","station_28","station_29","station_30",
	"station_31","station_32","station_33","station_34","station_35",
	"station_36","station_37","station_38","station_39","station_40",
	"station_41","station_42a","station_42b","station_42c","station_43",
]

const UNLOCK_METHODS: Array[StringName] = [
	&"unlock_exit_door", &"_unlock_exit_door", &"unlock_security_door",
	&"unlock_turnstile", &"open_bus_doors", &"_open_bus_doors",
	&"_open_entrance_door", &"_unlock_exit", &"unlock_exit",
	&"_complete_procedure", &"_check_unlock_condition", &"_check_unlock",
	&"_check_completion_condition", &"_check_threshold_conditions",
]

const VIEW := Vector2(640.0, 360.0)
## CRTDialogueBox._build_interface(): panel at (24, 238), size (592, 102).
const DIALOGUE_PANEL := Rect2(24.0, 238.0, 592.0, 102.0)
const FOOT_OFFSET := 27.0
const BODY_HEIGHT := 87.0

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		print("FAIL: " + message)


func _run() -> void:
	# The gate drives exits directly. Auto transition would swap the scene out
	# from under the station being examined and poison every station after it.
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm:
		gsm.set("campaign_auto_transition_enabled", false)
	_test_apron_contract()
	await _test_displacement_driven_cycle()
	await _test_campaign()
	_finish()


# ------------------------------------------------------------- 1. contract ---

func _test_apron_contract() -> void:
	print("1. Stage apron covers the dialogue framing budget...")
	_expect(
		VectorStageStyle.STAGE_APRON > 0.0,
		"VectorStageStyle must declare a painted stage apron"
	)
	var cam := CinematicCamera.new()
	_expect(
		cam.stage_apron >= cam.dialogue_framing_offset,
		"the painted apron (%.0f) must cover the dialogue framing offset (%.0f)" % [
			cam.stage_apron, cam.dialogue_framing_offset
		]
	)
	# A frame already sitting on the chamber floor has exactly the apron to spend.
	cam.setup_chambers([Rect2(Vector2.ZERO, VIEW)])
	_expect(
		is_equal_approx(cam.get_framing_budget(180.0), cam.stage_apron),
		"a centred flat chamber must offer the whole apron as budget, got %.1f" % cam.get_framing_budget(180.0)
	)
	# And a frame already parked at the bottom of the budget has nothing left.
	_expect(
		is_zero_approx(cam.get_framing_budget(180.0 + cam.stage_apron)),
		"the budget must run out at the bottom of the apron"
	)
	cam.free()


# --------------------------------------------------------- 5. locomotion -----

func _test_displacement_driven_cycle() -> void:
	print("2. Locomotion cycle follows ground covered, not intended velocity...")
	var holder := Node2D.new()
	root.add_child(holder)
	var rig := LenaVisualRig.new()
	holder.add_child(rig)
	rig.set_mechanical_state(Vector2(96.0, 0.0), true, false, false)
	await process_frame
	await process_frame

	# Body pinned in place while the movement code still asks for 96 px/s: this
	# is the slope case, and the cycle must not advance.
	var pinned_before: float = float(rig.get("_cycle_phase"))
	for _i in 6:
		rig.set_mechanical_state(Vector2(96.0, 0.0), true, false, false)
		await process_frame
	var pinned_after: float = float(rig.get("_cycle_phase"))
	_expect(
		is_equal_approx(pinned_before, pinned_after),
		"a body that covers no ground must not advance the walk cycle (%.4f -> %.4f)" % [
			pinned_before, pinned_after
		]
	)

	# Now cover exactly one stride and expect exactly one step.
	var before: float = float(rig.get("_cycle_phase"))
	holder.position.x += LenaVisualRig.WALK_STRIDE_PX
	rig.set_mechanical_state(Vector2(96.0, 0.0), true, false, false)
	await process_frame
	var advance: float = fposmod(float(rig.get("_cycle_phase")) - before, 1.0)
	_expect(
		advance > 0.9 or advance < 0.1,
		"one stride of ground must be one full step of cycle, got %.3f" % advance
	)

	# Half a stride is half a step, so the contact foot tracks the floor.
	before = float(rig.get("_cycle_phase"))
	holder.position.x += LenaVisualRig.WALK_STRIDE_PX * 0.5
	rig.set_mechanical_state(Vector2(96.0, 0.0), true, false, false)
	await process_frame
	advance = fposmod(float(rig.get("_cycle_phase")) - before, 1.0)
	_expect(
		absf(advance - 0.5) < 0.02,
		"half a stride must advance half a step, got %.3f" % advance
	)
	holder.queue_free()
	await process_frame


# --------------------------------------- 1-4. every station, live ------------

func _test_campaign() -> void:
	print("3. Framing, labels and exits on all %d campaign scenes..." % STATIONS.size())
	for id in STATIONS:
		await _check_station(id)


func _find(node: Node, pred: Callable) -> Node:
	if pred.call(node):
		return node
	for c in node.get_children():
		var f: Node = _find(c, pred)
		if f:
			return f
	return null


func _collect(node: Node, pred: Callable, out: Array) -> void:
	if pred.call(node):
		out.append(node)
	for c in node.get_children():
		_collect(c, pred, out)


## Flips every story flag the station gates on, so the exit is judged on the
## mechanism rather than on the writing. `is_level_completed` is the outcome.
func _satisfy_story_gates(st: Node) -> void:
	# `is_drawer_open` stays in: an open drawer is a live collider in the middle of
	# station 13, so leaving it open is the worse case and the one worth walking.
	const KEEP := ["is_level_completed", "is_climbing", "is_player_in_range"]
	for prop in st.get_property_list():
		if int(prop.get("type", 0)) != TYPE_BOOL:
			continue
		var pname: String = String(prop.get("name", ""))
		if pname in KEEP or pname.begins_with("_"):
			continue
		if pname.begins_with("is_") or pname.begins_with("are_") or pname.begins_with("has_"):
			st.set(pname, true)


## Anchoring is a player verb, not a flag: station 38's rescue bulkhead resets
## the checkpoint until the tether is actually anchored. Satisfying the exit
## condition therefore means anchoring, not only flipping booleans.
func _anchor_everything(node: Node) -> void:
	if node is AnchorableObject:
		(node as AnchorableObject).set_anchored(true)
	for c in node.get_children():
		_anchor_everything(c)


func _check_station(id: String) -> void:
	var packed := load("res://scenes/levels/%s.tscn" % id) as PackedScene
	_expect(packed != null, "%s must load" % id)
	if packed == null:
		return
	var st := packed.instantiate() as Node2D
	root.add_child(st)
	for _i in 4:
		await process_frame

	var cam := _find(st, func(n): return n is Camera2D) as Camera2D
	var box := _find(st, func(n): return n is CanvasLayer and n.has_method("is_presenting"))
	var player := st.get_node_or_null("Player") as CharacterBody2D
	var stage := _find(st, func(n): return n is VectorStageEnvironment) as VectorStageEnvironment
	var stage_rect := Rect2(Vector2.ZERO, VIEW)
	if stage:
		stage_rect = Rect2(stage.global_position, stage.world_size)

	# --- 1. framed shot never leaves painted scenery --------------------
	if box and not bool(box.call("is_presenting")):
		box.call("present", [{"speaker": "LENA", "text": "Kontrola kadru PKG-0137."}])
	for _i in 40:
		await physics_frame

	if cam:
		var half := VIEW * 0.5 * cam.zoom
		var view := Rect2(cam.global_position + cam.offset - half, half * 2.0)
		var painted := Rect2(
			stage_rect.position,
			stage_rect.size + Vector2(0.0, VectorStageStyle.STAGE_APRON)
		)
		_expect(
			view.position.y >= painted.position.y - 0.5
				and view.end.y <= painted.end.y + 0.5
				and view.position.x >= painted.position.x - 0.5
				and view.end.x <= painted.end.x + 0.5,
			"%s framed shot %s leaves the painted stage %s" % [id, str(view), str(painted)]
		)

	# --- 2. diegetic labels clear the panel and the actor ---------------
	var labels: Array = []
	_collect(st, func(n): return n is CrispDiegeticText, labels)
	var lena_rect := Rect2()
	if player:
		var feet: Vector2 = (player as Node2D).get_canvas_transform() \
			* (player.global_position + Vector2(0.0, FOOT_OFFSET))
		lena_rect = Rect2(feet.x - 16.0, feet.y - BODY_HEIGHT, 32.0, BODY_HEIGHT)
	for lbl in labels:
		var panel := lbl.get("_panel") as Control
		if panel == null:
			continue
		var r := Rect2(panel.position, panel.size)
		if r.size.x <= 0.0 or r.size.y <= 0.0:
			continue
		_expect(
			not r.intersects(DIALOGUE_PANEL),
			"%s label %s sits on the dialogue panel @%s" % [id, lbl.name, str(r)]
		)
		if lena_rect.size.x > 0.0:
			_expect(
				not r.intersects(lena_rect),
				"%s label %s sits on the actor @%s" % [id, lbl.name, str(r)]
			)

	if box:
		box.call("hide_box")
		for _i in 10:
			await physics_frame

	# --- 3. AirlockZone opens forward -----------------------------------
	var airlock := _find(st, func(n): return String(n.name) == "AirlockZone") as Area2D
	_expect(airlock != null, "%s must own an AirlockZone (forward exit)" % id)
	var completed: Array = []
	if st.has_signal(&"level_completed"):
		st.connect(&"level_completed", func(): completed.append(true))
	var went_back: Array = []
	if st.has_signal(&"previous_level_requested"):
		st.connect(&"previous_level_requested", func(): went_back.append(true))

	if airlock and player:
		player.set_physics_process(false)
		_satisfy_story_gates(st)
		_anchor_everything(st)
		for m in UNLOCK_METHODS:
			if st.has_method(m):
				st.call(m)
		await physics_frame
		_ThresholdBinder.install(st)
		if st.get_node_or_null("Threshold") != null:
			_ThresholdBinder.complete_from_test(st, player)
			await physics_frame
		else:
			player.global_position = airlock.global_position
			for _i in 8:
				await physics_frame
		_expect(
			not completed.is_empty() or bool(st.get("is_level_completed")),
			"%s AirlockZone must complete the station once its condition is met" % id
		)

	# --- 4. ReturnZone goes back, never forward -------------------------
	if id != "station_01":
		var ret := _find(st, func(n): return String(n.name) == "ReturnZone")
		_expect(ret is ReturnZone, "%s ReturnZone must carry return_zone.gd" % id)
		_expect(
			st.has_signal(&"previous_level_requested"),
			"%s must expose previous_level_requested" % id
		)
		if ret is ReturnZone and player:
			st.set("is_level_completed", false)
			completed.clear()
			player.global_position = Vector2(20.0, (ret as Node2D).global_position.y)
			for _i in 8:
				await physics_frame
			_expect(not went_back.is_empty(), "%s ReturnZone must fire on the left edge" % id)
			_expect(completed.is_empty(), "%s ReturnZone must not complete the level" % id)

	# Freed immediately: a queued station keeps its colliders alive into the next
	# scene and would make the following station report a phantom blocker.
	root.remove_child(st)
	st.free()
	await physics_frame
	await process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("PKG-0137: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for failure in _failures:
			print("FINAL FAIL: " + failure)
		quit(1)
