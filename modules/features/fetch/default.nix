{ self, ... }:
{
  flake.nixosModules.fetch =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fetch
      ];
    };

  perSystem =
    { inputs', ... }:
    {
      packages.fetch = inputs'.fetch.packages.default;
    };
}
