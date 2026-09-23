{ self, inputs, ... }:
{
  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    {
      packages.iso = self.lib.platformGuard {
        inherit pkgs;
        name = "iso";
        body =
          let
            iso = inputs.nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                (inputs.nixpkgs.outPath + "/nixos/modules/installer/cd-dvd/iso-image.nix")

                self.nixosModules.desktop
                self.nixosModules.development

                {
                  # Boot as EFI and from a USB stick, in addition to BIOS.
                  isoImage.makeEfiBootable = true;
                  isoImage.makeUsbBootable = true;

                  isoImage.edition = "hyprland";
                  isoImage.appendToMenuLabel = " Live System";

                  # Live media must work on arbitrary hardware.
                  hardware.enableAllHardware = true;
                }
              ];
            };
          in
          iso.config.system.build.isoImage;
      };
    };
}
