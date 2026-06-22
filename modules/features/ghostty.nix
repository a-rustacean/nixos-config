{ inputs, ... }: {
  perSystem =
    { pkgs, self', ... }:
    {
      packages.ghostty = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.ghostty;
          runtimePkgs = [ self'.packages.zsh ];
          env = {
            XDG_CONFIG_HOME = pkgs.symlinkJoin {
              name = "ghostty-config";
              paths = [
                (pkgs.writeTextDir "ghostty/config.ghostty" ''
                  language = en
                  font-family = "JetBrainsMono Nerd Font"
                  font-size = 16
                  cursor-style = block
                  mouse-hide-while-typing = true
                  scroll-to-bottom = keystroke, output
                  mouse-reporting = false
                  theme = nix-theme
                  # restore XDG_CONFIG_HOME
                  env = XDG_CONFIG_HOME=~/.config

                  background-opacity = 0.75
                  background-blur = 20

                  window-padding-x = 10
                  window-padding-y = 10
                  window-padding-balance = true
                  window-padding-color = extend

                  shell-integration = detect
                  shell-integration-features = no-cursor, sudo
                '')

                (pkgs.writeTextDir "ghostty/themes/nix-theme" (
                  builtins.readFile (
                    (pkgs.callPackage inputs.base16.lib { }).mkSchemeAttrs
                      "${inputs.tt-schemes}/base24/catppuccin-mocha.yaml"
                      {
                        templateRepo = inputs.base16-terminal;
                        target = "ghostty-base24";
                        check-parsed-config-yaml = false;
                      }
                  )
                ))
              ];
            };
            XDG_DATA_DIRS = "${pkgs.nerd-fonts.jetbrains-mono}/share";
          };
        }
      );
    };
}
