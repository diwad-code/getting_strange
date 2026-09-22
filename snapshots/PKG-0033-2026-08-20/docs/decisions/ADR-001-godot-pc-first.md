# ADR-001: Godot i PC jako pierwsza platforma

## Status

Accepted

## Data

2026-08-15

## Kontekst

Projekt potrzebuje dobrego workflow 2D, niskiego kosztu wejscia, kontroli nad
pixel-artowym obrazem i licencji odpowiedniej dla potencjalnej gry komercyjnej.
Pierwszy zespol moze byc jednoosobowy lub bardzo maly. Najwiekszym ryzykiem nie
jest brak funkcji silnika, lecz niezwalidowany game feel i koszt animacji.

## Decyzja

Uzywamy Godot 4.7.x stable oraz GDScript. Pierwszy zakres platform to Windows
i Linux. Bazowy viewport to 640x360, renderer `gl_compatibility`, fizyka 60 Hz.

## Rozwazane alternatywy

### GameMaker

Dobry workflow 2D i dojrzale narzedzia, ale dodatkowa licencja komercyjna oraz
mniejsza korzysc przy obecnym dostepie do Godota. Pozostaje alternatywa, gdyby
prototyp ujawnil konkretna blokade silnika.

### Unity

Duzy ekosystem i szerokie wsparcie platform, lecz wyzszy narzut projektu,
licencji i pipeline'u dla malej gry 2D. Nie rozwiazuje glownego ryzyka designu.

### Framework webowy

Latwe udostepnianie buildow, ale obecny produkt jest PC-first, wymaga stabilnej
fizyki, pada i lokalnego pipeline'u assetow. Web moze zostac rozwazony pozniej,
nie jest baza produkcji.

## Konsekwencje

- Silnik nie pobiera oplaty od przychodu, ale wymaga zachowania informacji o
  licencji w dystrybucji.
- Zespol uczy sie GDScript i scen Godota.
- Eksport konsolowy nie jest czescia obecnego planu.
- Zaleznosci i pluginy pozostaja minimalne.
- Zmiana silnika wymaga nowego ADR-u oraz dowodu, ze konkretna blokada jest
  drozsza niz migracja.
