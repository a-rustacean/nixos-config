{ self, ... }:
let
  ctp = self.lib.colors.catppuccin.mocha;
  hex = color: builtins.substring 1 6 color;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprlock = self.lib.wrappers.hyprlock.wrap {
        inherit pkgs;
        settings = {
          general = {
            hide_cursor = true;
            ignore_empty_input = false;
            grace = 300;
          };

          animations = {
            enabled = true;
            fade_in = {
              duration = 300;
              bezier = "easeOutQuint";
            };
            fade_out = {
              duration = 300;
              bezier = "easeOutQuint";
            };
          };

          background = [
            {
              path = "${../../lib/configs/wallpaper.jpg}";
              blur_passes = 4;
              blur_size = 8;
              contrast = 0.8;
              brightness = 0.5;
            }
          ];

          label = [
            {
              text = "cmd[update:1000] date '+%I:%M %p'";
              font_size = 96;
              font_family = "JetBrainsMono Nerd Font";
              color = "rgb(${hex ctp.text})";
              position = "0, 120";
              monitor = "";
              halign = "center";
              valign = "center";
            }
            {
              text = "cmd[update:3600] date '+%A, %B %d'";
              font_size = 24;
              font_family = "JetBrainsMono Nerd Font";
              color = "rgb(${hex ctp.subtext0})";
              position = "0, 40";
              monitor = "";
              halign = "center";
              valign = "center";
            }
          ];

          input-field = [
            {
              size = "320, 54";
              position = "0, -70";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              placeholder_text = "Password...";
              outline_thickness = 2;
              dots_size = 0.2;
              dots_spacing = 0.3;
              font_color = "rgb(${hex ctp.text})";
              inner_color = "rgb(${hex ctp.surface0})";
              outer_color = "rgb(${hex ctp.lavender})";
              fail_color = "rgb(${hex ctp.red})";
              fail_text = "<i>Incorrect...</i>";
              capslock_color = "rgb(${hex ctp.yellow})";
              check_color = "rgb(${hex ctp.green})";
              shadow_passes = 2;
              rounding = 12;
            }
          ];
        };
        importantPrefixes = [
          "$"
          "bezier"
          "monitor"
          "size"
        ];
      };
    };
}
