# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0118  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P4: relacyjna rewolucja fabuły i kontrolowana przebudowa gry Godot 4.7**
(`ADR-006`, `ADR-007`, `D-114`).

Foundation Slice (Station 01–07) został w pełni dostarczony i zweryfikowany zgodnie z Kanonem 0.3 (`docs/narrative/NARRATIVE_BIBLE.md`, `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/LENA_CHARACTER_AND_ANIMATION.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`, `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`).

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

## Architektura techniczna i prezentacja

- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - 13 stanów: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`.
  - Wzrost 48 px, anatomia, proporcje, wektorowe płaszczyzny, dynamiczny zwrot i wsparcie dla cue/override.
- **Prezentacja Rowień Pixel-Stage**:
  - `WorldPixelCompositor` (CanvasLayer 5) renderuje świat w siatce 2x2 nearest-neighbor (320x180).
  - `CrispDiegeticText` (CanvasLayer 10) renderuje ostre napisy diegetyczne w świecie.
  - `InnerThoughtSurface` (CanvasLayer 16) wyświetla myśli `LENA // MYŚL` i wskazówki.
  - `CRTDialogueBox` (CanvasLayer 20) wyświetla dialog mówiony.
  - Zero wywołań `draw_string()` w Layer 0 w skryptach Station 01..07.
- **NarrativeGuidanceService**:
  - Model: Pokaż → Naprowadź → Pomyśl → Sprawdź.
  - Wymuszony cooldown minimum 8s, omylne hipotezy (`hypothesis_id`, `predicted_check`), zamykanie hipotez po weryfikacji.

## Stan weryfikacji

- `tools/verify.ps1` — **PASS (exit code 0)**:
  - Documentation contract — PASS
  - Godot headless import — PASS
  - Getting Strange smoke test (43 sceny) — PASS
  - Traversal contract lint (0 violations) — PASS
  - PKG-0095..PKG-0118 gates — PASS (w tym dedykowany `pkg_0118_smoke_test.gd` PASS)
- `tools/capture_preview.gd` — wygenerowano i zweryfikowano świeże klatki pod sterownikiem Windows dla 01–07.

## Ostatnia swieza weryfikacja

- Data: 2026-08-25 po PKG-0118
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod wyjścia 0)
- Wynik `tools/capture_preview.gd`: wyrenderowano klatki dla stacji 01..07 z oknem Windows OpenGL Compatibility.

## Czego jeszcze nie potwierdzono

- Odbiór emocjonalny gracza i tempo narastania niepokoju (zgodnie z ADR-003 brak testów zewnętrznych przed P5).
- Przejście stacji 08–43 z formatu legacy na Kanon 0.3 (zaplanowane w pakietach PKG-0119..PKG-0123).

## Nastepny pakiet

- **PKG-0119**: Sekwencja II/III (Station 08–13 — Rysa i cudzy dom) według Kanonu 0.3.
