class_name StationCameraRig
extends RefCounted

## PKG-0141 — jeden kontrakt kamery kinowej dla wszystkich 45 stacji kampanii
## (D-150).
##
## Do PKG-0140 kampania miala trzy rozne sposoby na to samo:
##
## * stacje 01–23 nazywaly wezel `Camera`, podpinaly `target` i wolaly
##   `setup_chambers()`;
## * stacje 24–32 nazywaly wezel `Camera`, ale nie podpinaly niczego;
## * stacje 33–43 nazywaly wezel `Camera2D` i tez nie podpinaly niczego,
##   a czesc skryptow szukala wtedy wezla pod druga nazwa i dostawala `null`.
##
## Skutek: na 22 stacjach — calym Akcie IV i wszystkich trzech finalach —
## `CinematicCamera` byla martwym `Camera2D` zaparkowanym na (320, 180).
## Nie dzialalo tam sledzenie pionowe (D-120), kadr dialogowy (D-133), budzet
## kadrowania (D-136), wyprzedzenie kadru ani tlumienie transportu pionowego
## i natychmiastowe centrowanie po progu (D-148).
##
## Ten modul jest jedyna sciezka, ktora stacja ma prawo znac. Nazwa wezla,
## granice komory i kolejnosc podpiec zyja tutaj, a nie w 45 kopiach.

## Jedyna dozwolona nazwa wezla kamery w kampanii.
const NODE_NAME := "Camera"

## Logiczny kadr 640x360 (D-098). Powtorzony tutaj, bo granice komory sa
## definiowane wzgledem kadru, a nie wzgledem okna.
const VIEW_SIZE := Vector2(640.0, 360.0)


## Kamera stacji albo `null`. Jedyny czytnik, z ktorego korzystaja skrypty stacji.
static func resolve(station: Node) -> CinematicCamera:
	if station == null:
		return null
	return station.get_node_or_null(NODE_NAME) as CinematicCamera


## Granice komor stacji.
##
## Kampania jest zbudowana z pokoi dokladnie jednego kadru: kazda stacja to
## jedna komora 640x360, a caly transport pionowy (drabiny, windy towarowe)
## miesci sie w tym kadrze. Zwracamy wiec jedna komore rowna kadrowi.
##
## To nie jest uproszczenie na skroty, tylko zapisany kontrakt: `CinematicCamera`
## zwija wtedy klamr pionowy do srodka komory, a `get_framing_budget()` liczy
## zejscie kadru dialogowego wzglednie do namalowanego fartucha (D-136). Gdyby
## kiedys powstala stacja wyzsza niz kadr, to jest jedyne miejsce, w ktorym
## trzeba to opisac.
static func chamber_bounds(_station: Node) -> Array[Rect2]:
	var bounds: Array[Rect2] = [Rect2(Vector2.ZERO, VIEW_SIZE)]
	return bounds


## Podpina kamere stacji: cel, komory i pozycje startowa. Zwraca kamere, zeby
## skrypt stacji mial ja pod reka bez drugiego `get_node_or_null()`.
##
## Kamera jest tworzona w locie tylko wtedy, gdy scena jej nie ma — bramka
## `pkg_0141_smoke_test.gd` pilnuje, zeby zaden `.tscn` kampanii nie polegal na
## tej sciezce awaryjnej.
static func bind(station: Node, player: Node2D) -> CinematicCamera:
	if station == null:
		return null
	var camera := resolve(station)
	if camera == null:
		camera = CinematicCamera.new()
		camera.name = NODE_NAME
		station.add_child(camera)
	camera.position = VIEW_SIZE * 0.5
	if is_instance_valid(player):
		camera.target = player
	camera.setup_chambers(chamber_bounds(station))
	return camera


## Czy stacja spelnia kontrakt: wezel o wlasciwej nazwie, skrypt `CinematicCamera`,
## podpiety cel i niepusta lista komor. Uzywane przez bramke na wszystkich
## 45 scenach.
static func is_bound(station: Node) -> bool:
	var camera := resolve(station)
	if camera == null:
		return false
	if not is_instance_valid(camera.target):
		return false
	return not camera.chamber_bounds.is_empty()
