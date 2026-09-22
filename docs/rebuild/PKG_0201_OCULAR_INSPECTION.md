# PKG-0201 — Ocularna inspekcja 57 kadrów 0198 (ścieżka B)

Data: 2026-09-06. Dyspozycja: ścieżka B z `docs/NEXT_SESSION_PROMPT.md`
(po PKG-0200). Ścieżka A (ekstrakcja interakcji/audio MRP) wymaga jawnej
dyspozycji właściciela, bo dotyka logiki — bez niej nie ruszana. Ten dokument
jest diagnozą wykonaną, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie pakietu: **czy każdy z 19 adresów wycinka 2 trzyma sylwetę i działanie
bez tekstu i bez koloru — okiem, na wszystkich 57 kadrach z
`reports/pkg_0198/visual/`?**

## Metoda i ograniczenia (uczciwie)

- Materiał: niezmienione 57 PNG 640×360 z PKG-0198 (19 adresów × pełny /
  bez tekstu / mono L8) + `frames.tsv`. Żaden kadr nie został nadpisany ani
  wygenerowany na nowo; nowe pliki pakietu leżą wyłącznie w
  `reports/pkg_0201/visual/` (7 arkuszy kontaktowych, dowód inspekcji).
- Ogląd: wszystkie 57 kadrów obejrzane okiem na 7 arkuszach kontaktowych
  (każdy adres: pełny | bez tekstu | mono obok siebie; miniatury 320×180).
  Przypadki flagowane z miniatur (najciemniejszy kadr 14, najciemniejsza trasa
  16, anomalia tekstowa 43) dobadane w pełnej rozdzielczości 640×360:
  `station_14` bez-tekstu + mono, `station_16` mono, `station_43` pełny.
- Metryki narzędziowe (PIL, skrypt jednorazowy poza repo): każdy mono-kadr to
  czysta skala szarości (max odchylenie R/G/B = 0 na wszystkich 19); wymiary
  640×360 dla 57/57. Różnica pełny-vs-bez-tekstu (śr. 10–39, 39–74% pikseli)
  NIE jest miarą samego usunięcia tekstu: warianty capture dzieli kilka klatek
  żywej maszynerii (zegary stacji pracują między ujęciami), więc liczba miesza
  animację z czyszczeniem dialogu. Wniosek o czystości kadru „bez tekstu" jest
  oczny, nie pikselowy.
- Skale tekstu 85/100/115: bramka 0198 dowodziła żywą prezentacją stacji 08;
  ten pakiet rozszerza runtime na 11 (najjaśniejsza), 14 (najciemniejsza)
  i 43 (finał) × 3 skale (ładowanie + instancja + klatki bez błędów skryptu
  na każdej skali) oraz regresję 08. Oczami przy 85/115 nie oglądano —
  jawne ograniczenie.
- Bez nowej tezy autorskiej (D-214): język miejsc z diagnozy 0197 pozostaje
  hipotezą; inspekcja sprawdzała wyłącznie regułę minimalną (bryła krawędzią
  + działanie geometrią, nigdy samym kolorem). Żadna etykieta nie tłumaczy
  żadnego miejsca; nic nie naprawiano „przy okazji".
- Logika gry, dźwięk, zapis, pauza, kamera, MRP, enum, serialize IDs:
  nietknięte. Zero zmian w `scripts/`, `scenes/`, konfiguracji.

## Wynik: 19/19 HOLD — lista napraw jest pusta

Żaden adres nie wymaga naprawy. Cztery ciemne adresy (14/15/16/17) niosą
strukturę słabiej niż reszta trasy, ale każdy trzyma się krawędzią i
obrysem — poniżej szczegóły jako notatki obserwacyjne, nie zlecenia.

