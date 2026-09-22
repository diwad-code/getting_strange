# Audyt czytelności Rówień Vector-Stage — H-012

Status dokumentu: **ZAMKNIĘTY TECHNICZNIE — H-012 UNTESTED — PKG-0108**  
Data rozpoczęcia: **2026-08-24**  
Zakres: techniczny raster Godot 4.7, bez playtestu i bez wnioskowania o
odbiorze człowieka.

## Cel i granica dowodu

Audyt sprawdza, czy bieżący render dostarcza powtarzalnego materiału do oceny
materialnej, nieglitchowej korekty w logicznym viewportcie `640×360`. Mierzone
są piksele, położenie, relatywny kontrast i zachowanie rastera po transformacji;
żaden wynik nie będzie opisany jako dowód funu, emocji, zrozumienia fabuły ani
czytelności przez nową osobę.

Getting Strange pozostaje projektem Godot 4.7-only. Audyt nie zmienia scen,
colliderów, InputMap, fizyki 60 Hz, logiki kampanii, limitu 25 ani schematu
zapisu 1.

## Plan zapisany przed zmianą kodu

### Zestaw kadrów

| Grupa | Źródło | Powód włączenia |
|---|---|---|
| początek | `scenes/levels/station_01.tscn` | pierwszy kadr pomiaru i droga bazowa |
| środek / kotwica | `scenes/levels/station_14.tscn` | materialna rysa, koszt i akcent korekty |
| środek / Uległość | `scenes/levels/station_22.tscn` | bramka tożsamości i lokalna reguła przejścia |
| plaster mechaniczny | `scenes/levels/station_38.tscn` | śluza ratunkowa R3 i akcent stanu |
| komora wyboru | `scenes/levels/station_41.tscn` | trzy konsole i droga do decyzji |
| finał A | `scenes/levels/station_42a.tscn` | świeży kadr Powrotu |
| finał B | `scenes/levels/station_42b.tscn` | świeży kadr Uzgodnienia |
| finał C | `scenes/levels/station_42c.tscn` | świeży kadr Świadectwa |
| epilog | `scenes/levels/station_43.tscn` | świeży kadr napisów i wygaszenia |

Każda scena dostanie świeży kadr świata bez panelu CRT oraz, dla
reprezentatywnego początku, środka i finału, osobny kadr z widocznym panelem
CRT. Położenia pomiarowe są jawnie zapisane w narzędziu i raporcie wynikowym;
nie są odczytywane z nazwy pliku ani z oczekiwania autora.

### Elementy mierzone osobno

1. droga przejścia, wyprowadzona z aktualnych colliderów przez
   `VectorStageStyle.draw_play_plane()`;
2. materialny akcent korekty, jeśli scena go posiada;
3. punktowy akcent stanu, np. cyjan, cynober lub bursztyn;
4. panel i ramka CRT w kadrze UI;
5. granica planu / krawędź głównej płaszczyzny;
6. sylwetka Leny jako maska bursztynowo-ciemna w kadrze świata.

Dla każdego wykrywalnego elementu narzędzie zapisze: liczbę pikseli maski,
`x/y`, szerokość i wysokość obwiedni, centroid oraz kontrast względem lokalnego
otoczenia. Brak maski w danym kadrze zostanie zapisany jako `ABSENT`, a nie
zamieniony na domniemanie obecności.

### Jednostki i metoda

- Jednostką wielkości i położenia jest logiczny piksel rastera `640×360`.
- Maski korzystają z jawnego koloru docelowego palety Vector-Stage oraz
  tolerancji kanału zapisanej w narzędziu; piksele antyaliasingu nie są
  dopisywane ręcznie. Dla półprzezroczystych linii narzędzie zapisuje jawny
  tryb `oxide_family`, `cyan_family` albo `amber_family`, który mierzy rodzinę
  barwy po kompozycji z tłem zamiast udawać, że wynik musi zachować dokładny
  kolor źródłowy.
