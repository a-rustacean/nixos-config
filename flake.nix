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

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprland-protocols.follows = "hyprland/hyprland-protocols";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.aquamarine.follows = "hyprland/aquamarine";
      inputs.hyprgraphics.follows = "hyprland/hyprgraphics";
      inputs.hyprtoolkit.follows = "hyprland/hyprland-guiutils/hyprtoolkit";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprwire.follows = "hyprland/hyprwire";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprgraphics.follows = "hyprland/hyprgraphics";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
    };

    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.hyprland-protocols.follows = "hyprland/hyprland-protocols";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
    };

    hyprshutdown = {
      url = "github:hyprwm/hyprshutdown";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.aquamarine.follows = "hyprland/aquamarine";
      inputs.hyprgraphics.follows = "hyprland/hyprgraphics";
      inputs.hyprtoolkit.follows = "hyprland/hyprland-guiutils/hyprtoolkit";
      inputs.hyprutils.follows = "hyprland/hyprutils";
    };

    hyprlauncher = {
      url = "github:hyprwm/hyprlauncher";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "hyprland/systems";
      inputs.aquamarine.follows = "hyprland/aquamarine";
      inputs.hyprgraphics.follows = "hyprland/hyprgraphics";
      inputs.hyprlang.follows = "hyprland/hyprlang";
      inputs.hyprwire.follows = "hyprland/hyprwire";
      inputs.hyprtoolkit.follows = "hyprland/hyprland-guiutils/hyprtoolkit";
      inputs.hyprutils.follows = "hyprland/hyprutils";
      inputs.hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
