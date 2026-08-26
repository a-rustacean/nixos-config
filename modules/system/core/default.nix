{ self, ... }:
{
  flake.nixosModules.core =
    { pkgs, ... }:
    let
      modules = with self.nixosModules; [
        bootloader
        nix
        locale
        user
      ];
    in
    {
      imports = modules;
      services.openssh.enable = true;
      environment.systemPackages = with pkgs; [
        nh
        firefox
      ];
      system.stateVersion = "26.05";
    };
}
