# CEL SESJI: PKG-0052 — Implementacja Przestrzeni 34 (Maszynownia Główna / Rdzeń Wymiany)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0051` (Przestrzeń 33: Szyb Techniczny / Drabina do Maszynowni Głównej)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-065)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 34**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_core_reactor_pulse_sound()`: potężne niskie dudnienie i pulsacja hydrauliczna rdzenia wymiany;
     - `create_biography_slider_drag_sound()`: mechaniczny opór i tarcie analogowych suwaków alokacji biografii;
     - `create_core_thermal_alarm_sound()`: modulowany sygnał alarmu przeciążenia termicznego;
     - `create_jakub_diagnostic_probe_sound()`: cyfrowy rezonans i pisk próbnika diagnostycznego Jakuba;
     - `create_station34_filtration_gate_sound()`: potężne rozszczelnienie i otwarcie bramy filtracyjnej.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 157..161:
     - `MAIN_EXCHANGE_CORE_REACTOR` (157): centralny reaktor wymiany z tłokami i wirującymi dyskami pamięci;
     - `BIOGRAPHY_ALLOCATION_DESK` (158): pulpit sterowania z suwakami dystrybucji pamięci i lampami zgodności;
     - `THERMAL_OVERLOAD_INDICATOR` (159): analogowy wskaźnik przeciążenia termicznego rdzenia (8.9 bar);
     - `JAKUB_CORE_DIAGNOSTIC_PORT` (160): próbnik diagnostyczny Jakuba wpięty w szynę danych rdzenia;
     - `STATION_34_EXIT` (161): brama filtracyjna do Przestrzeni 35 (Sektor Filtracji / Baseny Sedacyjne).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów z zachowaniem spójnej palety i stylu pixel-art.

3. **Scena i kontroler poziomu `Station34`**:
   - Utworzenie `scripts/levels/station_34.gd` oraz `scenes/levels/station_34.tscn` (640x360).
   - Odtworzenie monumentalnej scenografii Maszynowni Głównej: potężny reaktor, pomosty serwisowe, pulsujące tłoki.
   - Wdrożenie pełnej sekwencji dialogowej Scene 34 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_34()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_34.png` i `reports/station_34_core.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-066) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0052`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0052`
