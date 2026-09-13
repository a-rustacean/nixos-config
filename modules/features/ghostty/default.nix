{ self, lib, ... }: {
  flake.nixosModules.ghostty =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty
      ];
    };
  perSystem =
    { pkgs, self', ... }:
    {
      packages.ghostty = self.lib.wrappers.ghostty.wrap {
        inherit pkgs;
        runtimePkgs = [ self'.packages.zsh ];
        settings = {
          command = "${lib.getExe self'.packages.zsh} -l";
          language = "en";
          font-family = "JetBrainsMono Nerd Font";
          font-size = 20;
          cursor-style = "block";
          mouse-hide-while-typing = true;
          scroll-to-bottom = [
            "keystroke"
            "output"
          ];
          confirm-close-surface = false;
          theme = "Catppuccin Mocha";
          background-opacity = 0.90;
          background-opacity-cells = true;
          macos-titlebar-style = "hidden";
          background-blur = true;
          window-padding-x = 10;
          window-padding-y = 10;
          window-padding-balance = true;
          window-padding-color = "extend";
          shell-integration = "detect";
          shell-integration-features = [
            "no-cursor"
            "sudo"
          ];
        };
        fontPackage = pkgs.nerd-fonts.jetbrains-mono;
      };
    };
}
