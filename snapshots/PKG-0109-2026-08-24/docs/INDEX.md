# Indeks dokumentacji

Ten plik jest mapa kontekstu projektu. Nowa osoba lub nowy model powinny moc
ustalic aktualny stan w mniej niz dziesiec minut bez czytania calej historii
rozmow.

## Kolejnosc wejscia w nowej sesji

1. `AGENTS.md` - stale zasady pracy i granice aktywnej fazy.
2. `docs/CURRENT_STATE.md` - co faktycznie istnieje, co przeszlo testy i czego
   jeszcze nie wykonano.
3. `docs/NEXT_SESSION_PROMPT.md` - gotowy, aktualny zakres nastepnego pakietu.
4. Aktywna specyfikacja wymieniona w `CURRENT_STATE.md`.
5. Pliki kodu i testow wskazane w prompcie.
6. Odpowiednie ADR-y, bible projektu i research tylko wtedy, gdy sa potrzebne
   do decyzji w danym pakiecie.

Przed edycja nalezy uruchomic swieza bramke
`pwsh -NoProfile -File .\tools\verify.ps1`.

Projekt nie jest wersjonowany. Nie ma repozytorium, commitow ani historii; pliki
na dysku sa jedynym stanem, a `SESSION_LOG.md` jedyna kronika. Zob. D-016.

## Hierarchia prawdy

Gdy zrodla sa sprzeczne, obowiazuje kolejnosc:

1. aktualne zachowanie uruchomionej gry i pelny wynik testow;
2. aktualny kod, zasoby i konfiguracja na dysku;
3. `CURRENT_STATE.md` i aktywna specyfikacja;
4. zaakceptowane ADR-y i `PRODUCT_BRIEF.md`;
5. `PROJECT_BIBLE.md`, roadmapa i rejestr hipotez;
6. historyczne handoffy, wpisy sesji i rozmowy.

Kod nie usprawiedliwia jednak rozjazdu dokumentacji. Jesli punkt 1 lub 2
przeczy punktowi 3, poprawa dokumentacji nalezy do tego samego pakietu pracy.

Bez wersjonowania punkty 3-6 przestaja byc wygoda i staja sie jedyna pamiecia
projektu. Nieopisana zmiana jest zmiana utracona.

## Dokumenty trwale

