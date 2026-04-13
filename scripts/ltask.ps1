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
  "run"    {
    $runScript = Join-Path $PSScriptRoot "lrun.ps1"
    $argList = @(
      "-NoExit",
      "-ExecutionPolicy", "Bypass",
      "-File", "`"$runScript`""
    )
    Start-Process -FilePath "powershell.exe" -ArgumentList $argList | Out-Null
  }
  "launch" { & "$PSScriptRoot\llaunch.ps1" }
  "lsp"    { & "$PSScriptRoot\lsp-ccdb.ps1" }
}
