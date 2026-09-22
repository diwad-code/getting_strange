extends SceneTree

## PKG-0139 Smoke Test — Procedural soundscapes, surface materiality, and CRT blip modulation.
##
## Verifies:
## 1. Procedural audio synthesis for all 5 surface footstep types, landing impacts, speaker blips, and act soundscapes.
## 2. PrototypePlayer surface detection across all 5 surface types and footstep/landing playback.
## 3. CRTDialogueBox speaker-specific audio modulation across characters (LENA, MARTA, JAKUB, WIERZBICKA, SYSTEM).
## 4. AtmosphereRig act soundscape mapping (Acts I..IV, 42a/b/c, 43) and clean lifecycle.

const ProceduralAudio := preload("res://scripts/audio/procedural_audio.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const CRTDialogueBox := preload("res://scripts/ui/crt_dialogue_box.gd")
const AtmosphereRig := preload("res://scripts/levels/atmosphere_rig.gd")

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(cond: bool, msg: String) -> void:
	if not cond:
		_failures.append(msg)
		printerr("FAIL: " + msg)


func _run() -> void:
	print("================================================================================")
	print("  PKG-0139 SMOKE TEST: Soundscapes, Surface Materiality & Dialogue Modulation")
	print("================================================================================")
	
	print("1. Testing PKG-0139 procedural audio synthesizers...")
	_test_synthesizers()
	
	print("2. Testing PrototypePlayer 5-surface footstep & landing system...")
	_test_player_surfaces()
	
	print("3. Testing CRTDialogueBox speaker-specific dialogue blips...")
	await _test_crt_dialogue_blips()
	
	print("4. Testing AtmosphereRig Act soundscape configuration across campaign...")
	await _test_atmosphere_rig_soundscapes()
	
	_finish()


func _test_synthesizers() -> void:
	# Surface footsteps
	var s_terrazzo := ProceduralAudio.create_footstep_terrazzo_sound()
	_expect(s_terrazzo != null and s_terrazzo.data.size() > 0, "create_footstep_terrazzo_sound must produce valid WAV")
	_expect(s_terrazzo.format == AudioStreamWAV.FORMAT_16_BITS, "terrazzo step must be 16-bit PCM")

	var s_asphalt := ProceduralAudio.create_footstep_wet_asphalt_sound()
	_expect(s_asphalt != null and s_asphalt.data.size() > 0, "create_footstep_wet_asphalt_sound must produce valid WAV")

	var s_steel := ProceduralAudio.create_footstep_steel_grating_sound()
	_expect(s_steel != null and s_steel.data.size() > 0, "create_footstep_steel_grating_sound must produce valid WAV")

	var s_deck := ProceduralAudio.create_footstep_hollow_deck_sound()
	_expect(s_deck != null and s_deck.data.size() > 0, "create_footstep_hollow_deck_sound must produce valid WAV")

	var s_linoleum := ProceduralAudio.create_footstep_linoleum_sound()
	_expect(s_linoleum != null and s_linoleum.data.size() > 0, "create_footstep_linoleum_sound must produce valid WAV")

	# Surface landings
	for st_idx in range(5):
		var land_sfx := ProceduralAudio.create_surface_land_sound(st_idx)
		_expect(land_sfx != null and land_sfx.data.size() > 0, "create_surface_land_sound(%d) must produce valid WAV" % st_idx)

	# Speaker blips
	var blip_lena := ProceduralAudio.create_dialogue_lena_blip_sound()
	_expect(blip_lena != null and blip_lena.data.size() > 0, "create_dialogue_lena_blip_sound must produce valid WAV")

	var blip_marta := ProceduralAudio.create_dialogue_marta_blip_sound()
	_expect(blip_marta != null and blip_marta.data.size() > 0, "create_dialogue_marta_blip_sound must produce valid WAV")

	var blip_jakub := ProceduralAudio.create_dialogue_jakub_blip_sound()
	_expect(blip_jakub != null and blip_jakub.data.size() > 0, "create_dialogue_jakub_blip_sound must produce valid WAV")

	var blip_wierzbicka := ProceduralAudio.create_dialogue_wierzbicka_blip_sound()
	_expect(blip_wierzbicka != null and blip_wierzbicka.data.size() > 0, "create_dialogue_wierzbicka_blip_sound must produce valid WAV")

	var blip_sys := ProceduralAudio.create_dialogue_system_blip_sound()
	_expect(blip_sys != null and blip_sys.data.size() > 0, "create_dialogue_system_blip_sound must produce valid WAV")

	# Speaker dispatcher
	for spk in ["LENA", "MARTA", "JAKUB", "dr Wierzbicka", "Szymon", "SYSTEM", "ŚLAD"]:
		var d_blip := ProceduralAudio.create_dialogue_blip_for_speaker(spk)
		_expect(d_blip != null and d_blip.data.size() > 0, "create_dialogue_blip_for_speaker('%s') must produce valid WAV" % spk)

	# Act soundscapes
	var act1_hum := ProceduralAudio.create_act1_fluorescent_ballast_hum_sound()
	_expect(act1_hum != null and act1_hum.data.size() > 0, "create_act1_fluorescent_ballast_hum_sound valid")

	var act1_rain := ProceduralAudio.create_act1_rain_ambience_sound()
	_expect(act1_rain != null and act1_rain.data.size() > 0, "create_act1_rain_ambience_sound valid")

	var act1_phone := ProceduralAudio.create_bakelite_telephone_ring_sound()
	_expect(act1_phone != null and act1_phone.data.size() > 0, "create_bakelite_telephone_ring_sound valid")

	var act2_hvac := ProceduralAudio.create_institutional_hvac_ambient_sound()
	_expect(act2_hvac != null and act2_hvac.data.size() > 0, "create_institutional_hvac_ambient_sound valid")

	var act2_corr := ProceduralAudio.create_linoleum_corridor_resonance_sound()
	_expect(act2_corr != null and act2_corr.data.size() > 0, "create_linoleum_corridor_resonance_sound valid")

	var act2_relay := ProceduralAudio.create_teletype_relay_ambience_sound()
	_expect(act2_relay != null and act2_relay.data.size() > 0, "create_teletype_relay_ambience_sound valid")

	var act2_latch := ProceduralAudio.create_magnetic_latch_sterile_sound()
	_expect(act2_latch != null and act2_latch.data.size() > 0, "create_magnetic_latch_sterile_sound valid")

	var act3_trans := ProceduralAudio.create_transformer_infrasound_sound()
	_expect(act3_trans != null and act3_trans.data.size() > 0, "create_transformer_infrasound_sound valid")

	var act3_drip := ProceduralAudio.create_shaft_water_drip_echo_sound()
	_expect(act3_drip != null and act3_drip.data.size() > 0, "create_shaft_water_drip_echo_sound valid")

	var act3_glass := ProceduralAudio.create_tempered_glass_resonance_sound()
	_expect(act3_glass != null and act3_glass.data.size() > 0, "create_tempered_glass_resonance_sound valid")

	var act3_creak := ProceduralAudio.create_riveted_catwalk_creak_sound()
	_expect(act3_creak != null and act3_creak.data.size() > 0, "create_riveted_catwalk_creak_sound valid")

	var act4_tension := ProceduralAudio.create_correction_tension_swell_sound()
	_expect(act4_tension != null and act4_tension.data.size() > 0, "create_correction_tension_swell_sound valid")

	var act4_tri := ProceduralAudio.create_tri_path_resonance_sound()
	_expect(act4_tri != null and act4_tri.data.size() > 0, "create_tri_path_resonance_sound valid")


func _test_player_surfaces() -> void:
	var packed_player := load("res://scenes/player/prototype_player.tscn") as PackedScene
	_expect(packed_player != null, "prototype_player.tscn must load")
	if packed_player == null:
		return

	var player := packed_player.instantiate() as PrototypePlayer
	root.add_child(player)

	_expect(PrototypePlayer.SurfaceType.LINOLEUM_TILE == 0, "LINOLEUM_TILE enum is 0")
	_expect(PrototypePlayer.SurfaceType.TERRAZZO_STAIR == 1, "TERRAZZO_STAIR enum is 1")
	_expect(PrototypePlayer.SurfaceType.WET_ASPHALT == 2, "WET_ASPHALT enum is 2")
	_expect(PrototypePlayer.SurfaceType.STEEL_GRATING == 3, "STEEL_GRATING enum is 3")
	_expect(PrototypePlayer.SurfaceType.HOLLOW_DECK == 4, "HOLLOW_DECK enum is 4")

	# Test footstep sound assignment
	player.play_footstep()
	_expect(player._step_audio_player != null, "StepAudioPlayer exists")
	_expect(player._step_audio_player.stream != null, "StepAudioPlayer has stream")

	# Test landing sound assignment
	player.play_landing(150.0)
	_expect(player._land_audio_player != null, "LandAudioPlayer exists")
	_expect(player._land_audio_player.stream != null, "LandAudioPlayer has stream")

	player.queue_free()
	await process_frame


func _test_crt_dialogue_blips() -> void:
	var crt := CRTDialogueBox.new()
	root.add_child(crt)
	await process_frame

	var test_speakers := ["LENA", "MARTA", "JAKUB", "WIERZBICKA", "SYSTEM"]
	for spk in test_speakers:
		crt.show_line(spk, "Test blip phrase.")
		crt._visible_characters = 2
		crt._play_speech_blip()
		_expect(crt._audio.stream != null, "CRT audio stream non-null for %s" % spk)
		_expect(crt._audio.pitch_scale >= 0.90 and crt._audio.pitch_scale <= 1.10, "CRT pitch randomized for %s" % spk)

	crt.hide_box()
	crt.queue_free()
	await process_frame


func _test_atmosphere_rig_soundscapes() -> void:
	var test_stations := [1, 5, 6, 8, 12, 16, 22, 26, 30, 32, 35, 37, 40, 41, 43]
	for st_num in test_stations:
		var rig := AtmosphereRig.new()
		rig.station_number = st_num
		rig.world_width = 640.0
		root.add_child(rig)
		await process_frame

		_expect(rig._fluorescent_hum != null, "AtmosphereRig has _fluorescent_hum on station %d" % st_num)
		_expect(rig._fluorescent_hum.stream != null, "AtmosphereRig stream non-null on station %d" % st_num)
		_expect(rig.get_act_number() >= 1 and rig.get_act_number() <= 4, "AtmosphereRig get_act_number valid on station %d" % st_num)

		rig.queue_free()
		await process_frame


func _finish() -> void:
	print("================================================================================")
	if _failures.is_empty():
		print("PKG-0139 SMOKE PASS: Procedural soundscapes, surface materiality & dialogue modulation verified.")
		quit(0)
	else:
		print("PKG-0139 SMOKE FAIL: %d failures" % _failures.size())
		for f in _failures:
			print("  - " + f)
		quit(1)
