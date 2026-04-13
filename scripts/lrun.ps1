#
# run exe file that has already been compiled before
#
function Get-ExeNameFromCMakeLists() {
  $content = Get-Content -Raw -Path "./CMakeLists.txt"
  foreach ($line in $content -split "`n") {
    if ($line -match 'set\(MY_EXECUTABLE_NAME[^\"]*\"([^\"]+)\"') {
      return $matches[1]
    }
  }
  return ""
}

$exeName = Get-ExeNameFromCMakeLists
if (-not $exeName) {
  Write-Host "Cannot find MY_EXECUTABLE_NAME in CMakeLists.txt."
  exit 1
}

$candidates = @(
  "./build/$exeName.exe",                # MinGW Makefiles
  "./build/bin/$exeName.exe",            # MinGW with runtime output dir
  "./build/bin/Debug/$exeName.exe",      # VS-style custom output
  "./build/Debug/$exeName.exe"           # VS default output
)

$exePath = $null
foreach ($path in $candidates) {
  if (Test-Path $path) {
    $exePath = $path
    break
  }
}

if (-not $exePath) {
  Write-Host "Executable not found. Checked:"
  $candidates | ForEach-Object { Write-Host "  $_" }
  Write-Host "Please build first: :Pt build"
  exit 1
}

Write-Host "Running: $exePath"
& $exePath
