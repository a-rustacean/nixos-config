{
  self,
  inputs,
  lib,
  ...
}:
let
  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;
  system = pkgs: pkgs.stdenv.hostPlatform.system;

  mkHyprWrapper = name: {
    wrap =
      {
        pkgs,
        settings,
        runtimePkgs ? [ ],
        extraFlags ? { },
        extraConfig ? "",
        importantPrefixes ? [ "$" ],
      }:
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
              })
              + extraConfig
            );
          }
          // extraFlags;
        }
      );
  };
in
{
  flake.lib.wrappers = {
    inherit wrapPackage;

    helix = {
      wrap =
        {
          pkgs,
          settings,
          themes ? { },
          languages ? { },
          runtimePkgs ? [ ],
        }:
        inputs.wrapper-modules.wrappers.helix.wrap {
          inherit pkgs;
          package = pkgs.helix;
          inherit
            runtimePkgs
            settings
            themes
            languages
            ;
        };
    };

    zsh = {
      wrap =
        {
          pkgs,
          zshrc,
          runtimePkgs ? [ ],
        }:
        inputs.wrapper-modules.wrappers.zsh.wrap {
          inherit pkgs;
          package = pkgs.zsh;
          inherit runtimePkgs;
          zshrc.content = zshrc;
        };
    };

    oh-my-posh = {
      wrap =
        {
          pkgs,
          config,
          runtimePkgs ? [ ],
        }:
        wrapPackage (
          { ... }: {
            inherit pkgs;
            package = pkgs.oh-my-posh;
            inherit runtimePkgs;
            flags = {
              "--config" = pkgs.writeText "oh-my-posh.json" (self.lib.generators.toOMP config);
            };
          }
        );
    };

    git = {
      wrap =
        {
          pkgs,
          settings,
          runtimePkgs ? [ ],
        }:
        inputs.wrapper-modules.wrappers.git.wrap {
          inherit pkgs;
          package = pkgs.git;
          inherit runtimePkgs settings;
        };
    };

    quickshell = {
      wrap =
        {
          pkgs,
          runtimePkgs ? [ ],
          configDir,
          env ? { },
          extraFlags ? { },
        }:
        wrapPackage (
          { ... }: {
            inherit pkgs;
            package = pkgs.quickshell;
            inherit runtimePkgs;
            flags = {
              "--path" = configDir;
            }
            // extraFlags;
            inherit env;
          }
        );
    };

    hypridle = mkHyprWrapper "hypridle";
    hyprpaper = mkHyprWrapper "hyprpaper";
    hyprlock = mkHyprWrapper "hyprlock";
    hyprsunset = mkHyprWrapper "hyprsunset";

    ghostty = {
      wrap =
        {
          pkgs,
          runtimePkgs ? [ ],
          config,
          theme ? null,
          fontPackage ? null,
        }:
        wrapPackage (
          { ... }:
          {
            inherit pkgs;
            package = inputs.ghostty.packages.${system pkgs}.ghostty;
            inherit runtimePkgs;
            env = {
              XDG_CONFIG_HOME = pkgs.symlinkJoin {
                name = "ghostty-config";
                paths = [
                  (pkgs.writeTextDir "ghostty/config" config)
                ]
                ++ lib.optional (theme != null) (pkgs.writeTextDir "ghostty/themes/nix-theme" theme);
              };
            }
            // lib.optionalAttrs (fontPackage != null) {
              XDG_DATA_DIRS = "${fontPackage}/share";
            };
          }
        );
    };

    vesktop = {
      wrap =
        {
          pkgs,
          settings ? { },
          vencordSettings ? { },
          quickCss ? "",
          themes ? { },
          rgbStrip ? null,
          runtimePkgs ? [ ],
          env ? { },
        }:
        let
          configFiles = [
            (pkgs.writeTextDir "settings.json" (builtins.toJSON settings))
            (pkgs.writeTextDir "settings/settings.json" (builtins.toJSON vencordSettings))
          ]
          ++ lib.optional (quickCss != "") (pkgs.writeTextDir "settings/quickCss.css" quickCss)
          ++ lib.optional (themes != { }) (
            pkgs.runCommandLocal "vesktop-themes" { } (
              lib.concatStringsSep "\n" (
                lib.mapAttrsToList (name: path: "ln -s '${path}' \"$out/themes/${name}\"") themes
              )
            )
          )
          ++ lib.optional (rgbStrip != null) (pkgs.writeTextDir "rgbStrip.json" (builtins.toJSON rgbStrip));

          storeConfig = pkgs.symlinkJoin {
            name = "vesktop-config";
            paths = configFiles;
          };

          vesktopBin = lib.getExe pkgs.vesktop;

          runtimePath = lib.makeBinPath runtimePkgs;

          wrapperScript = pkgs.writeShellScriptBin "vesktop" ''
            set -euo pipefail

            DATA_DIR="''${VENCORD_USER_DATA_DIR:-"$HOME/.local/share/vesktop-nix"}"

            mkdir -p "$DATA_DIR/settings" "$DATA_DIR/themes"

            cp --remove-destination "$(readlink -f "${storeConfig}/settings.json")" "$DATA_DIR/settings.json"
            cp --remove-destination "$(readlink -f "${storeConfig}/settings/settings.json")" "$DATA_DIR/settings/settings.json"

            ${lib.optionalString (quickCss != "") ''
              cp --remove-destination "$(readlink -f "${storeConfig}/settings/quickCss.css")" "$DATA_DIR/settings/quickCss.css"
            ''}

            ${lib.optionalString (themes != { }) ''
              for f in "${storeConfig}"/themes/*; do
                [ -e "$f" ] && cp --remove-destination "$(readlink -f "$f")" "$DATA_DIR/themes/$(basename "$f")"
              done
            ''}

            ${lib.optionalString (rgbStrip != null) ''
              cp --remove-destination "$(readlink -f "${storeConfig}/rgbStrip.json")" "$DATA_DIR/rgbStrip.json"
            ''}

            export VENCORD_USER_DATA_DIR="$DATA_DIR"
            ${lib.optionalString (runtimePath != "") "export PATH=\"$runtimePath\":\"$PATH\""}
            ${builtins.concatStringsSep "\n" (
              lib.mapAttrsToList (n: v: "export ${n}=${lib.escapeShellArg v}") env
            )}
            exec ${lib.escapeShellArg vesktopBin} "$@"
          '';
        in
        wrapperScript;
    };

    hyprland = {
      wrap =
        {
          pkgs,
          runtimePkgs ? [ ],
          flags ? { },
          env ? { },
        }:
        lib.extendDerivation true inputs.hyprland.packages.${system pkgs}.hyprland.passthru (
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
