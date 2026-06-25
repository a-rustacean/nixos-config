{ self, ... }:
let
  ctp = self.lib.generators.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.htop = self.lib.wrappers.htop.wrap {
        inherit pkgs;
        settings = {
          color_scheme = 0;
          fields = "0 48 17 18 38 39 40 2 46 47 49 1";
          hide_kernel_threads = true;
          hide_userland_threads = false;
          hide_threads = false;
          highlight_changes = false;
          highlight_base_name = true;
          highlight_megabytes = true;
          highlight_threads = true;
          sort_key = 46;
          sort_direction = -1;
          tree_view = true;
          tree_view_always_by_pid = false;
          all_branches_collapsed = false;
          screen = "Main";
          delay = 15;
          left_meters = "LeftCPUs Memory Swap";
          left_meter_modes = "1 1 1";
          right_meters = "RightCPUs Tasks LoadAverage Uptime";
          right_meter_modes = "1 2 2 2";
        };
      };
    };
}
