{ inputs, ... }:
{
  wrap =
    {
      pkgs,
      zshrc,
      runtimePkgs ? [ ],
    }:
    inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;
      package = pkgs.zsh;
      inherit runtimePkgs;
      zshrc.content = zshrc;
    };
}
