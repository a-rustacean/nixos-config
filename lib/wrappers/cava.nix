{ inputs, lib, ... }:
let
  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;
  isHex = s: builtins.isString s && builtins.substring 0 1 s == "#";
  quoteHex = v: if isHex v then "'${v}'" else toString v;
  iniKeyValue = name: value: "${name} = ${quoteHex value}";
  iniSection = name: attrs: ''
    [${name}]
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList iniKeyValue attrs)}
  '';
in
{
  wrap =
    {
      pkgs,
      settings,
      colors,
      runtimePkgs ? [ ],
    }:
    if pkgs.stdenv.hostPlatform.isLinux then
      wrapPackage (
        { ... }: {
          inherit pkgs;
          package = pkgs.cava;
          inherit runtimePkgs;
          flags = {
            "-p" = pkgs.writeText "cava-config" (
              lib.concatStringsSep "\n" (lib.mapAttrsToList iniSection (settings // { color = colors; }))
            );
          };
        }
      )
    else
      pkgs.runCommand "cava-wrapper"
        {
          meta = {
            platforms = lib.platforms.linux;
            badPlatforms = lib.platforms.darwin;
          };
        }
        ''
          echo "cava is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
          exit 1
        '';
}
