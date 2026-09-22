# Lena Wolska — kierunek postaci i animacji 4.1

Status: **KANON PRODUKCYJNY 4.1 — PKG-0136 (D-129..D-131); baza 4.0 z PKG-0131/0132**

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


## 11. Lena 4.1 (PKG-0136) — co naprawiono i dlaczego

### 11.1 Diagnoza 4.0 z dysku

Właściciel nazwał ruch nie do zaakceptowania. Przemiar klatek i rigu 4.0
pokazał cztery niezależne defekty, wszystkie mierzalne:

1. **Kotwiczenie poziome po szerokości płótna.** Klatki 4.0 miały szerokości
   39–60 px, a `_apply_current_frame()` ustawiało `position.x = -drawn_w * 0.5`.
   Centroid sylwetki wewnątrz płótna wahał się od 13,0 do 23,1, więc biodra
   przeskakiwały do **7 px na klatkę** — 8% wysokości ciała.
2. **Niespójna linia stopy.** `footY` wynosił 80, 81 albo 86 zależnie od klatki.
   Postać zapadała się do 5 px w podłogę i wyskakiwała z niej co klatkę.
3. **Sześć „stanów” było tym samym plikiem co idle.** `start`, `stop`, `turn`,
   `seam_gesture`, `unease_reaction` miały identyczne metryki jak `idle.png`
   (opaqW 27, cx 13,0). Ruch nie miał antycypacji, hamowania ani obrotu.
   W pięcioklatkowym cyklu chodu `walk_2` też było pozą stojącą, więc chód
   zatrzymywał się co ~0,11 s.
4. **Stała kadencja 9 fps** niezależna od prędkości. Poślizg stóp w obie strony.

### 11.2 Kontrakt 4.1

- Wszystkie klatki na **jednym płótnie 64 x 104**, pivot wypalony offline:
  kolumna bioder na `x = 32`, linia gruntu na `y = 96`.
- Rig rysuje `scale = 1` i stałą pozycję. Zero arytmetyki per-klatka (D-129).
- Faza cyklu rośnie z dystansu **pokonanego**: `LenaVisualRig._sample_travel()`
  próbkuje własną pozycję światową rigu, krok chodu 42 px, krok biegu 48 px
  (D-130 co do stałych, D-137 co do źródła dystansu).
- `start` / `stop` / `turn` to nakładki prezentacyjne. Gameplay dalej widzi
  `idle/walk/run/jump_rise/jump_fall/land/climb`; `get_display_state_name()`
  pokazuje, co faktycznie leży na ekranie (D-131).
- Stany jednorazowe (`land`, skoki, `interact`, `examine`, reakcje) trzymają
  ostatnią klatkę zamiast zapętlać się.
- Obrót: squash osi x przez pivot w 0,12 s. Zewnętrzne ustawienie kierunku
  (spawn, capture) pozostaje natychmiastowe.
- Oddech: 1 px pionowego offsetu w cyklu 2,6 s dla stanów stojących.

### 11.3 Zestaw klatek 4.1

| Stan | Pliki | Uwaga |
|---|---|---|
| idle | `idle.png` | + oddech proceduralny |
| walk | `walk_0..3` | contact → down → pass → up |
| run | `run_0..3` | z klatką lotu |
| start / stop / turn | po jednej | osobne pozy, nie kopia idle |
| jump_rise / jump_fall | po jednej | |
| land | `land_0`, `land_1` | przysiad → wyjście z przysiadu |
| climb | `climb_0`, `climb_1` | cykl napędzany `velocity.y` |
| interact / examine | po jednej | |
| unease_reaction / seam_gesture | po jednej | |

Źródło: `gen-ai` (Picsart, Nano Banana Pro), pięć arkuszy po 4 klatki,
identyczność trzymana referencją obrazu. Normalizacja, keying tła, usuwanie
wysp i tłumienie boba wykonane offline i deterministycznie. Klatki źródłowe
4.0 leżą w `assets/characters/lena/_source_v40/` z `.gdignore`.

### 11.3a Poprawka 4.1.1 (PKG-0137): dystans pokonany, nie zamierzony

Pierwsza wersja 4.1 liczyła fazę z `|velocity.x| * delta`. To dystans, o który
ruch *poprosił*, a nie ten, który ciało faktycznie przebyło: `move_and_slide()`
odchyla wektor na pochyłości, a `try_curb_step()` podnosi ciało na krawężniku.
Sterowany playthrough zmierzył dryf 16–39 px na przebiegu 480 px na stacjach
07, 09 i 11 — stopa kontaktowa wyprzedzała podłoże dokładnie tam, gdzie profil
nie był płaski. Faza idzie teraz z realnego przemieszczenia rigu; skok większy
niż jeden krok biegu jest traktowany jako teleport (spawn, wczytanie sceny,
przypięcie do drabiny, narzędzie capture) i wraca do wartości z prędkości.

Skutek uboczny wart zapamiętania: **rig odłączony od poruszającego się ciała
nie animuje chodu.** Podgląd, który ustawia tylko `set_mechanical_state()`
i nie przesuwa węzła, zobaczy zamrożoną klatkę. To jest zamierzone — cykl ma
jedno źródło prawdy i jest nim podłoga.

### 11.4 Świadome ograniczenie

Cykl chodu ma **4 klatki, nie 8**. Model konsekwentnie zwracał drugą połowę
cyklu jako kopię pierwszej — z profilu obie nogi są tym samym ciemnym
granatem, więc różnica bliska/daleka noga i tak nie niesie informacji przy
87 px. Czterofazowy cykl (contact/down/pass/up) jest tu pełnowartościowy;
ośmioklatkowy pozostaje możliwym ulepszeniem, nie długiem blokującym.

