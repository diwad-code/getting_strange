# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0129 (Phase P5: Global Traversal Geometry Audit, Diegetic Ladders & Lifts, and Traversal Certification)  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P5: Release Candidate 1 / Golden Master 1.0.0 — PEŁNA CERTYFIKACJA GEOMETRII I TRAWERSU**
(`ADR-006`, `ADR-007`, `D-099`, `D-114`, `D-115`, `D-116`, `D-117`, `D-118`, `D-119`).

Przeprowadzono pełny, globalny audyt drożności geometrii oraz wdrożono diegetyczne systemy mechaniczne:
1. **Globalna audytowalność geometrii**: Zaimplementowano narzędzie `tools/geometry_audit.gd` oraz bramkę `tests/pkg_0129_smoke_test.gd`. Przeanalizowano wszystkie 45 scen kampanii (01..41, 42a, 42b, 42c, 43). Potwierdzono 0 przeszkód blokujących ruch Leny (brak litych brył > 35 px bez jednokierunkowej kolizji `one_way_collision = true` lub dedykowanej drabiny `LadderZone` / windy `ServiceLift`).
2. **Remediacja i diegetyczne systemy pionowe**:
   - Stacja 01: przekształcono biurka `OperatorDesk` i `ConsoleBench` na `one_way_collision = true`, zainstalowano 2 drabiny serwisowe `OperatorLadder` i `ConsoleLadder`.
   - Stacja 09 & 11: wdrożono `one_way_collision = true` dla rekwizytów przesuwanych (`StairwellPlanter`, `HallwaySideboard`).
   - Stacja 25 & 34: zainstalowano automatyczne platformy pionowe `ServiceLift` (`TrackBedServiceLift`, `TurbineDeckServiceLift`) z fizyką `sync_to_physics = true`.
   - Stacje 30, 32, 37: wdrożono drabiny technologiczne `RelayServiceLadder`, `GlassLabLadder`, `SignalGalleryLadder`.
3. **Certyfikacja mechanik wspinaczki i platform**:
   - `LadderZone`: dołączanie `attach_to_ladder`, wspinaczka `is_climbing`, dźwięki szczebli `play_ladder_rung_sound` co 14 px, animacje `climb` w `LenaVisualRig`, płynne zeskakiwanie.
   - `ServiceLift`: ruch zgodny z fizyką, odliczanie czasów postoju na krańcach, proceduralny dźwięk silnika.
4. Zgodnie z dyspozycją użytkownika **nie generowano nowych plików `.exe` ani paczek binarnych**.

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0 (ukończony w 100%).  
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rówień Pixel-Stage.  
Aktywny kanon fabuły: `docs/narrative/NARRATIVE_BIBLE.md` 0.3 i `docs/narrative/FULL_STORY.md` 0.3.  
Aktywny kanon traweru: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` (Certyfikacja 100%).  
Aktywny tracker ciągłości: `docs/narrative/CONTINUITY_TRACKER.md` 0.3.  
Aktywne notatki wydania: `docs/RELEASE_NOTES.md` (Wersja 1.0.0-RC1 / Golden Master).  
Aktywny pakiet licencyjny: `docs/LICENSES.md` (Zero-Asset Architecture, Godot MIT).

## Pakiety binarne i dystrybucja (Release Candidate 1)

Skonfigurowano i przetestowano `export_presets.cfg` z automatycznym skryptem budującym `tools/export_builds.ps1`:

| Platforma | Plik binarny / Ścieżka | Rozmiar | Architektura | Renderer |
|---|---|---|---|---|
| **Windows Desktop** | `dist/windows/GettingStrange.exe` | ~125 MB | x86_64 standalone (embedded PCK) | GL Compatibility |
| **Linux Desktop** | `dist/linux/GettingStrange.x86_64` | ~90 MB | x86_64 standalone (embedded PCK) | GL Compatibility |

- **Metadane gry (`project.godot`)**:
  - Nazwa: `Getting Strange`
  - Wersja: `1.0.0`
  - Ikona: `res://icon.svg` (wektorowa kompozycja Rówień Pixel-Stage)
  - Rozdzielczość bazowa: `640x360` (integer scaling 2x/3x/4x, canvas_items)
  - Częstotliwość fizyki: `60 Hz`
  - Akcje wejścia: `move_left`, `move_right`, `move_up`, `move_down`, `jump`, `interact`, `pause`, `restart`, `trigger_correction`

## Kompletny stan 43 stacji kampanii (Content Lock 3.0 & Traversal Certified)

| Zakres stacji | Nazwa sekwencji / Aktu | Status | Prezentacja | Trawers |
|---|---|---|---|---|
| **01–07** | Foundation Slice (Ostatni odczyt, Kiosk, Dwa rozkłady) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | Drożność 100%, 2x LadderZone |
| **08–13** | Sekwencja II/III: Rysa i cudzy dom (Mieszkanie 14, Pamięć) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | Drożność 100%, Push props one-way |
| **14–23** | Sekwencja IV/V: Marta, UCP i rozpoznanie (Budka, Jakub) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | Drożność 100%, Ladders & Airlocks |
| **24–30** | Sekwencja VI/VII: Węzeł pod Linią 4, żywa odpowiedź | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | Drożność 100%, ServiceLift, Ladder |
| **31–37** | Sekwencja VIII/IX: Podstruktura i rejestr par | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | Drożność 100%, ServiceLift, 2x Ladder |
| **38–43** | Sekwencja X: Metoda, odgałęzienia 42A/B/C i epilog 43 | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | Drożność 100%, Branching certified |

