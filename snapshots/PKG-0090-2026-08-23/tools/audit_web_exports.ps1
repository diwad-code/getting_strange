[CmdletBinding()]
param(
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
}

$webDir = Join-Path $ProjectRoot "web"
$js = ""
Get-ChildItem (Join-Path $webDir "js") -Filter "*.js" | ForEach-Object {
    $js += (Get-Content $_.FullName -Raw -Encoding UTF8) + "`n"
}

# 1. All window.NAME = NAME; exports where NAME must be a declared identifier
$exportMatches = [regex]::Matches($js, 'window\.(?<name>[A-Za-z_][A-Za-z0-9_]*)\s*=\s*(?<rhs>[A-Za-z_][A-Za-z0-9_]*)\s*;')
$missing = New-Object System.Collections.Generic.List[string]
foreach ($m in $exportMatches) {
    $rhs = $m.Groups['rhs'].Value
    $isDeclared =
        ($js -match "(^|\n)\s*(async\s+)?function\s+$([regex]::Escape($rhs))\s*\(") -or
        ($js -match "(^|\n)\s*(const|let|var)\s+$([regex]::Escape($rhs))\b") -or
        ($js -match "(^|\n)\s*class\s+$([regex]::Escape($rhs))\b")
    if (-not $isDeclared) {
        $missing.Add("window.$($m.Groups['name'].Value) = $rhs  <-- RHS identifier never declared")
    }
}

Write-Host "MISSING EXPORT DEFINITIONS ($($missing.Count)):"
$missing | Sort-Object -Unique | ForEach-Object { Write-Host "  $_" }

# 2. All global functions invoked from inline handlers in index.html
$html = Get-Content (Join-Path $webDir "index.html") -Raw -Encoding UTF8
$handlers = [regex]::Matches($html, 'on(?:click|input|change|keydown|keyup|submit)="([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
$fnNames = New-Object System.Collections.Generic.HashSet[string]
foreach ($h in $handlers) {
    foreach ($fm in [regex]::Matches($h, '(?<![.\w])([A-Za-z_][A-Za-z0-9_]*)\s*\(')) {
        $fn = $fm.Groups[1].Value
        if ($fn -in @('if','for','while','parseFloat','parseInt','Math','setTimeout','Number','String','Array','Object','JSON','isNaN','encodeURIComponent','alert','confirm')) { continue }
        [void]$fnNames.Add($fn)
    }
}
$missingFns = New-Object System.Collections.Generic.List[string]
foreach ($fn in $fnNames) {
    $isDeclared =
        ($js -match "(^|\n)\s*(async\s+)?function\s+$([regex]::Escape($fn))\s*\(") -or
        ($js -match "(^|\n)\s*(const|let|var)\s+$([regex]::Escape($fn))\s*=") -or
        ($js -match "window\.$([regex]::Escape($fn))\s*=")
    if (-not $isDeclared) {
        $missingFns.Add($fn)
    }
}

Write-Host ""
Write-Host "MISSING INLINE HANDLER FUNCTIONS ($($missingFns.Count)):"
$missingFns | Sort-Object | ForEach-Object { Write-Host "  $_" }
