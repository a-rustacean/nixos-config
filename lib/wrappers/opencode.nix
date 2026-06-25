{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      settings ? { },
      tui ? { },
      runtimePkgs ? [ ],
    }:
    let
      env =
        { }
        // lib.optionalAttrs (settings != { }) {
          OPENCODE_CONFIG = pkgs.writeText "opencode.json" (builtins.toJSON settings);
        }
        // lib.optionalAttrs (tui != { }) {
          OPENCODE_TUI_CONFIG = pkgs.writeText "tui.json" (builtins.toJSON tui);
        };
    in
    inputs.wrapper-modules.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.opencode;
        inherit runtimePkgs env;
      }
    );
}
