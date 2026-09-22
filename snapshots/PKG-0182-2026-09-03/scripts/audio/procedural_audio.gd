class_name ProceduralAudio
extends RefCounted

## Procedural audio generator for Getting Strange.
## Synthesizes clean 16-bit PCM AudioStreamWAV streams without external audio assets.
## Timbral character derived from VISUAL_DESIGN.md (clinical institutional order,
## cool cyan #75C7C3 anchor resonance, oxide cinnabar #C65D58 correction rumble).

const SAMPLE_RATE: int = 44100

static var _sound_cache: Dictionary = {}


static func get_cached_sound(cache_key: StringName, generator_callable: Callable) -> AudioStreamWAV:
	if _sound_cache.has(cache_key):
		return _sound_cache[cache_key]
	var stream: AudioStreamWAV = generator_callable.call()
	_sound_cache[cache_key] = stream
	return stream


static func clear_sound_cache() -> void:
	_sound_cache.clear()


static func drain_playback(node: Node) -> void:
	if node == null:
		return
	if node is AudioStreamPlayer:
		var player := node as AudioStreamPlayer
		player.stop()
		player.stream = null
	elif node is AudioStreamPlayer2D:
		var spatial := node as AudioStreamPlayer2D
		spatial.stop()
		spatial.stream = null
	for child in node.get_children():
		drain_playback(child)


static func get_sound_cache_size() -> int:
	return _sound_cache.size()


static func generate_wav(duration: float, generator_func: Callable) -> AudioStreamWAV:
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = SAMPLE_RATE
	wav.stereo = false

	var total_samples := maxi(1, int(duration * SAMPLE_RATE))
	var data := PackedByteArray()
	data.resize(total_samples * 2)

	for i in range(total_samples):
		var t: float = float(i) / float(SAMPLE_RATE)
		var sample: float = clampf(float(generator_func.call(t, duration)), -1.0, 1.0)
		var s16: int = int(sample * 32767.0)
		data.encode_s16(i * 2, s16)

	wav.data = data
	return wav


## Anchor Sound: Cool cyan resonance (740 Hz F#5 crystalline harmonic chime with latch transient)
static func create_anchor_sound() -> AudioStreamWAV:
	var duration := 0.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Attack envelope (5ms attack, exponential release)
		var env := exp(-t * 8.5) if t >= 0.005 else (t / 0.005)
		
		# Fundamental and upper harmonic
		var f0 := 740.0
		var f1 := 1480.0
		var tone := 0.75 * sin(t * TAU * f0) + 0.25 * sin(t * TAU * f1)
		
		# Short mechanical latch transient at t < 0.015s
		var click := 0.0
		if t < 0.015:
			var click_t := t / 0.015
			click = (1.0 - click_t) * (sin(t * TAU * 2200.0) * 0.4 + (sin(t * 1337.0) - 0.5) * 0.3)
		
		return (tone * 0.7 + click * 0.3) * env * 0.85
	)


## Unanchor Sound: Soft downward release (660 Hz -> 330 Hz relaxation curve)
static func create_unanchor_sound() -> AudioStreamWAV:
	var duration := 0.28
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := (1.0 - progress) * (1.0 - progress)
		# Smooth descending frequency
		var freq := lerpf(660.0, 310.0, progress * progress)
		var tone := sin(t * TAU * freq) * 0.8 + sin(t * TAU * freq * 0.5) * 0.2
		return tone * env * 0.7
	)


## Correction Pulse Sound: Heavy institutional sub-bass rumble (92 Hz -> 44 Hz cinnabar pulse)
static func create_correction_pulse_sound() -> AudioStreamWAV:
	var duration := 0.55
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		# Smooth trapezoidal / exponential envelope
		var attack := minf(1.0, t / 0.02)
		var decay := exp(-progress * 3.8)
		var env := attack * decay
		
		# Sweeping low frequency
		var freq := lerpf(92.0, 44.0, progress)
		var sub := sin(t * TAU * freq)
		var sub2 := sin(t * TAU * (freq * 0.5)) * 0.5
		# Subtle industrial texture (filtered noise grain)
		var noise_texture := sin(t * 8400.0) * cos(t * 4320.0) * 0.15
		
		var raw := (sub * 0.65 + sub2 * 0.25 + noise_texture) * env
		# Soft saturation curve
		return tanh(raw * 1.4) * 0.95
	)


## Resist Shift Sound: Metallic phase clash resolving to stable anchor tone
static func create_resist_sound() -> AudioStreamWAV:
	var duration := 0.42
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 6.5) if t >= 0.003 else (t / 0.003)
		
		# Beating interference (587 Hz D5 & 622 Hz Eb5) creating tension
		var beat := sin(t * TAU * 587.0) * 0.5 + sin(t * TAU * 622.0) * 0.5
		# Stable cyan resolution tone (740 Hz) rising as beating fades
		var stable := sin(t * TAU * 740.0)
		var mix_weight := clampf(progress * 2.5, 0.0, 1.0)
		var tone := lerpf(beat, stable, mix_weight)
		
		# Metallic sharp strike transient
		var strike := 0.0
		if t < 0.02:
			strike = (1.0 - t / 0.02) * sin(t * TAU * 1960.0) * 0.5
			
		return (tone * 0.75 + strike * 0.25) * env * 0.9
	)


## Goal / Synchronization Sound: Dual harmonic chime (C5 + G5 pure fifth)
static func create_goal_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 4.5) if t >= 0.005 else (t / 0.005)
		var c5 := sin(t * TAU * 523.25) * 0.6
		var g5 := sin(t * TAU * 783.99) * 0.4
		return (c5 + g5) * env * 0.8
	)


## Linoleum / Concrete Footstep: Dry, subtle institutional tap with low body
static func create_footstep_linoleum_sound() -> AudioStreamWAV:
	var duration := 0.07
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 80.0) if t >= 0.002 else (t / 0.002)
		var body := sin(t * TAU * 220.0) * 0.65 + sin(t * TAU * 340.0) * 0.35
		var click := 0.0
		if t < 0.008:
			click = (1.0 - t / 0.008) * sin(t * TAU * 1600.0) * 0.35
		return (body * 0.7 + click * 0.3) * env * 0.65
	)


## Metal Footstep: Crisp metallic tap with ringing overtone (lift / steel bridge)
static func create_footstep_metal_sound() -> AudioStreamWAV:
	var duration := 0.09
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 55.0) if t >= 0.001 else (t / 0.001)
		var tone := sin(t * TAU * 1180.0) * 0.45 + sin(t * TAU * 1860.0) * 0.3 + sin(t * TAU * 440.0) * 0.25
		var click := 0.0
		if t < 0.008:
			click = (1.0 - t / 0.008) * sin(t * TAU * 3400.0) * 0.45
		return (tone * 0.65 + click * 0.35) * env * 0.75
	)


## Landing Impact: Firm cushion thud with surface resonance
static func create_land_sound(is_metal: bool = false) -> AudioStreamWAV:
	var duration := 0.14
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 26.0) if t >= 0.003 else (t / 0.003)
		var low_impact := sin(t * TAU * 115.0) * 0.65 + sin(t * TAU * 180.0) * 0.35
		var overtone := 0.0
		if is_metal:
			overtone = (sin(t * TAU * 880.0) * 0.35 + sin(t * TAU * 1420.0) * 0.25) * exp(-t * 35.0)
		else:
			overtone = sin(t * TAU * 400.0) * 0.2 * exp(-t * 45.0)
		return (low_impact * 0.7 + overtone * 0.3) * env * 0.85
	)


## Airlock Lockdown & Containment Seal: Rising magnetic charge + pneumatic hydraulic latch
static func create_airlock_seal_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var sample := 0.0
		
		# Phase 1: Magnetic resonance frequency sweep (0.0s .. 0.60s)
		if t < 0.60:
			var p1 := t / 0.60
			var env1 := minf(1.0, t / 0.04) * (1.0 - p1 * 0.3)
			var freq := lerpf(330.0, 880.0, p1 * p1)
			var mag := sin(t * TAU * freq) * 0.6 + sin(t * TAU * (freq * 1.5)) * 0.25
			var flutter := sin(t * TAU * 40.0) * 0.15
			sample += (mag + flutter) * env1 * 0.55
		
		# Phase 2: Heavy pneumatic latch & mechanical seal impact at t >= 0.45s
		if t >= 0.45:
			var p2 := (t - 0.45) / 0.40
			var env2 := exp(-p2 * 9.0) if p2 >= 0.005 else (p2 / 0.005)
			var thud := sin((t - 0.45) * TAU * 95.0) * 0.6 + sin((t - 0.45) * TAU * 240.0) * 0.4
			var metallic_clack := 0.0
			if p2 < 0.04:
				metallic_clack = (1.0 - p2 / 0.04) * sin((t - 0.45) * TAU * 2200.0) * 0.5
			var hiss := (sin(t * 12345.0) * cos(t * 7890.0)) * 0.25 * exp(-p2 * 5.0)
			sample += (thud * 0.5 + metallic_clack * 0.3 + hiss * 0.2) * env2 * 0.8
			
		return clampf(sample, -1.0, 1.0)
	)


## Memory Resonance Sound: Warm amber harmonic tone (A4 440 Hz + C#5 554.37 Hz) with gentle phase drift
static func create_memory_resonance_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 3.8) if t >= 0.015 else (t / 0.015)
		var progress := t / dur
		
		# Warm harmonic dual-frequency resonance (warm major third)
		var f_a := 440.0 + sin(t * TAU * 1.5) * 1.2
		var f_csharp := 554.37 + cos(t * TAU * 2.0) * 1.5
		var f_sub := 220.0
		
		var tone_a := sin(t * TAU * f_a) * 0.45
		var tone_csharp := sin(t * TAU * f_csharp) * 0.35
		var tone_sub := sin(t * TAU * f_sub) * 0.20
		
		# Subtle warm filament grain / soft hum
		var tape_grain := (sin(t * 7800.0) * cos(t * 3900.0)) * 0.06 * exp(-progress * 2.0)
		
		var raw := (tone_a + tone_csharp + tone_sub + tape_grain) * env
		return clampf(raw * 0.9, -1.0, 1.0)
	)


## Switch Toggle Sound: Crisp institutional mechanical toggle latch (820 Hz transient + 180 Hz body)
static func create_switch_toggle_sound() -> AudioStreamWAV:
	var duration := 0.08
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 70.0) if t >= 0.001 else (t / 0.001)
		# Mechanical lever snap
		var lever := sin(t * TAU * 820.0) * 0.6 + sin(t * TAU * 1640.0) * 0.25
		var body := sin(t * TAU * 180.0) * 0.4
		var snap := 0.0
		if t < 0.005:
			snap = (1.0 - t / 0.005) * sin(t * TAU * 3600.0) * 0.5
		return (lever * 0.5 + body * 0.3 + snap * 0.2) * env * 0.85
	)


## Vacuum Hum Sound: Low-frequency turbine and vacuum chamber hum loop
static func create_vacuum_hum_sound() -> AudioStreamWAV:
	var duration := 0.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var f1 := 55.0
		var f2 := 110.0
		var f3 := 165.0
		var tone := sin(t * TAU * f1) * 0.5 + sin(t * TAU * f2) * 0.3 + sin(t * TAU * f3) * 0.15
		var air_flow := (sin(t * 4320.0) * cos(t * 2160.0)) * 0.08
		return clampf((tone + air_flow) * 0.7, -1.0, 1.0)
	)


## Correlation Hum Sound: High-energy dual carrier harmonic resonance (220 Hz + 330 Hz with pure fifth and sub-bass)
static func create_correlation_hum_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sub := sin(t * TAU * 55.0) * 0.25
		var c1 := sin(t * TAU * 220.0) * 0.40
		var c2 := sin(t * TAU * 330.0) * 0.30
		var harmonic := sin(t * TAU * 660.0) * 0.15
		var crystal := sin(t * TAU * 880.0) * 0.08
		# Electromagnetic flux fluctuation
		var flux := sin(t * TAU * 8.0) * 0.08
		var raw := (sub + c1 + c2 + harmonic + crystal) * (1.0 + flux)
		return clampf(raw * 0.8, -1.0, 1.0)
	)


## Strip Chart Printer Sound: Mechanical paper feed stepper motor chirp + thermal print strike clicks
static func create_printer_strip_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 5.0) if t >= 0.01 else (t / 0.01)
		# Stepper motor step pulse series (every 0.04s)
		var step_cycle := fmod(t, 0.045)
		var step_env := exp(-step_cycle * 90.0)
		var stepper := sin(step_cycle * TAU * 1150.0) * step_env * 0.65
		# Printhead thermal impact hiss
		var noise := (sin(t * 14500.0) * cos(t * 6200.0)) * 0.25 * exp(-t * 6.0)
		var raw := (stepper * 0.7 + noise * 0.3) * env
		return clampf(raw * 0.85, -1.0, 1.0)
	)


## Galvanometer Needle Spike Sound: Overload deflection strike with mechanical damping bounce
static func create_needle_spike_sound() -> AudioStreamWAV:
	var duration := 0.12
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 40.0) if t >= 0.001 else (t / 0.001)
		# Sharp tap on gauge stop
		var strike := sin(t * TAU * 1380.0) * 0.7 + sin(t * TAU * 2760.0) * 0.3
		var bounce := 0.0
		if t >= 0.025:
			var t_b := t - 0.025
			bounce = sin(t_b * TAU * 920.0) * exp(-t_b * 60.0) * 0.35
		var raw := (strike * 0.75 + bounce * 0.25) * env
		return clampf(raw * 0.9, -1.0, 1.0)
	)


## Desk Telephone Pulse / Ring Sound: Institutional European dual-tone beep & flutter
static func create_phone_ring_pulse_sound() -> AudioStreamWAV:
	var duration := 0.35
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 6.0) if t >= 0.005 else (t / 0.005)
		# Dual frequency 425 Hz carrier with 25 Hz amplitude flutter
		var carrier := sin(t * TAU * 425.0) * 0.65 + sin(t * TAU * 850.0) * 0.20
		var flutter := 0.6 + 0.4 * sin(t * TAU * 25.0)
		# High frequency electronic message alert chirp (1680 Hz + 2100 Hz)
		var alert_chirp := (sin(t * TAU * 1680.0) * 0.3 + sin(t * TAU * 2100.0) * 0.2) * exp(-t * 18.0)
		var raw := (carrier * flutter + alert_chirp) * env
		return clampf(raw * 0.85, -1.0, 1.0)
	)


## Card Reader Authorization / Discordant Access Chime: Dual electronic ping + solenoid latch click
static func create_card_reader_beep_sound() -> AudioStreamWAV:
	var duration := 0.26
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sample := 0.0
		# Tone 1: 987 Hz B5 ping (0.00s .. 0.10s)
		if t < 0.11:
			var p1 := t / 0.11
			var env1 := exp(-p1 * 8.0) if t >= 0.002 else (t / 0.002)
			sample += sin(t * TAU * 987.77) * env1 * 0.55
		# Tone 2: 1318 Hz E6 chime (0.08s .. 0.26s)
		if t >= 0.08:
			var p2 := (t - 0.08) / 0.18
			var env2 := exp(-p2 * 7.5) if p2 >= 0.002 else (p2 / 0.002)
			# Slight discordant minor second undertone (1380 Hz) symbolizing "urlop przerwany" anomaly
			var tone2 := sin((t - 0.08) * TAU * 1318.5) * 0.5 + sin((t - 0.08) * TAU * 1380.0) * 0.15
			sample += tone2 * env2 * 0.55
		# Mechanical solenoid latch click at t < 0.015s
		if t < 0.015:
			sample += (1.0 - t / 0.015) * sin(t * TAU * 2800.0) * 0.3
		return clampf(sample, -1.0, 1.0)
	)


## Fluorescent Ballast Hum: Institutional corridor ambient hum with 100 Hz ballast buzz
static func create_fluorescent_hum_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var f1 := 100.0 # 50Hz full-wave rectified mains ballast
		var f2 := 200.0
		var f3 := 300.0
		var buzz := sin(t * TAU * f1) * 0.50 + sin(t * TAU * f2) * 0.30 + sin(t * TAU * f3) * 0.15
		var filament_tick := sin(t * TAU * 12.5) * 0.08
		var gas_noise := (sin(t * 8900.0) * cos(t * 4450.0)) * 0.05
		var raw := (buzz + filament_tick + gas_noise) * 0.65
		return clampf(raw, -1.0, 1.0)
	)


## Camera Relay Cutoff Click: Sharp electromagnetic switch disconnect + filament snap (Scene 04)
static func create_camera_click_sound() -> AudioStreamWAV:
	var duration := 0.18
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 35.0) if t >= 0.001 else (t / 0.001)
		# Heavy relay coil pop (180 Hz) + sharp ceramic snap (1850 Hz)
		var coil := sin(t * TAU * 180.0) * 0.65
		var snap := sin(t * TAU * 1850.0) * 0.35 + (sin(t * 6200.0) - 0.5) * 0.25
		# Filament discharge ping
		var discharge := sin(t * TAU * 3200.0) * exp(-t * 70.0) * 0.2
		var raw := (coil + snap + discharge) * env
		return tanh(raw * 0.95) * 0.94
	)


## Turnstile Unlatch Sound: Mechanical solenoid clunk + ratchet tooth release
static func create_turnstile_unlatch_sound() -> AudioStreamWAV:
	var duration := 0.22
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 22.0) if t >= 0.002 else (t / 0.002)
		# Solenoid strike (340 Hz)
		var strike := sin(t * TAU * 340.0) * 0.60
		# High frequency mechanical pawl friction
		var pawl := sin(t * TAU * 2200.0) * 0.25 + (sin(t * 9100.0) - 0.5) * 0.20
		# Delayed tooth rebound at t = 0.035
		var rebound := 0.0
		if t >= 0.035:
			var tr := t - 0.035
			rebound = sin(tr * TAU * 680.0) * exp(-tr * 45.0) * 0.35
		var raw := (strike + pawl + rebound) * env
		return clampf(raw * 0.90, -1.0, 1.0)
	)


## Dialogue Blip Sound: Soft tactile terminal text pulse
static func create_dialogue_blip_sound(is_lena: bool = true) -> AudioStreamWAV:
	var duration := 0.05
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 90.0) if t >= 0.001 else (t / 0.001)
		# Lena: 587 Hz warm amber harmonic; Guard: 330 Hz deeper institutional chime
		var freq := 587.33 if is_lena else 329.63
		var tone := sin(t * TAU * freq) * 0.75 + sin(t * TAU * freq * 2.0) * 0.25
		return clampf(tone * env * 0.6, -1.0, 1.0)
	)


## Crosswalk Acoustic Beacon / Signal Sound: 500 Hz locator pulses + optional formant whisper "Lena" (Scene 05)
static func create_crosswalk_signal_sound(with_name_whisper: bool = false) -> AudioStreamWAV:
	var duration := 0.65 if with_name_whisper else 0.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sample := 0.0
		
		# 1. Standard European acoustic pedestrian locator pulses (2 beeps: t=0.0..0.08s and t=0.18..0.26s)
		var p1_env := (exp(-t * 35.0) if t >= 0.002 else (t / 0.002)) if t < 0.12 else 0.0
		var p2_t := t - 0.18
		var p2_env := (exp(-p2_t * 35.0) if p2_t >= 0.002 else (p2_t / 0.002)) if (t >= 0.18 and t < 0.30) else 0.0
		
		var f_locator := 500.0
		var locator_tone := sin(t * TAU * f_locator) * 0.6 + sin(t * TAU * (f_locator * 2.0)) * 0.25
		sample += locator_tone * (p1_env + p2_env) * 0.75
		
		# 2. Formant-filtered whisper resonance ("Le-na") on activation per FULL_STORY 05
		if with_name_whisper and t >= 0.22:
			var w_t := t - 0.22
			var w_dur := 0.42
			var progress := clampf(w_t / w_dur, 0.0, 1.0)
			var w_env := sin(progress * PI) * exp(-progress * 1.5)
			
			# Syllable 1: "Le" (t=0..0.20): F1 ~450 Hz, F2 ~1800 Hz, F3 ~2400 Hz
			# Syllable 2: "na" (t=0.20..0.42): F1 ~750 Hz, F2 ~1200 Hz, F3 ~2200 Hz
			var is_syl1 := progress < 0.48
			var f1 := 450.0 if is_syl1 else 750.0
			var f2 := 1800.0 if is_syl1 else 1200.0
			var f3 := 2400.0 if is_syl1 else 2200.0
			
			var formant := sin(w_t * TAU * f1) * 0.40 + sin(w_t * TAU * f2) * 0.30 + sin(w_t * TAU * f3) * 0.15
			var breath := (sin(w_t * 7890.0) * cos(w_t * 3450.0)) * 0.18
			sample += (formant + breath) * w_env * 0.60
		
		return clampf(sample, -1.0, 1.0)
	)


## Rain on Wet Asphalt Sound: Ambient rain texture with micro-droplet impact transients
static func create_rain_asphalt_sound() -> AudioStreamWAV:
	var duration := 0.90
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Base continuous rain hiss (low-pass filtered white noise simulation)
		var n1 := sin(t * 11340.0) * cos(t * 5420.0) * 0.35
		var n2 := sin(t * 7820.0) * sin(t * 3210.0) * 0.25
		var sub_rumble := sin(t * TAU * 65.0) * 0.12
		
		# Micro droplet puddle impact clicks (rhythmic splatter texture)
		var clicks := 0.0
		var intervals: Array[float] = [0.08, 0.23, 0.41, 0.59, 0.77]
		for click_time in intervals:
			if t >= click_time and t < click_time + 0.02:
				var ct := (t - click_time) / 0.02
				clicks += (1.0 - ct) * sin((t - click_time) * TAU * 2600.0) * 0.15
		
		var raw := (n1 + n2 + sub_rumble + clicks) * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Tram Catenary & Electric Traction Sound: 50 Hz mains hum + 620 Hz traction motor whine + rail flange
static func create_tram_traction_sound() -> AudioStreamWAV:
	var duration := 0.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# 50 Hz / 100 Hz European catenary mains hum
		var mains := sin(t * TAU * 50.0) * 0.45 + sin(t * TAU * 100.0) * 0.30
		# 620 Hz electric inverter / traction motor whine with slight flutter
		var f_traction := 620.0 + sin(t * TAU * 2.5) * 8.0
		var traction := sin(t * TAU * f_traction) * 0.35 + sin(t * TAU * (f_traction * 2.0)) * 0.15
		# High frequency rail flange friction (~1420 Hz with soft noise)
		var rail_hiss := (sin(t * 8920.0) * cos(t * 4460.0)) * 0.08
		var flange := sin(t * TAU * 1420.0) * 0.12 * (0.6 + 0.4 * sin(t * TAU * 8.0))
		
		var raw := (mains + traction + rail_hiss + flange) * 0.65
		return clampf(raw, -1.0, 1.0)
	)


## Bus Diesel Engine Hum Sound: 42 Hz fundamental diesel combustion rumble with chassis vibration (Scene 06)
static func create_bus_engine_sound(is_decelerating: bool = false) -> AudioStreamWAV:
	var duration := 1.00
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Diesel engine cylinder strokes: ~42 Hz idle / cruising, ~28 Hz when decelerating
		var base_f := 28.0 if is_decelerating else 42.0
		# Subtle rhythmic engine throb (4-cylinder cycle)
		var throb := 1.0 + 0.18 * sin(t * TAU * (base_f * 0.5))
		
		var f0 := sin(t * TAU * base_f) * 0.50
		var f1 := sin(t * TAU * (base_f * 2.0)) * 0.30
		var f2 := sin(t * TAU * (base_f * 3.0)) * 0.15
		var sub := sin(t * TAU * (base_f * 0.5)) * 0.25
		
		# Low-pass chassis vibration texture
		var vibration := (sin(t * 240.0) * cos(t * 110.0)) * 0.10
		
		var raw := (f0 + f1 + f2 + sub + vibration) * throb * 0.70
		return clampf(raw, -1.0, 1.0)
	)


## Bus Rain on Window Pane Sound: Droplets pattering against vibrating bus glass with wind wash (Scene 06)
static func create_bus_rain_window_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Glass resonance / wind wash
		var glass_wash := sin(t * 6800.0) * cos(t * 3100.0) * 0.22
		var wind_sub := sin(t * TAU * 85.0) * 0.10
		
		# Sharp micro droplets tapping against glass surface
		var taps := 0.0
		var tap_moments: Array[float] = [0.05, 0.17, 0.31, 0.44, 0.58, 0.72]
		for tap_t in tap_moments:
			if t >= tap_t and t < tap_t + 0.015:
				var local_t := (t - tap_t) / 0.015
				taps += (1.0 - local_t) * sin((t - tap_t) * TAU * 3400.0) * 0.25
		
		var raw := (glass_wash + wind_sub + taps) * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Bus PA / Intercom Announcement Chime: Two-tone institutional chime (F#5 740 Hz -> C#5 554 Hz) with speaker hiss (Scene 06)
static func create_bus_announcement_sound() -> AudioStreamWAV:
	var duration := 0.70
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sample := 0.0
		
		# Chime 1: 740 Hz (F#5) from t=0.0..0.28s
		if t < 0.30:
			var env1 := exp(-t * 12.0) if t >= 0.003 else (t / 0.003)
			var tone1 := sin(t * TAU * 740.0) * 0.65 + sin(t * TAU * 1480.0) * 0.20
			sample += tone1 * env1 * 0.70
		
		# Chime 2: 554.37 Hz (C#5) from t=0.22..0.65s
		if t >= 0.20:
			var t2 := t - 0.20
			var env2 := exp(-t2 * 10.0) if t2 >= 0.003 else (t2 / 0.003)
			var tone2 := sin(t2 * TAU * 554.37) * 0.65 + sin(t2 * TAU * 1108.74) * 0.20
			sample += tone2 * env2 * 0.70
		
		# Speaker static / bandpass hiss
		var pa_hiss := (sin(t * 14200.0) * cos(t * 7800.0)) * 0.06 * (1.0 - exp(-t * 20.0))
		sample += pa_hiss
		
		return clampf(sample, -1.0, 1.0)
	)


## Bus Pneumatic Door Sound: Compressed air exhaust release whoosh + mechanical folding latch (Scene 06)
static func create_bus_door_pneumatic_sound() -> AudioStreamWAV:
	var duration := 0.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		# Air hiss / release whoosh
		var air_env := (exp(-progress * 4.5) if progress >= 0.02 else (progress / 0.02))
		var freq_sweep := lerpf(1800.0, 420.0, progress)
		var air := (sin(t * TAU * freq_sweep) * 0.35 + sin(t * 9200.0) * 0.40) * air_env
		
		# Mechanical folding latch transient at t=0.25..0.30
		var latch := 0.0
		if t >= 0.25 and t < 0.32:
			var lt := (t - 0.25) / 0.07
			latch = (1.0 - lt) * (sin((t - 0.25) * TAU * 880.0) * 0.5 + sin((t - 0.25) * TAU * 2200.0) * 0.3)
		
		var raw := (air * 0.70 + latch * 0.30)
		return clampf(raw, -1.0, 1.0)
	)


