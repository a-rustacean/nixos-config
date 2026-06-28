# Homeless nixos config

A [dendritic](https://discourse.nixos.org/t/the-dendritic-pattern/61271) NixOS flake - no home-manager, no dotfiles, no symlinks into `~`. Programs that need configuration get it baked into store-path-bound wrappers instead. See [Wrappers vs. Dotfiles](https://nixos.wiki/wiki/Wrappers_vs._Dotfiles).

## Architecture

Every `.nix` under `modules/` is a flake-parts module, auto-imported by `import-tree` - no manual wiring.

- `modules/features/` - feature modules, each defines a NixOS module + wrapped package
- `lib/wrappers/` - wrapper definitions (pure Nix functions, auto-discovered)
- `lib/generators.nix` - config serializers (`toHyprconf`, `toKDL`, `toSCFG`, `toOMP`, `toGituiTheme`, `toUserJs`, `toGhostty`)
- `lib/catppuccin.nix` - Catppuccin Mocha color palette
- `lib/mkStoreConfigWrapper.nix` - runtime config injection for programs that write to their config dir
- `modules/lib-load.nix` - aggregates all `lib/` files into `self.lib.*`
- `modules/hosts/nixos/` - single host `work`

## Hard rules

- **No dotfiles** - config lives in the Nix store, injected via `--config`, `-c`, env vars, or hardcoded paths in wrappers. No `XDG_CONFIG_HOME` symlinks, no stow, no home-manager.
- **Wrappers when config is needed** - packages that require user configuration must be wrapped. Packages that need no config (`pkgs.foo` directly in `environment.systemPackages`) are fine as-is.
- **Isolation** - `nix run .#<program>` must coexist with any global/home-manager/vanilla install of the same program. Shared mutable data (history, cache) is fine; config segregation is mandatory.

## Details

- **Theme**: Catppuccin Mocha
- **Font**: JetBrainsMono Nerd Font
- **WM**: Hyprland
- **Editor**: Helix (Catppuccin, LSP/client config)
- **Terminal**: Ghostty (Catppuccin, JetBrainsMono, shell integration)
- **Shell**: Zsh (syntax highlighting, completions, oh-my-posh prompt)
- **Browser**: Zen Browser (Catppuccin, policies, extensions)
- **Discord**: Vesktop with Vencord
- **Bar/Shell**: Quickshell (Hyprland widget shell)
- **Notifications**: Dunst (Catppuccin Mocha)
- **File browser**: Fzf (fuzzy finder for files/history/processes)
- **System monitor**: Btop
- **Git**: Git + Gitui (TUI client, Catppuccin)
- **Audio visualizer**: Cava

Hyprland ecosystem (all Catppuccin): `hyprland`, `hyprpaper`, `hyprlock`, `hypridle`, `hyprsunset`, `hyprlauncher`, `hyprpicker`, `xdg-desktop-portal-hyprland`.
