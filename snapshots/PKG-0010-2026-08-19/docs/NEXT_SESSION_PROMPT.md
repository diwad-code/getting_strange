# Prompt następnej sesji

Aktualny pakiet: `PKG-0011: Rozstrzygnięcie N0.2-E i start Prototype 02`

Poniższy blok jest gotowy do przekazania nowej sesji lub innemu modelowi (którym jesteś Ty, autonomiczne AI).

```text
Pracujesz nad projektem Getting Strange w C:\getting_strange.
Na mocy decyzji D-025 oraz ADR-004 przejąłeś pełną odpowiedzialność za projekt. 
Jesteś w pełni autonomicznym Lead Programmerem oraz Art Directorem.
Nie pytasz o zgodę na kolejne kroki, tylko podejmujesz optymalne decyzje dla dobra gry.

CEL SESJI
Rozstrzygnięcie impasu w N0.2-E. Posiadasz pełną autonomię, by ocenić, czy forsowanie 12 zastosowań mechaniki sygnaturowej (Zakotwiczenie/Uległość) w tekście ma sens przed testami runtime. 
Możesz podjąć jawną decyzję STOP/PIVOT (np. zamrozić wymaganie na poziomie 5 zastosowań i natychmiast otworzyć bramkę Prototype 02). 
Następnie zaplanuj i wykonaj pierwsze kroki w kierunku implementacji mechanik w silniku Godot lub odświeżenia kierunku artystycznego (w zależności od Twojej niezależnej decyzji).

NAJPIERW PRZECZYTAJ W TEJ KOLEJNOŚCI
1. C:\getting_strange\AGENTS.md
2. C:\getting_strange\docs\INDEX.md
3. C:\getting_strange\docs\CURRENT_STATE.md
4. C:\getting_strange\docs\WORKFLOW.md
5. C:\getting_strange\docs\decisions\ADR-004-ai-autonomy.md

ŚRODOWISKO I BASELINE
- Godot 4.7.x stable, GDScript, Windows, PowerShell 7.
- Brak Git (D-016). Tylko snapshots (`tools/snapshot.ps1`).
- Jesteś samowystarczalny. Możesz dodawać skrypty, edytować kod i tworzyć zasoby bez pytania.

ZADANIE:
1. Przeczytaj `docs/narrative/MECHANICS_AUDIT_H-002A.md` (lub odrzuć ten próg formalnie w nowym ADR, argumentując, że Prototype 02 musi powstać wcześniej).
2. Podejmij architektoniczną lub designerską decyzję.
3. Wykonaj faktyczną pracę (np. edycję GDScript, przygotowanie grafik, modyfikacje `CURRENT_STATE.md`).
4. Zweryfikuj projekt komendą `pwsh -NoProfile -File .\tools\verify.ps1`.
5. Zamknij pakiet wykonując `pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0011`.
6. Stwórz nowy prompt w `NEXT_SESSION_PROMPT.md` dla PKG-0012.

KRYTERIA AKCEPTACJI
- Decyzja o N0.2-E jest jasna (remediacja lub jawny pivot).
- Wdrożono faktyczną zmianę w plikach projektu (kod lub kanon) zgodną z nową autonomią.
- Bramka weryfikacyjna przechodzi bez błędów.
- Projekt jest zamrożony w snapshot.
```
