class_name AnchorableObject
extends AnimatableBody2D

enum RealityState {
	STATE_A = 0,
	STATE_B = 1,
}

signal anchor_state_changed(is_anchored: bool)
signal reality_shift_processed(target_state: RealityState, resisted: bool)

const COLOR_PLATFORM := Color("263943")
const COLOR_EDGE := Color("66747a")
const COLOR_ANCHOR_CYAN := Color("75c7c3")
const COLOR_CORRECTION_CINNABAR := Color("c65d58")
const COLOR_GHOST_A := Color(0.46, 0.78, 0.76, 0.25)
const COLOR_GHOST_B := Color(0.78, 0.36, 0.35, 0.20)

@export var state_a_position: Vector2 = Vector2.ZERO
@export var state_b_position: Vector2 = Vector2.ZERO
@export var state_a_size: Vector2 = Vector2(64.0, 20.0)
@export var state_b_size: Vector2 = Vector2(64.0, 20.0)
@export var state_a_solid: bool = true
@export var state_b_solid: bool = true
@export var interaction_radius: float = 56.0
@export var object_name: String = "Anchorable Object"

var _is_anchored: bool = false
var is_anchored: bool:
	get:
		return _is_anchored
	set(value):
		if _is_anchored == value:
			return
		_is_anchored = value
		if _is_anchored:
			_resonance.hold()
		else:
			_resonance.release()
		if is_node_ready():
			if _is_anchored:
				_play_sfx(_anchor_sound)
				_play_haptic(_grip_sound)
				_start_sustain()
				if _anchor_particles:
					_anchor_particles.emitting = true
			else:
				_play_sfx(_unanchor_sound)
				_play_haptic(_release_sound)
				if _anchor_particles:
					_anchor_particles.emitting = false
		anchor_state_changed.emit(_is_anchored)
		queue_redraw()

var current_reality: RealityState = RealityState.STATE_A
var _is_player_in_range: bool = false
var is_player_in_range: bool:
	get:
		return _is_player_in_range
	set(value):
		if _is_player_in_range == value:
			return
		_is_player_in_range = value
		queue_redraw()

var _current_size: Vector2 = Vector2(64.0, 20.0)
var _collision_shape: CollisionShape2D
var _rect_shape: RectangleShape2D
var _tween: Tween
var _pulse_phase: float = 0.0
var _flash_color: Color = Color.TRANSPARENT
var _flash_intensity: float = 0.0

var _audio_player: AudioStreamPlayer2D
var _anchor_sound: AudioStreamWAV
var _unanchor_sound: AudioStreamWAV
var _resist_sound: AudioStreamWAV

## PKG-0140 (D-146). Chwyt, przesuniecie i zwolnienie kotwicy to trzy rozne
## gesty; wspolna obwiednia `AnchorResonance` prowadzi je zarowno w rysunku,
## jak i w miksie tonu harmonicznego.
var _resonance := AnchorResonance.new()
## Dotyk i ton podtrzymany ida przez wspoldzielone glosy stacji (D-149):
## budzet klatki dopuszcza 20 odtwarzaczy na stacje, a Lena i tak trzyma jedna
## rzecz naraz, wiec wlasny wezel przy kazdym rekwizycie byl czystym kosztem.
var _grip_sound: AudioStreamWAV
var _release_sound: AudioStreamWAV
var _yield_sound: AudioStreamWAV
var _sustain_sound: AudioStreamWAV

var _anchor_particles: CPUParticles2D
var _resist_particles: CPUParticles2D


func _ready() -> void:
	if state_a_position == Vector2.ZERO and state_b_position == Vector2.ZERO:
		state_a_position = position
		state_b_position = position

	_current_size = state_a_size
	_setup_collision()
	_setup_audio()
	_setup_particles()
	_update_to_reality(RealityState.STATE_A, false)


func _setup_collision() -> void:
	sync_to_physics = true
	_collision_shape = get_node_or_null("CollisionShape2D") as CollisionShape2D
	if _collision_shape == null:
		_collision_shape = CollisionShape2D.new()
		_collision_shape.name = "CollisionShape2D"
		add_child(_collision_shape)

	if _collision_shape.shape is RectangleShape2D:
		_rect_shape = _collision_shape.shape as RectangleShape2D
	else:
		_rect_shape = RectangleShape2D.new()
		_collision_shape.shape = _rect_shape

	_rect_shape.size = _current_size


