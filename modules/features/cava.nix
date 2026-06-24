{ self, ... }:
let
  ctp = self.lib.generators.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.cava = self.lib.wrappers.cava.wrap {
        inherit pkgs;
        settings = { };
        colors = {
          gradient = 1;
          gradient_color_1 = ctp.sky;
          gradient_color_2 = ctp.blue;
          gradient_color_3 = ctp.mauve;
          gradient_color_4 = ctp.pink;
          gradient_color_5 = ctp.red;
        };
      };
    };
}
