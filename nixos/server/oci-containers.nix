{
  imports = [
    ./oci-containers/authelia.nix
    ./oci-containers/caddy.nix
    ./oci-containers/cloudflared.nix
    ./oci-containers/filebrowser.nix
    ./oci-containers/flaresolverr.nix
    ./oci-containers/gotify.nix
    ./oci-containers/home-assistant.nix
    ./oci-containers/jellyfin.nix
    ./oci-containers/jfa-go.nix
    ./oci-containers/mailrise.nix
    ./oci-containers/matter.nix
    ./oci-containers/nzbget.nix
    ./oci-containers/prowlarr.nix
    ./oci-containers/radarr.nix
    ./oci-containers/recyclarr.nix
    ./oci-containers/sonarr.nix
    ./oci-containers/syncthing.nix
    ./oci-containers/transmission.nixs
  ];

  # Enable auto-updates
  systemd.units."podman-auto-update.timer".wantedBy = [ "timers.target" ];

  virtualisation.podman = {
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
    defaultNetwork.settings = {
      dns_enabled = true;
      ipv6_enabled = true;
      subnets = [{
        subnet = "10.88.0.0/16";
        gateway = "10.88.0.1";
        lease_range = {
          start_ip = "10.88.0.10";
          end_ip = "10.88.0.255";
        };
      }];
    };
  };
}