| Plik | Rola | Aktualizowac, gdy |
|---|---|---|
| `PRODUCT_BRIEF.md` | Krotka definicja produktu | zmienia sie obietnica, odbiorca lub filary |
| `PROJECT_BIBLE.md` | Pelna wizja gry i jezyk projektowy | zmienia sie kierunek narracji, mechaniki, artu lub tonu |
| `narrative/NARRATIVE_BIBLE.md` | Kanon fabuly, postaci, swiata i zakonczen | zmienia sie prawda fabularna albo relacja |
| `narrative/FULL_STORY.md` | Przebieg calej gry scena po scenie | zmienia sie kolejnosc, rytm lub skutek sceny |
| `narrative/CONTINUITY_TRACKER.md` | Poszlaki, stany postaci i warunki finalow | zmienia sie ujawnienie, rekwizyt lub wiedza postaci |
| `narrative/DIALOGUE_SCRIPT.md` | Glosy i kluczowe rozmowy | zmienia sie dialog, subtekst lub granica postaci |
| `../VISUAL_DESIGN.md` | Kanon rezyserii wizualnej i handoff artu | zmienia sie paleta, kompozycja lub jezyk efektow |
| `TRAVERSAL_AND_OBSTACLE_DESIGN.md` | Kanon przeszkod i poruszania sie | zmienia sie rodzina przeszkod, model porazki lub zestaw czasownikow |
| `TRAVERSAL_ACT_II_AUDIT.md` | Audyt przeszkod Station 11..15 (PKG-0099) | zmienia sie przeszkoda w Akcie II |
| `TRAVERSAL_ACT_I_AUDIT.md` | Audyt przeszkod Station 06..10 (PKG-0100) | zmienia sie przeszkoda w Akcie I |
| `TRAVERSAL_ACT_IIB_AUDIT.md` | Audyt przeszkod Station 16..20 (PKG-0101) | zmienia sie przeszkoda w Akcie IIb |
| `TRAVERSAL_ACT_IIC_AUDIT.md` | Audyt przeszkod Station 21..25 (PKG-0102) | zmienia sie przeszkoda w Akcie IIc |
| `TRAVERSAL_ACT_III_AUDIT.md` | Audyt przeszkod Station 26..30 (PKG-0103) | zmienia sie przeszkoda w Akcie III |
| `TRAVERSAL_ACT_IIIB_AUDIT.md` | Audyt przeszkod Station 31..35 (PKG-0104) | zmienia sie przeszkoda w Akcie IIIb |
| `TRAVERSAL_ACT_IIIC_AUDIT.md` | Audyt przeszkod Station 36..40 (PKG-0105) | zmienia sie przeszkoda w Akcie IIIc |
| `TRAVERSAL_ACT_IV_AUDIT.md` | Audyt przeszkod Station 41 (PKG-0106) | zmienia sie przeszkoda albo decyzja o swiadomej ciszy w Akcie IV |
| `TRAVERSAL_ACT_IV_FINAL_AUDIT.md` | Audyt przeszkod i swiadomej ciszy finalow 42A..43 (PKG-0107) | zmienia sie przeszkoda albo decyzja o swiadomej ciszy w finalach Aktu IV |
| `VECTOR_STAGE_READABILITY_AUDIT_H-012.md` | Techniczny audyt rastera czytelności Vector-Stage (PKG-0108) | zmienia sie kontrakt pomiaru H-012 albo decyzja o korekcie artystycznej |
| `VECTOR_STAGE_COST_AUDIT_H-005.md` | Techniczny audyt kosztu renderu i animacji Vector-Stage (PKG-0109) | pojawia sie jawny budzet produkcyjny albo nowy dowod kosztu H-005 |
| `VECTOR_STAGE_ACT_IIC_AUDIT.md` | Audyt kompozycji Vector-Stage Station 21..25 | zmienia sie kompozycja lub widocznosc kadru Aktu IIc |
| `INSPIRATION_BOUNDARIES.md` | Granice inspiracji i IP | pojawia sie nowe ryzyko podobienstwa |
| `RESEARCH_FOUNDATIONS.md` | Zrodla i wnioski researchu | decyzja korzysta z nowego zewnetrznego dowodu |
| `TECHNICAL_DIRECTION.md` | Architektura i standardy techniczne | zmienia sie silnik, platforma, pipeline lub granica modulu |
| `ROADMAP.md` | Fazy, bramki i kolejnosc ryzyka | pakiet zamyka lub otwiera etap |
| `RISKS_AND_HYPOTHESES.md` | Co przewidujemy i jak to sprawdzimy | pojawia sie dowod, nowe ryzyko lub falsyfikacja |
| `DECISION_LOG.md` | Lekki rejestr decyzji | zapada decyzja istotna, ale niewymagajaca osobnego ADR-u |
| `decisions/*.md` | Niezmienne uzasadnienia drogich decyzji | decyzja jest kosztowna do odwrocenia |

## Dokumenty zywe

| Plik | Rola | Regula |
|---|---|---|
| `CURRENT_STATE.md` | Jeden aktualny stan projektu | aktualizowany na koniec kazdego pakietu |
| `NEXT_SESSION_PROMPT.md` | Jeden gotowy prompt kontynuacji | zawsze zastapiony aktualnym promptem |
| `SESSION_LOG.md` | Chronologiczny, dopisywany rejestr pakietow | nie przepisywac historii |
| `PROTOTYPE_*.md` | Specyfikacja aktywnego eksperymentu | wynik ma trafic do stanu i rejestru hipotez |
| `PLAYTEST_*.md` | Protokol i pozniej wyniki testow | oddzielac obserwacje od interpretacji |

## Protokol przekazania

Pelna zasada konca pakietu znajduje sie w `WORKFLOW.md`. W skrocie: pakiet nie
jest skonczony bez testow, aktualizacji dokumentow, wpisu do logu, aktualnego
handoffu i promptu nastepnej sesji. Po duzym pakiecie domyslnie konczymy sesje
i kontynuujemy w nowej.