## Gold Ring Chime Sound: Pure warm gold metallic resonance with micro-harmonic beat (Scene 06)
static func create_ring_chime_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 7.0) if t >= 0.002 else (t / 0.002)
		# Dual harmonic shimmer (1046.5 Hz C6 + 1318.5 Hz E6 with micro-phase drift)
		var tone1 := sin(t * TAU * 1046.50) * 0.55
		var tone2 := sin(t * TAU * 1318.51 + sin(t * TAU * 3.0) * 0.2) * 0.35
		var tone3 := sin(t * TAU * 2093.00) * 0.10
		
		var raw := (tone1 + tone2 + tone3) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Terrazzo / Lastryko Stair Footstep Sound: Dense mineral impact with enclosed stairwell acoustic slapback (Scene 07)
static func create_stair_footstep_sound() -> AudioStreamWAV:
	var duration := 0.18
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 32.0) if t >= 0.002 else (t / 0.002)
		# Mineral tap transient (280 Hz + 480 Hz)
		var tap := sin(t * TAU * 280.0) * 0.55 + sin(t * TAU * 480.0) * 0.30
		# Concrete stairwell acoustic cavity resonance (180 Hz with subtle decay tail)
		var stair_reverb := sin(t * TAU * 180.0) * 0.25 * exp(-t * 18.0)
		var friction := (sin(t * 7200.0) * cos(t * 3600.0)) * 0.12 * env
		
		var raw := (tap * env + stair_reverb + friction) * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Heavy Wooden/Laminate Apartment Door Sound: Hinge friction creak + brass latch unlatch (Scene 07)
static func create_apartment_door_sound() -> AudioStreamWAV:
	var duration := 0.75
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sample := 0.0
		
		# Latch unlatch click at t=0.0..0.08s
		if t < 0.10:
			var latch_env := exp(-t * 50.0) if t >= 0.001 else (t / 0.001)
			var latch := sin(t * TAU * 1650.0) * 0.50 + sin(t * TAU * 2400.0) * 0.30
			sample += latch * latch_env * 0.60
		
		# Slow wooden door hinge creak (FM modulated friction 480 Hz -> 680 Hz) from t=0.05..0.70s
		if t >= 0.05:
			var t_creak := t - 0.05
			var creak_env := sin((t_creak / 0.65) * PI) * exp(-t_creak * 2.2)
			var mod_freq := 520.0 + sin(t_creak * TAU * 14.0) * 120.0
			var creak := sin(t_creak * TAU * mod_freq) * 0.45 + sin(t_creak * TAU * (mod_freq * 1.5)) * 0.20
			# Low wooden body rumble
			var body := sin(t_creak * TAU * 110.0) * 0.20 * creak_env
			sample += (creak + body) * creak_env * 0.65
		
		return clampf(sample, -1.0, 1.0)
	)


## Marta Kurek Dialogue Vocal Blip Sound: Warm matte 440 Hz tone with rich sub-harmonic warmth (Scene 07)
static func create_dialogue_marta_blip_sound() -> AudioStreamWAV:
	var duration := 0.075
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI)
		# 440.0 Hz A4 fundamental + 220.0 Hz warm sub + 880.0 Hz overtone
		var f0 := sin(t * TAU * 440.0) * 0.55
		var sub := sin(t * TAU * 220.0) * 0.30
		var overtone := sin(t * TAU * 880.0) * 0.15
		
		var raw := (f0 + sub + overtone) * env * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Staircase Timer Switch / Relay Snap Sound: Bimetallic switch snap + electromagnetic pulse (Scene 07)
static func create_stair_timer_switch_sound() -> AudioStreamWAV:
	var duration := 0.12
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 40.0) if t >= 0.001 else (t / 0.001)
		# High frequency mechanical snap (1250 Hz + 2800 Hz)
		var snap := sin(t * TAU * 1250.0) * 0.60 + sin(t * TAU * 2800.0) * 0.25
		# 50 Hz mains pulse from staircase lighting relay coil
		var coil_hum := sin(t * TAU * 50.0) * 0.35 * exp(-t * 22.0)
		
		var raw := (snap * env + coil_hum) * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Parquet / Wooden Floor Footstep Sound: Warm wooden resonance and subtle plank creak (Scene 08)
static func create_parquet_footstep_sound() -> AudioStreamWAV:
	var duration := 0.16
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 28.0) if t >= 0.002 else (t / 0.002)
		# Warm wooden body fundamental (190 Hz + 310 Hz)
		var body := sin(t * TAU * 190.0) * 0.50 + sin(t * TAU * 310.0) * 0.35
		# Wood grain friction & surface texture
		var grain := (sin(t * 6200.0) * cos(t * 3100.0)) * 0.12 * env
		# Subtle micro-creak at onset
		var creak := sin(t * TAU * 640.0) * 0.15 * exp(-t * 45.0)
		
		var raw := (body + grain + creak) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Mechanical Cipher Drawer Lock Unlatch Sound: Tumbler click + brass bolt slide + wooden drawer glide (Scene 08)
static func create_drawer_lock_unlatch_sound() -> AudioStreamWAV:
	var duration := 0.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sample := 0.0
		
		# Phase 1: Precision tumbler dial click (t=0.0..0.08s)
		if t < 0.08:
			var tumbler_env := exp(-t * 60.0) if t >= 0.001 else (t / 0.001)
			var tumbler := sin(t * TAU * 950.0) * 0.60 + sin(t * TAU * 2400.0) * 0.30
			sample += tumbler * tumbler_env * 0.65
		
		# Phase 2: Brass spring-loaded locking bolt release slide (t=0.06..0.22s)
		if t >= 0.06 and t < 0.24:
			var tb := (t - 0.06) / 0.18
			var bolt_env := sin(tb * PI) * exp(-tb * 3.5)
			var bolt_sweep := lerpf(1450.0, 820.0, tb)
			var bolt := sin((t - 0.06) * TAU * bolt_sweep) * 0.50 + (sin(t * 8800.0) * cos(t * 4400.0)) * 0.20
			sample += bolt * bolt_env * 0.55
		
		# Phase 3: Heavy wooden drawer glide friction along runners (t=0.15..0.40s)
		if t >= 0.15:
			var td := (t - 0.15) / 0.25
			var glide_env := sin(td * PI) * exp(-td * 2.0)
			var glide_rumble := sin((t - 0.15) * TAU * 220.0) * 0.40
			var wood_friction := (sin(t * 4800.0) * cos(t * 2400.0)) * 0.25
			sample += (glide_rumble + wood_friction) * glide_env * 0.45
		
		return clampf(sample, -1.0, 1.0)
	)


## Technical Paper / Calculation Sheets Rustle Sound: Multi-frequency paper texture flutter (Scene 08)
static func create_paper_rustle_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI) * exp(-t * 2.2)
		# Multi-band crisp paper friction flutter
		var flutter1 := sin(t * TAU * 1120.0) * (sin(t * 14500.0) * 0.5 + 0.5) * 0.35
		var flutter2 := sin(t * TAU * 2840.0) * (cos(t * 9600.0) * 0.5 + 0.5) * 0.25
		var air_noise := (sin(t * 18200.0) * cos(t * 9100.0)) * 0.35
		# Low page flip body transient
		var page_body := sin(t * TAU * 340.0) * 0.20 * exp(-t * 15.0)
		
		var raw := (flutter1 + flutter2 + air_noise + page_body) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Kettle Water Boil / Simmer Loop Sound: Gentle water bubbling and stove thermal hum (Scene 08)
static func create_kettle_boil_sound() -> AudioStreamWAV:
	var duration := 0.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Low bubble pulses (85 Hz + 140 Hz + 210 Hz)
		var bubble1 := sin(t * TAU * 85.0 + sin(t * TAU * 12.0) * 1.5) * 0.35
		var bubble2 := sin(t * TAU * 140.0 + cos(t * TAU * 18.0) * 1.2) * 0.25
		var bubble3 := sin(t * TAU * 210.0 + sin(t * TAU * 24.0) * 0.8) * 0.15
		# Simmering water hiss
		var hiss := (sin(t * 8400.0) * cos(t * 4200.0)) * 0.18
		
		var raw := (bubble1 + bubble2 + bubble3 + hiss) * 0.70
		return clampf(raw, -1.0, 1.0)
	)


## Kettle Steam Whistle Sound: Soft harmonic retro kettle whistle with steam micro-flutter (Scene 08)
static func create_kettle_whistle_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := minf(1.0, t / 0.08) * exp(-t * 1.8)
		# Dual harmonic steam whistle with 5.5 Hz vibrato flutter
		var vib := sin(t * TAU * 5.5) * 12.0
		var tone1 := sin(t * TAU * (1150.0 + vib)) * 0.55
		var tone2 := sin(t * TAU * (1380.0 + vib * 1.2)) * 0.30
		var steam_air := (sin(t * 12000.0) * cos(t * 6000.0)) * 0.15
		
		var raw := (tone1 + tone2 + steam_air) * env * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Ceramic Tile Footstep Sound: Mineral tap and glassy bathroom tile reverberation (Scene 09)
static func create_tile_footstep_sound() -> AudioStreamWAV:
	var duration := 0.18
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 22.0) if t >= 0.001 else (t / 0.001)
		# Mineral ceramic tile body (450 Hz + 780 Hz)
		var body := sin(t * TAU * 450.0) * 0.45 + sin(t * TAU * 780.0) * 0.35
		# Glassy tile glaze click transient in first 12ms
		var glaze := 0.0
		if t < 0.012:
			var gt := t / 0.012
			glaze = (1.0 - gt) * (sin(t * TAU * 3200.0) * 0.50 + (sin(t * 14200.0) - 0.5) * 0.30)
		# Damp bathroom acoustic room reflection resonance (1250 Hz)
		var room_reverb := sin(t * TAU * 1250.0) * 0.18 * exp(-t * 14.0)
		
		var raw := (body + glaze + room_reverb) * env * 0.85
		return tanh(raw) * 0.94
	)


## Water Pipe Hiss / Plumbing Resonance Sound: Pressurized flow in cast-iron & chrome pipes (Scene 09)
static func create_water_pipe_hiss_sound() -> AudioStreamWAV:
	var duration := 0.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Cast iron pipe metallic resonance (110 Hz + 320 Hz + 640 Hz)
		var pipe1 := sin(t * TAU * 110.0) * 0.35
		var pipe2 := sin(t * TAU * 320.0) * 0.25
		var pipe3 := sin(t * TAU * 640.0) * 0.15
		# Water turbulent flow noise modulated by gentle 3 Hz pipe pressure pulse
		var flow_mod := sin(t * TAU * 3.0) * 0.15 + 0.85
		var flow_noise := (sin(t * 7200.0) * cos(t * 3600.0)) * 0.25 * flow_mod
		
		var raw := (pipe1 + pipe2 + pipe3 + flow_noise) * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Glass Scratch Sound: Sharp stylus / razor blade scratching mirror silvering (Scene 09)
static func create_glass_scratch_sound() -> AudioStreamWAV:
	var duration := 0.38
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI) * exp(-t * 1.8)
		# Rapid chatter modulation representing microscopic glass fracture
		var chatter := sin(t * TAU * 85.0) * 120.0
		# Dual high frequency friction squeal (2400 Hz + 3800 Hz)
		var squeal1 := sin(t * TAU * (2400.0 + chatter)) * 0.45
		var squeal2 := sin(t * TAU * (3800.0 + chatter * 1.5)) * 0.35
		# Glass surface micro-friction noise
		var glass_grit := (sin(t * 16800.0) * cos(t * 8400.0)) * 0.20
		
		var raw := (squeal1 + squeal2 + glass_grit) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Mirror Shimmer Sound: Temporal lag phase dissonance (A5 880 Hz + B5 987 Hz with 0.4 Hz phase drift) (Scene 09)
static func create_mirror_shimmer_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := minf(1.0, t / 0.05) * (1.0 - t / dur)
		# 0.4 Hz phase drift beating between A5 (880 Hz) and B5 (987 Hz)
		var drift := sin(t * TAU * 0.4) * 0.3 + 0.7
		var tone_a := sin(t * TAU * 880.0) * 0.45
		var tone_b := sin(t * TAU * 987.0 + sin(t * TAU * 0.4) * 0.8) * 0.35 * drift
		# Cyan crystalline overtone (1760 Hz) and deep sub foundation (220 Hz)
		var overtone := sin(t * TAU * 1760.0) * 0.15
		var sub := sin(t * TAU * 220.0) * 0.20
		
		var raw := (tone_a + tone_b + overtone + sub) * env * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Bakelite Bell Sound: Mechanical dual brass gong telephone ringer (1020 Hz + 1240 Hz with 20 Hz clapper modulation) (Scene 10)
static func create_bakelite_bell_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.5) if t >= 0.002 else (t / 0.002)
		# Clapper rapid hammer oscillation (20 Hz AM tremolo)
		var clapper := 0.5 + 0.5 * sin(t * TAU * 20.0)
		var gong1 := sin(t * TAU * 1020.0) * 0.55
		var gong2 := sin(t * TAU * 1240.0) * 0.40
		var strike_transient := (sin(t * TAU * 3400.0) * 0.25) if t < 0.015 else 0.0
		var metallic_chime := sin(t * TAU * 2040.0) * 0.15 * exp(-progress * 6.0)
		var raw := ((gong1 + gong2) * clapper + strike_transient + metallic_chime) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Handset Pickup Sound: Mechanical telephone cradle switchhook release (850 Hz transient + 180 Hz body) (Scene 10)
static func create_handset_pickup_sound() -> AudioStreamWAV:
	var duration := 0.16
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 35.0) if t >= 0.001 else (t / 0.001)
		var hook_click := sin(t * TAU * 850.0) * 0.55 + sin(t * TAU * 1950.0) * 0.30
		var bakelite_body := sin(t * TAU * 180.0) * 0.45
		var spring_ping := sin(t * TAU * 2600.0) * exp(-t * 50.0) * 0.25
		var raw := (hook_click + bakelite_body + spring_ping) * env * 0.85
		return tanh(raw) * 0.94
	)


## Reel Tape Motor Hum Sound: Tape drive capstan motor hum (120 Hz) & tape scrape flutter (3200 Hz) (Scene 10)
static func create_tape_motor_hum_sound() -> AudioStreamWAV:
	var duration := 0.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var motor_hum := sin(t * TAU * 120.0) * 0.40 + sin(t * TAU * 240.0) * 0.20 + sin(t * TAU * 60.0) * 0.25
		var flutter_mod := sin(t * TAU * 8.5) * 0.2 + 0.8
		var tape_scrape := (sin(t * 12800.0) * cos(t * 6400.0)) * 0.18 * flutter_mod
		var head_resonance := sin(t * TAU * 3200.0) * 0.12 * flutter_mod
		var raw := (motor_hum + tape_scrape + head_resonance) * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Jakub Wolski Dialogue Vocal Blip Sound: Rough male voice in carbon microphone telephone handset (370 Hz with 185/740 Hz overtones) (Scene 10)
static func create_dialogue_jakub_blip_sound() -> AudioStreamWAV:
	var duration := 0.08
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI)
		# Jakub fundamental: 370.0 Hz (rough male baritone) + sub 185.0 Hz + telephone carbon harmonics
		var f0 := sin(t * TAU * 370.0) * 0.55
		var sub := sin(t * TAU * 185.0) * 0.25
		var harmonic1 := sin(t * TAU * 740.0) * 0.20
		var harmonic2 := sin(t * TAU * 1480.0) * 0.15
		# Carbon granule mic distortion / sibilance
		var carbon_grit := (sin(t * 9800.0) * cos(t * 4200.0)) * 0.12
		var raw := (f0 + sub + harmonic1 + harmonic2 + carbon_grit) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Morning Courtyard Ambience Sound: Cool morning breeze, mist and distant city rumble (80 Hz sub + 950 Hz wash) (Scene 11)
static func create_morning_ambience_sound() -> AudioStreamWAV:
	var duration := 1.00
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Distant city rumble (80 Hz with slow 0.5 Hz thermal breathing)
		var city_sub := sin(t * TAU * 80.0) * (0.8 + 0.2 * sin(t * TAU * 0.5)) * 0.35
		var sub2 := sin(t * TAU * 40.0) * 0.20
		
		# Cool morning wind wash filtered around 950 Hz
		var wind_mod := 0.7 + 0.3 * sin(t * TAU * 1.2)
		var wind := (sin(t * 950.0 * TAU) * cos(t * 475.0 * TAU)) * 0.25 * wind_mod
		var air_noise := (sin(t * 13400.0) * cos(t * 6700.0)) * 0.12 * wind_mod
		
		var raw := (city_sub + sub2 + wind + air_noise) * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## UCP Field Stabilizer Beam Sound: Quiet modulated resonance pulse of UCP field apparatus (330 Hz + 660 Hz with 4 Hz AM) (Scene 11)
static func create_ucp_stabilizer_beam_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI) * exp(-t * 0.8)
		# 4 Hz field pulse modulation
		var am := 0.65 + 0.35 * sin(t * TAU * 4.0)
		
		var f0 := sin(t * TAU * 330.0) * 0.55
		var f1 := sin(t * TAU * 660.0) * 0.30
		var f2 := sin(t * TAU * 990.0) * 0.15
		var crystal_shimmer := sin(t * TAU * 1980.0) * 0.08
		
		var raw := (f0 + f1 + f2 + crystal_shimmer) * am * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Masonry Smoothing Sound: Subtle mineral rustle of mortar seam fading and brick wall smoothing into solid plane (Scene 11)
static func create_masonry_smooth_sound() -> AudioStreamWAV:
	var duration := 0.55
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * exp(-progress * 1.5)
		
		# Downward frequency sweep from 1800 Hz down to 600 Hz representing mortar grain settling
		var f_sweep := lerpf(1800.0, 600.0, progress * progress)
		var mineral_tone := sin(t * TAU * f_sweep) * 0.40
		
		# Granular mortar / brick dust friction noise
		var grit_noise := (sin(t * 15600.0) * cos(t * 7800.0)) * 0.35 * (1.0 - progress * 0.5)
		var masonry_body := sin(t * TAU * 220.0) * 0.25 * progress
		
		var raw := (mineral_tone + grit_noise + masonry_body) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Elderly Resident Dialogue Blip Sound: Quiet, trembling elderly voice (480 Hz with 6 Hz vibrato) (Scene 11)
static func create_dialogue_elderly_woman_sound() -> AudioStreamWAV:
	var duration := 0.075
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI)
		# 6 Hz natural tremor / vibrato
		var trem := sin(t * TAU * 6.0) * 18.0
		var f0 := sin(t * TAU * (480.0 + trem)) * 0.55
		var sub := sin(t * TAU * (240.0 + trem * 0.5)) * 0.25
		var overtone := sin(t * TAU * (960.0 + trem * 2.0)) * 0.20
		
		var raw := (f0 + sub + overtone) * env * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Subterranean Metro / Traction Hum Sound: Distant deep tunnel rumble (55 Hz with 110 Hz concrete resonance) (Scene 12)
static func create_subway_hum_sound() -> AudioStreamWAV:
	var duration := 1.2
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Slow atmospheric breathing envelope
		var env := sin((t / dur) * PI) * 0.95
		
		# Low frequency ground wave (55 Hz base + 110 Hz harmonic)
		var sub := sin(t * TAU * 55.0) * 0.50
		var harmonic := sin(t * TAU * 110.0 + sin(t * TAU * 0.8) * 0.3) * 0.30
		var infra := sin(t * TAU * 27.5) * 0.25
		
		# Distant rail steel resonance / friction wash
		var rail_friction := (sin(t * 4200.0) * cos(t * 1800.0)) * 0.08
		
		var raw := (sub + harmonic + infra + rail_friction) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Neon Sign Flickering & Gas Hum Sound: 120 Hz ballast hum + 2800 Hz high frequency ionization sparkle (Scene 12)
static func create_neon_flicker_sound() -> AudioStreamWAV:
	var duration := 0.70
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := 0.85 + 0.15 * sin(t * TAU * 14.0)
		
		# 120 Hz AC line double-harmonic hum
		var hum := sin(t * TAU * 120.0) * 0.40 + sin(t * TAU * 240.0) * 0.25
		
		# High frequency tube ionization shimmer & micro-sparkles
		var gas_shimmer := sin(t * TAU * 2800.0 + sin(t * TAU * 60.0) * 2.0) * 0.20
		var arc_spikes := (sin(t * 16400.0) * cos(t * 8200.0)) * 0.15 * (1.0 if sin(t * 45.0) > 0.6 else 0.2)
		
		var raw := (hum + gas_shimmer + arc_spikes) * env * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Industrial CRT Terminal Keypress Sound: Crisp mechanical switch transient (980 Hz) + heavy chassis body (240 Hz) (Scene 12)
static func create_terminal_keypress_sound() -> AudioStreamWAV:
	var duration := 0.09
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := exp(-t * 55.0) if t >= 0.001 else (t / 0.001)
		
		# Mechanical click snap (980 Hz + 1960 Hz)
		var snap := sin(t * TAU * 980.0) * 0.60 + sin(t * TAU * 1960.0) * 0.25
		# Damped chassis body resonance (240 Hz)
		var body := sin(t * TAU * 240.0) * 0.35 * exp(-t * 28.0)
		
		var raw := (snap * env + body) * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Underground PA Chime Sound: Two-tone institutional reverberant gong (784 Hz G5 -> 587 Hz D5) (Scene 12)
static func create_pa_chime_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sample := 0.0
		
		# Tone 1: 784.0 Hz (G5) from t=0.0..0.35s
		if t < 0.40:
			var env1 := exp(-t * 9.0) if t >= 0.002 else (t / 0.002)
			var tone1 := sin(t * TAU * 784.0) * 0.60 + sin(t * TAU * 1568.0) * 0.20
			sample += tone1 * env1 * 0.70
		
		# Tone 2: 587.33 Hz (D5) from t=0.25..0.85s
		if t >= 0.25:
			var t2 := t - 0.25
			var env2 := exp(-t2 * 7.5) if t2 >= 0.002 else (t2 / 0.002)
			var tone2 := sin(t2 * TAU * 587.33) * 0.60 + sin(t2 * TAU * 1174.66) * 0.20
			sample += tone2 * env2 * 0.70
		
		# Subterranean tile echo reverb tail
		var tile_reverb := sin(t * TAU * 392.0) * 0.12 * exp(-t * 4.0)
		sample += tile_reverb
		
		return clampf(sample, -1.0, 1.0)
	)


## Drafting Lamp Hum Sound: Quiet transformer ballast hum (60 Hz + 120 Hz) with warm incandescent filament body (420 Hz) (Scene 13)
static func create_drafting_lamp_hum_sound() -> AudioStreamWAV:
	var duration := 0.90
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI) * 0.92
		
		# 60 Hz fundamental line hum + 120 Hz octave
		var hum := sin(t * TAU * 60.0) * 0.45 + sin(t * TAU * 120.0) * 0.28
		
		# 420 Hz warm acoustic body resonance with subtle thermal flutter
		var warm_tone := sin(t * TAU * 420.0 + sin(t * TAU * 2.5) * 0.4) * 0.25
		
		# High frequency tube filament hiss
		var filament_shimmer := (sin(t * 7800.0) * cos(t * 3600.0)) * 0.06
		
		var raw := (hum + warm_tone + filament_shimmer) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Photograph Slide Sound: Crisp paper friction transient (1450 Hz / 3100 Hz) into metal mounting frame (Scene 13)
static func create_photo_slide_sound() -> AudioStreamWAV:
	var duration := 0.32
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		# Double-phase envelope: initial slide friction (0..0.22s) + frame seat click (0.22..0.32s)
		var env := exp(-t * 12.0) if t >= 0.003 else (t / 0.003)
		
		# Multi-frequency fibrous paper texture (1450 Hz & 3100 Hz)
		var paper_friction := (sin(t * TAU * 1450.0 + sin(t * 850.0)) * 0.45 + sin(t * TAU * 3100.0) * 0.30)
		
		# Frame seat latch at t=0.22s
		var seat_click := 0.0
		if t >= 0.20:
			var t_seat := t - 0.20
			var env_seat := exp(-t_seat * 45.0) if t_seat >= 0.001 else (t_seat / 0.001)
			seat_click = (sin(t_seat * TAU * 1850.0) * 0.55 + sin(t_seat * TAU * 820.0) * 0.35) * env_seat
		
		var raw := (paper_friction * env * 0.65 + seat_click * 0.80)
		return clampf(raw, -1.0, 1.0)
	)


## Shadow Whisper Sound: Eerie temporal emergence on photographic emulsion (880 Hz tone with 3.5 Hz phase modulation) (Scene 13)
static func create_shadow_whisper_sound() -> AudioStreamWAV:
	var duration := 1.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Swelling and undulating envelope
		var env := sin((t / dur) * PI)
		env = pow(env, 0.8) # broader bell curve
		
		# Core 880 Hz tone (A5) with slow 3.5 Hz phase tremor / subtle pitch drift
		var phase_mod := sin(t * TAU * 3.5) * 0.8
		var f0 := 880.0 + phase_mod * 12.0
		var tone_core := sin(t * TAU * f0) * 0.40
		
		# Subharmonic dark resonance (440 Hz / 220 Hz)
		var tone_dark := sin(t * TAU * 440.0) * 0.25 + sin(t * TAU * 220.0 + sin(t * 1.8)) * 0.20
		
		# High frequency silver-halide crystal whisper / dark emulsion rustle
		var halide_whisper := (sin(t * 12400.0) * cos(t * 4800.0)) * 0.12 * (0.5 + 0.5 * sin(t * TAU * 7.0))
		
		var raw := (tone_core + tone_dark + halide_whisper) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Relay Alignment Click Sound: Precise multi-pole stepping relay sync click (1120 Hz snap + 340 Hz coil echo) (Scene 13)
