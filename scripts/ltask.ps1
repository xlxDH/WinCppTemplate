# Unified project task entry:
#   powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode build
#   powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode run
#   powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode launch
#   powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode lsp

param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("build", "run", "launch", "lsp")]
  [string]$Mode
)

$ErrorActionPreference = "Stop"

switch ($Mode) {
  "build"  { & "$PSScriptRoot\lcompile.ps1" }
  "run"    { & "$PSScriptRoot\lrun.ps1" }
  "launch" { & "$PSScriptRoot\llaunch.ps1" }
  "lsp"    { & "$PSScriptRoot\lsp-ccdb.ps1" }
}
