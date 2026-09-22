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

Write-Host 'Verification passed.'
