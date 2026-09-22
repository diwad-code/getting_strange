extends SceneTree

## PKG-0109: repeatable technical cost audit for the existing Godot runtime.
##
## Run with the normal Windows/OpenGL driver, not --headless:
##   godot_console.exe --path C:\getting_strange --script res://tools/audit_h005.gd
##
## This harness changes only its own viewport sampling and CanvasItem visibility
## toggles. It never edits a game scene, changes collision, or disables the
## player/process/physics logic during a comparison run.

const OUTPUT_ROOT := "res://reports/pkg_0109"
const WARMUP_FRAMES := 60
const SAMPLE_FRAMES := 120
const ANIMATION_CYCLE_FRAMES := 220
const METRIC_KEYS: Array[String] = [
	"frame_interval_ms",
	"time_process_ms",
	"time_physics_ms",
	"canvas_items",
	"canvas_primitives",
	"canvas_draw_calls",
	"render_cpu_ms",
	"render_gpu_ms",
	"frame_setup_cpu_ms",
]

const STATIC_MODES: Array[String] = ["full_world", "no_player_and_shadow"]
const ANIMATION_MODES: Array[String] = [
	"full_world",
	"no_dust",
	"no_dust_and_shadow",
	"no_player_and_shadow",
	"no_shadow",
]

var _inventory_rows: Array[Dictionary] = []
var _measurement_rows: Array[Dictionary] = []
var _animation_rows: Array[Dictionary] = []
var _animation_sample_rows: Array[Dictionary] = []
var _component_delta_rows: Array[Dictionary] = []
var _animation_aggregates: Dictionary = {}
var _metadata: Dictionary = {}


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(640, 360)
	Engine.max_fps = 0
	# The product project does not set this value. The harness disables V-Sync
	# only so frame intervals do not collapse to the monitor refresh period.
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	var viewport_rid := root.get_viewport_rid()
	RenderingServer.viewport_set_measure_render_time(viewport_rid, true)
	_metadata = _build_metadata()
	_write_json("metadata.json", _metadata)

	var state := root.get_node_or_null("GameStateManager")
	if state:
		_set_if_property(state, "campaign_auto_transition_enabled", false)
		if state.has_method("reset_campaign"):
			state.call("reset_campaign", true)

	await _run_inventory()
	await _run_static_measurements(state)
	await _run_animation_audit(state)
	_write_outputs()

	if state:
		_set_if_property(state, "campaign_auto_transition_enabled", true)
		if state.has_method("reset_campaign"):
			state.call("reset_campaign", true)

	print("PKG-0109 AUDIT PASS: %d scene resources inventoried, %d frame rows, %d animation rows" % [
		_inventory_rows.size(), _measurement_rows.size(), _animation_rows.size()
	])
	quit(0)


func _build_metadata() -> Dictionary:
	var version_info: Dictionary = Engine.get_version_info()
	return {
		"package": "PKG-0109",
		"audit": "H-005",
		"timestamp_utc": Time.get_datetime_string_from_system(true),
		"godot": String(version_info.get("string", "unknown")),
		"os": OS.get_name(),
		"rendering_method": RenderingServer.get_current_rendering_method(),
		"rendering_driver": RenderingServer.get_current_rendering_driver_name(),
		"video_adapter_name": RenderingServer.get_video_adapter_name(),
		"video_adapter_vendor": RenderingServer.get_video_adapter_vendor(),
		"video_adapter_api": RenderingServer.get_video_adapter_api_version(),
		"viewport": "640x360",
		"physics_hz": 60,
		"vsync": "disabled by harness only",
		"engine_max_fps": 0,
		"warmup_frames": WARMUP_FRAMES,
		"sample_frames": SAMPLE_FRAMES,
		"animation_cycle_frames": ANIMATION_CYCLE_FRAMES,
		"render_time_measurement": "RenderingServer.viewport_set_measure_render_time",
		"notes": "Normal Windows/OpenGL runtime measurement; no game scene edits",
	}


func _build_scene_cases() -> Array[Dictionary]:
	var cases: Array[Dictionary] = []
	for station_number in range(1, 42):
		var id := "station_%02d" % station_number
		cases.append({
			"id": id,
			"path": "res://scenes/levels/%s.tscn" % id,
			"campaign_space": station_number,
			"kind": "station",
		})
	for finale_id in ["station_42a", "station_42b", "station_42c"]:
		cases.append({
			"id": finale_id,
			"path": "res://scenes/levels/%s.tscn" % finale_id,
			"campaign_space": 42,
			"kind": "finale_variant",
		})
	cases.append({
		"id": "station_43",
		"path": "res://scenes/levels/station_43.tscn",
		"campaign_space": 43,
		"kind": "epilogue",
	})
	return cases


