let
  eth = "enp9s0";
in
{
  # Networking
  networking = {
    firewall.enable = true;
    useDHCP = false;
    useNetworkd = true;
  };
  services.resolved.enable = true;
  systemd.network = {
    networks.physical = {
      matchConfig.Name = eth;
      networkConfig = {
        DHCP = "yes";
        MulticastDNS = "yes";
      };
      linkConfig = {
        Multicast = "yes";
        AllMulticast = "yes";
      };
    };
  };
}
