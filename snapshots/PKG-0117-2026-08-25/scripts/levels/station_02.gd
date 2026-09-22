class_name Station02
extends Node2D

const NarrativeGuidanceService := preload("res://scripts/core/narrative_guidance_service.gd")
const GuidanceBeat := preload("res://scripts/core/guidance_beat.gd")

## Station 02 (Przestrzeń 02: Korelacja) for Getting Strange Vertical Slice.
## Represents the IKP Correlation Measurement Chamber (Komora Pomiarowa).
## Symmetrical correlation frame, twin optical light points, correlation anomaly,
## observed shadow motion discontinuity, and strip chart printer with 'WYNIK ZGODNY'.
## Follows VISUAL_DESIGN.md and FULL_STORY.md (Scene 02).

enum ProcedureState {
	IDLE,
	CALIBRATION,
	EXCITATION,
	THRESHOLD_EXCEEDED,
	ANOMALY_ACTIVE,
	PRINTED_VERDICT,
	ABORTED_BY_LENA,
	COMPLETED,
}

const VIEW_SIZE := Vector2(640.0, 360.0)

const COLOR_BACKGROUND := VectorStageStyle.BACKDROP
const COLOR_INFRASTRUCTURE := VectorStageStyle.LIGHT_PLANE
const COLOR_AMBER := VectorStageStyle.HUMAN_AMBER
const COLOR_CYAN := VectorStageStyle.ANCHOR_CYAN
const COLOR_CORRECTION := VectorStageStyle.CORRECTION_OXIDE
const COLOR_DARK_STEEL := VectorStageStyle.MID_PLANE
const COLOR_FLOOR := VectorStageStyle.DEEP_PLANE
const COLOR_FLOOR_EDGE := VectorStageStyle.LIGHT_PLANE

signal correlation_procedure_started()
signal threshold_exceeded(ratio: float)
signal anomaly_observed()
signal verdict_printed(text: String)
signal measurement_aborted()
signal chamber_unlocked()
signal level_completed()

@onready var player: PrototypePlayer = $Player
@onready var camera: CinematicCamera = $Camera
@onready var geometry: Node2D = $Geometry
@onready var props: Node2D = $Props
@onready var chamber_door: AnimatableBody2D = $ChamberDoor
@onready var airlock_zone: Area2D = $AirlockZone
@onready var shadow_renderer: DiscontinuousShadow = $DiscontinuousShadow

var procedure_state: ProcedureState = ProcedureState.IDLE
var correlation_ratio: float = 0.0
var target_correlation_ratio: float = 0.0

var is_optical_calibrated: bool = false
var is_threshold_exceeded: bool = false
var is_anomaly_active: bool = false
var is_verdict_printed: bool = false
var is_aborted_by_lena: bool = false
var is_door_unlocked: bool = false
var is_level_completed: bool = false

var paper_feed_progress: float = 0.0
var _door_open_progress: float = 0.0
var _door_tween: Tween
var _pulse_time: float = 0.0
var _procedure_timer: float = 0.0

var _light_1_pos := Vector2(320.0, 140.0)
var _light_2_pos := Vector2(440.0, 140.0)
var _light_1_intensity: float = 0.0
var _light_2_intensity: float = 0.0

var _vacuum_hum_player: AudioStreamPlayer
var _correlation_hum_player: AudioStreamPlayer
var _printer_audio_player: AudioStreamPlayer
var _needle_audio_player: AudioStreamPlayer
var _door_audio_player: AudioStreamPlayer

var _vacuum_hum_sfx: AudioStreamWAV
var _correlation_hum_sfx: AudioStreamWAV
var _printer_strip_sfx: AudioStreamWAV
var _needle_spike_sfx: AudioStreamWAV
var _door_seal_sfx: AudioStreamWAV


func _ready() -> void:
	_setup_camera()
	_setup_shadow()
	_setup_audio()
	_setup_guidance()
	_connect_props()
	
	if airlock_zone:
		airlock_zone.body_entered.connect(_on_airlock_body_entered)
	
	queue_redraw()


