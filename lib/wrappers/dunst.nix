{ inputs, lib, ... }:
let
  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;
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
    if pkgs.stdenv.hostPlatform.isLinux then
      wrapPackage (
        { ... }: {
          inherit pkgs;
          package = pkgs.dunst;
          inherit runtimePkgs;
          flags."--config" = pkgs.writeText "dunstrc" (
            concatStringsSep "\n" (mapAttrsToList iniSection settings)
          );
        }
      )
    else
      pkgs.runCommand "dunst-wrapper"
        {
          meta.platforms = lib.platforms.linux;
        }
        ''
          echo "dunst is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
          exit 1
        '';
}
