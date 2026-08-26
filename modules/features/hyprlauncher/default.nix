{ self, ... }:
{
  flake.nixosModules.hyprlauncher =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.hyprlauncher
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprlauncher = self.lib.wrappers.hyprlauncher.wrap {
        inherit pkgs;
      };
    };
}