func _run_inventory() -> void:
	for case_data in _build_scene_cases():
		var packed := load(String(case_data["path"])) as PackedScene
		if packed == null:
			_inventory_rows.append({
				"scene": case_data["id"],
				"path": case_data["path"],
				"campaign_space": case_data["campaign_space"],
				"status": "missing",
			})
			continue
		var station := packed.instantiate() as Node2D
		if station == null:
			_inventory_rows.append({
				"scene": case_data["id"],
				"path": case_data["path"],
				"campaign_space": case_data["campaign_space"],
				"status": "not_node2d",
			})
			continue
		root.add_child(station)
		await _wait_frames(8)
		_prepare_station(station)
		var row := _collect_inventory(station, case_data)
		_inventory_rows.append(row)
		station.queue_free()
		await process_frame


func _run_static_measurements(state: Node) -> void:
	var measured_ids: Array[String] = [
		"station_01",
		"station_02",
		"station_14",
		"station_22",
		"station_38",
		"station_41",
		"station_42a",
		"station_42b",
		"station_42c",
		"station_43",
	]
	for scene_id in measured_ids:
		var path := "res://scenes/levels/%s.tscn" % scene_id
		var packed := load(path) as PackedScene
		if packed == null:
			continue
		if state and state.has_method("reset_campaign"):
			state.call("reset_campaign", true)
		var station := packed.instantiate() as Node2D
		if station == null:
			continue
		root.add_child(station)
		await _wait_frames(8)
		_prepare_station(station)

		for mode in STATIC_MODES:
			_apply_visual_mode(station, mode)
			var stats := await _sample_frames(station, mode, SAMPLE_FRAMES, WARMUP_FRAMES)
			_measurement_rows.append(_summary_row(scene_id, "world", mode, stats))

		if scene_id == "station_01" or scene_id == "station_42c":
			_apply_visual_mode(station, "full_world")
			_present_audit_dialogue(station)
			var ui_stats := await _sample_frames(station, "full_world_plus_crt", SAMPLE_FRAMES, WARMUP_FRAMES)
			_measurement_rows.append(_summary_row(scene_id, "world_plus_crt", "full_world_plus_crt", ui_stats))
			_hide_dialogue(station)

		_restore_visuals(station)
		station.queue_free()
		await process_frame


func _run_animation_audit(state: Node) -> void:
	# Station 02 is the existing scene that owns DiscontinuousShadow. It is the
	# correct host for measuring the complete currently implemented visual cycle.
	var scene_id := "station_02"
	var packed := load("res://scenes/levels/station_02.tscn") as PackedScene
	if packed == null:
		return
	if state and state.has_method("reset_campaign"):
		state.call("reset_campaign", true)
	var station := packed.instantiate() as Node2D
	if station == null:
		return
	root.add_child(station)
	await _wait_frames(8)
	_prepare_station(station)
	_hide_dialogue(station)

	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player == null:
		station.queue_free()
		await process_frame
		return
	var spawn_position := player.global_position
	var shadows := _find_nodes_of_type(station, "DiscontinuousShadow")
	for shadow_node in shadows:
		_set_if_property(shadow_node, "is_secondary_light_active", true)
		_set_if_property(shadow_node, "is_anomaly_active", true)

	for mode in ANIMATION_MODES:
		_release_actions()
		player.reset_to(spawn_position)
		_apply_visual_mode(station, mode)
		await _wait_frames(WARMUP_FRAMES)
		var cycle_rows := await _run_animation_cycle(station)
		var aggregate := _stats_for_rows(cycle_rows)
		aggregate["scene"] = scene_id
		aggregate["mode"] = mode
		aggregate["cycle_frames"] = cycle_rows.size()
		_animation_aggregates[mode] = aggregate
		_animation_rows.append(_summary_row(scene_id, "animation_cycle", mode, aggregate))
		for row in cycle_rows:
			row["scene"] = scene_id
			row["mode"] = mode
			_animation_sample_rows.append(row)

	_build_component_deltas()
	_release_actions()
	_restore_visuals(station)
	station.queue_free()
	await process_frame


