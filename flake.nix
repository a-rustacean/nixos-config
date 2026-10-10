{
  description = "Bleeding Edge NixOS Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    extra-substituters = ["https://a-rustacean-nixos-config-cache.cachix.org"];
    extra-trusted-public-keys = ["a-rustacean-nixos-config-cache.cachix.org-1:Q4ttHUKuQxZZjVm+ujZOW0ioOdAvI1qbIQNVx9Hsfh8="];
  };
}
