{ lib, mkStoreConfigWrapper, ... }:
{
  wrap =
    {
      pkgs,
      settings ? { },
      vencordSettings ? { },
      quickCss ? "",
      themes ? { },
      rgbStrip ? null,
      runtimePkgs ? [ ],
      env ? { },
    }:
    mkStoreConfigWrapper {
      inherit pkgs;
      name = "vesktop";
      package = pkgs.vesktop;
      dataDir = "$HOME/.nix-wrapped-apps/vesktop";
      dataDirEnv = "VENCORD_USER_DATA_DIR";

      configFiles = {
        "settings.json" = pkgs.writeText "vesktop-settings" (builtins.toJSON settings);
        "settings/settings.json" = pkgs.writeText "vencord-settings" (builtins.toJSON vencordSettings);
      }
      // lib.optionalAttrs (quickCss != "") {
        "settings/quickCss.css" = pkgs.writeText "quickCss.css" quickCss;
      }
      // lib.optionalAttrs (rgbStrip != null) {
        "rgbStrip.json" = pkgs.writeText "vesktop-rgb-strip" (builtins.toJSON rgbStrip);
      }
      // lib.mapAttrs' (name: path: {
        name = "themes/${name}";
        value = path;
      }) themes;

      inject.env = {
        "VENCORD_USER_DATA_DIR" = "$DATA_DIR";
      };

      desktopEntry = {
        name = "vesktop";
        desktopName = "Vesktop";
        comment = "Discord client with Vencord";
        icon = "vesktop";
        exec = "vesktop";
        terminal = false;
        type = "Application";
        categories = [
          "Network"
          "InstantMessaging"
        ];
        startupWMClass = "vesktop";
      };

      inherit runtimePkgs;
      extraEnv = env;
    };
}
