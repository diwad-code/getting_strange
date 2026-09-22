# CEL SESJI: PKG-0051 — Implementacja Przestrzeni 33 (Szyb Techniczny / Drabina do Maszynowni Głównej)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0050` (Przestrzeń 32: Ślad w szkle / Korytarz Luster)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-064)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 33**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_ladder_rung_climb_sound()`: metaliczny stuk buta i dłoni o szczebel drabiny serwisowej;
     - `create_depth_pressure_creak_sound()`: głęboki zgrzyt konstrukcji szybu pod ciśnieniem sprzeczności;
     - `create_cable_trunk_pulse_sound()`: elektromagnetyczny pulsujący szum magistrali kablowej;
     - `create_shaft_work_light_hum_sound()`: przydźwięk i brzęczenie dławika przemysłowej lampy szybowej;
     - `create_station33_lower_hatch_sound()`: potężne uderzenie rygla i odpieczętowanie dolnego włazu maszynowni.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 152..156:
     - `VERTICAL_LADDER_ARRAY` (152): szczeble pionowej drabiny stalowej z klatką bezpieczeństwa;
     - `DEPTH_PRESSURE_GAUGE` (153): mechaniczny manometr głębokości i ciśnienia (-40 m, 4.2 bar);
     - `MEMORY_BUS_CABLE_TRUNK` (154): gruba wiązka kabli magistrali pulsujących światłem;
     - `SHAFT_WORK_LIGHT_BEACON` (155): przemysłowa lampa ostrzegawcza oświetlająca czeluść szybu;
     - `STATION_33_EXIT` (156): dolny właz dekompresyjny do Przestrzeni 34 (Maszynownia Główna / Rdzeń Wymiany).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów z zachowaniem spójnej palety i stylu pixel-art.

3. **Scena i kontroler poziomu `Station33`**:
   - Utworzenie `scripts/levels/station_33.gd` oraz `scenes/levels/station_33.tscn` (640x360).
   - Odtworzenie scenografii Szybu Technicznego: pionowe rury, stalowe pierścienie obudowy, zwisające kable i dolny właz.
   - Wdrożenie pełnej sekwencji dialogowej Scene 33 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_33()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_33.png` i `reports/station_33_shaft.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-065) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0051`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0051`
