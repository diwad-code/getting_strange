[CmdletBinding()]
param(
    [string] $ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$failures = [System.Collections.Generic.List[string]]::new()

$requiredFiles = @(
    'AGENTS.md',
    'README.md',
    'docs/INDEX.md',
    'docs/CURRENT_STATE.md',
    'docs/NEXT_SESSION_PROMPT.md',
    'docs/WORKFLOW.md',
    'docs/SESSION_LOG.md',
    'docs/DECISION_LOG.md',
    'docs/PRODUCT_BRIEF.md',
    'docs/PROJECT_BIBLE.md',
    'docs/CREATIVE_REBUILD_PLAN.md',
    'docs/NARRATIVE_SKILL_AUDIT_0_2.md',
    'docs/LENA_CHARACTER_AND_ANIMATION.md',
    'docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md',
    'docs/PIXEL_PRESENTATION_ARCHITECTURE.md',
    'docs/narrative/NARRATIVE_BIBLE.md',
    'docs/narrative/FULL_STORY.md',
    'docs/narrative/CONTINUITY_TRACKER.md',
    'docs/narrative/DIALOGUE_SCRIPT.md',
    'VISUAL_DESIGN.md',
    'docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md',
    'docs/RESEARCH_FOUNDATIONS.md',
    'docs/ROADMAP.md',
    'docs/TECHNICAL_DIRECTION.md',
    'docs/RISKS_AND_HYPOTHESES.md',
    'docs/INSPIRATION_BOUNDARIES.md',
    'docs/PROTOTYPE_01_MOVEMENT_LAB.md',
    'docs/PLAYTEST_01.md',
    'docs/decisions/ADR-001-godot-pc-first.md',
    'docs/decisions/ADR-002-evidence-gated-prototypes.md',
    'docs/decisions/ADR-003-evidence-model-without-external-testers.md',
    'docs/decisions/ADR-004-ai-autonomy.md',
    'docs/decisions/ADR-005-mechanics-threshold-pivot.md',
    'docs/decisions/ADR-006-controlled-creative-rebuild.md',
    'docs/decisions/ADR-007-character-first-narrative-revolution.md',
    'docs/LICENSES.md',
    'docs/RELEASE_NOTES.md',
    'docs/templates/HANDOFF_TEMPLATE.md'
)

foreach ($relativePath in $requiredFiles) {
    $absolutePath = Join-Path $ProjectRoot $relativePath
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
        $failures.Add("missing required documentation: $relativePath")
    }
}

