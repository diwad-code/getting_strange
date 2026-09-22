# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0119  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P4: relacyjna rewolucja fabuły i kontrolowana przebudowa gry Godot 4.7**
(`ADR-006`, `ADR-007`, `D-114`).

Foundation Slice (Station 01–07) oraz Sekwencja II/III (Station 08–13 — Rysa i cudzy dom) zostały w pełni dostarczone i zweryfikowane zgodnie z Kanonem 0.3 (`docs/narrative/NARRATIVE_BIBLE.md`, `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/LENA_CHARACTER_AND_ANIMATION.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`, `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`).

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
   - Hipoteza `hyp_address_shift` (`Ktoś przełożył numery.`) z przewidywanym sprawdzeniem drzwi i administracji.
   - **RETIRE zrealizowane**: usunięto wnętrze mieszkania Marty, szufladę szyfrową i szkice Podstruktury z tej przestrzeni.
9. **Station 09 (Sąsiadka z trzeciego)**:
   - Klatka schodowa. W miejscu gaśnicy stoi ciężka donica, którą trzeba przepchnąć do wnęki.
   - Sąsiadka wita Lenę naturalnie (`Dobry wieczór, Lena`), wskazuje dwunastkę piętro niżej i przypisuje Lenie czternastkę od roku.
   - Hipoteza `hyp_neighbor_confusion` (`Myli piętra. Ludzie mylą piętra.`).
   - **RETIRE zrealizowane**: usunięto łazienkę, lustro obserwowane i napis `NIE SZUKAJ ORYGINAŁU`.
10. **Station 10 (Klucz)**:
    - Próg mieszkania 14. Klucz obraca się bez oporu; sam klucz nie wpuszcza Leny odruchowo do środka.
    - Lena odstawia torbę przy drzwiach, żeby móc wyjść w trzy kroki. Dopiero wtedy próg się otwiera.
    - Pasujący klucz zamyka hipotezę `hyp_address_shift` i otwiera `hyp_lock_coincidence` (`Ta sama seria zamków.`).
    - **RETIRE zrealizowane**: usunięto telefon Jakuba, magnetofon szpulowy i bramkę tożsamości.
11. **Station 11 (Dwie osoby na zdjęciu)**:
    - Wnętrze mieszkania 14. Buty robocze, płaszcz i stacja czytnika pasują do ciała i zawodu Leny.
    - Fotografia na komodzie pokazuje Lenę i Martę w domowej, partnerskiej relacji. Jakuba na niej nie ma.
    - Komoda w przedpokoju wymaga przepchnięcia; przeciśnięcie się zrzuca ramkę i zabiera ostrość jednej twarzy.
    - Hipoteza `hyp_identity_theft` (`Nie zrobiłaby takiego zdjęcia.`).
    - **RETIRE zrealizowane**: usunięto dziedziniec, zespół interwencyjny UCP i zatarty ślad drzwi.
12. **Station 12 (Wiadomość głosowa)**:
    - Automatyczna sekretarka. Uchylony balkon zagłusza nagranie i blokuje przejście, więc Lena najpierw domyka skrzydło.
    - Wiadomość Marty w brzmieniu kanonicznym; Lena zatrzymuje ją na słowie `znowu`, cofa i słucha ponownie bez komentarza.
    - Głos jest niewątpliwie Marty, więc hipoteza podszywania się (`hyp_identity_theft`) zostaje obalona; rośnie `hyp_memory_gap`.
    - Zamiast odpowiadać na gorąco, Lena sprawdza numer i zapisuje dwa pytania.
    - **RETIRE zrealizowane**: usunięto przejście podziemne, terminal informacyjny UCP i pokaz bezpieczeństwa.
13. **Station 13 (Dwie ważne wersje)**:
    - Porównanie zaświadczenia z torby z umową najmu z szuflady. Zachodzące daty, różne adresy, dwie prawidłowe pieczęcie.
    - Szuflada po wysunięciu blokuje przejście; przeciskanie się rozsypuje papiery i zamazuje jedną pieczęć.
    - Para dokumentów wyklucza zwykłą przeprowadzkę i zamyka hipotezę `hyp_lock_coincidence`; otwiera się `hyp_conflicting_records`.
    - Lena prosi Martę o spotkanie i mówi tylko, że potrzebuje potwierdzić dzisiejszy dzień.
    - **RETIRE zrealizowane**: usunięto archiwum kreślarskie, kabinę rezonansu i fotografię Jakuba.

## Architektura techniczna i prezentacja

- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - 13 stanów: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`.
  - Wzrost 48 px, anatomia, proporcje, wektorowe płaszczyzny, dynamiczny zwrot i wsparcie dla cue/override.
- **Prezentacja Rowień Pixel-Stage**:
  - `WorldPixelCompositor` (CanvasLayer 5) renderuje świat w siatce 2x2 nearest-neighbor (320x180).
  - `CrispDiegeticText` (CanvasLayer 10) renderuje ostre napisy diegetyczne w świecie.
  - `InnerThoughtSurface` (CanvasLayer 16) wyświetla myśli `LENA // MYŚL` i wskazówki.
  - `CRTDialogueBox` (CanvasLayer 20) wyświetla dialog mówiony.
  - Zero wywołań `draw_string()` w Layer 0 w skryptach Station 01..13.
- **NarrativeGuidanceService**:
  - Model: Pokaż → Naprowadź → Pomyśl → Sprawdź.
  - Wymuszony cooldown minimum 8s, omylne hipotezy (`hypothesis_id`, `predicted_check`), zamykanie hipotez po weryfikacji.

## Stan weryfikacji

- `tools/verify.ps1` — **PASS (exit code 0)**:
  - Documentation contract — PASS
  - Godot headless import — PASS
  - Getting Strange smoke test (43 sceny) — PASS
  - Traversal contract lint (0 violations) — PASS
  - PKG-0095..PKG-0119 gates — PASS (w tym dedykowane `pkg_0118_smoke_test.gd` i `pkg_0119_smoke_test.gd` PASS)
- `tools/capture_preview.gd` — wygenerowano i zweryfikowano świeże klatki pod sterownikiem Windows dla 01–13.

## Ostatnia swieza weryfikacja

- Data: 2026-08-25 po PKG-0119
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod wyjścia 0)
- Wynik `tools/capture_preview.gd`: wyrenderowano klatki dla stacji 01..13 z oknem Windows OpenGL Compatibility, w tym `station_08.png`, `station_08_open.png`, `station_09.png`, `station_09_neighbour.png`, `station_10.png`, `station_10_threshold.png`, `station_11.png`, `station_11_photograph.png`, `station_12.png`, `station_12_message.png`, `station_13.png`, `station_13_documents.png`.

## Czego jeszcze nie potwierdzono

- Odbiór emocjonalny gracza i tempo narastania niepokoju (zgodnie z ADR-003 brak testów zewnętrznych przed P5).
- Przejście stacji 14–43 z formatu legacy na Kanon 0.3 (zaplanowane w pakietach PKG-0120..PKG-0123).
- Czytelność pary sprzeczności 08–13 dla osoby z zewnątrz: bez dowodu odbiorczego (ADR-003).

## Nastepny pakiet

- **PKG-0120**: Sekwencja IV/V (Station 14–23 — Marta, UCP i rozpoznanie) według Kanonu 0.3.
