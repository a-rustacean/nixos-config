{ lib, wrapPackage, ... }:
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
      flags ? { },
      env ? { },
    }:
    if pkgs.stdenv.hostPlatform.isLinux then
      lib.extendDerivation true
        pkgs.hyprland.passthru
        (
          wrapPackage (
            { ... }:
            {
              inherit pkgs;
              package = pkgs.hyprland;
              inherit runtimePkgs flags env;
            }
          )
        )
    else
      pkgs.runCommand "hyprland-wrapper"
        {
          meta = {
            platforms = lib.platforms.linux;
            badPlatforms = lib.platforms.darwin;
          };
        }
        ''
          echo "Hyprland is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
          exit 1
        '';
}