$contentContracts = @{
    'docs/CURRENT_STATE.md' = @(
        '## Aktywna faza',
        '## Ostatnia swieza weryfikacja',
        '## Czego jeszcze nie potwierdzono',
        '## Nastepny pakiet'
    )
    'docs/NEXT_SESSION_PROMPT.md' = @(
        'CEL SESJI',
        'SRODOWISKO I BASELINE',
        'KRYTERIA AKCEPTACJI',
        'KONIEC PAKIETU JEST OBOWIAZKOWY'
    )
    'docs/WORKFLOW.md' = @(
        '## Start nowej sesji',
        '## Obowiazkowy koniec kazdego pakietu',
        '## Definition of Done'
    )
    'docs/INDEX.md' = @(
        '## Kolejnosc wejscia w nowej sesji',
        '## Hierarchia prawdy',
        '## Dokumenty zywe'
    )
    'docs/narrative/NARRATIVE_BIBLE.md' = @(
        '## 1. Tożsamość opowieści',
        '## 12. Station 21 — rozpoznanie',
        '## 16. Rodziny zakończeń',
        '## 19. Co pozostaje niepewne'
    )
    'docs/narrative/FULL_STORY.md' = @(
        '# Sekwencja I — Próbka',
        '# Sekwencja VIII — Metoda i skutek',
        '## 43. Epilog konkretnych osób',
        'To nie jest mój świat.'
    )
    'docs/CREATIVE_REBUILD_PLAN.md' = @(
        '## 1. Werdykt',
        '### PKG-0117 — Narrative Revolution + Foundation Reconciliation Audit',
        '## 6. Bramka jakości planu'
    )
    'docs/NARRATIVE_SKILL_AUDIT_0_2.md' = @(
        'Requested Mode: full',
        'Effective Mode: solo',
        'Verdict: **REJECT kanonu 0.2 jako podstawy dalszego autorstwa scen**'
    )
    'docs/LENA_CHARACTER_AND_ANIMATION.md' = @(
        '## 1. Diagnoza obecnego runtime',
        '## 4. Architektura runtime',
        '## 9. Kryteria akceptacji pierwszego plastra'
    )
    'docs/PLAYER_GUIDANCE_AND_INNER_VOICE.md' = @(
        '## 1. Zasada nadrzędna',
        '## 3. Drabina podpowiedzi L0..L4',
        '## 5. Wiarygodna omylność'
    )
    'docs/PIXEL_PRESENTATION_ARCHITECTURE.md' = @(
        '## 2. Warstwy kompozycji',
        'CrispDiegeticText',
        '## 7. Kryteria akceptacji'
    )
    'docs/decisions/ADR-006-controlled-creative-rebuild.md' = @(
        '## Decyzja',
        'Station 21',
        'kontrolowaną przebudowę'
    )
    'docs/decisions/ADR-007-character-first-narrative-revolution.md' = @(
        '## Decyzja',
        'Station 21',
        'kanon 0.3: relacyjny thriller'
    )
    'docs/DECISION_LOG.md' = @(
        'D-114',
        'Relacyjna rewolucja narracji 0.3'
    )
    'VISUAL_DESIGN.md' = @(
        '## 7. AI-Generated Look Suppression Rules',
        '## 11. Handoff produkcyjny',
        '## 12. Czego jeszcze nie zatwierdzono'
    )
    'docs/TRAVERSAL_AND_OBSTACLE_DESIGN.md' = @(
        '## 2. Zakazy twarde',
        '## 3. Test trzech pytań (obowiązkowy)',
        '## 4. Katalog dozwolonych rodzin przeszkód',
        '## 5. Model porażki'
    )
    'docs/SESSION_LOG.md' = @(
        '## PKG-0001:',
        '## PKG-0002:'
    )
    'docs/LICENSES.md' = @(
        '## 1. Prawa autorskie i licencja gry',
        '## 2. Architektura bezassetowa',
        '## 3. Silnik Godot Engine',
        'FreeType'
    )
    'docs/RELEASE_NOTES.md' = @(
        '## 1. Podsumowanie wydania',
        '## 2. Zawartość kampanii',
        '## 3. Kluczowe systemy technologiczne',
        '## 4. Dystrybucja i pakiety binarne'
    )
}

foreach ($relativePath in $contentContracts.Keys) {
    $absolutePath = Join-Path $ProjectRoot $relativePath
    if (-not (Test-Path -LiteralPath $absolutePath -PathType Leaf)) {
        continue
    }

    $content = Get-Content -LiteralPath $absolutePath -Raw
    foreach ($requiredText in $contentContracts[$relativePath]) {
        if (-not $content.Contains($requiredText)) {
            $failures.Add("$relativePath is missing contract text: $requiredText")
        }
    }
}

$docsRoot = Join-Path $ProjectRoot 'docs'
if (Test-Path -LiteralPath $docsRoot) {
    $unfinished = Get-ChildItem -LiteralPath $docsRoot -Recurse -File -Filter '*.md' |
        Where-Object { $_.FullName -notmatch '[\\/]templates[\\/]' } |
        Select-String -Pattern 'PENDING_[A-Z_]+' -List

    foreach ($match in $unfinished) {
        $relativePath = [System.IO.Path]::GetRelativePath($ProjectRoot, $match.Path)
        $failures.Add("unresolved handoff placeholder in $relativePath")
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error "DOCS: $failure"
    }
    throw "Documentation contract failed with $($failures.Count) issue(s)"
}

Write-Host "DOCS PASS: $($requiredFiles.Count) required files and handoff contracts"
