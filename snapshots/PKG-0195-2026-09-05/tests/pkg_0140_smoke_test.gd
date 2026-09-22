extends SceneTree

## PKG-0140 Smoke Test — sprzezenie audiowizualne Anchor / Yield, haptyka
## interakcji i wygladzenie kadru kamery kinowej.
##
## Czego pilnuje ta bramka:
##
## 1. Sprzezenie Anchor / Yield (D-146). Chwyt, przesuniecie i zwolnienie
##    kotwicy to trzy rozne gesty; obwiednia `AnchorResonance` prowadzi je
##    ciagle, a `AnchorableObject` i `MovableAnchorableProp` uzywaja dokladnie
##    tej samej obwiedni, wiec platforma i skrzynia nie rozjezdzaja sie
##    wizualnie ani dzwiekowo.
## 2. Ton harmoniczny kotwicy jest zapetlony i miksowany sila chwytu, nie
##    wlaczany i wylaczany skokiem.
## 3. Haptyka interakcji (D-147). Punkt pamieci ma warstwe dotyku: mikro-stuk
##    przy wejsciu w zasieg, badanie przy interakcji, zapadka na przelacznikach,
##    plus ciagly kontaktowy odczyt wizualny bez zadnego HUD-u.
## 4. Wygladzenie kadru (D-148). Snap 2 px kompozytora zachowany, tlumienie
##    przy transporcie pionowym oraz natychmiastowe centrowanie po przejsciu
##    progu (`ReturnZone` / `AirlockZone`).
## 5. Kampania: stacje z rekwizytami zakotwiczalnymi realnie dostaja pelny
##    tor audiowizualny, a nie tylko klasy w izolacji.

const ProceduralAudio := preload("res://scripts/audio/procedural_audio.gd")
const AnchorResonance := preload("res://scripts/visual/anchor_resonance.gd")
const AnchorableObject := preload("res://scripts/interactables/anchorable_object.gd")
const MovableAnchorableProp := preload("res://scripts/interactables/movable_anchorable_prop.gd")
const MemoryResonancePoint := preload("res://scripts/interactables/memory_resonance_point.gd")
const CinematicCamera := preload("res://scripts/camera/cinematic_camera.gd")
const ReturnZone := preload("res://scripts/environment/return_zone.gd")
const PrototypePlayer := preload("res://scripts/player/prototype_player.gd")
const StationAudioVoices := preload("res://scripts/audio/station_audio_voices.gd")

## Budzet klatki PKG-0130 (D-120), powtorzony tutaj celowo: warstwa dotyku i ton
## kotwicy musialy zmiescic sie w tym samym kontrakcie, co reszta dzwieku.
const MAX_POOLED_AUDIO_PLAYERS := 20
const MAX_PLAYING_AUDIO_VOICES := 4

## Stacje kampanii, ktore realnie uzywaja rekwizytow zakotwiczalnych.
const ANCHOR_STATIONS := [
	"station_09", "station_11", "station_28", "station_32", "station_33", "station_38",
]

const STEP := 1.0 / 60.0

var _failures: Array[String] = []


func _initialize() -> void:
	call_deferred(&"_run")


func _expect(cond: bool, msg: String) -> void:
	if not cond:
		_failures.append(msg)
		printerr("FAIL: " + msg)


func _run() -> void:
	print("================================================================================")
	print("  PKG-0140 SMOKE TEST: Anchor/Yield coupling, interaction haptics, camera easing")
	print("================================================================================")

	print("1. Syntezatory sprzezenia Anchor/Yield i haptyki...")
	_test_synthesizers()

	print("2. Obwiednia AnchorResonance...")
	_test_resonance_envelope()

	print("3. AnchorableObject — tor audiowizualny...")
	await _test_anchorable_object()

	print("4. MovableAnchorableProp — chwyt, przesuwanie, uleglosc...")
	await _test_movable_prop()

	print("5. MemoryResonancePoint — haptyka i kontaktowy odczyt...")
	await _test_memory_point_haptics()

	print("6. CinematicCamera — tlumienie transportu pionowego i centrowanie...")
	await _test_camera_easing()

	print("7. ReturnZone — zadanie centrowania kadru...")
	await _test_return_zone_recenter()

	print("8. Kampania — stacje z rekwizytami zakotwiczalnymi...")
	await _test_campaign_stations()

	# Kolejka `queue_free()` musi zdazyc sie opróznic przed `quit()`, inaczej
	# silnik raportuje wycieki ObjectDB na wyjsciu.
	for i in range(6):
		await process_frame

	_finish()


# ─── 1. Syntezatory ───────────────────────────────────────────────────────────

