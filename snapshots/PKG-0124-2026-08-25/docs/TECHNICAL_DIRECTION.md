# Kierunek techniczny

Status: **AKTYWNA BAZA 2.0 PO ADR-006**

## Platforma i silnik

- Godot 4.7.x stable;
- GDScript;
- pierwsze platformy: Windows i Linux;
- renderer `gl_compatibility` dla szerokiego zakresu komputerow;
- logiczny viewport 640x360 i integer scaling; świat przechodzi przez
  `WorldPixelCompositor` (domyślnie efektywne 320x180, nearest), a dialog,
  myśli, czytelne teksty i UI renderują się później w ostrej warstwie;
- fizyka 60 Hz;
- klawiatura i pad od pierwszego prototypu.

Cel wydania to wylacznie PC (Windows / Linux). Eksport mobilny i konsolowy nie
jest w zakresie. Zaden inny target dystrybucji nie jest w zakresie (D-098).

## Zasada architektury

Budujemy najmniejszy pionowy wycinek, ktory pozwala obalic biezaca hipoteze.
Nie tworzymy systemu "na cala gre", dopoki prototyp nie wykaze, ze dana
mechanika zasluguje na produkcje.

Preferencje:

- male, samodzielne sceny;
- typowane skrypty i semantyczne akcje `InputMap`;
- komunikacja lokalnymi sygnalami;
- dane konfiguracyjne w `Resource`, kiedy istnieja co najmniej dwa realne
  warianty lub potrzebny jest kontrolowany eksperyment;
- jawne stabilne identyfikatory dla danych zapisywanych;
- brak globalnego EventBus, service locatora i rozbudowanych singletonow bez
  konkretnej potrzeby.

## Docelowe granice modulow

Struktura bedzie rosla wraz z udowodnionymi systemami:

```text
autoload/             tylko prawdziwie globalne uslugi
scenes/player/        scena protagonisty i prezentacja
scenes/rooms/         samodzielne kadry gry
scripts/player/       ruch i stany protagonisty
scripts/gameplay/     Zakotwiczenie, interakcje, zagrozenia
scripts/narrative/    flagi i konsekwencje, nie tekst w kodzie scen
resources/            typowane dane i konfiguracje
assets/               zrodla uporzadkowane wedlug rodzaju
tests/                smoke, regresje i deterministyczne scenariusze
tools/                lokalne skrypty weryfikacji i produkcji
docs/                 prawda projektowa i handoff
```

**Aktualnie nie tworzymy pustych katalogow ani abstrakcji tylko po to, by
pasowaly do tej mapy.**

## Gracz

- `CharacterBody2D`, nie `RigidBody2D`;
- ruch przez `velocity` i `move_and_slide()`;
- coyote time, bufor i zmienna wysokosc skoku sa jawnie testowalne;
- reset zeruje predkosc oraz timery;
- parametry fizyki nie sa mnozone przez `delta` przed `move_and_slide()`;
- collider pozostaje prosty, a animowana sylwetka nie zmienia fizyki;
- `PrototypePlayer` pozostaje właścicielem fizyki, a produkcyjny
  `LenaVisualRig` jest dzieckiem prezentacji sterowanym adapterem stanu;
- rig używa jawnych stanów start/chód/bieg/stop/obrót/skok/lądowanie/interakcja/
  oglądanie/reakcja i nie opóźnia mechanicznej odpowiedzi wejścia;
- kamera statyczna jest domyslem dla jednego filmowego kadru.

## Przestrzenie

Prototype 01 moze uzywac prostych `StaticBody2D`. Produkcyjne pokoje powinny
oddzielac warstwe kolizji od finalnej kompozycji. TileMapLayer jest opcja dla
powtarzalnej geometrii, nie wymogiem dla kazdego recznie kadrowanego ujecia.

Kazdy pokoj docelowo powinien deklarowac:

- stabilny identyfikator;
- punkt wejscia i wyjscia;
- lokalne checkpointy;
- wymagane oraz modyfikowane flagi;
- lokalna regule i jej wizualna prezentacje;
- jawny stan restartu.

## Stan i zapis

Zapis kampanii już istnieje jako `GameStateManager` z `SAVE_SCHEMA_VERSION = 1`,
a ustawienia mają osobny `SETTINGS_SCHEMA_VERSION = 1`. Kontrolowana przebudowa
zachowuje te systemy, dopóki nowa treść nie wymaga jawnej migracji.

- pokoje i flagi używają stabilnych ID;
- stare flagi nie mogą ustawić `world_recognized` ani pominąć bramy Station 21;
- migracja ma fixture legacy i test idempotencji;
- checkpoint zapisuje minimalny stan deterministyczny, nie całe SceneTree;
- restart czyści lokalny GuidanceBeat i timery, ale zachowuje właściwy checkpoint;
- nie tworzymy nowego autoloadu, jeśli lokalny komponent lub istniejący manager
  wystarcza.

