# NixOS Config — Agent Guide

## Entrypoint
`flake.nix` — uses `flake-parts` + `import-tree` (recursively imports `modules/`).

## Key commands
- Build: `nix build .#<name>` (packages are per-feature, see `modules/features/`)
- Apply: `sudo nixos-rebuild switch --flake .#work`
- Format: `nix fmt` (uses `nixfmt-tree`)
- Update flake: `nix flake update`

## Architecture (Dendritic pattern)
This repo follows the **dendritic pattern** — every `.nix` file under `modules/` is a flake-parts module, auto-imported by `import-tree`. No manual import wiring; just create a file and it's loaded.
- **`modules/features/`** — 20 feature modules. Each defines:
  - a `flake.nixosModules.<name>` NixOS module (optional, for system integration)
  - a `perSystem.packages.<name>` wrapped package via `self.lib.wrappers.<name>`
- **`lib/wrappers/`** — wrapper definitions auto-discovered by `modules/wrappers/default.nix`; becomes `self.lib.wrappers.<name>`. Consumed by feature files.
- **`modules/hosts/nixos/`** — single host `work` (hardware config `hardware.nix` is gitignored).
- **`modules/generators.nix`** — config serializers: `toHyprconf`, `toKDL`, `toSCFG`, `toOMP`, `toGituiTheme`, plus `catppuccin` color palette.
- **`modules/hosts/nixos/vm.nix`** — 9p shared folder for VM testing.
- User: `dilshad` (password same as username), timezone `Asia/Kolkata`.

## Conventions
- **Catppuccin Mocha** theme everywhere. Color values from `modules/generators.nix` catppuccin set.
- **JetBrainsMono Nerd Font** is the primary font.
- **Hyprland config** is Lua (`hyprland/hyprland.lua`). Uses `hl` global API. LuaLS typed via `hyprland/.luarc.json`.
- **Wrapper pattern**: feature files call `self.lib.wrappers.<name>.wrap { inherit pkgs; settings = { ... }; }`. Most wrappers use `nix-wrapper-modules` (`github:BirdeeHub/nix-wrapper-modules`).
- Package env vars (`HYPRLAND_PROGRAM_*`) are set in `modules/features/hyprland.nix` for autostart programs.
- `nixpkgs` follows `nixos-unstable`.

## Hard rules
- **No symlinks into user home** — never use `home-manager`, `stow`, `XDG_CONFIG_HOME` symlinks, or any approach that puts dotfiles/conf in `~`. Everything is a Nix store path.
- **Config lives in the store** — every program must read its config from the Nix store, injected via `--config` flag, `-c` argument, env vars (`XDG_CONFIG_HOME`, `HOME`), or wrapped with a hardcoded path. No runtime symlink tricks.
- **No home-manager or home-manager-style modules** — this repo is NixOS-only. User-level config is handled by wrapped packages, not by home-manager profiles.
- **Wrapper pattern is mandatory** — use `self.lib.wrappers.<name>.wrap { ... }` from `nix-wrapper-modules` or `mkHyprWrapper`. Raw `pkgs.writeText` + env injection is acceptable. Direct `environment.systemPackages = [ pkgs.<foo> ]` without wrapping is not.
- **Isolation from existing installs** — a wrapped program must never corrupt an existing installation of the same program. Both must coexist: the wrapped version uses its own config (from the store), while sharing mutable user data (e.g. command history, cache) is fine. `nix run .#<program>` must be safe to run regardless of whether the program is also installed globally, via home-manager, or outside Nix entirely.

## Adding a new program

1. **Find config injection method** — search docs/flags for how the program accepts a custom config path (`--config`, `-c`, `XDG_CONFIG_HOME`, `HOME`, env vars, etc.).
2. **Write wrapper** — create `lib/wrappers/<name>.nix` using `self.lib.wrappers.<name>.wrap { ... }` from `nix-wrapper-modules` or `mkHyprWrapper`, converting the nix attrset/expression into the program's config format (JSON, TOML, Lua, etc.). Use `modules/generators.nix` serializers when applicable.
3. **Add feature module** — create `modules/features/<name>.nix` that calls the wrapper with settings.
4. **Add generator (if needed)** — extend `modules/generators.nix` with a new `to<Format>` serializer for bespoke config formats not yet supported.

## Gotchas
- `result/` is gitignored (build output symlink).
- Adding a new feature? Create both `modules/features/<name>.nix` and `lib/wrappers/<name>.nix` (the latter is auto-imported).
- The `~/.config/opencode/` dir under the repo root is an artifact (not a real instruction source).
- `nixosConfigurations.work` is hardcoded in `modules/hosts/nixos/default.nix`.
