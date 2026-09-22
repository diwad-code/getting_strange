# PKG-0197 — Diagnoza obrazu od zera (wycinek 1: 01/06/08 + winiety)

Data: 2026-09-05. Dyspozycja właściciela: zero rewizji artystycznej — żadnej
decyzji graficznej nie traktuje się jako kanonu, każdą trzeba udowodnić od nowa.
Ten dokument jest diagnozą, nie werdyktem o urodzie ani odbiorze (D-012, ADR-003).

Pytanie: **co widać w kadrze 640×360 bez ani linijki tekstu — kim jest Lena,
gdzie jest i co tu działa?**

## Metoda i ograniczenia (uczciwie)

- Kod rysujący przeczytany w całości: `_draw()` stacji 01/06/08,
  `vector_stage_environment.gd` (kompozycje 01–43 + oświetlenie praktyczne),
  `vector_stage_style.gd`, `character_visual_rig.gd`, `lena_visual_rig.gd`,
  `world_pixel_compositor.gd`, `vibration_trace_display.gd`,
  `cinematic_catalog/director/vignette.gd`.
- Świeże kadry normalnym sterownikiem Windows (OpenGL, Intel Iris Xe):
  `reports/pkg_0197/visual/` — 3 PNG 640×360 (01/06/08) + `frames.tsv`.
  Pełne 60 kadrów (20 adresów × 3) NIE zostało wyrenderowanych w tym wycinku;
  dla pozostałych 17 adresów dowodem jest kod kompozycji + kadry
  `reports/pkg_0187/visual/` i `reports/pkg_0196/visual_final/` jako inwentarz.
- Trzy kadry na adres w pełnym sensie (pełny / bez tekstu / mono) są kolejką
  wycinka 2. Wnioski poniżej, które wymagają kadru mono, są oznaczone [MONO-Q].
- Automat dowodzi kontraktów mierzalnych (`tests/pkg_0197_zero_revision_test.gd`),
  nigdy czytelności dla człowieka.

## Twarde znaleziska (naprawione w tym wycinku)

### F-01. Winiety dubbingowały scenę tezą autorską (6 z 7)
`cinematic_catalog.gd`: drugi podpis w `vig_threshold`, `vig_signal`,
`vig_commit`, `vig_finale_a/b/c` to sentencja w głosie Leny, innym językiem
obrazu niż scena (plansza gen-ai + aforyzm). Jedyna winieta czysta to
`vig_synthesis` (puste podpisy). Ten sam wzorzec, który CR-C/CR-D usunął ze
scen 42/43 i 01–08: teza zamiast gestu. **Naprawa:** wszystkie drugie podpisy
wyzerowane do `""`; sloty, wyzwalacze, długości klatek, warstwa 19 i skip
bez zmian. Fakty niosą już stacje (kontrakt winiety: wzmocnienie, nigdy jedyny
nośnik).

