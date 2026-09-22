# Prompt na następną sesję

Pakiet: **PKG-0127**  
Zakres: **Kompleksowy audyt masteringu i balansu: końcowa certyfikacja spójności audio/wideo na wszystkich 43 stacjach, weryfikacja zapisu, płynności przejść scenicznych oraz stabilności pamięci RAM**  
Data bazowa: 2026-08-25  
Rola agenta: Lead Programmer i Art Director (`D-025`, `D-085`, `ADR-004`, `ADR-007`, `D-114`, `D-115`, `D-116`, `D-117`, `D-118`)  
Tryb pracy: Pełna autonomia, wysoka przepustowość (mega-package), krok po kroku bez pytań blokujących.

## ZASADA WYDANIA (DYREKTYWA UŻYTKOWNIKA)
**NIE GENEROWAĆ PLIKU `.exe` ANI PACZEK BINARNYCH PO TYM PAKIECIE.** Weryfikację opierać na testach silnikowych Godota headless (`tools/verify.ps1`), inspekcji klatek i smoke testach. Eksport binarny zostanie uruchomiony dopiero po wyraźnym poleceniu użytkownika.

---

## CEL SESJI I ZADANIA DO WYKONANIA KROK PO KROKU

### 1. AUDYT PAMIĘCI RAM I PROFILOWANIE PROCESU
1. **Weryfikacja alokacji i zwalniania pamięci audio/wideo**:
   - Przetestować sekwencyjne ładowanie i zwalnianie scen 01..43, upewniając się, że generowane strumienie PCM w `ProceduralAudio` oraz tekstury świateł w `AtmosphereRig` nie wyciekają do pamięci podręcznej (zero `ObjectDB leaks`).
   - Wdrożyć czyszczenie pamięci podręcznej przy zmianie sceny w `GameStateManager`.

### 2. CERTYFIKACJA SPÓJNOŚCI PRZEJŚĆ SCENICZNYCH I CIĄGŁOŚCI DANYCH
1. **Dwukierunkowe przejścia i flagi fabularne**:
   - Zweryfikować przejścia tam i z powrotem między stacjami ze szczególnym uwzględnieniem drabin, wind i korytarzy tranzytowych.
   - Upewnić się, że flagi fabularne (`CONTINUITY_TRACKER`) poprawnie synchronizują się z zapisanym stanem gry po restarcie i kontynuacji.

### 3. GLOBALNY AUDYT WSPÓŁCZYNNIKA KONTRASTU I TYPOGRAFII
1. **Inspekcja warstw prezentacji**:
   - Zweryfikować brak kolizji wizualnych między `CrispDiegeticText` (Layer 10), `InnerThoughtSurface` (Layer 16) i `CRTDialogueBox` (Layer 20) w dynamicznych sytuacjach dialogowych.
   - Potwierdzić pełną ostrość i skalowalność tekstu w trybach powiększenia 85%–115%.

### 4. WERYFIKACJA AUTOMATYCZNA I BRAMKA TESTOWA PKG-0127
1. **Utworzenie testu `tests/pkg_0127_smoke_test.gd`**:
   - Sprawdzić alokacje, integralność zapisu, dwukierunkowość oraz współbieżność warstw UI.
2. **Integracja w `tools/verify.ps1`**:
   - Dodać bramkę PKG-0127 i uruchomić pełny suite weryfikacyjny.

---

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (GL Compatibility, 640x360, 60 Hz).
- **Kanon wizualny**: `VISUAL_DESIGN.md` (Rówień Pixel-Stage — 66 px LenaVisualRig 3.0).
- **Kanon narracyjny**: `docs/narrative/NARRATIVE_BIBLE.md` 0.3, `FULL_STORY.md` 0.3, `DIALOGUE_SCRIPT.md` 0.3.
- **Zasada twarda D-098**: Wyłącznie silnik Godot 4.7. Zero prac webowych.

---

## KRYTERIA AKCEPTACJI

1. **Zarządzanie zasobami**:
   - Płynne ładowanie i zwalnianie 43 stacji bez wycieków pamięci.
2. **Ciągłość i zapis**:
   - Deterministyczny zapis, odczyt i dwukierunkowa nawigacja bez desynchronizacji flag.
3. **Weryfikacja**:
   - Dedykowany test `tests/pkg_0127_smoke_test.gd` przechodzi pomyślnie.
   - `pwsh -NoProfile -File .\tools\verify.ps1` przechodzi z kodem wyjścia 0.
   - Wykonany snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0127`.
   - **NIE generować pliku exe**.

---

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po zakończeniu mega-pakietu:
1. Zaktualizować `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`.
2. Dodać wpis do `docs/SESSION_LOG.md`.
3. Wygenerować prompt dla kolejnego pakietu w `docs/NEXT_SESSION_PROMPT.md`.
4. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0127`.
