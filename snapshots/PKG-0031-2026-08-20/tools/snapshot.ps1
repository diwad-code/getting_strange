#Requires -Version 7
<#
.SYNOPSIS
    Zamraza kopie tresci projektu na koniec pakietu pracy (D-017).

.DESCRIPTION
    Projekt nie jest wersjonowany (D-016). Ten skrypt jest jedyna odpowiedzia
    techniczna na R-017: brak cofania zmian. Kopiuje wylacznie tresc projektu -
    dokumentacje, sceny, skrypty, zasoby, testy i narzedzia. Nie kopiuje
    katalogow skilli, wyjscia generowanego ani wczesniejszych snapshotow.

    To nie jest system kontroli wersji. Nie ma scalania, roznic ani historii
    liniowej. Jest to plaska kopia katalogu, ktora mozna przejrzec i z ktorej
    mozna recznie odtworzyc plik.

.EXAMPLE
    pwsh -NoProfile -File .\tools\snapshot.ps1 -Package PKG-0006
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^PKG-\d{4}$')]
    [string]$Package,

    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$stamp = Get-Date -Format 'yyyy-MM-dd'
$targetRoot = Join-Path $root 'snapshots'
$target = Join-Path $targetRoot "$Package-$stamp"

# Tresc projektu. Swiadomie pominiete: .agent, .codex, .claude, skills (tooling
# wylaczone z importu Godota), .godot, reports, logs (wyjscie generowane),
# snapshots (poprzednie kopie) oraz .git (nieuzywane od PKG-0006).
$include = @(
    'docs',
    'resources',
    'scenes',
    'scripts',
    'tests',
    'tools',
    'AGENTS.md',
    'README.md',
    'VISUAL_DESIGN.md',
    'project.godot'
)

if (Test-Path $target) {
    if (-not $Force) {
        throw "Snapshot juz istnieje: $target. Uzyj -Force, aby go nadpisac."
    }
    Remove-Item $target -Recurse -Force
}

New-Item -ItemType Directory -Path $target -Force | Out-Null

# Snapshoty zawieraja kopie .tscn i .gd. Bez .gdignore Godot zaimportowalby je
# jako drugi zestaw scen i skryptow, powodujac kolizje nazw klas.
$guard = Join-Path $targetRoot '.gdignore'
if (-not (Test-Path $guard)) {
    New-Item -ItemType File -Path $guard -Force | Out-Null
}

$missing = @()
foreach ($item in $include) {
    $source = Join-Path $root $item
    if (-not (Test-Path $source)) {
        $missing += $item
        continue
    }
    Copy-Item -Path $source -Destination $target -Recurse -Force
}

if ($missing.Count -gt 0) {
    Write-Warning "Brak w projekcie: $($missing -join ', ')"
}

$files = Get-ChildItem $target -Recurse -File
$sizeMb = [math]::Round(($files | Measure-Object Length -Sum).Sum / 1MB, 2)

$manifest = @(
    "Snapshot: $Package",
    "Data: $stamp",
    "Plikow: $($files.Count)",
    "Rozmiar: $sizeMb MB",
    '',
    'Projekt nie jest wersjonowany (D-016). Ta kopia jest plaskim zamrozeniem',
    'tresci projektu wykonanym na koniec pakietu, zgodnie z D-017. Nie zawiera',
    'katalogow skilli, wyjscia generowanego ani historii.',
    '',
    'Odtworzenie jest reczne: skopiuj potrzebny plik z powrotem do projektu i',
    'opisz to jako osobny pakiet w SESSION_LOG.md.',
    '',
    'Objete kopia:',
    ($include | ForEach-Object { "  - $_" })
) -join [Environment]::NewLine

Set-Content -Path (Join-Path $target 'SNAPSHOT.txt') -Value $manifest -Encoding utf8

Write-Output "SNAPSHOT OK: $Package -> snapshots\$Package-$stamp ($($files.Count) plikow, $sizeMb MB)"
