{ ... }:

{
  networking.networkmanager.enable = true;

  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "2c:f0:5d:6e:6c:2d";
    linkConfig.Name = "lan0";
  };

  networking.interfaces.lan0 = {
    ipv4.addresses = [
      {
        address = "192.168.2.20";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "192.168.2.1";

  networking.nameservers = [
    "192.168.2.20"
    "1.1.1.1"
    "8.8.8.8"
  ];
}