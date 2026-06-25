{ inputs, ... }:
{
  wrap =
    {
      pkgs,
      settings,
      themes ? { },
      languages ? { },
      runtimePkgs ? [ ],
    }:
    inputs.wrapper-modules.wrappers.helix.wrap {
      inherit pkgs;
      package = pkgs.helix;
      inherit
        runtimePkgs
        settings
        themes
        languages
        ;
    };
}
