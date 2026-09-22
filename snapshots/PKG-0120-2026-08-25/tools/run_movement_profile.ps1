[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('A', 'B', 'C')]
    [string] $Profile,

    [switch] $CheckOnly
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
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

$profileId = $Profile.ToUpperInvariant()
$godotArguments = @('--path', $projectRoot)
if ($CheckOnly) {
    $godotArguments += '--headless'
}
$godotArguments += @('--', "--movement-profile=$profileId")
if ($CheckOnly) {
    $godotArguments += '--profile-check'
}

Write-Host "FACILITATOR PROFILE: $profileId"
& $godot @godotArguments
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    throw "Movement profile $profileId failed with exit code $exitCode"
}
