# Polecenie dla następnej sesji (High-Throughput Mega-Package)

Identyfikator pakietu: **PKG-0119**  
Zakres: **Station 08–13 — Sekwencja II/III: Rysa i cudzy dom (Eskalacja pęknięć) według Kanonu 0.3**  
Tryb: **Pełna autonomia inżynierska i artystyczna (D-025, D-085, ADR-004, ADR-007, D-114)**

---

## CEL SESJI

Zaimplementować, zintegrować i zweryfikować mega-pakiet **PKG-0119: Station 08–13 (Rysa i cudzy dom)** w pełnej zgodności z Kanonem 0.3 (`docs/narrative/FULL_STORY.md`, `docs/narrative/NARRATIVE_BIBLE.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/LENA_CHARACTER_AND_ANIMATION.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`, `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`).

---

## SRODOWISKO I BASELINE

- **Silnik**: Godot 4.7.stable.official.5b4e0cb0f (640x360 logical viewport, 60Hz physics).
- **Architektura wizualna**:
  - `WorldPixelCompositor` (Layer 5) downsample 2x2 do 320x180;
  - `CrispDiegeticText` (Layer 10) dla wszystkich napisów w świecie gry (zero `draw_string` w Layer 0);
  - `InnerThoughtSurface` (Layer 16) dla myśli Leny (`LENA // MYŚL`) i wskazówek (`WSKAZÓWKA // SYSTEM`);
  - `CRTDialogueBox` (Layer 20) dla dialogu mówionego;
  - `LenaVisualRig` (13 stanów, 48px wzrostu, oddech, system cue/override).
- **Guidance**: `NarrativeGuidanceService` z modelem Pokaż → Naprowadź → Pomyśl → Sprawdź, cooldownem >= 8s oraz zamykaniem hipotez (`close_hypothesis`).
- **Baseline weryfikacyjny**: PKG-0118 zakończony z kodem 0 we wszystkich testach i narzędziu `tools/verify.ps1`.

---

## ZADANIA WYKONAWCZE

### 1. Sceny i skrypty Station 08–13 (Kanon 0.3)
1. **Station 08 (Numer czternaście)**:
   - Klatka schodowa bloku. Lena szuka dawnego numeru 12, lecz tabliczki i rozkład wskazują mieszkanie 14.
   - Usunąć stary dialog/rekwizyty legacy. Wdrożyć tabliczki z `CrispDiegeticText`.
2. **Station 09 (Sąsiadka z trzeciego)**:
   - Sąsiadka wita Lenę naturalnie (`Dobry wieczór, Lena`), informuje, że nr 12 jest piętro niżej, a Lena od roku mieszka pod 14.
   - Lena pyta kontrolnie bez zdradzania zagubienia. Trzy źródła są spójne, ale sprzeczne z pamięcią Leny.
3. **Station 10 (Klucz)**:
   - Próg mieszkania 14. Klucz pasuje do zamka. Lena nie wchodzi odruchowo — odstawia torbę przy drzwiach, by móc uciec.
   - Obalenie hipotezy `błąd numeracji`, przejście do hipotezy `pomyłka lokalu / zbieg okoliczności`.
4. **Station 11 (Dwie osoby na zdjęciu)**:
   - Wnętrze mieszkania 14. Meble i czytnik pasują, lecz fotografia na komodzie przedstawia Lenę i Martę w jednoznacznym związku domowym/partnerskim.
   - Brak śladu Jakuba. Hipoteza kradzieży tożsamości / luki pamięci.
5. **Station 12 (Wiadomość głosowa)**:
   - Automatyczna sekretarka / telefon. Odsłuchanie wiadomości Marty: ton partnerki po sprzeczce, odniesienie do procedury UCP.
   - Głos to niewątpliwie Marta. Hipoteza `fałszywa Marta` upada.
6. **Station 13 (Dwie ważne wersje)**:
   - Porównanie dokumentów: zaświadczenie z torby vs umowa z szuflady. Obie wersje mają zachodzące daty i urzędowe pieczęcie.
   - Wykluczenie prostej przeprowadzki. Lena prosi Martę o spotkanie, by zweryfikować dzień przez żywą osobę.

### 2. Guidance i hipotezy
- Zarejestrować w `NarrativeGuidanceService`:
  - `hyp_address_shift` (Station 08)
  - `hyp_neighbor_confusion` (Station 09)
  - `hyp_lock_coincidence` (Station 10)
  - `hyp_identity_theft` (Station 11)
  - `hyp_memory_gap` (Station 12)
  - `hyp_conflicting_records` (Station 13)

---

## KRYTERIA AKCEPTACJI

1. Wszystkie sceny Station 08..13 instancjonują się i działają deterministycznie w pętli 60Hz.
2. Zero wywołań `draw_string()` w Layer 0 w skryptach stacji 08..13 (wszystkie napisy w `CrispDiegeticText` na Layer 10).
3. Żaden dialog ani tekst myśli w 08..13 nie zawiera zakazanych pojęć paranormalnych / przedwczesnych nazw innego świata (`Rówień`, `drugi świat`, `duplikat`, `korekta`, `inna linia czasowa`).
4. Stworzony test `tests/pkg_0119_smoke_test.gd` przechodzi na 100% zielono.
5. `pwsh -NoProfile -File .\tools\verify.ps1` zwraca kod 0.
6. `tools/capture_preview.gd` generuje świeże zrzuty dla scen 08..13 i podgląd potwierdza czytelność i styl Pixel-Stage.

---

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po ukończeniu implementacji i testów:
1. Zaktualizować `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`.
2. Dodać wpis w `docs/SESSION_LOG.md` dla PKG-0119.
3. Przygotować `docs/NEXT_SESSION_PROMPT.md` dla PKG-0120.
4. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0119`.
