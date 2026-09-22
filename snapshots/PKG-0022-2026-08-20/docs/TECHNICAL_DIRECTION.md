# Kierunek techniczny

Status: zaakceptowana baza, rozszerzana dopiero przez potrzeby prototypu

## Platforma i silnik

- Godot 4.7.x stable;
- GDScript;
- pierwsze platformy: Windows i Linux;
- renderer `gl_compatibility` dla szerokiego zakresu komputerow;
- logiczny viewport 640x360, integer scaling, nearest filtering;
- fizyka 60 Hz;
- klawiatura i pad od pierwszego prototypu.

Nie rozwijamy obecnie eksportu webowego, mobilnego ani konsolowego.

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

Nie implementujemy zapisu w Prototype 01. Gdy pojawi sie pierwsza trwala
konsekwencja:

- format otrzyma numer wersji;
- pokoje i flagi uzyja stabilnych ID;
- migracje beda testowane na fixture starego zapisu;
- checkpoint zapisze minimalny stan deterministyczny, nie cala SceneTree;
- `SaveService` moze zostac autoloadem dopiero wtedy.

Przewidywane maksymalnie trzy autoloady: `SaveService`, `AudioService` i
`SessionState`. To limit kierunkowy, nie lista do utworzenia teraz.

## Asset pipeline

**Projekt nie jest wersjonowany (D-016).** Git LFS nie obowiazuje. Dla assetow
binarnych oznacza to brak historii wersji i brak cofania: nadpisany `.aseprite`
albo WAV jest stracony. Zanim ruszy produkcja assetow, potrzebna jest decyzja o
sposobie przechowywania wersji zrodel - to jest otwarte ryzyko R-017, nie
rozwiazany problem.

- pliki zrodlowe `.aseprite`, WAV/FLAC, Blender i wideo trzymamy na dysku obok
  wyeksportowanych assetow, z jawna nazwa i data w nazwie pliku zrodlowego;
- Aseprite lub Krita dla finalnego pixel artu;
- Blender opcjonalnie do blockoutu lub materialu rotoskopowego;
- REAPER opcjonalnie do montazu i miksu;
- Picsart AI CLI (`gen-ai` w terminalu) dostepne z pelnym dostepem do generacji obrazow (`gen-ai image`), wideo (`gen-ai video`), muzyki i sfx (`gen-ai sfx`/`audio-from-text`) - do eksploracji moodboardow, referencji kadrów narracyjnych i podkladow;
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

## Zaleznosci

Nie dodajemy pluginu, frameworka testowego ani middleware tylko dlatego, ze
moze przydac sie pozniej. Nowa zaleznosc wymaga:

- konkretnego problemu z aktywnej specyfikacji;
- sprawdzenia licencji i utrzymania;
- ADR-u, jesli wyznacza architekture lub jest droga do usuniecia;
- testu projektu bez ukrytego polaczenia sieciowego.
