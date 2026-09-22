# Aktualny stan projektu

Stan na: 2026-08-26 po PKG-0134 (live walk 45 stacji)
Katalog: `C:\getting_strange`
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`
Wersjonowanie: brak; pliki na dysku sa jedynym stanem (D-016)

## Aktywna faza

**P6: Human Scale & Playability — OTWARTA (PKG-0134 zamknięty).**

Decyzje D-121..D-128. Runtime:

1. Live chód: 45/45 stacji dochodzi do śluzy po interact/unlock.
2. `try_curb_step` (18 px). `ExitClearance` na drzwiach i przegrodzie 26.
3. GATE_STORY (fizyka otwarta, flaga po dialogu): 12, 14, 15, 19, 20, 21.
4. Chód default, Shift=bieg. Lena 4.0, ReturnZone, zero nowych `.exe`.

Nastepny pakiet: **PKG-0135** (capture okiem, one_way 09/11, 05→04→03).



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
  `sprint`, `interact`, `pause`, `restart`, `trigger_correction`.
- `sprint` = modyfikator chodu (D-127), nie nowy czasownik lokomocji.
- Zakaz arcade (D-099). Zakaz webu (D-098).

## Stan weryfikacji

- `tests/pkg_0134_smoke_test.gd`: **PASS** (curb step, drzwi 02, kontrakty 45, chód 26).
- `tools/campaign_playability_audit.gd`: 45/45 fizycznie otwarte; 6 GATE_STORY.
- `tests/pkg_0133_smoke_test.gd`: **PASS**.
- Pełne `tools/verify.ps1` po zamknięciu pakietu.

## Ostatnia swieza weryfikacja

- Data: 2026-08-26 po PKG-0134
- Wynik `pkg_0134` + live audit: PASS fizyka; story gates nazwane.
- Status binariow: zakaz `.exe` (D-125).

## Czego jeszcze nie potwierdzono

- Capture na normalnym sterowniku Windows (H-027).
- Sterowany chód 05→04→03.
- One_way 09/11.
- Dialogowe flagi 12/14/15/19/20/21 (korytarz otwarty).
- Reduced-motion, nazwa kamery, Steam Deck / AMD / NVIDIA.

## Nastepny pakiet

- **PKG-0135**: capture, one_way 09/11, 05→04→03. Prompt: `docs/NEXT_SESSION_PROMPT.md`.

