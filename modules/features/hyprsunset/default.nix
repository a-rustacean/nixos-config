{ self, ... }:
{
  flake.nixosModules.hyprsunset =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.hyprsunset
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprsunset = self.lib.wrappers.hyprsunset.wrap {
        inherit pkgs;
        settings = {
          max-gamma = 100;

          profile = [
            {
              time = "7:30";
              identity = true;
            }
            {
              time = "21:00";
              temperature = 5000;
              gamma = 0.8;
            }
          ];
        };
      };
    };
}
