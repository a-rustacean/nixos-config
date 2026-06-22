{ self, ... }:
{
  # TODO: setup gpg agent
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
          settings = {
            commit.gpgSign = true;
            init.defaultBranch = "main";
            tag.gpgSign = true;
            # TODO: remove hard coded values
            user = {
              email = "a-rustacean@outlook.com";
              name = "Dilshad";
              signingKey = "95BBBA7922AE1CEC";
            };
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
