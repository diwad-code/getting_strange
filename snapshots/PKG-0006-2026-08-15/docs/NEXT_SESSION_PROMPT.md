# Prompt nastepnej sesji

Aktualny pakiet: `N0.2-B: Kanon 0.2 - sprzecznosci, poszlaki i sceny zwrotow`

Ponizszy blok jest gotowy do przekazania nowej sesji lub innemu modelowi.

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange jako head writer,
script editor i redaktor ciaglosci, w roli wlascicielskiej z eskalacja (D-013).

CEL SESJI
Usun twarde sprzecznosci miedzy dokumentami kanonu, dopisz brakujace zapowiedzi
najwiekszego zwrotu i napisz trzy brakujace sceny dialogowe. Pakiet konczy sie
ponownym pomiarem hipotezy H-010a.

Nie prowadzisz czytania stolikowego ani playtestu. One sie nie odbeda (D-012,
ADR-003) i ich symulacja jest zakazana. Nie oznaczasz zadnej hipotezy jako
SUPPORTED.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\WORKFLOW.md
5. C:\getting_strange\docs\decisions\ADR-003-evidence-model-without-external-testers.md
6. C:\getting_strange\docs\RISKS_AND_HYPOTHESES.md
7. C:\getting_strange\docs\narrative\NARRATIVE_BIBLE.md
8. C:\getting_strange\docs\narrative\FULL_STORY.md
9. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md
10. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md
11. C:\getting_strange\VISUAL_DESIGN.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Projekt NIE jest wersjonowany (D-016). Nie ma repozytorium, galezi, commita
  ani historii. Nie uruchamiaj `git` i nie inicjalizuj repozytorium.
- Oczekiwany ostatni zamkniety pakiet: PKG-0006 z 2026-08-15, wedlug
  SESSION_LOG.md.
- Runtime nadal jest w P1 i nie jest prowadzony; ten pakiet go nie dotyka.

Przed edycja pokaz i ocen pelny wynik:
  pwsh -NoProfile -File .\tools\verify.ps1

Nie filtruj wyjscia. Zielona bramka sprawdza istnienie plikow i graybox; nie
sprawdza spojnosci kanonu i nie wykryla zadnej z ponizszych sprzecznosci.

Cofanie siega jednego pakietu wstecz (R-017). Przeczytaj caly plik przed
zastapieniem go, zapisuj kazda skonczona zmiane natychmiast i nigdy nie
odtwarzaj tresci z pamieci zamiast z dysku. Ostatnie zamrozenie:
snapshots\PKG-0006-2026-08-15. Nie edytuj snapshotow i nie czytaj ich jak
aktualnego stanu.

ZADANIE 1: SIEDEM TWARDYCH SPRZECZNOSCI
Dla kazdej ustal jedna wersje, popraw wszystkie dotkniete pliki i dopisz wpis
do DECISION_LOG.md, jesli rozstrzygniecie zmienia kanon.

1. Los Wierzbickiej w finale C. NARRATIVE_BIBLE 11.C mowi "ginie"; FULL_STORY
   44C mowi "przegrana politycznie strazniczka". Rekomendacja audytu: nie
   zabijac - smierc antagonistki czyta sie jako nagroda dla finalu C i podnosi
   H-011a.
2. Rachunek Linii 4. FULL_STORY 30 daje dwanascie nazwisk; NARRATIVE_BIBLE 4
   mowi o jedenastu przeniesionych; CONTINUITY_TRACKER R-04 mowi o nazwisku po
   obu stronach listy; scena 32 nazywa sie "Jedenascie krzesel". Ustal kto, ilu
   i w jakim sensie. Od tego zalezy caly luk winy Jakuba.
3. Wiek Jakuba. NARRATIVE_BIBLE 4: 31 lat, smierc 13 lat wczesniej. DIALOGUE
   D-04: "Miales dwadziescia lat". Rekomendacja: Jakub 33.
4. Wariant instrumentalny finalu B istnieje w trzech wersjach: NARRATIVE_BIBLE
   11.B, FULL_STORY 44B i D-15B. Rekomendacja: przyjac D-15B, gdzie Marta
   zostaje w srodku i odmawia wejscia.
5. Ostatni obraz finalu A. NARRATIVE_BIBLE konczy na fotografii; FULL_STORY
   dodaje po niej telefon do Marty Kurek. Rekomendacja: telefon.
6. Ostatni obraz finalu C. NARRATIVE_BIBLE mowi o placu; FULL_STORY i
   VISUAL_DESIGN 8.6 mowia o tramwaju. Rekomendacja: tramwaj.