func _test_synthesizers() -> void:
	var one_shots := {
		"create_anchor_grip_sound": ProceduralAudio.create_anchor_grip_sound(),
		"create_anchor_release_sound": ProceduralAudio.create_anchor_release_sound(),
		"create_yield_collapse_sound": ProceduralAudio.create_yield_collapse_sound(),
		"create_contact_tap_sound": ProceduralAudio.create_contact_tap_sound(),
		"create_switch_detent_sound": ProceduralAudio.create_switch_detent_sound(),
		"create_probe_brush_sound": ProceduralAudio.create_probe_brush_sound(),
	}
	for key in one_shots:
		var wav: AudioStreamWAV = one_shots[key]
		_expect(wav != null and wav.data.size() > 0, "%s musi dac poprawny WAV" % key)
		_expect(wav.format == AudioStreamWAV.FORMAT_16_BITS, "%s musi byc 16-bit PCM" % key)
		_expect(wav.mix_rate == ProceduralAudio.SAMPLE_RATE, "%s musi trzymac 44100 Hz" % key)
		_expect(
			wav.loop_mode == AudioStreamWAV.LOOP_DISABLED,
			"%s to zdarzenie jednorazowe, nie moze byc zapetlone" % key
		)

	var loops := {
		"create_anchor_sustain_tone_sound": ProceduralAudio.create_anchor_sustain_tone_sound(),
		"create_prop_drag_scrape_sound": ProceduralAudio.create_prop_drag_scrape_sound(),
	}
	for key in loops:
		var wav: AudioStreamWAV = loops[key]
		_expect(wav != null and wav.data.size() > 0, "%s musi dac poprawny WAV" % key)
		_expect(
			wav.loop_mode == AudioStreamWAV.LOOP_FORWARD,
			"%s musi byc zapetlony do przodu — ton trwa tak dlugo jak chwyt" % key
		)
		_expect(wav.loop_begin == 0, "%s: petla musi zaczynac sie od zera" % key)
		_expect(
			wav.loop_end > wav.loop_begin and wav.loop_end < wav.data.size() / 2,
			"%s: koniec petli musi lezec w buforze" % key
		)

	# Mikro-dzwieki haptyki musza byc krotkie: to odczyt palca, nie powiadomienie.
	var tap := ProceduralAudio.create_contact_tap_sound()
	var tap_seconds := float(tap.data.size() / 2) / float(ProceduralAudio.SAMPLE_RATE)
	_expect(tap_seconds <= 0.08, "Mikro-stuk kontaktu musi byc <= 80 ms (jest %.3f s)" % tap_seconds)

	var detent := ProceduralAudio.create_switch_detent_sound()
	var detent_seconds := float(detent.data.size() / 2) / float(ProceduralAudio.SAMPLE_RATE)
	_expect(detent_seconds <= 0.14, "Zapadka przelacznika musi byc <= 140 ms (jest %.3f s)" % detent_seconds)

	# Cache PCM: warstwa haptyczna jest wspolna dla 45 stacji i nie moze
	# syntezowac sie od nowa przy kazdej zmianie sceny.
	var before := ProceduralAudio.get_sound_cache_size()
	var first := ProceduralAudio.get_cached_sound(&"contact_tap", ProceduralAudio.create_contact_tap_sound)
	var second := ProceduralAudio.get_cached_sound(&"contact_tap", ProceduralAudio.create_contact_tap_sound)
	_expect(first == second, "Cache PCM musi oddawac ten sam bufor mikro-stuku")
	_expect(
		ProceduralAudio.get_sound_cache_size() >= before,
		"Cache PCM nie moze kurczyc sie przy odczycie"
	)


# ─── 2. Obwiednia ─────────────────────────────────────────────────────────────

