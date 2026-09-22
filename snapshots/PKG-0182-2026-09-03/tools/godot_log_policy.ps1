Set-StrictMode -Version Latest

function Test-GodotLogLines {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Lines,

        [Parameter(Mandatory)]
        [string] $GateName
    )

    # These warnings are emitted only by negative-path tests which deliberately
    # feed malformed persisted data and assert the documented clean fallback.
    $allowedWarnings = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::Ordinal
    )
    [void]$allowedWarnings.Add(
        'WARNING: GameStateManager ignored malformed campaign save; using a clean campaign.'
    )
    [void]$allowedWarnings.Add(
        'WARNING: GameStateManager ignored unsupported settings schema; using defaults.'
    )

    $violations = [System.Collections.Generic.List[string]]::new()
    foreach ($entry in $Lines) {
        $line = [string]$entry
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed)) {
            continue
        }

        if ($trimmed -match '^(SCRIPT ERROR|ERROR:)' -or $trimmed -match 'Parse Error:') {
            $violations.Add($trimmed)
            continue
        }
        if (
            $trimmed -match '(?i)ObjectDB instances were leaked' -or
            $trimmed -match '(?i)^Leaked instance:' -or
            $trimmed -match '(?i)\bRID\b.*\bleak' -or
            $trimmed -match '(?i)\borphan(?:ed)?\b'
        ) {
            $violations.Add($trimmed)
            continue
        }
        if ($trimmed.StartsWith('WARNING:', [System.StringComparison]::Ordinal)) {
            if (-not $allowedWarnings.Contains($trimmed)) {
                $violations.Add($trimmed)
            }
        }
    }

    if ($violations.Count -gt 0) {
        $details = $violations -join "`n - "
        throw "$GateName violated the Godot log policy:`n - $details"
    }
}

