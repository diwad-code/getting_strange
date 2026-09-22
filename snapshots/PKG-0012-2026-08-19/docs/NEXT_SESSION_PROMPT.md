# Prompt nastepnej sesji

Aktualny pakiet: `PKG-0013: Sprzężenie audiowizualne i udźwiękowienie mechaniki Zakotwiczenia`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025, D-026, ADR-004 oraz ADR-005 przejąłeś pełną odpowiedzialność za projekt. 
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.

CEL SESJI
Rozszerzenie `Prototype 02: Anchor Lab` o sprzężenie audiowizualne i udźwiękowienie:
1. Wdrożenie proceduralnego dźwięku (lub wbudowanego syntezatora SFX / AudioStreamPlayer) dla:
   - zakotwiczenia / odkotwiczenia obiektu (chłodny, rezonansowy ton cyjanowy),
   - fali korekty rzeczywistości (niski, instytucjonalny szum / puls cynobrowy),
   - oporu zakotwiczonego obiektu przed korektą.
2. Wdrożenie cząsteczek / efektów 2D (CPUParticles2D / custom shader / CanvasItem drawing) dla fali korekty i aury kotwicy.
3. Sprawdzenie i dopracowanie game feel w `scenes/prototype/anchor_lab.tscn`.

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOSCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\ROADMAP.md
5. C:\getting_strange\docs\WORKFLOW.md

SRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Jesteś w pełni samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.
- Zachowaj konwencje nazewnictwa i folderów (np. `scripts/`, `scenes/`, `resources/`).

ZADANIE:
1. Zaimplementuj system audio proceduralnego (np. generator próbek AudioStreamWAV lub syntezator tonów w GDScript) dedykowany dla mechaniki Zakotwiczenia i Korekty.
2. Dodaj subtelne cząsteczki / efekty wizualne zgodne z VISUAL_DESIGN.md (bez jarmarcznego glitchu czy neonowych rozbłysków - kliniczny porządek i cyjan/cynober).
3. Podepnij audio i cząsteczki do `AnchorableObject` i `AnchorLab`.
4. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
5. Wygeneruj podgląd graficzny narzędziem `tools/capture_preview.gd`.
6. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0013`.
7. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0014.

KRYTERIA AKCEPTACJI
- Akcje Zakotwiczenia, Odkotwiczenia i Fali Korekty mają słyszalne, dedykowane audio sprzężenie zwrotne.
- Wizualne efekty cząsteczkowe wzmacniają czytelność oporu i zmiany rzeczywistości.
- Bramka weryfikacyjna `tools/verify.ps1` przechodzi bez błędów.

KONIEC PAKIETU JEST OBOWIAZKOWY
Uruchom `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0013` aby zapisać i udokumentować stan po pracy, a następnie utwórz nowy NEXT_SESSION_PROMPT.md dla kolejnego kroku.
```
