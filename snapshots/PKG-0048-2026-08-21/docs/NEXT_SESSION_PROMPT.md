# CEL SESJI: PKG-0049 — Implementacja Przestrzeni 31 (Magazyn dowodów rzeczowych / Jedenaście krzeseł)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0048` (Przestrzeń 30: Sektor Zasilania / Maszyna Świadków)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-062)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 31**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_eleven_chairs_whisper_sound()`: wielogłosowy pogłos szeptu 11 wymazanych tożsamości;
     - `create_wierzbicka_recitation_chime_sound()`: chłodny, ustrukturyzowany ton recytacji imion przez dr Wierzbicką;
     - `create_twelfth_chair_resonance_sound()`: melancholijny akord 12. krzesła i ocalenia Jakuba;
     - `create_ledger_page_turn_sound()`: szelest papieru archiwalnego i uderzenie suchej pieczęci UCP;
     - `create_station31_pressure_hiss_sound()`: dekompresja i syk śluzy ciśnieniowej ku Korytarzowi Luster.

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 142..146:
     - `ELEVEN_CHAIRS_ARCHIVE_ROW` (142): rząd 11 krzeseł z ułożonymi rzeczami osobistymi (płaszcze, teczki, torebki, zegarki);
     - `WIERZBICKA_REMOTE_HOLOTERMINAL` (143): holoterminal zdalny z recytacją imion 11 ofiar przez dr Wierzbicką;
     - `JAKUB_TWELFTH_CHAIR` (144): dwunaste krzesło z legitymacją Jakuba (dowód na jedność ocalenia i przesunięcia);
     - `VARIANT_CHOICE_LEDGER` (145): księga dyspozycji wariantów z wpisem »WYBRANO WARIANT, NIE CZŁOWIEKA«;
     - `STATION_31_EXIT` (146): ciśnieniowa śluza przeszklona do Przestrzeni 32 (Ślad w szkle / Korytarz Luster).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów z zachowaniem palety i stylu pixel-art.

3. **Scena i kontroler poziomu `Station31`**:
   - Utworzenie `scripts/levels/station_31.gd` oraz `scenes/levels/station_31.tscn` (640x360).
   - Odtworzenie scenografii Magazynu Dowodów: betonowe sklepienie archiwum, rząd 11 drewnianych krzeseł z rekwizytami, terminal transmisyjny, 12. krzesło i śluza ciśnieniowa.
   - Wdrożenie pełnej sekwencji dialogowej Scene 31 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_31()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_31.png` i `reports/station_31_chairs.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-063) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0049`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0049`
