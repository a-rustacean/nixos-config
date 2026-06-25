{ inputs, lib, ... }:
{
  wrap =
    {
      pkgs,
      settings,
      runtimePkgs ? [ ],
    }:
    let
      toBtoprc = attrs:
        lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value:
          let
            rendered = if builtins.isBool value then (if value then "True" else "False") else if builtins.isString value then "\"${value}\"" else toString value;
          in
          "${name} = ${rendered}"
        ) attrs);

      btopConfigDir = pkgs.symlinkJoin {
        name = "btop-config";
        paths = [
          (pkgs.writeTextDir "btop/btop.conf" (toBtoprc settings))
          (pkgs.runCommandLocal "btop-themes" { } ''
            mkdir -p "$out/btop/themes"
            for f in ${inputs.catppuccin-btop}/themes/*.theme; do
              ln -s "$f" "$out/btop/themes/$(basename "$f")"
            done
          '')
        ];
      };
    in
    inputs.wrapper-modules.lib.wrapPackage (
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
