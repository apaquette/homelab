{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.swraid = {
    enable = true;
    mdadmConf = ''
      HOMEHOST <system>
      MAILADDR root
    '';
  };

  system.stateVersion = "26.05";
}