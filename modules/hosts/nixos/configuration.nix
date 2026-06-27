{ self, ... }:
{
  flake.nixosModules.config =
    { pkgs, ... }:
    {
      imports = [
        self.nixosModules.hardwareConfig
        self.nixosModules.hyprland
        self.nixosModules.git
        self.nixosModules.vm
      ];
      system.stateVersion = "26.05";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;

      nix.settings = {
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

      environment.systemPackages =
        (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
          helix
          git
          vesktop
          gitui
          cava
          btop
          fzf
          fastfetch
          opencode
        ])
        ++ [
          pkgs.nh
          pkgs.firefox
        ];

      services.openssh.enable = true;
    };
}
