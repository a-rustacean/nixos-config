{ self, inputs, ... }:
{
  # TODO: replace the hardcoded `work`
  flake.nixosConfigurations.work = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.config ];
  };
}
