{ self, ... }:
{
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
              path = "${../../wallpaper.png}";
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
