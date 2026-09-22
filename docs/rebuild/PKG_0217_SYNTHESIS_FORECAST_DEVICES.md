# PKG-0217 — Synteza 13 (trzeci głos) + prognozy `brak danych` + dyferencjacja urządzeń (N2+N5+N7-część)

Data: 2026-09-12. Dyspozycja: `docs/NEXT_SESSION_PROMPT.md` po PKG-0216
(faza R2 planu PKG-0213 §8, findings N2+N5+N7-część). Decyzja D-230.
Nie jest PRODUCT GO. GATE-REL, release i nowe `.exe` pozostają BLOCKED BY D-168.

## Co zmieniono (tekst prezentowany + bramki, zero mechaniki)

1. Trzeci głos (N2): synteza 13 —
   - `scripts/levels/creative_scene_lines.gd` (`synthesize`): usunięta sugestia
     świadomego testu (`Marta: Zostawiła po sobie tę próbę`), dodana 1 kwestia
     Jakuba przez łącze jako trzeci głos przy stole (bez sprowadzania aktora):
     `JAKUB (ŁĄCZE): Tego numeru nie ma w naszej bazie. Mój czas się zgadza.`
     (odczyt jego sprawdzenia numeru ze stacji 12, głos Jakub-czas).
     Kanon 3 kwestii zachowany (`To nie jest mój świat.` → `Więc gdzie jest
     ona?` → `Nie wiem.` + zamiar szukania miejscowej Leny). Ta sama liczba
     par (6), bez nowych adresów, rodzin, interakcji, faktów ani postaci.
   - `docs/narrative/FULL_STORY.md` (13): dopisany trzeci głos Jakuba przez
     łącze i wycofanie sugestii świadomej próby (kanon zsynchronizowany
     z liniami w tym samym pakiecie, wzór D-216/D-218).
   - Logika syntezy NIETKNIĘTA: `station_13.gd` nadal wymaga 3 śladów
     (home/institution/jakub) + 3 rodzin dowodu (public/relational/carried)
     + obu markerów źródeł; bramka pinuje to read-only.
2. Prognozy (N5): wariant `granted` pokazuje jawne czerwone pola `brak danych`
   (wzór `FULL_STORY.md:475-476`) —
   - każda z 3 linii `forecast_comparator_granted` zawiera `brak danych`;
   - dyferencjacja urządzeń treścią (bez etykiet rozróżnialne):
     REJESTR UCP = numery/daty (`20:40`), ANALIZATOR = wykres (`Oś spada`),
     NOTATKA = odręczny wtręt (`na marginesie`); mówcy linii zmienieni
     z 3× `TABLICA PROGNOZ` na REJESTR/ANALIZATOR/NOTATKA;
   - `chroni mój powrót` zachowane (zgodność z pkg_0194 run A);
     `limited/refused/missing` NIETKNIĘTE (luki `brak zgody Jakuba` stoją).
3. Dyferencjacja urządzeń poza prognozami (N5/N7-część, te same 3 rejestry) —
   - `safe_analyzer` (ANALIZATOR): `Oś wspólna.` (wykres);
   - `cost_selector_sample_full/buffer` (ANALIZATOR): `Oś: pik spada.`
     (wykres; `Sekunda 20:40:07` i `Pamięć Marty zostaje cała` zachowane);
   - `abort_note` (NOTATKA SERWISOWA): `(na marginesie)` (odręczny wtręt;
     `Bez jej zgody nie powtarzaj` zachowane);
   - `cost_ledger_console` (REJESTR UCP): bez zmian (`Para 04/17` już niesie
     numery). Ta sama liczba par wszędzie.
4. Wierzbicka (N7-część): recepcjonistka → strona bezosobowa
   z kwalifikatorami (wzór `DIALOGUE_SCRIPT.md:85-94`) —
   - `identity_card` (2 kwestie), `minimal_report` (1), `adaptation_offer_terminal`
     (2): każda kwestia zawiera `stan:` + `zakres` + `stabilność` /
     `dopuszczalne` / `procedura`; usunięte formy pierwszoosobowe
     (`Proszę położyć`, `Wydam`, `Wpiszemy`, `wygładzimy` → strona bierna
     `zostałyby wygładzone`); treść decyzyjna zachowana (dom, Marta, żywy
     Jakub; odmowa Leny `Nie będę wygodnym zastępstwem` NIETKNIĘTA).
     Ta sama liczba par (4/4/4).

