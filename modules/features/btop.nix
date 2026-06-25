{ self, ... }:
let
  ctp = self.lib.generators.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.btop = self.lib.wrappers.btop.wrap {
        inherit pkgs;
        settings = {
          color_theme = "catppuccin_mocha";
          theme_background = false;
        };
      };
    };
}
