{ self, inputs, ... }:
{
  wrap =
    {
      pkgs,
      config,
      runtimePkgs ? [ ],
    }:
    inputs.wrapper-modules.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.oh-my-posh;
        inherit runtimePkgs;
        flags = {
          "--config" = pkgs.writeText "oh-my-posh.json" (self.lib.generators.toOMP config);
        };
      }
    );
}
