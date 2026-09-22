class_name ParticleBudget
extends RefCounted

## ParticleBudget — jedyny kontrakt czasu klatki dla cząstek CPU (PKG-0130).
##
## Świat jest kompozytowany przez siatkę 320x180 nearest-neighbour, więc symulacja
## cząstek szybsza niż 30 Hz nie daje żadnej widocznej różnicy — a każdy krok
## symulacji CPUParticles2D to koszt na rdzeniu w budżecie 16.66 ms.
##
## Każdy emiter w projekcie MUSI przejść przez `apply_frame_budget()`. Bramka
## `tests/pkg_0130_smoke_test.gd` oraz audyt `tools/frame_budget_audit.gd`
## odrzucają emitery bez nałożonego limitu.
##
## `fract_delta = false` usuwa interpolację częściowego kroku: symulacja staje się
## deterministyczna klatka po klatce, więc identyczne wejście daje identyczny
## przebieg cząstek — warunek powtarzalnego profilingu.

## Docelowa częstotliwość symulacji cząstek (Hz).
const SIMULATION_FPS := 30

## Maksymalna liczba jednocześnie aktywnych (emitujących) emiterów na scenę.
const MAX_ACTIVE_EMITTERS := 6

## Maksymalna liczba jednocześnie żywych cząstek na scenę.
const MAX_ACTIVE_PARTICLES := 128

## Maksymalna liczba wstępnie zaalokowanych (uśpionych) emiterów na scenę.
## Uśpiony emiter one-shot nie kosztuje nic na klatkę, ale zajmuje pamięć,
## dlatego pula również ma sufit.
const MAX_POOLED_EMITTERS := 20


## Nakłada kontrakt czasu klatki na jeden emiter cząstek.
static func apply_frame_budget(particles: CPUParticles2D) -> void:
	if particles == null:
		return
	particles.fixed_fps = SIMULATION_FPS
	particles.fract_delta = false


## Deterministycznie wygasza emiter i porzuca wszystkie żywe instancje cząstek.
## Wywoływane przy opuszczaniu drzewa, aby zmiana scen nigdy nie zostawiała
## wygasających cząstek symulowanych w tle.
static func release(particles: CPUParticles2D) -> void:
	if particles == null or not is_instance_valid(particles):
		return
	particles.emitting = false
	particles.restart()
	particles.emitting = false


## PKG-0141 (D-151). Emisja jednego DEKORACYJNEGO emitera mikro-cząstek: pyłu,
## pary, kurzu spod stóp. Tryb ograniczonego ruchu gasi tę warstwę w całości,
## bo nie niesie ona żadnej informacji — stan zakotwiczenia, opór i uległość
## mają własny rysunek pola i własne bursty zdarzeniowe, i przez ten warunek
## NIE przechodzą.
static func set_micro_emission(particles: CPUParticles2D, wanted: bool) -> void:
	if particles == null or not is_instance_valid(particles):
		return
	particles.emitting = wanted and MotionAccessibility.allows_micro_particles()


## Czy warstwa dekoracyjnych mikro-cząstek ma prawo emitować.
static func allows_micro_particles() -> bool:
	return MotionAccessibility.allows_micro_particles()


## Czy emiter ma nałożony kontrakt budżetu.
static func is_within_frame_budget(particles: CPUParticles2D) -> bool:
	if particles == null:
		return false
	return particles.fixed_fps == SIMULATION_FPS and not particles.fract_delta
