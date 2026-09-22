extends SceneTree

## PKG-0130 — Frame Budget & Frame Timing Audit (45 campaign scenes)
##
## Instantiates every campaign scene, separates the objects that actually consume
## the 60 Hz frame budget (emitting particle systems, live particles, lights,
## playing audio voices) from the objects that are merely pre-allocated and
## dormant (one-shot burst emitters, idle SFX players), and measures the
## wall-clock cost of a sustained run of frames.
##
## The distinction matters: a dormant one-shot CPUParticles2D costs nothing per
## frame, so counting it against a live budget would force the removal of
## correctly pooled effects. What must be bounded is the *active* set plus the
## pool size.
##
## The audit proves object budgets and relative frame cost only. It cannot prove
## GPU fill cost on a specific machine, and it never claims anything about how the
## game feels (ADR-003).
##
## Usage:
##   godot --headless --path . --script res://tools/frame_budget_audit.gd

const CAMPAIGN_DIR := "res://scenes/levels"

## Frames measured per scene for the timing sample.
const TIMED_FRAMES := 60

## A headless SceneTree spends a fixed cost per idle frame that has nothing to do
## with the scene under test. Timing is therefore differential: the empty tree is
## measured first, and only the cost *attributable to the scene* is budgeted.
## Headless frames carry no renderer, no compositor shader and no GPU fill, so this
## number bounds script, physics and particle-stepping cost only.
const ATTRIBUTABLE_FRAME_BUDGET_MS := 3.0

const STATION_IDS: Array[String] = [
	"station_01", "station_02", "station_03", "station_04", "station_05",
	"station_06", "station_07", "station_08", "station_09", "station_10",
	"station_11", "station_12", "station_13", "station_14", "station_15",
	"station_16", "station_17", "station_18", "station_19", "station_20",
	"station_21", "station_22", "station_23", "station_24", "station_25",
	"station_26", "station_27", "station_28", "station_29", "station_30",
	"station_31", "station_32", "station_33", "station_34", "station_35",
	"station_36", "station_37", "station_38", "station_39", "station_40",
	"station_41", "station_42a", "station_42b", "station_42c", "station_43",
]

## Object budgets per scene.
const MAX_LIGHTS := 8
const MAX_CANVAS_LAYERS := 8
const MAX_PLAYING_AUDIO_VOICES := 4
const MAX_POOLED_AUDIO_PLAYERS := 20

