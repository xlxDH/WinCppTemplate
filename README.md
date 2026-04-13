# About

This is a template for c++ in Windows.

I use the toolchains below (default):

- CMake
- MinGW-w64 (g++)
- pwsh7
- Neovim
- clangd

Of course, you can replace Neovim with VSCode.

Have fun writing C++ in Windows.

## Scripts

This template provides four task scripts:

- `scripts/lcompile.ps1`: build only
- `scripts/lrun.ps1`: run existing exe only
- `scripts/llaunch.ps1`: build then run
- `scripts/lsp-ccdb.ps1`: generate/update `compile_commands.json` for clangd
- `scripts/ltask.ps1`: unified task entry (`build` / `run` / `launch` / `lsp`)

Examples:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode build
powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode run
powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode launch
powershell -ExecutionPolicy Bypass -File .\scripts\ltask.ps1 -Mode lsp
```

## Neovim 快捷使用

在项目根目录打开 Neovim 后，可直接使用：

- `<leader>pt`: 打开任务选择器
- `:ProjectTask <mode>`: 直接执行任务
- `:Pt`: 快捷命令（默认 `lsp`）
- `:Pt build`: 编译
- `:Pt run`: 新开 PowerShell 终端运行 exe
- `:Pt launch`: 编译并运行
- `:Pt lsp`: 更新 `compile_commands.json` 并自动 `:LspRestart`

说明：

- `:Pt run` 不会自动编译；若提示找不到 exe，请先执行 `:Pt build`
- 若 C++ 补全异常，优先执行 `:Pt lsp`