- Luminancja jest liczona z kanałów sRGB po konwersji do liniowego RGB:
  `0.2126R + 0.7152G + 0.0722B`.
- Kontrast lokalny jest zapisywany jako iloraz `(Lmax + 0.05) / (Lmin + 0.05)`;
  otoczenie stanowi ten sam prostokąt pomiarowy po odjęciu maski. Jest to
  pomiar rastera, nie ustalony próg odbiorczy.
- Obwiednia i centroid są liczone z pikseli maski; droga ma dodatkowo kontrolę
  zgodności z kolorem krawędzi planu gry.

### Skale i transformacje

Każdy świeży kadr świata zostanie zapisany w oryginale oraz jako:

- skala całkowita `1×`, `2×`, `3×`, `4×` z interpolacją najbliższego sąsiada;
- `grayscale` — transformacja techniczna do wspólnej luminancji;
- `deuteranopia` i `protanopia` — techniczne macierze symulacyjne opisane
  w nagłówku narzędzia;
- każda transformacja pozostaje w logicznym rozmiarze, a skale są zapisane
  osobno, aby można było powtórzyć kontrolę bez filtrowania.

Narzędzie policzy także `nearest_neighbor_mismatch`: liczbę pikseli, które po
skalowaniu nie odpowiadają dokładnie pikselowi źródłowemu. Dla poprawnej skali
całkowitej oczekiwany wynik techniczny wynosi `0`; nie jest to próg H-012.

### Reguła interpretacji

Specyfikacja wizualna definiuje hierarchię i obowiązek kontrastu, ale nie
definiuje liczbowego progu, przy którym można twierdzić, że nowa osoba odczyta
stan. Audyt nie ustanawia takiego progu z własnej intuicji. Raport końcowy
rozdzieli:

1. obserwację z pliku PNG;
2. wynik obliczenia;
3. decyzję produkcyjną o ewentualnej minimalnej korekcie;
4. nierozstrzygniętą hipotezę odbiorczą.

Jeśli pomiar nie obejmie całego kontraktu albo pozostanie niejednoznaczny,
H-012 zostaje `UNTESTED`. Sam plik PNG, automatyczny test ani obejrzenie przez
autora nie awansują go do `SUPPORTED`.

## Baseline przed edycją

Komenda:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Wynik z 2026-08-24: **PASS, exit code 0, `Verification passed.`**
Przeszły kontrakty dokumentacji, import Godot, smoke projektu, lint traversal
oraz bramki `PKG-0095`–`PKG-0107`. Godot wypisał znane ostrzeżenia
`ObjectDB/RID leak` przy zamykaniu procesów; nie zmieniły kodu wyjścia.

## Stan pomiaru

Audyt wykonano narzędziem `tools/audit_h012.gd` w świeżym procesie Godot
4.7-stable, na normalnym sterowniku Windows/OpenGL Intel Iris Xe:

```powershell
godot_console.exe --path C:\getting_strange --script res://tools/audit_h012.gd
```

Wynik procesu: **`PKG-0108 AUDIT PASS: 12 frame captures, 63 raster
measurements, 48 scale checks`**, exit code 0. Zapisano dziewięć kadrów świata
(`station_01`, `14`, `22`, `38`, `41`, `42a`, `42b`, `42c`, `43`) oraz trzy
reprezentatywne kadry UI z widocznym CRT (`station_01`, `22`, `43`). Każdy kadr
ma PNG źródłowy, skale `1x`–`4x`, `grayscale`, `deuteranopia` i `protanopia`.
Łącznie zapisano 36 wariantów transformacji. Wszystkie 48 skal zachowały
wymiary `640×360`, `1280×720`, `1920×1080`, `2560×1440` i
`nearest_neighbor_mismatch = 0`.

Pełne dane maszynowe znajdują się w:

