{ lib, pkgs, ... }:
with builtins;
with lib.attrsets;
let
  motherboard = "/dev/disk/by-path/pci-0000:00:17.0-ata-";
  card = "/dev/disk/by-path/pci-0000:01:00.0-ata-";
  drivePaths = {
    m1 = "${motherboard}1-part3";
    m2 = "${motherboard}2";
    #m3 = "${motherboard}3";
    m4 = "${motherboard}4";
    #m5 = "${motherboard}5";
    m6 = "${motherboard}6";
    c1 = "${card}1";
    c2 = "${card}2";
  };
  drives = mapAttrsToList (name: value: name) drivePaths;
in
{
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/data" ];
  };
  systemd = rec {
    mounts = let cryptsetups = map (name: "${name}.service") (attrNames services); in [{
      after = cryptsetups;
      before = [ "umount.target" ];
      bindsTo = cryptsetups;
      conflicts = [ "umount.target" ];
      type = "btrfs";
      unitConfig.DefaultDependencies = "no";
      what = "/dev/mapper/${head (attrNames drivePaths)}";
      where = "/data";
    }];
    services = concatMapAttrs
      (name: path: {
        "cryptsetup-${name}" = {
          serviceConfig = {
            ExecStart = "${pkgs.systemd}/bin/systemd-cryptsetup attach '${name}' '${path}' /root/keyfiles/data 'luks,key-slot=1'";
            ExecStop = "${pkgs.systemd}/bin/systemd-cryptsetup detach '${name}'";
            RemainAfterExit = true;
            TimeoutSec = 0;
            Type = "oneshot";
          };
          unitConfig = {
            After = [ "systemd-random-seed-load.service" "systemd-readahead-collect.service" "systemd-readahead-replay.service" ];
            Before = [ "cryptsetup.target" "umount.target" ];
            Conflicts = [ "umount.target" ];
            DefaultDependencies = "no";
            PartOf = "data.mount";
          };
        };
      })
      drivePaths;
  };
}
