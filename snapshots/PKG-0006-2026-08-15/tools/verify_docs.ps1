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
    'docs/narrative/NARRATIVE_BIBLE.md',
    'docs/narrative/FULL_STORY.md',
    'docs/narrative/CONTINUITY_TRACKER.md',
    'docs/narrative/DIALOGUE_SCRIPT.md',
    'VISUAL_DESIGN.md',
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
        '## 11. Rodziny zakończeń',
        '## 15. Co pozostaje hipotezą'
    )
    'docs/narrative/FULL_STORY.md' = @(
        '## Prolog — Pomiar',
        '## Akt IV — Sygnał powrotu',
        '### 45. Napisy i epilog systemowy'
    )
    'VISUAL_DESIGN.md' = @(
        '## 7. AI-Generated Look Suppression Rules',
        '## 11. Handoff produkcyjny',
        '## 12. Czego jeszcze nie zatwierdzono'
    )
    'docs/SESSION_LOG.md' = @(
        '## PKG-0001:',
        '## PKG-0002:'
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
