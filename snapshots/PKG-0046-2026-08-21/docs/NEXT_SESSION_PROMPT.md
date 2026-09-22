# CEL SESJI: PKG-0047 — Implementacja Przestrzeni 29 (Peron trzynasty / Otwarcie Aktu III: Podstruktura)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0046` (Przestrzeń 28: Tramwaj bez pasażerów / Finał Aktu II: Korekta)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-060)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 29**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_platform13_drip_echo_sound()`: pogłos kapiącej wody w opuszczonym tunelu stacyjnym;
     - `create_flickering_neon_buzz_sound()`: brzęczenie transformatora i iskry neonu stacyjnego;
     - `create_deep_well_drone_sound()`: infradźwiękowy pomruk głębokiego szybu wentylacyjnego Podstruktury;
     - `create_jakub_torch_click_sound()`: kliknięcie włącznika roboczej latarki akumulatorowej Jakuba;
     - `create_station29_grate_creak_sound()`: metaliczny zgrzyt rdzewiejącej kraty rewizyjnej.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 132..136:
     - `ABANDONED_PLATFORM_TRACKS` (132): zardzewiałe szyny i kozioł oporowy Linii 4;
     - `FLICKERING_NEON_SIGN` (133): mrugający neon stacyjny "PERON 13" z przewodami wysokiego napięcia;
     - `DEEP_SUBSTRUCTURE_WELL` (134): szyb wentylacyjny schodzący w głąb właściwej Podstruktury;
     - `JAKUB_TORCH_BEACON` (135): Jakub z roboczą latarką oświetlający wejście i snop światła;
     - `STATION_29_EXIT` (136): brama rewizyjna prowadząca do Przestrzeni 30 (Sektor Zasilania).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów z zachowaniem palety i stylu pixel-art.

3. **Scena i kontroler poziomu `Station29`**:
   - Utworzenie `scripts/levels/station_29.gd` oraz `scenes/levels/station_29.tscn` (640x360).
   - Odtworzenie scenografii Peronu trzynastego: wilgotny opuszczony peron techniczny, zardzewiałe tory, popękane kafle ścienne, mrugający neon, szyb wentylacyjny i brama rewizyjna.
   - Wdrożenie pełnej sekwencji dialogowej Scene 29 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md` (otwarcie Aktu III: Podstruktura).
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_29()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_29.png` i `reports/station_29_platform.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-061) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0047`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0047`
