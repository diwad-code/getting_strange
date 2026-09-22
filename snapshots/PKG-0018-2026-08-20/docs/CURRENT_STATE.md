# Aktualny stan projektu

Stan na: 2026-08-20

## Katalog i srodowisko

- Katalog: `C:\getting_strange`
- Godot: `4.7.stable.official.5b4e0cb0f`
- Platforma robocza: Windows, PowerShell 7
- Narzędzia generatywne: Picsart AI CLI (`gen-ai`, uwierzytelniony dostęp do generacji obrazów, wideo i audio)
- **Wersjonowanie: brak (D-016).** Pliki na dysku sa jedynym stanem projektu.
  Nie ma repozytorium, galezi, commita ani historii. Nie uruchamiamy `git`.
- Ostatni zamkniety pakiet: `PKG-0018`, 2026-08-20
- Kronika pakietow: `SESSION_LOG.md` - jedyna historia, append-only
- Zamrozenia: `snapshots/PKG-NNNN-DATA/` przez `tools/snapshot.ps1` (D-017);
  ostatnie: `snapshots/PKG-0018-2026-08-20`

Do PKG-0005 wlacznie projekt byl wersjonowany. W `PKG-0006` usunieto `.git`,
`.gitignore` i `.gitattributes`. Ta historia nie istnieje juz w formie
odtwarzalnej; kazdy stan sprzed `PKG-0006` jest opisany wylacznie w
`SESSION_LOG.md`. Nie powoluj sie na commity - nie da sie ich sprawdzic.

## Aktywna faza

Faza **`P2 / Prototype 02: Anchor Lab`** została **UKOŃCZONA** (Bramka P2 zaliczona w PKG-0018). Projekt jest gotowy do przejścia do fazy **`P3 / Vertical Slice`**.

Model dowodu calego projektu zmienil sie 2026-08-15. Zewnetrzne playtesty i
czytania stolikowe nie odbeda sie (D-012, ADR-003). Bramki P1, P2, P3 i N1
zostaly przepisane na pomiar obiektywny i audyt kontraktu. Kazda z nich
wymienia jawnie, czego nie sprawdza.

Prowadzenie kanonu, kierunku wizualnego i dokumentow zarzadczych zostalo w pelni przekazane sztucznej inteligencji (AI - Antigravity) jako Lead Programmer i Art Director (D-025, ADR-004), znoszac koniecznosc eskalacji, co nadpisuje D-018. Runtime, Prototype 02 i bramka P1 znajduja sie teraz pod wylaczna jurysdykcja AI.

Aktywna specyfikacja kreatywna:
`docs/narrative/NARRATIVE_BIBLE.md`

Specyfikacja prototypu runtime:
`docs/PROTOTYPE_01_MOVEMENT_LAB.md`

Dokumenty wykonawcze N1:

- `docs/narrative/FULL_STORY.md` — 43 przestrzenie w pieciu aktach (układ
  7/10/11/11/4 po N0.2-C);
- `docs/narrative/CONTINUITY_TRACKER.md` — poszlaki, stany i warunki finalow;
- `docs/narrative/DIALOGUE_SCRIPT.md` — glosy i 15 kluczowych scen dialogowych;
- `VISUAL_DESIGN.md` — rezyseria wizualna oraz handoff artystyczny.

## Potwierdzone jako istniejace

### Runtime

- Projekt Godot 640x360 uruchamia sceny prototypowe `scenes/prototype/movement_lab.tscn` oraz `scenes/prototype/anchor_lab.tscn`.
- `PrototypePlayer` uzywa `CharacterBody2D`.
- Ruch ma coyote time, bufor skoku, zmienna wysokosc skoku, szybsze opadanie
  i limit predkosci spadania.
- Profile A/B/C laduja sie z `resources/movement/`, a A zachowuje bazowe liczby.
- A/B/C roznia sie tylko czterema parametrami reakcji poziomej.
- Zaimplementowano moduł syntezy `ProceduralAudio` (`scripts/audio/procedural_audio.gd`) generujący 16-bitowe próbki PCM `AudioStreamWAV` dla:
  - zakotwiczenia (740 Hz), odkotwiczenia (660->310 Hz);
  - fali korekty (92->44 Hz) oraz oporu (587/622 Hz);
  - celu/synchronizacji (523/784 Hz);
  - kroków na posadzce laboratoryjnej/betonie (220/340 Hz tap) oraz blasze stalowej (1180/1860 Hz metallic chime);
  - lądowań (115/180 Hz impact thud z rezonansem);
  - ryglowania i uszczelnienia śluzy `Goal` (rezonans magnetyczny 330->880 Hz + hydrauliczny rygiel pneumatyczny).
