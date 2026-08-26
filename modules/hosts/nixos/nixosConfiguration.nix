{ self, ... }:
{
  flake.nixosModules.nixosConfiguration =
    { ... }:
    {
      imports = [
        self.nixosModules.hardwareConfig
        self.nixosModules.vm
      ];

      networking.hostName = "nixos";
      networking.firewall.allowedTCPPorts = [
        80
        443
        8080
        8000
      ];
    };
}
