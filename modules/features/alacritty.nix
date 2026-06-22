{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.alacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
        inherit pkgs;
        settings = {
          general.live_config_reload = true;
          font = {
            size = 16.0;
            bold = {
              family = "JetBrainsMono Nerd Font";
              style = "Bold";
            };
            italic = {
              family = "JetBrainsMono Nerd Font";
              style = "Light Italic";
            };
            normal = {
              family = "JetBrainsMono Nerd Font";
              style = "Medium";
            };
            glyph_offset = {
              x = 0;
              y = 0;
            };
          };
          window = {
            decorations = if pkgs.stdenv.isDarwin then "Buttonless" else "None";
            dynamic_padding = true;
            startup_mode = "Windowed";
            dimensions = {
              columns = 120;
              lines = 30;
            };
            padding = {
              x = 10;
              y = 10;
            };
          };
        };
        env.XDG_DATA_DIRS = "${pkgs.nerd-fonts.jetbrains-mono}/share";
      };
    };
}
