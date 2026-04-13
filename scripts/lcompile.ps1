# Generate and compile executable files with MinGW.
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

$projectPath = (Get-Location).Path
$workPath = $projectPath
$proxyRoot = Join-Path $env:TEMP "wincpp_proxy"
$proxyPath = Join-Path $proxyRoot "WinCppTemplate"
$usingProxy = $false

if ($projectPath -match "[^\x00-\x7F]") {
  New-Item -ItemType Directory -Path $proxyRoot -Force | Out-Null
  if (Test-Path $proxyPath) {
    cmd /c "rmdir `"$proxyPath`"" | Out-Null
  }
  cmd /c "mklink /J `"$proxyPath`" `"$projectPath`"" | Out-Null
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path $proxyPath)) {
    Write-Host "Failed to create ASCII proxy path for build."
    exit 1
  }
  $workPath = $proxyPath
  $usingProxy = $true
  Write-Host "Using ASCII proxy path: $workPath"
}

Push-Location $workPath
try {
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
    Write-Host "Updated compile_commands.json in project root."
  }
}
finally {
  Pop-Location
  if ($usingProxy -and (Test-Path $proxyPath)) {
    cmd /c "rmdir `"$proxyPath`"" | Out-Null
  }
}
