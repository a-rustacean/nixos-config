{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    let
      toHtoprc = attrs:
        lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value:
          let
            rendered = if builtins.isBool value then (if value then "1" else "0") else toString value;
          in
          "${name}=${rendered}"
        ) attrs);
    in
    inputs.wrapper-modules.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.htop;
        inherit runtimePkgs;
        env = {
          HTOPRC = pkgs.writeText "htoprc" (toHtoprc settings);
        };
      }
    );
}
