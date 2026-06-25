{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.opencode = self.lib.wrappers.opencode.wrap {
        inherit pkgs;
        tui = {
          theme = "catppuccin";
        };
      };
    };
}
