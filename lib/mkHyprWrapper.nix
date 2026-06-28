{
  self,
  wrapPackage,
  platformGuard,
}:
name: {
  wrap =
    {
      pkgs,
      settings,
      package ? pkgs.${name},
      runtimePkgs ? [ ],
      extraFlags ? { },
      extraConfig ? "",
      importantPrefixes ? [ "$" ],
    }:
    platformGuard {
      inherit pkgs name;
      body = wrapPackage (
        { ... }:
        {
          inherit pkgs package runtimePkgs;
          flags = {
            "--config" = pkgs.writeText "${name}.conf" (
              (self.lib.generators.toHyprconf {
                attrs = settings;
                inherit importantPrefixes;
              })
              + extraConfig
            );
          }
          // extraFlags;
        }
      );
    };
}
