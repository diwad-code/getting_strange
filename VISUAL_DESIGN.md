# Getting Strange — Rówień Pixel-Stage

Status: **AKTYWNY KANON RENDERERA P9; GRAMATYKA RODZIN LOKACJI DO PRZEBUDOWY W BUNDLE-04**  
Data: 2026-08-31  
Decyzje: ADR-006, ADR-008; specyfikacja renderowania:
`docs/PIXEL_PRESENTATION_ARCHITECTURE.md`

Rówień Pixel-Stage zachowuje czytelność przestrzenną i teatralną kompozycję
dotychczasowego Vector-Stage, ale zmienia powierzchnię obrazu: świat gry jest
renderowany jako celowo ograniczony 2D pixel-art, a wszystkie dialogi, myśli,
napisy użytkowe i UI pozostają ostre. Dotychczasowe sceny są materiałem do
ponownego autorstwa, nie wzorcem jakości.

## 1. Obietnica obrazu

Gra ma wyglądać jak precyzyjnie wyreżyserowany, niskorozdzielczy thriller, nie
jak gładkie wektorowe plansze przepuszczone przez losowy filtr. Każdy kadr ma
jednocześnie spełnić cztery warunki:

1. Lena jest rozpoznawalną osobą o czytelnej postawie i zamiarze.
2. Najbliższy cel przestrzenny da się odczytać z obrazu przed wyświetleniem
   podpowiedzi.
3. Dziwność narasta przez kontrolowane różnice, nigdy przez stały „glitch”.
4. Tekst pozostaje natywnie ostry i nie dziedziczy pikselizacji świata.

## 2. Hierarchia kadru

Każda przestrzeń ma maksymalnie trzy poziomy uwagi:

- **postać i zagrożenie bieżące** — najwyższy kontrast lokalny;
- **obiekt celu lub droga** — drugi, jednoznaczny akcent;
- **kontekst świata** — ograniczone detale, które budują miejsce i ciągłość.

Element, którego nie można sklasyfikować, jest szumem i powinien zostać usunięty
albo połączony z większą bryłą. Kompozycja używa mas światła i cienia, osi ruchu,
powtórzeń infrastruktury i kontrolowanych pustych pól.

## 3. Rozdzielczość i piksel

- Logiczny viewport projektu pozostaje `640x360`.
- Domyślna warstwa świata jest próbkowana do efektywnego rastra `320x180`
  (blok 2x2 w widoku logicznym), a następnie skalowana filtrem nearest.
- Dopuszczalne są wyjątkowe profile sceniczne po audycie (`213x120` lub
  `160x90`), ale nie wolno zmieniać skali w trakcie zwykłego ruchu bez znaczenia
  narracyjnego.
- Krawędzie świata lądują na siatce piksela kompozytora. Subpikselowe drżenie
  kamery, cienkie półprzezroczyste linie i przypadkowe wygładzanie są zakazane.
- Dithering jest projektowany jako kontrolowany wzór, nie nakładany globalnie.
- Tekst, ikony klawiszy, cel, menu i napisy końcowe są renderowane po
  kompozytorze w `640x360` lub wyżej na eksporcie.

## 4. Paleta i światło

Paleta sceny ma 8–16 funkcjonalnych barw świata, z maksymalnie dwoma kolorami
akcentu. Kolor nie jest dekoracją; ma rolę:

- grafit / głęboki granat — masa, cisza, obudowy infrastruktury;
- chłodny turkus — pomiar, obwód aktywny, techniczna możliwość;
- bursztyn — obiekt bieżącego działania i ciepło relacji;
- zgaszona czerwień — nieodwracalny koszt lub realne zagrożenie;
- brudna biel — światło publiczne, dokument, przestrzeń instytucjonalna.

Wczesne Station 01–05 mają stabilne źródła i codzienny kontrast. W 06–13 jeden
znajomy układ może mieć drobną różnicę barwną lub rytmiczną. W 14–20 rośnie
izolacja Leny w kadrze. Po 21 świat może ujawniać strukturę rezonansu, ale nie
zmienia się w nieczytelny efekt specjalny.

## 5. Lena jako osoba, nie znacznik

Zastany `LenaVisualRig` z PKG-0117 poprawnie oddziela prezentację od
`CharacterBody2D` i ma ludzką sylwetkę, ale nadal jest proceduralnym
placeholderem: świeży capture nie pokazuje jeszcze opisanych niżej key poses
ani ciężaru dorównującego protagonistce. PKG-0118 rozwija tę architekturę,
zgodnie z `docs/LENA_CHARACTER_AND_ANIMATION.md`.

