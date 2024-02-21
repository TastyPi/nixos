{ config, ... }:
with builtins;
let
  filebrowserConfig = { port = 8080; };
in
rec {
  imports = [ ../options.nix ];

  systemd.services.podman-filebrowser = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };

  tastypi.caddy.filebrowser = {
    authelia = {
      enable = true;
      match = { not = [{ path = [ "/api/public/*" "/share/*" "/static/*" ]; }]; };
    };
    endpoint = "filebrowser:${toString filebrowserConfig.port}";
  };

  virtualisation.oci-containers.containers.filebrowser = {
    image = "docker.io/filebrowser/filebrowser:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString config.users.users.graham.uid}:${toString config.users.groups.users.gid}";
    volumes = [
      "/data/files:/srv:rw"
      "/data/oci-containers/filebrowser/filebrowser.db:/filebrowser.db:rw"
      "${toFile "filebrowser.json" (toJSON filebrowserConfig)}:/.filebrowser.json:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
