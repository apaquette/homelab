{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ../../modules/networking.nix
    ../../modules/storage.nix
    ../../modules/docker.nix
    ../../modules/caddy.nix
    ../../modules/dnsmasq.nix
    ../../modules/jellyfin.nix
    ../../modules/media-services.nix
    ../../modules/seerr.nix
    ../../modules/minecraft.nix
  ];

  networking.hostName = "homelab";

  system.stateVersion = "26.05";
}