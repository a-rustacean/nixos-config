{ self, inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprsunset = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = inputs.hyprsunset.packages.${pkgs.stdenv.hostPlatform.system}.hyprsunset;
          runtimePkgs = [ ];
          flags = {
            "--config" = pkgs.writeText "hyprsunset.conf" (
              self.lib.generators.toHyprconf {
                attrs = {
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
                importantPrefixes = [ "$" ];
              }
            );
          };
        }
      );
    };
}
