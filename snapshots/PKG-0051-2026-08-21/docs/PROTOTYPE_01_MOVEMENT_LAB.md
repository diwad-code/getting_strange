# Prototype 01: Movement Lab

Status: aktywny

Zakres: maksymalnie dwa tygodnie

Cel: sprawdzic, czy samo poruszanie sie po filmowym kadrze jest czytelne,
responsywne i ma odpowiedni ciezar.

## Hipoteza

Postac moze wygladac na fizycznie ciezka, nie odbierajac graczowi kontroli,
jesli wejscie jest buforowane, przyspieszenie przewidywalne, a porazka nie
powoduje oczekiwania.

## W zakresie

- chodzenie i zmiana kierunku;
- coyote time 100 ms;
- bufor skoku 150 ms;
- zmienna wysokosc skoku;
- szybsze opadanie niz wznoszenie;
- jeden statyczny kadr z trzema rodzajami krawedzi;
- przepasc, natychmiastowy respawn i reczny restart;
- sterowanie klawiatura i padem;
- headless smoke test projektu i kontrolera.

## Poza zakresem

- Zakotwiczenie/Uleglosc;
- walka, przeciwnicy, skradanie i AI;
- finalne sprite'y, rotoskopia, dialogi i muzyka;
- zapis gry, menu, ustawienia i eksport sklepowy;
- ruchome platformy, chwytanie krawedzi, drabiny i wall jump.

## Plan zadan

### T1. Fundament projektu

**Kryteria akceptacji:** projekt otwiera sie w Godot 4.7.x, ma scene glowna,
rozdzielczosc 640x360, skalowanie calkowite i wejscia semantyczne.

**Weryfikacja:** import headless konczy sie kodem 0.

### T2. Pionowy wycinek ruchu

**Kryteria akceptacji:** gracz moze przejsc kadr od lewej do prawej, skok ma
bufor i coyote time, puszczenie przycisku skraca skok.

**Weryfikacja:** test fizyki potwierdza opadanie oraz kontakt z geometria;
nastepnie trzy reczne przejscia klawiatura i padem.

### T3. Porazka bez tarcia

**Kryteria akceptacji:** upadek i `R` przywracaja pozycje startowa bez zmiany
sceny i bez czasu oczekiwania widocznego dla gracza.

**Weryfikacja:** dziesiec kolejnych restartow daje identyczny stan ruchu.

### Checkpoint A: koniec dnia 2

- projekt importuje sie i uruchamia bez bledu parsera;
- cala trasa jest technicznie przechodnia;
- kod nie zawiera systemow przyszlej gry.

### T4. Strojenie bez animacji

Przygotowac trzy jawnie opisane zestawy parametrow ruchu i sprawdzic je na
tej samej geometrii. Nie zmieniac jednoczesnie geometrii i fizyki.

Kontrolowany eksperyment 01B:

- profile A/B/C maja identyczne `move_speed`, skok, grawitacje, coyote time,
  bufor, jump cut, geometrie i kamere;
- roznia sie tylko pozioma reakcja: przyspieszenie i wyhamowanie na ziemi oraz
  kontrola w powietrzu;
- tester nie widzi opisu ani identyfikatora profilu;
- facylitator wybiera profil przed startem i zapisuje zbalansowana kolejnosc
  A/B/C z `PLAYTEST_01.md`;
- harness nie wybiera zwyciezcy i nie jest dowodem game feel.

Stan techniczny harnessu 01B: **GOTOWY DO PLAYTESTU**.

Profile sa plikami `MovementProfile` w `resources/movement/`. Kod A/B/C jest
jedynym identyfikatorem widocznym dla facylitatora i nie jest wyswietlany w
grze. Profil A jest kontrola i zachowuje bazowe parametry ruchu z pakietu
`PKG-0001`; ich obowiazujace wartosci sa w tabelach ponizej oraz w
`resources/movement/`, nie w zewnetrznej historii.

Parametry wspolne dla A/B/C:

| Parametr | Wartosc |
|---|---:|
| `move_speed` | 96.0 |
| `jump_velocity` | -252.0 |
| `gravity` | 720.0 |
| `fall_gravity_multiplier` | 1.35 |
| `coyote_time` | 0.10 s |
| `jump_buffer_time` | 0.15 s |
| `jump_release_multiplier` | 0.45 |
| `max_fall_speed` | 360.0 |

Jedyna kontrolowana roznica:

| Profil | `ground_acceleration` | `ground_deceleration` | `air_acceleration` | `air_deceleration` |
|---|---:|---:|---:|---:|
| A | 900.0 | 1100.0 | 480.0 | 480.0 |
| B | 1400.0 | 1650.0 | 760.0 | 680.0 |
| C | 620.0 | 720.0 | 300.0 | 260.0 |

Hipotezy przed testem, niedostepne testerowi:

- A: kontrola zachowujaca dotychczasowa reakcje moze byc czytelnym punktem
  odniesienia bez skrajnej bezposredniosci lub bezwladnosci.
- B: szybsze rozpedzanie, hamowanie i korekta w powietrzu moga zmniejszyc
  liczbe upadkow oraz ulatwic precyzyjne ladowanie, ale moga byc odbierane jako
  nerwowe.
- C: wolniejsza reakcja moze wzmacniac wrazenie masy, ale moze tez zwiekszyc
  liczbe porazek przypisywanych sterowaniu.

Uruchomienie dla facylitatora:

```powershell
pwsh -NoProfile -File .\tools\run_movement_profile.ps1 -Profile A
pwsh -NoProfile -File .\tools\run_movement_profile.ps1 -Profile B
pwsh -NoProfile -File .\tools\run_movement_profile.ps1 -Profile C
```

Skrypt zapisuje wybrany kod w konsoli. `-CheckOnly` wykonuje techniczny start
bez okna playtestu. Nieprawidlowy kod jest odrzucany przed startem, a
bezposrednie `--movement-profile=<ID>` konczy gre kodem 2 i czytelnym bledem.
Brak argumentu wybiera A, aby zachowac dotychczasowe zachowanie sceny i smoke
testu.

**Kryteria akceptacji:** wybrany zestaw wygrywa w slepym porownaniu co najmniej
u 3 z 5 osob; zapisujemy powod wyboru, nie tylko numer wariantu.

### T5. Zewnetrzny playtest

Przeprowadzic ciche testy zgodnie z `PLAYTEST_01.md`. Tester nie dostaje
instrukcji przed pierwsza proba.

**Kryteria akceptacji:** 4 z 5 nowych osob zaczyna sie poruszac w 30 sekund,
4 z 5 dociera do konca kadru, nikt nie nazywa smierci "kara za sterowanie".

### Checkpoint B: bramka ruchu

- mediana pierwszego przejscia jest ponizej 90 sekund;
- restart jest ponizej 2 sekund;
- brak powtarzalnego slepego skoku;
- testerzy potrafia przewidziec zasieg skoku po trzeciej probie;
- znane problemy sa zapisane jako obserwacje, nie usprawiedliwienia.

## Decyzja po prototypie

- **PASS:** zamrazamy podstawowy model ruchu i budujemy Prototype 02 z jedna
  zagadka Zakotwiczenia.
- **ITERATE:** zmieniamy jeden parametr lub jeden fragment geometrii i
  powtarzamy test z nowymi osobami.
- **STOP/PIVOT:** jesli ruch wymaga stalego tlumaczenia albo nie daje sie
  pogodzic z filmowym tempem, zmieniamy model sterowania przed produkcja artu.
