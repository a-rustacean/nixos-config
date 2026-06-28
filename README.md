# Homeless nixos config

A [dendritic](https://discourse.nixos.org/t/the-dendritic-pattern/61271) NixOS flake — no home-manager, no dotfiles, no symlinks into `~`. Programs that need configuration get it baked into store-path-bound wrappers instead. See [Wrappers vs. Dotfiles](https://nixos.wiki/wiki/Wrappers_vs._Dotfiles).

## Architecture

Every `.nix` under `modules/` is a flake-parts module, auto-imported by `import-tree` — no manual wiring.

- `modules/features/` — feature modules, each defines a NixOS module + wrapped package
- `lib/wrappers/` — wrapper definitions (pure Nix functions, auto-discovered)
- `lib/generators.nix` — config serializers (`toHyprconf`, `toKDL`, `toSCFG`, `toOMP`, `toGituiTheme`, `toUserJs`, `toGhostty`)
- `lib/catppuccin.nix` — Catppuccin Mocha color palette
- `lib/mkStoreConfigWrapper.nix` — runtime config injection for programs that write to their config dir
- `modules/lib-load.nix` — aggregates all `lib/` files into `self.lib.*`
- `modules/hosts/nixos/` — single host `work`

## Hard rules

- **No dotfiles** — config lives in the Nix store, injected via `--config`, `-c`, env vars, or hardcoded paths in wrappers. No `XDG_CONFIG_HOME` symlinks, no stow, no home-manager.
- **Wrappers when config is needed** — packages that require user configuration must be wrapped. Packages that need no config (`pkgs.foo` directly in `environment.systemPackages`) are fine as-is.
- **Isolation** — `nix run .#<program>` must coexist with any global/home-manager/vanilla install of the same program. Shared mutable data (history, cache) is fine; config segregation is mandatory.

## Details

- **Theme**: Catppuccin Mocha
- **Font**: JetBrainsMono Nerd Font
- **WM**: Hyprland

## Packages

All packages are runnable via `nix run .#<name>`, or globally via `nixos-rebuild switch`.

| Package | What it is |
|---|---|
| `helix` | Editor (Helix) — Catppuccin theme, LSP/client config |
| `ghostty` | Terminal emulator — Catppuccin Mocha, JetBrainsMono, shell integration |
| `zsh` | Shell — p10k prompt, syntax highlighting, completions, keybinds |
| `fzf` | Fuzzy finder — terminal browser for files/history/processes |
| `btop` | Resource monitor — terminal system overview |
| `fastfetch` | System info — terminal neofetch replacement |
| `git` | VCS — aliases, difftastic, gh CLI integration |
| `gitui` | TUI git client — Catppuccin theme |
| `oh-my-posh` | Prompt theme engine (used by zsh shell integration) |
| `cava` | Audio visualizer — terminal spectrum analyzer |
| `dunst` | Notification daemon — Catppuccin Mocha, progress bars, history |
| `vesktop` | Discord client with Vencord — Catppuccin theme, runtime config in `~/.nix-wrapped-apps/vesktop` |
| `zen-browser` | Firefox-based browser — Catppuccin Mocha Mauve theme (userChrome), policies, extensions, runtime config in `~/.nix-wrapped-apps/zen-browser` |
| `quickshell` | Widget shell — used by Hyprland setup |
| `opencode` | AI coding assistant — custom agent config |

Hyprland ecosystem (all Catppuccin themed): `hyprland`, `hyprpaper`, `hyprlock`, `hypridle`, `hyprsunset`, `hyprlauncher`, `hyprpicker`, `xdg-desktop-portal-hyprland`.
