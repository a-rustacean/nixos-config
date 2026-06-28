{ lib }:
{
  mkStoreConfigWrapper =
    {
      pkgs,
      name,
      package,
      dataDir,
      configFiles ? { },
      dataDirEnv ? null,
      inject ? { },
      desktopEntry ? null,
      runtimePkgs ? [ ],
      extraEnv ? { },
      preExec ? "",
    }:
    let
      inject' = inject // {
        flags = inject.flags or [ ];
        env = inject.env or { };
      };

      wrapperScript = pkgs.writeShellScriptBin name ''
        set -euo pipefail

        DATA_DIR="${dataDir}"
        ${lib.optionalString (dataDirEnv != null) ''
          DATA_DIR="''${${dataDirEnv}:-$DATA_DIR}"
        ''}

        mkdir -p "$DATA_DIR"

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (dest: src: ''
            ${lib.optionalString (builtins.dirOf dest != ".") ''
              mkdir -p "$DATA_DIR/${lib.escapeShellArg (builtins.dirOf dest)}"
            ''}
            rm -f "$DATA_DIR/${lib.escapeShellArg dest}"
            cp --no-preserve=mode "${src}" "$DATA_DIR/${lib.escapeShellArg dest}"
          '') configFiles
        )}

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (n: v: ''
            export ${n}=${v}
          '') inject'.env
        )}

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (n: v: ''
            export ${n}=${v}
          '') extraEnv
        )}

        ${lib.optionalString (runtimePkgs != [ ]) ''
          export PATH="${lib.makeBinPath runtimePkgs}:$PATH"
        ''}

        ${preExec}

        exec ${lib.getExe package} \
          ${builtins.concatStringsSep " " inject'.flags} \
          "$@"
      '';
    in
    pkgs.symlinkJoin {
      name = name;
      paths = [
        wrapperScript
      ]
      ++ lib.optional (desktopEntry != null) (pkgs.makeDesktopItem desktopEntry);
    };
}
