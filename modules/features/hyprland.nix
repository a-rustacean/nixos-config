{ self, inputs, ... }:
{
  flake.nixosModules.hyprland = (
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
        lib.extendDerivation true inputs.hyprland.packages.aarch64-linux.hyprland.passthru
          (
            inputs.wrapper-modules.lib.wrapPackage (
              { ... }:
              {
                inherit pkgs;
                package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
                runtimePkgs = with pkgs; [
                  inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
                  self'.packages.hypridle
                  self'.packages.hyprsunset
                  hyprpicker
                  cliphist
                  wl-clipboard
                  # TODO: dunst
                  # TODO: gtk?
                  # TODO: cursor
                  # TODO: dunst
                  # TODO: hyprshutdown
                ];
                flags = {
                  "--config" = "${../../hyprland}/hyprland.lua";
                };
                env = {
                  HYPRLAND_ALACRITTY_EXE = lib.getExe self'.packages.alacritty;
                  HYPRLAND_ROFI_EXE = lib.getExe pkgs.rofi; # TODO: configure rofi
                  HYPRLAND_HYPRPAPER_EXE = lib.getExe self'.packages.hyprpaper;
                  HYPRLAND_QUICKSHELL_EXE = lib.getExe self'.packages.quickshell;
                  # TODO: use hyprcursor
                  XCURSOR_PATH = "${pkgs.capitaine-cursors}/share/icons";
                  XCURSOR_THEME = "capitaine-cursors";
                  XCURSOR_SIZE = "24";
                };
              }
            )
          );
    };
}
