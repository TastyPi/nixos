with builtins;
let
  secrets = import ../../secrets/authelia.nix;
  configurationFile = builtins.toFile "configuration.yml" (builtins.toJSON {
    theme = "auto";
    jwt_secret = secrets.jwt_secret;
    authentication_backend.file.path = "/config/users.yml";
    access_control.rules = [{
      domain = "*.rogers.me.uk";
      policy = "two_factor";
    }];
    session = {
      domain = "rogers.me.uk";
      secret = secrets.session.secret;
    };
    storage = {
      encryption_key = secrets.storage.encryption_key;
      local.path = "/config/db.sqlite3";
    };
    notifier.filesystem.filename = "/config/notification.txt";
  });
in
rec {
  imports = [ ../options.nix ];

  systemd.services.podman-authelia = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ]; 
  };
  
  tastypi.caddy.authelia.endpoint = "authelia:9091";
  
  users = rec {
    groups.authelia.gid = users.authelia.uid;
    users.authelia = {
      isSystemUser = true;
      uid = 802;
      group = "authelia";
    };
  };
  
  virtualisation.oci-containers.containers.authelia = {
    image = "ghcr.io/authelia/authelia";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.authelia.uid}:${toString users.groups.authelia.gid}";
    volumes = [
      "/data/oci-containers/authelia/config:/config:rw"
      "${configurationFile}:/config/configuration.yml:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
