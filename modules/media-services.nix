{ pkgs, ... }:
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

  systemd.services.prowlarr = {
    description = "Prowlarr";

    after = [
      "network-online.target"
    ];

    wants = [
      "network-online.target"
    ];

    serviceConfig = {
      User = "prowlarr";
      Group = "prowlarr";
      Type = "simple";

      ExecStart = "/opt/Prowlarr/Prowlarr -nobrowser -data=/var/lib/prowlarr";

      TimeoutStopSec = 1800;

      Restart = "on-failure";
      RestartSec = 5;
    };

    wantedBy = [
      "multi-user.target"
    ];
  };

  systemd.services.qbittorrent-nox = {
    description = "qBittorrent-nox";

    after = [
      "network-online.target"
      "mnt-myraid.mount"
    ];

    wants = [
      "network-online.target"
    ];

    requires = [
      "mnt-myraid.mount"
    ];

    serviceConfig = {
      User = "qbittorrent";
      Group = "qbittorrent";
      Type = "simple";

      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox";

      PrivateTmp = false;

      TimeoutStopSec = 1800;

      Restart = "on-failure";
      RestartSec = 5;
    };

    wantedBy = [
      "multi-user.target"
    ];
  };
}
