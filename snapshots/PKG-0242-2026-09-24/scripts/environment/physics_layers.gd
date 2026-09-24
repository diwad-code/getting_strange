class_name PhysicsLayers
extends RefCounted

## PKG-0227 (D-240) — centralny pin warstw fizyki 2D (T5 z audytu PKG-0213).
##
## `project.godot [layer_names]` definiuje 4 warstwy; ten modul jest jedyna
## prawda o tym, ktora strefa srodowiskowa na ktorych warstwach zyje.
## Wartosci sa pinowane bramka `tests/pkg_0227_hygiene_tools_pin_test.gd`
## (4 strefy x 4 fakty: const warstwy, const maski, referencja w zrodle,
## runtime po _ready). Zmiana wartosci wymaga nowego pakietu z bramka.
##
## Konwencja (D-224): gracz slyszy swiat na masce 1 (warstwa "world").
## Strefy srodowiskowe nie nadaja na zadnej warstwie (layer 0) poza
## ReturnZone, ktora wspoldzieli warstwe 1 ze wzgledu na lewy prog powrotu;
## wszystkie nasluchuja wylacznie warstwy 1 (maska 1).

## Numery warstw wg project.godot [layer_names] (1-indeksowane nazwy).
const WORLD := 1
const PLAYER := 2
const TRIGGERS := 3
const INTERACTABLES := 4

## Bity warstw dla collision_layer / collision_mask.
const WORLD_BIT := 1
const PLAYER_BIT := 2
const TRIGGERS_BIT := 4
const INTERACTABLES_BIT := 8

## Tabela stref: [collision_layer, collision_mask] (Vector2i: x = layer, y = mask).
const THRESHOLD := Vector2i(0, 1)
const LADDER := Vector2i(0, 1)
const RETURN := Vector2i(1, 1)
const OPENING := Vector2i(0, 1)