| Adres | Werdykt | Co niesie sylwetę w mono (krawędź, nie kolor) | Metryka mono (śr/odch/cień%/krawędź) |
|---|---|---|---|
| 02 | HOLD | wiadukt, portal-drzwi (obrys), Lena, bryły maszyn | 48.6 / 17.5 / 48.7 / 1.09 |
| 03 | HOLD | wiata, ławka, dwoje drzwi (obrysy) | 40.2 / 22.3 / 69.5 / 1.30 |
| 04 | HOLD | masy wagonów, pionowa linia MRT, portal (obrys) | 44.0 / 22.0 / 52.5 / 1.18 |
| 05 | HOLD | rytm okien fasady, latarnia, portal (obrys), kreski jezdni | 40.0 / 16.4 / 64.5 / 0.82 |
| 07 | HOLD | niebo + horyzont dachów, trzy bryły czynności (tablica/domofon/klawiatura), portal wejścia | 44.4 / 26.0 / 63.4 / 1.08 |
| 09 | HOLD | stożek lampy, łóżko/biurko, okno, portal (obrys) | 70.5 / 30.6 / 26.6 / 1.23 |
| 10 | HOLD | stół, dwie postacie (odrębne masy), lampy, portal | 74.2 / 30.1 / 6.6 / 1.05 |
| 11 | HOLD | lada przez środek, boksy okienne w rytmie, drzwi ochrony | 144.5 / 66.8 / 3.8 / 1.83 |
| 12 | HOLD | rolki magnetofonów (ciemne koła + jasne środki), biurko, ledger, snopy światła | 65.4 / 26.8 / 22.4 / 1.36 |
| 13 | HOLD | długi stół syntezy, dwie postacie, lampy, okno | 86.8 / 38.0 / 21.7 / 0.96 |
| 14 | HOLD (marginalny) | full-res potwierdza: szafa analizatora (szklana bryła na tle), stożek z lampy, okrąg echa, bursztynowe ramię, pasek fali (czarny pasek + biały ślad), portal z masztem | 43.3 / 22.7 / 65.7 / 0.74 |
| 15 | HOLD (marginalny) | dwie tarcze, drabina (obrys), niebieska skrzynia; ciemno, ale struktura pełna | 42.7 / 19.8 / 63.2 / 0.92 |
| 16 | HOLD (marginalny) | full-res potwierdza: drabina + postać, bufet analizatora, odbiornik echa (biały rdzeń), selektor, słaby stożek lampy, portal | 38.8 / 18.4 / 80.4 / 0.92 |
| 17 | HOLD (marginalny) | rządek lad (jasne blaty), dwa kioski, portal; kioski zlewają się z tłem, blaty + portal niosą | 41.4 / 16.8 / 74.2 / 0.82 |
| 18 | HOLD | mur szaf/okien w rytmie, trzy stacje prawdy (jasne rdzenie), latarnie, portal | 39.3 / 18.9 / 67.9 / 1.49 |
| 42A | HOLD | czworo drzwi (odrębne obrysy), biurka, Lena | 47.9 / 16.6 / 66.7 / 1.11 |
| 42B | HOLD | złoty portal (jasna masa) + postać Marty w środku, linia podłogi | 48.5 / 19.9 / 66.8 / 1.25 |
| 42C | HOLD | jak 42B + druga postać; obie masy odrębne | 49.1 / 20.3 / 65.8 / 1.30 |
| 43 | HOLD | wiada świtu, dwa znaki, ławka, portal; gęsta ściana tekstu w kadrze pełnym to diegetyczne plansze credits/licencji + dialog — zamierzona treść epilogu, czyszczona w bez-tekstu | 41.8 / 30.5 / 63.6 / 1.75 |

Uwaga do 43: kadr pełny wygląda na pierwszy rzut oka jak zrzut debugowy
(ściana pomarańczowo-niebieskich bloków tekstu). Full-res rozstrzyga: to
diegetyczne tablice `EPILOG // ZAPIS NOWEJ CIĄGŁOŚCI // CREDITS / LICENCJE`
oraz plansze stanowisk — treść epilogu, nie wyciek. Nie jest to wada.

## Wykonane

1. Arkusze kontaktowe `reports/pkg_0201/visual/sheet_01..07_*.png` (7 plików,
   dowód oglądu wszystkich 57 kadrów bez nadpisywania `reports/pkg_0198/`).
2. Nowa bramka `tests/pkg_0201_ocular_inspection_test.gd`: integralność
   dowodu (TSV 57 wierszy, 57 plików 640×360, mono rzeczywiście szare,
   mono zgodne luminancją z bez-tekstu) + pin pokrycia inspekcji (19/19
   werdyktów HOLD) + runtime skale 85/100/115 (regresja 08 trzema akcjami
   jak w 0198; 11/14/43 ładują się i stoją 2 klatki bez błędów na każdej
   skali). Dowodzi kontraktów mierzalnych, nigdy czytelności dla człowieka.
3. Rejestracja: bramka dopisana do `tools/verify.ps1` (105. bramka).
4. Handoff: `CURRENT_STATE.md`, `SESSION_LOG.md` (PKG-0201), ten raport,
   `NEXT_SESSION_PROMPT.md`, `INDEX.md`, `ROADMAP.md` (wiersz 0201),
   `DECISION_LOG.md` (D-219).

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte (203/203, PKG-0200); dług
   interakcji/audio poza rendererami czeka na dyspozycję (dotyka logiki).
2. `station_18 MartaTruthTable` bez `prop_type` (default PHOTOGRAPH): otwarty
   fakt danych do decyzji właściciela (stwierdzony w PKG-0200, inspekcja
   kadru 18 go nie rozstrzyga ani nie zmienia).
3. Oczny ogląd skal 85/115 w pełnej rozdzielczości dla wszystkich adresów:
   otwarty (bramka dowodzi runtime, nie oko).
4. Ciemna czwórka 14/15/16/17 jako pozycje obserwacyjne: gdyby właściciel
   zlecił wzmocnienie, pierwszym kandydatem jest separacja stożka/szafy 14
   (krawędź, nie etykieta). Bez zlecenia — nie ruszać.
5. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
6. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
