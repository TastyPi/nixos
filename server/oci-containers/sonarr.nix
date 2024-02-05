{ config, ... }:
with builtins;
rec {
  imports = [ ../options.nix ];

  users = {
    users.sonarr = {
      isSystemUser = true;
      uid = 807;
      group = "media";
    };
  };
  
  systemd.services.podman-sonarr = {
    after = [ "data.mount" ];
    requires = [
      "data.mount"
      "podman-prowlarr.service"
      "podman-transmission.service"
    ];
  };
  
  tastypi.caddy.sonarr = {
    authelia.enable = true;
    endpoint = "sonarr:8989";
  };
  
  virtualisation.oci-containers.containers.sonarr = {
    image = "lscr.io/linuxserver/sonarr:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    environment = {
      PUID = toString users.users.sonarr.uid;
      PGID = toString config.users.groups.media.gid;
      UMASK = "002";
    };
    volumes = [
      "/data/oci-containers/sonarr/config:/config:rw"
      "/data/files/media:/media:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