static func create_relay_alignment_click_sound() -> AudioStreamWAV:
	var duration := 0.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Sharp magnetic strike
		var env_snap := exp(-t * 60.0) if t >= 0.001 else (t / 0.001)
		var snap := sin(t * TAU * 1120.0) * 0.65 + sin(t * TAU * 2240.0) * 0.30
		
		# 340 Hz electromagnetic coil damping ringing
		var env_coil := exp(-t * 22.0)
		var coil := sin(t * TAU * 340.0) * 0.35 * env_coil
		
		# Micro contact bounce at t = 0.018s
		var bounce := 0.0
		if t >= 0.018 and t < 0.05:
			var tb := t - 0.018
			bounce = sin(tb * TAU * 1680.0) * exp(-tb * 80.0) * 0.30
		
		var raw := (snap * env_snap + coil + bounce) * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Metal Scratch Chime Sound: Resonant structural metallic tone with micro-friction of the scratch (740 Hz + 1480 Hz cyan decay) (Scene 14)
static func create_metal_scratch_chime_sound() -> AudioStreamWAV:
	var duration := 0.48
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		# Crisp attack with long pure resonance
		var env := exp(-progress * 5.2) if t >= 0.002 else (t / 0.002)
		
		# 740 Hz fundamental (F#5) with octave 1480 Hz harmonic
		var f0 := 740.0
		var f1 := 1480.0
		var tone_pure := sin(t * TAU * f0) * 0.70 + sin(t * TAU * f1) * 0.30
		
		# Scratch micro-friction transient at onset (2400 Hz / 3800 Hz)
		var scratch := 0.0
		if t < 0.025:
			var st := t / 0.025
			scratch = (1.0 - st) * (sin(t * TAU * 2400.0) * 0.50 + (sin(t * 15800.0) * cos(t * 7200.0)) * 0.35)
		
		# Subtle cyan micro-phase drift
		var phase_drift := sin(t * TAU * 1.5) * 0.1
		var tone := sin(t * TAU * f0 + phase_drift) * 0.65 + sin(t * TAU * f1) * 0.25
		
		var raw := (tone * 0.75 + scratch * 0.35) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Tape Degradation Filter Sound: Degraded magnetic tape playback with muffled voice warmth, flutter and loss of highs (Scene 14)
static func create_tape_degradation_filter_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		# Bell envelope with smooth tape fade
		var env := sin(progress * PI)
		env = pow(env, 0.7)
		
		# Voice warmth band (240 Hz fundamental / 480 Hz formant)
		var voice_f0 := 240.0 + sin(t * TAU * 4.5) * 6.0
		var voice := sin(t * TAU * voice_f0) * 0.45 + sin(t * TAU * (voice_f0 * 2.0)) * 0.25
		
		# Wow & flutter (12 Hz speed instability)
		var flutter := sin(t * TAU * 12.0) * 0.15
		
		# Low-pass filtered magnetic tape grain (1800 Hz cutoff effect)
		var tape_grain := (sin(t * 4200.0) * cos(t * 1800.0)) * 0.15 * (1.0 - progress * 0.4)
		
		# Muffled high frequency loss (exponential dampening of higher alikwots)
		var raw := (voice + flutter + tape_grain) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Seam Clamp Sound: Heavy mechanical clamp of hydraulic seam stabilizer (280/840 Hz with metallic impact) (Scene 14)
static func create_seam_clamp_sound() -> AudioStreamWAV:
	var duration := 0.36
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Multi-stage envelope: hydraulic pressure build (0..0.04s) + solid lock strike (0.04..0.36s)
		var raw := 0.0
		if t < 0.04:
			# Hydraulic pressure build
			var pt := t / 0.04
			raw = sin(t * TAU * 180.0) * pt * 0.60
		else:
			# Heavy steel clamp impact
			var st := t - 0.04
			var env_lock := exp(-st * 24.0) if st >= 0.001 else (st / 0.001)
			var f_body := sin(st * TAU * 280.0) * 0.60
			var f_ring := sin(st * TAU * 840.0) * 0.35
			var f_latch := sin(st * TAU * 1650.0) * 0.20 * exp(-st * 60.0)
			raw = (f_body + f_ring + f_latch) * env_lock * 0.95
		
		return clampf(raw, -1.0, 1.0)
	)


## Conduit Shaft Wind Sound: Atmospheric airflow rush in vertical substructure shaft (45/90 Hz with 1600 Hz whistle) (Scene 14)
static func create_conduit_shaft_wind_sound() -> AudioStreamWAV:
	var duration := 1.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		# Smooth continuous wind swell envelope
		var env := sin(progress * PI)
		env = pow(env, 0.6)
		
		# Deep shaft sub-bass resonance (45 Hz fundamental + 90 Hz hollow body)
		var sub := sin(t * TAU * 45.0 + sin(t * TAU * 0.8) * 0.5) * 0.50
		var hollow := sin(t * TAU * 90.0) * 0.30
		
		# Shaft aerodynamic cavity whistle (1600 Hz with slow pressure modulation)
		var whistle_f := 1600.0 + sin(t * TAU * 2.2) * 80.0
		var whistle := sin(t * TAU * whistle_f) * 0.12
		
		# Broad filtered airflow turbulence
		var airflow := (sin(t * 3200.0) * cos(t * 1400.0)) * 0.18
		
		var raw := (sub + hollow + whistle + airflow) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Catwalk Footstep Sound: Metallic impact and ring of industrial open-steel grating / catwalk (Scene 15)
static func create_catwalk_footstep_sound() -> AudioStreamWAV:
	var duration := 0.22
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Fast percussive attack (0.002s) with ringing truss resonance
		var env := exp(-t * 26.0) if t >= 0.002 else (t / 0.002)
		
		# Fundamental grating clang (620 Hz) and high metallic ring (1440 Hz / 2880 Hz)
		var f0 := sin(t * TAU * 620.0) * 0.55
		var f1 := sin(t * TAU * 1440.0) * 0.30 * exp(-t * 35.0)
		var f2 := sin(t * TAU * 2880.0) * 0.15 * exp(-t * 50.0)
		
		# Footstep heel strike transient
		var transient := (sin(t * 7800.0) * cos(t * 3200.0)) * 0.25 * exp(-t * 80.0)
		
		var raw := (f0 + f1 + f2 + transient) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Water Drip Puddle Sound: Percussive droplet impact falling into shallow technical puddle (Scene 15)
static func create_water_drip_puddle_sound() -> AudioStreamWAV:
	var duration := 0.32
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Rapid ascending frequency droplet pitch (bubble compression)
		var drop_env := exp(-t * 22.0) if t >= 0.003 else (t / 0.003)
		var freq := lerpf(1150.0, 2300.0, minf(1.0, t / 0.04))
		var drop_tone := sin(t * TAU * freq) * 0.70
		
		# Secondary water surface ring / ripple resonance (580 Hz)
		var ripple := sin(t * TAU * 580.0) * 0.25 * exp(-t * 12.0)
		
		# Micro-splash transient at impact
		var splash := (sin(t * 9200.0) * cos(t * 4600.0)) * 0.20 * exp(-t * 60.0)
		
		var raw := (drop_tone + ripple + splash) * drop_env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Pressure Valve Release Sound: Hissing steam/gas decompression with latch mechanical snap (Scene 15)
static func create_pressure_valve_release_sound() -> AudioStreamWAV:
	var duration := 1.25
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		# Multi-stage envelope: mechanical latch pop at t < 0.03s + turbulent steam exhaust
		var raw := 0.0
		if t < 0.03:
			# Valve latch trigger snap
			var lt := t / 0.03
			raw = (sin(t * TAU * 950.0) * 0.5 + sin(t * TAU * 2400.0) * 0.4) * (1.0 - lt)
		
		# Steam noise hiss (shaped bandpass filter 800..4200 Hz)
		var steam_env := exp(-progress * 2.8) if progress >= 0.05 else (progress / 0.05)
		var hiss := (sin(t * 4200.0) * cos(t * 1850.0) * sin(t * 880.0)) * 0.75
		var low_whoosh := sin(t * TAU * 160.0) * 0.25
		
		raw += (hiss + low_whoosh) * steam_env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Resonance Pulse Sound: Low electromagnetic transmission conduit hum with beating (Scene 15)
static func create_resonance_pulse_sound() -> AudioStreamWAV:
	var duration := 1.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		env = pow(env, 0.5)
		
		# 52 Hz fundamental with 3 Hz beating oscillation (52 Hz and 55 Hz)
		var f0 := 52.0
		var f_beat := 55.0
		var sub := (sin(t * TAU * f0) * 0.55 + sin(t * TAU * f_beat) * 0.35)
		
		# First harmonic with subtle phase rotation
		var f_harm := sin(t * TAU * 104.0) * 0.20
		
		# Conduit metal casing shimmer
		var shimmer := sin(t * TAU * 740.0) * 0.08 * (sin(t * TAU * 6.0) * 0.5 + 0.5)
		
		var raw := (sub + f_harm + shimmer) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Ceramic Cup Clink Sound: Porcelain cup tapping against saucer with crystalline ringing (Scene 16)
static func create_ceramic_cup_clink_sound() -> AudioStreamWAV:
	var duration := 0.38
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Rapid 2ms impact attack with crystalline exponential decay
		var env := exp(-t * 16.0) if t >= 0.002 else (t / 0.002)
		
		# Porcelain harmonics (1450 Hz fundamental, 2900 Hz octave, 4350 Hz glassy overtone)
		var f0 := 1450.0
		var ring := sin(t * TAU * f0) * 0.60 + sin(t * TAU * (f0 * 2.0)) * 0.30 + sin(t * TAU * (f0 * 3.0)) * 0.15
		
		# Ceramic cup body resonance (720 Hz)
		var body := sin(t * TAU * 720.0) * 0.25 * exp(-t * 24.0)
		
		# Sharp contact tap transient
		var tap := 0.0
		if t < 0.008:
			var tt := t / 0.008
			tap = (1.0 - tt) * (sin(t * TAU * 3600.0) * 0.4 + (sin(t * 7800.0) - 0.5) * 0.3)
		
		var raw := (ring * 0.65 + body * 0.20 + tap * 0.15) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Tea Pour Steam Sound: Gentle boiling water stream and rising steam breath (Scene 16)
static func create_tea_pour_steam_sound() -> AudioStreamWAV:
	var duration := 1.15
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		env = pow(env, 0.7)
		
		# Liquid stream bubbling texture (350..950 Hz modulated band)
		var liquid_f := lerpf(420.0, 780.0, sin(t * 18.0) * 0.5 + 0.5)
		var liquid := sin(t * TAU * liquid_f) * sin(t * TAU * 38.0) * 0.45
		
		# Micro droplet bubbling
		var bubble := (sin(t * 1850.0) * cos(t * 920.0)) * 0.30
		
		# Soft steam breath noise (1200..3200 Hz filtered hiss)
		var steam := (sin(t * 3200.0) * cos(t * 1600.0) * sin(t * 800.0)) * 0.35
		
		var raw := (liquid + bubble + steam) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Kitchen Clock Tick Sound: Mechanical escapement tick with wooden clock housing (Scene 16)
static func create_kitchen_clock_tick_sound() -> AudioStreamWAV:
	var duration := 0.24
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var raw := 0.0
		# Primary tick escapement snap at t < 0.04s (820 Hz transient)
		if t < 0.04:
			var t1 := t / 0.04
			var snap := (1.0 - t1) * (sin(t * TAU * 820.0) * 0.70 + sin(t * TAU * 1640.0) * 0.30)
			raw += snap * 0.75
		
		# Secondary recoil "tock" latch at t = 0.045..0.09s (640 Hz)
		if t >= 0.045 and t < 0.09:
			var t2 := (t - 0.045) / 0.045
			var tock := (1.0 - t2) * sin((t - 0.045) * TAU * 640.0) * 0.55
			raw += tock * 0.60
		
		# Wooden case resonance (210 Hz damped thump)
		var wood_env := exp(-t * 28.0)
		var wood := sin(t * TAU * 210.0) * 0.35 * wood_env
		raw += wood
		
		return clampf(raw * 0.85, -1.0, 1.0)
	)


## Dossier Paper Turn Sound: Shuffling case dossier papers and thick folder cardboard (Scene 16)
static func create_dossier_paper_turn_sound() -> AudioStreamWAV:
	var duration := 0.48
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.2) if progress >= 0.08 else (progress / 0.08)
		
		# Fibrous paper rubbing texture (700..3400 Hz noise modulation)
		var paper_grain := (sin(t * 3400.0) * cos(t * 1700.0) * sin(t * 850.0)) * 0.55
		
		# Heavy folder cardboard crease / page flip impulse around t = 0.12s
		var flip_impulse := 0.0
		if t >= 0.08 and t < 0.20:
			var ft := (t - 0.08) / 0.12
			flip_impulse = sin(ft * PI) * (sin(t * TAU * 480.0) * 0.45 + sin(t * TAU * 960.0) * 0.25)
		
		var raw := (paper_grain * 0.65 + flip_impulse * 0.45) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Ticket Dispenser Sound: Mechanical paper feed and perforation tear-off (960/1920 Hz transient with paper friction) (Scene 17)
static func create_dispenser_ticket_sound() -> AudioStreamWAV:
	var duration := 0.42
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var raw := 0.0
		# Roller stepper motor feed (t = 0..0.22s)
		if t < 0.22:
			var ft := t / 0.22
			var stepper := (sin(t * TAU * 360.0) * 0.45 + sin(t * TAU * 720.0) * 0.25)
			var roller_friction := (sin(t * 4800.0) * cos(t * 2400.0)) * 0.20
			raw += (stepper + roller_friction) * sin(ft * PI) * 0.70
		
		# Paper perforation tear / guillotine cutter snap at t = 0.20..0.42s
		if t >= 0.18:
			var ct := t - 0.18
			var cut_env := exp(-ct * 35.0) if ct >= 0.001 else (ct / 0.001)
			var cut_snap := sin(ct * TAU * 960.0) * 0.60 + sin(ct * TAU * 1920.0) * 0.35
			var paper_rip := (sin(ct * 6400.0) * cos(ct * 3200.0)) * 0.30 * exp(-ct * 20.0)
			raw += (cut_snap + paper_rip) * cut_env * 0.85
		
		return clampf(raw, -1.0, 1.0)
	)


## Clinic Intercom Chime Sound: Institutional 3-tone calling chime (F5 698.46 Hz -> A5 880.0 Hz -> C6 1046.5 Hz) (Scene 17)
static func create_clinic_intercom_chime_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var sample := 0.0
		
		# Tone 1: 698.46 Hz (F5) from t = 0.00..0.35s
		if t < 0.45:
			var env1 := exp(-t * 8.5) if t >= 0.002 else (t / 0.002)
			var tone1 := sin(t * TAU * 698.46) * 0.65 + sin(t * TAU * 1396.92) * 0.20
			sample += tone1 * env1 * 0.65
		
		# Tone 2: 880.0 Hz (A5) from t = 0.24..0.65s
		if t >= 0.24 and t < 0.75:
			var t2 := t - 0.24
			var env2 := exp(-t2 * 8.0) if t2 >= 0.002 else (t2 / 0.002)
			var tone2 := sin(t2 * TAU * 880.0) * 0.65 + sin(t2 * TAU * 1760.0) * 0.20
			sample += tone2 * env2 * 0.65
		
		# Tone 3: 1046.5 Hz (C6) from t = 0.48..1.10s
		if t >= 0.48:
			var t3 := t - 0.48
			var env3 := exp(-t3 * 6.5) if t3 >= 0.002 else (t3 / 0.002)
			var tone3 := sin(t3 * TAU * 1046.5) * 0.70 + sin(t3 * TAU * 2093.0) * 0.25
			sample += tone3 * env3 * 0.70
		
		# Institutional ceramic tile hall reverberation tail
		var hall_reverb := sin(t * TAU * 523.25) * 0.10 * exp(-t * 3.5)
		sample += hall_reverb
		
		return clampf(sample, -1.0, 1.0)
	)


## Pneumatic Tube Whoosh Sound: Aerodynamic suction surge and brass capsule arrival latch (280..1800 Hz) (Scene 17)
static func create_pneumatic_tube_whoosh_sound() -> AudioStreamWAV:
	var duration := 1.35
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var raw := 0.0
		
		# Suction vacuum build & transit whoosh (t = 0..0.85s)
		if t < 0.95:
			var whoosh_env := sin((t / 0.95) * PI)
			whoosh_env = pow(whoosh_env, 0.7)
			var vacuum_sub := sin(t * TAU * 120.0 + sin(t * TAU * 4.0) * 0.4) * 0.45
			var air_whoosh := (sin(t * 2800.0) * cos(t * 1200.0)) * 0.35 * (0.6 + 0.4 * sin(t * TAU * 14.0))
			raw += (vacuum_sub + air_whoosh) * whoosh_env * 0.75
		
		# Brass carrier capsule arrival impact & latch seal at t = 0.82..1.35s
		if t >= 0.82:
			var at := t - 0.82
			var env_latch := exp(-at * 26.0) if at >= 0.001 else (at / 0.001)
			var brass_ring := sin(at * TAU * 820.0) * 0.55 + sin(at * TAU * 1640.0) * 0.30
			var damper_thump := sin(at * TAU * 180.0) * 0.40 * exp(-at * 40.0)
			var seal_hiss := (sin(at * 4800.0) * cos(at * 2400.0)) * 0.25 * exp(-at * 15.0)
			raw += (brass_ring + damper_thump + seal_hiss) * env_latch * 0.90
		
		return tanh(raw) * 0.94
	)


## Wierzbicka Diagnostic Printer Sound: Dot-matrix / needle diagnostic printer tracking sensory responses (720/1440 Hz transient with 18 steps/s cadence) (Scene 17)
static func create_wierzbicka_printer_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 1.5) if progress >= 0.02 else (progress / 0.02)
		
		# 18 needle pin impact strikes per second
		var strike_phase := fmod(t * 18.0, 1.0)
		var strike_env := exp(-strike_phase * 45.0) if strike_phase >= 0.02 else (strike_phase / 0.02)
		var needle_tone := sin(t * TAU * 720.0) * 0.60 + sin(t * TAU * 1440.0) * 0.35
		var needle_transient := (sin(t * 5600.0) * cos(t * 2800.0)) * 0.30
		
		# Stepper motor carriage lateral advance (110 Hz buzz)
		var carriage_buzz := sin(t * TAU * 110.0) * 0.20
		
		var raw := (needle_tone * strike_env * 0.75 + needle_transient * strike_env * 0.35 + carriage_buzz) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Sensory Galvanometer Tick Sound: micro-impulse of the sensory galvanometer recording Lena's lie (1650 Hz impulse with 380 Hz damping) (Scene 18)
static func create_sensory_galvanometer_tick_sound() -> AudioStreamWAV:
	var duration := 0.18
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 28.0) if progress >= 0.005 else (progress / 0.005)
		var tick := sin(t * TAU * 1650.0) * 0.70
		var damp_env := exp(-t * 48.0)
		var body := sin(t * TAU * 380.0) * 0.35 * damp_env
		var click := 0.0
		if t < 0.008:
			click = (1.0 - t / 0.008) * sin(t * TAU * 3200.0) * 0.25
		return clampf((tick * env + body + click) * 0.80, -1.0, 1.0)
	)


## Substructure Strain Groan Sound: deep metallic groan of structural tension in Podstruktura (34/68 Hz sub-bass with 220 Hz cast iron resonance) (Scene 18)
static func create_substructure_strain_groan_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := smoothstep(0.0, 0.3, progress) * (1.0 - smoothstep(0.65, 1.0, progress))
		var sub := sin(t * TAU * 34.0) * 0.55 + sin(t * TAU * 68.0) * 0.30
		var iron := sin(t * TAU * 220.0) * 0.20 * exp(-t * 0.8)
		var creak_mod := sin(t * TAU * 1.3) * 0.5 + 0.5
		var creak := sin(t * TAU * 560.0) * 0.12 * creak_mod
		return clampf((sub + iron + creak) * env * 0.78, -1.0, 1.0)
	)


## Map Node Pulse Sound: crystalline illumination tone of sensory memory map node (880 Hz A5 with cyan modulation) (Scene 18)
static func create_map_node_pulse_sound() -> AudioStreamWAV:
	var duration := 0.55
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := (1.0 - exp(-t * 35.0)) * exp(-progress * 5.5)
		var chime := sin(t * TAU * 880.0) * 0.65 + sin(t * TAU * 1760.0) * 0.25
		var cyan_mod := sin(t * TAU * 2.8) * 0.15 + 0.85
		chime *= cyan_mod
		var click := 0.0
		if t < 0.006:
			click = (1.0 - t / 0.006) * sin(t * TAU * 4200.0) * 0.20
		return clampf((chime + click) * env * 0.82, -1.0, 1.0)
	)


## Wierzbicka Stamp Sound: mechanical compliance approval stamp (massive snap 420 Hz with impact 1200 Hz) (Scene 18)
static func create_wierzbicka_stamp_sound() -> AudioStreamWAV:
	var duration := 0.35
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var impact_env := exp(-t * 22.0) if t >= 0.003 else (t / 0.003)
		var stamp_body := sin(t * TAU * 420.0) * 0.70 * impact_env
		var snap_env := exp(-t * 65.0) if t >= 0.001 else (t / 0.001)
		var snap := sin(t * TAU * 1200.0) * 0.45 * snap_env
		var thud := 0.0
		if t < 0.025:
			thud = sin(t * TAU * 90.0) * 0.35 * exp(-t * 120.0)
		var tail_env := exp(-progress * 12.0) * (1.0 - exp(-t * 50.0))
		var ink_pad := sin(t * TAU * 280.0) * 0.18 * tail_env
		return clampf((stamp_body + snap + thud + ink_pad) * 0.85, -1.0, 1.0)
	)


## Model Table Resonance Sound: 528 Hz crystalline resonance with dual beating frequencies and cyan shimmer (Scene 19)
static func create_model_table_resonance_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.8) * (1.0 - exp(-t * 80.0))
		var f1 := 528.0 # C5 Solfeggio / crystalline model frequency
		var f2 := 532.0 # 4 Hz slow acoustic beat representing two equivalent models
		var tone := sin(t * TAU * f1) * 0.55 + sin(t * TAU * f2) * 0.45
		var harmonic := sin(t * TAU * (f1 * 2.0)) * 0.20 * exp(-progress * 5.0)
		var shimmer := sin(t * TAU * 3.2) * 0.12 + 0.88
		var glass_click := 0.0
		if t < 0.008:
			glass_click = (1.0 - t / 0.008) * sin(t * TAU * 3800.0) * 0.25
		return clampf((tone * shimmer + harmonic + glass_click) * env * 0.80, -1.0, 1.0)
	)


## Paper Map Rustle Sound: architectural schematic map handling (900..3600 Hz cardboard/paper friction) (Scene 19)
static func create_paper_map_rustle_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		var noise := sin(t * 18453.7) * 0.35 + sin(t * 31415.9) * 0.30 + sin(t * 7421.3) * 0.35
		var fiber_friction := sin(t * TAU * 1450.0) * 0.30 + sin(t * TAU * 2850.0) * 0.25
		var snap := 0.0
		if t >= 0.08 and t <= 0.11:
			var st := (t - 0.08) / 0.03
			snap = sin(st * PI) * sin(t * TAU * 3400.0) * 0.30
		return clampf((noise * 0.45 + fiber_friction * 0.35 + snap) * env * 0.78, -1.0, 1.0)
	)


## Ledger Page Turn Sound: turning page in 11-person dossier (700..2800 Hz friction + 440 Hz fold snap) (Scene 19)
static func create_ledger_page_turn_sound() -> AudioStreamWAV:
	var duration := 0.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.2) * (1.0 - exp(-t * 50.0))
		var scrape := (sin(t * 12345.6) * 0.4 + sin(t * 23456.7) * 0.3 + sin(t * 34567.8) * 0.3) * 0.40
		var paper_body := sin(t * TAU * 880.0) * 0.25 + sin(t * TAU * 1760.0) * 0.15
		var fold_snap := 0.0
		if t >= 0.04 and t <= 0.07:
			var ft := (t - 0.04) / 0.03
			fold_snap = sin(ft * PI) * sin(t * TAU * 440.0) * 0.45
		return clampf((scrape + paper_body + fold_snap) * env * 0.82, -1.0, 1.0)
	)


## Model Room Door Release Sound: heavy locking bolt release toward Space 20 (680 Hz bolt slide + 1340 Hz latch snap) (Scene 19)
static func create_model_room_door_release_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.5) * (1.0 - exp(-t * 60.0))
		var bolt_slide := sin(t * TAU * 680.0) * 0.45 * exp(-t * 12.0)
		var latch_snap := 0.0
		if t >= 0.05 and t <= 0.08:
			var lt := (t - 0.05) / 0.03
			latch_snap = sin(lt * PI) * sin(t * TAU * 1340.0) * 0.55
		var motor_hum := sin(t * TAU * 120.0) * 0.20 * (1.0 - progress)
		var air_bleed := (sin(t * 15321.4) * 0.5 + sin(t * 27654.1) * 0.5) * 0.18 * exp(-progress * 6.0)
		return clampf((bolt_slide + latch_snap + motor_hum + air_bleed) * env * 0.85, -1.0, 1.0)
	)


## Crayon Drawing Rustle Sound: rough drawing paper friction with wax crayon strokes (600..2400 Hz) (Scene 20)
static func create_crayon_drawing_rustle_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 50.0))
		var wax_friction := (sin(t * 16342.1) * 0.35 + sin(t * 28911.3) * 0.35 + sin(t * 8123.5) * 0.30) * 0.40
		var paper_body := sin(t * TAU * 720.0) * 0.25 + sin(t * TAU * 1440.0) * 0.20
		var crayon_stroke := sin(t * TAU * 1850.0) * 0.22 * sin(t * TAU * 14.0)
		var erase_rub := 0.0
		if t >= 0.12 and t <= 0.25:
			var et := (t - 0.12) / 0.13
			erase_rub = sin(et * PI) * (sin(t * TAU * 1100.0) * 0.25 + sin(t * 31200.0) * 0.15)
		return clampf((wax_friction + paper_body + crayon_stroke + erase_rub) * env * 0.80, -1.0, 1.0)
	)


## Well Water Drip Sound: muffled acoustic resonance of deep well drip with cavernous echo (160 Hz + 480 Hz) (Scene 20)
static func create_well_water_drip_sound() -> AudioStreamWAV:
	var duration := 0.75
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var impact_env := exp(-t * 45.0) if t >= 0.002 else (t / 0.002)
		var drip_pitch := 1250.0 - t * 450.0
		var drip_impulse := sin(t * TAU * drip_pitch) * 0.65 * impact_env
		var well_cavity_env := exp(-progress * 3.5) * (1.0 - exp(-t * 20.0))
		var sub_water := sin(t * TAU * 160.0) * 0.45 * well_cavity_env
		var echo_tone := sin(t * TAU * 480.0) * 0.28 * exp(-progress * 4.2) * (sin(t * TAU * 6.5) * 0.2 + 0.8)
		var ripple := 0.0
		if t >= 0.08:
			var rt := t - 0.08
			ripple = sin(rt * TAU * 820.0) * 0.20 * exp(-rt * 18.0)
		return clampf((drip_impulse + sub_water + echo_tone + ripple) * 0.82, -1.0, 1.0)
	)