- `PrototypePlayer` (`scripts/player/prototype_player.gd`) wzbogacono o autorską detekcję nawierzchni (`get_current_surface_type()`), akumulator dystansu kroków (`STEP_STRIDE = 24.0 px`) z naprzemienną wariacją tonu oraz dynamiczne udźwiękowienie lądowań zależne od prędkości opadania.
- Zaimplementowano klasę `AnchorableObject` (`scripts/interactables/anchorable_object.gd`) obsługującą stan A i stan B, opór przed falą korekty, synchronizację fizyki (`sync_to_physics`), precyzyjną kalkulację odległości do obwiedni prostokąta (`get_distance_to_point`), wizualne ramki/piny cyjanowe, przezroczyste zarysy alternatywnej rzeczywistości oraz wyspecjalizowane rysowanie opuszczanych bram żaluzjowych z prowadnicami stalowymi.
- Zaimplementowano `AnchorLab` (`scripts/prototype/anchor_lab.gd`) z zasadą pojedynczej aktywnej kotwicy, animowaną falą korekty, architekturą fundamentów i instalacji sufitowych, rozbudowaną stacją śluzy pomiarowej `Goal` z dynamiczną wiązką skanującą oraz obsługą wejść semantycznych `interact` (`E`) i `trigger_correction` (`F`).
- Wdrożono sekwencję ukończenia sektora i ryglowania śluzy w `AnchorLab`:
  - animacja zaryglowania barier laserowych i osi optycznej śluzy;
  - sygnał `sector_completed` oraz stan `is_sector_completed`;
  - telemetryczny panel instytucjonalny (`_draw_sector_transition_overlay`) z paskiem stabilizacji konsensusu i płynnym wygaszeniem (fade-out).
- Zaimplementowano `MovableAnchorableProp` (`scripts/interactables/movable_anchorable_prop.gd`) — fizycznie przemieszczana skrzynia laboratoryjna rozszerzająca `CharacterBody2D`: grawitacja (640 px/s²), pchanie przez gracza (PUSH_CONTACT_DISTANCE = 36 px, push_speed_max = 64 px/s), selektywne zakotwiczenie zamrażające prędkość, opór przed falą korekty konsensusu, deterministyczny `reset_to_spawn()`, cząsteczki i dźwięk proceduralny.
- Rysowanie `MovableAnchorableProp` wzbogacono o proceduralne laboratoryjne oznaczenia zgodne z `VISUAL_DESIGN.md`: stalowe okucia narożne z nitami (`#A8B2AC`), stencile identyfikacyjne, retikuł korelacyjny, diodę inspekcyjną konsensusu, boczne uchwyty transportowe i górne karbowanie trakcyjne.
- Scena `scenes/prototype/anchor_lab.tscn` zawiera pełny 3-komorowy kompleks o szerokości 1920 px z ciągłą, bezszczelinową geometrią traktu oraz dwie skrzynie laboratoryjne: `Chamber2Crate` (`Vector2(780, 306)`) na dolnym poziomie oraz `Chamber2CrateB` (`Vector2(1080, 186)`) na antresoli.
- Zaimplementowano `CinematicCamera` (`scripts/camera/cinematic_camera.gd`) obsługującą dyskretne kadrowanie komorowe 640x360, wygładzanie ruchu, wyprzedzenie horyzontalne oraz wygaszanie traumy wstrząsu ekranu po fali korekty.
- Wdrożono interfejs w świecie gry: konsole aparatury na ścianach komór z fizycznymi lampami obecności Leny (bursztyn), stanu konsensusu (cyjan/cynober) i blokady kotwicy (cyjan). Brak sztucznego HUD-u.
- Rozszerzono `tests/smoke_test.gd` o automatyczną weryfikację Test 1..5: pełne przejście od Komory 1 przez Komorę 2 (podnośnik, antresola) do rozwiązania sprzeczności przyczynowo-skutkowej Komory 3 (most zakotwiczony w Stanie A, brama otwarta w Stanie B), wejścia do śluzy `Goal` oraz pełnej sekwencji zaryglowania śluzy i zgłoszenia sygnału `sector_completed`.
- Wygenerowano zaktualizowane zrzuty kontrolne:
  - `reports/movement_lab.png`
  - `reports/anchor_lab.png`
  - `reports/anchor_lab_ch2.png`
  - `reports/anchor_lab_ch3.png`
  - `reports/anchor_lab_ch3_solved.png`
  - `reports/anchor_lab_ch3_locked.png`