## Twardy fakt narzędziowy (limit długości linii)

Pierwsza wersja dopisków (wykres `Wykres: dwie krzywe…`, margines
`(dopisek odręczny, na marginesie)`, prognozy ~130–135 znaków) wyłożyła
sąsiada `pkg_0194` realnym FAIL-em (`dialogue text must fit at scale 100`,
2×): pudło CRT (488×52, font 15) mieści ~2 linie; 3. linia to overflow.
Naprawiono w tym samym pakiecie skróceniem dopisków do minimum
(`Oś wspólna.`, `Oś: pik spada.`, `(na marginesie)`, prognozy ~104–111
znaków) — po skróceniu `pkg_0194` PASS bez obniżania progów.
Wniosek do rejestru ryzyk: każda przyszła dopiska treści musi liczyć znaki
(guide: linie 0194-scope ≤ ~115 znaków); bramka 0217 nie mierzy wysokości
pudła, tylko treść — fit pinuje wyłącznie `pkg_0194`.

## Weryfikacja

- Baseline: `tools/verify_docs.ps1` PASS (52 pliki) przed edycjami.
- Nowa bramka `tests/pkg_0217_synthesis_forecast_pin_test.gd` PASS (synteza
  6 par / 3 głosy / brak sugestii próby / 3 ślady + 3 rodziny read-only;
  granted 3× `brak danych` + rejestry urządzeń + routing per zgoda;
  urządzenia w 4 ID; Wierzbicka 4/4/4 + kwalifikatory + brak recepcji +
  fallback wiedzy; dowody fail-closed).
- Sąsiedzi PASS: `pkg_0216` (słownik/lint/palimpsest nietknięte), `pkg_0165`
  (lint stacji), `pkg_0193` (09–13 z nową syntezą), `pkg_0194` (po skróceniu
  dopisków, bez zmiany asercji), `pkg_0195` (finały), `pkg_0168` (42B),
  `pkg_0207` (pin 111/110/109 po aktualizacji), `pkg_0208` (selektor).
- Zakresowa `tools/verify_scoped.ps1` PASS (docs + smoke 01–43 + 9 bramek;
  exit 0). Blast: linie dialogowe + kanon 1 linia + testy + rejestracja
  bramki; zero shared-touch (żaden z plików D-217 nie tknięty:
  memory_resonance_point, mrp_legacy_renderer, game_state_manager,
  procedural_audio, world_pixel_compositor, autoloady), zero enum/serialize/
  routing/progów/InputMap, zero nowych adresów/rodzin/interakcji/faktów/
  postaci. Liczby D-221 nietknięte. Licznik D-217: 2. zakresowa po pełnej
  PKG-0215 (limit: pełna najpóźniej w PKG-0220).
- Kadry: 12 PNG 640×360 (`reports/pkg_0217/visual/`, stacje 13/18 × skale
  85/100/115 × full/notext, normalny sterownik Windows, Iris Xe, OpenGL)
  + `frames.tsv`. Inspekcja ręczna: etykiety diegetyczne bez kolizji
  z aktorami w full; warstwa diegetyczna gaśnie wprost w notext; przy 115%
  kompozycja trzyma (HOLD obrazu, zero napraw). Bazą „przed" są archiwa
  0193/0194/0216 (nie nadpisane).

## Granice dowodu

Zielone bramki dowodzą kontraktów mierzalnych (3 głosy, `brak danych`,
rejestry urządzeń, strona bezosobowa), nie zabawy, emocji, zrozumienia ani
odbioru (D-012, ADR-003). N2-domknięcie nie dowodzi, że gracz usłyszy trzy
głosy jako trzy rodziny dowodu — tylko że tekst je niesie, a logika wymaga
3 rodzin. N7-reszta (Wierzbicka w 17-interkomie DIALOGUE_SCRIPT, pełne
rozbicie `loop_logbook`, głosy 09/17, polszczyzna N10) czeka w PKG-0223
wg planu. Ekstrakcja tabel MRP (krok 2) nadal wymaga oddzielnej dyspozycji
(shared-touch → pełna verify).
