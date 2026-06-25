{ inputs, ... }:
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      package = pkgs.git;
      inherit runtimePkgs settings;
    };
}
