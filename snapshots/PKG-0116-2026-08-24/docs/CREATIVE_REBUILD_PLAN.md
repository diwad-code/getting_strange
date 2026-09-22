# Getting Strange — plan kontrolowanej przebudowy kreatywnej

Status: **AKTYWNY PLAN PRODUKCYJNY 2.0 — PKG-0116**

Data: 2026-08-24

## 1. Werdykt

Nie kontynuujemy dawnego R2 content locka i nie kasujemy całego projektu.
Przebudowujemy doświadczenie na istniejącym, zweryfikowanym szkielecie Godot.

To rozdzielenie jest obowiązkowe:

| Zachować | Ponownie zbudować |
|---|---|
| Godot 4.7, 640x360, 60 Hz | przebieg i rytm scen 01..43 |
| shell, zapis, ustawienia, InputMap | dialogi oraz kolejność ujawnień |
| fizyka i profile ruchu jako baseline | wygląd, proporcje i animacje Leny |
| proceduralne audio i trasa kampanii | prowadzenie, myśli i podpowiedzi |
| Anchor/Yield jako działające systemy | światowy kompozytor pixel-art i ostry tekst |
| testy infrastruktury | bramki treści i kompozycji dla nowych wycinków |

Istnienie sceny na dysku nie jest odtąd równoznaczne z zatwierdzoną treścią.
Do czasu ponownego autorstwa sceny 01..43 są **legacy runtime substrate**.

## 2. Cztery kontrakty nadrzędne

### 2.1 Getting Strange naprawdę narasta

Przed Station 21 dowody pozostają wieloznaczne. Każdy etap ma dominujące
odczucie i granicę informacji:

| Zakres | Dominujący stan | Co Lena uważa | Co wolno pokazać |
|---|---|---|---|
| 01..05 | normalność i kompetencja | pomiar się udał, wieczór trwa zwyczajnie | rutyna bez jawnej anomalii |
| 06..09 | niepokój | błąd synchronizacji, zmiana miasta, zbieg okoliczności | jedna drobna niezgodność naraz |
| 10..13 | zmieszanie | pomyłka adresu, włamanie, przemęczenie | mieszkanie i dokumenty pasują do obcej biografii |
| 14..17 | lęk | ktoś przejął jej dane albo ona straciła pamięć | Marta i rejestr pracy znają inną biografię |
| 18..20 | dezorientacja i upiorność | możliwy spisek, załamanie albo niemożliwy powrót zmarłego | żywy Jakub i stabilna sprzeczna historia |
| 21 | zrozumienie | „to nie jest mój świat” | trzy niezależne dowody składają się w jeden model |
| 22..41 | sprawczość, groza proceduralna, odpowiedzialność | można znaleźć przyczynę i spróbować naprawy | Anchor/Yield, UCP, Ślad, Podstruktura |
| 42..43 | decyzja i konsekwencja | nie istnieje naprawa bez kosztu | trzy równorzędne odpowiedzi |

Przed Station 21 zakazane są: słowa „inna gałąź”, „alternatywny świat”,
„lokalna Lena”, wykład UCP o wersjach oraz świadome użycie Zakotwiczenia przez
Lenę. Świat może dawać dowody; nikt nie może wykonać za Lenę wniosku.

### 2.2 Lena jest człowiekiem w kadrze

`PrototypePlayer._draw()` jest oznaczony jako placeholder do zastąpienia.
Produkcja używa osobnego `LenaVisualRig`, autorskich pose sheets i
`AnimationTree`. Fizyka pozostaje właścicielem pozycji; animacja pokazuje
ciężar, intencję i emocję. Pełny kontrakt: `docs/LENA_CHARACTER_AND_ANIMATION.md`.

### 2.3 Gra pokazuje, potem podpowiada, potem pozwala Lenie pomyśleć

Każda lokacja stosuje drabinę:

1. kompozycja, światło, ruch i dźwięk;
2. reakcja świata na bezpieczną próbę;
3. krótka myśl Leny po obserwacji lub utknięciu;
4. konkretniejszy trop po kolejnych nieudanych próbach;
5. bezpośrednia wskazówka dopiero jako opcjonalny ratunek.

Myśl może mylić się co do przyczyny i ludzi, ale nie może fałszować reguły
sterowania ani kierować w nieodwracalną pułapkę. Pełny kontrakt:
`docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`.

### 2.4 Pikselujemy świat, nigdy tekst

Świat 2D, postacie, światło i efekty przechodzą przez domyślną siatkę 2x2
(efektywne 320x180). UI, dialogi, myśli, prompt interakcji, napisy diegetyczne,
menu, ustawienia, pauza i napisy końcowe są kompozytowane później w 640x360.
Pełny kontrakt: `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`.

## 3. Nowa mapa treści 01..43

Kanon scen znajduje się w `docs/narrative/FULL_STORY.md`. Mapa produkcyjna:

- **01..05 — Pomiar:** pełna normalność, onboarding i zamknięcie zmiany;
- **06..09 — Rysa:** błędy, które Lena racjonalizuje;
- **10..13 — Nie moje rzeczy:** działający klucz, obce życie i dwa adresy;
- **14..17 — Cudza biografia:** Marta, biuro, rejestr i zablokowany raport UCP;
- **18..20 — Niemożliwy brat:** kontakt w rejestrze, głos i żywy Jakub;
- **21 — Bramka rozpoznania:** jawne „to nie jest mój świat”;
- **22..30 — Pierwsze działanie:** nazwanie metod, koszty, ślady miejscowej
  Leny i mapa trzech dróg;
