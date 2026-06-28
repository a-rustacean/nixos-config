{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (builtins) readDir;

  wrapPackage = inputs.wrapper-modules.lib.wrapPackage;

  root = toString ./..;

  generators = import (root + "/lib/generators.nix") { inherit lib; };

  catppuccin = import (root + "/lib/catppuccin.nix") { };

  platformGuard = import (root + "/lib/platformGuard.nix") { inherit lib; };

  mkStoreConfigWrapper =
    (import (root + "/lib/mkStoreConfigWrapper.nix") { inherit lib; }).mkStoreConfigWrapper;

  mkHyprWrapper = import (root + "/lib/mkHyprWrapper.nix") {
    inherit
      self
      wrapPackage
      platformGuard
      ;
  };

  wrappersDir = root + "/lib/wrappers";

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
          mkHyprWrapper
          platformGuard
          mkStoreConfigWrapper
          ;
      }
    )
  ) wrapperFiles;
in
{
  flake.lib = {
    inherit
      generators
      wrappers
      wrapPackage
      platformGuard
      mkStoreConfigWrapper
      ;
    colors = { inherit catppuccin; };
  };
}
