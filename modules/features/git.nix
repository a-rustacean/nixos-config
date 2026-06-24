{ self, ... }:
let
  settings = {
    user = {
      email = "a-rustacean@outlook.com";
      name = "Dilshad";
      signingKey = "95BBBA7922AE1CEC";
    };
    commit = {
      gpgSign = true;
    };
    init = {
      defaultBranch = "main";
    };
    tag = {
      gpgSign = true;
    };
  };
in
{
  flake.lib.git = {
    inherit settings;
  };

  flake.nixosModules.git =
    { pkgs, ... }:
    {
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

  perSystem =
    { pkgs, lib, ... }:
    {
      packages.git =
        let
          lfsPath = lib.getExe pkgs.git-lfs;
        in
        self.lib.wrappers.git.wrap {
          inherit pkgs;
          runtimePkgs = [ pkgs.gnupg ];
          settings = settings // {
            filter.lfs = {
              required = true;
              clean = "${lfsPath} clean -- %f";
              process = "${lfsPath} filter-process --skip";
              smudge = "${lfsPath} smudge --skip -- %f";
            };
          };
        };
    };
}
