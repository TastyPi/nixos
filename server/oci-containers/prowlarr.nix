with builtins;
rec {
  imports = [ ../options.nix ];

  users = rec {
    groups.prowlarr.gid = users.prowlarr.uid;
    users.prowlarr = {
      isSystemUser = true;
      uid = 805;
      group = "prowlarr";
    };
  };
  
  systemd.services.podman-prowlarr = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
    wants = [ "podman-flaresolverr.service" ];
  };
  
  tastypi.caddy.prowlarr = {
    authelia = true;
    endpoint = "prowlarr:9696";
  };
  
  virtualisation.oci-containers.containers.prowlarr = {
    image = "lscr.io/linuxserver/prowlarr:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    environment = {
      PUID = toString users.users.prowlarr.uid;
      PGID = toString users.groups.prowlarr.gid;
    };
    volumes = [
      "/data/oci-containers/prowlarr/config:/config:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
