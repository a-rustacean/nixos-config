{ ... }:
{
  flake.nixosModules.hardwareConfig =
    { lib, modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/profiles/qemu-guest.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "virtio_pci"
        "usbhid"
        "usb_storage"
        "sr_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/283b6d4e-8215-4c1b-9f36-08f7766452a8";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/E872-E664";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/7683536d-35f8-4af1-ab6f-81705b6714c5"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
      hardware.graphics.enable = true;
    };
}