var _violations: Array[String] = []
var _worst_scene := ""
var _worst_ms := 0.0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	print("================================================================================")
	print("       PKG-0130 FRAME BUDGET & FRAME TIMING AUDIT: 45 CAMPAIGN SCENES           ")
	print("================================================================================")
	print("Active budgets per scene: emitting systems <= %d, live particles <= %d," % [
		ParticleBudget.MAX_ACTIVE_EMITTERS, ParticleBudget.MAX_ACTIVE_PARTICLES
	])
	print("                          lights <= %d, canvas layers <= %d, playing voices <= %d." % [
		MAX_LIGHTS, MAX_CANVAS_LAYERS, MAX_PLAYING_AUDIO_VOICES
	])
	print("Pool budgets per scene:   emitters <= %d, audio players <= %d." % [
		ParticleBudget.MAX_POOLED_EMITTERS, MAX_POOLED_AUDIO_PLAYERS
	])
	print("Timing budget:            <= %.2f ms/frame attributable to the scene over %d frames." % [
		ATTRIBUTABLE_FRAME_BUDGET_MS, TIMED_FRAMES
	])
	print("Particle simulation cap:  %d Hz, fract_delta off (deterministic).\n" % ParticleBudget.SIMULATION_FPS)

	var totals := {
		"pooled_emitters": 0,
		"active_emitters": 0,
		"active_particles": 0,
		"lights": 0,
		"pooled_audio": 0,
		"playing_audio": 0,
	}

	var baseline_ms := await _measure_idle_frame_cost()
	print("Headless idle baseline: %.3f ms/frame (empty tree, subtracted from every sample).\n" % baseline_ms)

	for station_id in STATION_IDS:
		var scene_path := CAMPAIGN_DIR + "/" + station_id + ".tscn"
		if not ResourceLoader.exists(scene_path):
			_violations.append("%s: scene file missing" % station_id)
			continue

		var packed: PackedScene = load(scene_path)
		if packed == null:
			_violations.append("%s: scene failed to load" % station_id)
			continue

		var instance: Node = packed.instantiate()
		root.add_child(instance)
		# Let _ready, particle preprocess and looping ambience settle before timing.
		for _warmup in range(6):
			await process_frame

		var stats := _collect_stats(instance)

		var started := Time.get_ticks_usec()
		for _frame in range(TIMED_FRAMES):
			await process_frame
		var elapsed_us := Time.get_ticks_usec() - started
		var per_frame_ms := (float(elapsed_us) / float(TIMED_FRAMES)) / 1000.0
		var attributable_ms := maxf(0.0, per_frame_ms - baseline_ms)

		for key in totals.keys():
			totals[key] = int(totals[key]) + int(stats[key])
		if attributable_ms > _worst_ms:
			_worst_ms = attributable_ms
			_worst_scene = station_id

		_check(station_id, "emitting particle systems", int(stats["active_emitters"]), ParticleBudget.MAX_ACTIVE_EMITTERS)
		_check(station_id, "live particles", int(stats["active_particles"]), ParticleBudget.MAX_ACTIVE_PARTICLES)
		_check(station_id, "pooled particle emitters", int(stats["pooled_emitters"]), ParticleBudget.MAX_POOLED_EMITTERS)
		_check(station_id, "lights", int(stats["lights"]), MAX_LIGHTS)
		_check(station_id, "canvas layers", int(stats["canvas_layers"]), MAX_CANVAS_LAYERS)
		_check(station_id, "playing audio voices", int(stats["playing_audio"]), MAX_PLAYING_AUDIO_VOICES)
		_check(station_id, "pooled audio players", int(stats["pooled_audio"]), MAX_POOLED_AUDIO_PLAYERS)

		if int(stats["uncapped_emitters"]) > 0:
			_violations.append("%s: %d particle emitter(s) bypassing ParticleBudget.apply_frame_budget()" % [
				station_id, int(stats["uncapped_emitters"])
			])
		if attributable_ms > ATTRIBUTABLE_FRAME_BUDGET_MS:
			_violations.append("%s: scene-attributable frame cost %.3f ms exceeds %.2f ms" % [
				station_id, attributable_ms, ATTRIBUTABLE_FRAME_BUDGET_MS
			])

		print("--- %s ---" % station_id)
		print("  nodes=%d | emitters %d active / %d pooled | particles %d live / %d pooled" % [
			int(stats["nodes"]),
			int(stats["active_emitters"]),
			int(stats["pooled_emitters"]),
			int(stats["active_particles"]),
			int(stats["pooled_particles"]),
		])
		print("  lights=%d | canvas layers=%s | audio %d playing / %d pooled" % [
			int(stats["lights"]),
			str(stats["layer_numbers"]),
			int(stats["playing_audio"]),
			int(stats["pooled_audio"]),
		])
		print("  frame cost: %.3f ms/frame raw, %.3f ms attributable to the scene (%d frames)" % [
			per_frame_ms, attributable_ms, TIMED_FRAMES
		])

		instance.queue_free()
		await process_frame
		await process_frame

	print("\n================================================================================")
	print("SUMMARY")
	print("  Scenes audited: %d" % STATION_IDS.size())
	print("  Emitting particle systems across campaign: %d" % int(totals["active_emitters"]))
	print("  Live particles across campaign: %d" % int(totals["active_particles"]))
	print("  Pooled (dormant) emitters across campaign: %d" % int(totals["pooled_emitters"]))
	print("  Light2D instances across campaign: %d" % int(totals["lights"]))
	print("  Playing audio voices across campaign: %d" % int(totals["playing_audio"]))
	print("  Pooled audio players across campaign: %d" % int(totals["pooled_audio"]))
	print("  Shared radial light textures cached: %d" % AtmosphereRig.get_light_texture_cache_size())
	print("  Cached procedural PCM buffers: %d" % ProceduralAudio.get_sound_cache_size())
	print("  Worst scene-attributable frame cost: %.3f ms (%s)" % [_worst_ms, _worst_scene])
	print("================================================================================")

	if _violations.is_empty():
		print("FRAME BUDGET AUDIT: PASS — every campaign scene stays inside its object and timing budget.")
		quit(0)
	else:
		print("FRAME BUDGET AUDIT: %d VIOLATION(S)" % _violations.size())
		for violation in _violations:
			print("  * ", violation)
		quit(1)


func _check(station_id: String, label: String, value: int, budget: int) -> void:
	if value > budget:
		_violations.append("%s: %s = %d exceeds budget %d" % [station_id, label, value, budget])


## Measure the fixed per-frame cost of an idle headless SceneTree so scene samples
## can be reported as a delta rather than an absolute that is mostly loop overhead.
func _measure_idle_frame_cost() -> float:
	for _warmup in range(12):
		await process_frame
	var started := Time.get_ticks_usec()
	for _frame in range(TIMED_FRAMES):
		await process_frame
	var elapsed_us := Time.get_ticks_usec() - started
	return (float(elapsed_us) / float(TIMED_FRAMES)) / 1000.0


func _collect_stats(instance: Node) -> Dictionary:
	var nodes := 0
	var pooled_emitters := 0
	var active_emitters := 0
	var uncapped_emitters := 0
	var pooled_particles := 0
	var active_particles := 0
	var lights := 0
	var pooled_audio := 0
	var playing_audio := 0
	var layer_numbers: Array[int] = []

	var pending: Array[Node] = [instance]
	while not pending.is_empty():
		var node: Node = pending.pop_back()
		nodes += 1
		if node is CPUParticles2D:
			var emitter := node as CPUParticles2D
			pooled_emitters += 1
			pooled_particles += emitter.amount
			if emitter.emitting:
				active_emitters += 1
				active_particles += emitter.amount
			if not ParticleBudget.is_within_frame_budget(emitter):
				uncapped_emitters += 1
		elif node is GPUParticles2D:
			# GPU particles are outside the Zero-Asset GL Compatibility contract.
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
			layer_numbers.append((node as CanvasLayer).layer)
		for child in node.get_children():
			pending.append(child)

	layer_numbers.sort()
	return {
		"nodes": nodes,
		"pooled_emitters": pooled_emitters,
		"active_emitters": active_emitters,
		"uncapped_emitters": uncapped_emitters,
		"pooled_particles": pooled_particles,
		"active_particles": active_particles,
		"lights": lights,
		"pooled_audio": pooled_audio,
		"playing_audio": playing_audio,
		"canvas_layers": layer_numbers.size(),
		"layer_numbers": layer_numbers,
	}
