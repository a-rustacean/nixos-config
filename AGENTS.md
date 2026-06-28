# NixOS Config — Agent Guide

## Entrypoint
`flake.nix` — uses `flake-parts` + `import-tree` (recursively imports `modules/`). Library files under `lib/` are loaded by `modules/lib-load.nix`.

## Key commands
- Build: `nix build .#<name>` (packages are per-feature, see `modules/features/`)
- Apply: `sudo nixos-rebuild switch --flake .#work`
- Format: `nix fmt` (uses `nixfmt-tree`)
- Update flake: `nix flake update`

## Architecture (Dendritic pattern)
This repo follows the **dendritic pattern** — every `.nix` file under `modules/` is a flake-parts module, auto-imported by `import-tree`. No manual import wiring; just create a file and it's loaded.
- **`modules/features/`** — feature modules. Each defines:
  - a `flake.nixosModules.<name>` NixOS module (optional, for system integration)
  - a `perSystem.packages.<name>` wrapped package via `self.lib.wrappers.<name>`
- **`lib/wrappers/`** — pure Nix functions returning `{ wrap = ... }`. Auto-discovered by `modules/lib-load.nix` via `readDir`; becomes `self.lib.wrappers.<name>`. Consumed by feature files.
- **`lib/generators.nix`** — config serializers: `toHyprconf`, `toKDL`, `toSCFG`, `toOMP`, `toGituiTheme`. Exposed as `self.lib.generators`.
- **`lib/catppuccin.nix`** — Catppuccin Mocha palette. Exposed as `self.lib.colors.catppuccin`.
- **`lib/mkHyprWrapper.nix`** — utility function (not a module) for creating Hyprland-ecosystem wrappers. Imported by the 4 hypr wrapper files.
- **`lib/platformGuard.nix`** — utility wrapping the Linux-only platform guard pattern (`if isLinux then body else runCommand`). Auto-imported by `lib-load.nix` and exposed as `self.lib.platformGuard` + injected arg to wrappers.
- **`lib/configs/`** — static config files: `hyprland/`, `quickshell/`, `wallpaper.jpg`.
- **`modules/hosts/nixos/`** — single host `work` (hardware config `hardware.nix` is gitignored).
- **`modules/lib-load.nix`** — aggregator that imports all `lib/` files and populates `self.lib`.
- **`modules/hosts/nixos/vm.nix`** — 9p shared folder for VM testing.

## Conventions
- **Catppuccin Mocha** theme everywhere. Color values from `lib/catppuccin.nix` via `self.lib.colors.catppuccin.mocha`.
- **JetBrainsMono Nerd Font** is the primary font.
- **Hyprland config** is Lua (`lib/configs/hyprland/hyprland.lua`). Uses `hl` global API. LuaLS typed via `lib/configs/hyprland/.luarc.json`.
- **Wrapper pattern**: feature files call `self.lib.wrappers.<name>.wrap { ... }`. Wrappers receive `wrapPackage`, `mkHyprWrapper`, `platformGuard`, `self`, `inputs`, `lib` as injected arguments from `lib-load.nix`. `wrapPackage` and `platformGuard` are also exposed as `self.lib.wrapPackage` and `self.lib.platformGuard`.
- **Platform guard**: Linux-only programs use `platformGuard { inherit pkgs name; body = wrapPackage (...); }` instead of duplicating the `if isLinux then ... else runCommand` pattern.
- **Parameter naming**: The main configuration parameter in `wrap` functions is named `settings`, not `config`, to avoid shadowing the module system keyword.
- **Hyprland wrappers**: For Hyprland ecosystem programs with `--config`, use `mkHyprWrapper` from `lib/mkHyprWrapper.nix`, which now accepts an optional `package` override.
- Package env vars (`HYPRLAND_PROGRAM_*`) are set in `modules/features/hyprland.nix` for autostart programs.
- `nixpkgs` follows `nixos-unstable`.

## Hard rules
- **No symlinks into user home** — never use `home-manager`, `stow`, `XDG_CONFIG_HOME` symlinks, or any approach that puts dotfiles/conf in `~`. Everything is a Nix store path.
- **Config lives in the store** — every program must read its config from the Nix store, injected via `--config` flag, `-c` argument, env vars (`XDG_CONFIG_HOME`, `HOME`), or wrapped with a hardcoded path. No runtime symlink tricks.
- **No home-manager or home-manager-style modules** — this repo is NixOS-only. User-level config is handled by wrapped packages, not by home-manager profiles.
- **Wrapper pattern is mandatory when config is needed** — use `self.lib.wrappers.<name>.wrap { ... }` from `nix-wrapper-modules` or `mkHyprWrapper`. Raw `pkgs.writeText` + env injection is acceptable. For packages that need no configuration, `environment.systemPackages = [ pkgs.<foo> ]` without wrapping is fine.
- **Isolation from existing installs** — a wrapped program must never corrupt an existing installation of the same program. Both must coexist: the wrapped version uses its own config (from the store), while sharing mutable user data (e.g. command history, cache) is fine. `nix run .#<program>` must be safe to run regardless of whether the program is also installed globally, via home-manager, or outside Nix entirely.

## Adding a new program

1. **Find config injection method** — search docs/flags for how the program accepts a custom config path (`--config`, `-c`, `XDG_CONFIG_HOME`, `HOME`, env vars, etc.).
2. **Write wrapper** — create `lib/wrappers/<name>.nix` returning `{ wrap = { pkgs, settings, ... }: ... }`. Destructure injected args as needed: `{ wrapPackage, platformGuard, ... }`. Use `lib/generators.nix` serializers when applicable. For Linux-only programs, wrap the body with `platformGuard { inherit pkgs name; body = ...; }`. For Hyprland tools with `--config`, use `mkHyprWrapper` from `lib/mkHyprWrapper.nix`.
3. **Add feature module** — create `modules/features/<name>.nix` that calls `self.lib.wrappers.<name>.wrap` with settings.
4. **Add generator (if needed)** — extend `lib/generators.nix` with a new `to<Format>` serializer for bespoke config formats not yet supported.

## Gotchas
- `result/` is gitignored (build output symlink).
- Adding a new wrapper? Create `lib/wrappers/<name>.nix` — it's auto-discovered by `modules/lib-load.nix` via `readDir`. No other wiring needed.
- Adding a new feature? Create both `modules/features/<name>.nix` and `lib/wrappers/<name>.nix`.
- The `~/.config/opencode/` dir under the repo root is an artifact (not a real instruction source).
- `nixosConfigurations.work` is hardcoded in `modules/hosts/nixos/default.nix`.
- `lib/mkHyprWrapper.nix` is NOT a module — it's a pure function imported by wrapper files. Don't add it to `lib-load.nix`.
- `lib/platformGuard.nix` is NOT a module — it's a pure utility imported by `lib-load.nix` and passed to wrappers. Must be git-added before building.
- `wrapPackage` and `platformGuard` are available both as injected args to wrappers and via `self.lib.wrapPackage`/`self.lib.platformGuard`.
- When creating a new pure Nix function file under `lib/`, it must be explicitly imported in `modules/lib-load.nix` to be exposed via `self.lib`.
