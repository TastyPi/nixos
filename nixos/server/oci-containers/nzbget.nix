{ config, ... }:
with builtins;
rec {
  imports = [ ../options.nix ];

  users = {
    users.nzbget = {
      isSystemUser = true;
      uid = 814;
      group = "media";
    };
  };

  systemd.services.podman-nzbget = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };

  tastypi.caddy.nzbget = {
    authelia.enable = true;
    endpoint = "nzbget:6789";
  };

  virtualisation.oci-containers.containers.nzbget = {
    image = "ghcr.io/nzbgetcom/nzbget:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    environment = {
      PUID = toString users.users.nzbget.uid;
      PGID = toString config.users.groups.media.gid;
    };
    volumes = [
      "/data/oci-containers/nzbget/config:/config:rw"
      "/data/files/media/nzbget:/media:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
