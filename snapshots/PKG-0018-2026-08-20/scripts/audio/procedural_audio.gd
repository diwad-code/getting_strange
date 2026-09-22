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