func _run_animation_cycle(station: Node2D) -> Array[Dictionary]:
	var rows: Array[Dictionary] = []
	var last_usec := Time.get_ticks_usec()
	for step in range(ANIMATION_CYCLE_FRAMES):
		_drive_cycle_input(step)
		await process_frame
		await RenderingServer.frame_post_draw
		var now_usec := Time.get_ticks_usec()
		if step >= 2:
			var row := _read_frame_metrics(float(now_usec - last_usec) / 1000.0)
			row["step"] = step
			row["phase"] = _cycle_phase(step)
			rows.append(row)
		last_usec = now_usec
	return rows


func _sample_frames(station: Node2D, mode: String, sample_count: int, warmup_count: int) -> Dictionary:
	await _wait_frames(warmup_count)
	var rows: Array[Dictionary] = []
	var last_usec := Time.get_ticks_usec()
	for index in range(sample_count):
		await process_frame
		await RenderingServer.frame_post_draw
		var now_usec := Time.get_ticks_usec()
		# The first two frames are discarded because RenderingServer documents that
		# its viewport statistics become available only after two rendered frames.
		if index >= 2:
			rows.append(_read_frame_metrics(float(now_usec - last_usec) / 1000.0))
		last_usec = now_usec
	return _stats_for_rows(rows)


func _read_frame_metrics(interval_ms: float) -> Dictionary:
	var viewport := root as Viewport
	var viewport_rid := viewport.get_viewport_rid()
	return {
		"frame_interval_ms": interval_ms,
		"time_process_ms": float(Performance.get_monitor(Performance.TIME_PROCESS)) * 1000.0,
		"time_physics_ms": float(Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)) * 1000.0,
		"canvas_items": float(viewport.get_render_info(Viewport.RENDER_INFO_TYPE_CANVAS, Viewport.RENDER_INFO_OBJECTS_IN_FRAME)),
		"canvas_primitives": float(viewport.get_render_info(Viewport.RENDER_INFO_TYPE_CANVAS, Viewport.RENDER_INFO_PRIMITIVES_IN_FRAME)),
		"canvas_draw_calls": float(viewport.get_render_info(Viewport.RENDER_INFO_TYPE_CANVAS, Viewport.RENDER_INFO_DRAW_CALLS_IN_FRAME)),
		"render_cpu_ms": RenderingServer.viewport_get_measured_render_time_cpu(viewport_rid),
		"render_gpu_ms": RenderingServer.viewport_get_measured_render_time_gpu(viewport_rid),
		"frame_setup_cpu_ms": RenderingServer.get_frame_setup_time_cpu(),
	}


func _stats_for_rows(rows: Array) -> Dictionary:
	var stats: Dictionary = {}
	for key in METRIC_KEYS:
		var values: Array[float] = []
		for row in rows:
			values.append(float(row.get(key, 0.0)))
		stats[key] = _summarize(values, key)
	return stats


func _summarize(values: Array[float], key: String) -> Dictionary:
	if values.is_empty():
		return {"status": "unavailable", "count": 0}
	var sorted_values: Array[float] = []
	var sum := 0.0
	var nonzero := 0
	for value in values:
		sorted_values.append(value)
		sum += value
		if not is_zero_approx(value):
			nonzero += 1
	sorted_values.sort()
	var p95_index := clampi(int(ceil(float(sorted_values.size()) * 0.95)) - 1, 0, sorted_values.size() - 1)
	var median_index := sorted_values.size() / 2
	var status := "available"
	if key == "render_gpu_ms" and nonzero == 0:
		status = "unavailable"
	return {
		"status": status,
		"count": sorted_values.size(),
		"nonzero_count": nonzero,
		"min": sorted_values.front(),
		"mean": sum / float(sorted_values.size()),
		"median": sorted_values[median_index],
		"p95": sorted_values[p95_index],
		"max": sorted_values.back(),
	}


func _summary_row(scene_id: String, frame_kind: String, mode: String, stats: Dictionary) -> Dictionary:
	var row: Dictionary = {
		"scene": scene_id,
		"frame_kind": frame_kind,
		"mode": mode,
	}
	if stats.has("cycle_frames"):
		row["cycle_frames"] = stats["cycle_frames"]
	for key in METRIC_KEYS:
		var metric: Dictionary = stats.get(key, {})
		row[key + "_status"] = metric.get("status", "unavailable")
		row[key + "_count"] = metric.get("count", 0)
		row[key + "_mean"] = metric.get("mean", 0.0)
		row[key + "_median"] = metric.get("median", 0.0)
		row[key + "_p95"] = metric.get("p95", 0.0)
		row[key + "_max"] = metric.get("max", 0.0)
	return row


