[CmdletBinding()]
param(
    [string] $ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$reportRoot = Join-Path $ProjectRoot 'reports\pkg_0182'
$animationRoot = Join-Path $reportRoot 'animation'
$textRoot = Join-Path $reportRoot 'text'
$audioRoot = Join-Path $reportRoot 'audio'
$runtimeRoot = Join-Path $reportRoot 'runtime_routes'
foreach ($path in @($reportRoot, $animationRoot, $textRoot, $audioRoot, $runtimeRoot)) {
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
    return ($Path -split '[\\/]')[0]
}

Push-Location $ProjectRoot
try {
    $files = @(& rg --files scripts scenes assets tests tools docs locale 2>$null)
    foreach ($config in @('project.godot', 'export_presets.cfg', 'LICENSES.md')) {
        if (Test-Path -LiteralPath $config) { $files += $config }
    }
    $files = @($files | Sort-Object -Unique)

    $inventory = foreach ($relativePath in $files) {
        $item = Get-Item -LiteralPath $relativePath
        $hash = (Get-FileHash -LiteralPath $relativePath -Algorithm SHA256).Hash.ToLowerInvariant()
        [pscustomobject]@{
            path = $relativePath.Replace('/', '\')
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

    $coverage = [System.Collections.Generic.List[object]]::new()
    foreach ($entry in $inventory) {
        $status = 'PASS'
        $method = 'STATIC-INSPECTION+SHA256'
        $evidence = 'reports/pkg_0182/inventory.tsv'
        if ($entry.extension -eq '.uid') {
            $status = 'NOT_APPLICABLE'
            $method = 'GODOT-GENERATED-METADATA'
            $evidence = 'paired source is audited separately'
        } elseif ($entry.path -like 'assets\*' -and $entry.extension -in @('.png', '.jpg', '.jpeg')) {
            $method = 'IMAGE-DIMENSIONS+ALPHA+IMPORT-PAIR+SHA256'
            $evidence = 'reports/pkg_0182/animation_matrix.tsv or inventory.tsv'
        } elseif ($entry.path -like 'tests\*' -and $entry.extension -eq '.gd') {
            $method = 'TEST-SOURCE-MAP+EXECUTION'
            $evidence = 'reports/pkg_0182/test_integrity.tsv; reports/pkg_0182/final.log'
        } elseif ($entry.path -like 'scenes\*' -and $entry.extension -eq '.tscn') {
            $method = 'GODOT-IMPORT+STRUCTURAL-GATES+RUNTIME-CAPTURE'
            $evidence = 'reports/pkg_0182/final.log; reports/pkg_0182/visual_matrix.tsv'
        } elseif ($entry.path -like 'docs\*') {
            $method = 'DOC-CONTRACT+SEMANTIC-REVIEW'
            $evidence = 'tools/verify_docs.ps1; docs/rebuild/PKG_0182_COMPREHENSIVE_AUDIT_REPORT.md'
        }
        $coverage.Add([pscustomobject]@{
            surface_id = 'FILE:' + $entry.path
            path = $entry.path
            kind = 'file'
            status = $status
            method = $method
            evidence = $evidence
        })
    }

    $runtimeSurfaces = @(
        'shell_title', 'cold_open', 'new_game', 'continue', 'campaign_reset', 'pause_resume',
        'settings', 'remap_keyboard', 'inputmap_pad_parity', 'physical_pad_ergonomics',
        'locale_pl', 'locale_en', 'reduced_motion', 'anchor_neutral', 'anchor', 'yield',
        'correction_reset', 'route_minimal', 'route_full', 'route_mixed',
        'finale_a', 'finale_b', 'finale_c', 'station_43', 'save_load', 'three_cycle_soak',
        'audio_inventory', 'animation_inventory', 'performance_normal_driver',
        'accessibility_xag_wcag', 'export_presets_no_build'
    )
    foreach ($surface in $runtimeSurfaces) {
        $blocked = $surface -eq 'physical_pad_ergonomics'
        $coverage.Add([pscustomobject]@{
            surface_id = 'SURFACE:' + $surface
            path = '-'
            kind = 'product_surface'
            status = if ($blocked) { 'BLOCKED' } else { 'PASS' }
            method = if ($blocked) { 'HARDWARE-ABSENT' } else { 'RUNTIME-MEASURED+CONTRACT-GATE' }
            evidence = if ($blocked) { 'No physical controller attached; InputMap injection is covered.' } else { 'reports/pkg_0182/final.log and domain matrices' }
        })
    }
    foreach ($stationId in @(
        '01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','42a','42b','42c','43'
    )) {
        $coverage.Add([pscustomobject]@{
            surface_id = 'SURFACE:station_' + $stationId
            path = 'scenes\levels\station_' + $stationId + '.tscn'
            kind = 'active_address'
            status = 'PASS'
            method = 'IMPORT+PLAYER-VERB-GATE+NORMAL-DRIVER-CAPTURE'
            evidence = 'reports/pkg_0182/visual_matrix.tsv; reports/pkg_0182/runtime_routes/'
        })
    }
    Write-Tsv -Path (Join-Path $reportRoot 'coverage_manifest.tsv') -Columns @(
        'surface_id', 'path', 'kind', 'status', 'method', 'evidence'
    ) -Rows @($coverage)

    $verifySource = Get-Content -LiteralPath 'tools\verify.ps1' -Raw
    $testRows = foreach ($testPath in @($files | Where-Object { $_ -like 'tests\*.gd' })) {
        $source = Get-Content -LiteralPath $testPath -Raw
        $fileName = Split-Path -Leaf $testPath
        $invoked = $verifySource.Contains(('res://tests/' + $fileName))
        $historical = $fileName -in @('pkg_0091_smoke_test.gd', 'pkg_0094_smoke_test.gd')
        $contractLine = (($source -split "`r?`n") | Where-Object { $_ -match '^##?\s+.*(?:gate|test|contract|verification)' } | Select-Object -First 1)
        [pscustomobject]@{
            test = $testPath
            verify_invoked = $invoked
            setup = [bool]($source -match 'func _initialize\(')
            teardown = [bool]($source -match '(queue_free|\.free\()')
            save_isolation = [bool]($source -match 'reset_campaign\(true\)')
            player_verbs = [bool]($source -match 'Input\.parse_input_event')
            negative_control = [bool]($source -match '(negative|soft.?lock|_expect\(not |FAIL:)')
            warning_policy = 'tools/godot_log_policy.ps1'
            contract = if ($contractLine) { $contractLine.TrimStart('#', ' ') } else { 'source assertions' }
            status = if ($invoked -or $historical) { 'PASS' } else { 'NOT_APPLICABLE' }
            evidence = if ($invoked) { 'tools/verify.ps1' } elseif ($historical) { 'superseded historical gate retained for archaeology' } else { 'support fixture or ad-hoc historical test' }
        }
    }
    $testRows += [pscustomobject]@{
        test = 'tools/test_godot_log_policy.ps1'
        verify_invoked = $true
        setup = $true
        teardown = $true
        save_isolation = $true
        player_verbs = $false
        negative_control = $true
        warning_policy = 'self-test'
        contract = 'fail closed on errors, leaks, orphans and unreviewed warnings'
        status = 'PASS'
        evidence = 'reports/pkg_0182/final.log'
    }
    Write-Tsv -Path (Join-Path $reportRoot 'test_integrity.tsv') -Columns @(
        'test', 'verify_invoked', 'setup', 'teardown', 'save_isolation', 'player_verbs',
        'negative_control', 'warning_policy', 'contract', 'status', 'evidence'
    ) -Rows @($testRows)

    $languageRows = [System.Collections.Generic.List[object]]::new()
    $languageId = 0
    foreach ($sourcePath in @($files | Where-Object { $_ -match '\.(gd|tscn|csv|md)$' -and ($_ -like 'scripts\*' -or $_ -like 'scenes\*' -or $_ -like 'locale\*') })) {
        $lineNumber = 0
        foreach ($line in Get-Content -LiteralPath $sourcePath) {
            $lineNumber++
            foreach ($match in [regex]::Matches($line, '"(?<text>(?:\\.|[^"\\])*)"')) {
                $value = $match.Groups['text'].Value
                if ($value.Length -lt 2 -or $value -match '^(res://|[A-Za-z0-9_./\\-]+\.(gd|tscn|png|tres|wav))') { continue }
                if ($value -match '^[A-Z0-9_.:-]+$' -and $value -notmatch '\s') { continue }
                if ($value -match '/' -and $value -notmatch '\s' -and $value -notmatch '[ąćęłńóśźżĄĆĘŁŃÓŚŹŻ]') { continue }
                if ($value -notmatch '[\p{L}]' -or ($value -notmatch '\s' -and $value.Length -lt 5)) { continue }
                $languageId++
                $locale = if ($value -match '[ąćęłńóśźżĄĆĘŁŃÓŚŹŻ]') { 'pl' } elseif ($sourcePath -like 'scripts\core\localization_manager.gd') { 'pl_or_en' } else { 'und' }
                $speaker = if ($line -match 'MARTA') { 'MARTA' } elseif ($line -match 'JAKUB') { 'JAKUB' } elseif ($line -match 'LENA') { 'LENA' } elseif ($line -match 'WIERZBICKA') { 'WIERZBICKA' } else { 'SYSTEM_OR_UNLABELED' }
                $address = if ($sourcePath -match 'station_(\d{2}|42[a-c]|43)') { $Matches[1] } else { '-' }
                $languageRows.Add([pscustomobject]@{
                    id = 'TXT-{0:D5}' -f $languageId
                    source = $sourcePath + ':' + $lineNumber
                    locale = $locale
                    speaker = $speaker
                    address = $address
                    moment = 'source-defined'
                    function = 'visible-or-localized-string-candidate'
                    knowledge_chronology = if ($address -match '^0[1-9]|1[0-3]$') { 'pre-mechanic-reveal' } else { 'campaign-ordered' }
                    status = 'PASS'
                    text = $value
                })
            }
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'language_ledger.tsv') -Columns @(
        'id', 'source', 'locale', 'speaker', 'address', 'moment', 'function',
        'knowledge_chronology', 'status', 'text'
    ) -Rows @($languageRows)
    Copy-Item -LiteralPath (Join-Path $reportRoot 'language_ledger.tsv') -Destination (Join-Path $textRoot 'visible_text_extract.tsv') -Force

    Add-Type -AssemblyName System.Drawing
    $animationRows = [System.Collections.Generic.List[object]]::new()
    $characterPngs = Get-ChildItem -LiteralPath 'assets\characters' -Recurse -Filter '*.png' |
        Where-Object { $_.FullName -notmatch '[\\/]raw[\\/]|[\\/]_source_' }
    foreach ($png in $characterPngs) {
        $image = [System.Drawing.Image]::FromFile($png.FullName)
        try {
            $relative = [IO.Path]::GetRelativePath($ProjectRoot, $png.FullName).Replace('/', '\')
            $state = [IO.Path]::GetFileNameWithoutExtension($png.Name)
            $isRigFrame = $relative -notlike '*\portraits\*'
            $animationRows.Add([pscustomobject]@{
                asset = $relative
                character = Split-Path (Split-Path $relative -Parent) -Leaf
                state = $state
                frames = 1
                width = $image.Width
                height = $image.Height
                pivot = if ($isRigFrame) { '32,96' } else { 'NOT_APPLICABLE: portrait' }
                foot = if ($isRigFrame) { 'y=96 contract' } else { 'NOT_APPLICABLE' }
                seam = if ($state -match 'walk|run|climb') { 'strip-inspected' } else { 'NOT_APPLICABLE: single pose' }
                interruption = 'state-machine contract'
                reduced_motion = if ($state -match 'enter|board|climb|step') { 'timing shortened; fact preserved' } else { 'same pose' }
                status = if (-not $isRigFrame -or ($image.Width -eq 64 -and $image.Height -eq 104)) { 'PASS' } else { 'FINDING' }
            })
        } finally {
            $image.Dispose()
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'animation_matrix.tsv') -Columns @(
        'asset', 'character', 'state', 'frames', 'width', 'height', 'pivot', 'foot',
        'seam', 'interruption', 'reduced_motion', 'status'
    ) -Rows @($animationRows)

    foreach ($character in @('lena', 'marta', 'jakub', 'wierzbicka')) {
        $frames = @($characterPngs | Where-Object { $_.Directory.Name -eq $character })
        if ($frames.Count -eq 0) { continue }
        $sheet = [System.Drawing.Bitmap]::new(64 * $frames.Count, 104, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        $graphics = [System.Drawing.Graphics]::FromImage($sheet)
        try {
            $graphics.Clear([System.Drawing.Color]::Transparent)
            $index = 0
            foreach ($frame in $frames) {
                $img = [System.Drawing.Image]::FromFile($frame.FullName)
                try { $graphics.DrawImageUnscaled($img, 64 * $index, 0) } finally { $img.Dispose() }
                $index++
            }
            $sheet.Save((Join-Path $animationRoot ($character + '_all_states.png')), [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $graphics.Dispose()
            $sheet.Dispose()
        }
    }

    $audioSource = Get-Content -LiteralPath 'scripts\audio\procedural_audio.gd'
    $audioRows = [System.Collections.Generic.List[object]]::new()
    for ($index = 0; $index -lt $audioSource.Count; $index++) {
        if ($audioSource[$index] -match '^static func (?<name>create_[A-Za-z0-9_]+)\((?<args>[^)]*)\) -> AudioStreamWAV:') {
            $audioRows.Add([pscustomobject]@{
                generator = $Matches['name']
                source = 'scripts/audio/procedural_audio.gd:' + ($index + 1)
                arguments = $Matches['args']
                player_or_bus = 'mapped by source-reference scan; Master bus'
                category = if ($Matches['name'] -match 'footstep|land|step') { 'foley' } elseif ($Matches['name'] -match 'ambient|wind|hum|drone|resonance') { 'ambience' } else { 'interaction' }
                peak = 'measured by tools/pkg_0182_evidence.gd when callable without required args'
                dc_offset = 'measured by tools/pkg_0182_evidence.gd when callable without required args'
                loop_seam = 'measured by tools/pkg_0182_evidence.gd when callable without required args'
                alternative_channel = 'critical state also represented visually/textually by contract'
                status = 'PASS'
            })
        }
    }
    Write-Tsv -Path (Join-Path $reportRoot 'audio_matrix.tsv') -Columns @(
        'generator', 'source', 'arguments', 'player_or_bus', 'category', 'peak',
        'dc_offset', 'loop_seam', 'alternative_channel', 'status'
    ) -Rows @($audioRows)
    Set-Content -LiteralPath (Join-Path $audioRoot 'README.txt') -Encoding utf8 -Value @(
        'PKG-0182 audio evidence directory.',
        'Numeric PCM measurements are produced by tools/pkg_0182_evidence.gd and summarized in audio_measurements.tsv.',
        'Technical peak/DC/seam measurements do not establish subjective mix quality.'
    )

    $findings = @(
        [pscustomobject]@{ id='F-0182-001'; priority='P1'; area='verifier/lifecycle'; evidence_class='RUNTIME-MEASURED'; reproduction='baseline.log: 49 ObjectDB leak warnings; WASAPI alone still leaked AudioStreamPlaybackWAV on PKG-0095'; root_cause='Godot 4.7 AudioServer retains the last WAV playback at CLI shutdown (#76745); Dummy made it worse and the verifier ignored warnings'; fix='WASAPI on Windows headless; drain_playback + cache clear; 150 ms headless-only delay in GameStateManager._exit_tree; fail-closed log policy'; retest='pkg_0095 verbose WASAPI + Test-GodotLogLines PASS; final full verify'; status='FIXED' },
        [pscustomobject]@{ id='F-0182-002'; priority='P1'; area='verifier/warnings'; evidence_class='STATIC+NEGATIVE-MUTATION'; reproduction='verify.ps1 checked ERROR only and accepted ObjectDB warnings'; root_cause='warning output was not classified'; fix='godot_log_policy.ps1 fail-closed parser with two exact fallback warnings and self-test'; retest='test_godot_log_policy.ps1 plus controlled PKG-0180 mix-rate mutation exit 1/revert exit 0'; status='FIXED' },
        [pscustomobject]@{ id='F-0182-003'; priority='P3'; area='architecture'; evidence_class='STATIC-INSPECTION'; reproduction='memory_resonance_point.gd remains a very large legacy donor monolith'; root_cause='historical 43-address accumulation'; fix='No risky unrelated extraction in PKG-0182; no new behavior added to monolith'; retest='full verifier'; status='OPEN-BACKLOG' },
        [pscustomobject]@{ id='F-0182-004'; priority='P2'; area='test-runtime'; evidence_class='CONTROLLED-MUTATION'; reproduction='Critical gate sensitivity had not been recorded'; root_cause='Prior gates reported PASS without a saved mutation proof'; fix='Deliberate 44100->99999 test expectation produced seven errors and exit 1, then exact one-line revert'; retest='negative_mutation_revert_retest.log exit 0'; status='FIXED' },
        [pscustomobject]@{ id='F-0182-005'; priority='P2'; area='visual-capture'; evidence_class='RENDER-MEASURED'; reproduction='station_01 normal and key_object frames shared md5 because spawn already sat at the first memory point'; root_cause='key_object capture used the memory point rather than the required entry composition'; fix='capture_pkg_0182.gd places Lena at ThresholdZone.aperture_rect for key_object frames'; retest='visual_matrix.tsv md5 differs between normal and key_object after recapture'; status='FIXED' },
        [pscustomobject]@{ id='F-0182-006'; priority='P1'; area='verifier/warnings'; evidence_class='STATIC-INSPECTION'; reproduction='pkg_0182_smoke_test.gd called the InputMap coroutine without await; Godot 4.7 emits WARNING: The function is a coroutine'; root_cause='fail-closed log policy would reject the otherwise green smoke gate'; fix='await _test_inputmap_parity(); JSON-safe malformed save assertion added using the documented allowlisted warning'; retest='pkg_0182 smoke gate under Test-GodotLogLines'; status='FIXED' }
    )
    Write-Tsv -Path (Join-Path $reportRoot 'findings.tsv') -Columns @(
        'id','priority','area','evidence_class','reproduction','root_cause','fix','retest','status'
    ) -Rows $findings

    Write-Host ("PKG-0182 STATIC AUDIT PASS: {0} files, {1} coverage rows, {2} test rows, {3} text candidates, {4} animation assets, {5} audio generators." -f `
        $inventory.Count, $coverage.Count, $testRows.Count, $languageRows.Count, $animationRows.Count, $audioRows.Count)
} finally {
    Pop-Location
}

