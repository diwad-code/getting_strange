# CEL SESJI: PKG-0048 — Implementacja Przestrzeni 30 (Sektor zasilania / Główna rozdzielnia)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0047` (Przestrzeń 29: Peron trzynasty / Otwarcie Aktu III: Podstruktura)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-061)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 30**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_transformer_oil_hum_sound()`: głębokie buczenie transformatorów wysokiego napięcia (50/100 Hz);
     - `create_knife_switch_throw_sound()`: trzask trójfazowego bezpiecznika nożowego i łuk elektryczny;
     - `create_high_voltage_spark_sound()`: impuls wyładowania koronowego na izolatorach ceramicznych;
     - `create_power_grid_relay_sound()`: sekwencyjny rytm przekaźników elektromagnetycznych;
     - `create_station30_door_release_sound()`: dejonizacja i zwolnienie rygli bramy ekranowanej.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 137..141:
     - `MAIN_POWER_DISTRIBUTION_BOARD` (137): główna tablica rozdzielcza z miedzianymi szynami i woltomierzem;
     - `HIGH_VOLTAGE_TRANSFORMER_BANK` (138): bateria transformatorów olejowych z buczącym rdzeniem;
     - `SECTION_BREAKER_LEVER` (139): trójfazowy bezpiecznik nożowy odcinający sekcję administracyjną UCP;
     - `GRID_SCHEMATIC_DISPLAY` (140): podświetlany schemat zasilania z trasą do Serwerowni Rejestru;
     - `STATION_30_EXIT` (141): brama ekranowana magnetycznie do Przestrzeni 31 (Magazyn dowodów rzeczowych).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów z zachowaniem palety i stylu pixel-art.

3. **Scena i kontroler poziomu `Station30`**:
   - Utworzenie `scripts/levels/station_30.gd` oraz `scenes/levels/station_30.tscn` (640x360).
   - Odtworzenie scenografii Sektora Zasilania: wielka rozdzielnia wysokiego napięcia, miedziane szyny prądowe, transformatory olejowe, ceramiczne izolatory i brama ekranowana.
   - Wdrożenie pełnej sekwencji dialogowej Scene 30 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_30()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_30.png` i `reports/station_30_power.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-062) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0048`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0048`