func _setup_audio() -> void:
	_audio_player = get_node_or_null("AudioPlayer2D") as AudioStreamPlayer2D
	if _audio_player == null:
		_audio_player = AudioStreamPlayer2D.new()
		_audio_player.name = "AudioPlayer2D"
		_audio_player.max_distance = 600.0
		_audio_player.bus = &"Master"
		add_child(_audio_player)

	_anchor_sound = ProceduralAudio.get_cached_sound(&"anchor", ProceduralAudio.create_anchor_sound)
	_unanchor_sound = ProceduralAudio.get_cached_sound(&"unanchor", ProceduralAudio.create_unanchor_sound)
	_resist_sound = ProceduralAudio.get_cached_sound(&"resist", ProceduralAudio.create_resist_sound)
	_grip_sound = ProceduralAudio.get_cached_sound(&"anchor_grip", ProceduralAudio.create_anchor_grip_sound)
	_release_sound = ProceduralAudio.get_cached_sound(&"anchor_release", ProceduralAudio.create_anchor_release_sound)
	_yield_sound = ProceduralAudio.get_cached_sound(&"yield_collapse", ProceduralAudio.create_yield_collapse_sound)
	_sustain_sound = ProceduralAudio.get_cached_sound(&"anchor_sustain", ProceduralAudio.create_anchor_sustain_tone_sound)



func _setup_particles() -> void:
	# 1. Ambient anchor containment particles
	_anchor_particles = get_node_or_null("AnchorParticles") as CPUParticles2D
	if _anchor_particles == null:
		_anchor_particles = CPUParticles2D.new()
		_anchor_particles.name = "AnchorParticles"
		_anchor_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		_anchor_particles.emission_rect_extents = _current_size * 0.5
		_anchor_particles.amount = 8
		_anchor_particles.lifetime = 1.0
		_anchor_particles.direction = Vector2(0.0, -1.0)
		_anchor_particles.spread = 15.0
		_anchor_particles.gravity = Vector2(0.0, -8.0)
		_anchor_particles.initial_velocity_min = 2.0
		_anchor_particles.initial_velocity_max = 6.0
		_anchor_particles.color = Color(COLOR_ANCHOR_CYAN, 0.55)
		_anchor_particles.emitting = is_anchored
		ParticleBudget.apply_frame_budget(_anchor_particles)
		add_child(_anchor_particles)

	# 2. Burst resistance particles when wave strikes anchored object
	_resist_particles = get_node_or_null("ResistParticles") as CPUParticles2D
	if _resist_particles == null:
		_resist_particles = CPUParticles2D.new()
		_resist_particles.name = "ResistParticles"
		_resist_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
		_resist_particles.emission_rect_extents = _current_size * 0.5
		_resist_particles.amount = 14
		_resist_particles.lifetime = 0.35
		_resist_particles.one_shot = true
		_resist_particles.explosiveness = 0.85
		_resist_particles.direction = Vector2(-1.0, -0.3)
		_resist_particles.spread = 45.0
		_resist_particles.gravity = Vector2(0.0, 20.0)
		_resist_particles.initial_velocity_min = 25.0
		_resist_particles.initial_velocity_max = 55.0
		_resist_particles.color = Color(COLOR_ANCHOR_CYAN, 0.9)
		_resist_particles.emitting = false
		ParticleBudget.apply_frame_budget(_resist_particles)
		add_child(_resist_particles)


func _play_sfx(stream: AudioStreamWAV) -> void:
	if _audio_player and stream:
		_audio_player.stream = stream
		_audio_player.play()


func _play_haptic(stream: AudioStreamWAV) -> void:
	StationAudioVoices.play_at(
		self,
		StationAudioVoices.HAPTIC,
		stream,
		320.0,
		-9.0,
		randf_range(0.97, 1.03)
	)


## Wspoldzielony ton kotwicy stacji, przejmowany na czas trzymania.
func _sustain_voice() -> AudioStreamPlayer2D:
	return StationAudioVoices.acquire(self, StationAudioVoices.ANCHOR_SUSTAIN, 420.0, -80.0)


func _start_sustain() -> void:
	var voice := _sustain_voice()
	if voice == null or _sustain_sound == null:
		return
	StationAudioVoices.claim(voice, self)
	voice.global_position = global_position
	voice.stream = _sustain_sound
	if not voice.playing:
		voice.play()


