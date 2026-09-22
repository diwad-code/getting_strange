# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0131 (P6 przekierowana: Human Scale & Playability)
Katalog: `C:\getting_strange`
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`
Wersjonowanie: brak; pliki na dysku sa jedynym stanem (D-016)

## Aktywna faza

**P6: Human Scale & Playability — OTWARTA.**
Faza P5 (RC1 / Golden Master techniczny) zostaje zamknieta. Stary cel
P6 (unifikacja nazwy kamery, reduced-motion) jest **odroczony**.

Wlasciciel (2026-08-25) podal cztery twarde wady runtime jako prawde,
nie jako hipoteze:

1. Lena nie wyglada jak kobieta i wyglada jak krasnoludek.
2. Skakanie sluzy do poruszania sie po miescie — absurd.
3. Postac moze isc tylko w prawo; lokacje nie wracaja w lewo.
4. Meble nie trzymaja jednej skali (krzeslo = czlowiek).

Decyzje: D-121..D-126. Kanon skali: `docs/WORLD_SCALE.md`.
Kanon traweru 1.1: `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` §7.5–7.7.
Kanon Leny 4.0: `docs/LENA_CHARACTER_AND_ANIMATION.md`.

Nastepny pakiet wykonawczy: **PKG-0132** (Lena 4.0 + skala + lewe wyjscia
+ drabiny/windy + audyt przejscia). Zakaz `.exe` do jawnego polecenia
wlasciciela (D-125).

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0 + kolejka P6.
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rowien Pixel-Stage.
Aktywny kanon fabulu: `docs/narrative/NARRATIVE_BIBLE.md` 0.3.
Aktywny raport wydajnosci: `docs/PKG_0130_FRAME_BUDGET_REPORT.md`.
Aktywny tracker ciaglosci: `docs/narrative/CONTINUITY_TRACKER.md` 0.3.

## Fakty z dysku (nie hipotezy)

- `LenaVisualRig` rysuje postac w `_draw()` (proceduralne wielokaty).
  CapsuleShape2D: wysokosc 56, promien 6. Figura ~66 px. To jest przyczyna
  krasnoludka.
- `previous_level_requested`: **zero** skryptow stacji deklaruje ten sygnal.
  `GameStateManager` go slucha, ale nikt go nie emituje. Dlatego da sie
  isc tylko w prawo.
- `geometry_audit.gd` traktuje schodek > 35 px jako blokade. 35 px to blat.
  Nowy prog: **18 px** (D-123). Audyt 35 px nie certyfikuje miasta.
- `LadderZone` i `ServiceLift` istnieja i dzialaja. Trzeba ich uzyc tam,
  gdzie sciana jest za wysoka na piesze wejscie.
- `gen-ai` (Picsart CLI) jest dostepny w terminalu. Skill: `gen-ai-use`,
  `text-to-visual`. Uzywac smialo do Leny i rekwizytow.

## Kompletny stan 43 stacji kampanii

Tresc i trawers PKG-0129/0130 pozostaja w kodzie. **Certyfikat traweru
100% jest niewazny** wobec D-123 (prog 18 px) i D-124 (brak lewych wyjsc).
Skala mebli nie byla audytowana.

| Zakres | Sekwencja | Tresc | Lena 4.0 | Skala | Lewo | Schodek 18 px |
|---|---|---|---|---|---|---|
| 01–07 | Foundation | CONTENT LOCK 3.0 | PLACEHOLDER | OPEN | BRAK | OPEN |
| 08–13 | Rysa | CONTENT LOCK 3.0 | PLACEHOLDER | OPEN | BRAK | OPEN |
| 14–23 | Marta / UCP | CONTENT LOCK 3.0 | PLACEHOLDER | OPEN | BRAK | OPEN |
| 24–30 | Wezel L4 | CONTENT LOCK 3.0 | PLACEHOLDER | OPEN | BRAK | OPEN |
| 31–37 | Podstruktura | CONTENT LOCK 3.0 | PLACEHOLDER | OPEN | BRAK | OPEN |
| 38–43 | Metoda | CONTENT LOCK 3.0 | PLACEHOLDER | OPEN | BRAK | OPEN |

Szablon audytu: `docs/PLAYTHROUGH_TRAVERSAL_AUDIT.md`.

## Architektura techniczna (bez zmian w PKG-0131)

- `ParticleBudget`, `CinematicCamera` snap 2 px, `AtmosphereRig` cache 18.
- `LadderZone`, `ServiceLift`, `GameStateManager` bidirectional API.
- Pixel-Stage: kompozytor 320x180, ostre teksty nad nim.
- InputMap: `move_left`, `move_right`, `move_up`, `move_down`, `jump`,
  `interact`, `pause`, `restart`, `trigger_correction`.
- Zakaz nowych czasownikow ruchu. Zakaz arcade (D-099). Zakaz webu (D-098).

## Stan weryfikacji

- `tools/verify.ps1` po PKG-0131: **PASS (exit code 0)**.
  DOCS PASS: 40 required files. Runtime bez zmian wobec PKG-0130.
- PKG-0131 nie rusza kodu gry; certyfikat Leny/skali/lewych wyjść
  pozostaje OPEN do PKG-0132.

## Ostatnia swieza weryfikacja

- Data: 2026-08-26 po PKG-0131
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod 0, 1054 s)
- Status binariow: zakaz `.exe` (D-125); buildy PKG-0124 w `dist/` nienaruszone.

## Czego jeszcze nie potwierdzono

- Lena 4.0 jako czytelna dorosla kobieta na kadrze (H-027 UNTESTED; ADR-003).
- Skala mebli we wszystkich 43 stacjach.
- Lewe wyjscia i spawn z prawej krawedzi.
- Schodki > 18 px bez drabiny/windy — audyt 35 px nie wystarcza.
- Reduced-motion i nazwa wezla kamery (`Camera` vs `Camera2D`) — odroczone.
- Testy na Steam Deck / AMD / NVIDIA.

## Nastepny pakiet

- **PKG-0132**: wykonaj piec zadan wlasciciela w jednym mega-pakiecie.
  Prompt: `docs/NEXT_SESSION_PROMPT.md`.
