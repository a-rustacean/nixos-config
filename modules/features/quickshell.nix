{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.quickshell = inputs.wrapper-modules.wrappers.quickshell.wrap {
        inherit pkgs;
        configDir = "${../../quickshell}";
        env.XDG_DATA_DIRS = "${pkgs.nerd-fonts.jetbrains-mono}/share";
      };
    };
}
