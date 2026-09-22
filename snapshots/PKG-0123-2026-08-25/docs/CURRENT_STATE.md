# Aktualny stan projektu

Stan na: 2026-08-25 po PKG-0123 (Content Lock 3.0)  
Katalog: `C:\getting_strange`  
Silnik: `Godot 4.7.stable.official.5b4e0cb0f`  
Wersjonowanie: brak; pliki na dysku są jedynym stanem (D-016)

## Aktywna faza

**P4: relacyjna rewolucja fabuły i kontrolowana przebudowa gry Godot 4.7 — ZAKOŃCZONA SUKCESEM (Content Lock 3.0 osiągnięty dla wszystkich 43 stacji)**
(`ADR-006`, `ADR-007`, `D-114`, `D-115`).

Wszystkie 43 przestrzenie kampanii (Station 01–43, w tym odgałęzienia finałowe 42A, 42B, 42C i epilog 43) zostały w pełni przebudowane, ujednolicone i zweryfikowane zgodnie z Kanonem 0.3 (`docs/narrative/NARRATIVE_BIBLE.md`, `docs/narrative/FULL_STORY.md`, `docs/narrative/DIALOGUE_SCRIPT.md`, `docs/narrative/CONTINUITY_TRACKER.md`, `docs/LENA_CHARACTER_AND_ANIMATION.md`, `docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md`, `docs/PIXEL_PRESENTATION_ARCHITECTURE.md`).

Aktywny plan: `docs/CREATIVE_REBUILD_PLAN.md` 3.0 (ukończony w 100%).  
Aktywny kanon wizualny: `VISUAL_DESIGN.md` — Rówień Pixel-Stage.  
Aktywny kanon fabuły: `docs/narrative/NARRATIVE_BIBLE.md` 0.3 i `docs/narrative/FULL_STORY.md` 0.3.  
Aktywny tracker ciągłości: `docs/narrative/CONTINUITY_TRACKER.md` 0.3.

## Sekwencja X — Metoda, konsekwencje i epilog 38–43 (Kanon 0.3)

38. **Station 38 (Marta nie przyjmuje legendy / Strefa Decyzji / Zgody Marty i Jakuba)**:
    - Odbiornik radiowy (łączność z Martą) i notatka z warunkiem przerwania po 3 sekundach.
    - Marta stawia własne granice i zgadza się na procedurę ratunkową bez przyjęcia fałszywych obietnic. Jakub ustala 10-sekundowe okno na rozdzielnicy.
    - Śluza `JakubRescueBulkhead` otwiera drogę do komory wyboru.
39. **Station 39 (Stół zgód i braków / Centralny Pulpit Wyboru Metody)**:
    - Trzy obwody transmisyjne (Metoda A: Wymuszenie powrotu, Metoda B: Zamknięcie Równi, Metoda C: Przejście wzajemne) i Rdzeń korelacyjny (58 px).
    - Bilans sześciu parametrów bez moralizowania i bez łatwego wyjścia. Ślad oddaje kontrolę Lenie.
40. **Station 40 (Ostatni impuls / Weryfikacja Dr Wierzbickiej / Poziom 0)**:
    - Sala Negocjacyjna na poziomie 0. Wierzbicka broni stabilności miasta, Marta patrzy bez uniku, Szymon zabezpiecza pamięć świadectwa.
    - Zezwolenie na przejście do stanowiska załączenia odpowiedzialności.
