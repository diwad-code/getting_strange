# CEL SESJI: PKG-0054 — Implementacja Przestrzeni 36 (Kanał Odpływowy / Zimny Ściek)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0053` (Przestrzeń 35: Sektor Filtracji / Baseny Sedacyjne)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-067)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 36**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_storm_drain_torrent_sound()`: potężny szum i plusk rwącego nurtu w kanale burzowym;
     - `create_drain_weir_creak_sound()`: zgrzyt i skrzyp zardzewiałej stalowej kraty jazu spiętrzającego;
     - `create_acid_ladder_clank_sound()`: metaliczny stukot butów o klamry drabinki ze stali kwasoodpornej;
     - `create_groundwater_leak_alarm_sound()`: pulsacyjny ton skażenia wód gruntowych substancją sedacyjną;
     - `create_station36_storm_gate_sound()`: dekompresyjny ryk i podniesienie bramy przeciwsztormowej.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 167..171:
     - `STORM_DRAIN_WEIR` (167): żelazny jaz burzowy z kratą zatrzymującą odpady i spiętrzoną wodą;
     - `SEDATIVE_SLUDGE_CURRENT` (168): rwący nurt spłukanego osadu z fosforyzującą smugą i bąblami;
     - `ACID_RESISTANT_CATWALK_LADDER` (169): kładka i drabinka pomostowa ze stali kwasoodpornej nad nurtem;
     - `CONTAMINATION_SAMPLING_TAP` (170): kurek probierczy ze wskaźnikiem skażenia wód gruntowych;
     - `STATION_36_EXIT` (171): brama przeciwsztormowa prowadząca do Przestrzeni 37 (Komora Sygnałowa).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów w spójnej palecie barwnej.

3. **Scena i kontroler poziomu `Station36`**:
   - Utworzenie `scripts/levels/station_36.gd` oraz `scenes/levels/station_36.tscn` (640x360).
   - Odtworzenie surowej scenografii Zimnego Ścieku: betonowe sklepienie łukowe, rwący potok ściekowy, zardzewiałe jazy.
   - Wdrożenie pełnej sekwencji narracyjno-dialogowej Scene 36 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_36()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_36.png` i `reports/station_36_drain.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-068) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0054`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0054`
