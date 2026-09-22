# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0122  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P4: relacyjna rewolucja fabuły i kontrolowana przebudowa gry Godot 4.7**
(`ADR-006`, `ADR-007`, `D-114`).

Foundation Slice (Station 01–07), Sekwencja II/III (Station 08–13 — Rysa i cudzy dom), Sekwencja IV/V (Station 14–23 — Marta, UCP i rozpoznanie), Sekwencja VI/VII (Station 24–30 — Węzeł pod Linią 4, żywa odpowiedź i pierwsze koszty) oraz Sekwencja VIII/IX (Station 31–37 — Podstruktura, Magazyn Dowodów i rejestr par) zostały w pełni dostarczone i zweryfikowane zgodnie z Kanonem 0.3 (`docs/narrative/NARRATIVE_BIBLE.md`, `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/LENA_CHARACTER_AND_ANIMATION.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`, `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`).

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0.  
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rówień Pixel-Stage.  
Aktywny kanon fabuły: `docs/narrative/NARRATIVE_BIBLE.md` 0.3 i `docs/narrative/FULL_STORY.md` 0.3.  
Aktywny tracker ciągłości: `docs/narrative/CONTINUITY_TRACKER.md` 0.3.

## Rdzeń Foundation Slice 01–07 (Kanon 0.3)

1. **Station 01 (Ostatni odczyt)**:
   - Rutynowy pomiar drgań na Linii 4 przy użyciu przenośnego rejestratora.
   - Trzysekundowa luka w buforze; ponowny, czysty pomiar; archiwizacja `LINIA 4 / LUKA 00:00:03`; spakowanie torby narzędziowej.
   - O 20:40 następuje niezauważony kontakt obu Len — brak widocznych anomalii dla bohaterki.
2. **Station 02 (Obejście serwisowe)**:
   - Znany skrót jest fizycznie zamknięty z powodu rzeczywistych prac konserwacyjnych (taśmy ostrzegawcze, wentylacja, lampy robocze).
   - Wygaszona podrozdzielnica serwisowa potwierdza stan prac; Lena przechodzi bezpieczną kładką.
   - **RETIRE zrealizowane**: usunięto anomalię korelacyjną, stosunek 1.42, nieciągły cień i "WYNIK ZGODNY".
3. **Station 03 (Wiadomość Marty)**:
   - Przystanek techniczny ze słabym zasięgiem i opóźnioną tablicą.
   - Wiadomość SMS od Marty: `Miałaś wrócić. Napisz tylko, czy jedziesz.`
   - Lena kasuje dłuższą odpowiedź i odpisuje `Jadę.` — ustanowienie intymności i zmęczenia bez ujawniania natury relacji w Równi.
   - **RETIRE zrealizowane**: usunięto podwójne kubki, zmienione zdjęcie i komunikat "URLOP PRZERWANY".
4. **Station 04 (Przejazd)**:
   - Nocny przejazd wagonem; czytnik drgań w buforze powtarza trzysekundową lukę.
   - Lena restartuje czytnik, zabezpiecza kartę i odkłada urządzenie ekranem do dołu. Za oknem mija pomnik Linii 4.
   - **RETIRE zrealizowane**: usunięto strażnika IKP, dialog o martwym bracie Jakubie i inspekcję nadzoru UCP.
5. **Station 05 (Znana ulica)**:
   - Spokojny spacer znajomą ulicą w deszczu. Pełny oddech i stabilny punkt odniesienia normalności.
   - Szyld `UCP / PRACE NOCNE` wygląda jak logo nowej firmy budowlanej.
   - Zapisana flaga kampanii `ordinary_return_complete`.
   - **RETIRE zrealizowane**: usunięto zmienną geometrię, brakujące piętro i szept imienia.
6. **Station 06 (Dwa rozkłady)**:
   - Porównanie rozkładu jazdy: papierowy na tablicy vs zapis offline w aplikacji w telefonie mają tę samą datę, lecz różne numery linii.
   - Nadjeżdżający autobus potwierdza wersję papierową; Lena uznaje to za starą pamięć podręczną (`Cache. Najprostsze.`).
   - Pierwsza hipoteza i omylny model myśli Leny.
   - **RETIRE zrealizowane**: usunięto pasażera zwracającego obrączkę i dialog o obcej biografii.
