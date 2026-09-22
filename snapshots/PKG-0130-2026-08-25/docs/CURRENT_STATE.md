# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0130 (Phase P5 zamknieta: Frame Budget 60 Hz, Particle Determinism, Pixel-Grid Camera Coherence)
Katalog: `C:\getting_strange`
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`
Wersjonowanie: brak; pliki na dysku sa jedynym stanem (D-016)

## Aktywna faza

**P5: Release Candidate 1 / Golden Master 1.0.0 — ZAMKNIETA.**
Nastepna faza: **P6: Post-RC1 presentation unification and reduced-motion accessibility** (`PKG-0131`).

PKG-0130 certyfikuje budzet klatki 60 Hz i koherencje pikselowa:

1. **Kontrakt czastek**: `ParticleBudget` (30 Hz, `fract_delta = false`) na wszystkich pieciu fabrykach emiterow. Deterministyczny teardown przy zmianie sceny.
2. **Cache swiatel**: 163 `Light2D` dziela 18 tekstur radialnych (redukcja 9.1x). Pulsowanie bez hashowania slownikow w `_process()`.
3. **Kamera**: snap transformacji i wstrzasu do siatki 2 px (kompozytor 320x180). Klamrowane sledzenie pionowe ze strefa martwa; plaskie komory bez zmiany kadrowania.
4. **Pomiar realny** (Intel Iris Xe, OpenGL Compatibility, vsync off): najgorsze p99 = 14.448 ms wobec 16.66 ms. Mediana 4.065–7.310 ms (137–246 FPS). Stacje 34–37 i 40–42 utrzymuja budzet.
5. Zgodnie z dyspozycja uzytkownika **nie generowano nowych plikow `.exe`**.

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0 (ukonczony w 100%).
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rowien Pixel-Stage.
Aktywny kanon fabulu: `docs/narrative/NARRATIVE_BIBLE.md` 0.3 i `docs/narrative/FULL_STORY.md` 0.3.
Aktywny kanon traweru: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` (Certyfikacja 100%).
Aktywny raport wydajnosci: `docs/PKG_0130_FRAME_BUDGET_REPORT.md`.
Aktywny tracker ciaglosci: `docs/narrative/CONTINUITY_TRACKER.md` 0.3.
Aktywne notatki wydania: `docs/RELEASE_NOTES.md` (Wersja 1.0.0-RC1 / Golden Master).
Aktywny pakiet licencyjny: `docs/LICENSES.md` (Zero-Asset Architecture, Godot MIT).

## Pakiety binarne i dystrybucja (Release Candidate 1)

Skonfigurowano i przetestowano `export_presets.cfg` z automatycznym skryptem budujacym `tools/export_builds.ps1`. Binarne buildy z PKG-0124 w `dist/` pozostaly nienaruszone.

| Platforma | Plik binarny / Sciezka | Rozmiar | Architektura | Renderer |
|---|---|---|---|---|
| **Windows Desktop** | `dist/windows/GettingStrange.exe` | ~125 MB | x86_64 standalone (embedded PCK) | GL Compatibility |
| **Linux Desktop** | `dist/linux/GettingStrange.x86_64` | ~90 MB | x86_64 standalone (embedded PCK) | GL Compatibility |

- **Metadane gry (`project.godot`)**:
  - Nazwa: `Getting Strange`
  - Wersja: `1.0.0`
  - Ikona: `res://icon.svg` (wektorowa kompozycja Rowien Pixel-Stage)
  - Rozdzielczosc bazowa: `640x360` (integer scaling 2x/3x/4x, canvas_items)
  - Czestotliwosc fizyki: `60 Hz`
  - Akcje wejscia: `move_left`, `move_right`, `move_up`, `move_down`, `jump`, `interact`, `pause`, `restart`, `trigger_correction`

## Kompletny stan 43 stacji kampanii (Content Lock 3.0, Traversal Certified, Frame Budget Certified)

