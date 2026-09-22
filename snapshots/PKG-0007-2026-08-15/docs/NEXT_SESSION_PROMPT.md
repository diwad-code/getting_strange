# Prompt nastepnej sesji

Aktualny pakiet: `N0.2-C: Symetria finalow i struktura aktu II`

Ponizszy blok jest gotowy do przekazania nowej sesji lub innemu modelowi.

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange jako head writer,
script editor i redaktor ciaglosci, w pelnej roli wlascicielskiej (D-018).
Decyzje kanonu, struktury i redakcji podejmujesz samodzielnie i od razu, bez
statusu PROPOSED. Poza rola sa wylacznie: przeglad prawny, zobowiazania
budzetowe i konsultacja ekspercka przy tresciach klinicznych.

CEL SESJI
Zdejmij cztery pozostale sygnaly przewagi strukturalnej finalu Swiadectwo i
przebuduj srodek gry. Pakiet konczy sie ponownym pomiarem H-011a.

Nie prowadzisz czytania stolikowego ani playtestu. One sie nie odbeda (D-012,
ADR-003) i ich symulacja jest zakazana. Nie oznaczasz zadnej hipotezy jako
SUPPORTED. Hipoteze MIERZALNA wolno zamknac wylacznie jako MEASURED albo
REFUTED, z podana metoda i liczba.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\WORKFLOW.md
5. C:\getting_strange\docs\decisions\ADR-003-evidence-model-without-external-testers.md
6. C:\getting_strange\docs\RISKS_AND_HYPOTHESES.md
7. C:\getting_strange\docs\DECISION_LOG.md
8. C:\getting_strange\docs\narrative\NARRATIVE_BIBLE.md
9. C:\getting_strange\docs\narrative\FULL_STORY.md
10. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md
11. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md
12. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Projekt NIE jest wersjonowany (D-016). Nie ma repozytorium, galezi, commita
  ani historii. Nie uruchamiaj `git` i nie inicjalizuj repozytorium.
- Oczekiwany ostatni zamkniety pakiet: PKG-0007 z 2026-08-15, wedlug
  SESSION_LOG.md.
- Runtime nadal jest w P1 i nie jest prowadzony; ten pakiet go nie dotyka.

Przed edycja pokaz i ocen pelny wynik:
  pwsh -NoProfile -File .\tools\verify.ps1

Nie filtruj wyjscia. Zielona bramka sprawdza istnienie plikow i graybox; nie
sprawdza spojnosci kanonu. Zadnej z siedmiu sprzecznosci naprawionych w
PKG-0007 nie wykryla.

Cofanie siega jednego pakietu wstecz (R-017). Przeczytaj caly plik przed
zastapieniem go, zapisuj kazda skonczona zmiane natychmiast i nigdy nie
odtwarzaj tresci z pamieci zamiast z dysku. Ostatnie zamrozenie:
snapshots\PKG-0007-2026-08-15. Nie edytuj snapshotow i nie czytaj ich jak
aktualnego stanu.

ZADANIE 1: CZTERY SYGNALY PRZEWAGI FINALU C
H-011a jest REFUTED. Swiadectwo mialo piec sygnalow, ktorych Powrot i
Uzgodnienie nie maja. D-022 zdjal szostego kandydata. Zostaly cztery:

1. Jedyny final warunkowy. Wdroz D-015: Swiadectwo jest zawsze dostepne, a
   brakujace polaczenia obnizaja jakosc wyniku zamiast blokowac wybor. Sciezka
   bez zbudowanych polaczen daje wersje niestabilna - siec powstaje, ale
   dzielnice bez swiadkow traca ciaglosc i widac to w epilogu. Interfejs
   pokazuje brakujace polaczenia, nigdy punkty dobra.
2. Jedyny final domykajacy wszystkie szesc postaci. Relacja Jakub-Wierzbicka ma
   wyplate tylko w D-15C. Dopisz jej domkniecie takze w finalach A i B; nie
   musi byc pojednaniem i nie moze byc dluzsze niz dwie repliki.
3. Jedyny final z triumfalna wymiana argumentacyjna. W D-14 usun dwie repliki:
   „To ktos usiadzie obok" (Marta) i „Nie. To procedura z drugim czlowiekiem"
   (Lena). Replika Marty „Wiec nauczymy motornicza patrzec" zostaje. Wierzbicka
   nie dostaje odpowiedzi; po jej pytaniu „A jesli odwroci glowe?" ma byc cisza.
