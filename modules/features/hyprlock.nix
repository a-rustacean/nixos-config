{ self, inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprlock = inputs.wrapper-modules.lib.wrapPackage (
        { ... }:
        {
          inherit pkgs;
          package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
          runtimePkgs = [ ];
          flags = {
            "--config" = pkgs.writeText "hyprpaper.conf" (
              self.generators.toHyprconf {
                attrs = {
                  general = {
                    hide_cursor = true;
                    ignore_empty_input = true;
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
                      path = "${../../wallpaper.jpg}";
                      blur_passes = 3;
                      blur_size = 8;
                    }
                  ];

                  input-field = [
                    {
                      size = "200, 50";
                      position = "0, -80";
                      monitor = "";
                      dots_center = true;
                      fade_on_empty = false;
                      font_color = "rgb(202, 211, 245)";
                      inner_color = "rgb(91, 96, 120)";
                      outer_color = "rgba(24, 25, 38, 100)";
                      outline_thickness = 5;
                      placeholder_text = "Password...";
                      shadow_passes = 2;
                    }
                  ];
                };
                importantPrefixes = [
                  "$"
                  "bezier"
                  "monitor"
                  "size"
                ];
              }
            );
          };
        }
      );
    };
}
