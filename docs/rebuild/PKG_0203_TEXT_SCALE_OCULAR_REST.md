# PKG-0203 — Oczny ogląd skal 85/115 w pełnej rozdzielczości, reszta wycinka 2 (ścieżka C)

Data: 2026-09-06. Dyspozycja: ścieżka C z `docs/NEXT_SESSION_PROMPT.md`
(po PKG-0202). Ścieżka A (ekstrakcja interakcji/audio MRP) wymaga jawnej
dyspozycji właściciela, bo dotyka logiki — bez niej nie ruszana. Ścieżka B
(`station_18 prop_type`) wymaga decyzji właściciela — nie naprawiana po cichu.
Ten dokument jest diagnozą wykonaną, nie werdyktem o urodzie ani odbiorze
(D-012, ADR-003).

Pytanie pakietu: **czy na pozostałych adresach wycinka 2 tekst w skalach
85/100/115 nie rozpycha kadru, nie ucina etykiet diegetycznych i nie zostawia
resztek w wariancie bez tekstu — okiem, w pełnej rozdzielczości 640×360?**

## Nazwany rozjazd: „15" z promptu to faktycznie 16

Prompt mówił o „pozostałych 15 adresach wycinka 2". Inwentarz
`reports/pkg_0198/visual/frames.tsv` liczy **19 adresów**
(02/03/04/05/07/09/10/11/12/13/14/15/16/17/18/42a/42b/42c/43), a PKG-0202
domknął ocznie 3 z tego zestawu (11/14/43; czwarty adres próby, 08, leży
poza zestawem 0198). Reszta to **16 adresów**
(02/03/04/05/07/09/10/12/13/15/16/17/18/42a/42b/42c), nie 15. Pakiet pokrył
wszystkie 16 — rozjazd jest wyłącznie arytmetyczny w handoffie, nie luką
w materiale. Razem z PKG-0202 cały zestaw 0198 ma teraz pokrycie oczne
85/115 (3 + 16) plus regresja 08.

## Metoda i ograniczenia (uczciwie)

- Materiał: 96 świeżych PNG 640×360 normalnym sterownikiem Windows (OpenGL,
  Intel Iris Xe) narzędziem `tools/capture_pkg_0203.gd` (verbatim wzór
  `tools/capture_pkg_0202.gd`): 16 adresów × 3 skale (85/100/115) × pełny /
  bez tekstu + `frames.tsv` (4 kolumny: station/scale/mode/file) pod
  `reports/pkg_0203/visual/`. Skala ustawiana przez
  `set_text_scale(v, false)` (bez persistu, z sygnałem
  `accessibility_changed`), po pętli powrót do 1.0. Nie nadpisano
  `reports/pkg_0198/`, `reports/pkg_0201/` ani `reports/pkg_0202/`.
- Ogląd: wszystkie 96 kadrów obejrzane okiem na 16 arkuszach kontaktowych
  `sheet_{station}_scales.png` (3 kolumny skal × góra pełny / dół bez tekstu;
  miniatury 320×180; arkusze złożone jednorazowym skryptem PIL poza repo)
  + dobadanie full-res 640×360 dla flagowanych metryką i próby ciemnej
  trasy: 09 s85/s115 notext (największy dryf notext 0.237), 03 s115 notext
  (0.083), 16 s115 full (ciemna trasa), 18 s115 full (witryna/stacje prawdy),
  42c s115 full (finałowa para).
- Metryki narzędziowe (PIL, skrypt jednorazowy): 96/96 plików 640×360.
  Różnica full-vs-notext s100 = 0.20–0.47 (dialog + czyszczenie diegetyk +
  animacja, nie sama skala). Różnica full s85-vs-s115 = 0.009–0.017
  (ok. 1% próbek: mały region tekstu + faza maszyny/animacji — ta sama
  klasa co w PKG-0202). Różnica notext s85-vs-s115 = 0.000 dla 9 adresów
  (02/04/10/12/16/42a/42b/42c + 08/11/43 z 0202); 0.0007 dla 13/15/17/18
  (pojedyncze próbki migotania); 0.026–0.083 dla 07/05/03; 0.237 dla 09.
  Oko rozstrzyga: kadry notext 09 s85 i s115 full-res są wolne od tekstu —
  dryf to żywa faza lampy/animacji między ujęciami (ten sam fakt o żywej
  maszynerii co w PKG-0201 i 0202 dla stacji 14), nie wyciek tekstu.
