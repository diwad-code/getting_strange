class_name AtmosphereRig
extends Node2D

## Reusable production-lighting and atmospheric soundscape rig for Getting Strange.
## The rig uses native PointLight2D nodes, low-count CPU particles, and procedural
## 16-bit PCM audio streams so it remains 100% Zero-Asset and safe on GL Compatibility renderer.

@export var station_number := 1
@export var world_width := 640.0

var _flicker_time := 0.0
var _fluorescent_lights: Array[PointLight2D] = []
var _pulsing_lights: Array[Dictionary] = [] # entries: { "light": PointLight2D, "base_energy": float, "pulse_speed": float, "pulse_amp": float }
var _fluorescent_hum: AudioStreamPlayer
var _substructure_player: AudioStreamPlayer
var _unease_player: AudioStreamPlayer
var _unease_active := false
var _unease_timer := 0.0


func _ready() -> void:
	_build_lights()
	_build_air_particles()
	_build_steam_particles()
	_build_audio_soundscape()


func _exit_tree() -> void:
	if is_instance_valid(_fluorescent_hum):
		_fluorescent_hum.stop()
		_fluorescent_hum.stream = null
	if is_instance_valid(_substructure_player):
		_substructure_player.stop()
		_substructure_player.stream = null
	if is_instance_valid(_unease_player):
		_unease_player.stop()
		_unease_player.stream = null
	_fluorescent_lights.clear()
	_pulsing_lights.clear()


func _process(delta: float) -> void:
	_flicker_time += delta
	
	# Unease timer update
	if _unease_active:
		_unease_timer -= delta
		if _unease_timer <= 0.0:
			_unease_active = false
	
	# Fluorescent 100 Hz micro-flicker
	var unease_factor := 0.72 if _unease_active else 1.0
	var micro_flicker := (0.84 + sin(_flicker_time * TAU * 100.0) * 0.06) * unease_factor
	for index in _fluorescent_lights.size():
		var light := _fluorescent_lights[index]
		if is_instance_valid(light):
			light.energy = micro_flicker + sin(_flicker_time * 1.7 + float(index)) * 0.04
			
	# Smooth periodic pulse lights (emergency beacons, neon, sodium, choice indicators)
	for entry in _pulsing_lights:
		var plight: PointLight2D = entry.get("light")
		if is_instance_valid(plight):
			var base_e: float = entry.get("base_energy", 0.7)
			var spd: float = entry.get("pulse_speed", 1.0)
			var amp: float = entry.get("pulse_amp", 0.25)
			var pulse := sin(_flicker_time * TAU * spd)
			plight.energy = maxf(0.05, base_e + pulse * amp)


func _build_lights() -> void:
	# Primary overhead fluorescent lighting (preserves contract name "FluorescentLight")
	var fluorescent_positions := [Vector2(world_width * 0.22, 72.0), Vector2(world_width * 0.68, 78.0)]
	var base_fl_color := Color("b8ded5")
	if station_number >= 31 and station_number <= 37:
		base_fl_color = Color("88b5c4") # Cold subterranean vaulted light
	elif station_number >= 38 and station_number <= 41:
		base_fl_color = Color("70a4b8") # Deep machinery cold cast
	elif station_number == 43:
		base_fl_color = Color("f0e6d2") # Morning daylight
		
	for position in fluorescent_positions:
		var light := _make_light("FluorescentLight", position, base_fl_color, 0.9)
		_fluorescent_lights.append(light)
		
	# Station-specific narrative and dramatic lighting profiles
	_build_station_specific_lighting()


