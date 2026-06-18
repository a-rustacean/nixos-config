{ inputs, ... }:
{
  systems = builtins.attrNames inputs.nixpkgs.legacyPackages;
}
