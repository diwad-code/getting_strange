[CmdletBinding()]
param(
    [string]$ProjectRoot
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
}

$webDir = Join-Path $ProjectRoot "web"
$indexHtmlPath = Join-Path $webDir "index.html"
$html = Get-Content -Path $indexHtmlPath -Raw -Encoding UTF8

$js = ""
Get-ChildItem (Join-Path $webDir "js") -Filter "*.js" | ForEach-Object {
    $js += (Get-Content $_.FullName -Raw -Encoding UTF8) + "`n"
}

$ids = [regex]::Matches($html, 'id="([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

$trulyDead = New-Object System.Collections.Generic.List[string]
foreach ($id in $ids) {
    if ($js -notmatch [regex]::Escape($id)) {
        $pattern = '<(?<tag>\w+)[^>]*id="' + [regex]::Escape($id) + '"[^>]*>'
        $m = [regex]::Match($html, $pattern)
        if ($m.Success) {
            $tag = $m.Value
            $isInteractive = $tag -match '^<(button|input|select|textarea)'
            $hasInlineHandler = $tag -match 'on(click|input|change|keydown|keyup|submit)='
            if ($isInteractive -and -not $hasInlineHandler) {
                $trulyDead.Add(($id + ' :: ' + $tag.Substring(0, [Math]::Min(160, $tag.Length))))
            }
        }
    }
}

Write-Host "TRULY DEAD INTERACTIVE ELEMENTS ($($trulyDead.Count)):"
$trulyDead | ForEach-Object { Write-Host "  $_" }