## Szymon Dialogue Blip Sound: fragile, elderly tremolo voice timbre (260 Hz with 3.5 Hz micro-tremor) (Scene 20)
static func create_szymon_dialogue_blip_sound() -> AudioStreamWAV:
	var duration := 0.09
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI)
		var f0 := 260.0 # Elderly male foundational pitch
		var tremolo := sin(t * TAU * 3.5) * 0.18 + 0.82
		var body := sin(t * TAU * f0) * 0.60 * tremolo
		var h1 := sin(t * TAU * (f0 * 2.0)) * 0.25 # 520 Hz chest formant
		var h2 := sin(t * TAU * (f0 * 3.0)) * 0.12 # 780 Hz throat formant
		var breath := (sin(t * 19283.4) * 0.5 + sin(t * 9843.2) * 0.5) * 0.08
		return clampf((body + h1 + h2 + breath) * env * 0.76, -1.0, 1.0)
	)


## Door Creak Shift Sound: quiet structural door frame lateral displacement (220/440 Hz iron friction) (Scene 20)
static func create_door_creak_shift_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		var iron_groan := sin(t * TAU * 220.0) * 0.40 + sin(t * TAU * 440.0) * 0.25
		var friction_screech := sin(t * TAU * (850.0 + sin(t * TAU * 8.0) * 120.0)) * 0.25
		var structural_pop := 0.0
		if t >= 0.20 and t <= 0.24:
			var pt := (t - 0.20) / 0.04
			structural_pop = sin(pt * PI) * sin(t * TAU * 180.0) * 0.45
		var wall_scrape := (sin(t * 14210.5) * 0.5 + sin(t * 22100.2) * 0.5) * 0.15
		return clampf((iron_groan + friction_screech + structural_pop + wall_scrape) * env * 0.85, -1.0, 1.0)
	)


## Anesthetic Hum Sound: low hum of UCP sedation wave (110 Hz with lowpass filtering and 2 Hz modulation) (Scene 21)
static func create_anesthetic_hum_sound() -> AudioStreamWAV:
	var duration := 1.2
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var mod := sin(t * TAU * 2.0) * 0.15 + 0.85
		var sub := sin(t * TAU * 110.0) * 0.55 * mod
		var harmonic := sin(t * TAU * 220.0) * 0.22 * (sin(t * TAU * 1.0) * 0.1 + 0.9)
		var whisper := (sin(t * 14120.3) * 0.5 + sin(t * 26180.7) * 0.5) * 0.08 * (sin(t * TAU * 0.5) * 0.5 + 0.5)
		return clampf((sub + harmonic + whisper) * env * 0.80, -1.0, 1.0)
	)


## Sedation Monitor Blip Sound: soft, muffled vital monitor beep (520 Hz with smooth decay) (Scene 21)
static func create_sedation_monitor_blip_sound() -> AudioStreamWAV:
	var duration := 0.22
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 7.5) * (1.0 - exp(-t * 100.0))
		var tone := sin(t * TAU * 520.0) * 0.70
		var overtone := sin(t * TAU * 1040.0) * 0.18
		var low_body := sin(t * TAU * 260.0) * 0.15
		return clampf((tone + overtone + low_body) * env * 0.75, -1.0, 1.0)
	)


## Erased Name Glitch Sound: asynchronous filter stripping voice formant upon attempt to speak erased name (800..2000 Hz noise with notch) (Scene 21)
static func create_erased_name_glitch_sound() -> AudioStreamWAV:
	var duration := 0.48
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		var band_noise := (sin(t * 18450.2) * 0.4 + sin(t * 31250.6) * 0.35 + sin(t * 9420.1) * 0.25) * 0.45
		var glitch_tone := sin(t * TAU * (1200.0 + sin(t * TAU * 35.0) * 450.0)) * 0.35
		var notch_pulse := sin(t * TAU * 60.0) * 0.20
		var vocal_struggle := 0.0
		if t >= 0.10 and t <= 0.30:
			var vt := (t - 0.10) / 0.20
			vocal_struggle = sin(vt * PI) * sin(t * TAU * 260.0) * 0.30 * (sin(t * TAU * 12.0) * 0.5 + 0.5)
		return clampf((band_noise + glitch_tone + notch_pulse + vocal_struggle) * env * 0.85, -1.0, 1.0)
	)


## Station 21 Airlock Sound: pneumatic unlocking sound of exit airlock towards Submissiveness zone (320 Hz + 740 Hz release) (Scene 21)
static func create_station21_airlock_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.0) * (1.0 - exp(-t * 50.0))
		var bolt := sin(t * TAU * 320.0) * 0.45 * exp(-t * 10.0)
		var release_tone := 0.0
		if t >= 0.06:
			var rt := t - 0.06
			release_tone = sin(rt * TAU * 740.0) * 0.40 * exp(-rt * 8.0)
		var air_burst := (sin(t * 22400.1) * 0.5 + sin(t * 33800.7) * 0.5) * 0.30 * exp(-progress * 5.0)
		var latch := 0.0
		if t >= 0.04 and t <= 0.07:
			var lt := (t - 0.04) / 0.03
			latch = sin(lt * PI) * sin(t * TAU * 1580.0) * 0.45
		return clampf((bolt + release_tone + air_burst + latch) * env * 0.85, -1.0, 1.0)
	)


## Biometric Gate Scan Sound: Hand contour scan with rising acoustic sweep and confirmation pulse (480 Hz -> 1920 Hz sweep with resonant confirm) (Scene 22)
static func create_biometric_gate_scan_sound() -> AudioStreamWAV:
	var duration := 0.75
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 60.0))
		
		# Rising biometric laser sweep from 480 Hz to 1920 Hz
		var sweep_freq := 480.0 + progress * progress * 1440.0
		var sweep_tone := sin(t * TAU * sweep_freq) * 0.45
		var sweep_harmonic := sin(t * TAU * sweep_freq * 2.0) * 0.15
		
		# Optical sensor grain shimmer
		var sensor_shimmer := (sin(t * 19200.0) * 0.5 + sin(t * 28400.0) * 0.5) * 0.20 * (sin(t * TAU * 16.0) * 0.5 + 0.5)
		
		# Identity confirmation chime (t = 0.50..0.75s)
		var confirm_tone := 0.0
		if t >= 0.48:
			var ct := t - 0.48
			var c_env := exp(-ct * 12.0) if ct >= 0.002 else (ct / 0.002)
			confirm_tone = (sin(ct * TAU * 880.0) * 0.50 + sin(ct * TAU * 1760.0) * 0.25) * c_env
		
		var raw := (sweep_tone + sweep_harmonic + sensor_shimmer + confirm_tone) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Ring Resonance Hum Sound: Subtle warm gold & flesh resonance (1200 Hz with 6 Hz micro-vibration and amber harmonic saturation) (Scene 22)
static func create_ring_resonance_hum_sound() -> AudioStreamWAV:
	var duration := 0.95
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		
		# 6 Hz tremolo / micro-vibration
		var tremolo := sin(t * TAU * 6.0) * 0.18 + 0.82
		
		# 1200 Hz fundamental + warm harmonics (2400 Hz, 3600 Hz)
		var gold_tone := sin(t * TAU * 1200.0) * 0.55 * tremolo
		var gold_octave := sin(t * TAU * 2400.0) * 0.22 * tremolo
		var warm_sub := sin(t * TAU * 600.0) * 0.25
		
		# Flesh contact warmth filter
		var contact_warmth := sin(t * TAU * 300.0) * 0.15 * exp(-t * 3.0)
		
		var raw := (gold_tone + gold_octave + warm_sub + contact_warmth) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Paint Memory Recall Sound: Sensory acoustic influx of foreign memory (528 Hz C5 with paint-roller friction modulation and solvent breath) (Scene 22)
static func create_paint_memory_recall_sound() -> AudioStreamWAV:
	var duration := 1.25
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 15.0))
		
		# Influx core: 528 Hz (Solffeggio DNA / relational memory) with warm beat
		var core_tone := (sin(t * TAU * 528.0) * 0.40 + sin(t * TAU * 532.0) * 0.25)
		var overtone := sin(t * TAU * 1056.0) * 0.15
		
		# Roller texture / paint emulsion friction (1200..3200 Hz filtered hiss)
		var roller_mod := sin(t * TAU * 3.2) * 0.5 + 0.5
		var roller_texture := (sin(t * 11500.0) * 0.5 + sin(t * 21300.0) * 0.5) * 0.22 * roller_mod
		
		# Solvent breath / vapor bloom (sub-harmonic 132 Hz swell)
		var vapor_bloom := sin(t * TAU * 132.0) * 0.25 * (sin(progress * PI))
		
		var raw := (core_tone + overtone + roller_texture + vapor_bloom) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Biographical Erasure Glitch Sound: Deep, muted fault line of autobiographical erasure (62 Hz sub-bass with mechanical bandwidth truncation and descending decay) (Scene 22)
static func create_biographical_erasure_glitch_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.5) * (1.0 - exp(-t * 80.0))
		
		# 62 Hz Sub-bass memory fault impact
		var sub_fault := sin(t * TAU * 62.0) * 0.65 * exp(-t * 4.0)
		var sub_second := sin(t * TAU * 31.0) * 0.35 * exp(-t * 3.0)
		
		# Bandwidth truncation / notch glitch (voice formants abruptly cut off)
		var truncation_snap := 0.0
		if t >= 0.05 and t <= 0.12:
			var st := (t - 0.05) / 0.07
			truncation_snap = sin(st * PI) * (sin(t * TAU * 1450.0) * 0.40 + sin(t * TAU * 2900.0) * 0.20)
		
		# Memory void hiss / vacuum fading away
		var void_whisper := (sin(t * 16200.0) * 0.5 + sin(t * 29800.0) * 0.5) * 0.18 * exp(-t * 5.0)
		
		var raw := (sub_fault + sub_second + truncation_snap + void_whisper) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 22 Door Release Sound: Massive transit door unlatch towards Space 23 (380 Hz electromagnet + pneumatic exhaust + 1100 Hz release chime) (Scene 22)
static func create_station22_door_release_sound() -> AudioStreamWAV:
	var duration := 0.70
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.2) * (1.0 - exp(-t * 60.0))
		
		# Heavy solenoid unlatch (380 Hz + 190 Hz thud)
		var solenoid := (sin(t * TAU * 380.0) * 0.50 + sin(t * TAU * 190.0) * 0.35) * exp(-t * 14.0)
		
		# Pneumatic seal break exhaust
		var exhaust := (sin(t * 18400.0) * 0.5 + sin(t * 31200.0) * 0.5) * 0.30 * exp(-progress * 5.5)
		
		# Release chime at t = 0.08s (1100 Hz F6)
		var chime := 0.0
		if t >= 0.08:
			var ct := t - 0.08
			chime = sin(ct * TAU * 1100.0) * 0.40 * exp(-ct * 9.0)
		
		var raw := (solenoid + exhaust + chime) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Designer Terminal Hum Sound: transformer hum and CRT green/amber phosphor ionization in designer's workstation (75/150 Hz with 3400 Hz ionization) (Scene 23)
static func create_designer_terminal_hum_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		
		# 75 Hz & 150 Hz power supply / magnetic transformer hum
		var hum := sin(t * TAU * 75.0) * 0.50 + sin(t * TAU * 150.0) * 0.30
		
		# CRT phosphor ionization hiss (3400 Hz + 6800 Hz)
		var crt_ion := (sin(t * TAU * 3400.0) * 0.20 + sin(t * TAU * 6800.0) * 0.10) * (sin(t * TAU * 12.0) * 0.15 + 0.85)
		
		# Line frequency flyback transformer whistle (15625 Hz simulation downscaled to 7800 Hz for audible range)
		var flyback := sin(t * TAU * 7812.5) * 0.08
		
		var raw := (hum + crt_ion + flyback) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Cursor Shift Glitch Sound: asynchronous piezoelectric click and phase-shift displacement as Shadow moves the cursor (1420 Hz with 380 Hz phase jump) (Scene 23)
static func create_cursor_shift_glitch_sound() -> AudioStreamWAV:
	var duration := 0.24
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 16.0) if progress >= 0.003 else (progress / 0.003)
		
		# Piezoelectric mechanical click
		var click := sin(t * TAU * 1420.0) * 0.65
		
		# Phase shift pop (380 Hz reactive jump)
		var phase_jump := 0.0
		if t >= 0.03 and t <= 0.09:
			var pt := (t - 0.03) / 0.06
			phase_jump = sin(pt * PI) * sin(t * TAU * 380.0) * 0.45
		
		# Ghost cursor micro-grain
		var ghost_grain := (sin(t * 22400.0) * 0.5 + sin(t * 31800.0) * 0.5) * 0.20 * exp(-t * 30.0)
		
		var raw := (click * env + phase_jump + ghost_grain) * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Burden Ledger Scan Sound: mechanical buffer scroll and digital index rustle of burdened persons registry (880 Hz stepper + digital rustle) (Scene 23)
static func create_burden_ledger_scan_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 50.0))
		
		# 880 Hz Stepper motor pulses (12 index steps per second)
		var step_phase := fmod(t * 12.0, 1.0)
		var step_env := exp(-step_phase * 35.0) if step_phase >= 0.02 else (step_phase / 0.02)
		var step_tone := (sin(t * TAU * 880.0) * 0.55 + sin(t * TAU * 1760.0) * 0.25) * step_env
		
		# Digital magnetic card buffer rustle
		var buffer_rustle := (sin(t * 14320.0) * 0.4 + sin(t * 26540.0) * 0.4 + sin(t * 9800.0) * 0.2) * 0.30
		
		# Sub-bass chassis relay thud
		var relay_thud := sin(t * TAU * 120.0) * 0.20 * exp(-progress * 4.0)
		
		var raw := (step_tone + buffer_rustle + relay_thud) * env * 0.82
		return clampf(raw, -1.0, 1.0)
	)


## Designer Note Chime Sound: warm copper-amber resonance upon discovering local Lena's handwritten inscription (660 Hz E5 with 1320/1980 Hz harmonics) (Scene 23)
static func create_designer_note_chime_sound() -> AudioStreamWAV:
	var duration := 0.90
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.8) * (1.0 - exp(-t * 90.0))
		
		# 660 Hz (E5) Foundational note + warm harmonics
		var f0 := 660.0
		var tone := sin(t * TAU * f0) * 0.55
		var h1 := sin(t * TAU * (f0 * 2.0)) * 0.25
		var h2 := sin(t * TAU * (f0 * 3.0)) * 0.15
		
		# Amber micro-tremolo
		var tremolo := sin(t * TAU * 4.5) * 0.12 + 0.88
		
		# Subtle copper plate friction strike at start
		var friction_strike := 0.0
		if t < 0.01:
			friction_strike = (1.0 - t / 0.01) * sin(t * TAU * 3600.0) * 0.22
		
		var raw := (tone * tremolo + h1 + h2 + friction_strike) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 23 Exit Unlatch Sound: deep solenoid unlatch and pneumatic pressure venting towards Space 24 (Marta under observation) (290/580 Hz solenoid + pneumatic exhaust) (Scene 23)
static func create_station23_exit_unlatch_sound() -> AudioStreamWAV:
	var duration := 0.75
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.0) * (1.0 - exp(-t * 50.0))
		
		# Heavy solenoid latch release (290 Hz + 580 Hz)
		var solenoid := (sin(t * TAU * 290.0) * 0.55 + sin(t * TAU * 580.0) * 0.30) * exp(-t * 12.0)
		
		# Pneumatic exhaust vent
		var vent := (sin(t * 19500.0) * 0.5 + sin(t * 32400.0) * 0.5) * 0.28 * exp(-progress * 5.0)
		
		# Magnetic lock ping at t = 0.06s (1280 Hz)
		var lock_ping := 0.0
		if t >= 0.06:
			var pt := t - 0.06
			lock_ping = sin(pt * TAU * 1280.0) * 0.35 * exp(-pt * 10.0)
		
		var raw := (solenoid + vent + lock_ping) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## CCTV Static Hum Sound: multi-screen CCTV surveillance wall hum & video interference (60/120 Hz hum with 15750 Hz flyback buzz) (Scene 24)
static func create_cctv_static_hum_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		
		# 60 Hz & 120 Hz mains hum from multi-monitor power racks
		var power_hum := sin(t * TAU * 60.0) * 0.45 + sin(t * TAU * 120.0) * 0.30
		
		# CRT flyback whistle (scaled down to 7875 Hz for clean acoustic reproduction without aliasing)
		var flyback := sin(t * TAU * 7875.0) * 0.12 * (sin(t * TAU * 8.0) * 0.1 + 0.9)
		
		# Video raster scanline static / noise burst
		var raster_noise := (sin(t * 17890.0) * 0.4 + sin(t * 29140.0) * 0.4 + sin(t * 8320.0) * 0.2) * 0.22
		var sync_hiss := sin(t * TAU * 240.0) * 0.15 * exp(-progress * 2.0)
		
		var raw := (power_hum + flyback + raster_noise + sync_hiss) * env * 0.82
		return clampf(raw, -1.0, 1.0)
	)


## Correction Stress Siren Sound: rising correlation stress whine around Marta in apartment 14 (modulated sweep 880->1760 Hz with 8 Hz pulse) (Scene 24)
static func create_correction_stress_siren_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		
		# Modulated frequency sweep from 880 Hz to 1760 Hz with urgent 8 Hz pulse
		var sweep_freq := 880.0 + progress * 880.0
		var pulse_mod := sin(t * TAU * 8.0) * 0.35 + 0.65
		var siren_tone := sin(t * TAU * sweep_freq) * 0.55 * pulse_mod
		var harmonic := sin(t * TAU * sweep_freq * 2.0) * 0.20 * pulse_mod
		
		# Sub-bass structural resonance groaning beneath the alarm
		var sub_groan := sin(t * TAU * 75.0) * 0.30 * (sin(t * TAU * 4.0) * 0.2 + 0.8)
		
		# Cinnabar interference crackle
		var crackle := (sin(t * 21500.0) * 0.5 + sin(t * 33100.0) * 0.5) * 0.18 * pulse_mod
		
		var raw := (siren_tone + harmonic + sub_groan + crackle) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Intercom Wierzbicka Tone Sound: transmission intercom dual-tone of dr Wierzbicka with mic preamp saturation (440 Hz + 1100 Hz) (Scene 24)
static func create_intercom_wierzbicka_tone_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.5) * (1.0 - exp(-t * 80.0))
		
		# Dual chime (440 Hz A4 + 1100 Hz C#6)
		var tone_low := sin(t * TAU * 440.0) * 0.50
		var tone_high := sin(t * TAU * 1100.0) * 0.45
		
		# Intercom carbon microphone saturation & bandwidth filter
		var preamp_click := 0.0
		if t < 0.008:
			preamp_click = (1.0 - t / 0.008) * sin(t * TAU * 2800.0) * 0.35
		
		# Line carrier hiss
		var carrier_hiss := (sin(t * 14200.0) * 0.5 + sin(t * 26700.0) * 0.5) * 0.15 * exp(-progress * 3.0)
		
		var raw := (tone_low + tone_high + preamp_click + carrier_hiss) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Decision Button Latch Sound: mechanical latch relay of Lena's disposition choice (320 Hz detent with 1400 Hz brass snap) (Scene 24)
static func create_decision_button_latch_sound() -> AudioStreamWAV:
	var duration := 0.30
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 18.0) if progress >= 0.002 else (progress / 0.002)
		
		# Heavy button mechanical detent (320 Hz)
		var detent := sin(t * TAU * 320.0) * 0.65
		
		# Brass micro-switch latch snap (1400 Hz)
		var snap := 0.0
		if t >= 0.02 and t <= 0.06:
			var st := (t - 0.02) / 0.04
			snap = sin(st * PI) * sin(t * TAU * 1400.0) * 0.55
		
		# Electrical relay engage thud
		var relay_pop := sin(t * TAU * 110.0) * 0.40 * exp(-t * 40.0)
		
		var raw := (detent * env + snap + relay_pop) * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 24 Door Release Sound: heavy transit solenoid airlock unlatch toward Space 25 (Wejście Jakuba) (340/680 Hz with pneumatic hiss) (Scene 24)
static func create_station24_door_release_sound() -> AudioStreamWAV:
	var duration := 0.75
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.0) * (1.0 - exp(-t * 60.0))
		
		# Solenoid locking pins release (340 Hz + 680 Hz)
		var solenoid := (sin(t * TAU * 340.0) * 0.55 + sin(t * TAU * 680.0) * 0.35) * exp(-t * 12.0)
		
		# Pneumatic pressure release hiss
		var pneumatic := (sin(t * 18900.0) * 0.5 + sin(t * 31500.0) * 0.5) * 0.30 * exp(-progress * 5.0)
		
		# Transit latch chime at t = 0.07s (1020 Hz)
		var latch_chime := 0.0
		if t >= 0.07:
			var lt := t - 0.07
			latch_chime = sin(lt * TAU * 1020.0) * 0.38 * exp(-lt * 10.0)
		
		var raw := (solenoid + pneumatic + latch_chime) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Transit Rail Hum Sound: low rail hum and traction converter of Line 4 (50 Hz + 150 Hz rail resonance + 3100 Hz whistle) (Scene 25)
static func create_transit_rail_hum_sound() -> AudioStreamWAV:
	var duration := 1.25
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		
		# 50 Hz power hum and 100 Hz harmonic from traction substations
		var power_hum := sin(t * TAU * 50.0) * 0.45 + sin(t * TAU * 100.0) * 0.25
		
		# 150 Hz rail acoustic cavity resonance modulated by vibration
		var rail_resonance := sin(t * TAU * 150.0) * 0.35 * (sin(t * TAU * 3.5) * 0.2 + 0.8)
		
		# High frequency inverter switching whistle (3100 Hz)
		var traction_whistle := sin(t * TAU * 3100.0) * 0.12 * (sin(t * TAU * 6.0) * 0.15 + 0.85)
		
		# Track bed ballast rumble and metallic friction hiss
		var track_vibration := (sin(t * 12500.0) * 0.3 + sin(t * 24300.0) * 0.3) * 0.15 * exp(-progress * 2.0)
		
		var raw := (power_hum + rail_resonance + traction_whistle + track_vibration) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Jakub Uniform Rustle Sound: rustle of heavy UCP operator technician canvas uniform (750..2800 Hz) (Scene 25)
static func create_jakub_uniform_rustle_sound() -> AudioStreamWAV:
	var duration := 0.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 50.0))
		
		# Multi-band canvas friction (750 Hz, 1450 Hz, 2800 Hz)
		var canvas_friction := (sin(t * TAU * 750.0) * 0.35 + sin(t * TAU * 1450.0) * 0.30 + sin(t * TAU * 2800.0) * 0.25)
		
		# High textile weave noise
		var fabric_noise := (sin(t * 16800.0) * 0.4 + sin(t * 28900.0) * 0.4) * 0.25 * exp(-progress * 4.0)
		
		# Heavy seam flex click
		var cloth_creak := sin(t * TAU * 380.0) * 0.20 * exp(-t * 15.0)
		
		var raw := (canvas_friction * 0.6 + fabric_noise + cloth_creak) * env * 0.82
		return clampf(raw, -1.0, 1.0)
	)


## Scar Revelation Chime Sound: crystalline dissonance of body identification memory (740 Hz / 784 Hz with 1.8 Hz tremolo) (Scene 25)
static func create_scar_revelation_chime_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.0) * (1.0 - exp(-t * 60.0))
		
		# Tremolo beating (1.8 Hz)
		var tremolo := sin(t * TAU * 1.8) * 0.25 + 0.75
		
		# Dissonant minor second chime (740 Hz F#5 + 784 Hz G5) representing morgue recognition
		var tone1 := sin(t * TAU * 740.0) * 0.50 * tremolo
		var tone2 := sin(t * TAU * 784.0) * 0.45 * tremolo
		
		# Sub-octave resonance (185 Hz)
		var sub_memory := sin(t * TAU * 185.0) * 0.30 * exp(-t * 6.0)
		
		# Glass shard overtone (2960 Hz)
		var glass_shard := sin(t * TAU * 2960.0) * 0.15 * exp(-t * 14.0)
		
		var raw := (tone1 + tone2 + sub_memory + glass_shard) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Finger Edge Scrape Sound: quiet dry sound of sliding finger along a sharp metal edge (1850 Hz micro-friction) (Scene 25)
static func create_finger_edge_scrape_sound() -> AudioStreamWAV:
	var duration := 0.35
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 6.0) * (1.0 - exp(-t * 90.0))
		
		# 1850 Hz sharp edge acoustic trace
		var scrape_tone := sin(t * TAU * 1850.0) * 0.45
		
		# Micro-frictional grain and skin drag
		var micro_friction := (sin(t * 22400.0) * 0.5 + sin(t * 37800.0) * 0.5) * 0.35 * exp(-progress * 8.0)
		
		# Metal burr harmonic ping (3700 Hz)
		var metal_edge := sin(t * TAU * 3700.0) * 0.20 * exp(-t * 25.0)
		
		var raw := (scrape_tone + micro_friction + metal_edge) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Station 25 Door Release Sound: pneumatic exit latch release toward isolation zone Space 26 (360/720 Hz release) (Scene 25)
static func create_station25_door_release_sound() -> AudioStreamWAV:
	var duration := 0.70
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.2) * (1.0 - exp(-t * 70.0))
		
		# Heavy dual solenoid unclamp (360 Hz + 720 Hz)
		var solenoid := (sin(t * TAU * 360.0) * 0.55 + sin(t * TAU * 720.0) * 0.35) * exp(-t * 14.0)
		
		# Pneumatic air seal venting hiss
		var pneumatic := (sin(t * 19200.0) * 0.5 + sin(t * 33400.0) * 0.5) * 0.30 * exp(-progress * 5.0)
		
		# Latch release chime at t = 0.05s (1080 Hz)
		var latch_chime := 0.0
		if t >= 0.05:
			var lt := t - 0.05
			latch_chime = sin(lt * TAU * 1080.0) * 0.35 * exp(-lt * 12.0)
		
		var raw := (solenoid + pneumatic + latch_chime) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Isolation Hum Sound: muted velvety sub-hum of gentle isolation chamber (45/90 Hz with micro-damping) (Scene 26)
