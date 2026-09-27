{ self, ... }:
{
  flake.nixosModules.prismlauncher =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.prismlauncher = pkgs.prismlauncher.override {
        prismlauncher-unwrapped = pkgs.prismlauncher-unwrapped.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            ./no-ownership-check.patch
          ];
        });
      };
    };
}
