# ADR-003: Model dowodu bez zewnetrznych testerow

## Status

Accepted. Uzupelnia ADR-002, nie zastepuje go.

## Data

2026-08-15

## Kontekst

ADR-002 otwiera kolejne fazy produkcji przez bramki oparte na nowych
testerach. Cala dokumentacja zostala zbudowana wokol tego zalozenia:

- bramka P1 wymaga 4/5 testerow i mediany pierwszego przejscia;
- bramka P3 wymaga minimum 20 zewnetrznych, pierwszorazowych testerow;
- tor N1 wymaga stolikowego czytania calej fabuly przez osoby spoza autorstwa;
- wszystkie dwanascie hipotez ma w kolumnie "najblizszy dowod" playtest,
  czytanie stolikowe albo wywiad po grze;
- `NEXT_SESSION_PROMPT.md` opisuje pakiet `Narrative 0.2: Table Read`, ktorego
  cala tresc to protokol sesji z pieciona czytelnikami.

Wlasciciel projektu potwierdzil, ze zewnetrzne czytania stolikowe i playtesty
nie odbeda sie. Nie jest to opoznienie ani brak rekrutacji, lecz trwaly warunek
brzegowy projektu.

Utrzymanie obecnego modelu oznacza, ze dokumentacja opisuje proces walidacji,
ktory nigdy nie nastapi. To jest dokladnie ryzyko R-009 i najgrozniejszy rodzaj
dlugu dokumentacyjnego: bramka, ktorej nikt nie moze przejsc, przestaje byc
bramka i staje sie ozdoba.

Jednoczesnie audyt kanonu 0.1 wykazal, ze czesc hipotez zostala zaszufladkowana
bledne. Nie wymagaly czlowieka; wymagaly pomiaru, ktorego nikt nie wykonal.

## Decyzja

### 1. ADR-002 pozostaje w mocy co do kolejnosci ryzyka

Sekwencja `ruch -> centralna mechanika -> vertical slice -> produkcja` jest
nadal obowiazujaca. Zmienia sie wylacznie rodzaj dowodu otwierajacego bramke,
nie kolejnosc sprawdzania ryzyka.

### 2. Kazda hipoteza dostaje klase dowodu

- **MIERZALNA** - da sie rozstrzygnac pomiarem, renderem, audytem tekstu albo
  testem automatycznym, bez udzialu nowej osoby.
- **ODBIORCZA** - da sie rozstrzygnac wylacznie reakcja czlowieka, ktory widzi
  material pierwszy raz. W tym projekcie pozostanie nierozstrzygnieta.
- **KOSZTOWA** - da sie rozstrzygnac zmierzonym czasem wykonania albo modelem
  budzetowym opartym na zewnetrznych danych.

Klasa jest czescia rejestru i nie moze byc zmieniana bez wpisu w
`DECISION_LOG.md`.

### 3. Nowe statusy rejestru

Do dotychczasowych `UNTESTED`, `TECHNICAL`, `SUPPORTED`, `REFUTED`, `RETIRED`
dochodza trzy:

- **MEASURED** - hipoteza MIERZALNA rozstrzygnieta konkretnym pomiarem; wpis
  musi zawierac metode, liczbe i date.
- **ACCEPTED-RISK** - hipoteza ODBIORCZA, na ktorej projekt swiadomie buduje
  mimo braku dowodu. Wymaga nazwania skutku bledu i taniego planu odwrotu.
- **OPEN-NO-EVIDENCE** - hipoteza ODBIORCZA, ktorej projekt jeszcze nie
  potrzebuje rozstrzygac; nie blokuje pracy, ale nie wolno sie na nia powolywac.

**Zakaz pozostaje bez zmian:** `SUPPORTED` wymaga powtarzalnego wyniku z
udzialem ludzi. Model, autor ani test automatyczny nie moga ustawic tego
statusu. Brak testerow nie jest licencja na optymizm.

### 4. Bramki przechodza na dowod mierzalny i audyt kontraktu

