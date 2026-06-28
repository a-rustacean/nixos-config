{ wrapPackage, platformGuard, ... }:
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
      configDir,
      env ? { },
      extraFlags ? { },
    }:
    platformGuard {
      inherit pkgs;
      name = "quickshell";
      body = wrapPackage (
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
      );
    };
}
