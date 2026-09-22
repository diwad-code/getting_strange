[CmdletBinding()]
param(
    [string] $ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$reportRoot = Join-Path $ProjectRoot 'reports\pkg_0184'
$prior0182 = Join-Path $ProjectRoot 'reports\pkg_0182\inventory.tsv'
$prior0183 = Join-Path $ProjectRoot 'reports\pkg_0183\inventory.tsv'
$prior0183Final = Join-Path $ProjectRoot 'reports\pkg_0183\final.log'
foreach ($path in @(
        $reportRoot,
        (Join-Path $reportRoot 'runtime_routes'),
        (Join-Path $reportRoot 'visual'),
        (Join-Path $reportRoot 'audio'),
        (Join-Path $reportRoot 'text'),
        (Join-Path $reportRoot 'animation')
    )) {
    [void](New-Item -ItemType Directory -Force -Path $path)
}

function ConvertTo-TsvField {
    param([AllowNull()][object] $Value)
    if ($null -eq $Value) { return '' }
    return ([string]$Value).Replace("`t", ' ').Replace("`r", ' ').Replace("`n", ' ')
}

function Write-Tsv {
    param(
        [Parameter(Mandatory)][string] $Path,
        [Parameter(Mandatory)][string[]] $Columns,
        [Parameter(Mandatory)][object[]] $Rows
    )
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add(($Columns -join "`t"))
    foreach ($row in $Rows) {
        $values = foreach ($column in $Columns) {
            ConvertTo-TsvField $row.$column
        }
        $lines.Add(($values -join "`t"))
    }
    Set-Content -LiteralPath $Path -Value $lines -Encoding utf8
}

function Get-Area {
    param([string] $Path)
    $normalized = $Path.Replace('/', '\')
    if ($normalized -notmatch '\\') { return 'root' }
    return ($normalized -split '\\')[0]
}

$includeRoots = @(
    'scripts', 'scenes', 'assets', 'tests', 'tools', 'docs', 'resources',
    'locale'
)
$rootFiles = @(
    'project.godot', 'export_presets.cfg', 'LICENSES.md', 'README.md',
    'AGENTS.md', 'VISUAL_DESIGN.md', 'icon.svg'
)
$excludeName = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($name in @(
        '.godot', 'reports', 'snapshots', 'archive_retired_web', 'dist',
        'skills', 'godot-mcp', 'vibe-eyes', 'playtest_panel_2026-08-25',
        'playtest_panel_2026-09-03', 'scratch', 'logs', 'node_modules',
        '.codex'
    )) {
    [void]$excludeName.Add($name)
}

Push-Location $ProjectRoot
try {
    $files = [System.Collections.Generic.List[string]]::new()
    foreach ($root in $includeRoots) {
        if (-not (Test-Path -LiteralPath $root)) { continue }
        Get-ChildItem -LiteralPath $root -Recurse -File -Force | ForEach-Object {
            $relative = $_.FullName.Substring($ProjectRoot.Length).TrimStart('\')
            $top = ($relative -split '\\')[0]
            if ($excludeName.Contains($top)) { return }
            $files.Add($relative.Replace('/', '\'))
        }
    }
    foreach ($config in $rootFiles) {
        if (Test-Path -LiteralPath $config -PathType Leaf) {
            $files.Add($config.Replace('/', '\'))
        }
    }
    $unique = @($files | Sort-Object -Unique)

    $inventory = foreach ($relativePath in $unique) {
        $item = Get-Item -LiteralPath $relativePath
        $hash = (Get-FileHash -LiteralPath $relativePath -Algorithm SHA256).Hash.ToLowerInvariant()
        [pscustomobject]@{
            path = $relativePath
            area = Get-Area $relativePath
            extension = $item.Extension.ToLowerInvariant()
            bytes = $item.Length
            sha256 = $hash
            last_write_utc = $item.LastWriteTimeUtc.ToString('o')
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'inventory.tsv') -Columns @(
        'path', 'area', 'extension', 'bytes', 'sha256', 'last_write_utc'
    ) -Rows @($inventory)

    function Read-InventoryPaths {
        param([string] $Path)
        $set = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
        if (Test-Path -LiteralPath $Path) {
            Import-Csv -LiteralPath $Path -Delimiter "`t" | ForEach-Object {
                [void]$set.Add(($_.path -replace '/', '\'))
            }
        }
        return $set
    }

    $paths0182 = Read-InventoryPaths $prior0182
    $paths0183 = Read-InventoryPaths $prior0183
    $currentPaths = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $inventory) { [void]$currentPaths.Add($entry.path) }

    $diffRows = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $inventory) {
        $in0182 = $paths0182.Contains($entry.path)
        $in0183 = $paths0183.Contains($entry.path)
        if (-not $in0183) {
            $reason = if ($entry.path -like 'tests\pkg_0184*') {
                'PKG-0184 new test'
            } elseif ($entry.path -like 'tools\*0184*') {
                'PKG-0184 new harness'
            } elseif ($entry.path -like 'docs\rebuild\PKG_0184*') {
                'PKG-0184 report'
            } else {
                'missing from PKG-0183 inventory'
            }
            $diffRows.Add([pscustomobject]@{
                    path = $entry.path
                    class = 'NEW_IN_0184'
                    vs_0182 = if ($in0182) { 'present' } else { 'absent' }
                    vs_0183 = 'absent'
                    reason = $reason
                })
        }
    }
    foreach ($old in ($paths0183 | Sort-Object)) {
        if (-not $currentPaths.Contains($old)) {
            $diffRows.Add([pscustomobject]@{
                    path = $old
                    class = 'ONLY_IN_0183'
                    vs_0182 = if ($paths0182.Contains($old)) { 'present' } else { 'absent' }
                    vs_0183 = 'present'
                    reason = 'listed in PKG-0183 inventory but absent from independent 0184 scan'
                })
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'inventory_diff.tsv') -Columns @(
        'path', 'class', 'vs_0182', 'vs_0183', 'reason'
    ) -Rows @($diffRows)

    $verifyText = Get-Content -LiteralPath (Join-Path $ProjectRoot 'tools\verify.ps1') -Raw
    $testRows = foreach ($test in (Get-ChildItem -LiteralPath 'tests' -Filter '*.gd' -File | Sort-Object Name)) {
        $invoked = $verifyText.Contains($test.Name)
        [pscustomobject]@{
            test = ('tests\' + $test.Name)
            verify_invoked = $invoked.ToString().ToLowerInvariant()
            bytes = $test.Length
            last_write_utc = $test.LastWriteTimeUtc.ToString('o')
            note = if ($invoked) { 'in verify.ps1' } else { 'NOT invoked by verify.ps1' }
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'verify_test_map.tsv') -Columns @(
        'test', 'verify_invoked', 'bytes', 'last_write_utc', 'note'
    ) -Rows @($testRows)

    $sourceStamp = (
        Get-ChildItem -Path @('scripts', 'scenes', 'assets', 'tests', 'tools', 'resources', 'project.godot') -Recurse -File -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTimeUtc -Descending |
            Select-Object -First 1
    )
    $final0183 = if (Test-Path -LiteralPath $prior0183Final) { Get-Item -LiteralPath $prior0183Final } else { $null }
    $report0183 = Get-Item -LiteralPath (Join-Path $ProjectRoot 'docs\rebuild\PKG_0183_INDEPENDENT_RED_TEAM_REPORT.md')
    $chronology = [pscustomobject]@{
        pkg0183_final_utc = if ($final0183) { $final0183.LastWriteTimeUtc.ToString('o') } else { 'MISSING' }
        pkg0183_report_utc = $report0183.LastWriteTimeUtc.ToString('o')
        report_before_final = if ($final0183) { ($report0183.LastWriteTimeUtc -lt $final0183.LastWriteTimeUtc).ToString().ToLowerInvariant() } else { 'unknown' }
        newest_source_path = if ($sourceStamp) { $sourceStamp.FullName.Substring($ProjectRoot.Length).TrimStart('\') } else { '' }
        newest_source_utc = if ($sourceStamp) { $sourceStamp.LastWriteTimeUtc.ToString('o') } else { '' }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'chronology.tsv') -Columns @(
        'pkg0183_final_utc', 'pkg0183_report_utc', 'report_before_final', 'newest_source_path', 'newest_source_utc'
    ) -Rows @($chronology)

    $textRows = [System.Collections.Generic.List[object]]::new()
    $loc = Get-Content -LiteralPath 'scripts\core\localization_manager.gd' -Raw
    $keyMatches = [regex]::Matches($loc, '"([A-Z][A-Z0-9_]+)":\s*"((?:\\.|[^"\\])*)"')
    foreach ($match in $keyMatches) {
        $textRows.Add([pscustomobject]@{
                source = 'scripts\core\localization_manager.gd'
                key = $match.Groups[1].Value
                text = $match.Groups[2].Value
                kind = 'ui_key'
            })
    }
    Get-ChildItem -LiteralPath 'scenes\levels' -Filter 'station_*.tscn' | ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw
        $open = [regex]::Match($content, 'opening_line\s*=\s*"((?:\\.|[^"\\])*)"')
        if ($open.Success) {
            $textRows.Add([pscustomobject]@{
                    source = ('scenes\levels\' + $_.Name)
                    key = 'opening_line'
                    text = $open.Groups[1].Value
                    kind = 'opening_line'
                })
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'text\visible_text_extract.tsv') -Columns @(
        'source', 'key', 'kind', 'text'
    ) -Rows @($textRows)

    $counts = [pscustomobject]@{
        inventory_files = $inventory.Count
        scenes_tscn = @($inventory | Where-Object { $_.extension -eq '.tscn' }).Count
        scripts_gd = @($inventory | Where-Object { $_.path -like 'scripts\*' -and $_.extension -eq '.gd' }).Count
        tests_gd = @($inventory | Where-Object { $_.path -like 'tests\*' -and $_.extension -eq '.gd' }).Count
        tools_files = @($inventory | Where-Object { $_.path -like 'tools\*' }).Count
        docs_files = @($inventory | Where-Object { $_.path -like 'docs\*' }).Count
        assets_files = @($inventory | Where-Object { $_.path -like 'assets\*' }).Count
        resources_files = @($inventory | Where-Object { $_.path -like 'resources\*' }).Count
        new_in_0184 = @($diffRows | Where-Object { $_.class -eq 'NEW_IN_0184' }).Count
        only_in_0183 = @($diffRows | Where-Object { $_.class -eq 'ONLY_IN_0183' }).Count
        tests_not_in_verify = @($testRows | Where-Object { $_.verify_invoked -eq 'false' }).Count
        text_candidates = $textRows.Count
        pkg0182_inventory_exists = (Test-Path -LiteralPath $prior0182).ToString().ToLowerInvariant()
        pkg0183_inventory_exists = (Test-Path -LiteralPath $prior0183).ToString().ToLowerInvariant()
    }
    $counts | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $reportRoot 'inventory_counts.json') -Encoding utf8
    Write-Host ("PKG-0184 inventory files={0} new_vs_0183={1} tests_not_in_verify={2} text_candidates={3}" -f `
            $counts.inventory_files, $counts.new_in_0184, $counts.tests_not_in_verify, $counts.text_candidates)
}
finally {
    Pop-Location
}
