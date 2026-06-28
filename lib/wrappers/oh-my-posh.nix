{ self, inputs, ... }:
let
  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;
in
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.oh-my-posh;
        inherit runtimePkgs;
        flags = {
          "--config" = pkgs.writeText "oh-my-posh.json" (self.lib.generators.toOMP settings);
        };
      }
    );
}
