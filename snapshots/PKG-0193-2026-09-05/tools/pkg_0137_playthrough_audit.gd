extends SceneTree

## PKG-0137 — driven playthrough 01 -> 43 after the D-133 dialogue framing change.
##
## For every campaign station this walks Lena through the room and records the
## five things the framing change could have broken:
##   1. frame vs stage — does the lowered camera expose void under the play plane
##   2. labels        — do CrispDiegeticText panels collide with the dialogue
##                      panel or with the actor silhouette
##   3. AirlockZone   — does the forward exit fire once the station is unlocked
##   4. ReturnZone    — does the left edge go back instead of completing (D-132)
##   5. locomotion    — does the distance-driven cycle slide on slopes / 18 px steps
##
## Prints a per-station row, then writes a machine-readable summary to reports/.

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
## LenaVisualRig: feet sit FOOT_OFFSET below the player origin, body is 87 px tall.
const FOOT_OFFSET := 27.0
const BODY_HEIGHT := 87.0
const WALK_SPEED := 96.0
const STEP_LIMIT := 18.0

var _rows: Array = []
var _blockers: Array = []


func _initialize() -> void:
	call_deferred(&"_run")


func _run() -> void:
	print("================================================================================")
	print("  PKG-0137 PLAYTHROUGH AUDIT 01 -> 43 (frame, labels, exits, locomotion)")
	print("================================================================================")
	var gsm := root.get_node_or_null("GameStateManager")
	if gsm:
		gsm.set("campaign_auto_transition_enabled", false)
	# `-- station_12 station_13` restricts the run while chasing one row.
	var wanted := OS.get_cmdline_user_args()
	for id in STATIONS:
		if not wanted.is_empty() and not wanted.has(id):
			continue
		await _audit(id)
	_report()


# ---------------------------------------------------------------- helpers ----

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


func _stage_rect(st: Node) -> Rect2:
	var stage := _find(st, func(n): return n is VectorStageEnvironment) as VectorStageEnvironment
	if stage == null:
		return Rect2(Vector2.ZERO, VIEW)
	return Rect2(stage.global_position, stage.world_size)


func _camera_view(cam: Camera2D) -> Rect2:
	var half := VIEW * 0.5 * cam.zoom
	var centre := cam.global_position + cam.offset
	return Rect2(centre - half, half * 2.0)


# ------------------------------------------------------------------ audit ----

