# PKG-0236 — Cięcia, nie teleporty (Pakiet B)

Data: 2026-09-15
Decyzja: D-248
Plan: `docs/narrative/SENS_FABULARNY_PLAN_NAPRAWY_2026-09-15.md` Pakiet B (B1–B4)

To **nie** jest Pakiet B z wyczerpanego planu PKG-0231 (tamten wszedł w skład
PKG-0233). Freeze D-241 zdjęty wyłącznie dla tego pakietu.

## Cel

Każde wyjście w prawo na odcinku 10–18 da się powiedzieć zdaniem o świecie.
Spawn w celu i rodzina progu zgadzają się z tym zdaniem. Bez nowych numerów
stacji i bez platformingu.

## Wdrożenie

### B1. Tabela cięć i zgodność przestrzenna

| Skok | Zdanie świata | Rodzina progu wyjścia | Spawn w celu | Kwestia i spójność |
|---|---|---|---|---|
| 10 → 11 | Wychodzę z mieszkania na noc, do UCP | DOOR (wyjście z domu) | lewa (wejście od ulicy/holu) | Myśl 10: zostawia telefon, wychodzi do UCP sprawdzić zapis. 11 wita Wierzbicką przy ladzie. |
| 11 → 12 | Idę do warsztatu z numeru w rejestrze | DOOR (drzwi serwisowe) | lewa (wejście do warsztatu) | 11 po wyciągu ma kontakt do warsztatu; 12 wita imadłem i łączem Jakuba. |
| 12 → 13 | Wracam do mieszkania, do stołu | DOOR (wyjście z warsztatu) | **prawa** (powrót) | 12: `s12_exit_back_home`. 13: stół, Marta, grafik. |
| 13 → 14 | Schodzę włazem serwisowym za klatką | **HATCH** (właz wyjściowy) | lewa (dół rozdzielni) | 14 wita: „Zeszłam włazem serwisowym za klatką schodową.” 13: `s13_exit_to_switchyard`. |
| 14 → 15 | Z mostu wzdłuż obwodu do pętli | HATCH (właz) | lewa (komora pętli) | 15: „Schodzę do pętli.” |
| 15 → 16 | Wychodzę włazem w górę, poza obwód | HATCH (właz) | lewa (pomieszczenie analizatora) | 16: odpowiedź do analizatora poza obwodem. |
| 16 → 17 | Idę do hali UCP, do rejestru par | DOOR | lewa (hala UCP) | 16: `s16_exit_to_ledger`. 17: hala rejestru par. |
| 17 → 18 | Wracam na Sadową | DOOR | **prawa** (powrót) | 18: ulica, Marta w oknie. |
| 18 → 42 | Noc → świt, metoda wykonana | DOOR | lewa / próg | Otwarcie 42 mówi o nocy przy słupku. |

### B2. Kod routingu

`GameStateManager.arrival_side_for` zachowuje ścisłą regułę fabularną:
- Powroty do znanych miejsc: `12 → 13` (powrót do domu) oraz `17 → 18` (powrót na ulicę) wchodzą z **prawej**.
- Pierwsze wejścia i drogi w głąb: `10 → 11`, `11 → 12`, `13 → 14`, `14 → 15`, `15 → 16`, `16 → 17`, `18 → 42A` wchodzą z **lewej**.
- Brak zbędnych wyjątków w kodzie; mechanika spójna z testem filmu.

### B3. Binder: stacja 13 wychodzi włazem (HATCH)

W `scripts/environment/threshold_binder.gd`:
- `station_13` przeniesione do grupy `ThresholdZone.Family.HATCH` (64×64, `door: ""`) razem ze `station_14` i `station_15`.
- `station_09` i `station_10` pozostają `ThresholdZone.Family.DOOR` (przejście pokój → pokój w tym samym mieszkaniu).
- Kontrolowana aktualizacja bramki `tests/pkg_0214_threshold_exit_open_pin_test.gd` na `FAMILY_HATCH` dla `station_13`.

### B4. Zdanie mostu w stacji 10

W `scripts/levels/station_10.gd`:
- Beat wyjścia `s10_exit_ucp_record` podmieniony na:
  *PL:* „Marta twierdzi, że pracuję w UCP. Zostawiam jej telefon i wychodzę — zapis sprawdzę w UCP, zanim uznam to za moje.”
  *EN:* „Marta claims I work at UCP. I leave her phone and step out — I will check the record at UCP before I take it as mine.”
- Zdanie nazywa fizyczny akt opuszczenia mieszkania (Lena zostawia telefon Marty i wychodzi) oraz cel instytucjonalny (weryfikacja zapisu w UCP), zamiast sugerować natychmiastowe przejście do stołu.
- Hipoteza i frazy pinowane bramką `pkg_0233` pozostają nienaruszone.

## Weryfikacja

Nowa bramka `tests/pkg_0236_cuts_not_teleports_test.gd`:
1. Binder 13 wychodzi jako HATCH (zgodny z §7.1: 64×64, door=""); 09 i 10 to DOOR;
2. Binder 12 to DOOR i nie zawiera BalconyDoor (pin A z PKG-0234 zachowany);
3. Zainstalowany próg w 13 w czasie rzeczywistym jest węzłem HATCH;
4. Stacja 10 nazywa wyjście z domu do UCP i zachowuje hipotezę 0233;
5. Stacja 14 wita włazem, a stacja 13 nazywa wyjście włazem i sekcją rozdzielni;
6. Routing odcinka 10–18: 12→13 i 17→18 z prawej, reszta z lewej;
7. Linie mostów: kontakt do warsztatu w 11, wyjście do domu w 12, wyjście do rejestru w 16 oraz kwestie nocy przy słupku w 42A/B/C nienaruszone.

Pin `pkg_0207`: 127 wywołań / 126 skryptów / 125 referencji / 125 plików na dysku; 134. sekcja w `tools/verify.ps1`.
PEŁNA `tools/verify.ps1`: PASS exit 0 (134 sekcje; dowód `reports/pkg_0236_verify_full.log`). Licznik D-217 zresetowany.

## Twarde fakty

- Właz w 13 to naturalny odpowiednik powitania w 14: 13 myśli o zejściu włazem, binder stawia HATCH, a 14 otwiera się zejściem włazem.
- Żadne nowe sceny ani zmiana topologii grafu nie były potrzebne: semantyka montażowa została osiągnięta wyłącznie rodziną progu, spawnem i zdaniem otwarcia/wyjścia.

## Poza zakresem

Pakiet D (słowa: Równia, Wierzbicka dwa tryby, analizator, 42B), Pakiet E. Akt I. Stacje 19–41. Wezły P7 poza trasą (PKG-0234 zachowane). Flagi luk P9 (PKG-0235 zachowane). Web, nowe `.exe`, PRODUCT GO (D-168).
Automat dowodzi kontraktów technicznych, nie emocji ani odbioru (D-012, ADR-003).
