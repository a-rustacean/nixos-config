{ self, inputs, ... }:
{
  flake.nixosModules.hyprland = (
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = self.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    }
  );

  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    {
      packages.hyprland =
        lib.extendDerivation true
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.passthru
          (
            inputs.wrapper-modules.lib.wrapPackage (
              { ... }:
              {
                inherit pkgs;
                package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
                runtimePkgs = with pkgs; [
                  self'.packages.xdg-desktop-portal-hyprland
                  self'.packages.hypridle
                  self'.packages.hyprsunset
                  hyprpicker
                  cliphist
                  wl-clipboard
                  # TODO: dunst
                  # TODO: gtk?
                  # TODO: cursor
                  # TODO: dunst
                ];
                flags = {
                  "--config" = "${../../hyprland}/hyprland.lua";
                };
                env = {
                  HYPRLAND_PROGRAM_ALACRITTY = lib.getExe self'.packages.alacritty;
                  HYPRLAND_PROGRAM_ROFI = lib.getExe pkgs.rofi; # TODO: use hyprlauncher
                  HYPRLAND_PROGRAM_HYPRPAPER = lib.getExe self'.packages.hyprpaper;
                  HYPRLAND_PROGRAM_HYPRLOCK = lib.getExe self'.packages.hyprlock;
                  HYPRLAND_PROGRAM_HYPRSHUTDOWN = lib.getExe self'.packages.hyprshutdown;
                  HYPRLAND_PROGRAM_QUICKSHELL = lib.getExe self'.packages.quickshell;
                  # TODO: use hyprcursor
                  XCURSOR_PATH = "${pkgs.capitaine-cursors}/share/icons";
                  XCURSOR_THEME = "capitaine-cursors";
                  XCURSOR_SIZE = "24";
                };
              }
            )
          );

      packages.xdg-desktop-portal-hyprland =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      packages.hyprshutdown =
        inputs.hyprshutdown.packages.${pkgs.stdenv.hostPlatform.system}.hyprshutdown;
    };
}
