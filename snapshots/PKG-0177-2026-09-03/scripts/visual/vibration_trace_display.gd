class_name VibrationTraceDisplay
extends Node2D

## PKG-0176 / DEF-1 — jeden przebieg drgań dla obu warstw zimnego otwarcia.
##
## `COLD_OPEN_SPEC.md` §3 (ujęcie 3) i §4.1 (kroki 3–4) opisują ten sam obraz
## widziany dwa razy: szum tła, gwałtowny wzrost przy przejeździe, wygaszenie,
## a w zapisie archiwalnym płaska linia o długości trzech sekund otoczona
## normalnym szumem. Spec wymaga wprost, żeby wykres był rysowany proceduralnie
## w kadrze, a nie teksturą.
##
## Węzeł jest mały i bezstanowy poza trybem i postępem przebiegu, więc warstwa A
## (`ColdOpen`) i warstwa B (`Station01`) współdzielą jeden rysunek zamiast
## dublować go w monolicie (`PRESENTATION_REPAIR_PLAN.md` §0, reguła 1).
##
## Amplituda jest funkcją wyłącznie pozycji w oknie czasu, bez fazy i bez
## losowości: dzięki temu `sample_amplitude()` jest tym samym dowodem dla bramki,
## dla kadru i dla trybu ograniczonego ruchu.

enum Mode {
	IDLE,     ## sam szum spoczynkowy
	LIVE,     ## przebieg rysowany na żywo do `pass_progress`
	ARCHIVE,  ## zapis archiwalny z płaską trzysekundową luką
}

## Okno czasu widoczne na ekranie przyrządu.
const WINDOW_SECONDS := 20.0
## Długość luki w zapisie archiwalnym — ta sama liczba, o której mówi Lena.
const GAP_SECONDS := 3.0
const SAMPLE_COUNT := 128
const NOISE_AMPLITUDE := 0.17
const SPIKE_AMPLITUDE := 0.86
## Środek i szerokość skoku przy przejeździe, w ułamku okna.
const SPIKE_CENTER := 0.46
const SPIKE_WIDTH := 0.055

@export var screen_size := Vector2(86.0, 54.0)
@export var mode: Mode = Mode.IDLE:
	set(value):
		mode = value
		queue_redraw()
@export var trace_color: Color = VectorStageStyle.ANCHOR_CYAN
@export var grid_color: Color = VectorStageStyle.MID_PLANE
@export var gap_color: Color = VectorStageStyle.CORRECTION_OXIDE
@export var draw_bezel := true

## 0..1 — ile przebiegu jest już narysowane. Warstwa steruje tym z zewnątrz,
## więc ten sam węzeł obsługuje automatyczne ujęcie 3 i pomiar uruchomiony
## przez gracza w Station 01.
var pass_progress := 0.0:
	set(value):
		pass_progress = clampf(value, 0.0, 1.0)
		queue_redraw()


func gap_window() -> Vector2:
	var half := (GAP_SECONDS / WINDOW_SECONDS) * 0.5
	return Vector2(0.5 - half, 0.5 + half)


func is_in_gap(t: float) -> bool:
	var window := gap_window()
	return t >= window.x and t <= window.y


## Amplituda w zakresie -1..1 dla pozycji `t` (0..1) w oknie czasu.
## Bramka GATE-INTRO czyta tę funkcję jako dowód M4: luka jest płaska, a
## otoczenie luki nie jest.
func sample_amplitude(t: float) -> float:
	var clamped := clampf(t, 0.0, 1.0)
	match mode:
		Mode.IDLE:
			return _noise(clamped)
		Mode.LIVE:
			if clamped > pass_progress:
				return 0.0
			return clampf(_noise(clamped) + SPIKE_AMPLITUDE * _spike_envelope(clamped), -1.0, 1.0)
		Mode.ARCHIVE:
			if is_in_gap(clamped):
				return 0.0
			return _noise(clamped)
	return 0.0


## Czy przebieg pokazał już skok przejazdu (skutek widoczny).
func has_reached_spike() -> bool:
	return mode == Mode.LIVE and pass_progress >= SPIKE_CENTER + SPIKE_WIDTH


## Czy przebieg wrócił do szumu po skoku (stan spoczynku).
func has_returned_to_noise() -> bool:
	return mode == Mode.LIVE and pass_progress >= SPIKE_CENTER + SPIKE_WIDTH * 4.0


func _noise(t: float) -> float:
	return NOISE_AMPLITUDE * (0.62 * sin(t * 137.0) + 0.38 * sin(t * 61.0 + 1.7))


func _spike_envelope(t: float) -> float:
	var d := (t - SPIKE_CENTER) / SPIKE_WIDTH
	return exp(-d * d)


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, screen_size)
	draw_rect(rect, VectorStageStyle.INK)
	if draw_bezel:
		draw_rect(rect, VectorStageStyle.shade(grid_color, 0.20), false, 1.0)
	var mid_y := screen_size.y * 0.5
	draw_line(Vector2(0.0, mid_y), Vector2(screen_size.x, mid_y), VectorStageStyle.shade(grid_color, 0.42), 1.0)
	for step in range(1, 4):
		var x := screen_size.x * float(step) / 4.0
		draw_line(Vector2(x, 2.0), Vector2(x, screen_size.y - 2.0), VectorStageStyle.shade(grid_color, 0.58), 1.0)

	if mode == Mode.ARCHIVE:
		var window := gap_window()
		var gap_rect := Rect2(
			Vector2(window.x * screen_size.x, 2.0),
			Vector2((window.y - window.x) * screen_size.x, screen_size.y - 4.0)
		)
		draw_rect(gap_rect, Color(gap_color, 0.16))
		draw_rect(gap_rect, Color(gap_color, 0.55), false, 1.0)

	var points := PackedVector2Array()
	var half_height := (screen_size.y * 0.5) - 3.0
	var visible_limit := 1.0 if mode != Mode.LIVE else pass_progress
	for index in range(SAMPLE_COUNT + 1):
		var t := float(index) / float(SAMPLE_COUNT)
		if t > visible_limit:
			break
		points.append(Vector2(t * screen_size.x, mid_y - sample_amplitude(t) * half_height))
	if points.size() >= 2:
		draw_polyline(points, trace_color, 1.0)
