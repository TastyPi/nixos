{ pkgs, ... }:
{
  boot.initrd.luks.devices.root = {
    fallbackToPassword = true;
    keyFile = "/dev/disk/by-partlabel/keyfile";
  };
  systemd.services = {
    lock-root = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "-${pkgs.cryptsetup}/bin/cryptsetup luksKillSlot --key-file /root/keyfiles/root /dev/disk/by-partlabel/root 2";
      };
      wantedBy = [ "default.target" ];
    };
    unlock-root = {
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.cryptsetup}/bin/cryptsetup luksAddKey --key-file /root/keyfiles/root --key-slot 2 /dev/disk/by-partlabel/root /dev/disk/by-partlabel/keyfile";
      };
      unitConfig.DefaultDependencies = "no";
      before = [ "reboot.target" ];
      wantedBy = [ "reboot.target" ];
    };
  };
}
