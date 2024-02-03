let
  hostName = "desktop";
in
{
  imports = [
    ./modules/1password.nix
    ./modules/amdcpu.nix
    ./modules/amdgpu.nix
    ./modules/boot.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/locale.nix
    ./modules/pipewire.nix
    ./modules/users.nix
    ./modules/zsh.nix
  ];
  boot.initrd.luks.devices.root.device = "/dev/disk/by-partlabel/root";
  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };
  networking.hostName = hostName;
  nixpkgs.hostPlatform = "x86_64-linux";
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    operation = "boot";
  };
}
