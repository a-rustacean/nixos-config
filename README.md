# Homeless nixos config

A [dendritic](https://discourse.nixos.org/t/the-dendritic-pattern/61271) NixOS flake - no home-manager, no dotfiles, no symlinks into `~`. Programs that need configuration get it baked into store-path-bound wrappers instead. See [Wrappers vs. Dotfiles](https://nixos.wiki/wiki/Wrappers_vs._Dotfiles).

## Architecture

Every `.nix` under `modules/` is a flake-parts module, auto-imported by `import-tree` - no manual wiring.

- `modules/parts.nix` - flake-parts `systems` list (hardcoded)
- `modules/features/` - one directory per feature, each defines a NixOS module (self-installs its wrapped package into `systemPackages`) + wrapped package
- `modules/system/` - system-level modules by category: `core/`, `audio/`, `network/`, `nix-ld/`, `systemTheme/`, `desktop/`
- `modules/attrs/` - aggregator NixOS modules grouping related features
- `modules/hosts/nixos/` - single host `nixos` (`default.nix` -> `nixosConfigurations.nixos`, `nixosConfiguration.nix` = host-specific bits)
- `lib/wrappers/` - wrapper definitions (pure Nix functions, auto-discovered)
- `lib/generators.nix` - config serializers (`toHyprconf`, `toKDL`, `toSCFG`, `toOMP`, `toGituiTheme`, `toUserJs`, `toGhostty`)
- `lib/catppuccin.nix` - Catppuccin Mocha color palette
- `modules/lib-load.nix` - aggregates all `lib/` files into `self.lib.*`

## Hard rules

- **No dotfiles** - config lives in the Nix store, injected via `--config`, `-c`, env vars, or hardcoded paths in wrappers. No `XDG_CONFIG_HOME` symlinks, no stow, no home-manager.
- **Wrappers when config is needed** - packages that require user configuration must be wrapped. Packages that need no config (`pkgs.foo` directly in `environment.systemPackages`) are fine as-is.
- **Isolation** - `nix run .#<program>` must coexist with any global/home-manager/vanilla install of the same program. Shared mutable data (history, cache) is fine; config segregation is mandatory.

## Details

- **Theme**: Catppuccin Mocha
- **Font**: JetBrainsMono Nerd Font
- **WM**: Hyprland
- **Display manager**: SDDM (Catppuccin, autologin; session spawns detached from the TTY so Ctrl+C can't kill it)
- **Editor**: Helix (Catppuccin, LSP/client config)
- **Terminal**: Ghostty (Catppuccin, JetBrainsMono, shell integration)
- **Shell**: Zsh (syntax highlighting, completions, oh-my-posh prompt)
- **Bar/Shell**: Quickshell (Hyprland widget shell)
- **Notifications**: Dunst (Catppuccin Mocha)
- **File browser**: Fzf (fuzzy finder for files/history/processes)
- **System monitor**: Btop
- **Git**: Git + Gitui (TUI client, Catppuccin)
- **Audio visualizer**: Cava

Hyprland ecosystem (all Catppuccin): `hyprland`, `hyprpaper`, `hyprlock`, `hypridle`, `hyprsunset`, `hyprlauncher`, `hyprpicker`, `xdg-desktop-portal-hyprland`.
