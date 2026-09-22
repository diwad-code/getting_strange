# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0016: Rozszerzenie interakcji i integracja układu puzzle w Komorze 2`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt.
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Dopracowanie i integracja układu puzzle skrzynia+podnośnik w Komorze 2 (PKG-0016):
1. Zweryfikowanie, że Chamber2Crate (MovableAnchorableProp) faktycznie ląduje na Chamber2Lift (AnchorableObject) gdy gracz ją popchnie — geometryczne wyrównanie, ewentualna korekta pozycji.
2. Opcjonalnie: dodanie drugiej skrzyni laboratoryjnej w Komorze 2 lub Komorze 3 jako przeszkody wymagającej sekwencji zakotwiczenia.
3. Opcjonalnie: wizualne etykiety laboratoryjne na skrzyni (draw() — kod jednostkowy, nie tekstury).
4. Rozszerzenie `tools/capture_preview.gd` o pozycjonowanie gracza blisko skrzyni w Chamber 2 i generowanie zrzutu z widoczną skrzynią.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Ostatni pakiet: PKG-0015.
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (np. `scripts/`, `scenes/`, `resources/`).

STAN BASELINE (PKG-0015):
- `MovableAnchorableProp` (`scripts/interactables/movable_anchorable_prop.gd`): CharacterBody2D, pchanie, grawitacja, kotwiczenie, opór korekty, AnchorableObject.RealityState.
- `Chamber2Crate` w `scenes/prototype/anchor_lab.tscn` na pozycji (800, 304), 28x28 px.
- `AnchorLab` rozszerzone o `active_prop_anchor`, `set_active_prop_anchor()`, push detection, prop reset w _respawn.
- 8 nowych testów smoke_test.gd (Test 4a–4h) — wszystkie zielone.
- Verify: DOCS PASS + SMOKE PASS.

ZADANIE:
1. Sprawdź geometrię: czy Chamber2Crate (800, 304) leży poprawnie na podłodze Komory 2 i czy po pchnięciu w prawo dotrze do Chamber2Lift (900, 320). Korekta pozycji jeśli potrzebna.
2. Dodaj zrzut kontrolny z widoczną skrzynią blisko podnośnika w capture_preview.gd.
3. Jeśli czas pozwala: druhą skrzynię w innym miejscu lub etykiety na skrzyni.
4. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
5. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0016`.
6. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0017.

KRYTERIA AKCEPTACJI
- Geometria Chamber2Crate i Chamber2Lift jest spójna — skrzynia może dosięgnąć podnośnika.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.
- CURRENT_STATE.md, SESSION_LOG.md i NEXT_SESSION_PROMPT.md są aktualne.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0016` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
