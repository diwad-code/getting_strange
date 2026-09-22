# PKG-0113 — audyt planu wdrożenia i gotowości wydawniczej

Data: 2026-08-24  
Zakres: wyłącznie gra Godot 4.7 na Windows/Linux  
Werdykt: **produkt nie jest gotowy do publicznego wydania**

## Aktualizacja po PKG-0114

PKG-0114 zamknął R0 technicznie: produkcyjny shell jest punktem wejścia,
`GameStateManager` prowadzi 01..41 → dokładnie jeden wariant 42 → 43 → tytuł,
a `tests/pkg_0114_smoke_test.gd` sprawdza rzeczywiste sygnały ukończenia,
trzy gałęzie, zapis i fallback uszkodzonego JSON. Wiersze macierzy poniżej są
historycznym audytem stanu przed R0; aktualny handoff i kolejność R1–R5 są w
`docs/CURRENT_STATE.md`, `docs/ROADMAP.md` i `docs/NEXT_SESSION_PROMPT.md`.
Eksport, czysta instalacja, pełna lokalizacja, remap, content lock i odbiór
przez ludzi nadal nie są zamknięte.

## 1. Cel i granica dowodu

Audyt konfrontuje żywą roadmapę z aktualnym `project.godot`, scenami,
skryptami, testami i świeżymi renderami. Rozróżnia trzy rzeczy, które wcześniej
były mieszane:

1. **istnienie zawartości** — scena lub system znajduje się na dysku;
2. **techniczny kontrakt** — automat potrafi załadować lub wykonać dany wycinek;
3. **gotowość produktu** — odbiorca może uruchomić build, przejść całość i
   zakończyć grę bez narzędzi deweloperskich.

PKG-0113 potwierdza pierwsze dwa punkty w dużej części, ale nie trzeci. Testy
nie są dowodem funu, czytelności przez nową osobę, emocji ani zrozumienia
fabuły (D-012, ADR-003).

## 2. Metoda i świeże dowody

- świeży baseline: `pwsh -NoProfile -File .\tools\verify.ps1`, exit code `0`;
- inspekcja `project.godot`, `GameStateManager`, scen 01..43, finałów,
  InputMap, narzędzi i dokumentów żywych;
- naprawienie głównego `tests/smoke_test.gd`, aby rzeczywiście wywoływał testy
  Station 20..43, a nie kończył po Station 19;
- pełny smoke po naprawie: Station 01..41, 42A, 42B, 42C i 43 wykonane, exit
  code `0`;
- nowy gate `tests/pkg_0113_smoke_test.gd`: 43-pozycyjny selektor, dopasowanie
  menu pauzy, dialog CRT, pełne wywołanie smoke i źródła wspólnej oprawy;
- świeże rendery normalnym sterownikiem Windows/OpenGL Intel Iris Xe:
  `reports/pkg_0113/before/` i `reports/pkg_0113/after/`, po 13 kadrów;
- ponowny `tools/audit_h012.gd`: `12` kadrów, `63` pomiary rastera, `48`
  kontroli skal, exit code `0`.

## 3. Najważniejszy wynik

Na dysku istnieje 45 scen lokacji reprezentujących 43 pozycje kampanii:
Station 01..41, trzy alternatywne warianty pozycji 42 i epilog 43. Wszystkie są
ładowane i wykonywane przez świeży smoke. Nie tworzą jednak jeszcze produktu,
który da się przejść od uruchomienia do napisów:

- `run/main_scene` wskazuje `scenes/prototype/movement_lab.tscn`;
- nie istnieje produkcyjny ekran tytułowy ani przepływ Nowa gra/Kontynuuj;
- `CAMPAIGN_TRANSITION_LIMIT` świadomie pozostaje równy `25`;
- centralny menedżer nie prowadzi normalnej kampanii przez 26..41, wybór
  42A/B/C ani przejście wariantów 42 do 43;
- nie ma `export_presets.cfg`, gotowych buildów Windows/Linux ani testu czystej
  instalacji.

To są blokery P0. Nie wolno opisywać projektu jako „100% gotowego” na
podstawie samego istnienia scen lub zielonego testu izolowanego.

