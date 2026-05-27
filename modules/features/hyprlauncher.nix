{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprlauncher =
        inputs.hyprlauncher.packages.${pkgs.stdenv.hostPlatform.system}.hyprlauncher;
    };
}
