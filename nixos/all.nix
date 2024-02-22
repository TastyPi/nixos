{
  system.stateVersion = "23.11";

  imports = [
    ./all/archives.nix
    ./all/boot.nix
    ./all/git.nix
    ./all/locale.nix
    ./all/users.nix
    ./all/zsh.nix
  ];

  documentation.enable = false;
  hardware.enableAllFirmware = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.flake = "github:TastyPi/nixos/main";
}
