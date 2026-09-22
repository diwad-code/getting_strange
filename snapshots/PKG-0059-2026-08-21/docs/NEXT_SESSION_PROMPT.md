# CEL SESJI: PKG-0060 — Sceny Finałowe 42A, 42B, 42C oraz Scena 43: Napisy i epilog systemowy (Finał Aktu IV)

Wdrożenie Scen Finałowych (42A Powrót — Własny pokój, 42B Uzgodnienie — Miejsce po niej, 42C Świadectwo — Dwie prawdy) oraz Sceny 43 (Napisy i epilog systemowy) z `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md` (D-15A, D-15B, D-15C) oraz `VISUAL_DESIGN.md`.

W PKG-0060 gracz przechodzi z Komory Wyboru Operacyjnego (Przestrzeń 41) do wybranego wariantu zakończenia:
1. **Scena 42A (Powrót — Własny pokój):** Przebudzenie przy aparaturze w IKP o 21:45, dwa kubki na stole, fotografia Jakuba z dorosłym cieniem, telefon do Marty Kurek i zaciemnienie przed pierwszym słowem.
2. **Scena 42B (Uzgodnienie — Miejsce po niej):** Mieszkanie 14, rozmowa z Martą Kurek w progu (nie pochodząca od lokalnej Leny), odmowa lub wpuszczenie na kawę, gest obrączki i dociśnięcia paznokcia do szwu palca.
3. **Scena 42C (Świadectwo — Dwie prawdy):** Publiczne węzły, rozproszenie Śladu w sieci miejskiej, poranny tramwaj stający przed dwoma nakładającymi się torami, motornicza zapisująca wybór.
4. **Scena 43 (Napisy i epilog systemowy):** Napisy końcowe na elementach architektury miasta oraz obojętny komunikat administracyjny (Linia 4 zamknięta / Karta kontroli pęknięcia / Tablica dwóch kolejności UCP).

## SRODOWISKO I BASELINE

- Projekt Godot: 4.7.stable na Windows (pwsh 7).
- Brak repozytorium git (D-016).
- Stan bazowy: PKG-0059 (Przestrzenie 01..41 w pełni zaimplementowane i przetestowane).
- Baseline: `pwsh -NoProfile -File .\tools\verify.ps1` musi przechodzić na zielono przed rozpoczęciem edycji.

## KRYTERIA AKCEPTACJI

1. **Synteza Proceduralnego Audio w `scripts/audio/procedural_audio.gd`**:
   - `create_epilogue_radio_announcement_sound()`: analogowy komunikat radiowy o Linii 4 (580/1160 Hz + trzaski);
   - `create_epilogue_cup_clink_sound()`: cichy stukot dwóch kubków laboratoryjnych o stół (1450 Hz + 2900 Hz);
   - `create_epilogue_tram_switch_latch_sound()`: mechaniczny dźwięk przestawienia zwrotnicy dwóch torów przez motorniczą (340 Hz + 1600 Hz);
   - `create_epilogue_credits_drone_sound()`: minimalistyczny dron napisów końcowych (55/110/220 Hz);
   - `create_epilogue_final_carrier_sound()`: nośna wygaszenia ekranu do czerni (440 Hz -> 0 Hz).

2. **Rozszerzenie `scripts/interactables/memory_resonance_point.gd`**:
   - Dodać typy rekwizytów do `PropType` (197..202):
     - `EPILOGUE_RETURN_CUPS = 197` (Dwa kubki laboratoryjne i telefon o 21:45);
     - `EPILOGUE_MARTA_DOORSTEP = 198` (Próg mieszkania 14 i klucz na progu);
     - `EPILOGUE_TRAM_DUAL_TRACKS = 199` (Dwa nakładające się tory porannego tramwaju);
     - `EPILOGUE_ADMIN_NOTICE_BOARD = 200` (Tablica administracyjna / Karta zgłoszenia UCP);
     - `EPILOGUE_CREDITS_ROLL = 201` (Napisy końcowe na elementach architektury);
     - `EPILOGUE_FINAL_BLACKOUT = 202` (Końcowe wygaszenie do czerni).
   - Zaimplementować procedury `_draw_*` dla epilogów w palecie zgodnej z `VISUAL_DESIGN.md`.

3. **Utworzenie scen finałowych i kontrolerów**:
   - `scripts/levels/station_42a.gd` i `scenes/levels/station_42a.tscn` (Powrót);
   - `scripts/levels/station_42b.gd` i `scenes/levels/station_42b.tscn` (Uzgodnienie);
   - `scripts/levels/station_42c.gd` i `scenes/levels/station_42c.tscn` (Świadectwo);
   - `scripts/levels/station_43.gd` i `scenes/levels/station_43.tscn` (Napisy i Epilog);
   - Integracja z przejściami między 41 -> 42A/B/C -> 43.

4. **Weryfikacja i Testy**:
   - Dodać testy w `tests/smoke_test.gd` (`_test_station_42a()`, `_test_station_42b()`, `_test_station_42c()`, `_test_station_43()` oraz testy audio);
   - Dodać zrzuty w `tools/capture_preview.gd` (`reports/station_42a.png`, `reports/station_42b.png`, `reports/station_42c.png`, `reports/station_43.png`);
   - Uruchomić `pwsh -NoProfile -File .\tools\verify.ps1` i `pwsh -NoProfile -File .\tools\capture.ps1`;
   - Zaktualizować `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` oraz `docs/ROADMAP.md`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po zaliczeniu wszystkich weryfikacji wykonać zamrożenie:
```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0060
```
