{ config, helpers, ... }:

with helpers;

[
  (assertEqual
    "network manager enabled"
    false
    config.networking.networkmanager.enable)

  (assertEqual
    "networkd enabled"
    true
    config.networking.useNetworkd)

  (assertEqual
    "systemd network enabled"
    true
    config.systemd.network.enable)

  (assertEqual
    "LAN interface MAC"
    "2c:f0:5d:6e:6c:2d"
    config.systemd.network.links."10-lan".matchConfig.PermanentMACAddress)

  (assertEqual
    "LAN interface name"
    "lan0"
    config.systemd.network.links."10-lan".linkConfig.Name)

  (assertContains
    "LAN static address"
    "192.168.2.20/24"
    config.systemd.network.networks."10-lan".address)

  (assertEqual
    "LAN gateway"
    "192.168.2.1"
    (builtins.head config.systemd.network.networks."10-lan".routes).Gateway)

  (assertContains
    "LAN DNS servers"
    "192.168.2.20"
    config.systemd.network.networks."10-lan".dns)

  (assertContains
    "LAN DNS servers"
    "1.1.1.1"
    config.systemd.network.networks."10-lan".dns)

  (assertContains
    "LAN DNS servers"
    "8.8.8.8"
    config.systemd.network.networks."10-lan".dns)
]
