# ADR-002: Produkcja otwierana przez dowody z prototypow

## Status

Accepted

## Data

2026-08-15

## Kontekst

Projekt ma ambitna wizje narracyjna, kosztowny styl animacji i centralna
mechanike, ktora jeszcze nie zostala przetestowana. Rozbudowany GDD albo duza
architektura nie udowodniaja, ze najczestsza czynnosc gracza jest przyjemna.

## Decyzja

Rozwijamy projekt przez kolejne pionowe eksperymenty z jawna hipoteza i bramka:

1. Movement Lab potwierdza sterowanie.
2. Anchor Lab potwierdza centralna mechanike.
3. Vertical Slice potwierdza polaczenie mechaniki, narracji, artu i audio.
4. Dopiero potem otwieramy produkcje pelnej gry.

Zautomatyzowany test moze potwierdzic techniczna poprawnosc, ale twierdzenia o
czytelnosci, emocji i zabawie wymagaja nowych testerow.

## Rozwazane alternatywy

### Pelny GDD przed prototypem

Pomaga uporzadkowac wizje, lecz zwieksza koszt porzucenia zlej mechaniki i
tworzy falszywe poczucie pewnosci. Odrzucone jako glowny proces.

### Od razu vertical slice

Daje atrakcyjny material, ale miesza game feel, mechanike, animacje i fabule.
Nie wiadomo wtedy, ktory element powoduje porazke. Odrzucone przed P1 i P2.

### Produkcja rozdzialu pierwszego

Tworzy duzo tresci przed poznaniem kosztu jednego finalnego kadru oraz wartosci
Zakotwiczenia. Odrzucone jako zbyt ryzykowne.

## Konsekwencje

- Tempo pierwszych tygodni moze wygladac wolniej, ale redukuje koszt reworku.
- Kazdy prototyp ma specyfikacje, protokol testu i decyzje PASS/ITERATE/PIVOT.
- Systemy przyszlej gry nie wchodza do prototypu bez potrzeby eksperymentu.
- Po duzym pakiecie aktualizujemy dokumentacje i przekazujemy prace nowej sesji.
