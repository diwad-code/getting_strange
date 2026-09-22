# Roadmapa: Getting Strange

Status: **AKTYWNA ROADMAPA 2.0 — KONTROLOWANA PRZEBUDOWA**  
Data: 2026-08-24  
Szczegółowy plan wykonawczy: `CREATIVE_REBUILD_PLAN.md`

## Meta produktu

Ukończona, samodzielna gra Godot 4.7 na Windows i Linux: 43 ponownie
zautoryzowane przestrzenie, pełny przebieg od ekranu tytułowego do konsekwencji,
nowa Lena, Rówień Pixel-Stage, ostre teksty, kontekstowe prowadzenie, zapis,
dostępność, buildy oraz jawny pakiet licencyjny.

Istnienie 43 scen technicznych nie jest content lockiem. Po D-113 droga do mety
prowadzi przez ponowne autorstwo kampanii, nie bezpośrednio do eksportu.

## Stan wejściowy zachowany z wersji 0.1

| Obszar | Status | Decyzja |
|---|---|---|
| Godot 4.7, 640x360, 60 Hz, InputMap | zachowany | nie przepisywać bez regresji blokującej |
| ruch i fizyka `PrototypePlayer` | zachowane jako baseline mechaniczny | oddzielić od nowego `LenaVisualRig` |
| shell, pauza, ustawienia i PL/EN UI | technicznie działają | utrzymać |
| zapis i topologia 01..41 → finał → 43 | technicznie działają | migracja treści bez zerwania trasy |
| proceduralne audio i CRT | zachowane jako infrastruktura | adaptować do nowych scen |
| Anchor Lab | techniczny prototyp | przenieść do kampanii dopiero od Station 22 |
| treść 01–43, obecne dialogi i kadry | LEGACY | ponownie stworzyć wycinkami |
| proceduralny rysunek Leny | PLACEHOLDER | zastąpić rigem produkcyjnym |
| Vector-Stage jako gładka powierzchnia | zastąpione częściowo | przejść na Pixel-Stage z ostrym tekstem |

## P4-RB0 — Rebaseline kreatywny

Pakiet: **PKG-0116**  
Status: **DOMYKANY**

Zakres:

- ADR-006 i D-113;
- kanon narracyjny 0.2 z bramą Station 21/22;
- kontrakt nowej Leny i animacji;
- system prowadzenia i wewnętrznego głosu;
- architektura world pixelation / crisp text;
- nowa kolejka pionowych wycinków;
- aktualizacja stanu, ryzyk, handoffu, weryfikacji i snapshotu.

Bramka wyjścia: dokumenty nie opisują starego content locku jako planu, pełne
`verify.ps1` kończy się kodem 0, a PKG-0117 ma samowystarczalny prompt.

## P4-RB1 — Foundation Slice 01–07

Pakiet: **PKG-0117**  
Status: **NASTĘPNY**

Jeden pionowy wycinek dostarcza cztery fundamenty równocześnie:

1. `LenaVisualRig`, model sheet i pełna podstawowa pętla ruchu;
2. `WorldPixelCompositor` oraz ostre warstwy tekstu/UI;
3. `NarrativeGuidanceService` i powierzchnia `LENA // MYŚL`;
4. ponowne autorstwo Station 01–07: zwykły pomiar → powrót → pierwszy
   racjonalizowalny dysonans.

Bramka:

- zero jawnego rozwiązania świata;
- czytelna postać w ruchu, zatrzymaniu i interakcji;
- świat pikselizowany, tekst ostry;
- pokaż → reakcja → myśl działa bez spamu;
- zapis/restart/trasa 01→07 bez regresji;
- świeże kadry i pełne testy techniczne.

## P4-RB2 — Unease Slice 08–14

Pakiet: **PKG-0118**  
Status: **PLANOWANY**

- domofon, klucz, mieszkanie, obce porządki, dwa adresy i wejście Marty;
- rozbudowa reakcji twarzy, progów, oglądania i interakcji Leny;
- GuidanceBeats dla zmiany celu bez ekspozycji;
- migracja wszystkich czytelnych napisów do ostrych warstw;
- walidator zakazanych terminów przed rozpoznaniem.

