# Indeks dokumentacji

Status: **P9 — PRODUCT RESCUE & HYBRID REBUILD OTWARTE (D-168 / ADR-008);
PHASE-09 ZAMKNIĘTA; PHASE-10 ABSOLUTE GAME AUDIT & EVOLUTION ZAMKNIĘTA
TECHNICZNIE (PKG-0182); GATE-REL NADAL ZABLOKOWANE**
Data: 2026-09-03 (PKG-0182)

> **Stan po PKG-0182.** Absolutny audyt, naprawy P0–P2, dwa wdrożone pomysły
> kreatywne i recertyfikacja są na dysku. Raport:
> `docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`. Verifier fail-closed
> na ObjectDB/RID/orphans i nieallowlistowane WARNING. Następny model wykonuje
> niezależny red-team PKG-0183 (`docs/PLUS_SESSION_PROMPT_2_A.md`). Release i
> nowe `.exe` pozostają zablokowane (D-168). Po PKG-0183: PKG-0184 z
> `docs/PLUS_SESSION_PROMPT_2_B.mm`. Nie uruchamiać ich równolegle.

P5–P8 pozostają zamknięte technicznie, a PKG-0154 jest prawdziwym dowodem
sprawności buildów, shellu, zapisu i kampanijnego runtime. Nie jest jednak
greenlightem produktu. Wiążąca diagnoza właściciela i board audit PKG-0155
odrzuciły obecną 43-adresową formę jako nieczytelną produktowo. Aktywna faza P9
zachowuje technologię Godot 4.7, lecz przebudowuje opening, hierarchię
informacji, rodziny lokacji, większość contentu i finał według
`PROJECT_REBUILD_EXECUTION_PLAN.md`.




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
| `CREATIVE_REBUILD_PLAN.md` | historyczna kolejka P4–P7 i status zamkniętych fal | materiał dawcy, nie aktywny plan P9 |
| `P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` | zamknięta mapa 15 sekwencji i migracji P7 | materiał dawcy dla mapy P9 |
| `ROADMAP.md` | fazy i meta wydania | aktualizować przy otwarciu/zamknięciu etapu |
| `PROJECT_REBUILD_EXECUTION_PLAN.md` | zaakceptowany board plan P9: HYBRID_REBUILD, target 20 adresów, 6 faz i 25 bundle'ów | jedyna aktywna kolejka odbudowy produktu |
| `decisions/ADR-008-hybrid-product-rebuild.md` | dlaczego technologia zostaje, a obecna forma gry nie | obowiązuje wszystkie pakiety P9 |
| `RISKS_AND_HYPOTHESES.md` | dowody, braki i ryzyka | nie zamieniać hipotez w fakty |
| `DECISION_LOG.md` | lekki rejestr decyzji | dopisywać zmianę, nie usuwać historii |
| `WORLD_SCALE.md` | Lena jest linijką; 1 m = 52 px | aktualizować przy zmianie metra |
| `PLAYTHROUGH_TRAVERSAL_AUDIT.md` | tabela przejścia 43 stacji | wypełniać w PKG-0132, nie spekulować |
| `FRAME_LAYOUT_AUDIT.md` | budżet pionowy kadru 640x360, etykiety, kolizje HUD | aktualizować przy zmianie kadru lub panelu |
| `PKG_0138_PLAYTHROUGH_REPORT.md` | sterowany przebieg 01→43: kadr, etykiety, wyjścia, lokomocja | aktualizować przy kolejnym pełnym przebiegu |
| `PKG_0130_FRAME_BUDGET_REPORT.md` | pomiar 60 Hz | aktualizować tylko przy nowym pomiarze |
| `PKG_0142_VISUAL_CERTIFICATION.md` | raport renderów 45 scen, trybów ruchu i ręcznej inspekcji | aktualizować przy kolejnym certyfikowanym przebiegu |

## Aktywne kontrakty P9

