let
  eth = "enp9s0";
in
{
  # Networking
  networking = {
    firewall.interfaces = {
      "${eth}".allowedUDPPorts = [ 5353 ]; # Allow mDNS for Matter
      podman0.allowedTCPPorts = [ 5580 ];  # Allow connecting to Matter
      podman0.allowedUDPPorts = [ 53 ];    # Allow DNS in containers
    };
    nftables.enable = true;
    useDHCP = false;
    useNetworkd = false;
  };
  services.resolved.enable = true;
  systemd.network = {
    enable = true;
    networks.physical = {
      matchConfig.Name = eth;
      networkConfig = {
        DHCP = "yes";
        #MulticastDNS = "resolve";
      };
    };
  };
}