### F-02. Maszyna stacji 01 nie pracowała bez gracza
`station_01.gd` przed pakietem: bęben rejestratora rysowany statycznym krzyżem,
zero własnego czasu, zero słyszalnego źródła hali w kadrze. Test kanonu
przeszkód („czy robiłaby to samo bez gracza?") oblany na najważniejszej
maszynie gry — tej, która ma ustanowić kontrakt §3 (narzędzie, procedura,
rozbieżność dwóch odczytów). **Naprawa:** zegar `_machine_time`, obrót bębna
~9 s/obrót, lampka statusu ~2,6 s, `MachineHum` (AudioStreamPlayer2D przy
rejestratorze, generator ballastu hali), cień kontaktowy w prawo pod maszyną.
Zero writerów/flag/sygnałów.

### F-03. Sprzedawca (06) i sąsiadka (08) stali jak słupy
Rig `vendor` ma klatki talk_0/talk_1/listen, rig `neighbour` talk_0/talk_1/
listen/gesture — ale żaden kod ich nie sterował: `creative_scene_presentation`
obsługuje tylko 09–18, a `station_06/08.gd` nigdy nie wołały `set_state`.
Obie postacie tkwiły w `idle` przez całą rozmowę; mówiła za nie wyłącznie
kwestia w CRT. **Naprawa:** wizualny sterownik w obu stacjach
(`line_started` → talk/listen + obrót do gracza, `dialogue_finished` → idle).
Zero writerów/flag/sygnałów gry.

### F-04. Cienie nie miały kierunku (01/06/08)
Trzy stacje nie rysowały cienia kontaktowego wcale; reszta kadru (lampy
praktyczne środowiska) zakłada górne światło. **Naprawa:** jeden cień 0.48
alpha pod bryłą dominującą w każdej z trzech stacji, kładziony w prawo,
zgodnie z lampą praktyczną. Konwencja do powielenia w wycinku 2.

## Inwentarz 20 adresów (co czytelne / co szum / co kłamie)

| Adres | Rodzina | Czytelne bez tekstu | Szum | Kłamstwo o funkcji | Status |
|---|---|---|---|---|---|
| 01 | zakład | stanowisko, bęben, walizka na próbkę, telefon, śluza-drzwi | pas etykiety y162–190 wchodzi w rysunek maszyny (znany, trzymany) | brak: maszyna ma własny cykl (F-02) | NAPRAWIONE |
| 02 | zakład | dwa punkty optyczne, zatoka pomiaru | — | brak | inwentarz |
| 03 | zakład | puste laboratorium, porzucone biurko, szew wyjścia | — | brak | inwentarz |
| 04 | zakład | lada, brama mechaniczna | — | brak | inwentarz |
| 05 | ulica | droga-sceniczna, jedno oświetlone przejście | dwa prostokąty poza kadrem (x672+, x1010+, `environment.gd` 05) rysowane poza ekranem — martwy kod, nie szum widoczny | brak | inwentarz, martwy kod do wycięcia w wycinku 2 |
| 06 | ulica | niebo ≥25%, kiosk, rozkład, lada-okno | gazetki-rack 4× prostokąt (dekoracja bez pracy) | brak po F-03: sprzedawca mówi ciałem | NAPRAWIONE |
| 07 | ulica | pion klatki w pustce | schody rysowane w `_draw_station_composition` + osobna drabina stacji (znany podwójny rysunek z komentarza 9.3 — do weryfikacji w wycinku 2) | [MONO-Q] | inwentarz |
| 08 | klatka | sufit 36 px, lamperia, skrzynki, drzwi 12/14, schody-mieszczańskie | donica-paprotka (kropka cyjanu bez pracy) | brak po F-03 | NAPRAWIONE |
| 09 | klatka | bieg schodów, okno półpiętra, wnęka po gaśnicy | — | brak | inwentarz |
| 10 | próg | ciemne skrzydło 14, bursztynowa szpara | — | brak | inwentarz |
| 11 | mieszkanie | ciepła wyspa, komoda przez przejście | głąb niedopowiedziana (zamierzone) | [MONO-Q] komoda czyta się jako blokada czy mebel? | inwentarz |
| 12 | mieszkanie | stolik z telefonem, zimny balkon rozcina pokój | — | brak | inwentarz |
| 13 | mieszkanie | blat na skos, dwa pola dokumentów | — | brak | inwentarz |
| 14 | techniczne | szyb serwisowy, zwężone zatoki | — | brak | inwentarz |
| 15 | liminalne | linia ciśnieniowa w prawo, dolna krata | — | brak | inwentarz |
| 16 | liminalne | niski stół, lampa-stożek | blok okienny 200–440 w ciemności (co to jest?) | [MONO-Q] | inwentarz |
| 17 | instytucja | filary, rozdzielacz kolejki, terminal | — | brak | inwentarz |
| 18 | instytucja | klinika, stół rejestratora, mapa | — | brak | inwentarz |
| 42A/B/C | finały | wspólna komora, trzy osie materiałowe | — | brak (tezy usunięte w CR-C) | inwentarz, winiety wyciszone |
| 43 | finał | — (kompozycja `_draw_finale_43`, do odczytu w wycinku 2) | — | — | inwentarz |

## Język miejsc (hipoteza robocza wycinka 1, do udowodnienia w 2)

- Zakład: głębokie płaszczyzny + wisząca lampa + bursztyn maszyny; sylweta: horyzont warsztatowy.
- Ulica: otwarte niebo ≥25% + fasada + publiczna głębia; sylweta: dach/horyzont.
- Klatka: niski sufit + lamperia + kinkiety; sylweta: pion schodów.
- Mieszkanie: ciepła wyspa na środku + ciemna głąb; sylweta: stół/blat.
- Instytucja: filary + rozdzielacz + terminal; sylweta: pion słupów.
- Komory anomalne: zwężone zatoki + jedna linia wiodąca; sylweta: korytarz.
- Finały: jedna komora, trzy osie materiałowe (A/B/C), cisza + jedno źródło.
- Reguła minimalna (nieudowodniona człowiekem): rodzina po sylwecie i działaniu,
  nigdy po napisie i nigdy wyłącznie po kolorze. [MONO-Q] dla 07/11/16.

## Dźwięk jako część obrazu (stan po wycinku 1)

- 01: `MachineHum` przy rejestratorze + `MartaMessageChime` (istniejący) — cykl
  ma źródło w kadrze. Kroki/lądowania/szczeble: 5 powierzchni (D-144), bez zmian.
- 06/08: brak dedykowanego dźwięku pracy kiosku/klatki; sprzedawca zamyka kiosk
  (tekst), ale nie słychać rolety; klatka nie ma dźwięku klucza poza linią.
  Kolejka wycinka 2: po jednym źródle na miejsce albo jawna decyzja o ciszy.
- Finały: trzy różne drony + cisza; po wyciszeniu podpisów winiet obraz nie
  konkuruje z dźwiękiem. Stingów paranormalnych przed stacją 05 brak (kontrakt).

## Winiety: które wzmacniają, które dubbingowały

- Wzmacnia: `vig_synthesis` (13) — czysty obraz, zero podpisu; tak mają
  wyglądać wszystkie.
- Dubbingowały (naprawione): `vig_threshold` (08), `vig_signal` (15),
  `vig_commit` (18), `vig_finale_a/b/c` — sentencja w głosie Leny streszczała
  scenę zamiast ją przedłużać. Po wyzerowaniu: obraz + cisza + skip bez zmian.
- Sloty i wyzwalacze bez zmian; treść scen nietknięta.

## Kolejka wycinka 2 (nie wynik tego pakietu)

1. Trzy kadry (pełny / bez tekstu / mono) dla 02–05, 07, 09–18, 42A/B/C, 43.
2. Martwy kod 05 (prostokąty poza kadrem) — wyciąć albo udowodnić.
3. Podwójny rysunek drabiny 07 (komentarz 9.3) — zmierzyć ≤2/1/2 px i 8–14 px.
4. Cienie kontaktowe i jedno źródło dźwięku na każde miejsce 02–05, 07, 09–18.
5. [MONO-Q] 07/11/16: test monochromatyczny rodzin.
6. Donica 08 i rack 06: dać pracę albo usunąć.
7. Tekst 85/100/115% na nowych kadrach.
