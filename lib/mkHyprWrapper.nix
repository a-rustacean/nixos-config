{
  self,
  inputs,
  lib,
  wrapPackage,
}:
let
  wrap = wrapPackage;
in
name: {
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
      extraFlags ? { },
      extraConfig ? "",
      importantPrefixes ? [ "$" ],
    }:
    if pkgs.stdenv.hostPlatform.isLinux then
      wrap (
        { ... }:
        {
          inherit pkgs;
          package = pkgs.${name};
          inherit runtimePkgs;
          flags = {
            "--config" = pkgs.writeText "${name}.conf" (
              (self.lib.generators.toHyprconf {
                attrs = settings;
                inherit importantPrefixes;
              })
              + extraConfig
            );
          }
          // extraFlags;
        }
      )
    else
      pkgs.runCommand "${name}-wrapper"
        {
          meta = {
            platforms = lib.platforms.linux;
            badPlatforms = lib.platforms.darwin;
          };
        }
        ''
          echo "${name} is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
          exit 1
        '';
}
