{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./users.nix
    ../../modules/networking.nix
    ../../modules/storage.nix
  ];

  networking.hostName = "homelab";

  system.stateVersion = "26.05";
}