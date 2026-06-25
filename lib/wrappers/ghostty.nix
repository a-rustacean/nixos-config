{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
      config,
      theme ? null,
      fontPackage ? null,
    }:
    let
      ghosttyPkg =
        if pkgs.stdenv.hostPlatform.isLinux then
          inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.ghostty
        else
          pkgs.runCommand "ghostty-unavailable" {
            meta = {
              platforms = lib.platforms.linux;
              badPlatforms = lib.platforms.darwin;
            };
          } ''
            echo "ghostty is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
            exit 1
          '';
    in
    inputs.wrapper-modules.lib.wrapPackage (
      { ... }:
      {
        inherit pkgs;
        package = ghosttyPkg;
        inherit runtimePkgs;
        env = {
          XDG_CONFIG_HOME = pkgs.symlinkJoin {
            name = "ghostty-config";
            paths = [
              (pkgs.writeTextDir "ghostty/config" config)
            ]
            ++ lib.optional (theme != null) (pkgs.writeTextDir "ghostty/themes/nix-theme" theme);
          };
        }
        // lib.optionalAttrs (fontPackage != null) {
          XDG_DATA_DIRS = "${fontPackage}/share";
        };
      }
    );
}
