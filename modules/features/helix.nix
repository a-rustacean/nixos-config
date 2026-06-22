{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.helix = inputs.wrapper-modules.wrappers.helix.wrap {
        inherit pkgs;
        package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix;
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
          theme = "nix-theme";
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
        themes = {
          "nix-theme" = fromTOML (
            builtins.readFile (
              (pkgs.callPackage inputs.base16.lib { }).mkSchemeAttrs
                # TODO: replace hardcoded
                "${inputs.tt-schemes}/base24/catppuccin-mocha.yaml"
                {
                  templateRepo = inputs.base16-helix;
                  target = "base24";
                }
            )
          );
        };
        languages = {
          language =
            (map
              (lang: {
                name = lang;
                formatter.command = lib.getExe pkgs.oxfmt;
                auto-format = true;
              })
              [
                "javascript"
                "jsx"
                "typescript"
                "tsx"
                "json"
                "jsonc"
                "json5"
                "yaml"
                "toml"
                "html"
                "vue"
                "svelte"
                "css"
                "scss"
                "less"
                "markdown"
                "graphql"
              ]
            )
            ++ [
              {
                name = "nix";
                formatter.command = lib.getExe pkgs.nixfmt;
                auto-format = true;
              }
            ];
        };
      };
    };
}
