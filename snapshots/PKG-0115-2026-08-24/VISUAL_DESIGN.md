# Getting Strange — Biblia wizualna: Rówień Vector-Stage

Status: **KANON PRODUKCYJNY 1.0 — PKG-0093**
Data: 2026-08-23
Zakres: obraz gry Godot 4.7, 640×360, 43 przestrzenie, UI diegetyczne i postacie.

## 0. Decyzja kierunkowa i granica inspiracji

Docelowy wygląd Getting Strange to własny **Rówień Vector-Stage**: niskokolorowy,
kinetyczny obraz z dużych płaszczyzn, czytelnych sylwetek i filmowego bocznego
kadru. Punkt odniesienia stanowi ogólna dyscyplina platformówek kinowych, w tym
historyczna technika płaskich wielokątów i oszczędnej animacji kojarzona z
*Another World / Out of This World* (Éric Chahi, 1991). Nie jest to polecenie
kopiowania stylu tej gry.

Getting Strange ma własną ekspresję: Rówień, IKP/UCP, instytucjonalny modernizm,
pamięć jako materialna niezgodność oraz paletę grafit–szałwia–bursztyn–cyjan–
cynober. Nie kopiujemy postaci, proporcji, palety, świata, scen, broni,
przeciwników, interfejsu, zagadek, ujęć ani sekwencji śmierci źródła. Pełne
reguły są w `docs/INSPIRATION_BOUNDARIES.md`.

## 1. Zdanie przewodnie i tagi

**Zdanie przewodnie:** kliniczny porządek, który nie potrafi utrzymać tej samej
wersji siebie — przedstawiony jako materialny teatr płaszczyzn.

- `#vector-stage-materiality` — każda rzecz ma 2–4 celowe płaszczyzny, nie
  gęstą teksturę lub przypadkowy gradient;
- `#composition-negative-space` — wolny obszar kadru jest miejscem wypartego
  świadka albo decyzji, nie dekoracyjną pustką;
- `#silhouette-before-detail` — postać, ryzyko i cel są czytelne po wartości,
  krawędzi i pozie przed detalem;
- `#observed-discontinuity` — anomalia zmienia relację materialnych brył poza
  spojrzeniem, nigdy nie jest losowym glitchem;
- `#institutional-stage` — architektura wygląda jak funkcjonalny IKP/UCP, a nie
  obca planeta, ruiny science-fiction lub cyberpunkowa dekoracja.

## 2. Hierarchia czytelności

Gracz w dwie sekundy ma rozpoznać bez HUD:

1. **Lenę:** bursztynową twarz/dłoń, ciemny płaszcz z jasną płaszczyzną i
   asymetryczną torbę narzędziową;
2. **regułę przestrzeni:** jedną dominującą relację brył, światła lub osi;
3. **ryzyko korekty:** cynobrową, zbyt gładką płaszczyznę albo zanik śladu
   używania — nie potwora i nie czerwony alarm na całym ekranie;
4. **świadka:** osobę, odbicie albo rekwizyt zachowujący inną wersję powierzchni.

Czytelność wynika z wartości i położenia. Kolor nie może być jedynym nośnikiem
stanu. Kamera nie chowa obowiązkowej drogi w czerni, mgle ani za światłem.

## 3. Gramatyka Rówień Vector-Stage

### 3.1 Płaszczyzna i kontur

- Tło budujemy od dużych pól: daleki plan, środkowa architektura, podłoga,
  jedna sylweta funkcjonalna i detal informacyjny.
- Jedna bryła ma zwykle 2–4 płaszczyzny; ważny rekwizyt 3–6; postać w pozie
  bazowej maksymalnie 9. Mniejsza liczba jest preferowana, jeśli zachowuje sens.
- Kontur ma 1–2 logical px i jest ciemniejszą odmianą lokalnego koloru, nie
  czarnym komiksem wokół wszystkich powierzchni.
- Architektura używa ciętych trapezów, klinów i pól perspektywy. Obłe formy są
  wyjątkami dla szkła, manometru, twarzy albo światła.
- Zakazane: fotorealistyczne materiały, dithering jako wypełniacz, szum AI,
  nadmiar linii panelowych, miękkie plastikowe gradienty i cząsteczki bez funkcji.

### 3.2 Kompozycja kadru

- Kadr boczny ma trzy głębokości: daleki plan (20–35% kontrastu), plan gry
  (najwyższa czytelność), przód kadru (tylko gdy prowadzi wzrok).
- W kadrze istnieje jedna dominująca oś: poziom procedury, pion urzędu, skos
  niepewności albo próg relacji. Nie łączymy wszystkich naraz.
- Negatywna przestrzeń zajmuje zwykle 25–45% kadru; wskazuje brak, wybór albo
  przyszłą zmianę, ale nie utrudnia skoku.
- Stan aktywny zmienia 1–2 relacje płaszczyzn, nie całą paletę lub layout.

### 3.3 Ruch i animacja

- Animacja opiera się na pozach: przygotowanie, ciężar, kontakt i odzyskanie
  równowagi. Interpolacja jest oszczędna.
