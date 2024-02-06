with builtins;
rec {
  imports = [ ../options.nix ];

  users = rec {
    groups.syncthing.gid = users.syncthing.uid;
    users.syncthing = {
      isSystemUser = true;
      uid = 811;
      group = "syncthing";
    };
  };
  
  systemd.services.podman-syncthing = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };
  
  tastypi.caddy.syncthing = {
    authelia.enable = true;
    endpoint = "192.168.1.2:8384";
  };
  
  virtualisation.oci-containers.containers.syncthing = {
    image = "docker.io/syncthing/syncthing";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.syncthing.uid}:${toString users.groups.syncthing.gid}";
    volumes = [
      "/data/oci-containers/syncthing/data:/data:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
    extraOptions = [ "--network=host" ];
  };
}