func _test_resonance_envelope() -> void:
	var r := AnchorResonance.new()
	_expect(is_zero_approx(r.grip), "Obwiednia startuje bez chwytu")
	_expect(not r.is_active(), "Obwiednia w spoczynku nie zajmuje klatek")
	_expect(is_equal_approx(r.sustain_volume_db(), -80.0), "Bez chwytu ton harmoniczny musi milczec")

	# Chwyt narasta szybko, ale nie w jednej klatce — to reka, nie klawisz.
	r.hold()
	r.advance(STEP)
	_expect(r.grip > 0.0 and r.grip < 1.0, "Chwyt nie moze skoczyc do pelna w jednej klatce (%.3f)" % r.grip)
	for i in range(30):
		r.advance(STEP)
	_expect(is_equal_approx(r.grip, 1.0), "Chwyt musi dojsc do pelna (%.3f)" % r.grip)
	_expect(r.sustain_volume_db() > -80.0, "Trzymana kotwica musi brzmiec")
	_expect(r.is_active(), "Trzymana kotwica jest aktywna")

	# Ton oddycha, ale nigdy nie gasnie przy pelnym chwycie.
	var min_env := 2.0
	var max_env := -2.0
	for i in range(180):
		r.advance(STEP)
		min_env = minf(min_env, r.sustain_envelope())
		max_env = maxf(max_env, r.sustain_envelope())
	_expect(min_env > 0.35, "Oddech tonu nie moze schodzic do zera przy chwycie (min %.3f)" % min_env)
	_expect(max_env > min_env + 0.05, "Ton musi realnie oddychac (min %.3f, max %.3f)" % [min_env, max_env])

	# Zwolnienie opada wolniej niz narastal chwyt.
	r.release()
	var release_frames := 0
	while r.grip > 0.0 and release_frames < 600:
		r.advance(STEP)
		release_frames += 1
	_expect(is_zero_approx(r.grip), "Zwolniona kotwica musi wygasnac do zera")
	_expect(
		release_frames > int(AnchorResonance.GRIP_ATTACK / STEP),
		"Zwalnianie musi trwac dluzej niz chwytanie (%d klatek)" % release_frames
	)
	_expect(is_equal_approx(r.sustain_volume_db(), -80.0), "Po zwolnieniu ton musi zamilknac")

	# Blyski oporu i uleglosci wygasaja same.
	r.strike_resist()
	_expect(is_equal_approx(r.flash_envelope(), 1.0), "Opor musi zapalic pelny blysk")
	for i in range(120):
		r.advance(STEP)
	_expect(is_zero_approx(r.resist_flash), "Blysk oporu musi wygasnac")

	r.strike_yield()
	_expect(is_equal_approx(r.yield_flash, 1.0), "Uleglosc musi zapalic pelny blysk")
	for i in range(120):
		r.advance(STEP)
	_expect(is_zero_approx(r.yield_flash), "Blysk uleglosci musi wygasnac")

	# Energia przesuwania cichnie sama, gdy gracz przestaje pchac.
	r.feed_drag(1.0)
	_expect(is_equal_approx(r.drag, 1.0), "Pchanie musi zasilic energie przesuwania")
	for i in range(60):
		r.advance(STEP)
	_expect(is_zero_approx(r.drag), "Energia przesuwania musi wygasnac bez pchania")

	# Kolor akcentu jest ciagly: przy zerowym chwycie to kolor spoczynkowy,
	# przy pelnym — kolor trzymania, a w polowie lezy miedzy nimi.
	var rest := Color(1.0, 0.0, 0.0)
	var held := Color(0.0, 0.0, 1.0)
	var yielded := Color(0.0, 1.0, 0.0)
	var fresh := AnchorResonance.new()
	_expect(fresh.accent_color(rest, held, yielded).is_equal_approx(rest), "Bez chwytu akcent = kolor spoczynkowy")
	fresh.hold()
	for i in range(60):
		fresh.advance(STEP)
	_expect(fresh.accent_color(rest, held, yielded).is_equal_approx(held), "Pelny chwyt = kolor trzymania")

	var mid := AnchorResonance.new()
	mid.hold()
	mid.advance(AnchorResonance.GRIP_ATTACK * 0.5)
	var mid_color := mid.accent_color(rest, held, yielded)
	_expect(
		mid_color.b > 0.05 and mid_color.r > 0.05,
		"Polowa chwytu musi lezec miedzy kolorami, nie na ktoryms z nich"
	)

	# Ramka pola rosnie razem z chwytem.
	var weak := AnchorResonance.new()
	weak.hold()
	weak.advance(AnchorResonance.GRIP_ATTACK * 0.25)
	var strong := AnchorResonance.new()
	strong.hold()
	for i in range(60):
		strong.advance(STEP)
	_expect(
		strong.field_alpha() > weak.field_alpha(),
		"Silniejszy chwyt musi dawac mocniejsza ramke pola"
	)
	_expect(
		strong.field_expansion() > weak.field_expansion(),
		"Silniejszy chwyt musi rozszerzac ramke pola"
	)


# ─── 3. AnchorableObject ──────────────────────────────────────────────────────

