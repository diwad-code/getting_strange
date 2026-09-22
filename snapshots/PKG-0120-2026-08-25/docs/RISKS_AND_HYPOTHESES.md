# Ryzyka, hipotezy i przewidywania

Status: **ŻYWY REJESTR 3.0 PO D-114**  
Data: 2026-08-25

Implementacja, zielony test, audyt narracyjny i pojedynczy render nie zamieniają
intuicji o odbiorze w fakt. Model dowodu określa ADR-003: zewnętrzne playtesty
pozostają odłożone do końca produkcji, więc pytania o emocje są jawnie otwarte.

## Klasy dowodu

- `MIERZALNA` — może zostać rozstrzygnięta pomiarem, audytem tekstu, renderu lub
  testem automatycznym.
- `ODBIORCZA` — wymaga reakcji nowej osoby; obecnie pozostaje bez bezpośredniego
  dowodu.
- `KOSZTOWA` — wymaga zmierzonego czasu, wydajności albo budżetu.

## Statusy

- `UNTESTED` — brak wystarczającego dowodu;
- `TECHNICAL` — kontrakt działa technicznie, nie dowodzi doświadczenia;
- `MEASURED` — mierzalna hipoteza rozstrzygnięta podaną metodą;
- `ACCEPTED-RISK` — produkcja świadomie buduje na hipotezie odbiorczej;
- `OPEN-NO-EVIDENCE` — pytanie odbiorcze pozostaje otwarte i nie blokuje;
- `REFUTED` — dowód przeczy hipotezie;
- `RETIRED` — hipoteza straciła zastosowanie po zmianie kierunku.

`SUPPORTED` jest zarezerwowane dla powtarzalnego wyniku z udziałem ludzi i nie
jest obecnie używane.

## Aktywne hipotezy

| ID | Hipoteza | Klasa | Status | Dostępna metoda / granica |
|---|---|---|---|---|
| H-001 | Responsywność ruchu da się pogodzić z ciężarem nowej animacji Leny | MIERZALNA + ODBIORCZA | TECHNICAL | 13 stanów kluczowych i proporcje 44-52px weryfikowane w `pkg_0118_smoke_test.gd`; przyjemność ruchu bez dowodu |
| H-002 | Anchor/Yield ma dość znaczących zastosowań, by unieść drugą tajemnicę 22–41 | MIERZALNA + ODBIORCZA | TECHNICAL | wprowadzenie mechaniki w 22-23 zbadane w `pkg_0120_smoke_test.gd`; pełny audyt czynność–koszt–konsekwencja po PKG-0122 |
| H-003 | Narastanie 01–20 buduje niepokój bez zdradzenia rozwiązania i bez nudy | ODBIORCZA | ACCEPTED-RISK | mierzalne proxy: sufity wiedzy, lint terminów w 01-07 (PKG-0118), 08-13 (PKG-0119) i 14-20 (PKG-0120); emocja i nuda bez dowodu |
| H-004 | Obraz i dźwięk wskazują zdarzenie przed myślą Leny | MIERZALNA + ODBIORCZA | TECHNICAL | sekwencje show → reaction → thought w 01-07 (PKG-0118), 08-13 (PKG-0119) i 14-23 (PKG-0120); zrozumienie bez dowodu |
| H-005 | Pixel-Stage jest wydajny i powtarzalny w 43 scenach | KOSZTOWA | TECHNICAL | WorldPixelCompositor w Layer 5 przetestowany dla 01-23; pełny profil 43 scen w PKG-0123 |
| H-006 | Omylne interpretacje Leny brzmią ludzko, nie jak arbitralne oszustwo | ODBIORCZA | ACCEPTED-RISK | cykl hipoteza -> sprawdzenie wdrożony w 01-20, z syntezą i zamknięciem 4 hipotez w Station 21; odbiór psychologiczny bez dowodu |
| H-007 | Lena pozostaje czytelną osobą w `640x360` po próbkowaniu świata do `320x180` | MIERZALNA + ODBIORCZA | TECHNICAL | sylwetka fasetowa, ciemne spodnie, jasny sweter i torba sprawdzone na klatkach 01-23 |
| H-008 | Marta, Jakub, miejscowa Lena i Wierzbicka zachowują własne cele przez 2,5–3,5 godziny | MIERZALNA + ODBIORCZA | TECHNICAL | odmowa Marty (14-15) i odmowa Jakuba (20) przetestowane w `pkg_0120_smoke_test.gd`; emocjonalna waga bez dowodu |
| H-009 | Wierzbicka i UCP są skuteczną, racjonalną opozycją, a nie jednowymiarowym złem | ODBIORCZA | OPEN-NO-EVIDENCE | pierwsza oferta UCP w 22, raport w 17; policzyć sceny po migracji 24–38 |
| H-010 | Rozpoznanie w Station 21 jest uczciwe i nieprzedwczesne | MIERZALNA + ODBIORCZA | TECHNICAL | 3 rodziny dowodów, bramka `is_world_recognized` i lint terminów w 14-20 zweryfikowane w PKG-0120; zaskoczenie bez dowodu |
| H-011 | Trzy zakończenia nie kodują „golden ending” | MIERZALNA + ODBIORCZA | UNTESTED | porównać dostępność, czas, zgody, straty i epilogi w PKG-0123; moralny odbiór bez dowodu |
| H-012 | Wszystkie czytelne teksty pozostają ostre nad pikselizowanym światem | MIERZALNA | TECHNICAL | CrispDiegeticText w Layer 10 i brak draw_string w Layer 0 zweryfikowane w PKG-0118, PKG-0119 i PKG-0120 |
| H-013 | System myśli pomaga przy zastoju bez spamowania | MIERZALNA + ODBIORCZA | TECHNICAL | cooldown >= 8.0s, reset po postępie i zamykanie hipotez potwierdzone testem automatycznym |
| H-014 | Dwie różne relacje Marty z dwiema Lenami są zrozumiałe bez wykładu | MIERZALNA + ODBIORCZA | TECHNICAL | próg Marty (14) i rozbieżność wspomnień (15) przetestowane; zrozumienie bez dowodu |
| H-015 | Miejscowa Lena pozostaje sprawczą osobą mimo fizycznej nieobecności | MIERZALNA + ODBIORCZA | TECHNICAL | celowy błąd rejestru w 22 i obwód w 23 potwierdzają ślady jej decyzji; poczucie obecności bez dowodu |
| H-016 | Druga tajemnica po Station 21 utrzymuje napięcie zamiast zamienić się w procedurę | ODBIORCZA | ACCEPTED-RISK | przejście z rozpoznania do poszukiwania miejscowej Leny (21-23); napięcie bez dowodu |

