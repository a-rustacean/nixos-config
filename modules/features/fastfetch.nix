{ self, ... }:
let
  ctp = self.lib.generators.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.fastfetch = self.lib.wrappers.fastfetch.wrap {
        inherit pkgs;
        settings = {
          modules = [
            "title"
            "separator"
            "os"
            "host"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "terminal"
            "cpu"
            "gpu"
            "memory"
            "disk"
            "localip"
            "separator"
            "colors"
          ];
          display = {
            separator = " → ";
            color = ctp.mauve;
            key = {
              color = ctp.teal;
            };
          };
        };
      };
    };
}
