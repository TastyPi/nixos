{
  virtualisation.oci-containers.containers.cloudflared = {
    image = "docker.io/cloudflare/cloudflared";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "nobody";
    cmd = [ "tunnel" "--no-autoupdate" "run" "--token" (import ../../../secrets/cloudflare.nix).tunnel ];
    volumes = [ "/etc/localtime:/etc/localtime:ro" ];
  };
}
