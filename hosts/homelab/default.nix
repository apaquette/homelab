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

  networking.hostName = "homelab";

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

  users.users.apaquette = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
    ];
  };

  users.groups.apaquette.gid = 1000;

  users.users.radarr = {
    isSystemUser = true;
    uid = 101;
    group = "radarr";
  };

  users.groups.radarr.gid = 103;

  users.users.sonarr = {
    isSystemUser = true;
    uid = 102;
    group = "sonarr";
  };

  users.groups.sonarr.gid = 104;

  users.users.prowlarr = {
    isSystemUser = true;
    uid = 103;
    group = "prowlarr";
  };

  users.groups.prowlarr.gid = 105;

  users.users.qbittorrent = {
    isSystemUser = true;
    uid = 104;
    group = "qbittorrent";
  };

  users.groups.qbittorrent.gid = 106;

  users.users.jellyfin = {
    isSystemUser = true;
    uid = 105;
    group = "jellyfin";
    extraGroups = [
      "video"
      "render"
    ];
  };

  users.groups.jellyfin.gid = 107;

  users.users.seerr = {
    isSystemUser = true;
    uid = 106;
    group = "seerr";
  };

  users.groups.seerr.gid = 108;

  users.users.minecraft = {
    isSystemUser = true;
    uid = 997;
    group = "minecraft";
  };

  users.groups.minecraft.gid = 988;

  users.users.jenkins-deploy = {
    isSystemUser = true;
    uid = 1001;
    group = "jenkins-deploy";
  };

  users.groups.jenkins-deploy.gid = 1001;

  system.stateVersion = "26.05";
}