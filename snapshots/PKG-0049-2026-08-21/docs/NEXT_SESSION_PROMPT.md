# CEL SESJI: PKG-0050 — Implementacja Przestrzeni 32 (Ślad w szkle / Korytarz luster)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0049` (Przestrzeń 31: Magazyn Dowodów / Jedenaście Krzeseł)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-063)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 32**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_glass_condensation_wipe_sound()`: wilgotne tarcie palca o zaparowane szkło;
     - `create_glass_stress_ring_sound()`: kryształowy, wysoki rezonans naprężeń szklanych tafli;
     - `create_fire_memory_rumble_sound()`: stłumiony pogłos pożaru i syren uwięzionych w popękanej tafli;
     - `create_consensus_stamp_reverberation_sound()`: chłodny, sterylny rezonans pieczęci UCP;
     - `create_station32_hatch_unseal_sound()`: zwolnienie rygla i odpieczętowanie włazu szybu technicznego.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 147..151:
     - `STEAMED_GLASS_PANE_A` (147): zaparowana tafla szkła z obrazem pustej ulicy i zatartego tramwaju;
     - `CRACKED_GLASS_PANE_B` (148): popękana tafla szkła z widmem pożaru i syren ratunkowych;
     - `POLISHED_GLASS_PANE_C` (149): sterylnie wypolerowana tafla ze znakiem consensusu UCP;
     - `CONDENSATION_TRACE_ETCHER` (150): interaktywny Ślad przeciągnięty palcem po szkle;
     - `STATION_32_EXIT` (151): stalowy właz rewizyjny do Przestrzeni 33 (Szyb Techniczny / Maszynownia).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów z zachowaniem palety i stylu pixel-art.

3. **Scena i kontroler poziomu `Station32`**:
   - Utworzenie `scripts/levels/station_32.gd` oraz `scenes/levels/station_32.tscn` (640x360).
   - Odtworzenie scenografii Korytarza Luster: szklane tafle, jarzące się krawędzie, refleksy i właz szybu.
   - Wdrożenie pełnej sekwencji dialogowej Scene 32 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_32()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_32.png` i `reports/station_32_glass.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-064) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0050`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0050`
