# Audyt przejścia kampanii — drabiny, windy, dwukierunkowość, skala

Status: **SZABLON DO WYPEŁNIENIA W PKG-0132**
Kanon: `docs/WORLD_SCALE.md`, `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` D-123/D-124
Zakaz: nie wypełniać spekulacją. Wiersz bez próby przejścia = puste.

Próg schodka: **18 px**. Wyżej = drabina (`LadderZone`) albo winda (`ServiceLift`).
Skok nie jest sposobem poruszania się po mieście.

Sygnał cofania: `previous_level_requested` z lewej krawędzi.
Na dysku w chwili otwarcia PKG-0131: **zero stacji emituje ten sygnał**.

| Stacja | Próba przejścia | Mebel-olbrzym | Schodek >18 px bez drabiny/windy | Wyjście w lewo | Remedium | Status |
|---|---|---|---|---|---|---|
| 01 | | | | n/d (start) | | OPEN |
| 02 | | | | BRAK SYGNAŁU | | OPEN |
| 03 | | | | BRAK SYGNAŁU | | OPEN |
| 04 | | | | BRAK SYGNAŁU | | OPEN |
| 05 | | | | BRAK SYGNAŁU | | OPEN |
| 06 | | | | BRAK SYGNAŁU | | OPEN |
| 07 | | | | BRAK SYGNAŁU | | OPEN |
| 08 | | | | BRAK SYGNAŁU | | OPEN |
| 09 | | | | BRAK SYGNAŁU | | OPEN |
| 10 | | | | BRAK SYGNAŁU | | OPEN |
| 11 | | | | BRAK SYGNAŁU | | OPEN |
| 12 | | | | BRAK SYGNAŁU | | OPEN |
| 13 | | | | BRAK SYGNAŁU | | OPEN |
| 14 | | | | BRAK SYGNAŁU | | OPEN |
| 15 | | | | BRAK SYGNAŁU | | OPEN |
| 16 | | | | BRAK SYGNAŁU | | OPEN |
| 17 | | | | BRAK SYGNAŁU | | OPEN |
| 18 | | | | BRAK SYGNAŁU | | OPEN |
| 19 | | | | BRAK SYGNAŁU | | OPEN |
| 20 | | | | BRAK SYGNAŁU | | OPEN |
| 21 | | | | BRAK SYGNAŁU | | OPEN |
| 22 | | | | BRAK SYGNAŁU | | OPEN |
| 23 | | | | BRAK SYGNAŁU | | OPEN |
| 24 | | | | BRAK SYGNAŁU | | OPEN |
| 25 | | | | BRAK SYGNAŁU | | OPEN |
| 26 | | | | BRAK SYGNAŁU | | OPEN |
| 27 | | | | BRAK SYGNAŁU | | OPEN |
| 28 | | | | BRAK SYGNAŁU | | OPEN |
| 29 | | | | BRAK SYGNAŁU | | OPEN |
| 30 | | | | BRAK SYGNAŁU | | OPEN |
| 31 | | | | BRAK SYGNAŁU | | OPEN |
| 32 | | | | BRAK SYGNAŁU | | OPEN |
| 33 | | | | BRAK SYGNAŁU | | OPEN |
| 34 | | | | BRAK SYGNAŁU | | OPEN |
| 35 | | | | BRAK SYGNAŁU | | OPEN |
| 36 | | | | BRAK SYGNAŁU | | OPEN |
| 37 | | | | BRAK SYGNAŁU | | OPEN |
| 38 | | | | BRAK SYGNAŁU | | OPEN |
| 39 | | | | BRAK SYGNAŁU | | OPEN |
| 40 | | | | BRAK SYGNAŁU | | OPEN |
| 41 | | | | BRAK SYGNAŁU | | OPEN |
| 42A | | | | BRAK SYGNAŁU | | OPEN |
| 42B | | | | BRAK SYGNAŁU | | OPEN |
| 42C | | | | BRAK SYGNAŁU | | OPEN |
| 43 | | | | BRAK SYGNAŁU | | OPEN |

Statusy: `OPEN` / `BLOCKED` / `REMEDIATED` / `PASS`.
`PASS` tylko po próbie przejścia (headless geometria + capture albo
sterowany przebieg gracza) i po wpisaniu remedium.

Narzędzia: `tools/geometry_audit.gd` (próg do obniżenia z 35 na 18),
`LadderZone`, `ServiceLift`, `GameStateManager.transition_to_station_bidirectional`.