- `reports/pkg_0108/measurements.tsv` — 63 wiersze pomiarowe;
- `reports/pkg_0108/measurements.json` — pomiary, skale i wynik kontroli
  najbliższego sąsiada;
- `reports/pkg_0108/metadata.json` — viewport, wersja Godota, luminancja,
  tolerancja i macierze transformacji;
- `reports/pkg_0108/world/` oraz `reports/pkg_0108/ui/` — świeże PNG do
  ręcznej kontroli technicznej.

### Wyniki liczbowe

Wartości kontrastu są obserwacją rastera według metody z tego dokumentu, a nie
progiem akceptacji H-012:

| Element | Zakres w 9 kadrach świata | Dodatkowa obserwacja |
|---|---:|---|
| droga | `2.46–3.13` | maska obecna w każdym kadrze, dolny pas `y=260` albo `266` |
| granica planu | `1.88–3.75` | maska obecna w każdym kadrze |
| materialny akcent korekty | `1.08–5.85` w 8 kadrach | `42A` ma `ABSENT` w zdefiniowanym regionie; to nie jest domniemanie obecności |
| punktowy akcent stanu | `1.49–6.80` | maska obecna w każdym kadrze |
| sylwetka Leny | `3.14–4.36` | maska obecna w każdym kadrze |
| ramka CRT | `6.62–6.65` w 3 kadrach UI | obwiednia `x=28`, `y=247/248`, `584×91/90` |

Kontrola finałów, które były obowiązkowo świeże:

| Kadr | Korekta: piksele / obwiednia / kontrast | Stan: piksele / obwiednia / kontrast |
|---|---|---|
| `42A` | `ABSENT` | `595 / (430,211,174×34) / 6.22` |
| `42B` | `25 / (361,186,34×58) / 1.24` | `627 / (398,211,208×29) / 3.09` |
| `42C` | `64 / (520,223,84×6) / 3.26` | `281 / (163,100,282×29) / 2.57` |
| `43` | `62 / (324,231,32×2) / 1.81` | `11235 / (462,84,127×108) / 6.80` |

### Kontrola wizualna wariantów

Obejrzano wszystkie świeże kadry świata w oryginale, skali `4x`, skali
szarości, deuteranopii i protanopii. Obejrzano także trzy kadry UI CRT w tych
samych wariantach oraz reprezentatywne skale `4x` dla początku, środka,
`42C`, `43` i CRT. Transformacje zachowują geometrię drogi, planu, sylwetki,
akcentów oraz panelu; nie są dowodem odbioru przez człowieka.

W obserwacji technicznej droga pozostaje szeroką, ciągłą maską dolnego pasa,
a CRT ma stabilną, dużą obwiednię. W kilku kadrach cienkie akcenty korekty
mają niski lokalny kontrast (`22`, `38`, `41`, `42B`), natomiast inne akcenty
tej samej rodziny są wyraźniejsze. Jest to sygnał do dalszej decyzji
artystycznej, nie samoczynna podstawa do zmiany palety ani do ustanowienia
uniwersalnego progu.

### Decyzja H-012

PKG-0108 dostarczył powtarzalny, techniczny raster i ujawnił miejsca o
różnym kontraście, ale kontrakt hipotezy nie definiuje liczbowego progu ani
nie zawiera dowodu odbiorczego. Zgodnie z regułą zapisaną przed zmianą:

**H-012 pozostaje `UNTESTED`.**

Nie wykonano korekty scen, palety, geometrii, colliderów, InputMap, fizyki,
logiki kampanii, limitu `25` ani schematu zapisu `1`. Nie ma podstaw, by
opisywać wynik jako dowód czytelności dla nowej osoby, funu, emocji lub
zrozumienia fabuły.

Audyt jest zamknięty jako pakiet techniczny. Następny pakiet powinien podjąć
oddzielną decyzję o kosztach renderu/animacji albo zdefiniować jawny kontrakt
H-012; nie powinien awansować H-012 wyłącznie na podstawie tych PNG.
