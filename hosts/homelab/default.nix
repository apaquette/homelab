{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
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
    ../../modules/sops.nix
    ../../modules/compose.nix
    ../../modules/compatibility.nix
    ../../modules/scripts.nix
    ../../modules/monitoring.nix
    ../../modules/backups.nix
    ../../modules/smartd.nix
    ../../modules/cockpit.nix
    ../../modules/system-tools.nix
  ];

  networking.hostName = "homelab";

  system.stateVersion = "26.05";
}