## Architektura techniczna i prezentacja

- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - 14 stanów: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`, `climb`.
  - Wzrost ~66 px, proporcje 1:6.7, wektorowe wypukłe płaszczyzny bez samoprzecięć, laboratoryjny prochowiec, dynamiczny zwrot i wsparcie dla cue/override.
- **Komponenty pionowej diegetycznej tranzycji (`LadderZone`, `ServiceLift`)**:
  - `LadderZone` (`scripts/environment/ladder_zone.gd`): przemysłowe drabiny ścienne z proceduralnymi szczeblami i syntetyzowanym audio kroków po szczeblach.
  - `ServiceLift` (`scripts/environment/service_lift.gd`): windy techniczne na szynach z płynnym ruchem fizycznym i sygnałami krańcowymi.
- **Prezentacja Rowień Pixel-Stage & Oświetlenie Wektorowe**:
  - `WorldPixelCompositor` (CanvasLayer 5) renderuje świat w siatce 2x2 nearest-neighbor (320x180).
  - `AtmosphereRig`: wieloprofilowe oświetlenie wektorowe z mikrodynamicznymi cząstkami pary `VentSteam` i kurzu `VolumetricDust` oraz jawnym `_exit_tree()` zapobiegającym wyciekom.
  - `CrispDiegeticText` (CanvasLayer 10) renderuje ostre napisy diegetyczne w świecie.
  - `InnerThoughtSurface` (CanvasLayer 16) wyświetla myśli `LENA // MYŚL` i wskazówki.
  - `CRTDialogueBox` (CanvasLayer 20) wyświetla dialog mówiony (42 CPS, auto-advance, pełny rejestr kolorów mówców).
  - `SceneTransitionLayer` (CanvasLayer 100) zarządza tranzycjami fade i zwalnianiem pamięci audio cache.
  - `CampaignPauseMenu` (CanvasLayer 110) obsługuje pauzę, siatkę stacji i ustawienia ze skalowaniem fontów 85%..115%.
  - Zero wywołań `draw_string()` w Layer 0 we wszystkich 43 stacjach gry.
- **Proceduralny dźwięk i pamięć RAM (Zero-Asset Architecture)**:
  - 80+ procedur PCM w `scripts/audio/procedural_audio.gd` generowanych deterministycznie w locie.
  - Statyczne buforowanie audio `ProceduralAudio.get_cached_sound()` zapobiega fragmentacji sterty RAM.
- **NarrativeGuidanceService**:
  - Model: Pokaż → Naprowadź → Pomyśl → Sprawdź (cooldown 8s, omylne hipotezy).
- **GameStateManager & Shell**:
  - Pełna dwukierunkowa obsługa kampanii 01..43 (`get_previous_campaign_station`, `target_spawn_side`), wybór operacji `select_finale_operation("A"|"B"|"C")`, routing do `station_42a`, `station_42b`, `station_42c`, przejście do `station_43`, zapis i odczyt stanu JSON (`user://getting_strange_campaign_v1.json`), remap 5 akcji ze wsparciem parzystości urządzeń (`_replace_event_of_matching_type`) i bilingwalny silnik PL/EN.

## Stan weryfikacji

- `tools/verify.ps1` — **PASS (exit code 0)**:
  - Documentation contract — PASS (38 wymaganych plików i kontraktów)
  - Godot headless import — PASS
  - Getting Strange smoke test (43 sceny) — PASS
  - Traversal contract lint (0 violations) — PASS
  - PKG-0095..PKG-0129 gates — PASS (w tym dedykowany `pkg_0129_smoke_test.gd` PASS)

## Ostatnia swieza weryfikacja

- Data: 2026-08-25 po PKG-0129
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod wyjścia 0)
- Status binariów: Zgodnie z dyspozycją użytkownika zachowano zakaz tworzenia `.exe` po pakiecie; binarne buildy z PKG-0124 w `dist/` pozostały nienaruszone.

## Czego jeszcze nie potwierdzono

- Odbiór emocjonalny gracza i subiektywny ciężar wyborów moralnych w finałach (zgodnie z ADR-003 brak testów zewnętrznych).
- Testy na specyficznych konfiguracjach sprzętowych Steam Deck / Wayland pod Linuxem (do ewentualnej weryfikacji w P5+).

## Nastepny pakiet

- **PKG-0130**: Optymalizacja i profiling framerate 60 Hz pod obciążeniem cząstek i kompozytora, certyfikacja spójności czasu renderowania klatek oraz finalny raport wydaniowy P5.