### Kanon kreatywny 0.2

- Protagonistka to Lena Wolska, inzynierka aparatury korelacji prozniowej.
- Akcja rozgrywa sie przez jedna noc i poranek w Rowni, ktora pamieta lokalna
  wersje Leny zaginiona siedemnascie dni wczesniej.
- Rdzen relacyjny tworza Marta Kurek, zywy Jakub Wolski, dr Helena Wierzbicka,
  lokalna Lena jako Slad i Szymon Bera.
- UCP naprawde chroni wspolna historie i realnie ratuje ludzi, ale przenosi
  koszt sprzecznosci na slabo poswiadczone osoby i miejsca.
- Nie istnieje potwierdzona pierwotna galaz. Takze swiat Leny nosi slad korekty.
- Pelna historia ma 43 przestrzenie: Pomiar, Bledy zgodnosci, Korekta,
  Podstruktura i Sygnal powrotu. Akt II jest krotszy o dwie przestrzenie,
  a dowod dobra UCP trafia do Aktu I przed wezwaniem do Punktu 6.
- Trzy pelne rodziny zakonczen to Powrot, Uzgodnienie i Swiadectwo. Zadne nie
  zostalo oznaczone jako dobre, zle ani kanonicznie zwycieskie.
- Tracker wymaga co najmniej trzech poszlak przed kazdym duzym zwrotem i
  pilnuje wiedzy postaci, rekwizytow oraz warunkow finalow. Od `PKG-0007`
  obowiazuje regula pokrycia: wiersz bez cytatu z `FULL_STORY.md` jest zadaniem
  do napisania, nie zapisem stanu.
- Biblia dialogowa odroznia glosy i zawiera 18 scen niosacych glowne zwroty
  emocjonalne, w tym D-16, D-17 i D-18 dla przestrzeni 23, 34 i 39. W pliku
  jest 20 blokow, bo final D-15 ma trzy warianty A/B/C. Nie jest to jeszcze
  pelna lista linii implementacyjnych.
- Raport `docs/narrative/MECHANICS_AUDIT_H-002A.md` obejmuje wszystkie 43
  przestrzenie fizyczne; naglowki 42A–42C sa wariantami jednej przestrzeni.
- Zdarzenie na Linii 4 ma jeden rachunek kanoniczny (D-020): dwanascie nazwisk
  na tablicy odrzuconego wariantu, jedenascioro przeniesionych, jedno utrzymane
  ocalenie. Wierzbicka nie wie, dlaczego utrzymal sie akurat Jakub.
- Przejscie przenosi adres, nie materie (D-021). Cialo i rzeczy Leny sa jej
  wlasne; zmienilo sie to, co swiat o niej twierdzi.
- Gra ma porazke wykonawcza i nie ma porazki narracyjnej (D-019). Uleglosc
  zatwierdza sie wylacznie na granicy sceny.
- Wierzbicka nie umiera w zadnym zakonczeniu (D-022).
- `VISUAL_DESIGN.md` definiuje materialna, informacyjna korekte zamiast
  dekoracyjnego glitchu, palete, sylwetki, kluczowe kadry i test pionowego
  wycinka.

### Wyniki audytu kanonu 0.2 (2026-08-15)

Audyt wykonala sesja bez udzialu w tworzeniu materialu. To jest teraz jedyny
mechanizm kontroli jakosci narracyjnej (R-016).

Rozstrzygniete pomiarem, nie opinia:

- **H-010a: MEASURED po `PKG-0008`.** Ponowny pomiar po przenumerowaniu wykazuje
  trzy zapowiedzi spelniajace wszystkie cztery warunki (sceny 01, 14, 22)
  oraz dwie wspierajace (02, 10). Granica: warunek sciezki obowiazkowej jest
  proxy dla „dostrzegalne", nie dowodem zauwazenia. Zauwazenie to H-010b,
  trwale bez dowodu.
