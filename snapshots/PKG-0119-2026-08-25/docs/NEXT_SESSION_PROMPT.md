# Polecenie dla następnej sesji (High-Throughput Mega-Package)

Identyfikator pakietu: **PKG-0120**  
Zakres: **Station 14–23 — Sekwencja IV/V/VI: Marta, zapis, niemożliwy brat i rozpoznanie według Kanonu 0.3**  
Tryb: **Pełna autonomia inżynierska i artystyczna (D-025, D-085, ADR-004, ADR-007, D-114)**

---

## CEL SESJI

Zaimplementować, zintegrować i zweryfikować mega-pakiet **PKG-0120: Station 14–23** w pełnej zgodności z Kanonem 0.3 (`docs/narrative/FULL_STORY.md`, `docs/narrative/NARRATIVE_BIBLE.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/LENA_CHARACTER_AND_ANIMATION.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`, `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`).

To jest pakiet rozpoznania. Kończy się jedynym zdaniem, które wolno wypowiedzieć dopiero
po skompletowaniu trzech niezależnych rodzin dowodów: `To nie jest mój świat.`

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
- **Model porażki**: strata podejścia zabiera jeden czytelny szczegół i zapisuje koszt przez `GameStateManager.record_decision`. Bez śmierci, bez health baru, bez platformowego timingu.
- **Baseline weryfikacyjny**: PKG-0119 zakończony z kodem 0 we wszystkich testach i narzędziu `tools/verify.ps1`.

---

## ZADANIA WYKONAWCZE

### 1. Sceny i skrypty Station 14–23 (Kanon 0.3)

1. **Station 14 (Próg Marty)**:
   - Marta przychodzi do wspólnego domu i oczekuje partnerki. Lena zna ją dobrze, ale nie w ten sposób.
   - Porównanie godziny, terenowego sprzętu i położenia klucza. Marta zatrzymuje gest powitania i zajmuje dłonie czajnikiem.
   - Marta dopuszcza uraz, chorobę lub manipulację. Bez oskarżeń i bez diagnozy.
2. **Station 15 (Ta sama wyprawa, inny skutek)**:
   - Obie pamiętają tę samą wyprawę terenową: u Leny zakończyła przyjaźń zawodową, w Równi rozpoczęła związek.
   - Gracz wybiera konkret (pogoda, uszkodzone ogrodzenie, zdanie po powrocie); każda odpowiedź odsłania inną spójną historię.
   - Marta chce wezwać lekarza i zabezpieczyć telefon miejscowej Leny; Lena odbiera to jako odebranie sprawczości.
3. **Station 16 (Zespół UCP-4)**:
   - Biuro pomiarowe. Karta Leny ma obcy numer, ale biometryka rozpoznaje jej ciało i przypisuje ją do zespołu UCP-4.
   - Porównanie numeru karty, profilu biometrycznego, 186 dni aktywności i grafiku dzisiejszej próby.
   - Nazwisko Wierzbickiej przy zatwierdzeniu testu o 20:40. Skrót UCP nadal może oznaczać program albo klienta.
4. **Station 17 (Nie powtarzać próbki)**:
   - Raport `INCYDENT CIĄGŁOŚCI POMIARU`; głos Wierzbickiej przez interkom nakazuje odłożyć czytnik i czekać.
   - Lena kopiuje nagłówek i wychodzi drogą serwisową, zanim ochrona zamknie sektor.
   - Dwie próby o tej samej sekundzie; lokalny raport nie zawiera numeru czytnika Leny.
5. **Station 18 (Brak aktu zgonu)**:
   - Rejestr miejski i szpital: brak aktu zgonu Jakuba, są późniejsze wpisy, adres i karta pracownika Linii 4.
   - Błąd migracji musiałby objąć dwa niezależne systemy i dziewięć lat życia.
6. **Station 19 (Głos)**:
   - Jakub dzwoni po wiadomości od Marty i zna rodzinny konkret spoza bazy.
   - Lena pyta o schowek u babci, potem o ostatnią rozmowę przed katastrofą. Pierwszą odpowiedź zna, drugą pamięta inaczej.
   - W tle realny warsztat Linii 4, nigdy upiorny efekt.
