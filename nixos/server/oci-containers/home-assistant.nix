with builtins;
rec {
  imports = [ ../options.nix ];

  systemd.services.podman-home-assistant = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
    wants = [ "podman-matter.service" "podman-zwave.service" ];
  };

  tastypi.caddy.home-assistant.endpoint = "home-assistant:8123";

  users = rec {
    groups.home-assistant.gid = users.home-assistant.uid;
    users.home-assistant = {
      isSystemUser = true;
      uid = 810;
      group = "home-assistant";
    };
  };

  virtualisation.oci-containers.containers.home-assistant = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.home-assistant.uid}:${toString users.groups.home-assistant.gid}";
    volumes = [
      "/data/oci-containers/home-assistant/config:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
