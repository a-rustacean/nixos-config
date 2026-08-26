{ self, ... }:
{
  flake.nixosModules.systemTheme =
    { ... }:
    let
      modules = with self.nixosModules; [
        catppuccinGtk
      ];
    in
    {
      imports = modules;
    };
}
