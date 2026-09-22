# Audyt przeszkód — Akt I, Station 01..10

Status: **AUDYT PAKIETU PKG-0100**  
Data: 2026-08-24  
Zakres: widoczność Vector-Stage w Station 01..10 oraz jedna przeszkoda w
Station 06..10.  
Nadrzędny kanon: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`.

Ten dokument sprawdza zgodność z kanonem i kontraktami technicznymi. Nie twierdzi,
że przeszkody są przyjemne, emocjonalnie skuteczne ani zrozumiałe dla nowej osoby;
projekt nie prowadzi zewnętrznych playtestów (D-012, ADR-003).

---

## 1. Stan po pakiecie

Station 01..05 pozostają prologiem pomiaru bez nowej próby fizycznej. Ich kadry
mają wspólny Vector-Stage i drogę wyprowadzoną z rzeczywistych colliderów.
Station 06..10 mają po jednej rzeczy świata, która zmienia stan bez dodawania
nowego czasownika ruchu.

| Przestrzeń | Rzecz świata | Rodzina | Implementacja |
|---|---|---|---|
| 06 | `ReplacementBusExitDoor` | R5 — infrastruktura w cyklu | `AnimatableBody2D` przy wyjściu autobusu |
| 07 | `ConcreteStairFlight` | R7 — realna architektura pionowa | przytwierdzony `StaticBody2D` z `CollisionPolygon2D` |
| 08 | `HallwaySideboard` | R4 — ciężar i bezwładność | istniejący `MovableAnchorableProp` |
| 09 | `ObservedMirror` | R1 — niezgodność wersji | istniejący `AnchorableObject`, dwa rozmiary tego samego mocowania |
| 10 | `IdentityGate` | R2 — próg administracyjny | `AnimatableBody2D` otwierany po rozmowie |

Nie zmieniono istniejących floorów, ścian, sufitów, `AirlockZone` ani promieni
interakcji. Nowe bryły są osobnymi węzłami zapisanymi w bramce
`tests/pkg_0100_smoke_test.gd`.

---

## 2. Station 06 — drzwi autobusu zastępczego

**Rodzina:** R5, infrastruktura wykonująca własną pracę. Autobus jedzie, daje
ogłoszenie i dopiero po spełnieniu scenicznych warunków zatrzymuje się oraz
odryglowuje pneumatyczne drzwi.

**Test trzech pytań** (nagłówek w `scripts/levels/station_06.gd`):

1. *Dlaczego to tu jest?* — autobus zastępczy wykonuje niezależny cykl postoju,
   zanim otworzy pneumatyczne drzwi na końcu trasy.
2. *Czego wymaga od Leny?* — zatrzymania się przy drzwiach i rozpoznania pełnego
   cyklu otwarcia.
3. *Co się dzieje, gdy się nie uda?* — powrót na przystanek wejścia, a
   ogłoszenie traci jedną informację o trasie.

**Implementacja i granica platformingu.** `ReplacementBusExitDoor` jest
`AnimatableBody2D` przytwierdzonym do tylnego wyjścia. Nie jest celem skoku ani
poruszającą się podłogą; otwarcie wynika z pracy drzwi i zatrzymania autobusu.
Zamknięte drzwi są widoczne jako cynobrowy kontur, otwarte jako dwie krawędzie
cyan. Bramka sprawdza zmianę położenia drzwi.

**Model porażki.** `_apply_bus_exit_correction()` zapisuje
`station_06_bus_exit_corrected`, resetuje Lenę do `Vector2(80, 296)` i utrwala
`bus_exit_detail_faded`. To korekta, nie śmierć ani koniec poziomu.

---

## 3. Station 07 — betonowy bieg schodów

**Rodzina:** R7, realna architektura pionowa. Bieg jest częścią klatki schodowej,
a nie zawieszonym klockiem.

**Test trzech pytań** (nagłówek w `scripts/levels/station_07.gd`):

1. *Dlaczego to tu jest?* — betonowy bieg schodów prowadzi do rzeczywistego
   półpiętra klatki, którego krawędź nie może wisieć w powietrzu.
2. *Czego wymaga od Leny?* — wejścia po przytwierdzonym biegu i rozpoznania,
   że górne półpiętro należy do tej samej klatki.
3. *Co się dzieje, gdy się nie uda?* — korekta odsyła do dolnego spocznika,
   a oznaczenie brakującej kondygnacji zostaje wyblakłe.

**Implementacja i granica platformingu.** `ConcreteStairFlight` ma stały
trójkątny `CollisionPolygon2D` oparty o podłogę. Warstwa stanu rysuje jeden
ciągły betonowy klin i jego krawędź, bez oddzielnych stopni do przeskakiwania.
Nie ma timera skoku ani pływającej geometrii.

**Model porażki.** `_apply_stairwell_correction()` zapisuje
`station_07_stairwell_corrected`, resetuje Lenę do dolnego spocznika i utrwala
`stair_detail_faded`. Przejście przez bieg ustawia `stair_flight_crossed`, a
wyjście wymaga także otwartych drzwi mieszkania.

---

## 4. Station 08 — ciężka szafka kartotekowa

**Rodzina:** R4, ciężar i bezwładność rzeczy, która już stoi w świecie.

**Test trzech pytań** (nagłówek w `scripts/levels/station_08.gd`):

1. *Dlaczego to tu jest?* — szafka kartotekowa zablokowała jedyny korytarz,
   bo ciężar mebla przesunął się razem z mieszkaniem.
2. *Czego wymaga od Leny?* — odepchnięcia ciężkiej szafki do wnęki i
   zostawienia przejścia dla następnej osoby.
3. *Co się dzieje, gdy się nie uda?* — korekta przywraca szafkę na wejście,
   a jeden szczegół mieszkania traci ostrość.

**Implementacja i granica platformingu.** `HallwaySideboard` używa istniejącej
klasy `MovableAnchorableProp`, z grawitacją, tarciem i pchaniem przez kontakt z
wejściem `move_left`/`move_right`. Nie tworzy nowej klasy ani nowego czasownika;
wysoki mebel blokuje przejście jako mebel, nie jako ściana do skoku. Kotwiczenie
pozostaje stanem obiektu, a nie wymaganym skokiem.

**Model porażki.** `_apply_sideboard_correction()` zapisuje
`station_08_sideboard_corrected`, wywołuje `reset_to_spawn()`, resetuje Lenę do
wejścia i utrwala `sideboard_detail_faded`. Bramka sprawdza, że `receive_push`
realnie zmienia pozycję szafki.

---

## 5. Station 09 — lustro i niezgodność mocowania

**Rodzina:** R1, dwie wersje tej samej rzeczy. To pierwsze użycie
`AnchorableObject` w tym pakiecie, ale nie jest to ruchoma platforma.

**Test trzech pytań** (nagłówek w `scripts/levels/station_09.gd`):

1. *Dlaczego to tu jest?* — lustro ma dwa stałe mocowania, a wersja korytarza
   wybiera jedno z nich.
2. *Czego wymaga od Leny?* — zakotwiczenia właściwego mocowania przed przejściem
   i zaakceptowania kosztu dla zapisu.
3. *Co się dzieje, gdy się nie uda?* — korekta odsyła do umywalki, a ślad
   inskrypcji traci jedną warstwę czytelności.

**Implementacja i granica platformingu.** `ObservedMirror` pozostaje w tym
samym miejscu (`state_a_position == state_b_position`), a wersje różnią się
rozmiarem panelu: pełne lustro albo węższy, niepełny ślad. Kolizja obiektu jest
wyłączona, bo lustro jest mocowaniem na ścianie, nie blokadą trasy. Trzymane
lustro opiera się korekcie; nietrzymane przechodzi do wersji B.

**Model porażki.** `run_mirror_correction_pass()` uruchamia zmianę stanu.
`_apply_mirror_correction()` zapisuje `station_09_mirror_corrected`, resetuje
Lenę do umywalki i utrwala `mirror_detail_faded`. Zakotwiczenie zapisuje
`station_09_anchored_mirror`.

---

## 6. Station 10 — administracyjny próg tożsamości

**Rodzina:** R2, profil lokalny i dokument/version gate. Próba nie jest
platformingiem, tylko konsekwencją rozmowy telefonicznej.

**Test trzech pytań** (nagłówek w `scripts/levels/station_10.gd`):

1. *Dlaczego to tu jest?* — próg techniczny jest zamknięty, dopóki telefon nie
   potwierdzi tożsamości lokalnej wersji Jakuba.
2. *Czego wymaga od Leny?* — wysłuchania potwierdzenia przy telefonie i
   przejścia przez otwarty próg bez wymuszania wersji.
3. *Co się dzieje, gdy się nie uda?* — korekta odsyła do biurka, a jeden
   szczegół rozmowy zostaje wyciszony.

**Implementacja i granica platformingu.** `IdentityGate` to pionowa bramka
`AnimatableBody2D` na istniejącym przejściu. Dialog D-04 otwiera ją przez
`_check_unlock_conditions()` i przesuwa do górnego gniazda; nie ma platformy,
spadania ani skoku. Wyjście sprawdza `is_airlock_unlocked`.

**Model porażki.** `_apply_identity_gate_correction()` zapisuje
`station_10_identity_gate_corrected`, resetuje Lenę do biurka i utrwala
`gate_detail_faded`. Korekta nie kończy sceny i nie zmienia limitu kampanii.

---

## 7. Dowód techniczny i otwarte hipotezy

`tests/pkg_0100_smoke_test.gd` uruchamia wszystkie sceny 01..10, sprawdza
faktyczne floor names, shell colliders, `AirlockZone`, promienie rekwizytów,
profile `station_number`, pierwszy call `draw_play_plane`, typy nowych rzeczy,
zmiany stanów, nagłówki oraz łańcuch 01..10 przy limicie 25. `traversal_lint_test.gd`
przechodzi bez naruszenia zakazu platformingu.

Rendery w `reports/pkg_0100/` zostały wykonane na normalnym sterowniku Windows
i obejrzane. To dowód obecności kompozycji, nie dowód odbioru. Otwarte pozostają
hipotezy H-0100-A: czy pięć rodzin przeszkód różnicuje rytm Aktu I bez dodatkowych
czasowników, oraz H-0100-B: czy wyblakły detal jest odczytywany jako koszt, a nie
usterka. Bez zewnętrznych playtestów nie wolno nadać im statusu potwierdzonego.
