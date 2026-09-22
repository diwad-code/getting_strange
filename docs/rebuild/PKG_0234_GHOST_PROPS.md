# PKG-0234 — Duchy w pokojach (Pakiet A)

Data: 2026-09-15
Decyzja: D-246
Plan: `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` Pakiet A (A1–A4)

To **nie** jest Pakiet A z wyczerpanego planu PKG-0231.

## Cel

Pomieszczenie zawiera tylko przedmioty tego pomieszczenia. Kampania P9 nie
zależy od `is_passage_clear` z donicy/komody ani od balkonu jako progu.

## Wdrożenie

### A1. Stacja 09 — salon bez klatki

- `Geometry/StairwellPlanter` zostaje w drzewie (piny 0100/0119/0135/0146/smoke).
- Przesunięty na `(430, 287)` — doniczka przy komodzie/regału, nie na środku
  salonu. `collision_layer = 0` (gracz nie wpada), `collision_mask = 1`
  (stoi na podłodze). `object_name = "Doniczka na komodzie"`.
- `Geometry/StairFlight` zostaje (pin 0219: 5 StaticBody2D), ale
  `CollisionPolygon2D.disabled = true` — bieg schodów nie blokuje salonu
  (znaleziony in situ: polygon 52 px na x=400..570, nie 18 px curb).
- Auto-push w `_physics_process` zdjęty z trasy. Callable `push_planter` /
  `ask_neighbour_without_leading` zostają dla testów i **nie** otwierają
  progu kampanii. Próg: `respect_private_boundary()`.

### A2. Stacja 11 — lada UCP bez komody-przeszkody

- `Geometry/HallwaySideboard` zostaje. Przesunięty na `(500, 287)` — szafka
  akt przy drzwiach serwisowych, nie na drodze przez ladę.
  `collision_layer = 0`, `collision_mask = 1`.
- Komentarz 0192: `ZOSTAJE jako` zachowane; dopisek „węzeł w drzewie, nie
  jest przeszkodą trasy”.
- Auto-push zdjęty. Wyjście nadal po `request_minimal_report()`.

### A3. Stacja 12 — warsztat bez balkonu-wyjścia

- Binder `spec_for("station_12")`: `door: ""`, rodzina DOOR, apertura 48×112.
  `BalconyDoor` **nie** jest `blocking_body_path`.
- `BalconyDoor` zostaje w drzewie (0099/smoke/0192). Przesunięty na
  `(72, 140)` — wysokie skrzydło przy lewej ścianie, collider `disabled`.
  Animacja zamknięcia 72→156 zostaje dla 0099 (`x` rośnie).
- `_draw`: drzwi serwisowe na prawej krawędzi (536, 184, 54×112).
- Kwestia `s12_exit_back_home` bez zmian.

### A4. Stacja 13 — stół bez szuflady-bramki

- `DeskDrawer` zostaje. `_process` nadal animuje otwarcie dla testów, ale
  collider **zawsze** `disabled`. Synteza P9: `marta_source →
  institution_source → synthesize` bez `is_drawer_open`.

## Weryfikacja

- Nowa bramka `tests/pkg_0234_ghost_props_test.gd` PASS (7 kryteriów).
- Sąsiedzi: 0192, 0099, 0100, 0119, 0135, 0146, 0214, 0218, 0219, 0221,
  0233, 0207 (125/124/123).
- Kadry 09/11/12/13: 8 PNG s100 full/notext, `reports/pkg_0234/visual/`.
  Inspekcja HOLD obrazu: salon czyta się salonem; lada z Wierzbicką;
  warsztat z drzwiami serwisowymi; stół syntezy bez szuflady-bramki.
- Pin 0207: 124/123/122 → 125/124/123/123; 132. sekcja w `verify.ps1`.

## Twarde fakty

- `draw_play_plane` maluje tylko `StaticBody2D` z `RectangleShape2D`;
  donica/komoda to `CharacterBody2D` (własny `_draw` skrzyni); balkon i
  szuflada były niewidzialnymi colliderami.
- Wyłączenie collidera na `MovableAnchorableProp` bez zmiany warstwy
  spada przez podłogę (grawitacja). Warstwa 0 + maska 1 zostawia ciało
  na podłodze i zdejmuje je z maski gracza.
- Bieg `StairFlight` w 09 nie był w A1 promptu, ale był ciałem klatki w
  salonie (52 px, x=400..570). Zostaje węzeł, znika z trasy.

## Poza zakresem

Pakiet C (luki), B (cięcia/HATCH 13), D, E. Akt I. Linie
`creative_scene_lines.gd`. Stacje 19–41. Web, `.exe`, PRODUCT GO.
