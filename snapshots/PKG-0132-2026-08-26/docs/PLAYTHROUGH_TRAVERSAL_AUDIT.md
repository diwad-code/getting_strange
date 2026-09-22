# Audyt przejścia kampanii — drabiny, windy, dwukierunkowość, skala

Status: **PKG-0132 — REMEDIATED (geometria 18 px + sygnał powrotu). PASS playthrough nie przyznany.**
Kanon: `docs/WORLD_SCALE.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` D-123/D-124
Próba: `tools/geometry_audit.gd` próg 18 px (0 blockerów) + kontrakt `previous_level_requested` / `ReturnZone`.
Nie jest to sterowany przebieg gracza 01→43 ani 05→04→03 na ekranie.

Próg schodka: **18 px**. Wyżej = drabina (`LadderZone`) albo winda (`ServiceLift`).
Skok nie jest sposobem poruszania się po mieście.

Sygnał cofania: `previous_level_requested` z lewej krawędzi (`ReturnZone`, GSM dokleja na 02–43).
Stacja 01 nie wraca do tytułu lewą krawędzią.

| Stacja | Próba przejścia | Mebel-olbrzym | Schodek >18 px bez drabiny/windy | Wyjście w lewo | Remedium | Status |
|---|---|---|---|---|---|---|
| 01 | geometry_audit 18 | NIE (biurko/ławka 39 px, drabiny) | NIE | n/d (start) | kapsuła 72, Lena 87, meble 39 | REMEDIATED |
| 02 | geometry_audit 18 | NIE (ławka 18 px) | NIE | ReturnZone | bench 28→18 | REMEDIATED |
| 03 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 04 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 05 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał; GSM spawn right | REMEDIATED |
| 06 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 07 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 08 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 09 | geometry_audit 18 | one_way doniczka 44 px | NIE (one_way) | ReturnZone | nie na wymaganej trasie pieszej | REMEDIATED |
| 10 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 11 | geometry_audit 18 | one_way kredens 68 px | NIE (one_way) | ReturnZone | nie na wymaganej trasie pieszej | REMEDIATED |
| 12 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 13 | geometry_audit 18 | NIE (szuflada disabled) | NIE | ReturnZone | audit pomija disabled | REMEDIATED |
| 14 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 15 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 16 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 17 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 18 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 19 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 20 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 21 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 22 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 23 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 24 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 25 | geometry_audit 18 | NIE | NIE | ReturnZone | ServiceLift | REMEDIATED |
| 26 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 27 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 28 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 29 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 30 | geometry_audit 18 | NIE | NIE | ReturnZone | RelayServiceLadder | REMEDIATED |
| 31 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 32 | geometry_audit 18 | NIE | NIE | ReturnZone | GlassLabLadder | REMEDIATED |
| 33 | geometry_audit 18 | NIE (rama 18 px) | NIE | ReturnZone | DualWitnessFrame 24→18 | REMEDIATED |
| 34 | geometry_audit 18 | NIE | NIE | ReturnZone | ServiceLift | REMEDIATED |
| 35 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 36 | geometry_audit 18 | NIE | NIE | ReturnZone | drabina | REMEDIATED |
| 37 | geometry_audit 18 | NIE | NIE | ReturnZone | drabina | REMEDIATED |
| 38 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 39 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 40 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 41 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 42A | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 42B | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 42C | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |
| 43 | geometry_audit 18 | NIE | NIE | ReturnZone | sygnał | REMEDIATED |

Statusy: `OPEN` / `BLOCKED` / `REMEDIATED` / `PASS`.
`PASS` tylko po próbie przejścia (headless geometria + capture albo sterowany przebieg).
PKG-0132 zamyka geometrię i dwukierunkowość kontraktowo. Sterowany chód 05→04→03 i capture okiem na normalnym driverze: PKG-0133.

Narzędzia: `tools/geometry_audit.gd` (próg 18), `LadderZone`, `ServiceLift`, `ReturnZone`, `GameStateManager.transition_to_station_bidirectional`.