## Miks tonu podtrzymanego sledzi obwiednie chwytu, wiec zwolniona kotwica
## wycisza sie plynnie zamiast urywac w polowie okresu. Rekwizyt dotyka glosu
## tylko wtedy, gdy realnie go trzyma — inaczej dwie kotwice na jednej stacji
## wycinalyby sobie nawzajem wybrzmienie.
func _update_sustain_mix() -> void:
	var voice := _existing_sustain_voice()
	if _resonance.grip <= 0.001 and not _resonance.is_held():
		if voice != null and StationAudioVoices.owns(voice, self):
			voice.volume_db = -80.0
			if voice.playing:
				voice.stop()
			StationAudioVoices.release(voice, self)
		return
	if voice == null or not StationAudioVoices.owns(voice, self):
		return
	voice.global_position = global_position
	voice.volume_db = _resonance.sustain_volume_db()
	voice.pitch_scale = _resonance.sustain_pitch()


## Istniejacy glos stacji albo `null`. Miks nigdy nie tworzy glosu — powstaje on
## wylacznie przy pierwszym realnym chwycie, wiec stacja bez zakotwiczen nie
## placi za niego ani jednego wezla.
func _existing_sustain_voice() -> AudioStreamPlayer2D:
	if not is_inside_tree():
		return null
	var host := StationAudioVoices.station_root(self)
	if host == null:
		return null
	return host.get_node_or_null(NodePath(String(StationAudioVoices.ANCHOR_SUSTAIN))) as AudioStreamPlayer2D


func _process(delta: float) -> void:
	_resonance.advance(delta)
	_update_sustain_mix()
	if _resonance.is_active() or is_player_in_range or _flash_intensity > 0.0:
		_pulse_phase += delta * 4.0
		if _flash_intensity > 0.0:
			_flash_intensity = maxf(0.0, _flash_intensity - delta * 3.0)
		queue_redraw()


## Obwiednia kotwiczenia, wystawiona dla bramki PKG-0140.
func get_resonance() -> AnchorResonance:
	return _resonance


func toggle_anchor() -> bool:
	set_anchored(!is_anchored)
	return is_anchored


func set_anchored(anchored: bool) -> void:
	is_anchored = anchored
	if is_anchored:
		_flash_color = COLOR_ANCHOR_CYAN
		_flash_intensity = 1.0


func apply_reality_shift(target_state: RealityState, animate: bool = true) -> void:
	if is_anchored:
		# The anchored object resists the institutional shift!
		_flash_color = COLOR_ANCHOR_CYAN
		_flash_intensity = 1.0
		_resonance.strike_resist()
		_play_sfx(_resist_sound)
		if _resist_particles:
			_resist_particles.restart()
			_resist_particles.emitting = true
		reality_shift_processed.emit(target_state, true)
		queue_redraw()
		return

	# Yielding to the institutional correction.
	# PKG-0140 (D-146): uleglosc jest **zmiana**. Stacje wolaja
	# `apply_reality_shift(current_state, false)` przy inicjalizacji, zeby
	# ustawic rekwizyt; ozwuczenie takiego wywolania bylo falszem i zjadalo
	# glos w budzecie 4 grajacych kanalow (D-120).
	var is_real_shift := current_reality != target_state
	current_reality = target_state
	_flash_color = COLOR_CORRECTION_CINNABAR
	if is_real_shift:
		_flash_intensity = 1.0
		_resonance.strike_yield()
		_play_sfx(_yield_sound)
	reality_shift_processed.emit(target_state, false)
	_update_to_reality(target_state, animate)