## 4. Macierz prawdy runtime i wydania

| Obszar | Aktualny dowód | Status | Skutek dla wydania |
|---|---|---|---|
| Punkt wejścia | `project.godot` uruchamia Movement Lab | **BLOCKED P0** | odbiorca nie trafia do gry |
| Menu główne | brak sceny tytułowej i Nowa gra/Kontynuuj/Ustawienia/Zakończ | **BLOCKED P0** | brak produkcyjnej powłoki |
| Zawartość kampanii | wszystkie sceny 01..43 istnieją i przechodzą pełny smoke | **TECHNICAL** | zawartość jest obecna, ale nie spięta |
| Łańcuch 01..25 | centralne przejścia, checkpointy i zapis są testowane | **TECHNICAL** | działa tylko dostarczona granica 25 |
| Łańcuch 26..43 | limit 25; brak centralnej obsługi gałęzi 42 i epilogu | **BLOCKED P0** | gry nie da się ukończyć normalną drogą |
| Save | JSON schema 1, reload/reset, checkpoint i selektor są testowane | **PARTIAL** | brak pełnego przebiegu i testu upgrade/awarii podczas zapisu |
| Menu pauzy | po PKG-0113 komplet 43 pozycji mieści się w 640x360 | **TECHNICAL** | technicznie użyteczne; nie zastępuje menu głównego |
| Sterowanie | semantyczny InputMap; ruch, skok i część interakcji mają pad | **PARTIAL P1** | pauza/restart i remap nie mają pełnego toru pada |
| Dialog | teletype, blipy, proceduralny portret i semantyczny prompt | **PARTIAL P1** | brak historii dialogu, ustawień tempa i pełnego zestawu portretów obsady |
| Dostępność | integer scale; techniczne transformacje H-012 | **BLOCKED P1** | brak menu opcji, remapu, skali tekstu i udokumentowanego minimum |
| Lokalizacja | istnieje `LocalizationManager`, lecz treści scen są głównie wpisane bezpośrednio po polsku | **BLOCKED P1** | brak kompletnego, przełączalnego PL/EN |
| Audio | szeroki zestaw generatorów proceduralnych | **PARTIAL P1** | brak ustawień głośności/mute i testu miksu w buildzie |
| Vector-Stage | 43 pozycje mają wspólną warstwę; PKG-0113 usuwa globalną powtarzalność lamp i poprawia UI | **PARTIAL P1** | potrzebny content lock i ręczny pass najbardziej generycznych kadrów |
| Wydajność | H-005 ma pomiary jednego profilu i dwa powtórzenia procesu | **TECHNICAL** | brak uprzedniego budżetu i weryfikacji buildów na kilku profilach |
| Czytelność | H-012 ma dane rastera, skal i transformacji | **UNTESTED** | brak progu, który rozstrzyga wynik |
| Automaty QA | `verify.ps1`, traversal lint, pełny smoke i bramki pakietów | **TECHNICAL** | brak testu rzeczywistego end-to-end przez produkcyjny shell |
| Eksport Windows/Linux | brak `export_presets.cfg` i artefaktów | **BLOCKED P0** | nie ma produktu do instalacji |
| Czysta instalacja | brak pakietu i przebiegu na czystym profilu | **BLOCKED P0** | niezweryfikowane ścieżki zapisu, sterowniki i zasoby |
| Credits/licencje/tytuł | tytuł nadal kryptonimem; brak manifestu release i audytu praw | **BLOCKED P0** | publikacja byłaby niekontrolowana |
| Odbiór przez ludzi | zewnętrzne playtesty anulowane decyzją projektu | **ACCEPTED RISK** | nie wolno zastępować ich oceną AI ani automatem |

## 5. Rozbieżności starej roadmapy

1. P1 był opisany jako `W TOKU`, choć P2 i P3 zostały później wykonane.
   Poprawiona roadmapa zamyka P1 technicznie i pozostawia H-001 bez dowodu
   odbiorczego.
