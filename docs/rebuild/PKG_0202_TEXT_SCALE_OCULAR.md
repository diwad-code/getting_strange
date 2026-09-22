# PKG-0202 — Oczny ogląd skal 85/115 w pełnej rozdzielczości (ścieżka C)

Data: 2026-09-06. Dyspozycja: ścieżka C z `docs/NEXT_SESSION_PROMPT.md`
(po PKG-0201). Ścieżka A (ekstrakcja interakcji/audio MRP) wymaga jawnej
dyspozycji właściciela, bo dotyka logiki — bez niej nie ruszana. Ścieżka B
(`station_18 prop_type`) wymaga decyzji właściciela — nie naprawiana po cichu.
Ten dokument jest diagnozą wykonaną, nie werdyktem o urodzie ani odbiorze
(D-012, ADR-003).

Pytanie pakietu: **czy na 4 adresach próbkowych (08 regresja, 11 najjaśniejsza,
14 najciemniejsza, 43 finał) tekst w skalach 85/100/115 nie rozpycha kadru,
nie ucina etykiet diegetycznych i nie zostawia resztek w wariancie bez tekstu
— okiem, w pełnej rozdzielczości 640×360?**

## Metoda i ograniczenia (uczciwie)

- Materiał: 24 świeże PNG 640×360 normalnym sterownikiem Windows (OpenGL,
  Intel Iris Xe) narzędziem `tools/capture_pkg_0202.gd` (wzór
  `tools/capture_pkg_0198.gd`): 4 adresy × 3 skale (85/100/115) × pełny /
  bez tekstu + `frames.tsv` (4 kolumny: station/scale/mode/file) pod
  `reports/pkg_0202/visual/`. Skala ustawiana przez
  `set_text_scale(v, false)` (bez persistu, z sygnałem
  `accessibility_changed`), po pętli powrót do 1.0. Nie nadpisano
  `reports/pkg_0198/` ani `reports/pkg_0201/`.
- Ogląd: wszystkie 24 kadry obejrzane okiem na 4 arkuszach kontaktowych
  `sheet_{station}_scales.png` (3 kolumny skal × góra pełny / dół bez tekstu;
  miniatury 320×180; arkusze złożone jednorazowym skryptem PIL poza repo)
  + dobadanie full-res 640×360: 08 s85/s115 full, 11 s115 full/notext,
  14 s85 notext + s115 full/notext, 43 s85/s115 full + s115 notext.
- Metryki narzędziowe (PIL, skrypt jednorazowy): 24/24 plików 640×360.
  Różnica full s85-vs-s115 ≈ 0.009–0.011 (ok. 1% próbek: mały region tekstu
  + animacja); notext s85-vs-s115 = 0.000 dla 08/11/43 (ukrycie trzyma
  niezależnie od skali), 0.118 dla 14 (żywa maszyneria: pasek fali i ramię
  w innej fazie między ujęciami — ten sam fakt co w PKG-0201: warianty
  dzieli kilka klatek animacji). Różnica full-vs-notext s100 = 0.19–0.50
  (dialog + czyszczenie diegetyk + animacja, nie sama skala).
- Twarde zastrzeżenie porównań full: kadry pełne łapią dialog CRT w środku
  efektu maszyny do pisania (08: „Klatka schodowa. Ciep" vs „Klatka
  schodowa"; 14: „Maszyna pracuje w" vs „Maszyna prac" vs „Maszyna p";
  43: „Epilog. Mias" vs „Epilog. Mia"), więc liczba znaków w boxie różni
  się fazą prezentacji, nie skalą. Wniosek o braku ucięć jest oczny
  (etykiety diegetyczne w całości w kadrze na 85 i 115), nie pikselowy.
- Bez nowej tezy autorskiej (D-214/D-219): język miejsc z diagnozy 0197
  pozostaje hipotezą; sprawdzano wyłącznie regułę minimalną (brak ucięć
  i brak resztek tekstu, sylweta z 0198/0201 nietknięta). Żadna etykieta
  nie tłumaczy żadnego miejsca; nic nie naprawiano „przy okazji".
- Logika gry, dźwięk, zapis, pauza, kamera, MRP, enum, serialize IDs:
  nietknięte. Zero zmian w `scripts/`, `scenes/`, konfiguracji.

## Wynik: 4/4 HOLD — lista napraw jest pusta