7. **Station 07 (Herbata dla Marty / Kiosk)**:
   - Prawdziwy osiedlowy kiosk/sklep spożywczy ("Kiosk u Pawlaka").
   - Sprzedawca wita Lenę po imieniu i pyta o jaśminową herbatę dla Marty.
   - Lena pyta kontrolnie o wczorajszą wizytę; sprzedawca wskazuje wpis sprzedaży i zamyka sklep. Lena kupuje wodę i racjonalizuje sytuację pomyłką klientki / nazwiskiem na karcie. Ciało zatrzymuje się przed odebraniem butelki.
   - Koniec sceny kieruje do sprawdzenia adresu w Station 08.
   - **RETIRE zrealizowane**: usunięto Martę w progu klatki schodowej i ślepe schody.

## Sekwencja II/III — Rysa i cudzy dom 08–13 (Kanon 0.3)

8. **Station 08 (Numer czternaście)**:
   - Wejście do bloku przy Sadowej 7. Zaświadczenie terenowe Leny wskazuje mieszkanie 12, a lista domofonu przypisuje `LENA WOLSKA` do numeru 14.
   - Trzy odczyty (dokument, lista lokatorów, własny kod) otwierają drzwi wejściowe. Nic nie miga i nic się nie łamie.
9. **Station 09 (Sąsiadka z trzeciego)**:
   - Klatka schodowa bloku. Sąsiadka (Pani Danuta) wita Lenę, odnosząc się do wspólnej przeszłości i psa, którego przybyła Lena nigdy nie miała.
   - Lena zachowuje spokój, dziękuje, sprawdza tabliczkę piętra i wchodzi wyżej.
10. **Station 10 (Klucz)**:
    - Próg mieszkania 14. Klucz wchodzi do zamka i pasuje idealnie.
    - Otwarcie drzwi do w pełni wyposażonego mieszkania, które formalnie należy do Leny, lecz nie jest jej domem.
11. **Station 11 (Dwie osoby na zdjęciu)**:
    - Przedpokój i pokój dzienny. Fotografia na komodzie: Lena i Marta razem w górach z datą sprzed trzech lat.
    - Przybyła Lena pamięta tę samą wyprawę, lecz była na niej sama po rozstaniu.
12. **Station 12 (Wiadomość głosowa)**:
    - Telefon stacjonarny w mieszkaniu. Automatyczna sekretarka z nagraniem od Marty: prośba o odebranie telefonu i wspomnienie o biletach na niedzielę.
    - Zderzenie faktów: głos Marty, ale relacja jest aktualna i trwała.
13. **Station 13 (Dwie ważne wersje)**:
    - Biurko robocze z dokumentami. Teczka osobowa, zaświadczenie o zatrudnieniu w Miejskim Przedsiębiorstwie Trakcyjnym i identyfikator UCP.
    - Dwa sprzeczne zestawy dokumentów mające tę samą moc prawną i urzędową.

## Sekwencja IV/V — Marta, UCP i rozpoznanie 14–23 (Kanon 0.3)

14. **Station 14 (Próg Marty)**:
    - Mieszkanie Marty. Lena wchodzi do środka, kładzie torbę, konfrontuje się z codziennością Marty i odmawia rozmowy o pracy przed świtem.
15. **Station 15 (Ta sama wyprawa, inny skutek)**:
    - Kuchnia u Marty. Porównanie pamiętników i wspomnień (deszcz/pociąg vs słońce/przełęcz); telefon przerywa intymność.
16. **Station 16 (Zespół UCP-4)**:
    - Biuro pomiarowe UCP. Identyfikator biometryczny Leny działa, zadania pomiarowe z rejestru potwierdzają legalny status obu wersji.
17. **Station 17 (Nie powtarzać próbki)**:
    - Raport poufny UCP o anomalii na Linii 4 o godzinie 20:40; zalecenie wstrzymania ponownych pomiarów.
18. **Station 18 (Brak aktu zgonu)**:
    - Archiwum miejskie. Kwerenda w rejestrze zgonów: brak aktu zgonu brata Jakuba; karta zatrudnienia w podstacji trakcyjnej.
19. **Station 19 (Głos)**:
    - Budka telefoniczna. Rozmowa telefoniczna z żywym bratem Jakubem bez zdradzenia obcej tożsamości.
20. **Station 20 (Człowiek po tej dacie)**:
    - Podstacja trakcyjna. Bezpośrednie spotkanie z Jakubem; odmowa poddania się weryfikacji tożsamości.
