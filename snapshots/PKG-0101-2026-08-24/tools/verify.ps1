[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$godotCommand = (Get-Command godot -ErrorAction Stop).Source
$godotItem = Get-Item -LiteralPath $godotCommand
$godotTarget = [string]$godotItem.Target

if ([string]::IsNullOrWhiteSpace($godotTarget)) {
    $godotTarget = $godotCommand
}

$consoleCandidate = Join-Path `
    (Split-Path -Parent $godotTarget) `
    (([System.IO.Path]::GetFileNameWithoutExtension($godotTarget)) + '_console.exe')
$godot = if (Test-Path -LiteralPath $consoleCandidate) {
    $consoleCandidate
} else {
    $godotTarget
}

function Invoke-GodotGate {
    param(
        [Parameter(Mandatory)]
        [string[]] $Arguments,

        [Parameter(Mandatory)]
        [string] $Name
    )

    Write-Host "== $Name =="
    $output = @(& $godot @Arguments 2>&1)
    $exitCode = $LASTEXITCODE
    $output | ForEach-Object { Write-Host $_ }

    if ($exitCode -ne 0) {
        throw "$Name failed with exit code $exitCode"
    }

    $joinedOutput = $output -join "`n"
    if ($joinedOutput -match '(?m)^\s*(SCRIPT ERROR|ERROR:)|Parse Error:') {
        throw "$Name reported an engine or script error"
    }
}

Write-Host '== Documentation contract =='
& (Join-Path $PSScriptRoot 'verify_docs.ps1') -ProjectRoot $projectRoot

Invoke-GodotGate `
    -Name 'Godot headless import' `
    -Arguments @('--headless', '--editor', '--path', $projectRoot, '--quit')

Invoke-GodotGate `
    -Name 'Getting Strange smoke test' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/smoke_test.gd')

Invoke-GodotGate `
    -Name 'Traversal contract lint' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/traversal_lint_test.gd')

# Delivered campaign chain gates. Each package that extends the chain adds its own gate here.
Invoke-GodotGate `
    -Name 'PKG-0095 Act II gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0095_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0096 Act IIb gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0096_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0097 Act IIc gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0097_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0099 Act II playable slice gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0099_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0100 Act I playable slice gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0100_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0101 Act IIb visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0101_smoke_test.gd')

Write-Host 'Verification passed.'
