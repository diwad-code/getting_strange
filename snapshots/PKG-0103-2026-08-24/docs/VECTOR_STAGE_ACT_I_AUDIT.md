# Rówień Vector-Stage — audyt Aktu I (PKG-0094)

Data: 2026-08-23. Autorstwo: własne płaskie płaszczyzny rysowane proceduralnie
w `VectorStageEnvironment`; nie użyto modelu generatywnego, zewnętrznej palety,
sceny, ikony ani materiału referencyjnego wymagającego atrybucji.

Kontrakt: każda kompozycja zachowuje istniejące `Geometry`, `CollisionShape2D`,
`Area2D` i zasięgi interakcji. Weryfikują go `tests/pkg_0094_smoke_test.gd` i
rendery `reports/pkg_0094_act1/`. Kolory pochodzą wyłącznie z własnej palety
`VectorStageStyle`: atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan i
tylko tam, gdzie stan tego wymaga, tlenek korekty.

| Stacja | Oś / funkcja fabularna | Negatywna przestrzeń i plan gry | Paleta (max 6) | Akcent stanu | Rekwizyt-świadek |
|---|---|---|---|---|---|
| 06 — Linia zastępcza | Pozioma, rytm wagonu i fałszywej trasy | Czarne szyby zostawiają długi oddech nad pasem przejścia 80–585 | atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan | bursztynowa obrączka / pasażer | `GoldRing`, zwrócona obrączka bez śladu na dłoni Leny |
| 07 — Wróciłaś | Pionowa, wymusza wzrok po schodach | Lewy szyb pozostaje ciemny; droga gry biegnie przy dolnym pasie do Marty i wyjścia | atrament, grafit, stal, jasna płaszczyzna, cyjan | pion cyjanu przy kondygnacji-widmie | `TenantDirectory`, wspólny adres Wolska/Kurek |
| 08 — Mieszkanie po kimś | Przekątna domowego stołu ku pustemu oknu | Prawy ciemny otwór nie konkuruje z czytelną dolną trasą interakcji | atrament, grafit, stal, jasna płaszczyzna, bursztyn | bursztynowy stół / para miejsc | `ReflectedPhoto`, wspólny kadr Marty i Leny |
| 09 — Pokój, który nie czeka | Pionowa tafla lustra i skośne odbicie | Cichy dół kadru zachowuje ścieżkę; lustro izoluje centrum bez szumu | atrament, grafit, stal, jasna płaszczyzna, tlenek korekty | tlenkowy klin opóźnienia | `ScratchedInscription`, napis na szkle |
| 10 — Gabinet Jakuba | Przekątna blatu prowadzi do technicznego portalu | Ciemny prawy portal jest celem; pas podłogi nie zmienia kolizji ani drogi | atrament, grafit, stal, jasna płaszczyzna, bursztyn, cyjan | cyjanowy portal przejścia | `TopographyBoard`, mapa ciągłości Jakuba |

## Wynik audytu

- Wszystkie pięć scen ma własny profil `station_number = 6..10`, niezmienioną
  geometrię fizyczną oraz warstwę `VectorStageEnvironment` za zawartością gry.
- Każdy kadr ogranicza się do 4–6 kolorów aktywnych; tlenek pojawia się tylko w
  Station 09 jako stan anomalny.
- Render i kontrakt techniczny potwierdzają istnienie warstwy, CRT, checkpointu,
  rigów atmosfery i kolizji podłogi. Nie dowodzą odczucia filmowości,
  zrozumienia fabuły ani dostępności kontrastu przez człowieka po raz pierwszy.