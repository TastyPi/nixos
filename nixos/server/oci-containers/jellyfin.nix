{ config, ... }:
with builtins;
let
  jellyfin = { name, image ? "docker.io/jellyfin/jellyfin:latest", uid, volumes }: {
    image = image;
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString uid}:${toString config.users.groups.media.gid}";
    volumes = [
      "/data/oci-containers/jellyfin/${name}/cache:/cache:rw"
      "/data/oci-containers/jellyfin/${name}/config:/config:rw"
      "/etc/localtime:/etc/localtime:ro"
    ] ++ volumes;
    extraOptions = [ "--device=/dev/dri:/dev/dri" ];
  };
in
rec {
  imports = [ ../options.nix ];

  systemd.services = {
    podman-jellyfin = {
      after = [ "data.mount" ];
      requires = [ "data.mount" ];
    };
    podman-tastypi-tv = {
      after = [ "data.mount" ];
      requires = [ "data.mount" ];
    };
  };

  tastypi.caddy.jellyfin.endpoint = "jellyfin:8096";

  users = rec {
    users.jellyfin = {
      isSystemUser = true;
      uid = 801;
      group = "media";
    };
    users.tastypi-tv = {
      isSystemUser = true;
      uid = 812;
      group = "media";
    };
  };

  virtualisation.oci-containers.containers = {
    jellyfin = jellyfin {
      name = "rogers.me.uk";
      uid = users.users.jellyfin.uid;
      volumes = [ "/data/files/media:/media:rw" ];
    };
    tastypi-tv = jellyfin {
      name = "tastypi.tv";
      uid = users.users.tastypi-tv.uid;
      volumes = [ "/data/files/media/oxsc:/media:ro" ];
    };
  };
}