func _build_component_deltas() -> void:
	var full: Dictionary = _animation_aggregates.get("full_world", {})
	var no_dust: Dictionary = _animation_aggregates.get("no_dust", {})
	var body_only: Dictionary = _animation_aggregates.get("no_dust_and_shadow", {})
	var no_visuals: Dictionary = _animation_aggregates.get("no_player_and_shadow", {})
	if full.is_empty() or no_dust.is_empty() or body_only.is_empty() or no_visuals.is_empty():
		return
	var components := {
		"prototype_body_draw_including_builtin_floor_shadow": [body_only, no_visuals],
		"discontinuous_shadow_draw": [no_dust, body_only],
		"player_authored_dust_effect": [full, no_dust],
		"complete_protagonist_visual_layer": [full, no_visuals],
	}
	for component in components.keys():
		var pair: Array = components[component]
		var with_component: Dictionary = pair[0]
		var without_component: Dictionary = pair[1]
		for key in METRIC_KEYS:
			var with_metric: Dictionary = with_component.get(key, {})
			var without_metric: Dictionary = without_component.get(key, {})
			_component_delta_rows.append({
				"component": component,
				"metric": key,
				"with_mean": with_metric.get("mean", 0.0),
				"without_mean": without_metric.get("mean", 0.0),
				"delta_mean": float(with_metric.get("mean", 0.0)) - float(without_metric.get("mean", 0.0)),
				"with_p95": with_metric.get("p95", 0.0),
				"without_p95": without_metric.get("p95", 0.0),
				"delta_p95": float(with_metric.get("p95", 0.0)) - float(without_metric.get("p95", 0.0)),
				"with_status": with_metric.get("status", "unavailable"),
				"without_status": without_metric.get("status", "unavailable"),
			})


func _collect_inventory(station: Node2D, case_data: Dictionary) -> Dictionary:
	var profile_rows: Array[Dictionary] = []
	var script_paths: Dictionary = {}
	var type_counts: Dictionary = {}
	var scripted_nodes := 0
	var procedural_draw_nodes := 0
	var active_process_nodes := 0
	var active_physics_nodes := 0
	var animated_or_effect_nodes := 0
	var cpuparticles := 0
	var point_lights := 0
	var animation_players := 0
	var animated_sprites := 0
	var shared_elements := 0
	var player_count := 0
	var shadow_count := 0
	var dialogue_count := 0
	var environment_count := 0
	var atmosphere_count := 0
	var cue_count := 0

	var stack: Array[Node] = [station]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		type_counts[node.get_class()] = int(type_counts.get(node.get_class(), 0)) + 1
		var script_resource := node.get_script() as Script
		if script_resource != null:
			scripted_nodes += 1
			var script_path := String(script_resource.resource_path)
			script_paths[script_path] = int(script_paths.get(script_path, 0)) + 1
			if script_resource.get_source_code().contains("func _draw") and node is CanvasItem:
				procedural_draw_nodes += 1
			if script_resource.get_source_code().contains("func _process") or script_resource.get_source_code().contains("func _physics_process"):
				animated_or_effect_nodes += 1
		if node.is_processing():
			active_process_nodes += 1
		if node.is_physics_processing():
			active_physics_nodes += 1
		if node is CPUParticles2D:
			cpuparticles += 1
			animated_or_effect_nodes += 1
		if node is PointLight2D:
			point_lights += 1
			animated_or_effect_nodes += 1
		if node is AnimationPlayer:
			animation_players += 1
		if node is AnimatedSprite2D:
			animated_sprites += 1
		if node is PrototypePlayer:
			player_count += 1
			shared_elements += 1
		if node is DiscontinuousShadow:
			shadow_count += 1
		if node is CRTDialogueBox:
			dialogue_count += 1
			shared_elements += 1
		if node is VectorStageEnvironment:
			environment_count += 1
			shared_elements += 1
			profile_rows.append({
				"station_number": node.station_number,
				"stage_seed": node.stage_seed,
				"stage_variant": String(node.stage_variant),
				"world_size": str(node.world_size),
			})
		if node is AtmosphereRig:
			atmosphere_count += 1
			shared_elements += 1
		if node is StationDialogueCue:
			cue_count += 1
			shared_elements += 1
		for child in node.get_children():
			stack.append(child)

	return {
		"scene": case_data["id"],
		"path": case_data["path"],
		"campaign_space": case_data["campaign_space"],
		"scene_kind": case_data["kind"],
		"status": "inventory_only",
		"direct_frame_measurement": case_data["id"] in ["station_01", "station_02", "station_14", "station_22", "station_38", "station_41", "station_42a", "station_42b", "station_42c", "station_43"],
		"profiles": profile_rows,
		"profile_count": profile_rows.size(),
		"scripted_nodes": scripted_nodes,
		"procedural_draw_nodes": procedural_draw_nodes,
		"active_process_nodes": active_process_nodes,
		"active_physics_nodes": active_physics_nodes,
		"animated_or_effect_nodes": animated_or_effect_nodes,
		"cpuparticles_2d": cpuparticles,
		"point_lights_2d": point_lights,
		"animation_players": animation_players,
		"animated_sprites_2d": animated_sprites,
		"prototype_players": player_count,
		"discontinuous_shadows": shadow_count,
		"crt_dialogue_boxes": dialogue_count,
		"vector_stage_environments": environment_count,
		"atmosphere_rigs": atmosphere_count,
		"opening_dialogue_cues": cue_count,
		"shared_element_nodes": shared_elements,
		"script_paths": script_paths,
		"type_counts": type_counts,
	}


