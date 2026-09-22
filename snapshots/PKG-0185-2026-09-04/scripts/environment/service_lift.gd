class_name ServiceLift
extends AnimatableBody2D

## ServiceLift — diegetyczna platforma windy towarowej/szybowej IKP (3.0)
## Zapewnia płynne przemieszczanie pionowe bez konieczności platformingu.
## Zgodna z kanonem VISUAL_DESIGN.md i TRAVERSAL_AND_OBSTACLE_DESIGN.md.

signal lift_started(direction: int)
signal lift_arrived(at_top: bool)

@export var travel_distance: Vector2 = Vector2(0.0, -110.0)
@export var travel_speed: float = 38.0
@export var auto_cycle: bool = false
@export var wait_time_at_ends: float = 1.8
@export var lift_width: float = 76.0
@export var lift_height: float = 12.0

var _start_position: Vector2
var _target_position: Vector2
var _progress: float = 0.0
var _direction: int = 0 # 1 = to target, -1 = to start, 0 = idle
var _wait_timer: float = 0.0
var _motor_player: AudioStreamPlayer2D


func _ready() -> void:
	sync_to_physics = true
	_start_position = position
	_target_position = _start_position + travel_distance
	_ensure_collision()
	_setup_audio()
	queue_redraw()


func _ensure_collision() -> void:
	var shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape == null:
		shape = CollisionShape2D.new()
		shape.name = "CollisionShape2D"
		var rect := RectangleShape2D.new()
		rect.size = Vector2(lift_width, lift_height)
		shape.shape = rect
		shape.position = Vector2(0.0, 0.0)
		add_child(shape)


func _setup_audio() -> void:
	_motor_player = AudioStreamPlayer2D.new()
	_motor_player.name = "MotorAudioPlayer"
	# PKG-0130: route through the process-wide PCM cache. Synthesising a fresh
	# 1.2 s motor buffer per lift instance cost load time and heap on every scene
	# change; the waveform is deterministic, so one cached buffer serves all lifts.
	_motor_player.stream = ProceduralAudio.get_cached_sound(
		&"moving_tram_motor",
		ProceduralAudio.create_moving_tram_motor_sound
	)
	_motor_player.volume_db = -12.0
	_motor_player.max_distance = 500.0
	_motor_player.bus = &"Master"
	add_child(_motor_player)


func trigger_lift() -> void:
	if _direction != 0:
		return
	if _progress <= 0.05:
		_direction = 1
	elif _progress >= 0.95:
		_direction = -1
	else:
		_direction = 1
	
	if _motor_player:
		_motor_player.play()
	lift_started.emit(_direction)


func _physics_process(delta: float) -> void:
	if _direction != 0:
		var distance_len := travel_distance.length()
		var step := (travel_speed / maxf(1.0, distance_len)) * delta
		_progress = clampf(_progress + float(_direction) * step, 0.0, 1.0)
		position = _start_position.lerp(_target_position, _progress)
		
		if _progress >= 1.0 or _progress <= 0.0:
			var arrived_at_top: bool = _progress >= 1.0
			_direction = 0
			if _motor_player:
				_motor_player.stop()
			lift_arrived.emit(arrived_at_top)
			if auto_cycle:
				_wait_timer = wait_time_at_ends
	elif auto_cycle and _wait_timer > 0.0:
		_wait_timer -= delta
		if _wait_timer <= 0.0:
			trigger_lift()


func _draw() -> void:
	var half_w := lift_width * 0.5
	var half_h := lift_height * 0.5
	
	# Heavy steel platform base
	var platform_poly := PackedVector2Array([
		Vector2(-half_w, -half_h),
		Vector2(half_w, -half_h),
		Vector2(half_w - 3.0, half_h),
		Vector2(-half_w + 3.0, half_h),
	])
	VectorStageStyle.draw_facet_polygon(self, platform_poly, VectorStageStyle.DEEP_PLANE, 0.0)
	
	# Top illuminated edge
	draw_line(Vector2(-half_w, -half_h), Vector2(half_w, -half_h), VectorStageStyle.LIGHT_PLANE, 2.0)
	
	# Side safety railings
	var rail_h := -28.0
	# Left railing
	draw_line(Vector2(-half_w + 4.0, -half_h), Vector2(-half_w + 4.0, rail_h), VectorStageStyle.MID_PLANE, 2.5)
	# Right railing
	draw_line(Vector2(half_w - 4.0, -half_h), Vector2(half_w - 4.0, rail_h), VectorStageStyle.MID_PLANE, 2.5)
	# Top bar
	draw_line(Vector2(-half_w + 2.0, rail_h), Vector2(-half_w + 20.0, rail_h), VectorStageStyle.LIGHT_PLANE, 2.0)
	draw_line(Vector2(half_w - 20.0, rail_h), Vector2(half_w - 2.0, rail_h), VectorStageStyle.LIGHT_PLANE, 2.0)
	
	# Cyan or Amber operational indicator
	var status_col := VectorStageStyle.ANCHOR_CYAN if _direction != 0 else VectorStageStyle.HUMAN_AMBER
	draw_rect(Rect2(-6.0, rail_h + 4.0, 12.0, 6.0), VectorStageStyle.INK)
	draw_circle(Vector2(0.0, rail_h + 7.0), 2.5, status_col)
