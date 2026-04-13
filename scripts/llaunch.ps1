# Compile first, then run (reusing existing scripts).
$ErrorActionPreference = "Stop"

& "$PSScriptRoot\lcompile.ps1"
if ($LASTEXITCODE -ne 0) {
  exit $LASTEXITCODE
}

& "$PSScriptRoot\lrun.ps1"
