{ self, ... }: {
  perSystem =
    { pkgs, self', ... }:
    {
      packages.ghostty = self.lib.wrappers.ghostty.wrap {
        inherit pkgs;
        runtimePkgs = [ self'.packages.zsh ];
        config = ''
          language = en
          font-family = "JetBrainsMono Nerd Font"
          font-size = 16
          cursor-style = block
          mouse-hide-while-typing = true
          scroll-to-bottom = keystroke, output
          confirm-close-surface = false
          theme = Catppuccin Mocha
          # restore XDG_CONFIG_HOME
          env = XDG_CONFIG_HOME=~/.config

          background-blur = true

          window-padding-x = 10
          window-padding-y = 10
          window-padding-balance = true
          window-padding-color = extend

          shell-integration = detect
          shell-integration-features = no-cursor, sudo
        '';
        fontPackage = pkgs.nerd-fonts.jetbrains-mono;
      };
    };
}
