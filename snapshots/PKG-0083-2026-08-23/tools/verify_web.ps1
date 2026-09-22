[CmdletBinding()]
param(
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
}

$webDir = Join-Path $ProjectRoot "web"
if (-not (Test-Path $webDir)) {
    throw "Web directory not found at $webDir"
}

Write-Host "== Web Showcase Static & Contract Validation ==" -ForegroundColor Cyan

$failures = [System.Collections.Generic.List[string]]::new()

# 1. Validate required web files
$requiredWebFiles = @(
    "index.html",
    "manifest.webmanifest",
    "service-worker.js",
    "css/style.css",
    "js/app.js",
    "js/audio-synth.js",
    "js/game-engine.js",
    "js/gallery.js",
    "js/story-timeline.js",
    "js/i18n.js",
    "locales/pl.json",
    "locales/en.json"
)

foreach ($relPath in $requiredWebFiles) {
    $fullPath = Join-Path $webDir $relPath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        $failures.Add("Missing required web file: $relPath")
    }
}

# 2. Validate JSON syntax for locales and manifest
$jsonFiles = @("manifest.webmanifest", "locales/pl.json", "locales/en.json")
$parsedJsons = @{}

foreach ($jFile in $jsonFiles) {
    $jPath = Join-Path $webDir $jFile
    if (Test-Path -LiteralPath $jPath) {
        try {
            $raw = Get-Content -Path $jPath -Raw -Encoding UTF8
            $obj = $raw | ConvertFrom-Json
            $parsedJsons[$jFile] = $obj
        } catch {
            $failures.Add("JSON Syntax Error in $jFile : $_")
        }
    }
}

# 3. Validate i18n key parity between pl.json and en.json
function Get-ObjectKeysRecursive ($obj, $prefix = "") {
    $keys = [System.Collections.ArrayList]::new()
    if ($null -eq $obj) { return $keys }
    
    $pNames = $obj.PSObject.Properties | ForEach-Object { $_.Name }
    foreach ($name in $pNames) {
        $val = $obj.$name
        $fullKey = if ($prefix -eq "") { $name } else { "$prefix.$name" }
        if ($val -is [System.Management.Automation.PSCustomObject]) {
            $subKeys = Get-ObjectKeysRecursive -obj $val -prefix $fullKey
            foreach ($sk in $subKeys) {
                [void]$keys.Add([string]$sk)
            }
        } else {
            [void]$keys.Add([string]$fullKey)
        }
    }
    return $keys
}

if ($parsedJsons.ContainsKey("locales/pl.json") -and $parsedJsons.ContainsKey("locales/en.json")) {
    $pl = $parsedJsons["locales/pl.json"]
    $en = $parsedJsons["locales/en.json"]

    $plKeys = Get-ObjectKeysRecursive -obj $pl
    $enKeys = Get-ObjectKeysRecursive -obj $en

    foreach ($k in $plKeys) {
        if (-not ($enKeys -contains $k)) {
            $failures.Add("Missing English translation key: $k")
        }
    }
    foreach ($k in $enKeys) {
        if (-not ($plKeys -contains $k)) {
            $failures.Add("Missing Polish translation key: $k")
        }
    }
}

# 4. Validate all referenced report images in web/assets/reports
$reportsDir = Join-Path $webDir "assets/reports"
if (Test-Path $reportsDir) {
    $pngCount = (Get-ChildItem -Path $reportsDir -Filter "*.png" -File).Count
    if ($pngCount -lt 43) {
        $failures.Add("Expected at least 43 rendered station images in web/assets/reports, found $pngCount")
    }
} else {
    $failures.Add("Missing web/assets/reports directory")
}

# 5. Check index.html data-i18n tags and element references
$indexHtmlPath = Join-Path $webDir "index.html"
if (Test-Path $indexHtmlPath) {
    $indexHtmlContent = Get-Content -Path $indexHtmlPath -Raw -Encoding UTF8
    $i18nMatches = [regex]::Matches($indexHtmlContent, 'data-i18n="([^"]+)"')
    if ($parsedJsons.ContainsKey("locales/pl.json")) {
        $pl = $parsedJsons["locales/pl.json"]
        $plKeys = Get-ObjectKeysRecursive -obj $pl
        foreach ($m in $i18nMatches) {
            $key = $m.Groups[1].Value
            if (-not ($plKeys -contains $key)) {
                $failures.Add("index.html references data-i18n key '$key' which is missing in pl.json")
            }
        }
    }
}

if ($failures.Count -gt 0) {
    Write-Host "WEB VALIDATION FAILURES ($($failures.Count)):" -ForegroundColor Red
    foreach ($err in $failures) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    throw "Web showcase validation failed with $($failures.Count) errors."
}

Write-Host "WEB PASS: All HTML, CSS, JS, Locales, PWA Manifest, and Assets validated successfully." -ForegroundColor Green
