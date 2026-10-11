{ ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages.default =
        pkgs.runCommand "all-packages"
          {
            buildInputs = [
              self'.packages.prismlauncher
              self'.packages.ghostty
              self'.packages.helix
              self'.packages.oh-my-posh
              self'.packages.fetch
            ];
          }
          ''
            touch $out
          '';
    };
}