## Ryzyka kontrolowanej przebudowy

| ID | Ryzyko | Prawdopodobieństwo | Wpływ | Odpowiedź |
|---|---|---|---|---|
| R-001 | Zbyt duże podobieństwo ruchu lub kadru do `Another World` | średnie | bardzo wysoki | zapożyczać zasady ciężaru i ekonomii, nie aktywa ani rozpoznawalne kadry; własny model sheet, timing, paleta i kostium |
| R-002 | Przebudowa zamieni się w pełny reset techniczny | średnie | bardzo wysoki | ADR-006/007 wyliczają systemy zachowane; przepisać komponent dopiero po wykazanej regresji blokującej |
| R-003 | Stary runtime nadal zdradza zwrot w migrowanym wycinku | wysokie | bardzo wysoki | lint terminów, mapa beatów, test flag; tekst legacy nie może pozostać na aktywnej ścieżce |
| R-004 | Station 01–05 są zwyczajne, lecz bez konfliktu i obietnicy działania | średnie | wysoki | konflikt zawodowy wokół próbki Linii 4, materialna procedura i relacja z Martą bez paranormalnej zapowiedzi |
| R-005 | Myśli Leny zastąpią projekt poziomu | wysokie | wysoki | pokaż → naprowadź → pomyśl → sprawdź; L2/L3 dopiero po zastoju |
| R-006 | Błędne myśli nauczą błędnej mechaniki | średnie | bardzo wysoki | omylna tylko interpretacja fabularna; obserwacja, sterowanie i cel czynności zawsze prawdziwe |
| R-007 | Pixel-art będzie globalnym filtrem bez kierunku | wysokie | wysoki | kompozytor + ręczne palety, siatka, dithering i kadry; zakaz automatycznego szumu |
| R-008 | Pikselizacja rozmyje dialog, terminale lub szyldy | wysokie | bardzo wysoki | ostre warstwy po kompozytorze; migracja czytelnych `draw_string()`; test screenshotów |
| R-009 | Nowa Lena nadal wygląda jak znacznik | średnie | bardzo wysoki | model sheet, segmentowy rig, stany ruchu i reakcje; inspekcja 01–07 |
| R-010 | Animacja Leny pochłonie plan | wysokie | bardzo wysoki | budżety poz, kluczowe stany najpierw, reużycie riga i jawny backlog wariantów |
| R-011 | Biblia, pełna historia, tracker, dialog i flagi rozjadą się | wysokie | bardzo wysoki | jeden zakres na pakiet, czterodokumentowy audyt, test flag i jeden snapshot |
| R-012 | Zachowany save schema uruchomi flagi legacy | średnie | wysoki | migrator lub jawne mapowanie przed 22; stare flagi nie ustawiają `world_recognized` |
| R-013 | Historyczne audyty zostaną potraktowane jak aktywny plan | średnie | wysoki | INDEX kieruje do 3.0; 0.2 ma jawny status odrzuconego projektu pośredniego |
| R-014 | Brak zewnętrznego odbiorcy ukryje niezrozumienie do końca produkcji | pewne | bardzo wysoki | jawne ograniczenia, tanie plany odwrotu i automaty tylko jako proxy; bez deklaracji odbioru |
| R-015 | Brak Git uczyni błędną migrację nieodwracalną | wysokie | bardzo wysoki | natychmiastowy zapis, append-only log i pakietowy snapshot |
| R-016 | Przeszkody skręcą w arcade | średnie | wysoki | D-099, test trzech pytań i traversal lint; maszyna musi mieć funkcję świata |
| R-017 | Build zostanie otwarty przed content lockiem 3.0 | średnie | wysoki | P5 zablokowane do PKG-0123 |
| R-018 | Zakończenia pozostaną abstrakcyjnymi nazwami systemów | średnie | bardzo wysoki | w 42–43 pokazać jawny stan obu Len, Marty, Jakuba, UCP i obu ciągłości |
| R-019 | Dwie Leny zleją się odbiorcy w jedną abstrakcję | wysokie | bardzo wysoki | osobne określenia robocze, relacje, sprawcze decyzje, nagrania i matryca stanów; unikać „oryginału” |
| R-020 | Relacja Marty zostanie odczytana jako trójkąt lub nagroda dla protagonistki | średnie | bardzo wysoki | Marta rozpoznaje różnicę, stawia granice i nie przenosi automatycznie relacji miejscowej Leny na przybyłą |
| R-021 | Nieudokumentowane zmiany Foundation Slice zostaną nadpisane albo fałszywie uznane za gotowe | wysokie | wysoki | klasyfikacja `KEEP/ADAPT/RETIRE`, świeży test i wpis PKG-0117 przed snapshotem |
| R-022 | Korelacja kosztów Linii 4 zostanie podana jako wygodne, nieudowodnione prawo metafizyczne | średnie | wysoki | rozdzielić zapis pomiarowy, hipotezę Leny i model UCP; finał nie daje wszechwiedzącej odpowiedzi |

