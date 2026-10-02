{ config, pkgs, ... }:
let
   mediaServiceRequirements = {
     after = [ "mnt-myraid.mount" ];
     requires = [ "mnt-myraid.mount" ];
   };
in
{
  services.sonarr = {
    enable = true;
    package = pkgs.sonarr;
    dataDir = "/var/lib/sonarr";
    user = "sonarr";
    group = "sonarr";
  };

  systemd.services.sonarr = mediaServiceRequirements;

  services.radarr = {
    enable = true;
    package = pkgs.radarr;
    dataDir = "/var/lib/radarr";
    user = "radarr";
    group = "radarr";
  };

   systemd.services.radarr = mediaServiceRequirements;

  services.prowlarr = {
    enable = true;
    package = pkgs.prowlarr;
    dataDir = "/var/lib/prowlarr";
  };

  services.qbittorrent = {
    enable = true;
    package = pkgs.qbittorrent-nox;

    user = "qbittorrent";
    group = "qbittorrent";

    profileDir = "/var/lib/qBittorrent";
    webuiPort = 8080;
  };

  systemd.services.qbittorrent =
    mediaServiceRequirements
    // {
      serviceConfig = {
        SupplementaryGroups = config.users.users.qbittorrent.extraGroups;
      };
    };

}
