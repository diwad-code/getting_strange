# Ryzyka, hipotezy i przewidywania

Status: **ŻYWY REJESTR 2.0 PO D-113**  
Data: 2026-08-24

Implementacja, zielony test i pojedynczy render nie zamieniają intuicji o
odbiorze w fakt. Model dowodu określa ADR-003: projekt nie korzysta z
zewnętrznych playtestów jako bramy.

## Klasy dowodu

- `MIERZALNA` — może zostać rozstrzygnięta pomiarem, audytem tekstu, renderu lub
  testem automatycznym.
- `ODBIORCZA` — wymaga reakcji nowej osoby; w tym procesie pozostaje bez
  bezpośredniego dowodu.
- `KOSZTOWA` — wymaga zmierzonego czasu, wydajności albo uprzedniego budżetu.

## Statusy

- `UNTESTED` — brak wystarczającego dowodu;
- `TECHNICAL` — kontrakt działa technicznie, nie dowodzi doświadczenia;
- `MEASURED` — mierzalna hipoteza rozstrzygnięta podaną metodą;
- `ACCEPTED-RISK` — produkcja świadomie buduje na hipotezie odbiorczej;
- `OPEN-NO-EVIDENCE` — pytanie odbiorcze pozostaje otwarte i nie blokuje;
- `REFUTED` — dowód przeczy hipotezie;
- `RETIRED` — hipoteza straciła zastosowanie po zmianie kierunku.

`SUPPORTED` jest zarezerwowane dla powtarzalnego wyniku z udziałem ludzi i nie
jest obecnie używane. Ocena modelu, autora, automatu ani zrzutu nie wystarcza.

## Aktywne hipotezy

| ID | Hipoteza | Klasa | Status | Dostępna metoda / granica |
|---|---|---|---|---|
| H-001 | Mechaniczna responsywność da się pogodzić z ciężarem nowej animacji Leny | ODBIORCZA | ACCEPTED-RISK | Profil ruchu przechodzi smoke; PKG-0117 mierzy opóźnienia stanów i kontakt klatek, lecz przyjemność pozostaje bez dowodu |
| H-002 | Anchor/Yield ma dość zastosowań, by unieść Station 22–41 po nowym autorstwie | MIERZALNA + ODBIORCZA | UNTESTED | historyczny wynik 5/43 dotyczył kanonu 0.1 i nie rozstrzyga planu 0.2; audyt czynności/kosztów po PKG-0121 |
| H-003 | Narastanie 01–20 buduje niepokój bez zdradzenia rozwiązania i bez nudy | ODBIORCZA | ACCEPTED-RISK | mierzalne proxy: sufity intensywności, lint słów i rozkład dowodów; emocja i nuda bez dowodu |
| H-004 | Obraz i dźwięk wystarczą, by wskazać bieżące zdarzenie przed myślą | ODBIORCZA | ACCEPTED-RISK | audyt afordancji, kolejności show/reaction/thought oraz bezczynności; zrozumienie bez dowodu |
| H-005 | Rówień Pixel-Stage jest wydajny i produkcyjnie powtarzalny w 43 scenach | KOSZTOWA | UNTESTED | PKG-0117 ustanawia profil kompozytora i pomiar; historyczne metryki Vector-Stage nie są budżetem Pixel-Stage |
| H-006 | Omylne interpretacje Leny brzmią ludzko, nie jak arbitralne wprowadzanie w błąd | ODBIORCZA | ACCEPTED-RISK | audyt: obserwacja prawdziwa, hipoteza uzasadniona, mechanika nigdy fałszywa; odbiór bez dowodu |
| H-007 | Nowa Lena pozostaje czytelną osobą w `640x360` po próbkowaniu świata do `320x180` | MIERZALNA + ODBIORCZA | UNTESTED | pomiar sylwetki, stawów, kontrastu i klatek 1x–4x; rozpoznawalność emocji bez dowodu |
| H-008 | Marta i Jakub zachowują podmiotowość i emocjonalny rdzeń 2–3 godzin | ODBIORCZA | ACCEPTED-RISK | strukturalny audyt celów, odmów, konsekwencji i czasu obecności; emocjonalna waga bez dowodu |
| H-009 | UCP jest jednocześnie skuteczne i krzywdzące, a nie jednowymiarowe | ODBIORCZA | OPEN-NO-EVIDENCE | policzyć sceny skutku/krzywdy po ponownym autorstwie 22–41 |
| H-010 | Rozpoznanie w Station 21 jest uczciwe i nieprzedwczesne | MIERZALNA + ODBIORCZA | UNTESTED | trzy niezależne rodziny dowodów i zakaz diagnozy wcześniej są mierzalne; zaskoczenie pozostaje bez dowodu |
| H-011 | Trzy rodziny zakończeń nie kodują jednego „golden ending” | MIERZALNA + ODBIORCZA | UNTESTED | audyt dostępności, czasu, domknięć i nagród w PKG-0122; moralny odbiór bez dowodu |
| H-012 | Wszystkie czytelne teksty pozostają ostre nad pikselizowanym światem | MIERZALNA | UNTESTED | test warstw, zrzuty normalnym driverem, kontrola skal 1x–4x i skala tekstu 85–115% |
| H-013 | System myśli pomaga przy realnym zastoju bez spamowania | MIERZALNA + ODBIORCZA | UNTESTED | deterministyczne progi, cooldown ≥8 s, brak powtórek i reset po postępie; pomocność bez dowodu |