- **31..41 — Podstruktura i wybór:** odpowiedzi układu, koszty UCP, węzły
  Marty/Jakuba i wykonanie metody;
- **42A..42C, 43 — trzy konsekwencje i epilog.**

## 4. Kolejka mega-pakietów

### PKG-0116 — Creative rebaseline (ten pakiet)

- ADR-006 i D-113;
- kanon fabuły 0.2 oraz nowa mapa ujawnień;
- specyfikacja Leny, prowadzenia i kompozytora Pixel-Stage;
- nowa roadmapa, ryzyka, handoff i bramka dokumentacji;
- zero zmian runtime poza kontraktem testów dokumentacji.

### PKG-0117 — Foundation Slice 01..07

Jeden pionowy plaster łączy cztery systemy:

1. `LenaVisualRig` i minimalny produkcyjny zestaw idle/walk/run/turn/jump/land/
   interact/start/stop;
2. `WorldPixelCompositor` z ostrym `CrispTextLayer` i inwentaryzacją każdego
   źródła tekstu;
3. `NarrativeGuidanceService` oraz `InnerThoughtSurface` z poziomami L0..L4;
4. ponowne autorstwo Station 01..07 zgodnie z normalnością i pierwszą rysą.

Bramka wyjścia: żadna scena 01..05 nie zawiera jawnej anomalii ani słownika
alternatywnego świata; 06..07 mają wyłącznie dwuznaczne sygnały; Lena ma
czytelną pozę w ruchu i bezruchu; cały tekst omija pixelizację.

### PKG-0118 — Slow Burn 08..14

- domofon, znajoma klatka, działający klucz, mieszkanie, wiadomość Marty, dwa
  adresy i wejście Marty;
- adaptacyjne myśli Leny od racjonalizacji do potrzeby zewnętrznego faktu;
- rozszerzenie animacji o ostrożny próg, badanie, cofnięcie i pracę z dokumentem;
- zero jawnej diagnozy i zero świadomego Anchor.

### PKG-0119 — Fear and Recognition 15..21

- sprzeczne wspomnienie Marty, biuro, zablokowany raport i skrót UCP bez wykładu;
- rejestr kontaktu, telefon i spotkanie z żywym Jakubem;
- potrójny dowód i nieodwracalna bramka rozpoznania Station 21;
- test zakazujący jawnej wiedzy przed 21 i wymagający zmiany celu po 21.

### PKG-0120 — Agency 22..30

- pierwsze kampanijne Anchor/Yield dopiero po rozpoznaniu;
- czytelny koszt obu metod na działającej infrastrukturze;
- warunek Marty, odmowa instrumentalizacji Jakuba i ślady miejscowej Leny;
- echo domu oraz mapa trzech metod wejścia do Podstruktury;
- prowadzenie pozostaje fikcyjne, ale mechanicznie prawdziwe.

### PKG-0121 — Understructure 31..41

- procedura miejscowej Leny, echo domu i ujawnienie kosztów UCP;
- węzły Jakuba i Marty oraz brak uprzywilejowanego „oryginału”;
- trzy operacje bez sygnału „dobrego” finału;
- pełny pass animacji emocjonalnej Leny i kluczowej obsady.

### PKG-0122 — Endings and new content lock

- 42A/42B/42C i 43 zgodne z kanonem 0.2;
- pełna migracja tekstu do ostrej warstwy;
- spójny miks, lokalizacja narracji, credits i manifest treści;
- capture matrix świata 320x180→640x360 oraz tekstu 640x360;
- dopiero ten pakiet może przywrócić status **content lock**.

### PKG-0123+ — Build i release candidate

Eksporty Windows/Linux, czysta instalacja i publiczny RC pozostają zablokowane,
dopóki PKG-0122 nie zamknie przebudowanej treści.

## 5. Reguła migracji wycinka

Każdy zakres stacji przechodzi kolejno:

1. snapshot poprzedniego pakietu jest potwierdzony;
2. funkcja emocjonalna i wiedza Leny są zapisane przed edycją;
3. stare kwestie i rekwizyty klasyfikuje się jako `KEEP`, `REWRITE`, `MOVE`,
   `RETIRE`;
4. scena jest przepisywana w miejscu, bez hurtowego kasowania pozostałych;
5. tekst trafia do wspólnego systemu, nie do `_draw()` stacji;
6. powstaje gate kontraktu treści i normal-driver capture;
7. aktualizowane są kanon, stan, log i kolejny prompt.

## 6. Bramka jakości planu

Plan jest wykonany poprawnie, gdy:

- nowa sesja nie może pomylić istniejącej kampanii z content lockiem;
- Station 21 jest jedyną pierwszą jawną bramką rozpoznania;
- runtime przed 21 nie daje świadomego Anchor/Yield;
- spec Leny wymaga pełnej postaci i animacji, nie deformacji jednego gryzmołu;
- żadna ścieżka tekstowa nie przechodzi przez pixelizację;
- wskazówki mają deterministyczne triggery, cooldown i granice wiarygodności;
- kolejka buildów jest zablokowana do nowego content locka.