func _update_to_reality(state: RealityState, animate: bool) -> void:
	var target_pos := state_a_position if state == RealityState.STATE_A else state_b_position
	var target_size := state_a_size if state == RealityState.STATE_A else state_b_size
	var target_solid := state_a_solid if state == RealityState.STATE_A else state_b_solid

	if _tween and _tween.is_valid():
		_tween.kill()

	if animate:
		_tween = create_tween().set_parallel(true)
		_tween.tween_property(self, "position", target_pos, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		_tween.tween_method(_set_size, _current_size, target_size, 0.25)
	else:
		position = target_pos
		_set_size(target_size)

	if _collision_shape:
		_collision_shape.set_deferred("disabled", not target_solid)
	queue_redraw()


func _set_size(new_size: Vector2) -> void:
	_current_size = new_size
	if _rect_shape:
		_rect_shape.size = _current_size
	if _anchor_particles:
		_anchor_particles.emission_rect_extents = _current_size * 0.5
	if _resist_particles:
		_resist_particles.emission_rect_extents = _current_size * 0.5
	queue_redraw()


func get_distance_to_point(point: Vector2) -> float:
	var half := _current_size * 0.5
	var dx := maxf(0.0, absf(point.x - global_position.x) - half.x)
	var dy := maxf(0.0, absf(point.y - global_position.y) - half.y)
	return sqrt(dx * dx + dy * dy)


func update_player_distance(player_global_position: Vector2) -> void:
	var dist := get_distance_to_point(player_global_position)
	is_player_in_range = (dist <= interaction_radius)


func get_ghost_rect() -> Rect2:
	var other_pos := state_b_position if current_reality == RealityState.STATE_A else state_a_position
	var other_size := state_b_size if current_reality == RealityState.STATE_A else state_a_size
	var relative_offset := other_pos - position
	return Rect2(relative_offset - other_size * 0.5, other_size)


func _draw() -> void:
	var half := _current_size * 0.5
	var body_rect := Rect2(-half, _current_size)
	var is_solid := state_a_solid if current_reality == RealityState.STATE_A else state_b_solid
	var body_color := VectorStageStyle.MID_PLANE if is_solid else Color(VectorStageStyle.MID_PLANE, 0.28)
	# PKG-0140 (D-146). Akcent nie przeskakuje miedzy dwoma kolorami — jest
	# ciagla mieszanka prowadzona sila chwytu i blyskiem zdarzenia, wiec chwyt,
	# przesuniecie i zwolnienie czyta sie jako jeden gest, nie jako trzy stany.
	var rest_color: Color = VectorStageStyle.HUMAN_AMBER
	if current_reality == RealityState.STATE_B:
		rest_color = VectorStageStyle.CORRECTION_OXIDE
	var accent_color := _resonance.accent_color(
		rest_color,
		VectorStageStyle.ANCHOR_CYAN,
		VectorStageStyle.CORRECTION_OXIDE
	)

	# Plane 1: the unheld version leaves one quiet, translucent trace behind.
	if not is_anchored:
		var ghost_rect := get_ghost_rect()
		var ghost_color := VectorStageStyle.ANCHOR_CYAN if current_reality == RealityState.STATE_A else VectorStageStyle.CORRECTION_OXIDE
		draw_rect(ghost_rect, Color(ghost_color, 0.12), true)
		draw_rect(ghost_rect, Color(ghost_color, 0.48), false, 1.0)

	# Plane 2: one faceted body keeps the physical state legible at a glance.
	var body_points := PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x - 2.0, -half.y),
		Vector2(half.x, half.y - 2.0),
		Vector2(-half.x + 2.0, half.y),
	])
	VectorStageStyle.draw_facet_polygon(self, body_points, body_color, 1.0)

	# Plane 3: a single state strip is the deliberate anchor/correction signal.
	# Jego wysokosc oddycha razem z tonem harmonicznym, wiec dzwiek i obraz
	# opisuja to samo zdarzenie.
	var strip_height := minf(4.0 + 2.0 * _resonance.sustain_envelope(), _current_size.y)
	draw_rect(Rect2(-half.x, -half.y, _current_size.x, strip_height), accent_color)
	draw_line(Vector2(-half.x, half.y), Vector2(half.x, half.y), VectorStageStyle.LIGHT_PLANE, 1.0)

	# Plane 3b: pole kotwiczenia. Ramka rozszerza sie z obwiednia, wiec uderzenie
	# fali korekty w utrzymana kotwice jest widoczne bez zadnego HUD-u.
	var field_alpha := _resonance.field_alpha()
	if field_alpha > 0.01:
		draw_rect(
			body_rect.grow(2.0 + _resonance.field_expansion()),
			Color(accent_color, field_alpha),
			false,
			1.0
		)

	# Plane 4: the interaction bracket appears only when the object can be held.
	if is_player_in_range and not is_anchored:
		var bracket_alpha := 0.55 + 0.35 * sin(_pulse_phase)
		var bracket_color := Color(VectorStageStyle.ANCHOR_CYAN, bracket_alpha)
		draw_rect(body_rect.grow(4.0), bracket_color, false, 1.0)