func _test_anchorable_object() -> void:
	var obj := AnchorableObject.new()
	obj.name = "TestAnchorable"
	obj.state_a_position = Vector2(100.0, 100.0)
	obj.state_b_position = Vector2(160.0, 100.0)
	obj.position = Vector2(100.0, 100.0)
	root.add_child(obj)
	await process_frame

	# Glosy stacji sa leniwe: rekwizyt, ktorego nikt nie chwycil, nie kosztuje
	# ani jednego dodatkowego wezla audio (D-149).
	_expect(
		obj.get_node_or_null(String(StationAudioVoices.ANCHOR_SUSTAIN)) == null,
		"Ton kotwicy nie moze istniec, zanim ktos chwyci rekwizyt"
	)

	var res: AnchorResonance = obj.get_resonance()
	_expect(res != null, "AnchorableObject musi wystawiac obwiednie")

	# Chwyt: obwiednia rusza, ton narasta.
	obj.set_anchored(true)
	_expect(res.is_held(), "Zakotwiczenie musi wlaczyc chwyt w obwiedni")
	var sustain: AudioStreamPlayer2D = obj.get_node_or_null(
		String(StationAudioVoices.ANCHOR_SUSTAIN)
	) as AudioStreamPlayer2D
	_expect(sustain != null, "Chwyt musi powolac wspoldzielony ton kotwicy stacji")
	if sustain != null:
		_expect(sustain.stream != null, "Ton podtrzymany musi miec strumien")
		_expect(
			(sustain.stream as AudioStreamWAV).loop_mode == AudioStreamWAV.LOOP_FORWARD,
			"Ton podtrzymany musi byc zapetlony"
		)
		_expect(
			StationAudioVoices.owns(sustain, obj),
			"Trzymajacy rekwizyt musi byc wlascicielem tonu stacji"
		)
	for i in range(40):
		obj._process(STEP)
	_expect(res.grip > 0.9, "Chwyt musi dojsc do pelna po zakotwiczeniu (%.3f)" % res.grip)
	_expect(sustain != null and sustain.volume_db > -80.0, "Trzymana kotwica musi podnosic ton podtrzymany")

	# Opor: fala korekty uderza w kotwice.
	var shift_log := {"resisted": false, "seen": false}
	obj.reality_shift_processed.connect(
		func(_t, r: bool) -> void:
			shift_log["resisted"] = r
			shift_log["seen"] = true
	)
	obj.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	_expect(shift_log["seen"], "Zmiana rzeczywistosci musi zglosic sie sygnalem")
	_expect(shift_log["resisted"], "Zakotwiczony obiekt musi stawiac opor")
	_expect(res.resist_flash > 0.5, "Opor musi zapalic blysk w obwiedni")
	_expect(
		obj.current_reality == AnchorableObject.RealityState.STATE_A,
		"Opor nie moze przepuscic zmiany rzeczywistosci"
	)

	# Zwolnienie: ton wygasa plynnie i sam sie zatrzymuje.
	obj.set_anchored(false)
	_expect(not res.is_held(), "Zwolnienie musi zdjac chwyt")
	for i in range(120):
		obj._process(STEP)
	_expect(is_zero_approx(res.grip), "Chwyt musi wygasnac po zwolnieniu")
	_expect(sustain != null and not sustain.playing, "Ton podtrzymany musi sam sie zatrzymac po wygasnieciu")
	_expect(
		sustain != null and not StationAudioVoices.owns(sustain, obj),
		"Zwolniony rekwizyt musi oddac ton stacji"
	)

	# Uleglosc: niezakotwiczony obiekt przyjmuje korekte i zapala blysk.
	obj.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	_expect(
		obj.current_reality == AnchorableObject.RealityState.STATE_B,
		"Niezakotwiczony obiekt musi przyjac korekte"
	)
	_expect(res.yield_flash > 0.5, "Uleglosc musi zapalic blysk uleglosci")

	# Rysunek prowadzi silnik; bramka pilnuje, ze kazdy z tych stanow zada
	# odrysowania, zamiast wolac `_draw()` poza kontekstem rysowania.
	obj.is_player_in_range = true
	obj.set_anchored(true)
	obj._process(STEP)
	obj.queue_redraw()

	obj.queue_free()
	await process_frame


# ─── 4. MovableAnchorableProp ─────────────────────────────────────────────────

