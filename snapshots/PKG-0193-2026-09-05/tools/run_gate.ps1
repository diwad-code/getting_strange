#!/usr/bin/env pwsh
# PKG-0147 helper: run a single Godot gate script with the same executable
# resolution as tools/verify.ps1. Development aid only; not a verification gate.
param(
    [Parameter(Mandatory = $true)][string]$Script,
    [int]$Tail = 60
)

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

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

$output = @(& $godot '--headless' '--path' $projectRoot '--script' $Script 2>&1)
$code = $LASTEXITCODE
$output | Select-Object -Last $Tail | ForEach-Object { Write-Output $_ }
Write-Output "GATE_EXIT=$code"
exit $code
