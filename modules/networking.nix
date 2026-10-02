{ ... }:

{
  networking.networkmanager.enable = false;
  networking.useNetworkd = true;
  networking.useDHCP = false;

  systemd.network.enable = true;

  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "2c:f0:5d:6e:6c:2d";
    linkConfig.Name = "lan0";
  };

  systemd.network.networks."10-lan" = {
    matchConfig.Name = "lan0";

    address = [
      "192.168.2.20/24"
    ];

    routes = [
      {
        Gateway = "192.168.2.1";
      }
    ];

    dns = [
      "192.168.2.20"
      "1.1.1.1"
      "8.8.8.8"
    ];

    linkConfig.RequiredForOnline = "routable";
  };

  networking.firewall = {
    interfaces.lan0 = {
      allowedTCPPorts = [
        53
        80
        443
        4300
      ];

      allowedUDPPorts = [
        53
        67
      ];
    };

extraCommands = ''
  # Allow Docker containers to use the host's DNS resolver.
  iptables -A nixos-fw -i br-+ -p tcp --dport 53 -j nixos-fw-accept
  iptables -A nixos-fw -i br-+ -p udp --dport 53 -j nixos-fw-accept

  # Allow Docker containers to reach Caddy on the host.
  iptables -A nixos-fw -i br-+ -p tcp --dport 80 -j nixos-fw-accept
  iptables -A nixos-fw -i br-+ -p tcp --dport 443 -j nixos-fw-accept

  # Allow Docker containers to reach the Minecraft gameplay port.
  iptables -A nixos-fw -i br-+ -p tcp --dport 4300 -j nixos-fw-accept

  # Allow Docker containers to query the Minecraft server.
  iptables -A nixos-fw -i br-+ -p udp --dport 25565 -j nixos-fw-accept
'';
};
}

