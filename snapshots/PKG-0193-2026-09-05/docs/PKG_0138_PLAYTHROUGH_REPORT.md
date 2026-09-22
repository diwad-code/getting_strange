# PKG-0138 Narrative Playthrough & Player Verbs Report

**Data:** 2026-08-29  
**Zakres:** Kampania 01→43 (wszystkie 45 scen: 01–41, 42a, 42b, 42c, 43)  
**Kanon:** `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `VISUAL_DESIGN.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`  
**Status:** **100% CLEAN (0 BLOCKERS across all 45 stations)**

---

## 1. Cel pakietu i reguła grywalności (D-141)

Dotychczasowe bramki weryfikacyjne sprawdzały geometrię, etykiety diegetyczne, fartuch sceny i budżet klatek. Część testów odryglowywała jednak wyjścia przez bezpośrednie wołanie metod `unlock_exit_door()` lub przestawianie flag z poziomu skryptu testowego.

**PKG-0138 wdrożył rygorystyczny audyt przejścia narracyjnego 01→43 oparty w 100% na symulacji zachowania gracza (player verbs):**
1. **Fizyczna lokomocja:** Lena porusza się za pomocą `_walk_to` z wykorzystaniem `move_and_slide()` oraz mechanizmu pokonywania krawężników `try_curb_step()`.
2. **Sekwencyjna interakcja diegetyczna:** Lena podchodzi do rekwizytów rezonansu pamięci (`MemoryResonancePoint`) w porządku geometrycznym (z lewej do prawej) i wchodzi w interakcję za pomocą czasownika `interact`.
3. **Przewijanie dialogu teletypowego:** Tekst na `CRTDialogueBox` jest postępem czytanym i przewijanym za pomocą nowo wyeksponowanego publicznego API `advance_dialogue()`.
4. **Naturalne odryglowanie śluz:** Śluza wyjściowa `AirlockZone` otwiera się i rejestruje sygnał `level_completed` **wyłącznie** w wyniku zrealizowanych akcji wewnątrz sceny (brak jakichkolwiek manipulacji flagami logicznymi z zewnątrz).

---

## 2. Kanoniczna deklaracja `ReturnZone` (D-142)

Audyt wykazał, że o ile stacje 03–05 posiadały węzły `ReturnZone` zadeklarowane w plikach `.tscn`, o tyle pozostałe stacje (02 oraz 06–43) polegały na dynamicznym tworzeniu instancji.

W ramach PKG-0138 wprowadzono statyczną, ujednoliconą deklarację węzła `ReturnZone` do wszystkich 42 plików scen `.tscn`:
- **Węzeł:** `[node name="ReturnZone" type="Area2D" parent="."]`
- **Pozycja:** `position = Vector2(15, 238)`
- **Skrypt:** `ExtResource("..._returnzone")` wskazujący na `res://scripts/environment/return_zone.gd`
- **Kształt:** `shape = SubResource("Rectangle_airlock")` (współdzielony z `AirlockZone`)
- **Warstwy:** `collision_layer = 0`, `collision_mask = 1`

Każda stacja w kampanii posiada teraz w pełni zadeklarowaną, statyczną strefę powrotu po lewej stronie, która po wejściu Leny emituje sygnał `previous_level_requested`.

---

## 3. Wyniki audytu przejścia 01→43 (`pkg_0138_playthrough_audit.gd`)

Przeprowadzono pełny audyt wszystkich 45 scen kampanii.

