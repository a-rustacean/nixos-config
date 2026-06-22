{ self, ... }:
{
  perSystem =
    { pkgs, lib, self', ... }:
    {
      packages.hypridle = self.lib.wrappers.hypridle.wrap {
        inherit pkgs;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = lib.getExe self'.packages.hyprlock;
          };
          listener = [
            {
              on-timeout = lib.getExe self'.packages.hyprlock;
              timeout = 900;
            }
            {
              on-resume = "hyprctl dispatch dpms on";
              on-timeout = "hyprctl dispatch dpms off";
              timeout = 1200;
            }
          ];
        };
      };
    };
}
