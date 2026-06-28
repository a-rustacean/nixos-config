{
  lib,
  wrapPackage,
  platformGuard,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    isBool
    ;
  boolToStr = v: if v then "yes" else "no";
  renderValue =
    v:
    if isBool v then
      boolToStr v
    else if builtins.isString v then
      v
    else
      toString v;
  iniSection = name: attrs: ''
    [${name}]
    ${concatStringsSep "\n" (mapAttrsToList (k: v: "    ${k} = ${renderValue v}") attrs)}
  '';
in
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    platformGuard {
      inherit pkgs;
      name = "dunst";
      body = wrapPackage (
        { ... }: {
          inherit pkgs;
          package = pkgs.dunst;
          inherit runtimePkgs;
          flags."--config" = pkgs.writeText "dunstrc" (
            concatStringsSep "\n" (mapAttrsToList iniSection settings)
          );
        }
      );
    };
}
