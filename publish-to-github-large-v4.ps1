#Requires -Version 5.1
# publish-to-github-large-v4.ps1
# Kodowanie: UTF-8 BOM
#
# ZMIANY W v4 (wzgl. v3.1):
#   BUGFIX: $args → $ghArgs (kolizja z automatyczną zmienną PS)
#   BUGFIX: Add-Content -Encoding UTF8 (polskie znaki w logu)
#   BUGFIX: plik logu auto-dodawany do .gitignore (Ensure-LogFileIgnored)
#   BUGFIX: origin istnieje + repo nie ma na GH → set-url zamiast błędu
#   BUGFIX: Analyze-ProjectFiles filtruje pliki z .gitignore (Get-GitIgnoredPaths)
#   BUGFIX: git init przeniesiony PRZED analizę (żeby git ls-files działało)
#   NOWE: -Description — opis repo na GitHubie
#   NOWE: -Org        — repo w organizacji
#   NOWE: -RepoName   — override nazwy folderu
#   NOWE: -DryRun     — tryb podglądu bez zmian
#   NOWE: -GenerateReadme — auto README.md
#   NOWE: -NoLargeFileCheck — pomijaj analizę dużych plików
#   NOWE: Get-SanitizedRepoName — walidacja nazwy repo
#   NOWE: Rozszerzona lista ciężkich katalogów (.gradle, .next, .nuxt, vendor, __pycache__)

[CmdletBinding()]
param(
    [switch]$Public,
    [switch]$Private,
    [string]$Description       = "",
    [string]$Org               = "",
    [string]$RepoName          = "",
    [switch]$NoGitIgnore,
    [string]$CommitMessage     = "Pierwszy commit",
    [switch]$Force,
    [int]$TopLargestFiles      = 20,
    [switch]$NonInteractive,
    [ValidateSet("Git","LFS","Ignore","Abort")]
    [string]$LargeFiles50To100MB  = "Git",
    [ValidateSet("LFS","Ignore","Abort")]
    [string]$LargeFilesOver100MB  = "Abort",
    [string]$LogFile              = ".\publish-to-github.log",
    [switch]$DryRun,
    [switch]$GenerateReadme,
    [switch]$NoLargeFileCheck
)

$ErrorActionPreference  = "Stop"
$script:ResolvedLogFile = [System.IO.Path]::GetFullPath($LogFile)
$script:IsDryRun        = $DryRun.IsPresent

# ─── Logging ──────────────────────────────────────────────────────────────────
function Write-LogLine([string]$level, [string]$msg) {
    $ts   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "[$ts] [$level] $msg"
    Add-Content -Path $script:ResolvedLogFile -Value $line -Encoding UTF8
}
function Write-Info([string]$msg)    { Write-Host "[INFO] $msg" -ForegroundColor Cyan;    Write-LogLine "INFO" $msg }
function Write-Ok([string]$msg)      { Write-Host "[ OK ] $msg" -ForegroundColor Green;   Write-LogLine "OK"   $msg }
function Write-WarnMsg([string]$msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow;  Write-LogLine "WARN" $msg }
function Write-ErrMsg([string]$msg)  { Write-Host "[ERR ] $msg" -ForegroundColor Red;     Write-LogLine "ERR"  $msg }
function Write-DryRun([string]$msg)  { Write-Host "[DRY ] $msg" -ForegroundColor DarkGray; Write-LogLine "DRY" $msg }

# ─── Helpers ──────────────────────────────────────────────────────────────────
function Confirm-Action([string]$msg) {
    if ($NonInteractive) { return $true }
    $answer = Read-Host "$msg [t/n]"
    return ($answer -match '^(t|tak|y|yes)$')
}

function Ask-Choice([string]$title, [string[]]$options, [int]$defaultIndex = 1) {
    if ($NonInteractive) {
        Write-Info "Tryb nieinteraktywny: automatycznie wybrano opcję ${defaultIndex}: $($options[$defaultIndex - 1])"
        return $defaultIndex
    }
    Write-Host ""
    Write-Host $title -ForegroundColor White
    for ($i = 0; $i -lt $options.Count; $i++) {
        $marker = if (($i + 1) -eq $defaultIndex) { " [domyślna]" } else { "" }
        Write-Host ("  {0}) {1}{2}" -f ($i + 1), $options[$i], $marker)
    }
    do {
        $raw = Read-Host "Wybierz opcję [1-$($options.Count)] (Enter = $defaultIndex)"
        if ([string]::IsNullOrWhiteSpace($raw)) { return $defaultIndex }
        $num = 0
        $ok  = [int]::TryParse($raw, [ref]$num)
    } while (-not $ok -or $num -lt 1 -or $num -gt $options.Count)
    return $num
}