## Ryzyka kontrolowanej przebudowy

| ID | Ryzyko | Prawdopodobieństwo | Wpływ | Odpowiedź |
|---|---|---|---|---|
| R-001 | Zbyt duże podobieństwo ruchu lub kadru do `Another World` | średnie | bardzo wysoki | korzystać tylko z zasad obserwacji ruchu i filmowej ekonomii; własny model sheet, timing, paleta, kostium i kadry; audyt IP |
| R-002 | Przebudowa zamieni się w pełny reset techniczny | wysokie | bardzo wysoki | ADR-006 lista zachowanych systemów; przepisać komponent tylko po wykazanej regresji blokującej |
| R-003 | Stary runtime nadal zdradza zwrot w migrowanym wycinku | wysokie | bardzo wysoki | lint terminów, mapa beatów, test flag; wycinek nie jest zamknięty z tekstem legacy na aktywnej ścieżce |
| R-004 | Station 01–05 są tak zwyczajne, że nie ustanawiają obietnicy interaktywnej | średnie | wysoki | kompetentny pomiar, materialna czynność i motyw rezonansu z wiarygodnym wyjaśnieniem; nie dodawać paranormalnej zapowiedzi |
| R-005 | Myśli Leny zastąpią projekt poziomu | wysokie | wysoki | pokaż → reakcja → myśl; L2/L3 dopiero po zmierzonym zastoju; L4 opcjonalne |
| R-006 | Błędne myśli uczą błędnej mechaniki | średnie | bardzo wysoki | omylna tylko interpretacja fabularna; obserwacja, sterowanie i warunek działania zawsze prawdziwe |
| R-007 | Pixel-art będzie globalnym filtrem bez kierunku | wysokie | wysoki | kompozytor + ręczne palety, siatka, dithering i kadry; zakaz automatycznego szumu |
| R-008 | Pikselizacja rozmyje dialog, terminale lub szyldy | wysokie | bardzo wysoki | ostre warstwy po kompozytorze; migracja `draw_string()` z poziomów; test screenshotów |
| R-009 | Nowa Lena nadal wygląda jak znacznik po zmianie skali | średnie | bardzo wysoki | model sheet, rig z odrębnymi segmentami, 12+ stanów, reakcje i test ruchu w 01–07 |
| R-010 | Animacja Leny pochłonie plan | wysokie | bardzo wysoki | budżety poz, najpierw kluczowe stany Foundation Slice, reużycie rigów i jawny backlog wariantów |
| R-011 | Nowa fabuła, tracker, dialog i flagi rozjadą się | wysokie | bardzo wysoki | jeden zakres numerów na pakiet, audyt czterech dokumentów, test flag i aktualizacja w tym samym snapshotcie |
| R-012 | Zachowany save schema uruchomi niezgodne flagi legacy | średnie | wysoki | migrator lub jawne mapowanie przed Agency Slice; stare flagi nie ustawiają `world_recognized` |
| R-013 | Stare audyty zostaną potraktowane jak aktywny plan | wysokie | wysoki | INDEX oznacza je jako historyczne; CURRENT_STATE i NEXT_SESSION wskazują wyłącznie plan 2.0 |
| R-014 | Brak zewnętrznego odbiorcy ukryje niezrozumienie do premiery | pewne | bardzo wysoki | jawne etykiety ograniczeń, tanie plany odwrotu, automaty tylko jako proxy; nie deklarować odbioru |
| R-015 | Brak Git uczyni błędną migrację nieodwracalną | wysokie | bardzo wysoki | natychmiastowy zapis, append-only log, pakietowy snapshot; nadal brak kopii poza katalogiem projektu |
| R-016 | Przeszkody ponownie skręcą w arcade | średnie | wysoki | D-099, test trzech pytań i traversal lint; proces maszyny musi mieć funkcję świata |
| R-017 | Build zostanie otwarty przed content lockiem 2.0 | średnie | wysoki | P5 zablokowane do PKG-0122; brak presetów eksportu nie jest obecnym priorytetem |
| R-018 | Trzy zakończenia nie będą dość odmienne albo jedno stanie się uprzywilejowane | średnie | wysoki | projektować rodziny konsekwencji na istniejącej topologii, a stabilność jako wariant epilogu; nie tworzyć nowych mechanik finałowych |

## Wczesne wskaźniki alarmowe

- Przed Station 21 pojawia się jawna diagnoza sytuacji.
- Myśl wyświetla się zanim świat pokaże stan lub ponownie bez nowej informacji.
- Czytelny tekst znajduje się pod `WorldPixelCompositor`.
- Stan animacji Leny zmienia się po stanie fizyki z widocznym opóźnieniem.
- Asset Leny nie ma spójnego model sheetu albo światła z kadrem.
- Pakiet edytuje sceny poza swoim przedziałem bez koniecznej zależności.
- Dokument mówi „content lock”, choć aktywna treść legacy nie została migrowana.
- Test lub render jest opisywany jako dowód strachu, zabawy lub zrozumienia.

## Jak aktualizowac

Po pakiecie dopisz lub zmień:

- datę, metodę i surowy wynik pomiaru;
- zakres, którego wynik dotyczy;
- ograniczenie dowodu;
- zmianę statusu i wpływ na roadmapę;
- plan odwrotu, jeśli ryzyko się materializuje.

Nie ustawiaj `MEASURED` bez metody i nie ustawiaj `SUPPORTED` bez
powtarzalnego wyniku z udziałem ludzi.
