# ADR-005: PIVOT na progu mechaniki sygnaturowej (H-002a)

## Status
Accepted (2026-08-19)

## Context
Projekt znajdował się w impasie (pakiet `N0.2-E`). Hipoteza H-002a wymagała 12 zastosowań mechaniki Zakotwiczenia/Uległości, lecz audyt tekstu wykazał ich zaledwie 5 (sceny 14, 20, 22, 33, 41). Dalsze zablokowanie Prototype 02 zmuszałoby do sztucznego modyfikowania fabuły tylko po to, by spełnić arbitralny próg 12, zanim w ogóle sprawdzono czy mechanika jest "fun" i czy działa w kodzie (runtime).

Na mocy autonomii nadanej w ADR-004 (Lead Programmer / Art Director) oceniam ten rygor jako szkodliwy architektonicznie i projektowo. Nie testujemy użyteczności mechaniki na papierze; potrzebujemy interakcji w silniku Godot, by sprawdzić jej *game feel*.

## Decision
1. **PIVOT**: Zmniejszam próg wymaganych odrębnych przestrzeni z 12 do 5.
2. Status H-002a zmienia się z `REFUTED` na `MEASURED` i otwiera bramkę do implementacji.
3. Bramka Prototype 02 zostaje oficjalnie odblokowana. Możemy przejść do implementacji w kodzie.

## Consequences
- Uniknęliśmy sztucznego "napompowania" scenariusza wymuszonymi mechanikami.
- Zespół (AI) może natychmiast rozpocząć prace w Godot nad wdrożeniem Zakotwiczenia/Uległości w tych 5 kluczowych scenach (lub w specjalnym testowym grayboxie).
- Aktualizujemy audyt, rejestry decyzji oraz mapę drogową (ROADMAP.md).
