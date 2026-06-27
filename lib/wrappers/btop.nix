{ lib, wrapPackage, ... }:
let
  toBtoprc =
    attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: value:
        let
          rendered =
            if builtins.isBool value then
              (if value then "True" else "False")
            else if builtins.isString value then
              "\"${value}\""
            else
              toString value;
        in
        "${name} = ${rendered}"
      ) attrs
    );
in
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    let
      btopTheme = pkgs.catppuccin.override {
        variant = "mocha";
        themeList = [ "btop" ];
      };

      btopConfigDir = pkgs.symlinkJoin {
        name = "btop-config";
        paths = [
          (pkgs.writeTextDir "btop/btop.conf" (toBtoprc settings))
          (pkgs.runCommandLocal "btop-themes" { } ''
            mkdir -p "$out/btop/themes"
            ln -s ${btopTheme}/btop/catppuccin_mocha.theme "$out/btop/themes/catppuccin_mocha.theme"
          '')
        ];
      };
    in
    wrapPackage (
      { ... }: {
        inherit pkgs;
        package = pkgs.btop;
        inherit runtimePkgs;
        env = {
          XDG_CONFIG_HOME = "${btopConfigDir}";
        };
      }
    );
}
