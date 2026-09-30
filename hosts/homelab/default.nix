{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ../../modules/networking.nix
    ../../modules/storage.nix
    ../../modules/docker.nix
  ];

  networking.hostName = "homelab";

  system.stateVersion = "26.05";
}