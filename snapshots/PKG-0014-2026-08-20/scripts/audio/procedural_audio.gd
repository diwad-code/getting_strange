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