static func create_isolation_hum_sound() -> AudioStreamWAV:
	var duration := 1.30
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		
		# 45 Hz sub-bass fundamental and 90 Hz acoustic cavity resonance
		var f0 := sin(t * TAU * 45.0) * 0.55
		var f1 := sin(t * TAU * 90.0) * 0.30 * (sin(t * TAU * 3.0) * 0.15 + 0.85)
		
		# Velvety isolation chamber acoustic damping texture (filtered air wash)
		var damping_wash := (sin(t * 9400.0) * 0.4 + sin(t * 18600.0) * 0.4) * 0.15 * exp(-progress * 1.5)
		
		# Low soothing hum flutter (135 Hz harmonic)
		var flutter := sin(t * TAU * 135.0) * 0.12 * (cos(t * TAU * 1.5) * 0.2 + 0.8)
		
		var raw := (f0 + f1 + damping_wash + flutter) * env * 0.82
		return clampf(raw, -1.0, 1.0)
	)


## Reconfiguration Chime Sound: modulated pitch sweep of dynamic room functional reallocation (640->520 Hz sweep) (Scene 26)
static func create_reconfiguration_chime_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.2) * (1.0 - exp(-t * 80.0))
		
		# Modulated frequency sweep (640 Hz down to 520 Hz)
		var cur_freq := lerpf(640.0, 520.0, progress)
		var sweep_tone := sin(t * TAU * cur_freq) * 0.55
		
		# Cyan resonance overtone (cur_freq * 2.0)
		var overtone := sin(t * TAU * (cur_freq * 2.0)) * 0.28 * exp(-progress * 4.0)
		
		# Spatial reallocation micro-pulse (260 Hz sub-warmth)
		var sub_chime := sin(t * TAU * 260.0) * 0.22 * exp(-progress * 2.5)
		
		# Transition shimmer noise
		var shimmer := (sin(t * 14200.0) * 0.3 + sin(t * 28400.0) * 0.3) * 0.12 * exp(-progress * 5.0)
		
		var raw := (sweep_tone + overtone + sub_chime + shimmer) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Dr Wierzbicka Calming PA Tone Sound: low soothing intonation of adaptive PA announcements (330/660 Hz with bandpass filter) (Scene 26)
static func create_wierzbicka_calming_tone_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 60.0))
		
		# 330 Hz E4 fundamental with warm 660 Hz harmonic and subtle carbon mic warmth
		var tone1 := sin(t * TAU * 330.0) * 0.60
		var tone2 := sin(t * TAU * 660.0) * 0.30
		var sub := sin(t * TAU * 165.0) * 0.20
		
		# Institutional speaker bandwidth hiss
		var pa_air := (sin(t * 12600.0) * 0.35 + sin(t * 22400.0) * 0.35) * 0.15 * exp(-progress * 2.5)
		
		var raw := (tone1 + tone2 + sub + pa_air) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Motivation Scratch Sound: sharp stylus carving/anchoring Lena's intent into composite wall (2100 Hz friction with 4200 Hz snap) (Scene 26)
static func create_motivation_scratch_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.5) * (1.0 - exp(-t * 90.0))
		
		# Sharp stylus micro-friction chatter (2100 Hz with 85 Hz phase vibration)
		var chatter := sin(t * TAU * 85.0) * 160.0
		var scratch_tone := sin(t * TAU * (2100.0 + chatter)) * 0.50
		
		# High frequency crystalline composite fracture (4200 Hz)
		var composite_fracture := sin(t * TAU * 4200.0) * 0.32 * exp(-progress * 8.0)
		
		# Mineral grain scratch noise
		var mineral_grit := (sin(t * 24500.0) * 0.5 + sin(t * 41200.0) * 0.5) * 0.30 * exp(-progress * 6.0)
		
		# Structural anchor click at onset
		var anchor_click := sin(t * TAU * 740.0) * 0.25 * exp(-t * 30.0)
		
		var raw := (scratch_tone + composite_fracture + mineral_grit + anchor_click) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 26 Door Release Sound: pneumatic service exit latch release toward Space 27 (310/620 Hz release) (Scene 26)
static func create_station26_door_release_sound() -> AudioStreamWAV:
	var duration := 0.75
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.0) * (1.0 - exp(-t * 65.0))
		
		# Dual electromagnetic solenoid unclamp (310 Hz + 620 Hz)
		var solenoid := (sin(t * TAU * 310.0) * 0.55 + sin(t * TAU * 620.0) * 0.35) * exp(-t * 12.0)
		
		# Pneumatic air seal venting hiss
		var pneumatic := (sin(t * 18400.0) * 0.5 + sin(t * 32800.0) * 0.5) * 0.30 * exp(-progress * 4.8)
		
		# Latch release chime at t = 0.06s (930 Hz)
		var latch_chime := 0.0
		if t >= 0.06:
			var lt := t - 0.06
			latch_chime = sin(lt * TAU * 930.0) * 0.35 * exp(-lt * 11.0)
		
		var raw := (solenoid + pneumatic + latch_chime) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Service Tunnel Hum Sound: deep 52/104 Hz service tunnel background hum with industrial ventilation (Scene 27)
static func create_service_tunnel_hum_sound() -> AudioStreamWAV:
	var duration := 1.2
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 50.0))
		
		# Sub-bass structural hum (52 Hz fundamental + 104 Hz harmonic)
		var sub1 := sin(t * TAU * 52.0) * 0.55
		var sub2 := sin(t * TAU * 104.0) * 0.35
		var sub3 := sin(t * TAU * 208.0) * 0.18
		
		# Heavy forced-air duct murmur
		var air_noise := (sin(t * 11200.0) * 0.35 + sin(t * 19800.0) * 0.35) * 0.22 * (0.8 + sin(t * TAU * 1.5) * 0.2)
		
		var raw := (sub1 + sub2 + sub3 + air_noise) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Jakub Keycard Latch Sound: magnetic swipe 1600 Hz + mechanical solenoid 480 Hz unlatch (Scene 27)
static func create_jakub_keycard_latch_sound() -> AudioStreamWAV:
	var duration := 0.55
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.5) * (1.0 - exp(-t * 80.0))
		
		# Magnetic reader friction sweep (1400 -> 1800 Hz)
		var mag_freq := 1400.0 + progress * 400.0
		var mag_swipe := sin(t * TAU * mag_freq) * 0.40 * exp(-t * 22.0)
		
		# Heavy solenoid latch drop at t = 0.08s (480 Hz + 960 Hz)
		var solenoid := 0.0
		if t >= 0.08:
			var st := t - 0.08
			solenoid = (sin(st * TAU * 480.0) * 0.60 + sin(st * TAU * 960.0) * 0.35) * exp(-st * 16.0)
		
		# High frequency mechanical click
		var click := (sin(t * 26500.0) * 0.5 + sin(t * 43200.0) * 0.5) * 0.35 * exp(-t * 40.0)
		
		var raw := (mag_swipe + solenoid + click) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Gratitude Confession Tone Sound: warm, melancholic tone 440/554 Hz (major third A4/C#5) (Scene 27)
static func create_gratitude_confession_tone_sound() -> AudioStreamWAV:
	var duration := 1.0
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 45.0))
		
		# Harmonic dual tone (A4 440 Hz + C#5 554.37 Hz)
		var tone_a := sin(t * TAU * 440.0) * 0.50
		var tone_cs := sin(t * TAU * 554.37) * 0.42
		var sub_oct := sin(t * TAU * 220.0) * 0.25
		
		# Slow chorus modulation
		var chorus := sin(t * TAU * 1.8) * 0.15
		
		var raw := (tone_a + tone_cs + sub_oct) * (1.0 + chorus) * env * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Surface Danger Siren Sound: muffled, distant 1200 Hz warning whistle of surface instability (Scene 27)
static func create_surface_danger_siren_sound() -> AudioStreamWAV:
	var duration := 0.9
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 35.0))
		
		# Distant modulated siren (1150 Hz <-> 1280 Hz at 3 Hz modulation)
		var siren_mod := sin(t * TAU * 3.0) * 65.0
		var siren_tone := sin(t * TAU * (1200.0 + siren_mod)) * 0.55
		
		# Concrete tunnel acoustic filter (damping high transients)
		var tunnel_sub := sin(t * TAU * 300.0) * 0.30
		var air_grain := (sin(t * 14200.0) * 0.5 + sin(t * 23100.0) * 0.5) * 0.15 * exp(-progress * 2.0)
		
		var raw := (siren_tone + tunnel_sub + air_grain) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Station 27 Door Release Sound: heavy pneumatic rolling shutter release (260/520 Hz + 820 Hz ring) (Scene 27)
static func create_station27_door_release_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.8) * (1.0 - exp(-t * 60.0))
		
		# Heavy iron shutter mechanism (260 Hz fundamental + 520 Hz harmonic)
		var shutter := (sin(t * TAU * 260.0) * 0.60 + sin(t * TAU * 520.0) * 0.38) * exp(-t * 10.0)
		
		# Steel guide rail resonance ring (820 Hz)
		var rail_ring := sin(t * TAU * 820.0) * 0.30 * exp(-t * 7.5)
		
		# Pneumatic depressurization hiss
		var pneumatic := (sin(t * 17500.0) * 0.5 + sin(t * 31400.0) * 0.5) * 0.32 * exp(-progress * 4.2)
		
		var raw := (shutter + rail_ring + pneumatic) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Moving Tram Motor Sound: deep 65/130 Hz electric traction motor roar and wheel hum (Scene 28)
static func create_moving_tram_motor_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		
		# Electric traction motor drone (65 Hz + 130 Hz + inverter whine 850 Hz)
		var motor_bass := sin(t * TAU * 65.0) * 0.55 + sin(t * TAU * 130.0) * 0.35
		var inverter := sin(t * TAU * (850.0 + sin(t * 12.0) * 45.0)) * 0.18
		
		# Steel rail friction texture (high frequencies)
		var rail_texture := (sin(t * 11500.0) * 0.5 + sin(t * 22400.0) * 0.5) * 0.22
		
		var raw := (motor_bass + inverter + rail_texture) * env * 0.82
		return clampf(raw, -1.0, 1.0)
	)


## Track Switch Clack Sound: sharp metallic wheel impact over rail junction switch points (Scene 28)
static func create_track_switch_clack_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 9.0) * (1.0 - exp(-t * 120.0))
		
		# Primary wheel impact on switch blade (320 Hz + 640 Hz)
		var impact1 := (sin(t * TAU * 320.0) * 0.65 + sin(t * TAU * 640.0) * 0.45) * exp(-t * 25.0)
		
		# Secondary axle bounce 0.12s later
		var t2 := t - 0.12
		var impact2 := 0.0
		if t2 > 0.0:
			impact2 = (sin(t2 * TAU * 290.0) * 0.55 + sin(t2 * TAU * 580.0) * 0.35) * exp(-t2 * 25.0)
		
		# Metallic snap & rail ring (1400 Hz)
		var snap := sin(t * TAU * 1400.0) * 0.30 * exp(-t * 30.0)
		
		var raw := (impact1 + impact2 + snap) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Wierzbicka Closing Intercom Sound: filtered radio PA transmission tone (880 Hz beep + 380..2200 Hz voice formant) (Scene 28)
static func create_wierzbicka_closing_intercom_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := (1.0 - exp(-progress * 6.0)) * exp(-progress * 2.8)
		
		# Initial PA beep call tone (880 Hz)
		var beep := sin(t * TAU * 880.0) * 0.40 * exp(-t * 14.0)
		
		# Radio transmission carrier wave and formant harmonics
		var carrier := (sin(t * TAU * 480.0) * 0.45 + sin(t * TAU * 960.0) * 0.28 + sin(t * TAU * 1920.0) * 0.18) * exp(-progress * 2.2)
		var radio_static := (sin(t * 16300.0) * 0.5 + sin(t * 29500.0) * 0.5) * 0.15
		
		var raw := (beep + carrier + radio_static) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Paradox Peron Shimmer Sound: resonant triple-harmonic paradox chime (330/440/587 Hz) (Scene 28)
static func create_paradox_peron_shimmer_sound() -> AudioStreamWAV:
	var duration := 1.35
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * exp(-progress * 1.5)
		
		# Triple harmonic chord corresponding to 3 simultaneous versions of accident
		var chord := (sin(t * TAU * 330.0) * 0.45 + sin(t * TAU * 440.0) * 0.40 + sin(t * TAU * 587.33) * 0.35)
		
		# Shimmer beat modulation
		var beat := (1.0 + 0.35 * sin(t * TAU * 5.5))
		
		var raw := chord * beat * env * 0.78
		return clampf(raw, -1.0, 1.0)
	)


## Station 28 Pneumatic Brake Sound: heavy train brake release & hiss (hiss 1200..400 Hz + 220 Hz bass thud) (Scene 28)
static func create_station28_pneumatic_brake_sound() -> AudioStreamWAV:
	var duration := 0.95
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.5) * (1.0 - exp(-t * 50.0))
		
		# Pneumatic release hiss
		var hiss := (sin(t * (12000.0 - progress * 8000.0)) * 0.5 + sin(t * 25000.0) * 0.5) * 0.50 * exp(-progress * 2.8)
		
		# Mechanical brake shoe clamp and carriage thud (220 Hz + 110 Hz)
		var thud := (sin(t * TAU * 220.0) * 0.45 + sin(t * TAU * 110.0) * 0.35) * exp(-t * 8.0)
		
		var raw := (hiss + thud) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Platform 13 Drip Echo Sound: wet reverberant droplet impact in cavernous tunnel (180 Hz thud + 2200 Hz drop) (Scene 29)
static func create_platform13_drip_echo_sound() -> AudioStreamWAV:
	var duration := 1.15
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.0) * (1.0 - exp(-t * 80.0))
		
		# High frequency droplet snap sweeping down 2400..1800 Hz
		var drop_freq := 2400.0 - t * 4000.0
		var drop := sin(t * TAU * drop_freq) * exp(-t * 22.0) * 0.55
		
		# Cavernous tunnel echo reverb thud (180 Hz with sub-harmonic 90 Hz)
		var thud := (sin(t * TAU * 180.0) * 0.40 + sin(t * TAU * 90.0) * 0.30) * exp(-progress * 2.5)
		
		var raw := (drop + thud) * env * 0.82
		return clampf(raw, -1.0, 1.0)
	)


## Flickering Neon Buzz Sound: electrical transformer hum & ballast spark (100/200 Hz + 3400 Hz spark) (Scene 29)
static func create_flickering_neon_buzz_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * 0.95
		
		# 100 Hz / 200 Hz transformer core buzz
		var buzz := (sin(t * TAU * 100.0) * 0.50 + sin(t * TAU * 200.0) * 0.35 + sin(t * TAU * 400.0) * 0.20)
		
		# Irregular flickering discharge spikes
		var spark := sin(t * TAU * 3400.0) * sin(t * TAU * 45.0) * 0.30
		
		var raw := (buzz + spark) * env * 0.76
		return clampf(raw, -1.0, 1.0)
	)


## Deep Well Drone Sound: infrasonic Substructure ventilation shaft resonance (42 Hz + 84 Hz) (Scene 29)
static func create_deep_well_drone_sound() -> AudioStreamWAV:
	var duration := 1.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * exp(-progress * 0.5)
		
		# Infrasonic cavernous drone
		var drone := (sin(t * TAU * 42.0) * 0.55 + sin(t * TAU * 84.0) * 0.38 + sin(t * TAU * 126.0) * 0.22)
		
		# Low frequency acoustic swell
		var swell := (1.0 + 0.25 * sin(t * TAU * 1.8))
		
		var raw := drone * swell * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Jakub Torch Click Sound: tactile click of industrial battery flashlight (1800 Hz click + 440 Hz pop) (Scene 29)
static func create_jakub_torch_click_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 9.0) * (1.0 - exp(-t * 120.0))
		
		# Sharp mechanical switch snap (1800 Hz + 3600 Hz)
		var snap := (sin(t * TAU * 1800.0) * 0.65 + sin(t * TAU * 3600.0) * 0.35) * exp(-t * 45.0)
		
		# Housing resonance (440 Hz)
		var housing := sin(t * TAU * 440.0) * 0.40 * exp(-t * 18.0)
		
		var raw := (snap + housing) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Station 29 Grate Creak Sound: heavy rusted security grate unlatching & groan (340/680 Hz + 110 Hz) (Scene 29)
static func create_station29_grate_creak_sound() -> AudioStreamWAV:
	var duration := 1.05
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 2.8) * (1.0 - exp(-t * 50.0))
		
		# Rusted iron friction squeak (frequency modulates slightly with strain)
		var squeak_freq := 340.0 + sin(t * TAU * 4.0) * 45.0
		var iron := (sin(t * TAU * squeak_freq) * 0.50 + sin(t * TAU * squeak_freq * 2.0) * 0.35)
		
		# Heavy bar clank (110 Hz)
		var clank := sin(t * TAU * 110.0) * 0.45 * exp(-t * 8.0)
		
		var raw := (iron + clank) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Transformer Oil Hum Sound: deep 50Hz/100Hz/150Hz power transformer oil-cooled hum (Scene 30)
static func create_transformer_oil_hum_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		var hum50 := sin(t * TAU * 50.0) * 0.50
		var hum100 := sin(t * TAU * 100.0) * 0.35
		var hum150 := sin(t * TAU * 150.0) * 0.20
		var oil_flutter := sin(t * TAU * 1.5) * 0.15
		var raw := (hum50 + hum100 + hum150 + oil_flutter) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Knife Switch Throw Sound: heavy 3-phase industrial knife switch throw with electrical arc flash (Scene 30)
static func create_knife_switch_throw_sound() -> AudioStreamWAV:
	var duration := 0.90
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 5.0)
		var thud := (sin(t * TAU * 320.0) * 0.40 + sin(t * TAU * 160.0) * 0.45) * exp(-t * 18.0)
		var spark_env := clampf((t - 0.05) * 20.0, 0.0, 1.0) * exp(-(t - 0.05) * 12.0) if t >= 0.05 else 0.0
		var spark := (sin(t * TAU * 2400.0) * 0.30 + sin(t * TAU * 4800.0) * 0.25) * spark_env
		var raw := (thud + spark) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## High Voltage Spark Sound: high voltage corona discharge snap across ceramic insulator (Scene 30)
static func create_high_voltage_spark_sound() -> AudioStreamWAV:
	var duration := 0.40
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 22.0)
		var crack := (sin(t * TAU * 4200.0) * 0.55 + sin(t * TAU * 8400.0) * 0.35)
		var ceramic := sin(t * TAU * 980.0) * 0.30 * exp(-t * 10.0)
		var raw := (crack + ceramic) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Power Grid Relay Sound: electromagnetic relay bank latching sequence (Scene 30)
static func create_power_grid_relay_sound() -> AudioStreamWAV:
	var duration := 0.70
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var raw := 0.0
		var t_relays := [0.05, 0.18, 0.32]
		var f_relays := [820.0, 1240.0, 960.0]
		for i in range(3):
			var tr: float = t_relays[i]
			if t >= tr:
				var dt := t - tr
				var renv := exp(-dt * 30.0)
				raw += sin(dt * TAU * f_relays[i]) * 0.40 * renv
		return clampf(raw * 0.85, -1.0, 1.0)
	)


## Station 30 Door Release Sound: electromagnetic lock deionization and heavy shielded gate unlatch (Scene 30)
static func create_station30_door_release_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.5)
		var freq_sweep := maxf(60.0, 180.0 - t * 140.0)
		var thud := sin(t * TAU * freq_sweep) * 0.55 * exp(-t * 6.0)
		var coil := sin(t * TAU * 640.0) * 0.35 * exp(-t * 4.0)
		var bolt := sin(t * TAU * 360.0) * 0.30 * exp(-t * 12.0)
		var raw := (thud + coil + bolt) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Eleven Chairs Whisper Sound: multi-voiced reverberant whisper of 11 erased passengers (Scene 31)
static func create_eleven_chairs_whisper_sound() -> AudioStreamWAV:
	var duration := 1.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 8.0))
		# 3 subtle resonant harmonic vocal formants
		var formant1 := sin(t * TAU * 320.0 + sin(t * TAU * 3.5) * 1.5) * 0.35
		var formant2 := sin(t * TAU * 480.0 + sin(t * TAU * 4.2) * 1.8) * 0.28
		var formant3 := sin(t * TAU * 540.0 + sin(t * TAU * 2.8) * 1.2) * 0.22
		# Atmospheric room breath noise modulation
		var breath := sin(t * TAU * 1250.0) * sin(t * TAU * 18.0) * 0.15
		var raw := (formant1 + formant2 + formant3 + breath) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Wierzbicka Recitation Chime Sound: cold solemn holographic chime calling erased names (Scene 31)
static func create_wierzbicka_recitation_chime_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.5)
		# Pristine dual chime (660 Hz + 880 Hz with 1320 Hz overtone)
		var chime := sin(t * TAU * 660.0) * 0.50 + sin(t * TAU * 880.0) * 0.35 + sin(t * TAU * 1320.0) * 0.20
		# Hologram carrier sub-carrier (4400 Hz faint ring)
		var holo := sin(t * TAU * 4400.0) * 0.10 * exp(-t * 12.0)
		var raw := (chime + holo) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Twelfth Chair Resonance Sound: melancholy chord of Jakub's solitary survival (Scene 31)
static func create_twelfth_chair_resonance_sound() -> AudioStreamWAV:
	var duration := 1.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI * 0.95) * exp(-progress * 1.8)
		# A-major triad root resonance (440 Hz + 554 Hz + 659 Hz)
		var chord := sin(t * TAU * 440.0) * 0.45 + sin(t * TAU * 554.37) * 0.32 + sin(t * TAU * 659.25) * 0.25
		# Wood chair tactile body hum (140 Hz)
		var wood := sin(t * TAU * 140.0) * 0.25 * exp(-t * 6.0)
		var raw := (chord + wood) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Variant Ledger Page Turn Sound: dry archive paper rustle and official UCP stamp thud (Scene 31)
static func create_variant_ledger_page_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 6.0)
		# Paper friction rustle (1600 Hz modulated noise)
		var paper := sin(t * TAU * 1600.0) * sin(t * TAU * 85.0) * 0.40 * exp(-t * 14.0)
		# Heavy official seal impact stamp at t=0.15
		var stamp := 0.0
		if t >= 0.12:
			var dt := t - 0.12
			stamp = (sin(dt * TAU * 280.0) * 0.60 + sin(dt * TAU * 120.0) * 0.40) * exp(-dt * 25.0)
		var raw := (paper + stamp) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Station 31 Pressure Hiss Sound: glass airlock decompression hiss into mirror corridor (Scene 31)
static func create_station31_pressure_hiss_sound() -> AudioStreamWAV:
	var duration := 1.25
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 2.2) * (1.0 - exp(-t * 60.0))
		# Pressurized gas expansion sweep (950 Hz down to 220 Hz)
		var f_sweep := maxf(220.0, 950.0 - t * 600.0)
		var hiss := sin(t * TAU * f_sweep) * sin(t * TAU * 3200.0) * 0.50
		# Structural glass seal mechanical unclamp (160 Hz)
		var seal := sin(t * TAU * 160.0) * 0.35 * exp(-t * 8.0)
		var raw := (hiss + seal) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Glass Condensation Wipe Sound: moist tactile friction of finger tracing steamed glass pane (Scene 32)
static func create_glass_condensation_wipe_sound() -> AudioStreamWAV:
	var duration := 0.75
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 15.0))
		# Moist rubbery squeak on glass (850 Hz sweeping to 1400 Hz)
		var f_squeak := 850.0 + sin(progress * PI * 2.0) * 550.0
		var squeak := sin(t * TAU * f_squeak) * 0.45
		# Glass pane resonance body (220 Hz)
		var glass_body := sin(t * TAU * 220.0) * 0.25 * exp(-t * 4.0)
		# Surface friction noise
		var friction := sin(t * TAU * 3600.0) * sin(t * TAU * 45.0) * 0.20
		var raw := (squeak + glass_body + friction) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Glass Stress Ring Sound: crystalline harmonic tension of structural glass pane (Scene 32)
static func create_glass_stress_ring_sound() -> AudioStreamWAV:
	var duration := 1.30
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.2) * (1.0 - exp(-t * 50.0))
		# Dual crystal harmonics (2200 Hz + 3300 Hz with 4400 Hz shimmer)
		var ring1 := sin(t * TAU * 2200.0) * 0.45
		var ring2 := sin(t * TAU * 3300.0) * 0.30
		var ring3 := sin(t * TAU * 4400.0) * 0.15
		var tremolo := 1.0 + sin(t * TAU * 8.0) * 0.25
		var raw := (ring1 + ring2 + ring3) * tremolo * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Fire Memory Rumble Sound: muffled rumble of fire and sirens trapped in cracked glass pane (Scene 32)
static func create_fire_memory_rumble_sound() -> AudioStreamWAV:
	var duration := 1.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		# Muffled low combustion rumble (90 Hz + 180 Hz)
		var fire := sin(t * TAU * 90.0 + sin(t * TAU * 4.0) * 2.0) * 0.45 + sin(t * TAU * 180.0) * 0.30
		# Distant doppler siren through glass (720 Hz modulated)
		var siren := sin(t * TAU * (720.0 + sin(t * TAU * 1.5) * 120.0)) * 0.20
		var crackle := sin(t * TAU * 4800.0) * sin(t * TAU * 22.0) * 0.15
		var raw := (fire + siren + crackle) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Consensus Stamp Reverberation Sound: clinical sterile metallic resonance of UCP consensus seal (Scene 32)
static func create_consensus_stamp_reverberation_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.0)
		# Sterile dual bell (520 Hz + 1040 Hz)
		var tone := sin(t * TAU * 520.0) * 0.55 + sin(t * TAU * 1040.0) * 0.35
		# Dampened metallic chassis (130 Hz)
		var chassis := sin(t * TAU * 130.0) * 0.30 * exp(-t * 10.0)
		var raw := (tone + chassis) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Station 32 Hatch Unseal Sound: mechanical unclamp and opening of vertical shaft hatch (Scene 32)
static func create_station32_hatch_unseal_sound() -> AudioStreamWAV:
	var duration := 1.00
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.8)
		# Heavy steel latch throw sweep (240 Hz down to 80 Hz)
		var f_sweep := maxf(80.0, 240.0 - t * 180.0)
		var thud := sin(t * TAU * f_sweep) * 0.55 * exp(-t * 8.0)
		# Metal latch squeak (480 Hz)
		var squeak := sin(t * TAU * 480.0) * 0.35 * exp(-t * 14.0)
		# Rebounding spring rattle at t=0.15
		var rattle := 0.0
		if t >= 0.15:
			var dt := t - 0.15
			rattle = sin(dt * TAU * 320.0) * 0.30 * exp(-dt * 20.0)
		var raw := (thud + squeak + rattle) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Ladder Rung Climb Sound: sharp metal clink of boots and hands gripping ladder rungs (Scene 33)