func _audit(id: String) -> void:
	var packed := load("res://scenes/levels/%s.tscn" % id) as PackedScene
	if packed == null:
		_blockers.append("%s: scene missing" % id)
		return
	var st := packed.instantiate() as Node2D
	root.add_child(st)
	for _i in 6:
		await process_frame

	var row := {"id": id}
	var cam := _find(st, func(n): return n is Camera2D) as Camera2D
	var box := _find(st, func(n): return n is CanvasLayer and n.has_method("is_presenting"))
	var player := st.get_node_or_null("Player") as CharacterBody2D

	# --- 1. frame vs stage, with the dialogue panel open -----------------
	if box and not bool(box.call("is_presenting")):
		box.call("present", [{"speaker": "LENA", "text": "Kontrola kadru PKG-0137."}])
	for _i in 60:
		await physics_frame

	# Painted scenery is the stage plus the apron the camera is allowed to spend.
	var stage := _stage_rect(st)
	stage.size.y += VectorStageStyle.STAGE_APRON
	var overflow := {"top": 0.0, "bottom": 0.0, "left": 0.0, "right": 0.0}
	var worst_overflow := 0.0
	if cam:
		var view := _camera_view(cam)
		overflow["top"] = maxf(0.0, stage.position.y - view.position.y)
		overflow["bottom"] = maxf(0.0, view.end.y - stage.end.y)
		overflow["left"] = maxf(0.0, stage.position.x - view.position.x)
		overflow["right"] = maxf(0.0, view.end.x - stage.end.x)
		row["cam_y"] = cam.global_position.y
		worst_overflow = maxf(
			maxf(overflow["top"], overflow["bottom"]),
			maxf(overflow["left"], overflow["right"])
		)
	row["overflow"] = overflow
	row["frame_ok"] = worst_overflow <= 0.5
	if not row["frame_ok"]:
		_blockers.append("%s: framing exposes %.0f px outside the stage (%s)" % [
			id, worst_overflow, JSON.stringify(overflow)
		])

	# --- 2. diegetic labels vs the dialogue panel and vs the actor -------
	var labels: Array = []
	_collect(st, func(n): return n is CrispDiegeticText, labels)
	var label_hits: Array = []
	var lena_rect := Rect2()
	if player:
		var xform := (player as Node2D).get_canvas_transform()
		var feet: Vector2 = xform * (player.global_position + Vector2(0.0, FOOT_OFFSET))
		lena_rect = Rect2(feet.x - 16.0, feet.y - BODY_HEIGHT, 32.0, BODY_HEIGHT)
	for lbl in labels:
		var panel := lbl.get("_panel") as Control
		if panel == null:
			continue
		var r := Rect2(panel.position, panel.size)
		if r.size.x <= 0.0 or r.size.y <= 0.0:
			continue
		if r.intersects(DIALOGUE_PANEL):
			label_hits.append("%s over the dialogue panel @%s" % [lbl.name, str(r)])
		if lena_rect.size.x > 0.0 and r.intersects(lena_rect):
			label_hits.append("%s over the actor @%s" % [lbl.name, str(r)])
	row["labels"] = labels.size()
	row["label_hits"] = label_hits
	row["labels_ok"] = label_hits.is_empty()
	for hit in label_hits:
		_blockers.append("%s: %s" % [id, hit])

	if box:
		box.call("hide_box")
		for _i in 20:
			await physics_frame

	# --- 5. locomotion across the whole floor ---------------------------
	var loco := {"slip_px": 0.0, "max_step": 0.0, "stuck_at": -1.0, "blocked_frames": 0, "travelled": 0.0}
	if player:
		player.set_physics_process(false)
		loco = await _walk_profile(player)
	row["loco"] = loco
	row["loco_ok"] = float(loco["slip_px"]) <= 6.0 and float(loco["max_step"]) <= STEP_LIMIT + 0.5
	if not row["loco_ok"]:
		_blockers.append("%s: locomotion slip=%.1f px, max step=%.1f px" % [
			id, loco["slip_px"], loco["max_step"]
		])

	# --- 3 + 4. exits ---------------------------------------------------
	var airlock := _find(st, func(n): return String(n.name) == "AirlockZone") as Area2D
	var ret := _find(st, func(n): return String(n.name) == "ReturnZone")
	row["has_airlock"] = airlock != null
	row["has_return"] = ret is ReturnZone

	var completed: Array = []
	if st.has_signal(&"level_completed"):
		st.connect(&"level_completed", func(): completed.append(true))
	var went_back: Array = []
	if st.has_signal(&"previous_level_requested"):
		st.connect(&"previous_level_requested", func(): went_back.append(true))

	if player and airlock:
		var props: Array = []
		_collect(st, func(n): return n is MemoryResonancePoint, props)
		for p in props:
			p.is_player_in_range = true
			p.trigger_interaction()
			p.trigger_interaction()
		await process_frame
		for m in UNLOCK_METHODS:
			if st.has_method(m):
				st.call(m)
		# Criterion 3 is about the mechanism, not about the writing: satisfy every
		# story flag the station gates on, then check the airlock actually opens.
		_satisfy_story_gates(st)
		_anchor_everything(st)
		for m in UNLOCK_METHODS:
			if st.has_method(m):
				st.call(m)
		await process_frame
		await physics_frame
		# The locomotion pass left her standing past the airlock. Step back out of
		# the zone first, or the entry that matters never happens.
		player.global_position = Vector2(
			maxf(60.0, airlock.global_position.x - 140.0), player.global_position.y
		)
		for _i in 6:
			await physics_frame
		await _walk_to(player, airlock.global_position.x)
		for _i in 8:
			await physics_frame
	row["airlock_ok"] = not completed.is_empty()
	if airlock == null:
		_blockers.append("%s: no AirlockZone" % id)
	elif completed.is_empty():
		_blockers.append("%s: AirlockZone did not complete the station after unlock" % id)

	if id != "station_01":
		if not (ret is ReturnZone):
			_blockers.append("%s: missing canonical ReturnZone" % id)
			row["return_ok"] = false
		elif player:
			st.set("is_level_completed", false)
			completed.clear()
			await _walk_to(player, 16.0)
			for _i in 8:
				await physics_frame
			row["return_ok"] = not went_back.is_empty() and completed.is_empty()
			if went_back.is_empty():
				_blockers.append("%s: ReturnZone never fired on the left edge" % id)
			if not completed.is_empty():
				_blockers.append("%s: ReturnZone completed the level instead of going back" % id)
	else:
		row["return_ok"] = true

	_rows.append(row)
	print("%-12s frame=%-4s(over %3.0f) labels=%d%-4s loco(slip %5.1f step %2.0f)=%-4s airlock=%-4s return=%s" % [
		id,
		"OK" if row["frame_ok"] else "FAIL", worst_overflow,
		row["labels"], "" if row["labels_ok"] else " HIT",
		loco["slip_px"], loco["max_step"], "OK" if row["loco_ok"] else "FAIL",
		"OK" if row.get("airlock_ok", false) else "FAIL",
		"OK" if row.get("return_ok", false) else "FAIL",
	])
	# Freed immediately, not queued: a station whose colliders survive into the
	# next instantiation would poison every later row of this report.
	root.remove_child(st)
	st.free()
	await physics_frame
	await process_frame


