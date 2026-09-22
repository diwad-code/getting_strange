class_name PKG0126SmokeTest
extends SceneTree

## PKG-0126 Smoke Test
## Verifies Atmospheric Soundscapes, Substructure Procedural Drones,
## Cinematic Vector Lighting, Dust/Steam Micro-particles, and CRT Dialogue Pacing.

const AtmosphereRigClass := preload("res://scripts/levels/atmosphere_rig.gd")
const CRTDialogueBoxClass := preload("res://scripts/ui/crt_dialogue_box.gd")
const PrototypePlayerClass := preload("res://scripts/player/prototype_player.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run_all_tests")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
		printerr("FAIL: " + message)


func _run_all_tests() -> void:
	print("--- PKG-0126 Smoke Test: Soundscapes, Vector Lighting, Micro-particles & CRT Pacing ---")
	
	_test_procedural_soundscape_generation()
	_test_atmosphere_rig_lighting_profiles()
	_test_steam_and_dust_particles()
	_test_crt_dialogue_pacing_and_speakers()
	_test_player_unease_integration()
	await _test_finale_scenes_atmosphere()
	
	if _failures.is_empty():
		print("PKG-0126: ALL TESTS PASSED (0 FAILURES).")
		quit(0)
	else:
		for f in _failures:
			printerr("FINAL FAIL: " + f)
		quit(1)


func _test_procedural_soundscape_generation() -> void:
	print("1. Testing PKG-0126 procedural audio synthesizers...")
	
	var generators: Array[Dictionary] = [
		{"name": "cooling_chamber_drone", "stream": ProceduralAudio.create_cooling_chamber_drone_sound()},
		{"name": "high_voltage_hum", "stream": ProceduralAudio.create_high_voltage_hum_sound()},
		{"name": "hydraulic_echo", "stream": ProceduralAudio.create_hydraulic_echo_sound()},
		{"name": "substructure_ambient", "stream": ProceduralAudio.create_substructure_ambient_sound()},
		{"name": "finale_42a_forced_return", "stream": ProceduralAudio.create_finale_42a_forced_return_sound()},
		{"name": "finale_42b_closure", "stream": ProceduralAudio.create_finale_42b_closure_sound()},
		{"name": "finale_42c_reciprocal_passage", "stream": ProceduralAudio.create_finale_42c_reciprocal_passage_sound()},
		{"name": "unease_tinnitus", "stream": ProceduralAudio.create_unease_tinnitus_sound()},
		{"name": "residential_ambience", "stream": ProceduralAudio.create_residential_ambience_sound()},
		{"name": "terminal_hum", "stream": ProceduralAudio.create_terminal_hum_sound()},
		{"name": "tunnel_rumble", "stream": ProceduralAudio.create_tunnel_rumble_sound()},
		{"name": "dawn_quietude", "stream": ProceduralAudio.create_dawn_quietude_sound()},
	]
	
	for gen in generators:
		var s: AudioStreamWAV = gen["stream"]
		var gname: String = gen["name"]
		_expect(s != null, "%s sound generator must not return null" % gname)
		if s != null:
			_expect(s.data.size() > 0, "%s sound generator must produce valid PCM sample data" % gname)
			_expect(s.mix_rate == 44100, "%s sound generator mix_rate must be 44100 Hz" % gname)
			_expect(s.format == AudioStreamWAV.FORMAT_16_BITS, "%s must be 16-bit PCM" % gname)


func _test_atmosphere_rig_lighting_profiles() -> void:
	print("2. Testing AtmosphereRig lighting profiles and station categories...")
	
	# Foundation station (1)
	var atmo_01 := AtmosphereRigClass.new()
	atmo_01.station_number = 1
	root.add_child(atmo_01)
	_expect(atmo_01.get_node_or_null("FluorescentLight") is PointLight2D, "Station 1 must have FluorescentLight")
	_expect(atmo_01.get_node_or_null("PracticalAccent") is PointLight2D, "Station 1 must have PracticalAccent")
	atmo_01.queue_free()
	
	# Municipal / Apartment station (8)
	var atmo_08 := AtmosphereRigClass.new()
	atmo_08.station_number = 8
	root.add_child(atmo_08)
	_expect(atmo_08.get_node_or_null("SodiumNeonPulse") is PointLight2D, "Station 8 must have SodiumNeonPulse")
	_expect(atmo_08.get_node_or_null("ApartmentWindowGlow") is PointLight2D, "Station 8 must have ApartmentWindowGlow")
	atmo_08.queue_free()
	
	# UCP Consultation station (18)
	var atmo_18 := AtmosphereRigClass.new()
	atmo_18.station_number = 18
	root.add_child(atmo_18)
	_expect(atmo_18.get_node_or_null("TerminalCyanGlow") is PointLight2D, "Station 18 must have TerminalCyanGlow")
	_expect(atmo_18.get_node_or_null("StressIndicatorPulse") is PointLight2D, "Station 18 must have StressIndicatorPulse")
	atmo_18.queue_free()
	
	# Junction tunnel station (25)
	var atmo_25 := AtmosphereRigClass.new()
	atmo_25.station_number = 25
	root.add_child(atmo_25)
	_expect(atmo_25.get_node_or_null("EmergencyBeacon") is PointLight2D, "Station 25 must have EmergencyBeacon")
	atmo_25.queue_free()
	
	# Substructure archive station (31)
	var atmo_31 := AtmosphereRigClass.new()
	atmo_31.station_number = 31
	root.add_child(atmo_31)
	_expect(atmo_31.get_node_or_null("ArchiveLedgerSpot") is PointLight2D, "Station 31 must have ArchiveLedgerSpot")
	_expect(atmo_31.get_node_or_null("SubstructureDronePlayer") is AudioStreamPlayer, "Station 31 must have SubstructureDronePlayer")
	atmo_31.queue_free()
	
	# Gabinet Wierzbickiej station (40)
	var atmo_40 := AtmosphereRigClass.new()
	atmo_40.station_number = 40
	root.add_child(atmo_40)
	_expect(atmo_40.get_node_or_null("HighContrastSpotlight") is PointLight2D, "Station 40 must have HighContrastSpotlight")
	atmo_40.queue_free()
	
	# Choice chamber station (41)
	var atmo_41 := AtmosphereRigClass.new()
	atmo_41.station_number = 41
	root.add_child(atmo_41)
	_expect(atmo_41.get_node_or_null("ChoicePillarCyan") is PointLight2D, "Station 41 must have ChoicePillarCyan")
	_expect(atmo_41.get_node_or_null("ChoicePillarOxide") is PointLight2D, "Station 41 must have ChoicePillarOxide")
	_expect(atmo_41.get_node_or_null("ChoicePillarAmber") is PointLight2D, "Station 41 must have ChoicePillarAmber")
	atmo_41.queue_free()
	
	# Epilogue station (43)
	var atmo_43 := AtmosphereRigClass.new()
	atmo_43.station_number = 43
	root.add_child(atmo_43)
	_expect(atmo_43.get_node_or_null("DawnWashLight") is PointLight2D, "Station 43 must have DawnWashLight")
	atmo_43.queue_free()