- Wysokość wizualna Leny: docelowo 44–52 piksele logiczne przed kompozytorem,
  po audycie kamery i kolizji.
- Sylwetka ma głowę, szyję/barki, tułów, miednicę, osobne kończyny i czytelne
  punkty ciężaru.
- Strój terenowy: krótka kurtka robocza, spodnie techniczne, buty, torba lub
  czytnik jako rekwizyt pracy. Rekwizyty nie mogą stapiać się z kończynami.
- Twarz może być oszczędna, lecz kierunek głowy, szczęka i linia wzroku muszą
  czytelnie reagować.
- Animacja pokazuje start, przeniesienie ciężaru, krok, hamowanie, obrót,
  zawahanie i kontakt z obiektem — nie tylko zmianę położenia kolizji.

Odniesienie do `Another World` dotyczy wyłącznie ogólnych zasad: obserwowanego
ruchu ciała, redukcji do silnej pozy i krótkiej filmowej interpunkcji. Nie
kopiujemy proporcji, rotoskopowanych sekwencji, palety, kostiumu ani kadrów.

## 6. Eskalacja wizualnej dziwności

| Pasmo | Obraz | Niedozwolone skróty |
|---|---|---|
| 01–05 normalność | stabilna perspektywa, pełne rytmy, codzienny ruch | glitche, niemożliwe sobowtóry, ostrzegawcze czerwienie bez powodu |
| 06–09 niepokój | pojedyncza różnica w znanym wzorze | deformacja całego ekranu |
| 10–13 zmieszanie | dwa wiarygodne porządki w jednym miejscu | dosłowny portal lub „pęknięcie świata” |
| 14–17 lęk | długie osie, obserwujące urządzenia, izolacja w świetle | potwory, jump scare bez przyczyny |
| 18–20 upiorność | żywa osoba w niemożliwej relacji, perfekcyjna spójność | glitchowa twarz Jakuba sugerująca fałsz |
| 21 rozpoznanie | trzy źródła w jednym czytelnym kadrze | ekspozycyjny montaż objaśniający wszystko |
| 22–41 działanie | widoczne reakcje sprzężeń i koszty w przestrzeni | abstrakcyjny efekt bez stanu świata |
| 42–43 konsekwencja | konkretna, mała zmiana o dużym znaczeniu | „dobry/zły” kolor zakończenia |

Najsilniejsza groza przed 21 polega na tym, że świat wygląda prawidłowo i tylko
Lena do niego nie pasuje.

## 7. AI-Generated Look Suppression Rules

Te reguły obowiązują bez względu na źródło assetu:

- żadnych przypadkowych mikrodeta­li, „bogatych” tekstur bez funkcji ani
  dekoracyjnego szumu na każdej powierzchni;
- żadnej niespójnej grubości konturów, zmiennego kierunku światła i perspektywy
  między obiektami tej samej sceny;
- żadnych miękkich, malarskich krawędzi udających pixel-art po skalowaniu;
- żadnego automatycznego ditheringu na twarzy i stawach Leny;
- żadnych losowych napisów, pseudo-liter i symboli generowanych jako część
  grafiki; tekst powstaje w systemie typografii;
- żadnego „cyberpunkowego” neonu jako domyślnego sygnału science-fiction;
- żadnych przesadnych póz, które nie wynikają z masy, kierunku i emocji;
- żadnego assetu bez ręcznej korekty sylwetki, palety, siatki piksela oraz
  zgodności z sąsiednimi kadrami.

Generowanie może służyć jako szkic lub materiał referencyjny. Kanonem staje się
dopiero po świadomej adaptacji do model sheetu, palety i testu w ruchu.

## 8. Środowisko i rekwizyty

Każde pomieszczenie odpowiada jednym zdaniem na pytanie: „do czego służy to
miejsce, gdy Leny w nim nie ma?”. Maszyny poruszają się dlatego, że pracują.
Drzwi, lampy, pulpity i bariery pokazują stan przez kształt, światło, dźwięk i
ruch — tekst jest potwierdzeniem, nie jedynym nośnikiem.