func _build_station_specific_lighting() -> void:
	if station_number <= 7:
		# Foundation / Street / Kiosk
		var accent_color := Color("d6a46d") if station_number <= 3 else Color("a9d5e0")
		_make_light("PracticalAccent", Vector2(world_width * 0.82, 195.0), accent_color, 0.62)
		if station_number == 5:
			_make_light("StreetLampGlow", Vector2(world_width * 0.52, 100.0), Color("e2d5a3"), 0.78)
			
	elif station_number >= 8 and station_number <= 13:
		# Residential / Municipal / Apartment 14
		var sodium := _make_light("SodiumNeonPulse", Vector2(world_width * 0.48, 85.0), Color("e2b060"), 0.75)
		_add_pulsing_light(sodium, 0.75, 0.35, 0.20)
		_make_light("ApartmentWindowGlow", Vector2(world_width * 0.85, 160.0), Color("89b8c2"), 0.55)
		
	elif station_number >= 14 and station_number <= 23:
		# UCP Compliance / Consultation / Jakub
		var terminal := _make_light("TerminalCyanGlow", Vector2(world_width * 0.75, 140.0), Color("75c7c3"), 0.70)
		_add_pulsing_light(terminal, 0.70, 0.8, 0.15)
		if station_number >= 18:
			var stress_ind := _make_light("StressIndicatorPulse", Vector2(world_width * 0.25, 120.0), Color("c65d58"), 0.50)
			_add_pulsing_light(stress_ind, 0.50, 0.5, 0.22)
			
	elif station_number >= 24 and station_number <= 30:
		# Line 4 Junction / Intermediate tunnels
		var beacon := _make_light("EmergencyBeacon", Vector2(world_width * 0.50, 60.0), Color("d69a62"), 0.85)
		_add_pulsing_light(beacon, 0.85, 0.75, 0.35)
		_make_light("TunnelDeepGlow", Vector2(world_width * 0.88, 210.0), Color("4a7280"), 0.60)
		
	elif station_number >= 31 and station_number <= 37:
		# Substructure Vaults / Evidence / Filtration
		var archive_lamp := _make_light("ArchiveLedgerSpot", Vector2(world_width * 0.35, 180.0), Color("d8a068"), 0.75)
		_add_pulsing_light(archive_lamp, 0.75, 0.25, 0.12)
		_make_light("SubstructureChasmLight", Vector2(world_width * 0.78, 90.0), Color("6ba8be"), 0.65)
		
	elif station_number == 40:
		# Gabinet Wierzbickiej: Dramatic high-contrast desk spotlight
		var desk_spot := _make_light("HighContrastSpotlight", Vector2(world_width * 0.50, 160.0), Color("d9b88a"), 1.25)
		desk_spot.texture_scale = 1.85
		_make_light("PerimeterDeepShadow", Vector2(world_width * 0.15, 220.0), Color("1a2b38"), 0.40)
		
	elif station_number == 41:
		# Choice Chamber: Tri-color ethical axis pillars
		var pillar_cyan := _make_light("ChoicePillarCyan", Vector2(world_width * 0.20, 150.0), Color("75c7c3"), 0.85)
		var pillar_oxide := _make_light("ChoicePillarOxide", Vector2(world_width * 0.50, 150.0), Color("c65d58"), 0.85)
		var pillar_amber := _make_light("ChoicePillarAmber", Vector2(world_width * 0.80, 150.0), Color("d69a62"), 0.85)
		_add_pulsing_light(pillar_cyan, 0.85, 0.4, 0.18)
		_add_pulsing_light(pillar_oxide, 0.85, 0.4, 0.18)
		_add_pulsing_light(pillar_amber, 0.85, 0.4, 0.18)
		
	elif station_number == 42:
		# Finales 42A / 42B / 42C
		var finale_light := _make_light("FinaleFocalLight", Vector2(world_width * 0.50, 140.0), Color("9bd2cc"), 1.10)
		finale_light.texture_scale = 2.0
		_add_pulsing_light(finale_light, 1.10, 0.2, 0.15)
		
	elif station_number == 43:
		# Epilogue 43: Morning daylight breakthrough
		var dawn := _make_light("DawnWashLight", Vector2(world_width * 0.50, 120.0), Color("f0e6d2"), 1.15)
		dawn.texture_scale = 2.2


func _add_pulsing_light(light: PointLight2D, base_energy: float, pulse_speed: float, pulse_amp: float) -> void:
	_pulsing_lights.append({
		"light": light,
		"base_energy": base_energy,
		"pulse_speed": pulse_speed,
		"pulse_amp": pulse_amp
	})


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


func _build_steam_particles() -> void:
	# Add delicate microdynamic steam plumes in industrial/junction/substructure sectors
	if (station_number >= 14 and station_number <= 41):
		var steam := CPUParticles2D.new()
		steam.name = "VentSteam"
		steam.position = Vector2(world_width * 0.35, 275.0)
		steam.amount = 16
		steam.lifetime = 2.8
		steam.preprocess = 1.0
		steam.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		steam.emission_rect_extents = Vector2(14.0, 3.0)
		steam.direction = Vector2(0.05, -1.0)
		steam.spread = 16.0
		steam.gravity = Vector2(1.0, -6.0)
		steam.initial_velocity_min = 18.0
		steam.initial_velocity_max = 32.0
		steam.scale_amount_min = 1.2
		steam.scale_amount_max = 2.8
		steam.color = Color(0.82, 0.94, 0.92, 0.16)
		add_child(steam)


