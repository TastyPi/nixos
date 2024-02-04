{ config, ... }:
with builtins;
rec {
  imports = [ ../options.nix ];
  
  systemd.services.podman-matter = {
    after = [ "data.mount" ];
    requires = [ "data.mount" "dbus.service" ];
  };
  
  virtualisation.oci-containers.containers.matter = {
    image = "ghcr.io/home-assistant-libs/python-matter-server:stable";
    labels = { "io.containers.autoupdate" = "registry"; };
    volumes = [
      "/data/oci-containers/matter/data:/data:rw"
      "/run/dbus:/run/dbus:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
    extraOptions = [
      "--network=host"
      "--security-opt"
      "apparmor=unconfined"
    ];
  };
}
