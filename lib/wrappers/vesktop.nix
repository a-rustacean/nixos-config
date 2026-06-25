{ lib, ... }:
{
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

        rm -f "$DATA_DIR/settings.json"
        cp "${storeConfig}/settings.json" "$DATA_DIR/settings.json"
        rm -f "$DATA_DIR/settings/settings.json"
        cp "${storeConfig}/settings/settings.json" "$DATA_DIR/settings/settings.json"

        ${lib.optionalString (quickCss != "") ''
          rm -f "$DATA_DIR/settings/quickCss.css"
          cp "${storeConfig}/settings/quickCss.css" "$DATA_DIR/settings/quickCss.css"
        ''}

        ${lib.optionalString (themes != { }) ''
          for f in "${storeConfig}"/themes/*; do
            [ -e "$f" ] && rm -f "$DATA_DIR/themes/$(basename "$f")" && cp "$f" "$DATA_DIR/themes/$(basename "$f")"
          done
        ''}

        ${lib.optionalString (rgbStrip != null) ''
          rm -f "$DATA_DIR/rgbStrip.json"
          cp "${storeConfig}/rgbStrip.json" "$DATA_DIR/rgbStrip.json"
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
}
