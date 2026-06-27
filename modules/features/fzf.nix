{ self, ... }:
let
  ctp = self.lib.colors.catppuccin.mocha;
in
{
  perSystem =
    { pkgs, ... }:
    {
      packages.fzf = self.lib.wrappers.fzf.wrap {
        inherit pkgs;
        settings = {
          color = {
            bg = "-1";
            fg = ctp.text;
            header = ctp.red;
            "bg+" = ctp.surface0;
            "fg+" = ctp.text;
            "hl+" = ctp.red;
            prompt = ctp.mauve;
            border = ctp.surface0;
            info = ctp.surface2;
            spinner = ctp.pink;
            pointer = ctp.mauve;
            marker = ctp.pink;
            hl = ctp.red;
            gutter = "-1";
          };
          layout = "reverse";
          border = "rounded";
          height = "40%";
        };
      };
    };
}