func _test_movable_prop() -> void:
	var prop := MovableAnchorableProp.new()
	prop.name = "TestCrate"
	prop.position = Vector2(200.0, 120.0)
	root.add_child(prop)
	await process_frame

	_expect(
		prop.get_node_or_null(String(StationAudioVoices.ANCHOR_DRAG)) == null,
		"Nieruchoma skrzynia nie moze powolywac kanalu tarcia"
	)
	_expect(
		prop.get_node_or_null(String(StationAudioVoices.ANCHOR_SUSTAIN)) == null,
		"Nietrzymana skrzynia nie moze powolywac tonu kotwicy"
	)

	var res: AnchorResonance = prop.get_resonance()
	_expect(res != null, "Skrzynia musi wystawiac obwiednie")

	# Ta sama obwiednia co w AnchorableObject — jeden kontrakt na oba rekwizyty.
	_expect(
		res.get_script() == AnchorResonance,
		"Skrzynia i platforma musza dzielic dokladnie ten sam model obwiedni"
	)

	# Przesuwanie: energia tarcia rosnie razem z realna predkoscia.
	prop.velocity.x = prop.push_speed_max
	res.feed_drag(absf(prop.velocity.x) / prop.push_speed_max)
	prop._update_resonance_mix()
	_expect(res.drag > 0.9, "Pelna predkosc musi dac pelna energie tarcia")
	var drag_player: AudioStreamPlayer2D = prop.get_node_or_null(
		String(StationAudioVoices.ANCHOR_DRAG)
	) as AudioStreamPlayer2D
	_expect(drag_player != null, "Przesuwanie musi powolac wspoldzielony kanal tarcia stacji")
	if drag_player != null:
		_expect(drag_player.stream != null, "Kanal tarcia musi miec strumien")
		_expect(
			(drag_player.stream as AudioStreamWAV).loop_mode == AudioStreamWAV.LOOP_FORWARD,
			"Tarcie musi byc zapetlone"
		)
		_expect(drag_player.playing, "Przesuwana skrzynia musi szurac")
		_expect(drag_player.volume_db > -40.0, "Tarcie musi byc slyszalne przy pelnej predkosci")

	# Zatrzymanie: tarcie cichnie samo.
	prop.velocity.x = 0.0
	for i in range(60):
		res.advance(STEP)
	prop._update_resonance_mix()
	_expect(is_zero_approx(res.drag), "Zatrzymana skrzynia musi zamilknac")
	_expect(drag_player != null and not drag_player.playing, "Zatrzymana skrzynia nie moze dalej szurac")

	# Chwyt zamraza skrzynie i podnosi ton.
	prop.set_anchored(true)
	_expect(res.is_held(), "Zakotwiczenie skrzyni musi wlaczyc chwyt")
	for i in range(40):
		res.advance(STEP)
	prop._update_resonance_mix()
	var sustain: AudioStreamPlayer2D = prop.get_node_or_null(
		String(StationAudioVoices.ANCHOR_SUSTAIN)
	) as AudioStreamPlayer2D
	_expect(sustain != null, "Chwyt skrzyni musi powolac ton kotwicy stacji")
	_expect(
		sustain != null and sustain.volume_db > -80.0,
		"Zakotwiczona skrzynia musi brzmiec tonem podtrzymanym"
	)

	var crate_log := {"resisted": false, "seen": false}
	prop.reality_shift_processed.connect(
		func(_t, r: bool) -> void:
			crate_log["resisted"] = r
			crate_log["seen"] = true
	)
	prop.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	_expect(crate_log["seen"], "Zmiana rzeczywistosci skrzyni musi zglosic sie sygnalem")
	_expect(crate_log["resisted"], "Zakotwiczona skrzynia musi stawiac opor")
	_expect(res.resist_flash > 0.5, "Opor skrzyni musi zapalic blysk")

	prop.set_anchored(false)
	prop.apply_reality_shift(AnchorableObject.RealityState.STATE_B, false)
	_expect(res.yield_flash > 0.5, "Uleglosc skrzyni musi zapalic blysk")

	# Powrot do punktu wyjscia zdejmuje chwyt (porazka nigdy nie zostawia
	# wiszacej kotwicy — D-146).
	prop.set_anchored(true)
	prop.reset_to_spawn()
	_expect(not res.is_held(), "Reset skrzyni musi zdjac chwyt")

	prop.is_player_in_range = true
	prop.queue_redraw()

	prop.queue_free()
	await process_frame


# ─── 5. Haptyka punktu pamieci ────────────────────────────────────────────────