7. Zegar. Usun "mniej niz pol sekundy" z NARRATIVE_BIBLE 11.A; przesun blok
   mieszkania w CONTINUITY_TRACKER z 22:00 na 22:30, bo siedem przestrzeni nie
   miesci sie w pietnastu minutach.

Dodatkowo rozstrzygnij i zapisz jako regule w NARRATIVE_BIBLE 7: co fizycznie
przeszlo z Lena. Telefon w scenie 03 ma wiadomosci lokalne, a fotografia w
scenie 12 pochodzi z jej galezi. Rekomendacja: rzeczy i cialo zostaja jej,
zmienia sie to, co swiat o niej twierdzi.

ZADANIE 2: POSZLAKI ZWROTU O SKORYGOWANEJ GALEZI
H-010a jest REFUTED: tracker deklaruje szesc poszlak, w tekscie sa dwie.
Dopisz do FULL_STORY trzy zapowiedzi, kazda dwuznaczna przy pierwszym odbiorze:

- scena 01: fotografia ma nienaturalnie pusty margines;
- scena 13: nagranie glosu Jakuba ma miejsce, ktore zawsze bylo ciche;
- scena 23: Lena zauwaza, ze twarzy pielegniarki nie pamietala juz wczesniej.

Nastepnie usun z CONTINUITY_TRACKER R-04 wiersze bez pokrycia w tekscie albo
dopisz brakujacy tekst. Obowiazuje regula: wiersz trackera bez frazy obecnej w
FULL_STORY jest zadaniem do napisania, nie zapisem stanu.

ZADANIE 3: TRZY BRAKUJACE SCENY DIALOGOWE
DIALOGUE_SCRIPT deklaruje komplet scen niosacych zwroty emocjonalne i nie
zawiera trzech najwiekszych. Napisz:

- D-16 dla przestrzeni 24, punkt zwrotny: Lena rozumie, ze zostala sprowadzona
  celowo, ale nie po cialo;
- D-17 dla przestrzeni 35, reversal: galaz Leny takze zostala skorygowana;
- D-18 dla przestrzeni 41: Slad oddaje kontrole nad interfejsem.

Obowiazuja reguly z DIALOGUE_SCRIPT 1. Slad nie uzywa slowa, ktorego nie ma w
otoczeniu sceny. Zadna linia nie wyjasnia zakonczenia za gracza.

POZA ZAKRESEM
- runtime, Godot, Prototype 02, Zakotwiczenie i Uleglosc w kodzie;
- wybor kanonicznego finalu;
- concept art, sprite'y, audio, voice-over, lokalizacja;
- decyzje PROPOSED D-014 i D-015 - czekaja na wlasciciela, nie realizuj ich;
- decyzja o istnieniu stanu przegranej - osobny pakiet;
- scalanie scen 18 i 36, przenoszenie sceny 19 i przenumerowanie przestrzeni -
  to jest pakiet N0.2-C i wykonuje sie go raz, nie dwa razy;
- symulowanie czytelnikow, testerow i danych z odbioru w jakiejkolwiek formie.

KRYTERIA AKCEPTACJI
- siedem sprzecznosci ma jedna wersje w kazdym dotknietym pliku;
- regula o tym, co przeszlo z Lena, jest zapisana w NARRATIVE_BIBLE 7;
- FULL_STORY zawiera trzy nowe zapowiedzi, kazda mozliwa do zinterpretowania
  inaczej przy pierwszym czytaniu;
- kazdy wiersz CONTINUITY_TRACKER R-04 cytuje fraze obecna w FULL_STORY;
- H-010a zmierzone ponownie i zapisane jako MEASURED albo REFUTED, z metoda i
  liczba; zakaz statusu SUPPORTED obowiazuje;
- DIALOGUE_SCRIPT zawiera D-16, D-17 i D-18;
- zaden final nie zyskal nowego sygnalu przewagi strukturalnej;
- pelna weryfikacja przechodzi.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pelna weryfikacje po zmianach dokumentacji, przejrzyj zmienione pliki i
zaktualizuj RISKS_AND_HYPOTHESES, DECISION_LOG, CURRENT_STATE, SESSION_LOG i
ten prompt. Wszystko ma byc zapisane na dysku natychmiast; nie ma commita ani
drzewa do zamkniecia. Dopisz wpis PKG-0007 do SESSION_LOG.md - to jedyna
historia projektu i musi wystarczyc bez dostepu do rozmowy. Na koniec wykonaj
  pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0007
Raportuj fakty,
rozstrzygniete sprzecznosci, wynik pomiaru H-010a, niewykonane zadania, numer
pakietu i gotowy punkt przejecia. Nie deklaruj poprawy odbioru - nie masz jak
jej zmierzyc.
```
