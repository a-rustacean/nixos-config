{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.helix = self.lib.wrappers.helix.wrap {
        inherit pkgs;
        runtimePkgs = with pkgs; [
          typescript-language-server
          vscode-langservers-extracted
          bash-language-server
          lua-language-server
          nixd
          just-lsp
          taplo
        ];
        settings = {
          theme = "catppuccin_mocha";
          editor = {
            line-number = "relative";
            true-color = true;
            rulers = [
              80
              100
            ];
            cursor-shape.insert = "bar";
            file-picker.hidden = false;

            statusline = {
              left = [
                "mode"
                "spinner"
                "spacer"
                "spacer"
                "version-control"
              ];
              center = [
                "file-base-name"
                "file-modification-indicator"
              ];
              right = [
                "diagnostics"
                "selections"
                "position"
                "file-encoding"
                "file-line-ending"
                "file-type"
              ];
              separator = "|";
              mode.normal = "NOR";
              mode.insert = "INS";
              mode.select = "SEL";
            };

            lsp = {
              enable = true;
              display-messages = true;
              display-inlay-hints = true;
            };

            whitespace.render = {
              space = "all";
              nbsp = "all";
              tab = "all";
              newline = "none";
              tabpad = "all";
            };
          };
        };
      };
    };
}
