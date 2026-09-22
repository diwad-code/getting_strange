# NEXT_SESSION_PROMPT — PKG-0189 (P3 residual-boundary audit)

> Przejmujesz Getting Strange jako **Lead Programmer**. PKG-0188 jest zamknięty
> technicznie. Ten pakiet nie implementuje release'u, contentu ani refaktoru:
> tworzy weryfikowalną specyfikację wykonawczą dwóch pozostałych długów P3,
> zanim ktokolwiek dotknie ich kodu.

## CEL SESJI

Rozdzielić na faktach F-0184-010 i F-0184-012 z
`docs/rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md`:

1. **F-0184-010:** zinwentaryzować odpowiedzialności, publiczne call-site'y,
   state, sygnały i kontrakty `scripts/interactables/memory_resonance_point.gd`.
   Zaproponować małe granice ekstrakcji wraz z testami migracji; nie edytować
   tego monolitu i nie wykonywać ekstrakcji w tym pakiecie.
2. **F-0184-012:** porównać runtime Station 10–13 z aktywnym `CAMPAIGN_MAP`,
   scenami i ich testami; wypisać konkretne hybrydowe zachowania P7 oraz mapę
   minimalnych, izolowanych pakietów naprawczych. Nie przebudowywać scen 10–13.
3. Utworzyć jeden raport/specyfikację, test statycznego inventory oraz kolejny
   prompt, który ma mierzalny zakres implementacji. Nie deklarować poprawy
   produktu, zabawy, emocji, zrozumienia ani PRODUCT GO.

## SRODOWISKO I BASELINE

- Katalog: `C:\getting_strange`; Godot 4.7.2; viewport 640×360; fizyka 60 Hz.
- Ostatni pakiet: **PKG-0188**. Raport: `docs/rebuild/PKG_0188_HYGIENE_REPORT.md`.
- PKG-0188: `pkg_0091`/`pkg_0094` są w `verify.ps1`; PCM ma jedną granicę w
  `generate_wav`; `getting_strange_locales.csv` jest RETIRED i nieroutowany.
- Nie nadpisuj `reports/pkg_0182/` … `reports/pkg_0187/`. Nie uruchamiaj Git,
  release'u, exportu ani nowego `.exe`; web pozostaje poza zakresem (D-168).

Przed pierwszą edycją:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

## OBOWIAZKOWA KOLEJNOŚĆ CZYTANIA

1. `AGENTS.md`, `docs/INDEX.md`, `docs/CURRENT_STATE.md`, ten prompt i
   `docs/WORKFLOW.md`.
2. `docs/rebuild/PKG_0184_FINAL_CERTIFICATION_REPORT.md` oraz
   `docs/rebuild/PKG_0188_HYGIENE_REPORT.md`.
3. `docs/rebuild/CAMPAIGN_MAP.md`, odpowiednie kontrakty P9 i
   `docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md` przed analizą fizycznych scen.
4. `memory_resonance_point.gd`, wszystkie jego call-site'y, Station 10–13,
   ich testy oraz `tools/verify.ps1`.

## GRANICE TWARDZE

- Nie edytuj `memory_resonance_point.gd` ani nie przebudowuj Station 10–13.
- Nie zmieniaj colliderów, progów, `ThresholdZone`, `ReturnZone`, InputMap,
  viewportu, fizyki, assetów lub trasowania kampanii.
- Nie ukrywaj znalezionego długu przez skip, allowlistę warningów, usunięcie
  asercji albo słabszy próg.
- Nie rób release'u, eksportu, webu, Gita ani zewnętrznych playtestów.

## KRYTERIA AKCEPTACJI

- Raport ma inventory dowodowe F-010 i F-012, oddziela fakty runtime od planu.
- Wskazuje minimalne granice modułów, callerów, migracje oraz testy wymagane
  przed implementacją; nie podaje ogólnikowego „refaktoru”.
- Test inventory jest czuły na usunięcie wskazanego faktu, ale nie udaje, że
  rozwiązał monolit albo hybrydę.
- `godot_log_policy.ps1` pozostaje fail-closed; pełne `verify.ps1` kończy się
  exit 0. Dokumentacja, decyzje, ryzyka, roadmapa i następny prompt opisują
  rzeczywisty wynik.

## KONIEC PAKIETU JEST OBOWIAZKOWY

```powershell
pwsh -NoProfile -File .\tools\verify_docs.ps1
pwsh -NoProfile -File .\tools\verify.ps1
pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0189
```

Raport końcowy nazwie inventory, testy, ograniczenia dowodu, `PKG-0189` i
ścieżkę następnego handoffu.