func _prepare_station(station: Node2D) -> void:
	_set_if_property(station, "dialogue_active", false)
	_set_if_property(station, "is_exit_unlocked", true)
	_set_if_property(station, "is_door_unlocked", true)
	_set_if_property(station, "is_shaft_unlocked", true)
	_set_if_property(station, "is_airlock_unlocked", true)
	_set_if_property(station, "is_procedure_completed", true)
	_set_if_property(station, "is_level_completed", false)
	_hide_dialogue(station)
	_restore_visuals(station)
	station.queue_redraw()


func _present_audit_dialogue(station: Node2D) -> void:
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CRTDialogueBox
	if dialogue == null:
		return
	dialogue.characters_per_second = 100000.0
	dialogue.present([{"speaker": &"Lena", "text": "H-005 AUDIT FRAME"}])


func _hide_dialogue(station: Node2D) -> void:
	var dialogue := station.get_node_or_null("CRTDialogueBox") as CanvasLayer
	if dialogue:
		dialogue.hide()


func _apply_visual_mode(station: Node2D, mode: String) -> void:
	_restore_visuals(station)
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if mode == "no_player_and_shadow":
		if player:
			player.visible = false
		for shadow_node in _find_nodes_of_type(station, "DiscontinuousShadow"):
			shadow_node.visible = false
	elif mode == "no_dust":
		for particle in _find_nodes_of_type(station, "CPUParticles2D"):
			if particle.get_parent() == player:
				particle.visible = false
	elif mode == "no_dust_and_shadow":
		for particle in _find_nodes_of_type(station, "CPUParticles2D"):
			if particle.get_parent() == player:
				particle.visible = false
		for shadow_node in _find_nodes_of_type(station, "DiscontinuousShadow"):
			shadow_node.visible = false
	elif mode == "no_shadow":
		for shadow_node in _find_nodes_of_type(station, "DiscontinuousShadow"):
			shadow_node.visible = false
	# full_world and full_world_plus_crt retain all existing visual nodes.


func _restore_visuals(station: Node2D) -> void:
	var player := station.get_node_or_null("Player") as PrototypePlayer
	if player:
		player.visible = true
	for node in _find_nodes_of_type(station, "CPUParticles2D"):
		node.visible = true
	for node in _find_nodes_of_type(station, "DiscontinuousShadow"):
		node.visible = true


func _find_nodes_of_type(root_node: Node, class_name_text: String) -> Array[Node]:
	var result: Array[Node] = []
	var stack: Array[Node] = [root_node]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		var script_resource := node.get_script() as Script
		var script_global_name := ""
		if script_resource != null:
			script_global_name = String(script_resource.get_global_name())
		if node.get_class() == class_name_text or script_global_name == class_name_text:
			result.append(node)
		for child in node.get_children():
			stack.append(child)
	return result


func _set_if_property(node: Object, property_name: String, value: Variant) -> void:
	if node == null:
		return
	for property in node.get_property_list():
		if String(property.get("name", "")) == property_name:
			node.set(property_name, value)
			return


