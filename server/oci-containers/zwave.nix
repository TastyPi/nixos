with builtins;
rec {
  imports = [ ../options.nix ];

  users = rec {
    groups.zwave.gid = users.zwave.uid;
    users.zwave = {
      isSystemUser = true;
      uid = 809;
      group = "zwave";
    };
  };
  
  services.udev.extraRules = ''
    ENV{ID_MODEL}=="CP2102N_USB_to_UART_Bridge_Controller", GROUP="zwave"
  '';
  
  systemd.services.podman-zwave = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };
  
  tastypi.caddy.zwave = {
    authelia = true;
    endpoint = "zwave:8091";
  };
  
  virtualisation.oci-containers.containers.zwave = {
    image = "docker.io/zwavejs/zwave-js-ui";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.zwave.uid}:${toString users.groups.zwave.gid}";
    volumes = [
      "/data/oci-containers/zwave/config:/usr/src/app/store"
      "/etc/localtime:/etc/localtime:ro"
    ];
    extraOptions = [
      "--device=/dev/serial/by-id/usb-Silicon_Labs_CP2102N_USB_to_UART_Bridge_Controller_34d24c804985ed11a5a0c69f9d1cc348-if00-port0:/dev/zwave"
    ];
  };
}
