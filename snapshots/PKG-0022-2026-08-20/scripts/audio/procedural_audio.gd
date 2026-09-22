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