func _setup_guidance() -> void:
	var guidance := get_node_or_null("NarrativeGuidanceService") as NarrativeGuidanceService
	if guidance:
		var beat := GuidanceBeat.new()
		beat.beat_id = &"s02_catwalk_observation"
		beat.scene_id = &"station_02"
		beat.tier = GuidanceBeat.Tier.L2_CONTEXTUAL_THOUGHT
		beat.thought_kind = &"observation"
		beat.text_pl = "Ścieżka serwisowa jest wolna. Wyjście za komorą."
		beat.text_en = "Service walkway is clear. Exit behind the chamber."
		beat.cooldown_s = 8.0
		guidance.register_beat(beat)


func _setup_camera() -> void:
	if not is_instance_valid(camera):
		camera = CinematicCamera.new()
		camera.name = "Camera"
		add_child(camera)
	
	camera.target = player
	var bounds: Array[Rect2] = [Rect2(Vector2.ZERO, VIEW_SIZE)]
	camera.setup_chambers(bounds)


func _setup_shadow() -> void:
	if not is_instance_valid(shadow_renderer):
		shadow_renderer = DiscontinuousShadow.new()
		shadow_renderer.name = "DiscontinuousShadow"
		add_child(shadow_renderer)
	
	shadow_renderer.target_player = player
	shadow_renderer.light_source_a = _light_1_pos
	shadow_renderer.light_source_b = _light_2_pos
	shadow_renderer.floor_y = 296.0
	shadow_renderer.is_secondary_light_active = false
	shadow_renderer.is_anomaly_active = false


func _setup_audio() -> void:
	_vacuum_hum_sfx = ProceduralAudio.create_vacuum_hum_sound()
	_correlation_hum_sfx = ProceduralAudio.create_correlation_hum_sound()
	_printer_strip_sfx = ProceduralAudio.create_printer_strip_sound()
	_needle_spike_sfx = ProceduralAudio.create_needle_spike_sound()
	_door_seal_sfx = ProceduralAudio.create_airlock_seal_sound()
	
	_vacuum_hum_player = AudioStreamPlayer.new()
	_vacuum_hum_player.name = "VacuumHumPlayer"
	_vacuum_hum_player.stream = _vacuum_hum_sfx
	_vacuum_hum_player.volume_db = -12.0
	_vacuum_hum_player.bus = &"Master"
	add_child(_vacuum_hum_player)
	_vacuum_hum_player.play()
	
	_correlation_hum_player = AudioStreamPlayer.new()
	_correlation_hum_player.name = "CorrelationHumPlayer"
	_correlation_hum_player.stream = _correlation_hum_sfx
	_correlation_hum_player.volume_db = -80.0
	_correlation_hum_player.bus = &"Master"
	add_child(_correlation_hum_player)
	_correlation_hum_player.play()
	
	_printer_audio_player = AudioStreamPlayer.new()
	_printer_audio_player.name = "PrinterAudioPlayer"
	_printer_audio_player.stream = _printer_strip_sfx
	_printer_audio_player.volume_db = -4.0
	_printer_audio_player.bus = &"Master"
	add_child(_printer_audio_player)
	
	_needle_audio_player = AudioStreamPlayer.new()
	_needle_audio_player.name = "NeedleAudioPlayer"
	_needle_audio_player.stream = _needle_spike_sfx
	_needle_audio_player.volume_db = -2.0
	_needle_audio_player.bus = &"Master"
	add_child(_needle_audio_player)
	
	_door_audio_player = AudioStreamPlayer.new()
	_door_audio_player.name = "DoorAudioPlayer"
	_door_audio_player.volume_db = -4.0
	_door_audio_player.bus = &"Master"
	add_child(_door_audio_player)


func _connect_props() -> void:
	if props == null:
		return
	
	for child in props.get_children():
		if child is MemoryResonancePoint:
			var prop := child as MemoryResonancePoint
			prop.resonance_triggered.connect(_on_prop_resonance_triggered.bind(prop))
			prop.state_changed.connect(_on_prop_state_changed.bind(prop))


