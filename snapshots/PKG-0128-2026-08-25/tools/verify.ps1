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

Invoke-GodotGate `
    -Name 'PKG-0102 Act IIc route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0102_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0103 Act III route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0103_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0104 Act IIIb route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0104_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0105 Act IIIc route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0105_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0106 Act IV choice chamber and silence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0106_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0107 finale Vector-Stage and silence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0107_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0113 release-readiness truth and visual remediation gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0113_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0114 production shell and end-to-end campaign gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0114_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0115 R1 settings, remap, focus and localization gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0115_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0117 inherited Foundation component gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0117_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0118 Foundation Slice 01-07 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0118_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0119 Station 08-13 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0119_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0120 Station 14-23 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0120_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0121 Station 24-30 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0121_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0122 Station 31-37 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0122_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0123 Station 38-43 and Final Content Lock 3.0 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0123_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0124 Release Candidate 1 and Distribution gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0124_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0125 Feminine Lena, Diegetic Climbing, Bidirectionality and Scale gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0125_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0126 Atmospheric Soundscapes, Vector Lighting, Micro-particles and CRT Pacing gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0126_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0127 RAM Lifecycle, Sound Cache, Bidirectional Topology and Presentation Contrast gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0127_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0128 Golden Master audit, soak simulation and integrity gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0128_smoke_test.gd')

Write-Host 'Verification passed.'