func _build_audio_soundscape() -> void:
	# Primary ambient player (preserves "FluorescentHum" name for test suite backwards compatibility)
	_fluorescent_hum = AudioStreamPlayer.new()
	_fluorescent_hum.name = "FluorescentHum"
	_fluorescent_hum.stream = _select_primary_soundscape()
	_fluorescent_hum.volume_db = -24.0
	_fluorescent_hum.bus = &"Master"
	add_child(_fluorescent_hum)
	_fluorescent_hum.finished.connect(_fluorescent_hum.play)
	_fluorescent_hum.play()
	
	# Secondary substructure / tension layer for deep sectors
	if station_number >= 31 and station_number <= 41:
		_substructure_player = AudioStreamPlayer.new()
		_substructure_player.name = "SubstructureDronePlayer"
		_substructure_player.stream = ProceduralAudio.get_cached_sound(&"cooling_chamber_drone", ProceduralAudio.create_cooling_chamber_drone_sound)
		_substructure_player.volume_db = -28.0
		_substructure_player.bus = &"Master"
		add_child(_substructure_player)
		_substructure_player.finished.connect(_substructure_player.play)
		_substructure_player.play()
		
	# Unease tinnitus player
	_unease_player = AudioStreamPlayer.new()
	_unease_player.name = "UneaseTinnitusPlayer"
	_unease_player.stream = ProceduralAudio.get_cached_sound(&"unease_tinnitus", ProceduralAudio.create_unease_tinnitus_sound)
	_unease_player.volume_db = -22.0
	_unease_player.bus = &"Master"
	add_child(_unease_player)


func _select_primary_soundscape() -> AudioStreamWAV:
	if station_number <= 7:
		return ProceduralAudio.get_cached_sound(&"fluorescent_hum", ProceduralAudio.create_fluorescent_hum_sound)
	elif station_number <= 13:
		return ProceduralAudio.get_cached_sound(&"residential_ambience", ProceduralAudio.create_residential_ambience_sound)
	elif station_number <= 23:
		return ProceduralAudio.get_cached_sound(&"terminal_hum", ProceduralAudio.create_terminal_hum_sound)
	elif station_number <= 30:
		return ProceduralAudio.get_cached_sound(&"tunnel_rumble", ProceduralAudio.create_tunnel_rumble_sound)
	elif station_number <= 37:
		return ProceduralAudio.get_cached_sound(&"substructure_ambient", ProceduralAudio.create_substructure_ambient_sound)
	elif station_number <= 39:
		return ProceduralAudio.get_cached_sound(&"high_voltage_hum", ProceduralAudio.create_high_voltage_hum_sound)
	elif station_number <= 41:
		return ProceduralAudio.get_cached_sound(&"hydraulic_echo", ProceduralAudio.create_hydraulic_echo_sound)
	elif station_number == 42:
		var parent_node := get_parent()
		if parent_node != null:
			var pname := parent_node.name.to_lower()
			if "42a" in pname:
				return ProceduralAudio.get_cached_sound(&"finale_42a_forced_return", ProceduralAudio.create_finale_42a_forced_return_sound)
			elif "42b" in pname:
				return ProceduralAudio.get_cached_sound(&"finale_42b_closure", ProceduralAudio.create_finale_42b_closure_sound)
			elif "42c" in pname:
				return ProceduralAudio.get_cached_sound(&"finale_42c_reciprocal_passage", ProceduralAudio.create_finale_42c_reciprocal_passage_sound)
		return ProceduralAudio.get_cached_sound(&"finale_42a_forced_return", ProceduralAudio.create_finale_42a_forced_return_sound)
	else:
		return ProceduralAudio.get_cached_sound(&"dawn_quietude", ProceduralAudio.create_dawn_quietude_sound)


## Trigger unease reaction audio and lighting flicker
func trigger_unease_atmosphere(duration: float = 1.5) -> void:
	_unease_active = true
	_unease_timer = duration
	if _unease_player and not _unease_player.playing:
		_unease_player.play()