## Asset pipeline

**Projekt nie jest wersjonowany (D-016).** Git LFS nie obowiazuje. Dla assetow
binarnych oznacza to brak historii wersji i brak cofania: nadpisany `.aseprite`
albo WAV jest stracony. Zanim ruszy produkcja assetow, potrzebna jest decyzja o
sposobie przechowywania wersji zrodel - to jest otwarte ryzyko R-017, nie
rozwiazany problem.

- pliki zrodlowe `.aseprite`, WAV/FLAC, Blender i wideo trzymamy na dysku obok
  wyeksportowanych assetow, z jawna nazwa i data w nazwie pliku zrodlowego;
- Aseprite/Krita dla finalnych arkuszy Pixel-Stage i model sheetów; Inkscape,
  Blender lub własne `_draw()` mogą służyć jako blockout, maska albo źródło,
  lecz finalny świat musi przejść świadomą korektę siatki, palety i ditheringu;
- Blender opcjonalnie do blockoutu, referencji pozy i własnego materiału
  rotoskopowego; finalne klatki są przerysowywane do własnej geometrii;
- REAPER opcjonalnie do montazu i miksu;
- Picsart AI CLI (`gen-ai` w terminalu) jest uwierzytelnione i ma wysoki budżet
  kredytowy zaakceptowany do aktywnego wykorzystania przez właściciela
  (PKG-0093). Używamy `gen-ai image`, `edit-image`, `multi-image`,
  `vectorize`, `upscale`, `video`, `sfx` i `audio-from-text` do eksploracji
  moodboardów, referencji własnych kadrów, materiału dla pose sheets, bazowych
  rekwizytów oraz assetów pomocniczych;
- każda generacja użyta poza eksperymentem zapisuje: pełny prompt, model,
  datę, identyfikator joba/plik źródłowy, przeznaczenie i wynik kontroli IP w
  `docs/art/` lub wpisie pakietu; surowe wyniki są materiałem źródłowym,
  dopóki nie przejdą ręcznej adaptacji do Rówień Pixel-Stage;
- assety finalne musza miec znane autorstwo, licencje i plik zrodlowy;
- generowanie obrazow moze wspierac moodboard i eksploracje, ale surowy wynik
  nie powinien trafic do wydania bez swiadomego przerysowania i kontroli praw.

## Dostepnosc

Od poczatku zachowujemy:

- semantyczne akcje zamiast klawiszy w kodzie;
- mozliwosc pozniejszego remapowania klawiatury i pada;
- brak rozgrywki zaleznej wylacznie od koloru lub dzwieku;
- oddzielne ustawienia ograniczenia blyskow, drgan i przytrzymania;
- brak niepomijalnych QTE wymagajacych szybkiego spamowania;
- przyszle tryby pomocy nie moga blokowac fabuly ani finalu.

## Weryfikacja

Aktualna bramka `tools/verify.ps1`:

1. sprawdza kontrakt dokumentacji;
2. wykonuje import Godota w trybie headless;
3. odrzuca bledy skryptu nawet przy kodzie procesu 0;
4. uruchamia smoke test sceny, wejsc i fizyki;
5. potwierdza deterministyczna przechodniosc grayboxu.

Dla zmian wizualnych wymagany jest dodatkowo swiezy render przez
`tools/capture_preview.gd` ze zwyklym sterownikiem ekranu i rzeczywista
inspekcja obrazu.

### Kontrakt Rówień Pixel-Stage

- warstwa prezentacji nie zmienia `CollisionShape2D`, fizyki ani zasięgu
  interakcji;
- warstwy świata są kompozytowane przed `CrispDiegeticText`,
  `CrispGameplayUI` i `CrispSystemUI`;
- żaden czytelny tekst nie używa `draw_string()` pod kompozytorem;
- każdy kadr ma ograniczoną funkcjonalną paletę, duże masy, czytelne krawędzie i
  kontrolowany dithering zamiast automatycznego szumu;
- `LenaVisualRig` należy do świata i podlega tej samej siatce, ale zachowuje
  czytelną sylwetkę, stawy i kierunek głowy;
- przebudowany wycinek ma test warstw oraz świeże rendery świata, ruchu,
  dialogu i myśli ze zwykłym sterownikiem ekranu.

## Zaleznosci

Nie dodajemy pluginu, frameworka testowego ani middleware tylko dlatego, ze
moze przydac sie pozniej. Nowa zaleznosc wymaga:

- konkretnego problemu z aktywnej specyfikacji;
- sprawdzenia licencji i utrzymania;
- ADR-u, jesli wyznacza architekture lub jest droga do usuniecia;
- testu projektu bez ukrytego polaczenia sieciowego.