- Twarde zastrzeżenie porównań full (jak w 0202): kadry pełne łapią dialog
  CRT w środku efektu maszyny do pisania (np. 02: „Skrót z" vs „Skrót
  zamknięty"; 05: „Moja u" vs „Moja ulic…"; 18: „Tablica t" vs „Tablica
  trze…"), więc liczba znaków w boxie różni się fazą prezentacji, nie skalą.
  Wniosek o braku ucięć jest oczny (etykiety diegetyczne w całości w kadrze
  na 85 i 115), nie pikselowy.
- Bez nowej tezy autorskiej (D-214/D-219): język miejsc z diagnozy 0197
  pozostaje hipotezą; sprawdzano wyłącznie regułę minimalną (brak ucięć
  i brak resztek tekstu, sylweta z 0198/0201 nietknięta). Żadna etykieta
  nie tłumaczy żadnego miejsca; nic nie naprawiano „przy okazji".
- `station_18 MartaTruthTable prop_type` (default PHOTOGRAPH): wyłącznie
  obserwowane na kadrze s115 (trzy stacje prawdy czytelne), nietknięte —
  nadal otwarty fakt danych do decyzji właściciela.
- Logika gry, dźwięk, zapis, pauza, kamera, MRP, enum, serialize IDs:
  nietknięte. Zero zmian w `scripts/`, `scenes/`, konfiguracji.

## Wynik: 16/16 HOLD — lista napraw jest pusta

Żaden adres nie wymaga naprawy w skalach 85/100/115. Notatki to obserwacje,
nie zlecenia.

| Adres | Werdykt | Co niesie skalę okiem full-res (85 i 115) |
|---|---|---|
| 02 | HOLD | `ROBOTY W TOKU // OBJAZD 12 MIN` całe na obu końcach; box mieści tekst (faza maszyny, nie skala); notext czysty. |
| 03 | HOLD | `LINIA 4 // 20:47 // ZA 3 MIN` całe na 115; wiata/ławka/drzwi z 0201 nietknięte; notext full-res bez resztek (dryf 0.083 to faza animacji). |
| 04 | HOLD | `LINIA 4 // DRZWI Z PRAWEJ` całe na 115; masy wagonów i portal niosą; notext czysty (0.000). |
| 05 | HOLD | `UL. WIEJSKA // KIERUNEK SADOWA` i `PRZEJŚCIE DLA PIESZYCH // SYGNALIZACJA SPRAWNA` całe na 115; box mieści tekst; notext czysty. |
| 07 | HOLD | `UL. SADOWA 7`, `ZAŚMIECONE // SADOWA 7 M. 12`, `DOMOFON // 12. KOWALCZYK • 14. WOLSKA / KUREK` całe na 115; stopień 14 px bez drabiny (0198) nietknięty; notext czysty. |
| 09 | HOLD | `MIESZKANIE 14 // SALON` całe na 115; box mieści tekst; notext full-res s85/s115 wolny od tekstu (dryf 0.237 to żywa lampa/animacja, nie wyciek). |
| 10 | HOLD | `1. WOLSKA` i `14` całe na 115; stół/dwie postacie z 0201 nietknięte; notext czysty (0.000). |
| 12 | HOLD | `ŁĄCZE WARSZTATOWE // SERWIS LINII 4`, `NAPĘD // ODBIÓR PO ZMIANIE` całe na 115; rolki/ledger/snopy nietknięte; notext czysty (0.000). |
| 13 | HOLD | Trzy diegetyki syntezy (`ZAMÓWIENIE…`, `UMOWA NAJMU…`, `CZYTNIK // ZAPIS OFFLINE…`) całe na 115; box mieści tekst; notext czysty. |
| 15 | HOLD | `PĘTLA POMIAROWA LINII 4 // POZIOM -2`, `ODEBRANIE PĘTLI // DWA EGZEMPLARZE` całe na 115; tarcze/drabina/skrzynia nietknięte; notext czysty. |
| 16 | HOLD | `ANALIZATOR // ODPOWIEDŹ W TRYBIE OCHRONNYM`, `ŚLAD DOMU // JEDEN SZCZEGÓŁ MOŻE ZMIENIĆ OSTROŚĆ` całe na 115 (full-res); drabina/bufet/odbiornik z 0201 nietknięte; notext czysty (0.000). |
| 17 | HOLD | `REJESTR PAR LINII 4 // KTO UTWORZYŁ ZAPIS // KTO ZAPŁACIŁ`, `OFERTA ADAPTACJI // WPROWADZENIE DO REJESTRU` całe na 115; rząd lad/kioski/portal nietknięte; notext czysty. |
| 18 | HOLD | `TRZY PROGNOZY // ZGODY I BRAKI // JEDNA METODA`, `WITRYNA MARTY // PRAWDA ALBO JEJ CZĘŚĆ` całe na 115 (full-res); mur szaf/trzy stacje prawdy nietknięte; notext czysty. `prop_type` nietknięte. |
| 42a | HOLD | `POWRÓT // PUSTE KIESZENIE // PRÓG MIĘDZY ADRESAMI` całe na 115; czworo drzwi/Lena nietknięte; notext czysty (0.000). |
| 42b | HOLD | `ZAMKNIĘCIE RÓWNI // ODCZYTANE CIAŁO // NIEROZPOZNANA OBECNOŚĆ` całe na 115; złoty portal/Marta nietknięte; notext czysty (0.000). |
| 42c | HOLD | `PRZEJŚCIE WZAJEMNE // TRWAŁY PRZECIEK // OBIE LENY` całe na 115 (full-res); obie postacie odrębne; notext czysty (0.000). |

## Wykonane

1. Narzędzie `tools/capture_pkg_0203.gd` (96 kadrów: skala przed instancją,
   warianty full/notext wzorem 0198/0202 z gaszeniem `CrispDiegeticLayer`
   wprost).
2. Kadry `reports/pkg_0203/visual/` (96 PNG + `frames.tsv`) + 16 arkuszy
   kontaktowych (dowód oglądu bez nadpisywania starszych raportów).
3. Nowa bramka `tests/pkg_0203_text_scale_ocular_rest_test.gd`: integralność
   dowodu (TSV 96 wierszy, 96 plików 640×360, full-vs-notext rozłączne,
   full s85-vs-s115 rozłączne, próbkowanie krokiem 13 — twardy fakt
   z PKG-0202) + pin pokrycia inspekcji (48/48 werdyktów HOLD: 16 adresów
   × 3 skale) + runtime skale 85/100/115 (regresja 08 trzema akcjami +
   ładowanie każdego z 16 adresów i 2 klatki bez błędów na każdej skali).
   Dowodzi kontraktów mierzalnych, nigdy czytelności dla człowieka.
4. Rejestracja: bramka dopisana do `tools/verify.ps1` (107. bramka;
   składnia sprawdzona parserem: 2171 tokenów, 0 błędów).
5. Handoff: `CURRENT_STATE.md`, `SESSION_LOG.md` (PKG-0203), ten raport,
   `NEXT_SESSION_PROMPT.md`, `INDEX.md`, `ROADMAP.md` (wiersz 0203).

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte (203/203, PKG-0200); dług
   interakcji/audio poza rendererami czeka na dyspozycję (dotyka logiki).
2. `station_18 MartaTruthTable` bez `prop_type` (default PHOTOGRAPH): otwarty
   fakt danych do decyzji właściciela (kadr 0203 go nie dotyczy merytorycznie).
3. Oczny ogląd skal 85/115 full-res dla zestawu 0198: **DOMKNIĘTY**
   (0202: 08/11/14/43; 0203: pozostałe 16). Ograniczenie z PKG-0202 zdjęte.
4. Trzecia pełna weryfikacja z rzędu odłożona zakresową (0201/0202/0203,
   wszystkie D-217, zero plików współdzielonych): reguła wymaga pełnej
   `verify.ps1` najpóźniej w PKG-0205 (co najmniej raz na pięć pakietów;
   ostatnia pełna: PKG-0200, 104 bramki, exit 0).
5. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
6. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
