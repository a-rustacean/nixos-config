{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    let
      flags = lib.optionalAttrs (settings != { }) {
        "--config" = pkgs.writeText "fastfetch.jsonc" (builtins.toJSON settings);
      };
    in
    inputs.wrapper-modules.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.fastfetch;
        inherit runtimePkgs flags;
      }
    );
}
