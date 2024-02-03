{
  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        modules = [ ./all.nix ./desktop.nix ];
      };
    };
  };
}