---

## 12. Lena 4.2 (PHASE-08) — stany trawersu i progu

Status: **WDROŻONE DLA STOPNI, DRABINY I PROGÓW — PKG-0173 / PKG-0174 (D-188 / D-189 / D-190).**
Progi (`enter_door`, `board_vehicle`) są w `LenaVisualRig` i odtwarzane przez `ThresholdZone`.
Specyfikacja nadrzędna: `docs/rebuild/PRESENTATION_REPAIR_PLAN.md`,
kontrakt szczegółowy: `docs/rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md`.

### 12.1 Diagnoza 4.1 z runtime (2026-09-02)

Właściciel zgłosił dwa defekty animacji. Oba potwierdzone w kodzie.

**Defekt A — „cały czas się o coś potyka i dziwnie kuca”.**

`try_curb_step()` (`prototype_player.gd:460-481`) podnosi ciało o stałe
`MAX_CURB_STEP = 18.0` px niezależnie od wysokości przeszkody. Podstopnice
Station 08 mają 12 px, więc po każdym stopniu zostaje 6 px swobodnego spadku.
Przy `gravity = 720.0` i `fall_gravity_multiplier = 1.35` (972 px/s²) daje to
≈108 px/s, a próg reakcji lądowania to 80 px/s (`prototype_player.gd:282`).
Skutek na **każdym** stopniu: `play_landing()`, `_emit_landing_dust()` oraz
`_play_squash_stretch(Vector2(1.20, 0.80), …)` — pion ściśnięty do 0,80, czyli
widoczny przysiad. Między tym `set_mechanical_state()` widzi `grounded == false`
i wystawia `jump_fall` (`lena_visual_rig.gd:316-320`).

To nie jest błąd assetu. To jest błąd sposobu pokonywania stopnia, który
*wywołuje* poprawnie działającą reakcję lądowania w złym momencie.

**Defekt B — „na drabinie wisi w powietrzu, powinniśmy widzieć plecy”.**

Dwie niezależne przyczyny:

1. Station 02 ma dwie drabiny naraz — funkcjonalną `LadderZone` (y ∈ [224, 310])
   i ręcznie rysowaną w `station_02.gd` (y ∈ [162, 256]). Rozjazd 62 px przy
   87 px wzrostu Leny.
2. `climb_0.png` i `climb_1.png` to **profil boczny**. Postać na drabinie
   ustawionej prostopadle do kamery musi być widziana od tyłu.

### 12.2 Nowe stany 4.2

Wszystkie na tym samym płótnie 64 × 104 z pivotem (32, 96). Kontrakt 4.1
(zero skalowania per klatka, nearest, wypalony pivot) obowiązuje bez zmian.

| Stan | Pliki | Rodzaj | Uwaga |
|---|---|---|---|
| `step_up` | `step_up_0`, `step_up_1` | jednorazowy | noga na stopień → przeniesienie ciężaru. **Bez przysiadu.** |
| `step_down` | `step_down_0` | jednorazowy | kontrolowane zejście, bez lądowania |
| `ladder_mount` | `ladder_mount` | jednorazowy | obrót z profilu do widoku tylnego, chwyt szczebla |
| `climb_back` | `climb_back_0..3` | cykl | widok od tyłu, napędzany `velocity.y`, `CLIMB_RUNG_PX = 26.0` bez zmian |
| `ladder_dismount` | `ladder_dismount` | jednorazowy | zejście na podest, obrót z powrotem do profilu |
| `enter_door` | `enter_door_0..2` | jednorazowy | ręka na klamce → pchnięcie → krok w cień otworu |
| `board_vehicle` | `board_vehicle_0..1` | jednorazowy | krok w górę na stopień pojazdu, chwyt poręczy |

Stary `climb` zostaje jako fallback i nie jest już używany na trasie.

### 12.3 Reguły, których nie wolno złamać

1. **Stopień mierzy się, a nie zgaduje.** Podniesienie o stałą wartość jest
   przyczyną defektu A i wraca zakazem.
2. **Ruch po stopniu trwa 0,18–0,24 s** i jest interpolowany po łuku, nie
   wykonywany w jednej klatce fizyki.
3. **W trakcie kroku reakcja lądowania jest wyłączona** — flaga `_stepping`
   blokuje dźwięk uderzenia, kurz i squash. Dźwiękiem kroku jest zwykły footstep.
4. **`jump_fall` nie może pojawić się na schodach.** GATE-ANIM liczy jego
   wystąpienia i próg wynosi zero.
5. **Drabinę rysuje wyłącznie `LadderZone`.** Zgodność rysunku ze strefą:
   ≤2 px w pionie, ≤1 px w osi x.
6. **Limit 18 px wejścia bez drabiny (D-123) zostaje.** Zmienia się sposób,
   nie limit.
7. **Prezentacja nie dotyka fizyki ani hitboxa.** Kapsuła 72 × 8 i linia stopy
   bez zmian; różnica stopy wizualnej i dołu kapsuły dalej ≤2 px.

### 12.4 Pipeline klatek

Ten sam co 4.1 (§10 i §11.3): `gen-ai` z referencją tożsamości, jedna poza =
jedno wywołanie, `remove-bg`, normalizacja offline i deterministyczna, wypalony
pivot, import nearest. Dla ujęć tylnych (`climb_back`, `ladder_mount`,
`ladder_dismount`) kandydatem jest `picsart-qwen-image-edit-angle`
(zmiana kąta z zachowaniem postaci); alternatywnie `flux-kontext-pro` z klatką
`idle` jako referencją. Kryteria odrzutu: `docs/rebuild/CAST_AND_NPC_BIBLE.md` §7.