21. **Station 21 (Trzy źródła / Rozpoznanie)**:
    - Zestawienie 3 niezależnych rodzin dowodów (czytnik drgań, rejestry publiczne, relacje osobiste).
    - Lena wypowiada kluczowe: »To nie jest mój świat«. Zamknięcie 4 hipotez roboczych, początek poszukiwań miejscowej Leny.
22. **Station 22 (Odchylenie w rejestrze)**:
    - Terminal diagnostyczny. Ślad celowej modyfikacji danych przez miejscową Lenę, odrzucenie oferty asymilacji UCP, kampanijny mechanizm Anchor/Yield.
23. **Station 23 (Martwy obwód)**:
    - Odcięta sekcja podstacji. Stabilizacja obwodu, nauka fizycznego kosztu manipulacji wektorami pamięci.

## Sekwencja VI/VII — Węzeł pod Linią 4, żywa odpowiedź i pierwsze koszty 24–30 (Kanon 0.3)

24. **Station 24 (Nie jesteś jej zastępstwem / Granice Marty)**:
    - Stacja nadzoru CCTV mieszkania 14. Wybór dyspozycji tożsamościowej wobec Dr Wierzbickiej (Consent, Refusal, Apparent Cooperation).
25. **Station 25 (Węzeł pod Linią 4 / Jakub)**:
    - Tranzyt Linii 4. Warunek pomocy Jakuba (D-09) i konfrontacja z motywacją brata.
26. **Station 26 (Przerwana próba / Stanowisko analizatora)**:
    - Śluza izolacyjna, cykl przegrody adaptacyjnej, formuła ugruntowania Leny na ścianie Podstruktury bez arcade'owych platform.
27. **Station 27 (Trzy powtórzenia / Żywy sygnał)**:
    - Węzeł tunelu technicznego. Jakub otwiera drogę do składu technicznego, żądając obietnicy, że Lena nie uczyni z innych długu wdzięczności.
    - Rejestracja powtarzających się sygnałów trakcyjnych z poziomu Podstruktury.
28. **Station 28 (Cena małego wyniku / Skład techniczny)**:
    - Wagon techniczny w ruchu pod Linią 4. Potrójny widok w oknie tranzytowym ukazujący rozbieżność planów rzeczywistości.
    - Komunikat interkomu Dr Wierzbickiej o domykaniu odciętych korytarzy.
29. **Station 29 (Jakub mówi nie / Peron trzynasty)**:
    - Opuszczony peron 13. Zardzewiałe tory, migający neon, studnia do Podstruktury i latarka Jakuba wskazująca kratę zejścia.
    - Decyzja o zejściu do Podstruktury.
30. **Station 30 (Trzy prognozy / Sektor Zasilania)**:
    - Główna rozdzielnia sektora 4. Trzy rozbieżne prognozy rozpływu mocy.
    - Przełączenie odłącznika sekcyjnego, rozładowanie baterii przekaźników i odblokowanie drogi do Magazynu Dowodów (Station 31).

## Sekwencja VIII/IX — Podstruktura, Magazyn Dowodów i rejestr par 31–37 (Kanon 0.3)

31. **Station 31 (Oferta adaptacji / Dwieście krzeseł)**:
    - Magazyn Dowodów Podstruktury. Archiwizowane krzesła, teczki i rejestry asymilacji.
    - Wierzbicka składa jawną ofertę adaptacji (zachowanie ciała, adresu i relacji za cenę wygaszenia sprzecznych wspomnień). Lena odmawia asymilacji (`s31_adaptation_refusal`).
32. **Station 32 (Szkło laboratoryjne / Pamięć materiału)**:
    - Laboratorium spektrometrii korelacyjnej. Zaparowane, popękane i wypolerowane tafle szkła.
    - Obserwacja zjawiska pamięci materiału i wytrasowanie Śladu w `ObservedGlassTrace` (`AnchorableObject`), zwalniającego właz rewizyjny.
33. **Station 33 (Szyb wentylacyjny / Notatka z warunkiem przerwania)**:
    - Szyb wentylacyjny na głębokości -40 m. Manometr, skrzynka kablowa i odnalezienie notatki miejscowej Leny (`DWIE STRONY / DWA ODCZYTY / BRAK ODPOWIEDZI = PRZERWIJ / ABORT PO 3 S`).
    - Korekta ramy `DualWitnessFrame` (`AnchorableObject`) i odblokowanie włazu do Maszynowni Głównej.