- Rotoskopia może dawać referencję czasu i ciężaru, lecz klatka końcowa jest
  własną uproszczoną geometrią, nigdy kopiowaną sekwencją ruchu.
- Squash-and-stretch Leny jest krótki, podporządkowany ciężarowi i nie zmienia
  kolizji. Efekt nie zastępuje czytelnej pozy.
- Przejście fabularne to cięcie za filarem, wejście świadka, zmiana odbicia lub
  przesunięcie jednej bryły; nie błysk, RGB split ani datamosh.

## 4. Paleta i światło

Paleta `VectorStageStyle` jest kontraktem runtime, nie sugestią:

| Rola | Kolor | Zastosowanie | Zakaz |
|---|---|---|---|
| głęboki plan | `#121A24` | noc, wolna przestrzeń, rama | czerń ukrywająca drogę |
| plan daleki | `#1D2B37` | objętość pomieszczeń, podłoga | szczegół o wysokim kontraście |
| konstrukcja | `#344958` | IKP/UCP, płaszcz Leny, metal | sterylna biel sci-fi |
| światło/krawędź | `#82949A` | szkło, aparat, obrys | wypełnianie każdego obiektu |
| życie/Lena | `#D29A63` | twarz, dłoń, torba, dom | kolor łupu/celu |
| Zakotwiczenie | `#6CC4BF` | utrzymany parametr, odbicie | pełnoekranowa poświata |
| Korekta | `#BA625B` | koszt uzgodnienia | automatyczny sygnał zła |

Kadr używa 4–6 kolorów bazowych i najwyżej jednego akcentu stanu (cyjan albo
cynober) poza bursztynem człowieka. Światło ma źródło praktyczne. PointLight2D
wzmacnia narysowaną hierarchię, nie maskuje niedopracowanej kompozycji.
Mikro-flicker 100 Hz dotyczy źródła, nigdy całego ekranu.

## 5. Progresja pięciu aktów

| Akt | Kompozycja | Materiał | Zmiana Vector-Stage |
|---|---|---|---|
| Pomiar | symetria z pustym polem | szkło, stal, linoleum | 3 główne płaszczyzny i jedna niezgodność |
| Błędy zgodności | osie domknięte zbyt wcześnie | dom, papier, mokry asfalt | ciepłe facety ścierają się z IKP |
| Korekta | pion urzędu i progi | emalia, szkło, formularze | punktowy cynober, zanik śladów użycia |
| Podstruktura | warstwy, szyby, puste pola | beton, kable, para | racjonalne płaszczyzny o różnych osiach |
| Sygnał powrotu | jedna rama, trzy kierunki | poranek, tramwaj, fasada | relacje barw i odległości, nie filtr finałowy |

## 6. Postacie

### Lena Wolska

- Płaszcz ma dwie płaszczyzny grafitu/szałwii; głowa i dłoń są bursztynowe;
  torba po lewej jest stałą asymetrią.
- Krótkie włosy są jednym ciemnym klinem. Mały cyjanowy facet może oznaczać
  visor/odbicie, lecz Lena nie jest neonową astronautką.
- Gest paznokcia przy palcu zmienia linię dłoni, nie wymaga portretowego zbliżenia.

### Marta, Jakub, Wierzbicka, Ślad i Szymon

- Marta ma szerszą, poziomą sylwetkę; miarka i torba łamią piony instytucji.
- Jakub ma ciężar sprzętu nisko na biodrach; presja zamienia aktywną posturę w
  bezruch dużej płaszczyzny ciała.
- Wierzbicka jest zgodna z pionami UCP, a pęknięty zegarek jest małym ciepłym
  kontrapunktem.
- Ślad istnieje wyłącznie jako przesunięta pełna płaszczyzna w szkle, wodzie lub
  polerowanym metalu; nigdy jako hologram.
- Szymon jest miękką siedzącą bryłą; rysunek trzyma szeroko jak mapę.

### 6.1 Język świata i efektów

| Zjawisko | Obraz | Informacja |
|---|---|---|
| zmiana poza obserwacją | dwa układy tych samych płaszczyzn | świat ma regułę |
| Zakotwiczenie | cyjan utrzymuje krawędź/relację | parametr pozostaje własny |
| Uległość | cynober wygładza ślad używania | koszt to utrata różnicy |
| Ślad | odbicie kończy inny moment ruchu | istnieje drugi świadek |
| niebezpieczeństwo | szczelina, próg lub idealna bryła | zatrzymaj się i obserwuj |

Zakazane: RGB split, śnieg VHS, pikselowa korupcja, datamosh, losowe drżenie,
pełnoekranowe filtry, magiczne portale i cyberpunkowa siatka.

## 8. UI, tekst i dźwięk

- CRT Dialogue Box jest obiektem UI, nie wzorem całego świata: płaski panel
  luminoforowy z jednym bursztynowym/cyjanowym akcentem.
- Typografia diegetyczna jest techniczna i prosta; nie imituje rozpoznawalnego
  kroju lub logotypu zewnętrznej gry.