Żaden adres nie wymaga naprawy w skalach 85/100/115. Notatki to obserwacje,
nie zlecenia.

| Adres | Werdykt | Co niesie skalę okiem full-res (85 i 115) |
|---|---|---|
| 08 | HOLD | Diegetyki w całości na obu końcach: `KLATKA SCHODOWA // PIĘTRO 1`, `12 — KOWALCZYK`, `14 — L. WOLSKA / M. KUREK` bez ucięć; box dialogu mieści tekst na 85 i 115 (różna długość to faza maszyny, nie skala); notext czysty na wszystkich skalach, sylweta z 0201 nietknięta. |
| 11 | HOLD | Diegetyki w całości na 115: `UCP-4 // EWIDENCJA WEJŚĆ`, `WYCIĄGI // STANOWISKO OBSŁUGI` bez ucięć; box dialogu mieści tekst; notext czysty (lada, rytm boksów, drzwi ochrony niosą bez koloru na każdej skali). |
| 14 | HOLD | Diegetyki w całości na 115: `ROZDZIELNIA LINII 4 // SEKCJA 7`, `MOST SEKCJI // DWA MONTAŻE` bez ucięć; stożek, szafa analizatora, okrąg echa, bursztynowe ramię i pasek fali czytelne na 85 i 115; notext bez resztek (faza fali inna między skalami — żywa animacja, nie wyciek tekstu). Pozycja obserwacyjna z 0201 bez zmian. |
| 43 | HOLD | Ściana credits w całości na 85 i 115: `EPILOG // ZAPIS NOWEJ CIĄGŁOŚCI // CREDITS / LICENCJE` + plansze `LICENCJE // MANIFEST RUNTIME…` i `CREDITS // PRODUCTION…` bez ucięć — potwierdza diegetyczny charakter z 0201 także na największej skali; notext czyści plansze do pustych tablic (pomarańczowa/cyjanowa kreska), ławka i portal niosą. |

## Wykonane

1. Narzędzie `tools/capture_pkg_0202.gd` (24 kadry: skala przed instancją,
   warianty full/notext wzorem 0198 z gaszeniem `CrispDiegeticLayer` wprost).
2. Kadry `reports/pkg_0202/visual/` (24 PNG + `frames.tsv`) + 4 arkusze
   kontaktowe (dowód oglądu bez nadpisywania `reports/pkg_0198/`).
3. Nowa bramka `tests/pkg_0202_text_scale_ocular_test.gd`: integralność
   dowodu (TSV 24 wiersze, 24 pliki 640×360, full-vs-notext rozłączne,
   full s85-vs-s115 rozłączne) + pin pokrycia inspekcji (12/12 werdyktów
   HOLD: 4 adresy × 3 skale) + runtime skale 85/100/115 (regresja 08 trzema
   akcjami + 11/14/43 ładowanie i 2 klatki bez błędów na każdej skali).
   Dowodzi kontraktów mierzalnych, nigdy czytelności dla człowieka.
4. Rejestracja: bramka dopisana do `tools/verify.ps1` (106. bramka).
5. Handoff: `CURRENT_STATE.md`, `SESSION_LOG.md` (PKG-0202), ten raport,
   `NEXT_SESSION_PROMPT.md`, `INDEX.md`, `ROADMAP.md` (wiersz 0202).

## Kolejka (nie wynik tego pakietu)

1. F-0184-010: rendery MRP zamknięte (203/203, PKG-0200); dług
   interakcji/audio poza rendererami czeka na dyspozycję (dotyka logiki).
2. `station_18 MartaTruthTable` bez `prop_type` (default PHOTOGRAPH): otwarty
   fakt danych do decyzji właściciela (kadry 0202 go nie dotyczą).
3. Oczny ogląd 85/115 dla pozostałych 15 adresów wycinka 2: otwarty (ten
   pakiet domyka 08/11/14/43; bramki dowodzą runtime, nie oko).
4. Ciemna czwórka 14/15/16/17 jako pozycje obserwacyjne z 0201: bez zmian,
   bez zlecenia nie ruszać.
5. Fun, emocja, uroda, zrozumienie: OPEN-NO-EVIDENCE (D-012, ADR-003).
6. Release i `.exe`: BLOCKED (D-168). PRODUCT GO: nie jest wynikiem.
