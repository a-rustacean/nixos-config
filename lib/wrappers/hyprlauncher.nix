{ inputs, lib, ... }:
let
  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;
in
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
    }:
    if pkgs.stdenv.hostPlatform.isLinux then
      wrapPackage (
        { ... }: {
          inherit pkgs;
          package = pkgs.hyprlauncher;
          inherit runtimePkgs;
        }
      )
    else
      pkgs.runCommand "hyprlauncher-wrapper"
        {
          meta.platforms = lib.platforms.linux;
        }
        ''
          echo "hyprlauncher is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
          exit 1
        '';
}