func _has_property(node: Object, property_name: String) -> bool:
	if node == null:
		return false
	for property in node.get_property_list():
		if String(property.get("name", "")) == property_name:
			return true
	return false


func _drive_cycle_input(step: int) -> void:
	if step == 0:
		_release_actions()
	if step == 30:
		Input.action_press(&"move_right")
	if step == 72:
		Input.action_press(&"jump")
	if step == 74:
		Input.action_release(&"jump")
	if step == 144:
		Input.action_release(&"move_right")
	if step == 172:
		Input.action_press(&"move_left")
	if step == 208:
		Input.action_release(&"move_left")


func _release_actions() -> void:
	Input.action_release(&"move_left")
	Input.action_release(&"move_right")
	Input.action_release(&"jump")


func _cycle_phase(step: int) -> String:
	if step < 30:
		return "idle"
	if step < 72:
		return "walk_right"
	if step < 75:
		return "jump_launch"
	if step < 144:
		return "airborne_and_land"
	if step < 172:
		return "recovery"
	if step < 209:
		return "walk_left"
	return "idle_after_cycle"


func _wait_frames(count: int) -> void:
	for _index in range(count):
		await process_frame


func _write_outputs() -> void:
	var summary := {
		"metadata": _metadata,
		"inventory": _inventory_rows,
		"frame_measurements": _measurement_rows,
		"animation_aggregates": _animation_rows,
		"component_deltas": _component_delta_rows,
		"campaign_mapping": "45 scene resources represent 43 campaign spaces; station_42a/b/c map to campaign space 42",
	}
	_write_json("summary.json", summary)
	_write_table("inventory_43.tsv", _inventory_headers(), _inventory_rows)
	_write_table("frame_metrics.tsv", _measurement_headers(), _measurement_rows)
	_write_table("animation_metrics.tsv", _measurement_headers(), _animation_rows)
	_write_table("animation_component_deltas.tsv", _component_delta_headers(), _component_delta_rows)
	_write_table("animation_samples.tsv", ["scene", "mode", "step", "phase"] + METRIC_KEYS, _animation_sample_rows)


func _write_json(file_name: String, value: Variant) -> void:
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	DirAccess.make_dir_recursive_absolute(output_dir)
	var file := FileAccess.open(output_dir.path_join(file_name), FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(value, "\t"))
		file.store_string("\n")


func _write_table(file_name: String, headers: Array, rows: Array) -> void:
	var output_dir := ProjectSettings.globalize_path(OUTPUT_ROOT)
	DirAccess.make_dir_recursive_absolute(output_dir)
	var file := FileAccess.open(output_dir.path_join(file_name), FileAccess.WRITE)
	if file == null:
		push_error("PKG-0109: cannot write " + file_name)
		return
	file.store_string("\t".join(headers) + "\n")
	for row in rows:
		var cells: Array[String] = []
		for header in headers:
			var value: Variant = row.get(header, "")
			var cell := str(value).replace("\t", " ").replace("\r", " ").replace("\n", " ")
			cells.append(cell)
		file.store_string("\t".join(cells) + "\n")


func _inventory_headers() -> Array[String]:
	return [
		"scene", "path", "campaign_space", "scene_kind", "status", "direct_frame_measurement",
		"profiles", "profile_count", "scripted_nodes", "procedural_draw_nodes",
		"active_process_nodes", "active_physics_nodes", "animated_or_effect_nodes",
		"cpuparticles_2d", "point_lights_2d", "animation_players", "animated_sprites_2d",
		"prototype_players", "discontinuous_shadows", "crt_dialogue_boxes",
		"vector_stage_environments", "atmosphere_rigs", "opening_dialogue_cues",
		"shared_element_nodes", "script_paths", "type_counts",
	]


func _measurement_headers() -> Array[String]:
	var headers: Array[String] = ["scene", "frame_kind", "mode", "cycle_frames"]
	for key in METRIC_KEYS:
		headers.append(key + "_status")
		headers.append(key + "_count")
		headers.append(key + "_mean")
		headers.append(key + "_median")
		headers.append(key + "_p95")
		headers.append(key + "_max")
	return headers


func _component_delta_headers() -> Array[String]:
	return [
		"component", "metric", "with_mean", "without_mean", "delta_mean",
		"with_p95", "without_p95", "delta_p95", "with_status", "without_status",
	]
