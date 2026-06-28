{ lib, wrapPackage, platformGuard, ... }:
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
      flags ? { },
      env ? { },
    }:
    platformGuard {
      inherit pkgs;
      name = "hyprland";
      body = lib.extendDerivation true pkgs.hyprland.passthru (
        wrapPackage (
          { ... }:
          {
            inherit pkgs;
            package = pkgs.hyprland;
            inherit runtimePkgs flags env;
          }
        )
      );
    };
}
