# Audyt przeszkód Aktu IV — Station 41 (PKG-0106)

Data: 2026-08-24. Zakres: wyłącznie Godot 4.7, `Station 41 — Komora Wyboru
Operacyjnego`. Audyt wykonano przed zmianą sceny i skryptu. Obowiązują
`docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`, D-099, D-106 oraz twarda granica
Godot-only z D-098.

## Stan read-only przed pakietem

- `scenes/levels/station_41.tscn` ma wyłącznie shell geometrii:
  `Geometry/FloorMain`, `Geometry/Ceiling`, `Geometry/WallLeft` i
  `Geometry/WallRight`. Odpowiadające prostokąty mają rozmiary `640×80`,
  `640×48` oraz `20×360` dla każdej ściany.
- `AirlockZone` istnieje przy `Vector2(610, 245)` i zachowuje prostokąt
  `50×70`. Scena ma `Player`, `Camera2D` oraz sygnał `level_completed`.
- `Props` zawiera wyświetlacz topografii, trzy konsole operacyjne i wrota:
  `TopographyDisplay`, `ConsoleReturnA`, `ConsoleReconciliationB`,
  `ConsoleTestimonyC`, `Station41Exit`. Ich promienie interakcji to kolejno
  `48`, `48`, `48`, `48`, `60`.
- `scripts/levels/station_41.gd` ma zachowane sygnały
  `interaction_triggered`, `operation_selected`, `dialogue_advanced` oraz
  metody `select_operation`, `unlock_exit`, `_complete_level` i obsługę
  `AirlockZone`. Wybór A/B/C odryglowuje istniejące wrota, a wejście w strefę
  kończy scenę.
- Przed pakietem scena nie ma `VectorStageEnvironment`, `AtmosphereRig`,
  `CRTDialogueBox` ani `OpeningDialogueCue`. `_draw()` maluje własne,
  nieprzezroczyste tło komory zamiast korzystać z rozdziału odpowiedzialności
  Vector-Stage.
- Nie ma `AnimatableBody2D`, dodatkowego `StaticBody2D`, pułapki, cyklu maszyny
  ani osobnego testu ruchowego. Istniejący `AnchorableObject` pozostaje
  dostępny w projekcie, ale Station 41 nie potrzebuje go do decyzji finałowej.

## Decyzja: świadoma cisza mechaniczna

Station 41 nie dostaje nowej przeszkody diegetycznej. Komora jest miejscem
odpowiedzialnego wyboru jednej z trzech operacji, a nie miejscem sprawdzania
zręczności, rytmu ani prawidłowej odpowiedzi. Dodanie bryły tylko po to, by
zapełnić kadr albo powtórzyć poprzednią rodzinę R, zafałszowałoby stawkę finału.

Kontrakt pakietu:

- `Geometry` zachowuje dokładnie cztery istniejące ciała shell;
- liczba `AnimatableBody2D` w geometrii wynosi dokładnie `0`;
- nie dodaje się nowego czasownika, strefy porażki, śmierci, paska zdrowia ani
  zmiany checkpointu wynikającej z błędu wykonawczego;
- A, B i C pozostają równoprawnie dostępne, a wybór odblokowuje istniejące
  wrota do odpowiedniego finału 42A, 42B albo 42C bez modyfikowania scen
  finałowych i bez rozszerzania centralnego łańcucha kampanii poza 25.

## Test trzech pytań — świadoma cisza Station 41

1. **Dlaczego to tu jest?** — Komora UCP rozdziela trzy operacje, ponieważ
   odpowiedzialność za sprzeczną historię musi zostać załączona w jednym,
   jawnie obserwowalnym miejscu.
2. **Czego wymaga od Leny?** — Odczytania topografii świadków, porównania
   nazwanych kosztów i fizycznego załączenia jednej z konsol A/B/C, a następnie
   przejścia przez wrota wybranej operacji.
3. **Jaki jest koszt porażki?** — Nie ma korekty fizycznej; dopóki żadna
   konsola nie zostanie załączona, wrota pozostają zamknięte, lecz wszystkie
   trzy operacje nadal są dostępne i nie powstaje fikcyjny test poprawnej
   zręcznościowo odpowiedzi.

## Konsekwencje dla implementacji i dowodu

- `VectorStageEnvironment` dostarcza kadr i ręczny profil komory; droga jest
  wyprowadzana z istniejącego `Geometry` przez pierwszy krok warstwy stanu
  `VectorStageStyle.draw_play_plane(self, geometry)`.
- Skrypt Station 41 rysuje wyłącznie relacje stanu, trzy stanowiska, mapę
  świadków, wrota i istniejący HUD. Stare nieprzezroczyste rysowanie zostaje
  poza aktywną ścieżką.
- Bramka `tests/pkg_0106_smoke_test.gd` sprawdzi profil 41, węzły UI i cue,
  shell, promienie, sygnały, wybór A/B/C, zero `AnimatableBody2D`, test trzech
  pytań, aktywną warstwę stanu oraz granicę kampanii 25 / schema 1.
- Render `reports/pkg_0106/station_41.png` będzie dowodem technicznym obecności
  trzech stanowisk, drogi i hierarchii komory. Nie będzie dowodem funu,
  emocji, czytelności przez nową osobę ani zrozumienia fabuły.
