# CEL SESJI: PKG-0053 — Implementacja Przestrzeni 35 (Sektor Filtracji / Baseny Sedacyjne)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0052` (Przestrzeń 34: Maszynownia Główna / Rdzeń Wymiany)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-066)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 35**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_sedation_liquid_slosh_sound()`: gęsty, lepki chlupot cieczy sedacyjnej z pękającymi bąblami gazu;
     - `create_sludge_valve_creak_sound()`: zgrzyt żeliwnego koła zaworu spustowego i szum tłoczenia osadu;
     - `create_chemical_bubbler_sound()`: perliste bulgotanie odczynnika chemicznego w szklanym próbniku;
     - `create_sedation_saturation_alarm_sound()`: chłodny, stłumiony ton nasycenia mieszkańców sedacją;
     - `create_station35_drain_sluice_sound()`: gwałtowny odpływ cieczy i uniesienie zasuwy śluzy odpływowej.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 162..166:
     - `SEDATION_BASIN_POOL` (162): wielki basen sedacyjny z fosforyzującą cieczą i widmami odrzuconych wspomnień;
     - `SLUDGE_DRAIN_VALVE_WHEEL` (163): koło zaworu spustowego osadu poznawczego z rurociągiem tłocznym;
     - `CHEMICAL_SEDATION_SAMPLER` (164): szklany próbnik chemiczny z wirującym odczynnikiem UCP;
     - `JAKUB_SEDATION_MONITOR` (165): terminal monitorujący poziom nasycenia osiedla substancją sedacyjną;
     - `STATION_35_EXIT` (166): śluza odpływowa do Przestrzeni 36 (Kanał Odpływowy / Zimny Ściek).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów w spójnej palecie barwnej.

3. **Scena i kontroler poziomu `Station35`**:
   - Utworzenie `scripts/levels/station_35.gd` oraz `scenes/levels/station_35.tscn` (640x360).
   - Odtworzenie surowej scenografii Sektora Filtracji: betonowe baseny, pomosty nad cieczą, parujące rurociągi.
   - Wdrożenie pełnej sekwencji dialogowej Scene 35 / D-14 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_35()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_35.png` i `reports/station_35_sedation.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-067) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0053`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0053`