function Test-CommandExists([string]$name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# BUGFIX: oryginalne Run-Step nie miało ochrony DryRun i nie używało typed params
function Run-Step([string]$exe, [string[]]$arguments) {
    $cmdText = "{0} {1}" -f $exe, ($arguments -join " ")
    if ($script:IsDryRun) {
        Write-DryRun "Pominięto: $cmdText"
        return
    }
    Write-Info "Uruchamiam: $cmdText"
    & $exe @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Polecenie zakończone błędem (exit $LASTEXITCODE): $cmdText"
    }
}

function Get-Owner([string]$ghLogin) {
    if (-not [string]::IsNullOrWhiteSpace($Org)) { return $Org }
    return $ghLogin
}

function Get-GitHubUserLogin {
    try {
        $login = gh api user --jq .login 2>$null
        if ([string]::IsNullOrWhiteSpace($login)) { return $null }
        return $login.Trim()
    } catch { return $null }
}

# NOWE: walidacja i sanityzacja nazwy repo zgodnie z regułami GitHub
function Get-SanitizedRepoName([string]$name) {
    # Spacje → myślnik
    $s = $name -replace '\s+', '-'
    # Usuń znaki niedozwolone w nazwach repo GitHub (dozwolone: a-zA-Z0-9, -, _, .)
    $s = $s -replace '[^a-zA-Z0-9\-_\.]', ''
    # Trimuj myślniki i kropki z brzegów
    $s = $s.Trim('-').Trim('.')
    # Limit 100 znaków (limit GitHub)
    if ($s.Length -gt 100) { $s = $s.Substring(0, 100).TrimEnd('-').TrimEnd('.') }
    return $s
}

function Test-GitRepo {
    try { git rev-parse --is-inside-work-tree *> $null; return ($LASTEXITCODE -eq 0) }
    catch { return $false }
}
function Test-GitRemoteOrigin {
    try { git remote get-url origin *> $null; return ($LASTEXITCODE -eq 0) }
    catch { return $false }
}
function Test-AnyCommitExists {
    try { git rev-parse --verify HEAD *> $null; return ($LASTEXITCODE -eq 0) }
    catch { return $false }
}
function Test-StagedChanges {
    try { git diff --cached --quiet; return ($LASTEXITCODE -ne 0) }
    catch { return $false }
}
function Test-UntrackedOrModifiedFiles {
    $status = git status --porcelain
    return -not [string]::IsNullOrWhiteSpace(($status | Out-String))
}
function Test-GitHubRepoExists([string]$owner, [string]$repo) {
    try { gh repo view "$owner/$repo" *> $null; return ($LASTEXITCODE -eq 0) }
    catch { return $false }
}

function Format-Bytes([Int64]$bytes) {
    if ($bytes -ge 1GB)  { return "{0:N2} GB" -f ($bytes / 1GB) }
    elseif ($bytes -ge 1MB) { return "{0:N2} MB" -f ($bytes / 1MB) }
    elseif ($bytes -ge 1KB) { return "{0:N2} KB" -f ($bytes / 1KB) }
    else { return "$bytes B" }
}

