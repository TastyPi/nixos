let
  eth = "enp9s0";
in
{
  # Networking
  networking = {
    # I really did try to use the firewall, but could not get mDNS working for Matter
    firewall.enable = false;
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
