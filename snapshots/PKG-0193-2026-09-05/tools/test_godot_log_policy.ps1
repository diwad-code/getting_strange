[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'godot_log_policy.ps1')

Test-GodotLogLines -GateName 'allowed warning probe' -Lines @(
    'Godot Engine v4.7.2.stable.official',
    'WARNING: GameStateManager ignored malformed campaign save; using a clean campaign.',
    'WARNING: GameStateManager ignored unsupported settings schema; using defaults.',
    'WARNING: GameStateManager ignored unsupported campaign schema; using a clean campaign.',
    'WARNING: GameStateManager could not open campaign save; using a clean campaign.',
    'Verification passed.'
)

$negativeCases = @(
    'SCRIPT ERROR: Invalid call.',
    'SCRIPT WARNING: The function "_finish()" is a coroutine, so it must be called with "await".',
    'Parse Error: Expected expression.',
    'WARNING: 2 ObjectDB instances were leaked at exit.',
    'Leaked instance: AudioStreamWAV:123',
    'RID allocations leaked at exit.',
    'Orphan StringName: Master',
    'WARNING: an unreviewed warning'
)

foreach ($negativeCase in $negativeCases) {
    $failedAsExpected = $false
    try {
        Test-GodotLogLines -GateName 'negative policy probe' -Lines @($negativeCase)
    } catch {
        $failedAsExpected = $true
    }
    if (-not $failedAsExpected) {
        throw "Log policy accepted forbidden line: $negativeCase"
    }
}

Write-Host 'GODOT LOG POLICY PASS: forbidden errors, leaks, orphans and warnings fail closed.'

