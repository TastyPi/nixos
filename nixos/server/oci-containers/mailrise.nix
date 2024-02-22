{ config, lib, ... }:
with builtins;
with lib;
let
  mailriseConfig = {
    configs = mapAttrs
      (app: appConfig: {
        urls = [ "gotify://${config.tastypi.caddy.gotify.endpoint}/${appConfig.gotify.token}?priority=${appConfig.gotify.priority}" ];
        mailrise = appConfig.mailrise;
      })
      config.tastypi.mailrise;
  };
in
{
  virtualisation.oci-containers.containers.mailrise = {
    image = "docker.io/yoryan/mailrise:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    ports = [ "8025:8025" ];
    volumes = [
      "${toFile "mailrise.conf" (toJSON mailriseConfig)}:/etc/mailrise.conf:ro"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
