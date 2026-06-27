{ inputs, lib, ... }:
let
  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;
in
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
    wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.fastfetch;
        inherit runtimePkgs flags;
      }
    );
}
