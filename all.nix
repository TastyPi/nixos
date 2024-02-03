{
  system.stateVersion = "23.11";

  imports = [
    ./all/boot.nix
    ./all/git.nix
    ./all/locale.nix
    ./all/users.nix
    ./all/zsh.nix
  ];

  documentation.enable = false;
  hardware.enableAllFirmware = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.autoUpgrade.flake = "github:TastyPi/nixos/main";
}
