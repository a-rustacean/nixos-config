{
  lib,
  wrapPackage,
  platformGuard,
  ...
}:
let
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
    platformGuard {
      inherit pkgs;
      name = "cava";
      body = wrapPackage (
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
      );
    };
}
