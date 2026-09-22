# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0126 (Phase P5: Atmospheric Polish, Soundscapes, Particles & CRT Pacing)  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P5: Release Candidate 1 (RC1) + Cinematic Atmosphere & Mechanical Polish — ZAKOŃCZONA SUKCESEM**
(`ADR-006`, `ADR-007`, `D-114`, `D-115`, `D-116`, `D-117`, `D-118`).

Wdrożono kompletną rozbudowę syntezy dźwiękowej (`ProceduralAudio` — 12 nowych 16-bit PCM pejzaży dźwiękowych zero-asset dla podstruktury, węzłów przemysłowych i finałów 42A/B/C/43), zintegrowano wieloprofilowe oświetlenie wektorowe i unoszące się cząstki pary wentylacyjnej `VentSteam` w `AtmosphereRig`, dodano reakcję na niepokój `trigger_unease()`, zoptymalizowano tempo teletypowe i auto-advance w `CRTDialogueBox` z pełną matrycą mówców `SPEAKER_COLORS`. Utrzymano sylwetkę Leny 3.0, wspinaczkę i swobodne cofanie. Zgodnie z bezwzględną dyspozycją użytkownika **nie generowano nowych plików `.exe` ani paczek binarnych**.

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0 (ukończony w 100%).  
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rówień Pixel-Stage.  
Aktywny kanon fabuły: `docs/narrative/NARRATIVE_BIBLE.md` 0.3 i `docs/narrative/FULL_STORY.md` 0.3.  
Aktywny tracker ciągłości: `docs/narrative/CONTINUITY_TRACKER.md` 0.3.  
Aktywne notatki wydania: `docs/RELEASE_NOTES.md` (Wersja 1.0.0-RC1).  
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
  - Akcje wejścia: `move_left`, `move_right`, `move_up`, `move_down`, `jump`, `interact`, `toggle_pause`, `restart`

## Kompletny stan 43 stacji kampanii (Content Lock 3.0)

| Zakres stacji | Nazwa sekwencji / Aktu | Status | Prezentacja |
|---|---|---|---|
| **01–07** | Foundation Slice (Ostatni odczyt, Kiosk, Dwa rozkłady) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT |
| **08–13** | Sekwencja II/III: Rysa i cudzy dom (Mieszkanie 14, Pamięć) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT |
| **14–23** | Sekwencja IV/V: Marta, UCP i rozpoznanie (Budka, Jakub) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT |
| **24–30** | Sekwencja VI/VII: Węzeł pod Linią 4, żywa odpowiedź | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT |
| **31–37** | Sekwencja VIII/IX: Podstruktura i rejestr par | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT |
| **38–43** | Sekwencja X: Metoda, odgałęzienia 42A/B/C i epilog 43 | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT |

## Architektura techniczna i prezentacja

- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - 14 stanów: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`, `climb`.
  - Wzrost ~66 px, proporcje 1:6.7, wektorowe wypukłe płaszczyzny bez samoprzecięć, laboratoryjny prochowiec, dynamiczny zwrot i wsparcie dla cue/override.
- **Komponenty pionowej diegetycznej tranzycji (`LadderZone`, `ServiceLift`)**:
  - `LadderZone` (`scripts/environment/ladder_zone.gd`): przemysłowe drabiny ścienne z proceduralnymi szczeblami i syntetyzowanym audio kroków po szczeblach.
  - `ServiceLift` (`scripts/environment/service_lift.gd`): windy techniczne na szynach z płynnym ruchem fizycznym i sygnałami krańcowymi.
- **Prezentacja Rowień Pixel-Stage & Oświetlenie Wektorowe**:
  - `WorldPixelCompositor` (CanvasLayer 5) renderuje świat w siatce 2x2 nearest-neighbor (320x180).
  - `AtmosphereRig`: wieloprofilowe oświetlenie wektorowe (neony sodowe, ekrany UCP, reflektory gabinetu 40, potrójne filary 41, świt 43) z mikrodynamicznymi cząstkami pary `VentSteam` i kurzu `VolumetricDust`.
  - `CrispDiegeticText` (CanvasLayer 10) renderuje ostre napisy diegetyczne w świecie.
  - `InnerThoughtSurface` (CanvasLayer 16) wyświetla myśli `LENA // MYŚL` i wskazówki.
  - `CRTDialogueBox` (CanvasLayer 20) wyświetla dialog mówiony (42 CPS, auto-advance, pełny rejestr kolorów mówców).
  - Zero wywołań `draw_string()` w Layer 0 we wszystkich 43 stacjach gry.
- **Proceduralny dźwięk (Zero-Asset Architecture)**:
  - 80+ procedur PCM w `scripts/audio/procedural_audio.gd` generowanych w locie w pamięci RAM (w tym 12 nowych pejzaży dźwiękowych tła).
- **NarrativeGuidanceService**:
  - Model: Pokaż → Naprowadź → Pomyśl → Sprawdź (cooldown 8s, omylne hipotezy).
- **GameStateManager & Shell**:
  - Pełna dwukierunkowa obsługa kampanii 01..43 (`get_previous_campaign_station`, `target_spawn_side`), wybór operacji `select_finale_operation("A"|"B"|"C")`, routing do `station_42a`, `station_42b`, `station_42c`, przejście do `station_43`, zapis i odczyt stanu JSON (`user://getting_strange_campaign_v1.json`), remap 5 akcji i bilingualny silnik PL/EN.

## Stan weryfikacji

- `tools/verify.ps1` — **PASS (exit code 0)**:
  - Documentation contract — PASS (38 wymaganych plików i kontraktów)
  - Godot headless import — PASS
  - Getting Strange smoke test (43 sceny) — PASS
  - Traversal contract lint (0 violations) — PASS
  - PKG-0095..PKG-0126 gates — PASS (w tym dedykowany `pkg_0126_smoke_test.gd` PASS)

## Ostatnia swieza weryfikacja

- Data: 2026-08-25 po PKG-0126
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod wyjścia 0)
- Status binariów: Zgodnie z dyspozycją użytkownika zachowano zakaz tworzenia `.exe` po pakiecie; binarne buildy z PKG-0124 w `dist/` pozostały nienaruszone.

## Czego jeszcze nie potwierdzono

- Odbiór emocjonalny gracza i subiektywny ciężar wyborów moralnych w finałach (zgodnie z ADR-003 brak testów zewnętrznych).
- Testy na specyficznych konfiguracjach sprzętowych Steam Deck / Wayland pod Linuxem (do ewentualnej weryfikacji w P5+).

## Nastepny pakiet

- **PKG-0127**: Kompleksowy przegląd masteringu i balansu: końcowa certyfikacja spójności audio/wideo na wszystkich 43 stacjach, weryfikacja zapisu i płynności przejść scenicznych.


