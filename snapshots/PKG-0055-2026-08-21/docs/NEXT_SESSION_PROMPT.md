# CEL SESJI: PKG-0056 — Implementacja Przestrzeni 38 (Sektor Pamięci Wypadku / Człowiek zamiast dowodu)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0055` (Przestrzeń 37: Komora Sygnałowa / Węzeł Nadawczy)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-069)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 38**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_accident_field_distortion_sound()`: dysonans grawitacyjno-magnetyczny pola wypadku Linii 4 (70..28 Hz + 1350 Hz);
     - `create_jakub_destabilization_hum_sound()`: drżenie formantu głosu i dekompozycja fali postaci Jakuba (340/510 Hz modulated 7 Hz);
     - `create_rescue_tether_chime_sound()`: czysty ton ratunkowy kotwicy międzyludzkiej (587/880 Hz);
     - `create_coordinate_calculator_click_sound()`: mechaniczne odrzucenie chłodnej kalkulacji współrzędnych powrotu (720 Hz + 180 Hz);
     - `create_station38_reference_vault_door_sound()`: potężne odryglowanie wrót Komory Referencyjnej (Przestrzeń 39) (110..32 Hz + 860 Hz).

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 177..181:
     - `ACCIDENT_SIMULATION_FIELD` (177): projekcja trójwymiarowego lewitującego widma wykolejonego tramwaju Linii 4 z falami uderzeniowymi;
     - `DESTABILIZING_JAKUB_SHADOW` (178): sylwetka Jakuba tracąca stabilność materialną w pasmach cynobrowej fali;
     - `RESCUE_TETHER_ANCHOR` (179): mechanizm podania dłoni i ustabilizowania brata jako żywego człowieka;
     - `RETURN_COORDINATE_CALCULATOR` (180): pulpit analityczny UCP oferujący instrumentalne użycie Jakuba jako wektora powrotu;
     - `STATION_38_EXIT` (181): ciężkie rotacyjne wrota do Przestrzeni 39 (Komora Referencyjna).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów w spójnej palecie barwnej.

3. **Scena i kontroler poziomu `Station38`**:
   - Utworzenie `scripts/levels/station_38.gd` oraz `scenes/levels/station_38.tscn` (640x360).
   - Odtworzenie scenografii Sektora Pamięci Wypadku: zakrzywione filary czasoprzestrzenne, cynobrowo-cyjanowe szczeliny pamięci, rdzeń symulacyjny.
   - Wdrożenie pełnej sekwencji narracyjno-dialogowej Scene 38 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md` (wybór ratunku człowieka zamiast dowodu powrotu).
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_38()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_38.png` i `reports/station_38_rescue.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-070) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0056`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0056`
