{ self, inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprpaper = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper;
          runtimePkgs = [ ];
          flags = {
            "--config" = pkgs.writeText "hyprpaper.conf" (
              self.lib.generators.toHyprconf {
                attrs = {
                  splash = false;
                  wallpaper = [
                    {
                      fit_mode = "cover";
                      monitor = "";
                      path = "${../../wallpaper.png}";
                    }
                  ];
                };
                importantPrefixes = [
                  "$"
                  "monitor"
                ];
              }
            );
          };
        }
      );
    };
}
