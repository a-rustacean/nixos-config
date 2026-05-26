{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.quickshell = inputs.wrapper-modules.wrappers.quickshell.wrap {
        inherit pkgs;
        runtimePkgs = [ pkgs.nerd-fonts.jetbrains-mono ];
        configDir = "${../../quickshell}";
      };
    };
}
