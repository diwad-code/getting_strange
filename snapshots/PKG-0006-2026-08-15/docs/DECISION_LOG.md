# Rejestr decyzji

Lekki, chronologiczny rejestr. Decyzje drogie do odwrocenia maja dodatkowy ADR.
Stare wpisy pozostaja; zmiana decyzji dodaje nowy wpis i wskazuje poprzedni.

| ID | Data | Status | Decyzja | Uzasadnienie / nastepstwo |
|---|---|---|---|---|
| D-001 | 2026-08-15 | ACCEPTED | Godot 4.7.x, GDScript, PC-first | Dedykowane 2D, MIT, niski narzut; zob. ADR-001 |
| D-002 | 2026-08-15 | ACCEPTED | Tribute dla filozofii gatunku, nie kopiowanie ekspresji Another World | Wlasna fabula, swiat, mechanika i jezyk wizualny |
| D-003 | 2026-08-15 | ACCEPTED | Najpierw ruch, potem centralna mechanika i finalny art | Wczesne sprawdzenie najczestszego kontaktu gracza; zob. ADR-002 |
| D-004 | 2026-08-15 | PROPOSED | Zakotwiczenie/Uleglosc jako mechanika sygnaturowa | Pozostaje H-002 i H-006, nie implementowac przed bramka P1 |
| D-005 | 2026-08-15 | ACCEPTED | 640x360, integer scaling i nearest filtering jako baza prototypu | Czytelny pixel art 16:9 i kontrolowany koszt kadru |
| D-006 | 2026-08-15 | ACCEPTED | Brak broni w pierwszych prototypach | Nie pozwala walce przejac gry przed dowodem narracyjnej mechaniki |
| D-007 | 2026-08-15 | ACCEPTED | Dokumentacja, stan i prompt sa czescia Definition of Done | Projekt ma byc przejmowalny bez historii rozmowy |
| D-008 | 2026-08-15 | ACCEPTED | Po duzym pakiecie domyslnie nowa sesja | Ogranicza stary kontekst i wymusza swiezy baseline |
| D-009 | 2026-08-15 | ACCEPTED | Aktualny runtime i kod maja pierwszenstwo przed historycznym handoffem | Handoff moze sie zestarzec; rozjazd trzeba naprawic w tym samym pakiecie |
| D-010 | 2026-08-15 | ACCEPTED | Zamykamy kanon narracyjny i wizualny 0.1 rownolegle do P1, bez wdrazania systemow fabularnych | Pelna historia daje cel prototypom; runtime nadal podlega bramkom ADR-002 |
| D-011 | 2026-08-15 | ACCEPTED | Lena, Marta, Jakub, Wierzbicka, Slad i UCP sa rdzeniem fabuly; finaly to Powrot, Uzgodnienie i Swiadectwo | Zmiana wymaga jawnej decyzji i synchronizacji trackera ciaglosci |
| D-012 | 2026-08-15 | ACCEPTED | Zewnetrzne playtesty i czytania stolikowe nie odbeda sie; bramki przechodza na pomiar obiektywny i audyt kontraktu | Potwierdzone przez wlasciciela. Zob. ADR-003. Zakaz ustawiania `SUPPORTED` bez ludzi zostaje utrzymany; dziesiec hipotez odbiorczych zapisano jawnie jako trwale bez dowodu (R-015) |
| D-013 | 2026-08-15 | ACCEPTED | Prowadzenie kanonu narracyjnego, wizualnego i dokumentow zarzadczych przejmuje jedna rola wlascicielska z eskalacja | Decyzje ciaglosci, redakcji i kanonu podejmowane samodzielnie; decyzje projektowe zapisywane jako `PROPOSED` do potwierdzenia; prawo, budzet i konsultacje eksperckie pozostaja poza rola. Runtime i Prototype 02 poza zakresem |
| D-014 | 2026-08-15 | PROPOSED | Rozszerzyc `tools/verify.ps1` o automatyczny audyt spojnosci kanonu narracyjnego | Zamienia dyscypline trackera z obietnicy w bramke: pokrycie poszlak cytatem z `FULL_STORY.md`, obecnosc sceny dialogowej dla kazdego zwrotu, brak przewagi strukturalnej finalu. Odpowiedz na R-009, R-012 i R-014, ktore sie zmaterializowaly. Dotyka bramki, wiec wymaga potwierdzenia |
| D-015 | 2026-08-15 | PROPOSED | Swiadectwo przestaje byc finalem warunkowym; brakujace polaczenia obnizaja jakosc wyniku zamiast blokowac wybor | Bramka finalu jest jednym z pieciu zmierzonych sygnalow przewagi strukturalnej (H-011a). Zmiana dotyka warunkow zakonczenia i kosztu produkcji wariantow, wiec wymaga potwierdzenia przed pakietem N0.2-B |
| D-016 | 2026-08-15 | ACCEPTED | Projekt nie jest wersjonowany; pliki na dysku sa jedynym stanem, zapis nastepuje natychmiast | Decyzja wlasciciela. Zastepuje wersjonowanie w D-007 i D-009. Zniesione: commit jako Definition of Done, sprawdzanie drzewa i `HEAD` na starcie sesji, Git LFS. Wzmocnione: `CURRENT_STATE.md`, `SESSION_LOG.md` i `NEXT_SESSION_PROMPT.md` staja sie jedyna historia projektu. Utracone bezpowrotnie: cofanie zmian, wykrywanie cudzych edycji, historia assetow binarnych - zob. R-017 |
| D-017 | 2026-08-15 | ACCEPTED | Snapshot tresci projektu na koniec kazdego pakietu przez `tools/snapshot.ps1` do `snapshots/PKG-NNNN-DATA/` | Jedyna odpowiedz techniczna na R-017 po zniesieniu wersjonowania. Zmierzony koszt: 48 plikow, 0,23 MB na pakiet - tresc projektu to <1 MB, reszta katalogu to tooling wylaczony z kopii. To nie jest kontrola wersji: brak scalania, roznic i historii liniowej; odtworzenie jest reczne i wymaga wpisu w `SESSION_LOG.md`. `snapshots/` ma `.gdignore`, bo kopie `.tscn` i `.gd` powodowalyby kolizje nazw klas przy imporcie |

## Statusy

- `PROPOSED`: propozycja lub hipoteza, jeszcze nie kontrakt produkcyjny.
- `ACCEPTED`: obowiazuje nowe pakiety.
- `SUPERSEDED`: zastapiona nowa decyzja o wskazanym ID.
- `RETIRED`: nie ma juz zastosowania po zmianie zakresu.