- **H-011a: MEASURED po `PKG-0008`.** Ponowny audyt policzyl cztery sygnaly
  porownawcze i wykazal **0 sygnalow przewagi strukturalnej** dla A, B i C:
  Swiadectwo jest zawsze dostepne, A, B i C maja domkniecia relacji
  Jakub-Wierzbicka, D-14 konczy sie cisza po pytaniu, a trzy epilogi maja ten
  sam obojetny rejestr administracyjny. Regula zlamanego fioletu pozostaje
  swiadomie wizualna i nie wchodzi do licznika. To pomiar kontraktu, nie odbioru.
- **H-002a: REFUTED po `PKG-0009` / PIVOT w ADR-005 (MEASURED w PKG-0011).** Audyt 43 przestrzeni policzyl 5
  odrebnych zastosowan: sceny 14, 20, 22, 33 i 41. Próg został zredukowany do 5. Bramka P2 zrealizowana i zaliczona.

Naprawione w `PKG-0007` - siedem sprzecznosci twardych:

- los Wierzbickiej w finale C (D-022: nie umiera nigdzie);
- rachunek Linii 4 (D-020: 12 nazwisk, 11 przeniesionych, 1 ocalenie);
- wiek Jakuba: 33 lata, smierc w wieku 20 lat trzynascie lat wczesniej;
- wariant instrumentalny finalu B: obowiazuje D-15B, Marta zostaje i odmawia;
- ostatni obraz finalu A: telefon do Marty Kurek;
- ostatni obraz finalu C: tramwaj, dwa tory, zapisany wybor;
- zegar: usunieto „mniej niz pol sekundy", prolog trwa do 22:30.

Dodatkowo zapisano regule 11 w `NARRATIVE_BIBLE` 7 (D-021) i rozstrzygnieto
stan przegranej (D-019).

Naprawione w `PKG-0008`:

- Swiadectwo jest zawsze dostepne; brakujace polaczenia obnizaja stabilnosc
  sieci i sa widoczne w epilogu, bez punktacji dobra;
- koszt finalu C przeniesiono na Slad: jego obecność rozprasza sie
  nieodwracalnie po wezłach zamiast pozostac osobnym glosem;
- domknieto relacje Jakub-Wierzbicka w A i B, usunieto dwie repliki D-14 i
  zostawiono cisze po pytaniu o odwrocenie glowy;
- ujednolicono rejestr trzech epilogow i wykonano jednorazowe przenumerowanie
  43 przestrzeni wedlug D-023: akt I 10, akt II 11, akt III 11, akt IV 4;
- H-010a zmierzono ponownie jako MEASURED (01, 14, 22), a H-011a jako
  MEASURED z wynikiem 0 sygnalow przewagi strukturalnej.

Otwarte, przypisane do kolejnych pakietow:

- `RESEARCH_FOUNDATIONS.md` nie zawiera zadnego zrodla o pamieci, zalobie,
  anomii ani psychologii instytucji - czyli o temacie gry;
- `INSPIRATION_BOUNDARIES.md` zabezpiecza wylacznie przed Another World i nie
  wspomina o Severance ani Control;
- D-014: bramka kanonu w `tools/verify.ps1` - przyjeta, niezaimplementowana.

## Ostatnia swieza weryfikacja

Komenda:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Potwierdzony wynik finalnej weryfikacji PKG-0018:

```text
DOCS PASS: 26 required files and handoff contracts
SMOKE PASS: project, scene, input and player physics
Verification passed.
```

Kontrakt dokumentacji obejmuje `ADR-001` do `ADR-005` oraz aktualne nagłówki. Bramka weryfikuje istnienie wymaganych dokumentów, brak wiszących placeholderów, poprawne ladowanie klas (`ProceduralAudio`, `AnchorableObject`, `MovableAnchorableProp`, `CinematicCamera`, `AnchorLab`, `PrototypePlayer`) oraz test automatyczny kamer, stref komorowych, syntezy dźwięków proceduralnych (w tym kroków na linoleum/metalu, lądowań i uszczelnienia śluzy), węzłów audio/cząsteczek, fizyki i logiki kotwiczenia (statycznej + wielu skrzyń ładunkowych) wraz z pełnym deterministycznym przejściem 3 komór i ryglowaniem śluzy `Goal` (Test 1..5).

