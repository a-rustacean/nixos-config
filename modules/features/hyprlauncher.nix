{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprlauncher = pkgs.hyprlauncher;
    };
}
