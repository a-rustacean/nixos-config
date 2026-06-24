{ self, ... }: {
  perSystem =
    { pkgs, ... }:
    {
      packages.vesktop = self.lib.wrappers.vesktop.wrap {
        inherit pkgs;

        # Vesktop settings (written to settings.json)
        settings = {
          appBadge = true;
          arRPC = true;
          checkUpdates = false;
          customTitleBar = false;
          minimizeToTray = true;
          tray = true;
          hardwareAcceleration = true;
          discordBranch = "stable";
          plainSettings = { };
        };

        # Vencord plugin settings (written to settings/settings.json)
        vencordSettings = {
          enableReactDevtools = false;
          frameless = false;
          useQuickCss = true;
          themeLinks = [ ];
          enabledThemes = [ ];
          notifyAboutUpdates = false;
          plugins = {
            ClearURLs.enabled = true;
            MemberCount.enabled = true;
            ReadAllNotificationsButton.enabled = true;
            ReviewDB.enabled = true;
            SilentTyping.enabled = true;
            TypingIndicator.enabled = true;
            WhoReacted.enabled = true;
            NoBlockedMessages.enabled = true;
            GameActivityToggle.enabled = true;
            NoProfileThemes.enabled = true;
            BetterNotesBox = {
              enabled = true;
              hideNotes = true;
            };
            OnePingPerDM.enabled = true;
            ReverseImageSearch.enabled = true;
            ValidUser.enabled = true;
            FakeNitro.enabled = true;
            MessageLogger = {
              enabled = true;
              ignoreSelf = true;
            };
          };
        };

        quickCss = ''@import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");'';

        runtimePkgs = [ ];
        env = { };
      };
    };
}
