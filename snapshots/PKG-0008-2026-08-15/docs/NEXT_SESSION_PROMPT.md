# Prompt nastepnej sesji

Aktualny pakiet: `N0.2-D: Audyt zastosowan mechaniki sygnaturowej`

Ponizszy blok jest gotowy do przekazania nowej sesji lub innemu modelowi.

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange jako head writer,
script editor i redaktor ciaglosci, w pelnej roli wlascicielskiej (D-018).
Decyzje kanonu, struktury i redakcji podejmujesz samodzielnie i od razu.
Poza rola sa wylacznie: przeglad prawny, zobowiazania budzetowe i konsultacja
ekspercka przy tresciach klinicznych.

CEL SESJI
Zmierz H-002a przez audyt 43 przestrzeni w `docs/narrative/FULL_STORY.md`.
Policz tylko jawne, rozne zastosowania Zakotwiczenia i Uleglosci, ktore maja
konkretne dzialanie, koszt albo skutek mozliwy do zapisania jako przyszly
kontrakt prototypu. Sama wzmianka tematyczna, rekwizyt albo deklaracja postaci
nie licza sie jako zastosowanie mechaniki. Wynik musi zawierac metode, pelna
liste scen sklasyfikowanych jako liczace i nieliczace oraz liczbe.

Nie prowadzisz czytania stolikowego ani playtestu. One sie nie odbeda (D-012,
ADR-003) i ich symulacja jest zakazana. Nie oznaczasz zadnej hipotezy jako
SUPPORTED. H-002a, jako hipoteza MIERZALNA, moze skonczyc tylko jako MEASURED
albo REFUTED, z metoda, liczba i data.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\WORKFLOW.md
5. C:\getting_strange\docs\decisions\ADR-003-evidence-model-without-external-testers.md
6. C:\getting_strange\docs\RISKS_AND_HYPOTHESES.md
7. C:\getting_strange\docs\DECISION_LOG.md
8. C:\getting_strange\docs\ROADMAP.md
9. C:\getting_strange\docs\narrative\NARRATIVE_BIBLE.md
10. C:\getting_strange\docs\narrative\FULL_STORY.md
11. C:\getting_strange\docs\narrative\CONTINUITY_TRACKER.md
12. C:\getting_strange\docs\narrative\DIALOGUE_SCRIPT.md
13. C:\getting_strange\VISUAL_DESIGN.md
14. C:\getting_strange\docs\SESSION_LOG.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Projekt NIE jest wersjonowany (D-016). Nie ma repozytorium, galezi, commita
  ani historii. Nie uruchamiaj `git` i nie inicjalizuj repozytorium.
- Ostatni zamkniety pakiet to `PKG-0008` z 2026-08-15. Kronika znajduje sie w
  `docs/SESSION_LOG.md`; sciezka root `C:\getting_strange\SESSION_LOG.md` nie
  istnieje i ta rozbieznosc zostala zapisana w PKG-0008.
- Oczekiwany wynik swiezej bramki:
  `DOCS PASS: 26 required files and handoff contracts`,
  `SMOKE PASS: project, scene, input and player physics`,
  `Verification passed.`

Przed edycja pokaz i ocen pelny, nieprzefiltrowany wynik:
  pwsh -NoProfile -File .\tools\verify.ps1

Nie czytaj snapshotow jako aktualnego stanu i nie edytuj ich. Przed praca
przeczytaj caly plik, ktory ma byc zmieniony; zapisuj kazda skonczona zmiane
natychmiast. Na koncu wykonaj:
  pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0009

POTWIERDZONE PO PKG-0008
- Historia ma 43 przestrzenie w pieciu aktach: 7/10/11/11/4.
- Finaly A, B i C sa dostepne zawsze. W C brakujace polaczenia obnizaja
  stabilnosc sieci i sa widoczne w epilogu, ale nie blokuja wyboru i nie sa
  punktami dobra.
- Koszt C ponosi Slad: rozprasza sie nieodwracalnie po publicznych wezlach i
  przestaje byc jedna osoba z jednym glosem.
