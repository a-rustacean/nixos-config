{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
      configDir,
      env ? { },
      extraFlags ? { },
    }:
    if pkgs.stdenv.hostPlatform.isLinux then
      inputs.wrapper-modules.lib.wrapPackage (
        { ... }: {
          inherit pkgs;
          package = pkgs.quickshell;
          inherit runtimePkgs;
          flags = {
            "--path" = configDir;
          }
          // extraFlags;
          inherit env;
        }
      )
    else
      pkgs.runCommand "quickshell-wrapper"
        {
          meta = {
            platforms = lib.platforms.linux;
            badPlatforms = lib.platforms.darwin;
          };
        }
        ''
          echo "quickshell is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
          exit 1
        '';
}