- Dźwięk potwierdza zmianę konkretnej bryły: jarzeniówka, pompa, szyny, szkło,
  rygiel. Nie dodaje triumfalnego stingu ani „glitch noise”.

## 7. AI-Generated Look Suppression Rules

Ten nagłówek pozostaje częścią kontraktu dokumentacji. W Rówień Vector-Stage
oznacza on następujące zasady wykonawcze:

- żadnych pozornie „bogatych” mikrotekstur, przypadkowych symboli, fałszywego
  tekstu, efektu olejnego, plastikowego połysku ani niezmotywowanych gradientów;
- żadnych wygenerowanych obrazów jako finalnej grafiki bez ręcznego przełożenia
  na własne płaszczyzny, funkcję fabularną i kontrolę praw;
- Picsart CLI `gen-ai` jest świadomie zatwierdzonym narzędziem produkcyjnym z
  dużym budżetem kredytowym: wolno generować wiele wariantów moodboardu,
  referencji pozy, materiałów, rekwizytów i kompozycji, aby wybrać najlepszy
  kierunek; nie wolno promptować o kopiowanie konkretnej gry, postaci, sceny,
  palety lub rozpoznawalnego kadru;
- wariant zaakceptowany do produkcji zachowuje prompt, model, datę i plik
  źródłowy, po czym jest ręcznie redukowany do własnej palety, płaszczyzn i
  funkcji Rówień Vector-Stage;
- każdy rekwizyt ma rozpoznawalną funkcję w scenie, a nie dekoracyjny zestaw
  kabli, ekranów i znaków; szczegół wynika z planu kadru;
- powtarzalność ma pochodzić z reguł IKP/UCP, a nie z automatycznego klonowania;
- wątpliwy detal usuwamy, gdy nie wspiera sylwetki, drogi, relacji lub stanu.

## 9. Implementacja Godot 4.7

- `scripts/visual/vector_stage_style.gd` to kontrakt palety, limitów i funkcji
  rysowania facetów.
- `scripts/visual/vector_stage_environment.gd` dostarcza tło pod geometrią gry;
  nie ma colliderów i nie steruje mechaniką.
- Rysowanie używa `_draw()`, `draw_colored_polygon()`, `draw_polyline()` i
  `queue_redraw()`. Zachowujemy `CharacterBody2D`, istniejące collidery i 640×360.
- `PointLight2D` oraz cząstki służą atmosferze tylko wtedy, gdy nie zasłaniają
  płaszczyzn i drogi.

## 10. Plan konwersji 43 przestrzeni

1. **PKG-0093:** `VectorStageStyle`, sylwetka Leny, pełny Station 01 i warstwa
   `VectorStageEnvironment` w Station 01..05.
2. **Akt I (06–10):** jedna oś i 3–5 dużych płaszczyzn w pokoju.
3. **Akt II–III (11–28):** systemy UCP jako proste bryły; poszlaki odróżnione
   wartością i geometrią, nie tylko tekstem.
4. **Podstruktura (29–41):** nakładające się osie i puste pola z jednoznacznym
   planem gry oraz limitem palety.
5. **Finale (42A–43):** różnica rodzin końców przez progi, płaszczyzny i poranek,
   nigdy przez „dobry/zły” filtr.

Każdy etap wymaga renderu kontrolnego, audytu kolorów/płaszczyzn, smoke testu i
aktualizacji dokumentacji. Nie deklarujemy ukończenia artu 43 przestrzeni przed
ręcznym przejściem tej listy.

## 11. Handoff produkcyjny

Przed rysowaniem kadru zapisz: funkcję fabularną, dominującą oś, obszar
negatywny, plan gry, maksymalnie sześć kolorów, akcent stanu i rekwizyt-świadka.

1. Kadr jest czytelny w 640×360 i w skali szarości, jeżeli niesie stan.
2. Używa własnej palety i ograniczonej liczby płaszczyzn.
3. Detal nie konkuruje z drogą, sylwetką ani funkcją narracyjną.
4. Nie zawiera szumu, mikrotekstury, dekoracyjnego glitche’u ani ekspresji
   kopiującej *Another World*.
5. Prezentacja nie zmienia kolizji, hitboxów, zasięgów ani ścieżki smoke testu.
6. Przechodzi import Godot, test sceny i świeży capture z inspekcją obrazu.

## 12. Czego jeszcze nie zatwierdzono

- budżetu ręcznej konwersji wszystkich 43 kadrów;
- finalnych pose sheets i liczby klatek pięciu postaci;
- finalnego kroju pisma, logotypu UCP i wszystkich portretów;
- dostępności kontrastu i ograniczeń migania poza technicznym kontraktem;
- odbioru game feel i czytelności przez nowych ludzi — automatyczne testy tego
  nie dowodzą.

To obowiązujący język produkcyjny, lecz nie twierdzi, że 43 przestrzenie zostały
przebudowane jedną zmianą. Stan wdrożenia i kolejność pracy opisują
`docs/CURRENT_STATE.md` oraz handoff.