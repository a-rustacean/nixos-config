{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    let
      renderValue =
        v:
        if builtins.isBool v then
          ""
        else if builtins.isString v then
          v
        else
          toString v;

      renderOpt =
        name: value:
        if builtins.isAttrs value then
          let
            parts = lib.mapAttrsToList (k: v: "${k}:${renderValue v}") value;
          in
          "--${name}=${lib.concatStringsSep "," parts}"
        else if builtins.isBool value then
          lib.optionalString value "--${name}"
        else
          "--${name}=${renderValue value}";

      fzfOpts = lib.concatStringsSep " " (lib.mapAttrsToList renderOpt settings);
    in
    inputs.wrapper-modules.lib.wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.fzf;
        inherit runtimePkgs;
        env = lib.optionalAttrs (fzfOpts != "") {
          FZF_DEFAULT_OPTS = fzfOpts;
        };
      }
    );
}
