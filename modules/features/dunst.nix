{ self, ... }:
let
  ctp = self.lib.colors.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.dunst = self.lib.wrappers.dunst.wrap {
        inherit pkgs;
        settings = {
          global = {
            monitor = 0;
            follow = "mouse";
            width = 300;
            height = 300;
            origin = "top-right";
            offset = "10x50";
            indicate_hidden = true;
            shrink = false;
            separator_height = 2;
            padding = 8;
            horizontal_padding = 8;
            frame_width = 2;
            frame_color = ctp.surface2;
            separator_color = "frame";
            sort = true;
            font = "JetBrainsMono Nerd Font 10";
            line_height = 4;
            markup = "full";
            format = "<b>%s</b>\n%b";
            alignment = "left";
            show_age_threshold = 60;
            word_wrap = true;
            ellipsize = "middle";
            ignore_newline = false;
            stack_duplicates = true;
            hide_duplicate_count = false;
            show_indicators = true;
            icon_position = "left";
            sticky_history = true;
            history_length = 20;
            browser = "/usr/bin/xdg-open";
            always_run_script = true;
            corner_radius = 8;
            ignore_dbusclose = false;
          };
          shortcuts = {
            close = "ctrl+space";
            close_all = "ctrl+shift+space";
            history = "ctrl+grave";
            context = "ctrl+shift+period";
          };
          urgency_low = {
            background = ctp.surface0;
            foreground = ctp.text;
            timeout = 10;
            highlight = ctp.mauve;
          };
          urgency_normal = {
            background = ctp.surface0;
            foreground = ctp.text;
            timeout = 10;
            highlight = ctp.mauve;
          };
          urgency_critical = {
            background = ctp.red;
            foreground = ctp.text;
            timeout = 0;
            highlight = ctp.red;
          };
        };
      };
    };
}