| Zakres stacji | Nazwa sekwencji / Aktu | Status | Prezentacja | Trawers | Budzet klatki |
|---|---|---|---|---|---|
| **01–07** | Foundation Slice | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | 100%, 2x LadderZone | p99 14.45 ms (01) |
| **08–13** | Rysa i cudzy dom | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | 100%, Push props one-way | w budzecie obiektowym |
| **14–23** | Marta, UCP i rozpoznanie | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | 100%, Ladders & Airlocks | w budzecie obiektowym |
| **24–30** | Wezel pod Linia 4 | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | 100%, ServiceLift, Ladder | p99 10.89 ms (25) |
| **31–37** | Podstruktura | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | 100%, ServiceLift, 2x Ladder | p99 10.80 ms (34), 10.10 ms (37) |
| **38–43** | Metoda i epilog | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig 3.0, Guidance, CRT | 100%, Branching certified | p99 8.97–10.57 ms |

## Architektura techniczna i prezentacja

- **ParticleBudget (`scripts/visual/particle_budget.gd`)**:
  - `SIMULATION_FPS = 30`, `fract_delta = false`, `MAX_ACTIVE_EMITTERS = 6`, `MAX_ACTIVE_PARTICLES = 128`, `MAX_POOLED_EMITTERS = 20`.
  - Jedyny kontrakt czasu klatki dla `CPUParticles2D`. Bramka PKG-0130 odrzuca fabryke bez `apply_frame_budget()`.
- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - 14 stanow: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`, `climb`.
- **CinematicCamera (`scripts/camera/cinematic_camera.gd`)**:
  - Snap `global_position` i `offset` (wstrzas) do siatki 2 px. Autorytet float `_smooth_position` bez dryfu.
  - Klamrowane sledzenie pionowe (`vertical_deadzone = 46`, `vertical_follow_speed = 4.5`). Komora = 1 widok → kadrowanie zablokowane w srodku.
- **AtmosphereRig**:
  - Cache tekstur swiatel (`get_light_texture_cache_size()` = 18 po pelnym przebiegu kampanii).
  - Pulsowanie na `PackedFloat32Array`. Cząstki przez `ParticleBudget`. Teardown `_exit_tree()`.
- **Komponenty pionowe**: `LadderZone`, `ServiceLift` (PCM silnika z cache).
- **Prezentacja Rowien Pixel-Stage**:
  - `WorldPixelCompositor` (CanvasLayer 5) — 320x180 nearest-neighbour.
  - `CrispDiegeticText` (10), `InnerThoughtSurface` (16), `CRTDialogueBox` (20), `SceneTransitionLayer` (100), `CampaignPauseMenu` (110).
  - Zero `draw_string()` w Layer 0 we wszystkich 43 stacjach.
- **Proceduralny dzwiek**: 80+ procedur PCM, `ProceduralAudio.get_cached_sound()`.
- **GameStateManager & Shell**: dwukierunkowa kampania 01..43, routing 42A/B/C, zapis JSON, remap 5 akcji, PL/EN.

## Stan weryfikacji

- `tools/verify.ps1` — **PASS (exit code 0)**:
  - Documentation contract — PASS (39 required files)
  - Godot headless import — PASS
  - Getting Strange smoke test (43 scenes) — PASS
  - Traversal contract lint (0 violations) — PASS
  - PKG-0095..PKG-0130 gates — PASS
  - PKG-0130 frame budget audit (45 scenes) — PASS

## Ostatnia swieza weryfikacja

- Data: 2026-08-25 po PKG-0130
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod wyjscia 0, 914 s)
- Wynik `tools/render_frame_timing.gd`: PASS (12/12, worst p99 14.448 ms, Intel Iris Xe)
- Status binariow: zakaz `.exe` zachowany; buildy PKG-0124 w `dist/` nienaruszone.

## Czego jeszcze nie potwierdzono

- Odbior emocjonalny gracza i subiektywny ciezar wyborow moralnych w finalach (ADR-003).
- Testy na Steam Deck / Wayland / GPU AMD i NVIDIA (pomiar 60 Hz dotyczy Intel Iris Xe, Windows).
- Subiektywna gladkosc kamery przy wspinaczce — kontrakt siatki zmierzony, odczucie nie.
- Niespojne nazwy wezla kamery (`Camera` w 01–32, `Camera2D` w 33–43) — cel PKG-0131.

## Nastepny pakiet

- **PKG-0131**: P6 — unifikacja nazewnictwa kamery, reduced-motion / dostepnosc migotania swiatel i czastek, porzadk prezentacji po zamknieciu P5.
