# CEL SESJI: PKG-0059 — Przestrzeń 41: Wybór operacyjny / Trzy warianty rozwiązania (Act IV Climax)

Wdrożenie Przestrzeni 41 (Wybór operacyjny) z `docs/narrative/FULL_STORY.md` (Scena 41), `docs/narrative/CONTINUITY_TRACKER.md` oraz `VISUAL_DESIGN.md`.

W Przestrzeni 41 gracz wchodzi do Komory Wyboru Operacyjnego na Poziomie 0. To nie jest menu dialogowe ani wybór tekstowy — gracz fizycznie i mechanicznie wykonuje jedną z trzech dostępnych operacji na trzech wyspecjalizowanych konsolach/stanowiskach:
1. **Stanowisko Operacji A (Powrót / Własny pokój):** zakotwiczenie własnego gestu z pierwszej komory (impuls korelacji próżniowej 21:45), odcięcie lokalnych świadectw, pojedynczy ocalony świat z wyjściem do Scene 42A.
2. **Stanowisko Operacji B (Uzgodnienie / Miejsce po niej):** przyjęcie złotej obrączki, adresu mieszkania 14 i wspomnienia wspólnego stołu z Martą Kurek, po czym pozwolenie UCP na bezpieczne domknięcie mostu z wyjściem do Scene 42B.
3. **Stanowisko Operacji C (Świadectwo / Dwie prawdy):** rozdzielenie punktów obserwacji między Martę, Jakuba, Szymona i sieć miejską — zakotwiczenie obserwowalności sprzeczności bez moralizowania, z dynamicznym wskaźnikiem zasięgu węzłów i wyjściem do Scene 42C.

## SRODOWISKO I BASELINE

- Projekt Godot: 4.7.stable na Windows (pwsh 7).
- Brak repozytorium git (D-016).
- Stan bazowy: PKG-0058 (Przestrzenie 01..40 w pełni zaimplementowane i przetestowane).
- Baseline: `pwsh -NoProfile -File .\tools\verify.ps1` musi przechodzić na zielono przed rozpoczęciem edycji.

## KRYTERIA AKCEPTACJI

1. **Synteza Proceduralnego Audio w `scripts/audio/procedural_audio.gd`**:
   - `create_operation_return_execution_sound()`: impuls fali odcięcia i wektor powrotu (640/1280 Hz + kryształowy sweep 2560 Hz);
   - `create_operation_reconciliation_execution_sound()`: ciepły relacyjny rezonans uległości i zatrzaśnięcie rygla mostu UCP (440/660/880 Hz);
   - `create_operation_testimony_execution_sound()`: wielopasmowy polifoniczny rezonans siatki świadków (330/495/660/990/1320 Hz);
   - `create_operation_console_engage_sound()`: mechaniczne załączenie stacji wyboru operacyjnego (520 Hz + 140 Hz);
   - `create_station41_act4_resolution_gate_sound()`: potężny sub-basowy akord rozstrzygnięcia i przejście do scen epilogu 42A..C (120..30 Hz + 980 Hz).

2. **Rozszerzenie `scripts/interactables/memory_resonance_point.gd`**:
   - Dodać typy rekwizytów do `PropType` (192..196):
     - `OP_CONSOLE_RETURN_A = 192` (Konsola Operacji A: Powrót);
     - `OP_CONSOLE_RECONCILIATION_B = 193` (Konsola Operacji B: Uzgodnienie);
     - `OP_CONSOLE_TESTIMONY_C = 194` (Konsola Operacji C: Świadectwo);
     - `OP_CONTINUITY_TOPOGRAPHY_DISPLAY = 195` (Wyświetlacz Topografii Ciągłości i Zasięgu Węzłów);
     - `STATION_41_EXIT = 196` (Wrota Rozstrzygnięcia do Scen Finałowych 42A..C);
   - Zaimplementować procedury `_draw_*` z czytelną architekturą operacyjną w palecie cyjan/bursztyn/cynober.

3. **Utworzenie `scripts/levels/station_41.gd` i `scenes/levels/station_41.tscn`**:
   - Scenografia Komory Wyboru Operacyjnego z trzema autonomicznymi terminalami egzekucyjnymi A, B, C;
   - Monitor mapy topograficznej obrazujący zasięg stabilizacji bez ukrywania kosztów;
   - Wybór i wykonanie operacji przez gracza (fizyczne załączenie terminala A, B lub C);
   - Odryglowanie wyjścia do odpowiedniego wariantu finału (Scene 42A / 42B / 42C).

4. **Weryfikacja i Testy**:
   - Dodać testy w `tests/smoke_test.gd` (`_test_station_41()` oraz testy audio);
   - Dodać zrzuty w `tools/capture_preview.gd` (`reports/station_41.png`, `reports/station_41_execution.png`);
   - Uruchomić `pwsh -NoProfile -File .\tools\verify.ps1` i `pwsh -NoProfile -File .\tools\capture.ps1`;
   - Zaktualizować `docs/CURRENT_STATE.md`, `docs/SESSION_LOG.md`, `docs/DECISION_LOG.md` (D-073) oraz `docs/ROADMAP.md`.

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po zaliczeniu wszystkich weryfikacji wykonać zamrożenie:
```powershell
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0059
```
