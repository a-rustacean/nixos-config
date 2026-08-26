{ self, ... }:
{
  flake.nixosModules.user =
    { pkgs, ... }:
    {
      # TODO: replace the hardcoded user
      users.users.dilshad = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = [ ];
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.zsh;
        initialPassword = "dilshad"; # username is the default password
      };
    };
}
