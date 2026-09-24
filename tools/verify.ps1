[CmdletBinding()]
param(
    [ValidateSet('WASAPI', 'Dummy', 'PulseAudio', 'ALSA')]
    [string] $AudioDriver = 'WASAPI'
)

$ErrorActionPreference = 'Stop'
# NOTE (PKG-0227 / T3): the function definition below only names the gate
# runner; it is NOT an invocation. The census gate (pkg_0207) counts invocation
# lines by their line-continuation mark, so a raw name grep returns one extra
# hit (this definition) and looks like a broken pin. Do not "fix" the pin.
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
        $Arguments + @('--audio-driver', $AudioDriver)
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

Write-Host "Audio profile: $AudioDriver (Dummy does NOT certify physical audio output)"
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
    -Name 'PKG-0091 P9 opening regression gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0091_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0094 P9 early-route regression gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0094_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0188 audio and locale hygiene gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0188_hygiene_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0189 residual-boundary inventory gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0189_boundary_inventory_test.gd')

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

Invoke-GodotGate `
    -Name 'PKG-0183 independent red-team gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0183_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0184 final independent recertification gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0184_smoke_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0186 cast style unification gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0186_cast_style_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0187 full visual audit and evidence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0187_visual_audit_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0190 cinematic vignette contract gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0190_cinematics_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0191 canonical-fact alignment gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0191_canonical_fact_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0192 P7 callable surface retirement gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0192_p7_retirement_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0193 creative scene delivery gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0193_creative_scene_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0194 creative scene B delivery gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0194_creative_scene_b_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0195 creative scene C delivery gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0195_creative_scene_c_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0196 opening rhythm and carrier-branch gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0196_opening_rhythm_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0197 zero revision visual gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0197_zero_revision_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0198 zero revision slice2 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0198_zero_revision_slice2_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0199 MRP renderer extraction pilot gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0199_mrp_renderer_pilot_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0200 MRP renderer extraction slice2 gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0200_mrp_renderer_slice2_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0201 ocular inspection evidence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0201_ocular_inspection_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0202 text-scale ocular evidence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0202_text_scale_ocular_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0203 text-scale ocular rest evidence gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0203_text_scale_ocular_rest_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0205 station18 proptype hold gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0205_station18_proptype_hold_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0206 MRP interaction inventory gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0206_mrp_interaction_inventory_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0207 gate census and foundations gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0207_gate_census_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0208 campaign selector and defaults gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0208_campaign_selector_defaults_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0210 architectural audit remediation gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0210_architectural_audit_remediation_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0211 procedural audio census gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0211_procedural_audio_census_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0212 station disk census gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0212_station_disk_census_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0214 threshold ownership and exit-open gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0214_threshold_exit_open_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0215 gap voice and interact priority gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0215_gap_voice_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0216 dictionary content and palimpsest gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0216_dictionary_content_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0217 synthesis forecast and device voice gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0217_synthesis_forecast_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0218 apron palette and line gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0218_apron_palette_line_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0219 ceiling light and rose rule gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0219_ceiling_light_rose_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0220 ambient loop and duck gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0220_ambient_loop_duck_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0221 ladder intent and return threshold gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0221_ladder_return_scale_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0222 correction cost and budget gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0222_correction_cost_budget_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0223 voices and tempo gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0223_voices_tempo_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0224 cast rigs and family geometry gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0224_cast_geometry_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0225 vignettes and finales carriers gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0225_vignettes_finales_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0226 truth payoff and review table gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0226_truth_payoff_table_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0227 hygiene and tools pin gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0227_hygiene_tools_pin_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0230 story sense repair gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0230_story_sense_repair_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0232 causal chain gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0232_causal_chain_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0233 story sense bridges gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0233_story_sense_bridges_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0234 ghost props off campaign route gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0234_ghost_props_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0235 gap verbs P9 campaign gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0235_gap_verbs_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0236 cuts not teleports gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0236_cuts_not_teleports_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0237 earned words gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0237_earned_words_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0238 dialogue bridges gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0238_dialogue_bridges_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0241 visual, animation and modal UX regression gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0241_visual_ux_test.gd')

Invoke-GodotGate `
    -Name 'PKG-0242 route traversal and interact priority gate' `
    -Arguments @('--headless', '--path', $projectRoot, '--script', 'res://tests/pkg_0242_route_traversal_test.gd')

Write-Host 'Verification passed.'

