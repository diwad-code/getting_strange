[CmdletBinding()]
param(
    [string] $ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

Write-Host "== Getting Strange Release Candidate Build Exporter =="
$distDir = Join-Path $ProjectRoot "dist"
$windowsDir = Join-Path $distDir "windows"
$linuxDir = Join-Path $distDir "linux"

# Ensure output directories exist and are clean
if (Test-Path -LiteralPath $distDir) {
    Remove-Item -LiteralPath $distDir -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force -Path $windowsDir | Out-Null
New-Item -ItemType Directory -Force -Path $linuxDir | Out-Null

$godotCommand = (Get-Command godot -ErrorAction Stop).Source
$godotItem = Get-Item -LiteralPath $godotCommand
$godotTarget = [string]$godotItem.Target
if ([string]::IsNullOrWhiteSpace($godotTarget)) {
    $godotTarget = $godotCommand
}

$consoleCandidate = Join-Path (Split-Path -Parent $godotTarget) (([System.IO.Path]::GetFileNameWithoutExtension($godotTarget)) + '_console.exe')
$godot = if (Test-Path -LiteralPath $consoleCandidate) { $consoleCandidate } else { $godotTarget }

# Export Windows Desktop Release
Write-Host "Exporting Windows Desktop Release Candidate..."
$winExe = Join-Path $windowsDir "GettingStrange.exe"
& $godot --headless --path $ProjectRoot --export-release "Windows Desktop" $winExe
if ($LASTEXITCODE -ne 0) {
    throw "Windows export failed with exit code $LASTEXITCODE"
}

# Clean temp files if any
Get-ChildItem -Path $windowsDir -Filter "*.tmp" -ErrorAction SilentlyContinue | Remove-Item -Force

# Export Linux Desktop Release
Write-Host "Exporting Linux Desktop Release Candidate..."
$linuxBin = Join-Path $linuxDir "GettingStrange.x86_64"
& $godot --headless --path $ProjectRoot --export-release "Linux Desktop" $linuxBin
if ($LASTEXITCODE -ne 0) {
    throw "Linux export failed with exit code $LASTEXITCODE"
}

Get-ChildItem -Path $linuxDir -Filter "*.tmp" -ErrorAction SilentlyContinue | Remove-Item -Force

Write-Host "== Export Summary =="
Get-ChildItem -Path $distDir -Recurse -File | Select-Object FullName, Length | ForEach-Object {
    $sizeMb = [math]::Round($_.Length / 1MB, 2)
    Write-Host " - $($_.FullName) ($sizeMb MB)"
}

Write-Host "Export completed successfully."
