# CEL SESJI: PKG-0057 — Implementacja Przestrzeni 39 (Komora Referencyjna / Finał Aktu III: Podstruktura)

## SRODOWISKO I BASELINE

- Katalog roboczy: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma: Windows, PowerShell 7 (pwsh)
- Brak gita (D-016), stan wylacznie na dysku
- Poprzedni zamkniety pakiet: `PKG-0056` (Przestrzeń 38: Sektor Pamięci Wypadku / Człowiek zamiast dowodu)
- Aktywny stan: `docs/CURRENT_STATE.md`
- Historia projektu: `docs/SESSION_LOG.md`
- Decyzje architektoniczne: `docs/DECISION_LOG.md` (D-001..D-070)

## KRYTERIA AKCEPTACJI

1. **Proceduralne audio dla Przestrzeni 39**:
   - Rozbudowa `scripts/audio/procedural_audio.gd` o 5 dedykowanych metod syntezy audio:
     - `create_reference_core_harmonics_sound()`: głęboka harmoniczna triada kwantowa serca Podstruktury (110/220/440 Hz + 1760 Hz shimmer);
     - `create_branch_configuration_a_sound()`: kryształowy ton wektora Powrotu / Własny Pokój (523/1046 Hz + 2093 Hz);
     - `create_branch_configuration_b_sound()`: ciepły mosiężny akord Uzgodnienia / Miejsce po niej (440/659/880 Hz);
     - `create_branch_configuration_c_sound()`: polifoniczny rezonans Świadectwa / Dwie Prawdy (330/495/660/990 Hz);
     - `create_station39_act4_gateway_sound()`: pęknięcie stabilizatora pamięci i otwarcie Aktu IV (85..20 Hz + 1420 Hz pulse).

2. **Rekwizyty i punkty rezonansu w `MemoryResonancePoint`**:
   - Rozszerzenie typu `PropType` w `scripts/interactables/memory_resonance_point.gd` o identyfikatory 182..186:
     - `CENTRAL_REFERENCE_CORE_MONOLITH` (182): monumentalny wieloboczny kryształ referencyjny serca Podstruktury z potrójną pętlą harmoniczną;
     - `BRANCH_CONFIG_RETURN_A` (183): pulpit konfiguracji A (Powrót / Własny Pokój — adres wyjściowy do laboratorium Leny);
     - `BRANCH_CONFIG_RECONCILIATION_B` (184): pulpit konfiguracji B (Uzgodnienie / Miejsce po niej — lokalny wzorzec biograficzny z Martą);
     - `BRANCH_CONFIG_TESTIMONY_C` (185): pulpit konfiguracji C (Świadectwo / Dwie Prawdy — publiczna sieć sprzecznych świadków);
     - `STATION_39_EXIT` (186): centralna śluza wznosząca ku Aktowi IV (Sygnał Powrotu / Poziom 0).
   - Implementacja procedur rysunkowych `_draw_*` dla wszystkich nowych typów w spójnej palecie barwnej.

3. **Scena i kontroler poziomu `Station39`**:
   - Utworzenie `scripts/levels/station_39.gd` oraz `scenes/levels/station_39.tscn` (640x360).
   - Odtworzenie majestatycznej scenografii Komory Referencyjnej na poziomie -40 m: potężne filary nośne Podstruktury, pierścienie koncentryczne energii, potrójne terminale wariantowe.
   - Wdrożenie pełnej sekwencji narracyjno-dialogowej Scene 39 z `FULL_STORY.md` i `DIALOGUE_SCRIPT.md` (przekazanie kontroli przez Ślad: „Jeśli wybiorę ja, znowu zrobię z ciebie koszt.”).
   - Obsługa strefy `AirlockZone` przy wyjściu z poziomu z emisją sygnału `level_completed`.

4. **Weryfikacja testowa i wizualna**:
   - Rozbudowa `tests/smoke_test.gd` o testy audio oraz procedurę `_test_station_39()`.
   - Rozbudowa `tools/capture_preview.gd` o zrzuty `reports/station_39.png` i `reports/station_39_triad.png`.
   - Wygenerowanie podglądów przez `tools/capture.ps1` i inspekcja wizualna.
   - Pełne przejście `pwsh -NoProfile -File .\tools\verify.ps1`.

5. **Aktualizacja dokumentacji i zamrożenie**:
   - Aktualizacja `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-071) i `docs/ROADMAP.md`.
   - Wykonanie snapshotu `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0057`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Przed zamknieciem sesji wykonaj:
1. `pwsh -NoProfile -File .\tools\verify.ps1`
2. `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0057`
