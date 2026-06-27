{ self, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, config, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      services.greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${config.programs.hyprland.package}/bin/start-hyprland";
            # TODO: no-hardcode
            user = "dilshad";
          };
          default_session = initial_session;
        };
      };

      environment.systemPackages = [
        (pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = [ "blue" ];
          size = "standard";
        })
        (pkgs.catppuccin-kde.override {
          flavour = [ "mocha" ];
          accents = [ "blue" ];
        })
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.adw-gtk3
        pkgs.libsForQt5.qt5ct
        pkgs.qt6Packages.qt6ct
      ];

      environment.variables.QT_QPA_PLATFORMTHEME = "kvantum";

      environment.etc."xdg/Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Catppuccin-Mocha-Blue
      '';

      programs.dconf.profiles.user.databases = [
        {
          settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "catppuccin-mocha-blue-standard";
            };
          };
        }
      ];
    };

  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      packages.hyprland = self.lib.wrappers.hyprland.wrap {
        inherit pkgs;
        runtimePkgs = with pkgs; [
          self'.packages.xdg-desktop-portal-hyprland
          self'.packages.hypridle
          self'.packages.hyprsunset
          cliphist
          wl-clipboard
        ];
        flags = {
          "--config" = "${../../lib/configs/hyprland}/hyprland.lua";
        };
        env = {
          HYPRLAND_PROGRAM_GHOSTTY = lib.getExe self'.packages.ghostty;
          HYPRLAND_PROGRAM_HYPRLAUNCHER = lib.getExe self'.packages.hyprlauncher;
          HYPRLAND_PROGRAM_HYPRPAPER = lib.getExe self'.packages.hyprpaper;
          HYPRLAND_PROGRAM_HYPRLOCK = lib.getExe self'.packages.hyprlock;
          HYPRLAND_PROGRAM_HYPRSHUTDOWN = lib.getExe self'.packages.hyprshutdown;
          HYPRLAND_PROGRAM_HYPRPICKER = lib.getExe self'.packages.hyprpicker;
          HYPRLAND_PROGRAM_QUICKSHELL = lib.getExe self'.packages.quickshell;
          HYPRLAND_PROGRAM_DUNST = lib.getExe self'.packages.dunst;
          # TODO: use hyprcursor
          XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons";
          XCURSOR_THEME = "Bibata-Modern-Ice";
          XCURSOR_SIZE = "24";
        };
      };

      packages.xdg-desktop-portal-hyprland = pkgs.xdg-desktop-portal-hyprland;
      packages.hyprshutdown = pkgs.hyprshutdown;
      packages.hyprpicker = pkgs.hyprpicker;
    };
}
