{ self, ... }:
{
  flake.nixosModules.config =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.hardwareConfig
        self.nixosModules.hyprland
        self.nixosModules.vm
      ];
      system.stateVersion = "26.05";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      nix.settings = {
        substituters = [
          "https://hyprland.cachix.org"
          "https://helix.cachix.org"
        ];
        trusted-substituters = [
          "https://hyprland.cachix.org"
          "https://helix.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        ];

        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      nixpkgs.config.allowUnfree = true;

      # TODO: replace the hardcoded `work`
      networking.hostName = "work";
      networking.networkmanager.enable = true;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          80
          443
          8080
          8000
        ];
      };

      # TODO: remove hardcoded
      time.timeZone = "Asia/Kolkata";

      # TODO: remove Ly
      services.displayManager.ly.enable = true;

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

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

      programs.dconf.enable = true;
      programs.nix-ld.enable = true;

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.helix
        self.packages.${pkgs.stdenv.hostPlatform.system}.git
        pkgs.gitui
      ];

      services.openssh.enable = true;
    };
}