Rendery kontrolne zaktualizowane:
- `reports/movement_lab.png`
- `reports/anchor_lab.png`
- `reports/anchor_lab_ch2.png`
- `reports/anchor_lab_ch3.png`
- `reports/anchor_lab_ch3_solved.png`
- `reports/anchor_lab_ch3_locked.png`

## Czego jeszcze nie potwierdzono

### Nie zostanie potwierdzone nigdy w tym projekcie

Zapisane jawnie, bo to sa twierdzenia, do ktorych projekt **nie ma prawa** i
nie wolno ich uzywac w zadnym dokumencie ani materiale bez etykiety braku
dowodu (D-012, ADR-003, R-015):

- czy ruch jest przyjemny i czy nowa osoba zaczyna bez instrukcji (H-001);
- czy gracz odczyta niezgodnosc swiata z akcji, bez ekspozycji (H-003);
- czy rzadkie zagrozenia utrzymaja napiecie przez 2-3 godziny (H-004);
- czy Uleglosc bedzie kuszaca, a nie odbierana jak zla opcja (H-006);
- czy brak HUD-u nie pogorszy czytelnosci stanu (H-007);
- czy Marta i Jakub uniosa rdzen emocjonalny - najdrozsze przyjete ryzyko
  projektu (H-008);
- czy UCP bedzie odbierane jednoczesnie jako skuteczne i krzywdzace (H-009b);
- czy zwrot zaskakuje (H-010b);
- czy kazdy final ma obroncow i rozpoznany koszt (H-011b).

### Mozliwe do potwierdzenia i jeszcze niezrobione

- czytelnosc kluczowych elementow w 640x360 na realnym renderze (H-012);
- rownowaga dowodow na skutecznosc i krzywde UCP w tekscie (H-009a);
- zmierzony koszt jednego finalnego kadru i animacji protagonisty (H-005) -
  jedyne kryterium rozstrzygajace o wykonalnosci calego projektu;
- H-011a jest zmierzone po `N0.2-C`; H-010a zmierzone ponownie po
  przenumerowaniu; H-002a ma status `MEASURED`.

### Nadal niewykonane

- 43 przestrzenie i 2-3 godziny nie maja budzetu produkcyjnego.
- Nie ma finalnych dialogow implementacyjnych, voice-overu ani lokalizacji.
- Nie sprawdzono tytulu handlowego ani praw przed publikacja.

## Znane ograniczenia techniczne i produkcyjne

- Automatyczne testy potwierdzaja kontrakty plikow, generowanie buforów audio, zachowanie kamery kinowej, grayboxu oraz logikę kotwiczenia, pchania skrzyń, pełnego przejścia 3 komór i ryglowania śluzy `Goal`, nie subiektywną satysfakcję (game feel) gracza.
- `DOCS PASS` sprawdza istnienie plikow i obecnosc naglowkow.
- Cofanie jest ograniczone do snapshotów (`tools/snapshot.ps1`).
- `AnchorLab` weryfikuje bazową mechanikę i opór obiektów (AnimatableBody2D i CharacterBody2D) w 3 pełnych komorach ze sprzężeniem audiowizualnym, kinową kamerą i przejściem do śluzy pomiarowej Goal.

## Nastepny pakiet

`PKG-0019: P3 Vertical Slice — Architektura pierwszej lokacji i integracja narracyjna`

Cel: Otwarcie prac nad Vertical Slice (P3): przygotowanie fundamentu sceny pierwszej lokacji (Instytut Korelacji Próżniowej / Stacja Pomiarowa), integracja subtelnych elementów narracyjnych (punkty rezonansu / ślady pamięci) w świecie gry bez naruszania zasady braku inwazyjnego HUD-u oraz przygotowanie szablonów interakcji dla wycinka pionowego.

Pakiet jest realizowany w 100% autonomicznie przez AI.

## Punkt przekazania

Nowa sesja zaczyna od swiezej weryfikacji (`tools/verify.ps1`), czyta `AGENTS.md`, `INDEX.md`, ten
plik i `NEXT_SESSION_PROMPT.md`, a nastepnie przechodzi do realizacji PKG-0019.