4. Najbardziej afirmatywny epilog. Wyrownaj rejestr trzech epilogow sceny 45:
   wszystkie trzy maja byc obojetnym komunikatem administracyjnym, ktory znaczy
   co innego zaleznie od finalu. Dzis A jest zlowieszczy, B cieply, C
   afirmatywny.

Piaty sygnal - wlasna regula palety finalu C w VISUAL_DESIGN 3 - zostaw bez
zmian. Zlamany fiolet jest regula wizualna wspolistnienia, nie nagroda, a jego
wykonalnosc w 640x360 jest osobna, nierozstrzygnieta kwestia (H-012).

Dodatkowo przenies koszt finalu C na Slad. Dzis Slad dostaje w C ograniczony,
osobny glos, czyli nagrode, w finale rzekomo najkosztowniejszym. Zmien na
nieodwracalne rozproszenie na wezly: Slad przestaje byc kims jednym. Final,
ktory daje wszystkim glos, ma odebrac go tej, ktora o niego walczyla.

ZADANIE 2: STRUKTURA AKTU II
Akt II ma 13 z 45 przestrzeni i szesc razy dowodzi tej samej tezy.

- Scal scene 18 ze scena 36. To ten sam spor, ta sama para postaci i to samo
  ujawnienie braku oryginalu.
- Wchlon scene 22 do sceny 24. Znalezisko o roli lokalnej Leny ma wyplate w 24.
- Przenies scene 19 do aktu I, bezposrednio po scenie 11. Dobro UCP ma byc
  udowodnione przed wezwaniem do Punktu Zgodnosci 6, zeby scena 16 byla
  trudniejsza decyzja.

PRZENUMEROWANIE WYKONUJESZ RAZ. Dotyka FULL_STORY, CONTINUITY_TRACKER,
DIALOGUE_SCRIPT i VISUAL_DESIGN. Kazde odwolanie do numeru sceny musi zostac
przeliczone w tym samym pakiecie. Zbuduj najpierw tablice stary numer -> nowy
numer i dopiero potem edytuj pliki.

POZA ZAKRESEM
- runtime, Godot, Prototype 02, Zakotwiczenie i Uleglosc w kodzie;
- wybor kanonicznego finalu;
- concept art, sprite'y, audio, voice-over, lokalizacja;
- implementacja D-014 - osobny pakiet techniczny;
- braki researchu i INSPIRATION_BOUNDARIES - osobny pakiet;
- liczba przestrzeni z zastosowaniem mechaniki, H-002a - pakiet N0.2-D;
- symulowanie czytelnikow, testerow i danych z odbioru w jakiejkolwiek formie.

KRYTERIA AKCEPTACJI
- zaden final nie ma sygnalu strukturalnego, ktorego nie maja dwa pozostale,
  poza swiadomie zachowana regula palety;
- Swiadectwo jest osiagalne bez spelnienia warunkow i ma opisana wersje
  niestabilna;
- Slad ponosi w finale C nazwany, nieodwracalny koszt;
- trzy epilogi sceny 45 sa w tym samym rejestrze;
- akt II ma o dwie przestrzenie mniej, akt I o jedna wiecej;
- kazde odwolanie do numeru sceny w czterech dokumentach wskazuje wlasciwa
  scene po przenumerowaniu;
- lancuchy poszlak w CONTINUITY_TRACKER nadal cytuja fraze z FULL_STORY;
- H-011a zmierzone ponownie i zapisane jako MEASURED albo REFUTED, z metoda i
  liczba sygnalow;
- H-010a zmierzone ponownie, bo zmienila sie kolejnosc scen;
- pelna weryfikacja przechodzi.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pelna weryfikacje, przejrzyj zmienione pliki i zaktualizuj
RISKS_AND_HYPOTHESES, DECISION_LOG, CURRENT_STATE, SESSION_LOG i ten prompt.
Wszystko ma byc zapisane na dysku natychmiast; nie ma commita ani drzewa do
zamkniecia. Dopisz wpis PKG-0008 do SESSION_LOG.md - to jedyna historia
projektu i musi wystarczyc bez dostepu do rozmowy. Na koniec wykonaj
  pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0008
Raportuj fakty, zdjete sygnaly przewagi, wynik pomiaru H-011a i H-010a,
niewykonane zadania, numer pakietu i gotowy punkt przejecia. Nie deklaruj
poprawy odbioru - nie masz jak jej zmierzyc.
```
