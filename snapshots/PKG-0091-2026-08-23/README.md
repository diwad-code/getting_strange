# Getting Strange

Roboczy projekt filmowego puzzle-platformera 2D o rzeczywistosci, ktora
retrospektywnie poprawia ludzi i miejsca niezgodne z jej dominujaca wersja.

Projekt jest obecnie w fazie **Prototype 01: Movement Lab**. Ten etap ma
zweryfikowac ruch postaci przed rozpoczeciem produkcji grafiki, fabuly i
centralnej mechaniki Zakotwiczenia.

## Uruchomienie

Wymagany jest Godot 4.7.x.

```powershell
godot --editor --path C:\getting_strange
```

Scena prototypu uruchamia sie bezposrednio klawiszem F6/F5 albo poleceniem:

```powershell
godot --path C:\getting_strange
```

Sterowanie w movement labie:

- `A` / `D` lub lewy analog: ruch;
- `Spacja` lub dolny przycisk pada: skok;
- `R`: natychmiastowy restart od punktu startowego;
- `Esc`: zamkniecie prototypu.

## Weryfikacja

```powershell
pwsh -File .\tools\verify.ps1
```

Skrypt sprawdza kontrakt dokumentacji, importuje projekt bez interfejsu,
weryfikuje ustawienia i sceny, a nastepnie uruchamia test fizyki oraz
deterministycznego przejscia calego grayboxu.

## Dokumentacja

Nowa sesja zaczyna od:

1. [Indeks dokumentacji](docs/INDEX.md)
2. [Aktualny stan](docs/CURRENT_STATE.md)
3. [Prompt nastepnej sesji](docs/NEXT_SESSION_PROMPT.md)
4. [Aktywna specyfikacja Prototype 01](docs/PROTOTYPE_01_MOVEMENT_LAB.md)

Trwaly kierunek projektu:

- [Product brief](docs/PRODUCT_BRIEF.md)
- [Biblia projektu](docs/PROJECT_BIBLE.md)
- [Fundamenty researchu](docs/RESEARCH_FOUNDATIONS.md)
- [Roadmapa](docs/ROADMAP.md)
- [Kierunek techniczny](docs/TECHNICAL_DIRECTION.md)
- [Ryzyka i hipotezy](docs/RISKS_AND_HYPOTHESES.md)
- [Granice inspiracji](docs/INSPIRATION_BOUNDARIES.md)

Proces:

- [Workflow pakietow i sesji](docs/WORKFLOW.md)
- [Rejestr decyzji](docs/DECISION_LOG.md)
- [Dziennik pakietow](docs/SESSION_LOG.md)
- [Protokol playtestu](docs/PLAYTEST_01.md)

## Status

`Getting Strange` jest kryptonimem, nie zatwierdzonym tytulem handlowym.
Zakres pierwszego wydania: jednoosobowa gra premium na Windows i Linux,
sterowana klawiatura lub padem.

Aktywna praca pozostaje w `Prototype 01`. Zakotwiczenie, przeciwnicy, finalna
grafika i produkcja pelnej gry sa zablokowane do czasu przejscia bramki ruchu.
