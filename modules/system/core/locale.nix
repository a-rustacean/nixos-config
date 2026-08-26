{ ... }:
{
  flake.nixosModules.locale =
    { ... }:
    {
      # TODO: remove hardcoded
      time.timeZone = "Asia/Kolkata";
    };
}