41. **Station 41 (Trzy testy po działaniu / Komora Przejścia / Świadome milczenie)**:
    - Trzy fizyczne konsole operacyjne A, B, C.
    - Świadome milczenie mechaniczne (brak arcade'owych przeszkód). Załączenie jednej z konsol zapisuje decyzję w `GameStateManager` i odryglowuje wrota do odpowiedniej przestrzeni finałowej (42A, 42B lub 42C).
42. **Station 42A (Wymuszenie powrotu — Własny pokój)**:
    - Powrót Leny A do świata domowego o 21:45. Dwa kubki na stole, rozmowa z domową Martą i przyjęcie nieodwracalnej ceny odciętej Równi.
43. **Station 42B (Zamknięcie Równi — Miejsce po niej)**:
    - Próg mieszkania 14 w Równi i obcy przystanek. Miejscowa Lena odzyskuje ciało i dom z Martą; Lena przybyła staje na obcym przystanku i wysyła wiadomość `Jadę`.
44. **Station 42C (Przejście wzajemne — Dwa tory i świadectwo)**:
    - Dwa równoległe tory porannego tramwaju. Obie Leny istnieją jednocześnie, most pozostaje częściowo otwarty z przeciekiem pamięci.
45. **Station 43 (Epilog konkretnych osób / Zapis nowej ciągłości)**:
    - Tablice ogłoszeń, karty spraw i rozkłady jazdy w mieście utrwalają stan sześciu podmiotów po wybranej operacji.
    - Ostatnia diegetyczna czynność i czysty powrót do ekranu tytułowego z oznaczeniem `campaign_completed = true`.

## Kompletny stan 43 stacji kampanii (Content Lock 3.0)

| Zakres stacji | Nazwa sekwencji / Aktu | Status | Prezentacja |
|---|---|---|---|
| **01–07** | Foundation Slice (Ostatni odczyt, Kiosk, Dwa rozkłady) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig, Guidance, CRT |
| **08–13** | Sekwencja II/III: Rysa i cudzy dom (Mieszkanie 14, Pamięć) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig, Guidance, CRT |
| **14–23** | Sekwencja IV/V: Marta, UCP i rozpoznanie (Budka, Jakub) | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig, Guidance, CRT |
| **24–30** | Sekwencja VI/VII: Węzeł pod Linią 4, żywa odpowiedź | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig, Guidance, CRT |
| **31–37** | Sekwencja VIII/IX: Podstruktura i rejestr par | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig, Guidance, CRT |
| **38–43** | Sekwencja X: Metoda, odgałęzienia 42A/B/C i epilog 43 | **CONTENT LOCK 3.0** | Pixel-Stage, LenaVisualRig, Guidance, CRT |

## Architektura techniczna i prezentacja

- **LenaVisualRig (`scripts/player/lena_visual_rig.gd`)**:
  - 13 stanów: `idle`, `start`, `walk`, `run`, `stop`, `turn`, `jump_rise`, `jump_fall`, `land`, `interact`, `examine`, `unease_reaction`, `seam_gesture`.
  - Wzrost 48 px, proporcje, wektorowe płaszczyzny, dynamiczny zwrot i wsparcie dla cue/override.
- **Prezentacja Rowień Pixel-Stage**:
  - `WorldPixelCompositor` (CanvasLayer 5) renderuje świat w siatce 2x2 nearest-neighbor (320x180).
  - `CrispDiegeticText` (CanvasLayer 10) renderuje ostre napisy diegetyczne w świecie.
  - `InnerThoughtSurface` (CanvasLayer 16) wyświetla myśli `LENA // MYŚL` i wskazówki.
  - `CRTDialogueBox` (CanvasLayer 20) wyświetla dialog mówiony.
  - Zero wywołań `draw_string()` w Layer 0 we wszystkich 43 stacjach gry.
- **NarrativeGuidanceService**:
  - Model: Pokaż → Naprowadź → Pomyśl → Sprawdź.
  - Wymuszony cooldown minimum 8s, omylne hipotezy (`hypothesis_id`, `predicted_check`), zamykanie hipotez po weryfikacji i syntezie.
- **GameStateManager**:
  - Pełna obsługa kampanii 01..43, wybór operacji `select_finale_operation("A"|"B"|"C")`, routing do `station_42a`, `station_42b`, `station_42c`, przejście do `station_43`, zapis i odczyt stanu oraz powrót do ekranu tytułowego.

## Stan weryfikacji

- `tools/verify.ps1` — **PASS (exit code 0)**:
  - Documentation contract — PASS (36 wymaganych plików i kontraktów)
  - Godot headless import — PASS
  - Getting Strange smoke test (43 sceny) — PASS
  - Traversal contract lint (0 violations) — PASS
  - PKG-0095..PKG-0123 gates — PASS (w tym dedykowany `pkg_0123_smoke_test.gd` PASS)
- `tools/capture_preview.gd` — wygenerowano i zweryfikowano świeże klatki pod sterownikiem Windows dla wszystkich stacji 01..43.

## Ostatnia swieza weryfikacja

- Data: 2026-08-25 po PKG-0123
- Wynik `pwsh -NoProfile -File .\tools\verify.ps1`: PASS (kod wyjścia 0)
- Wynik `tools/capture_preview.gd`: wyrenderowano klatki dla wszystkich 43 stacji z oknem Windows OpenGL Compatibility, w tym `station_38.png`, `station_39.png`, `station_40.png`, `station_41.png`, `station_42a.png`, `station_42b.png`, `station_42c.png`, `station_43.png`.

## Czego jeszcze nie potwierdzono

- Odbiór emocjonalny gracza i subiektywny ciężar wyborów moralnych w finałach (zgodnie z ADR-003 brak testów zewnętrznych przed P5).
- Stabilność binarnych buildów produkcyjnych na różnych dystrybucjach Linuxa i konfiguracjach Windows (zaplanowane w P5 / PKG-0124).

## Nastepny pakiet

- **PKG-0124**: Faza P5: Release Candidate — przygotowanie paczki dystrybucyjnej, optymalizacja assetów, audyt wydajności 60 Hz i finalny master release.
