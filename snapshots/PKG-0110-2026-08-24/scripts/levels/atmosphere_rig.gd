class_name AtmosphereRig
extends Node2D

## Reusable production-lighting rig for the first stations. The rig uses native
## PointLight2D nodes and low-count CPU particles so it remains safe on the
## GL Compatibility renderer and requires no external texture assets.

@export var station_number := 1
@export var world_width := 640.0

var _flicker_time := 0.0
var _fluorescent_lights: Array[PointLight2D] = []
var _fluorescent_hum: AudioStreamPlayer


func _ready() -> void:
	_build_lights()
	_build_air_particles()
	_build_fluorescent_audio()


func _process(delta: float) -> void:
	_flicker_time += delta
	var micro_flicker := 0.84 + sin(_flicker_time * TAU * 100.0) * 0.06
	for index in _fluorescent_lights.size():
		var light := _fluorescent_lights[index]
		light.energy = micro_flicker + sin(_flicker_time * 1.7 + float(index)) * 0.04


func _build_lights() -> void:
	var fluorescent_positions := [Vector2(world_width * 0.22, 72.0), Vector2(world_width * 0.68, 78.0)]
	for position in fluorescent_positions:
		var light := _make_light("FluorescentLight", position, Color("b8ded5"), 0.9)
		_fluorescent_lights.append(light)
	var accent_color := Color("d6a46d") if station_number <= 3 else Color("a9d5e0")
	_make_light("PracticalAccent", Vector2(world_width * 0.82, 195.0), accent_color, 0.62)
	if station_number == 5:
		_make_light("StreetLampGlow", Vector2(world_width * 0.52, 100.0), Color("e2d5a3"), 0.78)


func _make_light(node_name: String, light_position: Vector2, light_color: Color, light_energy: float) -> PointLight2D:
	var light := PointLight2D.new()
	light.name = node_name
	light.position = light_position
	light.color = light_color
	light.energy = light_energy
	light.texture = _create_radial_light_texture(light_color)
	light.texture_scale = 1.45
	light.blend_mode = Light2D.BLEND_MODE_ADD
	add_child(light)
	return light


func _create_radial_light_texture(light_color: Color) -> GradientTexture2D:
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.18, 0.62, 1.0])
	gradient.colors = PackedColorArray([
		Color(light_color, 0.92),
		Color(light_color, 0.52),
		Color(light_color, 0.13),
		Color(light_color, 0.0),
	])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.width = 256
	texture.height = 256
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(1.0, 0.5)
	texture.fill = GradientTexture2D.FILL_RADIAL
	return texture


func _build_air_particles() -> void:
	var particles := CPUParticles2D.new()
	particles.name = "VolumetricDust"
	particles.position = Vector2(world_width * 0.5, 170.0)
	particles.amount = 28
	particles.lifetime = 5.0
	particles.preprocess = 2.0
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = Vector2(world_width * 0.5, 145.0)
	particles.direction = Vector2(0.15, -1.0)
	particles.spread = 35.0
	particles.gravity = Vector2(2.0, -4.0)
	particles.initial_velocity_min = 4.0
	particles.initial_velocity_max = 12.0
	particles.scale_amount_min = 0.6
	particles.scale_amount_max = 1.4
	particles.color = Color(0.76, 0.88, 0.82, 0.18)
	add_child(particles)


func _build_fluorescent_audio() -> void:
	_fluorescent_hum = AudioStreamPlayer.new()
	_fluorescent_hum.name = "FluorescentHum"
	_fluorescent_hum.stream = ProceduralAudio.create_fluorescent_hum_sound()
	_fluorescent_hum.volume_db = -25.0
	_fluorescent_hum.bus = &"Master"
	add_child(_fluorescent_hum)
	_fluorescent_hum.finished.connect(_fluorescent_hum.play)
	_fluorescent_hum.play()