2. P3 twierdził jednocześnie „100% zaimplementowane i przetestowane” oraz
   wymagał stabilnego buildu PC i pełnego slice'u. Sceny są zaimplementowane,
   ale build i ciąg produkcyjny nie istnieją. Status został rozdzielony na
   zawartość techniczną i blokery produktu.
3. Filar 0 sugerował dodawanie przeszkód do pozostałych pustych przestrzeni.
   To przeczy późniejszym audytom świadomej ciszy i D-099. Nie każda scena ma
   dostać przeszkodę; obowiązuje fabularne uzasadnienie i istniejące audyty.
4. P5/P6 były ogólnymi hasłami bez bramek wejścia/wyjścia. Zastępuje je
   poniższa kolejka domknięcia z konkretnymi dowodami.
5. Stary `README.md` nadal opisywał Prototype 01 i blokował systemy, które już
   istnieją. PKG-0113 przepisał go zgodnie z runtime.
6. Zielony główny smoke deklarował wszystkie stacje, ale wykonywał tylko 01..19.
   PKG-0113 uruchomił 20..43, ujawnił stare założenia Station 32/38 i naprawił
   test tak, aby rzeczywiście wykonywał granice Zakotwiczenia.

## 6. Poprawiona kolejka do mety

### R0 — produkcyjny shell i ciąg całej kampanii (P0)

- ekran tytułowy: Nowa gra, Kontynuuj, Ustawienia, Zakończ;
- właściwy `run/main_scene`;
- przejścia 01..41, jawny wybór A/B/C, 42A/B/C → 43 i bezpieczny powrót po
  epilogu;
- test end-to-end, który używa realnych sygnałów ukończenia i nie omija scen;
- zachowanie lub kontrolowana migracja save schema 1.

### R1 — opcje, pełny pad, dostępność i lokalizacja (P1)

- wspólny ekran ustawień z głośnością, tempem tekstu, skalą tekstu i remapem;
- kompletne akcje klawiatury/pada, w tym pauza, restart i nawigacja UI;
- rzeczywista ekstrakcja tekstów i przełączalne PL/EN;
- techniczne testy ustawień oraz jawna lista ryzyk odbiorczych.

### R2 — content lock obrazu, dialogu i dźwięku (P1)

- ręczny pass hierarchii i semantycznej odrębności kadrów wskazanych w
  `VECTOR_STAGE_ART_DIRECTION_AUDIT.md`;
- pełny zestaw odrębnych portretów proceduralnych obsady i historia dialogu;
- miks, priorytety sygnałów i kontrola clippingu;
- zamrożenie tekstu, logiki finałów i listy assetów.

### R3 — eksportowalne buildy PC (P0)

- `export_presets.cfg` dla Windows i Linux, numer wersji, ikony i deterministyczny
  skrypt budowania;
- dwa uruchamialne artefakty z pełną zawartością;
- test uruchomienia bez edytora i bez ścieżek deweloperskich.

### R4 — release candidate i audyt publiczny (P0)

- czysta instalacja, nowy profil zapisu, kontynuacja i reset;
- pełny przebieg od tytułu do napisów na Windows i Linux;
- test klawiatury oraz pada, kontrola wydajności i awarii;
- credits, manifest licencji/źródeł, clearance tytułu, release notes i archiwum
  artefaktów;
- zero znanych P0 oraz jawna lista zaakceptowanych P1/P2.

### R5 — META

**Ukończona gra Godot PC i gotowość produkcyjna do publicznego wydania na Windows/Linux.**

Ta meta jest ostatnim krokiem planu, nie opisem dzisiejszego stanu.

## 7. Kontrakt następnego pakietu

Następny pakiet powinien wykonać R0 jako jeden spójny mega-pakiet: produkcyjny
shell, pełną topologię przejść i test end-to-end. Nie powinien zaczynać od
eksportu, marketingu ani dodatkowych przeszkód, ponieważ bez ciągu 01..43 nie
istnieje gra, którą warto pakować.

Nie wolno w tym celu naruszyć D-098 (Godot-only), D-099 (przeszkody
diegetyczne), istniejących colliderów bez audytu, semantycznego InputMap ani
technicznej granicy dowodów. H-005 pozostaje `TECHNICAL`, H-012 pozostaje
`UNTESTED`.