func _process(delta: float) -> void:
	_pulse_time += delta * 2.5
	
	# Smoothly interpolate correlation ratio and light intensities
	correlation_ratio = move_toward(correlation_ratio, target_correlation_ratio, delta * 0.8)
	
	# Update light intensities based on procedure state
	match procedure_state:
		ProcedureState.IDLE:
			_light_1_intensity = move_toward(_light_1_intensity, 0.15, delta * 2.0)
			_light_2_intensity = move_toward(_light_2_intensity, 0.0, delta * 2.0)
			if _correlation_hum_player:
				_correlation_hum_player.volume_db = move_toward(_correlation_hum_player.volume_db, -80.0, delta * 40.0)
		
		ProcedureState.CALIBRATION, ProcedureState.EXCITATION:
			_light_1_intensity = move_toward(_light_1_intensity, 0.85, delta * 2.0)
			_light_2_intensity = move_toward(_light_2_intensity, 0.05, delta * 2.0)
			if _correlation_hum_player:
				_correlation_hum_player.volume_db = move_toward(_correlation_hum_player.volume_db, -10.0, delta * 30.0)
			
			_procedure_timer += delta
			if _procedure_timer >= 1.2 and procedure_state == ProcedureState.EXCITATION:
				_trigger_threshold_exceeded()
		
		ProcedureState.THRESHOLD_EXCEEDED, ProcedureState.ANOMALY_ACTIVE, ProcedureState.PRINTED_VERDICT:
			# Both lights fully illuminated and correlated
			_light_1_intensity = move_toward(_light_1_intensity, 1.0, delta * 3.0)
			_light_2_intensity = move_toward(_light_2_intensity, 1.0, delta * 3.0)
			if _correlation_hum_player:
				_correlation_hum_player.volume_db = move_toward(_correlation_hum_player.volume_db, -6.0, delta * 20.0)
			
			_procedure_timer += delta
			if procedure_state == ProcedureState.THRESHOLD_EXCEEDED and _procedure_timer >= 0.8:
				_trigger_anomaly_active()
			elif procedure_state == ProcedureState.ANOMALY_ACTIVE and _procedure_timer >= 1.4:
				_trigger_verdict_printed()
			elif procedure_state == ProcedureState.PRINTED_VERDICT and _procedure_timer >= 2.5:
				_auto_abort_or_ready()
		
		ProcedureState.ABORTED_BY_LENA, ProcedureState.COMPLETED:
			# Stabilized consensus state
			_light_1_intensity = move_toward(_light_1_intensity, 0.5, delta * 1.5)
			_light_2_intensity = move_toward(_light_2_intensity, 0.5, delta * 1.5)
			if _correlation_hum_player:
				_correlation_hum_player.volume_db = move_toward(_correlation_hum_player.volume_db, -24.0, delta * 25.0)
	
	if shadow_renderer:
		shadow_renderer.is_secondary_light_active = (_light_2_intensity > 0.3)
		shadow_renderer.is_anomaly_active = is_anomaly_active
	
	queue_redraw()


func _on_prop_resonance_triggered(id: String, prop_type: int, prop: MemoryResonancePoint) -> void:
	match id:
		"optical_calibration":
			is_optical_calibrated = prop.is_activated
			if is_optical_calibrated and procedure_state == ProcedureState.IDLE:
				start_correlation_procedure()
		
		"correlation_console":
			if procedure_state == ProcedureState.IDLE:
				start_correlation_procedure()
			elif procedure_state in [ProcedureState.THRESHOLD_EXCEEDED, ProcedureState.ANOMALY_ACTIVE, ProcedureState.PRINTED_VERDICT]:
				abort_procedure()
		
		"strip_printer":
			if is_verdict_printed and not is_aborted_by_lena:
				abort_procedure()


func _on_prop_state_changed(is_active: bool, prop: MemoryResonancePoint) -> void:
	if prop.resonance_id == "optical_calibration":
		is_optical_calibrated = is_active


func start_correlation_procedure() -> void:
	if procedure_state != ProcedureState.IDLE:
		return
	
	procedure_state = ProcedureState.EXCITATION
	_procedure_timer = 0.0
	target_correlation_ratio = 0.95
	correlation_procedure_started.emit()
	
	var console := props.get_node_or_null("CorrelationConsole") as MemoryResonancePoint
	if console:
		console.is_activated = true
	var calib := props.get_node_or_null("OpticalCalibration") as MemoryResonancePoint
	if calib:
		calib.is_activated = true
		is_optical_calibrated = true


