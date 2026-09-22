# Workflow pakietow i sesji

Status: obowiazujacy kontrakt pracy

## Zasada nadrzedna

Kazdy skonczony pakiet pracy musi pozostawic projekt w stanie, ktory moze
przejac nowa osoba lub nowy model bez dostepu do poprzedniej rozmowy.

Dokumentacja, aktualny stan i prompt kontynuacji sa czescia wyniku pakietu,
nie porzadkami wykonywanymi opcjonalnie na koncu.

## Pojecia

### Sesja

Jedna rozmowa lub jeden ciag pracy modelu z aktualnym kontekstem.

### Pakiet pracy i Mega-Pakiet Wysokoprzepustowy (2x–5x)

- **Standardowy pakiet pracy**: Spójny, określony cel z kryteriami akceptacji, plikami, weryfikacją i decyzją końcową.
- **Mega-Pakiet Wysokoprzepustowy (High-Throughput Mega-Package, D-085)**: Tryb domyślny dla autonomicznego AI (Lead Programmer & Art Director). Obejmuje 2x do 5x większy zakres funkcjonalny realizowany całościowo w jednym cyklu:
  - Zamiast pojedynczych mikro-kroków, pakiet łączy 2–5 powiązanych systemów w pionowy wycinek (np. nowe autorstwo scen + `LenaVisualRig` + Pixel-Stage/ostry tekst + guidance + testy i rendery).
  - Praca postępuje płynnie krok po kroku bez przerw i bez oczekiwania na potwierdzenia.
  - Zapewnia 100% spójności architektonicznej i natychmiastowe ukończenie szerokich obszarów silnika gry.

### Duzy pakiet

Pakiet jest duzy, gdy zachodzi co najmniej jeden warunek:

- zamyka etap, checkpoint, prototyp lub istotna funkcje;
- wdraża wielomodułowy Mega-Pakiet (2x–5x) obejmujący audio, fizykę, CLI i dokumentację;
- zmienia architekture, centralna mechanike, kierunek narracji lub artu;
- obejmuje kilka dyscyplin, na przyklad kod, design i dokumentacje;
- tworzy nowy kontrakt, ktory bedzie obowiazywal kolejne pakiety.

Po duzym pakiecie rejestrujemy stan w `SESSION_LOG.md`, aktualizujemy `CURRENT_STATE.md`, generujemy nowy prompt w `NEXT_SESSION_PROMPT.md` i zamrażamy snapshot `tools/snapshot.ps1`.

## Start nowej sesji

Projekt nie jest wersjonowany. Nie ma repozytorium, galezi, commita ani
historii. Pliki na dysku sa jedynym stanem. Nie uruchamiamy `git`.

Nowy model wykonuje kolejno:

1. czyta `AGENTS.md`;
2. czyta `docs/INDEX.md`, `CURRENT_STATE.md` i `NEXT_SESSION_PROMPT.md`;
3. czyta aktywna specyfikacje oraz wymienione pliki kodu i testow;
4. raportuje model, srodowisko oraz ostatni pakiet `PKG-NNNN` z daty w
   `SESSION_LOG.md`;
5. uruchamia swieza, nieprzefiltrowana bramke bazowa;
6. porownuje wynik z handoffem;
7. przystępuje do autonomicznej realizacji w trybie Mega-Pakietu (2x–5x).

Handoff jest hipoteza o stanie projektu. Kod i swiezy runtime sa dowodem.

Bez wersjonowania nie ma wykrywania cudzych zmian ani cofania. Jesli bramka
albo tresc plikow przecza handoffowi, zapisz rozbieznosc w `SESSION_LOG.md`
przed jakakolwiek edycja. Nie odtwarzaj "poprzedniej wersji" z pamieci.

## Przed rozpoczeciem pakietu

- Zapisz cel i zakres Mega-Pakietu (obejmujący powiązane podsystemy 2x–5x).
- Powiaz pakiet z ryzykiem lub hipoteza, ktora ma sprawdzic.
- Ustal kryteria akceptacji oraz komende weryfikacji.
- Przeczytaj pliki, ktore beda modyfikowane, i ich testy.
- Porownaj tresc plikow z opisem w `CURRENT_STATE.md`.
- Nie nadpisuj cudzej pracy. Bez wersjonowania nadpisanie jest ostateczne.

## Podczas pracy