## Walks the floor left-to-right and measures how far the animation cycle drifts
## from the ground actually covered, plus the tallest vertical step survived.
func _walk_profile(player: CharacterBody2D) -> Dictionary:
	var rig = player.get("visual_rig")
	var slip := 0.0
	var max_step := 0.0
	var stuck_at := -1.0
	var start_x: float = player.global_position.x
	var last := player.global_position
	var stalled := 0
	var blocked := 0
	var last_phase: float = float(rig.get("_cycle_phase")) if rig else 0.0
	for _i in 300:
		if not player.is_on_floor():
			player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
		else:
			player.velocity.y = 0.0
		player.velocity.x = WALK_SPEED
		player.move_and_slide()
		if player.has_method("try_curb_step"):
			player.try_curb_step(1.0)
		if rig:
			rig.set_mechanical_state(player.velocity, player.is_on_floor(), false, false)
		await physics_frame
		var now := player.global_position
		var moved := now - last
		# Foot slide: how far the animation cycle claims the contact foot moved
		# against how far the ground under it actually went past. Only sampled
		# while the walk cycle owns the body — a curb step or a landing is a
		# different state and is not supposed to spin the cycle at all.
		if rig:
			var phase: float = float(rig.get("_cycle_phase"))
			var advance: float = fposmod(phase - last_phase, 1.0)
			last_phase = phase
			if rig.get_active_state_name() == &"walk":
				slip += absf(advance * LenaVisualRig.WALK_STRIDE_PX - absf(moved.x))
		max_step = maxf(max_step, absf(moved.y))
		if absf(moved.x) < 0.05:
			stalled += 1
			blocked += 1
			if stalled > 24 and stuck_at < 0.0:
				stuck_at = now.x
		else:
			stalled = 0
		last = now
		if now.x > 600.0:
			break
	return {
		"slip_px": slip,
		"max_step": max_step,
		"stuck_at": stuck_at,
		"blocked_frames": blocked,
		"travelled": player.global_position.x - start_x,
	}


## Flips every story flag the station declares, so the exits can be judged on
## their own terms. `is_level_completed` is left alone: that is the outcome.
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


func _walk_to(player: CharacterBody2D, target_x: float) -> void:
	for _i in 800:
		var dx: float = target_x - player.global_position.x
		if absf(dx) <= 8.0:
			return
		if not player.is_on_floor():
			player.velocity.y = minf(player.velocity.y + 12.0, 360.0)
		else:
			player.velocity.y = 0.0
		player.velocity.x = signf(dx) * WALK_SPEED
		player.move_and_slide()
		if player.has_method("try_curb_step"):
			player.try_curb_step(dx)
		await physics_frame


func _report() -> void:
	print("================================================================================")
	print("BLOCKERS: %d" % _blockers.size())
	for b in _blockers:
		print("  BLOCK  " + b)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://reports"))
	var f := FileAccess.open("res://reports/pkg_0137_playthrough_audit.json", FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"rows": _rows, "blockers": _blockers}, "  "))
		f.close()
	if _blockers.is_empty():
		print("PKG-0137 PLAYTHROUGH: CLEAN.")
		quit(0)
	else:
		print("PKG-0137 PLAYTHROUGH: %d BLOCKERS." % _blockers.size())
		quit(1)