7. **Station 20 (Człowiek po tej dacie)**:
   - Spotkanie publiczne z Martą obok. Znajome ciało, obca relacja.
   - Gracz może poprosić o bliznę, skan numeru czytnika i porównanie gestu; Jakub może odmówić zbyt inwazyjnej próby.
   - Czytnik Leny nie istnieje w lokalnej bazie serwisowej.
8. **Station 21 (Trzy źródła)**:
   - Interaktywna synteza: czytnik i próbka, lokalne rejestry biografii, zapis i obecność Jakuba. Każde źródło unieważnia jedną hipotezę.
   - Dopiero komplet trzech rodzin dowodów ustawia `world_recognized` i odblokowuje `To nie jest mój świat.` oraz odpowiedź Marty `Więc gdzie jest ona?`.
9. **Station 22 (Odchylenie w rejestrze)**:
   - Wierzbicka nawiązuje kontakt, nazywa Lenę `odchyleniem biograficznym` i oferuje bezpieczne odosobnienie. Lena odmawia oddania czytnika.
   - Pierwsze świadome porównanie dwóch zachowań sygnału i robocze nazwy Zakotwiczenie i Uległość.
10. **Station 23 (Martwy obwód)**:
    - Nauka metody bez używania człowieka i bez ważnego zapisu; obwód ma dwa sprzeczne stany kontrolne.
    - Zakotwiczenie przegrzewa sąsiedni przekaźnik, Uległość osłabia znacznik adresu. Koszt widoczny przed komentarzem.
    - Ustawienie `local_lena_search_started` dopiero po rozpoznaniu w 21.

### 2. Guidance i hipotezy

- Zarejestrować w `NarrativeGuidanceService`:
  - `hyp_medical_cause` (Station 14)
  - `hyp_rehearsed_memory` (Station 15)
  - `hyp_account_tampering` (Station 16)
  - `hyp_ucp_forgery` (Station 18)
  - `hyp_impersonation_call` (Station 19)
  - `hyp_single_world_error` (Station 21 — hipoteza obalana przez komplet trzech źródeł)
- Station 21 musi zamykać hipotezy `hyp_conflicting_records`, `hyp_memory_gap`, `hyp_ucp_forgery` i `hyp_single_world_error`, a nie tylko rejestrować nowe.

---

## KRYTERIA AKCEPTACJI

1. Wszystkie sceny Station 14..23 instancjonują się i działają deterministycznie w pętli 60Hz.
2. Zero wywołań `draw_string()` w Layer 0 w skryptach stacji 14..23 (wszystkie napisy w `CrispDiegeticText` na Layer 10).
3. Kontrakt wiedzy: zdanie `To nie jest mój świat.` oraz flaga `world_recognized` są nieosiągalne, dopóki gracz nie zbierze trzech niezależnych rodzin dowodów w Station 21. Flaga `local_lena_search_started` nie może zostać ustawiona przed `world_recognized`.
4. Żaden dialog ani tekst myśli w 14..20 nie nazywa drugiego świata (`Rówień`, `drugi świat`, `duplikat`, `inna linia czasowa`) — nazwa jest dozwolona dopiero od Station 21.
5. Stworzony test `tests/pkg_0120_smoke_test.gd` przechodzi na 100% zielono.
6. `pwsh -NoProfile -File .\tools\verify.ps1` zwraca kod 0.
7. `tools/capture_preview.gd` generuje świeże zrzuty dla scen 14..23 i podgląd potwierdza czytelność i styl Pixel-Stage.
8. Bramki dziedziczone (`tests/smoke_test.gd`, `tests/pkg_0099_smoke_test.gd`, `tests/pkg_0095_smoke_test.gd`, `tools/capture_pkg_0099.gd`) zostają uzgodnione z nowymi scenami, a nie obchodzone.

---

## KONIEC PAKIETU JEST OBOWIAZKOWY

Po ukończeniu implementacji i testów:
1. Zaktualizować `docs/CURRENT_STATE.md`, `docs/ROADMAP.md`, `docs/RISKS_AND_HYPOTHESES.md`.
2. Dodać wpis w `docs/SESSION_LOG.md` dla PKG-0120.
3. Przygotować `docs/NEXT_SESSION_PROMPT.md` dla PKG-0121.
4. Wykonać snapshot: `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0120`.
