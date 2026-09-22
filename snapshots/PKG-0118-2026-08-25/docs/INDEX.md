# Indeks dokumentacji

Status: **ROUTING 3.0 — AKTYWNY PKG-0118**  
Data: 2026-08-25

Projekt przechodzi relacyjną przebudowę kreatywną. Istniejące sceny są
technicznym substratem; aktywny kanon i kolejka wdrożeń mają wersję 3.0.

## Kolejnosc wejscia w nowej sesji

1. `AGENTS.md` — twarde granice Godot-only, no-Git i zasady przeszkód.
2. `docs/CURRENT_STATE.md` — aktualna prawda runtime i ostatnia weryfikacja.
3. `docs/NEXT_SESSION_PROMPT.md` — jedyny aktywny pakiet.
4. Aktywna specyfikacja wskazana w `CURRENT_STATE.md`.
5. Źródła i testy nazwane w prompcie.
6. ADR-y i bible tylko w zakresie potrzebnym do decyzji pakietu.

Przed pierwszą edycją uruchom:

```powershell
pwsh -NoProfile -File .\tools\verify.ps1
```

Projekt nie ma repozytorium ani historii Git. Pliki na dysku są jedynym stanem,
`SESSION_LOG.md` kroniką, a `snapshots/` zamrożeniem zamkniętych pakietów.

## Hierarchia prawdy

W razie sprzeczności:

1. aktualnie uruchomiony runtime i świeży wynik testów;
2. aktualny kod, sceny, zasoby i konfiguracja na dysku;
3. `CURRENT_STATE.md`, `NEXT_SESSION_PROMPT.md` i aktywna specyfikacja;
4. najnowsze zaakceptowane ADR-y i decyzje;
5. bible 0.3, plan przebudowy i roadmapa;
6. historyczne audyty, wpisy sesji, snapshoty i stare prompty.

Kod nie może służyć jako pretekst do pozostawienia niezgodnej dokumentacji.
Rozjazd naprawia ten sam pakiet. Snapshot jest zamrożoną kopią, nie źródłem
bieżącej prawdy.

## Dokumenty zywe

| Plik | Rola | Reguła |
|---|---|---|
| `CURRENT_STATE.md` | jeden aktualny stan projektu | zastąpić prawdą po każdym pakiecie |
| `NEXT_SESSION_PROMPT.md` | jeden samowystarczalny handoff | zawsze zastąpić aktualnym promptem |
| `SESSION_LOG.md` | chronologiczna historia pakietów | tylko dopisywać |
| `CREATIVE_REBUILD_PLAN.md` | aktywna kolejka 0118–0124+ | aktualizować po zmianie kolejności |
| `ROADMAP.md` | fazy i meta wydania | aktualizować przy otwarciu/zamknięciu etapu |
| `RISKS_AND_HYPOTHESES.md` | dowody, braki i ryzyka | nie zamieniać hipotez w fakty |
| `DECISION_LOG.md` | lekki rejestr decyzji | dopisywać zmianę, nie usuwać historii |

## Aktywne kontrakty przebudowy 3.0

| Plik | Odpowiada za |
|---|---|
| `decisions/ADR-006-controlled-creative-rebuild.md` | dlaczego nie pełny reset i dlaczego nie stary content lock |
| `decisions/ADR-007-character-first-narrative-revolution.md` | dlaczego kanon 0.2 wymagał relacyjnej rewolucji |
| `NARRATIVE_SKILL_AUDIT_0_2.md` | findings S1–S2, adaptacja skilli i werdykt REJECT |
| `CREATIVE_REBUILD_PLAN.md` | zakres zachowany/przebudowany, wynik rekoncyliacji PKG-0117 i kolejność wycinków |
| `LENA_CHARACTER_AND_ANIMATION.md` | nowa postać, rig, stany i kryteria animacji |
| `PLAYER_GUIDANCE_AND_INNER_VOICE.md` | pokaż → naprowadź → pomyśl, zastój i omylne interpretacje |
| `PIXEL_PRESENTATION_ARCHITECTURE.md` | pikselizowany świat i ostre warstwy tekstu |
| `../VISUAL_DESIGN.md` | Rówień Pixel-Stage i reżyseria obrazu |
| `TRAVERSAL_AND_OBSTACLE_DESIGN.md` | dozwolone wyzwania i zakaz arcade'owych przeszkód |

