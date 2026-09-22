class_name MotionAccessibility
extends RefCounted

## PKG-0141 — jeden globalny przelacznik trybu ograniczonego ruchu (D-151).
##
## Migotanie swietlowek, pulsowanie pola kotwiczenia, wstrzas kamery i emisja
## mikro-czastek to cztery niezalezne zrodla ruchu peryferyjnego. Dla czesci
## graczy — przedsionkowo wrazliwych, ze swiatlowstretem, z migrena — kazde z
## nich jest kosztem, a zadne nie niesie informacji. Do tej pory nie mialy
## zadnego wspolnego wylacznika.
##
## Ten modul jest jedynym zrodlem prawdy o trybie. Jest `static`, a nie
## autoloadem ani wezlem, z trzech powodow:
##
## 1. `AnchorResonance` i `ParticleBudget` to `RefCounted` bez dostepu do drzewa —
##    autoload wymagalby przekazywania referencji przez pol kampanii.
## 2. Bramki naglowkowe (`SceneTree` bez sceny glownej) czytaja stan bez
##    stawiania calego `GameStateManager`.
## 3. Stan przezywa zmiane sceny bez zadnego dodatkowego okablowania, wiec
##    "trwaly miedzy scenami" jest wlasciwoscia modulu, nie obietnica stacji.
##
## Trwalosc na dysku i lokalizacja naleza do `GameStateManager` i
## `SettingsOverlay`; ten modul zna wylacznie wartosc i jej konsumentow.
##
## Kontrakt: tryb tlumi RUCH, nie INFORMACJE. Kazdy konsument obniza amplitude
## do zera i zostawia poziom spoczynkowy, wiec swiatlo dalej swieci, pole
## kotwiczenia dalej sie rysuje, a rekwizyt dalej daje sie odczytac jednym
## spojrzeniem. Snap 2 px kompozytora (D-120) nie zalezy od tego trybu.

## Domyslnie tryb jest wylaczony: kanon wizualny 3.0 jest kanonem ruchomym.
static var _reduced_motion := false


static func is_reduced_motion() -> bool:
	return _reduced_motion


static func set_reduced_motion(enabled: bool) -> void:
	_reduced_motion = enabled


## Mnoznik amplitudy dowolnego ruchu peryferyjnego. Konsument mnozy przez niego
## SAMA amplitude, nigdy poziom spoczynkowy — dzieki temu tryb nie gasi obrazu.
static func motion_scale() -> float:
	return 0.0 if _reduced_motion else 1.0


## Czy warstwa dekoracyjnych mikro-czastek (kurz, para, unoszacy sie pyl) ma
## emitowac. Bursty zdarzeniowe niosace informacje (opor kotwicy, uleglosc)
## NIE przechodza przez ten warunek.
static func allows_micro_particles() -> bool:
	return not _reduced_motion


## Czy kamera moze przyjac wstrzas. Wstrzas jest zawsze akcentem, nigdy
## jedynym nosnikiem informacji, wiec tryb moze go zdjac w calosci.
static func allows_camera_shake() -> bool:
	return not _reduced_motion


## Resetuje modul do stanu fabrycznego. Uzywane przez bramki, zeby jedna z nich
## nie zostawila wlaczonego trybu kolejnej.
static func reset() -> void:
	_reduced_motion = false
