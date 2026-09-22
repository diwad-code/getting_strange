# CEL SESJI: PKG-0058 — Implementacja Przestrzeni 40 (Ostatnia propozycja / Otwarcie Aktu IV: Sygnał powrotu)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0057` (Przestrzeń 39: Komora Referencyjna / Finał Aktu III: Podstruktura)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-071)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 40**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_wierzbicka_personal_terminal_sound()`: chłodny, spokojny ton autoryzacji dyrektorskiej UCP (480/720/1080 Hz);
     - `create_marta_witness_presence_sound()`: intymny rezonans relacyjny Marty Kurek (392/587 Hz + 1174 Hz);
     - `create_szymon_transmission_feed_sound()`: analogowy szum przekazu radiowo-wizyjnego Szymona Bery (260/520 Hz + 1900 Hz);
     - `create_cost_dossier_matrix_sound()`: mechaniczne otwarcie potrójnej matrycy kosztów operacyjnych UCP (650 Hz + 220 Hz);
     - `create_station40_final_chamber_gate_sound()`: odryglowanie wrót do Przestrzeni 41 (Wybór operacyjny) (95..24 Hz + 1120 Hz).

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 187..191:
     - `WIERZBICKA_PERSONAL_TERMINAL` (187): pulpit osobisty dr Heleny Wierzbickiej bez zespołu UCP;
     - `MARTA_WITNESS_STATION` (188): postać Marty Kurek odmawiającej decydowania za którąkolwiek Lenę;
     - `SZYMON_TRANSMISSION_MONITOR` (189): ekran transmisji Szymona Bery z zachowanym rysunkiem zaginionej córki;
     - `OPERATION_COST_DOSSIER_MATRIX` (190): panel bilansu kosztów trzech operacji (Powrót, Uzgodnienie, Świadectwo);
     - `STATION_40_EXIT` (191): wrota prowadzące do Przestrzeni 41 (Wybór operacyjny).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów w spójnej palecie barwnej.

3. **Scena i kontroler poziomu `Station40`**:
   - Utworzenie `scripts/levels/station_40.gd` oraz `scenes/levels/station_40.tscn` (640x360).
   - Odtworzenie scenografii Sali Negocjacyjnej UCP na Poziomie 0 (powrót na powierzchnię): surowe modernistyczne filary, przeszklone lica, schematy trzech operacji.
   - Wdrożenie pełnej sekwencji narracyjno-dialogowej Scene 40 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md`.
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_40()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_40.png` i `reports/station_40_proposal.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-072) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0058`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0058`
