[CmdletBinding()]
param()

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

function Invoke-GodotGate {
    param(
        [Parameter(Mandatory)]
        [string[]] $Arguments,

        [Parameter(Mandatory)]
        [string] $Name
    )

    Write-Host "== $Name =="
    # Godot 4.7's Dummy audio backend can retain the final WAV playback during
    # headless shutdown (upstream #76745). WASAPI keeps real audio behaviour in
    # the gates and retires the playback before ObjectDB cleanup on Windows.
    $effectiveArguments = if ($Arguments -contains '--headless') {
        $Arguments + @('--audio-driver', 'WASAPI')
    } else {
        $Arguments
    }
    $output = @(& $godot @effectiveArguments 2>&1)
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

Invoke-GodotGate `
    -Name 'Godot headless import' `
    -Arguments @('--headless', '--editor', '--path', $projectRoot, '--quit')

Invoke-GodotGate `
    -Name 'Getting Strange smoke test' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/smoke_test.gd')

Invoke-GodotGate `
    -Name 'Traversal contract lint' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/traversal_lint_test.gd')

# Delivered campaign chain gates. Each package that extends the chain adds its own gate here.
Invoke-GodotGate `
    -Name 'PKG-0095 Act II gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0095_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0096 Act IIb gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0096_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0097 Act IIc gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0097_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0099 Act II playable slice gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0099_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0100 Act I playable slice gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0100_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0101 Act IIb visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0101_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0102 Act IIc route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0102_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0103 Act III route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0103_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0104 Act IIIb route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0104_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0105 Act IIIc route visibility and obstacle gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0105_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0106 Act IV choice chamber and silence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0106_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0107 finale Vector-Stage and silence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0107_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0113 release-readiness truth and visual remediation gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0113_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0114 production shell and end-to-end campaign gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0114_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0115 R1 settings, remap, focus and localization gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0115_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0117 inherited Foundation component gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0117_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0118 Foundation Slice 01-07 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0118_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0119 Station 08-13 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0119_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0120 Station 14-23 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0120_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0121 Station 24-30 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0121_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0122 Station 31-37 Canon 0.3 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0122_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0123 Station 38-43 and Final Content Lock 3.0 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0123_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0124 Release Candidate 1 and Distribution gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0124_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0125 Feminine Lena, Diegetic Climbing, Bidirectionality and Scale gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0125_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0126 Atmospheric Soundscapes, Vector Lighting, Micro-particles and CRT Pacing gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0126_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0127 RAM Lifecycle, Sound Cache, Bidirectional Topology and Presentation Contrast gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0127_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0128 Golden Master audit, soak simulation and integrity gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0128_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0129 Global Traversal Geometry, Diegetic Ladders & Lifts gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0129_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0130 Frame budget, particle determinism and pixel-grid camera gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0130_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0130 Frame budget audit (45 campaign scenes)' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tools/frame_budget_audit.gd')

Invoke-GodotGate `
    -Name 'PKG-0132 Lena 4.0, scale, return and 18px step gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0132_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0133 walk gait, Station 01 exit and resolved interact gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0133_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0134 campaign playability walk and interact gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0134_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0135 capture, one_way remediation and backtrack gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0135_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0136 Lena 4.1 locomotion, station exits and frame layout gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0136_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0137 campaign framing budget, label clearance, exits and displacement-driven gait gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0137_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0138 player-verb narrative playthrough, guidance and backtrack gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0138_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0139 procedural soundscape per act, footstep materiality and CRT dialogue blip gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0139_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0140 Anchor/Yield audiovisual coupling, interaction haptics and camera easing gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0140_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0141 unified cinematic camera (45 scenes) and reduced-motion accessibility gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0141_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0142 Station 01 right edge and visual-mode parity gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0142_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0145 P7 diagnostic vertical slice gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0145_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0146 P7 S01-S05 diagnostic wave gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0146_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0147 P7 S06-S07 diagnostic wave gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0147_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0148 P7 S09-S10 diagnostic wave gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0148_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0149 P7 S11-S13 diagnostic wave gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0149_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0150 P7 S14-S15 diagnostic wave gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0150_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0151 final P7 audit gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0151_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0152 P8 release surface audit gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0152_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0153 P8 runtime release surface gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0153_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0154 P8 export rehearsal hardening gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0154_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0156 P9 product reset lock gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0156_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0157 P9 first five minutes gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0157_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0158 P9 first thirty minutes gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0158_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0159 P9 opening remediation and evidence recertification gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0159_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0160 P9 personal mystery and family repayment gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0160_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0162 P9 dead-circuit mechanic lesson gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0162_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0163 P9 mutual signal test gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0163_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0164 P9 safe analyzer and small cost gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0164_smoke_test.gd')
Invoke-GodotGate `
    -Name 'PKG-0165 P9 cost ledger and consent scope gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0165_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0166 P9 forecasts, consent gaps and method_committed gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0166_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0167 P9 forced return of arrived Lena gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0167_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0168 P9 closure of Plane and recovered local Lena gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0168_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0169 P9 mutual passage and memory leak threshold gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0169_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0170 P9 Station 43 epilogue and administrative closure gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0170_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0171 route integrity and cutover gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0171_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0172 GATE-CAST cast and portrait gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0172_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0173 GATE-ANIM steps and ladders gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0173_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0174 GATE-THRESH and aperture scale gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0174_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0175 GATE-FLOW continuous passability gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0175_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0176 GATE-INTRO cold open gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0176_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0177 integration, 14 gates and CHECKPOINT-06 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0177_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0179 360 quality and audit remediation gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0179_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0180 master polish, ambient soundscape and release readiness gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0180_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0182 comprehensive audit evidence and soak gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0182_smoke_test.gd')

Write-Host 'Verification passed.'



