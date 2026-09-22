# ADR-006: Kontrolowana przebudowa kreatywna zamiast content locka

## Status

Accepted

## Data

2026-08-24

## Kontekst

Po PKG-0115 projekt ma działający szkielet Godot: shell, zapis, ustawienia,
semantyczny InputMap, fizykę, proceduralne audio, trasę 01..43 i rozbudowane
bramki automatyczne. Zielone testy potwierdzają jednak kontrakty techniczne,
nie właściwy rytm fabuły ani jakość postaci.

Audyt wykonany po uwadze właściciela wykazał trzy rozjazdy fundamentalne:

- już Station 04 mówi o żywym Jakubie, a Station 07 konfrontuje Lenę z cudzym
  życiem; tytułowe „getting strange” nie ma czasu narastać;
- `PrototypePlayer` rysuje Lenę bez systemu animacji z kilku wielokątów i dwóch
  linii nóg; jest placeholderem technicznym, nie bohaterką produkcyjną;
- dialogi, cele i wskazówki są rozproszone po skryptach stacji, a 33 skrypty
  poziomów rysują tekst bezpośrednio w warstwie świata, co uniemożliwia
  bezpieczne rozpikselizowanie obrazu przy zachowaniu ostrego tekstu.

Planowany PKG-0116 miał zamrozić obraz, dialog i dźwięk. Zamrożenie teraz
utrwaliłoby błędny kierunek.

## Decyzja

Anulujemy dawny content lock R2 i wykonujemy **kontrolowaną przebudowę
kreatywną**.

Zachowujemy sprawdzony kręgosłup techniczny:

- Godot 4.7, 640x360, fizykę 60 Hz i semantyczny InputMap;
- shell, ustawienia, zapis, trasę kampanii i testy infrastruktury;
- mechanikę Zakotwiczenia/Uległości, proceduralne audio i dozwolone rodziny
  przeszkód jako materiały do ponownego osadzenia;
- własną paletę, instytucjonalną materialność Równi i duże płaszczyzny
  Vector-Stage jako bazowy język świata.

Ponownie autorujemy:

- rytm, kolejność ujawnień, dialogi i funkcje wszystkich przestrzeni 01..43;
- wizualną postać Leny oraz pełny zestaw animacji opartych na pozach;
- system prowadzenia, myśli wewnętrznych i bezpiecznej eskalacji podpowiedzi;
- prezentację obrazu jako `Rówień Pixel-Stage`: świat przechodzi przez siatkę
  pikselową, a dialogi, myśli, napisy i każdy tekst są kompozytowane później w
  natywnej rozdzielczości;
- walidację treści: istniejąca scena może pozostać technicznie sprawna, ale do
  chwili ponownego autorstwa nie ma statusu produkcyjnego contentu.

Twarda bramka fabularna: Lena nie może wiedzieć ani powiedzieć, że to inny
świat przed Station 21. Station 21 jest sceną zrozumienia „to nie jest mój
świat”. Dopiero Station 22 otwiera świadome działanie naprawcze i kampanijne
Zakotwiczenie.

## Rozważone alternatywy

### Dokończyć dawny R2

Zaleta: najkrótsza droga do buildów. Wada: zamraża zbyt wczesny zwrot,
placeholder Leny i niezgodną architekturę tekstu. Odrzucone.

### Usunąć wszystko i rozpocząć pusty projekt

Zaleta: brak długu treści. Wada: utrata poprawnych systemów wejścia, zapisu,
ustawień, audio, fizyki i testów bez związku z problemem kreatywnym. Odrzucone.

### Kontrolowany rebuild na istniejącym szkielecie

Zaleta: pozwala ponownie zbudować doświadczenie bez odtwarzania neutralnej
infrastruktury. Wada: wymaga jawnego rozróżniania „istnieje technicznie” od
„zatwierdzone produkcyjnie”. Przyjęte.

## Konsekwencje

- D-092 pozostaje ważne dla własnej materialności i granic inspiracji, ale
  traci wyłączność na brak warstwy pixel-art; w tym zakresie zastępuje je
  D-113 i ten ADR.
- Kolejka R3/R4 wydania jest wstrzymana do nowego content locka po przebudowie.
- Obecne sceny i testy nie są usuwane hurtowo. Każdy wycinek jest przepisywany
  po snapshotcie, dostaje test kontraktu treści i dopiero wtedy zastępuje stary
  wycinek.
- Nie deklarujemy, że dokumentacja dowodzi niepokoju, lęku, czytelności lub
  jakości animacji. Definiuje zamiar oraz techniczne kryteria wykonania.
- Pełny plan pakietów znajduje się w `docs/CREATIVE_REBUILD_PLAN.md`.

