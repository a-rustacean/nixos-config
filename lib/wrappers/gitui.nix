{
  self,
  lib,
  wrapPackage,
  ...
}:
let
  renderGitValue = v: if builtins.isBool v then lib.boolToString v else toString v;

  toGitconfig =
    attrs:
    lib.concatStringsSep "\n" (
      lib.flatten (
        lib.mapAttrsToList (
          section: values:
          let
            simple = lib.filterAttrs (_: v: !builtins.isAttrs v) values;
            subsections = lib.filterAttrs (_: v: builtins.isAttrs v) values;

            simpleLines = map (key: "\t${key} = ${renderGitValue simple.${key}}") (builtins.attrNames simple);
            subsectionLines = lib.flatten (
              map (
                subkey:
                let
                  subvalues = subsections.${subkey};
                in
                [ "[${section} \"${subkey}\"]" ]
                ++ map (key: "\t${key} = ${renderGitValue subvalues.${key}}") (builtins.attrNames subvalues)
              ) (builtins.attrNames subsections)
            );
          in
          [ "[${section}]" ] ++ simpleLines ++ subsectionLines
        ) attrs
      )
    );

  gitconfigFile = pkgs: gitConfig: pkgs.writeText "gitconfig" (toGitconfig gitConfig);
in
{
  wrap =
    {
      pkgs,
      theme,
      gitConfig ? { },
      runtimePkgs ? [ ],
    }:
    wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.gitui;
        inherit runtimePkgs;
        flags = {
          "-t" = pkgs.writeText "theme.ron" (self.lib.generators.toGituiTheme theme);
        };
        env = {
          GIT_CONFIG_GLOBAL = gitconfigFile pkgs gitConfig;
        };
      }
    );
}