- A i B maja dwureplikowe domkniecie relacji Jakub-Wierzbicka. D-14 konczy sie
  cisza po pytaniu „A jesli odwroci glowe?”. Trzy epilogi maja obojetny rejestr
  administracyjny. Regula zlamanego fioletu z `VISUAL_DESIGN.md` 3 pozostaje
  wizualna i nie jest sygnalem przewagi H-011a.
- H-010a jest `MEASURED` po PKG-0008: trzy zapowiedzi spelniaja cztery warunki
  w scenach 01, 14 i 22; sceny 02 i 10 sa wsparciem.
- H-011a jest `MEASURED` po PKG-0008: audyt czterech sygnalow strukturalnych
  wykazal 0 sygnalow przewagi dla A, B i C. To audyt kontraktu, nie dowod
  odbioru. H-011b pozostaje bez dowodu.
- Scena 19 zawiera scalone ujawnienie dawnych scen 18 i 36. Dawna 22 jest
  wchlonieta w scene 23, a dawny pokaz UCP przeniesiono do sceny 12, zaraz po
  scenie 11. Nie wykonuj drugiego przenumerowania.

ZADANIE: AUDYT H-002a
1. Przejdz przez wszystkie 43 sceny w `FULL_STORY.md` i zbuduj tabele:
   - scena;
   - mechanika: Zakotwiczenie, Uleglosc, obie albo brak;
   - konkretna czynność gracza lub postaci;
   - obserwowalny skutek albo koszt;
   - czy zastosowanie jest odrębne od już policzonych.
2. Rozdziel zastosowania jawne i mechanicznie różne od samych funkcji
   dramaturgicznych. Nie dopisuj scen ani nie tworz nowych mechanik.
3. Zgodz wynik z `CONTINUITY_TRACKER.md`, zwlaszcza zmiennymi
   `anchor_detail`, `ring_disposition` i `public_witness_network`.
4. Zapisz wynik i status H-002a w `RISKS_AND_HYPOTHESES.md`, a jego wplyw na
   kolejke prac w `ROADMAP.md`, `CURRENT_STATE.md`, `DECISION_LOG.md` i
   `SESSION_LOG.md`.

POZA ZAKRESEM
- runtime, Godot, Prototype 02 i implementacja Zakotwiczenia/Uleglosci;
- zmiana liczby 43 przestrzeni lub ponowne przenumerowanie;
- zmiana rodzin finalu, kosztu Sladu, D-015 lub wyniku H-011a;
- concept art, sprite'y, audio, voice-over i lokalizacja;
- implementacja D-014 w `tools/verify.ps1`;
- research pamieci, zaloby, Severance i Control;
- czytelnicy, testerzy, dane odbioru i status `SUPPORTED`.

KRYTERIA AKCEPTACJI
- kazda z 43 scen ma jawna klasyfikacje liczaca/nieliczaca;
- metoda i liczba H-002a sa powtarzalne z samego tekstu;
- H-002a ma status `MEASURED` albo `REFUTED`, nigdy `SUPPORTED`;
- tracker nie ma odwolania do sceny, ktora nie istnieje, a dokumenty nie
  rozjezdzaja sie z `FULL_STORY.md`;
- pelna weryfikacja przechodzi;
- `CURRENT_STATE.md`, `ROADMAP.md`, `RISKS_AND_HYPOTHESES.md`,
  `DECISION_LOG.md`, `SESSION_LOG.md` i ten prompt opisuja stan faktyczny;
- wykonano snapshot `PKG-0009`.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom pelna weryfikacje, zapisz faktyczny wynik w dokumentacji, dopisz wpis
PKG-0009 do `docs/SESSION_LOG.md`, zastap ten prompt promptem wynikajacym ze
stanu i wykonaj snapshot `PKG-0009`.

Raportuj fakty, metode, liste i liczbe zastosowan, status H-002a, wynik bramki,
ograniczenia oraz gotowy punkt przejecia. Nie deklaruj, ze mechanika jest
interesujaca, zrozumiala albo grywalna — ten pakiet tego nie mierzy.
```