| Stacja | Sekwencja / Akt | Guidance | Zarejestrowane Beaty | Airlock (Forward) | ReturnZone (Backtrack) | Status |
|---|---|---|---|---|---|---|
| station_01 | Sterownia IKP | OK | 3 | OK | OK (Start) | PASS |
| station_02 | Komora Pomiarowa | OK | 2 | OK | OK | PASS |
| station_03 | Puste Laboratorium | OK | 2 | OK | OK | PASS |
| station_04 | Recepcja IKP | OK | 2 | OK | OK | PASS |
| station_05 | Rówień Nocą | OK | 1 | OK | OK | PASS |
| station_06 | Linia Zastępcza | OK | 3 | OK | OK | PASS |
| station_07 | Klatka Osiedle Tarasowe | OK | 3 | OK | OK | PASS |
| station_08 | Korytarz Mieszkań | OK | 3 | OK | OK | PASS |
| station_09 | Mieszkanie 14 — Przedsionek | OK | 3 | OK | OK | PASS |
| station_10 | Mieszkanie 14 — Pokój Pracy | OK | 3 | OK | OK | PASS |
| station_11 | Mieszkanie 14 — Sypialnia | OK | 3 | OK | OK | PASS |
| station_12 | Balkon i Podwórze | OK | 3 | OK | OK | PASS |
| station_13 | Archiwum Domowe | OK | 3 | OK | OK | PASS |
| station_14 | Sieć Podziemna — Wejście | OK | 3 | OK | OK | PASS |
| station_15 | Magistrala Techniczna | OK | 3 | OK | OK | PASS |
| station_16 | Punkt Kontrolny UCP | OK | 3 | OK | OK | PASS |
| station_17 | Śluza Wentylacyjna | OK | 2 | OK | OK | PASS |
| station_18 | Korytarz Archiwalny | OK | 3 | OK | OK | PASS |
| station_19 | Centrala Telefoniczna | OK | 3 | OK | OK | PASS |
| station_20 | Gabinet Marty | OK | 2 | OK | OK | PASS |
| station_21 | Pokój Syntezy Dowodów | OK | 3 | OK | OK | PASS |
| station_22 | Korytarz Prób | OK | 2 | OK | OK | PASS |
| station_23 | Stacja Przełączania | OK | 2 | OK | OK | PASS |
| station_24 | Punkt Obserwacji Linii 4 | OK | 1 | OK | OK | PASS |
| station_25 | Rampa Załadunkowa | OK | 1 | OK | OK | PASS |
| station_26 | Kanał Sygnalizacyjny | OK | 1 | OK | OK | PASS |
| station_27 | Posterunek Odgałęzienia | OK | 1 | OK | OK | PASS |
| station_28 | Skład Techniczny | OK | 1 | OK | OK | PASS |
| station_29 | Odcinek Zawaliskowy | OK | 1 | OK | OK | PASS |
| station_30 | Rozdzielnia Główna | OK | 1 | OK | OK | PASS |
| station_31 | Magazyn 11 Krzeseł | OK | 1 | OK | OK | PASS |
| station_32 | Galeria Tafli Szklanych | OK | 1 | OK | OK | PASS |
| station_33 | Szyb Pionowy | OK | 1 | OK | OK | PASS |
| station_34 | Reaktor Izotopowy | OK | 1 | OK | OK | PASS |
| station_35 | Zbiornik Chłodzący | OK | 1 | OK | OK | PASS |
| station_36 | Śluza Irygacyjna | OK | 1 | OK | OK | PASS |
| station_37 | Sala Nadajnika | OK | 1 | OK | OK | PASS |
| station_38 | Komora Ratunkowa | OK | 1 | OK | OK | PASS |
| station_39 | Węzeł Ostateczny | OK | 1 | OK | OK | PASS |
| station_40 | Próg Decyzji | OK | 1 | OK | OK | PASS |
| station_41 | Pulpit Wyboru Metody | OK | 1 | OK | OK | PASS |
| station_42a | Finał: Powrót | OK | 1 | OK | OK | PASS |
| station_42b | Finał: Uzgodnienie | OK | 1 | OK | OK | PASS |
| station_42c | Finał: Świadectwo | OK | 1 | OK | OK | PASS |
| station_43 | Epilog / Dworzec Główny | OK | 1 | OK | OK | PASS |

**Podsumowanie audytu:** 45 scen zbadanych, **0 blockerów**, 100% zgodności ze specyfikacją.

---

## 4. Weryfikacja serwisu prowadzenia narracyjnego (`NarrativeGuidanceService`)

- **Rejestracja beatów:** Wszystkie sceny rejestrują aktywne beaty prowadzenia (od 1 do 3 poziomów L1..L3).
- **Zarządzanie utknięciem (Stall Timers):**
  - Beaty L2 (kontekstowe) aktywują się po 20 sekundach bezczynności.
  - Beaty L3 (kierunkowe) aktywują się po 45 sekundach bezczynności.
  - Prawdziwy postęp w scenie natychmiast resetuje `time_since_progress = 0.0` i wygasza aktywną myśl.
- **Zamykanie hipotez:** `close_hypothesis(hyp_id)` wygasza przypisane do niej omylne myśli i blokuje ich powtórne wywołanie.

---

## 5. Odporność na soft-locki i traversability

- **Szuflada na Stacji 13:** Otwarta szuflada posiada wysokość progu 16 px (D-140) i nie blokuje Leny w drodze do śluzy ani w drodze powrotnej do `ReturnZone`.
- **Schody na Stacjach 07 i 09:** Realny bieg schodów z podstopnicami ≤ 18 px umożliwia swobodne wchodzenie i schodzenie z obu stron (D-138).
- **Kotwica na Stacji 38:** Grodź ratunkowa stabilizuje przestrzeń i pozwala na swobodne przejście do śluzy decyzyjnej.
