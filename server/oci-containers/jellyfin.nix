{ config, ... }:
with builtins;
rec {
  imports = [ ../options.nix ];

  systemd.services.podman-jellyfin = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };
  
  tastypi.caddy.jellyfin.endpoint = "jellyfin:8096";
  
  users = rec {
    users.jellyfin = {
      isSystemUser = true;
      uid = 801;
      group = "media";
    };
  };
  
  virtualisation.oci-containers.containers.jellyfin = {
    image = "docker.io/jellyfin/jellyfin:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.jellyfin.uid}:${toString config.users.groups.media.gid}";
    volumes = [
      "/data/files/media:/media:rw"
      "/data/oci-containers/jellyfin/cache:/cache:rw"
      "/data/oci-containers/jellyfin/config:/config:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment = {
      #JELLYFIN_CONFIG_DIR = "/config";
      #JELLYFIN_DATA_DIR = "/data";
      #JELLYFIN_LOG_DIR = "/log";
      #JELLYFIN_CACHE_DIR = "/cache";
    };
    extraOptions = [
      "--device=/dev/dri:/dev/dri"
    ];
  };  
}
