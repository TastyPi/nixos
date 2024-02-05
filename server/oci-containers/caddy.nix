{ config, lib, ... }:
with builtins;
with lib;
let
  caddyConfig = {
    apps = {
      http = {
        servers = {
          server = {
            listen = [ ":443" ];
            routes = [{
              # Have all hosts under this so Caddy only gets a cert for *.rogers.me.uk
              # This lets Cloudflare to not have to be configured for every host by setting "Origin Server Name" to *.rogers.me.uk
              match = [{ host = [ "*.rogers.me.uk" ]; }];
              handle = [{
                handler = "subroute";
                routes = concatLists (mapAttrsToList (subdomain: subdomainConfig: concatLists [
                  (optional subdomainConfig.authelia.enable {
                    # https://caddyserver.com/docs/caddyfile/directives/forward_auth#expanded-form
                    match = [({ host = [ "${subdomain}.rogers.me.uk" ]; } // subdomainConfig.authelia.match)];
                    handle = [{
                      handler = "reverse_proxy";
                      rewrite = {
                        method = "GET";
                        uri = "/api/verify?rd=https://authelia.rogers.me.uk";
                      };
                      headers.request.set = {
                        "X-Forwarded-Method" = [ "{http.request.method}" ];
                        "X-Forwarded-Uri" = [ "{http.request.uri}" ];
                      };
                      upstreams = [{ dial = config.tastypi.caddy.authelia.endpoint; }];
                      handle_response = [{
                        match.status_code = [ 2 ];
                        routes = [{
                          handle = [{
                            handler = "headers";
                            request.set.Remote-User = [ "{http.reverse_proxy.header.Remote-User}" ];
                          }];
                        }];
                      }];
                    }];
                  })
                  [{
                    match = [{ host = [ "${subdomain}.rogers.me.uk" ]; }];
                    handle = [{ handler = "reverse_proxy"; upstreams = [{ dial = subdomainConfig.endpoint; }]; }];
                  }]
                ]) config.tastypi.caddy);
              }];
            }];
          };
        };
      };
      tls.automation.policies = [{
        issuers = [{
          module = "acme";
          challenges.dns = {
            provider = {
              name = "cloudflare";
              api_token = (import ../../secrets/cloudflare.nix).dns;
            };
            resolvers = [ "1.1.1.1" ];
          };
        }];
      }];
    };
  };
in
rec {
  # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
  boot.kernel.sysctl."net.core.rmem_max" = 2500000;
  boot.kernel.sysctl."net.core.wmem_max" = 2500000;
  
  systemd.services.podman-caddy = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
    wants = [ "podman-authelia.service" ];
  };
  
  users = rec {
    groups.caddy.gid = users.caddy.uid;
    users.caddy = {
      group = "caddy";
      isSystemUser = true;
      uid = 800;
    };
  };
  
  virtualisation.oci-containers.containers.caddy = {
    image = "ghcr.io/tastypi/caddy-cloudflare:latest";
    cmd = [ "caddy" "run" "--config=/etc/caddy/caddy.json" ];
    ports = [ "80:80" "443:443" ];
    user = "${toString users.users.caddy.uid}:${toString users.groups.caddy.gid}";
    labels = { "io.containers.autoupdate" = "registry"; };
    volumes = [
      "${toFile "caddy.json" (toJSON caddyConfig)}:/etc/caddy/caddy.json:ro"
      "/data/oci-containers/caddy/config:/config:rw"
      "/data/oci-containers/caddy/data:/data:rw"
    ];
    extraOptions = [ "--ip=10.88.0.2" ];
  };
}
