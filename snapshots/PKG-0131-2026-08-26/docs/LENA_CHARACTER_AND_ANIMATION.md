# Lena Wolska — kierunek postaci i animacji 4.0

Status: **KANON PRODUKCYJNY 4.0 — PKG-0131 (D-122); IMPLEMENTACJA W PKG-0132**

## 1. Diagnoza obecnego runtime

Właściciel (2026-08-25) nazwał obecną Lene tragiczną: nie wygląda jak kobieta
i wygląda jak krasnoludek względem otoczenia. To jest **prawda runtime**.

`scripts/player/prototype_player.gd` pozostaje właścicielem fizyki.
`scripts/player/lena_visual_rig.gd` nadal rysuje całą postać w `_draw()`:
sinus, fasy, kąty kończyn, prochowiec z wielokątów. CapsuleShape2D ma
wysokość 56 px i promień 6. Cień kontaktowy leży przy y=+26..+29, więc
cała figura mieści się w ~66 px. Przy meblach rysowanych jak sprzęt
laboratoryjny 1:1 z klatką 360 px Lena jest dzieckiem.

H-017 i D-117 (rig 3.0, 14 stanów, 1:6.7) są **TECHNICAL** i nie zamykają
tematu. Proceduralny `_draw()` zostaje `PLACEHOLDER` do wymiany.

PKG-0132 zastępuje rysunek autorskim sprite'em wygenerowanym przez
`gen-ai` (Picsart), przyciętym do Pixel-Stage, bez kopiowania Lestera
ani żadnej obcej gry. Fizyka zostaje oddzielona. Wysokość wizualna:
87 ± 3 px (`docs/WORLD_SCALE.md`).

## 2. Co bierzemy z obserwacji Another World

Dozwolone są ogólne zasady potwierdzone przez wypowiedzi Érica Chahiego:

- ruch obserwowany z życia, redukowany do czytelnych poz;
- duże, proste kształty sugerujące objętość zamiast opisywania detalu;
- krótka filmowa interpunkcja zespolona z gameplayem;
- rytm napięcie–oddech–przyspieszenie widoczny w ciele.

Nie kopiujemy klatek, proporcji, chodu, stroju, fryzury, pozy śmierci ani
sylwety Lestera. Materiał referencyjny Leny ma być nagrany lub pozowany od
nowa, a końcowe klatki przerysowane w języku Równi.

## 3. Rozpoznawalność Leny

Lena ma być czytelna jako konkretna 36-letnia inżynierka, nie neutralny avatar.

- wysokość obrazu w pozie stojącej: **87 ± 3 logical px** przed światową
  pixelizacją (D-126); collider kapsuły 72 × 16; meble według `WORLD_SCALE.md`;
- proporcje dorosłej kobiety 36 lat: biodra, talię, piersi, szyję, nie pacynkę;
- krótki klin ciemnych włosów, blizna podbródka w zbliżeniach, jasny szew na
  lewym rękawie i asymetryczna torba narzędziowa;
- dłoń i twarz pozostają ciepłym akcentem, ale nie są jedyną informacją o
  postaci;
- sylwetka musi odróżniać stanie, chód, bieg, przygotowanie skoku, lot,
  lądowanie, badanie i strach w jednobarwnym teście.

## 4. Architektura runtime

Docelowy podział:

- `PrototypePlayer` lub jego następca: wejście, fizyka, kolizje, reset, stan;
- `LenaVisualRig`: części ciała, odbicie kierunku, wariant kostiumu i
  przekazywanie parametrów;
- `AnimationTree`: jawny stan animacji oraz przejścia;
- `LenaAnimationState`: adapter od prędkości i zdarzeń gameplayowych do
  prezentacji, bez odczytywania klawiszy;
- `LenaPerformanceCue`: krótkie emocjonalne akcje wtórne wywoływane przez
  narrację, np. spojrzenie, zawahanie, gest szwu, cofnięcie dłoni.

Animacja nigdy nie przesuwa collidera root motionem. Fizyka jest prawdą
położenia, ale animacja może wyprzedzić zamiar i wybrzmieć po kontakcie.

## 5. Minimalny produkcyjny zestaw ruchu

| Stan | Wymagane pozy | Rytm docelowy | Informacja |
|---|---:|---:|---|
| idle | 4–6 | 1.6–2.4 s | oddech, ciężar na jednej nodze |
| start walk/run | 3–5 | 0.12–0.22 s | zamiar przed przesunięciem |
| walk | 8–12 | 8–10 fps | kontakt, obniżenie, mijanie, wybicie |
| run | 8–10 | 10–12 fps | mocniejszy skłon i faza lotu |
| stop | 4–6 | 0.16–0.28 s | hamowanie przez biodra i stopę |
| turn | 4–6 | 0.18–0.30 s | posadzona stopa, barki kończą później |
| jump takeoff | 3–5 | do 0.16 s | czytelne ugięcie bez opóźniania inputu |
| rise/apex/fall | 2+2+2 | stan fizyki | inna linia ciała w każdej fazie |
| land light/heavy | 4–7 | 0.18–0.36 s | ciężar i odzyskanie równowagi |
| interact low/mid/high | po 5–8 | zależne od celu | ręka naprawdę trafia w obiekt |
| examine | 6–10 | 0.6–1.2 s | wzrok, dłoń, dystans od znaleziska |
| seam gesture | 5–7 | 0.5–0.9 s | wewnętrzna niezgodność Leny |
| recoil/freeze | 4–8 | zależne od sceny | strach bez komicznego podskoku |

