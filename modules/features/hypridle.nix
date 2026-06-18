{ self, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.hypridle = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
          runtimePkgs = [ ];
          flags = {
            "--config" = pkgs.writeText "hypridle.conf" (
              self.lib.generators.toHyprconf {
                attrs = {
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
                importantPrefixes = [ "$" ];
              }
            );
          };
        }
      );
    };
}
