{ self, ... }:
let
  ctp = self.lib.colors.catppuccin.mocha;
in
{
  flake.nixosModules.btop =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.btop
      ];
    };
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
