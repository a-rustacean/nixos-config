{ self, ... }:
{
  flake.nixosModules.hyprpaper =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprpaper = self.lib.wrappers.hyprpaper.wrap {
        inherit pkgs;
        settings = {
          splash = false;
          wallpaper = [
            {
              fit_mode = "cover";
              monitor = "";
              path = "${./wallpaper.jpg}";
            }
          ];
        };
        importantPrefixes = [
          "$"
          "monitor"
        ];
      };
    };
}
