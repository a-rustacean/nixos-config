{ self, ... }:
{
  flake.nixosModules.development =
    { ... }:
    let
      modules = with self.nixosModules; [
        git
        gitui
        helix
        opencode
        fzf
        zsh
        ghostty
        fastfetch
        fetch
        btop
        cava
        oh-my-posh
      ];
    in
    {
      imports = modules;
    };
}
