with builtins;
let
  port = "8080";
in
rec {
  imports = [ ../options.nix ];

  systemd.services.podman-gotify = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };

  tastypi.caddy.gotify.endpoint = "gotify:${port}";

  users = rec {
    groups.gotify.gid = users.gotify.uid;
    users.gotify = {
      isSystemUser = true;
      uid = 806;
      group = "gotify";
    };
  };

  virtualisation.oci-containers.containers.gotify = {
    image = "ghcr.io/gotify/server:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.gotify.uid}:${toString users.groups.gotify.gid}";
    environment.GOTIFY_SERVER_PORT = port;
    volumes = [
      "/data/oci-containers/gotify/data:/app/data:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
