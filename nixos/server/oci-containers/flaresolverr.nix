{
  virtualisation.oci-containers.containers.flaresolverr = {
    image = "ghcr.io/flaresolverr/flaresolverr:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    volumes = [ "/etc/localtime:/etc/localtime:ro" ];
  };
}
