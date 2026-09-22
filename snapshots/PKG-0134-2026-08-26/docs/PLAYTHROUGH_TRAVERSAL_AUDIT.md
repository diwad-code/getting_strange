# Audyt przejścia kampanii — drabiny, windy, dwukierunkowość, skala

Status: **PKG-0134 — LIVE WALK 45/45 fizycznie otwarte po interact/unlock. PASS playthrough nie przyznany (ADR-003).**
Kanon: `docs/WORLD_SCALE.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` D-123/D-124/D-128
Próba: `tools/campaign_playability_audit.gd` (instancja, chód, rekwizyty, unlock) + `tests/pkg_0134_smoke_test.gd`.

Próg schodka: **18 px** realizowany przez `PrototypePlayer.try_curb_step` (D-128).
Otwarte drzwi: `ExitClearance` wyłącza collider (uniesienie 70 px nie wystarcza).

Sygnał cofania: `previous_level_requested` / `ReturnZone` na 02–43.

| Stacja | Live chód do śluzy | Interakcje | Wyjście | Status |
|---|---|---|---|---|
| 01 | PASS po procedurze | 9 rekwizytów, drzwi disabled | Airlock | PASS_PHYSICS |
| 02 | PASS po unlock | 3, ChamberDoor disabled | Airlock | PASS_PHYSICS |
| 03 | PASS po unlock | 3, SecurityDoor disabled | Airlock | PASS_PHYSICS |
| 04 | PASS po unlock | 3, turnstile disabled | Airlock | PASS_PHYSICS |
| 05 | PASS | 3, śluza zawsze żywa | Airlock | PASS_PHYSICS |
| 06 | PASS po unlock | 3, drzwi autobusu | Airlock | PASS_PHYSICS |
| 07 | PASS | 3 | Airlock | PASS_PHYSICS |
| 08 | PASS po otwarciu | 3, drzwi disabled | Airlock | PASS_PHYSICS |
| 09 | PASS | 3 | Airlock | PASS_PHYSICS |
| 10 | PASS po progu | 3, drzwi disabled | Airlock | PASS_PHYSICS |
| 11 | PASS | 5 | Airlock | PASS_PHYSICS |
| 12 | PASS fizycznie | 5; flaga po dialogu/sekretarce | Airlock | GATE_STORY |
| 13 | PASS | 6 | Airlock | PASS_PHYSICS |
| 14 | PASS fizycznie | 5; flaga po dialogu Marty | Airlock | GATE_STORY |
| 15 | PASS fizycznie | 5; flaga po dialogu | Airlock | GATE_STORY |
| 16 | PASS | 5 | Airlock | PASS_PHYSICS |
| 17 | PASS | 5 | Airlock | PASS_PHYSICS |
| 18 | PASS | 5 | Airlock | PASS_PHYSICS |
| 19 | PASS fizycznie | 5; flaga po telefonie | Airlock | GATE_STORY |
| 20 | PASS fizycznie | 5; flaga po dialogu | Airlock | GATE_STORY |
| 21 | PASS fizycznie | 5; flaga po syntezie | Airlock | GATE_STORY |
| 22 | PASS | 5 | Airlock | PASS_PHYSICS |
| 23 | PASS | 5 | Airlock | PASS_PHYSICS |
| 24 | PASS | 5 | Airlock | PASS_PHYSICS |
| 25 | PASS | 5, winda 12 px + curb step | Airlock | PASS_PHYSICS |
| 26 | PASS po unlock | 5; przegroda izolacji disabled | Airlock | PASS_PHYSICS |
| 27 | PASS | 5 | Airlock | PASS_PHYSICS |
| 28 | PASS | 5 | Airlock | PASS_PHYSICS |
| 29 | PASS | 5 | Airlock | PASS_PHYSICS |
| 30 | PASS | 5 | Airlock | PASS_PHYSICS |
| 31 | PASS | 5 | Airlock | PASS_PHYSICS |
| 32 | PASS | 5 | Airlock | PASS_PHYSICS |
| 33 | PASS | 5 | Airlock | PASS_PHYSICS |
| 34 | PASS | 5 | Airlock | PASS_PHYSICS |
| 35 | PASS | 5 | Airlock | PASS_PHYSICS |
| 36 | PASS | 5 | Airlock | PASS_PHYSICS |
| 37 | PASS | 5 | Airlock | PASS_PHYSICS |
| 38 | PASS | 5 | Airlock | PASS_PHYSICS |
| 39 | PASS | 5 | Airlock | PASS_PHYSICS |
| 40 | PASS | 5 | Airlock | PASS_PHYSICS |
| 41 | PASS | 5 | Airlock | PASS_PHYSICS |
| 42A | PASS | 2 | Airlock | PASS_PHYSICS |
| 42B | PASS | 2 | Airlock | PASS_PHYSICS |
| 42C | PASS | 2 | Airlock | PASS_PHYSICS |
| 43 | PASS | 3 | Airlock | PASS_PHYSICS |

`PASS_PHYSICS` = headless chód dochodzi do śluzy po interact/unlock. Nie jest dowodem zabawy.
`GATE_STORY` = korytarz otwarty; `level_completed` czeka na dialog/sekretarkę.

Narzędzia: `tools/campaign_playability_audit.gd`, `ExitClearance`, `try_curb_step`.