Liczby są budżetem startowym, nie poleceniem mechanicznego wypełniania klatek.
Pozę utrzymujemy dłużej, gdy znaczenie wymaga czytelności.

## 6. Progresja emocjonalna ciała

- **01..05:** ruch pewny, ekonomiczny; Lena dotyka aparatury bez szukania;
- **06..09:** krótszy krok po zatrzymaniu, jedno spojrzenie wstecz;
- **10..13:** badanie przedmiotów z dystansu, torba trzymana bliżej ciała;
- **14..17:** ciało broni przestrzeni, dłoń cofa się przed cudzym dotykiem;
- **18..20:** zamarcie i niepełny oddech zamiast melodramatycznej gestykulacji;
- **21:** świadome wyprostowanie po nazwaniu prawdy;
- **22..41:** kompetencja wraca, ale ruch ma koszt i ślady zmęczenia;
- **42..43:** warianty finału różnią się decyzją i gestem, nie filtrem koloru.

Secondary action może przeczyć słowom. Lena może powiedzieć „to tylko błąd”,
ale poprawić chwyt torby albo sprawdzić drogę za plecami.

## 7. Responsywność

- input kierunku i skoku nie czeka na zakończenie klatki animacji;
- start/stop/turn mogą blendować się lub zostać skrócone przy zmianie fizyki;
- różnica wizualnej stopy i collidera nie może wprowadzać w błąd co do krawędzi;
- squash-and-stretch jest dodatkiem do pozy, nie substytutem anatomii;
- kamera ma pozwolić rozpoznać sylwetkę, ale nie ukrywać obowiązkowej drogi;
- wszystkie stany muszą mieć deterministyczny debug override do capture'ów.

## 8. Handoff assetów

### Pozostaje proceduralne

- paleta, światło krawędzi, cień kontaktowy i krótkie efekty stanu;
- debugowe obrysy, punkty stawów i test sylwety;
- warstwa pixelizacji całego świata.

### Staje się autorskim assetem/pose data

- anatomia i kształt Leny;
- wszystkie kluczowe pozy, dłonie i profile głowy;
- kostium, torba, szew rękawa i gesty emocjonalne;
- osobne klatki reakcji narracyjnych.

Referencja ruchu może pochodzić z własnego nagrania, ale nie trafia bezpośrednio
do gry. Każda klatka jest redukowana do własnych płaszczyzn i proporcji.

## 9. Kryteria akceptacji pierwszego plastra

- w nieruchomym kadrze Lena czyta się jako człowiek i protagonistka;
- test sylwety rozróżnia co najmniej idle/walk/run/jump/land/examine/recoil;
- ruch ma start, kontakt, ciężar i odzyskanie równowagi;
- odwrócenie nie jest natychmiastowym lustrzanym przeskokiem całej bryły;
- nie skopiowano żadnej sekwencji z gry referencyjnej;
- capture'y zawierają arkusz stanów oraz Station 01..07 w 640x360;
- testy potwierdzają brak wpływu prezentacji na fizykę i hitbox;
- ocena techniczna nie jest opisywana jako dowód empatii lub jakości odbioru.

## 10. Pipeline Leny 4.0 (PKG-0132)

1. `gen-ai whoami` — potwierdź auth Picsart.
2. `gen-ai models` — wybierz model obrazu (nie wideo). Preferuj model z
   kontrolą póz / image-to-image, nie losowy photoreal.
3. Karta postaci (stała, nie dryfuje między pozami):
   36-letnia polska inżynierka, krótki klin ciemnych włosów, laboratorium
   IKP, jasny szew na lewym rękawie, asymetryczna torba, twarz dorosłej
   kobiety, biodra i talię, nie chibi, nie krasnoludek, nie Lester.
4. Wygeneruj osobno: idle, walk 4–8, run 4–6, jump_rise, jump_fall, land,
   climb, interact, examine. Jedna poza = jedno wywołanie. Zakaz siatek
   „model sheet” na jednej klatce.
5. `gen-ai remove-bg` na każdej klatce. Przytnij do tej samej stopy
   (baseline). Wysokość stojąca 87 ± 3 px w 640-przestrzeni.
6. Import Godot: nearest, no filter, no mipmaps, `assets/characters/lena/`.
7. `LenaVisualRig` rysuje `Sprite2D` / `AnimatedSprite2D`, nie wielokąty.
   Stany 14 nazw zostają. `_draw()` tylko cień kontaktowy, jeśli trzeba.
8. Capture Station 01: Lena obok krzesła i drzwi. Test dwóch klatek z
   `WORLD_SCALE.md` §4. Jeśli wygląda jak krasnoludek — odrzuć i powtórz.

Wolno użyć `gen-ai` także do mebli i tła, o ile paleta zostaje Rowien
Pixel-Stage (`VISUAL_DESIGN.md`) i skala spełnia tabelę.
