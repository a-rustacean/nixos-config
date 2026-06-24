{ self, inputs, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
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
          "--config" = "${../../hyprland}/hyprland.lua";
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

      packages.xdg-desktop-portal-hyprland =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      packages.hyprshutdown =
        inputs.hyprshutdown.packages.${pkgs.stdenv.hostPlatform.system}.hyprshutdown;
      packages.hyprpicker = inputs.hyprpicker.packages.${pkgs.stdenv.hostPlatform.system}.hyprpicker;
    };
}
