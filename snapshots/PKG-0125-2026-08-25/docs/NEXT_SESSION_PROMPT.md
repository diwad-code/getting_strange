# Prompt na następną sesję

Pakiet: **PKG-0126**  
Zakres: **Zwieńczenie szlifu atmosferycznego, kinowe pejzaże dźwiękowe podstruktury, niuanse oświetlenia wektorowego w finałach oraz finalny przegląd balansu CRT**  
Data bazowa: 2026-08-25  
Rola agenta: Lead Programmer i Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`, `D-115`, `D-116`, `D-117`)  
Tryb pracy: Pełna autonomia, wysoka przepustowość (mega-package), krok po kroku bez pytań blokujących.

## ZASADA WYDANIA (DYREKTYWA UŻYTKOWNIKA)
**NIE GENEROWAĆ PLIKU `.exe` ANI PACZEK BINARNYCH PO TYM PAKIECIE.** Weryfikację opierać na testach silnikowych Godota headless (`tools/verify.ps1`), inspekcji klatek i smoke testach. Eksport binarny zostanie uruchomiony dopiero po zakończeniu wszystkich prac na wyraźny sygnał użytkownika.

---

## CEL SESJI I ZADANIA DO WYKONANIA KROK PO KROKU

### 1. SYNTEZA DŹWIĘKOWYCH PEJZAŻY PODSTRUKTURY I FINAŁÓW
1. **Rozbudowa syntezatorów w `ProceduralAudio`**:
   - Dodać wielowarstwowe tła akustyczne dla stacji podziemnych i maszynowni (`station_31` do `station_41`): rezonans komór chłodzenia, szum magistrali wysokiego napięcia, echa hydrauliczne.
   - Wdrożyć dedykowane tematy dźwiękowe dla trzech rozgałęzień finałowych (`station_42a` — wymuszenie powrotu, `station_42b` — zamknięcie Równi, `station_42c` — przejście wzajemne).
2. **Dynamiczna modulacja audio w zależności od stanu Leny**:
   - Przyciemnianie tonów wysokich (filtracja dolnoprzepustowa) w momentach silnego niepokoju (`unease_reaction`).

### 2. KINOWE ŚWIATŁO WEKTOROWE I EFEKTY WIZUALNE RÓWIEŃ PIXEL-STAGE
1. **Rozszerzenie profili oświetlenia w `AtmosphereRig`**:
   - Dodać delikatne pulsowanie świateł awaryjnych i neonów miejskich na stacjach 08..13 oraz 24..30.
   - Wzmocnić dramatyczny kontrast w stacji 40 (gabinet Wierzbickiej) i 41 (komora wyboru operacyjnego).
2. **Subtelne mikrodynamiczne cząstki pyłu i pary**:
   - Dodać wektorowe cząsteczki pary z kratek wentylacyjnych oraz zawiesiny pyłowej w opuszczonych sektorach.

### 3. PRZEGLĄD BALANSU CZASU TRWANIA DIALOGÓW CRT I PRĘDKOŚCI TEKSTU
1. **Optymalizacja interwałów CRTDialogueBox**:
   - Przetestować i dopasować domyślne tempo pisania (znaki/s) oraz czas podtrzymania kwestii dialogowych przy automatycznym odtwarzaniu.
   - Zweryfikować idealną czytelność napisów w polskich i angielskich wersjach językowych.

### 4. WERYFIKACJA AUTOMATYCZNA I BRAMKA TESTOWA PKG-0126
1. **Utworzenie testu `tests/pkg_0126_smoke_test.gd`**:
   - Zweryfikować nowe generatory dźwięku, profile oświetlenia i czasy dialogów.
2. **Integracja w `tools/verify.ps1`**:
   - Dodać bramkę PKG-0126 i uruchomić pełny suite weryfikacyjny.

---

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (GL Compatibility, 640x360, 60 Hz).
- **Kanon wizualny**: `VISUAL_DESIGN.md` (Rówień Pixel-Stage — 66 px LenaVisualRig 3.0).
- **Kanon narracyjny**: `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `FULL_STORY.md` 0.3, `DIALOGUE_SCRIPT.md` 0.3.
- **Zasada twarda D-098**: Wyłącznie silnik Godot 4.7. Zero prac webowych.

---

## KRYTERIA AKCEPTACJI

1. **Proceduralne pejzaże dźwiękowe**:
   - Kompletne tła podstruktury i finałów generowane w pamięci RAM bez zewnętrznych assetów.
2. **Oświetlenie wektorowe**:
   - Wzbogacone profile oświetlenia i atmosfery w `AtmosphereRig` dla kluczowych stacji.
3. **Pacing CRT**:
   - Płynny i czytelny dialog we wszystkich 43 stacjach w językach PL i EN.
4. **Weryfikacja**:
   - Dedykowany test `tests/pkg_0126_smoke_test.gd` przechodzi pomyślnie.
   - `pwsh -NoProfile -File .\tools\verify.ps1` przechodzi z kodem wyjścia 0.
   - Wykonany snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0126`.
   - **NIE generować pliku exe**.

---

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po zakończeniu mega-pakietu:
1. Zaktualizować `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`.
2. Dodać wpis do `docs/SESSION_LOG.md`.
3. Wygenerować prompt dla kolejnego pakietu w `docs/NEXT_SESSION_PROMPT.md`.
4. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0126`.