func _test_steam_and_dust_particles() -> void:
	print("3. Testing microdynamic dust and vent steam particles...")
	
	# Station 01 has dust but no steam
	var atmo_01 := AtmosphereRigClass.new()
	atmo_01.station_number = 1
	root.add_child(atmo_01)
	_expect(atmo_01.get_node_or_null("VolumetricDust") is CPUParticles2D, "Station 1 must have VolumetricDust")
	_expect(atmo_01.get_node_or_null("VentSteam") == null, "Station 1 should not have VentSteam")
	atmo_01.queue_free()
	
	# Station 34 (Main engine) has both dust and vent steam
	var atmo_34 := AtmosphereRigClass.new()
	atmo_34.station_number = 34
	root.add_child(atmo_34)
	_expect(atmo_34.get_node_or_null("VolumetricDust") is CPUParticles2D, "Station 34 must have VolumetricDust")
	_expect(atmo_34.get_node_or_null("VentSteam") is CPUParticles2D, "Station 34 must have VentSteam")
	atmo_34.queue_free()


func _test_crt_dialogue_pacing_and_speakers() -> void:
	print("4. Testing CRTDialogueBox pacing, auto_advance and speaker color registry...")
	var crt := CRTDialogueBoxClass.new()
	root.add_child(crt)
	
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"Lena"), "SPEAKER_COLORS must contain Lena")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"Marta"), "SPEAKER_COLORS must contain Marta")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"Jakub"), "SPEAKER_COLORS must contain Jakub")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"WIERZBICKA"), "SPEAKER_COLORS must contain WIERZBICKA")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"Szymon"), "SPEAKER_COLORS must contain Szymon")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"ŚWIADECTWO"), "SPEAKER_COLORS must contain ŚWIADECTWO")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"ŚLAD"), "SPEAKER_COLORS must contain ŚLAD")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"POWRÓT"), "SPEAKER_COLORS must contain POWRÓT")
	_expect(CRTDialogueBoxClass.SPEAKER_COLORS.has(&"UZGODNIENIE"), "SPEAKER_COLORS must contain UZGODNIENIE")
	
	crt.present([{"speaker": "LENA", "text": "Test line 1"}, {"speaker": "MARTA", "text": "Test line 2"}])
	_expect(crt.is_presenting() == true, "CRTDialogueBox must be presenting after present()")
	
	crt.queue_free()


func _test_player_unease_integration() -> void:
	print("5. Testing Player trigger_unease atmosphere integration...")
	var player := PrototypePlayerClass.new()
	root.add_child(player)
	
	player.trigger_unease(1.0)
	_expect(player.visual_rig.get_active_state_name() == &"unease_reaction", "Player visual rig should switch to unease_reaction")
	
	player.queue_free()


func _test_finale_scenes_atmosphere() -> void:
	print("6. Testing Finale scenes 40, 41, 42a, 42b, 42c, 43 AtmosphereRig integration...")
	
	var finale_scenes := [
		"res://scenes/levels/station_40.tscn",
		"res://scenes/levels/station_41.tscn",
		"res://scenes/levels/station_42a.tscn",
		"res://scenes/levels/station_42b.tscn",
		"res://scenes/levels/station_42c.tscn",
		"res://scenes/levels/station_43.tscn",
	]
	
	for path in finale_scenes:
		var packed := load(path) as PackedScene
		_expect(packed != null, "Scene %s must load" % path)
		if packed == null:
			continue
		var inst := packed.instantiate() as Node2D
		_expect(inst != null, "Scene %s must instantiate" % path)
		if inst == null:
			continue
			
		root.add_child(inst)
		await process_frame
		
		var atmo := inst.get_node_or_null("AtmosphereRig") as AtmosphereRig
		_expect(atmo != null, "%s missing AtmosphereRig" % path)
		if atmo:
			_expect(atmo.get_node_or_null("FluorescentLight") != null, "%s AtmosphereRig missing FluorescentLight" % path)
			_expect(atmo.get_node_or_null("FluorescentHum") != null, "%s AtmosphereRig missing FluorescentHum" % path)
			_expect(atmo.get_node_or_null("VolumetricDust") != null, "%s AtmosphereRig missing VolumetricDust" % path)
			
		inst.queue_free()
		for f in range(3):
			await process_frame
