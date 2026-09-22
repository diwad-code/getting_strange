[CmdletBinding()]
param(
    [string] $ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$reportRoot = Join-Path $ProjectRoot 'reports\pkg_0183'
$priorInventory = Join-Path $ProjectRoot 'reports\pkg_0182\inventory.tsv'
$priorCoverage = Join-Path $ProjectRoot 'reports\pkg_0182\coverage_manifest.tsv'
$priorFinal = Join-Path $ProjectRoot 'reports\pkg_0182\final.log'
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

    $priorPaths = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    if (Test-Path -LiteralPath $priorInventory) {
        Import-Csv -LiteralPath $priorInventory -Delimiter "`t" | ForEach-Object {
            [void]$priorPaths.Add(($_.path -replace '/', '\'))
        }
    }
    $currentPaths = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
    foreach ($entry in $inventory) { [void]$currentPaths.Add($entry.path) }

    $diffRows = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $inventory) {
        if (-not $priorPaths.Contains($entry.path)) {
            $reason = if ($entry.path -like 'resources\*') {
                'PKG-0182 inventory omitted resources/ runtime data'
            } elseif ($entry.area -eq 'root') {
                'PKG-0182 inventory omitted root runtime/config files outside its rg roots'
            } else {
                'missing from PKG-0182 inventory'
            }
            $diffRows.Add([pscustomobject]@{
                    path = $entry.path
                    class = 'MISSING_FROM_0182'
                    reason = $reason
                })
        }
    }
    foreach ($old in ($priorPaths | Sort-Object)) {
        if (-not $currentPaths.Contains($old)) {
            $diffRows.Add([pscustomobject]@{
                    path = $old
                    class = 'ONLY_IN_0182'
                    reason = 'listed in PKG-0182 inventory but absent from independent 0183 scan'
                })
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'inventory_diff.tsv') -Columns @(
        'path', 'class', 'reason'
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
    $finalItem = if (Test-Path -LiteralPath $priorFinal) { Get-Item -LiteralPath $priorFinal } else { $null }
    $chronology = [pscustomobject]@{
        pkg0182_final_utc = if ($finalItem) { $finalItem.LastWriteTimeUtc.ToString('o') } else { 'MISSING' }
        newest_source_path = if ($sourceStamp) { $sourceStamp.FullName.Substring($ProjectRoot.Length).TrimStart('\') } else { '' }
        newest_source_utc = if ($sourceStamp) { $sourceStamp.LastWriteTimeUtc.ToString('o') } else { '' }
        final_after_sources = if ($finalItem -and $sourceStamp) { ($finalItem.LastWriteTimeUtc -ge $sourceStamp.LastWriteTimeUtc).ToString().ToLowerInvariant() } else { 'unknown' }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'chronology.tsv') -Columns @(
        'pkg0182_final_utc', 'newest_source_path', 'newest_source_utc', 'final_after_sources'
    ) -Rows @($chronology)

    $counts = [pscustomobject]@{
        inventory_files = $inventory.Count
        scenes_tscn = @($inventory | Where-Object { $_.extension -eq '.tscn' }).Count
        scripts_gd = @($inventory | Where-Object { $_.path -like 'scripts\*' -and $_.extension -eq '.gd' }).Count
        tests_gd = @($inventory | Where-Object { $_.path -like 'tests\*' -and $_.extension -eq '.gd' }).Count
        tools_files = @($inventory | Where-Object { $_.path -like 'tools\*' }).Count
        docs_files = @($inventory | Where-Object { $_.path -like 'docs\*' }).Count
        assets_files = @($inventory | Where-Object { $_.path -like 'assets\*' }).Count
        resources_files = @($inventory | Where-Object { $_.path -like 'resources\*' }).Count
        missing_from_0182 = @($diffRows | Where-Object { $_.class -eq 'MISSING_FROM_0182' }).Count
        only_in_0182 = @($diffRows | Where-Object { $_.class -eq 'ONLY_IN_0182' }).Count
        tests_not_in_verify = @($testRows | Where-Object { $_.verify_invoked -eq 'false' }).Count
        prior_coverage_exists = (Test-Path -LiteralPath $priorCoverage).ToString().ToLowerInvariant()
    }
    $counts | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $reportRoot 'inventory_counts.json') -Encoding utf8
    Write-Host ("PKG-0183 inventory files={0} missing_from_0182={1} tests_not_in_verify={2}" -f `
            $counts.inventory_files, $counts.missing_from_0182, $counts.tests_not_in_verify)
}
finally {
    Pop-Location
}
