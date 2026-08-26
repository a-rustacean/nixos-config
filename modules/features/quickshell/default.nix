{ self, ... }:
{
  flake.nixosModules.quickshell =
    { pkgs, ... }:
    {
      services.upower.enable = true;
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.quickshell
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.quickshell = self.lib.wrappers.quickshell.wrap {
        inherit pkgs;
        configDir = "${./config}";
        env.XDG_DATA_DIRS = "${pkgs.nerd-fonts.jetbrains-mono}/share";
      };
    };
}