Obiekty interaktywne mają trzy stany wizualne: przed zauważeniem, gotowy do
działania i zmieniony po działaniu. Akcent nie może stale pulsować jak znacznik
questu; pojawia się przez kompozycję lub krótką reakcję na uwagę Leny.

## 9. Tekst, dialog i interfejs

Wszystkie elementy z tekstem należą do ostrych warstw:

- dialog i myśl;
- cele, podpowiedzi i podpisy interakcji;
- tekst terminala, dokumentu, tablicy i szyldu, jeśli ma być czytany;
- menu, ustawienia, pauza, napisy oraz komunikaty systemowe.

Świat może zawierać nieczytelny kształt napisu jako element dalekiego tła, ale
po zbliżeniu treść musi być odtworzona w ostrej warstwie. `draw_string()` w
skrypcie poziomu pod kompozytorem jest zabronione dla nowej treści.

Myśli używają etykiety `LENA // MYŚL`, mniejszego obciążenia wizualnego niż
dialog i zachowują bezpieczne pole wokół sylwetki oraz celu.

## 10. Ruch kamery i filmowa interpunkcja

- Kamera służy czytelności ruchu i relacji przestrzennych; nie dryfuje stale.
- Zmiana kadru ma przyczynę: ujawnienie relacji, wejście maszyny, reakcja ciała,
  przejście przez próg.
- Krótkie animowane beaty trwają zwykle 0,4–2,5 s i nie odbierają kontroli
  dłużej, niż potrzebuje czytelna czynność.
- W ważnym momencie najpierw widzimy zdarzenie, potem reakcję Leny, na końcu
  ewentualny tekst.
- Wstrząs, aberracja i deformacja nie są domyślną gramatyką dziwności.
- **Kadr dialogowy** zjeżdża o 36 px, kiedy panel CRT prezentuje, i wraca po
  zamknięciu (D-133). Aktor wychodzi wtedy ponad panel, a górne martwe powietrze
  jest przycięte.
- **Kadr nigdy nie wychodzi poza malowaną scenografię** (D-136). Scena rysuje
  fartuch 40 px pod planem gry (`VectorStageStyle.STAGE_APRON`), a kamera
  klampuje offset dialogowy do tego, co faktycznie namalowane
  (`CinematicCamera.get_framing_budget()`). Fartuch to przedłużenie planu
  podłogi — scenografia bez collidera, nie nowy poziom gry. Podniesienie offsetu
  bez podniesienia fartucha nie da nic i tak ma być.
- **Struktura nadwieszona** (belka, wieszaki, kanał) wypełnia górę kadru na
  stacjach o płaskim profilu — 24 i 31–37. Zatrzymuje się na y=86, czyli nad
  pasem etykiet diegetycznych, i nigdy nie zastępuje ich kolejnym napisem.

## 11. Handoff produkcyjny

Najbliższy pakiet wizualny to PKG-0118, Foundation Slice 01–07 według kanonu
0.3. Musi dostarczyć:

1. produkcyjny `LenaVisualRig` i pełną pętlę ruchu dla tego wycinka;
2. `WorldPixelCompositor` z ostrymi warstwami tekstu oraz UI;
3. migrację wszystkich czytelnych napisów w 01–07 ponad kompozytor;
4. ponowne autorstwo kadrów 01–07 zgodnie z pasmem normalność → pierwszy
   niepokój;
5. świeże kadry świata, ruchu, dialogu i myśli do ręcznej inspekcji;
6. testy warstw, stanów animacji, flag narracyjnych i braku zakazanego tekstu.

Kolejne pakiety nie mogą produkować nowych scen na starym szkielecie postaci ani
omijać migracji tekstu. Szczegółowa kolejka jest w
`docs/CREATIVE_REBUILD_PLAN.md`.

## 12. Czego jeszcze nie zatwierdzono

- Ostatecznej wysokości i proporcji Leny po teście ruchu w 01–07.
- Ostatecznego model sheetu, liczby klatek i wariantów kierunku.
- Efektywnego rastra innego niż domyślne `320x180` dla późnych przestrzeni.
- Palet poszczególnych stacji po Station 07.
- Czy zmiana skali piksela w Podstrukturze poprawia znaczenie, a nie tylko efekt.
- Czy myśli pozostają czytelne bez zasłaniania działania.
- Czy nowy rytm obrazu faktycznie buduje niepokój i grozę; wymaga to ostrożnej
  inspekcji, a nie deklaracji testu automatycznego.
