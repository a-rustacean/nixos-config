{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.helix = inputs.wrapper-modules.wrappers.helix.wrap {
        inherit pkgs;
        package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix;
        settings = {
          theme = "everblush_inherit_bg";
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
          everblush_inherit_bg = {
            inherits = "everblush";
            "ui.background" = { };
          };
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