function Get-RelativePathSafe([string]$basePath, [string]$fullPath) {
    $base        = [System.IO.Path]::GetFullPath($basePath)
    $full        = [System.IO.Path]::GetFullPath($fullPath)
    $baseUri     = New-Object System.Uri(($base.TrimEnd('\') + '\'))
    $fullUri     = New-Object System.Uri($full)
    $relativeUri = $baseUri.MakeRelativeUri($fullUri)
    $rel         = [System.Uri]::UnescapeDataString($relativeUri.ToString())
    return $rel -replace '/', '\'
}

# NOWE: pobiera listę plików ignorowanych przez .gitignore (wymaga git init)
function Get-GitIgnoredPaths {
    if (-not (Test-GitRepo)) { return @() }
    try {
        $raw = git ls-files -i --exclude-standard --others 2>$null
        if (-not $raw) { return @() }
        return @($raw | ForEach-Object { $_ -replace '/', '\' })
    } catch { return @() }
}

# ─── .gitignore ───────────────────────────────────────────────────────────────
function New-DefaultGitIgnore {
    if ($script:IsDryRun) { Write-DryRun "Pominięto tworzenie .gitignore"; return }

    $content = @"
# === Wygenerowano przez publish-to-github ===

# Zależności
node_modules/
vendor/

# Build
dist/
build/
out/
bin/
obj/
.next/
.nuxt/

# Logi (w tym logi skryptu publish)
*.log

# Zmienne środowiskowe / sekrety
.env
.env.*
!.env.example

# IDE / edytory
.vs/
.vscode/
.idea/

# System
Thumbs.db
.DS_Store

# Tymczasowe
tmp/
temp/

# Python
__pycache__/
*.pyc
*.pyo
.venv/
venv/

# .NET
*.user
*.suo
*.cache

# Coverage
coverage/
.coverage

# Gradle / Android
.gradle/
local.properties
"@
    Set-Content -Path ".gitignore" -Value $content -Encoding UTF8
}

function Add-Lines-ToGitIgnore([string[]]$lines) {
    if ($script:IsDryRun) {
        Write-DryRun "Pominięto aktualizację .gitignore (dodano by: $($lines -join ', '))"
        return
    }
    if (-not (Test-Path ".gitignore")) {
        New-Item -ItemType File -Path ".gitignore" | Out-Null
    }
    $existing = Get-Content ".gitignore" -ErrorAction SilentlyContinue
    if (-not $existing) { $existing = @() }

    $toAdd = @($lines | Where-Object {
        -not [string]::IsNullOrWhiteSpace($_) -and $existing -notcontains $_
    })

    if ($toAdd.Count -gt 0) {
        Add-Content ".gitignore" ""                                           -Encoding UTF8
        Add-Content ".gitignore" "# Dodano automatycznie przez publish script" -Encoding UTF8
        foreach ($line in $toAdd) {
            Add-Content ".gitignore" $line -Encoding UTF8
        }
    }
}

# NOWE: pilnuje, żeby plik logu nie trafił do repo
function Ensure-LogFileIgnored {
    $logFileName = Split-Path -Leaf $script:ResolvedLogFile
    if (-not (Test-Path ".gitignore")) {
        Write-WarnMsg "Brak .gitignore — plik logu '$logFileName' może trafić do repo!"
        return
    }
    $existing = Get-Content ".gitignore" -ErrorAction SilentlyContinue
    if (-not $existing) { $existing = @() }
    # Sprawdź czy log jest już pokryty przez wpis lub wildcard *.log
    $covered = ($existing -contains $logFileName) -or ($existing -contains "*.log")
    if (-not $covered) {
        Add-Lines-ToGitIgnore @($logFileName)
        Write-Info "Dodano '$logFileName' do .gitignore"
    }
}

# NOWE: auto-generuje README.md z podstawowym szablonem
function New-DefaultReadme([string]$repoName, [string]$description) {
    if ($script:IsDryRun) { Write-DryRun "Pominięto tworzenie README.md"; return }
    if (Test-Path "README.md") { Write-Info "README.md już istnieje — pomijam"; return }

    $descLine = if ([string]::IsNullOrWhiteSpace($description)) {
        "> Opis projektu — uzupełnij."
    } else {
        "> $description"
    }

    # Używamy zmiennej dla backtick-ów, by uniknąć problemów z interpolacją w heredoc
    $cb = '```'
    $content = @"
# $repoName

$descLine

## Instalacja

${cb}bash
# Uzupełnij
${cb}

## Użycie

${cb}bash
# Uzupełnij
${cb}

## Licencja

*Uzupełnij*
"@
    Set-Content -Path "README.md" -Value $content -Encoding UTF8
    Write-Ok "Wygenerowano README.md"
}

# ─── Ciężkie katalogi ─────────────────────────────────────────────────────────
function Get-HeavyDirectories {
    # ROZSZERZONO o .gradle, .next, .nuxt, vendor, __pycache__
    $knownHeavy = @(
        "node_modules", "vendor",
        "dist", "build", "out", ".next", ".nuxt",
        ".venv", "venv",
        "bin", "obj",
        ".vs", ".idea", ".gradle",
        "coverage",
        "tmp", "temp",
        "__pycache__"
    )

    $cwd  = (Get-Location).Path
    $dirs = Get-ChildItem -LiteralPath $cwd -Recurse -Directory -Force |
        Where-Object {
            $_.FullName -notmatch '\\\.git(\\|$)' -and $knownHeavy -contains $_.Name
        } |
        ForEach-Object {
            $size = 0
            try {
                $size = (Get-ChildItem -LiteralPath $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue |
                    Measure-Object -Property Length -Sum).Sum
                if (-not $size) { $size = 0 }
            } catch { $size = 0 }

            [PSCustomObject]@{
                FullName     = $_.FullName
                RelativePath = Get-RelativePathSafe -basePath $cwd -fullPath $_.FullName
                Name         = $_.Name
                Size         = [Int64]$size
            }
        } |
        Sort-Object Size -Descending
    return $dirs
}

function Show-HeavyDirectories($dirs) {
    if (-not $dirs -or @($dirs).Count -eq 0) {
        Write-Info "Nie wykryto typowych ciężkich katalogów."
        return
    }
    Write-Host "Typowe ciężkie katalogi wykryte w projekcie:" -ForegroundColor White
    foreach ($d in $dirs) {
        $line = " - {0}  [{1}]" -f $d.RelativePath, (Format-Bytes $d.Size)
        Write-Host $line
        Write-LogLine "INFO" $line
    }
    Write-Host ""
}

function Ignore-Directories($dirs) {
    if (-not $dirs -or @($dirs).Count -eq 0) { return }
    $lines = @($dirs | ForEach-Object {
        ($_.RelativePath -replace '\\', '/').TrimEnd('/') + "/"
    })
    Add-Lines-ToGitIgnore -lines $lines
    Write-Ok "Dodano katalogi do .gitignore"
}

# ─── Analiza plików ───────────────────────────────────────────────────────────
# BUGFIX: teraz respektuje .gitignore przez Get-GitIgnoredPaths
# BUGFIX: wyświetla osobno pliki "do wysłania" vs "ignorowane"
function Analyze-ProjectFiles {
    $cwd = (Get-Location).Path
    Write-Info "Analizuję pliki projektu (to może chwilę potrwać)..."

    $allFiles = Get-ChildItem -LiteralPath $cwd -Recurse -File -Force |
        Where-Object { $_.FullName -notmatch '\\\.git(\\|$)' } |
        ForEach-Object {
            [PSCustomObject]@{
                FullName     = $_.FullName
                RelativePath = Get-RelativePathSafe -basePath $cwd -fullPath $_.FullName
                Length       = [Int64]$_.Length
                Extension    = $_.Extension
                Name         = $_.Name
            }
        }

    # Pobierz pliki ignorowane przez gitignore (działa po git init)
    $ignoredSet = @(Get-GitIgnoredPaths)

    $effectiveFiles = if ($ignoredSet.Count -gt 0) {
        $allFiles | Where-Object { $ignoredSet -notcontains $_.RelativePath }
    } else {
        $allFiles
    }

    $totalSize     = [Int64](($allFiles       | Measure-Object -Property Length -Sum).Sum)
    $effectiveSize = [Int64](($effectiveFiles | Measure-Object -Property Length -Sum).Sum)
    if (-not $totalSize)     { $totalSize     = 0 }
    if (-not $effectiveSize) { $effectiveSize = 0 }

    return [PSCustomObject]@{
        AllFiles           = $allFiles
        EffectiveFiles     = $effectiveFiles
        TotalSize          = $totalSize
        EffectiveTotalSize = $effectiveSize
        LargestFiles       = @($effectiveFiles | Sort-Object Length -Descending | Select-Object -First $TopLargestFiles)
        FilesOver50MB      = @($effectiveFiles | Where-Object { $_.Length -gt 50MB })
        FilesOver100MB     = @($effectiveFiles | Where-Object { $_.Length -gt 100MB })
        FileCount          = @($allFiles).Count
        EffectiveFileCount = @($effectiveFiles).Count
        IgnoredFileCount   = @($allFiles).Count - @($effectiveFiles).Count
    }
}

function Show-AnalysisSummary($analysis) {
    Write-Host ""
    Write-Host "=== Analiza projektu ===" -ForegroundColor White
    Write-Host ("Pliki do wysłania  : {0}" -f $analysis.EffectiveFileCount)
    Write-Host ("Pliki ignorowane   : {0}" -f $analysis.IgnoredFileCount) -ForegroundColor DarkGray
    Write-Host ("Rozmiar (do wysł.) : {0}" -f (Format-Bytes $analysis.EffectiveTotalSize))
    if ($analysis.TotalSize -ne $analysis.EffectiveTotalSize) {
        Write-Host ("Rozmiar (wszystkie): {0}" -f (Format-Bytes $analysis.TotalSize)) -ForegroundColor DarkGray
    }
    Write-Host ("Pliki > 50 MB      : {0}" -f $analysis.FilesOver50MB.Count)
    Write-Host ("Pliki > 100 MB     : {0}" -f $analysis.FilesOver100MB.Count)
    Write-Host ""
    Write-LogLine "INFO" "Pliki: $($analysis.EffectiveFileCount), ignorowane: $($analysis.IgnoredFileCount), rozmiar: $(Format-Bytes $analysis.EffectiveTotalSize)"

    if ($analysis.LargestFiles -and @($analysis.LargestFiles).Count -gt 0) {
        Write-Host "Największe pliki (do wysłania):" -ForegroundColor White
        $i = 1
        foreach ($f in $analysis.LargestFiles) {
            $line = "{0,2}. {1}  [{2}]" -f $i, $f.RelativePath, (Format-Bytes $f.Length)
            Write-Host $line
            Write-LogLine "INFO" $line
            $i++
        }
        Write-Host ""
    }
}

# ─── Git LFS ──────────────────────────────────────────────────────────────────
function Ensure-GitLfsInstalledIfChosen {
    $hasLfs = $false
    try { git lfs version *> $null; $hasLfs = ($LASTEXITCODE -eq 0) } catch {}
    if (-not $hasLfs) {
        throw "Wybrano Git LFS, ale Git LFS nie jest zainstalowany. Zainstaluj i uruchom ponownie."
    }
    Run-Step "git" @("lfs", "install")
    Write-Ok "Git LFS gotowy"
}

# BUGFIX: jawnie dodaje .gitattributes do stage po śledzeniu przez LFS
function Track-Files-WithGitLfs($files) {
    if (-not $files -or @($files).Count -eq 0) { return }
    foreach ($file in $files) {
        $path = $file.RelativePath -replace '\\', '/'
        Run-Step "git" @("lfs", "track", "--", $path)
        Write-Ok "Dodano do Git LFS: $path"
    }
    if (-not $script:IsDryRun -and (Test-Path ".gitattributes")) {
        Run-Step "git" @("add", ".gitattributes")
        Write-Ok "Dodano .gitattributes do stage"
    }
}

function Ignore-Files($files) {
    if (-not $files -or @($files).Count -eq 0) { return }
    $lines = @($files | ForEach-Object { $_.RelativePath -replace '\\', '/' })
    Add-Lines-ToGitIgnore -lines $lines
    Write-Ok "Dodano pliki do .gitignore"
}

function Resolve-Behavior50To100 {
    switch ($LargeFiles50To100MB) {
        "Git"    { return 1 }
        "LFS"    { return 2 }
        "Ignore" { return 3 }
        "Abort"  { return 4 }
    }
    return 1
}

function Resolve-BehaviorOver100 {
    switch ($LargeFilesOver100MB) {
        "LFS"    { return 1 }
        "Ignore" { return 2 }
        "Abort"  { return 3 }
    }
    return 3
}

# =============================================================================
# MAIN
# =============================================================================
try {
    if (-not (Test-Path $script:ResolvedLogFile)) {
        New-Item -ItemType File -Path $script:ResolvedLogFile -Force | Out-Null
    }

    Write-Host ""
    Write-Host "=== Publikacja bieżącego folderu jako nowego repo na GitHubie ===" -ForegroundColor White
    if ($script:IsDryRun) {
        Write-Host "    *** TRYB PODGLĄDU — żadne zmiany nie zostaną wprowadzone ***" -ForegroundColor DarkYellow
    }
    Write-Host ""
    Write-LogLine "INFO" "Start skryptu$(if ($script:IsDryRun) { ' [DRY-RUN]' })"

    # 1. Wymagania
    if (-not (Test-CommandExists "git")) { throw "Nie znaleziono 'git'. Zainstaluj Git for Windows." }
    if (-not (Test-CommandExists "gh"))  { throw "Nie znaleziono 'gh'. Zainstaluj GitHub CLI." }

    $ghLogin = Get-GitHubUserLogin
    if (-not $ghLogin) { throw "GitHub CLI nie jest zalogowany. Uruchom: gh auth login" }

    Write-Ok "Wykryto: git"
    Write-Ok "Wykryto: gh"
    Write-Ok "Zalogowano jako: $ghLogin"

    $repoOwner = Get-Owner -ghLogin $ghLogin
    if ($repoOwner -ne $ghLogin) { Write-Info "Repo w organizacji: $repoOwner" }

    # 2. Nazwa repo
    $currentPath = (Get-Location).Path
    $folderName  = Split-Path -Leaf $currentPath

    $finalRepoName = if (-not [string]::IsNullOrWhiteSpace($RepoName)) {
        Get-SanitizedRepoName -name $RepoName
    } else {
        Get-SanitizedRepoName -name $folderName
    }

    if ([string]::IsNullOrWhiteSpace($finalRepoName)) {
        throw "Nazwa '$folderName' nie daje prawidłowej nazwy repo. Użyj parametru -RepoName."
    }

    # Ostrzeż jeśli nazwa była sanityzowana i nie użyto -RepoName
    if ($finalRepoName -ne $folderName -and [string]::IsNullOrWhiteSpace($RepoName)) {
        Write-WarnMsg "Nazwa folderu '$folderName' zawierała znaki niedozwolone → repo: '$finalRepoName'"
        if (-not $Force -and -not (Confirm-Action "Akceptujesz nazwę '$finalRepoName'?")) {
            throw "Przerwano przez użytkownika."
        }
    }

    Write-Info "Folder : $currentPath"
    Write-Info "Repo   : $repoOwner/$finalRepoName"
    Write-Info "Log    : $script:ResolvedLogFile"

    # 3. Widoczność
    if ($Public -and $Private) { throw "Nie można jednocześnie podać -Public i -Private." }
    $visibility = $null
    if ($Public)      { $visibility = "public" }
    elseif ($Private) { $visibility = "private" }
    else {
        if ($NonInteractive) {
            $visibility = "private"
            Write-Info "Tryb nieinteraktywny: widoczność = private"
        } else {
            do {
                $visibility = (Read-Host "public czy private? [public/private]").Trim().ToLower()
            } while ($visibility -notin @("public", "private"))
        }
    }
    Write-Info "Widoczność: $visibility"

    # 4. .gitignore
    if (-not $NoGitIgnore) {
        if (-not (Test-Path ".gitignore")) {
            Write-WarnMsg "Brak pliku .gitignore."
            if ($Force -or (Confirm-Action "Utworzyć domyślny .gitignore?")) {
                New-DefaultGitIgnore
                if (-not $script:IsDryRun) { Write-Ok "Utworzono .gitignore" }
            }
        } else {
            Write-Ok ".gitignore już istnieje"
        }
    }

    # BUGFIX: pilnuj, żeby plik logu nie trafił do repo
    Ensure-LogFileIgnored

    # 5. README.md (opcjonalne)
    if ($GenerateReadme) {
        New-DefaultReadme -repoName $finalRepoName -description $Description
    }

    # 6. Ciężkie katalogi
    $heavyDirs = Get-HeavyDirectories
    Show-HeavyDirectories -dirs $heavyDirs

    if ($heavyDirs -and @($heavyDirs).Count -gt 0) {
        $hChoice = Ask-Choice "Co zrobić z typowymi ciężkimi katalogami?" @(
            "Nic — zostawić bez zmian",
            "Dodać do .gitignore",
            "Przerwać"
        ) 2
        switch ($hChoice) {
            1 { Write-Info "Ciężkie katalogi bez zmian" }
            2 { Ignore-Directories -dirs $heavyDirs }
            3 { throw "Przerwano przez użytkownika." }
        }
    }

    # 7. git init — BUGFIX: przeniesiony PRZED analizę (git ls-files wymaga init)
    $isGitRepo = Test-GitRepo
    if (-not $isGitRepo) {
        Run-Step "git" @("init")
        if (-not $script:IsDryRun) { Write-Ok "Zainicjalizowano repo Git" }
    } else {
        Write-Ok "Folder jest już repozytorium Git"
    }

    # 8. git user.name / user.email
    $gitUserName  = git config user.name  2>$null
    $gitUserEmail = git config user.email 2>$null

    if ([string]::IsNullOrWhiteSpace($gitUserName)) {
        $gn = git config --global user.name 2>$null
        if ([string]::IsNullOrWhiteSpace($gn)) {
            Write-WarnMsg "Brak git user.name"
            if ($NonInteractive) { throw "Brak git user.name. Ustaw: git config --global user.name `"Imię`"" }
            $newName = Read-Host "Podaj git user.name"
            if ([string]::IsNullOrWhiteSpace($newName)) { throw "Brak user.name. Przerywam." }
            Run-Step "git" @("config", "user.name", $newName)
            Write-Ok "Ustawiono git user.name"
        }
    }

    if ([string]::IsNullOrWhiteSpace($gitUserEmail)) {
        $ge = git config --global user.email 2>$null
        if ([string]::IsNullOrWhiteSpace($ge)) {
            Write-WarnMsg "Brak git user.email"
            if ($NonInteractive) { throw "Brak git user.email. Ustaw: git config --global user.email `"email@example.com`"" }
            $newEmail = Read-Host "Podaj git user.email"
            if ([string]::IsNullOrWhiteSpace($newEmail)) { throw "Brak user.email. Przerywam." }
            Run-Step "git" @("config", "user.email", $newEmail)
            Write-Ok "Ustawiono git user.email"
        }
    }

    # 9. Analiza plików (po git init — żeby Get-GitIgnoredPaths działało)
    if (-not $NoLargeFileCheck) {
        $analysis = Analyze-ProjectFiles
        Show-AnalysisSummary -analysis $analysis

        # BUGFIX: sprawdź efektywny rozmiar (bez ignorowanych plików)
        if ($analysis.EffectiveTotalSize -gt 1GB) {
            Write-WarnMsg "Łączny rozmiar plików do wysłania > 1 GB: $(Format-Bytes $analysis.EffectiveTotalSize)"
            if (-not $Force -and -not (Confirm-Action "Kontynuować mimo to?")) {
                throw "Przerwano przez użytkownika."
            }
        }

        if ($analysis.FilesOver100MB.Count -gt 0) {
            Write-WarnMsg "Wykryto $($analysis.FilesOver100MB.Count) plik(i) > 100 MB."
            $c1 = Ask-Choice "Co zrobić z plikami > 100 MB?" @(
                "Użyć Git LFS",
                "Dodać do .gitignore",
                "Przerwać"
            ) (Resolve-BehaviorOver100)
            switch ($c1) {
                1 { Ensure-GitLfsInstalledIfChosen; Track-Files-WithGitLfs -files $analysis.FilesOver100MB }
                2 { Ignore-Files -files $analysis.FilesOver100MB }
                3 { throw "Przerwano przez użytkownika." }
            }
        }

        $warn50 = @($analysis.FilesOver50MB | Where-Object { $_.Length -le 100MB })
        if ($warn50.Count -gt 0) {
            Write-WarnMsg "Wykryto $($warn50.Count) plik(i) z przedziału 50-100 MB."
            $c2 = Ask-Choice "Co zrobić z plikami 50-100 MB?" @(
                "Zostawić normalnie w Git",
                "Użyć Git LFS",
                "Dodać do .gitignore",
                "Przerwać"
            ) (Resolve-Behavior50To100)
            switch ($c2) {
                1 { Write-Info "Pliki 50-100 MB pozostają w zwykłym Git" }
                2 { Ensure-GitLfsInstalledIfChosen; Track-Files-WithGitLfs -files $warn50 }
                3 { Ignore-Files -files $warn50 }
                4 { throw "Przerwano przez użytkownika." }
            }
        }
    } else {
        Write-Info "Analiza dużych plików pominięta (-NoLargeFileCheck)"
    }

    # 10. Sprawdź istniejący remote
    $remoteExists = Test-GitRemoteOrigin
    if ($remoteExists) {
        $originUrl = git remote get-url origin
        Write-WarnMsg "Remote 'origin' już istnieje: $originUrl"
        if (-not $Force -and -not (Confirm-Action "Kontynuować mimo istniejącego origin?")) {
            throw "Przerwano przez użytkownika."
        }
    }

    # 11. Sprawdź czy repo istnieje na GitHubie
    $repoExistsOnGitHub = Test-GitHubRepoExists -owner $repoOwner -repo $finalRepoName
    if ($repoExistsOnGitHub) {
        Write-WarnMsg "Repo $repoOwner/$finalRepoName już istnieje na GitHubie."
        if (-not $Force) {
            throw "Repo już istnieje. Zmień nazwę, użyj -RepoName albo usuń repo na GitHubie."
        }
    }

    # 12. git add
    if (-not $script:IsDryRun) {
        if (Test-UntrackedOrModifiedFiles) {
            Run-Step "git" @("add", ".")
            Write-Ok "Pliki dodane do stage"
        } else {
            Write-Info "Brak zmian do dodania"
        }
    } else {
        Write-DryRun "Pominięto: git add ."
    }

    # 13. git commit
    $hasAnyCommit     = Test-AnyCommitExists
    $hasStagedChanges = Test-StagedChanges

    if (-not $hasAnyCommit -or $hasStagedChanges) {
        Run-Step "git" @("commit", "-m", $CommitMessage)
        if (-not $script:IsDryRun) { Write-Ok "Commit: $CommitMessage" }
    } else {
        Write-Info "Brak zmian do commitowania"
    }

    # 14. Branch main
    Run-Step "git" @("branch", "-M", "main")
    if (-not $script:IsDryRun) { Write-Ok "Branch: main" }

    # 15. Utwórz repo na GitHubie i wypchnij
    # BUGFIX: rozróżniamy cztery przypadki zamiast dwóch, żeby nie sypać się
    # gdy origin już istnieje lokalnie a repo jeszcze nie ma na GH
    $repoFullName = if ($repoOwner -ne $ghLogin) { "$repoOwner/$finalRepoName" } else { $finalRepoName }

    if (-not $repoExistsOnGitHub) {
        # Bazowe argumenty gh repo create
        $ghArgs = @("repo", "create", $repoFullName, "--$visibility")
        if (-not [string]::IsNullOrWhiteSpace($Description)) {
            $ghArgs += @("--description", $Description)
        }

        if ($remoteExists) {
            # BUGFIX: origin już istnieje lokalnie → gh nie może dodać --remote=origin ponownie
            # Tworzymy samo repo na GH, potem aktualizujemy URL istniejącego origin
            Run-Step "gh" $ghArgs
            if (-not $script:IsDryRun) { Write-Ok "Repo utworzone na GitHubie" }

            $newUrl = "https://github.com/$repoOwner/$finalRepoName.git"
            Run-Step "git" @("remote", "set-url", "origin", $newUrl)
            if (-not $script:IsDryRun) { Write-Ok "Remote origin zaktualizowany: $newUrl" }

            Run-Step "git" @("push", "-u", "origin", "main")
            if (-not $script:IsDryRun) { Write-Ok "Push zakończony" }
        } else {
            # Normalny przypadek — brak lokalnego origin
            $ghArgs += @("--source=.", "--remote=origin", "--push")
            Run-Step "gh" $ghArgs
            if (-not $script:IsDryRun) { Write-Ok "Repo GitHub utworzone i wypchnięte" }
        }
    } else {
        # Repo już istnieje na GitHubie (tylko z -Force)
        if (-not $remoteExists) {
            $repoUrl = "https://github.com/$repoOwner/$finalRepoName.git"
            Run-Step "git" @("remote", "add", "origin", $repoUrl)
            if (-not $script:IsDryRun) { Write-Ok "Dodano remote origin: $repoUrl" }
        }
        Run-Step "git" @("push", "-u", "origin", "main")
        if (-not $script:IsDryRun) { Write-Ok "Wypchnięto do istniejącego repo" }
    }

    Write-Host ""
    if ($script:IsDryRun) {
        Write-Host "*** DRY-RUN zakończony — żadne zmiany nie zostały wprowadzone ***" -ForegroundColor DarkYellow
        Write-Host "    Podgląd repo: https://github.com/$repoOwner/$finalRepoName" -ForegroundColor DarkGray
    } else {
        Write-Ok "Gotowe!"
        Write-Host "  https://github.com/$repoOwner/$finalRepoName" -ForegroundColor Green
    }
    Write-Host ""
    Write-LogLine "OK" "Sukces$(if ($script:IsDryRun) { ' [DRY-RUN]' })"
}
catch {
    Write-Host ""
    Write-ErrMsg $_.Exception.Message
    Write-Host ""
    Write-LogLine "ERR" $_.Exception.Message
    exit 1
}
