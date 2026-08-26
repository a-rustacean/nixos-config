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
        btop
        cava
        oh-my-posh
      ];
    in
    {
      imports = modules;
    };
}
