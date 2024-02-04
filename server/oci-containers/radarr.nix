{ config, ... }:
with builtins;
rec {
  imports = [ ../options.nix ];

  users = {
    users.radarr = {
      isSystemUser = true;
      uid = 804;
      group = "media";
    };
  };
  
  systemd.services.podman-radarr = {
    after = [ "data.mount" ];
    requires = [
      "data.mount"
      "podman-prowlarr.service"
      "podman-transmission.service"
    ];
  };
  
  tastypi.caddy.radarr = {
    authelia = true;
    endpoint = "radarr:7878";
  };
  
  virtualisation.oci-containers.containers.radarr = {
    image = "lscr.io/linuxserver/radarr:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    environment = {
      PUID = toString users.users.radarr.uid;
      PGID = toString config.users.groups.media.gid;
      UMASK = "002";
    };
    volumes = [
      "/data/oci-containers/radarr/config:/config:rw"
      "/data/files/media:/media:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