34. **Station 34 (Maszynownia Główna / Rejestr par)**:
    - Serce Maszynowni Głównej. Rdzeń Korelacyjny, bilans wektorów sprzeczności, odczyt rejestru par Lena A & Lena B (alokacja biograficzna).
    - Zabezpieczenie koordynatów powrotnych miejscowej Leny.
35. **Station 35 (Sektor Filtracji / Baseny Sedacyjne / Echo domu)**:
    - Sektor filtracji i baseny sedacyjne. Osad wypartych wspomnień i zawór spustowy.
    - Odbiór wiadomości głosowej od Marty domowej potwierdzającej brak swapu. Lena zdaje sobie sprawę z konieczności powrotu do własnego domu.
36. **Station 36 (Drenaż trakcyjny / Para katastrof)**:
    - Jaz burzowy i rwący nurt energii zrzutowej Linii 4.
    - Odkrycie rachunku katastrof: ocalenie 207 pasażerów w tym świecie kosztowało życie Jakuba w świecie domowym.
37. **Station 37 (Komora Sygnałowa / Żywy sygnał i granice Jakuba)**:
    - Oscyloskop, krosownica i maszt anteny transmisyjnej Podstruktury.
    - Odbiór żywego sygnału miejscowej Leny i ustalenie granicy współpracy z Jakubem (10 sekund synchronizacji nadajnika z ręką na wyłączniku).
    - Otwarcie bramy do Strefy Decyzji (Station 38).

## Architektura techniczna i prezentacja

- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - 13 stanów: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`.
  - Wzrost 48 px, anatomia, proporcje, wektorowe płaszczyzny, dynamiczny zwrot i wsparcie dla cue/override.
- **Prezentacja Rowień Pixel-Stage**:
  - `WorldPixelCompositor` (CanvasLayer 5) renderuje świat w siatce 2x2 nearest-neighbor (320x180).
  - `CrispDiegeticText` (CanvasLayer 10) renderuje ostre napisy diegetyczne w świecie.
  - `InnerThoughtSurface` (CanvasLayer 16) wyświetla myśli `LENA // MYŚL` i wskazówki.
  - `CRTDialogueBox` (CanvasLayer 20) wyświetla dialog mówiony.
  - Zero wywołań `draw_string()` w Layer 0 w skryptach Station 01..37.
- **NarrativeGuidanceService**:
  - Model: Pokaż → Naprowadź → Pomyśl → Sprawdź.
  - Wymuszony cooldown minimum 8s, omylne hipotezy (`hypothesis_id`, `predicted_check`), zamykanie hipotez po weryfikacji i syntezie.

## Stan weryfikacji

- `tools/verify.ps1` — **PASS (exit code 0)**:
  - Documentation contract — PASS
  - Godot headless import — PASS
  - Getting Strange smoke test (43 sceny) — PASS
  - Traversal contract lint (0 violations) — PASS
  - PKG-0095..PKG-0122 gates — PASS (w tym dedykowane `pkg_0118_smoke_test.gd`, `pkg_0119_smoke_test.gd`, `pkg_0120_smoke_test.gd`, `pkg_0121_smoke_test.gd`, `pkg_0122_smoke_test.gd` PASS)
- `tools/capture_preview.gd` — wygenerowano i zweryfikowano świeże klatki pod sterownikiem Windows dla stacji 01..43.

## Ostatnia swieza weryfikacja

- Data: 2026-08-25 po PKG-0122
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod wyjścia 0)
- Wynik `tools/capture_preview.gd`: wyrenderowano klatki dla wszystkich 43 stacji z oknem Windows OpenGL Compatibility, w tym `station_31_evidence.png`, `station_32_glass.png`, `station_33_vent.png`, `station_34_core.png`, `station_35_sedation.png`, `station_36_drain.png`, `station_37_signal.png`.

## Czego jeszcze nie potwierdzono

- Odbiór emocjonalny gracza i waga moralna wyboru finałowego (zgodnie z ADR-003 brak testów zewnętrznych przed P5).
- Przejście stacji 38–43 z formatu legacy na Kanon 0.3 (zaplanowane w mega-pakiecie PKG-0123).

## Nastepny pakiet

- **PKG-0123**: Sekwencja X: Metoda, konsekwencje i content lock 3.0 (Station 38–43: komora wyboru metody, odgałęzienia 42A/42B/42C, epilog 43 i finalny content lock).