static func create_ladder_rung_climb_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 9.0)
		# Dual metal strike (620 Hz + 1240 Hz)
		var strike := sin(t * TAU * 620.0) * 0.60 + sin(t * TAU * 1240.0) * 0.35
		# Deep hollow pipe ringing (180 Hz)
		var pipe := sin(t * TAU * 180.0) * 0.40 * exp(-t * 5.0)
		var raw := (strike + pipe) * env * 0.88
		return tanh(raw) * 0.94
	)


## Depth Pressure Creak Sound: deep structural groan of steel shaft casing under ground stress (Scene 33)
static func create_depth_pressure_creak_sound() -> AudioStreamWAV:
	var duration := 1.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		# Infrasound ground groan (75 Hz + 150 Hz with pitch modulation)
		var f_mod := 75.0 + sin(t * TAU * 2.5) * 8.0
		var groan := sin(t * TAU * f_mod) * 0.55 + sin(t * TAU * 150.0) * 0.30
		# Metal stress friction creak (420 Hz harmonic)
		var creak := sin(t * TAU * 420.0) * sin(t * TAU * 18.0) * 0.25
		var raw := (groan + creak) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Cable Trunk Pulse Sound: electromagnetic pulsing hum of high-bandwidth memory bus trunk (Scene 33)
static func create_cable_trunk_pulse_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		# 110 Hz fundamental with 220 Hz octave and 880 Hz carrier pulse
		var f_pulse := 1.0 + sin(t * TAU * 6.0) * 0.40
		var hum := (sin(t * TAU * 110.0) * 0.50 + sin(t * TAU * 220.0) * 0.30) * f_pulse
		var carrier := sin(t * TAU * 880.0) * sin(t * TAU * 12.0) * 0.20
		var raw := (hum + carrier) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Shaft Work Light Hum Sound: inductive ballast hum and electrical buzz of industrial cage lamp (Scene 33)
static func create_shaft_work_light_hum_sound() -> AudioStreamWAV:
	var duration := 0.90
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.5)
		# 50 Hz power hum with 100 Hz harmonic and 1600 Hz starter flicker
		var hum := sin(t * TAU * 50.0) * 0.50 + sin(t * TAU * 100.0) * 0.35
		var flicker := sin(t * TAU * 1600.0) * sin(t * TAU * 25.0) * 0.18
		var raw := (hum + flicker) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 33 Lower Hatch Sound: massive hydraulic unclamp and descent into Core Engine Room (Scene 33)
static func create_station33_lower_hatch_sound() -> AudioStreamWAV:
	var duration := 1.35
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.8)
		# Massive low hydraulic thump sweep (140 Hz down to 40 Hz)
		var f_sweep := maxf(40.0, 140.0 - t * 90.0)
		var impact := sin(t * TAU * f_sweep) * 0.65 * exp(-t * 6.0)
		# Locking dogs mechanical unlatch (360 Hz)
		var dogs := sin(t * TAU * 360.0) * 0.35 * exp(-t * 12.0)
		var raw := (impact + dogs) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Core Reactor Pulse Sound: deep low hydraulic throb and rotational pulse of exchange core (Scene 34)
static func create_core_reactor_pulse_sound() -> AudioStreamWAV:
	var duration := 1.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		# 38 Hz infrasonic throb with 76 Hz harmonic and 320 Hz casing resonance
		var throb := sin(t * TAU * 38.0) * 0.55 + sin(t * TAU * 76.0) * 0.30
		var rotor := sin(t * TAU * 320.0) * sin(t * TAU * 4.0) * 0.20
		var raw := (throb + rotor) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Biography Slider Drag Sound: mechanical friction and detent notch clicks of brass allocation sliders (Scene 34)
static func create_biography_slider_drag_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.5)
		# Sliding metal friction (520/1040 Hz) with detent notch impulse at t=0.15s (210 Hz)
		var friction := (sin(t * TAU * 520.0) * 0.40 + sin(t * TAU * 1040.0) * 0.25) * (1.0 + sin(t * TAU * 30.0) * 0.5)
		var notch := 0.0
		if t >= 0.12 and t < 0.22:
			var nt := (t - 0.12) / 0.10
			notch = sin(nt * PI) * sin(t * TAU * 210.0) * 0.60
		var raw := (friction * 0.65 + notch * 0.55) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Core Thermal Alarm Sound: modulated warning tone of critical heat and contradiction pressure (Scene 34)
static func create_core_thermal_alarm_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		# Modulated alarm tone sweeping between 1400 Hz and 880 Hz
		var f_mod := 1140.0 + sin(t * TAU * 8.0) * 260.0
		var alarm := sin(t * TAU * f_mod) * 0.65 + sin(t * TAU * (f_mod * 2.0)) * 0.20
		var raw := alarm * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Jakub Diagnostic Probe Sound: synchronized digital signal sampling chirps (Scene 34)
static func create_jakub_diagnostic_probe_sound() -> AudioStreamWAV:
	var duration := 0.45
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 6.5)
		# Dual high-frequency sampling chirp (2400 Hz / 4800 Hz)
		var chirp := sin(t * TAU * 2400.0) * 0.55 + sin(t * TAU * 4800.0) * 0.35
		var raw := chirp * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 34 Filtration Gate Sound: pneumatic decompression and opening of heavy filtration gate (Scene 34)
static func create_station34_filtration_gate_sound() -> AudioStreamWAV:
	var duration := 1.50
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.4)
		# Low pneumatic sweep (160 Hz -> 50 Hz) and high hiss release (720 Hz)
		var f_sweep := maxf(50.0, 160.0 - t * 80.0)
		var rumble := sin(t * TAU * f_sweep) * 0.60 * exp(-t * 4.0)
		var hiss := (sin(t * TAU * 720.0) * cos(t * TAU * 1440.0)) * 0.35 * exp(-t * 3.0)
		var raw := (rumble + hiss) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Sedation Liquid Slosh Sound: viscous liquid slosh and popping gas bubbles in basin (Scene 35)
static func create_sedation_liquid_slosh_sound() -> AudioStreamWAV:
	var duration := 1.30
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		# Viscous liquid slosh wave (95 Hz modulated up to 160 Hz)
		var slosh := sin(t * TAU * (95.0 + sin(t * TAU * 4.0) * 35.0)) * 0.60
		# Popping sedation chemical bubbles (480 Hz ping bursts)
		var bubble := sin(t * TAU * 480.0) * sin(t * TAU * 18.0) * 0.25
		var raw := (slosh + bubble) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Sludge Drain Valve Creak Sound: cast-iron valve wheel turning and heavy sludge flow (Scene 35)
static func create_sludge_valve_creak_sound() -> AudioStreamWAV:
	var duration := 0.95
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.8)
		# Cast-iron wheel friction (320 Hz) with pipe sludge rush (1800 Hz)
		var friction := sin(t * TAU * 320.0) * 0.45 * (1.0 + sin(t * TAU * 24.0) * 0.5)
		var rush := (sin(t * TAU * 1800.0) * cos(t * TAU * 900.0)) * 0.35 * exp(-t * 1.5)
		var raw := (friction + rush) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Chemical Bubbler Sound: sparkling effervescent bubbling of sedative chemical in sampler (Scene 35)
static func create_chemical_bubbler_sound() -> AudioStreamWAV:
	var duration := 0.70
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.8)
		# Sparkling effervescent bubbling (800 Hz .. 2200 Hz frequency chirps)
		var f_chirp := 1200.0 + sin(t * TAU * 14.0) * 600.0
		var chirp := sin(t * TAU * f_chirp) * 0.50 + sin(t * TAU * 2200.0) * 0.25
		var raw := chirp * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Sedation Saturation Alarm Sound: muted chilling saturation chime (Scene 35)
static func create_sedation_saturation_alarm_sound() -> AudioStreamWAV:
	var duration := 0.80
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.2)
		# Two-tone chilling harmony (480 Hz + 720 Hz)
		var chime := sin(t * TAU * 480.0) * 0.55 + sin(t * TAU * 720.0) * 0.40
		var raw := chime * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 35 Drain Sluice Sound: rushing drain surge and sluice gate opening into Cold Drain (Scene 35)
static func create_station35_drain_sluice_sound() -> AudioStreamWAV:
	var duration := 1.45
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.2)
		# Heavy drain surge (220 Hz down to 60 Hz) and sluice rush (980 Hz)
		var f_sweep := maxf(60.0, 220.0 - t * 110.0)
		var surge := sin(t * TAU * f_sweep) * 0.65 * exp(-t * 3.0)
		var rush := (sin(t * TAU * 980.0) * cos(t * TAU * 490.0)) * 0.35 * exp(-t * 1.8)
		var raw := (surge + rush) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Storm Drain Torrent Sound: rushing torrent and turbulent flow in storm sewer (Scene 36)
static func create_storm_drain_torrent_sound() -> AudioStreamWAV:
	var duration := 1.60
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.6)
		# Sub-bass sewer flow (55/110 Hz) with turbulent water splash (450..2600 Hz noise texture)
		var bass := sin(t * TAU * 55.0) * 0.50 + sin(t * TAU * 110.0) * 0.30
		var turbulence := (sin(t * 5200.0) * cos(t * 2600.0) * sin(t * 1300.0)) * 0.35
		var splash := sin(t * TAU * 840.0) * 0.20 * exp(-t * 2.5)
		var raw := (bass + turbulence + splash) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Drain Weir Creak Sound: heavy cast-iron grating creak and trapped debris strain (Scene 36)
static func create_drain_weir_creak_sound() -> AudioStreamWAV:
	var duration := 0.95
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.0)
		# Iron grating vibration (280/560 Hz) with friction scrape (1600 Hz)
		var iron := sin(t * TAU * 280.0) * 0.55 + sin(t * TAU * 560.0) * 0.35
		var friction := (sin(t * 3200.0) * cos(t * 1600.0)) * 0.30
		var raw := (iron + friction) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Acid Ladder Clank Sound: metallic boot step on acid-resistant steel rung (Scene 36)
static func create_acid_ladder_clank_sound() -> AudioStreamWAV:
	var duration := 0.40
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 14.0) if t >= 0.002 else (t / 0.002)
		# Sharp metallic ring (740 Hz / 1480 Hz) with 280 Hz body
		var chime := sin(t * TAU * 740.0) * 0.60 + sin(t * TAU * 1480.0) * 0.30
		var body := sin(t * TAU * 280.0) * 0.40
		var raw := (chime + body) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Groundwater Leak Alarm Sound: pulsing alarm tone for chemical aquifer contamination (Scene 36)
static func create_groundwater_leak_alarm_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.8)
		# Two-tone pulsating dissonance (880 Hz + 1174 Hz modulated at 4 Hz)
		var mod := sin(t * TAU * 4.0) * 0.5 + 0.5
		var tone := sin(t * TAU * 880.0) * 0.50 + sin(t * TAU * 1174.0) * 0.40
		var raw := tone * (0.6 + mod * 0.4) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Station 36 Storm Gate Sound: heavy storm blast door unsealing and hydraulic lift (Scene 36)
static func create_station36_storm_gate_sound() -> AudioStreamWAV:
	var duration := 1.50
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.0)
		# Heavy decompression rumble (180 Hz down to 40 Hz) with hydraulic seal lift (820 Hz)
		var f_sweep := maxf(40.0, 180.0 - t * 90.0)
		var rumble := sin(t * TAU * f_sweep) * 0.65
		var lift := sin(t * TAU * 820.0) * 0.30 * exp(-t * 2.5)
		var raw := (rumble + lift) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Signal Antenna Carrier Sound: high frequency harmonic carrier and spire resonance (Scene 37)
static func create_signal_antenna_carrier_sound() -> AudioStreamWAV:
	var duration := 1.40
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.2)
		# Spire resonance carrier (1200 Hz with harmonic at 2400/3600 Hz and 580 Hz body)
		var carrier := sin(t * TAU * 1200.0) * 0.45 + sin(t * TAU * 2400.0) * 0.25 + sin(t * TAU * 3600.0) * 0.15
		var body := sin(t * TAU * 580.0) * 0.35
		var mod := sin(t * TAU * 6.0) * 0.3 + 0.7
		var raw := (carrier * mod + body) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Cross Patchbay Plug Sound: mechanical patch cable insertion and copper contact click (Scene 37)
static func create_cross_patchbay_plug_sound() -> AudioStreamWAV:
	var duration := 0.35
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 16.0) if t >= 0.002 else (t / 0.002)
		# Metallic jack insertion transient (680 Hz + 2100 Hz copper scrape)
		var click := sin(t * TAU * 680.0) * 0.60 + sin(t * TAU * 2100.0) * 0.40
		var scrape := (sin(t * 5600.0) * cos(t * 2800.0)) * 0.30 * exp(-t * 25.0)
		var raw := (click + scrape) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## CRT Sweep Interference Sound: vertical deflection line hum and Lissajous wave wobble (Scene 37)
static func create_crt_sweep_interference_sound() -> AudioStreamWAV:
	var duration := 0.90
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.6)
		# Line scan buzz (450 Hz) modulated by sub-harmonic sweep (150..600 Hz)
		var sweep := sin(t * TAU * (450.0 + sin(t * TAU * 12.0) * 120.0)) * 0.55
		var flyback := sin(t * TAU * 15625.0) * 0.15
		var raw := (sweep + flyback) * env * 0.80
		return clampf(raw, -1.0, 1.0)
	)


## Memory Injection Lever Sound: heavy industrial toggle switch click and channel engage (Scene 37)
static func create_memory_injection_lever_sound() -> AudioStreamWAV:
	var duration := 0.42
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 12.0) if t >= 0.002 else (t / 0.002)
		# Heavy toggle latch (540/1080 Hz) with spring body (190 Hz)
		var latch := sin(t * TAU * 540.0) * 0.60 + sin(t * TAU * 1080.0) * 0.35
		var spring := sin(t * TAU * 190.0) * 0.45 * exp(-t * 8.0)
		var raw := (latch + spring) * env * 0.90
		return tanh(raw) * 0.94
	)


## Station 37 Broadcast Gate Sound: broadcast chamber airlock seal release and electromagnetic hum (Scene 37)
static func create_station37_broadcast_gate_sound() -> AudioStreamWAV:
	var duration := 1.55
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.9)
		# Decompression sigh (310 Hz down to 75 Hz) with electromagnetic release ring (920 Hz)
		var f_sweep := maxf(75.0, 310.0 - t * 140.0)
		var sigh := sin(t * TAU * f_sweep) * 0.60
		var ring := sin(t * TAU * 920.0) * 0.35 * exp(-t * 2.2)
		var raw := (sigh + ring) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Accident Field Distortion Sound: gravitational and magnetic distortion in Line 4 memory anomaly (Scene 38)
static func create_accident_field_distortion_sound() -> AudioStreamWAV:
	var duration := 1.50
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.8)
		# Low frequency gravitational distortion (70 Hz down to 28 Hz) + high frequency shear sweep (1350 Hz)
		var f_sub := maxf(28.0, 70.0 - t * 28.0)
		var sub := sin(t * TAU * f_sub) * 0.65
		var shear := sin(t * TAU * (1350.0 + sin(t * TAU * 14.0) * 300.0)) * 0.25 * exp(-t * 2.4)
		var raw := (sub + shear) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Jakub Destabilization Hum Sound: voice formant tremor and matter decomposition rattle (Scene 38)
static func create_jakub_destabilization_hum_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.2)
		# Voice formant tremor (340 Hz + 510 Hz modulated by 7 Hz wobble)
		var mod := sin(t * TAU * 7.0) * 0.4 + 0.6
		var formant := (sin(t * TAU * 340.0) * 0.55 + sin(t * TAU * 510.0) * 0.40) * mod
		var hiss := (sin(t * 8200.0) * cos(t * 4100.0)) * 0.15 * exp(-t * 3.0)
		var raw := (formant + hiss) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Rescue Tether Chime Sound: resonant pure relational anchoring chime between siblings (Scene 38)
static func create_rescue_tether_chime_sound() -> AudioStreamWAV:
	var duration := 1.25
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.5) if t >= 0.002 else (t / 0.002)
		# Pure harmonious fifth chime (587.33 Hz D5 + 880.0 Hz A5)
		var chime := sin(t * TAU * 587.33) * 0.55 + sin(t * TAU * 880.0) * 0.40 + sin(t * TAU * 1174.66) * 0.15
		var raw := chime * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Coordinate Calculator Click Sound: mechanical calculation rejection and relay reset (Scene 38)
static func create_coordinate_calculator_click_sound() -> AudioStreamWAV:
	var duration := 0.38
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 14.0) if t >= 0.002 else (t / 0.002)
		# Industrial relay reset click (720 Hz + 180 Hz)
		var click := sin(t * TAU * 720.0) * 0.65 + sin(t * TAU * 180.0) * 0.45
		var raw := click * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Station 38 Reference Vault Door Sound: massive rotating locking vault unsealing to Reference Chamber (Scene 38)
static func create_station38_reference_vault_door_sound() -> AudioStreamWAV:
	var duration := 1.65
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.8)
		# Deep mechanical vault unlocking (110 Hz down to 32 Hz) with hydraulic ring release (860 Hz)
		var f_sweep := maxf(32.0, 110.0 - t * 48.0)
		var rumble := sin(t * TAU * f_sweep) * 0.65
		var hiss := sin(t * TAU * 860.0) * 0.30 * exp(-t * 2.1)
		var raw := (rumble + hiss) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Reference Core Harmonics Sound: Deep quantum harmonic triad resonance of central Substructure core (Scene 39)
static func create_reference_core_harmonics_sound() -> AudioStreamWAV:
	var duration := 2.2
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := sin(t / 2.2 * PI)
		# Harmonic triad fundamental 110/220/440 Hz with high shimmer 1760 Hz
		var fundamental := sin(t * TAU * 110.0) * 0.50
		var octave1 := sin(t * TAU * 220.0) * 0.35
		var octave2 := sin(t * TAU * 440.0) * 0.25
		var shimmer := sin(t * TAU * 1760.0 + sin(t * 8.0)) * 0.15
		var raw := (fundamental + octave1 + octave2 + shimmer) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Branch Configuration A Sound: Crystal Return vector resonance (523/1046/2093 Hz) (Scene 39)
static func create_branch_configuration_a_sound() -> AudioStreamWAV:
	var duration := 1.4
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.4) if t >= 0.01 else (t / 0.01)
		# C5 / C6 / C7 pure crystal vector chime
		var tone1 := sin(t * TAU * 523.25) * 0.55
		var tone2 := sin(t * TAU * 1046.5) * 0.35
		var tone3 := sin(t * TAU * 2093.0) * 0.20
		var raw := (tone1 + tone2 + tone3) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Branch Configuration B Sound: Warm brass Reconciliation chord (440/659/880 Hz) (Scene 39)
static func create_branch_configuration_b_sound() -> AudioStreamWAV:
	var duration := 1.5
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.1) if t >= 0.015 else (t / 0.015)
		# A4 / E5 / A5 warm relational consonance
		var tone1 := sin(t * TAU * 440.0) * 0.50
		var tone2 := sin(t * TAU * 659.25) * 0.35
		var tone3 := sin(t * TAU * 880.0) * 0.25
		var raw := (tone1 + tone2 + tone3) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Branch Configuration C Sound: Polyphonic Testimony resonance (330/495/660/990 Hz) (Scene 39)
static func create_branch_configuration_c_sound() -> AudioStreamWAV:
	var duration := 1.8
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.6) if t >= 0.02 else (t / 0.02)
		# E4 / B4 / E5 / B5 public multi-witness spread
		var tone1 := sin(t * TAU * 329.63) * 0.40
		var tone2 := sin(t * TAU * 493.88) * 0.30
		var tone3 := sin(t * TAU * 659.25) * 0.25
		var tone4 := sin(t * TAU * 987.77) * 0.20
		var raw := (tone1 + tone2 + tone3 + tone4) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Station 39 Act 4 Gateway Sound: memory stabilizer rupture and opening of Act IV (Scene 39)
static func create_station39_act4_gateway_sound() -> AudioStreamWAV:
	var duration := 1.9
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.5)
		# Sub-bass surge (85 Hz down to 20 Hz) with high pulse burst (1420 Hz)
		var f_sweep := maxf(20.0, 85.0 - t * 35.0)
		var sub := sin(t * TAU * f_sweep) * 0.70
		var pulse := sin(t * TAU * 1420.0 + sin(t * 12.0) * 2.0) * 0.28 * exp(-t * 3.0)
		var raw := (sub + pulse) * env * 0.92
		return clampf(raw, -1.0, 1.0)
	)


## Wierzbicka Personal Terminal Sound: Cool, composed director authorization tone (480/720/1080 Hz) (Scene 40)
static func create_wierzbicka_personal_terminal_sound() -> AudioStreamWAV:
	var duration := 1.5
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.5) if t >= 0.008 else (t / 0.008)
		# Institutional harmonic triad (480 Hz + 720 Hz + 1080 Hz with crisp sine clarity)
		var t1 := sin(t * TAU * 480.0) * 0.50
		var t2 := sin(t * TAU * 720.0) * 0.35
		var t3 := sin(t * TAU * 1080.0) * 0.20
		var chime := sin(t * TAU * 2160.0) * 0.12 * exp(-t * 8.0)
		var raw := (t1 + t2 + t3 + chime) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Marta Witness Presence Sound: Warm relational resonance (392/587 Hz + 1174 Hz) (Scene 40)
static func create_marta_witness_presence_sound() -> AudioStreamWAV:
	var duration := 1.6
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.2) if t >= 0.015 else (t / 0.015)
		# G4 (392 Hz) + D5 (587.33 Hz) + D6 (1174.66 Hz) with warm wood-like overtones
		var t1 := sin(t * TAU * 392.0) * 0.52
		var t2 := sin(t * TAU * 587.33) * 0.36
		var t3 := sin(t * TAU * 1174.66) * 0.18
		var breath := (sin(t * 3200.0) * cos(t * 1600.0)) * 0.06 * exp(-t * 3.0)
		var raw := (t1 + t2 + t3 + breath) * env * 0.86
		return clampf(raw, -1.0, 1.0)
	)


## Szymon Transmission Feed Sound: Analog radio-visual feed noise and drawing carrier (260/520 Hz + 1900 Hz) (Scene 40)
static func create_szymon_transmission_feed_sound() -> AudioStreamWAV:
	var duration := 1.4
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.0) if t >= 0.02 else (t / 0.02)
		# Szymon vocal carrier (260 Hz + 520 Hz) with CRT raster interference (1900 Hz + noise)
		var t1 := sin(t * TAU * 260.0) * 0.45
		var t2 := sin(t * TAU * 520.0) * 0.30
		var raster := sin(t * TAU * 1900.0 + sin(t * 24.0) * 3.0) * 0.15
		var radio_hiss := (sin(t * 8800.0) * cos(t * 4400.0)) * 0.14
		var raw := (t1 + t2 + raster + radio_hiss) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Cost Dossier Matrix Sound: Mechanical opening of the three-operation cost balance matrix (650 Hz + 220 Hz) (Scene 40)
static func create_cost_dossier_matrix_sound() -> AudioStreamWAV:
	var duration := 1.3
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.8) if t >= 0.005 else (t / 0.005)
		# Solenoid snap + matrix balance dual tone (220 Hz + 650 Hz + 1300 Hz)
		var sub := sin(t * TAU * 220.0) * 0.45
		var mid := sin(t * TAU * 650.0) * 0.40
		var high := sin(t * TAU * 1300.0) * 0.20
		var click := 0.0
		if t < 0.02:
			click = (1.0 - t / 0.02) * sin(t * TAU * 2800.0) * 0.4
		var raw := (sub + mid + high + click) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Station 40 Final Chamber Gate Sound: Heavy hydraulic unlatching of gate to Space 41 (95..24 Hz + 1120 Hz) (Scene 40)
static func create_station40_final_chamber_gate_sound() -> AudioStreamWAV:
	var duration := 1.8
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.6)
		# Sub-bass descent (95 Hz down to 24 Hz) with release pulse (1120 Hz)
		var f_sweep := maxf(24.0, 95.0 - t * 40.0)
		var sub := sin(t * TAU * f_sweep) * 0.68
		var pulse := sin(t * TAU * 1120.0) * 0.25 * exp(-t * 2.5)
		var raw := (sub + pulse) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Operation Return Execution Sound: Cutoff wave pulse and return vector (640/1280 Hz + crystalline sweep 2560 Hz) (Scene 41)
static func create_operation_return_execution_sound() -> AudioStreamWAV:
	var duration := 1.4
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.5) if t >= 0.01 else (t / 0.01)
		# Fundamental 640 Hz (E5) + octave 1280 Hz + crystalline sweep 2560 Hz
		var t1 := sin(t * TAU * 640.0) * 0.50
		var t2 := sin(t * TAU * 1280.0) * 0.32
		var sweep := sin(t * TAU * (2560.0 + sin(t * 18.0) * 120.0)) * 0.20 * exp(-t * 3.5)
		var click := 0.0
		if t < 0.015:
			click = (1.0 - t / 0.015) * sin(t * TAU * 3200.0) * 0.35
		var raw := (t1 + t2 + sweep + click) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Operation Reconciliation Execution Sound: Warm relational resonance and latching UCP bridge bolt (440/660/880 Hz) (Scene 41)
static func create_operation_reconciliation_execution_sound() -> AudioStreamWAV:
	var duration := 1.4
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 2.2) if t >= 0.015 else (t / 0.015)
		# A4 (440 Hz) + E5 (660 Hz) + A5 (880 Hz) warm relational triad with mechanical bolt snap
		var a4 := sin(t * TAU * 440.0) * 0.48
		var e5 := sin(t * TAU * 660.0) * 0.34
		var a5 := sin(t * TAU * 880.0) * 0.20
		var latch := 0.0
		if t < 0.03:
			latch = (1.0 - t / 0.03) * (sin(t * TAU * 220.0) * 0.4 + sin(t * TAU * 1450.0) * 0.3)
		var raw := (a4 + e5 + a5 + latch) * env * 0.86
		return clampf(raw, -1.0, 1.0)
	)


