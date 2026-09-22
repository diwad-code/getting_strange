[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string[]] $GateScripts,

    [string] $ScopeNote = ""
)

# PKG-0199 / D-217 — scoped verification. Runs the documentation contract plus
# an explicit subset of Godot gates with the SAME log policy as verify.ps1.
# Use only when the package blast radius excludes shared monoliths (see
# WORKFLOW.md "Weryfikacja zakresowa"). Packages touching shared files must
# run the full .\tools\verify.ps1 instead — PKG-0199 proved why: its scoped
# gates (0189+0199) were GREEN while the full run caught a real regression in
# PKG-0160 outside the assumed blast radius (Marta pink-hair slice moved to
# the helper; fixed by delegation-aware assertion, D-216).
#
# Example (MRP-adjacent change):
#   pwsh -NoProfile -File .\tools\verify_scoped.ps1 -GateScripts @(
#     'res://tests/pkg_0189_boundary_inventory_test.gd',
#     'res://tests/pkg_0199_mrp_renderer_pilot_test.gd',
#     'res://tests/pkg_0160_smoke_test.gd',
#     'res://tests/traversal_lint_test.gd'
#   ) -ScopeNote "PKG-02XX: MRP facade neighbours after renderer move"

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'godot_log_policy.ps1')
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

function Invoke-ScopedGate {
    param(
        [Parameter(Mandatory)]
        [string] $Script,

        [Parameter(Mandatory)]
        [string] $Name
    )

    Write-Host "== $Name =="
    $output = @(& $godot --headless --path $projectRoot --script $Script --audio-driver WASAPI 2>&1)
    $exitCode = $LASTEXITCODE
    $output | ForEach-Object { Write-Host $_ }

    if ($exitCode -ne 0) {
        throw "$Name failed with exit code $exitCode"
    }

    Test-GodotLogLines -Lines $output -GateName $Name
}

Write-Host '== Godot log policy self-test =='
& (Join-Path $PSScriptRoot 'test_godot_log_policy.ps1')

Write-Host '== Documentation contract =='
& (Join-Path $PSScriptRoot 'verify_docs.ps1') -ProjectRoot $projectRoot

if ($ScopeNote -ne "") {
    Write-Host ("== Scope: {0} ==" -f $ScopeNote)
}

Invoke-ScopedGate -Script 'res://tests/smoke_test.gd' -Name 'Getting Strange smoke test (always in scope)'

foreach ($gate in $GateScripts) {
    Invoke-ScopedGate -Script $gate -Name ("Scoped gate: {0}" -f $gate)
}

Write-Host 'Scoped verification passed.'
