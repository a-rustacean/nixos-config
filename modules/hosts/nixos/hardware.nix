{ ... }:
{
  flake.nixosModules.hardwareConfig =
    {
      lib,
      modulesPath,
      ...
    }:

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
        device = "/dev/disk/by-uuid/ad75ec6d-9c8d-4be3-af77-fdb63f34f3a5";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/DE51-D34B";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/9a59c532-24bf-4502-bd4f-786a77134638"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    };
}
