with builtins;
rec {
  imports = [ ../options.nix ];

  systemd.services.podman-jfa-go = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };

  users = rec {
    users.jfa-go = {
      isSystemUser = true;
      uid = 813;
      group = "jfa-go";
    };
    groups.jfa-go.gid = users.jfa-go.uid;
  };

  virtualisation.oci-containers.containers.jfa-go = {
    image = "docker.io/hrfee/jfa-go";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.jfa-go.uid}:${toString users.groups.jfa-go.gid}";
    volumes = [
      "/data/oci-containers/jfa-go/data:/data:rw"
      "/data/oci-containers/jellyfin/tastypi.tv/config:/jf:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
