{ self, ... }:
let
  ctp = self.lib.colors.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.gitui = self.lib.wrappers.gitui.wrap {
        inherit pkgs;
        gitConfig = self.lib.git.settings;
        theme = {
          selected_tab = "Reset";
          command_fg = ctp.text;
          selection_bg = ctp.surface2;
          selection_fg = ctp.text;
          cmdbar_bg = ctp.mantle;
          cmdbar_extra_lines_bg = ctp.mantle;
          disabled_fg = ctp.overlay1;
          diff_line_add = ctp.green;
          diff_line_delete = ctp.red;
          diff_file_added = ctp.green;
          diff_file_removed = ctp.maroon;
          diff_file_moved = ctp.mauve;
          diff_file_modified = ctp.peach;
          commit_hash = ctp.lavender;
          commit_time = ctp.subtext1;
          commit_author = ctp.sapphire;
          danger_fg = ctp.red;
          push_gauge_bg = ctp.blue;
          push_gauge_fg = ctp.base;
          tag_fg = ctp.rosewater;
          branch_fg = ctp.teal;
        };
      };
    };
}
