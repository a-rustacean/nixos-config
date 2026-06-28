{ wrapPackage, platformGuard, ... }:
{
  wrap =
    {
      pkgs,
      runtimePkgs ? [ ],
    }:
    platformGuard {
      inherit pkgs;
      name = "hyprlauncher";
      body = wrapPackage (
        { ... }: {
          inherit pkgs;
          package = pkgs.hyprlauncher;
          inherit runtimePkgs;
        }
      );
    };
}
