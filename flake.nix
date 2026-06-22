{
  description = "Bleeding Edge NixOS Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # <https://github.com/nix-systems/nix-systems>
    systems.url = "github:nix-systems/default-linux";

    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    hyprutils = {
      url = "github:hyprwm/hyprutils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprwayland-scanner = {
      url = "github:hyprwm/hyprwayland-scanner";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprland-protocols = {
      url = "github:hyprwm/hyprland-protocols";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprgraphics = {
      url = "github:hyprwm/hyprgraphics";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprwire = {
      url = "github:hyprwm/hyprwire";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
      };
    };

    aquamarine = {
      url = "github:hyprwm/aquamarine";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprtoolkit = {
      url = "github:hyprwm/hyprtoolkit";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.follows = "aquamarine";
        hyprgraphics.follows = "hyprgraphics";
        hyprlang.follows = "hyprland";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprland-guiutils = {
      url = "github:hyprwm/hyprland-guiutils";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.follows = "aquamarine";
        hyprgraphics.follows = "hyprgraphics";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
        hyprtoolkit.follows = "hyprtoolkit";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.follows = "aquamarine";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
        hyprland-protocols.follows = "hyprland-protocols";
        hyprlang.follows = "hyprlang";
        hyprgraphics.follows = "hyprgraphics";
        hyprwire.follows = "hyprwire";
        hyprland-guiutils.follows = "hyprland-guiutils";
      };
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprland-protocols.follows = "hyprland-protocols";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.follows = "aquamarine";
        hyprgraphics.follows = "hyprgraphics";
        hyprtoolkit.follows = "hyprtoolkit";
        hyprlang.follows = "hyprlang";
        hyprwire.follows = "hyprwire";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprgraphics.follows = "hyprgraphics";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprland-protocols.follows = "hyprland-protocols";
        hyprlang.follows = "hyprlang";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprshutdown = {
      url = "github:hyprwm/hyprshutdown";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.follows = "aquamarine";
        hyprgraphics.follows = "hyprgraphics";
        hyprtoolkit.follows = "hyprtoolkit";
        hyprutils.follows = "hyprutils";
      };
    };

    hyprlauncher = {
      url = "github:hyprwm/hyprlauncher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        aquamarine.follows = "aquamarine";
        hyprgraphics.follows = "hyprgraphics";
        hyprlang.follows = "hyprlang";
        hyprwire.follows = "hyprwire";
        hyprtoolkit.follows = "hyprtoolkit";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        hyprutils.follows = "hyprutils";
        hyprwayland-scanner.follows = "hyprwayland-scanner";
      };
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