Bramka: Station 08–14 przechodzi od niepokoju do lęku, lecz wszystkie fakty
mają jeszcze co najmniej jedną uczciwą codzienną interpretację.

## P4-RB3 — Recognition Build 15–21

Pakiet: **PKG-0119**  
Status: **PLANOWANY**

- wspólne wspomnienie Marty, biuro, raport UCP, kontakt i spotkanie z Jakubem;
- trzy niezależne rodziny dowodów;
- pełny aktorski zestaw dezorientacji/upiorności Leny;
- Station 21 jako interaktywna synteza, nie film ekspozycyjny;
- flaga `world_recognized` wymaga wszystkich dowodów.

Bramka: jedyna pierwsza jawna kwestia rozpoznania brzmi w Station 21; zapis nie
może ominąć ani ustawić jej jedną linią.

## P4-RB4 — Agency Slice 22–30

Pakiet: **PKG-0120**  
Status: **PLANOWANY**

- kampanijna integracja Anchor/Yield z istniejącego prototypu;
- nauka przez działającą infrastrukturę, bez arcade'owych torów;
- Marta i Jakub jako osoby stawiające warunki;
- pierwsze widoczne koszty stabilizacji;
- mapa trzech metod operacyjnych.

Bramka: każda mechaniczna sytuacja ma zdanie diegetyczne, stan przed/po,
uczciwą podpowiedź i trwałą konsekwencję w zapisie.

## P4-RB5 — Podstructure Slice 31–41

Pakiet: **PKG-0121**  
Status: **PLANOWANY**

- kulminacyjne wykorzystanie Anchor/Yield;
- procedura miejscowej Leny, ujawnienie kosztów UCP, węzły Marty i Jakuba;
- różnicowanie obrazu Podstruktury bez rozmycia tekstu;
- metoda finału wynika z całego wzoru działań;
- techniczna migracja historycznych flag do nowego zapisu kampanii.

Bramka: wszystkie metody są mechanicznie osiągalne, a gra pokazuje przewidywane
koszty przed zatwierdzeniem bez etykiet moralnych.

## P4-RB6 — Konsekwencje 42–43 i content lock 2.0

Pakiet: **PKG-0122**  
Status: **PLANOWANY**

- trzy rodziny zakończeń, ich stany stabilności i systemowy epilog;
- finalne portrety/animacje reakcji, teksty, cue audio i kadry;
- pełny indeks treści, credits, źródła i lista zaakceptowanych ograniczeń;
- end-to-end od Nowej gry i Kontynuuj dla wszystkich wyników;
- content lock dopiero po zgodności 01–43 z kanonem 0.2.

Bramka: brak znanej treści legacy w aktywnej trasie; pełny przebieg, zapis,
restart i ostre powierzchnie tekstu przechodzą testy.

## P5 — Build i release candidate

Pakiety: **PKG-0123+**  
Status: **ZABLOKOWANY DO P4-RB6**

1. `export_presets.cfg`, numer wersji, ikony i buildy Windows/Linux.
2. Smoke na artefaktach i czysta instalacja.
3. Kontynuacja, reset, klawiatura/pad, ustawienia i dostępność.
4. Budżet wydajności kompozytora oraz kontrola skalowania.
5. Licencje, credits, manifest źródeł, clearance tytułu i release notes.
6. Archiwum release candidate oraz jawna lista P1/P2.

Nie otwieramy buildów wcześniej tylko dlatego, że shell technicznie działa.

## Bramki stałe każdego pakietu

- brak webu i Git;
- zgodność z kanonem przeszkód D-099;
- semantyczny InputMap, 60 Hz i 640x360;
- szybki restart i deterministyczny stan debug;
- test dokumentacji, import i pakietowy smoke;
- dla zmian wizualnych: normal-driver capture i ręczna inspekcja świeżych kadrów;
- aktualne `CURRENT_STATE`, append-only `SESSION_LOG`, nowy handoff i snapshot;
- jasne rozdzielenie dowodów technicznych od hipotez odbiorczych.

## Warunek ukończenia roadmapy

Roadmapa kończy się dopiero na zweryfikowanym release candidate Windows/Linux.
Żaden test lub render sam nie potwierdza funu, emocji, czytelności przez nową
osobę ani skuteczności narastania grozy.
