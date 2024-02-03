{
  outputs = { nixpkgs, self, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        modules = [
          ./common.nix
          ./desktop.nix
          { 
            system.autoUpgrade = {
              flags = [
                "--update-input"
                "nixpkgs"
              ];
              flake = self.outPath;
            };
          }
        ];
      };
    };
  };
}
