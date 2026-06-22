{ self, inputs, lib, ... }:
let
  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;
  system = pkgs: pkgs.stdenv.hostPlatform.system;

  mkHyprWrapper = name: {
    wrap =
      { pkgs, settings, runtimePkgs ? [ ], extraFlags ? { }, extraConfig ? "", importantPrefixes ? [ "$" ] }:
      wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = inputs.${name}.packages.${system pkgs}.${name};
          inherit runtimePkgs;
          flags = {
            "--config" = pkgs.writeText "${name}.conf" (
              (self.lib.generators.toHyprconf {
                attrs = settings;
                inherit importantPrefixes;
              }) + extraConfig
            );
          } // extraFlags;
        }
      );
  };
in
{
  flake.lib.wrappers = {
    inherit wrapPackage;

    helix = {
      wrap =
        { pkgs, settings, themes, languages, runtimePkgs ? [ ] }:
        inputs.wrapper-modules.wrappers.helix.wrap {
          inherit pkgs;
          package = inputs.helix.packages.${system pkgs}.helix;
          inherit runtimePkgs settings themes languages;
        };
    };

    zsh = {
      wrap =
        { pkgs, zshrc, runtimePkgs ? [ ] }:
        inputs.wrapper-modules.wrappers.zsh.wrap {
          inherit pkgs;
          package = pkgs.zsh;
          inherit runtimePkgs;
          zshrc.content = zshrc;
        };
    };

    git = {
      wrap =
        { pkgs, settings, runtimePkgs ? [ ] }:
        inputs.wrapper-modules.wrappers.git.wrap {
          inherit pkgs;
          package = pkgs.git;
          inherit runtimePkgs settings;
        };
    };

    quickshell = {
      wrap =
        { pkgs, runtimePkgs ? [ ], configDir, env ? { }, extraFlags ? { } }:
        wrapPackage ({ ... }: {
          inherit pkgs;
          package = pkgs.quickshell;
          inherit runtimePkgs;
          flags = { "--path" = configDir; } // extraFlags;
          inherit env;
        });
    };

    hypridle = mkHyprWrapper "hypridle";
    hyprpaper = mkHyprWrapper "hyprpaper";
    hyprlock = mkHyprWrapper "hyprlock";
    hyprsunset = mkHyprWrapper "hyprsunset";

    ghostty = {
      wrap =
        { pkgs, runtimePkgs ? [ ], config, theme ? null, fontPackage ? null }:
        wrapPackage (
          { ... }:
          {
            inherit pkgs;
            package = inputs.ghostty.packages.${system pkgs}.ghostty;
            inherit runtimePkgs;
            env = {
              XDG_CONFIG_HOME = pkgs.symlinkJoin {
                name = "ghostty-config";
                paths =
                  [
                    (pkgs.writeTextDir "ghostty/config" config)
                  ]
                  ++ lib.optional (theme != null) (pkgs.writeTextDir "ghostty/themes/nix-theme" theme);
              };
            } // lib.optionalAttrs (fontPackage != null) {
              XDG_DATA_DIRS = "${fontPackage}/share";
            };
          }
        );
    };

    hyprland = {
      wrap =
        { pkgs, runtimePkgs ? [ ], flags ? { }, env ? { } }:
        lib.extendDerivation true
          inputs.hyprland.packages.${system pkgs}.hyprland.passthru
          (
            wrapPackage (
              { ... }:
              {
                inherit pkgs;
                package = inputs.hyprland.packages.${system pkgs}.hyprland;
                inherit runtimePkgs flags env;
              }
            )
          );
    };
  };
}
