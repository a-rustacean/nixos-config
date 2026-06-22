{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.flake.lib = mkOption {
    type = types.lazyAttrsOf types.raw;
    default = { };
    description = "Library functions";
  };
}