func _test_memory_point_haptics() -> void:
	var point := MemoryResonancePoint.new()
	point.name = "TestMemoryPoint"
	point.resonance_id = "pkg_0140_probe"
	point.prop_type = MemoryResonancePoint.PropType.PHOTOGRAPH
	root.add_child(point)
	await process_frame

	_expect(
		point.get_node_or_null(String(StationAudioVoices.HAPTIC)) == null,
		"Nietkniety punkt pamieci nie moze powolywac glosu dotyku"
	)
	_expect(
		is_zero_approx(point.get_contact_progress()),
		"Bez Leny w zasiegu kontakt musi byc zerowy"
	)

	# Karencja po wejsciu w scene: Lena, ktora startuje przy rekwizycie, nie
	# dotknela go — stuk kontaktu w pierwszej klatce bylby falszem (D-149).
	_expect(point._spawn_grace > 0.0, "Punkt pamieci musi startowac z karencja dotyku")
	point._on_body_entered(point)
	point.is_player_in_range = false
	for i in range(60):
		point._process(STEP)
	_expect(is_zero_approx(point._spawn_grace), "Karencja dotyku musi wygasnac sama")

	# Wejscie w zasieg: mikro-stuk i narastajacy kontakt.
	point.is_player_in_range = true
	for i in range(30):
		point._process(STEP)
	_expect(
		point.get_contact_progress() > 0.5,
		"Kontakt musi narastac przy Lenie w zasiegu (%.3f)" % point.get_contact_progress()
	)
	var contact_at_hold := point.get_contact_progress()

	# Wyjscie: kontakt opada, nie znika skokiem.
	point.is_player_in_range = false
	point._process(STEP)
	var contact_after_one_frame := point.get_contact_progress()
	_expect(
		contact_after_one_frame < contact_at_hold and contact_after_one_frame > 0.0,
		"Kontakt musi opadac plynnie, nie gasnac w jednej klatce (%.3f)" % contact_after_one_frame
	)
	for i in range(60):
		point._process(STEP)
	_expect(is_zero_approx(point.get_contact_progress()), "Po odejsciu Leny kontakt musi wygasnac")

	# Badanie: blysk dotkniecia i haptyczny strumien badania.
	point.is_player_in_range = true
	point.trigger_interaction()
	_expect(is_equal_approx(point.get_touch_flash(), 1.0), "Badanie musi zapalic blysk dotkniecia")
	var haptic: AudioStreamPlayer2D = point.get_node_or_null(
		String(StationAudioVoices.HAPTIC)
	) as AudioStreamPlayer2D
	_expect(haptic != null, "Badanie musi powolac wspoldzielony glos dotyku stacji")
	_expect(
		haptic != null and haptic.volume_db < 0.0,
		"Warstwa haptyczna musi byc cichsza od dzwieku diegetycznego rekwizytu"
	)
	_expect(haptic != null and haptic.stream != null, "Badanie musi zaladowac strumien haptyczny")
	var probe_stream: AudioStream = haptic.stream if haptic != null else null
	for i in range(120):
		point._process(STEP)
	_expect(is_zero_approx(point.get_touch_flash()), "Blysk dotkniecia musi wygasnac")

	point.queue_free()
	await process_frame

	# Przelacznik dostaje zapadke, nie to samo badanie co fotografia.
	var switch_point := MemoryResonancePoint.new()
	switch_point.name = "TestSwitchPoint"
	switch_point.resonance_id = "pkg_0140_switch"
	switch_point.prop_type = MemoryResonancePoint.PropType.CIRCUIT_BREAKER
	root.add_child(switch_point)
	await process_frame

	_expect(
		MemoryResonancePoint.PropType.CIRCUIT_BREAKER in MemoryResonancePoint.SWITCH_LIKE_PROPS,
		"Rozdzielnica musi byc traktowana jak przelacznik"
	)
	_expect(
		not (MemoryResonancePoint.PropType.PHOTOGRAPH in MemoryResonancePoint.SWITCH_LIKE_PROPS),
		"Fotografia nie jest przelacznikiem i nie moze klikac zapadka"
	)

	switch_point.is_player_in_range = true
	switch_point.trigger_interaction()
	var switch_haptic: AudioStreamPlayer2D = switch_point.get_node_or_null(
		String(StationAudioVoices.HAPTIC)
	) as AudioStreamPlayer2D
	_expect(switch_haptic != null, "Zapadka musi powolac glos dotyku stacji")
	_expect(switch_haptic != null and switch_haptic.stream != null, "Zapadka musi zaladowac strumien haptyczny")
	_expect(
		switch_haptic != null and switch_haptic.stream != probe_stream,
		"Zapadka przelacznika musi brzmiec inaczej niz badanie fotografii"
	)
	_expect(switch_point.get_touch_flash() > 0.9, "Obsluga przelacznika musi zapalic blysk dotkniecia")

	# Kontaktowy odczyt wizualny musi domagac sie odrysowania po dotknieciu.
	switch_point._process(STEP)
	switch_point.queue_redraw()

	switch_point.queue_free()
	await process_frame


# ─── 6. Kamera ────────────────────────────────────────────────────────────────

func _test_camera_easing() -> void:
	var camera := CinematicCamera.new()
	camera.name = "PKG0140Camera"
	root.add_child(camera)
	camera.setup_chambers([Rect2(Vector2.ZERO, Vector2(640.0, 720.0))] as Array[Rect2])

	var climber := PrototypePlayer.new()
	climber.name = "Climber"
	climber.position = Vector2(320.0, 620.0)
	root.add_child(climber)
	climber.set_physics_process(false)
	climber.set_process(false)
	camera.target = climber
	await process_frame

	# Kontrakt PKG-0130 zostaje: kadr nigdy nie schodzi z siatki 2 px.
	_expect(CinematicCamera.PIXEL_GRID == 2.0, "Snap kompozytora musi zostac przy 2 px")
	_expect(camera.pixel_snap_enabled, "Snap 2 px musi byc wlaczony domyslnie")

	# Natychmiastowe centrowanie: pierwsza klatka fizyki zastaje Lene, nie
	# srodek komory.
	camera._physics_process(STEP)
	_expect(
		camera.get_vertical_focus() > 360.0,
		"Centrowanie musi zastac wspinacza na dole szybu (%.2f)" % camera.get_vertical_focus()
	)
	_expect(camera.is_on_pixel_grid(), "Centrowanie musi zostawic kadr na siatce 2 px")

	# Tryb naziemny: brak tlumienia transportowego.
	for i in range(30):
		camera._physics_process(STEP)
	_expect(
		is_zero_approx(camera.get_traversal_blend()),
		"Chodzaca Lena nie moze wlaczac tlumienia transportowego (%.3f)" % camera.get_traversal_blend()
	)

	# Wejscie na drabine: tlumienie narasta, ale nie skokiem.
	climber.is_climbing = true
	camera._physics_process(STEP)
	var blend_first := camera.get_traversal_blend()
	_expect(
		blend_first > 0.0 and blend_first < 1.0,
		"Wsiadanie na drabine nie moze przelaczac kadru skokiem (%.3f)" % blend_first
	)
	for i in range(180):
		camera._physics_process(STEP)
	_expect(
		camera.get_traversal_blend() > 0.95,
		"Wspinaczka musi domknac tryb transportowy (%.3f)" % camera.get_traversal_blend()
	)

	# Zejscie z drabiny: tlumienie opada rownie plynnie.
	climber.is_climbing = false
	camera._physics_process(STEP)
	_expect(
		camera.get_traversal_blend() < 1.0 and camera.get_traversal_blend() > 0.0,
		"Zejscie z drabiny nie moze zdejmowac tlumienia skokiem"
	)
	for i in range(180):
		camera._physics_process(STEP)
	_expect(is_zero_approx(camera.get_traversal_blend()), "Po zejsciu tlumienie musi wygasnac")

	# Snap trzyma sie przez caly przebieg z ulamkowym krokiem.
	var off_grid := 0
	climber.is_climbing = true
	for i in range(240):
		climber.position.y -= 0.37
		camera._physics_process(STEP)
		if not camera.is_on_pixel_grid():
			off_grid += 1
	_expect(off_grid == 0, "Kadr zszedl z siatki 2 px na %d klatkach" % off_grid)

	# Tlumienie ma realnie spowalniac dociaganie kadru w pionie.
	var damped := _measure_focus_travel(true)
	var plain := _measure_focus_travel(false)
	_expect(
		damped < plain,
		"Tryb transportowy musi tlumic kadr (transport %.2f px, chod %.2f px)" % [damped, plain]
	)

	climber.queue_free()
	camera.queue_free()
	await process_frame


