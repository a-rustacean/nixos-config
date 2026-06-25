{ self, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.opencode = self.lib.wrappers.opencode.wrap {
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
          lsp = true;
        };
        tui = {
          theme = "catppuccin";
        };
      };
    };
}