- Realizuj zadania w trybie wysokoprzepustowym (High-Throughput Mega-Batching 2x–5x).
- Wykonuj implementację modułów krok po kroku bez sztucznych przerw.
- Najpierw sprawdzaj ryzyko, potem dodawaj jakosc i wygode.
- Nie oslabiaj progow, testow ani kryteriow tylko po to, by uzyskac zielony wynik.
- Dbaj o jawnie zadeklarowany zakres PL/EN i zgodność kontraktu Godot przez pełną lub zakresową weryfikację (sekcja „Weryfikacja zakresowa (D-217)" poniżej).
- Nowa kosztowna decyzja wymaga wpisu w `DECISION_LOG.md` lub ADR-u.

## Weryfikacja zakresowa (D-217)

Pełny `tools/verify.ps1` (100+ bramek) jest wolny. Pakiet może zamknąć się
weryfikacją zakresową `tools/verify_scoped.ps1` (kontrakt dokumentacji +
jawnie wymienione bramki, ta sama polityka logów co pełna), ale wyłącznie
gdy spełnione są wszystkie trzy warunki:

1. blast radius pakietu nie obejmuje plików współdzielonych: `scripts/interactables/memory_resonance_point.gd`,
   `scripts/interactables/mrp_legacy_renderer.gd`, `scripts/core/game_state_manager.gd`,
   `scripts/audio/procedural_audio.gd`, `scripts/visual/world_pixel_compositor.gd`,
   autoloadów ani bazowych scen/kontraktów (lista rosnie wraz z ekstrakcjami);
2. pakiet nie zmienia enum, serialize IDs, routingu kampanii, progów stacji ani InputMap;
3. wpis `PKG-NNNN` w `SESSION_LOG.md` nazywa uruchomione bramki i jednym
   zdaniem uzasadnia, dlaczego pominięte obszary nie mogły zostać dotknięte.

Pełny `tools/verify.ps1` pozostaje obowiązkowy przy każdym dotknięciu pliku
współdzielonego, przy nowym kontrakcie, przy checkpoincie/release oraz co
najmniej raz na pięć pakietów. Dowód ostrożności: w PKG-0199 bramki zakresowe
(0189+0199) były GREEN, a pełna weryfikacja złapała realną regresję w PKG-0160
poza zakładanym blast radius (wycinek źródła `_draw_marta_witness_station`
przeniesiony do helpera; naprawa D-216). Szybciej wolno tylko tam, gdzie
pełna nie ma czego złapać.


## Obowiazkowy koniec kazdego pakietu

Pakiet nie ma statusu `DONE`, dopoki nie zostana wykonane wszystkie punkty:

1. **Kod i dane:** cel jest zrealizowany, a zakres poza pakietem pozostaje
   nietkniety.
2. **Weryfikacja:** uruchomiono swieze testy i zapisano rzeczywisty wynik —
   pełny `tools/verify.ps1` albo zakresowy `tools/verify_scoped.ps1` zgodnie
   z sekcją „Weryfikacja zakresowa (D-217)"; pakiet shared-touch zawsze pełną.
3. **Inspekcja:** zmiana wizualna ma swiezy render; zmiana gameplayu ma runtime
   lub playtest odpowiedni do twierdzenia.
4. **Stan:** zaktualizowano `CURRENT_STATE.md` wraz z ograniczeniami i rzeczami
   niewykonanymi.
5. **Plan:** zaktualizowano `ROADMAP.md` i aktywna specyfikacje, jesli zmienil
   sie status bramki.
6. **Wiedza:** zaktualizowano decyzje, ryzyka, hipotezy i research, jesli
   pojawil sie nowy dowod.
7. **Historia:** dopisano jeden wpis `PKG-NNNN` do `SESSION_LOG.md`. To jest
   jedyna historia projektu; wpis musi wystarczyc bez dostepu do rozmowy.
8. **Przekazanie:** zastapiono `NEXT_SESSION_PROMPT.md` promptem wynikajacym z
   aktualnego stanu, nie z planu sprzed implementacji.
9. **Dysk:** wszystkie zmiany sa zapisane na dysku natychmiast po wykonaniu.
   Nie zostawiamy pracy w buforze i nie odkladamy zapisu na koniec pakietu.
   Katalog nie zawiera przypadkowych plikow roboczych ani generowanego wyjscia
   podanego jako stan projektu. Na koniec pakietu wykonano snapshot:

   ```powershell
   pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-NNNN
   ```

   Snapshot jest zamrozeniem, nie kopia zapasowa: lezy w katalogu projektu,
   wiec nie chroni przed jego utrata (R-017).
10. **Raport:** finalna odpowiedz podaje wynik, testy, ograniczenia, numer
    pakietu i wskazuje nowy prompt.

## Definition of Done

Zmiana jest wykonana, gdy:

- spelnia kryteria aktywnej specyfikacji;
- nie wprowadza bledu importu, parsera ani runtime;
- ma test proporcjonalny do ryzyka;
- nie psuje sterowania klawiatura lub padem w obslugiwanym zakresie;
- dokumentacja opisuje stan faktyczny;
- znane ograniczenia sa jawne;
- nowy model ma jednoznaczny nastepny krok;
- stan na dysku i opis w `CURRENT_STATE.md` mowia to samo.

## Zawartosc dobrego promptu kontynuacji

Prompt musi byc samodzielnym blokiem i zawierac:

- role i cel nowej sesji;
- katalog projektu, silnik, platformy i aktywna faze;
- obowiazkowa kolejnosc czytania;
- komende bramki bazowej i oczekiwany numer ostatniego pakietu;
- potwierdzone fakty oraz niewykonane testy;
- jeden pakiet, elementy poza zakresem i zakazane skroty;
- pliki prawdopodobnie dotykane;
- kryteria akceptacji i pelna weryfikacje;
- obowiazek aktualizacji stanu, logu i kolejnego promptu.

Prompt nie moze opierac sie na zdaniu "kontynuuj poprzednia sesje". Nowy model
nie musi miec dostepu do tej sesji.

## Zmiana kierunku przez uzytkownika

Najnowsza instrukcja uzytkownika ma pierwszenstwo przed promptem i roadmapa.
Model powinien nazwac konflikt, zaktualizowac odpowiednie dokumenty i nie
udawac, ze stary plan nadal obowiazuje.
