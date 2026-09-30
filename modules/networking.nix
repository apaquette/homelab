{ ... }:

{
  networking.networkmanager.enable = true;

  networking.interfaces.enp2s0 = {
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