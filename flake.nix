{
  outputs = { nixpkgs, self, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        modules = [ ./common.nix ./desktop.nix ];
      };
    };
  };
}
