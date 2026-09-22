# Aktualny stan projektu

Stan na: 2026-08-26 po PKG-0132 (Lena 4.0 + skala + ReturnZone + próg 18 px)
Katalog: `C:\getting_strange`
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`
Wersjonowanie: brak; pliki na dysku sa jedynym stanem (D-016)

## Aktywna faza

**P6: Human Scale & Playability — OTWARTA (wykonanie PKG-0132 zamknięte).**

Decyzje D-121..D-126 pozostają. Runtime:

1. Lena 4.0: sprite `assets/characters/lena/*.png` (idle 46×87), nie wielokąty ciała.
2. Kapsuła 72 × 16, dół stopy bez zmiany (+27).
3. Stacje 02–43 deklarują `previous_level_requested`; `ReturnZone` dokleja GSM.
4. `geometry_audit.gd` próg 18 px: **0 blockerów**.
5. Zero nowych `.exe` (D-125). Istniejące `Godot_v4.6.3-stable_win64*.exe` w korzeniu to edytor, nie build gry.

Kanon skali: `docs/WORLD_SCALE.md`.
Kanon traweru 1.1: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md`.
Kanon Leny 4.0: `docs/LENA_CHARACTER_AND_ANIMATION.md`.

Nastepny pakiet: **PKG-0133** (capture okiem na normalnym driverze, one_way meble 09/11, chód 05→04→03). Zakaz `.exe`.

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0 + kolejka P6.
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rowien Pixel-Stage.
Aktywny kanon fabulu: `docs/narrative/NARRATIVE_BIBLE.md` 0.3.
Aktywny raport wydajnosci: `docs/PKG_0130_FRAME_BUDGET_REPORT.md`.
Aktywny tracker ciaglosci: `docs/narrative/CONTINUITY_TRACKER.md` 0.3.

## Fakty z dysku (nie hipotezy)

- `LenaVisualRig` ładuje Sprite2D; `_draw()` tylko cień kontaktowy. `draws_polygonal_body() == false`.
- Wysokość visual idle: 87 px. Walk 5 klatek, run 4, plus jump/land/climb/interact/examine.
- Źródło: Gemini 3.1 Flash Image (tożsamość) + Flux Kontext Pro (warianty chodu/biegu). Flux 2 Pro dał mocniejszy pixel-side idle — nie wdrożony, bo rozjechałby cykl Gemini.
- `previous_level_requested` na 44 skryptach stacji 02–43 (w tym 42a/b/c).
- `ReturnZone` (`scripts/environment/return_zone.gd`): Area2D na lewej krawędzi.
- GSM: `_ensure_return_zone`, spawn z prawej z `test_move` (cofanie od ściany).
- Meble stacji 01: OperatorDesk/ConsoleBench 39 px. Bench 02 i DualWitnessFrame 33: 18 px.
- `geometry_audit.gd`: próg 18, pomija `disabled` collidery.

## Kompletny stan 43 stacji kampanii

| Zakres | Sekwencja | Tresc | Lena 4.0 | Skala | Lewo | Schodek 18 px |
|---|---|---|---|---|---|---|
| 01–07 | Foundation | CONTENT LOCK 3.0 | SPRITE | REMEDIATED | ReturnZone 02–07 | 0 blockerów |
| 08–13 | Rysa | CONTENT LOCK 3.0 | SPRITE | REMEDIATED | ReturnZone | 0 blockerów |
| 14–23 | Marta / UCP | CONTENT LOCK 3.0 | SPRITE | REMEDIATED | ReturnZone | 0 blockerów |
| 24–30 | Wezel L4 | CONTENT LOCK 3.0 | SPRITE | REMEDIATED | ReturnZone | 0 blockerów |
| 31–37 | Podstruktura | CONTENT LOCK 3.0 | SPRITE | REMEDIATED | ReturnZone | 0 blockerów |
| 38–43 | Metoda | CONTENT LOCK 3.0 | SPRITE | REMEDIATED | ReturnZone | 0 blockerów |

Tabela: `docs/PLAYTHROUGH_TRAVERSAL_AUDIT.md`. Status **REMEDIATED**, nie PASS playthrough.

## Architektura techniczna

- `ParticleBudget`, `CinematicCamera` snap 2 px, `AtmosphereRig` cache 18.
- `LadderZone`, `ServiceLift`, `ReturnZone`, `GameStateManager` bidirectional API.
- Pixel-Stage: kompozytor 320x180, ostre teksty nad nim.
- InputMap: `move_left`, `move_right`, `move_up`, `move_down`, `jump`,
  `interact`, `pause`, `restart`, `trigger_correction`.
- Zakaz nowych czasownikow ruchu. Zakaz arcade (D-099). Zakaz webu (D-098).

## Stan weryfikacji

- `tests/pkg_0132_smoke_test.gd`: **PASS** (Lena 87, kapsuła 72, sygnały 02–43, próg 18, ReturnZone na 05, zero nowych exe gry).
- `tools/geometry_audit.gd`: 45/45, 0 blockerów.
- Pełne `tools/verify.ps1` po zamknięciu pakietu.

## Ostatnia swieza weryfikacja

- Data: 2026-08-26 po PKG-0132
- Wynik `pwsh -NoProfile -File "tools/verify.ps1"`: PASS (kod 0, 1134 s)
- Status binariow: zakaz `.exe` (D-125); `Godot_v4.6.3-stable_win64*.exe` w korzeniu to edytor, nie build gry.

## Czego jeszcze nie potwierdzono

- Capture Station 01 Lena+krzesło+drzwi na **normalnym sterowniku Windows** (H-027 odbiór; ADR-003).
- Sterowany chód 05→04→03 (spawn nie w ścianie — kod jest, brak przebiegu na ekranie).
- One_way meble 09/11 nadal da się nadskoczyć; nie blokują audytu 18 px.
- Flux 2 Pro idle (pixel-side) jako ewentualna wymiana tożsamości.
- Reduced-motion i nazwa wezla kamery — odroczone.
- Testy na Steam Deck / AMD / NVIDIA.

## Nastepny pakiet

- **PKG-0133**: capture okiem, one_way 09/11, weryfikacja 05→04→03. Prompt: `docs/NEXT_SESSION_PROMPT.md`.