Bramka moze skladac sie wylacznie z:

- **pomiaru obiektywnego** - liczba, render, czas, kontrast, wynik testu;
- **audytu kontraktu** - sprawdzalna zgodnosc dokumentu z wlasna deklaracja,
  najlepiej zautomatyzowana w `tools/verify.ps1`.

Bramka nie moze zawierac kryterium odbioru. Kryteria odbioru przenosza sie do
rejestru jako `ACCEPTED-RISK` wraz z nazwanym skutkiem bledu.

### 5. Obowiazek etykiety

Kazde zdanie w dokumentacji projektu twierdzace cokolwiek o zrozumieniu,
emocji, czytelnosci albo przyjemnosci gracza musi albo zniknac, albo nosic
jawna etykiete braku dowodu. Nie wolno pisac "gracz rozumie"; wolno pisac
"zamierzamy, zeby gracz rozumial; nie sprawdzono".

### 6. Rozszerzenie bramki o kontrole kanonu

Propozycja rozszerzenia `tools/verify.ps1` o automatyczny audyt spojnosci
narracyjnej pozostaje `PROPOSED` i wymaga osobnej decyzji. Nie wchodzi w zakres
tego ADR-u.

## Rozwazane alternatywy

### Utrzymac bramki oparte na testerach

Formalnie najbezpieczniejsze. W praktyce zamraza projekt na P1 na stale i
pozostawia w repozytorium dokumenty opisujace nieistniejacy proces. Odrzucone
jako aktywnie szkodliwe.

### Uznac ocene modelu albo autora za dane z testu

Najtansze i wprost zakazane przez ADR-002, `AGENTS.md`, `WORKFLOW.md` oraz
`RISKS_AND_HYPOTHESES.md`. Odrzucone. Zakaz zostaje utrzymany takze po tej
zmianie: brak dowodu jest zapisywany jako brak dowodu.

### Zredukowac zakres do projektu, ktory nie wymaga walidacji odbioru

Gra oparta na czytelnosci reguly bez instrukcji, trzech rownorzednych finalach
i zwrocie poznawczym jest z definicji projektem, ktorego jakosc mieszka w
odbiorze. Redukcja do czegos weryfikowalnego bez ludzi oznaczalaby inna gre.
Odrzucone.

### Odlozyc decyzje do momentu, gdy testerzy sie znajda

Kazdy kolejny pakiet dziedziczylby wtedy fikcyjny model dowodu i produkowal
dokumenty powolujace sie na bramki nie do przejscia. Odrzucone.

## Konsekwencje

- Osiem z dwunastu hipotez pozostaje trwale bez dowodu. Ryzyko przesuwa sie z
  "jeszcze nie wiemy" na "wiemy, ze nie sprawdzimy" i musi byc tak zapisane.
- Rzemioslo, research zewnetrzny i audyt wewnetrzny staja sie jedynym
  zabezpieczeniem jakosci. Ich dyscyplina musi wzrosnac, nie zmalec.
- Projekt traci prawo do twierdzenia, ze gra jest zrozumiala, poruszajaca albo
  przyjemna. Zachowuje prawo do twierdzenia, ze jest spojna, czytelna w
  pomiarze i zgodna z wlasnym kontraktem.
- Cztery hipotezy zyskuja realna droge rozstrzygniecia, ktorej wczesniej nie
  mialy, bo blednie uznano je za odbiorcze.
- ADR nie jest jednokierunkowy. Pojawienie sie choc jednego zewnetrznego
  czytelnika lub testera przywraca stosowalnosc bramek ADR-002 dla tej
  konkretnej hipotezy, bez koniecznosci odwracania tej decyzji.
- Audyt zewnetrzny przestaje istniec jako funkcja procesu. Rola recenzenta musi
  byc odtwarzana swiadomie: nowa sesja bez kontekstu poprzedniej, zgodnie z
  D-008, jest teraz jedynym mechanizmem kontroli i przestaje byc higiena
  kontekstu, a staje sie zabezpieczeniem jakosci.