## Ile pikselow przejedzie kadr w 30 klatkach po skoku celu o 200 px w gore.
func _measure_focus_travel(climbing: bool) -> float:
	var camera := CinematicCamera.new()
	camera.name = "TravelProbe"
	root.add_child(camera)
	camera.setup_chambers([Rect2(Vector2.ZERO, Vector2(640.0, 720.0))] as Array[Rect2])

	var body := PrototypePlayer.new()
	body.position = Vector2(320.0, 540.0)
	root.add_child(body)
	body.set_physics_process(false)
	body.set_process(false)
	camera.target = body
	camera._physics_process(STEP)

	# Tryb ustalony przed pomiarem, zeby mierzyc tlumienie, nie przejscie.
	body.is_climbing = climbing
	for i in range(240):
		camera._physics_process(STEP)

	var start_focus := camera.get_vertical_focus()
	body.position.y -= 200.0
	for i in range(30):
		camera._physics_process(STEP)
	var travel := absf(camera.get_vertical_focus() - start_focus)

	body.queue_free()
	camera.queue_free()
	return travel


# ─── 7. ReturnZone ────────────────────────────────────────────────────────────

func _test_return_zone_recenter() -> void:
	var station := Node2D.new()
	station.name = "FakeStation"
	station.add_user_signal("previous_level_requested")
	root.add_child(station)

	var camera := CinematicCamera.new()
	camera.name = "Camera"
	station.add_child(camera)
	camera.setup_chambers([Rect2(Vector2.ZERO, Vector2(640.0, 720.0))] as Array[Rect2])

	var player := PrototypePlayer.new()
	player.name = "Player"
	player.position = Vector2(60.0, 600.0)
	station.add_child(player)
	player.set_physics_process(false)
	player.set_process(false)
	camera.target = player
	await process_frame

	# Kadr ustabilizowany przed przejsciem progu.
	for i in range(120):
		camera._physics_process(STEP)
	_expect(not camera._needs_recenter, "Ustabilizowany kadr nie czeka na centrowanie")

	var zone := ReturnZone.new()
	station.add_child(zone)
	await process_frame

	var return_log := {"returned": false}
	station.connect(&"previous_level_requested", func() -> void: return_log["returned"] = true)
	zone._on_body_entered(player)
	_expect(return_log["returned"], "Prog powrotu musi zglosic powrot do poprzedniej stacji")
	_expect(
		camera._needs_recenter,
		"Przejscie przez ReturnZone musi zazadac natychmiastowego centrowania kadru"
	)

	# Centrowanie realnie ustawia kadr na graczu i zostaje na siatce 2 px.
	player.position = Vector2(60.0, 200.0)
	camera._physics_process(STEP)
	_expect(not camera._needs_recenter, "Centrowanie musi zdjac zadanie po wykonaniu")
	_expect(camera.is_on_pixel_grid(), "Centrowanie po progu musi trzymac siatke 2 px")
	_expect(
		absf(camera.get_vertical_focus() - 200.0) <= camera.view_size.y * 0.5,
		"Kadr po progu musi zastac gracza, nie dojezdzac do niego"
	)

	station.queue_free()
	await process_frame


