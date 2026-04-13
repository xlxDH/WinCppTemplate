# Generate compile_commands.json for clangd completion.
# Usage (in project root): powershell -ExecutionPolicy Bypass -File .\scripts\lsp-ccdb.ps1

$ErrorActionPreference = "Stop"

$projectRoot = Get-Location
$cmakeLists = Join-Path $projectRoot "CMakeLists.txt"
if (-not (Test-Path $cmakeLists)) {
  Write-Host "No CMakeLists.txt in current directory."
  exit 1
}

$buildDir = Join-Path $projectRoot "build"
if (-not (Test-Path $buildDir)) {
  New-Item -ItemType Directory -Path $buildDir | Out-Null
}

$gxx = (Get-Command g++ -ErrorAction SilentlyContinue)
if (-not $gxx) {
  Write-Host "Cannot find g++ in PATH. Please install MinGW-w64 and add it to PATH."
  exit 1
}

Write-Host "Using C++ compiler: $($gxx.Source)"
Write-Host "Configuring CMake (MinGW Makefiles + compile_commands)..."

cmake -S . -B ./build `
  -G "MinGW Makefiles" `
  -DCMAKE_CXX_COMPILER="$($gxx.Source)" `
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

if ($LASTEXITCODE -ne 0) {
  Write-Host "CMake configure failed."
  exit $LASTEXITCODE
}

$ccdbInBuild = Join-Path $buildDir "compile_commands.json"
$ccdbInRoot = Join-Path $projectRoot "compile_commands.json"
if (-not (Test-Path $ccdbInBuild)) {
  Write-Host "compile_commands.json was not generated."
  exit 1
}

Copy-Item -Force $ccdbInBuild $ccdbInRoot
Write-Host "Done: $ccdbInRoot"
Write-Host "Now run :LspRestart in Neovim."
