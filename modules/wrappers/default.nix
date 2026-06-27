{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (builtins) readDir;

  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;

  mkHyprWrapper = wrap: name: {
    wrap =
      {
        pkgs,
        settings,
        runtimePkgs ? [ ],
        extraFlags ? { },
        extraConfig ? "",
        importantPrefixes ? [ "$" ],
      }:
      if pkgs.stdenv.hostPlatform.isLinux then
        wrap (
          { ... }:
          {
            inherit pkgs;
            package = pkgs.${name};
            inherit runtimePkgs;
            flags = {
              "--config" = pkgs.writeText "${name}.conf" (
                (self.lib.generators.toHyprconf {
                  attrs = settings;
                  inherit importantPrefixes;
                })
                + extraConfig
              );
            }
            // extraFlags;
          }
        )
      else
        pkgs.runCommand "${name}-wrapper"
          {
            meta = {
              platforms = lib.platforms.linux;
              badPlatforms = lib.platforms.darwin;
            };
          }
          ''
            echo "${name} is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
            exit 1
          '';
  };

  wrappersDir = ../../lib/wrappers;

  wrapperFiles = lib.filterAttrs (n: v: v == "regular") (readDir wrappersDir);

  wrappers = lib.mapAttrs' (
    name: _:
    lib.nameValuePair (lib.removeSuffix ".nix" name) (
      import (wrappersDir + "/${name}") {
        inherit
          self
          inputs
          lib
          wrapPackage
          ;
        mkHyprWrapper = mkHyprWrapper wrapPackage;
      }
    )
  ) wrapperFiles;
in
{
  flake.lib.wrappers = wrappers;
}
