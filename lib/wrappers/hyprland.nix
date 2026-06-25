{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
      flags ? { },
      env ? { },
    }:
    if pkgs.stdenv.hostPlatform.isLinux then
      lib.extendDerivation true inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.passthru (
        inputs.wrapper-modules.lib.wrapPackage (
          { ... }:
          {
            inherit pkgs;
            package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            inherit runtimePkgs flags env;
          }
        )
      )
    else
      pkgs.runCommand "hyprland-wrapper" {
        meta = {
          platforms = lib.platforms.linux;
          badPlatforms = lib.platforms.darwin;
        };
      } ''
        echo "Hyprland is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
        exit 1
      '';
}
