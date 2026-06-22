{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.quickshell = self.lib.wrappers.quickshell.wrap {
        inherit pkgs;
        runtimePkgs = [ pkgs.jq ];
        configDir = "${../../quickshell}";
        env.XDG_DATA_DIRS = "${pkgs.nerd-fonts.jetbrains-mono}/share";
      };
    };
}
