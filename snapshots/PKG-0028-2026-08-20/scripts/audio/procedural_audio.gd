class_name ProceduralAudio
extends RefCounted

## Procedural audio generator for Getting Strange.
## Synthesizes clean 16-bit PCM AudioStreamWAV streams without external audio assets.
## Timbral character derived from VISUAL_DESIGN.md (clinical institutional order,
## cool cyan #75C7C3 anchor resonance, oxide cinnabar #C65D58 correction rumble).

const SAMPLE_RATE: int = 44100


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
		return clampf(raw * 0.95, -1.0, 1.0)
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
		return clampf(raw, -1.0, 1.0)
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
		return clampf(raw, -1.0, 1.0)
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