| Plik | Odpowiada za |
|---|---|
| `decisions/ADR-006-controlled-creative-rebuild.md` | dlaczego nie pełny reset i dlaczego nie stary content lock |
| `decisions/ADR-008-hybrid-product-rebuild.md` | dlaczego technologia zostaje, a obecna forma i trasa 43 adresów nie |
| `rebuild/PLAYER_CONTRACT.md` | tożsamość Leny, stawka i stan wiedzy po 1/5/30 minutach |
| `rebuild/CAMPAIGN_MAP.md` | trasa 01–18 → 42A/B/C → 43 oraz statusy legacy 19–41 (`KEEP / ADAPT / RETIRE`) |
| `rebuild/LOCATION_FAMILY_BIBLE.md` | siedem rodzin lokacji na pięciu osiach z testem monochromatycznym |
| `rebuild/ACCEPTANCE_MATRIX.md` | **czternaście** bramek produktu (§3 + §3a) i osobne werdykty `TECHNICAL PASS` / `PRODUCT GO` |
| `rebuild/EXECUTIVE_RELEASE_ASSESSMENT.md` | całościowy raport gotowości wydania dla właściciela, status 14 bramek i CHECKPOINT-06 GO |
| `PROJECT_REBUILD_EXECUTION_PLAN.md` | target 20 adresów, osiem faz, 31 bundle'ów i checkpointy GO/PIVOT/CUT |
| **`rebuild/PRESENTATION_REPAIR_PLAN.md`** | **specyfikacja nadrzędna PHASE-08**: osiem defektów prezentacji zgłoszonych przez właściciela 2026-09-02, z dowodami w kodzie, kolejnością pakietów i sześcioma nowymi bramkami |
| **`rebuild/AUDIT_IMPLEMENTATION_PLAN.md`** | **specyfikacja nadrzędna PHASE-09 (PKG-0179)**: całościowy plan wdrożenia zaleceń audytu 360°, eliminacji wycieków ObjectDB, unifikacji portretów i szlifu dialogów |
| **`rebuild/COMPREHENSIVE_GAME_AUDIT_AND_EVOLUTION_PLAN.md`** | **specyfikacja PHASE-10 / PKG-0182**: kompletne pokrycie gry, dowody, naprawy i kreatywna ewolucja |
| **`rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md`** | **raport wykonawczy PKG-0182**: coverage, findings, pomysły, pomiary, ograniczenia |
| **`PLUS_SESSION_PROMPT_2.md`** | **wykonany prompt PKG-0182 / BUNDLE-32** (zamknięty) |
| **`PLUS_SESSION_PROMPT_2_A.md`** | **sekwencyjny prompt niezależnego red-team audytu i napraw PKG-0183 / BUNDLE-33; uruchamiać dopiero po zamknięciu PKG-0182** |
| **`PLUS_SESSION_PROMPT_2_B.mm`** | **sekwencyjny prompt finalnej recertyfikacji i ostatnich napraw PKG-0184 / BUNDLE-34; uruchamiać dopiero po zamknięciu PKG-0183** |
| `rebuild/CAST_AND_NPC_BIBLE.md` | wygląd, skala 84–92 px, `CharacterVisualRig` i pipeline `gen-ai` dla całej obsady |
| `rebuild/THRESHOLD_AND_ENTRY_CONTRACT.md` | `ThresholdZone`, trzy rodziny wejść, animacja stopni, drabiny i tabela skali otworów |
| `rebuild/PROGRESSION_FLOW_CONTRACT.md` | trasa zawsze przechodnia, rejestr luk i głos wewnętrzny zamiast twardych bramek |
| `rebuild/COLD_OPEN_SPEC.md` | zimne otwarcie w dwóch warstwach: sekwencja ustawiająca i grywalny prolog |
| `decisions/ADR-007-character-first-narrative-revolution.md` | dlaczego kanon 0.2 wymagał relacyjnej rewolucji |
| `NARRATIVE_SKILL_AUDIT_0_2.md` | findings S1–S2, adaptacja skilli i werdykt REJECT |
| `CREATIVE_REBUILD_PLAN.md` | zakres zachowany/przebudowany, wynik rekoncyliacji PKG-0117 i kolejność wycinków |
| `GAMEPLAY_DEPTH_VISION.md` | kierunek P7: aktywne sekwencje diagnozy, próby i zobowiązania |
| `P7_GAMEPLAY_DEPTH_IMPLEMENTATION_PLAN.md` | konkretna mapa P7, granice danych, migracja save i status wszystkich 15 sekwencji domkniętych przez PKG-0151 |
| `LENA_CHARACTER_AND_ANIMATION.md` | nowa postać, rig, stany i kryteria animacji |
| `PLAYER_GUIDANCE_AND_INNER_VOICE.md` | pokaż → naprowadź → pomyśl, zastój i omylne interpretacje |
| `PIXEL_PRESENTATION_ARCHITECTURE.md` | pikselizowany świat i ostre warstwy tekstu |
| `../VISUAL_DESIGN.md` | Rówień Pixel-Stage i reżyseria obrazu |
| `TRAVERSAL_AND_OBSTACLE_DESIGN.md` | dozwolone wyzwania, zakaz arcade, skok ≠ lokomocja, próg 18 px |
| `WORLD_SCALE.md` | jedna skala mebli i Leny |

## Kanon narracyjny 3.0 — materiał źródłowy P9

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

P9 zachowuje osoby, relacje, dwie tajemnice i koszt Linii 4 jako materiał
źródłowy, lecz BUNDLE-02..03 przeliczą progi oraz topologię na target
01–18 → 42A/B/C → 43. Do ich zamknięcia nadrzędne są D-168, ADR-008
i `PROJECT_REBUILD_EXECUTION_PLAN.md`.

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