func _trigger_threshold_exceeded() -> void:
	procedure_state = ProcedureState.THRESHOLD_EXCEEDED
	_procedure_timer = 0.0
	target_correlation_ratio = 1.42 # Exceeds expected 1.0 threshold!
	is_threshold_exceeded = true
	
	if _needle_audio_player and _needle_spike_sfx:
		_needle_audio_player.play()
	
	if camera:
		camera.add_trauma(0.28)
	
	threshold_exceeded.emit(1.42)


func _trigger_anomaly_active() -> void:
	procedure_state = ProcedureState.ANOMALY_ACTIVE
	_procedure_timer = 0.0
	is_anomaly_active = true
	
	anomaly_observed.emit()


func _trigger_verdict_printed() -> void:
	procedure_state = ProcedureState.PRINTED_VERDICT
	_procedure_timer = 0.0
	is_verdict_printed = true
	
	# Animate paper feed strip
	var tw := create_tween()
	tw.tween_property(self, "paper_feed_progress", 1.0, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if _printer_audio_player and _printer_strip_sfx:
		_printer_audio_player.play()
	
	var printer_prop := props.get_node_or_null("StripPrinter") as MemoryResonancePoint
	if printer_prop:
		printer_prop.is_activated = true
	
	verdict_printed.emit("WYNIK ZGODNY")


func _auto_abort_or_ready() -> void:
	# Protocol safety procedure: Lena aborts measurement per FULL_STORY 02
	abort_procedure()


func abort_procedure() -> void:
	if procedure_state == ProcedureState.ABORTED_BY_LENA or procedure_state == ProcedureState.COMPLETED:
		return
	
	procedure_state = ProcedureState.ABORTED_BY_LENA
	is_aborted_by_lena = true
	is_anomaly_active = false
	target_correlation_ratio = 1.00 # Locked consensus ratio
	
	measurement_aborted.emit()
	_unlock_exit_door()


func _unlock_exit_door() -> void:
	if is_door_unlocked:
		return
	is_door_unlocked = true
	
	chamber_unlocked.emit()
	if _door_audio_player and _door_seal_sfx:
		_door_audio_player.stream = _door_seal_sfx
		_door_audio_player.play()
	
	if camera:
		camera.add_trauma(0.30)
	
	_door_tween = create_tween()
	_door_tween.tween_property(self, "_door_open_progress", 1.0, 1.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if chamber_door:
		var target_y := chamber_door.position.y - 70.0
		_door_tween.parallel().tween_property(chamber_door, "position:y", target_y, 1.2)


func _on_airlock_body_entered(body: Node2D) -> void:
	if (body is PrototypePlayer or body.name == "Player") and is_door_unlocked:
		if not is_level_completed:
			is_level_completed = true
			level_completed.emit()


func _draw() -> void:
	_draw_state_layer()


func _draw_state_layer() -> void:
	VectorStageStyle.draw_play_plane(self, geometry)
	var procedure_col := VectorStageStyle.MID_PLANE
	if is_anomaly_active:
		procedure_col = VectorStageStyle.CORRECTION_OXIDE
	elif is_optical_calibrated:
		procedure_col = VectorStageStyle.ANCHOR_CYAN
	var ratio := clampf(correlation_ratio, 0.0, 1.0)
	draw_rect(Rect2(288.0, 226.0, 126.0, 5.0), VectorStageStyle.INK)
	draw_rect(Rect2(288.0, 226.0, 126.0 * ratio, 5.0), procedure_col)
	draw_line(Vector2(316.0, 102.0), Vector2(316.0, 214.0), procedure_col, 2.0)
	draw_line(Vector2(446.0, 108.0), Vector2(446.0, 214.0), procedure_col, 2.0)
	var door_col := VectorStageStyle.ANCHOR_CYAN if is_door_unlocked else VectorStageStyle.CORRECTION_OXIDE
	draw_line(Vector2(566.0, 174.0), Vector2(566.0, 252.0), door_col, 3.0)


func _draw_architecture() -> void:
	# Floor slab (y = 296..360)
	draw_rect(Rect2(0.0, 296.0, 640.0, 64.0), COLOR_FLOOR)
	draw_rect(Rect2(0.0, 296.0, 640.0, 3.0), COLOR_FLOOR_EDGE)
	
	# Modernist grid seam lines
	for i in range(1, 8):
		var x := float(i) * 80.0
		draw_line(Vector2(x, 36.0), Vector2(x, 296.0), Color(0.12, 0.18, 0.22, 0.45), 1.0)
	
	# Cable raceways & dado rails
	draw_rect(Rect2(0.0, 208.0, 640.0, 4.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(0.0, 108.0, 640.0, 3.0), COLOR_DARK_STEEL * 0.8)
	
	# Ceiling beam
	draw_rect(Rect2(0.0, 0.0, 640.0, 36.0), Color("121a20"))
	draw_line(Vector2(0.0, 36.0), Vector2(640.0, 36.0), COLOR_INFRASTRUCTURE * 0.4, 2.0)
	
	# Operator console bench on left (x = 85..215, y = 268..296)
	var bench_rect := Rect2(85.0, 268.0, 130.0, 28.0)
	draw_rect(bench_rect, COLOR_DARK_STEEL)
	draw_rect(bench_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	draw_rect(Rect2(83.0, 266.0, 134.0, 3.0), Color("344752"))


func _draw_correlation_chamber() -> void:
	# Symmetrical Correlation Containment Chamber (x = 230..530, y = 60..296)
	var chamber_rect := Rect2(230.0, 60.0, 300.0, 236.0)
	
	# Outer steel structural pillars
	draw_rect(Rect2(224.0, 56.0, 12.0, 240.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(224.0, 56.0, 12.0, 240.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	draw_rect(Rect2(524.0, 56.0, 12.0, 240.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(524.0, 56.0, 12.0, 240.0), COLOR_INFRASTRUCTURE * 0.5, false, 1.0)
	
	# Top and bottom containment bulkheads
	draw_rect(Rect2(224.0, 56.0, 312.0, 16.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(224.0, 288.0, 312.0, 8.0), COLOR_DARK_STEEL)
	
	# Inner void background (deep dark vacuum)
	draw_rect(Rect2(236.0, 72.0, 288.0, 216.0), Color("0b1216"))
	
	# Symmetrical correlation sensor grid
	for gx in range(5):
		var x := 260.0 + float(gx) * 60.0
		draw_line(Vector2(x, 74.0), Vector2(x, 286.0), Color(0.15, 0.28, 0.32, 0.20), 1.0)
	for gy in range(4):
		var y := 100.0 + float(gy) * 45.0
		draw_line(Vector2(238.0, y), Vector2(522.0, y), Color(0.15, 0.28, 0.32, 0.20), 1.0)
	
	# Symmetrical Central Measurement Core (x = 380, y = 180)
	var core_pos := Vector2(380.0, 180.0)
	draw_circle(core_pos, 16.0, Color("142229"))
	draw_circle(core_pos, 16.0, COLOR_INFRASTRUCTURE * 0.6, false, 1.5)
	var core_pulse := sin(_pulse_time * 3.0) * 0.5 + 0.5
	var core_glow := COLOR_CYAN * (_light_1_intensity * 0.6 + _light_2_intensity * 0.4)
	draw_circle(core_pos, 6.0 + core_pulse * 2.0, Color(core_glow.r, core_glow.g, core_glow.b, 0.4))
	draw_circle(core_pos, 3.0, core_glow)
	
	# Optical Axis Rails (y = 140)
	draw_line(Vector2(250.0, 140.0), Vector2(510.0, 140.0), COLOR_DARK_STEEL * 1.5, 2.0)
	
	# ── Twin Symmetrical Light Points (L1 at 320, L2 at 440) ──
	# Emitter 1 (L1 - Left / Primary)
	_draw_optical_emitter(_light_1_pos, _light_1_intensity, "L1")
	
	# Emitter 2 (L2 - Right / Secondary Reference)
	_draw_optical_emitter(_light_2_pos, _light_2_intensity, "L2")
	
	# Laser / Optical Correlation Axis Beam between L1, Core, and L2
	if _light_1_intensity > 0.2:
		var beam_alpha_1 := _light_1_intensity * 0.65
		draw_line(_light_1_pos, core_pos, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, beam_alpha_1), 1.5)
	
	if _light_2_intensity > 0.2:
		var beam_alpha_2 := _light_2_intensity * 0.65
		draw_line(_light_2_pos, core_pos, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, beam_alpha_2), 1.5)
		# Horizontal direct lock beam between L1 and L2
		draw_line(_light_1_pos, _light_2_pos, Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, minf(_light_1_intensity, _light_2_intensity) * 0.5), 1.0)
	
	# Leaded glass inspection sheen
	draw_line(Vector2(240.0, 80.0), Vector2(340.0, 280.0), Color(1.0, 1.0, 1.0, 0.05), 3.0)
	draw_line(Vector2(420.0, 80.0), Vector2(520.0, 280.0), Color(1.0, 1.0, 1.0, 0.04), 3.0)


func _draw_optical_emitter(pos: Vector2, intensity: float, label: String) -> void:
	# Emitter mechanical housing
	draw_rect(Rect2(pos.x - 8.0, pos.y - 12.0, 16.0, 10.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(pos.x - 8.0, pos.y - 12.0, 16.0, 10.0), COLOR_INFRASTRUCTURE * 0.6, false, 1.0)
	
	# Collimator lens
	draw_circle(pos, 4.0, Color("1a2930"))
	draw_circle(pos, 4.0, COLOR_INFRASTRUCTURE * 0.8, false, 1.0)
	
	if intensity > 0.05:
		var p := sin(_pulse_time * 4.0) * 0.2 + 0.8
		var col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, intensity * p)
		# Outer optical flare
		draw_circle(pos, 10.0 * intensity, Color(col.r, col.g, col.b, 0.25 * intensity))
		# Core point of light
		draw_circle(pos, 3.5 * intensity, col)
		draw_circle(pos, 1.5, Color.WHITE)
		
		# Downward illumination cone to floor
		var cone_pts := PackedVector2Array([
			pos,
			Vector2(pos.x - 45.0 * intensity, 296.0),
			Vector2(pos.x + 45.0 * intensity, 296.0),
		])
		draw_polygon(cone_pts, [Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.035 * intensity)])


func _draw_telemetry_and_printer() -> void:
	# Wall Telemetry Screen above console (x = 90..210, y = 125..195)
	var screen_rect := Rect2(90.0, 125.0, 120.0, 70.0)
	draw_rect(screen_rect, Color("0f161b"))
	draw_rect(screen_rect, COLOR_DARK_STEEL, false, 1.5)
	
	# Header banner: IKP KORELACJA PROZNIOWA
	draw_rect(Rect2(92.0, 127.0, 116.0, 11.0), Color("17232a"))
	draw_line(Vector2(95.0, 133.0), Vector2(165.0, 133.0), COLOR_INFRASTRUCTURE * 0.85, 1.5)
	draw_line(Vector2(175.0, 133.0), Vector2(204.0, 133.0), COLOR_CYAN * 0.9, 1.5)
	
	# Correlation Index readout: ETA = X.XX
	# Threshold mark at ratio = 1.0
	draw_line(Vector2(98.0, 160.0), Vector2(200.0, 160.0), Color("384752"), 1.0)
	draw_line(Vector2(160.0, 154.0), Vector2(160.0, 166.0), COLOR_CORRECTION * 0.8, 1.5) # Threshold limit line
	
	# Progress bar of correlation ratio (0.0 .. 1.42)
	var bar_width := clampf((correlation_ratio / 1.5) * 102.0, 0.0, 102.0)
	var bar_col := COLOR_CORRECTION if correlation_ratio > 1.0 else COLOR_CYAN
	draw_rect(Rect2(98.0, 157.0, bar_width, 6.0), bar_col)
	
	# Readout graph lines
	var p_col := COLOR_CYAN if not is_threshold_exceeded else COLOR_CORRECTION
	draw_line(Vector2(98.0, 178.0), Vector2(130.0, 178.0), p_col, 1.5)
	draw_line(Vector2(130.0, 178.0), Vector2(155.0, 170.0 if correlation_ratio > 0.5 else 178.0), p_col, 1.5)
	draw_line(Vector2(155.0, 170.0 if correlation_ratio > 0.5 else 178.0), Vector2(200.0, 165.0 if is_threshold_exceeded else 178.0), p_col, 1.5)
	
	# ── Strip Chart Recorder / Printer (x = 100..130, y = 240..280) ──
	var printer_rect := Rect2(100.0, 246.0, 32.0, 22.0)
	draw_rect(printer_rect, COLOR_DARK_STEEL)
	draw_rect(printer_rect, COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	# Paper slot
	draw_rect(Rect2(104.0, 265.0, 24.0, 2.0), Color("0d1317"))
	
	# Paper strip feeding out of recorder
	if paper_feed_progress > 0.01:
		var paper_len := paper_feed_progress * 24.0
		var paper_rect := Rect2(106.0, 267.0, 20.0, paper_len)
		draw_rect(paper_rect, Color("dfd9c7")) # Sage / institutional newsprint paper
		draw_rect(paper_rect, Color("9a9688"), false, 0.8)
		
		# Printed institutional text on paper strip: "WYNIK ZGODNY"
		# Represented with sharp clinical dark ink lines
		if paper_feed_progress >= 0.4:
			draw_line(Vector2(108.0, 272.0), Vector2(124.0, 272.0), Color("1a2228"), 1.2) # "WYNIK ZGODNY"
		if paper_feed_progress >= 0.7:
			draw_line(Vector2(108.0, 276.0), Vector2(120.0, 276.0), Color("3a454d"), 1.0) # "ETA=1.42 // IKP"
		if paper_feed_progress >= 0.95:
			draw_line(Vector2(108.0, 280.0), Vector2(116.0, 280.0), Color("3a454d"), 1.0) # "21:44:30"


func _draw_lighting_fixtures() -> void:
	# Symmetrical ceiling lighting fixtures
	var fixture_x := [100.0, 280.0, 480.0, 560.0]
	for fx in fixture_x:
		draw_rect(Rect2(fx - 20.0, 34.0, 40.0, 4.0), COLOR_INFRASTRUCTURE)
		draw_rect(Rect2(fx - 16.0, 36.0, 32.0, 3.0), Color("d8dec5"))
		var pts := PackedVector2Array([
			Vector2(fx - 16.0, 39.0),
			Vector2(fx + 16.0, 39.0),
			Vector2(fx + 55.0, 296.0),
			Vector2(fx - 55.0, 296.0),
		])
		draw_polygon(pts, [Color(0.85, 0.88, 0.80, 0.022)])


func _draw_airlock_frame() -> void:
	# Heavy Exit Airlock Frame (x = 550..620, y = 180..296)
	var frame_rect := Rect2(550.0, 180.0, 70.0, 116.0)
	draw_rect(frame_rect, Color("141c22"))
	draw_rect(frame_rect, COLOR_DARK_STEEL, false, 2.0)
	
	# Top hydraulic housing
	draw_rect(Rect2(546.0, 168.0, 78.0, 14.0), COLOR_DARK_STEEL)
	draw_rect(Rect2(546.0, 168.0, 78.0, 14.0), COLOR_INFRASTRUCTURE * 0.7, false, 1.0)
	
	# Airlock status lamp (Red when sealed, Cyan when unlocked)
	var lamp_col := COLOR_CYAN if is_door_unlocked else COLOR_CORRECTION
	draw_circle(Vector2(585.0, 175.0), 3.5, lamp_col)
	draw_circle(Vector2(585.0, 175.0), 6.5, Color(lamp_col.r, lamp_col.g, lamp_col.b, 0.25))
	
	# Direction arrow to Space 03 (Puste laboratorium)
	if is_door_unlocked:
		var arr_pulse := sin(_pulse_time * 2.0) * 0.5 + 0.5
		var arr_col := Color(COLOR_CYAN.r, COLOR_CYAN.g, COLOR_CYAN.b, 0.5 + arr_pulse * 0.5)
		draw_line(Vector2(575.0, 238.0), Vector2(595.0, 238.0), arr_col, 2.0)
		draw_line(Vector2(590.0, 232.0), Vector2(595.0, 238.0), arr_col, 2.0)
		draw_line(Vector2(590.0, 244.0), Vector2(595.0, 238.0), arr_col, 2.0)
