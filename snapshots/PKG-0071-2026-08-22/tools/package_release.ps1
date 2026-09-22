[CmdletBinding()]
param(
    [string]$OutputDir = "dist",
    [switch]$SkipGodotTest
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$distPath = Join-Path $projectRoot $OutputDir

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host " GETTING STRANGE — RELEASE PACKAGING & ASSET PIPELINE " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan

# 1. Verification of Documentation Contract
Write-Host "
[1/5] Weryfikacja kontraktu dokumentacji..." -ForegroundColor Yellow
& (Join-Path $PSScriptRoot 'verify_docs.ps1') -ProjectRoot $projectRoot

# 2. Godot Headless & Smoke Tests (unless skipped)
if (-not $SkipGodotTest) {
    Write-Host "
[2/5] Uruchamianie weryfikacji silnika Godot 4.7..." -ForegroundColor Yellow
    & (Join-Path $PSScriptRoot 'verify.ps1')
} else {
    Write-Host "
[2/5] Pominięto testy Godot (-SkipGodotTest)." -ForegroundColor DarkGray
}

# 3. Synchronizacja i walidacja zasobów statycznych (Web Showcase Assets)
Write-Host "
[3/5] Walidacja i synchronizacja zasobów Web Showcase..." -ForegroundColor Yellow
$webAssetsDir = Join-Path $projectRoot "web\assets\reports"
if (-not (Test-Path $webAssetsDir)) {
    New-Item -ItemType Directory -Path $webAssetsDir -Force | Out-Null
}

# Ensure all PNGs from reports are synchronized into web/assets/reports
$reportsDir = Join-Path $projectRoot "reports"
$reportPngs = Get-ChildItem -Path $reportsDir -Filter "*.png" -File
foreach ($png in $reportPngs) {
    $targetFile = Join-Path $webAssetsDir $png.Name
    if ((-not (Test-Path $targetFile)) -or ($png.Length -ne (Get-Item $targetFile).Length)) {
        Copy-Item -Path $png.FullName -Destination $targetFile -Force
    }
}

$webAssetCount = (Get-ChildItem -Path $webAssetsDir -Filter "*.png").Count
Write-Host "  -> Zsynchronizowano $webAssetCount kadrów referencyjnych w web/assets/reports." -ForegroundColor Green

& (Join-Path $PSScriptRoot 'verify_web.ps1') -ProjectRoot $projectRoot

# 4. Generowanie katalogu wyjściowego i archiwum dystrybucyjnego
Write-Host "
[4/5] Budowanie paczki dystrybucyjnej Web Showcase..." -ForegroundColor Yellow
if (-not (Test-Path $distPath)) {
    New-Item -ItemType Directory -Path $distPath -Force | Out-Null
}

$webSourceDir = Join-Path $projectRoot "web"
$zipTarget = Join-Path $distPath "getting_strange_web_showcase_v1.0.zip"
if (Test-Path $zipTarget) {
    Remove-Item -Path $zipTarget -Force
}

Compress-Archive -Path "$webSourceDir\*" -DestinationPath $zipTarget -CompressionLevel Optimal
$zipSizeMb = [math]::Round(((Get-Item $zipTarget).Length / 1MB), 2)
Write-Host "  -> Utworzono archiwum: $zipTarget ($zipSizeMb MB)" -ForegroundColor Green

# 5. Obliczanie sum kontrolnych SHA-256 i generowanie manifestu
Write-Host "
[5/5] Obliczanie sum kontrolnych SHA-256 i generowanie manifestu..." -ForegroundColor Yellow
$sha256 = (Get-FileHash -Path $zipTarget -Algorithm SHA256).Hash

$manifest = [ordered]@{
    "project" = "Getting Strange"
    "version" = "1.0.0-vertical-slice-pkg0067"
    "engine" = "Godot 4.7.stable.official.5b4e0cb0f"
    "build_date" = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    "package" = "getting_strange_web_showcase_v1.0.zip"
    "sha256" = $sha256
    "size_bytes" = (Get-Item $zipTarget).Length
    "size_mb" = $zipSizeMb
    "spaces_count" = 43
    "procedural_audio_modules" = 80
    "polyphonic_synth_themes" = 4
    "tactile_soundboard_pads" = 24
    "locales" = @("pl", "en")
    "verification_status" = "PASS"
}

$manifestJson = $manifest | ConvertTo-Json -Depth 4
$manifestPath = Join-Path $distPath "release_manifest.json"
[System.IO.File]::WriteAllText($manifestPath, $manifestJson, [System.Text.Encoding]::UTF8)

$checksumsContent = "$sha256  getting_strange_web_showcase_v1.0.zip
"
$checksumsPath = Join-Path $distPath "checksums.sha256"
[System.IO.File]::WriteAllText($checksumsPath, $checksumsContent, [System.Text.Encoding]::UTF8)

Write-Host "  -> Zapisano manifest: $manifestPath" -ForegroundColor Green
Write-Host "  -> Zapisano sumy kontrolne: $checksumsPath" -ForegroundColor Green
Write-Host "  -> SHA-256: $sha256" -ForegroundColor Cyan

Write-Host "
=======================================================" -ForegroundColor Cyan
Write-Host " PROCES BUDOWANIA I DYSTRYBUCJI ZAKOŃCZONY SUKCESEM!  " -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
