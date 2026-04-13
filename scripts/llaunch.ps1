#
# Generate, compile and run executable files with MinGW.
#
function Get-ExePathFromCMakeLists() {
  $content = Get-Content -Raw -Path "./CMakeLists.txt"
  foreach ($line in $content -split "`n") {
    if ($line -match 'set\(MY_EXECUTABLE_NAME[^\"]*\"([^\"]+)\"') {
      $exeName = $matches[1]
      return "./build/$exeName.exe"
    }
  }
  return ""
}

$ErrorActionPreference = "Stop"

$currentDirectory = Get-Location
$cmakeListsPath = Join-Path -Path $currentDirectory -ChildPath "CMakeLists.txt"
if (-not (Test-Path $cmakeListsPath)) {
  Write-Host "No CMakeLists.txt in current directory, please check."
  exit 1
}

$gxx = Get-Command g++ -ErrorAction SilentlyContinue
if (-not $gxx) {
  Write-Host "Cannot find g++ in PATH. Please install MinGW-w64 and add it to PATH."
  exit 1
}

Write-Host "Using compiler: $($gxx.Source)"
Write-Host "Start generating and compiling with MinGW..."

$buildFolderPath = ".\build"
if (-not (Test-Path $buildFolderPath)) {
  New-Item -ItemType Directory -Path $buildFolderPath | Out-Null
  Write-Host "build folder created."
}

cmake -S . -B ./build `
  -G "MinGW Makefiles" `
  -DCMAKE_CXX_COMPILER="$($gxx.Source)" `
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

if ($LASTEXITCODE -ne 0) {
  Write-Host "CMake configure failed."
  exit $LASTEXITCODE
}

cmake --build ./build
if ($LASTEXITCODE -ne 0) {
  Write-Host "Build failed."
  exit $LASTEXITCODE
}

if (Test-Path "./build/compile_commands.json") {
  Copy-Item -Force "./build/compile_commands.json" "./compile_commands.json"
}

$exePath = Get-ExePathFromCMakeLists
if (-not $exePath -or -not (Test-Path $exePath)) {
  Write-Host "Executable not found. Please ensure MY_EXECUTABLE_NAME is set in CMakeLists.txt."
  exit 1
}

Write-Host "Start running: $exePath"
& $exePath
