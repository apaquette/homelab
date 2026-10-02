{ pkgs, ... }:

{
  systemd.services.sonarr = {
    description = "Sonarr";

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
      User = "sonarr";
      Group = "sonarr";
      Type = "simple";

      ExecStart = "/opt/Sonarr/Sonarr -nobrowser -data=/var/lib/sonarr";

      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 20;
    };

    wantedBy = [
      "multi-user.target"
    ];
  };

  systemd.services.radarr = {
    description = "Radarr";

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
      User = "radarr";
      Group = "radarr";
      Type = "simple";

      ExecStart = "/opt/Radarr/Radarr -nobrowser -data=/var/lib/radarr";

      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 20;
    };

    wantedBy = [
      "multi-user.target"
    ];
  };

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
