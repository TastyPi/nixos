{ home-manager, ... }:
{
  system = "x86_64-linux";
  modules = [
    home-manager.nixosModules.home-manager

    ../hardware/amdcpu.nix
    ../hardware/amdgpu.nix
    ../hardware/pipewire.nix

    ./all.nix
    ./desktop/adb.nix
    ./desktop/gnome.nix
    ./desktop/mkvtoolnix.nix
    ./desktop/picard.nix
    ./desktop/vm.nix
    {
      networking.hostName = "desktop";

      # Disks
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

      # Networking
      networking.networkmanager.enable = true;

      # Auto-upgrade
      system.autoUpgrade = {
        enable = true;
        dates = "daily";
        # Don't want to suddenly switch while using the machine
        operation = "boot";
      };

      home-manager.users.graham = import ../home/graham/desktop.nix;
    }
  ];
}
