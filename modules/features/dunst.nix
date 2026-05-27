{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.dunst = pkgs.dunst;
    };
}