## Operation Testimony Execution Sound: Polyphonic multi-band harmonic resonance of witness mesh (330/495/660/990/1320 Hz) (Scene 41)
static func create_operation_testimony_execution_sound() -> AudioStreamWAV:
	var duration := 1.6
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.8) if t >= 0.02 else (t / 0.02)
		# 5-part polyphonic harmonic mesh: E4 (330 Hz), B4 (495 Hz), E5 (660 Hz), B5 (990 Hz), E6 (1320 Hz)
		var h1 := sin(t * TAU * 330.0) * 0.32
		var h2 := sin(t * TAU * 495.0) * 0.26
		var h3 := sin(t * TAU * 660.0) * 0.22
		var h4 := sin(t * TAU * 990.0) * 0.16
		var h5 := sin(t * TAU * 1320.0) * 0.12
		var shimmer := (sin(t * TAU * 4.0) * 0.08) * exp(-t * 1.5)
		var raw := (h1 + h2 + h3 + h4 + h5 + shimmer) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Operation Console Engage Sound: Industrial mechanical switch-in of operational choice stations (520 Hz + 140 Hz) (Scene 41)
static func create_operation_console_engage_sound() -> AudioStreamWAV:
	var duration := 0.9
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.6) if t >= 0.006 else (t / 0.006)
		# Dual industrial mechanical tone (140 Hz thud + 520 Hz solenoid ring + contact click)
		var sub := sin(t * TAU * 140.0) * 0.50
		var tone := sin(t * TAU * 520.0) * 0.40
		var click := 0.0
		if t < 0.018:
			click = (1.0 - t / 0.018) * sin(t * TAU * 2400.0) * 0.45
		var raw := (sub + tone + click) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Station 41 Act 4 Resolution Gate Sound: Sub-bass resolution chord unlatching passage to Epilogue Scenes 42A..C (120..30 Hz + 980 Hz) (Scene 41)
static func create_station41_act4_resolution_gate_sound() -> AudioStreamWAV:
	var duration := 1.8
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 1.5)
		# Sub-bass descending chord (120 Hz sweeping down to 30 Hz) with 980 Hz unseal chime
		var f_sweep := maxf(30.0, 120.0 - t * 50.0)
		var sub := sin(t * TAU * f_sweep) * 0.65
		var mid := sin(t * TAU * (f_sweep * 2.0)) * 0.25
		var chime := sin(t * TAU * 980.0) * 0.25 * exp(-t * 2.8)
		var raw := (sub + mid + chime) * env * 0.92
		return clampf(raw, -1.0, 1.0)
	)


## Epilogue Radio Announcement Sound: Analog municipal radio announcement feed about Line 4 (580/1160 Hz + static crackle) (Scene 43)
static func create_epilogue_radio_announcement_sound() -> AudioStreamWAV:
	var duration := 2.2
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 0.8) if t >= 0.05 else (t / 0.05)
		# AM radio carrier (580 Hz fundamental, 1160 Hz harmonic) with amplitude modulation
		var carrier := sin(t * TAU * 580.0) * 0.45 + sin(t * TAU * 1160.0) * 0.25
		var radio_am := (sin(t * TAU * 7.5) * 0.3 + 0.7)
		# Analog radio static crackle and hiss
		var crackle := (sin(t * 7800.0) * sin(t * 1420.0) * cos(t * 3100.0)) * 0.20
		var raw := (carrier * radio_am + crackle) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Epilogue Cup Clink Sound: Soft porcelain resonance of two laboratory cups on desk at 21:45 (1450/2900 Hz) (Scene 42A)
static func create_epilogue_cup_clink_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 9.0) if t >= 0.002 else (t / 0.002)
		var f0 := 1450.0
		var ring := sin(t * TAU * f0) * 0.55 + sin(t * TAU * (f0 * 2.0)) * 0.30
		var wood_table := sin(t * TAU * 220.0) * 0.25 * exp(-t * 22.0)
		var tap := 0.0
		if t < 0.006:
			tap = (1.0 - t / 0.006) * sin(t * TAU * 3800.0) * 0.4
		var raw := (ring + wood_table + tap) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Epilogue Tram Switch Latch Sound: Heavy mechanical track switch throw and flange contact (340 Hz + 1600 Hz) (Scene 42C)
static func create_epilogue_tram_switch_latch_sound() -> AudioStreamWAV:
	var duration := 1.2
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 3.0) if t >= 0.01 else (t / 0.01)
		# Mechanical lever throw (340 Hz metallic clank + 1600 Hz gear ratchet)
		var rail := sin(t * TAU * 340.0) * 0.50
		var ratchet := sin(t * TAU * 1600.0) * 0.30 * exp(-t * 8.0)
		var sub_thud := sin(t * TAU * 95.0) * 0.35 * exp(-t * 12.0)
		var raw := (rail + ratchet + sub_thud) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Epilogue Credits Drone Sound: Minimalist warm civic ambient drone for rolling credits (55/110/220 Hz) (Scene 43)
static func create_epilogue_credits_drone_sound() -> AudioStreamWAV:
	var duration := 2.5
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := sin((t / dur) * PI)
		# Subharmonic triad (55 Hz sub, 110 Hz fundamental, 220 Hz octave, 330 Hz fifth)
		var s55 := sin(t * TAU * 55.0) * 0.40
		var f110 := sin(t * TAU * 110.0) * 0.35
		var f220 := sin(t * TAU * 220.0) * 0.20
		var f330 := sin(t * TAU * 330.0) * 0.12 * (sin(t * TAU * 0.5) * 0.4 + 0.6)
		var raw := (s55 + f110 + f220 + f330) * env * 0.92
		return clampf(raw, -1.0, 1.0)
	)


## Epilogue Final Blackout Carrier Sound: Fading sine carrier drifting to pure silence before game end (Scene 43)
static func create_epilogue_final_carrier_sound() -> AudioStreamWAV:
	var duration := 1.5
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var env := pow(1.0 - (t / dur), 2.0)
		var f := maxf(0.0, 440.0 * (1.0 - (t / dur)))
		var carrier := sin(t * TAU * f) * 0.60
		var sub := sin(t * TAU * (f * 0.5)) * 0.30
		var raw := (carrier + sub) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Magnetic Resonance Hum Sound: 740 Hz carrier coupled with Kittel ferrimagnetic precession (740/1480 Hz + 48 Hz hum) (PKG-0086)
static func create_magnetic_resonance_hum_sound() -> AudioStreamWAV:
	var duration := 1.35
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 50.0))
		# 740 Hz fundamental carrier + 1480 Hz second harmonic + 48 Hz sub-bass iron tubing hum
		var carrier := sin(t * TAU * 740.0) * 0.48
		var harm := sin(t * TAU * 1480.0) * 0.24
		var sub_hum := sin(t * TAU * 48.0) * 0.38
		# Circular polarization modulation at 12 Hz
		var circ_mod := (sin(t * TAU * 12.0) * 0.15 + 0.85)
		var raw := (carrier + harm + sub_hum) * circ_mod * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Barkhausen Noise Sound: Microscopic magnetic domain switching avalanche noise in cast iron (PKG-0086)
static func create_barkhausen_noise_sound() -> AudioStreamWAV:
	var duration := 0.85
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.5) * (1.0 - exp(-t * 80.0))
		# Discrete stochastic pulse train mimicking domain wall jumps
		var crackle := sin(t * 31400.0) * cos(t * 15700.0) * sin(t * 47100.0) * 0.45
		var burst := sin(t * TAU * (1200.0 + sin(t * 180.0) * 450.0)) * 0.30 * exp(-fmod(t * 40.0, 1.0) * 12.0)
		var iron_thud := sin(t * TAU * 160.0) * 0.35 * exp(-t * 18.0)
		var raw := (crackle + burst + iron_thud) * env * 0.86
		return clampf(raw, -1.0, 1.0)
	)


## LLG Precession Whistle Sound: High-frequency damped spiral precession sweep (2400 Hz down to 740 Hz) (PKG-0086)
static func create_llg_precession_whistle_sound() -> AudioStreamWAV:
	var duration := 1.10
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 2.8) * (1.0 - exp(-t * 60.0))
		# Exponential spiral decay of frequency from 2400 Hz to asymptotic 740 Hz equilibrium
		var freq := 740.0 + 1660.0 * exp(-t * 6.0)
		var precession := sin(t * TAU * freq) * 0.62
		var overtone := sin(t * TAU * (freq * 2.0)) * 0.22 * exp(-t * 8.0)
		var gilbert_dissipation := (sin(t * 18500.0) * cos(t * 9200.0)) * 0.12 * exp(-t * 4.0)
		var raw := (precession + overtone + gilbert_dissipation) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Ferrimagnetic Switch Sound: Heavy electromagnetic latch and core remanence snap (320 Hz + 1850 Hz) (PKG-0086)
static func create_ferrimagnetic_switch_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 6.5) * (1.0 - exp(-t * 120.0))
		# High frequency contact snap
		var snap := sin(t * TAU * 1850.0) * 0.55 * exp(-t * 45.0)
		# Heavy core remanence thud
		var core := (sin(t * TAU * 320.0) * 0.50 + sin(t * TAU * 160.0) * 0.40) * exp(-t * 22.0)
		var raw := (snap + core) * env * 0.92
		return clampf(raw, -1.0, 1.0)
	)


## Onsager Thermoelectric Whistle Sound: Cross-coupled thermoelectric Seebeck/Peltier whistle (620..1840 Hz with thermal gradient modulation) (PKG-0087)
static func create_onsager_thermoelectric_whistle_sound() -> AudioStreamWAV:
	var duration := 1.25
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		# Frequency sweep corresponding to thermal-to-mass force coupling
		var f_seebeck := 740.0 + sin(t * TAU * 4.5) * 180.0 + 380.0 * (1.0 - progress)
		var tone := sin(t * TAU * f_seebeck) * 0.52
		var harm := sin(t * TAU * (f_seebeck * 1.5)) * 0.22 * exp(-t * 3.0)
		var peliter_sub := sin(t * TAU * 88.0) * 0.28
		var thermal_sizzle := (sin(t * 22000.0) * cos(t * 11000.0)) * 0.12 * exp(-progress * 2.0)
		var raw := (tone + harm + peliter_sub + thermal_sizzle) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Entropy Production Pulse Sound: Subharmonic base with harmonic density pulse proportional to entropy generation rate sigma >= 0 (PKG-0087)
static func create_entropy_production_pulse_sound() -> AudioStreamWAV:
	var duration := 0.95
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 4.2) * (1.0 - exp(-t * 90.0))
		# 58 Hz fundamental + 116 Hz / 232 Hz / 464 Hz harmonic stack
		var sub := sin(t * TAU * 58.0) * 0.45
		var h1 := sin(t * TAU * 116.0) * 0.30 * exp(-t * 2.5)
		var h2 := sin(t * TAU * 232.0) * 0.20 * exp(-t * 5.0)
		var h3 := sin(t * TAU * 464.0) * 0.15 * exp(-t * 8.0)
		var dissipation_pulse := sin(t * TAU * (740.0 * (1.0 - progress * 0.5))) * 0.18 * exp(-t * 6.0)
		var raw := (sub + h1 + h2 + h3 + dissipation_pulse) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Prigogine Relaxation Snap Sound: 920 Hz crystalline acoustic snap with sharp exponential decay to minimum dissipation state (PKG-0087)
static func create_prigogine_relaxation_snap_sound() -> AudioStreamWAV:
	var duration := 0.70
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 7.5) * (1.0 - exp(-t * 150.0))
		# High frequency crystal snap 920 Hz + 1840 Hz harmonic
		var snap := (sin(t * TAU * 920.0) * 0.60 + sin(t * TAU * 1840.0) * 0.35) * exp(-t * 35.0)
		# Low frequency stationary relaxation hum (44 Hz)
		var stationary_hum := sin(t * TAU * 44.0) * 0.40 * (1.0 - exp(-t * 20.0)) * exp(-t * 3.5)
		var raw := (snap + stationary_hum) * env * 0.92
		return clampf(raw, -1.0, 1.0)
	)


## Thermal Fluctuation Noise Sound: Colored Brownian-pink noise with Gaussian correlation flanger for Einstein-Onsager fluctuations (PKG-0087)
static func create_thermal_fluctuation_noise_sound() -> AudioStreamWAV:
	var duration := 1.15
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 60.0))
		# Multi-rate stochastic noise simulating Einstein-Onsager fluctuation spectrum
		var n1 := sin(t * 13371.0) * cos(t * 6843.0) * 0.35
		var n2 := sin(t * 34891.0) * sin(t * 17421.0) * 0.25
		var n3 := sin(t * TAU * (370.0 + sin(t * TAU * 2.5) * 60.0)) * 0.30
		var flanger := (sin(t * TAU * 0.75) * 0.2 + 0.8)
		var raw := (n1 + n2 + n3) * flanger * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Quantum Vacuum Whistle Sound: Zero-point micro-whistle (1480..3700 Hz with high-pass quantum flutter) (PKG-0088)
static func create_quantum_vacuum_whistle_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 50.0))
		# High frequency quantum zero-point flutter (1480 Hz to 3700 Hz sweep)
		var f_zpf := 1480.0 + 2220.0 * pow(progress, 1.5) + sin(t * TAU * 18.0) * 120.0
		var whistle := sin(t * TAU * f_zpf) * 0.48
		var overtone := sin(t * TAU * (f_zpf * 1.5)) * 0.22 * exp(-progress * 2.0)
		var flutter_noise := (sin(t * 28900.0) * cos(t * 14450.0)) * 0.15 * (sin(t * TAU * 32.0) * 0.3 + 0.7)
		var sub_carrier := sin(t * TAU * 740.0) * 0.18
		var raw := (whistle + overtone + flutter_noise + sub_carrier) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Casimir Cavity Hiss Sound: Fabry-Perot boundary compression resonance (880/1760 Hz with d^-4 force scaling) (PKG-0088)
static func create_casimir_cavity_hiss_sound() -> AudioStreamWAV:
	var duration := 1.05
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.8) * (1.0 - exp(-t * 80.0))
		# Boundary compression hiss modulated by 40 mm cavity modes
		var cavity_mode1 := sin(t * TAU * 880.0) * 0.45
		var cavity_mode2 := sin(t * TAU * 1760.0) * 0.28
		var boundary_hiss := (sin(t * 19600.0) * cos(t * 9800.0)) * 0.30 * exp(-t * 4.5)
		var compression_thump := sin(t * TAU * 110.0) * 0.35 * exp(-t * 15.0)
		var raw := (cavity_mode1 + cavity_mode2 + boundary_hiss + compression_thump) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Negative Energy Pulse Sound: Subharmonic bass pulse of vacuum stress tensor anisotropy T_zz != T_xx (36/72 Hz) (PKG-0088)
static func create_negative_energy_pulse_sound() -> AudioStreamWAV:
	var duration := 1.30
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		# Deep negative energy density sub-harmonic (36 Hz fundamental + 72 Hz / 144 Hz harmonic tensor stack)
		var sub36 := sin(t * TAU * 36.0) * 0.55
		var sub72 := sin(t * TAU * 72.0) * 0.32 * (sin(t * TAU * 3.2) * 0.2 + 0.8)
		var sub144 := sin(t * TAU * 144.0) * 0.20 * exp(-t * 2.0)
		var tensor_anisotropy_whine := sin(t * TAU * 740.0) * 0.12 * (1.0 - progress)
		var raw := (sub36 + sub72 + sub144 + tensor_anisotropy_whine) * env * 0.92
		return clampf(raw, -1.0, 1.0)
	)


## Lifshitz Retarded Snap Sound: Dielectric quartz/cast-iron surface attractive snap with retarded damping (1250/2500 Hz) (PKG-0088)
static func create_lifshitz_retarded_snap_sound() -> AudioStreamWAV:
	var duration := 0.65
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 6.8) * (1.0 - exp(-t * 140.0))
		# High frequency dielectric quartz snap (1250 Hz + 2500 Hz harmonic)
		var snap := (sin(t * TAU * 1250.0) * 0.58 + sin(t * TAU * 2500.0) * 0.32) * exp(-t * 38.0)
		# Retarded potential metallic contact thud (220 Hz + 440 Hz)
		var contact_thud := (sin(t * TAU * 220.0) * 0.45 + sin(t * TAU * 440.0) * 0.25) * exp(-t * 20.0)
		var dielectric_spark := (sin(t * 24500.0) * cos(t * 12250.0)) * 0.15 * exp(-t * 50.0)
		var raw := (snap + contact_thud + dielectric_spark) * env * 0.94
		return clampf(raw, -1.0, 1.0)
	)


## Substructure Cooling Chamber Drone: 48 Hz fundamental cavity resonance with refrigerant cycle hiss (PKG-0126)
static func create_cooling_chamber_drone_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		var sub24 := sin(t * TAU * 24.0) * 0.40
		var f48 := sin(t * TAU * 48.0) * 0.50
		var h96 := sin(t * TAU * 96.0) * 0.25 * (sin(t * TAU * 0.6) * 0.2 + 0.8)
		var h144 := sin(t * TAU * 144.0) * 0.15
		var refrigerant_hiss := (sin(t * 12345.0) * cos(t * 7890.0)) * 0.12 * (sin(t * TAU * 1.2) * 0.3 + 0.7)
		var raw := (sub24 + f48 + h96 + h144 + refrigerant_hiss) * env * 0.90
		return tanh(raw * 1.25) * 0.92
	)


## Substructure High Voltage Hum: 50/100/150/250 Hz mains electrical busway with dielectric ozone grain (PKG-0126)
static func create_high_voltage_hum_sound() -> AudioStreamWAV:
	var duration := 1.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 60.0))
		var m50 := sin(t * TAU * 50.0) * 0.48
		var m100 := sin(t * TAU * 100.0) * 0.28
		var m150 := sin(t * TAU * 150.0) * 0.18
		var m250 := sin(t * TAU * 250.0) * 0.12
		var corona_discharge := (sin(t * 18400.0) * sin(t * 9200.0)) * 0.14 * (sin(t * TAU * 25.0) * 0.35 + 0.65)
		var raw := (m50 + m100 + m150 + m250 + corona_discharge) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Substructure Hydraulic Echo: Heavy pressure compression pulse with multi-tap cavernous reflections (PKG-0126)
static func create_hydraulic_echo_sound() -> AudioStreamWAV:
	var duration := 1.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		# Initial pressure thump
		var env0 := exp(-t * 14.0) if t >= 0.002 else (t / 0.002)
		var sweep_f := lerpf(85.0, 35.0, clampf(t / 0.25, 0.0, 1.0))
		var thump := sin(t * TAU * sweep_f) * env0 * 0.65
		
		# Echo tap 1 at t=0.22s
		var echo1 := 0.0
		if t > 0.22:
			var dt1 := t - 0.22
			var env1 := exp(-dt1 * 9.0)
			echo1 = (sin(dt1 * TAU * 440.0) * 0.6 + sin(dt1 * TAU * 880.0) * 0.4) * env1 * 0.25
		
		# Echo tap 2 at t=0.48s
		var echo2 := 0.0
		if t > 0.48:
			var dt2 := t - 0.48
			var env2 := exp(-dt2 * 6.5)
			echo2 = (sin(dt2 * TAU * 330.0) * 0.7 + sin(dt2 * TAU * 660.0) * 0.3) * env2 * 0.18
			
		# Echo tap 3 at t=0.82s
		var echo3 := 0.0
		if t > 0.82:
			var dt3 := t - 0.82
			var env3 := exp(-dt3 * 4.5)
			echo3 = sin(dt3 * TAU * 220.0) * env3 * 0.10
			
		var tail := sin(t * TAU * 44.0) * exp(-t * 3.0) * 0.15
		var raw := thump + echo1 + echo2 + echo3 + tail
		return clampf(raw, -1.0, 1.0)
	)


## Substructure Ambient Sound: Cavernous structural rumble with ventilation and tension grain (PKG-0126)
static func create_substructure_ambient_sound() -> AudioStreamWAV:
	var duration := 2.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		var sub34 := sin(t * TAU * 34.0) * 0.52 * (sin(t * TAU * 0.4) * 0.15 + 0.85)
		var sub68 := sin(t * TAU * 68.0) * 0.28
		var vent_floor := (sin(t * 8800.0) * cos(t * 4400.0)) * 0.12
		var structural_strain := sin(t * TAU * (180.0 + sin(t * TAU * 0.8) * 30.0)) * 0.14 * exp(-progress * 2.0)
		var raw := (sub34 + sub68 + vent_floor + structural_strain) * env * 0.90
		return tanh(raw * 1.2) * 0.92
	)


## Finale 42A Sound: Forced return isolation theme (cold 740->370 Hz glide + institutional latch) (PKG-0126)
static func create_finale_42a_forced_return_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 3.2) * (1.0 - exp(-t * 50.0))
		var freq := lerpf(740.0, 370.0, pow(progress, 0.8))
		var chime := sin(t * TAU * freq) * 0.55
		var overtone := sin(t * TAU * (freq * 2.0)) * 0.22 * exp(-progress * 4.0)
		var strike := 0.0
		if t < 0.04:
			strike = (1.0 - t / 0.04) * (sin(t * TAU * 110.0) * 0.6 + sin(t * TAU * 550.0) * 0.4)
		var raw := (chime + overtone + strike * 0.35) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Finale 42B Sound: Seam closure theme (harmonic C3/G3/C4 chord fading to 55 Hz quiet ground) (PKG-0126)
static func create_finale_42b_closure_sound() -> AudioStreamWAV:
	var duration := 2.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		var c3 := sin(t * TAU * 130.81) * 0.40
		var g3 := sin(t * TAU * 196.00) * 0.30
		var c4 := sin(t * TAU * 261.63) * 0.22 * exp(-progress * 2.5)
		var e4 := sin(t * TAU * 329.63) * 0.15 * exp(-progress * 3.5)
		var ground55 := sin(t * TAU * 55.0) * 0.35 * (1.0 - progress * 0.4)
		var raw := (c3 + g3 + c4 + e4 + ground55) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Finale 42C Sound: Reciprocal passage theme (dual 660/740 Hz carrier with bilateral overtone synthesis) (PKG-0126)
static func create_finale_42c_reciprocal_passage_sound() -> AudioStreamWAV:
	var duration := 2.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 35.0))
		# Twin carrier frequencies with 4 Hz binaural drift
		var c1 := sin(t * TAU * 660.0) * 0.32
		var c2 := sin(t * TAU * 740.0) * 0.32 * (sin(t * TAU * 4.0) * 0.25 + 0.75)
		# Bilateral warm synthesis triad
		var c523 := sin(t * TAU * 523.25) * 0.24
		var e659 := sin(t * TAU * 659.25) * 0.18
		var g783 := sin(t * TAU * 783.99) * 0.14
		var shimmer := sin(t * TAU * 1480.0) * 0.10 * exp(-progress * 2.0)
		var sub := sin(t * TAU * 65.4) * 0.25
		var raw := (c1 + c2 + c523 + e659 + g783 + shimmer + sub) * env * 0.90
		return tanh(raw) * 0.94
	)


## Unease Tinnitus Sound: Subjective cognitive dissonance with 3840 Hz ringing and 58 Hz throb (PKG-0126)
static func create_unease_tinnitus_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 50.0))
		var ring := sin(t * TAU * 3840.0) * 0.48
		var throb := sin(t * TAU * 58.0) * 0.40 * (sin(t * TAU * 6.0) * 0.35 + 0.65)
		var wobble := sin(t * TAU * (58.0 + sin(t * TAU * 3.0) * 8.0)) * 0.20
		var raw := (ring + throb + wobble) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Residential Ambience Sound: Municipal/apartment quietude (110 Hz refrigerator + 42 Hz traffic floor) (PKG-0126)
static func create_residential_ambience_sound() -> AudioStreamWAV:
	var duration := 2.00
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		var hum110 := sin(t * TAU * 110.0) * 0.35
		var traffic42 := sin(t * TAU * 42.0) * 0.45 * (sin(t * TAU * 0.3) * 0.2 + 0.8)
		var room_noise := (sin(t * 6200.0) * cos(t * 3100.0)) * 0.08
		var raw := (hum110 + traffic42 + room_noise) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Terminal Hum Sound: CRT flyback line tone and institutional terminal processor hum (PKG-0126)
static func create_terminal_hum_sound() -> AudioStreamWAV:
	var duration := 1.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 45.0))
		var crt_whine := sin(t * TAU * 3125.0) * 0.22 + sin(t * TAU * 6250.0) * 0.12
		var psu_hum := sin(t * TAU * 120.0) * 0.45 + sin(t * TAU * 240.0) * 0.20
		var digital_grain := (sin(t * 14200.0) * sin(t * 7100.0)) * 0.10 * (sin(t * TAU * 18.0) * 0.4 + 0.6)
		var raw := (crt_whine + psu_hum + digital_grain) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Tunnel Rumble Sound: Line 4 junction standing wave resonance and tunnel draft (PKG-0126)
static func create_tunnel_rumble_sound() -> AudioStreamWAV:
	var duration := 2.00
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var pipe38 := sin(t * TAU * 38.0) * 0.50 * (sin(t * TAU * 0.5) * 0.2 + 0.8)
		var pipe76 := sin(t * TAU * 76.0) * 0.28
		var draft := (sin(t * 9600.0) * cos(t * 4800.0)) * 0.14 * (sin(t * TAU * 0.8) * 0.3 + 0.7)
		var raw := (pipe38 + pipe76 + draft) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Dawn Quietude Sound: Morning natural awakening chord (C Major 9 resolution) (PKG-0126)
static func create_dawn_quietude_sound() -> AudioStreamWAV:
	var duration := 2.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var c261 := sin(t * TAU * 261.63) * 0.35
		var e329 := sin(t * TAU * 329.63) * 0.28
		var g392 := sin(t * TAU * 392.00) * 0.22
		var b493 := sin(t * TAU * 493.88) * 0.15
		var d587 := sin(t * TAU * 587.33) * 0.10
		var sub := sin(t * TAU * 65.4) * 0.20
		var raw := (c261 + e329 + g392 + b493 + d587 + sub) * env * 0.85
		return tanh(raw) * 0.94
	)


# ==============================================================================
# PKG-0139: ACT SOUNDSCAPES, SURFACE MATERIALITY & DIALOGUE MODULATION
# ==============================================================================

## Terrazzo / Lastryko Footstep: Dense mineral tap with stairwell acoustic slapback (PKG-0139)
static func create_footstep_terrazzo_sound() -> AudioStreamWAV:
	var duration := 0.08
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 45.0) if t >= 0.002 else (t / 0.002)
		var tap := sin(t * TAU * 280.0) * 0.50 + sin(t * TAU * 480.0) * 0.30
		var stair_reverb := sin(t * TAU * 180.0) * 0.20 * exp(-t * 24.0)
		var friction := (sin(t * 7200.0) * cos(t * 3600.0)) * 0.15 * env
		var raw := (tap + stair_reverb + friction) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Wet Asphalt Footstep: Wet outdoor asphalt step with micro-splatter spray click (PKG-0139)
