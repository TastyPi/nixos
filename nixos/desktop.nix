{ ... }:
{
  system = "x86_64-linux";
  modules = [
    ../hardware/amdcpu.nix
    ../hardware/amdgpu.nix
    ../hardware/pipewire.nix

    ./all.nix
    ./desktop/adb.nix
    ./desktop/chat.nix
    ./desktop/gnome.nix
    ./desktop/picard.nix
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
    }
  ];
}
