{ self, inputs, ... }:
{
  perSystem =
    {
      system,
      pkgs,
      ...
    }:
    {
      # Builds a live ISO of this repo's Hyprland desktop for the current
      # system. From an aarch64 machine: `nix build .#iso` (native); for
      # another arch, `nix build .#packages.<system>.iso`.
      packages.iso = self.lib.platformGuard {
        inherit pkgs;
        name = "iso";
        body =
          let
            iso = inputs.nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                # Provides config.system.build.isoImage (a live bootable CD,
                # not the installer). Imported by path because the cd-dvd
                # installer modules are not part of nixpkgs' `nixosModules`
                # set on this channel.
                (inputs.nixpkgs.outPath + "/nixos/modules/installer/cd-dvd/iso-image.nix")

                # The full Hyprland desktop from this repo. The ISO-specific
                # filesystem and boot overrides (mkImageMediaOverride,
                # priority 60) win over the plain values set here, just like
                # on-disk installs.
                self.nixosModules.desktop

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
