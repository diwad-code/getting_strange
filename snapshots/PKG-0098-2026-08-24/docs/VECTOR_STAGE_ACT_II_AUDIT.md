# Rówień Vector-Stage — audyt Aktu II (PKG-0095)

Data: 2026-08-23. Autorstwo: własne płaskie płaszczyzny rysowane proceduralnie
w `VectorStageEnvironment`; nie użyto modelu generatywnego, zewnętrznej palety,
sceny, ikony ani materiału referencyjnego wymagającego atrybucji.

Kontrakt: kompozycje zachowują istniejące `Geometry`, `CollisionShape2D`,
`Area2D` oraz zasięgi interakcji. Potwierdzają go `tests/pkg_0095_smoke_test.gd`
i rendery `reports/pkg_0095_act2/`. Paleta pochodzi wyłącznie z
`VectorStageStyle`: atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan
i tlenek korekty stosowany wyłącznie jako sygnał konfliktu stanu.

| Stacja | Oś / funkcja fabularna | Negatywna przestrzeń i plan gry | Paleta (max 6) | Akcent stanu | Rekwizyt-świadek |
|---|---|---|---|---|---|
| 11 — Pierwsza korekta | Opadająca przekątna z galerii ku dziedzińcowi | Ciemny prawy plac nie konkuruje z zejściem i strefą wyjścia | atrament, grafit, stal, jasna płaszczyzna, tlenek | tlenkowy ślad wygładzanego wejścia | `ErasedDoorwayTrace`, wymazany próg mieszkanki |
| 12 — Archiwum pod przejściem | Pozioma archiwalna półka przecina centralną pustkę | Środkowy mrok zachowuje drogę przy dolnej krawędzi i oddech kadru | atrament, grafit, stal, jasna płaszczyzna, cyjan | pion cyjanu przy indeksie pamięci | `UCPInfoTerminal`, rejestr sprzecznych przejść |
| 13 — Pokój planów | Przekątne rzutów prowadzą ku szczelinie po prawej | Boczny atramentowy otwór jest celem, nie dekoracją; pas podłogi pozostał czytelny | atrament, grafit, stal, jasna płaszczyzna | jasny klin planu | `DraftingTable`, podwójny obrys pomieszczenia |
| 14 — Szyb serwisowy | Sprasowana pionowa rytmika przęseł | Wąska przestrzeń nad drogą jest niepokojąco pusta, ale nie zmienia kolizji podłogi | atrament, grafit, stal, jasna płaszczyzna, tlenek | tlenkowy obszar szwu | `MetalScratchBeam`, rysa wymagająca zakotwiczenia |
| 15 — Korytarz przewodów | Długa pozioma rura prowadzi do bramy | Dolna siatka zostawia przewidywalny plan ruchu; prawy cyjan wskazuje cel | atrament, grafit, stal, jasna płaszczyzna, cyjan | cyjanowa brama serwisowa | `PressureReliefValve`, zawór oddechu magistrali |

## Wynik audytu

- Station 11..15 mają odrębne profile `station_number = 11..15`, `AtmosphereRig`,
  CRT i checkpoint cue; warstwy rysują się za zawartością poziomu.
- Aktywne kadry stosują 4–6 kolorów. Tlenek występuje wyłącznie w Station 11 i
  14, gdzie oznacza korektę lub niestabilny szew.
- `GameStateManager` centralnie nasłuchuje istniejącego `level_completed` dla
  Station 01..15: odblokowuje kolejną stację, zapisuje kampanię i przechodzi
  przez fade. Station 15 jest obecnym krańcem dostarczonego łańcucha i nie
  odblokowuje jeszcze Station 16.
- Render oraz smoke potwierdzają techniczny kontrakt. Nie dowodzą odbioru
  filmowości, zrozumienia fabuły, komfortu sterowania ani dostępności kontrastu
  dla człowieka widzącego materiał po raz pierwszy.