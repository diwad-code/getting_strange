param([string]$Package)
if (!$Package) { throw 'Package name required' }
New-Item -ItemType Directory -Force -Path "snapshots/$Package-$(Get-Date -Format 'yyyy-MM-dd')"
Copy-Item -Recurse -Force -Path scenes, scripts, tests "snapshots/$Package-$(Get-Date -Format 'yyyy-MM-dd')"

