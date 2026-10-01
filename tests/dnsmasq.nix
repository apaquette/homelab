{ config, helpers, ... }:

with helpers;

[
  (assertEqual
    "dnsmasq enabled"
    true
    config.services.dnsmasq.enable)

  (assertEqual
    "dnsmasq interface"
    [ "lan0" ]
    config.services.dnsmasq.settings.interface)

  (assertEqual
    "dnsmasq listen addresses"
    [ "127.0.0.1" "192.168.2.20" ]
    config.services.dnsmasq.settings.listen-address)

  (assertEqual
    "dnsmasq DHCP range"
    [ "192.168.2.50,192.168.2.199,255.255.255.0,12h" ]
    config.services.dnsmasq.settings.dhcp-range)

  (assertEqual
    "dnsmasq DHCP options"
    [
      "option:router,192.168.2.1"
      "option:dns-server,192.168.2.20"
    ]
    config.services.dnsmasq.settings.dhcp-option)

  (assertEqual
    "dnsmasq upstream DNS"
    [ "1.1.1.1" "8.8.8.8" ]
    config.services.dnsmasq.settings.server)

  (assertEqual
    "dnsmasq no-resolv"
    [true]
    config.services.dnsmasq.settings.no-resolv)

  (assertEqual
    "dnsmasq cache size"
    [1000]
    config.services.dnsmasq.settings.cache-size)

  (assertEqual
    "dnsmasq desktop reservation"
    [ "b4:2e:99:fb:61:ae,192.168.2.100,nixos-desktop" ]
    config.services.dnsmasq.settings.dhcp-host)

  (assertEqual
    "dnsmasq local DNS entries"
    [
      "/jellyfin.alexpaquette.dev/192.168.2.20"
      "/seerr.alexpaquette.dev/192.168.2.20"
      "/immich.alexpaquette.dev/192.168.2.20"
      "/cloud.alexpaquette.dev/192.168.2.20"
      "/ntfy.alexpaquette.dev/192.168.2.20"
      "/radarr.alexpaquette.dev/192.168.2.20"
      "/sonarr.alexpaquette.dev/192.168.2.20"
      "/prowlarr.alexpaquette.dev/192.168.2.20"
      "/qbittorrent.alexpaquette.dev/192.168.2.20"
      "/cockpit.alexpaquette.dev/192.168.2.20"
      "/status.alexpaquette.dev/192.168.2.20"
      "/beszel.alexpaquette.dev/192.168.2.20"
      "/jenkins.alexpaquette.dev/192.168.2.20"
      "/homepage.alexpaquette.dev/192.168.2.20"
    ]
    config.services.dnsmasq.settings.address)
]
