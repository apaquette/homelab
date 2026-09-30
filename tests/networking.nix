{ config, helpers, ... }:

with helpers;

[
  (assertEqual
    "network manager enabled"
    true
    config.networking.networkmanager.enable)

  (assertEqual
    "static IP"
    "192.168.2.20"
    (builtins.head config.networking.interfaces.enp2s0.ipv4.addresses).address)

  (assertEqual
    "static IP prefix length"
    24
    (builtins.head config.networking.interfaces.enp2s0.ipv4.addresses).prefixLength)

  (assertEqual
    "default gateway"
    "192.168.2.1"
    config.networking.defaultGateway.address)

  (assertContains
    "DNS servers"
    "192.168.2.20"
    config.networking.nameservers)

  (assertContains
    "DNS servers"
    "1.1.1.1"
    config.networking.nameservers)

  (assertContains
    "DNS servers"
    "8.8.8.8"
    config.networking.nameservers)
]