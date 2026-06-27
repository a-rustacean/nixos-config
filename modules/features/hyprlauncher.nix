{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.hyprlauncher = self.lib.wrappers.hyprlauncher.wrap {
        inherit pkgs;
      };
    };
}
