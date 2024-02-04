{
  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        modules = [ ./all.nix ./desktop.nix ];
      };
      server = nixpkgs.lib.nixosSystem {
        modules = [ ./all.nix ./server.nix ];
      };
    };
  };
}