## Kanon narracyjny 3.0

| Plik | Odpowiada za |
|---|---|
| `PRODUCT_BRIEF.md` | krótka obietnica produktu i filary |
| `PROJECT_BIBLE.md` | nadrzędny kierunek produkcyjny |
| `narrative/NARRATIVE_BIBLE.md` | Linia 4, dwie Leny, relacje, UCP i bramy 21/22 |
| `narrative/FULL_STORY.md` | osiem sekwencji oraz pętle Station 01–43 |
| `narrative/CONTINUITY_TRACKER.md` | dwie tajemnice, wiedza, clue ledger, zgody i finały |
| `narrative/DIALOGUE_SCRIPT.md` | agendy, odrębne głosy, podtekst i omylne myśli |

Najważniejszy kontrakt: 01–05 normalność z konfliktem próbka/obietnica, 06–20
eskalacja bez diagnozy, Station 21 rozpoznanie „To nie jest mój świat”,
Station 22 pierwsze świadome Anchor/Yield. Od 21 głównym pytaniem staje się los
miejscowej Leny i koszt Linii 4; każdy finał pokazuje stan obu Len.

## Dokumenty techniczne i procesowe

| Plik | Rola |
|---|---|
| `TECHNICAL_DIRECTION.md` | architektura Godot, InputMap, viewport i moduły |
| `WORKFLOW.md` | start, Definition of Done, weryfikacja i snapshot |
| `RESEARCH_FOUNDATIONS.md` | źródła i ograniczone wnioski researchu |
| `INSPIRATION_BOUNDARIES.md` | granice inspiracji i ryzyka podobieństwa |
| `PROTOTYPE_01_MOVEMENT_LAB.md` | historyczny kontrakt ruchu bazowego |
| `PLAYTEST_01.md` | model dowodu bez zewnętrznych testerów |
| `decisions/ADR-001-godot-pc-first.md` | wybór silnika i platformy |
| `decisions/ADR-002-evidence-gated-prototypes.md` | bramki prototypów |
| `decisions/ADR-003-evidence-model-without-external-testers.md` | granice wniosków |
| `decisions/ADR-004-ai-autonomy.md` | autonomia roli |
| `decisions/ADR-005-mechanics-threshold-pivot.md` | historyczny pivot Anchor |

## Dokumenty historyczne / nieaktywne jako plan

- `IMPLEMENTATION_PLAN_AUDIT_AND_RELEASE_READINESS.md` opisuje stan przed
  D-113; jego droga R2 content lock → build jest zastąpiona przez plan 3.0.
- Kanon 0.2 zachowany w snapshotcie PKG-0116 jest audytowanym projektem
  pośrednim, nie aktywną prawdą. Audyt wskazuje jego dokładne źródło.
- `VECTOR_STAGE_ART_DIRECTION_AUDIT.md` i audyty `VECTOR_STAGE_*` są dowodem
  dawnego runtime, nie aktywnym kanonem powierzchni obrazu.
- `TRAVERSAL_ACT_*_AUDIT.md` zachowują fakty o istniejących colliderach; ponowne
  autorstwo nadal podlega nadrzędnemu kanonowi przeszkód.
- Snapshoty i stare `NEXT_SESSION_PROMPT.md` w zamrożeniach nie są czytane jako
  stan bieżący.
- `archive_retired_web/` jest martwym artefaktem poza projektem gry.

## Protokol przekazania

Pakiet kończy się dopiero po:

1. testach proporcjonalnych do zmiany;
2. synchronizacji kodu, kanonu i dokumentacji;
3. wpisie append-only w `SESSION_LOG.md`;
4. zastąpieniu `CURRENT_STATE.md` i `NEXT_SESSION_PROMPT.md`;
5. pełnym `tools/verify.ps1` z kodem 0;
6. dla obrazu — świeżych capture'ach normalnym driverem i inspekcji;
7. snapshotcie `tools/snapshot.ps1 -Package PKG-NNNN`.

Test lub render dowodzi wyłącznie mierzonego kontraktu, nie zabawy, emocji,
zrozumienia ani odbioru przez zewnętrznego gracza.
