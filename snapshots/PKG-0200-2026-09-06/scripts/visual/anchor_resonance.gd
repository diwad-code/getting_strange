class_name AnchorResonance
extends RefCounted

## PKG-0140 shared audiovisual envelope for the Anchor / Yield mechanic (D-146).
##
## Kotwiczenie i uleglosc byly do tej pory czytane binarnie: obiekt albo mial
## zapalony pasek akcentu, albo nie. Chwyt, przesuniecie i zwolnienie kotwicy sa
## jednak trzema roznymi gestami gracza i musza brzmiec oraz wygladac inaczej.
## Ten modul trzyma jeden model obwiedni, z ktorego korzystaja `AnchorableObject`
## i `MovableAnchorableProp`, dzieki czemu obie rodziny rekwizytow pulsuja
## dokladnie tak samo i nie rozjezdzaja sie przy kolejnych pakietach.
##
## Kanon wizualny: pulsowanie jest liczone w `_draw()` sceny wektorowej, nie w
## `ShaderMaterial`. Jedyny shader projektu to `WorldPixelCompositor`; dolozenie
## drugiego materialu na obiekt gry rozjechaloby siatke 2 px kompozytora i
## zlamalo limit 7 kolorow palety (D-146).

## Czas narastania chwytu do pelnej sily (s).
const GRIP_ATTACK := 0.085
## Czas wygaszania chwytu po zwolnieniu kotwicy (s).
const GRIP_RELEASE := 0.34
## Czestotliwosc oddechu tonu harmonicznego przy utrzymanej kotwicy (Hz).
const SUSTAIN_HZ := 0.85
## Czestotliwosc drgania przy przesuwaniu rekwizytu (Hz).
const DRAG_HZ := 5.2
## Tempo wygaszania blysku oporu / uleglosci (1/s).
const FLASH_DECAY := 2.6
## Tempo wygaszania energii przesuwania, gdy gracz przestaje pchac (1/s).
const DRAG_DECAY := 4.5

## 0..1 — jak mocno rekwizyt jest w tej chwili trzymany.
var grip: float = 0.0
## 0..1 — energia ruchu przy pchaniu rekwizytu.
var drag: float = 0.0
## 0..1 — blysk oporu (kotwica wytrzymala korekte).
var resist_flash: float = 0.0
## 0..1 — blysk uleglosci (rekwizyt przyjal korekte).
var yield_flash: float = 0.0
## Faza oddechu tonu harmonicznego; wspolna dla dzwieku i rysunku.
var phase: float = 0.0
## Faza drgania przesuwania.
var drag_phase: float = 0.0

var _held: bool = false


## Gracz chwyta kotwice. Narastanie jest szybkie, ale nie natychmiastowe —
## to roznica miedzy "wcisnietym klawiszem" a "trzymanym przedmiotem".
func hold() -> void:
	_held = true


## Gracz zwalnia kotwice. Obwiednia opada wolniej niz narasta.
func release() -> void:
	_held = false


func is_held() -> bool:
	return _held


## Kotwica wytrzymala fale korekty.
func strike_resist() -> void:
	resist_flash = 1.0


## Rekwizyt przyjal korekte i zmienil stan rzeczywistosci.
func strike_yield() -> void:
	yield_flash = 1.0


## Energia przesuwania, znormalizowana predkoscia (0..1).
func feed_drag(speed_ratio: float) -> void:
	drag = maxf(drag, clampf(speed_ratio, 0.0, 1.0))


func advance(delta: float) -> void:
	if delta <= 0.0:
		return
	var target_grip := 1.0 if _held else 0.0
	var rate := GRIP_ATTACK if _held else GRIP_RELEASE
	grip = move_toward(grip, target_grip, delta / maxf(0.001, rate))
	drag = maxf(0.0, drag - DRAG_DECAY * delta)
	resist_flash = maxf(0.0, resist_flash - FLASH_DECAY * delta)
	yield_flash = maxf(0.0, yield_flash - FLASH_DECAY * delta)
	phase = fposmod(phase + TAU * SUSTAIN_HZ * delta, TAU)
	drag_phase = fposmod(drag_phase + TAU * DRAG_HZ * delta, TAU)


## Czy obwiednia wymaga jeszcze klatek rysowania i miksu dzwieku.
func is_active() -> bool:
	return _held \
		or grip > 0.001 \
		or drag > 0.001 \
		or resist_flash > 0.001 \
		or yield_flash > 0.001


## Oddech tonu harmonicznego: 0..1, zawsze przeskalowany sila chwytu, wiec
## zwolniona kotwica gasnie zamiast pulsowac w pustce.
func sustain_envelope() -> float:
	return grip * (0.72 + 0.28 * sin(phase) * MotionAccessibility.motion_scale())


## Mikro-drganie nakladane w trakcie przesuwania rekwizytu.
func drag_envelope() -> float:
	return drag * (0.5 + 0.5 * sin(drag_phase) * MotionAccessibility.motion_scale())


## Laczna sila blysku zdarzeniowego (opor lub uleglosc).
func flash_envelope() -> float:
	return maxf(resist_flash, yield_flash)


## Kolor akcentu wyliczony z obwiedni. Opor przebija uleglosc, uleglosc przebija
## stan spoczynkowy; chwyt przeciaga bursztyn w strone cyjanu proporcjonalnie do
## sily trzymania, wiec przejscie jest ciagle, nie skokowe.
func accent_color(rest_color: Color, hold_color: Color, yield_color: Color) -> Color:
	var base := rest_color.lerp(hold_color, clampf(grip, 0.0, 1.0))
	if yield_flash > 0.001:
		base = base.lerp(yield_color, yield_flash)
	if resist_flash > 0.001:
		base = base.lerp(hold_color, resist_flash)
	return base


## Alfa ramki pola kotwiczenia. Nigdy nie schodzi do zera przy trzymaniu, wiec
## zakotwiczony rekwizyt zawsze da sie odczytac jednym spojrzeniem.
func field_alpha() -> float:
	var a := 0.30 * grip + 0.34 * sustain_envelope() + 0.30 * flash_envelope()
	return clampf(a, 0.0, 1.0)


## Rozszerzenie ramki pola w pikselach swiata. Skok przy blysku czyta sie jako
## uderzenie fali korekty w kotwice.
func field_expansion() -> float:
	return 2.0 * grip + 1.6 * sustain_envelope() + 3.0 * flash_envelope() + 1.2 * drag_envelope()


## Glosnosc podtrzymanego tonu harmonicznego w dB dla `AudioStreamPlayer2D`.
## Zwraca `-80.0` (cisza) gdy kotwica nie jest trzymana.
func sustain_volume_db(peak_db: float = -14.0) -> float:
	var level := clampf(grip, 0.0, 1.0)
	if level <= 0.001:
		return -80.0
	return lerpf(-80.0, peak_db, level)


## Wysokosc tonu podtrzymanego. Przesuwanie rekwizytu lekko napina harmoniczna.
func sustain_pitch() -> float:
	return 1.0 + 0.045 * sin(phase) + 0.06 * drag_envelope()
