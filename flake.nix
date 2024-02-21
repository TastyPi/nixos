{
  outputs = { self, nixpkgs }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
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
