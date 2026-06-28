{
  lib,
  inputs,
  self,
  mkStoreConfigWrapper,
  ...
}:
{
  wrap =
    {
      pkgs,
      settings ? { },
      policies ? { },
      userChrome ? null,
      userContent ? null,
      containers ? { },
      extraPrefs ? "",
    }:
    let
      inherit (self.lib.generators) toUserJs;

      inherit (inputs.catppuccin-zen-browser) outPath;

      catppuccinChrome = "${outPath}/themes/Mocha/Mauve/userChrome.css";
      catppuccinContent = "${outPath}/themes/Mocha/Mauve/userContent.css";
      catppuccinLogo = "${outPath}/themes/Mocha/Mauve/zen-logo-mocha.svg";

      defaultSettings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      mergedSettings = defaultSettings // settings;

      base = inputs.zen-browser.packages.${pkgs.system}.beta-unwrapped.override {
        inherit policies;
      };

      wrapped = pkgs.wrapFirefox base {
        icon = "zen-browser";
      };
    in
    mkStoreConfigWrapper {
      inherit pkgs;
      name = "zen-browser";
      package = wrapped;
      dataDir = "$HOME/.nix-wrapped-apps/zen-browser";
      dataDirEnv = "ZEN_DATA_DIR";
      configFiles = {
        "default/user.js" = pkgs.writeText "zen-user-js" (
          (toUserJs mergedSettings) + lib.optionalString (extraPrefs != "") "\n${extraPrefs}"
        );
        "default/chrome/userChrome.css" =
          if userChrome != null then pkgs.writeText "userChrome.css" userChrome else catppuccinChrome;
        "default/chrome/userContent.css" =
          if userContent != null then pkgs.writeText "userContent.css" userContent else catppuccinContent;
        "default/chrome/zen-logo-mocha.svg" = catppuccinLogo;
      }
      // lib.optionalAttrs (containers != { }) {
        "default/containers.json" = pkgs.writeText "containers.json" (builtins.toJSON containers);
      };

      inject.flags = [
        "--profile"
        "$DATA_DIR/default"
      ];

      desktopEntry = {
        name = "zen-browser";
        desktopName = "Zen Browser";
        icon = "zen-browser";
        exec = "zen-browser %u";
        mimeTypes = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "application/x-xpinstall"
          "application/pdf"
          "application/json"
        ];
        categories = [
          "Network"
          "WebBrowser"
        ];
        startupWMClass = "zen-beta";
        startupNotify = true;
        terminal = false;
      };
    };
}
