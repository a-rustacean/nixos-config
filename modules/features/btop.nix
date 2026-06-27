{ self, ... }:
let
  ctp = self.lib.colors.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.btop = self.lib.wrappers.btop.wrap {
        inherit pkgs;
        settings = {
          color_theme = "catppuccin_mocha";
          theme_background = true;
        };
      };
    };
}