# ─── 8. Kampania ──────────────────────────────────────────────────────────────

func _test_campaign_stations() -> void:
	for station_id in ANCHOR_STATIONS:
		var packed := load("res://scenes/levels/%s.tscn" % station_id) as PackedScene
		_expect(packed != null, "%s musi dac sie zaladowac" % station_id)
		if packed == null:
			continue

		var scene := packed.instantiate()
		root.add_child(scene)
		await process_frame
		await process_frame

		var anchorables := _collect_anchorables(scene)
		_expect(
			not anchorables.is_empty(),
			"%s deklaruje rekwizyt zakotwiczalny, ale zaden nie zyje w scenie" % station_id
		)

		for node in anchorables:
			var label := "%s/%s" % [station_id, node.name]
			var res: AnchorResonance = node.call(&"get_resonance")
			_expect(res != null, "%s musi wystawiac obwiednie kotwiczenia" % label)
			_expect(
				res != null and is_zero_approx(res.grip),
				"%s musi startowac bez wiszacego chwytu" % label
			)

		# Punkty pamieci stacji maja warstwe dotyku i karencje startowa.
		var points := _collect_memory_points(scene)
		_expect(not points.is_empty(), "%s musi miec punkty pamieci" % station_id)

		# Budzet klatki (D-120) nie moze ucierpiec przez warstwe dotyku i ton
		# kotwicy: glosy sa wspoldzielone przez stacje i powstaja leniwie.
		var audio := _count_audio(scene)
		_expect(
			audio["pooled"] <= MAX_POOLED_AUDIO_PLAYERS,
			"%s: %d odtwarzaczy audio przekracza budzet %d" % [
				station_id, audio["pooled"], MAX_POOLED_AUDIO_PLAYERS
			]
		)
		_expect(
			audio["playing"] <= MAX_PLAYING_AUDIO_VOICES,
			"%s: %d grajacych glosow przekracza budzet %d" % [
				station_id, audio["playing"], MAX_PLAYING_AUDIO_VOICES
			]
		)
		_expect(
			audio["shared_voices"] <= 3,
			"%s: stacja moze miec najwyzej 3 wspoldzielone glosy PKG-0140 (ma %d)" % [
				station_id, audio["shared_voices"]
			]
		)

		# Kamera stacji trzyma kontrakt PKG-0140.
		var camera := _find_camera(scene)
		_expect(camera != null, "%s musi miec CinematicCamera" % station_id)
		if camera != null:
			_expect(camera.pixel_snap_enabled, "%s: snap 2 px musi zostac wlaczony" % station_id)
			_expect(
				camera.traversal_damping_enabled,
				"%s: tlumienie transportu pionowego musi byc wlaczone" % station_id
			)
			_expect(camera.is_on_pixel_grid(), "%s: kadr musi lezec na siatce 2 px" % station_id)

		scene.queue_free()
		await process_frame


## Liczy odtwarzacze audio sceny w tym samym ujeciu, co bramka PKG-0130.
func _count_audio(node: Node) -> Dictionary:
	var pooled := 0
	var playing := 0
	var shared_voices := 0
	var pending: Array[Node] = [node]
	while not pending.is_empty():
		var current: Node = pending.pop_back()
		if current is AudioStreamPlayer or current is AudioStreamPlayer2D:
			pooled += 1
			if bool(current.get(&"playing")):
				playing += 1
			var voice_name := StringName(current.name)
			if voice_name == StationAudioVoices.HAPTIC \
				or voice_name == StationAudioVoices.ANCHOR_SUSTAIN \
				or voice_name == StationAudioVoices.ANCHOR_DRAG:
				shared_voices += 1
		for child in current.get_children():
			pending.append(child)
	return {"pooled": pooled, "playing": playing, "shared_voices": shared_voices}


func _collect_anchorables(node: Node) -> Array[Node]:
	var found: Array[Node] = []
	if node is AnchorableObject or node is MovableAnchorableProp:
		found.append(node)
	for child in node.get_children():
		found.append_array(_collect_anchorables(child))
	return found


func _collect_memory_points(node: Node) -> Array[Node]:
	var found: Array[Node] = []
	if node is MemoryResonancePoint:
		found.append(node)
	for child in node.get_children():
		found.append_array(_collect_memory_points(child))
	return found


func _find_camera(node: Node) -> CinematicCamera:
	if node is CinematicCamera:
		return node as CinematicCamera
	for child in node.get_children():
		var found := _find_camera(child)
		if found != null:
			return found
	return null


func _finish() -> void:
	print("================================================================================")
	if _failures.is_empty():
		print("PKG-0140 SMOKE PASS: sprzezenie Anchor/Yield, haptyka interakcji i kadr kamery zweryfikowane.")
		quit(0)
	else:
		print("PKG-0140 SMOKE FAIL: %d bledow" % _failures.size())
		for f in _failures:
			print("  - " + f)
		quit(1)
