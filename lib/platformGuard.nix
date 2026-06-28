{ lib }:
{
  name,
  pkgs,
  body,
}:
if pkgs.stdenv.hostPlatform.isLinux then
  body
else
  pkgs.runCommand "${name}-wrapper"
    {
      meta = {
        platforms = lib.platforms.linux;
        badPlatforms = lib.platforms.darwin;
      };
    }
    ''
      echo "${name} is not supported on ${pkgs.stdenv.hostPlatform.system}" >&2
      exit 1
    ''
