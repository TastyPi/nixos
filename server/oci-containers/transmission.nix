{ config, ...}:
with builtins;
rec {
  imports = [ ../options.nix ];

  systemd.services.podman-transmission = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };
  
  tastypi.caddy.transmission = {
    authelia.enable = true;
    endpoint = "transmission:9091";
  };
  
  users = {
    users.transmission = {
      isSystemUser = true;
      uid = 803;
      group = "media";
    };
  };
  
  virtualisation.oci-containers.containers.transmission = {
    image = "lscr.io/linuxserver/transmission:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    environment = {
      PUID = toString users.users.transmission.uid;
      PGID = toString config.users.groups.media.gid;
      UMASK = "002";
    };
    volumes = [
      "/data/oci-containers/transmission/config:/config"
      "/data/oci-containers/transmission/watch:/watch"
      "/data/files/media/transmission:/downloads:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