static func create_footstep_wet_asphalt_sound() -> AudioStreamWAV:
	var duration := 0.08
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 42.0) if t >= 0.002 else (t / 0.002)
		var body := sin(t * TAU * 140.0) * 0.45 + sin(t * TAU * 260.0) * 0.25
		var spray := 0.0
		if t < 0.015:
			var st := t / 0.015
			spray = (1.0 - st) * (sin(t * TAU * 2400.0) * 0.45 + (sin(t * 9800.0) - 0.5) * 0.35)
		var wet_friction := (sin(t * 8400.0) * cos(t * 4200.0)) * 0.18 * exp(-t * 28.0)
		var raw := (body * 0.6 + spray * 0.25 + wet_friction * 0.15) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Steel Grating Footstep: Crisp metallic tap with ringing resonant overtone (PKG-0139)
static func create_footstep_steel_grating_sound() -> AudioStreamWAV:
	var duration := 0.09
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 50.0) if t >= 0.001 else (t / 0.001)
		var ring := sin(t * TAU * 1180.0) * 0.45 + sin(t * TAU * 1860.0) * 0.30 + sin(t * TAU * 440.0) * 0.25
		var click := 0.0
		if t < 0.008:
			click = (1.0 - t / 0.008) * sin(t * TAU * 3400.0) * 0.45
		return clampf((ring * 0.65 + click * 0.35) * env * 0.85, -1.0, 1.0)
	)


## Hollow Deck Footstep: Resonant tram wooden/composite deck floor tap (PKG-0139)
static func create_footstep_hollow_deck_sound() -> AudioStreamWAV:
	var duration := 0.08
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 40.0) if t >= 0.002 else (t / 0.002)
		var cavity := sin(t * TAU * 140.0) * 0.55 + sin(t * TAU * 280.0) * 0.30
		var plank := sin(t * TAU * 460.0) * 0.20 * exp(-t * 30.0)
		var wood_grain := (sin(t * 5400.0) * cos(t * 2700.0)) * 0.12 * env
		var raw := (cavity + plank + wood_grain) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Surface Landing Sound: Impact cushion with surface-specific resonance (PKG-0139)
static func create_surface_land_sound(surface_type: int) -> AudioStreamWAV:
	var duration := 0.15
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 24.0) if t >= 0.003 else (t / 0.003)
		var low_impact := sin(t * TAU * 110.0) * 0.60 + sin(t * TAU * 175.0) * 0.40
		var surface_res := 0.0
		match surface_type:
			1: # TERRAZZO_STAIR
				surface_res = (sin(t * TAU * 280.0) * 0.35 + sin(t * TAU * 480.0) * 0.25) * exp(-t * 22.0)
			2: # WET_ASPHALT
				surface_res = ((sin(t * 8800.0) * cos(t * 4400.0)) * 0.30 + sin(t * TAU * 130.0) * 0.30) * exp(-t * 30.0)
			3: # STEEL_GRATING
				surface_res = (sin(t * TAU * 880.0) * 0.35 + sin(t * TAU * 1420.0) * 0.25) * exp(-t * 35.0)
			4: # HOLLOW_DECK
				surface_res = (sin(t * TAU * 140.0) * 0.40 + sin(t * TAU * 320.0) * 0.25) * exp(-t * 20.0)
			_: # LINOLEUM_TILE
				surface_res = sin(t * TAU * 380.0) * 0.20 * exp(-t * 45.0)
		return clampf((low_impact * 0.65 + surface_res * 0.35) * env * 0.90, -1.0, 1.0)
	)


## Dialogue Blip Synthesizer - Lena (587.33 Hz D5 warm amber harmonic) (PKG-0139)
static func create_dialogue_lena_blip_sound() -> AudioStreamWAV:
	var duration := 0.05
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 85.0) if t >= 0.001 else (t / 0.001)
		var f0 := sin(t * TAU * 587.33) * 0.70
		var f1 := sin(t * TAU * 1174.66) * 0.25
		var sub := sin(t * TAU * 293.66) * 0.15
		var raw := (f0 + f1 + sub) * env
		return clampf(tanh(raw * 1.2) * 0.70, -1.0, 1.0)
	)


## Dialogue Blip Synthesizer - dr Wierzbicka (520.0 Hz C5 authoritative crisp reed/bell formant) (PKG-0139)
static func create_dialogue_wierzbicka_blip_sound() -> AudioStreamWAV:
	var duration := 0.06
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 65.0) if t >= 0.001 else (t / 0.001)
		var f0 := sin(t * TAU * 520.0) * 0.55
		var f1 := sin(t * TAU * 1040.0) * 0.30
		var f2 := sin(t * TAU * 1560.0) * 0.20
		var crisp := 0.0
		if t < 0.005:
			crisp = (1.0 - t / 0.005) * sin(t * TAU * 3120.0) * 0.40
		var raw := (f0 + f1 + f2 + crisp) * env
		return clampf(raw * 0.75, -1.0, 1.0)
	)


## Dialogue Blip Synthesizer - System / Sterile Teletype (329.63 Hz E4 pulse) (PKG-0139)
static func create_dialogue_system_blip_sound() -> AudioStreamWAV:
	var duration := 0.045
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 95.0) if t >= 0.001 else (t / 0.001)
		var f0 := sin(t * TAU * 329.63) * 0.65
		var f1 := sin(t * TAU * 659.25) * 0.25
		var snap := 0.0
		if t < 0.003:
			snap = (1.0 - t / 0.003) * sin(t * TAU * 2600.0) * 0.45
		var raw := (f0 + f1 + snap) * env
		return clampf(raw * 0.68, -1.0, 1.0)
	)


## Universal Speaker Blip Dispatcher (PKG-0139)
static func create_dialogue_blip_for_speaker(speaker: Variant) -> AudioStreamWAV:
	var s := String(speaker).to_upper()
	if "LENA" in s:
		return create_dialogue_lena_blip_sound()
	elif "MARTA" in s:
		return create_dialogue_marta_blip_sound()
	elif "JAKUB" in s:
		return create_dialogue_jakub_blip_sound()
	elif "WIERZBICKA" in s:
		return create_dialogue_wierzbicka_blip_sound()
	elif "SZYMON" in s:
		return create_szymon_dialogue_blip_sound()
	else:
		return create_dialogue_system_blip_sound()


## Act I: Fluorescent Ballast Hum 50/100 Hz (PKG-0139)
static func create_act1_fluorescent_ballast_hum_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		var f50 := sin(t * TAU * 50.0) * 0.40
		var f100 := sin(t * TAU * 100.0) * 0.35
		var f200 := sin(t * TAU * 200.0) * 0.15
		var filament := sin(t * TAU * 12.5) * 0.08
		var gas_noise := (sin(t * 8900.0) * cos(t * 4450.0)) * 0.06
		var raw := (f50 + f100 + f200 + filament + gas_noise) * env * 0.75
		return clampf(raw, -1.0, 1.0)
	)


## Act I: Rain on Street & Windows Texture (PKG-0139)
static func create_act1_rain_ambience_sound() -> AudioStreamWAV:
	var duration := 2.00
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		var wash := sin(t * 11200.0) * cos(t * 5600.0) * 0.30
		var sub := sin(t * TAU * 62.0) * 0.15
		var window_patter := (sin(t * 7800.0) * sin(t * 3900.0)) * 0.20 * (sin(t * TAU * 4.0) * 0.3 + 0.7)
		var raw := (wash + sub + window_patter) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Act I: Bakelite Desk Telephone Bell (PKG-0139)
static func create_bakelite_telephone_ring_sound() -> AudioStreamWAV:
	var duration := 0.60
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 8.0) if t >= 0.005 else (t / 0.005)
		var g1 := sin(t * TAU * 440.0) * 0.45
		var g2 := sin(t * TAU * 480.0) * 0.40
		var flutter := 0.6 + 0.4 * sin(t * TAU * 25.0)
		var metal_ring := (sin(t * TAU * 1860.0) * 0.25 + sin(t * TAU * 2420.0) * 0.15) * exp(-t * 14.0)
		var raw := ((g1 + g2) * flutter + metal_ring) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Act II: Institutional HVAC Air Conditioning Ambient (PKG-0139)
static func create_institutional_hvac_ambient_sound() -> AudioStreamWAV:
	var duration := 2.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var duct_sub := sin(t * TAU * 48.0) * 0.45
		var fan_hum := sin(t * TAU * 144.0) * 0.25 + sin(t * TAU * 288.0) * 0.12
		var airflow := (sin(t * 5400.0) * cos(t * 2700.0)) * 0.16 * (sin(t * TAU * 0.4) * 0.2 + 0.8)
		var raw := (duct_sub + fan_hum + airflow) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Act II: Linoleum Corridor Reverb Cavity Resonance (PKG-0139)
static func create_linoleum_corridor_resonance_sound() -> AudioStreamWAV:
	var duration := 2.00
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		var cavity120 := sin(t * TAU * 120.0) * 0.35
		var cavity240 := sin(t * TAU * 240.0) * 0.25
		var fl_buzz := sin(t * TAU * 100.0) * 0.20
		var room_decay := (sin(t * 4800.0) * cos(t * 2400.0)) * 0.10
		var raw := (cavity120 + cavity240 + fl_buzz + room_decay) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Act II: Teletype Relay Clatter & Pulses (PKG-0139)
static func create_teletype_relay_ambience_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 40.0))
		var crt_sub := sin(t * TAU * 120.0) * 0.30
		var click_cycle := fmod(t, 0.18)
		var click_env := exp(-click_cycle * 80.0)
		var relay := sin(click_cycle * TAU * 1420.0) * click_env * 0.45
		var tape_hiss := (sin(t * 12400.0) * cos(t * 6200.0)) * 0.08
		var raw := (crt_sub + relay + tape_hiss) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Act II: Sterile Magnetic Latch (PKG-0139)
static func create_magnetic_latch_sterile_sound() -> AudioStreamWAV:
	var duration := 0.22
	return generate_wav(duration, func(t: float, _dur: float) -> float:
		var env := exp(-t * 30.0) if t >= 0.002 else (t / 0.002)
		var strike := sin(t * TAU * 420.0) * 0.55 + sin(t * TAU * 840.0) * 0.25
		var solenoid := sin(t * TAU * 1680.0) * 0.30
		var coil_hum := sin(t * TAU * 100.0) * 0.25 * exp(-t * 18.0)
		var raw := (strike + solenoid + coil_hum) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Act III: Infrasonic Transformer Hum 42/84 Hz (PKG-0139)
static func create_transformer_infrasound_sound() -> AudioStreamWAV:
	var duration := 2.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var f42 := sin(t * TAU * 42.0) * 0.50
		var f84 := sin(t * TAU * 84.0) * 0.30
		var f168 := sin(t * TAU * 168.0) * 0.15
		var oil_churn := (sin(t * 320.0) * cos(t * 160.0)) * 0.12 * (sin(t * TAU * 0.6) * 0.25 + 0.75)
		var raw := (f42 + f84 + f168 + oil_churn) * env * 0.90
		return clampf(raw, -1.0, 1.0)
	)


## Act III: Shaft Water Dripping Echo (PKG-0139)
static func create_shaft_water_drip_echo_sound() -> AudioStreamWAV:
	var duration := 2.00
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		var shaft_drone := sin(t * TAU * 52.0) * 0.35 + sin(t * TAU * 104.0) * 0.20
		var draft := (sin(t * 8200.0) * cos(t * 4100.0)) * 0.12
		var drops := 0.0
		var drop_times: Array[float] = [0.25, 0.72, 1.18, 1.65]
		for dt in drop_times:
			if t >= dt and t < dt + 0.12:
				var local_t := t - dt
				var drop_env := exp(-local_t * 35.0) if local_t >= 0.002 else (local_t / 0.002)
				var ping := sin(local_t * TAU * 1620.0) * 0.45 + sin(local_t * TAU * 810.0) * 0.25
				drops += ping * drop_env * 0.55
		var raw := (shaft_drone + draft + drops) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Act III: Tempered Glass Stress Resonance (PKG-0139)
static func create_tempered_glass_resonance_sound() -> AudioStreamWAV:
	var duration := 1.80
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		var vib := sin(t * TAU * 2.5) * 6.0
		var g1 := sin(t * TAU * (1280.0 + vib)) * 0.40
		var g2 := sin(t * TAU * (2560.0 + vib * 1.5)) * 0.22
		var sub := sin(t * TAU * 72.0) * 0.25
		var glass_scratch := (sin(t * 14200.0) * cos(t * 7100.0)) * 0.08
		var raw := (g1 + g2 + sub + glass_scratch) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## Act III: Riveted Catwalk Structural Creak (PKG-0139)
static func create_riveted_catwalk_creak_sound() -> AudioStreamWAV:
	var duration := 1.90
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var iron_groan := sin(t * TAU * 88.0 + sin(t * TAU * 4.0) * 1.2) * 0.40
		var structural_thud := sin(t * TAU * 176.0) * 0.25
		var rivet_friction := (sin(t * 6800.0) * cos(t * 3400.0)) * 0.15 * (sin(t * TAU * 1.2) * 0.4 + 0.6)
		var raw := (iron_groan + structural_thud + rivet_friction) * env * 0.88
		return clampf(raw, -1.0, 1.0)
	)


## Act IV: Correction Tension Swell Wave (PKG-0139)
static func create_correction_tension_swell_sound() -> AudioStreamWAV:
	var duration := 2.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var sweep_freq := lerpf(44.0, 110.0, sin(progress * PI))
		var sub_swell := sin(t * TAU * sweep_freq) * 0.55
		var cinnabar_grit := (sin(t * 8800.0) * cos(t * 4400.0)) * 0.18 * (sin(t * TAU * 8.0) * 0.3 + 0.7)
		var tension_tone := sin(t * TAU * 330.0) * 0.25 * (progress * 0.5 + 0.5)
		var raw := (sub_swell + cinnabar_grit + tension_tone) * env * 0.90
		return clampf(tanh(raw * 1.3) * 0.90, -1.0, 1.0)
	)


## Act IV & Finales: Tri-Path Harmonic Resonance (PKG-0139)
static func create_tri_path_resonance_sound() -> AudioStreamWAV:
	var duration := 2.50
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		var cyan740 := sin(t * TAU * 740.0) * 0.35 # Powrót / Anchor
		var amber440 := sin(t * TAU * 440.0) * 0.30 # Świadectwo / Relation
		var oxide330 := sin(t * TAU * 330.0) * 0.25 # Uzgodnienie / Compliance
		var sub65 := sin(t * TAU * 65.4) * 0.20
		var raw := (cyan740 + amber440 + oxide330 + sub65) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


# ─── PKG-0140: sprzezenie audiowizualne Anchor / Yield i haptyka interakcji ────

## Buduje strumien z domknieta petla do ciaglego podtrzymania tonu.
## `generate_wav` daje bufor jednorazowy; ton kotwicy musi brzmiec tak dlugo,
## jak dlugo gracz trzyma rekwizyt, wiec dostaje jawna petle do przodu (D-146).
static func generate_looping_wav(duration: float, generator_func: Callable) -> AudioStreamWAV:
	var wav := generate_wav(duration, generator_func)
	var frames := wav.data.size() / 2
	wav.loop_mode = AudioStreamWAV.LOOP_FORWARD
	wav.loop_begin = 0
	wav.loop_end = maxi(1, frames - 1)
	return wav


## Chwyt kotwicy: krotki, dotykowy zatrzask przed pelnym zakotwiczeniem.
## To dzwiek reki na przedmiocie, nie potwierdzenie systemu — stad brak tonu
## harmonicznego i bardzo krotka obwiednia.
static func create_anchor_grip_sound() -> AudioStreamWAV:
	var duration := 0.11
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 9.0) if t >= 0.002 else (t / 0.002)
		var contact := (sin(t * 5300.0) * cos(t * 2190.0)) * 0.55
		var body := sin(t * TAU * 196.0) * 0.35 + sin(t * TAU * 392.0) * 0.18
		return clampf((contact * 0.45 + body * 0.55) * env * 0.62, -1.0, 1.0)
	)


## Ton podtrzymany trzymanej kotwicy: cyjanowa harmoniczna F#5 z powolnym
## dudnieniem. Petla 1.20 s zawiera calkowita liczbe okresow wszystkich
## skladowych, wiec zapetla sie bez trzasku.
static func create_anchor_sustain_tone_sound() -> AudioStreamWAV:
	var duration := 1.20
	return generate_looping_wav(duration, func(t: float, _dur: float) -> float:
		# 740.0 -> 888 okresow, 1110.0 -> 1332, 370.0 -> 444, 2.5 Hz -> 3 okresy.
		var f0 := sin(t * TAU * 740.0) * 0.42
		var fifth := sin(t * TAU * 1110.0) * 0.16
		var sub := sin(t * TAU * 370.0) * 0.22
		var beat := 0.82 + 0.18 * sin(t * TAU * 2.5)
		return clampf((f0 + fifth + sub) * beat * 0.55, -1.0, 1.0)
	)


## Zwolnienie kotwicy: harmoniczna rozprzega sie w dol i wygasa w oddech.
static func create_anchor_release_sound() -> AudioStreamWAV:
	var duration := 0.34
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := (1.0 - progress) * (1.0 - progress * 0.4)
		var freq := lerpf(740.0, 288.0, progress * progress)
		var tone := sin(t * TAU * freq) * 0.7 + sin(t * TAU * freq * 1.5) * 0.15
		var air := (sin(t * 3100.0) * cos(t * 1450.0)) * 0.12 * progress
		return clampf((tone + air) * env * 0.6, -1.0, 1.0)
	)


## Uleglosc: rekwizyt przyjmuje korekte. Opadajaca kwinta w stronie tlenkowej,
## bez transjentu — ustapienie nie jest uderzeniem.
static func create_yield_collapse_sound() -> AudioStreamWAV:
	var duration := 0.46
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var attack := minf(1.0, t / 0.03)
		var env := attack * exp(-progress * 3.6)
		var freq := lerpf(494.0, 165.0, sqrt(progress))
		var tone := sin(t * TAU * freq) * 0.62 + sin(t * TAU * freq * 0.5) * 0.28
		var oxide := sin(t * TAU * 82.0) * 0.24 * progress
		return clampf(tanh((tone + oxide) * 1.15) * env * 0.72, -1.0, 1.0)
	)


## Przesuwanie zakotwiczalnego rekwizytu po podlozu: zapetlone tarcie.
## Miksowane glosnoscia proporcjonalna do predkosci, wiec cichnie samo.
static func create_prop_drag_scrape_sound() -> AudioStreamWAV:
	var duration := 0.80
	return generate_looping_wav(duration, func(t: float, _dur: float) -> float:
		var grain := (sin(t * 6100.0) * cos(t * 2830.0) + sin(t * 9700.0) * 0.4) * 0.30
		var body := sin(t * TAU * 110.0) * 0.16 + sin(t * TAU * 55.0) * 0.10
		var swell := 0.78 + 0.22 * sin(t * TAU * 3.75)
		return clampf((grain + body) * swell * 0.7, -1.0, 1.0)
	)


## Haptyka: mikro-stuk kontaktu, gdy Lena wchodzi w zasieg punktu pamieci.
## Ma byc slyszalny jako obecnosc, nie jako powiadomienie — stad 45 ms i
## bardzo niski poziom.
static func create_contact_tap_sound() -> AudioStreamWAV:
	var duration := 0.045
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := exp(-progress * 11.0) if t >= 0.001 else (t / 0.001)
		var tap := sin(t * TAU * 1240.0) * 0.5 + sin(t * TAU * 2480.0) * 0.2
		var wood := (sin(t * 4700.0) - 0.5) * 0.25
		return clampf((tap + wood) * env * 0.34, -1.0, 1.0)
	)


## Haptyka: zapadka przelacznika. Dwuczesciowa — opor sprezyny i zatrzask.
static func create_switch_detent_sound() -> AudioStreamWAV:
	var duration := 0.085
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var spring := 0.0
		if progress < 0.42:
			var sp := progress / 0.42
			spring = sin(sp * PI) * sin(t * TAU * 620.0) * 0.32
		var detent := 0.0
		if progress >= 0.42:
			var dp := (progress - 0.42) / 0.58
			detent = exp(-dp * 7.5) * (sin(t * TAU * 1680.0) * 0.45 + (sin(t * 5900.0) - 0.5) * 0.3)
		return clampf((spring + detent) * 0.55, -1.0, 1.0)
	)


## Haptyka: badanie punktu pamieci koncem palca — miekki, matowy odczyt.
static func create_probe_brush_sound() -> AudioStreamWAV:
	var duration := 0.16
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI)
		var brush := (sin(t * 3900.0) * cos(t * 1770.0)) * 0.42
		var warmth := sin(t * TAU * 262.0) * 0.18
		return clampf((brush + warmth) * env * 0.30, -1.0, 1.0)
	)


# ─── PKG-0180: Wzbogacenie proceduralnych pętli otoczenia (Ambient Soundscapes) ────

## PKG-0180: Outdoor Viaduct Wind Ambient (Station 02)
static func create_outdoor_viaduct_wind_sound() -> AudioStreamWAV:
	var duration := 2.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		var city_rumble := sin(t * TAU * 55.0) * (0.8 + 0.2 * sin(t * TAU * 0.4)) * 0.35
		var viaduct_sub := sin(t * TAU * 110.0) * 0.20
		var wind_wash := (sin(t * 920.0 * TAU) * cos(t * 460.0 * TAU)) * 0.28 * (0.75 + 0.25 * sin(t * TAU * 1.1))
		var high_air := (sin(t * 11800.0) * cos(t * 5900.0)) * 0.12 * (0.7 + 0.3 * cos(t * TAU * 1.8))
		var raw := (city_rumble + viaduct_sub + wind_wash + high_air) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## PKG-0180: Outdoor Perimeter Platform Wind Ambient (Station 04)
static func create_outdoor_perimeter_wind_sound() -> AudioStreamWAV:
	var duration := 2.40
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var sub := sin(t * TAU * 42.0) * (0.85 + 0.15 * sin(t * TAU * 0.6)) * 0.40
		var rail_friction := sin(t * TAU * 1420.0) * 0.10 * exp(-fmod(t, 0.6) * 12.0)
		var open_wind := (sin(t * 780.0 * TAU) * cos(t * 390.0 * TAU)) * 0.32 * (0.8 + 0.2 * sin(t * TAU * 0.9))
		var air_noise := (sin(t * 13200.0) * cos(t * 6600.0)) * 0.14
		var raw := (sub + rail_friction + open_wind + air_noise) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## PKG-0180: Subterranean Substation Transformer Resonance (Station 14)
static func create_subterranean_substation_resonance_sound() -> AudioStreamWAV:
	var duration := 2.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		var f50 := sin(t * TAU * 50.0) * 0.42
		var f100 := sin(t * TAU * 100.0) * 0.32
		var vault_sub := sin(t * TAU * 34.0) * 0.38 * (0.85 + 0.15 * sin(t * TAU * 0.5))
		var ucp_field := sin(t * TAU * 330.0) * 0.12 * (0.8 + 0.2 * sin(t * TAU * 2.0))
		var gas_hum := (sin(t * 6400.0) * cos(t * 3200.0)) * 0.08
		var raw := (f50 + f100 + vault_sub + ucp_field + gas_hum) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## PKG-0180: Signal Vault Subterranean Resonance (Station 15)
static func create_signal_vault_resonance_sound() -> AudioStreamWAV:
	var duration := 2.30
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		var chamber44 := sin(t * TAU * 44.0) * 0.45 * (0.9 + 0.1 * sin(t * TAU * 0.7))
		var cavity88 := sin(t * TAU * 88.0) * 0.25
		var cyan_trace := sin(t * TAU * 740.0) * 0.14 * (0.7 + 0.3 * sin(t * TAU * 1.5))
		var cold_air := (sin(t * 8400.0) * cos(t * 4200.0)) * 0.11
		var raw := (chamber44 + cavity88 + cyan_trace + cold_air) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## PKG-0180: Safe Analyzer Cooling Conduit Drone (Station 16)
static func create_analyzer_cooling_conduit_drone_sound() -> AudioStreamWAV:
	var duration := 2.20
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 25.0))
		var duct40 := sin(t * TAU * 40.0) * 0.46
		var duct80 := sin(t * TAU * 80.0) * 0.26
		var coolant := (sin(t * 3600.0) * cos(t * 1800.0)) * 0.16 * (0.8 + 0.2 * sin(t * TAU * 3.2))
		var air_intake := (sin(t * 7200.0) * cos(t * 3600.0)) * 0.10 * (sin(t * TAU * 0.5) * 0.3 + 0.7)
		var raw := (duct40 + duct80 + coolant + air_intake) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## PKG-0180: Archive Consent Ledger Acoustic Resonance (Station 17)
static func create_archive_ledger_resonance_sound() -> AudioStreamWAV:
	var duration := 2.10
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 30.0))
		var vault52 := sin(t * TAU * 52.0) * 0.40
		var vault104 := sin(t * TAU * 104.0) * 0.22
		var tape_flutter := (sin(t * 9400.0) * cos(t * 4700.0)) * 0.12 * (0.85 + 0.15 * sin(t * TAU * 6.0))
		var room_acoustic := sin(t * TAU * 220.0) * 0.15 * (0.7 + 0.3 * sin(t * TAU * 0.8))
		var raw := (vault52 + vault104 + tape_flutter + room_acoustic) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)


## PKG-0180: Dawn Riverbank & Morning Air Ambience (Station 43)
static func create_dawn_river_ambience_sound() -> AudioStreamWAV:
	var duration := 2.60
	return generate_wav(duration, func(t: float, dur: float) -> float:
		var progress := t / dur
		var env := sin(progress * PI) * (1.0 - exp(-t * 20.0))
		var c261 := sin(t * TAU * 261.63) * 0.30
		var e329 := sin(t * TAU * 329.63) * 0.24
		var g392 := sin(t * TAU * 392.00) * 0.18
		var b493 := sin(t * TAU * 493.88) * 0.12
		var river_wind := (sin(t * 750.0 * TAU) * cos(t * 375.0 * TAU)) * 0.22 * (0.75 + 0.25 * sin(t * TAU * 0.8))
		var water_shimmer := (sin(t * 11400.0) * cos(t * 5700.0)) * 0.10 * (0.7 + 0.3 * sin(t * TAU * 2.5))
		var sub := sin(t * TAU * 65.4) * 0.18
		var raw := (c261 + e329 + g392 + b493 + river_wind + water_shimmer + sub) * env * 0.85
		return clampf(raw, -1.0, 1.0)
	)