## Wczesne wskaźniki alarmowe

- Przed Station 21 pojawia się jawna diagnoza sytuacji.
- Po Station 21 pytanie „gdzie jestem?” nie zostaje zastąpione pytaniem o
  miejscową Lenę i koszt Linii 4.
- Marta mówi o obu Lenach tak samo lub nie stawia granicy przybyłej Lenie.
- Miejscowa Lena istnieje tylko jako plik potrzebny do rozwiązania zagadki.
- Jakub jest traktowany jako nagroda, dług albo dowód zamiast osoby ze zgodą.
- Wierzbicka przekazuje ekspozycję, ale nie podejmuje działań blokujących.
- Myśl pojawia się przed obserwacją albo podaje rozwiązanie jako pewnik.
- Czytelny tekst znajduje się pod `WorldPixelCompositor`.
- Dokument mówi „content lock”, choć aktywna trasa nadal zawiera legacy.
- Test lub render jest opisywany jako dowód strachu, zabawy lub zrozumienia.

## Jak aktualizować

Po pakiecie dopisz lub zmień:

- datę, metodę i surowy wynik pomiaru;
- zakres, którego wynik dotyczy;
- ograniczenie dowodu;
- zmianę statusu i wpływ na roadmapę;
- plan odwrotu, jeśli ryzyko się materializuje.

Nie ustawiaj `MEASURED` bez metody i nie ustawiaj `SUPPORTED` bez
powtarzalnego wyniku z udziałem ludzi.
